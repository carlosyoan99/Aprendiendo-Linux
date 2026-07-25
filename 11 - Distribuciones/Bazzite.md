---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: distribucion
prioridad: alta
gestor_paquetes: rpm-ostree + Flatpak
base: Fedora Silverblue / Kinoite (Fedora Atomic Desktops)
---

# Bazzite

## Qué es

**Bazzite** es una distribución Linux **inmutable** basada en **Fedora Atomic Desktops** (antes Fedora Silverblue/Kinoite), diseñada específicamente para **gaming en PC**. Es mantenida por el equipo de **Universal Blue** y se ha convertido en la alternativa más popular a SteamOS para cualquier PC, con la ventaja clave de **soporte nativo para NVIDIA**.

A diferencia de [[SteamOS]] (limitado a Steam Deck y AMD), Bazzite funciona en cualquier hardware: AMD, Intel y **NVIDIA**. Ofrece una experiencia dual-mode similar a SteamOS (Modo Gaming con Gamescope + Modo Escritorio) pero sobre una base Fedora estable e inmutable.

| Imagen | Base | Escritorio | Ideal para |
|---|---|---|---|
| **bazzite** | Fedora Silverblue | KDE Plasma | PCs gaming con GPU NVIDIA/AMD |
| **bazzite-deck** | Fedora Silverblue | KDE Plasma | Steam Deck / consolas portátiles |
| **bazzite-gnome** | Fedora Silverblue | GNOME | PCs gaming con GPU NVIDIA/AMD |
| **bazzite-nvidia** | Fedora Silverblue | KDE Plasma | PCs con GPU NVIDIA (drivers incluidos) |
| **bazzite-nvidia-deck** | Fedora Silverblue | KDE Plasma | Portátiles con NVIDIA (ROG Ally, etc.) |

## Filosofía

- **Gaming out of the box**: instala y juega — todo preconfigurado (Proton, Gamescope, MangoHUD, drivers)
- **Inmutable como SteamOS**: sistema de solo lectura, actualizaciones atómicas, rollback
- **Soporte NVIDIA nativo**: los drivers NVIDIA vienen incluidos en las imágenes nvidia (no hay que instalar nada)
- **Dual-mode**: Modo Gaming (Gamescope + Steam Big Picture) y Modo Escritorio (KDE Plasma o GNOME)
- **Basado en Fedora**: estable, actualizaciones cada 6 meses para la base, imágenes personalizadas continuas

## Gestor de paquetes

```bash
# rpm-ostree — sistema inmutable (similar a pacman en SteamOS)
# Los paquetes se superponen (layering) sobre la imagen base
rpm-ostree install paquete             # instalar paquete superpuesto
rpm-ostree update                      # actualizar sistema
rpm-ostree status                      # ver despliegues activos
rpm-ostree rollback                    # revertir a versión anterior

# Flatpak — método recomendado para apps de escritorio
flatpak install flathub com.valvesoftware.Steam
flatpak install flathub net.lutris.Lutris
flatpak install flathub com.heroicgameslauncher.hgl
flatpak install flathub org.mozilla.firefox

# ujust — comandos personalizados de Bazzite (post-instalación, tweaks)
ujust --help                           # lista de comandos disponibles
ujust bios                              # abrir configuración BIOS/UEFI desde Linux
ujust setup-nvidia                      # configurar drivers NVIDIA
ujust setup-deck                        # configurar Steam Deck
ujust enroll-secure-boot                # inscribir Secure Boot para módulos del kernel
ujust install-steam                     # instalar/actualizar Steam
ujust install-lutris                    # instalar Lutris
ujust install-heroic                    # instalar Heroic Games Launcher
ujust update-flathub                    # asegurar Flathub configurado
```

## Ciclo de lanzamiento

- **Rebase continuo**: Bazzite se actualiza mediante `rpm-ostree rebase` a nuevas versiones de la imagen base (no hay versiones discretas)
- **Actualizaciones atómicas**: se descargan en segundo plano y se aplican al reiniciar
- **Rollback instantáneo**: desde el menú GRUB o con `rpm-ostree rollback`
- **Canales**:
  - **Stable**: imágenes probadas, para uso diario
  - **Testing**: parches recientes antes de pasar a stable

```bash
# Ver despliegues instalados
rpm-ostree status

# Actualizar a la última imagen
rpm-ostree update
systemctl reboot

# Rollback a la versión anterior
rpm-ostree rollback
systemctl reboot
```

## Características clave

### 1. Arquitectura inmutable (Fedora Atomic)

