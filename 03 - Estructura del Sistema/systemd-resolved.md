---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: baja
alternativas: BIND, Unbound, dnsmasq, /etc/resolv.conf manual
---

# systemd-resolved

> Servicio de resolución DNS integrado en **systemd**. Gestiona las consultas DNS, mDNS y LLMNR del sistema, proporcionando un **stub resolver** en `127.0.0.53` que actúa como caché local y puerta de enlace a los resolvers configurados.

## Qué es

systemd-resolved es un servicio del ecosistema systemd que reemplaza la resolución DNS tradicional basada únicamente en `/etc/resolv.conf`. Escucha peticiones DNS en `127.0.0.53:53` y las redirige a los servidores DNS configurados por interfaz (vía NetworkManager, systemd-networkd o manualmente con `resolvectl`).

| Característica | Descripción |
|---|---|
| **Stub resolver** | Escucha en `127.0.0.53` — todas las apps resuelven ahí |
| **Caché DNS** | Almacena respuestas para acelerar consultas repetidas |
| **mDNS** | Resolución `.local` multicast (compatible con Avahi) |
| **LLMNR** | Resolución local Link-Local Multicast (nombres en LAN) |
| **DNSSEC** | Validación de firmas criptográficas en respuestas |
| **DNS over TLS** | Consultas cifradas a servidores DNS compatibles |
| **Por interfaz** | Servidores DNS distintos por interfaz de red |

## Instalación y estado

```bash
# systemd-resolved suele venir instalado por defecto en:
# Ubuntu 18.04+, Fedora, Arch, Debian (con systemd)

# Verificar que está activo
systemctl status systemd-resolved
resolvectl status

# Activar si no lo está
sudo systemctl enable --now systemd-resolved
```

## Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                    APLICACIÓN                            │
│  (firefox, ping, dig, curl, apt-get install ...)         │
└────────────────────────┬────────────────────────────────┘
                         │ consulta DNS
                         ▼
┌─────────────────────────────────────────────────────────┐
│              glibc (getaddrinfo /etc/nsswitch.conf)      │
│              → hosts: files resolve dns                  │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│           systemd-resolved (127.0.0.53:53)               │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────────┐ │
│  │  Caché   │ │  mDNS    │ │  LLMNR   │ │  DNSSEC     │ │
│  │  DNS     │ │  .local  │ │  LAN     │ │  validación  │ │
│  └──────────┘ └──────────┘ └──────────┘ └─────────────┘ │
└────────┬──────────┬──────────┬───────────────────────────┘
         │          │          │
         ▼          ▼          ▼
    1.1.1.1    8.8.8.8    Servidor DNS local (BIND/Unbound)
```

## NSSwitch (/etc/nsswitch.conf)

systemd-resolved se integra vía el módulo `resolve` de **nsswitch**:

```bash
# /etc/nsswitch.conf — línea hosts
hosts: files mymachines resolve [!UNAVAIL=return] dns

# Orden de resolución:
# 1. files         → /etc/hosts (estático)
# 2. mymachines    → contenedores systemd-nspawn
# 3. resolve       → systemd-resolved (127.0.0.53)
# 4. dns           → /etc/resolv.conf directo (fallback)
```

Si `systemd-resolved` no está corriendo, `[!UNAVAIL=return]` hace que se salte el módulo y pase al siguiente (`dns`).

## /etc/resolv.conf

Con systemd-resolved activo, `/etc/resolv.conf` se actualiza automáticamente:

```bash
# Opción A: /run/systemd/resolve/stub-resolv.conf (recomendado)
# → Apunta a 127.0.0.53
# → Asegura que todas las apps usen systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Opción B: /run/systemd/resolve/resolv.conf
# → Muestra los servidores DNS reales (sin stub)
# → Útil para debuggear
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Contenido típico de stub-resolv.conf:
# nameserver 127.0.0.53
# options edns0 trust-ad
# search .
```

## resolvectl — comando de gestión

`resolvectl` es la herramienta principal para interactuar con systemd-resolved:

### Consultas DNS

```bash
# Consultar un nombre
resolvectl query ejemplo.com
resolvectl query www.ejemplo.com

