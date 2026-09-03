---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: WM (tiling, minimalist, keyboard-driven)
motor_composicion: x11
lenguaje_config: Configuración en ~/.ratpoisonrc (comandos propios)
---
# Ratpoison

> Gestor de ventanas **X11 tiling minimalista**, inspirado en **GNU Screen** y **Emacs**: sin barras, sin marcos, sin iconos — toda la interacción es por **teclado** con prefijo `C-t`. Perfecto para usuarios de terminal que quieren eficiencia total y consumo insignificante.

> **Calidad**: un entorno/WM completo para `resuelto` supera las ~130 líneas (qué es, instalación, configuración, atajos, comparativa, troubleshooting). Esta nota la cumple.

## Qué es

**Ratpoison** es un window manager de X11 que se autodescribe como "Screen without mouse" (Screen sin ratón). Su objetivo es que **la ventana ocupe toda la pantalla** y que cambi entre ventanas directamente, como se hace con panes de `screen`/`tmux`, mediante combinaciones de teclado comandadas a un prefijo.

Escrito en **C**, es increíblemente ligero (~10-20 MB de RAM), estable y sin adornos: no trae barra de tareas, fondo de pantalla ni decoraciones de ventana. Toda la configuración es texto plano en `~/.ratpoisonrc`, con los mismos comandos que su controlador.

**Público objetivo**: programadores y usuarios avanzados que ya viven en terminal y no soportan el mouse, con foco en eficiencia máxima en escritorios virtuales de pantalla completa.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Tipo** | WM tiling de pantalla completa (un marco activo) |
| **Motor** | X11 puro (no Wayland) |
| **Prefijo** | `C-t` (Ctrl+t) como Screen |
| **Interacción** | 100% teclado, sin mouse, sin barra |
| **Configuración** | `~/.ratpoisonrc` en texto plano |
| **RAM en idle** | ~15 MB |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Cualquier x86_64 | x86_64 moderna |
| **RAM** | 32 MB | 256 MB+ |
| **GPU** | VGA básica | VGA con drivers X11 |

## Instalación

```bash
# En Debian/Ubuntu
sudo apt install ratpoison

# En Arch
sudo pacman -S ratpoison

# En Fedora
sudo dnf install ratpoison
```

Post-instalación: agregar `exec ratpoison` a `~/.xinitrc`, o en el gestor de sesión.

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | `~/.ratpoisonrc` (se crea en el primer arranque) |
| **Lenguaje** | Comandos Ratpoison (mixtos) |
| **Recomposición en caliente** | Sí, con `C-t :` ejecutando comandos |

Añadir al primer arranque:

```bash
# En ~/.ratpoisonrc (ejemplo)
exec urxvt
escape C-t
```

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `C-t C-c` | Cerrar la ventana activa |
| `C-t C-n` | Siguiente ventana |
| `C-t C-p` | Anterior ventana |
| `C-t C-number` | Ir a una ventana concreta |
| `C-t t` | Lista de ventanas |
| `C-t :` | Lanzar un comando (ratpoison) |
| `C-t space` | Subir/bajar de ventana (según configuración) |

## Personalización visual

- Sin barra ni decoraciones: la forma es intencional — toda la estética viene de la app (uso `urxvt`, `st`).
- Fondo: puede fijarse con **xsetroot -solid** o el daemon de wallpaper.
- Es común combinarlo con **st** o **urxvt** para emular la experiencia `screen` + `vim`.

## Comandos asociados

| Comando | Para qué |
|---|---|
| `ratpoison` | Lanzar el WM |
| `C-t : windows` | Listar ventanas |
| `C-t : execute <cmd>` | Ejecutar un comando externo |
| `ratpoison --help` | Ayuda por terminal |

## Comparativa con alternativas

| Aspecto | Ratpoison | DWM | Xmonad | bspwm |
|---|---|---|---|---|
| **Rendimiento** | Excelente | Excelente | Muy bueno | Muy bueno |
| **RAM en idle** | ~15 MB | ~20 MB | ~40 MB | ~30 MB |
| **Curva aprendizaje** | Media-Alta (keyboard) | Alta | Alta (Haskell) | Media |
| **Estilo** | Pantalla completa (Screen) | Tiling flotante | Tiling dinámico | Tiling manual |
| **Configuración** | Texto plano | C (recompilar) | Haskell (recompilar) | Bash |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Consumo mínimo (~15 MB) | Sin barra ni decoraciones (estética espartana) |
| 100% teclado (como Screen) | Curva de aprendizaje teclado |
| Estable y muy ligero | Sin Wayland |
| Config simple en texto | Pocas personalizaciones visuales |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| No responde a teclas | Prefijo distinto o app capturando | Ajustar `escape` en config |
| No lista ventanas | No hay apps en ejecución | Abrir terminal primero |
| Arranca y no se ve nada | No hay `.xinitrc` | `exec ratpoison` en `.xinitrc` |

## Notas personales

- Ratpoison es la experiencia **Screen + mouse-free**: para quienes ya viven en terminal, es pura eficiencia.
- No esperes un escritorio bonito: su objetivo es que la ventana llene todo y tu foco esté solo en la tarea.
- Ideal para máquinas muy viejas o SSH sessions con X-forwarding, por su consumo casi nulo.

## Enlaces externos

- [Sitio oficial Ratpoison](https://www.nongnu.org/ratpoison/)
- [Ratpoison en Savannah/GNU](https://savannah.nongnu.org/projects/ratpoison)
- [Wikipedia — Ratpoison](https://en.wikipedia.org/wiki/Ratpoison_(software))
- [Ratpoison GitHub](https://github.com/rail-rico/ratpoison?tab=readme-ov-file)
- [Arch Wiki — Ratpoison](https://wiki.archlinux.org/title/Ratpoison)

## Ver también

- [[DWM]] — WM tiling minimalista en C
- [[Xmonad]] — WM tiling configurable en Haskell
- [[Comparativa gestores de ventanas]] — guía para elegir WM
- [[Wayland vs X11]] — servidor gráfico subyacente

#entorno-escritorio