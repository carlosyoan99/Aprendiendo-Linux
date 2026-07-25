---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-20
estado: resuelto
categoria: programa
prioridad: media
licencia: MPL-2.0 (BIND 9+)
alternativas: Unbound, dnsmasq, PowerDNS, systemd-resolved, Knot DNS
---

# DNS y BIND

> El **Sistema de Nombres de Dominio (DNS)** traduce nombres legibles (`ejemplo.com`) a direcciones IP. **BIND** (Berkeley Internet Name Domain) es el servidor DNS más utilizado en Internet desde los años 80. También se cubren herramientas de consulta y resolución local.

## Conceptos fundamentales

### Jerarquía DNS

```
. (raíz)
├── com, org, net, es, …  (TLDs)
│   ├── ejemplo.com       (dominio)
│   │   ├── www           → 192.0.2.10
│   │   ├── mail          → 192.0.2.20
│   │   └── blog          → 192.0.2.30
│   └── otro.org
└── … (13 servidores raíz gestionados por ICANN)
```

| Componente | Descripción |
|---|---|
| **Root servers** | 13 conjuntos de servidores (a-m.root-servers.net) que conocen los TLDs |
| **TLD servers** | Servidores de .com, .org, .es, etc. |
| **Authoritative server** | El que tiene la respuesta oficial para un dominio |
| **Recursive resolver** | El que pregunta en cadena hasta obtener respuesta (8.8.8.8, 1.1.1.1) |
| **Stub resolver** | Resolver básico del sistema operativo (glibc `getaddrinfo`) |

### Tipos de registro DNS

| Registro | Función | Ejemplo |
|---|---|---|
| **A** | IPv4 del dominio | `ejemplo.com. IN A 192.0.2.10` |
| **AAAA** | IPv6 del dominio | `ejemplo.com. IN AAAA 2001:db8::1` |
| **CNAME** | Alias (canonical name) | `www IN CNAME ejemplo.com.` |
| **MX** | Servidor de correo (con prioridad) | `IN MX 10 mail.ejemplo.com.` |
| **TXT** | Texto arbitrario (SPF, DKIM, verificaciones) | `IN TXT "v=spf1 mx ~all"` |
| **NS** | Servidor autoritativo para el dominio | `IN NS ns1.ejemplo.com.` |
| **SOA** | Start of Authority — metadatos del dominio | (ver sección zonas) |
| **PTR** | Resolución inversa (IP → nombre) | `10.2.0.192.in-addr.arpa. IN PTR ejemplo.com.` |
| **SRV** | Servicio específico (_sip._tcp, etc.) | `_sip._tcp IN SRV 10 5 5060 sip.ejemplo.com.` |
| **CAA** | Autoridad de certificación permitida | `IN CAA 0 issue "letsencrypt.org"` |

### Flujo de resolución

```
Cliente → /etc/resolv.conf → 127.0.0.53 (systemd-resolved)
                              → Cache hit? → respuesta inmediata
                              → Cache miss → consulta recursiva:
                                  1. Root server → .org TLD
                                  2. .org TLD    → ns1.ejemplo.com
                                  3. ns1.ejemplo.com → 192.0.2.10
                                  4. Almacena en caché → respuesta al cliente
```

## Herramientas de consulta

### dig (DNS lookup tool)

`dig` es la herramienta más potente y detallada para consultas DNS.

```bash
# Consulta básica
dig ejemplo.com
dig ejemplo.com @8.8.8.8          # consultar a un resolver específico

# Consultas específicas
dig ejemplo.com A                  # solo registro A
dig ejemplo.com MX                 # registros MX
dig ejemplo.com ANY                # todos los registros (obsoleto en muchos servidores)
dig ejemplo.com CNAME              # alias

# Resolución inversa
dig -x 8.8.8.8                     # qué nombre tiene la IP 8.8.8.8

# Tracing y depuración
dig +trace ejemplo.com             # muestra cada paso de la resolución
dig ejemplo.com +short             # solo la respuesta, sin adornos
dig ejemplo.com +noall +answer     # solo la sección ANSWER

# Consultas masivas
dig -f dominios.txt +short         # resolver una lista de dominios

# Verificar propagación global
dig @a.root-servers.net ejemplo.com       # desde root
dig @ns1.ejemplo.com ejemplo.com          # desde el servidor autoritativo
```

