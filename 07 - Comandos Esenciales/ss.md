---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# ss

> Inspecciona sockets de red: conexiones activas, puertos en escucha, estadísticas TCP/UDP. Es el reemplazo moderno de `netstat`. No necesita instalación (viene en `iproute2`).

## Sintaxis

```bash
ss [opciones]
ss [opciones] state <estado>          # filtrar por estado TCP
ss [opciones] '( dport = :80 or sport = :80 )'  # filtrar por puerto
```

## Descripción

`ss` (socket statistics) lee información directamente de `/proc/net/` y `/proc/net/tcp*` para mostrar sockets activos, puertos en escucha, estadísticas TCP y más. Es **más rápido y detallado que netstat**. Esencial para diagnosticar:

- ¿Qué servicio está usando el puerto 80?
- ¿Hay muchas conexiones en TIME-WAIT?
- ¿Cuántas conexiones tiene mi servidor?
- ¿Hay procesos escuchando en IPv4/IPv6?

**⚠️**: Usar `sudo` para ver procesos de otros usuarios (sin sudo, solo ves tus procesos).

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-t` | Solo sockets TCP | `ss -t` |
| `-u` | Solo sockets UDP | `ss -u` |
| `-l` | Solo sockets en escucha (listening) | `ss -lt` |
| `-p` | Mostrar el proceso dueño del socket (requiere sudo) | `sudo ss -tulpn` |
| `-n` | No resolver nombres (IPs y puertos numéricos) | `ss -tln` |
| `-a` | Todos los sockets (conectados + escucha) | `ss -tua` |
| `-s` | Estadísticas resumidas | `ss -s` |
| `-4` | Solo IPv4 | `ss -tln4` |
| `-6` | Solo IPv6 | `ss -tln6` |
| `-o` | Información de temporizadores | `ss -to state established` |
| `-e` | Información extendida | `ss -tle` |
| `-m` | Uso de memoria del socket | `ss -tlm` |
| `-r` | Resolver nombres DNS (más lento) | `ss -tr` |
| `-K` | Matar socket (forzar cierre) | `sudo ss -K dport = :80` |

## Formato de salida

```bash
ss -tulpn
# Netid  State    Recv-Q  Send-Q  Local Address:Port    Peer Address:Port    Process
# tcp    LISTEN   0       128     0.0.0.0:22            0.0.0.0:*            users:(("sshd",pid=1024,fd=3))
# tcp    LISTEN   0       128     [::]:22               [::]:*               users:(("sshd",pid=1024,fd=4))
# tcp    LISTEN   0       511     *:80                  *:*                  users:(("nginx",pid=2048,fd=6))
# tcp    ESTAB    0       0       192.168.1.10:22       10.0.0.5:54321       users:(("sshd",pid=3124,fd=3))
```

| Columna | Significado |
|---|---|
| **Netid** | Protocolo (tcp, udp, raw, unix) |
| **State** | Estado de la conexión (LISTEN, ESTAB, TIME-WAIT, etc.) |
| **Recv-Q / Send-Q** | Bytes en cola de recepción/transmisión |
| **Local Address:Port** | IP y puerto local |
| **Peer Address:Port** | IP y puerto remoto |
| **Process** | PID y nombre del proceso (con sudo) |

## La combinación estrella: `ss -tulpn`

```bash
# Ver TODOS los puertos en escucha con sus procesos
sudo ss -tulpn

# Desglose:
# -t = TCP
# -u = UDP
# -l = listening (solo en escucha)
# -p = proceso (PID + nombre)
# -n = numérico (no resuelve nombres de servicio)
```

## Ejemplos

```bash
# 1. Puertos en escucha (el clásico)
sudo ss -tulpn

# 2. ¿Qué está escuchando en el puerto 80?
sudo ss -tulpn | grep ':80'

# 3. ¿Nginx está corriendo?
sudo ss -tulpn | grep nginx

# 4. Estadísticas de conexiones
ss -s
# Total: 245 (ipv4: 210, ipv6: 35, unix: 120)

# 5. Conexiones establecidas
ss -t state established

# 6. Conexiones en TIME-WAIT (muchas puede agotar puertos)
ss -t state time-wait

# 7. Solo IPv4
ss -tln4

# 8. Filtrar por puerto específico con expresión
ss -t -p '( dport = :80 or sport = :80 )'

# 9. Conexiones a una IP específica
ss -tun dst 192.168.1.1

# 10. Conexiones desde una IP
ss -tun src 10.0.0.5

# 11. Ver uso de memoria por socket
ss -tlm

