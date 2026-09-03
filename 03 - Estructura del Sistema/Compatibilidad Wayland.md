---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: sistema
prioridad: media
---

# Compatibilidad Wayland

> Guía práctica de compatibilidad de aplicaciones en Wayland: qué funciona, qué no, cómo forzar backends, screen sharing con xdg-desktop-portal, y workarounds para apps X11 que no cooperan.

## Qué es

Mientras [[Wayland vs X11]] compara los dos protocolos, esta nota se enfoca en **compatibilidad práctica**: qué apps funcionan nativamente en Wayland, cuáles necesitan XWayland, y cómo resolver los problemas más comunes al migrar de X11.

## Matriz de compatibilidad de apps

### ✅ Funcionan nativamente en Wayland

| App | Categoría | Notas |
|---|---|---|
| **Firefox** | Navegador | Nativo desde v99; forzar con `MOZ_ENABLE_WAYLAND=1` |
| **Chrome / Chromium** | Navegador | Nativo desde ~v110; `--enable-features=UseOzonePlatform --ozone-platform=wayland` |
| **GTK4 apps** (GNOME apps) | Escritorio | Nativo automático |
| **Qt6 apps** (KDE apps) | Escritorio | Nativo automático con `QT_QPA_PLATFORM=wayland` |
| **Electron** (VSCode, Discord, Slack) | Diversos | Nativo desde Electron 28+; `--ozone-platform=wayland` |
| **mpv** | Multimedia | Nativo; `--gpu-context=waylandvk` |
| **Alacritty, Kitty, Foot** | Terminal | Nativos nativos |
| **sway, Hyprland, Niri** | WM | Solo Wayland |
| **wlroots compositors** | WM | Nativos |

### ⚠️ Funcionan vía XWayland (capa de traducción)

| App | Categoría | Workaround |
|---|---|---|
| **Steam / Proton** | Gaming | La mayoría funciona bien via XWayland; Proton usa Wayland nativo en algunos juegos |
| **Wine** | Compatibilidad | Funciona via XWayland; no hay versión Wayland nativa |
| **Java apps** (IntelliJ, Eclipse) | IDE | Java 21+ soporta Wayland; versiones viejas via XWayland |
| **GIMP** | Imagen | GTK2 → XWayland; GIMP 3 (futuro) será GTK3/Wayland nativo |
| **Blender** | 3D | SDL2 soporta Wayland desde Blender 3.x |
| **OBS Studio** | Streaming | Funciona via XWayland; captura nativa con PipeWire |

### ❌ No funcionan en Wayland

| App | Categoría | Alternativa |
|---|---|---|
| **X11 apps que usan XInput2 directamente** | Varios | Sin alternativa; usar XWayland |
| **Algunos screen lockers X11** | Seguridad | Usar locker del compositor Wayland (swaylock, hyprlock) |
| **VirtualBox GUI** | Virtualización | Funciona via XWayland |
| **Apps que dependen de `xdotool`** | Automatización | Usar `ydotool` (Wayland) o `wtype` |
| **Apps con `xprop` / `xset`** | Configuración | No aplican en Wayland; usar herramientas del compositor |

## Screen sharing (compartir pantalla)

En Wayland, la captura de pantalla usa **PipeWire** + **xdg-desktop-portal** en vez del protocolo X11 `XComposite`.

### Requisitos

```bash
# Instalar componentes necesarios
sudo apt install xdg-desktop-portal xdg-desktop-portal-wlr pipewire

# Para GNOME
sudo apt install xdg-desktop-portal-gnome

# Para KDE
sudo apt install xdg-desktop-portal-kde

# Para wlroots (Hyprland, Sway, Niri)
sudo apt install xdg-desktop-portal-wlr
```

### Verificar que funciona

```bash
# Verificar que PipeWire está corriendo
systemctl --user status pipewire pipewire-pulse

# Verificar portales instalados
ls /usr/share/xdg-desktop-portal/portals/

# Verificar que el portal del compositor está disponible
busctl --user list | grep org.freedesktop.portal
```

