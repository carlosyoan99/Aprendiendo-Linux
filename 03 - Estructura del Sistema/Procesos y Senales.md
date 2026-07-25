---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: sistema
prioridad: media
---

# Procesos y Señales

## Definición

Todo lo que se ejecuta en Linux es un **proceso** — una instancia en ejecución de un programa — identificado por un número único llamado **PID** (Process ID). Los procesos se organizan jerárquicamente: cada proceso (excepto el primero, el PID 1 o `init`/`systemd`) tiene un **proceso padre** (PPID).

Los procesos se comunican y controlan mediante **señales** (interrupciones enviadas por el kernel, por otros procesos, o por el usuario desde la terminal).

```bash
# Tu proceso actual (la shell)
$$
# El PID de tu shell padre
$PPID
```

---

## Estados de un proceso

Un proceso no siempre está "ejecutándose". El kernel puede tenerlo pausado, dormido, o incluso "vivo" pero sin consumir recursos.

| Estado | Código `ps aux` | Significado | Consume CPU |
|---|---|---|---|
| **Running** | `R` | Se está ejecutando o está listo para ejecutarse | ✅ Sí |
| **Sleeping** (interrumpible) | `S` | Esperando un evento (E/S, temporizador, señal) — estado normal de la mayoría de procesos | ❌ No |
| **Sleeping** (no interrumpible) | `D` | Esperando E/S (ej. disco, NFS). No responde a señales hasta que termine la operación | ❌ No |
| **Stopped** | `T` | Pausado por señal (SIGSTOP, SIGTSTP) o por el debugger (ptrace) | ❌ No |
| **Zombie** | `Z` | El proceso terminó pero el padre no recolectó su código de salida (no `wait()`). Ya liberó recursos | ❌ No |
| **Idle** | `I` | Similar a sleeping, pero más específico de kernels idle (kernel threads) | ❌ No |

```bash
# Ver estados de procesos en vivo
ps aux | awk '{print $8, $11}' | sort | uniq -c | sort -rn
# Ejemplo de salida:
#  130 S  (bash)
#   45 I  (kworker)
#   12 R  (procesos activos)
#    3 T  (stopped)
#    0 Z  (zombies — idealmente ninguno)
```

### Zombie — ¿qué son y por qué existen?

Un proceso zombie ha terminado pero su entrada en la tabla de procesos aún existe porque el padre no ejecutó `wait()` para leer su código de salida. El zombie ya liberó toda su memoria y recursos — solo ocupa una entrada en la tabla de procesos.

```bash
# Un zombie se ve así en ps:
$ ps aux | grep Z
USER   PID  PPID  STAT  COMMAND
carlos 1234 1000  Z     [firefox] <defunct>
#                      ↑ zombie   ↑ marcador de zombie
```

**¿Son malos?** Un par de zombies transitorios son normales. Muchos zombies persistentes indican un bug en el proceso padre (no está recolectando a sus hijos). Como los zombies ya no consumen CPU ni RAM, no afectan el rendimiento, pero agotan la tabla de procesos si se acumulan muchos.

**Solución:**
```bash
# No se puede matar un zombie con kill (ya está muerto).
# Hay que matar al PADRE (PPID) para que init herede y limpie los zombies:
kill -9 <PPID_del_zombie>
# O mejor: reiniciar el proceso padre si es un servicio.
```

> Ver [[kill]] para más detalles sobre señales.

### D — Uninterruptible Sleep (D state)

El estado `D` es más preocupante que los zombies. Significa que el proceso está esperando una operación de E/S (disco, NFS, FUSE) y **no puede ser interrumpido** ni siquiera por SIGKILL. Si un proceso se queda en `D` permanentemente, suele indicar un disco fallando o un servidor NFS colgado.

```bash
# Ver procesos en D (uninterruptible sleep)
ps aux | awk '$8 ~ /D/'
# Si hay muchos y no desaparecen, revisar el disco:
dmesg | grep -iE "i/o error|hung_task|blocked"
```

---

## Jerarquía de procesos

```bash
# Ver el árbol de procesos
ps -ef --forest
# O con pstree (más visual)
pstree
# Ejemplo:
# systemd───lightdm───Xorg
#         ├─lightdm───lightdm-session───i3───firefox───Isolated Web Co
#         │                              ├─alacritty───zsh───vim
#         │                              └─alacritty───zsh───ps
#         └─NetworkManager───dhcpcd
```

