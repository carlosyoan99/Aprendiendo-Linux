---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-01
estado: resuelto
categoria: programa
prioridad: baja
---

# procps-ng

## Qué es

**procps-ng** es un conjunto de utilidades de línea de comandos para **monitorizar y gestionar procesos y recursos del sistema** (CPU, memoria, disco, red, usuarios). Viene preinstalado en prácticamente cualquier distro Linux.

Su nombre viene de **procps** ("process + ps"), el proyecto original de utilidades de procesos; **procps-ng** es su continuación (fork) moderna, iniciada en 2012 cuando se abandonó el desarrollo del procps clásico. A día de hoy procps-ng es el paquete estándar que se instala con el meta-paquete `base` (Arch), `procps` (Debian/Ubuntu) o `procps-ng` (Fedora).

Todos estos comandos leen sus datos **directamente del pseudo-sistema de archivos `/proc`** (y de `/sys`), donde el kernel expone en tiempo real el estado de procesos, memoria, CPU y dispositivos.

## Componentes principales

| Comando | Función | Alternativa moderna |
|---|---|---|
| `ps` | Listar procesos en ejecución | `ps` con `aux` |
| `top` | Monitor interactivo de procesos | **htop**, **btop**, **atop** |
| `free` | Mostrar uso de memoria RAM/swap | `free -h` |
| `uptime` | Tiempo de actividad del sistema | — |
| `vmstat` | Estadísticas de memoria, CPU, I/O | **atop**, **sysstat** |
| `w` | Usuarios conectados y su actividad | — |
| `kill` | Enviar señales a procesos | `killall`, `pkill` |
| `pgrep` / `pkill` | Buscar/matar procesos por nombre | — |
| `slabtop` | Estadísticas de caché del kernel | — |
| `psmisc` (relacionado) | `killall`, `pstree`, `fuser` | — |

> `procps-ng` es el paquete base; **psmisc** es un paquete complementario (también casi universal) que añade `killall`, `pstree` y `fuser`.

## Opciones recurrentes

```bash
ps aux                               # todos los procesos con usuario y %cpu/%mem
ps -ef                               # formato estándar System V
ps -u $USER --sort=-%mem | head      # procesos del usuario ordenados por memoria
top -d 2 -n 10 -b > top.log          # batch: 10 muestras cada 2 s (para scripts)
free -h                              # memoria legible (G/M/K)
free -s 5 -c 3                       # repetir cada 5 s, 3 veces
uptime -p                            # tiempo activo legible ("3 hours, 5 minutes")
vmstat 2 5                           # muestra cada 2 s, 5 veces
kill -9 1234                         # señal SIGKILL (forzar)
pkill -f "proceso*"                  # matar por patrón (cuidado con falsos positivos)
pgrep -la sshd                       # listar PIDs de sshd con nombre completo
```

## Señales comunes (kill)

| Señal | Número | Uso |
|---|---|---|
| `SIGTERM` | 15 | Terminación "limpia" (por defecto) |
| `SIGKILL` | 9 | Forzar terminación inmediata (no capturable) |
| `SIGHUP` | 1 | Recargar configuración (many daemons) |
| `SIGINT` | 2 | Interrumpir (equivale a Ctrl+C) |

Ver la lista completa con `kill -l`.

## Ejemplos reales

```bash
# Uso de memoria
free -h

# Estadísticas del sistema (cada 2 segundos)
vmstat 2

# Usuarios conectados y qué hacen
w

# Matar proceso por nombre
pkill -f nombre_proceso

# Encontrar el proceso que más memoria consume
ps aux --sort=-rss | head -6
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `free` muestra RAM casi toda usada | Linux cachea archivos (buff/cache) | Normal; la memoria cacheada se libera bajo demanda. Mira `free -h` columna `available` |
| `ps` no muestra todos mis procesos | Distribución usa namespaces/containers | `ps aux` dentro del contenedor solo ve sus procesos; usa `ps aux` anfitrión |
| `top` parpadea o no entiendo las columnas | Interfaz poderosa de top | Usa `top` + `x` (resaltar columna ordenada) o migra a **htop**/btop |
| `pkill` mata procesos no deseados | El patrón glob coincide de más | Usa `pgrep -la` primero para revisar qué matarías antes de `pkill` |
| No encuentro el comando `vmstat` | No está en PATH o no es procps | `which vmstat`; en algunas distros está en `procps`/`procps-ng` |

## Ver también

- [[Proc y Sys]] — el pseudo-filesystem `/proc` y `/sys`
- [[Procesos y Senales]] — señales y gestión de procesos
- [[Coreutils y util-linux]] — comandos base del sistema
- [[Utilidades Base del Sistema]] — índice de paquetes base
- [[binutils]] — herramientas de binarios
- [[htop btop]] — monitores modernos
- [[top]] — monitor interactivo de procesos
- [[ps]] — listar procesos
- [[free]] — memoria
- [[kill]] — señales

## Enlaces externos

- [GitLab — procps-ng](https://gitlab.com/procps-ng/procps)
- [Wikipedia — procps](https://en.wikipedia.org/wiki/Procps)
- [man7.org — proc(5)](https://man7.org/linux/man-pages/man5/proc.5.html)

#programa #sistema