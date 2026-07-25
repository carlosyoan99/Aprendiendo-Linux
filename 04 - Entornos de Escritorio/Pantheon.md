---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: DE
---

# Pantheon

## Qué es

**Pantheon** es el escritorio nativo de **elementary OS**, conocido por su estética **macOS-like** y su integración vertical: todas las apps nativas están diseñadas específicamente para él, siguiendo los **elementary HIG** (Human Interface Guidelines).

Desarrollado por el equipo de **elementary, Inc.**, Pantheon usa **GTK 3** y la toolkit **Granite** (una capa de widgets GTK diseñada por elementary). Su gestor de ventanas es **Gala** (basado en Mutter).

## Filosofía

- **Diseño coherente**: cada app se siente como parte del mismo escritorio
- **Menos es más**: interfaz limpia, sin elementos innecesarios
- **Integración vertical**: el escritorio y las apps se diseñan juntos
- **Pay What You Want**: las apps pueden pagarse voluntariamente en AppCenter

## Componentes clave

### Gala (gestor de ventanas)

Gestor de ventanas basado en Mutter (el mismo que GNOME), con:

- **Multitasking View**: vista de escritorios virtuales con gestos táctiles
- **Hot Corners**: esquinas activas para mostrar vista multitarea
- **Snap to Grid**: organización de ventanas por zonas
- **Animaciones fluidas**: transiciones suaves entre escritorios

### Apps nativas

| App | Propósito |
|---|---|
| **Files** | Gestor de archivos con vista de fotos, integración cloud |
| **Music** (Noise) | Reproductor musical minimalista |
| **Code** (Scratch) | Editor de código ligero |
| **Mail** | Cliente de correo integrado |
| **Calendar** | Calendario con servicios online |
| **Photos** | Visor de imágenes |
| **Camera** | App de cámara web |

## Instalación

```bash
# elementary OS (viene preinstalado)

# En otras distros (no oficial, puede requerir PPA en Ubuntu):
sudo add-apt-repository ppa:elementary-os/stable
sudo apt update
sudo apt install pantheon

# Arch Linux (AUR)
yay -S pantheon
```

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `Super` | Menú de aplicaciones |
| `Super+Tab` | Cambiar entre apps |
| `Super+´` (acento) | Cambiar entre ventanas de la misma app |
| `Super+A` | Multitasking View |
| `Super+L` | Bloquear pantalla |
| `Super+D` | Mostrar escritorio |
| `Alt+F4` | Cerrar ventana |
| `Ctrl+Alt+Delete` | Bloquear sesión |

## Personalización

```bash
# System Settings → Desktop
# - Cambiar wallpaper
# - Ajustar dock (comportamiento, posición)
# - Hot Corners
# - Notificaciones

# Temas: elementary soporta temas GTK + Granite
# Los temas de elementary se instalan desde AppCenter
```

## Pantheon vs GNOME

| Aspecto | Pantheon | GNOME |
|---|---|---|
| **Estética** | macOS-like | Propia (Adwaita) |
| **Dock** | Sí (inferior) | No (solo dash en overview) |
| **Panel superior** | Sí (menú + indicadores) | Sí (barra de actividades) |
| **App Store** | AppCenter (curada, Flatpak) | GNOME Software (Snap/Flatpak) |
| **Toolkit** | GTK + Granite | GTK + libadwaita |
| **Wayland** | Experimental | ✅ Nativo |
| **RAM idle** | ~500-700 MB | ~800 MB - 1.2 GB |

## Notas personales

- Pantheon es el DE con el diseño más coherente de Linux. Sigue sus propias HIG (Human Interface Guidelines) al pie de la letra.
- La integración con elementary OS es total: AppCenter, el sistema de pagos voluntarios, y las apps nativas forman un ecosistema cerrado y pulido.
- Fuera de elementary OS, la instalación es complicada. No lo recomiendo si no vas a usar elementary.
- El dock inferior y el panel superior son una experiencia muy macOS-like, pero con personalidad propia.

## Ver también

- [[elementary OS]] — distro que usa Pantheon por defecto
- [[GNOME]] — base técnica (Mutter, GTK)
- [[Budgie]] — DE moderno alternativo
- [[KDE Plasma]] — DE completo Qt
- [[DEs adicionales (Budgie Deepin Enlightenment LXQt MATE Pantheon Sugar Trinity)]]

## Enlaces externos

- [elementary OS — Página oficial](https://elementary.io/)
- [Pantheon — GitHub](https://github.com/elementary)
- [elementary Developer Docs (HIG)](https://docs.elementary.io/develop/)

#entorno-escritorio
