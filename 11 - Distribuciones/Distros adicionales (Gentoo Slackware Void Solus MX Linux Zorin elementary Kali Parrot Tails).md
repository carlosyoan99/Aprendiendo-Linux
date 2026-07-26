---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: baja
---

# Distribuciones adicionales

Además de las distribuciones con nota individual, existen otras distribuciones notables. Esta nota recoge las que no tienen nota dedicada y sirve como índice de las que sí.

## Notas individuales

- [[Gentoo]] — source-based, Portage, máximo control
- [[Kali Linux]] — pentesting, seguridad informática
- [[Void Linux]] — rolling, xbps, runit (sin systemd)
- [[Tails]] — anonimato extremo, live USB, Tor
- [[MX Linux]] — Debian Stable + MX Tools
- [[Zorin OS]] — migración desde Windows
- [[elementary OS]] — diseño cuidado, Pantheon
- [[Slackware]] — la distro activa más antigua, sin systemd
- [[Solus]] — rolling independiente con Budgie
- [[Parrot OS]] — pentesting + privacidad basado en Debian

---

## Slackware

### Qué es

La distribución activa más antigua (1993). Filosofía: simplicidad y fidelidad a Unix. Sin systemd, sin dependencias automáticas complejas, sin asistentes gráficos de configuración.

```bash
# Gestor de paquetes: pkgtools
installpkg paquete.txz                # instalar paquete
removepkg paquete                     # desinstalar
upgradepkg paquete.txz                # actualizar
slackpkg update                       # actualizar lista
slackpkg install-all                  # instalar todo un conjunto
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | pkgtools / slackpkg |
| **Base** | Independiente |
| **Init** | rc (BSD-style, sin systemd) |
| **Instalación** | Sencilla pero manual |
| **Ideal para** | Tradicionalistas, amantes de Unix clásico |

---

## Solus

### Qué es

Distribución **rolling** independiente, diseñada para escritorio. Creada por Ikey Doherty. Usa su propio gestor **eopkg** y escritorio Budgie por defecto. Conocida por su pulido y facilidad de uso.

```bash
# Gestor de paquetes: eopkg
sudo eopkg update-repo                  # actualizar repos
sudo eopkg install firefox              # instalar paquete
sudo eopkg remove firefox               # desinstalar
sudo eopkg upgrade                      # actualizar sistema
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | eopkg (PiSi-based) |
| **Base** | Independiente |
| **Init** | systemd |
| **Rama** | Rolling |
| **Ideal para** | Escritorio moderno sin ser Ubuntu |

---

## Parrot OS

### Qué es

Distribución basada en **Debian Testing**, similar a Kali pero con enfoque en **privacidad, anonimato y seguridad**. Incluye herramientas de pentesting, pero también está diseñada para uso diario con encriptación y anonimato.

```bash
# Basada en Debian, usa apt
sudo apt update
sudo apt install parrot-tools-full      # todas las herramientas

# AnonSurf (túnel a Tor)
sudo anonsurf start                     # iniciar Tor
sudo anonsurf stop                      # detener Tor
sudo anonsurf status                    # verificar estado
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | apt |
| **Base** | Debian Testing |
| **DE por defecto** | MATE (también XFCE) |
| **Ideal para** | Pentesters que también usan el equipo para daily driving |

---

## ChimeraOS

### Qué es

**ChimeraOS** es una distribución Linux inmutable diseñada específicamente para convertir cualquier PC en una **consola de juegos de salón (living room)**. Arranca directamente en Steam Big Picture sobre Gamescope, ofreciendo una experiencia tipo Steam Deck sin necesidad de conocimientos técnicos.

Originalmente llamada **GamerOS**, fue renombrada a ChimeraOS en 2021. **No es un fork de SteamOS**, sino un proyecto independiente que se inspira en la misma filosofía: una consola abierta basada en Linux. Está construida sobre **Arch Linux** como base.

```bash
# ChimeraOS no usa pacman directamente — el sistema es inmutable
# Gestor de actualizaciones: frzr (actualizaciones atómicas)
frzr-update                           # actualizar sistema completo
frzr-rollback                         # revertir a versión anterior
frzr-info                             # información de la imagen actual

