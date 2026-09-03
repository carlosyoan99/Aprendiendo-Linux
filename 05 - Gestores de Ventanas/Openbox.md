---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: WM
---

# Openbox

## Qué es

**Openbox** es un gestor de ventanas **flotante** (no tiling) minimalista para **X11**. Extremadamente ligero, configurable y estable. Puede usarse como gestor independiente o como reemplazo del WM dentro de un escritorio completo (LXDE lo usa por defecto; LXQt también lo soporta como opción).

Desarrollado por **Dana Jansens** como fork de **Blackbox** (de ahí el nombre). Openbox fue el estándar de facto para WM flotantes ligeros durante años.

## Filosofía

- **Simple pero potente**: no abruma al usuario pero permite configuraciones muy complejas
- **Estándar**: implementa correctamente los estándares de freedesktop (EWMH, ICCCM)
- **Ligereza extrema**: ~100 MB RAM en idle, funciona en hardware de los 90
- **Pipe menus**: menús generados dinámicamente por scripts

## Características clave

| Aspecto | Detalle |
|---|---|
| **Tipo** | WM flotante (stacking) minimalista |
| **Configuración** | XML (`rc.xml`, `menu.xml`, `autostart`) |
| **Estándares** | EWMH + ICCCM completos |
| **Configuración gráfica** | obconf, obmenu |
| **RAM en idle** | ~100 MB |
| **Wayland** | No (solo X11) |

## Instalación

```bash
# Debian/Ubuntu
sudo apt install openbox obconf obmenu

# Arch Linux
sudo pacman -S openbox

# Fedora
sudo dnf install openbox

# openSUSE
sudo zypper install openbox
```

## Configuración

Openbox se configura mediante **archivos XML**:

### rc.xml — atajos, comportamiento, decoraciones

```bash
# ~/.config/openbox/rc.xml
# =========================

<openbox_config>
  <resistance>
    <strength>10</strength>
  </resistance>

  <focus>
    <focusNew>yes</focusNew>
    <followMouse>no</followMouse>
    <focusLast>yes</focusLast>
    <underMouse>no</underMouse>
  </focus>

  <placement>
    <policy>Smart</policy>
    <center>yes</center>
  </placement>

  <theme>
    <name>Clearlooks</name>
    <titleLayout>NLIMC</titleLayout>
  </theme>

  <keyboard>
    <keybind key="W-Return">
      <action name="Execute"><command>alacritty</command></action>
    </keybind>
    <keybind key="W-d">
      <action name="ToggleShowDesktop"/>
    </keybind>
    <keybind key="A-F4">
      <action name="Close"/>
    </keybind>
  </keyboard>

  <mouse>
    <context name="Titlebar">
      <mousebind button="Left" action="DoubleClick">
        <action name="ToggleMaximizeFull"/>
      </mousebind>
    </context>
  </mouse>
</openbox_config>
```

### menu.xml — menú contextual

```bash
# ~/.config/openbox/menu.xml
# ==========================

<openbox_menu>
  <menu id="root-menu" label="Openbox">
    <item label="Terminal">
      <action name="Execute"><command>alacritty</command></action>
    </item>
    <item label="Navegador">
      <action name="Execute"><command>firefox</command></action>
    </item>
    <separator/>
    <menu id="apps" label="Aplicaciones">
      <item label="GIMP"><action name="Execute"><command>gimp</command></action></item>
      <item label="LibreOffice"><action name="Execute"><command>libreoffice</command></action></item>
    </menu>
    <separator/>
    <item label="Bloquear pantalla">
      <action name="Execute"><command>i3lock</command></action>
    </item>
    <item label="Reiniciar Openbox">
      <action name="Reconfigure"/>
    </item>
    <item label="Salir">
      <action name="Exit"/>
    </item>
  </menu>
</openbox_menu>
```

### autostart — programas al iniciar

```bash
# ~/.config/openbox/autostart
# ============================

# Compositor
picom --config ~/.config/picom/picom.conf &

# Barra de tareas
tint2 &

# Fondo de pantalla
feh --bg-scale ~/wallpaper.jpg &

# Notificaciones
dunst &

# Gestor de portapapeles
copyq &
```

## Herramientas complementarias

| Herramienta | Propósito |
|---|---|
| **tint2** | Barra de tareas ligera |
| **picom** | Compositor (transparencias, sombras) |
| **feh** / **nitrogen** | Fondo de pantalla |
| **dmenu** / **rofi** | Lanzador de aplicaciones |
| **dunst** | Notificaciones |
| **obconf** | Configuración gráfica de Openbox |
| **obmenu** | Editor gráfico de menús |
| **j4-dmenu-desktop** | Lanzador con .desktop files |

## Atajos por defecto

| Atajo | Acción |
|---|---|
| `Alt+Tab` | Siguiente ventana |
| `Alt+F4` | Cerrar ventana |
| `Alt+F8` | Redimensionar |
| `Alt+F7` | Mover |
| `Win+D` | Mostrar escritorio |
| `Win+Space` | Menú Openbox |
| `Alt+Left Click` | Mover ventana |
| `Alt+Right Click` | Redimensionar |

## Comparativa con alternativas

| Aspecto | Openbox | Fluxbox | bspwm | i3 |
|---|---|---|---|---|
| **Estilo** | Flotante | Flotante | Tiling | Tiling |
| **Configuración** | XML | Texto | Shell (bspc) | Texto |
| **RAM idle** | ~100 MB | ~60 MB | ~50 MB | ~45 MB |
| **Pipe menus** | Sí | No | No | No |
| **Wayland** | No | No | No | No |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Cambios en rc.xml no se aplican | No recargado | `openbox --reconfigure` |
| Atajos no responden | Conflicto con otro WM/app | Revisar `Alt+f8`/`Win+d` duplicados |
| Menú Pipe no se ve | Script sin ejecutable | `chmod +x` al script y `openbox --reconfigure` |
| Sesión no arranca | Falta exec en .xinitrc | `exec openbox-session` en `~/.xinitrc` |

## Notas personales

- Openbox fue mi primer WM cuando dejé los DEs completos. Es perfecto para la transición: te acostumbras a controlar ventanas por teclado sin perder la familiaridad del escritorio flotante.
- Los pipe menus son una funcionalidad infravalorada: puedes tener menús generados dinámicamente por scripts (últimos archivos, estado del sistema, etc.).
- Si tienes un PC antiguo (1 GB RAM o menos), Openbox con tint2 y pcmanfm te da un escritorio completamente funcional con ~100 MB de RAM.
- Para usuarios que vienen de Windows, recomiendo empezar con Openbox antes de saltar al tiling puro. La curva es mucho más suave.

## Ver también

- [[Fluxbox]] — fork de Blackbox (primo de Openbox)
- [[bspwm]] — tiling WM minimalista
- [[i3]] — tiling WM clásico
- [[DWM]] — WM suckless minimalista
- [[Comparativa gestores de ventanas]] — comparativa completa de todos los WMs

## Enlaces externos

- [Openbox — Página oficial](http://openbox.org/)
- [Openbox Wiki](http://openbox.org/wiki/)
- [ArchWiki — Openbox](https://wiki.archlinux.org/title/Openbox)
- [Openbox Themes](https://box-look.org/)

#entorno-escritorio
