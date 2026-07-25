---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: alta
---

# Optimización de rendimiento

> Guía práctica para identificar cuellos de botella y optimizar el rendimiento de un sistema Linux: kernel tuning, límites de recursos, plan de diagnóstico sistemático y monitoreo continuo.

## Definición

La optimización de rendimiento en Linux consiste en **identificar y eliminar cuellos de botella** mediante el ajuste de parámetros del kernel, límites de recursos del sistema, configuración de servicios y la elección del hardware y sistema de archivos adecuados. No se trata de tocar parámetros al azar, sino de seguir un **proceso sistemático**: medir → identificar → ajustar → verificar.

```
Ciclo de optimización:

  1. MEDIR                    2. IDENTIFICAR
  ┌──────────────────┐        ┌──────────────────────┐
  │ perf stat         │        │ perf report           │
  │ top/htop/btop     │        │ flamegraphs           │
  │ iostat, vmstat    │        │ systemd-cgtop         │
  │ dstat, sar        │        │ strace, ltrace        │
  │ nethogs, iftop    │        │ journalctl -xe        │
  └────────┬─────────┘        └──────────┬───────────┘
           │                             │
           └──────────────┬──────────────┘
                          ▼
              3. AJUSTAR
          ┌──────────────────────┐
          │ sysctl -w clave=val  │
          │ ulimit -n 1048576    │
          │ CPU governor         │
          │ mount -o noatime     │
          │ ionice / nice        │
          └──────────┬───────────┘
                     │
                     ▼
              4. VERIFICAR
          ┌──────────────────────┐
          │ repetir paso 1      │
          │ comparar métricas   │
          │ ¿mejoró? ¿empeoró?  │
          └──────────────────────┘
```

## Por qué importa

Sin optimización, el sistema usa configuraciones genéricas que funcionan para todo el mundo pero no están afinadas para tu caso de uso específico. Ajustar parámetros clave puede significar:

| Escenario | Sin optimizar | Optimizado | Ganancia |
|---|---|---|---|
| **Servidor web con 10k conexiones simultáneas** | `somaxconn=128`, buffers pequeños | `somaxconn=65535`, buffers de 16MB | Hasta 5x más requests/segundo |
| **Base de datos con mucha E/S** | `noatime` desactivado, deadline scheduler | `noatime`, `none` scheduler, `vm.dirty_ratio` ajustado | 20-40% menos latencia de escritura |
| **Escritorio con 16GB RAM** | `swappiness=60` (usa swap antes de tiempo) | `swappiness=10` (solo swap si es necesario) | Menos latencia, swap apenas usado |
| **Servidor de archivos con muchos usuarios** | `file-max=100000`, `inotify` watch limit bajo | `file-max=200000`, `max_user_watches=524288` | Evita errores "too many open files" |
| **Compilación de código grande** | Sin tuning de CPU governor | `performance` governor, `nice` ajustado | Compilación 10-30% más rápida |

---

## 1. Ciclo de diagnóstico: medir primero, ajustar después

Antes de cambiar cualquier parámetro, hay que **medir qué está pasando**. Sin datos, los cambios son aleatorios.

### 1.1 Vista general: ¿dónde está el cuello de botella?

```bash
# ── CPU ──
top -bn1 | head -20              # uso de CPU por proceso
htop / btop                      # monitor interactivo más rico
mpstat -P ALL 1                  # uso por núcleo (instalar sysstat)
perf top                         # funciones que más CPU consumen

# ── Memoria ──
free -h                          # RAM usada/libre/swap
vmstat 1 5                       # memoria, swap, E/S, CPU
cat /proc/meminfo                # detalle de memoria

# ── E/S de disco ──
iostat -x 1                      # I/O detallado por disco (sysstat)
iotop                            # I/O por proceso (sudo)
dstat -d                         # lectura/escritura por segundo

# ── Red ──
nethogs                          # tráfico de red por proceso (sudo)
iftop                            # tráfico por conexión (sudo)
ss -s                            # estadísticas de sockets
sar -n DEV 1                     # tráfico de red histórico (sysstat)

# ── Sistema general ──
dstat -c -d -n -m                # CPU, disco, red, memoria combinados
sar -A                           # reporte completo de actividad
uptime                           # load average (1, 5, 15 min)
```

### 1.2 Interpretación rápida de métricas

