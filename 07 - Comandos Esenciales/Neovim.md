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
vim.opt.termguicolors = true       -- true color
vim.opt.updatetime = 300           -- ms para CursorHold
vim.opt.signcolumn = 'yes'         -- columna de signos siempre visible
vim.opt.undofile = true            -- historial persistente
```

## Características exclusivas de Neovim

- **LSP integrado**: `vim.lsp.*` — autocompletado, diagnósticos, go-to-definition, renombrar
- **Tree-sitter**: parseo sintáctico preciso para resaltado y navegación estructural del código
- **Terminal integrada**: `:terminal` con mejor integración que Vim (pseudoterminal, navegación nativa)
- **API externa msgpack/RPC**: comunicación bidireccional con herramientas externas (GUI, headless, CI)
- **Lua como lenguaje de configuración**: más rápido y potente que Vimscript, con tipado dinámico y metatables

## LSP Setup (Mason + nvim-lspconfig)

Mason instala los servidores de lenguaje. nvim-lspconfig conecta cada servidor con el editor.

```lua
-- ~/.config/nvim/lua/plugins/lsp.lua
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "ts_ls", "basedpyright", "lua_ls", "rust_analyzer", "gopls" },
})

-- Atajos LSP comunes
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  end,
})
```

## Autocompletado: blink.cmp

`blink.cmp` (sucesor moderno de nvim-cmp, escrito en Rust) ofrece autocompletado más rápido con menos configuración.

```lua
require("blink.cmp").setup({
  keymap = {
    ["<C-space>"] = { "show", "hide" },
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
})
```

## Telescope (búsqueda difusa)

```lua
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Buffers" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help tags" })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = "Symbols" })
vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = "References" })
```

## DAP (Debugging)

```lua
-- ~/.config/nvim/lua/plugins/dap.lua
local dap = require("dap")
local ui = require("dapui")

require("mason-nvim-dap").setup({
  ensure_installed = { "python", "js", "codelldb" },
})

ui.setup()

-- Abrir/cerrar UI automáticamente
dap.listeners.before.attach.dapui_config = function() ui.open() end
dap.listeners.before.launch.dapui_config = function() ui.open() end
dap.listeners.before.event_terminated.dapui_config = function() ui.close() end

-- Atajos
vim.keymap.set('n', '<F5>', dap.continue, { desc = "Continue" })
vim.keymap.set('n', '<F10>', dap.step_over, { desc = "Step over" })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = "Step into" })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = "Step out" })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
```

## init.lua completo (estructura modular)

```
~/.config/nvim/
├── init.lua              # entry point
├── lua/
│   └── plugins/
│       ├── lsp.lua       # LSP + Mason
│       ├── telescope.lua # Telescope
│       ├── blink.lua     # blink.cmp
│       ├── dap.lua       # Debugging
│       └── ui.lua        # Lualine, colorscheme, etc.
└── lazy-lock.json        # versiones bloqueadas
```

```lua
-- init.lua
-- Bootstrap lazy.nvim automáticamente
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
```

## Troubleshooting

| Problema | Solución |
|---|---|
| LSP no inicia | `:LspLog` para ver errores. Mason: `:Mason` y verificar servidores instalados |
| Plugin no carga | `:Lazy` para ver estado de plugins instalados y actualizaciones |
| Neovim lento | Revisar `:Lazy profile` para identificar plugins lentos. Usar `vim.schedule` para diferir carga |
| Telescope no encuentra archivos | Verificar `.gitignore` (Telescope lo respeta por defecto). Usar `hidden = true` para ver archivos ocultos |
| Error de Lua en config | `:checkhealth nvim` para diagnóstico completo. Buscar errores de sintaxis con `luafile ~/.config/nvim/init.lua` |
| blink.cmp no funciona | `:checkhealth blink.cmp`. Verificar que no tengas nvim-cmp también cargado (conflicto) |

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
- [blink.cmp docs](https://cmp.saghen.dev/)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)
- [Neovim config for 2026](https://rdrn.me/neovim-2025/)

#comando #editor
