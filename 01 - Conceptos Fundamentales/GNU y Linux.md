---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: alta
---

# GNU y Linux

## Definición

**GNU** (GNU's Not Unix) es un proyecto iniciado por Richard Stallman en 1983 para crear un sistema operativo completamente libre. **Linux** es el kernel creado por Linus Torvalds en 1991. La combinación de herramientas GNU + kernel Linux forma el sistema que la mayoría llama \"Linux\", pero que la Free Software Foundation denomina **GNU/Linux**.

```
Composición de un sistema GNU/Linux típico:

  ┌────────────────────────────────────────────┐
  │        Aplicaciones de usuario             │
  │  (Firefox, LibreOffice, GIMP, juegos)      │
  ├────────────────────────────────────────────┤
  │        GNU Userland (herramientas)          │
  │  bash, coreutils (ls, cp, mv, rm), gcc,   │
  │  glibc, tar, grep, sed, awk, make, nano,  │
  │  diff, find, gzip, etc.                    │
  ├────────────────────────────────────────────┤
  │                Kernel Linux                │
  │  (drivers, scheduler, memoria, red, VFS)   │
  ├────────────────────────────────────────────┤
  │                Hardware                    │
  │  (CPU, RAM, discos, GPU, red, USB...)      │
  └────────────────────────────────────────────┘
```

## GNU — El proyecto

### Origen y filosofía

- **1983**: Richard Stallman anuncia el proyecto GNU
- **1985**: Publica el **Manifiesto GNU**
- **1989**: Se publica la **GNU General Public License (GPL)**
- **1990**: GNU ya tiene editor (Emacs), compilador (GCC), depurador (GDB), shell (bash), utilidades básicas (coreutils)

GNU buscaba crear un sistema operativo completo llamado **GNU Hurd** (kernel propio), pero el Hurd no estuvo listo hasta mucho después (sigue en desarrollo hoy). El kernel Linux llenó ese vacío.

### Componentes GNU en tu sistema

| Componente | Propósito | Comando para ver versión |
|---|---|---|
| **GCC** (GNU Compiler Collection) | Compilador de C, C++, Fortran, etc. | `gcc --version` |
| **glibc** (GNU C Library) | Librería estándar de C (base de casi todo) | `/lib/libc.so.6` (o `ldd --version`) |
| **Bash** (Bourne Again SHell) | Shell por defecto en la mayoría de distros | `bash --version` |
| **Coreutils** | Herramientas esenciales (ls, cp, mv, rm, cat) | No tiene versión única, son paquete |
| **GNU tar** | Archivador | `tar --version` |
| **GNU sed** | Editor de flujo | `sed --version` |
| **GNU awk** (gawk) | Procesamiento de texto | `awk --version` |
| **GNU grep** | Búsqueda de patrones | `grep --version` |
| **GNU make** | Automatización de compilación | `make --version` |
| **GNU diff** | Comparación de archivos | `diff --version` |
| **GNU find** | Búsqueda de archivos | `find --version` |
| **GNU binutils** | Ensamblador, enlazador (ld, as) | `ld --version` |
| **GNU Privacy Guard (GnuPG)** | Cifrado y firmas | `gpg --version` |
| **Emacs** | Editor extensible | `emacs --version` |
| **GNU Screen** | Multiplexor de terminal | `screen --version` |

```bash
# Ver todos los paquetes GNU instalados (Debian/Ubuntu)
dpkg -l | grep -i gnu

# En Arch, los paquetes GNU son la mayoría del sistema base
pacman -Q | grep -E "^(glibc|gcc|coreutils|bash|tar|grep|sed|gawk|make)"
```

## GNU GPL — La licencia que cambió el mundo

La **GNU General Public License** (GPL) es el corazón del proyecto GNU. Sus principios:

1. **Libertad 0**: Ejecutar el programa como quieras
2. **Libertad 1**: Estudiar y modificar el código fuente
3. **Libertad 2**: Redistribuir copias
4. **Libertad 3**: Distribuir tus versiones modificadas

> **Copyleft**: Si distribuyes una versión modificada, debes hacerlo bajo la misma licencia (GPL). Es \"copyright\" al revés — garantiza que el software siga siendo libre.

| Licencia GNU | Usada en | Característica |
|---|---|---|
| **GPLv2** | Kernel Linux, Git | La más usada, compatible con la mayoría de proyectos |
| **GPLv3** | Bash 4+, GNU coreutils recientes | Cierra vacíos legales de v2 (patentes, DRM, TiVoization) |
| **LGPL** (Lesser GPL) | glibc, GTK | Permite enlazar desde software no GPL (más permisiva) |
| **AGPL** (Affero GPL) | Servicios de red | Cierra el vacío del software como servicio (SaaS) |

## Linux — El kernel

```bash
# Verificar qué componentes GNU vs no-GNU usa tu sistema
# Los comandos GNU responden a --version mencionando "GNU"
ls --version | head -1          # (GNU coreutils)
bash --version | head -1        # GNU bash
gcc --version | head -1         # gcc (GCC)

# Los comandos no-GNU (o alternativas) no mencionan GNU
busybox --help 2>&1 | head -1   # BusyBox (alternativa embebida, no GNU)
clang --version | head -1       # LLVM (no GNU)
```

## La controversia GNU/Linux

Richard Stallman y la FSF defienden que el sistema debería llamarse **GNU/Linux** en lugar de solo \"Linux\", argumentando que:

1. GNU aporta la mayoría de herramientas del sistema operativo
2. Linux es solo el kernel
3. El objetivo filosófico del proyecto GNU se diluye al llamarlo solo \"Linux\"

Linus Torvalds y la mayoría de la comunidad llaman al sistema simplemente **Linux**, argumentando que:

1. Linux es el nombre popular que la gente reconoce
2. No todas las herramientas son GNU (Xorg, Wayland, systemd, etc.)
3. Muchas distros (Android, Alpine) no usan herramientas GNU

**Uso en este vault**: Usamos \"Linux\" para referirnos al sistema completo por simplicidad, reconociendo la contribución fundamental de GNU.

## ¿Qué distros usan más GNU?

| Distribución | Dependencia de GNU | Notas |
|---|---|---|
| **Debian / Ubuntu** | Alta | Usan GNU coreutils, bash, gcc — todo GNU |
| **Arch Linux** | Alta | Similar a Debian, base GNU estándar |
| **Fedora / RHEL** | Alta | GNU estándar, aunque Red Hat contribuye mucho a GCC/glibc |
| **Alpine Linux** | **Baja** | Usa **musl** (no glibc), **busybox** (no coreutils), **OpenRC** (no systemd) |
| **Gentoo** | Alta pero configurable | Puedes cambiar a musl, clang, y alternativas no-GNU |
| **Android** | **Mínima** | Usa Bionic (no glibc), toybox (no coreutils), kernel modificado |
| **NixOS** | Alta | GNU estándar, pero con su propio gestor de paquetes |

## Enlaces externos

- [GNU.org](https://www.gnu.org/) — página oficial del proyecto GNU
- [Wikipedia: Proyecto GNU](https://es.wikipedia.org/wiki/Proyecto_GNU)
- [Wikipedia: GNU/Linux](https://es.wikipedia.org/wiki/GNU/Linux) — controversia del nombre
- [GNU Licenses](https://www.gnu.org/licenses/licenses.html) — todas las licencias GNU
- [kernel.org](https://www.kernel.org/) — kernel Linux

## Ver también

- [[Que es Linux]] — introducción general
- [[Kernel Linux]] — el kernel en detalle
- [[Compilacion desde Codigo Fuente]] — compilar GCC, glibc, etc.
- [[Procesos y Senales]] — cómo glibc interactúa con el kernel (syscalls)
- [[Shells (bash zsh fish)]] — bash es el shell GNU por excelencia

#concepto