### host (simplificado)

```bash
host ejemplo.com                    # consulta simple
host -t MX ejemplo.com              # tipo específico
host -a ejemplo.com                 # todo (equivalente a ANY)
host 8.8.8.8                        # resolución inversa
```

### nslookup (legado, aún útil)

```bash
nslookup ejemplo.com
nslookup -type=MX ejemplo.com
nslookup 8.8.8.8
```

## Resolución local en Linux

### /etc/hosts

Resolución estática, tiene prioridad sobre DNS:

```bash
# /etc/hosts
127.0.0.1   localhost
::1         localhost

# Bloqueo de dominios (redirigir a 127.0.0.1)
127.0.0.1   facebook.com www.facebook.com
127.0.0.1   doubleclick.net

# Entradas de desarrollo
127.0.0.1   miproyecto.local
```

### /etc/resolv.conf

En sistemas modernos este archivo suele ser gestionado automáticamente por `systemd-resolved` o `NetworkManager`:

```bash
# /etc/resolv.conf típico (gestionado automáticamente)
nameserver 127.0.0.53              # stub resolver de systemd-resolved
options edns0 trust-ad
search misitio.com
```

```bash
# Si usas un resolver manual (sin systemd-resolved)
nameserver 1.1.1.1
nameserver 8.8.8.8
```

### systemd-resolved

```bash
# Estado de la resolución
resolvectl status
resolvectl query ejemplo.com       # consultar vía systemd-resolved
resolvectl statistics              # estadísticas (caché, hits, misses)

# Configuración por interfaz
resolvectl dns eth0 1.1.1.1 8.8.8.8
resolvectl domain eth0 misitio.com

# Gestionar caché
sudo resolvectl flush-caches       # limpiar caché DNS
```

### NSSwitch (/etc/nsswitch.conf)

Controla el orden de las fuentes de resolución:

```bash
# /etc/nsswitch.conf - línea hosts
hosts: files mymachines resolve [!UNAVAIL=return] dns

# Orden típico:
# files → /etc/hosts
# mymachines → contenedores systemd-nspawn
# resolve → systemd-resolved
# dns → /etc/resolv.conf directo
```

## BIND: instalación y configuración básica

### Instalación

```bash
# Debian/Ubuntu
sudo apt install bind9 bind9utils bind9-doc

# Arch Linux
sudo pacman -S bind

# Fedora/RHEL
sudo dnf install bind bind-utils

# Verificar versión
named -v
```

### Estructura de directorios

| Ruta | Propósito |
|---|---|
| `/etc/bind/` | Configuración principal |
| `/etc/bind/named.conf` | Configuración global |
| `/etc/bind/named.conf.options` | Opciones globales |
| `/etc/bind/named.conf.local` | Zonas locales |
| `/etc/bind/named.conf.default-zones` | Zonas por defecto (localhost, etc.) |
| `/etc/bind/db.root` | Servidores raíz (hints) |
| `/var/cache/bind/` | Archivos de zona dinámicos |
| `/var/log/` | Logs si se configuran |

### named.conf.options — resolver local (caché)

```nginx
# /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    # Escuchar en localhost (solo uso local)
    listen-on { 127.0.0.1; };
    listen-on-v6 { ::1; };

    # Permitir consultas desde localhost
    allow-query { localhost; };

    # Forwarders — a quién preguntar si no está en caché
    forwarders {
        1.1.1.1;
        8.8.8.8;
    };

    # Seguridad: evitar amplificación DNS
    recursion yes;                    # necesario para resolver local
    allow-recursion { localhost; };
    dnssec-validation auto;

    # Rendimiento
    max-cache-size 256m;
};
```

