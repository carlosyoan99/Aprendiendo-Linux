---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: terminal
prioridad: alta
---

# tmux

## Qué es

**tmux** (terminal multiplexer) es un programa que permite tener múltiples sesiones de terminal dentro de una sola ventana. Esencial para trabajo remoto vía SSH: puedes iniciar una sesión, desconectarte, y volver a conectarte después sin perder nada (los procesos siguen corriendo).

Alternativas: `screen` (más antiguo), `kitty` (tiene splits nativos), `wezterm` (multiplexor integrado).

## Instalación

```bash
# Debian/Ubuntu
sudo apt install tmux

# Arch
sudo pacman -S tmux

# Fedora
sudo dnf install tmux
```

## Conceptos básicos

```
┌─────────────────────────────────────┐
│  Sesión tmux (grupo de ventanas)     │
│  ┌──────────┐ ┌──────────┐          │
│  │ Ventana 1 │ │ Ventana 2 │  ...   │
│  │ (pestaña) │ │ (pestaña) │        │
│  │  ┌──┬──┐  │ └──────────┘        │
│  │  │A │B │  │                      │
│  │  │  │  │  │      paneles         │
│  │  └──┴──┘  │      (splits)       │
│  └──────────┘                       │
│  [status bar: sesión | ventanas]   │
└─────────────────────────────────────┘
```

| Concepto | Descripción |
|---|---|
| **Sesión** | Contenedor principal. Puedes tener varias sesiones independientes |
| **Ventana** | Como una pestaña dentro de la sesión |
| **Panel (pane)** | División de la ventana en áreas más pequeñas (splits) |
| **Prefix** | Combinación de teclas para activar comandos (por defecto `Ctrl+B`) |

## Comandos básicos

```bash
# Crear sesiones
tmux                                    # crear una sesión sin nombre
tmux new -s trabajo                      # crear sesión llamada "trabajo"

# Listar sesiones
tmux ls                                 # listar sesiones activas

# Conectarse a sesiones
tmux attach                             # conectarse a la última sesión
tmux attach -t trabajo                   # conectarse a la sesión "trabajo"

# Desde dentro de tmux
tmux detach                             # o prefix + d — desconectarse (deja corriendo)
tmux kill-session -t trabajo            # cerrar la sesión "trabajo"

# Atajo rápido desde terminal
tmux new-session -A -s main             # crear o adjuntar a sesión "main"
```

## Atajos de teclado

Todos los comandos comienzan con **Prefix** (`Ctrl+B` por defecto), luego la tecla de acción:

| Atajo | Acción |
|---|---|
| `Prefix + c` | Crear nueva ventana (pestaña) |
| `Prefix + ,` | Renombrar ventana actual |
| `Prefix + 0-9` | Ir a la ventana N |
| `Prefix + n/p` | Siguiente/anterior ventana |
| `Prefix + %` | Split vertical (panel derecho) |
| `Prefix + "` | Split horizontal (panel inferior) |
| `Prefix + flechas` | Moverse entre paneles |
| `Prefix + Alt + flechas` | Redimensionar panel |
| `Prefix + d` | Detach (desconectarse, la sesión sigue) |
| `Prefix + [` | Modo scroll (copiar, flechas/PageUp) |
| `Prefix + ]` | Pegar |
| `Prefix + t` | Reloj grande (útil en presentaciones) |
| `Prefix + x` | Cerrar panel actual (pide confirmación) |
| `Prefix + z` | Maximizar/restaurar panel (zoom) |
| `Prefix + :` | Línea de comandos de tmux |

## Modo scroll y mouse

```bash
# Activar scroll con mouse (en ~/.tmux.conf):
set -g mouse on

# Una vez activado:
# - Scroll con rueda del mouse
# - Seleccionar con mouse (copia automática al portapapeles)
# - Clickear paneles para cambiar foco

# Sin mouse: Prefix + [ para entrar en modo scroll
# flechas, PageUp/PageDown, q para salir
```

## Configuración (`~/.tmux.conf`)

```bash
# ~/.tmux.conf — configuración básica recomendada
set -g mouse on                          # soporte mouse
set -g default-terminal "tmux-256color"  # 256 colores
set -g history-limit 10000               # más historial de scroll

# Cambiar prefix a Ctrl+A (como screen, más cómodo)
# set -g prefix C-a
# unbind C-b
# bind C-a send-prefix

# Atajos personalizados
bind r source-file ~/.tmux.conf \; display "Config recargada"  # recargar config
bind -r H resize-pane -L 5              # redimensionar sin prefix repetitivo
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Iniciar con nombres de sesión/ventana en la barra
set -g status-left '#[fg=green]#S #[fg=white]|'
set -g status-right '#[fg=cyan]%Y-%m-%d %H:%M'
```

```bash
# Recargar configuración sin cerrar tmux:
# Desde terminal: tmux source-file ~/.tmux.conf
# O desde tmux: Prefix + r (si configuraste el atajo de arriba)
```

## Casos de uso reales

### 1. Sesión remota que sobrevive a cortes de red

```bash
ssh servidor
tmux new -s remoto
# ... trabajar normalmente ...
# Si se cae la conexión: la sesión sigue corriendo
# Al reconectar:
ssh servidor
tmux attach -t remoto                    # todo sigue igual
```

### 2. Entorno de desarrollo típico

```bash
tmux new -s dev                          # crear sesión "dev"
# Prefix + c → "editor"   (neovim)
# Prefix + c → "servidor" (npm run dev)
# Prefix + c → "git"      (git status, comandos)
# Tener NeoVim y servidor en paneles divididos dentro de la misma ventana
```

### 3. Script para sesión con layout predefinido

```bash
#!/bin/bash
# dev-session.sh — crea sesión de desarrollo preconfigurada
tmux new-session -d -s dev -n editor
tmux send-keys -t dev 'nvim .' C-m
tmux split-window -h -t dev
tmux send-keys -t dev 'npm run dev' C-m
tmux split-window -v -t dev
tmux send-keys -t dev 'htop' C-m
tmux select-pane -t dev:0.0
tmux attach -t dev
```

## tmux vs screen

| Característica | tmux | screen |
|---|---|---|
| Split vertical/horizontal | ✅ Ambos | ❌ Solo horizontal nativo |
| 256 colores out-of-box | ✅ | ❌ Requiere config extra |
| Config (archivo) | `~/.tmux.conf` | `~/.screenrc` |
| Vi-mode en scrollback | ✅ `Prefix + [` | ✅ `Ctrl+A Esc` |
| Popularidad actual | ✅ Alta | ❀ Baja |

## Por qué importa

- **Persistencia remota**: los procesos **no se detienen** al cerrar la terminal o perder la conexión.
- **Multitarea en terminal**: splits y pestañas sin abrir 10 ventanas de terminal.
- **Colaboración**: dos personas pueden adjuntarse a la misma sesión tmux (``tmux attach``) y ver la misma terminal.

## Enlaces externos

- [Wikipedia — tmux](https://en.wikipedia.org/wiki/Tmux)
- [Repositorio oficial en GitHub](https://github.com/tmux/tmux)
- [tmux.github.io](https://tmux.github.io/)

## Ver también

- [[La Shell]]
- [[Emuladores de Terminal]]
- [[SSH]]
- [[alias]]

#terminal #tmux
