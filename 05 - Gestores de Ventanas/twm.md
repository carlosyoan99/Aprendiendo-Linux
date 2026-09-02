---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: borrador
categoria: entorno-escritorio
prioridad: baja
tipo: WM (flotante/minimalista)
motor_composicion: x11
lenguaje_config: ~/.twmrc (texto/X resources)
---

# twm

> El **Tab Window Manager** de X11, el gestor de ventanas **por defecto del servidor X** desde 1987, minimalista y puramente flotante, ideal para entornos ultra-ligeros, sesiones de rescate y aprender la X Window System.

## Qué es

**twm** es el window manager clásico distribuido con el **servidor X** histórico (proyecto X.org/OpenMotif). Es el "WM por defecto" que carga el X server si no hay otro. Aporta lo mínimo:

- **Bordes de ventana** con títulos y botones de colapso, iconify, etc.
- **Menú raíz** (click en escritorio)
- **Docks/menús** simplistas
- Configuración en `~/.twmrc` (formato de recursos X)
- **Puramente flotante**, sin tiling, sin barra de tareas de estado (aunque tiene Title task menu)

Es mayormente histórico/educativo: perfecto para sesiones X desnudas, contenedores sin DE, o entender cómo funciona el X server sin ningún ayudante moderno.

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Cualquiera (muy antigua) | Cualquiera |
| **RAM** | ~5-10 MB | Ínfima |
| **GPU** | Básica | Compatible X11 |

## Instalación

```bash
# En Debian/Ubuntu
sudo apt install twm

# En Arch
sudo pacman -S twm

# En Fedora
sudo dnf install twm
```

Arrancar con `startx` (si no hay otro WM en `~/.xinitrc`) o `twm &` en una sesión X.

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | `~/.twmrc` |
| **Lenguaje** | Texto / X resources |
| **Recomposición en caliente** | Recargar con `twm -f ~/.twmrc` al reiniciar |

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Click en fondo` | Abrir menú raíz del escritorio |
| `Titlebar - botoón` | Iconify / restaurar |
| `Botones de esquina` | Redimensionar |
| `Alt + Tab` | (config) ciclar ventanas |

## Personalización visual

- Bordes, titlebars y colores vía `~/.twmrc`
- Menú raíz configurado con listas de aplicaciones en el mismo archivo
- Iconos de escritorio (funcionalidad básica)
- Sin barras de estado modernas; se suele combinar con títulos/botones simples

## Comandos asociados

| Comando | Para qué |
|---|---|
| `twm` | Arrancar el gestor de ventanas |
| `twm -f ~/.twmrc` | Cargar config concreta |
| `xrdb` | Cargar recursos X adicionales |

## Comparativa con alternativas

| Aspecto | twm | Openbox | IceWM |
|---|---|---|---|
| **Rendimiento** | Máximo (mínimo) | Alto | Muy alto |
| **RAM en idle** | ~5 MB | ~20 MB | ~10 MB |
| **Curva aprendizaje** | Baja | Baja | Baja |
| **Personalización** | Muy básica | Media | Media |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| El más minimalista posible, cero dependencias | Sin tiling, sin barra moderna, sin temas avanzados |
| Siempre presente en cualquier X | Estética muy antigua (1987) |
| Ideal para rescate/educativo | No pensado para el escritorio diario |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| No hay menú | Mal `IconManager`/botones | Revisar `~/.twmrc`; si vacío usa el default |
| Sesión vacía | Sin fondo/barra | Usar `xsetroot`/otro WM; twm solo gestiona ventanas |
| No redimensiona | Faltan botones config | Definir bordes en `~/.twmrc` |

## Notas personales
- Más una curiosidad histórica que un escritorio operativo moderno.
- Útil para entender el mínimo de la X Window System o entornos de rescate/deploy ultra-ligero.

## Enlaces externos
- [Página de twm (X.org)](https://gitlab.freedesktop.org/xorg/app/twm)
- [Arch Wiki — twm](https://wiki.archlinux.org/title/twm)
- [Wikipedia — twm](https://en.wikipedia.org/wiki/Twm)

## Ver también
- [[Openbox]] — WM flotante ligero moderno
- [[Fluxbox]] — WM ligero con barra
- [[Wayland vs X11]] — servidor gráfico subyacente

#DE-WM