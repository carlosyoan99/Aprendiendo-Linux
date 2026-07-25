---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: concepto
prioridad: alta
---

# XDG Base Directory y dotfiles modernos

## Definición

La **XDG Base Directory Specification** (estándar de freedesktop.org) define dónde deben guardar las aplicaciones sus archivos de configuración, datos y caché. Su objetivo es acabar con el caos de dotfiles (`~/.vimrc`, `~/.bashrc`, `~/.gitconfig`, `~/.mozilla/`, etc.) en el `$HOME` del usuario, organizándolos en directorios estandarizados.

```
Antes del XDG Base Directory (caos en $HOME):

  $HOME/
  ├── .bashrc
  ├── .vimrc
  ├── .gitconfig
  ├── .ssh/
  ├── .mozilla/
  ├── .config/
  ├── .cache/
  ├── .local/
  ├── .npm/
  ├── .cargo/
  ├── .gnupg/
  ├── .docker/
  └── ... (decenas de archivos y carpetas con punto)

Después (aplicaciones que siguen XDG):

  $HOME/
  ├── .bashrc                     ← legacy, los dotfiles de shell son la excepción
  ├── .config/                    ← $XDG_CONFIG_HOME: configuración
  │   ├── nvim/
  │   ├── git/
  │   ├── i3/
  │   ├── hypr/
  │   └── user-dirs.dirs
  ├── .local/
  │   ├── share/                  ← $XDG_DATA_HOME: datos de aplicaciones
  │   │   ├── applications/
  │   │   ├── icons/
  │   │   └── fonts/
  │   └── state/                  ← $XDG_STATE_HOME: estado de aplicaciones (logs, historial)
  │       ├── zsh/
  │       ├── bash/
  │       └── nvim/
  └── .cache/                     ← $XDG_CACHE_HOME: archivos temporales
      ├── pip/
      ├── npm/
      ├── wal/
      └── thumbnails/
```

---

## Variables del estándar XDG

| Variable | Propósito | Valor por defecto | Importancia |
|---|---|---|---|
| `$XDG_CONFIG_HOME` | Configuración específica del usuario | `~/.config` | 🔴 Alta — esencial para apps modernas |
| `$XDG_DATA_HOME` | Datos de aplicaciones (no configuración) | `~/.local/share` | 🔴 Alta — instalación flatpak, iconos, fonts |
| `$XDG_CACHE_HOME` | Datos no esenciales (se pueden regenerar) | `~/.cache` | 🟡 Media — se puede borrar sin riesgo |
| `$XDG_STATE_HOME` | Estado de aplicaciones (logs, historial) | `~/.local/state` | 🟡 Media — añadido en 2021 |
| `$XDG_RUNTIME_DIR` | Sockets y archivos temporales de sesión | `/run/user/$UID` | 🔴 Alta — usado por Wayland, PipeWire, D-Bus |
| `$XDG_DATA_DIRS` | Rutas de datos del sistema (separadas por `:`) | `/usr/local/share:/usr/share` | 🟢 Baja — casi nunca se modifica |
| `$XDG_CONFIG_DIRS` | Rutas de configuración del sistema | `/etc/xdg` | 🟢 Baja — afecta a apps que heredan config global |

```bash
# Ver valores actuales
echo "$XDG_CONFIG_HOME"          # debería ser ~/.config
echo "$XDG_DATA_HOME"            # ~/.local/share
echo "$XDG_CACHE_HOME"           # ~/.cache
echo "$XDG_STATE_HOME"           # ~/.local/state
echo "$XDG_RUNTIME_DIR"          # /run/user/1000 (o similar)

# Si alguna está vacía, se usan los valores por defecto
```

---

## Por qué importa XDG

### Home limpio

Sin XDG, cada aplicación añade su propio dotfile al `$HOME`:
```bash
ls -d ~/.* 2>/dev/null | wc -l
# Fácilmente 50-100 archivos/carpetas ocultas si las apps no siguen XDG
```

Con XDG, el `$HOME` queda limpio:
```bash
ls ~/.config/  # toda la configuración aquí
ls ~/.local/share/  # todos los datos aquí
```

