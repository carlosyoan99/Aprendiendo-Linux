---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# lsblk

> Lista información sobre todos los dispositivos de bloque disponibles (discos, particiones, LVM, loop, etc.). Esencial para identificar discos antes de montarlos, particionarlos o formatearlos.

## Sintaxis

```bash
lsblk [opciones] [dispositivo]
```

## Descripción

`lsblk` (list block devices) muestra los dispositivos de bloque en formato de árbol, con sus relaciones jerárquicas. Lee información de `/sys/` y `udev` — es rápido, legible y no necesita `sudo` para información básica.

Es el primer comando que usar al conectar un disco nuevo, USB o SSD, para identificar su nombre (`sda`, `sdb`, `nvme0n1`, etc.).

## Formato de salida

```bash
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 238.5G  0 disk
├─sda1        8:1    0   512M  0 part /boot/efi
├─sda2        8:2    0 237.1G  0 part /
└─sda3        8:3    0   976M  0 part [SWAP]
nvme0n1     259:0    0 465.8G  0 disk
└─nvme0n1p1 259:1    0 465.8G  0 part /home
```

| Columna | Significado |
|---|---|
| **NAME** | Nombre del dispositivo (sda, nvme0n1, loop0, etc.) |
| **MAJ:MIN** | Número major:minor del dispositivo |
| **RM** | Removable? (0=no, 1=sí, ej. USB) |
| **SIZE** | Tamaño total (humano: K, M, G, T) |
| **RO** | Read-only? (0=lectura/escritura, 1=solo lectura) |
| **TYPE** | disk, part (partition), rom, loop, lvm, crypt |
| **MOUNTPOINT** | Dónde está montado (vacío si no montado) |

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-f` | Mostrar sistema de archivos y UUID | `lsblk -f` |
| `-o` | Columnas personalizadas | `lsblk -o NAME,SIZE,FSTYPE,UUID,MOUNTPOINT` |
| `-l` | Formato de lista (no árbol) | `lsblk -l` |
| `-p` | Rutas completas (/dev/sda en vez de sda) | `lsblk -p` |
| `-t` | Topología (jerarquía de dispositivos) | `lsblk -t` |
| `-S` | Solo dispositivos SCSI (discos USB/SATA) | `lsblk -S` |
| `-d` | Solo discos (sin particiones) | `lsblk -d` |
| `-n` | Sin encabezados (para scripting) | `lsblk -n -o NAME` |
| `-J` | Salida en JSON | `lsblk -J` |
| `-i` | Sin indentación ASCII (solo espacios) | `lsblk -i` |
| `--exclude 1,7` | Excluir tipos (1=loop, 7=ram) | `lsblk --exclude 7` |
| `-e 7` | Excluir dispositivos tipo (loop, ram) | `lsblk -e7` |
| `--output-all` | Todas las columnas disponibles | `lsblk --output-all` |

## Ejemplos

```bash
# 1. Vista general (árbol)
lsblk

# 2. Ver sistemas de archivos y UUID (antes de montar)
lsblk -f
# NAME   FSTYPE LABEL UUID                 MOUNTPOINT
# sda
# ├─sda1 vfat         A1B2-3C4D            /boot/efi
# └─sda2 ext4         a1b2c3d4-...         /

# 3. Solo discos físicos (sin loop, ram, etc.)
lsblk -d -e7

# 4. Columnas específicas para scripting
lsblk -n -o NAME,SIZE,TYPE | grep disk

# 5. Identificar un USB recién conectado
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,RM
# RM=1 indica dispositivo removible — tu USB

# 6. Tamaño total de cada disco
lsblk -d -o NAME,SIZE -n

# 7. Salida JSON (para procesar con jq)
lsblk -J | jq '.blockdevices[] | {name: .name, size: .size, type: .type, mountpoint: .mountpoint}'

# 8. Ver todos los discos con modelo y serial
lsblk -o NAME,MODEL,SERIAL,SIZE,TYPE

# 9. Información de un disco específico
lsblk /dev/sda -f

