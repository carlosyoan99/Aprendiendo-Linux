---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: comando
prioridad: alta
---

# mount / umount

## Sintaxis
```bash
mount [opciones] dispositivo directorio
umount [opciones] directorio|dispositivo
```

## Descripción
`mount` monta sistemas de archivos (discos, USB, ISOs) en el árbol de directorios. `umount` los desmonta. El archivo `/etc/fstab` define los montajes permanentes que se activan al arrancar.

## Opciones frecuentes de mount
| Flag | Efecto |
|------|--------|
| `-t tipo` | Tipo de FS (ext4, ntfs, vfat, etc.) |
| `-o opciones` | Opciones de montaje separadas por coma |
| `-a` | Monta todo lo definido en /etc/fstab |
| `-L etiqueta` | Montar por etiqueta |
| `-U UUID` | Montar por UUID |
| `--bind` | Montar un directorio en otra ruta |
| `-r` | Montar solo lectura (read-only) |

## Ejemplos de mount
```bash
# Montar un disco/USB
sudo mount /dev/sda1 /mnt                    # montar partición sda1 en /mnt
sudo mount -t ext4 /dev/sda2 /mnt            # especificando tipo de FS

# Montar con opciones
sudo mount -o rw,noatime /dev/sda1 /mnt      # lectura/escritura + noatime
sudo mount -o ro /dev/sda1 /mnt               # solo lectura
sudo mount -o uid=1000,gid=1000 /dev/sda1 /mnt # forzar propietario (FAT/NTFS)

# Montar por UUID (recomendado, no cambia)
sudo mount UUID="a1b2c3d4-e5f6-..." /mnt

# Montar ISO
sudo mount -o loop imagen.iso /mnt/iso

# Bind mount (un directorio aparece en otra ruta)
sudo mount --bind /var/www /home/user/www

# Montar todo lo de fstab
sudo mount -a
```

## umount
```bash
sudo umount /mnt                             # desmontar por punto de montaje
sudo umount /dev/sda1                        # desmontar por dispositivo
sudo umount -l /mnt                          # lazy: desmontar cuando no esté en uso
sudo umount -f /mnt                          # forzar (si NFS o dispositivo no responde)

# Si dice "target is busy":
lsof /mnt                                    # qué proceso está usando el directorio
fuser -m /mnt                                # qué PIDs lo están usando
sudo fuser -km /mnt                          # matar procesos y desmontar
```

## /etc/fstab — Montajes permanentes

```bash
# Formato: <dispositivo>  <punto-montaje>  <tipo>  <opciones>  <dump>  <pass>
UUID=xxxx-xxxx  /  ext4  defaults,noatime  0  1
```

| Campo | Descripción | Ejemplo |
|---|---|---|
| **Dispositivo** | Partición (preferir UUID sobre /dev/sdX) | `UUID=a1b2...` o `LABEL=DISCO1` |
| **Punto de montaje** | Directorio donde se monta | `/`, `/home`, `/mnt/datos` |
| **Tipo** | Sistema de archivos | `ext4`, `btrfs`, `ntfs3`, `vfat`, `swap` |
| **Opciones** | Flags de montaje separados por coma | `defaults,noatime,compress=zstd` |
| **dump** | ¿Hacer backup con dump? (0=no) | `0` |
| **pass** | Orden de fsck al arrancar (0=no, 1=root, 2=resto) | `1` para `/`, `2` para otros |

### UUID vs Etiquetas

```bash
# Obtener UUID y LABEL de todas las particiones
sudo blkid
# /dev/sda1: UUID="A1B2-..." TYPE="vfat" PARTLABEL="EFI"
# /dev/sda2: UUID="a1b2c3..." TYPE="ext4" LABEL="ROOT"

# Ventajas de UUID:
# - No cambia aunque conectes el disco a otro puerto SATA
# - No hay ambigüedad (los LABEL pueden duplicarse)
```

### Opciones de montaje comunes

| Opción | Efecto |
|---|---|
| `defaults` | rw, suid, dev, exec, auto, nouser, async |
| `noatime` | No actualizar tiempo de acceso (más rápido) |
| `nodiratime` | No actualizar tiempo de acceso de directorios |
| `relatime` | Actualizar atime si es anterior a mtime/ctime (equilibrio) |
| `compress=zstd` | Compresión transparente (Btrfs) |
| `noexec` | No permitir ejecución de binarios |
| `nosuid` | Ignorar bits SUID/SGID |
| `nodev` | No permitir dispositivos |
| `uid=1000,gid=1000` | Forzar propietario (para FAT/NTFS) |
| `umask=022` | Permisos por defecto (para FAT/NTFS) |
| `discard` | Activar TRIM en SSD (o usar `fstrim` periódicamente) |

### Ejemplos de /etc/fstab

```bash
# /etc/fstab — sistema de archivos estándar
UUID=a1b2c3d4-...  /              ext4    defaults,noatime          0  1
UUID=e5f6a7b8-...  /home          ext4    defaults,noatime          0  2
UUID=a1b2-...      /boot/efi      vfat    umask=0077                0  2

# Swap como archivo (no partición)
/swapfile          none           swap    sw                         0  0

# Disco NTFS compartido con Windows
UUID=XXXX...       /mnt/datos     ntfs3   uid=1000,gid=1000,dmask=022,fmask=133  0  0

# Montar ISO al arranque
/opt/imagen.iso    /mnt/iso       iso9660 loop,ro                    0  0

# Montaje remoto NFS
servidor:/export   /mnt/nfs       nfs4    _netdev,noatime            0  0

# tmpfs en RAM (rápido, se borra al apagar)
tmpfs              /mnt/ram       tmpfs   defaults,size=1G           0  0
```

### Troubleshooting de fstab

```bash
# Probar sintaxis de fstab sin montar todo
sudo mount -a                             # montar todo — si hay error, muestra qué falló
findmnt                                   # ver todos los montajes activos en árbol
findmnt /                                 # ver qué dispositivo tiene montado /

# Error de UUID incorrecto
sudo blkid                                # verificar UUID actual
# Si cambiaste de disco, actualiza el UUID en /etc/fstab

# Error de montaje al arrancar (modo recovery)
# Arrancar en modo recovery y comentar la línea en /etc/fstab
```

## Ver también
- [[Particionado y Esquemas de Disco]] — particionar antes de montar
- [[lsblk]] — identificar dispositivos de bloque
- [[SSH]] — montar remoto vía SSHFS
- [[Filesystem Hierarchy Standard]] — puntos de montaje
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — mount](https://en.wikipedia.org/wiki/Mount_(command))
- [util-linux — mount manual](https://man7.org/linux/man-pages/man8/mount.8.html)

#comando