### Portabilidad y backups

- Si toda la configuración está en `~/.config`, es trivial: `tar czf config-backup.tar.gz ~/.config`
- Compatible con dotfiles managers (chezmoi, stow, yadm)
- Las apps que siguen XDG se pueden reinstalar y conservar su configuración

### Seguridad y limpieza

- `~/.cache` se puede borrar completamente sin perder datos importantes
- `~/.local/state` contiene logs e historial que pueden ocupar espacio
- Separar datos, configuración y caché facilita backups selectivos

---

## Aplicaciones que cumplen XDG (y cómo forzar a las que no)

### Apps modernas que siguen XDG nativamente

| App | Config en | Datos en |
|---|---|---|
| **Neovim** | `~/.config/nvim/` | `~/.local/share/nvim/` |
| **Git** | `~/.config/git/config` (junto a `~/.gitconfig`, ambos se leen; `~/.gitconfig` tiene prioridad) | — |
| **htop** | `~/.config/htop/htoprc` | — |
| **mpv** | `~/.config/mpv/` | `~/.local/share/mpv/` |
| **btop** | `~/.config/btop/` | — |
| **fish** | `~/.config/fish/` | `~/.local/share/fish/` |
| **i3** | `~/.config/i3/config` | — |
| **Hyprland** | `~/.config/hypr/` | — |
| **Kitty** | `~/.config/kitty/` | — |
| **Flameshot** | `~/.config/flameshot/` | — |
| **Rofi** | `~/.config/rofi/` | — |
| **Waybar** | `~/.config/waybar/` | — |
| **Dunst** | `~/.config/dunst/` | — |
| **Mako** | `~/.config/mako/config` | — |
| **PipeWire** | `~/.config/pipewire/` | — |
| **WirePlumber** | `~/.config/wireplumber/` | — |

### Apps conocidas que NO cumplen XDG

Algunas aplicaciones populares todavía ensucian el `$HOME`. Se pueden forzar con variables de entorno:

```bash
# ── Bash ──
# ~/.bashrc — force XDG
export HISTFILE="$XDG_STATE_HOME/bash/history"
mkdir -p "$XDG_STATE_HOME/bash"

# ── Zsh ──
# ~/.zshrc — force XDG
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_CONFIG_HOME/zsh"

# ── Node.js (npm) ──
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node/repl_history"

# ── Rust (cargo) ──
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# ── Python (pip) ──
export PIP_CONFIG_DIR="$XDG_CONFIG_HOME/pip"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"

# ── GPG ──
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# ── Docker ──
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# ── GTK ──
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
```

### Script: forzar XDG en apps comunes

> ⚠️ **GPG**: si ya usas GPG, migra manualmente tu keyring antes de cambiar `GNUPGHOME`:
> ```bash
> mv ~/.gnupg/* "$XDG_DATA_HOME/gnupg/"
> ```
> Si no migras, la firma de commits y paquetes dejará de funcionar.

```bash
#!/bin/bash
# ~/.config/xdg-force.sh — Añadir al .bashrc/.zshrc
# Crea los directorios XDG necesarios y exporta variables
# Usa valores por defecto del estándar si las variables no están definidas

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"
mkdir -p "$XDG_DATA_HOME"/{bash,zsh,npm,python,gnupg,cargo,node}
mkdir -p "$XDG_CONFIG_HOME"/{pip,npm,gtk-2.0,gtk-3.0,gtk-4.0}

export HISTFILE="$XDG_STATE_HOME/bash/history"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
```

---

## Gestión moderna de dotfiles

Una vez que las aplicaciones siguen XDG, gestionar la configuración se vuelve mucho más simple.

### Estrategia 1: Repositorio Git + Symlinks (GNU Stow)

