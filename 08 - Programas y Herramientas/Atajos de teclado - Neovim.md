---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# Atajos de teclado - Neovim

> Atajos de **Neovim** más allá de lo básico de Vim. Esta nota cubre atajos específicos de Neovim: LSP, Telescope, buffers, tabs, la ventana de comandos, y atajos comunes de plugins populares. Para atajos básicos de Vim ver [[Atajos de teclado - Vim]].

## Atajos de Neovim (sin plugins)

### Navegación de buffers

| Atajo | Modo | Efecto |
|---|---|---|
| `:bnext` o `:bn` | Command | Siguiente buffer |
| `:bprev` o `:bp` | Command | Buffer anterior |
| `:b <num>` | Command | Ir al buffer número |
| `:b <nombre>` | Command | Ir a buffer por nombre (Tab autocomplete) |
| `:bd` | Command | Cerrar buffer actual |
| `:bd!` | Command | Cerrar buffer sin guardar |
| `:ls` | Command | Listar buffers |
| `Ctrl+^` | Normal | Alternar entre buffer actual y anterior |
| `Ctrl+6` | Normal | Alternar entre buffer actual y anterior (alternativo) |

### Navegación de ventanas (splits)

| Atajo | Modo | Efecto |
|---|---|---|
| `:split` o `:sp` | Command | Split horizontal |
| `:vsplit` o `:vs` | Command | Split vertical |
| `Ctrl+w h` | Normal | Ir a ventana izquierda |
| `Ctrl+w j` | Normal | Ir a ventana abajo |
| `Ctrl+w k` | Normal | Ir a ventana arriba |
| `Ctrl+w l` | Normal | Ir a ventana derecha |
| `Ctrl+w w` | Normal | Alternar entre ventanas |
| `Ctrl+w H` | Normal | Mover ventana a la izquierda |
| `Ctrl+w J` | Normal | Mover ventana abajo |
| `Ctrl+w K` | Normal | Mover ventana arriba |
| `Ctrl+w L` | Normal | Mover ventana a la derecha |
| `Ctrl+w =` | Normal | Igualar tamaño de ventanas |
| `Ctrl+w _` | Normal | Maximizar alto de ventana |
| `Ctrl+w \|` | Normal | Maximizar ancho de ventana |
| `Ctrl+w q` | Normal | Cerrar ventana |
| `Ctrl+w o` | Normal | Cerrar todas excepto la actual |

### Navegación de tabs

| Atajo | Modo | Efecto |
|---|---|---|
| `:tabnew` o `:tabe` | Command | Nueva tab |
| `:tabnext` o `:tabn` | Command | Siguiente tab |
| `:tabprev` or `:tabp` | Command | Tab anterior |
| `gt` | Normal | Siguiente tab |
| `gT` | Normal | Tab anterior |
| `g<tab>` | Normal | Alternar entre tab actual y anterior |
| `:tabclose` o `:tabc` | Command | Cerrar tab |
| `:tabonly` or `:tabo` | Command | Cerrar todas excepto actual |

---

## Atajos de LSP (Language Server Protocol)

### Navegación del código

| Atajo | Modo | Efecto |
|---|---|---|
| `gd` | Normal | Ir a definición |
| `gD` | Normal | Ir a declaración |
| `gr` | Normal | Referencias (todas las instancias) |
| `gi` | Normal | Implementación |
| `gt` | Normal | Tipo del símbolo bajo el cursor |
| `K` | Normal | Documentación hover |
| `Ctrl+k Ctrl+i` | Normal | Info del símbolo (inspección) |

### Edición con LSP

| Atajo | Modo | Efecto |
|---|---|---|
| `<leader>rn` | Normal | Renombrar símbolo |
| `<leader>ca` | Normal | Code action (acciones disponibles) |
| `<leader>fmt` | Normal | Formatear buffer |
| `<leader>f` | Normal | Formatear selección |
| `]d` | Normal | Ir a siguiente diagnóstico/error |
| `[d` | Normal | Ir a diagnóstico/error anterior |
| `<leader>e` | Normal | Mostrar diagnóstico flotante |
| `<leader>q` | Normal | Lista de diagnósticos |

### Diagnósticos

| Atajo | Modo | Efecto |
|---|---|---|
| `<leader>d` | Normal | Abrir ventana de diagnósticos |
| `]e` | Normal | Siguiente error |
| `[e` | Normal | Error anterior |
| `<leader>dl` | Normal | Listar todos los diagnósticos |

---

## Atajos de Telescope (fuzzy finder)

```lua
-- Configuración típica en init.lua
-- Telescope se abre con <leader> seguido de una tecla

-- Búsqueda de archivos
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>')
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<cr>')
vim.keymap.set('n', '<leader>fw', '<cmd>Telescope lsp_workspace_symbols<cr>')
vim.keymap.set('n', '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
vim.keymap.set('n', '<leader>gc', '<cmd>Telescope git_commits<cr>')
vim.keymap.set('n', '<leader>gs', '<cmd>Telescope git_status<cr>')
```

### Atajos dentro de Telescope