| Recurso | Señal de alerta | Qué hacer |
|---|---|---|
| **CPU** | `idle < 20%`, `load average > núcleos` | Identificar proceso con `top`. ¿Es esperable? ¿Necesita más núcleos o hay un proceso rogue? |
| **Memoria** | `free` cerca de 0, `swap` > 0 estable | Aumentar RAM, o ajustar swappiness. Verificar fugas con `ps aux --sort=-%mem` |
| **E/S disco** | `iostat %util > 80%`, `await > 50ms` | Cambiar scheduler, montar con `noatime`, mover datos a SSD, aumentar caché |
| **Red** | `sar` muestra drops/errors, `ss` con colas largas | Aumentar buffers, `somaxconn`, `tcp_rmem`/`tcp_wmem`. Verificar NIC offloading |
| **Swap** | Uso constante de swap con RAM libre | Reducir `vm.swappiness` |
| **Context switches** | `vmstat` muestra > 50k/s | Demasiados procesos/hilos compitiendo. Revisar con `pidstat -w` |

---

## 2. Tuning del kernel (sysctl)

Los parámetros del kernel se ajustan con `sysctl`. Ver [[sysctl]] para la referencia completa de comandos y opciones.

> **⚠️ Regla de oro**: probar cada cambio en caliente (`sudo sysctl -w clave=valor`) antes de hacerlo permanente. Si el sistema se comporta mal, un reinicio restaura los valores por defecto.

### 2.1 Memoria virtual

```bash
# /etc/sysctl.d/99-memoria.conf

# swappiness: cuándo usar swap (0-100)
# 10 → servidores/escritorio con SSD + RAM suficiente
# 60 → default (neutral)
# 100 → usar swap agresivamente (útil en equipos con poca RAM)
vm.swappiness = 10

# dirty_ratio: % de RAM que puede estar sucia antes de forzar escritura
# 20 → default
# 30 → más datos en caché antes de escribir (mejor throughput, peor latencia si hay corte)
# 10 → escribir más seguido (mejor para batería, peor rendimiento)
vm.dirty_ratio = 20
vm.dirty_background_ratio = 10

# vfs_cache_pressure: 50 = conservar caché, 100 = neutral, 200 = liberar agresivo
vm.vfs_cache_pressure = 50

# overcommit: política de asignación de memoria
# 0 → heurística (default), 1 → siempre asignar, 2 → no exceder swap + RAM*ratio
vm.overcommit_memory = 0

# Min Free Kilobytes: memoria reservada para procesos del sistema
# Aumentar en servidores con mucha RAM: 1GB = ~50000, 16GB = ~100000
# Útil para que servicios críticos (sshd) tengan memoria incluso bajo presión
vm.min_free_kbytes = 65536
```

### 2.2 Red

```bash
# /etc/sysctl.d/99-red.conf

# Cola de conexiones entrantes (servidores web: subir de 128 a 65535)
net.core.somaxconn = 65535

# Buffers de red
net.core.rmem_max = 16777216              # 16 MB
net.core.wmem_max = 16777216              # 16 MB
net.ipv4.tcp_rmem = 4096 131072 16777216  # min, default, max
net.ipv4.tcp_wmem = 4096 65536 16777216

# TCP Fast Open (reduce latencia en nuevas conexiones)
net.ipv4.tcp_fastopen = 3

# Reducir TIME_WAIT
net.ipv4.tcp_fin_timeout = 15

# Rango de puertos efímeros (útil para clientes con muchas conexiones salientes)
net.ipv4.ip_local_port_range = 1024 65535

# Seguridad (protección SYN flood, IP spoofing)
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
```

### 2.3 Sistema de archivos

```bash
# /etc/sysctl.d/99-fs.conf

# Máximo de archivos abiertos global
fs.file-max = 200000

# Inotify (útil para editores, IDEs, Dropbox, monitoreo)
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512

# PID máximo (útil en servidores con muchos procesos)
kernel.pid_max = 131072
```

> Para todos los parámetros sysctl en detalle (seguridad de red, debugging, módulos), ver [[sysctl]].

---

## 3. Límites de recursos del sistema (ulimit)

Además de los límites globales del kernel (sysctl), cada **proceso y usuario** tiene límites individuales que se configuran en `/etc/security/limits.conf` y con el comando `ulimit`.

### 3.1 Ver límites actuales

