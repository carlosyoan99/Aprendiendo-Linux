---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
---

# Fish Shell

> Shell interactivo con autocompletado predictivo, syntax highlighting y funcionalidades pensadas para usabilidad diaria. Alternativa moderna a bash/zsh.

## Qué es

Fish (**F**riendly **I**nteractive **SH**ell) es un shell que prioriza la experiencia de usuario: autocompletado que predice comandos, resaltado de sintaxis en tiempo real y una sintaxis de configuración más legible que bash.

| Característica | Fish | Bash | Zsh |
|---|---|---|---|
| **Autocompletado predictivo** | ✅ Integrado | ❌ | ❌ (fzf) |
| **Syntax highlighting** | ✅ Integrado | ❌ | ✅ (plugin) |
| **Configuración** | `~/.config/fish/` | `~/.bashrc` | `~/.zshrc` |
| **POSIX compatible** | ❌ | ✅ | Parcial |
| **Scripting** | Sintaxis propia | POSIX + extensiones | POSIX + extensiones |
| **Plugin manager** | Fisher | — | Oh My Zsh / zinit |

## Instalación

```bash
# Debian/Ubuntu
sudo apt install fish

# Arch
sudo pacman -S fish

# Fedora
sudo dnf install fish

# Cambiar shell por defecto
chsh -s /usr/bin/fish
```

## Configuración

La configuración vive en `~/.config/fish/`:

```bash
# Configuración general
~/.config/fish/config.fish        # Archivo principal de config
~/.config/fish/functions/         # Funciones personalizadas
~/.config/fish/conf.d/            # Archivos de configuración por plugin
```

### Variables de entorno

```fish
# fish usa 'set' en lugar de 'export'
set -gx EDITOR nvim
set -gx PATH ~/.local/bin $PATH
set -gx XDG_CONFIG_HOME ~/.config

# Variables de entorno permanentes
set -Ux MY_VAR "valor"          # -U = universal (persiste entre sesiones)
```

### Alias

```fish
# Alias permanentes (en config.fish o funciones)
alias ll="ls -la"
alias gs="git status"

# O mejor aún, crear una función
# ~/.config/fish/functions/gs.fish
function gs
    git status $argv
end
```

### Prompt personalizado

Fish usa `fish_prompt` y `fish_right_prompt`:

```fish
# ~/.config/fish/functions/fish_prompt.fish
function fish_prompt
    set_color cyan
    echo -n (prompt_pwd)
    set_color green
    echo -n ' ❯ '
end
```

## Funciones destacadas

### Autocompletado predictivo

Escribe el inicio de un comando y Fish sugiere la continuación en gris. Presiona → para aceptar.

### Historial compartido entre sesiones

Fish busca en el historial de todas las sesiones anteriores automáticamente.

### Variables en tiempo real

```fish
# Mostrar todas las variables de entorno
set -S

# Ver la definición de un comando
type ls
```

### Manejo de pipes

```fish
# Fish tiene mejor manejo de pipes que bash
command1 | command2 | command3

# Variables de pipe disponibles en todos los comandos
echo "hola" | read -l mi_var
echo $mi_var
```

## Fish vs. Zsh vs. Bash

| Bash | Zsh | Fish | Ventaja |
|---|---|---|---|
| `export VAR=value` | `export VAR=value` | `set -gx VAR value` | Fish: más explícito |
| `alias x='y'` | `alias x='y'` | `alias x y` | Bash/Zsh: más conocido |
| Config en `~/.bashrc` | Config en `~/.zshrc` | Config en `~/.config/fish/` | Fish: XDG compliant |
| POSIX compatible | Parcial | No compatible | Bash: portabilidad |

## Plugin manager: Fisher

```bash
# Instalar Fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher install jorgebucaran/fisher

# Instalar plugins populares
fisher install jethrokuan/z          # Integración con fzf
fisher install ilancosman/tide       # Tema prompt moderno
fisher install patrickf1/fzf.fish    # fzf integrado
```

## Bashisms en Fish (traducción)

| Bash/Zsh | Fish |
|---|---|
| `if [ -f file ]; then` | `if test -f file` |
| `$(command)` | `(command)` |
| `export VAR=val` | `set -gx VAR val` |
| `for i in 1 2 3; do` | `for i in 1 2 3` |
| `&&` | `; and` o simplemente `&&` |
| `||` | `; or` o simplemente `\|\|` |

## Casos de uso

- **Shell diaria interactiva**: autocompletado predictivo y syntax highlighting mejoran productividad.
- **Configuración de entorno**: `set -gx` es más explícito que `export`.
- **Funciones**: la sintaxis de funciones es más limpia que bash.
- **No para scripts**: no usar para scripts de sistema ni cron (no POSIX compatible).

## Ver también

- [[Shells (bash zsh fish)]]
- [[La Shell]]
- [[tmux]]
- [[Alias]]

#fish #shell #terminal #interactivo #autocompletado
