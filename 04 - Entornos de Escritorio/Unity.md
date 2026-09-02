---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: borrador
categoria: entorno-escritorio
prioridad: media
tipo: DE (shell de escritorio sobre GNOME/Mutter)
motor_composicion: x11 (también wayland experimental)
lenguaje_config: sistema de ajustes gráficos + gsettings
---

# Unity

> Entorno de escritorio que **regresó** como opción en **Ubuntu 23.10+ (Canonical)**, con el clásico **launcher** izquierdo y el **global menu** superior, ahora mantenido por la comunidad Unity8/UnityX, sobre GNOME/Mutter.

## Qué es

**Unity** es un shell de escritorio que Canonical desarrolló para Ubuntu (2011-2017), abandonado por default en 2017 en favor de GNOME, pero **revivido en 2023** por la comunidad y reintroducido como opción oficial en Ubuntu 23.10.

Ese escritorio se caracteriza por:
- **Dash** (lanzador de aplicaciones) y **launcher** vertical en el borde izquierdo
- **Global menu** en la barra superior
- **Indicators** (bandeja/campana) en la barra superior
- Basado en **Mutter/GNOME** (UnityX) o en Mir/GNOME Clutter (versión clásica)

Funciona sobre X11 (y hay build experimental para Wayland). El regreso en Ubuntu 23.10+ lo mantiene Canonical de forma ligera, y la comunidad Unity8 (bombadier) sigue el fork clásico.

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64 1 núcleo | 2 núcleos |
| **RAM** | 2 GB | 4 GB |
| **GPU** | Básica | Compatible con Mutter/OpenGL |

## Instalación

```bash
# En Ubuntu 24.04+ (repo oficial opt-in)
sudo apt install gnome-session-unity unity-shell # o unity (sesión)

# En Arch (AUR)
yay -S unity3d-hub   # yay -S unity-desktop (comunidad)

# En Fedora (COPR en desarrollo)
sudo dnf install unity-*
```

Normalmente se instala el paquete de sesión y se elige "Unity" en el gestor de sesión (LightDM/GDM). Nota: la app `unity-shell` se acerca a la experiencia Unity clásica vía GNOME Shell.

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | `gsettings` (dconf), sincronizado con GNOME |
| **Lenguaje** | GTK/GNOME |
| **Recomposición en caliente** | Parcial (vía gsettings) |

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Super` | Abrir Dash (buscar apps y archivos) |
| `Super + [1-9]` | Seleccionar app del launcher |
| `Super + Tab` | Cambiar de aplicación |
| `Alt + F2` | Comando/ejecutar |
| `Super + Shift + q` | Salir/foco |

## Personalización visual

- Launcher y global menu se comportan por defecto con la estética Unity
- Temas GTK/GNOME; se pueden cambiar vía `gnome-tweaks` y ajustes
- `unity-tweak-tool` (para la versión clásica) para configurar transparencia, autohide, tamaño del launcher
- Autohide del launcher, sensibilidad del borde, etc. vía ajustes

## Comandos asociados

| Comando | Para qué |
|---|---|
| `unity-shell` | Iniciar la sesión Unity nueva |
| `gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false` | Ajustes del launcher |
| `unity --reset` | Resetear config (versión clásica) |

## Comparativa con alternativas

| Aspecto | Unity | GNOME | KDE Plasma |
|---|---|---|---|
| **Rendimiento** | Medio | Alto | Alto |
| **RAM en idle** | Media | Media | Media-alta |
| **Curva aprendizaje** | Baja | Baja | Baja |
| **Personalización** | Media | Media | Muy alta |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Launcher + global menu muy eficientes en pantallas grandes | No es el focus de Canonical (soporte intermitente) |
| Regresa tras años, usa base GNOME estable | Muy ligado a Ubuntu/GNOME |
| Familiar para ex-usuarios de Unity | Menos ecosistema propio que en 2015 |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| No aparece el launcher | Sesión X11/GNOME mal config | Elegir sesión "Unity" explícitamente |
| Global menu no en todas las apps | Apps GTK/Flatpak no integradas | Instalar extensión `app-menu`/proxy |
| Regresa a GNOME al reiniciar | Sesión por defecto | Cambiar sesión en LightDM |

## Notas personales
- Es básicamente "GNOME disfrazado de Unity" en la versión nueva (unity-shell).
- La versión clásica (Unity8, Mir) sigue viva en la comunidad con más fidelidad.

## Enlaces externos
- [Página del regreso en Ubuntu](https://ubuntu.com/blog)
- [Repositorio unity-shell](https://gitlab.com/ubuntu-unity)
- [Wikipedia — Unity (user interface)](https://en.wikipedia.org/wiki/Unity_(user_interface))
- [Arch Wiki — Unity](https://wiki.archlinux.org/title/Unity)

## Ver también
- [[GNOME]] — base de escritorio sobre la que corre
- [[KDE Plasma]] — alternativa de escritorio completa
- [[Wayland vs X11]] — servidor gráfico subyacente

#DE-WM