| Componente | PID | Rol |
|---|---|---|
| `systemd` (o `init`) | **1** | Primer proceso — padre de todos los demás. No se puede matar |
| `kthreadd` | **2** | Creador de hilos del kernel (kworker, kswapd) |
| Procesos de usuario | 1000+ | Tus aplicaciones (shell, navegador, editor) |
| Procesos huérfanos | — | Cuando un padre muere, sus hijos son adoptados por PID 1 (init/systemd) |

```bash
# Ver el PID 1 de tu sistema
ps -p 1 -o pid,comm
```

---

## Exploración de `/proc`

El sistema de archivos virtual `/proc` contiene información en tiempo real de cada proceso y del kernel. No ocupa espacio en disco — es una interfaz con el kernel.

```bash
# Cada proceso tiene su directorio /proc/<PID>/
ls /proc/1234/
#  cmdline    → línea de comando completa que invocó el proceso
#  cwd        → symlink al directorio de trabajo actual
#  environ    → variables de entorno del proceso (separadas por \0)
#  exe        → symlink al binario ejecutable
#  fd/        → descriptores de archivo abiertos (0=stdin, 1=stdout, 2=stderr)
#  maps       → regiones de memoria mapeadas
#  status     → estado, PID, PPID, UID, memoria, señales
#  cgroup     → a qué cgroup pertenece
#  limits     → límites de recursos (ulimit)
#  root/      → symlink a su raíz (puede estar en un chroot/namespace distinto)
```

### Información útil de /proc

```bash
# Estado detallado de un proceso
cat /proc/1234/status
# Name:   firefox
# State:  S (sleeping)
# Pid:    1234
# PPid:   1000
# Uid:    1000 1000 1000 1000    # real, effective, saved, filesystem
# Gid:    100 100 100 100
# VmRSS:  450000 kB              # RAM física usada (~450 MB)
# Threads: 48
# voluntary_ctxt_switches: 1234  # cambios de contexto voluntarios
# nonvoluntary_ctxt_switches: 56 # cambios forzados por agotar quantum

# Variables de entorno (útil para debug)
cat /proc/1234/environ | tr '\0' '\n' | grep -E "DISPLAY|WAYLAND|DBUS"

# Descriptores de archivo (detectar fugas de fd)
ls -la /proc/1234/fd/ | head
# lrwx------  ... 0 -> /dev/pts/0    (stdin)
# lrwx------  ... 1 -> /dev/pts/0    (stdout)
# lrwx------  ... 2 -> /dev/pts/0    (stderr)
# lr-x------  ... 3 -> /home/user/documento.txt  (archivo abierto)
# lrwx------  ... 4 -> socket:[12345]            (socket de red)

# Línea de comando completa (con argumentos)
cat /proc/1234/cmdline | tr '\0' ' '
# /usr/bin/firefox --new-window about:preferences

# Límites de recursos del proceso
cat /proc/1234/limits
# Limit                     Soft Limit           Hard Limit
# Max cpu time              unlimited            unlimited
# Max file size             unlimited            unlimited
# Max data size             unlimited            unlimited
# Max stack size            8388608               unlimited
# Max open files            1024                 524288
# Max processes             63735                63735
```

### Estadísticas globales del sistema en /proc

```bash
cat /proc/cpuinfo         # información de CPUs (modelo, núcleos, flags)
cat /proc/meminfo         # memoria RAM total, libre, buffers, caché
cat /proc/loadavg         # load average (1, 5, 15 min)
cat /proc/uptime          # tiempo encendido + tiempo idle
cat /proc/version         # versión del kernel + compilador
cat /proc/sys/...         # parámetros del kernel ajustables (sysctl)
```

> El contenido de /proc cambia constantemente — lo que ves es el estado actual, no histórico. Para persistencia y logs, usar `journalctl`.

---

## nice / renice — Prioridad de procesos

Linux asigna una **prioridad** a cada proceso. El planificador (scheduler) usa esta prioridad para decidir qué proceso ejecuta y por cuánto tiempo.

### Valor nice

El **valor nice** es una sugerencia de prioridad (no un comando absoluto). Rango: **-20 (máxima prioridad) a +19 (mínima prioridad)**. Por defecto: 0.

```
Más prioritario                    Menos prioritario
   -20 ────···──── 0 ────···──── +19
   (sistema)        (default)      (tareas de baja prioridad)
```

```bash
# Ver nice de los procesos (NI column en ps)
ps -eo pid,comm,nice,pri | sort -n -k 3 | head -10

# Ver en top (columna NI)
top
# Para mostrar nice en htop: F2 → Columns → add NI
```

