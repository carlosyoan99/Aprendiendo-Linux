---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: Entorno de escritorio (estética macOS)
motor_composicion: x11-wayland
lenguaje_config: —
---

# CutefishOS

> Entorno de escritorio con estética macOS-like: dock inferior, barra superior y animaciones suaves sobre Qt5 + KDE Frameworks y KWin.

## Qué es

CutefishOS (también **Cutefish Desktop**) es un entorno de escritorio ligero que replica la experiencia de macOS en Linux: **dock inferior** con efecto de aumento, **barra de estado superior**, launcher a pantalla completa y transiciones suaves entre ventanas. Se distribuye como distro propia basada en Ubuntu, pero el entorno también se puede instalar sobre otras distribuciones.

- **Filosofía**: "Linux fácil de usar con la estética de macOS", pensado para usuarios que vienen de Apple o del mundo móvil.
- **Base tecnológica**: **Qt5 + KDE Frameworks** y **KWin** como compositor, que soporta tanto **X11 como Wayland**.
- **Componentes propios**: cutefish-dock, cutefish-statusbar, cutefish-launcher, cutefish-filemanager y cutefish-settings, todos desarrollados por el mismo equipo.
- **Estado (2026)**: proyecto en **pausa/abandonado** — la actividad pública decayó hacia 2022. Sigue siendo interesante como referencia o para experimentar, pero no es una apuesta para un sistema en producción.

| Aspecto | Detalle |
|---|---|
| **Toolkit** | Qt5 + KDE Frameworks |
| **Compositor** | KWin (X11 y Wayland) |
| **Estilo** | macOS-like (dock inferior, barra superior, launcher fullscreen) |
| **Distro propia** | CutefishOS (base Ubuntu) |
| **Lenguaje de desarrollo** | C++ |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 2 núcleos | 4+ núcleos |
| **RAM** | 2 GB | 4 GB |
| **GPU** | Compatible con X11 básico | GPU con soporte Wayland/composición 3D |
| **Disco** | ~20 GB | 40 GB+ |

## Instalación

```bash
# Como distro independiente (CutefishOS): imagen ISO desde la página oficial

# Como DE en otra distro:

# Arch (vía AUR)
yay -S cutefish

# Debian/Ubuntu — paquetes .deb publicados en el GitHub oficial (cutefish-*)
sudo dpkg -i <paquete>.deb     # o gdebi

# Fedora — sin paquete oficial; toca compilar desde fuente
```

En la distro propia ya inicia por defecto; al instalar el DE sobre otra distro, elige la sesión desde el gestor de pantalla del login.

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | Mayormente gráfica: `cutefish-settings` + config por app bajo `~/.config/cutefish/` |
| **Lenguaje** | Sin lenguaje de config de usuario (todo por GUI) |
| **Recomposición en caliente** | Sí — casi todos los cambios de apariencia aplican al momento |

Desde `cutefish-settings` se cambian el fondo de pantalla, el tema, el acento, el dock (tamaño, posición, auto-ocultar), el idioma y los atajos.

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Super` | Launcher a pantalla completa (estilo Launchpad) |
| `Super + D` | Mostrar escritorio |
| `Alt + Tab` | Cambiar entre ventanas |
| `Ctrl + Alt + T` | Abrir terminal |
| `Alt + F4` | Cerrar ventana |
| `Super + Flechas` | Ajustar/empujar ventana (KWin) |

Configurables desde las propias aplicaciones y desde las opciones de KWin.

## Personalización visual

- **Dock**: inferior por defecto, con efecto de aumento al pasar el ratón (como macOS) y auto-ocultado opcional.
- **Barra superior**: hora, WiFi, volumen, batería y centro de notificaciones.
- **Tema**: opciones claro/oscuro propias del equipo y acento de color.
- **Fondos**: wallpapers precargados de la distro, cambiables desde settings.
- **Apps precargadas**: gestor de archivos propio (cutefish-filemanager) y un kit básico coherente con la estética.

## Comandos asociados

| Comando | Para qué |
|---|---|
| `cutefish-dock` | Barra de acoplamiento inferior |
| `cutefish-statusbar` | Barra de estado superior |
| `cutefish-launcher` | Lanzador pantalla completa |
| `cutefish-filemanager` | Gestor de archivos |
| `cutefish-settings` | Centro de configuración |
| `cutefish-daemon` | Procesos de fondo / D-Bus del sistema |

## Comparativa con alternativas

| Aspecto | CutefishOS | Pantheon | GNOME | KDE Plasma |
|---|---|---|---|---|
| **Estética** | macOS-like | macOS-like | Propia | Clásica (configurable) |
| **Toolkit** | Qt5 | GTK (Granite) | GTK | Qt |
| **Compositor** | KWin | Mutter | Mutter | KWin |
| **Actividad** | Abandonado | Activo (elementary OS) | Muy activo | Muy activo |
| **Peso** | Ligero | Medio | Medio-alto | Medio |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Estética macOS muy pulida "out of the box" | Proyecto inactivo (sin actividad sustancial desde ~2022) |
| Ligero: Qt5 + KWin es frugal en recursos | Ecosistema pequeño, casi sin temas/plugins de terceros |
| Dock con efecto de aumento incluido | Aplicaciones dependientes del desarrollador original |
| Buen punto de partida para equipos modestos | Pocas actualizaciones de seguridad |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| No arranca en hardware reciente | Kernel/base Ubuntu antiguos en la ISO | Instalar el DE sobre una distro actual en vez de usar la ISO |
| El dock no aparece | Proceso `cutefish-dock` caído | `cutefish-dock &` o reiniciar la sesión |
| Apps GTK se ven foráneas | Sin tema GTK adaptado | Aplicar un tema GTK/`kvantum` compatible |
| No hay sesión Wayland | Driver NVIDIA/composición fallando | Entrar por sesión X11 (KWin soporta ambos) |

## Enlaces externos

- [Organización GitHub — CutefishOS](https://github.com/CutefishOS)
- [Repositorio — cutefish-dock](https://github.com/CutefishOS/cutefish-dock)
- [AUR — cutefish (Arch)](https://aur.archlinux.org/packages/cutefish)

## Ver también

- [[Pantheon]] — la otra apuesta macOS en el mundo GTK (elementary OS)
- [[GNOME]] — el DE por defecto de la mayoría de distros Ubuntu
- [[KDE Plasma]] — la suite Qt de referencia
- [[Deepin]] — otro DE que apostó por una estética propia
- [[Wayland vs X11]] — KWin soporta ambos protocolos

#entorno-escritorio #wayland