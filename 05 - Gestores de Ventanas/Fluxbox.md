---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: WM
---

# Fluxbox

## Qué es

**Fluxbox** es un gestor de ventanas **flotante** (stacking) para **X11**, fork de **Blackbox** (2001), creado por **Henrik Kinnunen** para preservar la filosofía minimalista de Blackbox añadiendo funcionalidades como **pestañas en ventanas (tabbing)**.

Es extremadamente ligero, rápido y configurable mediante archivos de texto plano. Su última versión estable (1.3.7) es de 2015, pero no porque esté abandonado — está en modo **mantenimiento**, tan estable que apenas necesita cambios.

```bash
┌─────────────────────────────────────────────────┐
│                  Fluxbox                          │
├─────────────────────────────────────────────────┤
│  2001 — Fork de Blackbox (Henrik Kinnunen)       │
│  2004 — Crecimiento significativo, estabilidad   │
│  2010 — Incorpora tabbing nativo                 │
│  2015 — Fluxbox 1.3.7 (última versión estable)   │
│  2026 — Mantenimiento, estable, presente en      │
│         repos de todas las distros               │
└─────────────────────────────────────────────────┘
```

## Filosofía

- **Ligereza**: funciona en hardware de hace 20 años
- **Velocidad**: arranque instantáneo, sin demonios innecesarios
- **Pestañas en ventanas**: agrupa ventanas relacionadas en un mismo marco (su característica más distintiva)
- **Configurable con texto**: todo se define en archivos de texto plano en `~/.fluxbox/`
- **Sin dependencias pesadas**: no requiere GTK ni Qt (aunque las apps los usen)
- **Sin systemd**: puede ejecutarse en cualquier sistema X11

## Instalación

```bash
# Debian/Ubuntu
sudo apt install fluxbox

# Arch Linux
sudo pacman -S fluxbox

# Fedora
sudo dnf install fluxbox

# openSUSE
sudo zypper install fluxbox

# Desde fuente (última versión)
git clone https://github.com/fluxbox/fluxbox
cd fluxbox
./autogen.sh
./configure --prefix=/usr
make
sudo make install
```

## Configuración

Todos los archivos de configuración están en `~/.fluxbox/`:

```bash
~/.fluxbox/
├── init          # configuración general (estilo, barra, comportamiento)
├── keys          # atajos de teclado
├── menu          # menú contextual (clic derecho)
├── startup       # script que se ejecuta al iniciar sesión
├── apps          # configuraciones por aplicación (posición, decoración)
├── overlay       # sobreescribe estilos sin modificarlos (temas parciales)
└── styles/       # temas de estilo
```

### init

```bash
# ~/.fluxbox/init (fragmentos comunes)
session.styleFile: /usr/share/fluxbox/styles/Clean
session.screen0.toolbar.onTop: True
session.screen0.toolbar.visible: True
session.screen0.toolbar.widthPercent: 100
session.screen0.toolbar.autoHide: False
session.screen0.strftimeFormat: %H:%M
session.screen0.workspaceNames: main,web,dev,media,
```

### keys

```bash
# ~/.fluxbox/keys
# Atajos de teclado
Mod4 Tab :NextWindow
Mod4 Shift Tab :PrevWindow
Mod4 Return :Exec alacritty
Mod4 d :Exec bemenu-run
Mod4 q :Close
Mod4 1 :Workspace 1
Mod4 2 :Workspace 2
Mod4 Left :LeftWorkspace
Mod4 Right :RightWorkspace
Mod4 Shift Left :SendToWorkspace LeftWorkspace
Mod4 Shift Right :SendToWorkspace RightWorkspace
Mod4 Shift t :ToggleDecor
Mod4 t :ToggleTabbing
```

### menu

```bash
# ~/.fluxbox/menu
[begin] (Fluxbox)
  [exec] (Terminal) { alacritty }
  [exec] (Navegador) { firefox }
  [exec] (Archivos) { pcmanfm }
  [submenu] (Desarrollo)
    [exec] (VS Code) { code }
    [exec] (Git GUI) { gitg }
  [end]
  [submenu] (Apariencia)
    [stylesdir] (Estilos)
  [end]
  [separator]
  [config] (Configuración)
  [workspaces] (Espacios de trabajo)
  [separator]
  [exit] (Salir)
[end]
```

### startup

