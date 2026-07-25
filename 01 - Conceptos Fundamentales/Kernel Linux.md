---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: alta
---

# Kernel Linux

## Definición

El **kernel Linux** es el núcleo del sistema operativo: gestiona procesos, memoria, dispositivos, sistemas de archivos y redes. Creado por Linus Torvalds en 1991, es el proyecto de código abierto más grande del mundo. No debe confundirse con **GNU/Linux** — el kernel es solo una parte del sistema operativo completo (ver [[GNU y Linux]]).

## Versiones del kernel

### Esquema de versionado

```
Histórico (pre-5.0):  major.minor.patch    ej: 4.19.280
Moderno (5.0+):      major.minor.patch     ej: 6.8.12

major = versión principal (6.x)
minor = funcionalidades nuevas (6.8.x)
patch = parches de seguridad/correcciones (6.8.12)
```

### Ramas del kernel

| Rama | Descripción | Quién la usa | Soporte |
|---|---|---|---|
| **mainline** | Versión en desarrollo activo de Linus | Desarrolladores, entusiastas | ~2 meses hasta la siguiente |
| **stable** | Mainline considerado estable, mantenido por Greg Kroah-Hartman | Mayoría de distros (Ubuntu, Fedora, Arch) | ~3-4 meses |
| **LTS** (Long Term Support) | Versiones mantenidas por años | Distros empresariales (Debian, RHEL, Ubuntu LTS) | **6+ años** (antes 2-3) |
| **linux-next** | Rama de integración para el próximo ciclo | Desarrolladores de kernel | Diario |

```bash
# Ver qué versión del kernel usas
uname -r                                # ej: 6.8.12-arch1-1
uname -v                                # fecha de compilación
cat /proc/version                       # información completa
```

### Versiones LTS activas (2026)

| Versión | Lanzamiento | Fin de soporte | Usada por |
|---|---|---|---|
| **6.12.x** | Dic 2025 | ~2030+ | Última LTS, recomendada |
| **6.6.x** | Oct 2023 | ~2029 | Ubuntu 24.04, Debian 13 |
| **6.1.x** | Dic 2022 | ~2028 | Varias distros enterprise |
| **5.15.x** | Oct 2021 | ~2027 | Ubuntu 22.04 LTS |
| **5.10.x** | Dic 2020 | ~2026 | Debian 11, RHEL 9 |
| **5.4.x** | Nov 2019 | ~2025 | Ubuntu 20.04 LTS |

> **Fuente**: https://www.kernel.org/category/releases.html

## Hitos en la historia del kernel

| Año | Versión | Cambio clave |
|---|---|---|
| **1991** | 0.01 | Primer lanzamiento público por Linus Torvalds |
| **1994** | 1.0 | Primer versión \"estable\", soporte de red |
| **1996** | 2.0 | Soporte SMP (múltiples CPUs), nuevo modelo de gestión de memoria |
| **2001** | 2.4 | Soporte USB, ext3, RAID software, IPv6 experimental |
| **2003** | 2.6 | Nuevo scheduler O(1), preemptible kernel, soporte NUMA, ALSA, udev |
| **2008** | 2.6.28 | Eliminado el antiguo scheduler O(1), reemplazado por CFS |
| **2011** | 3.0 | Versión por 20 aniversario (sin cambios revolucionarios) |
| **2015** | 4.0 | **No hay reinicio** después de aplicar parches del kernel (kpatch) |
| **2019** | 5.0 | Fin del versionado 4.x (por llegar a 4.20) |
| **2020** | 5.6 | **WireGuard** integrado al kernel |
| **2022** | 5.18 | Driver de NTFS escrito por Paragon (mejor integración con Windows) |
| **2022** | 6.0 | Nueva numeración mayor, Rust como lenguaje para drivers (experimental) |
| **2023** | 6.6 | Mejoras significativas en scheduler y soporte de Rust |
| **2024** | 6.8 | Mejoras en Btrfs y soporte de hardware más reciente |
| **2025** | 6.12 | LTS actual, soporte extendido |

