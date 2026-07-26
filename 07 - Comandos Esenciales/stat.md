---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# stat

> Muestra metadata detallada de archivos: permisos, owner, timestamps (access/modify/change), inode, tamaño, bloques.

## Sintaxis

```bash
stat [opciones] [archivo...]
```

## Descripción

`stat` muestra información que `ls -l` no muestra: tres timestamps distintos (atime, mtime, ctime), número de inode, bloques asignados, y formato personalizable. Esencial para debugging de filesystem y scripts que dependen de metadata.

## Opciones principales

| Opción | Descripción |
|---|---|
| `-c "formato"` | Formato de salida personalizado |
| `-f` | Info del filesystem (no del archivo) |
| `-t` | Formato corto (para parsing) |
| `-L` | Seguir symlinks |
| `-A` | No mostrar header |

## Formato de salida por defecto

```
File: archivo.txt
  Size: 1024       Blocks: 8          IO Block: 4096   regular file
Device: 802h/2050d Inode: 1234567     Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/  carlos)   Gid: ( 1000/  carlos)
Access: 2026-07-25 10:30:00.000000000 -0300
Modify: 2026-07-24 15:45:00.000000000 -0300
Change: 2026-07-24 15:45:00.000000000 -0300
 Birth: 2026-07-20 09:00:00.000000000 -0300
```

### Los 3 timestamps

| Timestamp | Qué mide | Cambia cuando... |
|---|---|---|
| **Access (atime)** | Último acceso (lectura) | Lees el archivo |
| **Modify (mtime)** | Última modificación de contenido | Editas el archivo |
| **Change (ctime)** | Último cambio de metadata | Cambias permisos, owner, o editas |
| **Birth (btime)** | Fecha de creación | Solo al crear (no todos los FS lo soportan) |

## Ejemplos

### Ver info completa de un archivo
```bash
stat archivo.txt
```

### Formato personalizado
```bash
stat -c "%n: %s bytes, %A, modified %y" archivo.txt
# archivo.txt: 1024 bytes, -rw-r--r--, modified 2026-07-24 15:45:00.000000000 -0300
```

### Ver info del filesystem
```bash
stat -f /
# File: "/"
#     ID: 80200000000   Namelen: 255    Type: ext2/ext3
# Block size: 4096       Blocks: Total: 123456   Free: 67890
```

### Seguir symlinks
```bash
stat -L enlace_simbolico
```

### Comparar timestamps de dos archivos
```bash
diff <(stat -c '%Y' a.txt) <(stat -c '%Y' b.txt)
```

## Codificaciones de formato (-c)

| Código | Significado | Ejemplo |
|---|---|---|
| `%n` | Nombre | `archivo.txt` |
| `%s` | Tamaño (bytes) | `1024` |
| `%A` | Permisos legibles | `-rw-r--r--` |
| `%a` | Permisos octal | `644` |
| `%U` | Owner (nombre) | `carlos` |
| `%u` | Owner (UID) | `1000` |
| `%y` | Modify time | `2026-07-24 15:45:00` |
| `%x` | Access time | `2026-07-25 10:30:00` |
| `%w` | Change time | `2026-07-24 15:45:00` |
| `%i` | Inode | `1234567` |
| `%F` | Tipo de archivo | `regular file` |

## Casos de uso

### Encontrar archivos modificados en las últimas 24h
```bash
find . -maxdepth 1 -name "*.md" -exec stat -c '%Y %n' {} \; | \
  awk '$1 > '"$(date -d '1 day ago' +%s)"' {print $2}'
```

### Verificar si un archivo es symlink
```bash
stat -c '%F' enlace
# symlink
```

### Verificar integridad de backup
```bash
# Comparar mtime de original vs backup
stat -c '%Y %n' original.txt backup.txt
```

## Combinaciones pipe

```bash
# Tamaño de todos .md en KB, ordenados
find . -name "*.md" -exec stat -c '%s %n' {} \; | \
  awk '{printf "%.1f KB %s\n", $1/1024, $2}' | sort -rn | head -10

# Solo archivos vacíos
find . -name "*.md" -empty
```

## Alternativas

| Herramienta | Cuándo usarla |
|---|---|
| **stat** | Metadata detallada, timestamps, formato custom |
| **ls -l** | Vista rápida de permisos |
| **file** | Tipo de contenido (magic numbers) |

## Ver también

- [[ls]] — listado rápido de archivos
- [[file]] — tipo de contenido
- [[chmod]] — cambiar permisos
- [[chown]] — cambiar owner
- [[find]] — buscar archivos por criteria

## Enlaces externos

- [man stat(1)](https://man7.org/linux/man-pages/man1/stat.1.html)
- [GNU Coreutils — stat](https://www.gnu.org/software/coreutils/manual/html_node/stat-invocation.html)
- [Wikipedia — stat(2)](https://en.wikipedia.org/wiki/Stat_(system_call))

#comando
