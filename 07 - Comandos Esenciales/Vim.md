---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: alta
---

# Vim — Editor modal clásico

**Vim** (Vi IMproved) es un editor de texto modal, descendiente del editor `vi` original (1976). Conocido por su eficiencia: los dedos nunca abandonan la fila central del teclado.

## Instalación

```bash
sudo apt install vim            # Debian/Ubuntu
sudo pacman -S vim              # Arch
sudo dnf install vim            # Fedora

vimtutor                        # tutorial interactivo (30 min)
```

## Modos

```
Normal ───→ Insert
  │            │
  ├──→ Visual  │
  ├──→ Command │
  └──→ Replace │
```

## Atajos esenciales

### Navegación
```bash
h j k l          # ← ↓ ↑ →
w b e            # palabra sig/anterior/final
0 ^ $            # inicio / primer char / fin
gg G             # inicio / fin archivo
Ctrl+d Ctrl+u    # media pág abajo/arriba
```

### Edición
```bash
i I              # insertar en cursor / inicio línea
a A              # insertar después / final línea
o O              # nueva línea debajo / encima
x                # borrar carácter
dd               # borrar línea
yy               # copiar línea
p P              # pegar después / antes
u Ctrl+r         # deshacer / rehacer
.                # repetir último cambio
```

### Verbos + objetos
```bash
dw               # borrar palabra
d$               # borrar hasta fin línea
ci"              # cambiar dentro de comillas
y2w              # copiar 2 palabras
```

### Búsqueda y reemplazo
```bash
/patrón          # buscar adelante
?patrón          # buscar atrás
n N              # siguiente / anterior
* #              # buscar palabra bajo cursor

:%s/viejo/nuevo/g          # en todo el archivo
:'<,'>s/viejo/nuevo/gc     # en selección visual
```

### Gestión de archivos
```bash
:w               # guardar
:q               # cerrar
:wq              # guardar y cerrar
:q!              # cerrar sin guardar
:e archivo       # abrir otro
```

## Configuración (~/.vimrc)

```vim
set number                      " números de línea
set relativenumber              " números relativos
set tabstop=4 shiftwidth=4      " tabs de 4 espacios
set expandtab                   " tabs → espacios
set mouse=a                     " soporte ratón
set hlsearch incsearch          " resaltar búsqueda
set ignorecase smartcase        " búsqueda case-insensitive
set clipboard=unnamedplus       " portapapeles sistema
syntax on                       " resaltado sintaxis
```

## Gestor de plugins (vim-plug)

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## Vim vs Neovim

| Característica | Vim | Neovim |
|---|---|---|
| Configuración | Vimscript | Vimscript + Lua |
| LSP integrado | No (coc.nvim) | Sí (vim.lsp) |
| Tree-sitter | No | Sí |
| Plugins asíncronos | Parcial (desde 8.0) | Nativo |

Ver [[Neovim]] para la versión moderna.

## Ver también

- [[Neovim]] — fork moderno de Vim
- [[Vim comandos avanzados]] — macros, registros, quickfix
- [[Vim Neovim]] — índice + comparativa
- [[Nano]] — editor simple
- [[Editores de Texto]] — índice + comparativa

## Enlaces externos

- [Vim oficial](https://www.vim.org/)
- [Open Vim](https://www.openvim.com/) — tutorial interactivo
- [Vim Adventures](https://vim-adventures.com/) — aprender jugando

#comando #editor