# Resolución inversa
resolvectl query 8.8.8.8

# Ver servidores DNS por interfaz
resolvectl dns
resolvectl dns eth0                   # DNS de una interfaz específica
resolvectl domain eth0                # dominios de búsqueda

# Estadísticas
resolvectl statistics
# Cache: current size, hits, misses, etc.
```

### Servidores DNS por interfaz

```bash
# Asignar servidores DNS a una interfaz
sudo resolvectl dns eth0 1.1.1.1 8.8.8.8
sudo resolvectl dns wlan0 192.168.1.1

# Asignar dominio de búsqueda
sudo resolvectl domain eth0 misitio.com
sudo resolvectl domain eth0 "~."         # ~. = usar este DNS para TODO

# DNS over TLS (DoT)
sudo resolvectl dnsovertls eth0 yes

# DNSSEC
sudo resolvectl dnssec eth0 yes
sudo resolvectl dnssec eth0 allow-downgrade  # permitir si el servidor no soporta
```

### Gestión de caché

```bash
# Ver contenido de la caché
sudo resolvectl show-cache

# Limpiar caché
sudo resolvectl flush-caches

# Ver estadísticas de caché
resolvectl statistics | grep -i cache
```

### Logging y debugging

```bash
# Ver queries en tiempo real
sudo resolvectl monitor              # muestra cada consulta DNS en vivo

# Logs del servicio
journalctl -u systemd-resolved -f
journalctl -u systemd-resolved --since "5 min ago"
```

## mDNS (Multicast DNS)

systemd-resolved tiene un servidor mDNS integrado para resolver nombres `.local` en la red local sin necesidad de un servidor DNS central:

```bash
# Habilitar mDNS globalmente
sudo resolvectl mdns eth0 yes

# Ver estado
resolvectl mdns

# Probar resolución .local
resolvectl query mi-raspberry.local
```

| Aspecto | systemd-resolved mDNS | Avahi |
|---|---|---|
| **Protocolo** | mDNS (RFC 6762) | mDNS/DNS-SD |
| **Integración** | Nativa en systemd | Independiente |
| **Service discovery** | Limitado | Avahi-publish, avahi-browse |
| **Conflicto** | Pueden coexistir o excluirse mutuamente |

> Si usas Avahi, desactiva mDNS en resolved para evitar conflictos: `sudo resolvectl mdns eth0 no`

## LLMNR (Link-Local Multicast Name Resolution)

Resuelve nombres en la LAN sin servidor DNS, similar a mDNS pero usando el espacio de nombres genérico (sin `.local`):

```bash
sudo resolvectl llmnr eth0 yes
resolvectl llmnr
```

LLMNR es menos usado que mDNS. Windows lo usa para resolución local, Linux prefiere mDNS.

## Modo de operación

systemd-resolved puede operar en varios modos que afectan cómo se gestiona la resolución:

### Modo stub (predeterminado)

Escucha en `127.0.0.53` y delega las consultas a los servidores DNS configurados por interfaz.

### Modo directo (sin stub)

Actúa como resolver completo, hablando directamente con los servidores DNS configurados sin pasar por un stub. No recomendado para uso general porque las apps que no usan NSS no pueden resolver.

### Modo cache-only (sin upstream)

Ideal para entornos aislados donde no se necesita resolución externa. Útil en contenedores o entornos de prueba.

## DNSSEC

```bash
# Verificar estado
resolvectl dnssec

# Activar
sudo resolvectl dnssec eth0 yes

# Verificar firma en consulta
resolvectl query --dnssec ejemplo.com
# Si la respuesta incluye "authenticated" → DNSSEC válido
```

## DNS over TLS

```bash
# Activar DoT en una interfaz
sudo resolvectl dnsovertls eth0 yes

