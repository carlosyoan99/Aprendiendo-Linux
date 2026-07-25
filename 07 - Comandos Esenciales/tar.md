---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: comando
prioridad: alta
---

# tar

## Sintaxis
```
tar [opciones] [archivo.tar] [archivos/directorios]
```

## Descripción
Empaqueta y comprime archivos y directorios. Es el formato estándar en Linux para distribuir código fuente, backups y paquetes. Por sí solo solo empaqueta (sin compresión) — se combina con gzip, bzip2 o xz para comprimir.

## Opciones frecuentes

### Crear / Extraer

| Flags cortos | Significado |
|---|---|
| `-c` | Crear un nuevo archivo |
| `-x` | Extraer un archivo |
| `-t` | Listar contenido sin extraer |
| `-f archivo` | Especificar el nombre del archivo .tar |

### Compresión

| Flag | Formato | Extensión |
|---|---|---|
| `-z` | gzip (rápido, compatible) | `.tar.gz` |
| `-j` | bzip2 (mejor compresión, más lento) | `.tar.bz2` |
| `-J` | xz (mejor compresión, lento) | `.tar.xz` |

### Otras opciones

| Flag | Efecto |
|---|---|
| `-v` | Verboso — muestra lo que se procesa |
| `-C directorio` | Extraer en un directorio específico |
| `--exclude=patron` | Excluir archivos que coincidan |

## Mnemotecnia

```bash
# Recordar: c=crear, x=extraer, t=listar (table of contents)
# Recordar: z=gzip, j=bzip2, J=xz
# Recordar: f=file (siempre va al final, antes del nombre del archivo)
```

## Ejemplos

```bash
# Crear
tar -czf proyecto.tar.gz proyecto/          # empaquetar + comprimir con gzip
tar -cjf proyecto.tar.bz2 proyecto/         # con bzip2
tar -cJf proyecto.tar.xz proyecto/          # con xz
tar -czvf proyecto.tar.gz proyecto/         # verbose

# Extraer
tar -xzf proyecto.tar.gz                    # extraer en el directorio actual
tar -xzf proyecto.tar.gz -C /tmp/           # extraer en /tmp
tar -xjf proyecto.tar.bz2                   # extraer bzip2

# Inspeccionar
tar -tzf proyecto.tar.gz                    # listar contenido sin extraer
tar -tzf proyecto.tar.gz | grep "config"    # buscar archivos específicos dentro

# Excluir
tar -czf backup.tar.gz /home/usuario --exclude=".cache" --exclude="node_modules"
```

## Notas y advertencias
- El flag `-f` debe ir siempre **al final** de los flags, justo antes del nombre del archivo: `tar -czf archivo.tar.gz destino/`.
- No olvides la extensión: `.tar.gz` para gzip, `.tar.xz` para xz. El comando funciona igual, pero la extensión ayuda a recordar cómo extraerlo.
- Para extraer: `tar -xzf archivo.tar.gz` (solo cambia crear por extraer).
- Ver el contenido antes de extraer con `tar -tzf archivo.tar.gz` evita sorpresas (como que extraiga todo en el directorio actual sin subcarpeta).

## Enlaces externos

- [Wikipedia — tar (computing)](https://en.wikipedia.org/wiki/Tar_(computing))
- [GNU tar manual](https://www.gnu.org/software/tar/manual/)

## Ver también
- [[zip]]
- [[Cheat Sheet - Comandos Esenciales]]

#comando