# Flatpak — método recomendado para apps adicionales
flatpak install flathub com.valvesoftware.Steam
flatpak install flathub org.mozilla.firefox

# Chimera web app (gestión remota desde el móvil)
# Acceder desde el navegador: http://chimeraos.local
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | frzr (imágenes atómicas) + Flatpak |
| **Base** | Arch Linux |
| **Init** | systemd |
| **Rama** | Rolling (actualizaciones atómicas por imagen) |
| **DE** | Solo Gaming Mode (sin escritorio tradicional) |
| **Gamescope** | Nativo, preconfigurado |
| **Soporte NVIDIA** | Limitado (AMD recomendado) |

### Filosofía y público objetivo

- **Experiencia consola**: el sistema arranca directamente en Steam Big Picture sobre Gamescope. No hay escritorio KDE/GNOME — es solo juegos.
- **Appliance**: diseñado para usuarios que quieren encender el PC, coger el mando y jugar, sin tocar configuraciones.
- **Actualizaciones atómicas**: el sistema usa **frzr**, que descarga imágenes completas y las aplica de forma atómica. Nunca se rompe por una actualización parcial.
- **Rollback instantáneo**: si una actualización falla, se puede revertir desde el menú de arranque.
- **Inmutable**: el sistema raíz es de solo lectura. No se puede instalar paquetes con pacman directamente.
- Público objetivo: jugadores de sofá que quieren una consola Steam en su salón.

### Características clave

#### 1. Arquitectura inmutable (frzr)

```
┌─────────────────────────────────────────────────┐
│                  ChimeraOS                        │
├─────────────────────────────────────────────────┤
│ Imagen base: Arch Linux optimizada               │
│ (sistema de solo lectura, inmutable)             │
├─────────────────────────────────────────────────┤
│ frzr gestiona las actualizaciones por imagen:    │
│ - Descarga imagen completa en segundo plano      │
│ - Aplica al reiniciar (intercambio atómico)      │
│ - Rollback seleccionable en bootloader           │
├─────────────────────────────────────────────────┤
│ /home → persistente, escribible                  │
│ /var  → persistente (Flatpaks, configuraciones)  │
│ /usr  → solo lectura                             │
├─────────────────────────────────────────────────┤
│ Flatpaks en /var/lib/flatpak                     │
└─────────────────────────────────────────────────┘
```

#### 2. Gamescope + Steam Big Picture

ChimeraOS inicia automáticamente Gamescope con Steam Big Picture. No requiere configuración:

```bash
# Lo que ejecuta al arrancar (equivalente):
gamescope -W 1920 -H 1080 -r 60 -- steam -gamepadui

# Con FSR para escalado (rendimiento en GPUs medias):
gamescope -W 1280 -H 720 -w 1920 -h 1080 -F fsr -- steam -gamepadui
```

#### 3. Chimera web app

ChimeraOS incluye una interfaz web accesible desde cualquier navegador en la misma red:

```bash
# http://chimeraos.local/ — desde el móvil, tablet u otro PC
# Permite:
# - Gestionar juegos fuera de Steam (Epic, GOG, emulación)
# - Ver el estado del sistema (temperatura, almacenamiento)
# - Apagar, reiniciar, actualizar
# - Acceder a la terminal remota
```

#### 4. Juegos fuera de Steam

ChimeraOS ofrece una interfaz unificada para juegos de otras plataformas (Epic, GOG, emuladores) a través de la web app, sin necesidad de instalar Lutris o Heroic manualmente.

### Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64 (Intel 4ª gen+ / AMD Ryzen) | AMD Ryzen 3000+ |
| **RAM** | 4 GB | 8 GB |
| **GPU** | Vulkan 1.3 (AMD/Intel) | AMD RDNA 1+ (RADV) |
| **Almacenamiento** | 64 GB | 256 GB+ SSD |
| **Arranque** | UEFI | UEFI |
| **Mando** | Xbox o PlayStation vía USB/BT | Control inalámbrico |

> **Nota sobre NVIDIA**: ChimeraOS tiene soporte limitado para NVIDIA. Se recomienda AMD para la mejor experiencia.

### Instalación