```bash
# Límites del shell actual
ulimit -a                        # todos los límites
# -n → archivos abiertos (open files)
# -u → procesos (max user processes)
# -s → stack size
# -d → data segment
ulimit -Sn                       # soft limit (puede aumentarlo el usuario)
ulimit -Hn                       # hard limit (solo root puede cambiarlo)
```

### 3.2 Configuración persistente

```bash
# /etc/security/limits.conf
# Formato: <dominio> <tipo> <recurso> <valor>

# ── Usuario específico ──
carlos          soft    nofile          1048576    # archivos abiertos (soft)
carlos          hard    nofile          1048576    # archivos abiertos (hard)
carlos          soft    nproc           65536      # procesos
carlos          hard    nproc           65536

# ── Grupo específico (usar @) ──
@www-data       soft    nofile          65536
@www-data       hard    nofile          65536

# ── Todos los usuarios (*) ──
*               soft    nofile          65536
*               hard    nofile          65536
*               soft    stack           8192       # 8 MB de stack
*               hard    stack           16384      # 16 MB
```

```bash
# Cargar la configuración (requiere reinicio de sesión)
# O para services systemd, añadir en el unit:
# [Service]
# LimitNOFILE=1048576
# LimitNPROC=65536
# LimitSTACK=16M
```

### 3.3 Límites recomendados por perfil

| Perfil | `nofile` | `nproc` | `stack` | Notas |
|---|---|---|---|---|
| **Escritorio normal** | 4096 | 4096 | 8M | Default suele bastar |
| **Desarrollador** | 1048576 | 65536 | 16M | IDEs, compiladores, hot-reload abren muchos archivos |
| **Servidor web (nginx/apache)** | 65536 | 65536 | 8M | Muchas conexiones simultáneas |
| **Base de datos (PostgreSQL)** | 1048576 | 65536 | 16M | PostgreSQL recomienda al menos 4096 nofile |
| **Servidor de archivos (Samba/NFS)** | 65536 | 65536 | 8M | Muchas conexiones de archivos abiertos |

### 3.4 systemd y límites por servicio

Los servicios gestionados por systemd tienen su propia configuración de límites:

```bash
# Ver límites actuales de un servicio
systemctl show nginx -p LimitNOFILE -p LimitNPROC

# Ajustar límites de un servicio
sudo systemctl edit nginx
# Añadir:
# [Service]
# LimitNOFILE=65536
# LimitNPROC=65536
# LimitSTACK=16M

# Recargar y reiniciar
sudo systemctl daemon-reload
sudo systemctl restart nginx

# Verificar que se aplicaron
cat /proc/$(systemctl show -p MainPID nginx | cut -d= -f2)/limits | head -10
```
---

## 4. CPU: governors, procesos y prioridades

### 4.1 CPU Frequency Scaling (governors)

Los CPUs modernos ajustan su frecuencia dinámicamente. El governor controla esta política:

```bash
# Ver governor actual
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# powersave → frecuencia mínima (ahorro energía, laptop)
# ondemand  → sube frecuencia bajo demanda (buen balance)
# conservative → similar a ondemand pero cambios más graduales
# performance → frecuencia máxima (mejor rendimiento, más consumo)
# schedutil → governor basado en scheduler (kernel 5+, recomendado moderno)

# Cambiar governor temporalmente
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Cambiar permanentemente (con systemd)
sudo tee /etc/systemd/system/cpufreq.service << 'EOF'
[Unit]
Description=Set CPU governor to performance
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/cpupower frequency-set -g performance

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable --now cpufreq

# Instalar cpupower si no está
sudo apt install linux-cpupower          # Debian/Ubuntu
sudo pacman -S cpupower                  # Arch
sudo dnf install kernel-tools            # Fedora
```

### 4.2 nice y renice — prioridad de procesos

```bash
# Ver nice de procesos
ps -eo pid,comm,nice,pri | sort -n -k3

# Ejecutar con prioridad baja (nice +19 = mínima prioridad)
nice -n 19 ./script_lento.sh

# Ejecutar con prioridad alta (nice -20 = máxima, requiere sudo)
sudo nice -n --20 ./proceso_critico.sh

# Cambiar prioridad de un proceso en ejecución
renice -n 10 -p 1234                    # bajar prioridad de PID 1234
sudo renice -n -5 -p 5678               # subir prioridad de PID 5678
sudo renice -n -10 -u www-data          # subir prioridad a todos los procesos de www-data

# ionice — prioridad de E/S de disco (independiente de nice)
ionice -c 2 -n 7 -p 1234                # clase best-effort, prioridad baja
ionice -c 1 -n 0 ./importante.sh        # clase real-time (cuidado: puede saturar disco)
ionice -c 3 ./copia_seguridad.sh        # clase idle (solo cuando el disco está desocupado)
```

