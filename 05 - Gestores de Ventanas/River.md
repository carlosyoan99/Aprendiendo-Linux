---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: WM
---

# River

## Qué es

**River** es un gestor de ventanas de mosaico (tiling) dinámico para **Wayland**, escrito en **Zig**. Es minimalista como [[DWM]] pero dinámico y configurable en tiempo real mediante `riverctl`.

Su arquitectura **no monolítica** lo distingue de otros WMs Wayland: River actúa como compositor, y la gestión de ventanas puede ser un proceso independiente mediante el protocolo `river-window-management-v1`. Esto significa que si el gestor de ventanas falla, no pierdes la sesión gráfica.

```bash
┌─────────────────────────────────────────────────┐
│              River (compositor + WM)              │
├─────────────────────────────────────────────────┤
│  wlroots (librería base)                         │
│  Zig (lenguaje de programación)                  │
│  riverctl (configuración en tiempo real)         │
│  river-window-management-v1 (gestión externa)    │
│  rivercarro (layout dinámico integrado)          │
└─────────────────────────────────────────────────┘
```

Creado por **Isaac Freund**, River ha ganado popularidad en la comunidad Wayland por su enfoque modular y su filosofía de simplicidad (heredera de dwm y suekless).

## Instalación

```bash
# Arch Linux
sudo pacman -S river

# Debian/Ubuntu
sudo apt install river

# Fedora
sudo dnf install river

# openSUSE
sudo zypper install river

# Compilar desde fuente (Zig requerido)
git clone https://github.com/riverwm/river
cd river
zig build -Drelease-safe
sudo cp zig-out/bin/river /usr/local/bin/
```

## Filosofía y conceptos clave

### Tags vs Workspaces

River usa **tags** en vez de workspaces tradicionales:

| Concepto | Workspaces (i3/Sway) | Tags (River/dwm) |
|---|---|---|
| **Cada ventana** | Pertenece a 1 workspace | Puede tener múltiples tags |
| **Visibilidad** | 1 workspace visible | Múltiples tags visibles a la vez |
| **Movimiento** | Mover entre workspaces | Activar/desactivar tags |
| **Flexibilidad** | Rígido (1:1 ventana/workspace) | Flexible (N:M ventanas/tags) |

```bash
# Tags se numeran del 1 al 9
riverctl focus-view-tags 1              # ver ventanas con tag 1
riverctl toggle-focused-tags 2          # añadir/quitar tag 2 de la ventana activa
riverctl focus-output next              # cambiar de monitor
```

### Configuración dinámica

No hay archivo de configuración estático — se usa un script ejecutable (`~/.config/river/init`) que ejecuta comandos `riverctl` al iniciar:

```bash
#!/bin/sh
# ~/.config/river/init

# Layout
riverctl default-layout rivertile

# Atajos de teclado (mod = Super)
riverctl map normal Super Return spawn alacritty
riverctl map normal Super D spawn "bemenu-run --nb '#222' --nf '#eee'"
riverctl map normal Super Q close

# Focus
riverctl map normal Super J focus-view next
riverctl map normal Super K focus-view previous

# Movimiento de ventanas
riverctl map normal Super+Shift J swap next
riverctl map normal Super+Shift K swap previous

# Tags
for i in $(seq 1 9); do
    tags=$((1 << (i - 1)))
    riverctl map normal Super $i set-focused-tags $tags
    riverctl map normal Super+Shift $i set-view-tags $tags
done

# Layout
riverctl map normal Super Z rivertile-toggle
riverctl map normal Super Space zoom

# Floating
riverctl map normal Super F toggle-float

# Monitor (multi-output)
riverctl map normal Super+Control H focus-output left
riverctl map normal Super+Control L focus-output right
```

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Super + Return` | Abrir terminal (Alacritty) |
| `Super + Q` | Cerrar ventana |
| `Super + D` | Lanzador de aplicaciones (bemenu) |
| `Super + J/K` | Navegar entre ventanas |
| `Super + Shift + J/K` | Mover ventana |
| `Super + 1-9` | Mostrar tag N |
| `Super + Shift + 1-9` | Mover ventana a tag N |
| `Super + Space` | Zoom (ventana activa a pantalla completa) |
| `Super + F` | Alternar modo flotante |
| `Super + Z` | Alternar layout rivertile |
| `Super + Control + H/L` | Cambiar de monitor |

## Características clave

### 1. Arquitectura modular

River expone el protocolo `river-window-management-v1` que permite implementar gestores de ventanas externos. Ya existen más de una docena de implementaciones de la comunidad:

```bash
# Ejemplos de WMs externos para River:
# - rivertile (layout dinámico por defecto)
# - rivermax (maximizar ventanas)
# - river-mirror (espejo de outputs)
```

### 2. rivercarro (layout dinámico)

River incluye **rivercarro**, un layout dinámico tipo dwm (master + stack):

```bash
# En el init:
riverctl default-layout rivertile