```bash
# 1. Descargar ISO desde https://chimeraos.org/
# 2. Grabar en USB
sudo dd if=chimeraos.iso of=/dev/sdX bs=4M status=progress

# 3. Arrancar desde USB e instalar
#    - El instalador es minimalista (similar a Arch Linux)
#    - Seleccionar disco (se borrará todo el contenido)
#    - Crear usuario (se usa para sudo y SSH)
#    - La instalación tarda ~5-10 minutos

# 4. Post-instalación
#    - Conectar el mando vía USB o Bluetooth
#    - Iniciar sesión en Steam (Big Picture se abre automáticamente)
#    - Configurar red desde la interfaz de Steam
```

### Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| **Pantalla negra al arrancar** | GPU NVIDIA sin drivers | Usar GPU AMD/Intel o probar Bazzite |
| **No detecta el mando** | Bluetooth no configurado | Probar con cable USB primero |
| **WiFi no funciona** | Firmware no incluido | Usar Ethernet o conectar vía móvil |

---

## HoloISO

### Qué es

**HoloISO** fue un proyecto que intentaba llevar **SteamOS 3.x** (nombre en clave "Holo") a PCs genéricos. Parcheaba las imágenes de recuperación oficiales de la Steam Deck para que funcionaran en hardware de PC común, ofreciendo la experiencia exacta de SteamOS fuera del hardware de Valve.

**Estado actual**: el proyecto fue **discontinuado por su creador (TheVaan) en 2023** debido a la insostenibilidad del mantenimiento. Actualmente se considera un proyecto en abandono con soporte muy limitado. **No se recomienda para instalaciones nuevas** — usar [[Bazzite]] o ChimeraOS en su lugar.

```bash
# HoloISO usaba los mismos comandos que SteamOS:
steamos-readonly disable               # deshabilitar modo inmutable
sudo pacman -Syu                       # actualizar sistema
sudo pacman -S paquete                 # instalar paquete
steamos-readonly enable                # re-habilitar modo inmutable

# Flatpak para apps de escritorio
flatpak install flathub org.mozilla.firefox
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | pacman + Flatpak (SteamOS-style) |
| **Base** | SteamOS 3.x (Arch Linux) |
| **Init** | systemd |
| **Rama** | Rolling (actualizaciones de SteamOS) |
| **DE** | KDE Plasma (modo escritorio) + Gamescope (modo gaming) |
| **Gamescope** | Nativo (hereda de SteamOS) |
| **Soporte NVIDIA** | Prácticamente nulo |

### Historia

```
2022 — TheVaan publica HoloISO como parche a las ISOs de recuperación de Steam Deck
     → Primer fork funcional de SteamOS 3.x para PC
     → Soporte para GPUs AMD, Intel, y NVIDIA limitado

2023 — TheVaan anuncia el cese del desarrollo
     → Razón: insostenibilidad de mantener soporte para
       hardware genérico sobre una base diseñada para
       hardware cerrado (Steam Deck)
     → La comunidad intenta forks (HoloISO reborn, etc.)
     → Ninguno logra tracción significativa

2024-2026 — Proyecto en estado de abandono
     → Las ISOs siguen disponibles pero sin actualizaciones
     → Los usuarios migran a Bazzite y ChimeraOS
