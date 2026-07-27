---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
---

# Wayfire

> Compositoror Wayland inspirado en Compiz. Efectos visuales, plugins, y personalización extensa con formato de configuración INI.

## Qué es

Wayfire es un compositor Wayland que busca recrear la experiencia de Compiz (efectos, plugins, personalización) bajo el moderno protocolo Wayland. No es un WM completo — es un compositor que puede usarse con barras como waybar.

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `Super` | Menú |
| `Super+Q` | Cerrar ventana |
| `Super+↑/↓` | Mover ventana |
| `Super+F` | Maximizar |
| `Super+1-9` | Cambiar workspace |

## Configuración

```ini
# ~/.config/wayfire.ini
[core]
plugins = ipc vswitch expo scale \
          command wf-shell

[command]
binding_super_q = close
binding_super_f = toggle-maximize
```

## Ver también

- [[Hyprland]], [[Sway]], [[Wayland vs X11]]

#entorno-escritorio #wayland
