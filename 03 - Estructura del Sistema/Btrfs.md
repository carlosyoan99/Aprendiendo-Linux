---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: alta
---

# Btrfs — B-tree Filesystem

## Definición

**Btrfs** (B-tree Filesystem, a menudo pronunciado "Butter FS" o "B-tree FS") es un sistema de archivos **copy-on-write (CoW)** para Linux, desarrollado originalmente por **Oracle Corporation** y anunciado en 2007. Su objetivo es ser el sucesor de ext4, ofreciendo características avanzadas como snapshots, compresión transparente, checksums de datos, subvolúmenes, y RAID integrado — sin necesidad de herramientas externas como LVM o mdadm.

Es el sistema de archivos por defecto en **Fedora** (desde Fedora 33), **openSUSE**, **SteamOS** (Steam Deck), y una opción popular en **Arch Linux** y **Debian**.

> Para una visión general de todos los sistemas de archivos y su comparativa, ver [[Sistemas de Archivos]].

---

## Historia

| Año | Hito |
|---|---|
| 2007 | Chris Mason (Oracle) anuncia Btrfs en la lista de correo del kernel Linux |
| 2008 | Se integra en el kernel Linux 2.6.29 como experimental |
| 2009 | Btrfs v0.19 publicado como software libre bajo GPL |
| 2012 | openSUSE 12.2 adopta Btrfs como FS por defecto |
| 2013 | Synology lo incluye en DSM 6.0 para sus NAS |
| 2020 | Fedora 33 cambia a Btrfs como FS por defecto |
| 2022 | SteamOS 3.0 (Steam Deck) usa Btrfs |
| 2026 | Btrfs es considerado estable y el FS moderno dominante en Linux de escritorio |

El diseño de Btrfs se basa en los **árboles-B copy-on-write** propuestos originalmente por Ohad Rodeh (IBM) en USENIX 2007. Theodore Ts'o, mantenedor de ext4, ha dicho que Btrfs incorpora ideas de diseño de ReiserFS y características avanzadas similares a ZFS.

---

## Características clave

| Característica | Btrfs |
|---|---|
| **Copy-on-Write** | ✅ Sí — todas las escrituras son CoW (se puede desactivar por archivo con `chattr +C`) |
| **Snapshots** | ✅ Instantáneos, casi sin costo de espacio (solo diferencias) |
| **Subvolúmenes** | ✅ Particiones lógicas dentro del mismo pool de espacio |
| **Compresión** | ✅ zlib, lzo, zstd (por archivo o por montaje) |
| **Checksums** | ✅ CRC32C en datos y metadatos (detecta corrupción silenciosa) |
| **Auto-reparación** | ✅ Con redundancia (RAID1/DUP), corrige datos corruptos |
| **RAID integrado** | ✅ 0, 1, 10, 5, 6 — sin necesidad de mdadm |
| **Tamaño máx. archivo** | 16 EiB |
| **Tamaño máx. volumen** | 16 EiB |
| **Asignación dinámica de inodos** | ✅ No hay límite fijo de archivos |
| **Desfragmentación** | ✅ Online, sin desmontar |
| **Reducir tamaño** | ✅ Sí (`btrfs filesystem resize -10G /`) |
| **Modo SSD** | ✅ Optimizaciones automáticas para SSD (opción de montaje `ssd`) |
| **Deduplicación** | ⚠️ No nativa (herramientas externas: `duperemove`, `bees`) |
| **Cifrado** | ❌ No nativo (usar LUKS por debajo) |
| **RAID 5/6** | ⚠️ Experimental — no para datos críticos |

---

## Comandos esenciales

### Creación y montaje

```bash
# Crear sistema de archivos
sudo mkfs.btrfs /dev/sda1                          # un solo disco
sudo mkfs.btrfs -L DATOS /dev/sda1                 # con etiqueta
sudo mkfs.btrfs /dev/sda1 /dev/sdb1                # varios discos (pool)
sudo mkfs.btrfs -m raid1 -d raid1 /dev/sda1 /dev/sdb1  # mirror (RAID 1)

# Montar
sudo mount /dev/sda1 /mnt
sudo mount -o compress=zstd:3 /dev/sda1 /mnt       # con compresión zstd
sudo mount -o subvol=@home /dev/sda1 /home          # montar subvolumen específico
```

### Subvolúmenes

Los subvolúmenes son la columna vertebral de Btrfs. Son como particiones lógicas que comparten el mismo espacio:

