---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
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

## Características clave

- **LSP integrado** — no requiere plugins ni configuración extra para autocompletado, diagnóstico, ir a definición
- **Tree-sitter** — resaltado sintáctico preciso y parsing en tiempo real
- **Multi-cursor nativo**
- **Configuración en TOML** — limpia y declarativa
- **Sin plugins (por ahora)** — filosofía "batteries included"
- **Atajos consistentes** — similares a Vim pero más lógicos y sin modos extraños

## Helix vs Vim

| Aspecto | Vim/Neovim | Helix |
|---|---|---|
| Selección | Acción → objeto | **Objeto → acción** |
| LSP | Plugins (coc.nvim, mason) | Integrado nativo |
| Tree-sitter | Neovim sí, Vim con plugins | Integrado |
| Config | Vimscript / Lua | TOML |
| Multi-cursor | Con plugins | Nativo |
| Curva de aprendizaje | Alta | Media |

## Ver también

- [[Vim Neovim]] — el estándar modal clásico
- [[Editores de Texto]] — índice + comparativa
- [[Editores de código (VSCode Codium Zed Helix Antigravity)]]

## Enlaces externos

- [Web oficial](https://helix-editor.com/)
- [GitHub](https://github.com/helix-editor/helix)
- [Wikipedia — Helix](https://en.wikipedia.org/wiki/Helix_(text_editor))

#programa #editores