### 4.3 Aislamiento de CPUs (isolcpus)

En sistemas con carga crítica (bases de datos, audio en tiempo real, gaming), se pueden **aislar núcleos** dedicados para procesos específicos:

```bash
# En /etc/default/grub (o donde se configuren kernel params):
# GRUB_CMDLINE_LINUX_DEFAULT="isolcpus=2,3 nohz_full=2,3 rcu_nocbs=2,3"
# Esto aísla los núcleos 2 y 3: el scheduler no pondrá procesos normales allí
# Luego puedes asignar procesos manualmente:
taskset -c 2,3 ./proceso_dedicado.sh

# Ver afinidad actual de un proceso
taskset -p 1234

# Después de añadir, ejecutar:
sudo update-grub
sudo reboot
```

---

## 5. E/S de disco: I/O schedulers y opciones de montaje

### 5.1 I/O Scheduler

El scheduler decide **el orden** en que se escriben/leen los datos del disco:

```bash
# Ver scheduler actual por disco
cat /sys/block/sda/queue/scheduler
# [mq-deadline] none  (entre corchetes el activo)

# Schedulers disponibles:
# none (NVMe) → sin reordenación (los SSDs NVMe gestionan su propia cola internamente)
# mq-deadline → intenta garantizar latencia máxima (buen balance, default en muchos kernels)
# kyber → optimizado para latencia baja (bueno para servidores)
# bfq  → fairness entre procesos (buen balance para escritorio)

# Cambiar temporalmente
echo kyber | sudo tee /sys/block/sda/queue/scheduler

# Cambiar permanentemente (udev rule)
sudo tee /etc/udev/rules.d/60-ioscheduler.rules << 'EOF'
# NVMe → none (no reordenar)
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
# SSD SATA → mq-deadline o kyber
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
# HDD → bfq (mejor fairness entre procesos)
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
EOF
```

### 5.2 Opciones de montaje para rendimiento

```bash
# /etc/fstab — opciones que afectan rendimiento:

# noatime: no actualizar el timestamp de acceso al leer (GRAN mejora)
# relatime: actualizar atime solo si es anterior a mtime/ctime (buen balance)
UUID=xxx / ext4 defaults,noatime 0 1

# SSD: forzar discard (TRIM) periódico en vez de montaje continuo
# (mount -o discard puede degradar rendimiento en algunos SSDs)
# Mejor: systemd-fstrim.service semanal (activado por defecto en la mayoría de distros)
UUID=xxx / ext4 defaults,noatime 0 1

# Para servidores de bases de datos: barrier / nobarrier (seguridad vs rendimiento)
# barrier=1 (default, seguro), barrier=0 (más rápido, riesgo de corrupción si hay corte)
UUID=xxx / ext4 defaults,noatime,barrier=1 0 1

# Tamaño de bloque (debe coincidir con el del disco al formatear)
# mkfs.ext4 -b 4096 /dev/sda1  → 4KB blocks (default, buen balance)
# mkfs.ext4 -b 1024 /dev/sda1  → 1KB (menor desperdicio, peor rendimiento)
```

### 5.3 zram / zswap

Compresión de RAM para reducir uso de swap sin necesidad de disco:

```bash
# Ver si zram está activo
zramctl

# Activar zram (1 GB de RAM comprimida como swap)
sudo modprobe zram
echo 1G | sudo tee /sys/block/zram0/disksize
sudo mkswap /dev/zram0
sudo swapon -p 100 /dev/zram0            # prioridad 100 (más alta que swap de disco)
```

Ver [[zram]] para configuración detallada.

---

## 6. Tuning por perfil de uso

### 🖥 Escritorio / Uso general

```bash
# Objetivo: menor latencia, interfaz fluida
sysctl -w vm.swappiness=10               # no usar swap innecesariamente
sysctl -w vm.vfs_cache_pressure=50        # conservar caché de FS
cpupower frequency-set -g schedutil       # governor responsive
echo bfq | sudo tee /sys/block/sda/queue/scheduler   # fairness para discos
```

