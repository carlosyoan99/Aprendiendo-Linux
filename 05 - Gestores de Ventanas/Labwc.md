---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: entorno-escritorio
prioridad: media
---

# labwc

> Compositor Wayland de stacking inspirado en Openbox. Configuración vía XML (librwc), compatible con waybar, wlroots.

## Qué es

labwc es un compositor Wayland que busca ser el equivalente de Openbox para Wayland: stacking simple, configuración vía XML, compatible con el ecosistema wlroots (waybar, wofi, swaybg).

| Aspecto | Detalle |
|---|---|
| **Tipo** | Stacking compositor Wayland |
| **Base** | wlroots |
| **Configuración** | XML (`~/.config/labwc/rc.xml`) |
| **Temas** | Openbox themes compatibles |
| **Barras** | waybar, yambar |
| **Launcher** | wofi, fuzzel, rofi-wayland |

## Instalación

```bash
# Arch
sudo pacman -S labwc waybar wofi wl-clipboard

# Debian/Ubuntu (wlroots needed)
sudo apt install labwc
```

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `Super+Return` | Abrir terminal |
| `Super+Q` | Cerrar ventana |
| `Super+F` | Maximizar |
| `Super+V` | Menú de ventanas |
| `Super+D` | Launcher (wofi) |

## Configuración

```xml
<!-- ~/.config/labwc/rc.xml -->
<labwc_config>
  <keyboard>
    <keybind key="A-Return">
      <action name="Execute"><command>foot</command></action>
    </keybind>
    <keybind key="A-F4">
      <action name="Close"/>
    </keybind>
  </keyboard>
</labwc_config>
```

## Ver también

- [[Openbox]], [[Fluxbox]], [[Wayfire]], [[Hyprland]]

## Enlaces externos

- [GitHub — labwc](https://github.com/labwc/labwc)
- [Arch Wiki — labwc](https://wiki.archlinux.org/title/Labwc)

#entorno-escritorio #wayland
