---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: alta
---

# cgroups — Control de recursos

## Definición

cgroups (control groups) es una funcionalidad del kernel Linux que permite **limitar, contabilizar y aislar** el uso de recursos (CPU, memoria, E/S de disco, red) para grupos de procesos. Es la base técnica de los contenedores (Docker, Podman, LXC), systemd (cada servicio tiene su propio cgroup), y herramientas de monitorización.

```
cgroups v2 — jerarquía unificada (Linux 4.5+, default en distros modernas):

  /sys/fs/cgroup/
  ├── system.slice/               ← servicios del sistema
  │   ├── sshd.service/           ← cgroup del servicio SSH
  │   │   ├── cpu.max             ← límite de CPU
  │   │   ├── memory.max          ← límite de RAM
  │   │   ├── memory.current      ← RAM usada actualmente
  │   │   ├── pids.max            ← máximo de procesos
  │   │   └── ...
  │   ├── nginx.service/
  │   └── postgresql.service/
  ├── user.slice/                 ← sesiones de usuario
  │   └── user-1000.slice/
  ├── machine.slice/              ← contenedores (Docker, nspawn)
  └── cgroup.controllers          ← controladores disponibles
```

---

## cgroups v1 vs v2

| Característica | cgroups v1 | cgroups v2 (moderno) |
|---|---|---|
| **Jerarquía** | Múltiples jerarquías (una por recurso) | Jerarquía única unificada |
| **CPU** | `cpu,cpuacct/` | `cpu.max`, `cpu.weight` |
| **Memoria** | `memory/` | `memory.max`, `memory.current` |
| **E/S** | `blkio/` | `io.max`, `io.weight` |
| **Procesos** | `pids/` (a veces separado) | `pids.max` |
| **Migrar procesos** | Manual entre jerarquías complicado | Automático con systemd |
| **Default desde** | Kernel 2.6.24 (2007) | Kernel 4.5+ (usado por Fedora, Ubuntu 22.04+, Arch, Debian 12+) |

```bash
# Ver qué versión de cgroups usa tu sistema
stat -fc %T /sys/fs/cgroup/
# cgroup2fs → v2
# tmpfs → v1

# O con grep:
grep cgroup /proc/filesystems
# cgroup2  → v2
# cgroup   → v1
```

---

## Controladores disponibles

```bash
# Ver qué controladores (subsistemas) están activos
cat /sys/fs/cgroup/cgroup.controllers
# cpuset cpu io memory hugetlb pids rdma misc

# Controladores principales:
#   cpu     → límite de CPU (peso, máximo)
#   memory  → límite de RAM, swap, OOM killer
#   io      → límite de E/S de disco (peso, máximo)
#   pids    → límite de procesos/hilos
#   cpuset  → asignación a núcleos específicos
#   hugetlb → páginas enormes (HugeTLB)
#   rdma    → acceso RDMA
```

---

## systemd — Control de recursos por servicio

systemd gestiona cgroups automáticamente: cada servicio `.service`, cada usuario (`user.slice`) y cada contenedor (`machine.slice`) tiene su propio cgroup.

### Límites en unit files

```bash
# /etc/systemd/system/mi-servicio.service
[Service]
# ── CPU ──
CPUWeight=200                            # peso relativo (100 = default, 200 = doble prioridad)
CPUQuota=50%                             # máximo 50% de un núcleo
CPUQuotaPeriodSec=100ms                  # período de la cuota (systemd v243+)

# ── Memoria ──
MemoryMax=512M                           # máximo absoluto (si se excede → OOM kill)
MemoryHigh=384M                          # límite blando (empieza a relentizar antes de OOM)
MemorySwapMax=128M                       # máximo de swap

# ── E/S de disco ──
IOWeight=200                             # peso relativo (100 = default)
IOReadBandwidthMax=/dev/sda 50M          # límite de lectura
IOWriteBandwidthMax=/dev/sda 20M         # límite de escritura

# ── Procesos ──
TasksMax=100                             # máximo de procesos/tareas del servicio

# ── CPU set (núcleos específicos) ──
AllowedCPUs=0-3                          # solo núcleos 0 a 3
AllowedMemoryNodes=0                     # solo nodo NUMA 0
```

### Comandos para ver/ajustar límites en caliente

