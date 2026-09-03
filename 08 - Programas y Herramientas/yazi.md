---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# yazi

> ⚡ Gestor de archivos TUI escrito en Rust. El más rápido de su clase, con previsualización de imágenes, pestañas, y navegación Vim.

## Qué es

**yazi** (que significa "rápido" en chino) es un gestor de archivos para terminal que prioriza la velocidad y la experiencia visual. Ofrece previsualización de imágenes (incluso en terminales sin sixel, via kitty/ueberzug), código con syntax highlighting, pestañas, y navegación Vim. Todo asíncrono, todo rápido.

## Instalación

```bash
# No está en repos oficiales. Descargar binario desde GitHub:

# Opción 1: script oficial
curl -sLO https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
unzip yazi-x86_64-unknown-linux-gnu.zip
sudo mv yazi /usr/local/bin/

# Opción 2: con cargo (Rust)
cargo install --locked yazi-fm

# Opción 3: Homebrew
brew install yazi

# Verificar
yazi --version
```

## Atajos esenciales

### Navegación

| Tecla | Acción |
|---|---|
| `h` / `j` / `k` / `l` | Vim: subir / bajar / atrás / entrar |
| `g` / `G` | Ir al principio / final de la lista |
| `Ctrl+d` / `Ctrl+u` | Media página abajo / arriba |
| `~` | Ir al directorio home |
| `Tab` | Siguiente pestaña |
| `Ctrl+Tab` | Pestaña anterior |
| `q` | Salir |

### Gestión de archivos

| Tecla | Acción |
|---|---|
| `espacio` | Seleccionar archivo (múltiple) |
| `v` | Alternar selección visible |
| `y` | Copiar (yank) archivos seleccionados |
| `x` | Cortar archivos seleccionados |
| `p` | Pegar archivos |
| `d` | Mover a la papelera (trash) |
| `D` | Eliminar permanentemente |
| `a` | Renombrar archivo |
| `r` | Abrir en el editor por defecto |
| `o` | Abrir archivo con el programa por defecto |
| `Ctrl+r` | Refrescar directorio |

### Búsqueda y filtros

| Tecla | Acción |
|---|---|
| `/` | Buscar archivo por nombre |
| `f` | Filtrar archivos (por tipo/patrón) |
| `z` | Mostrar/ocultar archivos ocultos |
| `:` | Línea de comandos (como en Vim) |

### Previsualización

| Tecla | Acción |
|---|---|
| `m` | Entrar/salir de modo de previsualización |
| `-` | Alternar panel de previsualización |
| `Tab` | Navegar entre paneles (archivos / previsualización) |

## Configuración: `~/.config/yazi/yazi.toml`

```toml
[manager]
show_hidden = false
sort_by = "alphabetical"
sort_dir_first = true
linemode = "none"

[preview]
max_width = 600
max_height = 900
cache_dir = "/tmp/yazi"

[opener]
edit = [
    { run = 'nvim "$@"', block = true, desc = "nvim" },
    { run = 'micro "$@"', block = true, desc = "micro" },
]
```

### Tema: `~/.config/yazi/theme.toml`

```toml
[manager]
preview = { fg = "#b3b1ad" }
syntect_theme = "dracula"

[status]
separator_open = ""
separator_close = ""
```

## Características destacadas

### Previsualización de imágenes

```bash
# yazi puede previsualizar imágenes en terminal si el emulador lo soporta:
# - kitty: sin configuración extra ✅
# - WezTerm: sin configuración extra ✅
# - Alacritty + Überzug: necesario instalar Überzug
# - Otros: fallback a chaf (terminal ANSI)
```

### Integración con otras herramientas

```bash
# Abrir yazi desde la terminal en el directorio actual
yazi

# Usar yazi para seleccionar archivos desde scripts
# (devuelve la ruta del archivo seleccionado al salir)
path=$(yazi --chooser-file=/dev/stdout)
cd "$path"
```

## Comparativa

| Aspecto | yazi | lf | ranger | nnn | broot |
|---|---|---|---|---|---|
| **Velocidad** | ⚡ Más rápida | Muy rápida | Lenta | Rápida | Rápida |
| **Previsualización imágenes** | ✅ Sí | ❌ No | ✅ Con w3m | ❌ No | ❌ No |
| **Pestañas** | ✅ | ❌ | ✅ | ❌ | ❌ |
| **Idioma** | Rust | Go | Python | C | Rust |
| **Binario único** | ✅ | ✅ | ❌ Python | ✅ | ✅ |
| **Async I/O** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Tamaño** | ~10 MB | ~5 MB | ~50 MB + Python | ~100 KB | ~8 MB |

> yazi es el más rápido y moderno. Si usas ranger y es lento, cambia a yazi.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Vista previa de imágenes vacía | Falta `chafa`/`ueberzug` | Instalar el visor de imágenes requerido para TUI |
| Sin previa de PDF | Dependencia `pdftotext` | Instalar poppler/xpdf |
| No abre en directorio | Terminal en cwd distinto | Ejecutar `yazi` desde el directorio o configurar "cd on quit" |
| Atajos custom no aplican | YAML mal | Validar `yazi.toml` y revisión de dependencias |

## Ver también

- [[Gestores de Archivos]] — nota general sobre gestores de archivos en Linux
- [[lf]] — alternativa en Go, minimalista
- [[ranger]] — el clásico en Python
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — sxyazi/yazi](https://github.com/sxyazi/yazi)
- [Documentación yazi](https://yazi-rs.github.io/)

#programa #tui #gestor-archivos
