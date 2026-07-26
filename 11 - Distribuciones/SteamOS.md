---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: alta
gestor_paquetes: pacman + Flatpak (principal)
base: Arch Linux (SteamOS 3.x)
---

# SteamOS

## Qué es

**SteamOS** es una distribución Linux creada por **Valve Corporation** diseñada específicamente para llevar la experiencia de Steam a la sala de estar y, posteriormente, a la consola portátil **Steam Deck**. Su lema: una experiencia de consola con la flexibilidad de un PC abierto.

| Versión | Base | Lanzamiento | Estado |
|---|---|---|---|
| **1.0** (beta) | Debian 7 | Diciembre 2013 | Descontinuada |
| **2.0** | Debian 8 + Steam Big Picture | Noviembre 2015 | Descontinuada |
| **3.0** (o 3.x) | **Arch Linux** + KDE Plasma 5/6 | Febrero 2022 | **Activa** (Steam Deck) |

La versión 3.x supuso un cambio radical: Valve abandonó Debian por Arch Linux para obtener un **rolling release** con drivers gráficos, kernel y componentes actualizados constantemente — algo crítico para el gaming.

## Filosofía y público objetivo

- **Consola abierta**: el usuario es libre de hacer lo que quiera con el sistema — instalar otro SO, modificar el escritorio, cambiar componentes. Sin bloqueos tipo iOS/consolas cerradas.
- **Gaming first**: todo está optimizado para jugar. El modo por defecto es Steam Big Picture con Gamescope; el escritorio KDE es secundario.
- **Inmutable**: el sistema raíz (`/`) es de solo lectura. Esto garantiza que el sistema nunca se corrompa y las actualizaciones sean atómicas. Las aplicaciones se instalan como Flatpaks.
- **Rolling release**: actualizaciones continuas de kernel, drivers Mesa, Proton y componentes del sistema sin necesidad de reinstalar.
- Público objetivo: jugadores que quieren una consola portátil (Steam Deck) o un HTPC de juegos en el salón.

## Gestor de paquetes

```bash
# pacman — presente pero NO RECOMENDADO para uso diario
# (los cambios en / se pierden tras cada actualización del sistema)
sudo steamos-readonly disable    # deshabilitar modo inmutable
sudo pacman -S paquete           # instalar (se perderá al actualizar)
sudo steamos-readonly enable     # re-habilitar modo inmutable

# Flatpak — método recomendado para apps de escritorio
flatpak install flathub com.valvesoftware.Steam   # Steam
flatpak install flathub org.mozilla.firefox        # Firefox
flatpak install flathub net.lutris.Lutris          # Lutris
flatpak install flathub com.heroicgameslauncher.hgl # Heroic
flatpak list                                       # listar instalados
flatpak update                                     # actualizar todo

# Steam Deck también tiene Discover (KDE) como frontend gráfico
```

## Ciclo de lanzamiento

- **Rolling release**: SteamOS 3.x recibe actualizaciones continuas sin versiones numeradas mayores.
- **Canales**:
  - **Stable**: actualizaciones probadas, para la mayoría de usuarios
  - **Beta**: parches más recientes, posiblemente inestables
  - **Preview** (Steam Deck): lo último antes de beta
- Valve publica imágenes de recuperación periódicas (~cada 1-2 meses) que actualizan todo el sistema base.
- Las actualizaciones son **atómicas**: se descargan a una partición pasiva y se aplican al reiniciar. Si algo falla, se puede hacer rollback desde el menú de arranque.

```bash
# Ver canal actual
steamos-update --status

# Cambiar canal
steamos-update --channel=stable

# Forzar actualización
steamos-update --check

# Rollback a la versión anterior (desde el menú de arranque)
# o desde terminal:
steamos-update --rollback
```

## Características clave

### 1. Arquitectura inmutable

```
┌─────────────────────────────────────────────────┐
│                  SteamOS 3.x                     │
├─────────────────────────────────────────────────┤
│ Partición activa (root-a)  ← sistema en uso     │
│ Partición pasiva (root-b)  ← próxima actualización │
│ /home        → persistente, escribible          │
│ /var         → partición separada                │
├─────────────────────────────────────────────────┤
│ Flatpaks en /var/lib/flatpak (persisten)         │
│ ~/.local/share/Steam (juegos y Proton)           │
└─────────────────────────────────────────────────┘
```

El sistema usa dos particiones raíz: mientras una está activa, la otra recibe la siguiente actualización. Al reiniciar, se intercambian. Esto permite **rollback instantáneo** desde el bootloader.

### 2. Gamescope

**Gamescope** es el compositor micro-gráfico de Valve, escrito específicamente para juegos:

