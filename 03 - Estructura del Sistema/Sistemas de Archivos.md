---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: sistema
prioridad: alta
---

# Sistemas de Archivos

## ¿Qué es un sistema de archivos?

Es el método que usa el kernel para organizar, almacenar y recuperar datos en un disco. Determina:

- **Cómo se estructuran** los archivos y directorios (inodos, árboles B, etc.)
- **Integridad**: si detecta corrupción de datos (checksums, copy-on-write)
- **Rendimiento**: velocidad en lecturas/escrituras, archivos grandes vs pequeños
- **Características**: snapshots, compresión, deduplicación, cifrado

Cada sistema de archivos tiene sus fortalezas. No hay uno "mejor" — depende del caso de uso.

---

## Familia ext: evolución (ext → ext2 → ext3 → ext4)

La familia **ext** (Extended File System) es la más longeva de Linux. Nació en 1992 con el primer FS diseñado específicamente para Linux y ha evolucionado hasta ext4, el estándar actual en la mayoría de las distros.

### Timeline

| FS | Año | Creador | Innovación clave | Estado |
|---|---|---|---|---|
| **ext** | 1992 | Rémy Card | Primer FS específico para Linux, reemplazó a Minix FS. Usaba VFS. Máx: 2 GB | ❌ Histórico |
| **ext2** | 1993 | Rémy Card | Sin journaling. Inodos dinámicos, bloques 512B-4KiB. Máx archivo: 2 TB | ❌ Obsoleto |
| **ext3** | 2001 | Stephen Tweedie | Journaling (ordered/journal/writeback). Migración sin formateo desde ext2. HTree | ❌ Obsoleto |
| **ext4** | 2008 | Andrew Morton, Theodore Ts'o | Extents, delayed allocation, 16 TB archivo, 1 EiB volumen, journal checksums | ✅ Estándar |

### ext — El origen (1992)

Primer sistema de archivos diseñado específicamente para Linux, por Rémy Card. Usó la interfaz VFS añadida al kernel 0.96c. Podía manejar hasta 2 GB. Reemplazado por ext2 al año siguiente.

### ext2 — Sin journal (1993)

FS por defecto de Red Hat Linux, Fedora Core y Debian durante años. Sin journaling: un corte de energía requería `fsck` completo (lento en discos grandes). Base para ext3: se podía migrar sin formatear.

```bash
# Crear ext2 (aún usado para particiones /boot en algunos sistemas)
sudo mkfs.ext2 /dev/sda1
```

### ext3 — Journaling retrocompatible (2001)

Añadió **journaling** a ext2 manteniendo compatibilidad total: un FS ext3 podía montarse como ext2. Fue el FS más usado en Linux durante la década del 2000.

**Modos de journaling:**

| Modo | Descripción | Riesgo | Velocidad |
|---|---|---|---|
| `data=journal` | Datos y metadatos al journal primero | Bajo | Lento (datos 2× escritura) |
| `data=ordered` (default) | Metadatos al journal, datos se escriben antes | Medio | Moderado |
| `data=writeback` | Solo metadatos al journal, datos sin orden | Alto | Rápido |

**Limitaciones:** máx. 32,000 subdirectorios, sin extents, sin desfragmentación online, sin checksums en journal.

```bash
# Migrar de ext2 a ext3 (añadir journal, online)
sudo tune2fs -j /dev/sda1
# Convertir ext3 a ext2 (quitar journal, requiere desmontar)
sudo tune2fs -O ^has_journal /dev/sda1
sudo fsck.ext2 -f /dev/sda1
```

### ext4 — Mejoras sobre ext3 (2008)

```bash
# Migrar de ext3 a ext4 (online, irreversible)
sudo tune2fs -O extents,uninit_bg,dir_index /dev/sda1
sudo fsck -pf /dev/sda1
# ⚠️ Una vez convertido a ext4, NO se puede volver a ext3
```

**Mejoras clave de ext4 sobre ext3:**
- **Extents**: reemplazan el esquema de bloques individuales. Un extent mapea hasta 128 MiB contiguos ← reduce drásticamente la fragmentación
- **Asignación retrasada** (delayed allocation): reserva bloques justo antes de escribir al disco, mejorando decisiones de asignación
- **Asignador multibloque** (mballoc): múltiples bloques en una sola operación
- **64,000 subdirectorios** (con `dir_nlink` puede ir más allá)
- **Journal checksumming**: suma de verificación en el journal para mayor fiabilidad
- **Timestamps en nanosegundos**: supera el límite de segundos; retrasa el problema del año 2038
- **Desfragmentación online**: `e4defrag` sin desmontar
- **Asignación persistente** (preallocation): `fallocate()` reserva espacio instantáneamente