```
┌─────────────────────────────────────────────────┐
│                  Bazzite                          │
├─────────────────────────────────────────────────┤
│ Imagen base: Fedora Silverblue/Kinoite           │
│ (sistema de archivos de solo lectura)            │
├─────────────────────────────────────────────────┤
│ Capas superpuestas (rpm-ostree layering):        │
│ - Steam, Gamescope, drivers NVIDIA              │
│ - Codecs multimedia, firmware                    │
├─────────────────────────────────────────────────┤
│ /home → persistente, escribible                  │
│ /var  → persistente (Flatpaks, contenedores)     │
│ /usr  → solo lectura (inmutable)                 │
├─────────────────────────────────────────────────┤
│ Flatpaks en /var/lib/flatpak                     │
│ Contenedores (toolbox / distrobox)               │
└─────────────────────────────────────────────────┘
```

### 2. Gaming Mode con Gamescope

Bazzite incluye Gamescope preconfigurado para lanzar Steam en modo Gaming:

```bash
# Lanzar Steam en modo Gaming (Gamescope + Steam Big Picture)
gamescope -W 1920 -H 1080 -r 60 -- steam -gamepadui

# Con FSR activado
gamescope -W 1280 -H 720 -w 1920 -h 1080 -F fsr -- fsr-sharpness 5 -- steam -gamepadui
```

### 3. Dual-Mode

| Modo | Descripción | Cómo acceder |
|---|---|---|
| **Modo Gaming** | Steam Big Picture sobre Gamescope. Navegación con mando. | Por defecto en imágenes deck |
| **Modo Escritorio** | KDE Plasma o GNOME completo. Navegador, terminal, Flatpaks. | Cambiar desde Steam → Power → Switch to Desktop |

### 4. Soporte NVIDIA

Bazzite es la única distro gaming que ofrece **soporte NVIDIA nativo y preconfigurado**:

```bash
# Las imágenes bazzite-nvidia incluyen:
# - nvidia-open-dkms (módulo open source) o nvidia-dkms (propietario)
# - CUDA
# - VA-API con nvidia-vaapi-driver (aceleración video)
# - nvidia-settings
# - nvidia-drm.modeset=1 configurado automáticamente

# Verificar drivers activos
nvidia-smi
glxinfo | grep "OpenGL renderer"
```

### 5. MangoHUD + Gamescope integrados

Bazzite incluye **MangoHUD** y **Gamescope** preconfigurados. Se puede alternar el overlay de rendimiento con `Super + T` durante el juego.

### 6. Toolbox / Distrobox

Bazzite incluye **toolbox** (y opcionalmente distrobox) para ejecutar contenedores con otras distribuciones:

```bash
# Crear contenedor Ubuntu (acceso a apt para paquetes no disponibles)
toolbox create ubuntu
toolbox enter ubuntu
sudo apt install paquete-faltante

# Sin afectar el sistema inmutable
```

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64 (Intel 4ª gen+ / AMD Ryzen) | Intel 12ª gen+ / AMD Ryzen 5000+ |
| **RAM** | 4 GB | 16 GB |
| **GPU** | Vulkan 1.3 (AMD/Intel/NVIDIA) | AMD RDNA 2+ / NVIDIA RTX 2000+ |
| **Almacenamiento** | 64 GB | 512 GB+ SSD NVMe |
| **Arranque** | UEFI | UEFI con Secure Boot (opcional) |

## Instalación

```bash
# 1. Descargar ISO desde https://bazzite.gg/
#    Elegir la imagen según hardware:
#    - bazzite.iso → AMD/Intel con KDE
#    - bazzite-nvidia.iso → NVIDIA con KDE
#    - bazzite-gnome.iso → AMD/Intel con GNOME
#    - bazzite-deck.iso → Steam Deck / consolas portátiles

# 2. Grabar en USB
sudo dd if=bazzite.iso of=/dev/sdX bs=4M status=progress

# 3. Arrancar e instalar (usando Anaconda, el instalador de Fedora)
#    - Elegir idioma, teclado, disco
#    - Crear usuario (se usa sudo, no root directamente)
#    - Configurar red

# 4. Post-instalación
ujust update-flathub          # asegurar Flathub
ujust install-steam            # instalar Steam
ujust install-lutris           # instalar Lutris
ujust install-heroic           # instalar Heroic
ujust enroll-secure-boot       # si se necesita Secure Boot
ujust setup-nvidia             # si se usa GPU NVIDIA
```

## Post-instalación checklist