# 10. Listado sin árbol
lsblk -l
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Conecté un USB, ¿cómo se llama?** | `lsblk -o NAME,SIZE,TYPE,RM` (RM=1 = USB) |
| **Antes de particionar, ver estructura actual** | `lsblk -f` |
| **¿Cuál es el UUID de la partición root?** | `lsblk -o NAME,UUID,MOUNTPOINT -f \| grep '/$'` |
| **¿Qué discos tengo conectados?** | `lsblk -d -o NAME,SIZE,MODEL` |
| **Identificar disco NVMe vs SATA** | `lsblk -t` (topología) |
| **Verificar que un disco nuevo se detectó** | `lsblk \| grep sd` |
| **Scripting: obtener el primer disco** | `lsblk -d -n -o NAME \| head -1` |

## Combinaciones comunes con pipe

```bash
# Obtener el nombre del disco root
lsblk -n -o NAME,MOUNTPOINT | grep '/$' | awk '{print $1}' | sed 's/[0-9]*$//'

# Listar solo discos físicos (sin loop, ram, rom)
lsblk -d -n -o NAME,TYPE | grep -E 'disk$' | awk '{print $1}'

# Ver sistemas de archivos como tabla compacta
lsblk -f | grep -E '^(sd|nvme|vd|xvd)'

# Contar discos físicos
lsblk -d -n -o TYPE | grep -c disk

# Exportar UUIDs de todas las particiones (para fstab)
lsblk -n -o UUID,MOUNTPOINT -f | grep -v '^$'
```

## Alternativas modernas

| Herramienta | Ventaja |
|---|---|
| `lsblk` | La herramienta estándar moderna — reemplaza a `fdisk -l` para inspeccionar |
| `blkid` | Muestra UUID, LABEL y tipo de FS (más detalle que `lsblk -f`) |
| `findmnt` | Muestra puntos de montaje en árbol (similar a `lsblk` pero enfocado en montajes) |
| `fdisk -l` | Legacy — más verboso, menos legible |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `lsblk: /dev/sdx: not a block device` | El dispositivo no existe o no es de bloque | Verificar nombre con `lsblk` sin argumentos |
| No aparece un USB recién conectado | No se detectó o no tiene drivers | `sudo dmesg \| tail` para ver si el kernel lo detectó |
| Muestra muchos `loop*` dispositivos | Snap o AppImage crean loop devices | Filtrar con `lsblk -e7` o `lsblk \| grep -v loop` |
| `lsblk` no muestra UUID | La partición no tiene sistema de archivos | Formatear primero: `sudo mkfs.ext4 /dev/sdb1` |
| Diferencia entre `sda` y `nvme0n1` | sda = SATA/SCSI, nvme0n1 = NVMe (M.2) | Ambos son discos — NVMe usa nombres más largos (`nvme0n1p1` = partición 1) |

## Notas y advertencias

- **No necesita `sudo`** para info básica. Para ver detalles de sectores dañados (`lsblk -S`), sí.
- **`lsblk -f`** es probablemente el uso más común: muestra de un vistazo qué sistema de archivos tiene cada partición y su UUID.
- **Los nombres pueden cambiar**: `/dev/sda` hoy puede ser `/dev/sdb` mañana si conectas otro disco. Usar UUID en `/etc/fstab` en lugar de `/dev/sdX`.
- **Dispositivos loop**: Snap y AppImage crean muchos `/dev/loopN`. No son discos reales. Usar `lsblk -e7` para excluirlos.
- **nvme0n1** significa: NVMe controller 0, namespace 1. Las particiones son `nvme0n1p1, nvme0n1p2...`.

## Enlaces externos

- [Wikipedia — lsblk](https://en.wikipedia.org/wiki/Lsblk)
- [Linux man page — lsblk(8)](https://man.archlinux.org/man/lsblk.8)
- [util-linux — lsblk](https://www.kernel.org/pub/linux/utils/util-linux/)

## Ver también

- [[mount]] — montar sistemas de archivos
- [[df y du]] — espacio en disco usado/disponible
- [[Particionado y Esquemas de Disco]] — guía de particionado
- [[Sistemas de Archivos]] — tipos de FS
- [[Cheat Sheet - Comandos Esenciales]]

#comando #util-linux