- Arranca como compositor Wayland solo para la sesión de juego
- Escalado por entero (integer scaling) para juegos con resolución baja
- Limitación de FPS por juego
- Control de TDP (potencia) en Steam Deck
- FSR (FidelityFX Super Resolution) integrado
- HDR (en Steam Deck OLED)
- Latencia mínima (sin compositor de escritorio de por medio)

```bash
# Lanzar un juego con Gamescope (desde terminal en modo escritorio)
gamescope -- steam -gamepadui

# Con parámetros
gamescope -W 1920 -H 1080 -r 60 --fsr-sharpness 5 -- steam -gamepadui
```

### 3. Proton integrado

SteamOS incluye Proton por defecto. No requiere configuración: los juegos de Windows se ejecutan automáticamente con la mejor versión de Proton disponible.

```bash
# Versiones de Proton disponibles en SteamOS:
# Proton Experimental → lo último (recomendado)
# Proton 9.0 → versión estable
# Proton Hotfix → parches urgentes
# Proton GE → se puede instalar manualmente
```

### 4. Dual-Mode

| Modo | Descripción | Acceso |
|---|---|---|
| **Modo Gaming** | Interfaz Steam Big Picture, navegación con mando/pantalla táctil, Gamescope como compositor. Ideal para jugar. | Por defecto al encender |
| **Modo Escritorio** | KDE Plasma completo. Navegador web, terminal, gestor de archivos, Flatpaks. | Steam → Power → Switch to Desktop |

## Requisitos del sistema

### Steam Deck (hardware oficial)

| Componente | Steam Deck LCD | Steam Deck OLED |
|---|---|---|
| **APU** | AMD custom Zen 2 + RDNA 2 | AMD custom Zen 2 + RDNA 2 |
| **CPU** | 4C/8T, 2.4-3.5 GHz | 4C/8T, 2.4-3.5 GHz (6nm) |
| **GPU** | 8 CU RDNA 2, 1.6 GHz | 8 CU RDNA 2, 1.6 GHz |
| **RAM** | 16 GB LPDDR5 | 16 GB LPDDR5 |
| **Almacenamiento** | 64GB eMMC / 256GB NVMe / 512GB NVMe | 512GB / 1TB NVMe |
| **Pantalla** | 7" 1280×800 60Hz LCD | 7.4" 1280×800 90Hz OLED HDR |
| **Batería** | 40 Wh | 50 Wh |
| **Peso** | ~669 g | ~640 g |

### Para PC (vía forks comunitarios)

No hay requisitos oficiales porque Valve no distribuye SteamOS 3.x para PC. Los forks tienen requisitos variables:

- **Procesador**: x86_64 con soporte AVX2 (cualquier Intel 4ª gen+ / AMD Ryzen)
- **Gráficos**: GPU con soporte Vulkan 1.3 (AMD/Intel recomendado, NVIDIA limitado)
- **RAM**: 4 GB mínimo, 8 GB recomendado
- **Almacenamiento**: 64 GB mínimo
- **Arranque UEFI** (sin BIOS heredado)

## Notas de instalación

### Steam Deck (oficial)

La Steam Deck viene con SteamOS preinstalado. Para reinstalar o recuperar:

```bash
# 1. Descargar imagen de recuperación:
#    https://store.steampowered.com/steamos/
# 2. Grabar en USB con:
#    sudo dd if=steamos-recovery.img of=/dev/sdX bs=4M status=progress
# 3. Arrancar desde el USB en la Steam Deck:
#    - Apagar → Volumen abajo + Power → Boot Manager → USB
# 4. Opciones: Reinstalar SteamOS, Reimagen completa, Reinstalar desde dock
```

### Forks comunitarios (para PC)

Valve no publica ISO de SteamOS 3.x para PC, pero existen alternativas:

