---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: alta
---

# Filesystem Hierarchy Standard (FHS)

> El FHS define la estructura de directorios estándar en los sistemas Unix/Linux. Todo el sistema de archivos es un solo árbol que parte de la raíz `/`, a diferencia de Windows donde cada disco tiene su propia raíz (`C:\`, `D:\`).

## Definición

El **Filesystem Hierarchy Standard (FHS)** es un estándar mantenido por la **Linux Foundation** que especifica la ubicación de archivos y directorios en sistemas operativos tipo Unix. Su objetivo es garantizar la **compatibilidad** entre distribuciones: saber qué hay en cada carpeta sin importar si usas Arch, Debian, Fedora o Alpine.

```bash
# Visualizar la estructura del sistema de archivos
ls /                   # carpetas principales (versión rápida)
tree -L 1 /            # árbol completo (puede tardar si hay muchos mounts)
findmnt                # ver puntos de montaje activos
```

```
/
├── bin -> usr/bin/     # Ejecutables esenciales (symlink en distros modernas)
├── boot/               # Kernel, initramfs, bootloader
├── dev/                # Dispositivos del sistema
├── etc/                # Configuración global del sistema
├── home/               # Directorios personales de usuarios
├── lib -> usr/lib/     # Librerías esenciales (symlink)
├── media/              # Montaje automático (USBs, CDs)
├── mnt/                # Montaje manual temporal
├── opt/                # Software opcional de terceros
├── proc/               # Sistema de archivos virtual del kernel (procesos)
├── root/               # Home del usuario root
├── run/                # Archivos de ejecución (sockets, PIDs)
├── sbin -> usr/sbin/   # Binarios de administración (symlink)
├── srv/                # Datos de servicios del sistema
├── sys/                # Información de dispositivos (virtual)
├── tmp/                # Archivos temporales (se borran al reiniciar)
├── usr/                # Programas y datos del usuario del sistema
└── var/                # Datos variables (logs, bases de datos, caché)
```

---

## 1. Historia del FHS

| Año | Evento |
|---|---|
| **1990s** | Antes del FHS, cada distribución organizaba los archivos de forma distinta. Los scripts y programas no eran portables entre distros |
| **1994** | Se publica la primera versión del FSSTND (File System Standard) para Linux |
| **2001** | El FSSTND evoluciona al FHS 2.2, mantenido por la Free Standards Group (luego Linux Foundation) |
| **2004** | FHS 2.3 — última versión oficial aprobada. A partir de aquí el estándar se estabiliza |
| **2012** | Aparece el debate sobre **usrmerge** — unificar `/bin`, `/sbin`, `/lib` bajo `/usr/` |
| **2015** | Fedora, Debian, Ubuntu y Arch adoptan el usrmerge. `/bin`, `/sbin`, `/lib` pasan a ser symlinks |
| **2024** | Alpine Linux (musl/busybox) es una de las pocas distros que mantiene separación real entre `/bin` y `/usr/bin` |

> ⚡ **Dato clave**: El FHS **no se ha actualizado oficialmente** desde 2004 (v2.3). Las distribuciones modernas implementan una versión de facto del estándar con modificaciones acordadas entre los desarrolladores principales (usrmerge, `/run/`, `/sys/`).

---

## 2. Directorios clave en detalle

### `/` — La raíz

Es la base de todo el sistema. Solo root contiene los directorios necesarios para arrancar el sistema antes de que se monte `/usr` (en sistemas con particiones separadas). En sistemas modernos con usrmerge, `/bin`, `/sbin` y `/lib` son symlinks a `/usr/`.

```bash
# Ver el sistema de archivos de la raíz
df -h /                 # espacio disponible en la partición raíz
lsblk                   # ver qué partición es /
```

### `/bin` y `/sbin` — Ejecutables esenciales

En el FHS clásico, `/bin` contenía binarios necesarios para el arranque (antes de montar `/usr`). Hoy son symlinks a `/usr/bin`.

```bash
ls -la /bin              # lrwxrwxrwx ... /bin -> usr/bin
ls /bin | head -10       # ls, cp, mv, cat, bash, sh, echo, pwd, sleep...
```

**Contenido típico**: `bash`, `sh`, `ls`, `cp`, `mv`, `rm`, `cat`, `echo`, `grep`, `sed`, `awk`, `tar`, `gzip`, `mount`, `ping`.

### `/boot` — Kernel y bootloader

Contiene los archivos necesarios para arrancar el sistema:

```bash
ls -lh /boot
# vmlinuz-6.8.0-arch1-1       → kernel Linux comprimido
# initramfs-6.8.0-arch1-1.img → initramfs (sistema de archivos temporal de arranque)
# grub/                        → archivos de configuración de GRUB
# EFI/                         → partición ESP (UEFI)
```

**⚠️**: No llenar esta partición — si `/boot` se llena, no podrás actualizar el kernel ni arrancar correctamente.

### `/dev` — Dispositivos

Sistema de archivos virtual gestionado por `udev`. Cada dispositivo tiene un archivo aquí:

```bash
ls /dev | head -20
# sda, sda1, sda2     → discos y particiones SCSI/SATA/NVMe
# tty, pts/           → terminales
# input/              → teclado, ratón, touchpad
# dri/                → GPUs (card0, renderD128)
# usb/                → dispositivos USB
# loop0, loop1...     → dispositivos loop (para imágenes)
```

```bash
# Comandos útiles
lsblk                  # lista dispositivos de bloque (discos, particiones)
lspci                  # dispositivos PCIe
lsusb                  # dispositivos USB
```

### `/etc` — Configuración del sistema

El directorio más importante para el administrador. Contiene **archivos de configuración en texto plano** del sistema y de los servicios instalados.

```bash
ls /etc/                            # config del sistema
# passwd, shadow, group    → usuarios
# hosts, hostname          → resolución local
# resolv.conf              → DNS
# fstab                    → montajes al arranque
# ssh/                     → SSH
# systemd/                 → servicios
sudoedit /etc/ssh/sshd_config        # editar con copia de seguridad
sudo cat /etc/hostname               # ver nombre del host
```

**⚠️**: No poner archivos personales aquí. `/etc/` es para configuración del sistema, no para tus scripts.

### `/home` — Usuarios

Contiene los directorios personales de cada usuario. Cada usuario tiene su propia carpeta con sus archivos, configuraciones y dotfiles.

```bash
ls /home/
# carlos/                    → /home/carlos
#   Descargas/, Documentos/  → carpetas personales
#   .bashrc, .config/        → dotfiles del usuario
```

**⚠️**: En sistemas con partición separada para `/home`, puedes reinstalar la distro sin perder tus archivos.

### `/root` — Home del superusuario

El directorio home del usuario root. Separado de `/home` por seguridad — si `/home` no se puede montar, root aún tiene acceso a su configuración.

### `/var` — Datos variables

Archivos cuyo tamaño y contenido cambian durante la operación del sistema. Es donde se almacenan logs, bases de datos, cachés y colas de impresión.

```bash
ls /var/                            # datos variables
# log/          → logs del sistema y servicios
# cache/        → caché de paquetes (apt, pacman)
# lib/          → datos persistentes (docker, mysql, postgres)
# tmp/          → temporales persistentes entre reinicios
# spool/        → colas de impresión, correo
# backups/      → backups locales (por convención)

du -sh /var/log/*                    # tamaño de cada log
sudo journalctl --disk-usage         # cuánto ocupan los logs de systemd
du -sh /var/cache/apt                # caché de apt (Debian/Ubuntu)
```

**⚠️**: `/var/log` es lo primero que revisar al diagnosticar problemas. `/var/cache` puede crecer y ocupar GBs — limpiar periódicamente.

### `/usr` — Jerarquía del usuario del sistema

El directorio más grande del sistema. Contiene la mayoría de los programas, librerías, documentación y datos compartidos.

```bash
ls /usr/                            # programas del sistema
# bin/          → ejecutables (git, vim, python, node...)
# sbin/         → binarios de administración
# lib/          → librerías compartidas
# share/        → datos: doc, man, icons, locale, applications
# local/        → software compilado manualmente (ver abajo)

ls /usr/local/                      # instalaciones manuales
# bin/          → binarios compilados a mano
# lib/, share/, etc/  → librerías, datos y config propia
```

> El PATH típico en Linux es: `/usr/local/bin` → `/usr/bin` → `/bin`. Los programas en `/usr/local` tienen prioridad sobre los del sistema.

### `/proc` — Sistema de archivos virtual del kernel

No existe físicamente en el disco. Es una interfaz virtual que el kernel expone para acceder a información de procesos y del sistema.

```bash
cat /proc/cpuinfo                    # info de la CPU
cat /proc/meminfo                    # memoria RAM detallada
cat /proc/version                    # versión del kernel
cat /proc/uptime                     # tiempo desde el arranque
ls /proc/                            # cada número = PID de un proceso
cat /proc/1/status                   # info del proceso init

ls /sys/class/                       # clasificación de dispositivos
cat /sys/class/backlight/*/brightness # brillo de pantalla
ls /sys/block/                       # dispositivos de bloque
```

### `/tmp`, `/run`, `/mnt`, `/media`, `/opt`

```bash
# /tmp → archivos temporales (tmpfs en RAM, se borran al reiniciar)
df -h /tmp                             # tmpfs — normalmente la mitad de la RAM

# /run → sockets IPC, archivos PID, locks de servicios
ls /run/                               # systemd/, docker.sock, lock/, user/

# /mnt → montaje manual / /media → montaje automático
sudo mount /dev/sdb1 /mnt              # montar manual
sudo umount /mnt                       # desmontar

# /opt → software de terceros no gestionado por el gestor de paquetes
ls /opt/                               # google/, intellij/, vivaldi/
```

### `/srv` — Servicios del sistema

Datos específicos de servicios HTTP, FTP, rsync, etc. En la práctica, pocas distros lo usan activamente — la mayoría usa `/var/www/` o rutas personalizadas.

---

## 3. usrmerge — La unificación de /bin, /sbin y /lib

Históricamente, el FHS separaba `/bin` (binarios esenciales para arrancar) de `/usr/bin` (binarios no esenciales). Esto tenía sentido cuando `/usr` podía estar en una partición NFS remota o en un disco separado.

Hoy en día, casi ninguna distro monta `/usr` por separado. Por eso se adoptó el **usrmerge**:

```bash
# Antes del usrmerge (FHS clásico)
/bin/ls         # binario esencial para el arranque
/usr/bin/vim    # binario no esencial, podía estar en otra partición

# Después del usrmerge (distros modernas)
/bin -> usr/bin/    # symlink
/sbin -> usr/sbin/  # symlink
/lib -> usr/lib/    # symlink
```

**Distros con usrmerge**: Fedora (2012+), Arch (2016+), Debian (2019+, bookworm obligatorio), Ubuntu (19.04+), openSUSE.

**Sin usrmerge**: Alpine Linux (busybox), Slackware, algunas imágenes mínimas de Docker.

```bash
# Verificar si tu sistema tiene usrmerge
stat /bin | head -3
# Si dice "symbolic link" → usrmerge activo
# Si dice "directory" → FHS clásico (Alpine, etc.)
```

---

## 4. FHS vs tendencias modernas

### Contenedores e imágenes minimalistas

En el mundo Docker/OCI, el FHS se simplifica drásticamente:

```dockerfile
FROM alpine:latest
# /bin/sh → busybox (todo-en-uno, ~1MB)
# No tiene /home, /media, /mnt, /opt, /srv
# /tmp y /var pueden no existir
```

Las imágenes base (`scratch`, `alpine`, `distroless`) eliminan la mayoría de directorios no esenciales para reducir tamaño.

### Distros inmutables

Distros como Fedora Silverblue, Vanilla OS, NixOS y SteamOS usan sistemas de archivos de solo lectura. `/usr` es inmutable y los cambios se hacen mediante overlays, imágenes o capas:

```
/usr/ → imagen OSTree (solo lectura, versionada)
/etc/ → combina defaults del sistema + overrides locales
/var/ → writable (logs, datos de usuario, state)
```

### systemd y la evolución de directorios

| Directorio tradicional | Reemplazo moderno (systemd) |
|---|---|
| `/var/run/` | `/run/` (tmpfs, se borra al reiniciar) |
| `/var/lock/` | `/run/lock/` |
| `/etc/rc.local` | `/etc/systemd/system/` (units) |
| `/etc/init.d/` | `/etc/systemd/system/` |
| `/var/log/syslog` | `journalctl` (logs binarios) |

---

## 5. Comandos para explorar el sistema de archivos

```bash
# Visualizar estructura
tree -L 2 /                   # árbol (instalar con apt/pacman/dnf install tree)
ncdu /                        # navegador interactivo de uso de disco
du -sh /*                     # tamaño de cada directorio raíz
df -h                         # espacio disponible en cada partición
lsblk                         # ver montajes y particiones

# Encontrar archivos por tipo
find /etc -type f -name "*.conf" | head -20   # archivos de configuración
find /usr -type l -name "*.so" | head -10     # symlinks a librerías

# Ver permisos y propietarios
ls -la /etc/passwd            # permisos 644, propietario root:root
stat /etc/hosts               # información detallada del archivo
```

---

## 6. Por qué importa en el día a día

Saber qué va dónde te permite:

| Situación | Qué hacer | Dónde mirar |
|---|---|---|
| **Diagnosticar un error** | Revisar logs del sistema | `/var/log/syslog`, `journalctl -xe` |
| **El disco está lleno** | Encontrar qué ocupa espacio | `ncdu /`, `du -sh /var/cache/apt` |
| **Editar configuración de red** | Modificar archivos de red | `/etc/NetworkManager/`, `/etc/systemd/network/` |
| **Instalar programa manualmente** | Compilar e instalar | `./configure --prefix=/usr/local && make && sudo make install` |
| **Buscar un comando** | Encontrar dónde está instalado | `which git`, `type -a python`, `find /usr/bin -name 'git'` |
| **Limpiar espacio** | Borrar cachés de paquetes | `sudo apt clean` (Debian), `sudo pacman -Sc` (Arch) |
| **Actualizar kernel** | Saber qué kernels están instalados | `ls /boot/vmlinuz-*`, `file /boot/vmlinuz-*` |
| **Montar USB manualmente** | Conectar disco externo | `sudo mount /dev/sdb1 /mnt`, luego ver en `/media/` |
| **Encontrar archivo de servicio** | Ver unit de un servicio | `/etc/systemd/system/`, `/usr/lib/systemd/system/` |

---

## 7. Troubleshooting / Problemas comunes

| Problema | Causa | Solución |
|---|---|---|
| **`/boot` está lleno** y no puedo actualizar kernel | Acumulación de kernels antiguos | `sudo pacman -R linux-old` (Arch) o `sudo apt autoremove` (Debian). Verificar con `ls /boot` |
| **`/var/log` ocupa GBs** | Logs sin rotar o journald sin límite | `journalctl --vacuum-size=500M` / `sudo logrotate -f /etc/logrotate.conf` |
| **`/tmp` lleno** | Archivos temporales no limpiados | Solo se borra al reiniciar. `sudo rm -rf /tmp/*` (si no hay procesos activos) |
| **No encuentro un comando** | No está en PATH o no está instalado | `which comando` / `type comando` / `find /usr/bin -name '*comando*'` |
| **`/usr/local/bin` no está en PATH** | Variable PATH incompleta | `export PATH=/usr/local/bin:$PATH` en `.bashrc` |
| **`mount: unknown filesystem type`** | Falta el driver del sistema de archivos | Instalar `ntfs-3g`, `exfat-utils`, `btrfs-progs`, etc. |
| **Disco lleno pero `du` muestra poco** | Archivos borrados pero retenidos por procesos activos | `sudo lsof +L1` o `sudo find /proc/*/fd -type f -size +1M 2>/dev/null` |

---

## Ver también

- [[Proc y Sys]] — sistemas de archivos virtuales del kernel
- [[Sistemas de Archivos]] — tipos de sistemas de archivos (ext4, Btrfs, XFS, ZFS)
- [[Permisos y Propietarios]] — permisos y ownership en Linux
- [[Symlinks y Dotfiles]] — enlaces simbólicos y archivos de configuración
- [[Particionado y Esquemas de Disco]] — cómo particionar el disco siguiendo el FHS
- [[Variables de Entorno y PATH]] — cómo el sistema encuentra binarios
- [[Post-Instalación Checklist]] — qué carpetas verificar tras instalar
- [[XDG Base Directory y dotfiles modernos]] — estándar moderno para directorios de usuario

## Enlaces externos

- [Wikipedia — Filesystem Hierarchy Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)
- [Linux Foundation — FHS 2.3 (PDF)](https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf)
- [Pathname.com — FHS 3.0 Draft (2015)](https://www.pathname.com/fhs/)
- [Arch Wiki — File System Hierarchy](https://wiki.archlinux.org/title/File_system_hierarchy)
- [Debian Wiki — FHS](https://wiki.debian.org/FilesystemHierarchyStandard)
- [Fedora — UsrMove](https://fedoraproject.org/wiki/Features/UsrMove)
- [Alpine Linux — FHS differences](https://wiki.alpinelinux.org/wiki/Comparison_with_other_distros#Filesystem_Hierarchy)

#sistema #fhs
