---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
licencia: Comercial (de pago, ~11$)
alternativas: SystemRescue, GParted Live, GParted (herramienta)
---

# Parted Magic

> Live CD/USB de rescate y particionado de discos, basado en Slackware. Incluye herramientas de particionado, clonado, recuperación de datos, borrado seguro y testeo de hardware.

## Qué es

**Parted Magic** es una distribución Linux comercial (de pago, aunque tuvo una versión gratuita años atrás) diseñada para ejecutarse completamente desde un CD, USB o red (PXE) sin necesidad de instalación. Está pensada para tareas de **mantenimiento de discos**: particionado, clonado, recuperación de datos, borrado seguro, y diagnóstico de hardware.

El nombre viene de la combinación de **GNU Parted** (herramienta de particionado) y **PartitionMagic** (el antiguo gestor de particiones de Windows).

A diferencia de otras distros de rescate, Parted Magic incluye herramientas propietarias (como `ddrescue` y `hdparm` optimizadas) y soporta lectura/escritura de NTFS, exFAT, ext4, Btrfs y otros sistemas de archivos.

## Características

| Funcionalidad | Herramientas incluidas |
|---|---|
| **Particionado** | GParted, Parted, fdisk, gdisk, sfdisk |
| **Clonado de discos** | Clonezilla, dd, ddrescue, Partclone, Partimage |
| **Recuperación de datos** | TestDisk, PhotoRec, extundelete, ntfsundelete, foremost |
| **Borrado seguro** | shred, wipe, hdparm (ATA Secure Erase), nwipe (DBAN-like) |
| **Sistemas de archivos** | ext2/3/4, NTFS (NTFS-3G), FAT16/32, exFAT, Btrfs, XFS, JFS, ReiserFS, F2FS |
| **Diagnóstico** | smartctl, hdparm, memtest86+, lshw, dmidecode |
| **Red** | Firefox, FileZilla, SSH, Samba, navegador web |
| **Cifrado** | LUKS, cryptsetup |
| **Arranque** | CD/USB directo, instalación frugal, PXE |

## Requisitos del sistema

| Componente | Mínimo |
|---|---|
| **CPU** | i686 compatible (x86 y x86-64) |
| **RAM** | 512 MB |
| **Arquitecturas** | x86, x86-64 |

## Instalación en USB

Parted Magic se vende como ISO descargable. Para crear un USB booteable:

```bash
# Método 1: dd (Linux/macOS)
sudo dd if=partedmagic.iso of=/dev/sdX bs=4M status=progress

# Método 2: balenaEtcher (multi-plataforma)
# Método 3: Rufus (Windows)
```

## Uso típico

### 1. Recuperar datos de un disco dañado

```bash
# Arrancar Parted Magic
# Abrir terminal
# Clonar disco dañado a uno sano (evitar más lecturas)
sudo ddrescue -f /dev/sda /dev/sdb rescue.map

# Montar el disco clonado y extraer datos
sudo mount /dev/sdb1 /mnt
```

### 2. Borrado seguro de disco (ATA Secure Erase)

```bash
# Verificar soporte de Secure Erase
sudo hdparm -I /dev/sda | grep -i erase

# Ejecutar borrado seguro
sudo hdparm --user-master u --security-set-pass p /dev/sda
sudo hdparm --user-master u --security-erase p /dev/sda
```

### 3. Redimensionar partición NTFS

```bash
# Usar GParted gráficamente, o desde terminal:
sudo ntfsresize /dev/sda1 -s 100G   # redimensionar a 100GB
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No arranca desde USB | BIOS no configurado o ISO mal grabada | Verificar Secure Boot desactivado, regrabar ISO |
| Disco no detectado | Controlador SATA en modo RAID | Cambiar a AHCI en BIOS |
| No puede montar NTFS | Partición no desmontada limpiamente (dirty) | `sudo ntfsfix /dev/sda1`, luego montar |

## Alternativas

| Herramienta | Precio | Ventaja |
|---|---|---|
| **Parted Magic** | ~11$ | Completo, fácil, herramientas propietarias |
| **SystemRescue** | Gratis | Muy completo, basado en Arch, paquetes actualizados |
| **GParted Live** | Gratis | Enfocado en particionado, muy estable |
| **Hiren's Boot CD** | Gratis | Enfoque Windows + Linux |

## Notas personales

- Vale la pena tener una ISO de rescate siempre a mano en un USB
- Parted Magic es de pago (~11$), pero **SystemRescue** (gratuito) cubre el 95% de las mismas necesidades
- La función más útil: ATA Secure Erase para borrar SSDs de forma irreversible antes de venderlos
- Para recuperación de datos seria, combinar con `ddrescue` + `TestDisk` + `PhotoRec`

## Enlaces externos

- [Sitio oficial Parted Magic](https://partedmagic.com/)
- [Wikipedia — Parted Magic](https://es.wikipedia.org/wiki/Parted_Magic)
- [SystemRescue (alternativa gratuita)](https://www.system-rescue.org/)
- [GParted Live](https://gparted.org/livecd.php)

## Ver también

- [[Creación de USB Booteable]] — cómo crear USBs de rescate
- [[Particionado y Esquemas de Disco]] — conceptos de particionado
- [[Sistemas de Archivos]] — compatibilidad con diferentes FS
- [[dd]] — clonado de discos a bajo nivel

#programa #rescate #particiones