### Configurar por compositor

```bash
# GNOME — funciona out of the box con Mutter

# Hyprland — configurar portal
# En ~/.config/hypr/hyprland.conf:
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# Sway — similar a Hyprland
exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# En ~/.config/xdg-desktop-portal/portals/wlr.portal:
[main]
use=wlroots
```

### Apps de screen sharing

| App | Soporte Wayland | Método |
|---|---|---|
| **OBS Studio** | ✅ Nativo | PipeWire capture (Screen Capture portal) |
| **Zoom** | ⚠️ XWayland | Funciona via XWayland; compartir pantalla limitado |
| **Google Meet** (en navegador) | ✅ Nativo | Firefox/Chrome usan portal nativo |
| **Discord** | ⚠️ XWayland | Compartir pantalla via XWayland |
| **Telegram** | ⚠️ XWayland | Llamadas via XWayland |

## Forzar backend de apps

### Variables de entorno por toolkit

```bash
# GTK (apps GNOME, GIMP, etc.)
export GDK_BACKEND=wayland        # forzar Wayland
export GDK_BACKEND=x11            # forzar X11 (XWayland)

# Qt (apps KDE, Dolphin, etc.)
export QT_QPA_PLATFORM=wayland    # forzar Wayland
export QT_QPA_PLATFORM=xcb        # forzar X11

# Electron (VSCode, Discord, etc.)
electron --ozone-platform=wayland  # forzar Wayland
electron --ozone-platform=x11      # forzar X11

# SDL2 (juegos, Blender)
export SDL_VIDEODRIVER=wayland     # forzar Wayland
export SDL_VIDEODRIVER=x11         # forzar X11

# Firefox
export MOZ_ENABLE_WAYLAND=1       # forzar Wayland

# Java
export _JAVA_AWT_WM_NONREPARENTING=1  # arregla ventanas en algunos compositores
```

### Permanente en ~/.profile

```bash
# Añadir al final de ~/.profile o ~/.bashrc
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland  # o tu compositor
```

## Herramientas X11 → Wayland

| Herramienta X11 | Alternativa Wayland | Notas |
|---|---|---|
| `xdotool` | `ydotool` | Automatización de teclado/ratón |
| `xset` | Herramientas del compositor | No hay equivalente directo |
| `xprop` | No hay | Información de ventana inaccesible |
| `xclip` | `wl-clipboard` (`wl-copy`, `wl-paste`) | Portapapeles |
| `scrot` / `maim` | `grim` + `slurp` | Screenshots |
| `xrandr` | Herramientas del compositor | Gestión de monitores |
| `compton` / `picom` | No necesario | Wayland tiene composición integrada |
| `xss-lock` | Locker del compositor | Bloqueo de pantalla |
| `xmodmap` | `xkb` o herramientas del compositor | Layout de teclado |

### wl-clipboard (portapapeles)

```bash
# Instalar
sudo apt install wl-clipboard

# Copiar texto
echo "hola" | wl-copy
wl-copy "texto"

# Pegar texto
wl-paste

# Copiar imagen
wl-copy < imagen.png

# Pegar imagen
wl-paste > imagen.png
```

### grim + slurp (screenshots)

```bash
# Instalar
sudo apt install grim slurp

# Screenshot completo
grim ~/screenshot.png

# Screenshot de área (seleccionar con el ratón)
grim -g "$(slurp)" ~/screenshot.png

# Screenshot de monitor específico
grim -o DP-1 ~/screenshot.png

# Copiar al portapapeles
grim -g "$(slurp)" - | wl-copy
```

### ydotool (automatización)

```bash
# Instalar
sudo apt install ydotool

# Clic en coordenadas
ydotool mousemove --absolute 500 300 click 0xC0

# Escribir texto
ydotool type "hola mundo"

# Tecla
ydotool key 28    # Enter
```

## HiDPI y escalado

### Escalado por monitor

