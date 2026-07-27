---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: alta
---

# Firewall en Linux

## ¿Qué es un firewall?

Un firewall controla el tráfico de red entrante y saliente según reglas definidas. En Linux, el firewall opera a nivel de kernel gracias a **Netfilter** — el marco de filtrado de paquetes integrado en el kernel.

| Capa | Qué es |
|---|---|
| **Netfilter** | Framework en el kernel que intercepta paquetes |
| **nftables** | Frontend moderno (reemplaza iptables). Default en Arch, Debian 11+, Fedora, RHEL 9+ |
| **iptables** | Frontend legacy (deprecado pero aún usado). Default en Debian 10-, Ubuntu < 22.04 |
| **ufw** | Interfaz simplificada sobre iptables/nftables. Default en Ubuntu |
| **firewalld** | Gestor dinámico de zonas. Default en Fedora/RHEL |

Para el día a día: elige **ufw** si quieres simplicidad, o **nftables** si necesitas control fino.

---

## nftables — el estándar moderno

Reemplazo de iptables con sintaxis más limpia, mejor rendimiento y atomicidad (las reglas se cargan todas juntas o ninguna).

### Verificar estado

```bash
sudo nft list ruleset                    # mostrar todas las reglas activas
sudo systemctl status nftables           # servicio activo?
```

> ⚠️ **Orden de las reglas**: nftables evalúa las reglas en orden. La primera regla que coincide determina el destino del paquete. Siempre añade las reglas **permisivas primero** y el `drop`/`reject` al final, o usa `policy drop` en la cadena.

### Reglas básicas

```bash
# Crear tabla y cadenas (tabla = contenedor, cadena = punto del tráfico)
sudo nft add table inet filter           # tabla para IPv4 + IPv6 (inet)

# Cadenas base (input = entrante, output = saliente, forward = reenviado)
# La política por defecto es accept — denegaremos con reglas explícitas al final
sudo nft add chain inet filter input { type filter hook input priority 0\; policy accept\; }
sudo nft add chain inet filter output { type filter hook output priority 0\; policy accept\; }

# 1. Permitir tráfico establecido (conexiones ya aceptadas) — siempre primero
sudo nft add rule inet filter input ct state established,related accept

# 2. Permitir loopback (localhost)
sudo nft add rule inet filter input iif lo accept

# 3. Permitir servicios específicos
sudo nft add rule inet filter input tcp dport 22 accept       # SSH
sudo nft add rule inet filter input tcp dport { 80, 443 } accept  # HTTP/HTTPS

# 4. Permitir ping (ICMP)
sudo nft add rule inet filter input icmp type echo-request accept

# 5. Denegar todo lo demás (se añade al final)
sudo nft add rule inet filter input drop
```

### Script completo (archivo .nft)

```bash
# /etc/nftables.conf — se carga al inicio
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;

        # Tráfico ya establecido
        ct state established,related accept

        # Loopback
        iif lo accept

        # ICMP (ping)
        icmp type echo-request accept

        # Servicios abiertos
        tcp dport 22 accept      # SSH
        tcp dport 80 accept      # HTTP
        tcp dport 443 accept     # HTTPS

        # Log y descartar el resto
        log prefix "nftables-input: " counters drop
    }

    chain forward {
        type filter hook forward priority 0; policy drop;
    }

    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

```bash
# Cargar el archivo de reglas
sudo nft -f /etc/nftables.conf
sudo systemctl enable --now nftables
```

### Comandos útiles

```bash
# Listar reglas con handles (IDs) para borrar
sudo nft list ruleset -a

# Borrar una regla por handle
sudo nft delete rule inet filter input handle 5

# Añadir regla al inicio (insert) en vez de al final
sudo nft insert rule inet filter input tcp dport 2222 accept

# Conteo de paquetes por regla
sudo nft list ruleset | grep -A2 "tcp dport"
# Cada regla muestra: bytes y paquetes procesados

# Ver reglas de NAT
sudo nft list table nat
```

### Tablas, cadenas y hooks

| Tabla | Ámbito | Uso típico |
|---|---|---|
| `inet filter` | IPv4 + IPv6 | Filtrado de paquetes (input/output/forward) |
| `inet nat` | IPv4 + IPv6 | NAT (solo en cadenas prerouting/postrouting/input/output) |
| `ip filter` | Solo IPv4 | Si necesitas separar IPv4 de IPv6 |
| `ip6 filter` | Solo IPv6 | Reglas específicas para IPv6 |

| Hook | Cuándo se ejecuta | Dirección |
|---|---|---|
| `input` | Paquetes destinados al equipo local | Entrante |
| `output` | Paquetes originados en el equipo | Saliente |
| `forward` | Paquetes que se reenvían (routing) | Reenviado |
| `prerouting` | Antes de decidir ruta | Entrante temprano |
| `postrouting` | Después de decidir ruta | Saliente tardío |

---

## iptables — el clásico (legacy, aún en uso)

Aunque deprecado, iptables sigue siendo el firewall por defecto en muchas guías e imágenes Docker. Usa una sintaxis más verbosa que nftables.

```bash
# Política por defecto: denegar todo
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Permitir conexiones establecidas
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Permitir loopback
sudo iptables -A INPUT -i lo -j ACCEPT

# Abrir puertos
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT    # SSH
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT    # HTTP
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT   # HTTPS

# Ver reglas
sudo iptables -L -n -v                    # lista detallada con contadores
sudo iptables-save                         # dump de todas las reglas (para persistir)

# Borrar reglas
sudo iptables -F                           # flush (borrar todas)
sudo iptables -D INPUT -p tcp --dport 80 -j ACCEPT  # borrar una específica