```bash
#!/bin/bash
# ~/.fluxbox/startup
# Apps que se lanzan al iniciar sesión

feh --bg-scale ~/wallpaper.jpg &
tint2 &
nm-applet &
volumeicon &
picom -b &

exec fluxbox
```

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Mod4 + Return` | Abrir terminal |
| `Mod4 + D` | Lanzador de aplicaciones |
| `Mod4 + Q` | Cerrar ventana |
| `Mod4 + Tab` | Siguiente ventana |
| `Mod4 + 1-9` | Ir al workspace N |
| `Mod4 + Left/Right` | Workspace anterior/siguiente |
| `Mod4 + Shift + Left/Right` | Mover ventana a otro workspace |
| `Mod4 + T` | Activar/desactivar tabbing |
| `Mod4 + Shift + T` | Quitar decoración de ventana |

## Características clave

### 1. Tabbing (pestañas en ventanas)

La característica más distintiva de Fluxbox: puedes agrupar ventanas en pestañas arrastrando una sobre otra, o con el atajo `Mod4 + T`.

```bash
# Activar tabbing
# 1. Arrastrar una ventana sobre otra con Shift presionado
# 2. O usar el atajo: Mod4+T en la ventana activa
# 3. Las pestañas aparecen en la parte superior del marco
```

### 2. Slit (dock de applets)

El **slit** es un área especial donde se alojan applets pequeños (reloj, monitor de sistema, bandeja de iconos):

```bash
# Applets comunes para el slit:
# - gkrellm (monitor de sistema)
# - bbsload (carga del sistema)
# - wmclock (reloj)
# - wmcpuload (CPU)
```

### 3. Estilos (theming)

Fluxbox usa su propio sistema de estilos basado en archivos de texto:

```bash
# Los estilos se almacenan en:
/usr/share/fluxbox/styles/     # estilos del sistema
~/.fluxbox/styles/             # estilos del usuario

# Cambiar estilo:
# Menú → Apariencia → Estilos
# O desde init:
session.styleFile: /usr/share/fluxbox/styles/Shade
```

### 4. Workspaces con nombres

```bash
# En init:
session.screen0.workspaceNames: main,web,dev,media,
# (la coma final indica que el resto se numeran automáticamente)
```

## Requisitos

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Pentium III o superior | Cualquier CPU moderna |
| **RAM** | 64 MB | 256 MB |
| **GPU** | Cualquier compatible con X11 | Genérica |
| **Disco** | 50 MB (solo Fluxbox) | 5 GB (con apps) |
| **X11** | ✅ Sí | ✅ |
| **Wayland** | ❌ No | ❌ |

## Fluxbox vs alternativas

| Aspecto | Fluxbox | Openbox | IceWM |
|---|---|---|---|
| **Tipo** | Flotante | Flotante | Flotante |
| **Tabbing** | ✅ Nativo | ❌ No | ❌ No |
| **Barra integrada** | ✅ Sí | ❌ No | ✅ Sí |
| **Slit (dock)** | ✅ Sí | ❌ No | ❌ No |
| **Menú** | Texto plano | XML | Texto plano |
| **RAM idle** | ~50 MB | ~50 MB | ~60 MB |
| **Estilos** | Propios | Tema GTK/OB | Propios |
| **Popular en** | MX Linux, BunsenLabs | Lubuntu, CrunchBang | Puppy Linux, antiX |
| **Ideal para** | Ligereza + funciones integradas | Modularidad total | Familiaridad Windows clásico |

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| **Apps no tienen barra de título** | Tabbing activado | `Mod4 + Shift + T` para restaurar decoración |
| **No aparece el menú** | Archivo menu mal formado | Verificar `~/.fluxbox/menu`, probar con `fluxbox-generate_menu` |
| **Sin sonido** | No hay applet de audio | Añadir `volumeicon &` al startup |
| **Fuentes feas** | Sin hinting configurado | Instalar `fontconfig-infinality` o ajustar `~/.config/fontconfig/` |
| **Sin transparencias** | Sin compositor | Añadir `picom -b &` al startup |

## Notas personales

- Fluxbox me sorprendió por su estabilidad. Con 10 años sin una versión nueva (1.3.7 es de 2015), sigue funcionando perfectamente en distros modernas. Eso es madurez, no abandono.
- El tabbing es su killer feature: poder agrupar ventanas relacionadas en pestañas (varios terminales, o varias ventanas del mismo proyecto) es algo que ningún WM tiling ofrece de serie.
- El slit es otro diferenciador: un área para applets pequeños tipo gkrellm o wmcpuload. Es una idea de los 2000 que aún tiene su encanto.
- Si buscas un escritorio ligero para un PC muy antiguo (512 MB RAM), Fluxbox es mejor opción que Openbox porque ya incluye barra, menú y slit integrados — menos piezas que configurar.

## Ver también

- [[Openbox]] — WM flotante minimalista (fork de Blackbox también)
- [[bspwm]] — tiling binario para X11
- [[Comparativa gestores de ventanas]] — comparativa completa de todos los WMs
- [[Personalización en Linux]] — theming, GTK, Qt
- [[Gestores de Archivos]] — pcmanfm, Thunar con Fluxbox

## Enlaces externos

- [Fluxbox — Página oficial](https://fluxbox.org/)
- [Fluxbox — Documentación](https://fluxbox.org/help/)
- [Fluxbox — GitHub](https://github.com/fluxbox/fluxbox)
- [Fluxbox — ArchWiki](https://wiki.archlinux.org/title/Fluxbox)
- [Fluxbox — Wikipedia](https://en.wikipedia.org/wiki/Fluxbox)
- [Fluxbox — Estilos](https://tenr.de/styles/)
- [Fluxbox — Foro](https://forums.fluxbox.org/)

#entorno-escritorio
