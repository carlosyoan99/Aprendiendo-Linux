---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: WM
---

# qtile

## Qué es

**qtile** es un gestor de ventanas de mosaico (tiling) **escrito en Python**, lo que lo hace extremadamente fácil de configurar (configuración en Python puro). Soporta tanto **X11** como **Wayland** bajo el mismo código base — elige el backend al arrancar.

Creado por **Aldo Cortesi** en 2012. Es mantenido por un equipo de desarrolladores que valoran la flexibilidad de tener un WM configurable con toda la potencia de Python.

## Filosofía

- **Python como lenguaje de configuración**: no necesitas aprender una sintaxis nueva — la configuración es código Python
- **Backend dual**: mismo config funciona en X11 y Wayland
- **Barra integrada**: qtile incluye su propia barra con widgets nativos
- **Hooks**: responde a eventos del sistema (cambio de wallpaper, conexión WiFi, batería baja)

## Características clave

| Aspecto | Detalle |
|---|---|
| **Tipo** | WM tiling con layouts dinámicos |
| **Configuración** | Python (`config.py`) |
| **Barra integrada** | Sí, con widgets (fecha, red, CPU…) |
| **Backend dual** | X11 + Wayland |
| **RAM en idle** | ~80 MB |
| **Extensibilidad** | Python puro |

## Instalación

```bash
# Debian/Ubuntu
sudo apt install qtile

# Arch Linux
sudo pacman -S qtile

# Fedora
sudo dnf install qtile

# openSUSE
sudo zypper install qtile

# Desde pip (última versión)
pip install qtile
```

## Configuración

La configuración es un archivo Python puro:

```python
# ~/.config/qtile/config.py
# =========================

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"  # Super key

# Atajos de teclado
keys = [
    Key([mod], "Return", lazy.spawn("alacritty")),
    Key([mod], "d", lazy.spawn("rofi -show run")),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "space", lazy.next_layout()),

    # Cambiar focus
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),

    # Mover ventana
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

    # Workspaces
    Key([mod], "1", lazy.group["1"].toscreen()),
    Key([mod], "2", lazy.group["2"].toscreen()),
    Key([mod, "shift"], "1", lazy.window.togroup("1")),
]

# Layouts
layouts = [
    layout.MonadTall(margin=8),
    layout.Max(),
    layout.Tile(ratio=0.5),
    layout.Floating(),
]

# Workspaces
groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.append(Key([mod], i.name, lazy.group[i.name].toscreen()))
    keys.append(Key([mod, "shift"], i.name, lazy.window.togroup(i.name)))

# Barra de estado
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %H:%M"),
                widget.Battery(),
                widget.Wlan(),
            ],
            30,
        ),
    ),
]

# Hooks
@hook.subscribe.startup_once
def autostart():
    import subprocess
    subprocess.Popen(["picom"])
    subprocess.Popen(["feh", "--bg-scale", "~/.wallpaper.jpg"])
```

## Widgets integrados

La barra de qtile incluye widgets nativos para casi todo:

| Widget | Propósito |
|---|---|
| `GroupBox` | Grupos/workspaces |
| `CurrentLayout` | Layout activo |
| `WindowName` | Título de ventana activa |
| `Clock` | Reloj / calendario |
| `Battery` | Estado de batería |
| `Wlan` | Red WiFi |
| `Net` | Tráfico de red |
| `Cpu` | Uso de CPU |
| `Memory` | Uso de RAM |
| `Disk` | Espacio en disco |
| `Systray` | Bandeja del sistema |
| `Pomodoro` | Temporizador Pomodoro |
| `MPD2` | Control de MPD (música) |

## Layouts disponibles

qtile incluye layouts variados:

```python
layouts = [
    layout.MonadTall(),      # Principal izquierda, stack derecha
    layout.MonadWide(),      # Principal arriba, stack abajo
    layout.Max(),            # Ventana maximizada
    layout.Columns(),        # Columnas de ancho fijo
    layout.Tile(),           # Mosaico tradicional
    layout.Matrix(),         # Matriz de celdas
    layout.RatioTile(),      # Tamaños proporcionales
    layout.VerticalTile(),   # Mosaico vertical
    layout.Zoomy(),          # Zoom en ventana activa
    layout.Floating(),       # Ventanas flotantes
    layout.Bsp(),            # Árbol binario (como bspwm)
]
```

## qtile en Wayland

```bash
# Arrancar qtile en Wayland
qtile start -b wayland

# O por defecto en start script
echo "exec qtile start -b wayland" > ~/.xinitrc

# En X11
qtile start -b x11
```

## Comparativa con alternativas

| Aspecto | qtile | bspwm | i3 | awesome |
|---|---|---|---|---|
| **Configuración** | Python | Shell (bspc) | Texto | Lua |
| **Barra integrada** | Sí (widgets) | No | No (i3bar simple) | Sí |
| **Backend** | X11 + Wayland | X11 | X11 | X11 |
| **RAM idle** | ~80 MB | ~50 MB | ~45 MB | ~100 MB |
| **Curva** | Media (Python) | Media | Baja | Alta (Lua) |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Config Python con error no arranca | Sintaxis/layout inválido | `python -c "import config"` para depurar; revisar `~/.config/qtile/config.py` |
| Widget no se actualiza | Backend o librería ausente | Comprobar dependencias (`psutil`, `netifaces`…) y reiniciar |
| Wayland + atajos fallan | GDK/backend | Lanzar `qtile start -b wayland` con la sesión correcta |
| No se ve la barra | Extensión no cargada | Verificar lista `screens[0].bar` en config |

## Notas personales

- qtile es el WM ideal para programadores Python que quieren personalizar su escritorio sin aprender un lenguaje nuevo. La configuración es Python puro y puedes importar cualquier librería estándar.
- La barra integrada con widgets es uno de sus puntos fuertes: no necesitas polybar ni scripts externos para tener fecha, batería, red, CPU, etc.
- El backend dual (X11 + Wayland) es una ventaja única: misma configuración, dos protocolos. Pero en Wayland algunos widgets pueden no funcionar igual.
- El layout `Bsp()` implementa el árbol binario de bspwm, lo que te da lo mejor de ambos mundos: la potencia de Python + el modelo BSP.

## Ver también

- [[bspwm]] — tiling WM minimalista en C
- [[i3]] — tiling WM clásico
- [[Sway]] — i3-compatible para Wayland
- [[Hyprland]] — WM Wayland moderno
- [[Comparativa gestores de ventanas]] — comparativa completa de todos los WMs

## Enlaces externos

- [qtile — Página oficial](http://www.qtile.org/)
- [qtile Documentation](https://docs.qtile.org/)
- [qtile GitHub](https://github.com/qtile/qtile)
- [ArchWiki — qtile](https://wiki.archlinux.org/title/Qtile)

#entorno-escritorio
