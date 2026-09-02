---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: WM (flotante/clásico)
motor_composicion: x11
lenguaje_config: archivo de texto (~/GNUstep/Defaults)
---

# Window Maker

> Gestor de ventanas **flotante** para X11 inspirado en el escritorio **NeXTSTEP**, de estética retro alternativa, con iconos/escritorio y configuración por texto, muy estable y ligero, sin dependencia de toolkits pesados.

## Qué es

**Window Maker** es un window manager de estética heredera de **NeXTSTEP** (NeXT de Steve Jobs): escritorio con iconos en el dock, barra de trabajo y menú "switcher". Es conocido por su apariencia elegante oscura y su filosofía de no llevar bloat.

- Estética **NeXTSTEP**: dock con iconos, gradient en ventanas
- Solo **X11**, tiling no es su fuerte (es flotante)
- Configuración por texto (archivos `~/GNUstep/Defaults/WindowMaker`)
- Muy estable y ligero; sin toolkit obligatorio para el propio WM
- Se puede usar sin gestor de escritorio completo (fondo, dock, menú integrados)

En uso activo desde 1997. Va dirigido a quien aprecia la estética retro y quiere un WM ligero con dock.

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Antigua | Dual-core |
| **RAM** | ~128 MB | 256 MB+ |
| **GPU** | Básica | Compatible X11 |

## Instalación

```bash
# En Debian/Ubuntu
sudo apt install wmaker

# En Arch
sudo pacman -S windowmaker

# En Fedora
sudo dnf install windowmaker
```

Arrancar con `wmaker` desde gestor de sesión o `startx`.

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | `~/GNUstep/Defaults/WindowMaker` (y `WMState`, `WMRootMenu`) |
| **Lenguaje** | Texto/plist simple |
| **Recomposición en caliente** | Parcial (`restart` del WM) |

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Alt + Tab` | Cambiar ventana |
| `Alt + F2` | Ejecutar opción (menú apps) |
| `Alt + F3` | Abrir menú del escritorio |
| `Meta/Cmd + click` | Operaciones de ventana |

## Personalización visual

- **Temas** en `~/GNUstep/Library/WindowMaker/Themes`
- **Dock** con iconos y aplicaciones persistentes
- **Switcher** (Alt-Tab) sustituible e iconos de ventana
- Fondos, gradients y colores vía `WPrefs` (preferencias gráficas) o texto

## Comandos asociados

| Comando | Para qué |
|---|---|
| `wmaker` | Arrancar WM |
| `WPrefs` | Preferencias gráficas del WM |
| `wmaker.inst` | Registro de recursos |
| `wmapp` / `wmmenu` | Utilidades del menú de aplicaciones |

## Comparativa con alternativas

| Aspecto | Window Maker | Fluxbox | IceWM |
|---|---|---|---|
| **Rendimiento** | Alto | Muy alto | Muy alto |
| **RAM en idle** | ~30 MB | ~10 MB | ~10 MB |
| **Curva aprendizaje** | Baja | Baja | Baja |
| **Personalización** | Media (dock/neo) | Media | Media |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Estética NeXT única y elegante | Solo X11 |
| Dock y menú integrados, sin DE | Dock puede ser confuso al inicio |
| Muy estable (desde 1997) | Menos comunidad/Eco de temas que otros WMs |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Dock no guarda apps | Config corrupta | Borrar/regenerar `~/GNUstep/Defaults` (guardar backup) |
| Menú no abre | Fichero de menú roto | Editar `WMRootMenu` o reinstalar classic menu |
| Regresa al login al lanzar | Falta `wmaker-session` | Usar `wmaker` socket o login manager que lo reconozca |

## Notas personales
- Ideal para un toque retro-neo y muy estable en hardware viejo.
- Requiere acostumbrarse al "switcher" y dock de estilo NeXT.

## Enlaces externos
- [Sitio oficial](https://www.windowmaker.org/)
- [Arch Wiki — Window Maker](https://wiki.archlinux.org/title/Window_Maker)
- [Wikipedia — Window Maker](https://en.wikipedia.org/wiki/Window_Maker)
- [Repositorio GitHub](https://github.com/window-maker)

## Ver también
- [[Fluxbox]] — WM clásico ligero
- [[IceWM]] — WM clásico ligero con barra de tareas
- [[Wayland vs X11]] — servidor gráfico subyacente

#entorno-escritorio