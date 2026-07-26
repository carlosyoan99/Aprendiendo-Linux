---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: alta
---

# Vim / Neovim — Editores modales

Vim y Neovim son editores de texto **modales**: tienen modos separados para navegar, insertar y ejecutar comandos. Ambos descienden del editor `vi` original (1976).

## Notas individuales

- [[Vim]] — editor clásico (configuración en Vimscript, amplia compatibilidad)
- [[Neovim]] — fork moderno (Lua, LSP integrado, Tree-sitter)

## Neovim vs Vim

| Característica | Vim | Neovim |
|---|---|---|
| **Configuración** | Vimscript | Vimscript + **Lua** |
| **Plugins asíncronos** | Parcial (desde 8.0) | Nativo |
| **LSP integrado** | No (coc.nvim) | **Sí** (vim.lsp) |
| **Tree-sitter** | No | **Sí** |
| **Terminal integrada** | `:terminal` | Mejor integrada |
| **API externa** | Limitada | **Sí** (msgpack, RPC) |
| **Distribuciones** | No | LunarVim, AstroNvim, NvChad |
| **Popularidad actual** | Estable | Creciente |

## ¿Cuál elegir?

- **Neovim** si empiezas de cero: Lua es más accesible, LSP y Tree-sitter vienen incluidos
- **Vim** si trabajas en servidores o contenedores donde solo `vi` está disponible
- Ambos comparten atajos, modos y plugins (Neovim es compatible con `.vimrc`)

## Vimtutor

```bash
vimtutor          # tutorial interactivo (30 min)
nvim +Tutor       # en Neovim
```

## Ver también

- [[Vim comandos avanzados]] — macros, registros, quickfix, sesiones
- [[Nano]] — editor simple para edits rápidos
- [[Editores de Texto]] — índice + comparativa

## Enlaces externos

- [Vim oficial](https://www.vim.org/)
- [Neovim oficial](https://neovim.io/)
- [Open Vim](https://www.openvim.com/) — tutorial interactivo

#comando