# Persistir reglas (en Debian/Ubuntu)
sudo iptables-save | sudo tee /etc/iptables/rules.v4
```

### ip6tables (para IPv6)

```bash
# iptables solo aplica a IPv4. Para IPv6 necesitas ip6tables:
sudo ip6tables -P INPUT DROP
# ... mismas reglas pero para tráfico IPv6
```

⚠️ Si bloqueas IPv6 pero tu servidor DNS responde con IPv6, las conexiones fallarán silenciosamente. O bloqueas ambas o permites ambas.

---

## ufw — Uncomplicated Firewall (Ubuntu y derivadas)

Interfaz de alto nivel sobre iptables/nftables. Ideal para principiantes o para asegurar un servidor rápidamente.

### Comandos básicos

```bash
# Estado
sudo ufw status                           # ¿activo?
sudo ufw status verbose                   # estado + política por defecto
sudo ufw status numbered                  # reglas numeradas (para borrar)

# Activar/desactivar
sudo ufw enable                           # activar firewall
sudo ufw disable                          # desactivar (cuidado)

# Política por defecto
sudo ufw default deny incoming            # denegar todo entrante
sudo ufw default allow outgoing           # permitir todo saliente

# Permitir servicios por nombre
sudo ufw allow ssh                        # permite puerto 22
sudo ufw allow http                       # permite puerto 80
sudo ufw allow https                      # permite puerto 443

# Permitir por puerto
sudo ufw allow 22/tcp
sudo ufw allow 8080/tcp

# Denegar
sudo ufw deny 23/tcp                      # denegar telnet

# Desde IP específica
sudo ufw allow from 192.168.1.100         # todo desde esa IP
sudo ufw allow from 192.168.1.0/24 to any port 22  # SSH solo desde LAN

# Borrar reglas
sudo ufw delete allow 8080/tcp
sudo ufw delete 3                         # borrar regla número 3

# Verbosidad en logs de denegaciones
sudo ufw logging on
# Los logs van a /var/log/ufw.log (o kern.log)
```

### Perfiles de aplicación

```bash
# ufw conoce aplicaciones comunes por nombre
sudo ufw app list                         # lista de perfiles disponibles
# 'OpenSSH', 'Apache Full', etc.
sudo ufw allow 'OpenSSH'
sudo ufw allow 'Apache Full'
```

---

## firewalld — Zonas dinámicas (Fedora/RHEL)

Gestor de firewall con zonas (home, public, dmz, trusted). Cada zona tiene su propio conjunto de reglas. Ideal para portátiles que cambian de red.

```bash
# Estado
sudo firewall-cmd --state                 # running / not running
sudo firewall-cmd --list-all              # reglas de la zona activa

# Zonas
sudo firewall-cmd --get-active-zones      # qué zona está activa (ej: public)
sudo firewall-cmd --zone=public --add-service=http  # permitir HTTP
sudo firewall-cmd --zone=public --add-service=ssh --permanent  # permanente

# Recargar (sin perder conexiones activas)
sudo firewall-cmd --reload
```

---

## Tabla comparativa

| Característica | ufw | firewalld | nftables | iptables |
|---|---|---|---|---|
| **Facilidad** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐ |
| **Control fino** | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Rendimiento** | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **IPv4 + IPv6** | ✅ automático | ✅ automático | ✅ (tabla inet) | ❌ (por separado) |
| **Atomicidad** | ❌ | ❌ | ✅ | ❌ |
| **Por defecto en** | Ubuntu | Fedora/RHEL | Arch, Debian 11+ | Legacy |
| **Recomendado para** | Principiantes, servidores simples | Escritorios Fedora, portátiles | Usuarios avanzados, servidores | Solo si ya hay reglas escritas |

---

## Troubleshooting

```bash
# Ver reglas activas
sudo nft list ruleset                     # nftables
sudo ufw status verbose                   # ufw
sudo iptables -L -n -v                    # iptables

# Probar si un puerto está accesible desde fuera
# Desde otra máquina:
nc -zv <ip-del-servidor> 22              # probar puerto 22

# Desde el propio servidor:
ss -tulpn | grep :22                     # ¿el servicio está escuchando?

# Ver logs de denegaciones
sudo journalctl -k -f | grep -i "nft\|iptables\|DENIED"   # logs del kernel
sudo tail -f /var/log/ufw.log                              # logs de ufw
sudo tail -f /var/log/syslog | grep -i firewall            # logs genéricos

# Desactivar temporalmente (para pruebas)
sudo ufw disable                          # solo si estás en local/IP estable
sudo systemctl stop nftables
# ⚠️  Hacer esto en un servidor remoto puede dejarte fuera
```

### Cosas que nunca hacer en un servidor remoto

```bash
# ❌ Esto te deja fuera si estás conectado por SSH:
sudo ufw default deny incoming && sudo ufw enable

# ✅ Secuencia segura:
sudo ufw allow ssh                        # primero abrir SSH
sudo ufw default deny incoming            # luego política restrictiva
sudo ufw enable                           # finalmente activar

# ❌ Aplicar reglas sin permitir SSH antes
# ❌ iptables -P INPUT DROP sin haber permitido antes el puerto 22
```

---

## Ver también

- [[Redes Basicas]] — conceptos de red
- [[SSH]] — servicio a proteger primero
- nftables — profundización en la sección correspondiente
- [[Gestores de Paquetes]] — instalar ufw, firewalld
- [[Solución de Problemas - Recursos]] — metodología de troubleshooting

## Enlaces externos

- [Wikipedia — Firewall (computing)](https://en.wikipedia.org/wiki/Firewall_(computing))
- [Wikipedia — nftables](https://en.wikipedia.org/wiki/Nftables)
- [Arch Wiki — Firewall](https://wiki.archlinux.org/title/Firewall)

#sistema
#seguridad