---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: concepto
prioridad: media
---

# Historia de Linux

> Linux comienza en **1991** como un proyecto personal del estudiante finlandés **Linus Torvalds**: crear un núcleo de sistema operativo libre. Desde entonces, ha crecido de unos pocos archivos C a más de **33 millones de líneas de código**, ejecutándose en todo, desde relojes inteligentes hasta supercomputadoras.

## Antecedentes

### Unix (1969)

Unix fue creado por **Ken Thompson** y **Dennis Ritchie** en AT&T Bell Labs en 1969, reescrito en C en 1973. Su portabilidad y diseño modular lo hicieron enormemente influyente. AT&T licenciaba Unix, pero distribuía el código fuente a universidades, creando una cultura de estudio y modificación.

### BSD (1977)

El **Computer Systems Research Group** de UC Berkeley creó **BSD** (Berkeley Software Distribution) basado en Unix. BSD contenía código de AT&T, lo que llevó a una demanda (USL vs BSDi) a principios de los 90 que limitó su adopción.

### GNU (1983)

**Richard Stallman** inició el proyecto **GNU** (GNU's Not Unix) en 1983 para crear un sistema operativo completamente libre. Para 1991, GNU tenía casi todo listo — compilador (GCC), shell (Bash), utilidades — excepto el **kernel** (Hurd, que aún hoy no está listo para producción).

### MINIX (1987)

**Andrew Tanenbaum** creó **MINIX** como sistema educativo para su libro "Operating Systems: Design and Implementation". Aunque el código fuente estaba disponible, la licencia restringía la redistribución y modificación. Además, MINIX estaba diseñado para hardware de 16 bits, no para el nuevo Intel 386 de 32 bits.

## La creación (1991)

En 1991, Linus Torvalds era un estudiante de 21 años en la Universidad de Helsinki. Quería usar las capacidades del **Intel 80386** (modo protegido de 32 bits, paginación de memoria) desde su nueva PC. Compró un 386 y comenzó a escribir un kernel como pasatiempo.

**3 julio 1991**: Torvalds pide documentación POSIX en comp.os.minix.

**25 agosto 1991**: El anuncio histórico en comp.os.minix:

> Hello everybody out there using minix -
>
> I'm doing a (free) operating system (just a hobby, won't be big and professional like gnu) for 386(486) AT clones. This has been brewing since april, and is starting to get ready.
>
> — Linus Torvalds

**Septiembre 1991**: Linux 0.01 se publica en el servidor FTP de FUNET. Ari Lemmke (administrador) nombra el directorio "Linux" en lugar de "Freax" (el nombre original que quería Torvalds).

## Crecimiento inicial (1992-1994)

| Año | Hito |
|---|---|
| **1992** | Linux relicenciado bajo **GNU GPL** (antes tenía licencia propia restrictiva) |
| **1992** | **Debate Tanenbaum–Torvalds** sobre micronúcleos vs monolíticos |
| **1992** | Orest Zborowski porta **X11** a Linux (nace el Linux gráfico) |
| **1993** | Nace **Debian** (Ian Murdock) |
| **1993** | **Slackware** se convierte en la primera distro popular |
| **1994** | **Linux 1.0** (176,250 líneas de código) |
| **1994** | Nace Red Hat Linux |

## Linux 2.x Era (1996-2003)

| Versión kernel | Año | Novedades |
|---|---|---|
| **2.0** | 1996 | SMP (múltiples CPUs), soporte de arquitecturas múltiples |
| **2.2** | 1999 | Mejoras en SMP, redes, sistemas de archivos |
| **2.4** | 2001 | USB, RAID, ext3, NPTL |
| **2.6** | 2003 | Kernel preemptible, futex, sysfs, ALSA, nuevas arquitecturas |

### Distribuciones nacidas en esta era

