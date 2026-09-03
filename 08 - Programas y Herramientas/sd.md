---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: baja
---

# sd

> sed moderno, simple e intuitivo. Reemplaza patrones en archivos y pipes con una sintaxis mucho más clara que `sed`.

## Qué es

**sd** (search and destroy) es un reemplazo de `sed` para las operaciones más comunes: buscar y reemplazar texto. A diferencia de `sed`, sd usa una sintaxis consistente `sd 'pattern' 'replacement'` sin necesidad de delimitadores `/`, flags confusos o escaping de barras.

**Ventajas sobre `sed`:**
- Sintaxis simple: `sd 'pattern' 'replacement'`
- Delimitador automático (no necesitas `/` ni `\`)
- Regex por defecto (PCRE)
- Preserva permisos del archivo
- Colores en la salida (diferencias)

## Instalación

```bash
# Debian/Ubuntu
sudo apt install sd

# Arch / CachyOS
sudo pacman -S sd

# Fedora
sudo dnf install sd

# Cargo
cargo install sd
```

## Uso

```bash
# Reemplazar en archivo (in-place)
sd 'pattern' 'replacement' archivo.txt

# Reemplazar en pipe
cat archivo.txt | sd 'old' 'new'

# Reemplazar con regex
sd '\d+' 'NUMERO' archivo.txt

# Reemplazar con captures
sd '(\w+) (\w+)' '$2 $1' archivo.txt   # intercambiar palabras
```

## Ejemplos

```bash
# Cambiar extensión de todos los archivos .jpg a .png
sd '\.jpg$' '.png' *.txt

# Eliminar líneas vacías
sd '\n\n' '\n' archivo.txt

# Formatear fecha
sd '(\d{4})-(\d{2})-(\d{2})' '$3/$2/$1' archivo.txt

# Reemplazar espacios múltiples por uno
sd ' +' ' ' archivo.txt

# Cambiar todos los .md a .txt
sd '\.md$' '.txt' *.md
```

## Comparativa con `sed`

| Operación | sed | sd |
|---|---|---|
| Reemplazo simple | `sed 's/old/new/g'` | `sd 'old' 'new'` |
| Regex con captures | `sed 's/\(foo\)/[\1]/g'` | `sd 'foo' '[$1]'` |
| Archivo in-place | `sed -i 's/.../.../g'` | `sd '...' '...'` |
| Delimitador | Necesita `/` o `#` | Automático |
| Flags | `-i`, `-E`, `-n`... | Integrados |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No reemplaza en varios ficheros | `sd` opera por archivo, no recursivo | Iterar: `rg -l 'regla' archivos | xargs -I{} sd 'patrón' 'nuevo' {}` |
| Caracteres literales interpretados como regex | `sd` usa regex por defecto | Usar `-F` (fixed string) o escapar el patrón |
| Edición in-place no persistida | Faltó el flag `-i` | `sd 'patrón' 'nuevo' archivo -i` |
| `$`/`\` en el reemplazo dan salida inesperada | Colisiones de escapes de regex/captura | Ajustar el escaping de capturas o usar `-F` |
| Diferencias con sed al sustituir en sitio | Sintaxis distinta (sd: archivo al final) | Revisar el orden: `sd patrón reemplazo archivo -i` |

## Ver también

- `sed` — editor de flujo clásico
- `awk` — procesamiento por columnas
- [[sed y awk]] — índice de sed y awk
- [[Regular Expressions]] — patrones de búsqueda
- `ruplacer` — alternativa similar

## Enlaces externos

- [GitHub — sd](https://github.com/chmln/sd)
- [Arch Wiki — sd](https://wiki.archlinux.org/title/Sd)

#programa #terminal #texto