```bash
# Ver subvolúmenes
sudo btrfs subvolume list /
sudo btrfs subvolume list -a /                      # incluye snapshots
sudo btrfs subvolume show /@home

# Crear
sudo btrfs subvolume create /mnt/@datos
sudo btrfs subvolume create /mnt/@logs

# Snapshot (instantáneo)
sudo btrfs subvolume snapshot /home /home-backup           # escribible
sudo btrfs subvolume snapshot -r /home /home-snapshot-RO   # solo lectura

# Eliminar
sudo btrfs subvolume delete /home-backup

# Estructura típica (openSUSE/Fedora):
# /@          → subvolumen raíz
# /@home      → /home
# /@snapshots → snapshots automáticos (snapper)
# /@var       → /var (opcional, excluir de snapshots)
```

### Snapshots

Los snapshots de Btrfs son **instantáneos** y ocupan espacio solo por los bloques que cambian después de crearlos:

```bash
# Snapshot manual antes de una actualización
sudo btrfs subvolume snapshot / /@pre-update-2026-07-19

# Volver a un snapshot (rollback)
# 1. Arrancar desde un Live USB
# 2. Mover el subvolumen actual y renombrar el snapshot
sudo mv /@ /@broken
sudo mv /@pre-update-2026-07-19 /@

# Ver espacio usado por snapshots
sudo btrfs subvolume show /@pre-update-2026-07-19

# Snapshots automáticos con snapper
sudo snapper -c root create -d "antes de actualizar kernel"
sudo snapper list
sudo snapper delete 5                              # eliminar snapshot #5
```

### Compresión transparente

```bash
# En /etc/fstab
UUID=xxxx-xxxx  /  btrfs  defaults,compress=zstd:3  0  0

# Niveles recomendados:
# compress=zstd:1  → rápido, buena compresión (uso diario)
# compress=zstd:3  → balance velocidad/compresión (recomendado)
# compress=zstd:9  → máxima compresión, más lento (archivos)
# compress=lzo     → muy rápido, compresión baja
# compress=no      → desactivar

# Ver ratio de compresión
compsize /ruta/a/carpeta

# Forzar compresión en archivos existentes (reescribirlos)
sudo btrfs filesystem defrag -r -v -czstd /ruta
```

### Mantenimiento y diagnóstico

```bash
# Verificar integridad (online, no necesita desmontar)
sudo btrfs scrub start /
sudo btrfs scrub status /

# Balancear (redistribuir datos entre dispositivos)
sudo btrfs balance start /
sudo btrfs balance status /
sudo btrfs balance start -dusage=50 /               # solo chunks con <50% de uso

# Ver uso de espacio
sudo btrfs filesystem df /
sudo btrfs filesystem usage /
df -h /                                              # espacio "aparente" (puede diferir)

# Fragmentación
sudo btrfs filesystem defrag -r /home                # desfragmentar recursivo

# Redimensionar
sudo btrfs filesystem resize -10G /                  # reducir 10 GB
sudo btrfs filesystem resize max /                   # ocupar todo el dispositivo

# Información del dispositivo
sudo btrfs device usage /
sudo btrfs device stats /                            # estadísticas de errores
```

### Reparación

```bash
# Check (comprobar integridad del árbol)
sudo btrfs check /dev/sda1                           # requiere desmontar
sudo btrfs check --repair /dev/sda1                  # reparar (solo si sabes lo que haces)
# ⚠️ btrfs check --repair puede causar más daño si no se usa correctamente

# Para la mayoría de casos, scrub es suficiente:
sudo btrfs scrub start /                             # online, corrige lo que puede
```

---

## Casos de uso prácticos

### Escritorio moderno (Fedora/openSUSE)

```bash
# Estructura típica:
# /@            → sistema raíz
# /@home        → home (no incluido en snapshots del sistema)
# /@snapshots   → snapshots de snapper

# Ver snapshots automáticos creados por dnf/zypper
sudo snapper list
sudo snapper diff 10..11                            # cambios entre snapshots
sudo snapper undochange 10..11                      # deshacer cambios

# Antes de una actualización grande
sudo snapper -c root create -d "pre-upgrade-kernel-6.8"
sudo dnf upgrade                                     # o zypper dup
```

### Servidor NAS con redundancia

```bash
# Pool con 2 discos en mirror
sudo mkfs.btrfs -m raid1 -d raid1 /dev/sda /dev/sdb
sudo mount /dev/sda /mnt/nas

# Añadir discos al pool (expandir)
sudo btrfs device add /dev/sdc /mnt/nas
sudo btrfs balance start /mnt/nas                    # redistribuir datos

# Convertir a RAID1 (si no se hizo al crear)
sudo btrfs balance start -mconvert=raid1 -dconvert=raid1 /mnt/nas
```

