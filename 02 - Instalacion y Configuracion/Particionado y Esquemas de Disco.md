---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: instalacion
prioridad: media
---

# Particionado y Esquemas de Disco

## Definición

Particionar un disco significa dividirlo en secciones lógicas independientes, cada una con su propio sistema de archivos o propósito (swap, datos, sistema). Linux puede (y suele) montar varias particiones en distintos puntos del árbol `/`.

## Tabla de particiones: MBR vs GPT

| Característica | MBR (msdos) | GPT |
|---|---|---|
| Máximo discos | 2 TB | 9.4 ZB |
| Particiones primarias | 4 (o 3 + extended) | 128 por defecto |
| Compatibilidad | Universal (BIOS y UEFI) | Solo UEFI (para bootear), aunque datos en cualquier sistema |
| ¿Se usa hoy? | Solo en sistemas legacy/BIOS | Estándar moderno — usarlo si no hay razón para no hacerlo |

```bash
# Ver esquema de particiones
sudo fdisk -l /dev/sda        # muestra el tipo: "Disklabel type: gpt" o "dos"
sudo parted /dev/sda print    # alternativa más detallada
```

## Sistemas de archivos comunes

| FS | Ideal para | Características |
|---|---|---|
| **ext4** | Raíz y datos — el estándar | Estable, rápido, compatible con casi todo. Usar si no sabes cuál elegir |
| **btrfs** | Raíz si quieres snapshots/compresión | Subvolúmenes, snapshots (rollback), compresión transparente, COW |
| **xfs** | Grandes archivos / servidores | Buen rendimiento con archivos grandes, pero no se puede reducir de tamaño |
| **FAT32** | Partición EFI (forzado por UEFI) | Máximo 4 GB por archivo |
| **NTFS** | Discos compartidos con Windows | Soporte de lectura/escritura con `ntfs-3g` |

```bash
# Formatear particiones
sudo mkfs.ext4 /dev/sda2                    # ext4
sudo mkfs.btrfs /dev/sda2                   # btrfs
sudo mkfs.fat -F32 /dev/sda1                # FAT32 para EFI
```

## Esquemas típicos

### 1. Escritorio simple (lo más común)

| Partición | Tamaño | Punto de montaje | FS | Nota |
|---|---|---|---|---|
| EFI | 512 MB | `/boot/efi` (o `/boot`) | FAT32 | Obligatoria en UEFI |
| Root | resto del disco | `/` | ext4 o btrfs | TODO en una partición |
| Swap | (ver abajo) | - | swap | Archivo de swap recomendado sobre partición |

### 2. Separación /home (útil para reinstalar)

| Partición | Tamaño | Punto de montaje | Nota |
|---|---|---|---|
| EFI | 512 MB | `/boot/efi` | |
| Root | 40-80 GB | `/` | Suficiente para SO + programas |
| Home | resto | `/home` | Tus datos sobreviven a reinstalaciones |
| Swap | según RAM | - | |

```bash
# Separar /home te permite reinstalar la distro sin perder config y archivos
# Solo formateas la partición root y mantienes /home intacta
```

### 3. Dual boot (Linux + Windows)

```
Esquema en disco (simplificado):
┌──────────┬──────────┬──────────┬──────────┐
│ Win EFI  │ Win C:\  │ Linux EFI│ Linux /  │
│ (FAT32)  │ (NTFS)   │ (FAT32)  │ (ext4)   │
├──────────┴──────────┴──────────┴──────────┤
│           Espacio libre contiguo            │
└────────────────────────────────────────────┘
```
Ver [[Dual Boot con Windows]].

## Swap: ¿Partición, archivo o zram?

| Opción | Renderimiento | Flexibilidad | Recomendado para |
|---|---|---|---|
| **Partición swap** | Excelente | Baja (difícil de redimensionar) | Instalaciones con disco tradicional |
| **Archivo de swap** | Bueno | Alta (se crea/redimensiona sobre la marcha) | Distros que lo soportan out-of-the-box (Ubuntu, Fedora) |
| **zram** | Muy bueno | Alta | Sistemas con suficiente RAM y sin necesidad de hibernar |

```bash
# Crear archivo de swap (alternativa moderna a partición)
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
# persistir en /etc/fstab: /swapfile none swap sw 0 0
```

**Regla práctica**: si tienes ≥ 8 GB RAM, el swap difícilmente se usará (salvo hibernación). Con poca RAM, swap = tamaño de RAM × 1.5-2 como regla clásica, aunque hoy se recomienda más conservadoramente: swap = RAM si hibernas, 2-4 GB si no.

## Herramientas de particionado

| Herramienta | Tipo | Notas |
|---|---|---|
| `fdisk` | Terminal (CLI) | Clásica, estable, menú interactivo |
| `cfdisk` | Terminal (semi-GUI) | Más amigable que fdisk, basada en curses |
| `parted` / `gdisk` | Terminal (CLI) | `parted` para GPT/MBR, `gdisk` solo GPT |
| `lsblk` | Terminal | Solo listar, no modificar — esencial para identificar discos |
| `blkid` | Terminal | Ver UUID y tipo de FS de cada partición |
| GParted | Gráfico (GUI) | Si estás desde un live USB con entorno gráfico |

```bash
# Flujo típico con cfdisk (más amigable)
lsblk                          # identificar el disco (ej. /dev/sda)
sudo cfdisk /dev/sda           # particionar interactivamente
sudo mkfs.ext4 /dev/sda2       # formatear la partición root
sudo mount /dev/sda2 /mnt      # montar para instalar
```

## LVM (Logical Volume Manager)

Permite tener **volúmenes lógicos** que cruzan discos físicos y se redimensionan en caliente. Útil en servidores, pero overkill en escritorio a menos que sepas que lo necesitas.

```bash
# Concepto: Disco Físico (PV) → Grupo de Volúmenes (VG) → Volumen Lógico (LV)
# Extensión: lvm2, system-storage-manager
```

## Por qué importa

Elegir bien el particionado al instalar evita dolores de cabeza después:
- No poder Redimensionar `/` por falta de espacio (sin herramientas complejas)
- No poder reinstalar sin perder datos
- Que el sistema se ponga lento porque el swap está en un disco lento, o falta

## Notas de instalación propias

-

## Enlaces externos

- [Wikipedia — Partition (file system)](https://en.wikipedia.org/wiki/Disk_partitioning)
- [Arch Wiki — Partitioning](https://wiki.archlinux.org/title/Partitioning)
- [Wikipedia — GPT](https://en.wikipedia.org/wiki/GUID_Partition_Table)

## Ver también

- [[Proceso de Instalacion General]]
- [[Dual Boot con Windows]]
- [[Creacion de USB Booteable]]

#instalacion #particiones