> **Fuente**: https://kernel.org/ (historial completo)

## Arquitectura del kernel

```
                    ┌─────────────────────────────────────┐
                    │         System Calls (syscalls)      │
                    │  (open, read, write, fork, execve…)  │
                    └─────────────────────────────────────┘
                                   │
        ┌──────────────────────────┼──────────────────────────┐
        ▼                          ▼                          ▼
┌──────────────┐          ┌──────────────┐          ┌──────────────┐
│ Gestión de   │          │ Gestión de   │          │ Gestión de   │
│ Procesos     │          │ Memoria      │          │ Archivos     │
│ (scheduler,  │          │ (MMU, page   │          │ (VFS, ext4,  │
│  signals)    │          │  cache, OOM) │          │  Btrfs)      │
└──────────────┘          └──────────────┘          └──────────────┘
┌──────────────┐          ┌──────────────┐          ┌──────────────┐
│ Gestión de   │          │ Redes        │          │ Drivers      │
│ Dispositivos │          │ (Netfilter,  │          │ (módulos     │
│ (udev,       │          │  protocolos) │          │  .ko)        │
│  devtmpfs)   │          │              │          │              │
└──────────────┘          └──────────────┘          └──────────────┘
                                   │
                    ┌───────────────┴───────────────┐
                    ▼                               ▼
            ┌──────────────┐               ┌──────────────┐
            │  Módulos     │               │  Hardware    │
            │  (lsmod)     │               │  (CPU, RAM,  │
            │              │               │   discos)    │
            └──────────────┘               └──────────────┘
```

### Subsistemas principales

| Subsistema | Función | Archivos clave |
|---|---|---|
| **scheduler** (CFS/EEVDF) | Decide qué proceso se ejecuta y por cuánto tiempo | `kernel/sched/` |
| **MM** (Memory Manager) | Gestiona RAM, paginación, swapping, OOM killer | `mm/` |
| **VFS** (Virtual File System) | Capa de abstracción sobre sistemas de archivos | `fs/` |
| **Networking** | Pilas TCP/IP, Netfilter (firewall), sockets | `net/` |
| **Device Drivers** | Drivers de hardware (GPU, WiFi, NVMe, USB...) | `drivers/` (~70% del código) |
| **IPC** (Inter-Process Comm.) | Tuberías, señales, sockets Unix, memoria compartida | `ipc/` |

## Cómo ver el kernel que tienes

```bash
# Versión del kernel
uname -r                                # 6.8.12-arch1-1

# Fecha de compilación
uname -v                                # #1 SMP PREEMPT_DYNAMIC ...

# Arquitectura
uname -m                                # x86_64

# Todos los detalles del kernel
cat /proc/version
# Linux version 6.8.12-arch1-1 (linux@archlinux) (gcc (GCC) 14.1.1) #1 SMP PREEMPT_DYNAMIC

# Módulos cargados (relacionados con qué drivers usa el kernel)
lsmod | head -10

# Parámetros con los que arrancó el kernel
cat /proc/cmdline
# BOOT_IMAGE=/vmlinuz-linux root=UUID=... rw quiet
```

## Enlaces externos

- [kernel.org](https://www.kernel.org/) — sitio oficial, descargas y releases
- [Wikipedia: Linux kernel](https://en.wikipedia.org/wiki/Linux_kernel) — historia detallada
- [The Linux Kernel documentation](https://docs.kernel.org/) — documentación oficial
- [ELinux.org](https://elinux.org/) — kernel para sistemas embebidos

## Ver también

- [[GNU y Linux]] — diferencia entre el kernel GNU y el sistema completo
- [[Módulos del kernel (lsmod modprobe blacklist)]] — drivers y módulos cargables
- [[Compilacion desde Codigo Fuente]] — compilar tu propio kernel
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — cómo arranca el kernel
- [[Proc y Sys]] — interfaces /proc y /sys del kernel

#concepto #kernel