### Configurar systemd-resolved para usar BIND local

```bash
# Decirle al sistema que use BIND en 127.0.0.1
# Opción A: configurar resolvectl
sudo resolvectl dns eth0 127.0.0.1
sudo resolvectl domain eth0 ~.

# Opción B: editar /etc/resolv.conf manualmente
# nameserver 127.0.0.1

# Probar
dig google.com
```

## Zonas autoritativas

### Zona directa (forward)

```nginx
# /etc/bind/named.conf.local
zone "ejemplo.com" {
    type master;
    file "/etc/bind/db.ejemplo.com";
};
```

```nginx
; /etc/bind/db.ejemplo.com
$TTL 3600
@   IN  SOA     ns1.ejemplo.com. admin.ejemplo.com. (
                2026072001  ; Serial (YYYYMMDDNN)
                3600        ; Refresh
                1800        ; Retry
                604800      ; Expire
                86400       ; Negative TTL
                )

@       IN  NS      ns1.ejemplo.com.
@       IN  NS      ns2.ejemplo.com.
@       IN  A       192.0.2.10
@       IN  AAAA    2001:db8::10
@       IN  MX      10 mail.ejemplo.com.

ns1     IN  A       192.0.2.2
ns2     IN  A       192.0.2.3
www     IN  A       192.0.2.10
mail    IN  A       192.0.2.20
blog    IN  CNAME   www.ejemplo.com.
_spf    IN  TXT     "v=spf1 mx -all"
_dmarc  IN  TXT     "v=DMARC1; p=none; rua=mailto:dmarc@ejemplo.com"
```

### Zona inversa (reverse)

```nginx
zone "2.0.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.0.2";
};
```

```nginx
; /etc/bind/db.192.0.2
$TTL 3600
@   IN  SOA     ns1.ejemplo.com. admin.ejemplo.com. (
                2026072001  ; Serial
                3600        ; Refresh
                1800        ; Retry
                604800      ; Expire
                86400       ; Negative TTL
                )

@       IN  NS      ns1.ejemplo.com.
@       IN  NS      ns2.ejemplo.com.

10      IN  PTR     www.ejemplo.com.
20      IN  PTR     mail.ejemplo.com.
2       IN  PTR     ns1.ejemplo.com.
3       IN  PTR     ns2.ejemplo.com.
```

### Activar y probar zonas

```bash
# Verificar configuración de BIND
sudo named-checkconf

# Verificar zona directa
sudo named-checkzone ejemplo.com /etc/bind/db.ejemplo.com

# Verificar zona inversa
sudo named-checkzone 2.0.192.in-addr.arpa /etc/bind/db.192.0.2

# Recargar configuración
sudo systemctl reload bind9

# Probar consultas contra el servidor local
dig @127.0.0.1 ejemplo.com
dig @127.0.0.1 www.ejemplo.com
dig @127.0.0.1 -x 192.0.2.10
```

### Serial

El serial debe **incrementarse** cada vez que se modifica una zona. Formato recomendado: `YYYYMMDDNN` (año, mes, día, número de revisión del día). Si los servidores secundarios no detectan un serial mayor, no propagan los cambios.

## BIND como forwarding/caching resolver

Para usar tu propio servidor de caché local y no depender de 8.8.8.8:

```nginx
options {
    directory "/var/cache/bind";
    listen-on { 127.0.0.1; 192.168.1.0/24; };
    allow-query { localhost; 192.168.1.0/24; };
    forwarders { 1.1.1.1; 8.8.8.8; };
    recursion yes;
    dnssec-validation auto;
    max-cache-size 256m;
};
```

Esto mejora privacidad (no envías cada consulta a Google/Cloudflare) y velocidad al compartir caché en la red local.

## Seguridad

