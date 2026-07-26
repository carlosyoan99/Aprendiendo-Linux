---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: alta
---

# Neovim — La evolución moderna de Vim

**Neovim** (nvim) es un fork moderno de [[Vim]] que añade Lua como lenguaje de configuración, arquitectura de plugins asíncrona, LSP integrado, Tree-sitter y mejor integración con el sistema.

## Instalación

```bash
sudo apt install neovim          # Debian/Ubuntu
sudo pacman -S neovim            # Arch
sudo dnf install neovim          # Fedora

nvim +Tutor                      # tutorial interactivo
```

## Configuración en Lua

```lua
-- ~/.config/nvim/init.lua
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
```

## Plugin manager (Lazy.nvim)

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  'folke/tokyonight.nvim',
  'nvim-tree/nvim-tree.lua',
  'nvim-lualine/lualine.nvim',
})
vim.cmd.colorscheme('tokyonight')
```

## Características exclusivas

- **LSP integrado**: `vim.lsp.*` — autocompletado, diagnósticos, go-to-definition sin plugins externos
- **Tree-sitter**: parseo sintáctico preciso para resaltado y navegación de código
- **Terminal integrada**: `:terminal` con mejor integración
- **API externa**: msgpack/RPC para comunicación con herramientas externas
- **Lua como lenguaje de configuración**: más potente y rápido que Vimscript

## Plugins esenciales

| Plugin | Propósito |
|---|---|
| **Nvim-tree** | Explorador de archivos lateral |
| **Telescope** | Búsqueda difusa (archivos, texto, git) |
| **Lualine** | Barra de estado minimalista |
| **Mason** | Instalar LSP, DAP, linters |
| **nvim-cmp** | Autocompletado inteligente |
| **Treesitter** | Resaltado sintáctico preciso |

## Distribuciones preconfiguradas

| Distribución | Estilo |
|---|---|
| **LunarVim** | IDE-like |
| **AstroNvim** | Modular |
| **NvChad** | Rápido, bonito |
| **LazyVim** | Moderno (Lazy.nvim) |

## Ver también

- [[Vim]] — editor clásico
- [[Vim comandos avanzados]] — macros, registros, quickfix
- [[Vim Neovim]] — índice + comparativa
- [[Editores de Texto]] — índice + comparativa

## Enlaces externos

- [Neovim oficial](https://neovim.io/)
- [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html)
- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)

#comando #editor
