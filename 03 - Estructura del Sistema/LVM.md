---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: sistema
prioridad: media
---

# LVM (Logical Volume Manager)

## Definición

LVM es una capa de abstracción entre los discos físicos y los sistemas de archivos. Permite gestionar el almacenamiento de forma flexible: redimensionar volúmenes en caliente, combinar varios discos en un solo volumen lógico, crear snapshots, y mover datos entre discos sin desmontar.

Fue escrito originalmente en **1998 por Heinz Mauelshagen**, basado en el administrador de volúmenes Veritas usado en sistemas HP-UX. Existen dos versiones: **LVM1** (original, limitado) y **LVM2** (actual, con device-mapper y snapshots de lectura/escritura).

```
Arquitectura LVM:

  ┌──────────┐  ┌──────────┐        Discos físicos (PV)
  │ /dev/sda │  │ /dev/sdb │
  └────┬─────┘  └────┬─────┘
       └──────┬──────┘
         ┌────▼────┐                   Grupo de Volúmenes (VG)
         │  vg_main │
         └─┬─────┬─┘
    ┌──────▼──┐ ┌▼───────┐            Volúmenes Lógicos (LV)
    │ lv_root │ │ lv_home │
    ├─────────┤ ├─────────┤
    │ ext4    │ │ ext4     │
    │ 40 GB   │ │ 80 GB   │
    └─────────┘ └─────────┘
```

## Componentes

| Componente | Abreviatura | Qué es |
|---|---|---|
| **Physical Volume** (PV) | PV | Disco o partición marcada para LVM (ej. `/dev/sda1`). Se divide en bloques llamados **Physical Extents (PE)** |
| **Volume Group** (VG) | VG | Grupo que reúne uno o varios PVs en un pool de almacenamiento. Todas las PE en el VG tienen el mismo tamaño |
| **Logical Volume** (LV) | LV | "Partición virtual" creada del VG, donde se pone el sistema de archivos. Se divide en **Logical Extents (LE)** del mismo tamaño que las PE |

### Extents (PE y LE)

LVM divide cada PV en bloques de tamaño fijo llamados **Physical Extents (PE)**. De forma similar, un LV se divide en **Logical Extents (LE)**. La correspondencia entre LE y PE se almacena en una **tabla de mapeo**:

| Tipo de mapeo | Descripción |
|---|---|
| **Directo** | Un rango de LE se asigna a un rango consecutivo de PE en un solo PV (ej. LE 1-99 → PE 100-347 del PV2) |
| **Entrelazado (striping)** | Los chunks de datos se entrelazan entre varios PVs, mejorando rendimiento (similar a RAID 0). Ej: 1er chunk en PV1, 2º en PV2, 3º en PV1... |

El tamaño de PE se define al crear el VG (por defecto 4 MiB) y afecta al rendimiento y granularidad del espacio.

### Tabla de mapeo

```
LV: lv_datos (LEs: 1..347)
  ├── LE 001-099  → PV1 (sda1) PE 001-099  [mapeo directo]
  └── LE 100-347  → PV2 (sdb1) PE 001-248  [mapeo directo]
```

## Ventajas en sistemas pequeños vs grandes

| Escenario | Ventaja LVM |
|---|---|
| **PC de escritorio** | Evita estimar tamaños fijos al instalar: creas un VG con todo el disco y slices flexibles. Si `/home` se llena, lo redimensionas desde `/opt` sin tocar particiones |
| **Servidor** | Añadir discos sin tiempo de inactividad: agregas un PV al VG, extiendes el LV y el FS, y el almacenamiento crece en caliente |
| **Multi-usuario** | Grupos de usuarios ("ventas", "desarrollo") tienen LVs independientes que pueden crecer según necesidad |
| **Migración** | Migras datos de discos antiguos a nuevos sin que el usuario lo note (p. ej. `pvmove /dev/sda /dev/sdc`) |

## Comandos principales

```bash
# 1. Preparar discos físicos
sudo pvcreate /dev/sda1 /dev/sdb1       # marcar particiones como PVs
sudo pvs                                 # listar PVs

# 2. Crear grupo de volúmenes
sudo vgcreate vg_main /dev/sda1 /dev/sdb1  # agrupar PVs en un VG
sudo vgs                                 # listar VGs

# 3. Crear volúmenes lógicos
sudo lvcreate -L 40G -n lv_root vg_main  # LV de 40GB llamado lv_root
sudo lvcreate -L 80G -n lv_home vg_main  # LV de 80GB llamado lv_home
sudo lvs                                 # listar LVs

# 4. Formatear y montar (igual que particiones normales)
sudo mkfs.ext4 /dev/vg_main/lv_root
sudo mount /dev/vg_main/lv_root /mnt

# 5. Redimensionar en caliente
sudo lvextend -L +10G /dev/vg_main/lv_home    # añadir 10 GB al LV
sudo resize2fs /dev/vg_main/lv_home            # redimensionar el FS para que lo reconozca
```

## Snapshots

LVM permite crear instantáneas (snapshots) de un volumen lógico en segundos:

```bash
sudo lvcreate -L 5G -s -n lv_home_snap /dev/vg_main/lv_home   # snapshot de 5GB
sudo mount /dev/vg_main/lv_home_snap /mnt/snap                 # montar para backup
sudo lvremove /dev/vg_main/lv_home_snap                        # eliminar snapshot
```

Útil para backups consistentes: montas el snapshot mientras el volumen original sigue en uso.

## LVM vs particionado tradicional

| Característica | Particiones clásicas | LVM |
|---|---|---|
| Redimensionar | Limitado (necesita herramientas como GParted, a veces no posible en caliente) | ✅ En caliente y sin desmontar |
| Múltiples discos | Cada disco es independiente | ✅ Varios discos se combinan en un VG |
| Snapshots | ❌ No | ✅ Sí |
| Complejidad | Baja | Alta (curva de aprendizaje) |

## Por qué importa

- En servidores, permite añadir discos sin tiempo de inactividad: agregas un PV al VG, extiendes el LV y el FS, y la partición crece en caliente.
- En escritorio, es overkill a menos que tengas necesidades específicas (querer separar root de home, hacer snapshots regulares).
- La mayoría de instaladores de distros ofrecen LVM como opción durante el particionado (Ubuntu, Fedora, RHEL).

## Relación con otros conceptos

- [[Particionado y Esquemas de Disco]] — LVM es una alternativa/reemplazo del particionado tradicional
- [[Filesystem Hierarchy Standard]] — los FS van sobre los LVs

## Ver también

- [[Particionado y Esquemas de Disco]]
- [[Filesystem Hierarchy Standard]]
- [[Permisos y Propietarios]]

## Enlaces externos

- [Wikipedia — Logical Volume Manager (Linux)](https://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux))
- [Arch Wiki — LVM](https://wiki.archlinux.org/title/LVM)
- [Red Hat — LVM administration](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_logical_volumes/index)

#sistema
