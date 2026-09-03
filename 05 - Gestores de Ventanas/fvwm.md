---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: WM (completamente configurable, flotante/tiling)
motor_composicion: x11
lenguaje_config: FvwmM4 + Configuración en ~/.fvwm
---
# fvwm

> Gestor de ventanas **X11** extremadamente configurable, descendiente de **fvwm2** (del autor Robb Kidd), que permite desde flotante clásico hasta tiling complejo mediante scripting en escala de Bourne. Sueño/mJ/Potential favorito de usuarios avanzados por su flexibilidad total y bajo consumo de recursos.

## Qué es

**fvwm** (Fellow Window Manager, inicialmente "Virtual Window Manager") es un gestor de ventanas para X11 que destaca por ser **modular y programable**. Su carácter radicalmente configurable lo convirtió en el preferido del universo Linux en los 90 (diseñó modernos escritorios con menús personalizables y barras "pager").

A diferencia de los tiling modernos (i3, DWM, Xmonad), fvwm es un WM **flotante por naturaleza pero programable** — puedes definir layouts, atajos, estilos de ventana, decoraciones y hasta lanzador de aplicaciones en sus funciones `Fvwm*`. Desciende del antiguo **Fvwm** versión 2 (escrito por Robert Nation, mediados de los 90), y su nombre también se lee "Friend of the Window Manager".

**Público objetivo**: usuarios de X11 que disfrutan de configuración profunda, sin Wayland (no lo soporta), que priorizan el rendimiento y la estética minimalista clásica.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Tipo** | WM flotante + posibilidades de scripting tiling |
| **Motor** | X11 puro (no Wayland) |
| **Lenguaje config** | FvwmM4 (Escalable/scripting) en `~/.fvwm/config` |
| **Dependencias** | Mínimas (solo X11 + herramientas básicas) |
| **RAM en idle** | ~20-40 MB |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Cualquier x86 | x86_64 |
| **RAM** | 64 MB | 512 MB+ |
| **GPU** | VGA básica (X11 con drivers) | VGA con aceleración |

## Instalación

```bash
# En Debian/Ubuntu
sudo apt install fvwm

# En Arch
sudo pacman -S fvwm

# En Fedora
sudo dnf install fvwm
```

Post-instalación: arrancar desde el gestor de sesión (elegir "fvwm") o con `exec fvwm` en `~/.xinitrc`.

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | `~/.fvwm/config` (se crea en el primer arranque) |
| **Lenguaje** | Fvwm/M4 (macros escalables) |
| **Recomposición en caliente** | No (al modificar config hay que reiniciar `fvwm`) |

Ejemplo de configuración base:

```bash
# En ~/.fvwm/config
# Definir estilo de las ventanas
Style "xterm" BorderWidth 2, Relieve Flat
Style "*"         BackColor grey100, ForeColor black

# Atajo global para abrir terminal
Key F1 A M Exec exec urxvt

# Reiniciar con la config nueva
MenuStyle "Reiniciar fvwm" Exec exec fvwm -f ~/.fvwm/config
```

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `Alt + F1` | Menú de aplicaciones (definido en config) |
| `Alt + F2` | Ejecutar comando |
| `Alt + Right/Left` | Cambiar de escritorio virtual (pager) |
| `Alt + Click der.` | Menú de ventana |
| `Alt + Drag` | Mover ventana |
| `Alt + Ctrl + Right/Left` | Cambiar de página de escritorio |

## Personalización visual

- **FvwmButtons**: barra de aplicaciones y lanzadores personalizables.
- **FvwmPager**: cambio de escritorios virtuales (pager), el clásico original.
- **FvwmMenu**: menús jerárquicos programables con perlas simples.
- **Temas**: uno muy popular es el **fvwm-themes** del proyecto clásico.

## Comandos asociados

| Comando | Para qué |
|---|---|
| `fvwm` | Lanzar el gestor |
| `fvwm -f ~/.fvwm/config` | Cargar una configuración concreta |
| `fvwm2` | Alias/emulación de mayor compatibilidad (algunos temas) |
| `FvwmCommand*` | Interfaz de comandos remotos del WM |

## Comparativa con alternativas

| Aspecto | fvwm | Openbox | i3 | Fluxbox |
|---|---|---|---|---|
| **Rendimiento** | Excelente | Muy bueno | Bueno | Muy bueno |
| **RAM en idle** | ~30 MB | ~50 MB | ~45 MB | ~35 MB |
| **Curva aprendizaje** | Alta (config avanzada) | Media | Media | Media |
| **Personalización** | Extrema | Alta | Media | Media |
| **Modo** | Flotante+scripting | Flotante | Tiling | Flotante |
| **Wayland** | No | No | No | No |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Consumo mínimo (~30 MB) | Sin soporte Wayland |
| Configuración casi infinita (scripting) | Curva pronunciada de configuración |
| Muy estable (maduro desde 1990) | Sin tiling presupuestado de fábrica |
| Menús y pager clásicos | Compatibilidad limitada con temas modernos |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Config no tiene efecto | Fichero cache | Ejecutar `fvwm -f ~/.fvwm/config` a mano |
| Fuentes de menú ilegibles | Faltan paquetes de tipos | Instalar `ttf-*`/`xfonts-75dpi` |
| No arranca nada al inicio | Falta `.xinitrc` con `exec fvwm` | Añadir al `.xinitrc` la línea `exec fvwm` |

## Notas personales

- fvwm es un "dinosaurio" funcional: te lleva a los 90 con FvwmPager y menús, pero es de lo más estable que hay en X11.
- Si te gusta **configurar a conciencia** y no te importa el Wayland, fvwm da una libertad incomparable (aunque con esfuerzo).
- Es ideal para **máquinas muy viejas**: con 256 MB de RAM sigue viable con esta ventana.

## Enlaces externos

- [Sitio oficial fvwm](https://www.fvwm.org/)
- [fvwm Wiki](https://fvwmwiki.wikidot.com/)
- [Wikipedia — fvwm](https://en.wikipedia.org/wiki/FVWM)
- [fvwm GitHub](https://github.com/fvwmorg/fvwm)
- [Reddit /r/fvwm](https://reddit.com/r/fvwm)
- [Arch Wiki — fvwm](https://wiki.archlinux.org/title/FVWM)

## Ver también

- [[Fluxbox]] — WM ligero con barra de tareas (heredó herramientas de fvwm)
- [[Openbox]] — flotante ligero configurable
- [[Comparativa gestores de ventanas]] — guía para elegir WM
- [[Wayland vs X11]] — servidor gráfico subyacente

#entorno-escritorio