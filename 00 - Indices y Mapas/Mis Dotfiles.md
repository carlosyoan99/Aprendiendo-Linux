---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: indice
prioridad: baja
---

# 📁 Mis Dotfiles

> Plantillas, herramientas y flujo de trabajo para gestionar dotfiles de forma reproducible.

---

## Filosofía

Los **dotfiles** son archivos de configuración que empiezan con `.` (punto) en tu `$HOME`. Gestionarlos con control de versiones te permite:

- **Reproducir** tu entorno en cualquier máquina en minutos
- **Recuperarte** de una reinstalación sin perder configuraciones
- **Sincronizar** entre varias máquinas (escritorio, laptop, servidor)

> Ver [[Symlinks y Dotfiles]] para los fundamentos (symlinks, GNU Stow, chezmoi).
> Ver [[XDG Base Directory y dotfiles modernos]] para el estándar de directorios.

---

## Herramientas recomendadas

| Herramienta | Curva | Ideal para | Comando inicial |
|---|---|---|---|
| **GNU Stow** | 🟢 Baja | Mínimo, symlinks manuales | `stow -t $HOME bash` |
| **chezmoi** | 🟡 Media | Declarativo, multi-máquina, plantillas | `chezmoi init --apply` |
| **Script manual** | 🟢 Baja | Una máquina, control total | `./bootstrap.sh` |

---

## Plantillas descargables

### 📄 `~/.bashrc` — Terminal y alias

```bash
# ─── Modo estricto no interactivo ────────────────────────
# (solo para scripts, no para .bashrc)

# ─── PATH ────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"

# ─── Editor ──────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

# ─── Idioma ──────────────────────────────────────────────
export LANG=es_AR.UTF-8
export LC_ALL=es_AR.UTF-8

# ─── Prompt ──────────────────────────────────────────────
PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

# ─── Alias esenciales ────────────────────────────────────
alias ll='ls -lahF --color=auto'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ..='cd ..'
alias ...='cd ../..'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ip='ip -color=auto'
alias mkdir='mkdir -pv'
alias fucking='sudo'
alias ports='ss -tulpn'
alias myip='curl -s ifconfig.me'
alias update='sudo apt update && sudo apt upgrade -y'

# ─── Funciones útiles ────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() {
    case "$1" in
        *.tar.gz|*.tgz)  tar xzf "$1" ;;
        *.tar.bz2)       tar xjf "$1" ;;
        *.tar.xz)        tar xJf "$1" ;;
        *.zip)           unzip "$1"  ;;
        *.rar)           unrar x "$1";;
        *)              echo "Formato no soportado: $1" ;;
    esac
}
```

### 📄 `~/.gitconfig` — Control de versiones

```ini
[user]
    name = Tu Nombre
    email = tu@email.com

[core]
    editor = nvim
    pager = less
    autocrlf = input
    safecrlf = warn

[init]
    defaultBranch = main

[push]
    default = simple
    autoSetupRemote = true

[fetch]
    prune = true

[diff]
    tool = vimdiff
    colorMoved = zebra

[merge]
    conflictstyle = zdiff3

[color]
    ui = auto
    status = auto
    diff = auto
    branch = auto

[alias]
    st = status
    lg = log --oneline --graph --all --decorate
    co = checkout
    br = branch
    ci = commit
    fix = commit --fixup
    squash = rebase --interactive --autosquash
    undo = reset --soft HEAD~1
    last = log -1 HEAD
    unstage = restore --staged
    discard = restore
    who = shortlog -sne --all --no-merges
    tree = log --oneline --graph --all --decorate --simplify-by-decoration
    tags = tag --sort=-version:refname
    lol = log --oneline --graph

[url "git@github.com:"]
    insteadOf = https://github.com/
```

### 📄 `~/.nanorc` — Editor Nano

```nanorc
## Color syntax highlighting
include "/usr/share/nano/*.nanorc"

## Configuración
set tabsize 4
set tabstospaces
set autoindent
set backup
set backupdir ~/.cache/nano/backups/
set constantshow
set linenumbers
set mouse
set softwrap
set wordbounds
set locking
unset suspend
```

### 📄 `~/.config/nvim/init.vim` — Neovim mínimo

```vim
" ─── Plugins (vim-plug) ──────────────────────────────────
call plug#begin('~/.local/share/nvim/plugged')

Plug 'preservim/nerdtree'           " explorador de archivos
Plug 'vim-airline/vim-airline'      " barra de estado
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'           " git integration
Plug 'jiangmiao/auto-pairs'         " auto cerrar paréntesis
Plug 'editorconfig/editorconfig-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " LSP

call plug#end()

" ─── Configuración básica ────────────────────────────────
set number                          " números de línea
set relativenumber                  " números relativos
set tabstop=4                       " tabs = 4 espacios
set shiftwidth=4
set expandtab                       " tabs → espacios
set autoindent
set smartindent
set mouse=a                         " soporte ratón
set clipboard+=unnamedplus          " clipboard del sistema
set hlsearch                        " resaltar búsquedas
set incsearch                       " búsqueda incremental
set ignorecase                      " ignorar mayúsculas
set smartcase                       " a menos que haya mayúsculas
set termguicolors                   " 24-bit color
syntax on                           " coloreado sintáctico

" ─── Atajos personalizados ───────────────────────────────
let mapleader = " "

" Guardar con Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>

" Salir con Ctrl+Q
nnoremap <C-q> :q<CR>

" Navegación entre ventanas con Ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" NERDTree toggle
nnoremap <leader>n :NERDTreeToggle<CR>
```

