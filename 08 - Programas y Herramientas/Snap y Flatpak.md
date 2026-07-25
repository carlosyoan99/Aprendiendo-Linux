---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: programa
prioridad: alta
---

# Snap y Flatpak

## Qué son

**Snap** y **Flatpak** son sistemas de paquetes **universales** para Linux. A diferencia de los gestores tradicionales (apt, pacman, dnf) que están atados a una distribución específica, los paquetes universales funcionan igual en cualquier distro. Esto permite a los desarrolladores distribuir su software directamente a los usuarios sin tener que empaquetar para cada distro por separado.

```bash
┌──────────────────────────────────────────────────────────┐
│              Formatos de paquetes en Linux                 │
├───────────────┬───────────────┬───────────────┬───────────┤
│   Tradicional  │   Universal   │   Universal   │ Universal │
│   .deb / .rpm  │   Snap        │   Flatpak     │ AppImage  │
├───────────────┼───────────────┼───────────────┼───────────┤
│   apt, dpkg   │   snapd       │   flatpak     │ Solo      │
│   dnf, pacman │               │               │ ejecutar  │
└───────────────┴───────────────┴───────────────┴───────────┘
```

---

## Flatpak

### Historia

Desarrollado por **Alexander Larsson** (Red Hat) como parte de freedesktop.org. Originalmente llamado **xdg-app** (hasta mayo 2016), Flatpak se basa en tecnologías de contenedores: **cgroups**, **namespaces**, **bubblewrap**, **seccomp** y **OSTree**. Está diseñado para aplicaciones de escritorio (no servidores) y usa **Flathub** como repositorio principal.

A diferencia de Snap (creado por Canonical/Ubuntu), Flatpak es **independiente de cualquier empresa** y está gobernado por la comunidad de freedesktop.org.

### Ventajas clave

- **Sandboxing**: cada app corre aislada con permisos controlados por el usuario
- **Independiente de la distro**: funciona en cualquier Linux con Flatpak instalado
- **Actualizaciones atómicas**: se actualiza completo o no se actualiza
- **Runtimes compartidos**: las apps comparten runtimes (GNOME, KDE, Freedesktop) ahorrando espacio
- **Sin sudo**: las apps se instalan por usuario (`--user`) o para todos (`--system`)

### Instalación

```bash
# Debian/Ubuntu
sudo apt install flatpak

# Arch
sudo pacman -S flatpak

# Fedora (ya viene instalado por defecto)
sudo dnf install flatpak

# Añadir repositorio Flathub (imprescindible)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### Comandos esenciales

```bash
# Buscar e instalar
flatpak search spotify                    # buscar en Flathub
flatpak install flathub com.spotify.Client # instalar app
flatpak run com.spotify.Client            # ejecutar

# Gestión
flatpak list                              # apps instaladas
flatpak list --app                        # solo apps (sin runtimes)
flatpak update                            # actualizar todo
flatpak update com.spotify.Client         # actualizar app específica
flatpak info com.spotify.Client           # detalles de la app

# Permisos
flatpak info -m com.spotify.Client        # metadatos (permisos)
flatpak override --user com.spotify.Client --socket=wayland  # override de permisos

# Eliminar
flatpak uninstall com.spotify.Client      # desinstalar app
flatpak uninstall --unused                # limpiar runtimes no usados
flatpak repair                            # reparar instalación
```

### Distribuciones que incluyen Flatpak por defecto

Fedora Workstation, Fedora Silverblue, Linux Mint, Pop!_OS, elementary OS, Endless OS, Zorin OS, SteamOS, Ubuntu MATE, PureOS, Clear Linux, CentOS.

### Permisos (sandboxing)

Las apps Flatpak pueden solicitar permisos específicos:

| Permiso | Acceso |
|---|---|
| `--socket=x11` | Pantalla X11 |
| `--socket=wayland` | Pantalla Wayland |
| `--socket=pulseaudio` | Audio |
| `--share=network` | Red |
| `--filesystem=home` | Archivos del usuario |
| `--device=all` | Dispositivos (webcam, USB) |

```bash
# Ver y modificar permisos de una app
flatpak info -m org.gimp.GIMP            # permisos actuales
flatpak override --user org.gimp.GIMP --filesystem=~/Fotos:ro  # acceso solo lectura a Fotos
```

---

## Snap

### Historia

Creado por **Canonical** (la empresa detrás de Ubuntu). Originalmente diseñado para Ubuntu Phone (2014), luego expandido a desktop, servidores e IoT. Los paquetes se llaman **snaps**, el demonio es **snapd**, y el formato usa **squashfs** (sistema de archivos comprimido).

El repositorio principal es la **Snap Store**, gestionada por Canonical.

### Ventajas clave

- **Actualizaciones automáticas**: los snaps se actualizan automáticamente cada día (configurable)
- **Transaccional**: las actualizaciones son atómicas (se revierten si fallan)
- **Canales**: puedes elegir entre stable, candidate, beta, edge
- **Confinamiento estricto**: por defecto las apps no ven el sistema (solo lo que se les permite)
- **Integración con Ubuntu**: viene instalado por defecto en Ubuntu 16.04+

### Críticas

- **Centralizado**: la Snap Store es propiedad de Canonical (no es abierta)
- **Actualizaciones forzadas**: las apps se actualizan automáticamente sin preguntar
- **Mayor tiempo de arranque**: los snaps tardan más en iniciar que las apps tradicionales
- **Mayor uso de disco**: cada snap incluye sus dependencias (aunque comparten librerías)
- **Polémica en la comunidad**: Linux Mint deshabilitó Snap por defecto; Arch Linux eliminó snapd de los repos oficiales

### Instalación

```bash
# Ubuntu (ya viene instalado)
sudo apt install snapd                    # si no está