### 🌐 Servidor web (nginx, apache)

```bash
# Objetivo: alta concurrencia, baja latencia de conexión
sysctl -w net.core.somaxconn=65535
sysctl -w net.ipv4.tcp_fastopen=3
sysctl -w net.ipv4.tcp_fin_timeout=15
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216

# Límites en /etc/security/limits.conf:
# www-data  soft  nofile  65536
# www-data  hard  nofile  65536

# En el unit de nginx:
# [Service]
# LimitNOFILE=65536
```

### 🗄️ Base de datos (PostgreSQL, MySQL)

```bash
# Objetivo: E/S eficiente, buffering adecuado
sysctl -w vm.swappiness=1                # casi nada de swap
sysctl -w vm.dirty_ratio=10              # escritura temprana
sysctl -w vm.dirty_background_ratio=5
sysctl -w vm.vfs_cache_pressure=200      # liberar caché de FS agresivo

# Aislamiento de CPU (con isolcpus en kernel params)
# taskset -c 0,1 postgres               # dedicar núcleos 0,1 a postgres

# I/O scheduler: none (si NVMe) o mq-deadline
echo none | sudo tee /sys/block/nvme0n1/queue/scheduler

# Montaje: noatime para evitar escrituras extra
```

### 🔧 Compilación / Desarrollo

```bash
# Objetivo: máxima CPU y E/S
cpupower frequency-set -g performance     # frecuencia máxima fija
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# nice de compilación: prioridad normal, I/O mejorada
make -j$(nproc)                           # paralelo (núcleos disponibles)

# Caché de compilación (ccache)
sudo apt install ccache
# export CC="ccache gcc" → acelera recompilaciones
```

---

## 7. tuned — Perfiles de rendimiento automáticos

`tuned` es un servicio que aplica perfiles de rendimiento preconfigurados. Es la forma más rápida y segura de optimizar un sistema sin tocar sysctl manualmente.

```bash
# Instalación
sudo apt install tuned                    # Debian/Ubuntu
sudo pacman -S tuned                      # Arch
sudo dnf install tuned                    # Fedora/RHEL

# Ver perfil activo
tuned-adm active

# Listar perfiles disponibles
tuned-adm list

# Perfiles comunes:
# - throughput-performance  → máximo throughput (servidores, default en RHEL)
# - latency-performance     → baja latencia (BD, trading, audio)
# - virtual-guest           → para VMs invitadas
# - powersave               → ahorro de energía (laptops)
# - desktop                 → balance para escritorio
# - balanced                → perfil neutral (default en Fedora)

# Aplicar perfil
tuned-adm profile latency-performance

# Recomendar perfil automáticamente según hardware
tuned-adm recommend

# Ver recomendaciones de tuning aplicadas
tuned-adm off                              # desactivar (restaurar valores por defecto)
```

`tuned` ajusta automáticamente: CPU governors, I/O schedulers, swappiness, dirty_ratio, virtual memory, kernel scheduler, y más. Es la alternativa moderna a tocar sysctl a mano.

## 8. Transparent HugePages (THP)

Las **HugePages** permiten al kernel usar páginas de memoria más grandes (2MB en vez de 4KB), reduciendo la cantidad de entradas en la TLB y mejorando el rendimiento en cargas de trabajo con uso intensivo de memoria. Linux tiene dos modos:

| Modo | Descripción |
|---|---|
| **HugePages tradicionales** | Reserva estática de páginas grandes al arrancar. Requiere configuración manual |
| **Transparent HugePages (THP)** | El kernel asigna páginas grandes automáticamente. Activado por defecto en la mayoría de distros |

```bash
# Ver estado de THP
cat /sys/kernel/mm/transparent_hugepage/enabled
# always [madvise] never
# always → activado por defecto
tal modo

# Ver qué procesos usan HugePages
cat /proc/meminfo | grep -i huge
# AnonHugePages:    204800 kB    → páginas THP en uso
# HugePages_Total:  0
# HugePages_Free:   0
```

### ⚠️ Bases de datos y THP

**PostgreSQL, MongoDB y MySQL recomiendan deshabilitar THP** (pero no las HugePages tradicionales). THP puede causar fragmentación de memoria y latencia impredecible en bases de datos.

```bash
# Deshabilitar THP temporalmente
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled

# Deshabilitar permanentemente
sudo tee /etc/systemd/system/disable-thp.service << 'EOF'
[Unit]
Description=Disable Transparent Huge Pages
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'
ExecStart=/bin/sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/defrag'
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable --now disable-thp
```

