---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: entorno-escritorio
prioridad: alta
tipo: Compositor Wayland tiling (dinámico)
---

# Hyprland

## Qué es

Compositor **Wayland** (no X11) de mosaico dinámico, muy popular en distros modernas por sus animaciones fluidas y efectos visuales (blur, sombras, transiciones, desvanecimientos) sin sacrificar el paradigma tiling. Es el sucesor espiritual de i3/Awesome pero nativo de Wayland. Escrito en C++, con configuración declarativa en un archivo de texto.

## Instalación

```bash
# Arch / CachyOS
sudo pacman -S hyprland

# Fedora
sudo dnf install hyprland

# Ubuntu/Debian
# Suele requerir el repositorio PPA de ximia o compilar desde fuente
sudo add-apt-repository ppa:xremap/xremap
sudo apt install hyprland
```

## Configuración inicial

- Archivo de config: `~/.config/hypr/hyprland.conf` (texto plano, sintaxis propia declarativa).
- Requiere componentes adicionales típicos de Wayland:

```bash
# Ecosistema mínimo recomendado
sudo pacman -S waybar                     # barra de estado
sudo pacman -S wofi                       # lanzador de apps (rofi-wayland también sirve)
sudo pacman -S hyprpaper                  # wallpaper
sudo pacman -S hyprlock                   # pantalla de bloqueo
sudo pacman -S hypridle                   # gestión de idle/suspensión
sudo pacman -S dunst                      # notificaciones (o mako)
sudo pacman -S polkit-kde-agent           # autenticación gráfica para sudo
```

### Ejemplo de configuración básica

```conf
# ~/.config/hypr/hyprland.conf
monitor=,preferred,auto,1                 # monitor principal, escala 1x

# Atajos
$mainMod = SUPER

bind = $mainMod, Return, exec, kitty
bind = $mainMod, D, exec, wofi --show drun
bind = $mainMod, Q, killactive,
bind = $mainMod, Space, togglefloating,
bind = $mainMod, F, fullscreen,

# Navegación de ventanas
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod SHIFT, 1, movetoworkspace, 1

# Animaciones
animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Decoración
decoration {
    rounding = 10                         # esquinas redondeadas
    blur {
        enabled = true
        size = 5
        passes = 2
    }
    drop_shadow = yes
    shadow_range = 20
}
```

## hyprctl (control en runtime)

```bash
hyprctl monitors                         # info de monitores
hyprctl clients                          # ventanas activas
hyprctl workspaces                       # workspaces
hyprctl dispatch workspace 3             # cambiar workspace
hyprctl keyword decoration:rounding 0    # cambiar configuración en caliente (sin recargar)
hyprctl reload                           # recargar configuración
```

## Multi-monitor en Hyprland

```conf
# En hyprland.conf:
monitor = HDMI-A-1, 1920x1080@144, 0x0, 1       # monitor principal
monitor = eDP-1, 1920x1080@60, 1920x0, 1         # portátil a la derecha
monitor = ,preferred,auto,1                       # cualquier otro monitor con auto-detect

# Workspaces dedicados por monitor
workspace = 1, monitor:HDMI-A-1
workspace = 2, monitor:HDMI-A-1
workspace = 3, monitor:eDP-1
```

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Mod + Enter` | Abrir terminal |
| `Mod + D` | Lanzador de apps |
| `Mod + Q` | Cerrar ventana |
| `Mod + Flechas` | Moverse entre ventanas |
| `Mod + Shift + Flechas` | Mover ventana |
| `Mod + Space` | Toggle floating/tiling |
| `Mod + F` | Pantalla completa |
| `Mod + 1-9` | Workspace N |
| `Mod + Shift + 1-9` | Mover ventana a workspace N |
| `Mod + Mouse (arrastrar)` | Mover ventana flotante |
| `Mod + R` | Modo resize |

(`Mod` = Super por defecto, configurable)

## Animaciones y efectos

Hyprland destaca por su apartado visual. Se configuran desde la sección `animations` y `decoration`:

```conf
# Efecto de desvanecimiento al cambiar workspace
animation = workspaces, 1, 8, default, slide

# Efecto de zoom al abrir ventana
animation = windowsIn, 1, 10, myBezier, popin

# Desenfoque del fondo detrás de ventanas flotantes/menús
decoration {
    blur {
        new_optimizations = true
        xray = true                       # modo más eficiente
    }
}
```

## Pros / Contras

- ✅ Wayland nativo: mejor gestión de mixed-DPI, seguridad, sin screen tearing.
- ✅ Muy estético: animaciones fluidas, blur, sombras, transiciones.
- ✅ Comunidad grande y activa, muchos dotfiles compartidos en r/unixporn y GitHub.
- ❌ Ecosistema Wayland aún tiene huecos de compatibilidad (algunas apps X11 necesitan XWayland, algunas apps de captura de pantalla/grabación pueden no funcionar).
- ❌ Configuración más compleja que i3 (hay que configurar barra, lanzador, wallpaper, notificaciones por separado).
- ❌ Puede ser más pesado que i3/DWM por los efectos visuales.

## Notas personales

- Hyprland es, sin duda, el WM más bonito que he probado. Las animaciones y el blur lo hacen sentir como un escritorio moderno, no como un WM tiling de 2010.
- Pero: el hype ha hecho que mucha gente llegue a Hyprland sin entender tiling. Mi consejo: aprende tiling con Sway o i3 primero, y después migra a Hyprland si quieres los efectos.
- El ecosistema (hyprlock, hypridle, hyprpaper, hyprctl) está muy bien integrado. Todo se configura desde `hyprland.conf`.
- Requisito no negociable: GPU con aceleración 3D. En una iGPU vieja o en una VM, Hyprland va muy lento.
- La comunidad es enorme y activa. Si te atascas, hay solución en Discord, Reddit o la Wiki en cuestión de horas.

## Enlaces externos

- [Wikipedia — Hyprland](https://en.wikipedia.org/wiki/Hyprland)
- [Repositorio oficial en GitHub](https://github.com/hyprwm/Hyprland)
- [Sitio oficial](https://hyprland.org/)
- [Wiki de Hyprland](https://wiki.hyprland.org/)

## Ver también

- [[Niri]] — otro compositor Wayland con paradigma scrollable
- [[i3]] — antecesor en X11, similar en filosofía tiling
- [[Wayland vs X11]]
- [[Emuladores de Terminal]]

#entorno-escritorio
