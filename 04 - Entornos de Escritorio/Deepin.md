---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: DE
---

# Deepin

## Qué es

**Deepin** es un entorno de escritorio desarrollado por **Deepin Technology** (China), conocido por su **estética cuidada** y **animaciones fluidas**. Usa el toolkit **DTK** (Deepin Toolkit) basado en Qt y es considerado uno de los escritorios visualmente más pulidos de Linux.

Originalmente basado en GNOME, Deepin creó su propio escritorio desde cero usando Qt. Es el escritorio por defecto de la distribución **Deepin Linux** (también conocida como **Linux Deepin**), basada en Debian.

## Filosofía

- **Estética ante todo**: Deepin compite directamente con macOS y Windows en pulido visual
- **Experiencia unificada**: todas las apps nativas comparten el mismo diseño y comportamiento
- **Animación fluida**: transiciones suaves, desvanecimientos, efectos de desenfoque
- **Integración Android**: soporte para apps Android mediante contenedores (en Deepin Linux)

## Componentes clave

### Deepin Desktop Environment (DDE)

| Componente | Nombre | Función |
|---|---|---|
| **Gestor ventanas** | KWin (modificado) | Compositor con efectos 3D |
| **Panel** | DDE Dock | Dock tipo macOS inferior/izquierdo |
| **Launcher** | DDE Launcher | Lanzador de aplicaciones a pantalla completa |
| **Centro control** | DDE Control Center | Configuración unificada del sistema |
| **Gestor archivos** | DDE File Manager | Gestor de archivos moderno |

### Apps nativas

| App | Propósito |
|---|---|
| **Deepin Music** | Reproductor musical |
| **Deepin Movie** | Reproductor de video |
| **Deepin Terminal** | Terminal con temas y splits |
| **Deepin Screenshot** | Captura de pantalla avanzada (con OCR, anotaciones) |
| **Deepin Voice Recorder** | Grabación de voz |
| **Deepin Calculator** | Calculadora científica |
| **Deepin Calendar** | Calendario |
| **Deepin Store** | Tienda de aplicaciones |

## Instalación

```bash
# Deepin Linux (viene preinstalado)

# Debian/Ubuntu (no oficial en todos los repos)
sudo apt install deepin-desktop

# Arch Linux
sudo pacman -S deepin deepin-extra

# Fedora
sudo dnf group install deepin-desktop

# openSUSE
sudo zypper install -t pattern deepin
```

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `Super` | Launcher (menú de apps a pantalla completa) |
| `Super+D` | Mostrar escritorio |
| `Super+L` | Bloquear pantalla |
| `Super+Tab` | Cambiar entre ventanas |
| `Alt+Tab` | Cambiar entre apps |
| `Alt+F4` | Cerrar ventana |
| `Ctrl+Alt+T` | Terminal (Deepin Terminal) |
| `Print` | Captura de pantalla (Deepin Screenshot) |
| `Super+E` | Gestor de archivos |

## Personalización

```bash
# Deepin Control Center → Personalization
# - Themes: varios temas preinstalados (oscuro, claro)
# - Wallpaper: fondos animados (opcional)
# - Transparencia del dock
# - Tamaño de iconos en el dock
# - Modo eficiencia (clásico con panel inferior)
# - Modo moda (moderno con dock)

# Instalar temas personalizados
# Descargar temas .deb desde https://www.deepin.org/en/
```

## Deepin vs GNOME

| Aspecto | Deepin | GNOME |
|---|---|---|
| **Toolkit** | Qt + DTK | GTK + libadwaita |
| **Gestor ventanas** | KWin modificado | Mutter |
| **Estética** | macOS-like muy pulida | Moderna minimalista |
| **RAM idle** | ~800 MB - 1.2 GB | ~800 MB - 1.2 GB |
| **Wayland** | Soporte básico | ✅ Nativo |
| **Animaciones** | Muy fluidas | Suaves |
| **Apps propias** | Muchas (todo el stack) | Pocas (apps GNOME Core) |
| **Popular en** | Deepin Linux, UbuntuDDE | Ubuntu, Fedora |

## Notas personales

- Deepin tiene el escritorio más bonito de Linux, punto. El dock tipo macOS, el centro de control y las animaciones están a la altura de macOS y Windows 11.
- La pega: es un proyecto chino, y aunque el código es abierto, hay preocupaciones legítimas de privacidad. Úsalo si te importa más la estética que la telemetría.
- Las apps nativas (Deepin Music, Movie, Terminal) son de las mejores apps por defecto de cualquier DE. Coherentes, bonitas y funcionales.
- Deepin en distros no-Chinas (como UbuntuDDE) pierde parte de la integración. La experiencia completa solo se vive en Deepin Linux.

## Ver también

- [[KDE Plasma]] — DE Qt completo y personalizable
- [[GNOME]] — DE moderno alternativo
- [[Pantheon]] — DE con diseño cuidado (elementary OS)
- [[Comparativa entornos de escritorio]] — comparativa de todos los DEs

## Enlaces externos

- [Deepin Desktop — Página oficial](https://www.deepin.org/en/dde/)
- [Deepin Technology](https://www.deepin.org/)
- [Deepin Wiki](https://wiki.deepin.org/)
- [Wikipedia — Deepin](https://en.wikipedia.org/wiki/Deepin)

#entorno-escritorio
