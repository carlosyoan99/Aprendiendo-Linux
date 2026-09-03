---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: WM (flotante minimalista, C)
motor_composicion: x11
lenguaje_config: Configuración en ~/.xinitrc + opciones al arranque
---
# evilwm

> Window manager **X11** legible y extremadamente ligero escrito en **C**: unos **20 KB** de binario, sin barra de tareas, sin menús, sin iconos — puro flotante con atajos de teclado. La elección definitiva para hardware mínimo y adictos a la simplicidad radical.

## Qué es

**evilwm** es un gestor de ventanas flotante minimalista que nació a finales de los 90 como alternativa de ultra-bajo consumo a fluxbox y openbox. Su filosofía es **"keep it simple"**: apenas decora las ventanas con un borde, permite mover/cambiar el tamaño con el teclado, y no ofrece barra, menú de inicio ni configuraciones gráficas.

Escrito en **C** con muy pocas dependencias, es famoso por ser de los WMs más rápidos y ligeros de X11. Se controla casi exclusivamente por atajos de teclado; las opciones se pasan como argumentos al lanzarlo desde `~/.xinitrc`.

**Público objetivo**: puristas de X11, usuarios de máquinas muy antiguas o con poca RAM, y quienes valoran total transparencia y control del WM por el teclado.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Tipo** | WM flotante minimalista (sin barra ni menús) |
| **Motor** | X11 puro (no Wayland, no compositor) |
| **Binario** | ~20 KB (muy pequeño) |
| **Control** | Atajos de teclado |
| **Configuración** | Opciones CLI en `.xinitrc` |
| **RAM en idle** | <10 MB |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86 clásica | x86_64 |
| **RAM** | 16 MB | 128 MB+ |
| **GPU** | Cualquier VGA | VGA con drivers X11 |

## Instalación

```bash
# En Debian/Ubuntu
sudo apt install evilwm

# En Arch
sudo pacman -S evilwm

# En Fedora
sudo dnf install evilwm
```

Post-instalación: añadir `exec evilwm` al `~/.xinitrc`, o seleccionarlo en el gestor de sesión.

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | `~/.xinitrc` (argumentos CLI) |
| **Lenguaje** | Bash/shell |
| **Recomposición en caliente** | No (reiniciar WM con `Alt+F2` y ejecutar de nuevo) |

Ejemplo de `.xinitrc`:

```bash
#!/bin/sh
exec evilwm -b 8 -no-unmanaged-rules &
```

Opción típica: `-b` determina el grosor del borde; `-no-unmanaged-rules` deja ventanas sin gestionar totalmente transparentes.

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `Alt + Ctrl + Right/Left` | Cambiar de escritorio virtual |
| `Alt + [1-8]` | Ir al escritorio N |
| `Alt + Button1` | Mover la ventana activa |
| `Alt + Button2` | Cambiar tamaño de la ventana |
| `Alt + Esc` | Cerrar la ventana activa |
| `Alt + Tab` | Cambiar de ventana |

## Personalización visual

- **Borde**: modificable con `-b <pixels>` al arrancar; se define el ancho del marco.
- **Fondo**: se fija con `xsetroot` o un gestor de wallpapers externo.
- **Sin barra ni paneles**: para paneles externos usar `tint2`, `dzen2` o `polybar` por fuera.

## Comandos asociados

| Comando | Para qué |
|---|---|
| `evilwm` | Lanzar el WM |
| `evilwm -help` | Mostrar argumentos disponibles |
| `xsetroot -solid gray` | Fijar color de fondo |
| `tint2` / `polybar` | Barra de tareas externa opcional |

## Comparativa con alternativas

| Aspecto | evilwm | Fluxbox | Openbox | IceWM |
|---|---|---|---|---|
| **Rendimiento** | Excelente (top) | Muy bueno | Muy bueno | Bueno |
| **RAM en idle** | ~8 MB | ~35 MB | ~50 MB | ~40 MB |
| **Curva aprendizaje** | Media (teclado) | Media | Media | Baja |
| **Personalización** | Mínima | Alta | Alta | Media |
| **Barra integrada** | No | Sí | No | Sí |
| **Wayland** | No | No | No | No |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Binario diminuto (~20 KB) y RAM mínima | Sin barra, menús ni paneles |
| Muy estable y transparente (C puro) | Configuración solo por CLI |
| Control total por teclado | Sin Wayland, sin compositor nativo |
| Ideal para máquinas viejas | Estética simplemente minimalista |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| No responde atajos | WM no es la sesión activa | Asegurar `exec evilwm` en `.xinitrc` |
| Borde no visible | Opción `-b 0` | Usar `-b 8` para borde visible |
| Sin barra ni clock | No hay barra integrada | Añadir `tint2`/`polybar` externo |

## Notas personales

- evilwm es la opción definitiva cuando quieres el **mínimo absoluto** en un servidor con X o una máquina muy vieja.
- Su escala es impresionante: todo lo que hace cabe en un binario de ~20 KB.
- Ideal combinarlo con `st` y `dzen2` para un escritorio 100% teclado, sin florituras.

## Enlaces externos

- [Sitio oficial evilwm](https://www.6809.org.uk/evilwm/)
- [evilwm GitHub](https://github.com/engineerjoe440/evilwm)
- [Wikipedia — evilwm](https://en.wikipedia.org/wiki/Evilwm)
- [Arch Wiki — evilwm](https://wiki.archlinux.org/title/Evilwm)

## Ver también

- [[Fluxbox]] — WM ligero con barra de tareas (contraste presencia de barra)
- [[Openbox]] — WM flotante ligero configurable
- [[Comparativa gestores de ventanas]] — guía para elegir WM
- [[Wayland vs X11]] — servidor gráfico subyacente

#entorno-escritorio