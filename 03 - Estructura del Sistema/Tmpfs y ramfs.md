---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: sistema
prioridad: media
---

# Tmpfs y ramfs

> Sistemas de archivos en memoria. Tmpfs usa RAM + swap (con límite configurable), ramfs es puro RAM sin límite. Base de /tmp, /dev/shm y zram swap.

## Qué son

| Filesystem | RAM | Swap | Límite | Persiste al reiniciar |
|---|---|---|---|---|
| **tmpfs** | ✅ | ✅ (puede verter a swap) | Configurable | ❌ |
| **ramfs** | ✅ | ❌ | Sin límite (crece libremente) | ❌ |
| **zram** | ✅ (comprimido) | ❌ | Configurable | ❌ (bloque virtual) |

**Diferencia clave**: tmpfs tiene un tamaño fijo (se configura al montar) y puede usar swap si se llena. ramfs no tiene límite y si se llena puede causar OOM killer.

## Montajes típicos

```bash
# Ver mounts actuales
mount | grep -E "tmpfs|ramfs"

# Salida típica:
# tmpfs on /run type tmpfs (rw,nosuid,nodev,noexec,mode=755)
# tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
# tmpfs on /tmp type tmpfs (rw,nosuid,nodev,nr_inodes=1048576)
# tmpfs on /run/user/1000 type tmpfs (rw,nosuid,nodev,relatime,size=1638400k)
```

## /dev/shm (shared memory)

```bash
# /dev/shm es tmpfs — usado para IPC de alta velocidad
df -h /dev/shm
# Filesystem      Size  Used Avail Use% Mounted on
# tmpfs           3.9G     0  3.9G   0% /dev/shm

# Crear archivo compartido entre procesos
echo "datos" > /dev/shm/mi-archivo
```

## /tmp en tmpfs

```bash
# En muchas distros, /tmp es tmpfs (rápido, se limpia al reiniciar)
# Verificar:
stat -f /tmp | grep Type
# Type: tmpfs

# Montar /tmp como tmpfs manualmente (si no lo está)
sudo mount -t tmpfs -o size=2G tmpfs /tmp
```

## Crear tmpfs manualmente

```bash
# Montar tmpfs con tamaño fijo
sudo mount -t tmpfs -o size=512m tmpfs /mnt/ramdisk

# Verificar
df -h /mnt/ramdisk
# tmpfs           512M     0  512M   0% /mnt/ramdisk

# Desmontar
sudo umount /mnt/ramdisk
```

## Relación con zram

zram crea dispositivos de bloque comprimidos en RAM. Se usa como **swap comprimido**, no como filesystem directo. Complementa tmpfs:

```
┌─────────────────────────────────────┐
│           Aplicaciones              │
├──────────────┬──────────────────────┤
│   tmpfs      │     zram swap        │
│  (RAM real)  │  (RAM comprimida)    │
│  /tmp, /run  │  swap alternativo    │
├──────────────┴──────────────────────┤
│         RAM física                  │
└─────────────────────────────────────┘
```

Ver [[zram]] para configuración detallada.

## Casos de uso

### Directorio temporal de alto rendimiento
```bash
# Para procesamiento de video temporal
sudo mount -t tmpfs -o size=4G tmpfs /tmp/processing
ffmpeg -i input.mp4 -f null /tmp/processing/output.bin
sudo umount /tmp/processing
```

### Cache de compilación
```bash
# compilar en RAM para máxima velocidad
sudo mount -t tmpfs -o size=8G tmpfs /tmp/build
cp -r /path/to/source /tmp/build/
cd /tmp/build && make -j$(nproc)
```

## Ver también

- [[zram]] — swap comprimido en RAM
- [[Sistemas de Archivos]] — visión general de filesystems
- [[Procesos y Senales]] — IPC y shared memory
- [[Optimización de rendimiento]] — tuning de memoria

## Enlaces externos

- [Arch Wiki — tmpfs](https://wiki.archlinux.org/title/Tmpfs)
- [man tmpfs(5)](https://man7.org/linux/man-pages/man5/tmpfs.5.html)
- [Wikipedia — tmpfs](https://en.wikipedia.org/wiki/Tmpfs)

#sistema #archivos
