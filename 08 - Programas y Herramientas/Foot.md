---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# Foot

Terminal **Wayland-nativa** y extremadamente ligera. Corre directamente sobre Wayland sin pasar por XWayland, ideal para compositores Wayland como [[Niri]], [[Hyprland]], [[Sway]] y [[River]].

Es la terminal por defecto de algunos entornos Wayland-puros y muy popular en setups minimalistas.

## Qué es

- Emulador de terminal escrito en C que usa **Wayland puro** (protocolo nativo) — no depende de X11 ni de XWayland, por lo que arranca en milisegundos y consume muy poca RAM (~8 MB).
- Pensado para sesiones de escritorio Wayland modernas (niri, hyprland, sway, river, wayfire) donde se valora la ligereza y la fidelidad al protocolo.
- Soporta True Color, emoji, texto vertical y clipboard sincronizado (primary selection).
- Además de **protocolo nativo Wayland**, usa **libxkbcommon** para teclado y **fcft** para fuentes (con renderizado por CPU/GPU según configuración).

## Instalación

```bash
sudo pacman -S foot         # Arch (nativo)
sudo apt install foot       # Debian/Ubuntu
sudo dnf install foot       # Fedora
# Compilar desde fuente: meson setup build && ninja -C build
```

También hay paquete Flatpak (`io.footm.foot`), pero la versión nativa es la recomendada.

## Configuración

Archivo de configuración: `~/.config/foot/foot.ini`

```ini
[main]
font=monospace:size=10
dpi-aware=yes
pad=2x2
initial-window-size-chars=100x30

[colors]
background=1e1e2e
foreground=cdd6f4

[scrollback]
lines=10000

[cursor]
style=beam
blink=yes

[url]
launch=xdg-open ${url}
```

### Secciones clave de foot.ini

| Sección | Opciones principales | Descripción |
|---|---|---|
| `[main]` | `font`, `dpi-aware`, `pad`, `initial-window-size-chars`, `term` | Fuente, padding, tamaño inicial |
| `[scrollback]` | `lines`, `multiplier` | Líneas de historial (0 = ilimitado) |
| `[cursor]` | `style` (block/beam/underline), `blink`, `color` | Apariencia del cursor |
| `[colors]` | `background`, `foreground`, `regular0-7`, `bright0-7`, `selection-*` | Paleta de 16 colores + selección |
| `[key-bindings]` | `scrollback-up`, `font-increase`, `search-start` | Atajos de teclado personalizados |
| `[mouse]` | `hide-when-typing`, `selection-*` | Comportamiento del ratón |
| `[url]` | `launch`, `osc8-underline` | Abrir URLs con el atajo `url-launch` |
| `[bell]` | `urgent`, `notify` | Campana del terminal |
| `[tweak]` | `font-monospace-warn`, `grapheme-shaping`, `damage-whole-window` | Ajustes avanzados/experimentales |

### Atajos de teclado por defecto

| Atajo | Acción |
|---|---|
| `Ctrl+Shift+Up/Down` | Scroll de historial (o `Ctrl+Shift+PageUp/PageDown`) |
| `Ctrl+Shift+Left/Right` | Scroll página a página |
| `Ctrl+Shift+Home/End` | Ir al inicio/fin del historial |
| `Ctrl+Shift+r` | Buscar en el historial (search mode) |
| `Ctrl+Shift+c` / `Ctrl+Shift+v` | Copiar / pegar |
| `Ctrl+Shift+u` | Pegar selección primaria (si `clipboard` configurado) |
| `Ctrl+Shift+w` | Cerrar la ventana (solo con `-W`/single window) |
| `Ctrl+Shift+n` | Nueva ventana (con `--server`) |
| `Ctrl+Shift+t` | Nueva ventana (si se usa con footclient) |

Los atajos se personalizan en `[key-bindings]`:

```ini
[key-bindings]
font-increase=Control+equal
font-decrease=Control+minus
scrollback-up=Control+Shift+Up
```

## Comandos / uso