# 12. Matar conexión (forzar cierre, útil para troubleshooting)
sudo ss -K dport = :3000
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **¿Qué servicio está usando el puerto 3000?** | `sudo ss -tulpn \| grep ':3000'` |
| **¿Hay muchas conexiones TIME-WAIT?** | `ss -t state time-wait \| wc -l` |
| **¿Cuántas conexiones SSH activas tengo?** | `ss -t state established dport = :22` |
| **Verificar que un servicio está escuchando** | `sudo ss -tulpn \| grep -i postgres` |
| **Diagnosticar agotamiento de puertos** | `ss -s` (si hay muchas TIME-WAIT, aumentar `ip_local_port_range`) |
| **Matar conexión colgada** | `sudo ss -K dport = :3000` |

## Combinaciones comunes con pipe

```bash
# Contar conexiones por estado TCP
ss -t | awk '{print $1}' | sort | uniq -c | sort -rn

# Contar conexiones por IP remota
ss -t | grep ESTAB | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn

# Ver top 10 IPs por número de conexiones
ss -t | grep ESTAB | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -10

# Saber cuántas conexiones tiene cada proceso
sudo ss -tulpn | tail -n +2 | awk '{print $7}' | sort | uniq -c | sort -rn
```

## Estados de sockets TCP

| Estado | Significado |
|---|---|
| **LISTEN** | El socket está esperando conexiones entrantes (servidor). Buscar con `-l` |
| **ESTAB** | Conexión activa establecida entre dos hosts |
| **TIME-WAIT** | Conexión cerrada, esperando paquetes tardíos. Muchas pueden indicar agotamiento de puertos |
| **CLOSE-WAIT** | Conexión cerrada por el remoto, esperando que la app local la cierre. Muchas = app con bug |
| **SYN-SENT** | Cliente intentando conectar (posible firewall bloqueando) |
| **CLOSED** | Socket cerrado |

## ss vs netstat

| Característica | ss | netstat |
|---|---|---|
| **Velocidad** | ⭐ Más rápido (lee `/proc` directamente) | 🐢 Más lento |
| **Disponibilidad** | ✅ Viene preinstalado (`iproute2`) | ⚠️ Obsoleto, puede no venir |
| **Información** | Más detallada (temporizadores, estados TCP, memoria) | Información básica |
| **Paquete** | `iproute2` (incluido en todo Linux moderno) | `net-tools` (instalación separada) |
| **Filtros avanzados** | ✅ Expresiones de puerto, estados, IPs | ❌ Solo grep básico |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| **ss no muestra procesos** | Falta `sudo` para ver procesos de otros usuarios | Usar `sudo ss -tulpn` |
| **ss: command not found** | `iproute2` no instalado (muy raro) | `sudo apt install iproute2` |
| **No veo el puerto que esperaba** | El servicio no está corriendo o está en otro puerto | Verificar con `systemctl status servicio` o `ps aux \| grep servicio` |
| **Muchas conexiones TIME-WAIT** | Alta tasa de conexiones y cierres | Aumentar `net.ipv4.ip_local_port_range` con sysctl |
| **Muchas conexiones CLOSE-WAIT** | La app no cierra sockets correctamente | Revisar el código de la aplicación (bug de leak de conexiones) |
| **Recv-Q alto** | La app no lee datos del socket lo suficientemente rápido | La app está saturada o tiene un cuello de botella |

## Notas y advertencias

- **No instalar nada**: `ss` viene en `iproute2`, que está instalado en **todo Linux moderno**. `netstat` requiere `net-tools` que ya no está preinstalado.
- **Filtros con expresiones**: `ss` soporta un lenguaje de filtros propio: `dport = :80`, `sport > :1024`, `src 192.168.1.0/24`, `state established`.
- **`sudo` es necesario** para ver procesos de otros usuarios. Sin sudo, `-p` solo muestra tus procesos.
- **`ss -K`** (kill socket) está disponible en versiones recientes de iproute2 (5.x+). Permite cerrar conexiones sin reiniciar servicios.

## Enlaces externos

- [Wikipedia — ss (Unix)](https://en.wikipedia.org/wiki/Ss_(Unix))
- [Linux man page — ss(8)](https://man7.org/linux/man-pages/man8/ss.8.html)
- [Arch Wiki — ss](https://wiki.archlinux.org/title/Network_configuration#ss)
- [iproute2 GitHub](https://github.com/shemminger/iproute2)

## Ver también

- [[ip]] — configurar interfaces de red
- [[ping]] — probar conectividad básica
- [[curl]] — probar servicios HTTP
- [[Nmap]] — escaneo de puertos remoto
- [[netstat]] — comando legacy (instalar `net-tools` si lo necesitas)
- [[Redes Basicas]] — conceptos de red
- [[Cheat Sheet - Comandos Esenciales]]

#comando