```

### Por qué fracasó

| Factor | Detalle |
|---|---|
| **Base cerrada** | SteamOS está diseñado para un hardware específico (Steam Deck). Adaptarlo a PC genérico requería parchear componentes críticos. |
| **Drivers NVIDIA** | SteamOS solo soporta AMD. Añadir soporte NVIDIA requería mantener módulos del kernel y configuraciones fuera del ecosistema de Valve. |
| **Actualizaciones** | Valve puede cambiar cualquier componente de SteamOS sin aviso. HoloISO tenía que actualizarse cada vez, a menudo con semanas de retraso. |
| **Equipo pequeño** | Un solo desarrollador manteniendo un fork enorme. |
| **Alternativas mejores** | Bazzite y ChimeraOS ofrecen experiencia similar con mejor soporte. |

### Alternativas recomendadas

| Alternativa | Por qué |
|---|---|
| **[[Bazzite]]** | Experiencia más similar a SteamOS, soporte NVIDIA, activo, gran comunidad. Ideal para PC gaming. |
| **ChimeraOS** | Experiencia consola pura, minimalista, para living room. Ideal para HTPC. |
| **[[SteamOS]]** | Si tienes Steam Deck, es la opción oficial. |

---

## Tabla comparativa

### Distribuciones adicionales generales

| Distro | Base | Gestor | Init | Tipo | Ideal para |
|---|---|---|---|---|---|
| **Slackware** | Independiente | pkgtools | rc (BSD-style) | Binaria clásica | Tradicionalistas Unix |
| **Solus** | Independiente | eopkg | systemd | Rolling | Escritorio pulido |
| **Parrot OS** | Debian Testing | apt | systemd | Rolling | Pentesting + privacidad |
| **ChimeraOS** | Arch Linux | frzr + Flatpak | systemd | Rolling inmutable | Consola living room |
| **HoloISO** | SteamOS (Arch) | pacman + Flatpak | systemd | Rolling inmutable | ⚠️ Abandonado — no usar |

### Forks y alternativas a SteamOS para PC

| Aspecto | SteamOS | Bazzite | ChimeraOS | HoloISO |
|---|---|---|---|---|
| **Base** | Arch Linux | Fedora Silverblue | Arch Linux | SteamOS (Arch) |
| **ISO para PC** | ❌ (solo Deck) | ✅ | ✅ | ✅ (abandonado) |
| **Soporte NVIDIA** | ❌ | ✅ Nativo | ❌ (limitado) | ❌ |
| **Inmutable** | ✅ Dual root-a/root-b | ✅ rpm-ostree | ✅ frzr | ✅ SteamOS-style |
| **Gamescope** | ✅ Nativo | ✅ | ✅ | ✅ Heredado |
| **Modo Gaming** | ✅ Steam Big Picture | ✅ Steam Big Picture | ✅ Steam Big Picture | ✅ Steam Big Picture |
| **Modo Escritorio** | ✅ KDE Plasma | ✅ KDE / GNOME | ❌ Solo gaming | ✅ KDE Plasma |
| **Gestor paquetes** | pacman + Flatpak | rpm-ostree + Flatpak | frzr + Flatpak | pacman + Flatpak |
| **Rollback** | ✅ Bootloader | ✅ rpm-ostree rollback | ✅ frzr-rollback | ✅ Bootloader |
| **MangoHUD** | ✅ Integrado | ✅ Preinstalado | ❌ | ❌ |
| **Chimera web app** | ❌ | ❌ | ✅ Gestión remota | ❌ |
| **Mantenimiento** | ✅ Oficial (Valve) | ✅ Activo (Universal Blue) | ✅ Activo | ❌ Abandonado |
| **Ideal para** | Steam Deck | PC gaming / NVIDIA / Handhelds | Living room / consola | ❌ No recomendado |

## Ver también

- [[Gentoo]]
- [[Kali Linux]]
- [[Void Linux]]
- [[Tails]]
- [[MX Linux]]
- [[Zorin OS]]
- [[elementary OS]]
- [[Ubuntu]] — base de Zorin, elementary
- [[Debian]] — base de MX, Kali, Parrot, Tails
- [[Arch Linux]] — alternativa rolling a Gentoo
- [[Compilación desde Código Fuente]] — relevante para Gentoo
- [[SteamOS]] — la distro gaming original de Valve
- [[Bazzite]] — fork activo de SteamOS para PC con soporte NVIDIA
- [[Videojuegos en Linux]] — gaming en Linux en general
- [[Gamescope]] — compositor micro-gráfico de Valve

## Enlaces externos

- [ChimeraOS — Página oficial](https://chimeraos.org/)
- [ChimeraOS — GitHub](https://github.com/ChimeraOS/chimeraos)
- [HoloISO — GitHub (archivo)](https://github.com/HoloISO/releases)
- [Bazzite — Alternativa activa](https://bazzite.gg/)
- [SteamOS — Valve](https://store.steampowered.com/steamos/)
- [frzr — Sistema de actualizaciones atómicas](https://github.com/ChimeraOS/frzr)

#distro #gaming
