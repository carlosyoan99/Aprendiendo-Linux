---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: baja
---

# Historial de versiones del kernel de Linux

## Definición

El kernel Linux ha pasado por un largo proceso de versionado desde su primera publicación en 1991. Este documento recoge los hitos principales de cada era del kernel, las versiones LTS, y el esquema de numeración.

> Para una visión general del kernel (arquitectura, subsistemas, cómo ver tu versión), ver [[Kernel Linux]].

---

## Esquema de versionado

```
Época clásica (1991-2003):  0.01 → 0.11 → 0.95 → 1.0 → 1.2 → 2.0 → 2.2 → 2.4
Época 2.6 (2003-2011):      2.6.0 → 2.6.39   (estable durante 8 años)
Época 3.x (2011-2015):      3.0 → 3.19       (solo por 20 aniversario)
Época 4.x (2015-2019):      4.0 → 4.20       (llegó a 4.20)
Época 5.x (2019-2022):      5.0 → 5.19       (WireGuard, NTFS3, Rust)
Época 6.x (2022-presente):  6.0 → actual     (Rust estable, mejoras Btrfs/scheduler)
```

### Numeración

| Componente | Significado | Ejemplo |
|---|---|---|
| **Major** (6.x) | Versión principal, cambia con hitos importantes | 4.0, 5.0, 6.0, 7.0 |
| **Minor** (6.8.x) | Funcionalidades nuevas, cambios cada ~2meses | 6.1, 6.2, ..., 6.19 |
| **Patch** (6.8.12) | Correcciones de seguridad y bugs | 6.8.1, 6.8.2, ... |

Las versiones **pares** (2.0, 2.2, 2.4, 2.6) solían ser estables, y las **impares** (2.1, 2.3, 2.5) de desarrollo. Esto se abandonó con 3.0.

---

## Timeline completo

| Versión | Fecha | Líneas de código | Hito |
|---|---|---|---|
| **0.01** | 17 sep 1991 | 8,413 | Primer lanzamiento público |
| **0.11** | 8 dic 1991 | 11,907 | Primeras funcionalidades básicas completas |
| **1.0** | 14 mar 1994 | 170,581 | Primera versión "estable", soporte de red |
| **1.2** | 7 mar 1995 | 294,623 | Soporte de más arquitecturas |
| **2.0** | 9 jun 1996 | 716,119 | SMP (múltiples CPUs), nuevo modelo de memoria |
| **2.2** | 26 ene 1999 | 1,676,182 | Mejoras en SMP y redes |
| **2.4** | 4 ene 2001 | 3,158,560 | USB, ext3, RAID software, IPv6 experimental |
| **2.6** | 18 dic 2003 | 5,475,685 | Scheduler O(1), preemptible, ALSA, udev, NUMA |
| **3.0** | 22 jul 2011 | 13,688,408 | 20 aniversario — sin cambios revolucionarios |
| **4.0** | 12 abr 2015 | ~19M | kpatch (parches del kernel sin reinicio) |
| **5.0** | 3 mar 2019 | ~27M | Fin de 4.x (por llegar a 4.20) |
| **6.0** | 2 oct 2022 | ~33M | Rust como lenguaje para drivers (experimental) |
| **7.0** | 22 feb 2026 | — | Última versión mayor al momento |

> **Dato**: el kernel 0.01 tenía 8,413 líneas de código. El 6.0 supera los **33 millones**. Creció ~4,000× en 35 años.

---

## Versiones LTS y su ciclo de vida

Antes de 2011 no existía el concepto formal de LTS. Las versiones 2.6.16 y 2.6.27 fueron informalmente designadas como "largo soporte".

| Versión | Fecha | Fin de soporte | Usada por |
|---|---|---|---|
| **5.4** | nov 2019 | dic 2025 | Ubuntu 20.04 LTS |
| **5.10** | dic 2020 | dic 2026 | Debian 11, RHEL 9 |
| **5.15** | oct 2021 | dic 2026 | Ubuntu 22.04 LTS, Slackware 15 |
| **6.1** | dic 2022 | dic 2027 | Primera con soporte para Rust |
| **6.6** | oct 2023 | dic 2026 | Ubuntu 24.04 |
| **6.12** | nov 2024 | dic **2036** | LTS más longeva hasta ahora |
| **6.18** | nov 2025 | dic 2027 | LTS reciente |

> El kernel 6.12 tiene soporte hasta 2036 — el período LTS más largo jamás otorgado, gracias al programa CIP (Civil Infrastructure Platform).