```bash
# Desfragmentar online
sudo e4defrag /ruta/al/archivo          # archivo específico
sudo e4defrag /                         # todo el sistema de archivos

# Preasignar espacio (útil para VMs, bases de datos)
fallocate -l 10G archivo.img            # instantáneo, no escribe ceros
```

## ext4 — El estándar (default en Debian, Ubuntu, Arch)

**El sistema de archivos por defecto** en la mayoría de las distros. Maduro, probado, confiable.

### Características clave

| Característica | Detalle |
|---|---|
| **Journaling** | ✅ Sí (metadatos + opcional de datos) |
| **Tamaño máx. archivo** | 16 TB |
| **Tamaño máx. volumen** | 1 EiB |
| **Snapshots** | ❌ No |
| **Compresión** | ❌ No |
| **Checksums en datos** | ❌ No |
| **Copy-on-Write** | ❌ No |
| **Extents** | ✅ Sí (asignación contigua) |
| **Desfragmentación** | ✅ Online (e4defrag) |
| **Timestamps** | ✅ Nanosegundos |

### Comandos básicos

```bash
# Crear
sudo mkfs.ext4 /dev/sda1
sudo mkfs.ext4 -L DATOS /dev/sda1        # con etiqueta
sudo mkfs.ext4 -O ^has_journal /dev/sda1 # sin journal (discos temporales)

# Información
dumpe2fs -h /dev/sda1                    # info detallada
tune2fs -l /dev/sda1                     # resumen legible

# Ajustes
sudo tune2fs -c 30 /dev/sda1             # forzar fsck cada 30 montajes
sudo tune2fs -C -1 /dev/sda1             # resetear contador de montajes
sudo tune2fs -m 5 /dev/sda1              # reservar 5% para root (default 5%)

# Comprobar errores
sudo fsck.ext4 -f /dev/sda1              # forzar revisión (desmontado)
sudo fsck.ext4 -p /dev/sda1              # reparar automáticamente

# Espacio
df -hT                                   # tipo de FS incluido
lsblk -f                                 # UUID y tipo FS
```

### Opciones de montaje

```bash
# /etc/fstab
UUID=xxx  /  ext4  defaults,noatime,nodiratime  0  1

# noatime: no actualizar tiempo de acceso
# nodiratime: lo mismo para directorios
# commit=60: sincronizar cada 60s
# data=ordered: journal de metadatos + datos antes (default)
# data=writeback: journal de metadatos, datos sin orden (más rápido, menos seguro)
# barrier=1: barreras de escritura (evita corrupción con HW reordenando)
```

### ¿Cuándo usar ext4?

✅ **Para empezar, o si no tienes requisitos especiales**. Es el filesystem más probado, con la mejor herramienta de recuperación (`fsck.ext4`). Si no sabes cuál elegir, elige ext4.

---

---

## Btrfs — Moderno, con snapshots (default en Fedora, openSUSE)

> Para una guía detallada con todos los comandos, subvolúmenes, snapshots y compresión, ver [[Btrfs]].


**B-tree Filesystem**. Filesystem copy-on-write (CoW) con snapshots, compresión, checksums y auto-reparación. El sucesor natural de ext4 para escritorio: Fedora lo usa por defecto desde Fedora 33, openSUSE desde antes.

### Características clave

| Característica | Detalle |
|---|---|
| **Copy-on-Write** | ✅ Sí |
| **Snapshots** | ✅ Sí (instantáneos, sin duplicar espacio) |
| **Compresión** | ✅ Sí (zlib, lzo, zstd) — transparente |
| **Checksums** | ✅ CRC32C en datos y metadatos |
| **Auto-reparación** | ✅ Con RAID1/DUP, corrige corrupción |
| **Subvolúmenes** | ✅ Particiones independientes dentro del mismo pool |
| **RAID** | ✅ 0, 1, 10, 5, 6 (RAID56 experimental) |
| **Tamaño máx. archivo** | 16 EiB |
| **Defragmentación** | ✅ Online |

### Subvolúmenes

Los subvolúmenes son la clave del diseño de Btrfs. Son como particiones lógicas que comparten el mismo pool de espacio:

```bash
# Ver subvolúmenes existentes
sudo btrfs subvolume list /

# Crear un subvolumen
sudo btrfs subvolume create /mnt/btrfs/@datos

# Montar un subvolumen específico
sudo mount -o subvol=@datos /dev/sda1 /mnt/datos

# Snapshot de un subvolumen (instantáneo, ocupa espacio solo de los cambios)
sudo btrfs subvolume snapshot /home /home-backup
sudo btrfs subvolume snapshot -r /home /home-backup-readonly  # solo-lectura
```

### Snapshots

Los snapshots de Btrfs son **instantáneos y casi sin costo de espacio** (solo almacenan las diferencias con el original). Ideales para backups y antes de cambios riesgosos:

