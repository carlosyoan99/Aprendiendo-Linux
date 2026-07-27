---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# Utilidades del sistema (Coreutils, GNU utils, util-linux, procps-ng)

## Visión general

Linux se compone de múltiples colecciones de utilidades. Cada colección tiene un propósito y un mantenedor distinto. Entender quién provee cada comando ayuda a diagnosticar problemas de compatibilidad, especialmente en sistemas embebidos o contenedores minimalistas.

```bash
┌──────────────────────────────────────────────────────────┐
│                    Utilidades del sistema                  │
├───────────────────┬──────────────────┬───────────────────┤
│    GNU Coreutils   │    util-linux    │     procps-ng     │
│  ls, cp, mv, rm,   │  mount, fdisk,   │  ps, top, kill,   │
│  cat, echo, sort,  │  dmesg, blkid,   │  free, uptime,    │
│  grep, sed, awk  │  hwclock, cal   │  vmstat, watch    │
├───────────────────┴──────────────────┴───────────────────┤
│              Otras: findutils, diffutils, tar, gzip       │
└──────────────────────────────────────────────────────────┘
```

---

## 1. GNU Coreutils

**Paquete**: `coreutils`
**Mantenedor**: Proyecto GNU (Richard Stallman, Jim Meyering)
**Tamaño**: ~15 MB instalado

Es la colección más fundamental. Contiene las utilidades esenciales para manipular archivos, texto y el shell. Es uno de los primeros paquetes que se instalan en cualquier sistema Linux.

### Comandos incluidos

```bash
# Archivos
ls, cp, mv, rm, touch, mkdir, rmdir, ln, chmod, chown, chgrp
cat, tac, head, tail, nl, od, base64, basename, dirname, pathchk
# Texto
sort, uniq, cut, tr, expand, unexpand, fmt, pr, fold, paste, join
echo, printf, yes, seq, env, printenv, factor, shred, sha*sum
# Fechas y sistema
date, cal, sleep, timeout, true, false, sync, hostname, nproc, whoami
# Otros
tee, test, [, who, users, uname, arch, uptime, pwd, realpath, readlink
stat, wc, md5sum, sha1sum, sha256sum, b2sum
```

```bash
# Ver versión de coreutils
ls --version | head -1                  # (GNU coreutils) 9.5
# Ver paquetes que dependen de coreutils
apt depends coreutils                    # Debian/Ubuntu
```

### Alternativas no-GNU

En sistemas minimalistas (Alpine Linux, BusyBox) los comandos son proporcionados por **BusyBox** (multi-call binary) y pueden tener opciones diferentes:

```bash
# BusyBox combina todos los comandos en un solo binario
busybox ls -la                          # ls de BusyBox
busybox --help                          # lista de comandos disponibles

# En Alpine, el shell es ash (no bash), ls es de BusyBox (no GNU)
# Esto significa que algunas opciones GNU no están disponibles
```

---

## 2. GNU utils (paquetes separados)

GNU produce varias colecciones de utilidades además de coreutils:

### findutils
```bash
# Paquete: findutils (~2 MB)
find, locate, updatedb, xargs

# find es parte de findutils, no de coreutils
# locate y updatedb requieren que mlocate o plocate estén instalados
```

### diffutils
```bash
# Paquete: diffutils (~1 MB)
diff, cmp, diff3, sdiff
```

### tar
```bash
# Paquete: tar (~2 MB)
tar                                     # GNU tar
# No confundir con bsdtar (libarchive)
tar --version | head -1                 # tar (GNU tar) 1.35
```

### gzip / bzip2 / xz
```bash
# Paquetes separados
gzip, gunzip, zcat, zcmp, zdiff, zgrep
bzip2, bunzip2, bzcat, bzcmp, bzdiff, bzgrep
xz, unxz, xzcat, xzcmp, xzdiff, xzgrep
zstd, unzstd, zstdcat                    # Zstandard (no GNU, pero estándar moderno)
```

### grep
```bash
# Paquete: grep (~1 MB)
grep, egrep, fgrep, rgrep
grep --version | head -1                # grep (GNU grep) 3.11
```

---

## 3. util-linux

**Paquete**: `util-linux`
**Mantenedor**: Karel Zak (kernel.org)
**Tamaño**: ~10 MB instalado
**Propósito**: Utilidades del sistema relacionadas con el kernel, discos, particiones y gestión del sistema. Es el segundo paquete más fundamental después de coreutils.

### Comandos incluidos

