---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# fd (fd-find)

> Alternativa moderna a `find`. Busca archivos en tiempo real con colores, respeta `.gitignore`, y es 5-10× más rápido que `find` para uso diario.

## Qué es

`fd` es un reemplazo de `find` escrito en Rust. No usa base de datos indexada (como `locate`), sino que recorre el sistema de archivos en tiempo real pero optimizado con paralelismo y filtros inteligentes.

**Ventajas sobre `find`:**
- Sintaxis intuitiva: `fd patrón` vs `find -name 'patrón'`
- Colores por tipo de archivo (archivo, directorio, symlink, ejecutable)
- Respeta `.gitignore` por defecto (ideal para proyectos)
- Regex inteligente (no necesitas escapar caracteres comunes)
- 5-10× más rápido que `find` en directorios grandes

## Instalación

```bash
# Debian/Ubuntu (el binario se llama fdfind)
sudo apt install fd-find

# Arch
sudo pacman -S fd

# Fedora
sudo dnf install fd-find

# Con cargo (Rust)
cargo install fd-find

# Alias recomendado (Debian/Ubuntu):
echo \"alias fd='fdfind'\" >> ~/.bashrc
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `-H`, `--hidden` | Buscar archivos ocultos |
| `-I`, `--no-ignore` | No ignorar `.gitignore` |
| `-e`, `--extension` | Filtrar por extensión (`fd -e py`) |
| `-t`, `--type` | Tipo: `f` (archivo), `d` (directorio), `l` (symlink), `x` (ejecutable) |
| `-s`, `--case-sensitive` | Búsqueda sensible a mayúsculas |
| `-i`, `--ignore-case` | Ignorar mayúsculas (por defecto en minúsculas) |
| `-g`, `--glob` | Patrón glob (`fd -g '*.log'`) |
| `-E`, `--exclude` | Excluir patrón |
| `-p`, `--full-path` | Buscar en la ruta completa |
| `-d`, `--max-depth` | Profundidad máxima |
| `-L`, `--follow` | Seguir enlaces simbólicos |
| `-x`, `--exec` | Ejecutar comando por resultado |
| `-0`, `--print0` | Separar por null (para xargs) |
| `--size` | Filtrar por tamaño (`fd --size +100k`) |
| `--changed-within` | Modificado en los últimos N días |
| `--changed-before` | Modificado antes de N días |

## Ejemplos

```bash
# Buscar archivos por nombre
fd \"nginx.conf\"                     # busca en todo el árbol (respeta .gitignore)
fd -H \".bashrc\"                     # incluyendo archivos ocultos
fd -I \"secrets\"                      # ignorando .gitignore

# Filtrar por tipo
fd -t f \"config\"                     # solo archivos (no directorios)
fd -t d \"src\"                        # solo directorios
fd -t x \"script\"                     # solo ejecutables

# Filtrar por extensión
fd -e py                             # todos los archivos .py
fd -e md -e txt                      # .md y .txt
fd -e rs -x wc -l                    # contar líneas de todos los .rs

# Búsqueda por tamaño
fd --size +1M                        # archivos mayores a 1 MB
fd --size -10k                       # archivos menores a 10 KB
fd -e jpg --size +5M                 # fotos grandes

# Búsqueda por fecha
fd --changed-within 7d               # modificados en la última semana
fd --changed-before \"2026-01-01\"    # modificados antes de 2026

# Ejecutar comandos con los resultados
fd -e py -x echo \"Archivo: {}\"       # imprime cada archivo .py
fd -e jpg -x mv {} ~/fotos/          # mover todas las fotos
fd -e zip -x unzip -l {}             # listar contenido de zips

# Buscar con glob (no regex)
fd -g '*.test.js'                    # solo archivos .test.js
fd -g '**/node_modules/**'           # dentro de node_modules

# Excluir directorios
fd -E node_modules \"config\"          # excluir node_modules
fd -E .git -E target \"main\"          # excluir varios
```

## Integración con fzf

```bash
# La combinación más potente para búsqueda interactiva
fd -t f | fzf                        # buscar archivos con fuzzy finder
fd -t d | fzf                        # buscar directorios

# Abrir archivo seleccionado con fzf + fd
vim \"$(fd -t f | fzf)\"              # buscar y abrir en vim

# cd a un directorio
cd \"$(fd -t d | fzf)\"

# Buscar y previsualizar
fd -t f | fzf --preview 'bat {}'     # ver preview con bat
```

## Comparativa

| Aspecto | fd | find | locate | fzf |
|---|---|---|---|---|
| **Velocidad** | ⚡ Rápido (paralelo) | Moderado | ❌ Instantáneo (índice) | N/A |
| **Sintaxis** | Intuitiva (`fd patrón`) | Verbosa (`-name 'patrón'`) | Simple (`locate patrón`) | Pipe desde stdin |
| **Respeta .gitignore** | ✅ Por defecto | ❌ | ❌ | ❌ |
| **Colores** | ✅ Por tipo | ❌ | ❌ | ❌ |
| **Búsqueda indexada** | ❌ Tiempo real | ❌ Tiempo real | ✅ Base de datos | ❌ |
| **Interactivo** | ❌ | ❌ | ❌ | ✅ Fuzzy finder |

> `fd` es perfecto para búsquedas rápidas en proyectos de código. `locate` es más rápido si buscas en todo el sistema. `fzf` combinado con `fd` es lo mejor para búsqueda interactiva.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `fd: command not found` | Binario se llama `fdfind` en Debian | Usar `fdfind` o alias `alias fd='fdfind'` |
| No encuentra archivos | `.gitignore` los excluye | Usar `-I` (no ignorar) |
| Demasiados resultados | Sin filtro de profundidad | Usar `-d 3` (máximo 3 niveles) |
| Quiero regex complejo | `fd` usa regex simple | `fd '^src.*test'` (regex básico) |

## Ver también

- [[find]] — búsqueda clásica
- [[locate]] — búsqueda indexada
- [[fzf]] — búsqueda difusa interactiva
- [[grep]] — buscar contenido en archivos
- [[ripgrep]] — grep moderno en Rust (del mismo ecosistema)

## Enlaces externos

- [GitHub — sharkdp/fd](https://github.com/sharkdp/fd)
- [Arch Wiki — Fd](https://wiki.archlinux.org/title/Fd)

#programa #herramientas #busqueda
