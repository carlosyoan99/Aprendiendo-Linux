---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: media
---

# history

> Muestra y reutiliza el historial de comandos ejecutados en la shell. Permite buscar, repetir y modificar comandos anteriores sin volver a escribirlos.

## Sintaxis

```bash
history [opciones]
!n           # ejecutar comando número n
!!           # ejecutar el último comando
!texto       # ejecutar el último comando que empiece con "texto"
!?texto      # ejecutar el último que contenga "texto"
^viejo^nuevo # reemplazar "viejo" por "nuevo" en el último comando
```

## Descripción

`history` muestra los comandos almacenados en la sesión actual y en el archivo `~/.bash_history` (bash). Permite re-ejecutar, buscar y modificar comandos anteriores. Es una de las funciones más útiles de la shell para productividad diaria.

## Opciones principales

| Flag | Efecto |
|---|---|
| `-c` | Limpiar historial en memoria |
| `-d offset` | Eliminar línea específica |
| `-a` | Añadir sesión actual al archivo |
| `-w` | Escribir todo el historial al archivo |
| `-r` | Leer archivo y añadirlo al actual |
| `-p` | Ejecutar comandos de historial de forma interactiva |

## Ejemplos

```bash
# Listar historial
history                      # lista numerada de comandos
history 20                   # últimos 20 comandos

# Re-ejecutar comandos
!!                           # repetir el último comando
!100                         # ejecutar comando #100
!ssh                         # último comando que empiece con "ssh"
!?config                     # último comando que contenga "config"

# Reemplazar en el último comando
^pacman^yay                  # reemplazar "pacman" por "yay" en el último

# Limpiar historial
history -c                   # limpiar de memoria
> ~/.bash_history            # vaciar el archivo

# Buscar con Ctrl+r
# Presionar Ctrl+r y escribir para buscar incrementalmente
# Ctrl+r de nuevo para siguiente resultado
# Enter para ejecutar, Ctrl+c para cancelar
```

## Configuración del historial

```bash
# En ~/.bashrc o ~/.profile:

export HISTSIZE=10000              # comandos en memoria
export HISTFILESIZE=100000         # líneas en el archivo
export HISTCONTROL=ignoredups      # ignorar comandos duplicados consecutivos
export HISTCONTROL=ignoreboth      # ignorar duplicados + comandos que empiezan con espacio
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "  # timestamp en cada línea
export HISTFILE=~/.local/share/bash_history    # mover fuera de ~ (XDG-friendly)

# Comandos que NO se guardan en historial
export HISTIGNORE="ls:cd:exit:pwd:clear:history"
```

## Atajos de teclado con historial

| Atajo | Acción |
|---|---|
| `↑` / `↓` | Navegar por el historial |
| `Ctrl+r` | Búsqueda inversa incremental |
| `Ctrl+s` | Búsqueda hacia adelante (si está habilitado) |
| `Alt+.` | Insertar último argumento del comando anterior |
| `Alt+n` | Insertar argumento del comando n |
| `!!` | Repetir último comando (expande a la línea) |
| `!$` | Último argumento del último comando |
| `!^` | Primer argumento del último comando |

## Historial en diferentes shells

| Shell | Archivo | Config |
|---|---|---|
| **bash** | `~/.bash_history` | `HISTSIZE`, `HISTFILESIZE` |
| **zsh** | `~/.zsh_history` | `HISTFILE`, `SAVEHIST` |
| **fish** | `~/.local/share/fish/fish_history` | `fish_history` |
| **nushell** | `~/.config/nushell/history` | `$env.config.history` |

### zsh

```bash
# En ~/.zshrc:
HISTFILE=~/.zsh_history
SAVEHIST=100000
HISTSIZE=100000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY          # compartir historial entre terminales
```

### fish

```bash
# fish guarda historial automáticamente
# Configurar en ~/.config/fish/config.fish:
set -g fish_history_size 100000

# Buscar historial con Ctrl+r (fzf integration)
```

## Casos de uso

### Encontrar un comando que ejecutaste hace días

```bash
# Buscar por texto
history | grep "docker" | tail -10

# Buscar por fecha (si HISTTIMEFORMAT está configurado)
history | grep "2026-07-25"
```

### Crear script a partir de comandos ejecutados

```bash
# Limpiar historial y guardar comandos útiles
history | grep "docker" | sed 's/^[ ]*[0-9]*  //' > docker-commands.sh
```

### Borrar comandos sensibles del historial

```bash
# Borrar el último comando (antes de que se guarde)
export HISTCONTROL=ignoreboth

# Borrar un comando específico
history -d $(history | grep "password" | awk '{print $1}')

# Ejecutar un comando sin guardarlo en historial
unset HISTFILE; mysql -u root -p
# O añadir espacio al inicio:
 password="secret" mysql -u root
```

## Ver también

- [[Touch y History]] — índice combinado
- [[Variables de Entorno y PATH]] — HISTFILE, HISTSIZE, HISTCONTROL
- [[XDG Base Directory y dotfiles modernos]] — mover .bash_history a ~/.local/share
- [[La Shell]] — cómo funciona el historial en diferentes shells
- [[Shells (bash zsh fish)]] — diferencias en el manejo del historial
- [[atuin]] — historial de shell con sincronización cloud

## Enlaces externos

- [Wikipedia — history (command)](https://en.wikipedia.org/wiki/History_(command))
- [Bash History — GNU Manual](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities)
- [Arch Wiki — Bash](https://wiki.archlinux.org/title/Bash)

#comando #shell #productividad