---

## Versiones destacadas por sus innovaciones

| Versión | Innovación clave | Impacto |
|---|---|---|
| **2.4** (2001) | USB, ext3, RAID, IPv6 | Linux se vuelve usable para el escritorio |
| **2.6** (2003) | Preemptible, ALSA, udev, O(1) scheduler | Madurez para servidores |
| **2.6.28** (2008) | CFS scheduler (reemplaza O(1)) | Mejor interactividad en escritorio |
| **3.11** (2013) | OOM killer mejorado, zswap, fstrim | Mejor manejo de RAM y SSDs |
| **4.0** (2015) | kpatch (parches sin reinicio) | Alta disponibilidad |
| **5.6** (2020) | WireGuard integrado | VPN moderna nativa |
| **5.15** (2021) | NTFS3 (driver nativo de Paragon) | Mejor compatibilidad con Windows |
| **5.18** (2022) | Switch a C11 como estándar del código | Código más moderno |
| **5.19** (2022) | Soporte LoongArch, AMD SEV-SNP, Intel TDX | Virtualización más segura |
| **6.1** (2022) | Módulos del kernel en **Rust** | Lenguaje moderno para drivers |
| **6.12** (2024) | Scheduler EEVDF (reemplaza CFS) | Mejor fairness en CPUs modernas |

---

## Ramas del kernel

```bash
# Mainline: versión en desarrollo de Linus Torvalds
# Stable: mantenida por Greg Kroah-Hartman (correcciones)
# LTS: mantenida por años (para distros enterprise)
# linux-next: integración de parches para el próximo ciclo

# Tu versión actual
uname -r

# Todas las versiones disponibles
ls /lib/modules/
```

| Rama | Mantenida por | Ciclo | Para quién |
|---|---|---|---|
| **Mainline** | Linus Torvalds | ~2 meses | Desarrolladores |
| **Stable** | Greg Kroah-Hartman | 3-4 meses | Distros rolling |
| **LTS** | Kroah-Hartman + Sasha Levin | 2-10+ años | Servidores, enterprise |
| **SLTS** (CIP) | Equipo CIP | 20+ años | Infraestructura civil, IoT |

---

## Nombres de versiones

Desde 2019, Linus Torvalds empezó a nombrar las versiones rc de forma cada vez más excéntrica:

| Versión | Nombre |
|---|---|
| 5.2 | Bobtail Squid |
| 5.11 | 💕 Valentine's Day Edition 💕 |
| 5.12 | Frozen Wasteland |
| 5.13 | Opossums on Parade |
| 5.15 | Trick or Treat |
| 5.17 | Superb Owl |
| 6.0 | Hurr durr I'ma ninja sloth |
| 6.1 | — (primera con Rust) |

> Ver la lista completa en el [Makefile del kernel](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Makefile).

---

## Curiosidades

- **Kernel 0.01 cabía en un diskette de 1.44 MB** (sin contar comentarios). Hoy el tarball comprimido ocupa ~130 MB.
- **El kernel 1.0 tardó 3 años** en llegar (1991→1994). El 2.6 duró **8 años** como rama estable principal.
- **Linus odia el versionado semántico**: "We do NOT bump the major version number for every random change. That's just silly."
- **Kernel 4.0 iba a ser 3.20**, pero Linus bromeó en una charla sobre "qué número después de 3.19" y la comunidad pidió 4.0.
- **El kernel 5.0** fue principalmente porque "4.20 sonaba a versión de marihuana" y "4.21 no tenía sentido".
- **Los lunes (a veces martes) son los días de release**. Linus suelta las rc los domingos por la noche (hora de EEUU).

---

## Ver también

- [[Kernel Linux]] — arquitectura, subsistemas, y versión actual
- [[Rust for Linux]] — Rust como segundo lenguaje del kernel
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — cómo el kernel toma el control
- [[Linux embebido]] — kernels customizados para sistemas integrados
- [[Compilacion desde Codigo Fuente]] — compilar tu propio kernel

## Enlaces externos

- [kernel.org — releases](https://www.kernel.org/category/releases.html) — timeline oficial
- [Wikipedia: Linux kernel version history](https://en.wikipedia.org/wiki/Linux_kernel_version_history)
- [Kernel Newbies](https://kernelnewbies.org/LinuxChanges) — cambios por versión, explicados
- [Phoronix](https://www.phoronix.com/) — noticias detalladas de cada release
- [ELinux.org — Kernel versions](https://elinux.org/Kernel_Versions)

#concepto #kernel #historia
