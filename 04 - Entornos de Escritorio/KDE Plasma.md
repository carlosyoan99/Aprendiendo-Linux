---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: entorno-escritorio
prioridad: alta
tipo: DE (desktop environment)
---

# KDE Plasma

## Qué es

Entorno de escritorio altamente personalizable, construido sobre Qt. Interfaz visualmente cercana a Windows por defecto (barra de tareas, menú de inicio, bandeja del sistema), pero configurable a fondo hasta parecer irreconocible. Desarrollado por KDE Community.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install kde-plasma-desktop      # versión mínima (recomendado)
sudo apt install kde-full                # TODO el ecosistema KDE

# Fedora
sudo dnf group install "KDE Plasma Workspaces"

# Arch
sudo pacman -S plasma                    # grupo completo
sudo systemctl enable sddm               # gestor de sesión KDE
```

## Configuración inicial

- Casi todo configurable desde **System Settings** con GUI, sin tocar archivos de texto.
- Archivos de config en `~/.config/plasma*`, `~/.config/kde*` (formato `.ini`-like).
- **Temas**: desde System Settings → Appearance. Hay miles en [store.kde.org](https://store.kde.org/).

### KRunner (el lanzador universal)

`Alt + Space` o `Alt + F2` abre KRunner, que sirve para mucho más que lanzar apps:

```bash
# Lo que puedes hacer desde KRunner sin abrir nada más:
# - Escribir "=42+8" → calculadora
# - Escribir "$ euro" → conversión de moneda
# - Escribir "6pm in tokyo" → conversión horaria
# - Escribir "ssh server" → abrir conexión SSH
# - Escribir "chrome" + Enter → abrir Chrome
# - Escribir "apagar" → opciones de apagado/reinicio
# - Escribir "define:palabra" → diccionario
```

### Widgets y paneles

- Los paneles se personalizan con click derecho → "Edit Panel".
- Se pueden añadir widgets al escritorio o al panel: reloj, clima, monitor de sistema, notas post-it, etc.
- `Latte Dock` (si se instala aparte) reemplaza el panel por un dock tipo macOS.

## Herramientas KDE destacadas

| Herramienta | Propósito | Equivalente |
|---|---|---|
| **Dolphin** | Gestor de archivos con split panel (F3) y terminal integrada (F4) | Nautilus |
| **Kwrite / Kate** | Editor de texto / editor con pestañas + IDE ligero | Gedit |
| **Konsole** | Emulador de terminal con perfiles y splits | GNOME Terminal |
| **Spectacle** | Capturas de pantalla con regiones, retardo, anotaciones | GNOME Screenshot |
| **Gwenview** | Visor de imágenes | Eye of GNOME |
| **Discover** | Tienda de apps (Flatpak/Snap/APT/rpm) | GNOME Software |
| **KDE Connect** | Integración con Android (notificaciones, archivos, portapapeles, media control) | GSConnect |

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Alt + Space` | KRunner (búsqueda universal) |
| `Meta` (Super) | Menú de aplicaciones |
| `Alt + Tab` | Cambiar de ventana (con miniatura) |
| `Ctrl + F10` | Menú de ventana actual (cerrar, minimizar, etc.) |
| `Meta + Flechas` | Ajustar ventana a mitades/esquinas |
| `Meta + Shift + Flechas` | Mover ventana a otro escritorio |
| `Ctrl + F1`-[F4] | Ir directamente al escritorio virtual N |
| `Meta + D` | Mostrar escritorio |
| `Print Screen` | Spectacle (captura de pantalla) |
| `Meta + V` | Historial del portapapeles (Klipper) |

## Pros / Contras

- ✅ Personalización extrema sin tocar archivos de texto; miles de ajustes desde GUI.
- ✅ Muy completo out-of-the-box (gestor de archivos potente, visor de imágenes, editor, terminal, etc.).
- ✅ KDE Connect es el mejor sistema de integración con Android en Linux.
- ❌ Más pesado que WMs tiling o XFCE (~1-2 GB RAM en reposo).
- ❌ A veces puede sentirse "sobrecargado" para quien busca minimalismo.
- ❌ Algunas actualizaciones mayores mueven opciones de lugar en System Settings sin aviso.

## Wayland vs X11 en KDE

KDE Plasma 6 (2024+) usa **Wayland por defecto**. En versiones anteriores (Plasma 5), X11 era el predeterminado y Wayland era experimental. Desde Plasma 6, Wayland es estable y recomendado; X11 se mantiene como opción para casos de compatibilidad.

Para cambiar a X11: en SDDM (pantalla de login) → menú de sesión → "Plasma (X11)".

## Notas personales

- KDE Plasma es el DE que instalo a cualquier persona que viene de Windows y no quiere cambiar su flujo de trabajo. El escritorio por defecto es muy familiar.
- La cantidad de opciones de personalización puede abrumar al principio. No intentes configurarlo todo el primer día: usa los valores por defecto y ajusta según necesites.
- KDE Connect es, sin discusión, la mejor integración con Android que existe en cualquier SO de escritorio.
- Plasma 6 con Wayland es ya muy estable (2026). Si antes evitabas KDE por X11, ahora es el momento de probarlo.

## Ver también

- [[GNOME]] — el otro DE grande, más minimalista
- [[XFCE]] — DE ligero, tercera opción popular
- [[Wayland vs X11]]
- [[Gestores de Archivos]]

#entorno-escritorio