- **1995**: Red Hat Linux, SUSE (independiente)
- **1997**: Fedora (como proyecto, no como distro)
- **2002**: **Gentoo**, **Arch Linux**
- **2004**: **Ubuntu** (Mark Shuttleworth), **Linux Mint** (2006)

## Linux 3.x y la era moderna (2011-presente)

| Versión | Año | Novedades |
|---|---|---|
| **3.0** | 2011 | Renombrado por 20 aniversario (sin cambios mayores) |
| **3.1-3.19** | 2011-2015 | Cgroups v2, Btrfs maduro, soporte ARM masivo |
| **4.0** | 2015 | Live patching (kpatch sin reiniciar) |
| **4.1-4.20** | 2015-2018 | Soporte Raspberry Pi 2/3, AMDGPU |
| **5.0** | 2019 | FreeSync, mejoras en GPU |
| **5.1-5.19** | 2019-2022 | Soporte Apple M1, NTFS3, mejoras en Btrfs |
| **6.0** | 2022 | Nuevos drivers, Rust infraestructura inicial |
| **6.1** | 2022 | **Rust en el kernel** (soporte oficial) |
| **6.2+** | 2023-2025 | Más drivers Rust, mejoras en GPU/CPU |

## Hitos clave por año

| Año | Hito |
|---|---|
| 1991 | Nacimiento de Linux |
| 1992 | GNU GPL, X11 portado |
| 1994 | Linux 1.0 |
| 1998 | Linux se vuelve "mainstream" (Mozilla liberado, Netscape) |
| 1999 | **Red Hat IPO** (éxito comercial de Linux) |
| 2000 | IBM invierte $1B en Linux |
| 2004 | Ubuntu 4.10, el escritorio Linux se vuelve accesible |
| 2005 | Git creado por Torvalds (para gestionar el desarrollo kernel) |
| 2007 | **Android** liberado (basado en Linux) |
| 2008 | Primer dispositivo Android (HTC Dream) |
| 2011 | Linux 3.0 (20 aniversario) |
| 2012 | **Raspberry Pi** + Linux conquista el mundo maker |
| 2014 | **systemd** se convierte en el init por defecto en la mayoría de distros |
| 2015 | Windows 10 incluye Subsistema Linux (WSL) |
| 2021 | Linux 30 aniversario |
| 2022 | Rust oficialmente aceptado en el kernel |
| 2023 | Linux en más del 90% de la nube pública |
| 2026 | Linux domina: nube, embebido, supercomputación (100% TOP500), y crece en escritorio |

## Linux en números (2026)

| Estadística | Valor |
|---|---|
| **Líneas de código** | ~35 millones |
| **Contribuyentes** | ~20,000+ (desde 2005) |
| **Arquitecturas** | ~30 |
| **% de servidores** | ~70%+ |
| **% de supercomputación** | 100% (TOP500) |
| **% de smartphones** | ~70% (Android) |
| **% de cloud** | ~90%+ |
| **% de escritorio** | ~4% (creciendo) |
| **Dispositivos IoT** | Miles de millones |

## Ver también

- [[Que es Linux]] — definición y filosofía
- [[GNU y Linux]] — controversia del nombre
- [[Debate Tanenbaum-Torvalds]] — debate sobre arquitectura de kernels
- [[Kernel Linux]] — evolución del kernel
- [[Android (sistema basado en Linux)]] — Linux en móviles
- [[Rust for Linux]] — Rust en el kernel
- Adopción de Linux — estadísticas de uso

## Enlaces externos

- [Anuncio original de Linus (1991)](https://groups.google.com/g/comp.os.minix/c/wlhw16QltzI)
- [Linux Kernel Mailing List](https://lkml.org/)
- [Historial de versiones del kernel](https://kernelnewbies.org/LinuxVersions)
- [The Linux Kernel Archives](https://www.kernel.org/)
- [Wikipedia — Historia de Linux](https://en.wikipedia.org/wiki/History_of_Linux)
- [Linux Foundation — 25 años de Linux](https://www.linuxfoundation.org/)

#concepto
