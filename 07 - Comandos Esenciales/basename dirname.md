---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-09-01
estado: resuelto
categoria: comando
prioridad: baja
---

# basename / dirname

> Extraer el nombre de archivo (`basename`) o el directorio (`dirname`) de una ruta. Herramientas ligeras para manipular paths en scripts.

## basename

```bash
basename /home/usuario/docs/nota.md
# nota.md

basename /home/usuario/docs/nota.md .md
# nota

basename -a /path/file1.txt /path/file2.txt
# file1.txt
# file2.txt
```

| Opción | Descripción |
|---|---|
| `-a` | Múltiples rutas |
| `-s <sufijo>` | Eliminar sufijo |
| `-z` | Separador null (para xargs) |

## dirname

```bash
dirname /home/usuario/docs/nota.md
# /home/usuario/docs

dirname /etc/passwd
# /etc

dirname nota.md
# .
```

## Ejemplos prácticos en scripts

```bash
# Obtener directorio del script actual
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Obtener nombre del archivo sin extensión
FILENAME=$(basename "$1" .tar.gz)

# Recorrer archivos en un directorio
for f in /etc/*.conf; do
    name=$(basename "$f" .conf)
    dir=$(dirname "$f")
    echo "Procesando $name en $dir"
done
```

## `realpath` (alternativa moderna)

```bash
# Obtener ruta completa canónica
realpath archivo.txt
# /home/usuario/docs/archivo.txt

# Obtener solo el directorio
realpath --directory-name archivo.txt
# /home/usuario/docs

# Obtener solo el nombre
realpath --basename archivo.txt
# archivo.txt
```

## Casos en sub-shell y pipes

```bash
# Iterar sobre un directorio sin escribir "find" por cada archivo
find . -name '*.png' -exec sh -c 'echo "Imagen: $(dirname "$1")/$(basename "$1")"' _ {} \;

# Saltar el nombre de archivo y quedarse con la carpeta
for p in $(find . -maxdepth 2 -name '*.log'); do
  log_dir=$(dirname "$p")
  echo "Analizando logs en $log_dir" && tail -3 "$p"
done
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `dirname` devuelve `.` para rutas relativas sin `/` | No hay separador de directorio | Usar `realpath` si necesitas la ruta canónica completa |
| `basename` deja la extensión | No pasaste el sufijo | `basename archivo.tar.gz .tar.gz` |
| Comillas perdidas en scripts | Rutas sin comillar | Siempre `"$(basename "$var")"` |

## Ver también

- `ls` — ver archivos en un directorio
- `readlink -f` — resolver ruta completa
- `find` — buscar archivos
- `pathchk` — verificar si una ruta es válida

## Enlaces externos

- [Man page — basename](https://man7.org/linux/man-pages/man1/basename.1.html)
- [Man page — dirname](https://man7.org/linux/man-pages/man1/dirname.1.html)

#comando #texto #scripts