```bash
# Snapshot del sistema completo antes de una actualización grande
sudo btrfs subvolume snapshot / /@pre-update

# Ver espacio usado por snapshots
sudo btrfs subvolume show /@pre-update

# Eliminar un snapshot
sudo btrfs subvolume delete /@pre-update

# Snapshot automáticos con snapper (openSUSE/Fedora)
sudo snapper -c root create -d "antes de instalar paquete X"
sudo snapper list
```

### Compresión transparente

```bash
# Activar compresión en montaje
# /etc/fstab
UUID=xxx  /  btrfs  defaults,compress=zstd:3  0  0

# Comprobar ratio de compresión
sudo btrfs filesystem usage /
compsize /ruta                               # ratio por archivo

# zstd tiene buena relación compresión/velocidad. Nivel 1-3 para uso diario.
```

### Mantenimiento

```bash
# Verificar integridad (escanear todo el FS, no necesita desmontar)
sudo btrfs scrub start /
sudo btrfs scrub status /

# Balancear (redistribuir datos entre dispositivos)
sudo btrfs balance start /                    # recomendado para RAID
sudo btrfs balance status /

# Liberar espacio no usado (trim, útil en SSD)
sudo fstrim -av

# Ver uso de espacio por subvolumen
sudo btrfs filesystem df /
```

### ¿Cuándo usar Btrfs?

✅ **Para escritorio moderno**. Si quieres snapshots (para recovery antes de una actualización), compresión transparente, y auto-reparación. Es el filesystem del futuro para Linux de escritorio.

⚠️ RAID5/6 aún experimental — no usar para datos críticos.

---

## XFS — Rendimiento para archivos grandes (default en RHEL, CentOS)

XFS es un sistema de archivos de 64 bits con journaling, creado por **Silicon Graphics (SGI)** en 1993 para su UNIX llamado **IRIX**. Fue liberado bajo GPL en mayo de 2000 y portado a Linux (kernel 2.4.25). Hoy es el FS por defecto en RHEL, CentOS, y para `/home` en openSUSE. Destaca por su rendimiento con archivos grandes y E/S paralela.

### Historia

- **1993**: SGI comienza el desarrollo para IRIX 5.3
- **1994**: Aparece por primera vez en IRIX 5.3
- **2000**: Liberado bajo GPL (código abierto)
- **2001**: Portado a Linux
- **2004**: Kernel Linux 2.4.25 lo incluye oficialmente
- **2014**: RHEL 7 adopta XFS como FS por defecto
- **Actualidad**: Estándar en RHEL, CentOS, y servidores NAS empresariales

### Grupos de asignación (Allocation Groups)

XFS divide internamente el sistema de archivos en **grupos de asignación**, regiones lineales del mismo tamaño. Cada grupo gestiona sus propios inodos y espacio libre de forma independiente. Esto proporciona:

- **Escalabilidad**: múltiples hilos pueden operar en distintos grupos simultáneamente
- **Paralelismo**: E/S paralela en sistemas con muchos núcleos
- **Rendimiento constante**: el tamaño del FS no degrada el rendimiento

### Journaling lógico

A diferencia de ext3 (journaling físico que copia bloques), XFS usa **journaling lógico**: registra descripciones de alto nivel de las operaciones. El journal es un buffer circular de bloques fuera del FS principal. Esto hace que:

- La recuperación sea **independiente del tamaño del FS** (siempre rápida)
- El rendimiento no se degrade con discos grandes
- Las actualizaciones del journal sean asincrónicas (evita bajadas de rendimiento)

### Características clave

| Característica | Detalle |
|---|---|
| **Journaling** | ✅ Sí (metadatos, lógico) |
| **Tamaño máx. archivo** | 8 EiB |
| **Tamaño máx. volumen** | 8 EiB |
| **Snapshots** | ❌ No (con LVM sí) |
| **Compresión** | ❌ No |
| **Checksums** | ✅ Metadatos (v5+, CRC32) — datos no |
| **Defragmentación** | ✅ Online (`xfs_fsr`) |
| **Delayed allocation** | ✅ Excelente para evitar fragmentación |
| **Allocation Groups** | ✅ Grupos paralelos independientes |
| **Reducir tamaño** | ❌ **No se puede reducir** |

### Comandos básicos

```bash
# Crear
sudo mkfs.xfs /dev/sda1
sudo mkfs.xfs -L DATOS -m reflink=1 /dev/sda1   # reflink (copias rápidas, Btrfs-like)

# NO se puede reducir (shrink) — solo crecer
# Redimensionar
sudo xfs_growfs /mount-point              # crecer al tamaño completo del dispositivo

# Ver información
xfs_info /mount-point

# Reparar (requiere desmontar)
sudo xfs_repair /dev/sda1

# Fragmentación
xfs_db -c "frag" /dev/sda1
```

### Limitación importante