```bash
# Ver límites de un servicio
systemctl show nginx -p CPUWeight -p MemoryMax -p TasksMax
# CPUWeight=100
# MemoryMax=infinity
# TasksMax=488

# Ver cgroup actual de un servicio
systemd-cgls                               # árbol de cgroups
systemd-cgls --unit nginx.service          # solo un servicio

# Ver consumo de recursos por servicio (como top pero por cgroup)
systemd-cgtop                              # top por unidad systemd

# Presionar Ctrl+C para salir de systemd-cgtop
```

### systemd-cgtop — monitorización en tiempo real

```bash
# Equivalente a top pero agrupado por servicio
systemd-cgtop
# Control Group                            Tasks   %CPU   Memory  Input/s Output/s
# /system.slice/nginx.service              4       2.3    45.3M   0B      0B
# /system.slice/postgresql.service         12      15.1   1.2G    0B      123K/s
# /system.slice/sshd.service               2       0.0    3.2M    0B      0B
# /user.slice/user-1000.slice              20      4.2    2.1G    0B      0B
```

---

## Uso directo de cgroups v2 (sin systemd)

Puedes crear y gestionar cgroups directamente en `/sys/fs/cgroup/`. Útil para contenedores o scripts.

### Crear un grupo y limitar recursos

```bash
# 1. Crear grupo (mkdir = crear cgroup)
sudo mkdir /sys/fs/cgroup/mi-grupo

# 2. Ver controladores disponibles (heredados del padre)
cat /sys/fs/cgroup/mi-grupo/cgroup.controllers

# 3. Habilitar los controladores que necesites
# (por defecto heredan los del padre si están en cgroup.subtree_control)

# 4. Establecer límites
echo "5000000" | sudo tee /sys/fs/cgroup/mi-grupo/memory.max          # 5 MB de RAM
echo "50000000" | sudo tee /sys/fs/cgroup/mi-grupo/memory.swap.max    # 50 MB swap (requiere swap activo: swapon --show)
echo "50" | sudo tee /sys/fs/cgroup/mi-grupo/cpu.weight               # peso bajo

# 5. Asignar procesos al grupo
echo $$ | sudo tee /sys/fs/cgroup/mi-grupo/cgroup.procs               # el shell actual en el cgroup
echo 1234 | sudo tee /sys/fs/cgroup/mi-grupo/cgroup.procs             # proceso PID 1234

# 6. Ver consumo
cat /sys/fs/cgroup/mi-grupo/memory.current
cat /sys/fs/cgroup/mi-grupo/memory.stat

# 7. Eliminar grupo (debe estar vacío, sin procesos)
sudo rmdir /sys/fs/cgroup/mi-grupo

# Avanzado: cgroup.threads permite migrar hilos individuales
# (cgroup.procs migra grupos completos de hilos)
# echo <tid> | sudo tee /sys/fs/cgroup/mi-grupo/cgroup.threads
```

### Límites de CPU en cgroups v2

```bash
# cpu.max: tiempo máximo de CPU en un período
# Formato: <quota-en-us> <periodo-en-us>
# "50000 100000" = 50ms de CPU cada 100ms = 50% de un núcleo
# "200000 100000" = 200ms de CPU cada 100ms = 2 núcleos completos
# "max 100000"    = sin límite

echo "50000 100000" | sudo tee /sys/fs/cgroup/mi-grupo/cpu.max

# cpu.weight: peso relativo (1-10000, default 100)
# Si hay 3 grupos con weight 100, 200, 300 compitiendo:
#   grupo1 → 100/(100+200+300) = 16.7% de CPU
#   grupo2 → 200/(100+200+300) = 33.3%
#   grupo3 → 300/(100+200+300) = 50%
echo "200" | sudo tee /sys/fs/cgroup/mi-grupo/cpu.weight
```

### Límites de E/S en cgroups v2

```bash
# io.max: límite absoluto de E/S
# Formato: <device-id> <tipo> <bytes|iops>
echo "8:0 rbps=52428800 wbps=20971520" | sudo tee /sys/fs/cgroup/mi-grupo/io.max
# 8:0 → major:minor de /dev/sda (ver con ls -l /dev/sda)
# rbps  → bytes/s de lectura (50 MB/s)
# wbps  → bytes/s de escritura (20 MB/s)
# riops → IOPS de lectura
# wiops → IOPS de escritura

# io.weight: peso relativo de E/S (1-10000, default 100)
echo "200" | sudo tee /sys/fs/cgroup/mi-grupo/io.weight
```

