---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: alta
---

# netstat

> Muestra conexiones de red, tablas de enrutamiento, estadísticas de interfaces y conexiones falsificadas. Es el comando legacy de diagnóstico de red — reemplazado por `ss` y `ip`.

## Sintaxis

```bash
netstat [opciones]
```

## Descripción

`netstat` (network statistics) fue durante décadas el estándar para diagnosticar redes en Linux: puertos en escucha, sockets establecidos, tabla de rutas y contadores por protocolo. Pertenece al paquete `net-tools` (junto a `ifconfig`, `route` y `arp`), que ya **no viene preinstalado** en las distros modernas. No es destructivo ni requiere sudo para consultas básicas; para ver el proceso asociado a cada socket (`-p`) hace falta ser root. Está obsoleto: su sustituto oficial es `ss` (de `iproute2`) y para rutas e interfaces, `ip`.

## Formato de salida

`netstat -a` (sockets TCP/UDP):

| Columna | Significado |
|---|---|
| `Proto` | Protocolo (tcp, udp, unix...) |
| `Recv-Q` | Bytes recibidos por la app y aún sin leer |
| `Send-Q` | Bytes enviados y aún sin confirmar |
| `Local Address` | Dirección y puerto local |
| `Foreign Address` | Dirección y puerto remoto |
| `State` | Estado del socket (LISTEN, ESTABLISHED, TIME_WAIT...) |

`netstat -i` (interfaces): `Iface`, `MTU`, `RX-OK`, `RX-ERR`, `TX-OK`, `TX-ERR`...

## Opciones frecuentes

| Flag / Opción | Efecto | Ejemplo |
|---|---|---|
| `-t` | Solo sockets TCP | `netstat -tlnp` |
| `-u` | Solo sockets UDP | `netstat -uln` |
| `-l` | Solo puertos en escucha | `netstat -ltn` |
| `-a` | Todos los sockets | `netstat -an` |
| `-n` | No resolver nombres ni DNS | `netstat -an` |
| `-p` | Proceso asociado (requiere root) | `sudo netstat -tlnp` |
| `-r` | Tabla de rutas | `netstat -rn` |
| `-i` | Estadísticas por interfaz | `netstat -i` |
| `-s` | Resumen por protocolo | `netstat -s` |

## Ejemplos de uso

```bash
netstat -tlnp                      # puertos TCP en escucha con su proceso
netstat -an | grep ESTABLISHED     # conexiones establecidas en este momento
netstat -uln                       # sockets UDP abiertos
netstat -rn                        # tabla de rutas (equivalente a route -n)
netstat -i                         # estado y errores de las interfaces
netstat -s                         # estadísticas TCP/UDP/ICMP
sudo netstat -tulpen               # todo en una sola pasada (con procesos)
```

## Casos de uso reales

- ¿Qué proceso ocupa el puerto 8080? `sudo netstat -tlnp | grep :8080` y ver el PID en la columna `PID/Program`.
- Comprobar que un servicio escucha solo en `127.0.0.1` o quedó expuesto en `0.0.0.0` a toda la red.
- Leer salidas de scripts o documentación antigua que todavía usan `netstat`.
- Detectar errores de RX/TX en interfaces con `netstat -i`.

## Combinaciones comunes con pipe

```bash
sudo netstat -tlnp | grep :80          # quién ocupa el puerto 80
netstat -an | grep -c ESTABLISHED      # número de conexiones establecidas
netstat -an | awk '{print $6}' | sort | uniq -c   # estados de sockets
netstat -rn | awk '{print $1, $2}'     # destino y gateway
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `netstat -tulpn` | `ss -tulpn` | Más rápido y detallado, sin paquete extra |
| `netstat -rn` | `ip route` | Vista limpia y con métricas |
| `netstat -i` | `ip -s link` | Contadores de interfaces |
| `netstat -s` | `ss -s` | Resumen por protocolo |
| `arp -a` | `ip neigh` | Tabla de vecinos ARP completa |

Para tráfico en tiempo real: `iftop`, `nethogs` o `tcpdump`; para escaneo remoto, `Nmap`.

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `netstat: command not found` | `net-tools` no instalado | `sudo apt install net-tools` o usar `ss` |
| No ves procesos con `-p` | Falta privilegios de root | `sudo netstat -tlnp` |
| Puertos resueltos como `:mysql` | No se pasó `-n` | Añadir `-n` para ver números |
| Estado `TIME_WAIT` abundante | Cierres TCP recientes | Normal: espera a que el SO haga cleanup |
| `ifconfig` también ausente | Suite net-tools obsoleta | Migrar a `ss` y `ip` |

## Notas y advertencias

- Usa `ss` en vez de `netstat`: mismo propósito, mejor rendimiento y sin dependencias.
- `-p` requiere root para ver procesos ajenos; sin sudo solo verás los tuyos.
- Un socket en `TIME_WAIT` no es un peligro por sí mismo: es el cierre normal de TCP.
- `netstat` solo muestra el estado local de la máquina: no sustituye un escaneo remoto con [[Nmap]].
- Los puertos en escucha en `0.0.0.0` indican exposición a la red: revisa con `-tl` regularmente.

## Enlaces externos

- [Wikipedia — netstat](https://en.wikipedia.org/wiki/Netstat)
- [man netstat(8)](https://man7.org/linux/man-pages/man8/netstat.8.html)
- [Arch Wiki — Network configuration](https://wiki.archlinux.org/title/Network_configuration)

## Ver también

- [[ss]] — reemplazo moderno y rápido de netstat
- [[ip]] — reemplazo moderno de ifconfig y route
- [[Nmap]] — escaneo de puertos remoto
- [[Redes Basicas]] — fundamentos de red
- [[SSH]] — conexiones remotas y diagnóstico de puerto 22

#comando #redes