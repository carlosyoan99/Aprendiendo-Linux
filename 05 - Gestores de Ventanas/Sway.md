---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: entorno-escritorio
prioridad: alta
tipo: WM
---

# Sway

## Qué es

**Sway** es el **reemplazo de i3 para Wayland**. Es compatible con la mayoría de configuraciones de i3 (misma sintaxis, mismos atajos por defecto), pero corre nativamente en Wayland sin X11. Es mantenido por **Drew DeVault** y la comunidad de swaywm.

Al correr en Wayland, Sway ofrece mejor seguridad (no permite keylogging de otras apps), mejor rendimiento con GPUs modernas, soporte nativo para pantallas HiDPI y gestos táctiles.

## Filosofía

- **i3-compatible**: migrar de i3 a Sway es casi instantáneo (copias el config y funciona)
- **Wayland nativo**: sin capas de compatibilidad XWayland (aunque la soporta para apps legacy)
- **Seguridad**: una app no puede keyloggear a otra ni acceder a la pantalla sin permiso
- **Rendimiento**: sin el overhead de X11, las animaciones son más fluidas

## Instalación

```bash
# Debian/Ubuntu
sudo apt install sway

# Arch Linux
sudo pacman -S sway

# Fedora
sudo dnf install sway

# openSUSE
sudo zypper install sway

# Desde fuente
git clone https://github.com/swaywm/sway.git
cd sway && meson build && ninja -C build && sudo ninja -C build install
```

## Configuración

La configuración es compatible con i3 (misma sintaxis):

```bash
# ~/.config/sway/config
# =====================

# Modificador
set $mod Mod4

# Terminal
bindsym $mod+Return exec foot

# Navegación
bindsym $mod+Left focus left
bindsym $mod+Right focus right
bindsym $mod+Up focus up
bindsym $mod+Down focus down

# Workspaces
bindsym $mod+1 workspace number 1
bindsym $mod+Shift+1 move container to workspace number 1

# Layout
bindsym $mod+b splith
bindsym $mod+v splitv
bindsym $mod+f fullscreen

# Floating
bindsym $mod+Shift+space floating toggle

# Reiniciar Sway
bindsym $mod+Shift+r restart

# Barra de estado
bar {
    position top
    status_command i3status
    colors {
        statusline #ffffff
        background #1e1e1e
        inactive_workspace #3e3e3e #3e3e3e #888888
    }
}

# Configuraciones de entrada (teclado, touchpad)
input type:keyboard {
    xkb_layout es
}
input type:touchpad {
    tap enabled
    natural_scroll enabled
}
```

## Variables de entorno útiles

```bash
# Añadir a ~/.bashrc o ~/.zshrc para apps Wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export MOZ_ENABLE_WAYLAND=1          # Firefox en Wayland
export QT_QPA_PLATFORM=wayland       # Qt en Wayland
export GDK_BACKEND=wayland           # GTK en Wayland
export ELM_DISPLAY=wl                # Enlightenment en Wayland
export SDL_VIDEODRIVER=wayland       # SDL2 en Wayland
export _JAVA_AWT_WM_NONREPARENTING=1 # Java en Wayland
```

## swaymsg — control remoto

```bash
# Listar workspaces
swaymsg -t get_workspaces

# Listar outputs (pantallas)
swaymsg -t get_outputs

# Listar inputs
swaymsg -t get_inputs

# Cambiar a workspace específico
swaymsg workspace number 3

# Ejecutar comando
swaymsg exec firefox

# Ver árbol de ventanas
swaymsg -t get_tree
```

## Herramientas del ecosistema

| Herramienta | Propósito |
|---|---|
| **waybar** | Barra de estado (alternativa moderna a i3status) |
| **wofi** | Lanzador de aplicaciones Wayland |
| **swaylock** | Pantalla de bloqueo |
| **swayidle** | Gestión de inactividad (suspender, bloquear) |
| **mako** | Notificaciones (en Wayland) |
| **grim** | Captura de pantalla |
| **slurp** | Selección de región (para grim) |
| **wf-recorder** | Grabación de pantalla |
| **foot** | Terminal ligera Wayland nativa |

## Sway vs i3

| Aspecto | Sway | i3 |
|---|---|---|
| **Protocolo** | Wayland | X11 |
| **Seguridad** | Alta (aislamiento de apps) | Baja (keylogging posible) |
| **HiDPI** | Nativo | Escalado X11 (difuso) |
| **Gestos táctiles** | ✅ | ❌ |
| **Config** | i3-compatible | Propia |
| **Barra** | swaybar (i3bar protocol) | i3bar |
| **Apps legacy** | XWayland (opcional) | Nativas X11 |
| **NVIDIA** | ⚠️ Limitado (requiere nvidia-dkms) | ✅ Completo |

## Notas personales

- Si vienes de i3, Sway es el camino de migración más suave a Wayland. Copias tu config de i3, cambias `i3status` por `waybar` (opcional), y listo.
- Las variables de entorno para apps Wayland son clave: sin `MOZ_ENABLE_WAYLAND=1`, Firefox corre sobre XWayland y pierdes los beneficios de Wayland.
- Sway es más estable que Hyprland pero menos vistoso. No tiene animaciones, blur ni efectos. Si eso te importa, Hyprland es mejor opción.
- El soporte NVIDIA es el talón de Aquiles de Sway. Si tienes GPU NVIDIA, necesitas `nvidia-dkms` y `--my-next-gpu-wont-be-nvidia`.

## Ver también

- [[i3]] — predecesor en X11 (config compatible)
- [[Hyprland]] — WM Wayland moderno con animaciones
- [[Wayland vs X11]] — diferencias de protocolo
- [[Niri]] — WM Wayland con scrolling
- [[Comparativa gestores de ventanas]] — comparativa completa de todos los WMs

## Enlaces externos

- [Sway — Página oficial](https://swaywm.org/)
- [Sway Wiki](https://github.com/swaywm/sway/wiki)
- [Sway GitHub](https://github.com/swaywm/sway)
- [Waybar](https://github.com/Alexays/Waybar)
- [ArchWiki — Sway](https://wiki.archlinux.org/title/Sway)

#entorno-escritorio
