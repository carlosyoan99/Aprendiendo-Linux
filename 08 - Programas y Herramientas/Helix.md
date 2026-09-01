---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: media
---

# Helix

## Qué es

Helix es un editor modal **post-Vim** que invierte la filosofía: primero seleccionas, luego actúas (a diferencia de Vim, donde primero actúas y afectas al texto bajo el cursor). Escrito en Rust, con LSP y Tree-sitter integrados de serie.

```bash
sudo apt install helix           # Debian/Ubuntu (desde repos recientes)
sudo pacman -S helix             # Arch
sudo dnf install helix           # Fedora

# O compilar desde fuente:
git clone https://github.com/helix-editor/helix
cargo install --path helix-term
```

## Instalación

```bash
sudo apt install helix           # Debian/Ubuntu (desde repos recientes)
sudo pacman -S helix             # Arch
sudo dnf install helix           # Fedora
flatpak install flathub com.helix_editor.Helix   # Flatpak

# O compilar desde fuente:
git clone https://github.com/helix-editor/helix
cargo install --path helix-term
```

## Características clave

- **LSP integrado** — no requiere plugins ni configuración extra para autocompletado, diagnóstico, ir a definición
- **Tree-sitter** — resaltado sintáctico preciso y parsing en tiempo real
- **Multi-cursor nativo**
- **Configuración en TOML** — limpia y declarativa
- **Sin plugins (por ahora)** — filosofía "batteries included"
- **Atajos consistentes** — similares a Vim pero más lógicos y sin modos extraños

## Atajos básicos

| Atajo | Acción |
|---|---|
| `x` | Seleccionar nodo (extender) |
| `w`/`b` | Mover a palabra siguiente/anterior |
| `d`/`Alt+d` | Borrar/borrar línea |
| `p` | Pegar |
| `m` | Modo editor de la selección |
| `Ctrl+w, w` | Cambiar de ventana |
| `Space f` | Abrir archivo (picker) |
| `Space g d` | Ir a definición (LSP) |

## Configuración

- Config en `~/.config/helix/config.toml` (editor) y `languages.toml` (LSP/formateadores).
- Ejemplo:

```toml
[editor]
line-number = "relative"
cursorline = true

[editor.cursor-shape]
normal = "block"
insert = "bar"
```

## Helix vs Vim

| Aspecto | Vim/Neovim | Helix |
|---|---|---|
| Selección | Acción → objeto | **Objeto → acción** |
| LSP | Plugins (coc.nvim, mason) | Integrado nativo |
| Tree-sitter | Neovim sí, Vim con plugins | Integrado |
| Config | Vimscript / Lua | TOML |
| Multi-cursor | Con plugins | Nativo |
| Curva de aprendizaje | Alta | Media |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Sin autocompletado | Falta el LSP servidor para el lenguaje | Instalar el servidor, se detecta vía `languages.toml` |
| Theme no se aplica | Nombre incorrecto en `theme` | `hx --health` y listar temas disponibles |
| Alt+muy incómodo | Mapeos por defecto | Editar `[keys.normal]` en `config.toml` |

## Ver también

- [[Vim Neovim]] — el estándar modal clásico
- [[Editores de Texto]] — índice + comparativa
- [[Editores de código (VSCode Codium Zed Helix Antigravity)]]

## Enlaces externos

- [Web oficial](https://helix-editor.com/)
- [GitHub](https://github.com/helix-editor/helix)
- [Wikipedia — Helix](https://en.wikipedia.org/wiki/Helix_(text_editor))

#programa #editores