```bash
# 1. Actualizar sistema
rpm-ostree update
systemctl reboot

# 2. Configurar Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 3. Instalar apps esenciales
flatpak install flathub org.mozilla.firefox
flatpak install flathub net.lutris.Lutris
flatpak install flathub com.heroicgameslauncher.hgl
flatpak install flathub com.usebottles.bottles
flatpak install flathub org.videolan.VLC

# 4. Verificar drivers gráficos
glxinfo | grep "OpenGL renderer"
vulkaninfo --summary | grep "GPU"

# 5. Verificar Gamescope
gamescope --version

# 6. Configurar Proton GE (opcional)
# Descargar de: https://github.com/GloriousEggroll/proton-ge-custom
# Extraer a: ~/.steam/root/compatibilitytools.d/
```

## Diagnóstico básico

```bash
# Verificar versión de Bazzite
cat /etc/os-release | grep -E "^VERSION|^PRETTY"

# Ver despliegues rpm-ostree
rpm-ostree status

# Ver espacio en particiones
df -h / /home /var

# Logs del sistema
journalctl -p 3 -xb
journalctl -u steam*

# Verificar soporte Vulkan
vulkaninfo --summary | grep "GPU\|Vulkan"

# Ver drivers NVIDIA (si aplica)
nvidia-smi
```

## Bazzite vs alternativas

| Aspecto | Bazzite | SteamOS | ChimeraOS | Nobara | Windows 11 |
|---|---|---|---|---|---|
| **Base** | Fedora (inmutable) | Arch (inmutable) | Arch | Fedora | NT |
| **ISO para PC** | ✅ | ❌ (solo Deck) | ✅ | ✅ | ✅ |
| **Soporte NVIDIA** | ✅ Nativo | ❌ | ❌ | ✅ | ✅ |
| **Inmutable** | ✅ rpm-ostree | ✅ | ✅ | ❌ | ❌ |
| **Gamescope** | ✅ | ✅ | ✅ | ⚠️ Manual | ❌ |
| **Proton incluido** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **MangoHUD** | ✅ Preinstalado | ✅ | ❌ | ⚠️ Manual | ❌ |
| **Toolbox** | ✅ Contenedores | ❌ | ❌ | ❌ | ❌ |
| **Escritorios** | KDE, GNOME | KDE | Solo gaming | KDE, GNOME | Propio |
| **Actualizaciones** | Atómicas (rebase) | Atómicas | Rolling | Rolling tradicional | Versiones |
| **Ideal para** | PC gaming, Steam Deck, NVIDIA | Steam Deck | HTPC/Living room | PC gaming AMD | Gaming general |

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| **Secure Boot bloquea NVIDIA** | Módulos del kernel no firmados | `ujust enroll-secure-boot` para inscribir clave |
| **rpm-ostree layering conflictos** | Demás paquetes superpuestos | `rpm-ostree uninstall paquete` o hacer rollback |
| **Flatpak no encuentra apps** | Flathub no agregado | `flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo` |
| **Pantalla negra al arrancar (NVIDIA)** | nvidia-drm.modeset no cargado | `ujust setup-nvidia` o verificar en GRUB |
| **Steam en modo gaming no arranca** | Gamescope sin permisos Vulkan | Verificar `vulkaninfo --summary` |
| **Actualización ocupa mucho espacio** | rpm-ostree mantiene despliegues viejos | `rpm-ostree cleanup --repomd` para limpiar |

## Ver también

- [[SteamOS]] — la distro gaming original de Valve
- ChimeraOS — distro gaming minimalista para living room (ver sección en Distros adicionales)
- Nobara — distro gaming basada en Fedora (no inmutable)
- [[Videojuegos en Linux]] — gaming en Linux en general
- [[Gamescope]] — compositor micro-gráfico de Valve
- [[Wine]] — capa de compatibilidad base de Proton
- [[Snap y Flatpak]] — Flatpak como gestor de apps
- [[KDE Plasma]] — escritorio en modo Desktop
- [[Fedora]] — base de Bazzite
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]]

## Enlaces externos

- [Bazzite — Página oficial](https://bazzite.gg/)
- [Bazzite — Documentación](https://docs.bazzite.gg/)
- [Bazzite — GitHub](https://github.com/ublue-os/bazzite)
- [Universal Blue — Proyecto base](https://universal-blue.org/)
- [Fedora Atomic Desktops](https://fedoraproject.org/atomic-desktops/)
- [rpm-ostree — Documentación](https://coreos.github.io/rpm-ostree/)
- [ProtonDB — Base de datos de compatibilidad](https://www.protondb.com/)

#distro #gaming
