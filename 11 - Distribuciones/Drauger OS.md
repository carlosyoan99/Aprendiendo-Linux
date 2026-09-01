---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: apt + Flatpak
base: Ubuntu LTS
modelo_lanzamiento: Fixed
init: systemd
arquitecturas:
  - x86_64
---

# Drauger OS

> Distro Linux orientada a gaming, basada en **Ubuntu LTS**. Steam, Proton, Lutris, Wine, MangoHud y Gamemode preinstalados. Kernel optimizado para juegos con KDE Plasma personalizado.

## Filosofía / público objetivo

Drauger OS es una distribución basada en **Ubuntu LTS** diseñada específicamente para gaming en Linux. A diferencia de distros gaming Arch-based (Garuda, CachyOS), Drauger usa Ubuntu como base para ofrecer mayor estabilidad y compatibilidad. Incluye todo el ecosistema de gaming preconfigurado: Steam, Proton, Lutris, Wine, MangoHud y Gamemode.

- **Público**: gamers que quieren estabilidad Ubuntu + gaming out-of-the-box
- **Enfoque**: gaming completo sin configuración manual
- **Base**: Ubuntu LTS (estable, probada)

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Ubuntu LTS (22.04/24.04) |
| **Gestor de paquetes** | apt + Flatpak |
| **Init** | systemd |
| **DE** | KDE Plasma (personalizado) |
| **Orientación** | Gaming |
| **Kernel** | HWE o custom optimizado |

### Incluido de serie

| Software | Función |
|---|---|
| **Steam** + Proton | Client de juegos + compatibilidad Windows |
| **Lutris** | Gestor de launchers (GOG, Epic, Battle.net) |
| **Wine** | Ejecutar apps y juegos Windows |
| **Gamemode** (Feral) | Optimización automática de CPU/GPU al jugar |
| **MangoHud** | Overlay de rendimiento (FPS, temperatura, uso CPU/GPU) |
| **KDE Plasma** | Escritorio personalizado |
| **Flatpak** | Formato portable para apps adicionales |

## Requisitos

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 64-bit x86_64 | 4+ cores |
| **RAM** | 4 GB | 8+ GB |
| **Disco** | 30 GB | 50+ GB SSD |
| **GPU** | NVIDIA GTX 1050+ / AMD RX 560+ | NVIDIA RTX / AMD RX 6000+ |

## Instalación

```bash
# Descargar ISO desde draugeros.com
# El instalador es Calamares (gráfico)

# Opciones de instalación:
# 1. NVIDIA driver (si aplica) — seleccionar durante install
# 2. SSD recomendado para tiempos de carga

# Tras instalar:
sudo apt update && sudo apt upgrade -y

# Driver NVIDIA (si no se instaló durante setup):
sudo ubuntu-drivers autoinstall
sudo reboot

# Verificar Gamemode
gamemoded -s    # estado del servicio

# Verificar MangoHud
mangohud --version
```

## Configuración post-instalación

```bash
# Activar Gamemode en Steam:
# En cada juego → Propiedades → Lanzamiento → añadir: gamemoderun %command%

# MangoHud overlay en Steam:
# Propiedades → Lanzamiento → añadir: mangohud %command%

# MangoHud configuración
# Crear ~/.config/MangoHud/MangoHud.conf:
fps_limit=60
vulkan_driver=1
gpu_stats
cpu_stats
ram
vram

# Driver NVIDIA específico
nvidia-smi                         # verificar driver
nvidia-settings                    # panel de configuración NVIDIA

# Compatibilidad Proton
# Steam → Configuración → Compatibilidad → Force Proton
# Elegir la versión más reciente de Proton Experimental
```

## Casos de uso

- **Gaming en Ubuntu estable**: todo preinstalado, sin configurar
- **Migrar de Windows para gaming**: Ubuntu LTS + ecosistema gaming completo
- **HTPC / living room**: KDE Plasma en PC conectado a TV
- **Stream gaming**: OBS + Steam (preinstalado)

## Drauger OS vs otras distros gaming

| Aspecto | Drauger OS | Bazzite | Pop!_OS | Garuda | CachyOS | SteamOS |
|---|---|---|---|---|---|---|
| **Base** | Ubuntu LTS | Fedora | Ubuntu | Arch | Arch | Arch (Valve) |
| **Gaming** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Estabilidad** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Inmutable** | ❌ | ✅ | ❌ | ❌ | ❌ | ✅ |
| **BTRFS snapshots** | ❌ | ✅ | ❌ | ✅ | ❌ | ✅ |
| **NVIDIA** | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ (solo AMD) |
| **Público** | Ubuntu gamers | PC gaming | Creators/gaming | Arch gamers | Performance | Consola |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Juego no inicia en Steam | Proton no configurado | Forzar Proton Experimental en propiedades del juego |
| FPS bajos | Gamemode no activo | Añadir `gamemoderun %command%` en lanzamiento |
| MangoHud no muestra overlay | MangoHud no instalado o incompatible | `sudo apt install mangohud` + verificar Vulkan |
| NVIDIA pantalla negra | Driver no instalado o NVIDIA optimus | `sudo ubuntu-drivers autoinstall` + reiniciar |
| Lutris no detecta juegos | Wine mal configurado | Instalar wine-stable: `sudo apt install wine-stable` |
| Teclado/mouse no responde en juego | gamemode bloqueando input | Desactivar gamemode temporalmente para ese juego |

## Ver también

- [[Videojuegos en Linux]]
- [[Bazzite]] — alternativa inmutable para gaming
- [[Garuda Linux]] — Arch-based gaming con BTRFS
- [[SteamOS]] — distro gaming de Valve
- [[Wine]] — compatibilidad Windows
- [[Gamescope]] — compositor micro-gráfico de Valve

## Enlaces externos

- [Sitio oficial](https://draugeros.com/)
- [GitHub](https://github.com/DraugerOS)
- [DistroWatch](https://distrowatch.com/table.php?distribution=draugeros)

#distribucion #gaming #ubuntu #kde
