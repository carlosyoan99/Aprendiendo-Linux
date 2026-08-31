---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: baja
---

# delta

> Pager de diff para Git con syntax highlighting, side-by-side view y navegación. Reemplaza `less` como pager de `git diff`.

## Qué es

**delta** es un pager de diffs escrito en Rust que mejora masivamente la legibilidad de `git diff`. Añade syntax highlighting por lenguaje, vista side-by-side, numeración de líneas, y navegación por archivos. Se integra transparentemente con Git como pager por defecto.

**Ventajas clave:**
- Syntax highlighting automático (detecta el lenguaje del archivo)
- Vista side-by-side con diff estabilizado
- Resaltado de tokens de diff (líneas añadidas/eliminadas/borradas)
- Navegación por archivos con `n`/`p`
- Soporte para diff de imágenes (delta --diff-type=image)

## Instalación

```bash
# Debian/Ubuntu
sudo apt install delta

# Arch / CachyOS
sudo pacman -S delta

# Fedora
sudo dnf install delta

# macOS (Homebrew)
brew install git-delta

# Desde fuente (Rust)
cargo install git-delta
```

## Configurar con Git

```bash
# Pager global para diffs
git config --global core.pager "delta"

# Solo para diffs interactivos (sin colorear pipes)
git config --global interactive.diffFilter "delta --color-only"

# Pager para blamelog
git config --global/blame.pager "delta"
```

### Configuración avanzada (`~/.gitconfig`)

```ini
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true                # habilitar navegación por archivos
    dark = true                    # tema oscuro (light para fondos claros)
    side-by-side = false           # vista side-by-side (true para dos columnas)
    line-numbers = true            # numeración de líneas
    syntax-theme = "Dracula"       # tema de syntax highlighting
    plus-style = "syntax \"#405d27\""
    minus-style = "syntax \"#630000\""
    map-styles = "bold purple => syntax \"#6c3082\""

[merge]
    conflictstyle = diff3

[diff]
    colorMoved = default
```

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `j/k` | Mover arriba/abajo |
| `q` | Salir |
| `?` | Mostrar ayuda |
| `n/p` | Siguiente/anterior archivo |
| `1/2/3` | Cambiar estilo de diff (plain, line-numbers, side-by-side) |
| `e` | Abrir archivo en editor ($EDITOR) |
| `+, -` | Aumentar/disminuir contexto |

## Uso avanzado

```bash
# Diff side-by-side en un PR
git diff main --delta --side-by-side

# Usar con git log
git log -p --delta

# Comparar ramas con side-by-side
git diff main..feature --delta --side-by-side

# Blame con resaltado
git blame file.py | delta
```

## Comparativa con alternativas

| Aspecto | delta | less | diff-so-fancy | ydiff |
|---|---|---|---|---|
| **Syntax highlighting** | ✅ Automático | ❌ | ❌ | ✅ |
| **Side-by-side** | ✅ | ❌ | ❌ | ✅ |
| **Numeración líneas** | ✅ | ❌ | ❌ | ✅ |
| **Navegación archivos** | ✅ `n/p` | ❌ | ❌ | ✅ |
| **Rendimiento** | ⚡ Rust | ⚡ C | 🐌 Perl | 🐌 Python |
| **Configuración** | Rica (.gitconfig) | Básica | Mínima | Rica |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Colores no aparecen | Git envía output a pipe, no TTY | Verificar `git config core.pager` apunta a delta |
| Side-by-side cortado | Terminal muy estrecha | Usar terminal ≥120 columnas o `delta --width $COLUMNS` |
| Syntax highlighting erróneo | Archivo sin extensión | Delta usa `linguist-generated`; para forzar: `delta --syntax-theme <tema>` |
| Fuga de memoria en diffs grandes | Parsing excesivo | `delta --max-line-length 0` o usar `less` para archivos enormes |

## Ver también

- [[Git]] — control de versiones
- [[lazygit]] — interfaz TUI de Git
- [[gitui]] — Git TUI en Rust
- [[tig]] — visor de commits Git

#programa #git #diff
