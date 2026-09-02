---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: WM (flotante/clásico)
motor_composicion: x11
lenguaje_config: archivo de texto (~/.icewm)
---

# IceWM

> Gestor de ventanas **flotante clásico y ligero** para X11, con barras de tareas, menús y temas configurables vía textos simples, muy rápido en hardware modesto y estable desde 1997.

## Qué es

**IceWM** es un window manager de estilo clásico-flotante (tipo Windows/LXDE), pero minimalista: no incluye escritorio integrado, solo gestión de ventanas, barra de tareas y menú de inicio. Se controla con archivos de texto bajo `~/.icewm/`.

- **Barra de tareas** y **bandeja** integradas
- **Menú de inicio** (menu) configurable en texto
- **Temas** (`themes/`) que cambian bordes y colores
- **Claves/atajos** configurados en `keys`
- Muy **ligero** (~10 MB RAM) y rápido en equipos antiguos
- Solo **X11** (no Wayland)

Es el complemento de escritorio de LDXE por defecto en algunas distros ligeras. Filosofía: simple, estable y sin frivolidades.

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Muy antigua | Dual-core |
| **RAM** | ~64 MB | 256 MB+ |
| **GPU** | Básica | Compatible X11 |

## Instalación

```bash
# En Debian/Ubuntu
sudo apt install icewm

# En Arch
sudo pacman -S icewm

# En Fedora
sudo dnf install icewm
```

Tras instalar, arrancar con `icewm-session` (desde el gestor de sesión o `startx`).

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | `~/.icewm/` (`icewmrc`, `keys`, `menu`, `preferences`, `theme`) |
| **Lenguaje** | Texto/INI simple |
| **Recomposición en caliente** | Parcial (recarga con `pk`/`xdotool`; espaciar con re-login) |

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Alt + Tab` | Cambiar ventana |
| `Ctrl + Esc` | Abrir menú de inicio |
| `Super/Ctrl + 1-9` | Cambiar workspace |
| `Alt + F4` | Cerrar ventana |

## Personalización visual

- **Temas**: en `~/.icewm/themes/`, cambiar con `theme` en `preferences`
- **Barra/botones**: bordes, sliders de color en `icewmrc`
- **Menú**: editar `menu` para agregar lanzadores
- Semi-transparencia vía compositor externo si se desea

## Comandos asociados

| Comando | Para qué |
|---|---|
| `icewm` | Arrancar WM (login) |
| `icewm-session` | Arrancar sesión completa (con ficheros config) |
| `icewmbg` | Fondo de pantalla |
| `icewm-menu` | Generar menú desde programa |

## Comparativa con alternativas

| Aspecto | IceWM | Fluxbox | XFCE |
|---|---|---|---|
| **Rendimiento** | Muy alto | Muy alto | Alto |
| **RAM en idle** | ~10 MB | ~10 MB | ~150 MB |
| **Curva aprendizaje** | Baja | Baja | Baja |
| **Personalización** | Media | Media | Media |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Extremadamente ligero y estable | Sin gestor de escritorio completo (no hay networking integrado) |
| Config en texto simple | Solo X11, sin soporte Wayland |
| 25+ años de madurez | Estética un poco "clásica" por defecto (varía con temas) |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Menú no muestra apps | Falta actualizar menú | Ejecutar `icewm-menu` o editar `~/.icewm/menu` |
| No hay fondo | Falta config | Editar `icewmrc` con `DesktopBackgroundImage` o usar `icewmbg` |
| Tema no aplica | Tema no instalado | Copiar tema a `~/.icewm/themes/` |

## Notas personales
- Perfecto para resucitar hardware muy antiguo manteniendo menús y barras sin bloat.
- Buena elección si solo quieres un WM clásico sin dependencias pesadas.

## Enlaces externos
- [Sitio oficial](https://ice-wm.org/)
- [Arch Wiki — IceWM](https://wiki.archlinux.org/title/IceWM)
- [Wikipedia — IceWM](https://en.wikipedia.org/wiki/IceWM)
- [Repositorio GitHub](https://github.com/ice-wm/icewm)

## Ver también
- [[Fluxbox]] — WM clásico ligero alternativo
- [[Openbox]] — WM flotante ligero configurable
- [[Wayland vs X11]] — servidor gráfico subyacente

#entorno-escritorio