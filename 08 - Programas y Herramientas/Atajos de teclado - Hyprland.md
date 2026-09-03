---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# Atajos de teclado - Hyprland

> Accesos rápidos **por defecto** del compositor Wayland **Hyprland**. Todos los atajos se configuran en `~/.config/hypr/hyprland.conf` en la sección `bind =`. La tecla `SUPER` (Mod4) es el prefijo por defecto.

## Ventanas

| Atajo | Efecto |
|---|---|
| `SUPER + Return` | Abrir terminal (kitty por defecto) |
| `SUPER + Q` | Cerrar ventana activa |
| `SUPER + F` | Ventana completa (fullscreen toggle) |
| `SUPER + V` | Toggle floating (flotante/tiling) |
| `SUPER + P` | Toggle pseudo-tiling (dwindle) |
| `SUPER + J` | Enfocar ventanaabajo |
| `SUPER + K` | Enfocar ventana arriba |
| `SUPER + H` | Enfocar ventana izquierda |
| `SUPER + L` | Enfocar ventana derecha |
| `SUPER + flechas` | Enfocar ventana en esa dirección |
| `SUPER + Shift + J/K/H/L` | Mover ventana activa |
| `SUPER + Shift + flechas` | Mover ventana activa |
| `SUPER + Ctrl + J/K/H/L` | Redimensionar ventana activa |
| `SUPER + Ctrl + flechas` | Redimensionar ventana activa |
| `SUPER + Shift + Espacio` | Mover ventana al frente |
| `SUPER + Alt + Espacio` | Mover ventana atrás |
| `SUPER + bracketleft` | Rotar layout anti-horario |
| `SUPER + bracketright` | Rotar layout horario |
| `SUPER + semicolon` | swapwithmaster |

## Trabajos (Workspaces)

| Atajo | Efecto |
|---|---|
| `SUPER + 1..9` | Cambiar al workspace 1-9 |
| `SUPER + 0` | Ir al workspace 10 |
| `SUPER + mouse_scroll_up/down` | Cambiar workspace con scroll |
| `SUPER + Shift + 1..9` | Mover ventana activa al workspace 1-9 |
| `SUPER + Shift + 0` | Mover ventana al workspace 10 |
| `SUPER + S` | Sticky toggle (ventana visible en todos los WS) |

## Monitor

| Atajo | Efecto |
|---|---|
| `SUPER + alt + flechas` | Mover foco a monitor |
| `SUPER + alt + 1..9` | Mover workspace a monitor |

## Arranquick de aplicaciones

| Atajo | Efecto |
|---|---|
| `SUPER + Return` | Terminal (kitty) |
| `SUPER + E` | File manager (dolphin/nautilus) |
| `SUPER + M` | Navegador (firefox) |
| `SUPER + B` | Barra de estado (waybar/eww) |
| `SUPER + R` | Launcher (wofi/rofi) |

Estos atajos dependen de la configuración personal en `hyprland.conf`. Los de arriba son los más comunes; el usuario define qué app se lanza con cada combinación.

## Arranquick de apps (configuración)

```bash
# En ~/.config/hypr/hyprland.conf
bind = SUPER, Return, exec, kitty
bind = SUPER, E, exec, dolphin
bind = SUPER, M, exec, firefox
bind = SUPER, R, exec, wofi --show drun
bind = SUPER, B, exec, waybar
bind = SUPER, V, exec, code
```

## Resizing mode

| Atajo | Efecto |
|---|---|
| `SUPER + ALT + R` | Entrar en modo resize |
| `flechas` / `h/j/k/l` | Redimensionar |
| `Return` / `Escape` | Confirmar / cancelar |

## Otros

| Atajo | Efecto |
|---|---|
| `SUPER + L` | Bloquear pantalla (si se configura `loginctl lock-session`) |
| `SUPER + Shift + E` | Salir de Hyprland |
| `SUPER + Ctrl + L` | Cambiar contraseña (si se configura) |
| `Print Screen` | Screenshot (grim/slurp si configurado) |
| `Ctrl + Print Screen` | Screenshot de área (slurp selection) |

## Ver también

- [[Hyprland]] — instalación, configuración, plugins, compositor Wayland
- [[Sway]] — compositor Wayland tiling con sintaxis i3
- [[Wayland vs X11]] — comparativa de servidores gráficos
- [[Niri]] — compositor Wayland scrollable
- [[Desktop Shells (Noctalia Caelestia)]] — shell de escritorio con barra

## Enlaces externos

- [Hyprland Wiki — Keybinds](https://wiki.hyprland.org/Configuring/Binds/)
- [Hyprland Wiki — General](https://wiki.hyprland.org/)
- [GitHub — hyprwm/Hyprland](https://github.com/hyprwm/Hyprland)

#programa #atajos #entorno-escritorio