## 9. Herramientas de monitoreo continuo

```bash
# Serie temporal (sysstat — el estándar)
sudo apt install sysstat                  # sar, iostat, mpstat, pidstat
sudo systemctl enable --now sysstat       # recolectar datos cada 10 min
sar -u -b -n DEV -r                       # reporte de CPU, E/S, red, RAM

# Monitorización interactiva
htop / btop                               # proceso + CPU + memoria + carga
nmon                                      # monitor completo (IBM)
glances                                   # todo en uno (Python)

# E/S de disco por proceso
iotop -oP                                 # solo procesos con E/S activa

# Red por proceso
nethogs                                   # tráfico por proceso
iftop                                     # tráfico por conexión

# Análisis de rendimiento con perf
perf record -F 99 -g -- sleep 30          # muestrear 30s
perf report                               # analizar (ver [[perf]])
```

---

## 8. Troubleshooting

| Problema | Causa probable | Solución |
|---|---|---|
| **Sistema lento sin proceso acaparando CPU** | I/O wait alto: disco es el cuello de botella | `iostat -x 1` para confirmar. Mover a SSD, ajustar scheduler, `noatime` |
| **Mucho swap usado con RAM libre** | `vm.swappiness` muy alto (default 60) | Reducir a 10: `sudo sysctl -w vm.swappiness=10` |
| **"Too many open files"** | Límite de `nofile` alcanzado | Aumentar con `ulimit -n 1048576` y en `limits.conf` + systemd unit |
| **"Too many open files (inotify)"** | `max_user_watches` alcanzado | `sudo sysctl -w fs.inotify.max_user_watches=524288` |
| **Servidor web lento con muchas conexiones** | `somaxconn` muy bajo (128) | `sudo sysctl -w net.core.somaxconn=65535` |
| **Compilación lenta** | CPU governor en powersave | Cambiar a performance: `cpupower frequency-set -g performance` |
| **Sistema se congela con mucha E/S** | I/O scheduler incorrecto | Cambiar a `kyber` (NVMe) o `bfq` (HDD) |
| **Portátil se calienta / batería dura poco** | CPU siempre en performance | Cambiar a `powersave` o `schedutil` |
| **strace dice "Resource temporarily unavailable"** | Demasiados hilos/procesos | Aumentar `kernel.pid_max` y `ulimit -u` |
| **sysctl --system no carga mi archivo** | El archivo no termina en `.conf` | Renombrar a `*.conf` |

---

## Relación con otros conceptos

- [[sysctl]] — referencia completa de parámetros del kernel
- [[cgroups (control de recursos)]] — limitar CPU, RAM, E/S por proceso/grupo
- [[perf]] — profiling de rendimiento (flamegraphs, callchains, contadores CPU)
- [[Procesos y Senales]] — nice, renice, prioridad de procesos
- [[Proc y Sys]] — sistemas de archivos virtuales (/proc, /sys)
- [[htop btop]] — monitorización interactiva del sistema
- [[top]] — monitorización clásica de procesos
- [[watch]] — monitorear cambios en tiempo real
- [[zram]] — compresión de RAM para swap
- [[Logging del sistema (rsyslog journald logrotate)]] — gestión de logs
- [[Monitorización (Prometheus node_exporter)]] — métricas para servidores
- [[Entorno de desarrollo Linux]] — optimización de entorno de desarrollo

## Enlaces externos

- [Arch Wiki — Performance tuning](https://wiki.archlinux.org/title/Performance_tuning)
- [Arch Wiki — Improving performance](https://wiki.archlinux.org/title/Improving_performance)
- [Arch Wiki — sysctl](https://wiki.archlinux.org/title/Sysctl)
- [Red Hat — Performance tuning guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/performance_tuning_guide/)
- [Ubuntu — Kernel optimization](https://wiki.ubuntu.com/Kernel/Optimization)
- [Brendan Gregg — Linux Performance](https://www.brendangregg.com/linuxperf.html) — referencia definitiva de perf/observabilidad
- [Linux Foundation — sysctl reference](https://sysctl-explorer.net/)
- [Kernel.org — scaling_governor documentation](https://www.kernel.org/doc/html/latest/admin-guide/pm/cpufreq.html)

#concepto #rendimiento #kernel