```bash
# Iniciar un proceso con nice específico
nice -n 10 ./script-lento.sh          # prioridad baja (nice 10)
nice -n -5 ./tarea-urgente            # prioridad alta (nice -5, requiere sudo)
nice --19 ./tarea-critica              # máxima prioridad (requiere sudo)

# Cambiar nice de un proceso en ejecución
renice -n 5 -p 1234                    # cambiar nice del PID 1234 a 5
renice -n -10 -p 1234                  # aumentar prioridad (requiere sudo)
renice -n 15 -u carlos                 # cambiar nice de TODOS los procesos de un usuario

# También con top: presiona r, escribe el PID y el nuevo valor nice
```

⚠️ Solo root puede **aumentar** la prioridad de un proceso (valores nice negativos). Un usuario normal solo puede **disminuirla** (hacerla menos prioritaria, es decir, valor nice positivo).

### ¿Cuándo usar nice?

| Situación | Comando nice |
|---|---|
| Compilar en background sin que se note | `nice -n 19 make -j8` |
| Copia de archivos grande que no debe afectar al resto | `nice -n 15 rsync -av /origen /destino` |
| Script importante que debe terminar rápido | `sudo nice -n -10 ./script-produccion.sh` |

### ionice — Prioridad de E/S (disco)

Además de CPU, puedes priorizar el acceso a disco con `ionice`:

```bash
# Clases de ionice
# 1 = Idle    → solo corre si nadie más usa el disco
# 2 = Best-effort → compite con otros procesos (default)
# 3 = Realtime → siempre tiene prioridad

ionice -c 3 rsync -av /origen /destino      # E/S idle (solo cuando nadie escribe)
ionice -c 1 -n 0 make -j8                   # alta prioridad de E/S
```

---

## Procesos en background y foreground

Cuando ejecutas un comando en la terminal, este se ejecuta en **foreground** (ocupa la terminal hasta que termina). Puedes enviarlo a **background** para que se ejecute sin bloquear la terminal.

```bash
# Ejecutar directamente en background (añadir & al final)
./script-largo.sh &

# Enviar un proceso en foreground a background
# Ctrl+Z → pausa el proceso (SIGTSTP) y lo envía a background detenido
bg       → lo reanuda en background

# Traer un proceso de background a foreground
fg

# Listar procesos en background de la terminal actual
jobs
# [1]+  Running                 ./script-largo.sh &
# [2]-  Stopped                 vim documento.txt

# Matar un trabajo en background por su job ID
kill %1                          # matar trabajo #1
kill %2                          # matar trabajo #2
```

### Gestión de múltiples trabajos

```bash
sleep 100 &                      # trabajo 1
ping 8.8.8.8 &                   # trabajo 2
find / -name "*.conf" > output.txt &  # trabajo 3

jobs
# [1]   Running                 sleep 100 &
# [2]   Running                 ping 8.8.8.8 &
# [3]+  Running                 find / -name "*.conf" > output.txt &

# Traer un trabajo específico al frente
fg %1                            # traer sleep 100
fg %2                            # traer ping

# Enviar Ctrl+Z para pausar y luego bg para reanudar en background
```

### nohup — Procesos que sobreviven al cierre de terminal

Cuando cierras la terminal, el shell envía SIGHUP a todos sus procesos hijos, lo que los termina. `nohup` los protege:

```bash
nohup ./script-largo.sh &
# La salida se redirige automáticamente a nohup.out

nohup ./script-largo.sh > mi-log.log &
# También puedes redirigir manualmente

disown                           # desde la shell: desvincula el último proceso bg del terminal
disown %1                        # desvincula un trabajo específico
```

> `nohup` + `&` es la combinación clásica para procesos que deben seguir ejecutándose aunque cierres sesión. Para tareas más robustas, usar `tmux`, `screen` o systemd services.

---

## Señales comunes (expandido)

| Señal | Número | Efecto | Cómo enviarla |
|---|---|---|---|
| **SIGTERM** | 15 | Pide terminar limpiamente (guardar datos, cerrar conexiones) | `kill <PID>` (la señal por defecto) |
| **SIGKILL** | 9 | Mata sin posibilidad de limpieza — **último recurso** | `kill -9 <PID>` |
| **SIGHUP** | 1 | Recargar configuración (la mayoría de servicios) o colgar terminal | `kill -1 <PID>`, `killall -HUP <nombre>` |
| **SIGINT** | 2 | Interrupción — equivalente a **Ctrl+C** | `kill -2 <PID>` |
| **SIGQUIT** | 3 | Terminar + guardar core dump (para debug) | `kill -3 <PID>` |
| **SIGSTOP** | 19 | Pausar el proceso (congelarlo, no terminarlo) | `kill -19 <PID>` |
| **SIGCONT** | 18 | Reanudar un proceso pausado | `kill -18 <PID>` |
| **SIGTSTP** | 20 | Pausa desde terminal — equivalente a **Ctrl+Z** | `kill -20 <PID>` |
| **SIGUSR1** | 10 | Señal de usuario 1 (cada programa decide qué hacer) | `kill -10 <PID>` |
| **SIGUSR2** | 12 | Señal de usuario 2 | `kill -12 <PID>` |
| **SIGPIPE** | 13 | Tubería rota (el otro extremo del pipe cerró) | La envía el kernel automáticamente |
| **SIGCHLD** | 17 | El proceso hijo terminó (el padre recibe esta señal) | La envía el kernel automáticamente |