| Proyecto | Base | Características | Web |
|---|---|---|---|
| **Bazzite** | Fedora Silverblue (inmutable) | Soporte NVIDIA, optimizaciones gaming, Steam Deck-like, HDR, GSync | [bazzite.gg](https://bazzite.gg/) |
| **ChimeraOS** | Arch | Minimalista, solo modo gaming, ideal para HTPC/living room | [chimeraos.org](https://chimeraos.org/) |
| **HolOISO** | SteamOS (parches) | Directo de las ISOs de recuperación de Valve, soporte PC genérico | [holoiso.site](https://holoiso.site/) |
| **SteamFork** | Debian | Fork ligero para hardware antiguo | [steamfork.org](https://steamfork.org/) |

```bash
# Instalación de Bazzite (recomendado para PC):
# 1. Descargar ISO desde https://bazzite.gg/
# 2. Grabar con:
sudo dd if=bazzite.iso of=/dev/sdX bs=4M status=progress
# 3. Arrancar e instalar (usando Anaconda, instalador de Fedora)
# 4. Bazzite ya incluye Steam, Proton, Gamescope, y drivers NVIDIA
```

## Post-instalación checklist

```bash
# 1. Configurar Flatpak (ya viene con Flathub)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 2. Instalar apps esenciales
flatpak install flathub org.mozilla.firefox
flatpak install flathub net.lutris.Lutris
flatpak install flathub com.heroicgameslauncher.hgl
flatpak install flathub org.kde.krita
flatpak install flathub org.videolan.VLC

# 3. Desbloquear root (solo si es necesario — los cambios se pierden al actualizar)
sudo steamos-readonly disable
sudo pacman -S base-devel git
sudo steamos-readonly enable

# 4. Configurar SSH (útil para administración remota)
sudo systemctl enable --now sshd

# 5. Configurar Proton GE (opcional, para mejor compatibilidad)
# Descargar de: https://github.com/GloriousEggroll/proton-ge-custom
# Extraer a: ~/.steam/root/compatibilitytools.d/
```

## Diagnóstico básico

```bash
# Verificar versión de SteamOS
cat /etc/os-release | grep -E "^VERSION|^PRETTY"

# Verificar modo inmutable
steamos-readonly status

# Verificar espacio disponible en particiones
df -h / /home /var

# Logs del sistema
journalctl -p 3 -xb     # errores del arranque actual
journalctl -u steam*    # logs de Steam
journalctl -f           # seguir logs en tiempo real

# Verificar soporte Vulkan
vulkaninfo --summary | grep "GPU\|Vulkan"

# Forzar verificación de actualizaciones
steamos-update --check

# Forzar actualización de Steam
steam --reset
```

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| `/` se llena fácilmente | Logs del sistema sin rotar | `sudo journalctl --vacuum-size=500M` |
| Flatpak no encuentra apps | Flathub no agregado | `flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo` |
| Juego no arranca con Proton | Problema de compatibilidad | Probar Proton GE, verificar en ProtonDB |
| No hay sonido en dock | Cableado HDMI/DisplayPort | `sudo alsactl init`, reiniciar PulseAudio/PipeWire |
| Steam no se abre en modo escritorio | Problema con display server | `killall steam; steam` desde terminal |

## SteamOS vs alternativas

| Aspecto | SteamOS | Bazzite | ChimeraOS | Nobara | Windows 11 |
|---|---|---|---|---|---|
| **Base** | Arch (rolling) | Fedora (inmutable) | Arch | Fedora | NT |
| **Inmutable** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Proton** | ✅ integrado | ✅ integrado | ✅ integrado | ✅ integrado | ❌ (nativo DX) |
| **Soporte NVIDIA** | ❌ (solo Deck) | ✅ | ❌ | ✅ | ✅ |
| **ISO para PC** | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Gamescope** | ✅ nativo | ✅ | ✅ | ⚠️ manual | ❌ |
| **Rolling release** | ✅ | ✅ (rebase) | ✅ | ✅ | ❌ (versiones) |
| **Tamaño** | ~5 GB base | ~4 GB ISO | ~2 GB ISO | ~3 GB ISO | ~20 GB+ |

## Ver también

- [[Videojuegos en Linux]] — gaming en Linux en general (Proton, DXVK, emuladores)
- [[Arch Linux]] — base de SteamOS 3.x
- [[Wine]] — capa de compatibilidad base de Proton
- [[Snap y Flatpak]] — Flatpak como gestor de apps en SteamOS
- [[KDE Plasma]] — escritorio en modo Desktop
- [[Wayland vs X11]] — Gamescope usa Wayland
- [[PipeWire]] — audio de baja latencia para juegos
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]]
- [[ChimeraOS]] — distro gaming inmutable para living room
- [[HoloISO]] — fork abandonado de SteamOS para PC (no recomendado)
- [[CachyOS]] — distro Arch optimizada para gaming (alternativa a SteamOS en PC)
- Nobara — distro gaming basada en Fedora

## Enlaces externos

- [SteamOS — Página oficial de Valve](https://store.steampowered.com/steamos/)
- [Steam Deck — Especificaciones técnicas](https://www.steamdeck.com/en/tech)
- [SteamOS — ArchWiki](https://wiki.archlinux.org/title/SteamOS)
- [ProtonDB — Base de datos de compatibilidad](https://www.protondb.com/)
- [Bazzite — Fork para PC gaming](https://bazzite.gg/)
- [ChimeraOS — Distro gaming living room](https://chimeraos.org/)
- [HoloISO — SteamOS para PC genérico](https://holoiso.site/)
- [GloriousEggroll — Proton GE](https://github.com/GloriousEggroll/proton-ge-custom)
- [Gamescope — GitHub](https://github.com/ValveSoftware/gamescope)

#distro #gaming
