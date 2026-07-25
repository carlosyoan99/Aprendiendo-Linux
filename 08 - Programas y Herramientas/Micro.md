---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: programa
prioridad: media
---

# Micro

## Qué es

**Micro** es un editor de texto moderno para terminal, diseñado para ser intuitivo sin sacrificar potencia. A diferencia de [[Vim Neovim]] (curva alta por ser modal) y [[Nano]] (curva baja pero funcionalidades limitadas), Micro ofrece una experiencia intermedia: atajos familiares (Ctrl+S, Ctrl+Q, Ctrl+C/V), resaltado de sintaxis nativo, soporte de ratón, y un sistema de plugins.

Es un solo binario estático (~5 MB), no tiene dependencias externas, y funciona en Linux, macOS, Windows y BSD. Perfecto para quienes vienen de editores GUI y quieren algo familiar en la terminal.

## Instalación

```bash
# Desde repos del sistema
sudo apt install micro              # Debian/Ubuntu
sudo pacman -S micro                # Arch
sudo dnf install micro              # Fedora

# Binario único (recomendado para tener la última versión)
curl https://getmic.ro | bash       # descarga micro a la carpeta actual
sudo mv micro /usr/local/bin/       # mover a PATH

# O descargar manualmente:
# https://github.com/zyedidia/micro/releases
```

## Atajos esenciales

Micro usa combinaciones familiares para quien viene de editores gráficos:

| Atajo | Acción |
|---|---|
| `Ctrl+S` | Guardar |
| `Ctrl+Q` | Salir (pregunta si hay cambios sin guardar) |
| `Ctrl+C` | Copiar |
| `Ctrl+V` | Pegar |
| `Ctrl+X` | Cortar |
| `Ctrl+Z` | Deshacer |
| `Ctrl+Y` | Rehacer |
| `Ctrl+F` | Buscar |
| `Ctrl+N` | Buscar siguiente |
| `Ctrl+H` | Buscar y reemplazar |
| `Ctrl+A` | Seleccionar todo |
| `Ctrl+D` | Duplicar línea |
| `Ctrl+U` | Seleccionar palabra bajo cursor |
| `Ctrl+P` | Abrir comando (command palette) |
| `Ctrl+W` | Cerrar pestaña |
| `Ctrl+Tab` | Siguiente pestaña |
| `Ctrl+L` | Ir a línea |
| `Ctrl+R` | Recargar archivo |
| `Ctrl+G` | Mostrar posición del cursor |
| `Ctrl+B` | Alternar gestor de archivos (filetree) |
| `Ctrl+E` | Ejecutar comando externo |

## Resaltado de sintaxis

Micro incluye resaltado de sintaxis para más de 130 lenguajes: Python, Go, Rust, JavaScript, C, C++, Ruby, Bash, YAML, JSON, Markdown, HTML, CSS, etc. Se activa automáticamente según la extensión del archivo.

## Configuración: `~/.config/micro/settings.json`

```json
{
    "colorscheme": "atom-dark",
    "tabstospaces": true,
    "tabsize": 4,
    "softwrap": false,
    "autoindent": true,
    "cursorline": true,
    "ruler": true,
    "statusline": true,
    "syntax": true,
    "diff": false,
    "savecursor": true,
    "scrollbar": true,
    "paste": true,
    "clipboard": "terminal",
    "mkparents": false,
    "pluginchannels": [
        "https://raw.githubusercontent.com/micro-editor/plugin-channel/master/channel.json"
    ],
    "pluginrepos": []
}
```

### Temas de color

```bash
# Listar temas disponibles
micro -colorscheme-help

# Temas populares:
# - atom-dark (oscuro, por defecto)
# - atom-light
# - dracula
# - monokai
# - solarized
# - gruvbox
# - geany

# Cambiar tema
# Desde Micro: Ctrl+E → set colorscheme dracula
# En settings.json: "colorscheme": "dracula"
```

## Plugins

Micro tiene un sistema de plugins simple:

```bash
# Listar plugins
micro -plugin list

# Instalar plugins desde Micro
# Ctrl+E → plugin install plugin-name

# Plugins populares:
# - detectindent: detecta indentación automáticamente
# - filemanager: gestor de archivos lateral
# - go: herramientas Go
# - ligu: resaltado de ligaduras tipográficas
# - monokai-dark: tema
# - snippet: snippets de código
# - wc: contador de palabras
```

## Uso como visor (pager)

```bash
# Micro puede usarse como visor de archivos (modo readonly)
micro -readonly archivo.txt

# También como paginador de pipes
cat archivo.txt | micro -
# O mejor:
micro - < archivo.txt
```

## Comparativa

| Característica | Nano | Micro | Vim/Neovim |
|---|---|---|---|
| Atajos familiares | ✅ Básicos | ✅ **Ctrl+S/Ctrl+Q/Ctrl+C/V** | ❌ Modal |
| Resaltado sintaxis | ❌ (con nanorc mínimo) | ✅ Nativo (130+ lenguajes) | ✅ Nativo |
| Tamaño | ~1 MB | ~5 MB (binario único) | ~10-30 MB |
| Dependencias | Ninguna | Ninguna (estático) | Depende (nvim requiere LuaJIT) |
| Plugins | ❌ | ✅ | ✅ (Vim 8+, Neovim) |
| Ratón | ✅ | ✅ | ✅ (set mouse=a) |
| Curva aprendizaje | Muy baja | **Baja** | Alta |
| Split/pestañas | ❌ | ✅ (pestañas) | ✅ |
| Multi-cursor | ❌ | ❌ | ✅ (Neovim con plugins) |
| Ideal para | Edits rápidos | Edición diaria, migración desde GUI | Programación avanzada |

## Ver también

- [[Nano]] — el básico universal, preinstalado en todas las distros
- [[Vim Neovim]] — el estándar profesional, modal
- [[Editores de Texto]] — comparativa general de editores de terminal
- [[Emuladores de Terminal]] — emuladores para usar Micro

## Enlaces externos

- [Wikipedia — Micro (text editor)](https://en.wikipedia.org/wiki/Micro_(text_editor))
- [Sitio oficial — Micro](https://micro-editor.github.io/)
- [GitHub — zyedidia/micro](https://github.com/zyedidia/micro)

#programa #editores