### 📄 `~/.tmux.conf` — Multiplexor de terminal

```tmux
# ─── Configuración ───────────────────────────────────────
set -g mouse on
set -g default-terminal "tmux-256color"
set -s escape-time 10
set -g history-limit 50000

# Prefijo: Ctrl+a (más cómodo que Ctrl+b)
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# ─── Atajos ──────────────────────────────────────────────
# Recargar configuración
bind r source-file ~/.tmux.conf \; display "Config recargada"

# Dividir paneles
bind | split-window -h
bind - split-window -v

# Navegar entre paneles con Alt+hjkl
bind -n M-h select-pane -L
bind -n M-j select-pane -D
bind -n M-k select-pane -U
bind -n M-l select-pane -R

# Redimensionar paneles
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# ─── Apariencia ──────────────────────────────────────────
set -g status-bg colour235
set -g status-fg white
set -g status-left '#{?client_prefix,#[fg=colour1]⌨ #[fg=colour15],}'
set -g status-right '#[fg=colour15]%Y-%m-%d %H:%M '
set -g pane-border-style "fg=colour238"
set -g pane-active-border-style "fg=colour39"
```

---

## Script de bootstrap

Guarda esto como `bootstrap.sh` en tu repositorio de dotfiles:

```bash
#!/bin/bash
set -euo pipefail

# ─── Bootstrap de dotfiles ──────────────────────────────
# Uso: bash bootstrap.sh [--stow|--chezmoi|--manual]
# Por defecto: manual (symlinks directos)

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo "🚀 Instalando dotfiles desde $DOTFILES_DIR"

# Backup de dotfiles existentes
echo "📦 Creando backup en $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
for f in .bashrc .gitconfig .nanorc .tmux.conf; do
    [ -f "$HOME/$f" ] && cp "$HOME/$f" "$BACKUP_DIR/$f"
done

# Config XDG para Neovim
mkdir -p "$HOME/.config/nvim"

# Symlinks
echo "🔗 Creando symlinks..."
ln -sf "$DOTFILES_DIR/bashrc"      "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/gitconfig"   "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/nanorc"      "$HOME/.nanorc"
ln -sf "$DOTFILES_DIR/tmux.conf"   "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/init.vim"    "$HOME/.config/nvim/init.vim"

# Dependencias opcionales
echo "📋 Verificando dependencias..."
command -v git   >/dev/null 2>&1 && echo "  ✅ git"   || echo "  ⚠️  git no instalado"
command -v nvim  >/dev/null 2>&1 && echo "  ✅ nvim"  || echo "  ⚠️  nvim no instalado"
command -v tmux  >/dev/null 2>&1 && echo "  ✅ tmux"  || echo "  ⚠️  tmux no instalado"

# Plugins de Neovim
if command -v nvim &> /dev/null; then
    echo "📦 Instalando plugins de Neovim..."
    nvim --headless +PlugInstall +qall 2>/dev/null || echo "  ⚠️  Error instalando plugins"
fi

echo ""
echo "✅ Dotfiles instalados. Recarga tu shell:"
echo "   source ~/.bashrc"
echo ""
echo "📁 Backup disponible en: $BACKUP_DIR"
```

---

## Estructura recomendada del repositorio

```
dotfiles/
├── bashrc                  # ~/.bashrc
├── gitconfig               # ~/.gitconfig
├── nanorc                  # ~/.nanorc
├── tmux.conf               # ~/.tmux.conf
├── init.vim                # ~/.config/nvim/init.vim
├── config/
│   ├── alacritty.yml       # ~/.config/alacritty/
│   ├── starship.toml       # ~/.config/starship/
│   └── nvim/               # ~/.config/nvim/ (carpeta completa)
├── bin/                    # scripts en ~/.local/bin/
│   ├── update-all
│   └── backup-dotfiles
├── bootstrap.sh            # script de instalación
├── README.md               # qué incluye y cómo usarlo
└── screenshots/            # capturas del resultado final
```

---

## Flujo de trabajo con chezmoi

```bash
# 1. Inicializar repositorio
chezmoi init

# 2. Añadir archivos
chezmoi add ~/.bashrc
chezmoi add ~/.gitconfig
chezmoi add ~/.config/nvim/init.vim

# 3. Ver diff entre tu configuración actual y la gestionada
chezmoi diff

# 4. Editar un archivo gestionado
chezmoi edit ~/.bashrc

# 5. Aplicar cambios
chezmoi apply

# 6. En una máquina nueva
chezmoi init --apply <tu-usuario>
```

> Ver [[Symlinks y Dotfiles]] para detalles de chezmoi y GNU Stow.

---

## Ver también

- [[Symlinks y Dotfiles]] — fundamentos de symlinks y gestión
- [[XDG Base Directory y dotfiles modernos]] — estándar de directorios de configuración
- [[Arsenal Power User]] — MoC de especialización (contiene esta sección)
- [[La Shell]] — personalización del shell
- [[Vim Neovim]] — configuración profunda de editor

#indice #dotfiles
