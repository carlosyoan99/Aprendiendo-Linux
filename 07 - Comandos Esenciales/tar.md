---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: alta
---

# tar

> Empaqueta y comprime archivos y directorios. Formato estándar en Linux para distribuir código fuente, backups y paquetes. La "navaja suiza" de compresión en terminal.

## Sintaxis

```bash
tar [opciones] [archivo.tar] [archivos/directorios]
```

## Descripción

Empaqueta y comprime archivos y directorios. Es el formato estándar en Linux para distribuir código fuente, backups y paquetes. Por sí solo solo empaqueta (sin compresión) — se combina con gzip, bzip2 o xz para comprimir. A diferencia de zip, tar **preserva permisos**, propietarios y estructura de directorios de Linux.

## Opciones principales

### Crear / Extraer / Listar

| Flag | Significado |
|---|---|
| `-c` | Crear un nuevo archivo |
| `-x` | Extraer un archivo |
| `-t` | Listar contenido sin extraer |
| `-f archivo` | Especificar el nombre del archivo .tar |

### Compresión

| Flag | Formato | Extensión | Velocidad | Compresión |
|---|---|---|---|---|
| `-z` | gzip | `.tar.gz` | Rápida | Buena |
| `-j` | bzip2 | `.tar.bz2` | Media | Mejor |
| `-J` | xz | `.tar.xz` | Lenta | Máxima |

### Otras opciones

| Flag | Efecto |
|---|---|
| `-v` | Verboso — muestra lo que se procesa |
| `-C directorio` | Extraer en un directorio específico |
| `--exclude=patron` | Excluir archivos que coincidan |
| `--exclude-from=archivo` | Excluir desde lista |
| `-p` | Preservar permisos al extraer |
| `--numeric-owner` | No resolver UID/GID a nombres |

## Mnemotecnia

```bash
# c=crear, x=extraer, t=listar (table of contents)
# z=gzip, j=bzip2, J=xz
# f=file (SIEMPRE va al final, antes del nombre del archivo)
# v=verbose (opcional, para ver qué hace)
```

## Ejemplos

```bash
# ── Crear ──

tar -czf proyecto.tar.gz proyecto/          # empaquetar + comprimir con gzip
tar -cjf proyecto.tar.bz2 proyecto/         # con bzip2
tar -cJf proyecto.tar.xz proyecto/          # con xz
tar -czvf proyecto.tar.gz proyecto/         # verbose

# Solo empaquetar (sin compresión)
tar -cf proyecto.tar proyecto/

# ── Extraer ──

tar -xzf proyecto.tar.gz                    # extraer en el directorio actual
tar -xzf proyecto.tar.gz -C /tmp/           # extraer en /tmp
tar -xjf proyecto.tar.bz2                   # extraer bzip2
tar -xJf proyecto.tar.xz                    # extraer xz

# ── Inspeccionar ──

tar -tzf proyecto.tar.gz                    # listar contenido sin extraer
tar -tzf proyecto.tar.gz | grep "config"    # buscar archivos específicos
tar -tzf proyecto.tar.gz | wc -l            # contar archivos

# ── Excluir ──

tar -czf backup.tar.gz /home/usuario \
  --exclude=".cache" \
  --exclude="node_modules" \
  --exclude=".local/share/Trash"

# Excluir desde archivo (uno por línea)
tar -czf backup.tar.gz /home/ --exclude-from=excluir.txt

# ── Backup del sistema ──

sudo tar -czvf /backup/root-$(date +%F).tar.gz / \
  --exclude=/proc \
  --exclude=/sys \
  --exclude=/dev \
  --exclude=/run \
  --exclude=/tmp \
  --exclude=/mnt \
  --exclude=/media \
  --exclude=/backup
```

## Comparativa de formatos de compresión

| Formato | Compresión | Velocidad | CPU | Uso ideal |
|---|---|---|---|---|
| **gzip** (.tar.gz) | ~65% | Muy rápida | Baja | Uso general, distribución |
| **bzip2** (.tar.bz2) | ~75% | Media | Media | Cuando espacio importa |
| **xz** (.tar.xz) | ~85% | Lenta | Alta | Máxima compresión |
| **zstd** (.tar.zst) | ~70% | Muy rápida | Baja | balance compresión/velocidad |

## tar vs zip vs 7z

| Característica | tar + compresión | zip | 7z |
|---|---|---|---|
| **Preserva permisos Linux** | ✅ | ❌ | Parcial |
| **Compatible Windows** | ❌ | ✅ | ✅ (7-Zip) |
| **Compresión máxima** | xz (~85%) | deflate (~60%) | LZMA2 (~95%) |
| **Empaquetar sin comprimir** | ✅ (tar solo) | ❌ | ❌ |
| **Ideal para** | Backups Linux, distribución | Compartir con Windows | Máxima compresión |

## Notas y advertencias

- El flag `-f` debe ir siempre **al final** de los flags, justo antes del nombre del archivo: `tar -czf archivo.tar.gz destino/`.
- No olvides la extensión: `.tar.gz` para gzip, `.tar.xz` para xz. El comando funciona igual, pero la extensión ayuda a recordar cómo extraerlo.
- Para extraer: `tar -xzf archivo.tar.gz` (solo cambia crear por extraer).
- Ver el contenido antes de extraer con `tar -tzf archivo.tar.gz` evita sorpresas.
- `tar` sin flag de compresión solo empaqueta — no comprime. Necesitas `-z`, `-j` o `-J`.

## Ver también

- [[zip]] — formato universal (Windows/macOS)
- [[rsync]] — sincronización incremental
- [[Backups (borg restic duplicity rsync)]] — estrategias de backup
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — tar (computing)](https://en.wikipedia.org/wiki/Tar_(computing))
- [GNU tar manual](https://www.gnu.org/software/tar/manual/)
- [Arch Wiki — tar](https://man.archlinux.org/man/tar.1)

#comando #compresion #backup
