---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# GParted

> Editor gráfico de particiones para crear, mover, redimensionar, formatear y copiar particiones en discos.

## Qué es

**GParted** (GNOME Partition Editor) es la herramienta gráfica más popular para gestionar particiones en Linux. Utiliza libparted por debajo y soporta una amplia variedad de sistemas de archivos (ext2/3/4, Btrfs, XFS, FAT32, NTFS, etc.). Es especialmente útil para operaciones visuales donde ver el layout del disco ayuda a evitar errores.

**Casos de uso típicos:**
- Redimensionar particiones sin perder datos
- Crear particiones nuevas para dual boot
- Formatear discos/USB
- Mover particiones para liberar espacio contiguo
- Copiar particiones de un disco a otro

## Instalación

```bash
# Debian/Ubuntu
sudo apt install gparted

# Arch / CachyOS
sudo pacman -S gparted

# Fedora
sudo dnf install gparted

# openSUSE
sudo zypper install gparted
```

## Uso

```bash
gparted        # requiere permisos de administración (polkit)
```

## Operaciones disponibles

| Operación | Descripción |
|---|---|
| `New` | Crear nueva partición en espacio libre |
| `Resize/Move` | Cambiar tamaño o posición de una partición |
| `Format` | Formatear con un FS (ext4, btrfs, ntfs, fat32...) |
| `Copy/Paste` | Duplicar una partición en otro espacio libre |
| `Delete` | Eliminar una partición |
| `Check` | Verificar errores del sistema de archivos |
| `Label` | Asignar nombre a la partición |
| `Flags` | Marcar partición (boot, esp, lba, hidden) |

> ⚠️ **Advertencia**: redimensionar o mover particiones puede destruir datos. Haz respaldo antes y evita operaciones sobre particiones montadas.

## Uso avanzado

### Redimensionar sin perder datos

1. Desmontar la partición (o arrancar desde Live USB si es la raíz)
2. Click derecho → Resize/Move
3. Arrastrar el borde o introducir tamaño exacto
4. Pulsar "Apply All Operations" (⋮)

### Crear partición para dual boot

1. Seleccionar espacio libre
2. New → tamaño, tipo (primary/logical), FS
3. Marcar flag `boot` o `esp` para UEFI
4. Apply

### Copiar una partición a otro disco

1. Click derecho en la partición origen → Copy
2. Seleccionar espacio libre en el disco destino
3. Paste → Adjustar tamaño si es necesario
4. Apply

> **Tip**: para clonar discos completos, `dd` o `rsync` son más eficientes que copiar partición por partición.

## Comparativa con alternativas

| Aspecto | GParted | parted (CLI) | fdisk (CLI) | KDE Partition Manager |
|---|---|---|---|---|
| **Interfaz** | Gráfica (GTK) | Línea de comandos | Línea de comandos | Gráfica (Qt) |
| **Operaciones visuales** | ✅ Arrastrar | ❌ | ❌ | ✅ Arrastrar |
| **Live USB** | ✅ Incluido en ISOs | Depende | Depende | ✅ |
| **Btrfs snapshots** | ❌ | ❌ | ❌ | ❌ |
| **LVM** | ❌ | ❌ | ❌ | Parcial |
| **Velocidad** | Media | Rápida | Rápida | Media |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Partición montada, no se puede modificar | FS activo | Desmontar: `sudo umount /dev/sdXn` o usar Live USB |
| "Could not mount" tras resize | Error de consistencia | `sudo fsck -f /dev/sdXn` y reintentar |
| No ve discos NVMe | Falta soporte udev | Actualizar GParted: `sudo apt update && sudo apt upgrade` |
| Operación muy lenta en Btrfs | Btrfs requiere desmontar | Desmontar siempre Btrfs antes de redimensionar |

## Veronces

- [[Particionado y Esquemas de Disco]] — conceptos previos
- [[snapper]] — snapshots de Btrfs (protección ante errores)
- [[timeshift]] — respaldo del sistema
- [[Backups (borg restic duplicity rsync)]] — respaldos antes de tocar particiones

## Enlaces externos

- [Sitio oficial](https://gparted.org/)
- [Documentación GParted](https://gparted.org/display-doc.php?name=help-manual)
- [Arch Wiki — GParted](https://wiki.archlinux.org/title/GParted)
- [Wikipedia — GParted](https://en.wikipedia.org/wiki/GParted)

## Notas personales

- En CachyOS con Btrfs, siempre desmontar antes de operar. `snapper` cubre la protección de datos.
- Para Live USB, la ISO de GParted incluye la herramienta preinstalada.

#programa #particiones #disco
