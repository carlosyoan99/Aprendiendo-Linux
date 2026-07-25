---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: comando
prioridad: alta
---

# Vim / Neovim

## Sintaxis
```
vim [opciones] archivo
nvim [opciones] archivo
```

## Descripción

**Vim** (Vi IMproved) es un editor de texto modal, descendiente del editor `vi` original (1976). Es conocido por su eficiencia: los dedos nunca abandonan la fila central del teclado. **Neovim** (nvim) es un fork moderno de Vim que añade Lua como lenguaje de configuración, arquitectura de plugins asíncrona, y mejor integración con el sistema.

Ambos son editores **modales**: tienen modos separados para navegar, insertar texto, seleccionar visualmente y ejecutar comandos. Esto los hace extremadamente rápidos una vez aprendidos.

## Filosofía modal

Vim no funciona como los editores tradicionales. Tiene **modos**:

```
Normal ───→ Insert
  │            │
  ├──→ Visual  │
  ├──→ Command │
  └──→ Replace │
```

| Modo | Tecla para entrar | Qué se puede hacer |
|---|---|---|
| **Normal** | `Esc` (desde cualquier modo) | Navegar, copiar, pegar, borrar, buscar |
| **Insert** | `i` (insertar), `a` (append), `o` (nueva línea) | Escribir texto |
| **Visual** | `v` (caracter), `V` (línea), `Ctrl+v` (bloque) | Seleccionar texto |
| **Command** | `:` (dos puntos) | Ejecutar comandos (`:w`, `:q`, `:s`) |
| **Replace** | `R` | Sobrescribir texto |

## Atajos esenciales

### Navegación (modo Normal)

```bash
h j k l          # ← ↓ ↑ → (movimiento básico)
w b              # siguiente palabra / palabra anterior
e                # final de la palabra actual
0 ^ $            # inicio (col 0) / primer carácter / fin de línea
gg G             # inicio del archivo / fin del archivo
Ctrl+d Ctrl+u    # media página abajo / arriba
Ctrl+f Ctrl+b    # página completa abajo / arriba
zt zz zb         # cursor en top / center / bottom de pantalla
```

### Edición básica

```bash
i I              # insertar en cursor / inicio de línea
a A              # insertar después del cursor / final de línea
o O              # nueva línea debajo / encima
x                # borrar carácter bajo cursor
dd               # borrar línea completa
yy               # copiar (yank) línea
p P              # pegar después / antes del cursor
u Ctrl+r         # deshacer / rehacer
.                # repetir último cambio
```

### Borrar, copiar y cambiar

Vim usa verbos + objetos de movimiento:
```bash
dw               # borrar palabra (delete word)
d$               # borrar hasta fin de línea
diw              # borrar palabra interna (in word)
ci"              # cambiar dentro de comillas (change inner quote)
y2w              # copiar 2 palabras
dap              # borrar alrededor del párrafo
```

### Selección visual

```bash
v                # selección por caracteres
V                # selección por líneas
Ctrl+v           # selección por bloques (columnas)

# Con texto seleccionado:
d                # borrar selección
y                # copiar selección
~                # cambiar mayúsculas/minúsculas
> <              # indentar / dedentar
```

### Búsqueda y reemplazo

```bash
/patrón          # buscar hacia adelante
?patrón          # buscar hacia atrás
n N              # siguiente / anterior resultado
* #              # buscar palabra bajo cursor

# Buscar y reemplazar
:%s/viejo/nuevo/g             # en todo el archivo
:'<,'>s/viejo/nuevo/gc        # en selección visual (con confirmación)
:%s/viejo/nuevo/gi            # case-insensitive
```

### Gestión de archivos

```bash
:w               # guardar (write)
:q               # cerrar (quit)
:wq              # guardar y cerrar
:q!              # cerrar sin guardar (force)
:e archivo       # abrir otro archivo
:w nuevo.txt     # guardar como
:ls              # lista de buffers
:bn :bp          # buffer siguiente / anterior
```

## Configuración: `~/.vimrc` / `~/.config/nvim/init.lua`