**No se puede reducir** un volumen XFS. Si necesitas redimensionar particiones hacia abajo, no uses XFS. Para eso, ext4 o Btrfs.

### ¿Cuándo usar XFS?

✅ **Servidores, NAS, archivos muy grandes (>10GB)**, bases de datos, edición de video. Si trabajas con archivos enormes y necesitas throughput máximo.

⚠️ No reduce de tamaño. Evitar en laptops/escritorios con particiones que puedan necesitar redimensionarse.

---

## F2FS — Flash-Friendly File System

**F2FS** (Flash-Friendly File System) es un sistema de archivos creado por **Samsung** (Kim Jaegeuk) para el kernel Linux, diseñado específicamente para memorias flash NAND: SSDs, eMMC y tarjetas SD. A diferencia de ext4 o XFS (diseñados para discos giratorios), F2FS considera desde cero las características del flash: borrado por bloques, desgaste de celdas, y operaciones de lectura/escritura asimétricas.

Usa un diseño **log-structured** (estructurado por registro), adaptado a las nuevas formas de almacenamiento. Soluciona problemas clásicos de los log-structured FS como el *snowball effect* y la alta sobrecarga de limpieza.

### Características clave

| Característica | Detalle |
|---|---|
| **Diseño objetivo** | Memorias flash NAND (SSD, eMMC, SD) |
| **Arquitectura** | Log-structured (escritura secuencial) |
| **Compresión** | ✅ Sí (lzo, lz4, zstd) |
| **Cifrado** | ✅ Nativo (desde kernel 5.18) |
| **Tamaño máx. volumen** | 16 TB |
| **Madurez** | Media — activo en Android y dispositivos móviles |
| **Soporte en kernel** | ✅ Nativo desde 3.8 |

### ¿Cuándo usar F2FS?

✅ **Dispositivos con almacenamiento flash (smartphones, tablets, SD cards)**. También útil en SSDs NVMe donde se busca maximizar vida útil y rendimiento de escritura. Es el FS por defecto en muchos dispositivos Android.

⚠️ No recomendado para discos giratorios (HDD). Menos probado que ext4/Btrfs/XFS en servidores de propósito general.

---

## ZFS — El todoterreno (OpenZFS)

Sistema de archivos + gestor de volúmenes. Original de Solaris, portado a Linux como **OpenZFS**. Incluye pool de almacenamiento, RAID por software, snapshots, clones, compresión, deduplicación, checksums, y más.

**No está en el kernel mainline de Linux** por problemas de licencia (CDDL vs GPL). Hay que instalarlo aparte.

### Características clave

| Característica | Detalle |
|---|---|
| **Pool de almacenamiento** | ✅ Varios discos en un pool, espacio compartido |
| **Copy-on-Write** | ✅ Sí |
| **Snapshots** | ✅ Sí (instantáneos) |
| **Compresión** | ✅ Sí (lz4, zstd, gzip) |
| **Checksums** | ✅ SHA-256, fletcher4 |
| **RAID** | ✅ mirror, RAID-Z1/2/3 (como RAID 5/6 pero sin write hole) |
| **Deduplicación** | ✅ Sí — ⚠️ consume ~5 GB RAM por TB deduplicado. No activar sin entender el costo |
| **Cifrado** | ✅ Nativo (desde ZFS 0.8) |
| **Gestión de volúmenes** | ✅ Integrado (no necesita LVM) |
| **RAM recomendada** | ~1 GB por TB almacenado (ARC adaptativo, configurable vía `zfs_arc_max`) |

### Instalación

```bash
# Arch
sudo pacman -S zfs-dkms                   # compila módulo del kernel (requiere dkms)
sudo modprobe zfs                          # cargar módulo

# Ubuntu
sudo apt install zfsutils-linux            # disponible desde Ubuntu 16.04

# Fedora
sudo dnf install zfs                       # requiere RPM Fusion non-free
```

### Comandos básicos

```bash
# Crear un pool
sudo zpool create -f tanque /dev/sda /dev/sdb /dev/sdc   # 3 discos, sin redundancia
sudo zpool create -f tanque mirror /dev/sda /dev/sdb      # RAID 1 (mirror)
sudo zpool create -f tanque raidz /dev/sda /dev/sdb /dev/sdc  # RAID-Z (como RAID 5)

# Ver pools
zpool status
zpool list

# Crear datasets (subvolúmenes)
sudo zfs create tanque/backups
sudo zfs set compression=lz4 tanque/backups
sudo zfs set mountpoint=/backups tanque/backups

# Snapshots
sudo zfs snapshot tanque/backups@2026-07-18
sudo zfs list -t snapshot

# Rollback (volver a un snapshot)
sudo zfs rollback tanque/backups@2026-07-18

# Enviar/replicar snapshots a otro equipo
zfs send tanque/backups@2026-07-18 | ssh otro-pc zfs receive tanque/backups

# Scrub (verificar integridad de todos los datos)
sudo zpool scrub tanque
```