```bash
# 1. Crear repositorio
mkdir -p ~/dotfiles
cd ~/dotfiles
git init

# 2. Organizar por programa (cada carpeta = un programa)
mkdir -p ~/dotfiles/nvim/.config/nvim
mkdir -p ~/dotfiles/hypr/.config/hypr
mkdir -p ~/dotfiles/waybar/.config/waybar
mkdir -p ~/dotfiles/kitty/.config/kitty

# 3. Mover configuración a la carpeta correspondiente
mv ~/.config/nvim ~/dotfiles/nvim/.config/nvim
mv ~/.config/hypr ~/dotfiles/hypr/.config/hypr

# 4. Instalar GNU Stow y crear symlinks
sudo apt install stow                    # Debian/Ubuntu
sudo pacman -S stow                      # Arch

cd ~/dotfiles
stow nvim hypr waybar kitty              # crea symlinks en $HOME/..
# Stow lee la estructura: .config/nvim/ → $HOME/.config/nvim/
```

### Estrategia 2: chezmoi (recomendada)

```bash
# Instalación
sudo apt install chezmoi                 # Debian/Ubuntu
sudo pacman -S chezmoi                   # Arch
sh -c "$(curl -fsLS get.chezmoi.io)"     # script oficial

# Inicializar
chezmoi init                              # crear ~/.local/share/chezmoi/
chezmoi cd                                # ir al directorio de trabajo

# Añadir archivos
chezmoi add ~/.config/nvim/init.lua      # añadir archivo al repo
chezmoi add ~/.bashrc                    # añadir dotfile

# Editar y aplicar
chezmoi edit ~/.config/nvim/init.lua     # editar
chezmoi diff                              # ver cambios pendientes
chezmoi apply                            # aplicar cambios

# Múltiples máquinas
chezmoi init --apply https://github.com/usuario/dotfiles.git  # clonar en máquina nueva
# chezmoi maneja diferencias por máquina con plantillas (Go templates)
```

### Estrategia 3: yadm (Yet Another Dotfiles Manager)

```bash
# Instalación
sudo apt install yadm                    # Debian/Ubuntu
sudo pacman -S yadm                      # Arch

# Uso (similar a git pero con dotfiles awareness)
yadm init
yadm add ~/.config/nvim/init.lua
yadm commit -m "Add nvim config"
yadm push

# Clonar en máquina nueva
yadm clone https://github.com/usuario/dotfiles.git
```

### Comparativa de gestores

| Herramienta | Enfoque | Plantillas por máquina | Encriptación | Dificultad |
|---|---|---|---|---|
| **GNU Stow** | Symlinks + git manual | ❌ No | ❌ No | ⭐ Muy fácil |
| **chezmoi** | Copias + plantillas Go | ✅ Sí | ✅ Sí (age/gpg) | ⭐⭐⭐ Medio |
| **yadm** | Git directo + plantillas | ✅ Sí (Jinja/Go) | ✅ Sí (transcrypt) | ⭐⭐ Fácil |
| **bash simple** | Script + git | ❌ No | ❌ No | ⭐ Muy fácil |

---

## Buenas prácticas

1. **Migrar apps a XDG**: busca en la documentación de cada app si soporta XDG. La mayoría moderna sí. Para las que no, usa las variables de entorno del script de forzado.
2. **Un solo `~/.config/`**: no crees carpetas aleatorias en `$HOME`. Todo lo que sea configuración va en `~/.config/`.
3. **Versionar dotfiles desde el día 1**: es mucho más fácil empezar con git que rescatar la configuración tras un formateo.
4. **No versionar secretos**: usa las funciones de encriptación de chezmoi/yadm, o un `.gitignore` con archivos que contengan tokens/contraseñas.
5. **`$HOME` no es basurero**: si una aplicación crea un archivo en `$HOME`, busca cómo hacer que use `$XDG_CONFIG_HOME` o considera usar otra alternativa.

## Ver también

- [[Symlinks y Dotfiles]] — conceptos base de symlinks y dotfiles
- [[Variables de Entorno y PATH]] — cómo funcionan las variables de entorno
- [[La Shell]] — dónde van estas variables (.bashrc, .zshrc, .profile)
- [[Git]] — control de versiones para dotfiles
- [[Personalización en Linux]] — theming y apariencia
- [[Shells (bash zsh fish)]] — cada shell tiene su configuración XDG

#concepto