```vim
" ~/.vimrc — configuración básica de Vim
set number                      " números de línea
set relativenumber              " números relativos (útil con movimientos)
set tabstop=4 shiftwidth=4      " tabs de 4 espacios
set expandtab                   " tabs → espacios
set autoindent smartindent      " indentación inteligente
set mouse=a                     " soporte de ratón
set hlsearch incsearch          " resaltar búsqueda + búsqueda incremental
set ignorecase smartcase        " búsqueda case-insensitive (sensible si hay mayúsculas)
set clipboard=unnamedplus       " portapapeles del sistema (requiere +clipboard)
set splitright splitbelow       " splits en dirección natural
syntax on                       " resaltado de sintaxis
colorscheme habamax             " tema (o desert, elflord, etc.)
```

```lua
-- ~/.config/nvim/init.lua — configuración de Neovim (Lua)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'  -- portapapeles del sistema (requiere +clipboard)
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Plugin manager (Lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  'folke/tokyonight.nvim',
  'nvim-tree/nvim-tree.lua',
  'nvim-lualine/lualine.nvim',
})
vim.cmd.colorscheme('tokyonight')
```

## Neovim vs Vim

| Característica | Vim | Neovim |
|---|---|---|
| Configuración | Vimscript | Vimscript + **Lua** |
| Plugins asíncronos | Parcial (desde 8.0) | Nativo (desde 0.1) |
| LSP integrado | No (coc.nvim) | **Sí** (vim.lsp) |
| Tree-sitter | No | **Sí** (parseo sintáctico) |
| Terminal integrada | `:terminal` (Vim 8.0+) | `:terminal` (mejor integrada) |
| API externa | Limitada | **Sí** (msgpack, RPC) |
| Distribuciones | No | Lunarvim, Astrovim, NvChad |
| Popularidad actual | Estable | **Creciente** |

## Gestores de plugins recomendados

```bash
# Para Vim: vim-plug (https://github.com/junegunn/vim-plug)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Para Neovim: Lazy.nvim (https://github.com/folke/lazy.nvim)
# Se instala desde init.lua automáticamente
```

## Plugins esenciales

| Plugin | Propósito |
|---|---|
| **Nvim-tree** | Explorador de archivos lateral |
| **Telescope** | Búsqueda difusa (archivos, texto, git) |
| **Lualine** | Barra de estado minimalista |
| **Comment** | Comentar/descomentar código |
| **Which-key** | Mostrar atajos disponibles |
| **Autopairs** | Auto-cerrar paréntesis, llaves |
| **Mason** | Instalar LSP, DAP, linters |
| **nvim-cmp** | Autocompletado inteligente |
| **Treesitter** | Resaltado sintáctico preciso |

## Distribuciones preconfiguradas

Para evitar configurar desde cero:

| Distribución | Base | Estilo |
|---|---|---|
| **LunarVim** | Neovim | IDE-like |
| **AstroNvim** | Neovim | Modular |
| **NvChad** | Neovim | Rápido, bonito |
| **LazyVim** | Neovim | Con Lazy.nvim, moderno |

## Vimtutor — aprender Vim

```bash
vimtutor          # tutorial interactivo incluido (30 min)
nvim +Tutor       # Neovim también lo incluye
```

## Notas y advertencias

- Vim viene preinstalado como `vi` en prácticamente **todos los sistemas Unix/Linux**, incluso en contenedores mínimos.
- Si no sabes salir de Vim: pulsa `Esc` (varias veces para asegurar), luego `:q!` y Enter.
- `clipboard=unnamedplus` requiere que Vim esté compilado con `+clipboard`. Verifica con: `vim --version | grep clipboard` (si ves `-clipboard`, la opción no estará disponible). Neovim siempre incluye clipboard.
- `vimtutor` es el mejor recurso para empezar — te enseña lo esencial en ~30 minutos.
- Neovim es compatible con los comandos y config de Vim (~/.vimrc) — migrar es sencillo.
- Para edición remota: `vim scp://servidor/ruta/archivo` o `nvim +'term ssh servidor'`.

## Enlaces externos

- [Vim oficial](https://www.vim.org/) — página oficial
- [Neovim oficial](https://neovim.io/) — página oficial
- [Open Vim](https://www.openvim.com/) — tutorial interactivo online
- [Vim Adventures](https://vim-adventures.com/) — aprender Vim jugando
- [Learn Vim Progressively](http://yannesposito.com/Scratch/en/blog/Learn-Vim-Progressively/)

## Ver también

- [[Nano]] — alternativa simple para edits rápidos
- [[Editores de Texto]] — comparativa general
- [[Man]] — páginas de manual (`:help` en Vim/Neovim)
- [[Desarrollo en Linux (gcc make gdb strace)]] — edición + compilación

#comando