### Cuidados

- **No mezclar con LVM** — ZFS ya maneja volúmenes por sí mismo
- **RAM**: ZFS necesita caché (ARC). Estimar 1 GB por TB de almacenamiento
- **No usar TRIM en discos viejos** — soporte mejoró pero puede dar problemas
- Si un pool tiene errores de datos, ZFS reporta pero espera redundancia para reparar

### ¿Cuándo usar ZFS?

✅ **Servidores NAS, almacenamiento de confianza, datos críticos**. Si tienes varios discos y necesitas integridad garantizada, snapshots eficientes, compresión, y RAID por software. También popular en equipos con mucha RAM (homelabs, servidores).

⚠️ No recomendado para laptops (consume RAM, más complejo, ausente del kernel mainline).

---

## Tabla comparativa

| Característica | ext4 | Btrfs | XFS | ZFS |
|---|---|---|---|---|
| **Copy-on-Write** | ❌ | ✅ | ❌ | ✅ |
| **Snapshots** | ❌ | ✅ | ❌ (con LVM) | ✅ |
| **Compresión** | ❌ | ✅ (zstd, lzo) | ❌ | ✅ (lz4, zstd) |
| **Checksums** | ❌ | ✅ (CRC32C) | solo metadatos | ✅ (SHA-256) |
| **Auto-reparación** | ❌ | ✅ (con redundancia) | ❌ | ✅ |
| **Reducir tamaño** | ✅ | ✅ | ❌ | ✅ |
| **RAID integrado** | ❌ | ✅ (0,1,10,5,6) | ❌ | ✅ (mirror,RAID-Z) |
| **Madurez** | Máxima | Alta | Máxima | Alta |
| **fsck/recuperación** | Excelente | Buena | Buena | Buena |
| **Uso típico** | Escritorio, general | Escritorio moderno | Servidores, archivos grandes | NAS, datos críticos |

## Operaciones comunes

### Crear y montar

```bash
# Particionar primero (fdisk o gdisk)
sudo fdisk /dev/sda                       # o cfdisk, gdisk

# Crear FS
sudo mkfs.ext4 /dev/sda1
sudo mkfs.btrfs /dev/sda1
sudo mkfs.xfs /dev/sda1

# Montar temporal
sudo mount /dev/sda1 /mnt                 # montar
sudo umount /mnt                           # desmontar

# Montar permanente (/etc/fstab)
# Usar UUID en lugar de /dev/sda1 (los UUID no cambian)
blkid /dev/sda1                            # obtener UUID
# Añadir a /etc/fstab:
# UUID=xxxx-xxxx  /mnt/datos  ext4  defaults  0  2
```

### UUID y LABEL

```bash
lsblk -f                                   # UUID y LABEL de todos los dispositivos
blkid                                      # UUID y tipo de FS

# Poner/quitar etiqueta
sudo e2label /dev/sda1 DATOS              # ext4
sudo btrfs filesystem label / DATOS       # Btrfs
sudo xfs_admin -L DATOS /dev/sda1         # XFS
sudo zfs set mountpoint=/datos tanque     # ZFS
```

### fsck (File System Check)

```bash
# ext4
sudo fsck.ext4 /dev/sda1                   # o: sudo fsck -t ext4
sudo fsck -y /dev/sda1                     # responder sí automáticamente

# Btrfs (no necesita desmontar para check)
sudo btrfs scrub start /                   # verificar integridad online

# XFS (necesita desmontar)
sudo xfs_repair /dev/sda1

# ZFS
sudo zpool scrub tanque                    # verificar online
```

### Convertir entre tipos

No hay conversión directa entre sistemas de archivos. El procedimiento siempre es:

```bash
# 1. Hacer backup de los datos
# 2. Formatear con el nuevo FS
# 3. Restaurar los datos

# Alternativa si tienes espacio en otro disco:
sudo rsync -aAXv /mnt/viejo/ /mnt/nuevo/   # preservando permisos + atributos + ACLs
```

## ¿Cuál elegir?

| Si tu prioridad es... | Elige... |
|---|---|
| **Simplicidad y compatibilidad** | ext4 |
| **Snapshots y compresión en escritorio** | Btrfs |
| **Archivos enormes y servidores** | XFS |
| **Integridad de datos y discos múltiples** | ZFS (o Btrfs) |
| **No sé, es mi primer Linux** | ext4 |

---

## JFS (Journaled File System) — Legado de IBM

**JFS** (Journaled File System) es un sistema de archivos de 64 bits con journaling, creado por **IBM** originalmente para su UNIX **AIX**. Más tarde fue portado a OS/2, y finalmente liberado bajo **GPL** para Linux, donde está disponible desde el kernel 2.4.

