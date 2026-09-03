---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# Atajos de teclado - tmux

> Accesos rápidos del multiplexor de terminal **tmux**. Todos los atajos de tmux se activan con un **prefijo** — por defecto `Ctrl+B` — seguido de la tecla de acción. Se puede cambiar el prefijo en `~/.tmux.conf` con `set -g prefix C-a`.

## Prefijo y sesiones

| Atajo | Efecto |
|---|---|
| `Ctrl+B` | Prefijo (activa el modo de comandos tmux) |
| `Ctrl+B` `d` | Desacoplar sesión (detach) — la sesión sigue corriendo |
| `Ctrl+B` `D` | Elegir sesión para desacoplar |
| `tmux attach` | Reacoplar a la última sesión |
| `tmux ls` | Listar sesiones activas |
| `Ctrl+B` `s` | Listar sesiones (interactivo) |
| `Ctrl+B` `$` | Renombrar sesión |
| `Ctrl+B` `(` | Cambiar a sesión anterior |
| `Ctrl+B` `)` | Cambiar a sesión siguiente |
| `Ctrl+B` `c` | Crear nueva ventana |
| `Ctrl+B` `,` | Renombrar ventana actual |
| `Ctrl+B` `&` | Cerrar ventana actual (con confirmación) |

## Navegación entre ventanas

| Atajo | Efecto |
|---|---|
| `Ctrl+B` `n` | Siguiente ventana |
| `Ctrl+B` `p` | Ventana anterior |
| `Ctrl+B` `0..9` | Ir a ventana por número |
| `Ctrl+B` `w` | Listar ventanas (interactivo, con preview) |
| `Ctrl+B` `l` | Alternar entre ventana actual y anterior |
| `Ctrl+B` `f` | Buscar ventana por nombre |

## Paneles (splits)

| Atajo | Efecto |
|---|---|
| `Ctrl+B` `%` | Dividir verticalmente (paneles lado a lado) |
| `Ctrl+B` `"` | Dividir horizontalmente (paneles arriba/abajo) |
| `Ctrl+B` `o` | Cambiar al siguiente panel |
| `Ctrl+B` `;` | Alternar panel anterior/actual |
| `Ctrl+B` `q` | Mostrar números de paneles (pulsar número para ir) |
| `Ctrl+B` `x` | Cerrar panel actual |
| `Ctrl+B` `z` | Zoom/dest zoom del panel (pantalla completa temporal) |
| `Ctrl+B` `{` | Intercambiar panel con el anterior |
| `Ctrl+B` `}` | Intercambiar panel con el siguiente |
| `Ctrl+B` `Alt+↑/↓/←/→` | Redimensionar panel en esa dirección |
| `Ctrl+B` `espacio` | Rotar layouts de panel predefinidos |

## Modo de copiado (scrollback)

| Atajo | Efecto |
|---|---|
| `Ctrl+B` `[` | Entrar en modo copia (scrollback) |
| `q` | Salir del modo copia |
| `Espacio` | Iniciar selección (en modo copia) |
| `Enter` | Copiar selección al buffer |
| `Ctrl+B` `]` | Pegar del buffer de tmux |
| ` Ctrl+Shift+C` | Copiar selección al portapapeles del sistema (si está configurado) |

Dentro del modo copia, se puede navegar con `↑/↓/←/→`, `PgUp/PgDn`, `Space` para iniciar selección y `Enter` para copiar.

## Sincronizar paneles

| Atajo | Efecto |
|---|---|
| `Ctrl+B` `:` `setw synchronize-panes on` | Enviar comandos a todos los paneles a la vez |
| `Ctrl+B` `:` `setw synchronize-panes off` | Desactivar sincronización |

## Configuración útil en ~/.tmux.conf

```bash
# Cambiar prefijo a Ctrl+A
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Navegación con vim keys en modo copia
setw -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection-and-cancel

# Dividir con | y -
bind | split-window -h
bind - split-window -v

# Reacoplar con r
bind r source-file ~/.tmux.conf \; display "Recargado"
```

## Ver también

- [[tmux]] — instalación, conceptos, sesiones y config avanzada
- [[screen]] — alternativa clásica al multiplexor de terminal
- [[Shells (bash zsh fish)]] — la shell que vive dentro de tmux
- [[zellij]] — multiplexor de terminal moderno alternativo
- [[Atajos de teclado - GNOME Terminal y Kitty]] — atajos del emulador de terminal

## Enlaces externos

- [tmux — Manual completo](https://man.openbsd.org/openbsd-manual.html?q=tmux)
- [tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [GitHub — tmux-plugins](https://github.com/tmux-plugins)

#programa #atajos #terminal