```bash
# Particionado y discos
fdisk, sfdisk, cfdisk, blkid, lsblk, mkfs, mkswap, swapon, swapoff, fsck
# Montaje
mount, umount, mountpoint, findmnt
# Sistema
dmesg, wall, write, mesg, renice, ionice, chcpu, chmem, lscpu, lsipc
hwclock, clock, rtcwake
# Terminal
agetty, su, login, logout, deluser, newgrp, last, lastb
# Procesos
kill, killall, pgrep, pkill, pidof
# Miscelánea
cal, whereis, flock, logger, look, mcookie, namei, rev
script, scriptlive, scriptreplay
setsid, setpriv, unshare, nsenter
uuidd, uuidgen, uuidparse
wipefs, fallocate, truncate
flock, getopt, hexdump, prlimit, readprofile
```

```bash
# Ver qué comandos vienen de util-linux (vs coreutils)
which fdisk                             # /usr/sbin/fdisk ← util-linux
which lsblk                             # /usr/sbin/lsblk ← util-linux
which cal                               # /usr/bin/cal ← util-linux (o coreutils en algunos)
```

### Identificar de qué paquete viene un comando

```bash
# Debian/Ubuntu
dpkg -S $(which fdisk)                  # util-linux: /usr/sbin/fdisk

# Arch
pacman -Qo $(which lsblk)               # util-linux: /usr/bin/lsblk

# Fedora/RHEL
rpm -qf $(which mount)                  # util-linux: /usr/bin/mount
```

---

## 4. procps-ng

**Paquete**: `procps-ng` (Debian/Ubuntu: `procps`, Arch/Fedora: `procps-ng`)
**Tamaño**: ~2 MB
**Propósito**: Utilidades para inspeccionar y gestionar procesos a través del sistema de archivos `/proc`.

### Comandos incluidos

```bash
# Procesos
ps, top, htop (no, htop es paquete separado)
pgrep, pkill, pidof, skill, slabtop, tload, w
# Memoria
free, vmstat, pmap, smem
# Sistema
uptime, sysctl, watch
```

```bash
# Ver información de /proc a través de procps
ps aux                                 # lista de procesos
free -h                                # memoria RAM
uptime                                 # tiempo encendido
vmstat 2                               # estadísticas del sistema cada 2s
watch -n 1 'cat /proc/loadavg'         # monitorizar load average
```

### Diferencia entre kill de util-linux y procps-ng

```bash
which kill                             # puede estar en /bin/kill (coreutils)
# o /usr/bin/kill (procps-ng o util-linux)
# kill de util-linux: comando externo (envía señales por PID)
# kill de bash/zsh: built-in del shell (más rápido, mismo efecto)
```

---

## Tabla resumen de colecciones

| Colección | Comandos principales | Paquete (Debian) | Paquete (Arch) |
|---|---|---|---|
| **GNU Coreutils** | ls, cp, mv, rm, cat, sort, uniq, echo, date, sleep | coreutils | coreutils |
| **GNU grep** | grep, egrep, fgrep | grep | grep |
| **GNU tar** | tar | tar | tar |
| **GNU findutils** | find, locate, xargs | findutils | findutils |
| **GNU diffutils** | diff, cmp, sdiff | diffutils | diffutils |
| **util-linux** | fdisk, blkid, lsblk, mount, dmesg, hwclock, kill | util-linux | util-linux |
| **procps-ng** | ps, top, free, uptime, vmstat, watch, pgrep | procps | procps-ng |
| **BusyBox** | Todo-en-uno (minimalista) | busybox (no instalado por defecto) | busybox |

## Curiosidades

- `[` (test) es un comando real en coreutils: `ls -la $(which [)` muestra `/usr/bin/[`
- `kill` es tanto un shell built-in (bash, zsh) como un comando externo (util-linux)
- En Alpine Linux, `ls --version` no dirá "GNU" porque usa BusyBox
- `watch` viene de procps-ng en la mayoría de distros
- GNU `yes` repite "y" infinitamente: `yes | sudo pacman -Syu` (automatizar confirmaciones)

## Ver también

- [[Utilidades Base del Sistema]] — visión general de paquetes base
- [[Proc y Sys]] — sistemas de archivos virtuales /proc y /sys
- [[Módulos del kernel (lsmod modprobe blacklist)]] — utilidades lsmod, modprobe (kmod)
- [[Gestores de Paquetes]] — cómo identificar a qué paquete pertenece un comando
- [[Compilación desde Código Fuente]] — compilar coreutils desde fuente

## Enlaces externos

- [Wikipedia - GNU Core Utilities](https://en.wikipedia.org/wiki/GNU_Core_Utilities)
- [Wikipedia - Util-linux](https://en.wikipedia.org/wiki/Util-linux)
- [Sitio oficial - GNU Coreutils](https://www.gnu.org/software/coreutils/)
- [GitHub - util-linux](https://github.com/util-linux/util-linux)

#comando #sistema