| Característica | Detalle |
|---|---|
| **Origen** | IBM AIX (1993), portado a Linux (kernel 2.4, 2001) |
| **Licencia** | GNU GPL |
| **Journaling** | ✅ Sí (solo metadatos — *metadata only*) |
| **Tamaño máx. archivo** | 8 EiB (64-bit) |
| **Tamaño máx. volumen** | 8 EiB |
| **Snapshots** | ❌ No |
| **Compresión** | ❌ No |
| **Estructura de directorios** | B-trees (directorios grandes); inode directo (directorios pequeños) |
| **Inodes** | Asignación dinámica (no hay límite fijo predefinido) |
| **Estado actual** | Mantenimiento — activo en kernel pero nicho |

### Características destacadas

- **Journaling de metadatos exclusivamente** (*metadata only*): registra solo cambios en metadatos en el journal, no los datos en sí. La recuperación tras caída es muy rápida, pero los datos no están protegidos por el journal.
- **B-trees para directorios grandes**: los directorios con muchos archivos usan árboles B para búsqueda eficiente, mientras que los pequeños almacenan el contenido directamente en el inodo.
- **Inodes dinámicos**: a diferencia de ext2/ext3 (que reservan un número fijo de inodes al formatear), JFS asigna inodes bajo demanda, evitando el problema de "quedarse sin inodos".
- **Agrupación de transacciones**: las operaciones concurrentes se agrupan en lotes para reducir la sobrecarga del journal.

```bash
# Crear un sistema JFS
sudo mkfs.jfs /dev/sda1
sudo mkfs.jfs -L DATOS /dev/sda1              # con etiqueta

# Montar
sudo mount -t jfs /dev/sda1 /mnt

# Verificar / reparar (requiere desmontar)
sudo fsck.jfs /dev/sda1

# Información del FS
jfs_tune -l /dev/sda1

# Habilitar journaling (por defecto ya está activo)
sudo mount -t jfs -o nointegrity /dev/sda1 /mnt  # deshabilitar journal (más rápido, menos seguro)
```

### ¿Cuándo usar JFS?

⚠️ **Uso nicho hoy en día**. JFS fue innovador en su época (inodes dinámicos, B-trees, 64-bit) pero está superado por ext4, XFS y Btrfs. Puede tener sentido en sistemas muy legacy que ya lo usan, pero para instalaciones nuevas siempre es mejor elegir ext4, XFS o Btrfs.

---

## ReiserFS / Reiser4 — El pionero (ReiserFS) y su sucesor (Reiser4)

### ReiserFS

**ReiserFS** fue uno de los primeros sistemas de archivos con **journaling** para Linux, desarrollado por **Namesys** (fundado por Hans Reiser). Fue el FS por defecto en **SUSE Linux** durante años. Innovó con un rendimiento excepcional para **archivos pequeños** (< 4 KB), almacenándolos directamente en el árbol B* en lugar de usar inodos separados.

| Característica | ReiserFS (v3) |
|---|---|
| **Journaling** | ✅ Sí (metadatos) |
| **Tamaño máx. archivo** | 8 TB |
| **Tamaño máx. volumen** | 16 TB |
| **Snapshots** | ❌ No |
| **Compresión** | ❌ No |
| **Rendimiento archivos pequeños** | ⭐ Excelente |
| **Estado actual** | Obsoleto — no recomendado para nuevos sistemas |
| **Soporte en kernel** | ✅ Sí (estable, pero en modo mantenimiento) |

```bash
# Crear (no recomendado para sistemas nuevos)
sudo mkfs.reiserfs /dev/sda1
# Montar
sudo mount -t reiserfs /dev/sda1 /mnt
```

> ⚠️ **ReiserFS está considerado obsoleto**. El desarrollador principal, Hans Reiser, fue condenado por asesinato en 2008 y el desarrollo quedó abandonado. No se recomienda para sistemas nuevos. La mayoría de distros ya no lo incluyen por defecto.

### Reiser4

**Reiser4** fue el sucesor planeado, con un diseño radicalmente diferente basado en **árboles dancing tree** (en lugar de B* trees). Ofrecía compresión y cifrado transparentes, y plugins para personalizar el comportamiento del FS. Sin embargo, nunca fue incluido en el kernel mainline (solo en parches externos) y su desarrollo está esencialmente congelado.

```bash
# Reiser4 NO está en el kernel mainline
# Requiere parchear el kernel manualmente
# No recomendado para sistemas en producción
```

**¿Cuándo usarlos?** — Solo si mantienes sistemas legacy que ya los usan. Para nuevos sistemas, elegir ext4 o Btrfs.

---

## SquashFS — Sistema de archivos comprimido de solo lectura