| Atajo | Modo | Efecto |
|---|---|---|
| `Ctrl+n` / `Ctrl+p` | Normal | Siguiente / anterior resultado |
| `Ctrl+j` / `Ctrl+k` | Normal | Siguiente / anterior resultado |
| `Enter` | Normal | Abrir archivo seleccionado |
| `Ctrl+x` | Normal | Abrir en split horizontal |
| `Ctrl+v` | Normal | Abrir en split vertical |
| `Ctrl+t` | Normal | Abrir en nueva tab |
| `Ctrl+q` | Normal | Enviar todos los resultados a quickfix |
| `Esc` | Normal | Cerrar Telescope |
| `/` | Normal | Modo filtro (escribir para refinar búsqueda) |
| `<C-space>` | Normal | Autocompletar/Fuzzy turbo |
| `<Tab>` | Normal | Seleccionar/deseleccionar archivo |
| `<S-Tab>` | Normal | Deseleccionar archivo |
| `<C-d>/<C-u>` | Normal | Scroll abajo/arriba en preview |

---

## Atajos de buffers (plugin gitsigns.nvim)

| Atajo | Modo | Efecto |
|---|---|---|
| `]c` | Normal | Siguiente cambio (hunk) |
| `[c` | Normal | Cambio anterior (hunk) |
| `<leader>hs` | Normal | Stage hunk |
| `<leader>hr` | Normal | Reset hunk |
| `<leader>hp` | Normal | Preview hunk |
| `<leader>hb` | Normal | Blame línea |
| `<leader>hd` | Normal | Diff this |
| `<leader>hS` | Normal | Stage buffer entero |

---

## Atajos de git (plugin fugitive / neogit)

| Atajo | Modo | Efecto |
|---|---|---|
| `:Git` | Command | Resumen git (fugitive) |
| `:Git diff` | Command | Diff de archivos staged |
| `:Git log` | Command | Log de commits |
| `:Git blame` | Command | Blame de archivo |
| `<leader>gs` | Normal | Git status (fugitive) |
| `<leader>gc` | Normal | Git commit (fugitive) |
| `<leader>gp` | Normal | Git push (fugitive) |

---

## Atajos de gestión de plugins

### lazy.nvim

| Atajo | Modo | Efecto |
|---|---|---|
| `:Lazy` | Command | Abrir dashboard de lazy.nvim |
| `:Lazy sync` | Command | Sincronizar plugins |
| `:Lazy install` | Command | Instalar plugins faltantes |
| `:Lazy clean` | Command | Limpiar plugins no usados |
| `:Lazy update` | Command | Actualizar todos los plugins |

### mason.nvim (LSP installer)

| Atajo | Modo | Efecto |
|---|---|---|
| `:Mason` | Command | Abrir Mason UI |
| `:MasonInstall <pkg>` | Command | Instalar paquete LSP/linter |
| `:MasonUpdate` | Command | Actualizar paquetes instalados |
| `:MasonUninstall <pkg>` | Command | Desinstalar paquete |

---

## Atajos de la ventana de comandos

| Atajo | Modo | Efecto |
|---|---|---|
| `q:` | Normal | Abrir ventana de comandos (editable) |
| `q/` | Normal | Abrir ventana de búsqueda (editable) |
| `Ctrl+f` | Command | Abrir ventana de comandos |
| `Ctrl+c` | Command | Cancelar comando |
| `Ctrl+w c` | Command | Cerrar ventana |

---

## Atajos de Neovim en terminal emuladora

| Atajo | Efecto |
|---|---|
| `Ctrl+\ Ctrl+n` | Salir del modo terminal a Normal mode |
| `Ctrl+Shift+C` | Copiar (depende del terminal) |
| `Ctrl+Shift+V` | Pegar (depende del terminal) |

---

## Configuración recomendada (~/.config/nvim/init.lua)

```lua
-- Leader key (ANTES de cualquier otro mapa)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- General
map("n", "<leader>w", ":w<CR>", { desc = "Guardar" })
map("n", "<leader>q", ":q<CR>", { desc = "Salir" })
map("n", "<leader>x", ":wq<CR>", { desc = "Guardar y salir" })

-- Navegación
map("n", "<C-h>", "<C-w>h", { desc = "Ventana izquierda" })
map("n", "<C-j>", "<C-w>j", { desc = "Ventana abajo" })
map("n", "<C-k>", "<C-w>k", { desc = "Ventana arriba" })
map("n", "<C-l>", "<C-w>l", { desc = "Ventana derecha" })

-- Buffers
map("n", "<S-h>", ":bp<CR>", { desc = "Buffer anterior" })
map("n", "<S-l>", ":bn<CR>", { desc = "Buffer siguiente" })
map("n", "<leader>bd", ":bd<CR>", { desc = "Cerrar buffer" })

-- Terminal
map("n", "<leader>t", ":terminal<CR>", { desc = "Abrir terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Salir del terminal" })

-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "Ir a definición" })
map("n", "gr", vim.lsp.buf.references, { desc = "Referencias" })
map("n", "K", vim.lsp.buf.hover, { desc = "Documentación hover" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Renombrar" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>fmt", function() vim.lsp.buf.format() end, { desc = "Formatear" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnóstico" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Siguiente error" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Error anterior" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Buscar archivos" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Grep en archivos" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buscar en buffer" })
```

---

## Ver también

- [[Neovim]] — conceptos, LSP, configuración completa
- [[Vim]] — editor base y conceptos
- [[Atajos de teclado - Vim]] — atajos básicos de Vim
- [[Shells (bash zsh fish)]] — atajos generales de terminal
- [[Atajos de teclado - VSCode]] — alternativa gráfica con atajos propios

#atajos #neovim #editor #lsp
