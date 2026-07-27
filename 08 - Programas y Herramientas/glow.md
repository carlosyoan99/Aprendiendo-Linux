---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# glow

> Visor de Markdown para terminal. Renderiza archivos `.md` con formato bonito: headings, negritas, tablas, listas, bloques de código con colores, imágenes y enlaces.

## Qué es

**glow** renderiza archivos Markdown directamente en la terminal con el formato visual completo. A diferencia de `cat` (que muestra el raw), glow procesa y muestra headings, tablas, listas, código, imágenes (en terminales compatibles) y enlaces. Ideal para leer README, documentación, y notas del vault sin salir de la terminal.

Creado por [Charmbracelet](https://charm.sh/), el mismo equipo de `gum`, `bubbletea` y `charm`.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install glow

# Arch
sudo pacman -S glow

# Fedora
sudo dnf install glow

# Homebrew
brew install glow

# Desde GitHub (binario estático)
# https://github.com/charmbracelet/glow/releases
```

## Uso básico

```bash
glow README.md                       # renderizar archivo
glow                                  # explorador de archivos .md (glow TUI)
glow -p README.md                    # modo presentación (página a página)

# Desde stdin
cat README.md | glow
curl -sL https://git.io/example.md | glow

# Sin estilo
glow -s notty README.md              # sin colores (para pipes/scripts)
```

## Atajos (modo explorador)

```bash
glow                                  # abre el explorador TUI
```

| Tecla | Acción |
|---|---|
| `j` / `k` | Navegar archivos |
| `Enter` | Abrir archivo |
| `/` | Buscar por nombre |
| `s` | Alternar orden (nombre/fecha) |
| `a` | Mostrar archivos ocultos |
| `q` | Salir |
| `?` | Ayuda |

## Integración para leer documentación

```bash
# Leer un README de cualquier proyecto desde GitHub
glow https://github.com/charmbracelet/glow

# Pipear documentación de man a glow
man glow | glow

# Leer documentación de paquetes npm
npm help install | glow

# Alias útil
alias readme='glow README.md'
alias cat-md='glow'
```

## Personalización: `~/.config/glow/glow.yml`

```yaml
# Estilo (usar cualquier tema de Chroma)
style: "dracula"
# Otros: "nord", "github", "monokai", "solarized-dark", "catppuccin"

# Ancho máximo (0 = sin límite)
width: 80
```

### Temas populares

```bash
# Listar temas disponibles de Chroma
glow --style-list

# Usar un tema específico
glow --style nord README.md
glow --style dracula README.md
glow --style github README.md
```

## Comparativa

| Aspecto | glow | cat | less | frogmouth | mdless |
|---|---|---|---|---|---|
| **Renderizado Markdown** | ✅ Completo | ❌ Raw | ❌ Raw | ✅ | ✅ |
| **Explorador TUI** | ✅ Integrado | ❌ | ✅ | ❌ | ❌ |
| **Temas** | ✅ 30+ estilos | ❌ | ❌ | ✅ | ❌ |
| **Tablas** | ✅ Con bordes | ❌ | ❌ | ✅ | ✅ |
| **Código con colores** | ✅ Syntax highlight | ❌ | ❌ | ✅ | ✅ |
| **Imágenes** | ✅ terminal compatibles | ❌ | ❌ | ❌ | ❌ |
| **Modo presentación** | ✅ `-p` | ❌ | ❌ | ❌ | ❌ |

> glow es la mejor opción para leer documentación Markdown en terminal. Si trabajas con notas Markdown a diario (como en este vault), es indispensable.

## Ver también

- [[cat]] — mostrar archivos raw
- [[less]] — paginador clásico
- [[Micro]] — editor de texto TUI con resaltado Markdown
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — charmbracelet/glow](https://github.com/charmbracelet/glow)
- [Sitio oficial](https://glow.charm.sh/)

#programa #tui #markdown