**SquashFS** es un sistema de archivos comprimido, de **solo lectura**, diseñado para Live CDs/USB y sistemas embebidos. Es el formato usado por **Snap** y **AppImage** para empaquetar aplicaciones.

| Característica | Detalle |
|---|---|
| **Compresión** | ✅ gzip, lzo, lz4, xz, zstd |
| **Lectura/Escritura** | Solo lectura |
| **Uso típico** | Live USBs, snaps, AppImages, sistemas embebidos |
| **Tamaño máx. archivo** | 16 EiB (con soporte de kernel moderno) |
| **Soporte en kernel** | ✅ Nativo (drivers/staging) |

```bash
# Ver metadatos de un archivo squashfs
unsquashfs -s archivo.squashfs           # info del FS
unsquashfs -l archivo.squashfs           # listar contenido

# Extraer todo el contenido
unsquashfs -d ./extraido archivo.squashfs

# Crear un squashfs desde un directorio
sudo mksquashfs ./mi-directorio imagen.squashfs -comp zstd

# Montar un squashfs
sudo mount -t squashfs imagen.squashfs /mnt -o loop

# Ver el squashfs de un snap (todos los snaps son squashfs)
ls /var/lib/snapd/snaps/*.snap
```

**Uso en el sistema**:
- Snap usa SquashFS para montar cada snap: los snaps están en `/var/lib/snapd/snaps/*.snap` y se montan en `/snap/<nombre>/`
- AppImage incluye un sistema de archivos squashfs dentro del binario que se monta al ejecutarlo
- Live CDs/USB usan squashfs para el sistema de archivos raíz comprimido

---

## Ceph File System — Sistema de archivos distribuido

**Ceph** es un sistema de almacenamiento distribuido que proporciona almacenamiento de objetos (RADOS), bloques (RBD) y archivos (CephFS). Diseñado para escalar a exabytes y tolerar fallos de hardware. Usado por OpenStack, Kubernetes y grandes despliegues cloud.

| Característica | Detalle |
|---|---|
| **Arquitectura** | Distribuida (sin punto único de fallo) |
| **Escalabilidad** | De 1 a miles de nodos |
| **Redundancia** | Replicación o erasure coding |
| **Auto-reparación** | ✅ Rebalanceo automático |
| **Protocolos** | POSIX, S3 (objetos), iSCSI (bloques) |
| **Uso típico** | Cloud, Kubernetes, OpenStack |
| **Complejidad** | Alta (requiere varios servidores) |

```bash
# Ceph no se "usa" como un FS normal en escritorio
# Es un sistema distribuido que requiere varios servidores

# En un nodo cliente, montar CephFS:
sudo mount -t ceph 192.168.1.10:6789:/ /mnt/ceph -o name=admin,secret=clave

# Comandos de administración (en nodo admin)
ceph status                              # estado del cluster
ceph osd tree                            # árbol de OSDs
ceph osd df                              # uso de disco por OSD
rados df                                 # uso del pool RADOS
```

### Componentes de Ceph

| Componente | Función |
|---|---|
| **RADOS** | Almacenamiento de objetos base (corazón de Ceph) |
| **RBD** (RADOS Block Device) | Almacenamiento en bloque (discos virtuales) |
| **CephFS** | Sistema de archivos POSIX |
| **RADOSGW** | Gateway S3/Swift (almacenamiento de objetos S3-compatible) |
| **MON** (Monitor) | Mapa del cluster, estado |
| **OSD** | Almacenamiento de datos real (uno por disco) |
| **MDS** | Metadatos de CephFS |

> ⚠️ **Ceph no es para escritorio**. Es un sistema de almacenamiento empresarial. En un PC normal, no tiene sentido instalar Ceph. Su lugar está en servidores, clouds y clusters de Kubernetes.

---

## Otras tablas: ReiserFS, SquashFS, Ceph

| Característica | ReiserFS (v3) | Reiser4 | SquashFS | CephFS |
|---|---|---|---|---|
| **Tipo** | Local | Local | Solo lectura (montado) | Distribuido |
| **Compresión** | ❌ | ✅ (plugins) | ✅ (gzip,lzo,lz4,xz,zstd) | ❌ (a nivel objeto) |
| **Snapshots** | ❌ | ❌ | ❌ | ✅ (vía RADOS) |
| **Journaling** | ✅ | ✅ (tree) | No aplica | No aplica |
| **Estado** | ❌ Obsoleto | ❌ Experimental | ✅ Activo | ✅ Activo |
| **Uso típico** | Legacy | Experimental | Live CD, snaps, AppImage | Cloud, servidores |

---

## FAT — Soporte para sistemas de archivos Windows (FAT12/16/32)

Linux soporta discos con formato FAT (FAT12, FAT16, FAT32) mediante **tres controladores** distintos en el kernel: `msdos`, `vfat` y `umsdos`. Son útiles para compatibilidad con USB drives, tarjetas SD, y particiones compartidas con sistemas Windows o dispositivos embebidos.