```bash
foot                      # lanzar terminal
foot -e fish              # ejecutar comando/shell al iniciar
foot --server             # modo servidor (más rápido al lanzar varias)
footclient -e htop        # cliente del servidor (arranque casi instantáneo)
foot -W 80x24             # tamaño inicial en columnas x filas
foot --font=monospace:size=12   # sobreescribir fuente desde CLI
foot -T "título"          # título de ventana
```

### Modo servidor (foot --server)

El modo servidor reduce aún más el tiempo de arranque de ventanas adicionales: un solo proceso `foot --server` y los clientes (`footclient`) comparten el estado. Ideal para lanzar varias terminales rápido (p. ej. con un WM dinámico).

```bash
# Arrancar el servidor una vez
foot --server

# Lanzar ventanas con footclient
footclient -e vim
footclient -e htop
```

También sirve como **terminal de drop-down/overlay** en compositores (leagueofoverlays, etc.) lanzándose con un atajo y feet del WM.

## Ventajas

- **Ultra-ligero**: ~8 MB RAM
- Sin dependencias X11 (no necesita XWayland)
- Arranque instantáneo
- Soporta True Color, emoji y clipboard sincronizado
- Historial de scrollback ilimitado opcional + modo búsqueda
- Fonts con **harfbuzz** (grapheme shaping, scripts complejos)

## Desventajas

- **Solo corre en Wayland** (no funciona en X11)
- No tiene pestañas nativas (se suele combinar con un multiplexor: tmux/zellij)
- Config menos flexible que Alacritty o Kitty (menos opciones de tema/plugins)

## Comparativa con otras terminales

| Característica | Foot | Alacritty | Kitty | WezTerm | GNOME Terminal |
|---|---|---|---|---|---|
| Protocolo | Wayland puro | OpenGL (X11/Wayland) | OpenGL (X11/Wayland) | OpenGL (X11/Wayland) | VTE (X11/Wayland) |
| RAM aproximada | ~8 MB | ~30 MB | ~50 MB | ~60 MB | ~60 MB |
| Pestañas nativas | No | No | Sí | Sí | Sí |
| Split panes | No | No | Sí | Sí | No |
| Servidor/cliente | Sí (`footclient`) | No | No | No | No |
| Config en archivo | foot.ini | YAML | kitty.conf | toml | dconf/GUI |
| GPU rendering | No (CPU) | Sí | Sí | Sí | No |
| Ideal para | WMs Wayland minimalistas | General | Power users | Cross-platform | GNOME |

**Recomendación**: Foot es la mejor opción en sesiones Wayland puras donde prima la ligereza (niri, river, sway minimalista). Si necesitas pestañas o splits nativos, Kitty o WezTerm. Si trabajas a la vez en X11 y Wayland con la misma terminal, Alacritty o Kitty son más portables.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No abre en sesión X11 | Requiere Wayland | Usar otra terminal en X11, Foot es solo Wayland |
| Fuente pixelada | DPI no detectado | `dpi-aware=yes` y tamaño correcto (o `dpi-aware=no` con escala fija) |
| Desplazamiento congelado | server mode y font still | Reiniciar `foot --server` |
| No veo emoji/scripts complejos | Font sin harfbuzz | Asegurar harfbuzz instalado; usar fuente con cobertura (Noto Color Emoji) |
| Colores extraños al hacer ssh | TERM incorrecto | `term=xterm-256color` en `[main]` (foot usa `foot` por defecto; añadir alias) |
| No se abre al pulsar atajo del WM | Compositor no encuentra el binario | Usar ruta absoluta (`/usr/bin/foot`) en el binding |

## Ver también

- [[Alacritty]] — terminal GPU cross-platform
- [[Kitty]] — terminal GPU con pestañas
- [[Emuladores de Terminal]] — índice + comparativa
- [[Wayland vs X11]]
- [[st]] — terminal minimalista X11 (filosofía suckless)

## Enlaces externos

- [Sitio oficial](https://codeberg.org/dnkl/foot)
- [Documentación](https://codeberg.org/dnkl/foot/src/branch/master/doc/foot.ini.5)
- [foot.ini(5) man page](https://man.archlinux.org/man/foot.ini.5)

#programa #terminal