```bash
# Ejemplos prácticos con señales

# Recargar configuración de nginx sin reiniciar el servicio
sudo kill -1 $(pgrep nginx | head -1)
# O mejor con systemd:
sudo systemctl reload nginx

# Pausar y reanudar un proceso (útil para congelar temporalmente)
kill -19 1234    # pausar firefox
kill -18 1234    # reanudar firefox

# Ctrl+C es SIGINT, Ctrl+Z es SIGTSTP
# En top, presiona k y escribe el PID + señal para matar un proceso
```

> Más detalles en [[kill]].

---

## cgroups — Control de recursos por grupo

Además de nice (por proceso), Linux permite limitar recursos por **grupos de procesos** mediante **cgroups** (control groups). Cada unidad de systemd (servicio, usuario, contenedor) tiene su propio cgroup.

```bash
# Ver cgroups desde systemd
systemd-cgtop                    # top por servicio/ unidad
systemd-cgls                     # árbol de cgroups

# Ver el cgroup del proceso actual
cat /proc/self/cgroup
# 0::/user.slice/user-1000.slice/session-3.scope
```

La nota detallada de cgroups cubre:
- Límites de CPU, memoria, E/S y procesos
- Configuración en unit files de systemd
- Uso directo de cgroups v2
- cgroups y contenedores (Docker, Podman)

> Para profundizar: [[cgroups (control de recursos)]].

---

## Comandos clave (resumen)

| Comando | Para qué |
|---|---|
| `ps aux` | Listar todos los procesos con su estado |
| `top` / `htop` | Monitor interactivo en tiempo real |
| `kill <PID>` | Enviar señal (SIGTERM por defecto) |
| `kill -9 <PID>` | SIGKILL — último recurso |
| `pgrep <nombre>` | Buscar PID por nombre |
| `pkill <nombre>` | Matar por nombre |
| `nice -n 10 <comando>` | Ejecutar con prioridad baja |
| `renice -n 5 -p <PID>` | Cambiar prioridad en caliente |
| `jobs` | Listar procesos bg de la terminal |
| `bg` / `fg` | Mover procesos entre bg y fg |
| `nohup <comando> &` | Ejecutar sin que SIGHUP lo mate |
| `systemd-cgtop` | Monitor por cgroup/servicio |
| `pstree` | Árbol de procesos |
| `cat /proc/<PID>/status` | Info detallada de un proceso |
| `ls /proc/<PID>/fd/` | Descriptores de archivo abiertos |

## Por qué importa

- **Zombies y D state**: identificar procesos zombies te ayuda a detectar software mal escrito. El estado `D` persistente indica problemas de hardware (disco, NFS).
- **/proc**: es la navaja suiza para debug — desde ver variables de entorno de un proceso hasta detectar fugas de descriptores de archivo.
- **nice/renice**: te permite compilar, copiar o procesar datos sin que la PC se vuelva inusable.
- **bg/fg/nohup**: gestionar múltiples tareas desde una terminal es base de productividad en Linux.
- **cgroups**: crítico para contenedores, servicios systemd y servidores multi-tenant.
- **Señales**: `kill -9` es el último recurso. Siempre probar SIGTERM primero. Diferenciar SIGTERM de SIGKILL evita corromper datos.

## Ver también

- [[kill]] — enviar señales a procesos
- [[ps]] — listar procesos
- [[top]] — monitor interactivo
- [[cgroups (control de recursos)]] — control de recursos por grupo
- [[systemd]] — gestión de servicios y procesos del sistema
- [[Proc y Sys]] — sistemas de archivos virtuales /proc y /sys
- [[La Shell]] — gestión de trabajos en la terminal
- [[tmux]] — persistencia de sesiones más robusta que nohup

## Enlaces externos

- [Wikipedia — Process (computing)](https://en.wikipedia.org/wiki/Process_(computing))
- [Wikipedia — Signal (IPC)](https://en.wikipedia.org/wiki/Signal_(IPC))
- [Arch Wiki — Signal](https://wiki.archlinux.org/title/Signal)

#sistema #procesos