```nginx
options {
    # Limitar consultas
    allow-query { localhost; 192.168.1.0/24; };
    allow-transfer { none; };              # evitar transferencia de zona no autorizada
    allow-recursion { localhost; 192.168.1.0/24; };
    recursion yes;

    # Prevenir amplificación DNS
    rate-limit {
        responses-per-second 10;
        exempt-clients { 127.0.0.1; };
    };

    # Ocultar versión
    version "not available";

    # DNSSEC
    dnssec-validation auto;
};
```

### ACLs

```nginx
acl "trusted" {
    127.0.0.1;
    192.168.1.0/24;
    10.0.0.0/8;
};

options {
    allow-query { trusted; };
    allow-recursion { trusted; };
};
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `dig ejemplo.com` vuelve `SERVFAIL` | DNSSEC validation fail | `dig +dnssec ejemplo.com`, verificar `dnssec-validation auto;` |
| `connection timed out; no servers could be reached` | Puerto 53 bloqueado | `sudo ss -tuln \| grep :53`, verificar firewall |
| La zona no se actualiza | Serial no incrementado | Aumentar serial y `sudo rndc reload` |
| `named: loading configuration: permission denied` | Permisos incorrectos | `sudo chown -R bind:bind /etc/bind/` |
| `lame server resolving` | NS apunta a servidores incorrectos | Verificar registros NS del dominio |
| Resolución local lenta | IPv6 fallando | `options { filter-aaaa-on-v4 yes; };` |
| `dnsmasq` o `systemd-resolved` en puerto 53 | Conflicto con BIND | `sudo systemctl stop systemd-resolved` |
| Las consultas de la red local no funcionan | `allow-query` restrictivo | Añadir subred a `allow-query` y firewall (puerto 53 UDP) |

### Comandos de diagnóstico

```bash
# Estado de BIND
sudo rndc status

# Estadísticas de consultas
sudo rndc stats
cat /var/cache/bind/named_stats.txt

# Forzar recarga de zona
sudo rndc reload ejemplo.com

# Ver caché
sudo rndc dumpdb -cache
cat /var/cache/bind/named_dump.db | grep ejemplo

# Limpiar caché
sudo rndc flush

# Logs en tiempo real
sudo journalctl -u named -f
sudo tail -f /var/log/syslog | grep named
```

## Alternativas a BIND

| Servidor | Uso típico | Características |
|---|---|---|
| **Unbound** | Resolver local/caché | Ligero, DNSSEC nativo, fácil configuración |
| **dnsmasq** | Red local + DHCP | Muy simple, ideal para LANs pequeñas |
| **systemd-resolved** | Resolver del sistema | Integrado en systemd, stub en 127.0.0.53 |
| **PowerDNS** | Autoritativo | Backends SQL (MySQL, PostgreSQL), API REST |
| **Knot DNS** | Autoritativo alto rendimiento | Rápido, módulos dinámicos |

### Unbound (alternativa ligera para resolver local)

```bash
sudo apt install unbound

# Configuración mínima /etc/unbound/unbound.conf
echo "
server:
    interface: 127.0.0.1
    access-control: 127.0.0.0/8 allow
    do-ip4: yes
    do-ip6: yes
    do-udp: yes
    do-tcp: yes
    hide-version: yes
" | sudo tee -a /etc/unbound/unbound.conf

sudo systemctl enable --now unbound
```

## Enlaces externos

- [BIND — ISC](https://www.isc.org/bind/)
- [BIND 9 Administrator Reference Manual](https://bind9.readthedocs.io/)
- [Unbound — NLnet Labs](https://nlnetlabs.nl/projects/unbound/about/)
- [DNS Glossary — ICANN](https://www.icann.org/resources/pages/dns-glossary-2014-02-04-en)
- [dig man page](https://man.archlinux.org/man/dig.1)

## Ver también

- [[Redes Basicas]] — conceptos de red subyacentes
- [[Firewall]] — apertura de puertos DNS (53 UDP/TCP)
- [[Nginx]] — virtual hosts con nombres DNS
- [[WireGuard VPN]] — uso de DNS interno en VPNs
- [[systemd-networkd]] — configuración de red con DNS

#programa #red #dns