# Debian
sudo apt install snapd

# Arch (desde AUR, no repos oficiales)
yay -S snapd
sudo systemctl enable --now snapd.socket

# Fedora
sudo dnf install snapd
sudo systemctl enable --now snapd.socket
# Tras instalar, cerrar sesión y volver a entrar
```

### Comandos esenciales

```bash
# Buscar e instalar
snap find "video editor"                  # buscar
snap install spotify                      # instalar
snap install --edge vlc                   # instalar desde canal edge

# Gestión
snap list                                 # snaps instalados
snap refresh                              # actualizar todos
snap refresh spotify                      # actualizar uno
snap info spotify                         # detalles (canales, versiones)

# Canales
snap switch --channel=beta spotify        # cambiar a canal beta
snap revert spotify                       # revertir a versión anterior

# Conexiones (permisos)
snap connections spotify                  # ver permisos conectados
snap connect spotify:audio-record         # conectar permiso de micrófono

# Eliminar
snap remove spotify                       # desinstalar

# Snapshots (backups de snaps)
snap saved                                # listar snapshots
snap save                                 # crear snapshot de todos los snaps
snap restore 1                            # restaurar snapshot #1
```

### Snaps instalados por defecto en Ubuntu

```bash
# Ubuntu 24.04+ incluye varios snaps preinstalados:
snap list
# core20, core22, core24    → runtimes base
# gnome-42-2204             → runtime GNOME
# firefox                   → navegador (Snap en Ubuntu)
# snap-store                → tienda de snaps
# firmware-updater          → actualizador de firmware
```

---

## Snap vs Flatpak vs AppImage

| Aspecto | Snap | Flatpak | AppImage |
|---|---|---|---|
| **Creador** | Canonical (Ubuntu) | freedesktop.org (Red Hat) | Simon Peter (comunidad) |
| **Repositorio** | Snap Store (Canonical) | Flathub (comunidad) | Ninguno (descarga directa) |
| **Sandboxing** | ✅ Estricto | ✅ Estricto | ❌ Igual que el usuario |
| **Actualizaciones** | Automáticas (forzadas) | Por comando `flatpak update` | Manual (descarga) |
| **Integración desktop** | Buena (tarda en abrir) | Excelente | Buena |
| **Permisos** | Snap connections | `flatpak override` | Ninguno |
| **Canales** | stable/beta/edge | Stable/beta | No |
| **Rollback** | ✅ `snap revert` | ✅ `flatpak update --commit` | No |
| **Tamaño base** | ~200 MB (core) | ~150 MB (runtime) | Variable |
| **Tiempo arranque** | Lento (1-5s) | Rápido (<1s) | Rápido |
| **Instalación sin root** | ❌ (snapd requiere root) | ✅ (`--user`) | ✅ (solo binario) |
| **Popular en** | Ubuntu, IoT | Fedora, Linux Mint, SteamOS | Distribución directa |
| **Código abierto** | Parcial (store propietaria) | ✅ Completo | ✅ Completo |

### ¿Cuál usar?

| Si buscas... | Recomendación |
|---|---|
| Compatibilidad máxima con Ubuntu | **Snap** (viene por defecto) |
| Independencia de empresas | **Flatpak** (comunidad, open source) |
| Una app sin instalar nada | **AppImage** (descargar y ejecutar) |
| Aislamiento de seguridad | **Flatpak** (sandboxing granular) |
| Actualizaciones automáticas | **Snap** (forzadas) o **Flatpak** (manual) |
| Distribuir mi app | **Flatpak** (Flathub) + **AppImage** (directa) |

---

## AppImage (formato complementario)

**AppImage** es un formato de paquete portable: un solo archivo ejecutable que contiene todo lo necesario. No requiere instalación, demonios ni permisos de root. Ideal para probar software sin compromiso.

```bash
# Descargar y ejecutar
wget https://github.com/Probablemente/App/releases/download/v1.0/app.AppImage
chmod +x app.AppImage
./app.AppImage

# Integrar al sistema (opcional)
./app.AppImage --install                # añade al menú de aplicaciones
```

---

## Buenas prácticas

1. **No mezcles Snap y Flatpak para lo mismo**: elige uno como principal y usa el otro solo si es necesario.
2. **Instala apps del sistema con tu gestor nativo** (apt, pacman). Usa Flatpak/Snap para apps que no están en los repos o están desactualizadas.
3. **Flatpak `--user`**: instala como usuario (sin root) para juegos y apps personales.
4. **Snap desde AUR**: en Arch Linux, snapd está solo en AUR, no en repos oficiales.
5. **AppImage**: perfecto para probar apps sin compromiso, pero no obtienes actualizaciones automáticas (puedes usar AppImageUpdate).

## Enlaces externos

- [Flatpak.org](https://flatpak.org/) — sitio oficial
- [Flathub](https://flathub.org/) — repositorio de apps Flatpak
- [Snapcraft.io](https://snapcraft.io/) — sitio oficial de Snap
- [Snap Store](https://snapcraft.io/store) — buscador de snaps
- [AppImage](https://appimage.org/) — formato portable

## Ver también

- [[Gestores de Paquetes]] — visión general de apt, pacman, dnf
- [[Contenedores]] — conceptos de sandboxing y aislamiento
- [[Videojuegos en Linux]] — Flatpak para juegos (Steam, Heroic, Lutris)
- [[Multimedia (GStreamer HandBrake VLC MPV)]] — apps multimedia vía Flatpak

#programa #paquetes