### SSD + compresión

```bash
# En /etc/fstab
UUID=xxxx  /  btrfs  defaults,noatime,compress=zstd:1,ssd,autodefrag  0  0

# noatime: evita escrituras de acceso
# compress=zstd:1: mínimo overhead de CPU
# ssd: optimizaciones para SSD (agrupación de escrituras)
# autodefrag: desfragmentación automática en segundo plano (útil con CoW)
```

---

## Comparativa rápida

| Característica | Btrfs | ext4 | XFS | ZFS |
|---|---|---|---|---|
| **Copy-on-Write** | ✅ | ❌ | ❌ | ✅ |
| **Snapshots** | ✅ | ❌ | ❌ (con LVM) | ✅ |
| **Compresión** | ✅ (zstd, lzo) | ❌ | ❌ | ✅ (lz4, zstd) |
| **Checksums datos** | ✅ (CRC32C) | ❌ | ❌ | ✅ (SHA-256) |
| **Auto-reparación** | ✅ | ❌ | ❌ | ✅ |
| **RAID integrado** | ✅ (0,1,10,5,6) | ❌ | ❌ | ✅ (mirror, RAID-Z) |
| **Reducir tamaño** | ✅ | ✅ | ❌ | ✅ |
| **Madurez** | Alta | Máxima | Máxima | Alta |
| **En kernel mainline** | ✅ | ✅ | ✅ | ❌ |
| **Uso típico** | Escritorio moderno | General | Servidores | NAS crítico |

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| **Btrfs monta como solo lectura** | Error de integridad detectado al montar | `sudo btrfs scrub start /` para intentar reparar. Si persiste, `sudo btrfs check --repair` (con precaución) |
| **Espacio en disco no se libera al borrar archivos** | Snapshots reteniendo bloques viejos | Revisar snapshots: `sudo btrfs subvolume list /`. Eliminar los innecesarios |
| **"No space left" pese a tener espacio libre** | Fragmentación de chunks o metadata sin balancear | `sudo btrfs filesystem df /` para ver uso real. Ejecutar `sudo btrfs balance start -dusage=50 /` |
| **Rendimiento lento en bases de datos/VMs** | Copy-on-Write fragmenta archivos grandes que se reescriben constantemente | Desactivar CoW en el directorio: `chattr +C /ruta/a/bd/` (los archivos nuevos no usarán CoW) |
| **Scrub encuentra errores pero no los repara** | Sin redundancia (single), no hay copia para restaurar | El FS reporta la corrupción pero no puede repararla. Restaurar desde backup |
| **Balance falla con "no space"** | Metadata sin espacio para reubicar chunks | Montar con `-o enospc_debug` para diagnóstico. Agregar más discos al pool |
| **Diferencia entre du y df** | Snapshots y CoW hacen que df muestre espacio lógico mientras du suma espacio real | `btrfs filesystem df /` es más preciso. `compsize` muestra el espacio físico por archivo |
| **RAID5/6 pierde datos** | Write hole conocido, aún experimental | No usar RAID56 para datos críticos. Usar RAID1 o RAID10 |
| **Recuperación tras fallo de disco** | Disco falla en pool RAID1 | `sudo btrfs device delete missing /` (si el disco se quitó físicamente). Sustituir y `btrfs replace` |
| **Quota en snapshots causa lentitud extrema** | qgroups (quotas groups) consumen mucha CPU en actualizaciones | Desactivar si no se necesita: `sudo btrfs quota disable /` |

---

## Enlaces externos

- [Btrfs Wiki oficial](https://btrfs.wiki.kernel.org/)
- [Arch Wiki — Btrfs](https://wiki.archlinux.org/title/Btrfs)
- [Wikipedia — Btrfs](https://es.wikipedia.org/wiki/Btrfs)
- [btrfs-rec — herramientas de recuperación](https://github.com/danobi/btrfs-rec)
- [Status de Btrfs en kernel.org](https://btrfs.readthedocs.io/)

## Ver también

- [[Sistemas de Archivos]] — visión general y comparativa con ext4, XFS, ZFS
- [[LVM]] — gestión de volúmenes (alternativa/complemento a Btrfs multi-disco)
- [[RAID (mdadm)]] — RAID por software (alternativa al RAID integrado de Btrfs)
- [[timeshift]] — snapshots del sistema basados en Btrfs
- [[Proceso de Instalación General]] — elección de FS durante la instalación
- [[Particionado y Esquemas de Disco]] — esquemas de particionado con Btrfs

#sistema #almacenamiento #btrfs
