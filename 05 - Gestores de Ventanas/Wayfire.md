---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: Compositor Wayland flotante (estilo Compiz)
motor_composicion: wayland
lenguaje_config: INI
---

# Wayfire

> Compositor Wayland inspirado en Compiz: efectos 3D, plugins y una configuración INI sencilla sobre la librería wlroots.

## Qué es

Wayfire es un **compositor Wayland** (no un WM clásico ni un DE completo) que recupera el espíritu de Compiz: ventanas flotantes, efectos visuales llamativos (cube 3D, wobbly, expo, scale) y personalización por plugins. Escrito en C++, corre sobre la librería **wlroots** (la misma familia tecnológica que Sway y River), por lo que es **solo Wayland**: no funciona en sesiones X11.

- **Filosofía**: compositor liviano y modular. No incluye barra, lanzador ni wallpaper; se los acopla aparte.
- **Público**: usuarios que quieren efectos estilo Compiz ya funcionando en Wayland y que no necesitan tiling obligatorio.
- **Ecosistema típico**: barra `wf-shell` o Waybar, lanzador `wofi`, y cualquier wallpaper/notificador compatible con el protocolo de capas de Wayland.

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 2 núcleos | 4+ núcleos |
| **RAM** | 2 GB | 4 GB |
| **GPU** | Aceleración 3D OpenGL 3.3+ (iGPU Intel/AMD) | GPU dedicada o iGPU moderna; NVIDIA requiere EGL/Vulkan bien configurado |

Sin aceleración 3D (por ejemplo una VM sin GPU passthrough) Wayfire no arranca o va extremadamente lento.

## Instalación

```bash
# Arch
sudo pacman -S wayfire wf-shell wayland-utils wofi waybar

# Fedora
sudo dnf install wayfire wf-shell wayland-utils wofi waybar

# Debian/Ubuntu
# Sin paquete oficial estable; compilar desde fuente siguiendo el README
sudo apt install meson ninja-build cmake libwlroots-dev gobject-introspection-wayland hicolor-icon-theme
meson setup build && ninja -C build && sudo ninja -C build install
```

Los plugins extra están en el paquete aparte `wayfire-plugins-extra` (disponible en Arch y derivados).

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | `~/.config/wayfire.ini` |
| **Lenguaje** | INI plano, organizado en `[secciones]` (una por plugin) |
| **Recomposición en caliente** | Parcial: la mayoría de opciones se releen al reiniciar Wayfire; algunas se cambian en vivo vía IPC (`wayfire-ipc` / `wfctl`) |

```ini
# ~/.config/wayfire.ini
[core]
plugins = autostart command expo scale switcher vswitcher \
          wm-actions ipc

[command]
binding_power = <super> KEY_ESCAPE

[expo]
binding_toggle = <super> KEY_W

[vswitcher]
binding_next = <super> KEY_RIGHT
binding_prev  = <super> KEY_LEFT
```

Los atajos del plugin `command` se escriben como `binding_<nombre> = <mod> TECLA`. Para listar plugins disponibles consulta el wiki oficial.

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Super + W` | Expo (vista general de workspaces) |
| `Super + Left/Right` | Cambiar de workspace (vswitch) |
| `Super + Enter` | Maximizar/restaurar ventana |
| `Super + Esc` | Menú de apagado (plugin command) |
| `Alt + F4` | Cerrar ventana |
| `Ctrl + Tab` | Switcher (alt-tab entre ventanas) |

Los de las filas superiores corresponden a la configuración por defecto típica; todo es editable en `[command]`, `[vswitcher]`, `[expo]`, etc.

## Personalización visual

- **Efectos**: plugin `cube` (escritorio cubo 3D), `wobbly`, `vanish` (explode al cerrar), `animator`, `fade`, esquinas redondeadas.
- **Barra de estado**: `wf-shell` (la que viene con Wayfire) o **Waybar**, que usa el protocolo de capas de Wayland y muestra workspaces vía `wlr/workspaces`.
- **Lanzador**: `wofi`, `bemenu` o `rofi` (versión Wayland).
- **Fondos**: no trae ninguno; usar `swaybg` o wallutils.
- **Docks/paneles**: posicionables con Waybar (superior/inferior) y módulos propios.

## Comandos asociados

| Comando | Para qué |
|---|---|
| `wayfire` | Iniciar el compositor (desde el gestor de sesión o entrada de inicio) |
| `wayfire --version` | Ver versión |
| `wayfire-ipc` / `wfctl` | Control en caliente por IPC (opciones, plugins, reload) |
| `wf-shell` | Barra/panel que acompaña a Wayfire |
| `waybar` | Barra de estado alternativa (Wayland) |

## Comparativa con alternativas

| Aspecto | Wayfire | Hyprland | Sway |
|---|---|---|---|
| **Tipo** | Flotante + plugins | Tiling dinámico | Tiling manual |
| **Efectos 3D** | Muchos (cube, wobbly, explode) | Animaciones suaves | Mínimos |
| **Configuración** | INI | Archivo declarativo propio | Sintaxis tipo i3 |
| **Librería base** | wlroots | wlroots | wlroots |
| **Curva de aprendizaje** | Media | Media-alta | Baja |
| **Comunidad** | Pequeña-mediana | Muy grande | Grande |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Efectos estilo Compiz en Wayland (lo más cercano al desktop cube moderno) | Ecosistema pequeño: menos documentación y plugins que Hyprland |
| Config INI sencilla y plugins modulares | Hay que montar periféricos aparte (barra, lanzador, wallpaper) |
| Estable y ligero sobre wlroots | Solo Wayland: sin opción X11 |
| Proyecto en desarrollo activo desde 2018 | Algunos plugins extra poco mantenidos |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Pantalla negra al iniciar en NVIDIA | Renderer/EGL no configurado para la GPU | `WLR_NO_HARDWARE_CURSORS=1`; probar `WLR_RENDERER=vulkan` |
| Cursor invisible | Cursor por hardware no soportado | Exportar `WLR_NO_HARDWARE_CURSORS=1` |
| La configuración no hace efecto | El plugin no está cargado en `[core] plugins` | Añadirlo a la lista y reiniciar Wayfire |
| Apps X11 se ven mal | XWayland con escala mal calculada | Forzar DPI/escala de XWayland (`WLR_XWAYLAND`) |
| No arranca en una VM | wlroots exige OpenGL sólido | GPU passthrough o ir a un WM más ligero |

## Enlaces externos

- [Sitio oficial de Wayfire](https://wayfire.org/)
- [Wiki de Wayfire (GitHub)](https://github.com/WayfireWM/wayfire/wiki)
- [Repositorio GitHub — WayfireWM/wayfire](https://github.com/WayfireWM/wayfire)
- [Arch Wiki — Wayfire](https://wiki.archlinux.org/title/Wayfire)

## Ver también

- [[Wayland vs X11]] — el protocolo sobre el que corre
- [[Hyprland]] — tiling con animaciones, la alternativa más popular
- [[Sway]] — tiling minimalista, heredero de i3 en Wayland
- [[i3]] — el clásico tiling en X11

#entorno-escritorio #wayland