---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: media
---

# touch

> Actualiza las marcas de tiempo (timestamps) de un archivo y lo crea vacío si no existe.

## Sintaxis

```bash
touch [opciones] archivo...
```

## Descripción

`touch` actualiza las marcas de tiempo (atime y mtime) de los archivos indicados a la hora actual, o las fija a un valor concreto con `-t`/`-d`. Si el archivo no existe, lo **crea vacío**. Pertenece a `coreutils`, no requiere sudo y no es destructivo: nunca modifica el contenido. Es clave en scripts (crear archivos de marcado), en `make` y Makefiles (decide qué recompilar según timestamps) y en pruebas de ordenación por fecha.

## Formato de salida

`touch` no produce salida estándar: el resultado se comprueba con otras herramientas.

| Herramienta | Muestra |
|---|---|
| `stat archivo` | atime, mtime, ctime y tamaño |
| `ls -l` | mtime (modificación) |
| `ls -l --time=atime` | atime (acceso) |
| `ls --full-time` | timestamps completos |

## Opciones frecuentes

| Flag / Opción | Efecto | Ejemplo |
|---|---|---|
| `-a` | Cambia solo el atime | `touch -a log.txt` |
| `-m` | Cambia solo el mtime | `touch -m log.txt` |
| `-c` | No crea el archivo si no existe | `touch -c solo-si-existe.txt` |
| `-t [CC]YYMMDDhhmm[.ss]` | Timestamp concreto | `touch -t 202608011200 nota.md` |
| `-d "fecha"` | Fecha libre o relativa | `touch -d "2 weeks ago" viejo.log` |
| `-r REF` | Copia el timestamp de otro archivo | `touch -r modelo.txt copia.txt` |
| `-h` | Actúa sobre el symlink, no sobre su destino | `touch -h enlace` |

## Ejemplos de uso

```bash
touch nota.txt                       # crear un archivo vacío
touch a.txt b.txt c.txt              # varios a la vez
touch {doc1,doc2,doc3}.md            # con brace expansion
touch -c solo-si-existe.txt          # no crear si no existe
touch -t 202608011200.30 fecha.txt   # timestamp fijo
touch -d "yesterday" viejo.log       # fecha relativa
touch -r referencia.txt destino      # replicar timestamp de otro archivo
touch -a -m archivo                  # forzar el momento actual en ambos
```

## Casos de uso reales

- Forzar recompilación: un `make` no reconstruye si los fuentes no son más nuevos que el objeto; `touch fuente.c` lo fuerza.
- Archivos de marcado (flag files) en scripts: `if [ -f /tmp/fase1.done ]; then ...` para señalar fases completadas.
- Pruebas de ordenación: crear archivos con fechas distintas con `-d` y verificar con `ls -lt`.
- Normalizar timestamps de archivos descargados para que `rsync`/backups no los copien de más.
- Comprobar permisos: `touch /ruta` falla donde no tienes escritura.

## Combinaciones comunes con pipe

```bash
# Crear archivos de prueba en lote
touch /tmp/prueba-{a,b,c}.tmp

# Tocar todos los .py que hayan cambiado hoy
find . -name '*.py' -mtime -1 -exec touch {} \;

# Ver timestamp antes y después
stat -c '%y %n' archivo && touch archivo && stat -c '%y %n' archivo

# Crear el flag de solo lectura que hacen algunos instaladores
sudo touch /etc/apt/sources.list
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `touch` crear vacío | `[ -e x ] || touch x` | No toca el mtime si el archivo ya existe |
| `touch -c` | `test -f x && touch x` | Equivalente explícito y legible |
| — | `date` + `touch -d` | `touch` no tiene sustituto: sigue en coreutils |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `Permission denied` | Sin permiso de escritura en archivo o directorio | `sudo touch` o ajustar permisos |
| `No such file or directory` | El directorio destino no existe | Crear el directorio con `mkdir -p` |
| No se crea el archivo | Se usó `-c` | Quitar `-c` para crearlo |
| Timestamp erróneo con `-t` | Formato incorrecto | Seguir `[[CC]YY]MMDDhhmm[.ss]` |
| `Read-only file system` | FS montado sin escritura (típico NTFS/pendrive) | Remontar con `mount -o rw,remount` |

## Notas y advertencias

- `touch` jamás toca el contenido: solo las marcas de tiempo.
- Retrasar mtime hacia el futuro puede confundir a `make`, `rsync` y a cualquier herramienta de sincronización.
- `touch -t`/`-d` no cambian el reloj del sistema: para eso está `date`.
- Con montajes `relatime` el `atime` prácticamente no se actualiza salvo consulta real.
- No esperes salida del comando: verifica con `stat`.

## Enlaces externos

- [Wikipedia — touch (Unix)](https://en.wikipedia.org/wiki/Touch_(Unix))
- [GNU Coreutils — touch invocation](https://www.gnu.org/software/coreutils/manual/html_node/touch-invocation.html)
- [man touch(1)](https://man7.org/linux/man-pages/man1/touch.1.html)

## Ver también

- [[cat]] — ver y crear contenido de archivos (redirección)
- [[stat]] — inspeccionar timestamps y metadatos
- [[find]] — localizar archivos por timestamp (`-mtime`, `-newer`)
- [[date]] — manejar fechas y formatos compatibles con `-d`
- [[history]] — historial de comandos (par con Touch)
- [[Coreutils y util-linux]] — la suite a la que pertenece

#comando