```bash
# GNOME — nativo
gsettings set org.gnome.desktop.interface text-scaling-factor 1.5

# Hyprland — en hyprland.conf
monitor=DP-1,2560x1440@60,0x0,1.5    # scale 1.5
monitor=HDMI-A-1,1920x1080@60,2560x0,1.0  # scale 1.0

# Sway — en config
output DP-1 scale 1.5
output HDMI-A-1 scale 1.0

# KDE — Ajustes → Pantallas → Escalado
```

### Fractional scaling

Wayland soporta escalado fraccionario nativo (125%, 150%, 175%):

```bash
# GNOME — nativo
gsettings set org.gnome.desktop.interface scaling-factor 2    # 200%

# Hyprland
monitor=DP-1,2560x1440@60,0x0,1.25    # 125%

# Qt apps
export QT_SCALE_FACTOR=1.5

# GTK apps
export GDK_SCALE=2
```

## HDR y VRR

| Característica | Soporte Wayland | Soporte X11 |
|---|---|---|
| **HDR** | ✅ GNOME 44+, KDE 6.x | ❌ No |
| **VRR** (Variable Refresh Rate) | ✅ Hyprland, Sway, KDE | ⚠️ Limitado |
| **Color management** | ✅ Wayland Color Management Protocol | ❌ No |

```bash
# GNOME — activar HDR (experimental)
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

# Hyprland — VRR
monitor=DP-1,2560x1440@144,0x0,1,vrr,1
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| App se ve borrosa | Escalado incorrecto o XWayland sin escalar | `GDK_SCALE=2` o `QT_SCALE_FACTOR=2` para la app |
| App no muestra cursor | Cursor theme no configurado | `gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'` |
| No puedo compartir pantalla en Zoom | Zoom usa X11 para screen capture | Usar Zoom en Firefox (funciona con portal nativo) |
| Portapapeles no funciona entre XWayland y Wayland | Protocolos distintos | `wl-clipboard` para Wayland; apps X11 usan `xclip` |
| Drag & drop no funciona entre apps | Apps de toolkits distintos | Usar apps del mismo toolkit o copiar/pegar |
| Juegos no detectan monitor | SDL2 no usa Wayland | `export SDL_VIDEODRIVER=wayland` |
| App abre en XWayland en vez de Wayland | App no detecta session type | Forzar backend: `GDK_BACKEND=wayland app` |
| Screenshot no funciona | Herramienta X11 en Wayland | Usar `grim` + `slurp` |
| xdotool no funciona | Protocolo X11 no disponible | Usar `ydotool` |

## Verificar qué apps usan XWayland vs Wayland

```bash
# Ver qué apps están en XWayland (DISPLAY definido)
xwaylandvid

# Verificar si una app usa Wayland nativo
xlsclients | grep -i app    # si no aparece, probablemente Wayland

# En GNOME — ver en System Monitor o con:
XDG_SESSION_TYPE=wayland xdotool getactivewindow  # falla si es Wayland nativo
```

## Ver también

- [[Wayland vs X11]] — comparativa teórica de protocolos
- [[Hyprland]] — compositor Wayland moderno
- [[Sway]] — compositor Wayland tipo i3
- [[Niri]] — compositor Wayland scrollable
- [[PipeWire]] — servidor de audio/video que habilita screen sharing
- [[GNOME]] · [[KDE Plasma]] — DEs con Wayland por defecto
- [[xdg-desktop-portal]] — API de portales para servicios del escritorio

## Enlaces externos

- [Are We Wayland Yet?](https://arewewaylandyet.com/) — estado de compatibilidad
- [Arch Wiki — Wayland](https://wiki.archlinux.org/title/Wayland)
- [Arch Wiki — XWayland](https://wiki.archlinux.org/title/XWayland)
- [freedesktop.org — xdg-desktop-portal](https://flatpak.github.io/xdg-desktop-portal/)
- [Wayland Wiki](https://wayland.freedesktop.org/)
- [Wikipedia — Wayland](https://en.wikipedia.org/wiki/Wayland_(protocol))

#sistema #wayland #compatibilidad
