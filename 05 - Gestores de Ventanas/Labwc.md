---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-09-01
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

## Modelo de stacking Wayland

A diferencia de los compositores *tiling* ([[Hyprland]], [[Sway]], [[Wayfire]]), labwc no organiza las ventanas automáticamente: cada ventana se superpone libremente y se mueve con el ratón o atajos, igual que hace [[Openbox]] en X11. Su objetivo es un escritorio **clásico y predecible**: barra superior, menú de aplicaciones y centrado/pantalla completa como maximizado.

## labwc vs Openbox vs Sway vs Wayfire

| Aspecto | labwc | Openbox | Sway | Wayfire |
|---|---|---|---|---|
| **Protocolo** | Wayland | X11 | Wayland | Wayland |
| **Modelo** | Stacking | Stacking | Tiling | Stacking/tiling |
| **Config** | `rc.xml` (XML) | `rc.xml` (XML) | `config` (texto) | `wayfire.ini` |
| **Base** | wlroots | X11 nativo | wlroots | wlroots |
| **Temas** | Openbox themes | Openbox themes | — (colores) | — |
| **Barras** | waybar, yambar | tint2, polybar | waybar | waybar |
| **Ideal para** | Migrar desde Openbox/X11 | X11 clásico | Usuarios i3 | Escritorio vistoso |

> **Receta**: si vienes de Openbox en X11 y quieres Wayland, labwc es el salto más natural — conservas `rc.xml` y los temas de Openbox.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| no arranca / pantalla en negro | falta un compositor de fondo o GPU accel | lanzar `dbus-run-session labwc`; revisar permisos del GPU |
| atajos `Super` no responden | falta el keybind en `rc.xml` | definir `<keybind key="W-Space">` para el launcher |
| ventanas sin bordes/título | falta un theme de Openbox | instalar un tema (`obconf`/Openbox themes) en `~/.themes/` |
| no se ve la barra | no se lanza waybar | añadir `waybar` al archivo de autostart de labwc |
| clic en ventanas va al fondo | desactivada la raises | ajustar `focusFollowMouse` / raises policy en `rc.xml` |

## Notas personales

- En niri uso stacking para tareas puntuales con `sway`-family; labwc es la alternativa stacking pura si quiero un escritorio clásico tipo Openbox.
- La ventaja real frente a X11 es poder probar Wayland sin renunciar al modelo de ventanas flotantes de Openbox.

## Ver también

- [[Openbox]], [[Fluxbox]], [[Wayfire]], [[Hyprland]]
- [[Comparativa gestores de ventanas]] — comparativa completa de todos los WMs
- [[Wayland vs X11]] — diferencias de protocolo

## Enlaces externos

- [GitHub — labwc](https://github.com/labwc/labwc)
- [Arch Wiki — labwc](https://wiki.archlinux.org/title/Labwc)

#entorno-escritorio #wayland