### Los tres controladores

| Controlador | Nombres largos | Semántica Unix | ¿Para qué usarlo? |
|---|---|---|---|
| **msdos** | ❌ Solo 8.3 | ❌ No | Solo nombres cortos DOS — obsoleto en la práctica |
| **vfat** | ✅ Sí | ❌ No | **El recomendado** para datos compartidos (USB, SD, dual boot) |
| **umsdos** | ✅ Sí | ✅ Sí | Permitía instalar Linux en FAT32. **Eliminado en kernel 2.6.11** (histórico) |

- **msdos**: el controlador más básico. Solo muestra nombres de archivo 8.3 y no proporciona permisos Unix. Prácticamente irrelevante hoy.
- **vfat**: el controlador **recomendado para uso general**. Usa las mismas estructuras de datos que Windows para nombres largos (VFAT). Monta cualquier disco FAT con soporte completo de lectura/escritura. No necesita mantenimiento al alternar entre SO.
- **umsdos**: extendía vfat con semántica Unix completa (permisos, propietarios). Almacenaba esta información extra en un archivo oculto `--LINUX-.---` en cada directorio. Requería ejecutar `umssync` al alternar entre Windows y Linux. **Eliminado del kernel en 2005 (2.6.11)** por falta de mantenimiento.

```bash
# Montar una USB FAT32 con vfat (uso normal)
sudo mount -t vfat /dev/sda1 /mnt/usb

# Montar con opciones útiles (para que los archivos sean tuyos)
sudo mount -t vfat -o uid=1000,gid=1000,umask=022 /dev/sda1 /mnt/usb
# uid/gid: propietario de los archivos
# umask=022: permisos 755 (lectura/escritura para ti, lectura para otros)

# Montar con conversión de saltos de línea (cuidado: puede dañar binarios)
sudo mount -t vfat -o conv=auto /dev/sda1 /mnt/usb  # detecta texto vs binario
# conv=b : binario (sin conversión, default)
# conv=t : texto (CRLF → LF al leer, LF → CRLF al escribir)
# conv=a : auto (detecta por extensión)

# Ver el tipo de FAT de un dispositivo
blkid /dev/sda1                              # muestra TYPE="vfat"
sudo fdisk -l /dev/sda                       # System: HPFS/NTFS/exFAT
```

### mtools — Alternativa en espacio de usuario

Si prefieres no montar el disco, el paquete **mtools** permite manipular archivos en volúmenes FAT directamente desde la línea de comandos, sin necesidad del kernel:

```bash
# Instalar
sudo apt install mtools                      # Debian/Ubuntu
sudo pacman -S mtools                        # Arch

# Copiar archivo a un disco FAT (por dispositivo)
mcopy /home/user/documento.txt D:

# Listar directorio
mdir D:

# Formatear un disco FAT (incluso sin montar)
sudo mformat -f 32 -H 255 -S 32 -v USB D:
```

### FAT vs exFAT vs NTFS para discos externos

| Formato | Máx. archivo | Máx. volumen | Journaling | ¿Para qué? |
|---|---|---|---|---|
| **FAT32** | 4 GB | 2 TB | ❌ | USB viejos, compatibilidad máxima |
| **exFAT** | 16 EiB | 128 PB | ❌ | USB modernos (>4 GB), SDXC, cámaras |
| **NTFS** (ntfs3) | 16 EiB | 256 TB | ✅ | Discos grandes, uso intensivo Windows+Linux |

> FAT32 tiene la limitación de **archivos de máximo 4 GB**, lo que lo hace inutilizable para ISOs, VMs o videos grandes. Para discos externos modernos, prefiere **exFAT** (compatible con Windows, macOS y Linux) o **NTFS** (si usas ntfs3).

---

## Ver también

- [[Filesystem Hierarchy Standard]] — dónde va cada cosa en el sistema de archivos
- [[LVM]] — gestión de volúmenes lógicos (complementario a FS)
- [[Particionado y Esquemas de Disco]] — cómo dividir el disco antes de crear FS
- [[Proc y Sys]] — sistemas de archivos virtuales (/proc, /sys)
- [[Docker]] — Btrfs/ZFS como driver de almacenamiento
- [[timeshift]] — snapshots de Btrfs
- [[Snap y Flatpak]] — Snap usa SquashFS internamente

## Enlaces externos

- [Wikipedia — Comparison of file systems](https://en.wikipedia.org/wiki/Comparison_of_file_systems)
- [Wikipedia — ext4](https://en.wikipedia.org/wiki/Ext4)
- [Wikipedia — Btrfs](https://en.wikipedia.org/wiki/Btrfs)
- [Arch Wiki — File systems](https://wiki.archlinux.org/title/File_systems)

#sistema #almacenamiento