### Límite de procesos (pids)

```bash
# pids.max: máximo de procesos/tareas en el cgroup
echo "50" | sudo tee /sys/fs/cgroup/mi-grupo/pids.max
cat /sys/fs/cgroup/mi-grupo/pids.current                  # procesos actuales
```

---

## cgroups y contenedores

Docker, Podman y systemd-nspawn usan cgroups para aislar contenedores:

```bash
# Ver cgroups de contenedores Docker
systemd-cgls --unit docker.service

# O directamente:
ls /sys/fs/cgroup/system.slice/docker-<container-id>.scope/

# Limitar recursos al ejecutar un contenedor
docker run -d --name web \
  --memory="512m" \                       # memory.max
  --cpus="0.5" \                          # cpu.max = 50000 100000
  --pids-limit=100 \                      # pids.max
  --device-write-bps=/dev/sda:30mb \      # io.max wbps
  nginx

# Con Podman (similar)
podman run -d --memory="512m" --cpus="0.5" nginx
```

---

## OOM Killer y memory pressure

Cuando un proceso excede `memory.max`, el kernel activa el **OOM Killer** (Out-Of-Memory Killer) que mata procesos para liberar memoria.

```bash
# Ver ajustes OOM de un servicio
systemctl show nginx -p ManagedOOMSwap
# ManagedOOMSwap=kill                    # matar proceso si excede swap
# ManagedOOMMemoryPressure= kill         # matar si hay presión de memoria

# Ver estadísticas de presión de memoria (memory pressure)
cat /sys/fs/cgroup/mi-grupo/memory.pressure
# some avg10=0.00 avg60=0.00 avg300=2.32 total=123456
# full avg10=0.00 avg60=0.00 avg300=0.00 total=7890
# some = algún proceso está esperando por memoria
# full = todos los procesos están esperando

# Configurar OOM en systemd unit:
[Service]
ManagedOOMSwap=kill                      # matar si usa demasiado swap
ManagedOOMMemoryPressure=kill            # matar si hay presión de memoria
ManagedOOMMemoryPressureLimit=50%        # umbral de presión (%)
```

---

## Buenas prácticas

- **Usar systemd para límites**: en lugar de manipular `/sys/fs/cgroup/` directamente, define límites en los unit files de systemd (CPUQuota, MemoryMax, TasksMax). Es más limpio y persistente.
- **Monitorizar con systemd-cgtop**: es más útil que `top` para ver qué servicio está consumiendo recursos, pues agrupa por unidad systemd.
- **No mezclar cgroups v1 y v2**: si migras a v2, asegúrate de que Docker/Podman estén actualizados para soportar cgroups v2. Docker 20.10+ y Podman 3.0+ lo soportan.
- **memory.high vs memory.max**: `memory.high` es un límite blando (el proceso se relentiza pero no se mata). `memory.max` es duro (OOM kill si se excede).
- **IOWeight vs IOMax**: `IOWeight` es relativo (peso entre grupos que compiten). `IOMax` es absoluto (nunca pasará de X bytes/s).

## Ver también

- [[systemd]] — systemd gestiona cgroups automáticamente
- [[Contenedores]] — Docker, Podman usan cgroups para aislamiento
- [[Procesos y Senales]] — procesos dentro de cgroups, señales, OOM
- [[Proc y Sys]] — /proc/self/cgroup, /sys/fs/cgroup/
- [[Monitorización (Prometheus node_exporter)]] — node_exporter expone métricas de cgroups
- [[Virtualización (KVM QEMU libvirt)]] — comparación cgroups vs virtualización completa

## Enlaces externos

- [Wikipedia — cgroups](https://en.wikipedia.org/wiki/Cgroups)
- [Arch Wiki — cgroups](https://wiki.archlinux.org/title/Cgroups)
- [Red Hat — Resource management with cgroups](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_monitoring_and_updating_the_kernel/using-cgroups-v2-to-control-distribution-of-cpu-time-for-applications_managing-monitoring-and-updating-the-kernel)

#sistema