# Alternar entre layout:
riverctl map normal Super Z rivertile-toggle
# Alterna entre: master/stack → monocle → grid
```

### 3. riverctl — control en tiempo real

Todo se puede cambiar sin reiniciar:

```bash
# Cambiar layout sobre la marcha
riverctl default-layout rivertile

# Ajustar proporción master/stack
riverctl map normal Super+Shift H mod-master-factor -0.05
riverctl map normal Super+Shift L mod-master-factor +0.05

# Cambiar padding
riverctl view-padding 5
riverctl outer-padding 3

# Recargar configuración
kill -HUP $(pidof river)  # o reiniciar el script init
```

### 4. Soporte de protocolos Wayland

| Protocolo | Soporte |
|---|---|
| `xdg-shell` | ✅ Apps de escritorio estándar |
| `layer-shell` | ✅ Barras (waybar, eww), fondos, notificadores |
| `wlr-layer-shell` | ✅ |
| `xdg-output` | ✅ |
| `wlr-data-control` | ✅ |
| `ext-session-lock` | ✅ Pantalla de bloqueo |
| `screencopy` | ✅ Captura de pantalla |

## Requisitos

| Componente | Requisito |
|---|---|
| **GPU** | Cualquier GPU con soporte Vulkan |
| **Protocolo** | Wayland (no funciona en X11) |
| **Dependencias** | wlroots, pixman, libwayland, libxkbcommon, zig (para compilar) |
| **Barra recomendada** | waybar, eww |
| **Lanzador recomendado** | bemenu, rofi-lbonn-wayland, fuzzel |
| **Fondo recomendado** | swaybg, mpvpaper |
| **Notificador** | mako, dunst |

## River vs alternativas

| Aspecto | River | Sway | DWM |
|---|---|---|---|
| **Protocolo** | Wayland | Wayland | X11 |
| **Lenguaje** | Zig | C | C |
| **Arquitectura** | Modular (WM externo posible) | Monolítica | Monolítica |
| **Tags** | ✅ Tags flexibles | ❌ Workspaces fijos | ✅ Tags |
| **Config** | riverctl (CLI en tiempo real) | Archivo config | Parchear fuente C |
| **Layout** | Dinámico (rivertile) | Manual (i3-like) | Dinámico |
| **Multi-monitor** | ✅ Nativo Wayland | ✅ | ⚠️ X11 |
| **Comunidad** | Pequeña, creciendo | Grande, madura | Grande, nicho |
| **Ideal para** | Minimalistas Wayland, usuarios dwm | Ex-usuarios i3 | Tradicionalistas X11 |

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| **Apps no aparecen** | Usan X11 (sin XWayland habilitado) | Iniciar river con `river -c ~/.config/river/init` sin flags extra, o instalar xwayland |
| **Sin barra ni fondo** | River no incluye nada por defecto | `riverctl spawn waybar`, `riverctl spawn swaybg` en init |
| **No funciona screen sharing** | Wayland + PipeWire necesita configuración | `xdg-desktop-portal-wlr` o `-gnome` |
| **Zig no compila** | Versión incorrecta de Zig | River requiere Zig estable, no nightly |

## Notas personales

- River es el WM que más me recuerda a DWM pero en Wayland: mismo sistema de tags, misma filosofía minimalista, pero sin necesidad de parches ni recompilación.
- La arquitectura modular (WM externo vía river-window-management-v1) es única. Si el layout se cuelga, el compositor sigue funcionando — no pierdes la sesión.
- El mayor inconveniente hoy es la comunidad pequeña. Hay pocos dotfiles de referencia y los tutoriales se cuentan con los dedos de una mano.
- Zig como lenguaje de implementación es interesante, pero como usuario no lo notas. River se configura con riverctl (shell), no con Zig.

## Ver también

- [[Sway]] — el WM Wayland más popular (i3-compatible)
- [[Hyprland]] — WM Wayland moderno con animaciones y efectos
- [[DWM]] — WM minimalista de suckless (inspiración de River)
- [[bspwm]] — tiling binario para X11
- [[Comparativa gestores de ventanas]] — comparativa completa de todos los WMs
- [[Wayland vs X11]] — diferencias entre protocolos

## Enlaces externos

- [River — GitHub](https://github.com/riverwm/river)
- [River — Documentación](https://isaacfreund.com/blog/river-window-management/)
- [River — ArchWiki](https://wiki.archlinux.org/title/River)
- [rivercarro — Layout dinámico](https://github.com/riverwm/river/tree/master/rivertile)
- [wlroots — Librería base](https://gitlab.freedesktop.org/wlroots/wlroots)
- [Wayland — Protocolo](https://wayland.freedesktop.org/)

#entorno-escritorio #wayland
