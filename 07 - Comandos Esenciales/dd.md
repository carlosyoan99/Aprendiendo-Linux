---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# dd

## Sintaxis
```
dd if=origen of=destino [opciones]
```

## Descripción
Copia datos a nivel de bloques, byte por byte. Se usa para clonar discos, crear USBs booteables, hacer imágenes ISO de CDs/DVDs, o benchmarks de disco. Opera a bajo nivel — no le importa el sistema de archivos, solo los bytes.

La sintaxis usa `if=` (input file) y `of=` (output file) en vez de flags tradicionales.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `if=<archivo>` | Origen (input file) |
| `of=<archivo>` | Destino (output file) |
| `bs=<N>` | Tamaño de bloque en bytes (ej. `bs=4M`) |
| `count=<N>` | Copiar solo N bloques (útil para probar) |
| `status=progress` | Muestra progreso durante la copia (importante) |
| `conv=fsync` | Forzar escritura física antes de terminar |
| `seek=<N>` | Saltar N bloques en el destino |
| `skip=<N>` | Saltar N bloques en el origen |

## Ejemplos
```bash
# Crear USB booteable
sudo dd if=debian.iso of=/dev/sdb bs=4M status=progress conv=fsync

# Clonar disco completo
sudo dd if=/dev/sda of=/dev/sdb bs=4M status=progress

# Crear imagen de un disco/partición
sudo dd if=/dev/sda of=backup_disco.img bs=4M status=progress

# Benchmark de escritura (prueba rápida)
dd if=/dev/zero of=test bs=1M count=1024 status=progress   # escribe 1GB

# Benchmark de lectura
dd if=test of=/dev/null bs=1M status=progress

# Borrar disco de forma segura (escribe ceros en todo el disco)
sudo dd if=/dev/zero of=/dev/sdb bs=4M status=progress

# Crear archivo de swap (alternativa a fallocate)
sudo dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Reparar MBR dañado (respaldar/restaurar primeros 512 bytes)
sudo dd if=/dev/sda of=mbr_backup.bin bs=512 count=1
```

## Notas y advertencias
- **dd puede destruir datos si te equivocas de `of=`**. Siempre verificar 3 veces que `if` y `of` sean correctos. Un `dd if=/dev/sda of=/dev/sdb` equivocado puede borrar el disco equivocado.
- `status=progress` es esencial para saber cuánto falta (en versiones recientes de dd).
- `conv=fsync` fuerza que los datos se escriban físicamente antes de que dd termine (evita datos en caché no escritos).
- No hay barra de progreso nativa en dd antiguos. En esos casos, enviar señal `USR1` al proceso: `kill -USR1 $(pidof dd)` muestra el progreso actual.
- Para clonar discos, alternativas más seguras y rápidas: `Clonezilla`, `ddrescue` (salta sectores dañados), `partclone`.
- El tamaño de bloque (`bs`) alto (4M, 8M, 16M) acelera la copia porque reduce los saltos entre kernel y userspace.

## Ver también
- [[rsync]] — copia incremental de archivos (más segura para backups)
- [[tar]] — empaquetado de archivos
- [[cp]] — copia normal de archivos
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — dd](https://en.wikipedia.org/wiki/Dd_(command))
- [GNU Coreutils — dd manual](https://www.gnu.org/software/coreutils/manual/html_node/dd-invocation.html)

#comando