# Verificar
resolvectl dnsovertls
# Requiere que los servidores DNS soporten DoT (1.1.1.1, 9.9.9.9, etc.)
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `resolvectl query` falla pero `dig @1.1.1.1` funciona | systemd-resolved no está corriendo | `sudo systemctl enable --now systemd-resolved` |
| `Temporary failure in name resolution` | No hay DNS configurado en la interfaz | `resolvectl dns eth0 1.1.1.1` |
| Las apps no resuelven | `/etc/resolv.conf` no apunta a systemd-resolved | `ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf` |
| `DNSSEC validation failed` | El servidor DNS no soporta DNSSEC | `resolvectl dnssec eth0 allow-downgrade` |
| Resolución lenta | Caché corrupta o consultas fallando | `resolvectl flush-caches`, ver `resolvectl statistics` |
| `.local` no resuelve | mDNS deshabilitado | `resolvectl mdns eth0 yes` |
| Conflicto con Avahi | Ambos intentan servir mDNS | Desactivar mDNS en uno de los dos |
| DoT no funciona | Servidor DNS no soporta DoT | Usar 1.1.1.1 o 9.9.9.9 como upstream |
| No se puede detener | systemd-resolved enlazado a systemd | `systemctl mask systemd-resolved` y configurar `/etc/resolv.conf` manual |

### Diagnóstico rápido

```bash
# 1. ¿Está corriendo?
systemctl is-active systemd-resolved

# 2. ¿Qué DNS tengo configurado?
resolvectl dns
resolvectl status

# 3. ¿Resuelve correctamente?
resolvectl query google.com

# 4. ¿Estadísticas de caché?
resolvectl statistics

# 5. Logs recientes
journalctl -u systemd-resolved --since "1 hour ago" --no-pager

# 6. Probar consulta directa (sin pasar por resolved)
dig @1.1.1.1 google.com

# 7. Ver configuración de nsswitch
grep hosts /etc/nsswitch.conf
```

## Comparativa: resolved vs alternativas

| Aspecto | systemd-resolved | BIND | Unbound | dnsmasq |
|---|---|---|---|---|
| **Instalación** | Viene con systemd | Requiere instalación | Requiere instalación | Requiere instalación |
| **Complejidad** | Mínima | Alta | Media | Baja |
| **Caché** | Sí | Sí | Sí | Sí |
| **mDNS** | Integrado | No | No | No |
| **DNSSEC** | Sí | Sí | Sí | Limitado |
| **DNS over TLS** | Sí | Sí | Sí | No |
| **Por interfaz** | Sí | No | No | No |
| **Uso típico** | Escritorio/servidor ligero | Servidores DNS autoritativos | Resolver local seguro | Red local + DHCP |

## Cuándo usar systemd-resolved vs un servidor DNS dedicado

**Usa systemd-resolved cuando:**
- Necesitas resolución DNS básica en un escritorio o servidor
- Quieres gestión sencilla por interfaz de red
- No necesitas ser autoritativo para un dominio
- Prefieres configuración cero (viene activo por defecto)

**Usa BIND/Unbound/dnsmasq cuando:**
- Necesitas servir zonas DNS autoritativas para un dominio
- Quieres un resolver recursivo completo (sin depender de upstreams externos)
- Gestionas una red local con DHCP + DNS integrado
- Ejecutas un servidor de correo que requiere registros MX y PTR

## Enlaces externos

- [systemd-resolved — documentación oficial](https://systemd.io/RESOLVED/)
- [resolvectl(1) — man page](https://man.archlinux.org/man/resolvectl.1)
- [systemd-resolved(8) — man page](https://man.archlinux.org/man/systemd-resolved.8)
- [systemd-resolved — ArchWiki](https://wiki.archlinux.org/title/Systemd-resolved)
- [systemd-resolved — Ubuntu Wiki](https://wiki.ubuntu.com/systemd-resolved)

## Ver también

- [[systemd]] — ecosistema systemd
- [[DNS y BIND]] — servidor DNS autoritativo y zonas
- [[Redes Basicas]] — conceptos de red subyacentes
- [[systemd-networkd]] — configuración de red gestionada por systemd
- [[journalctl]] — consultar logs de systemd-resolved
- [[Firewall]] — puertos DNS (53) y mDNS (5353)

#concepto #systemd #red #dns
