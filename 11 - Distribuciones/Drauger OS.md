---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: distribucion
prioridad: baja
---

# Drauger OS

> Distro Linux orientada a gaming, basada en Ubuntu. Steam, Proton, Lutris preinstalados. Kernel optimizado para juegos.

## Qué es

Drauger OS es una distribución basada en **Ubuntu LTS** diseñada específicamente para gaming en Linux. Incluye Steam, Proton y Lutris preinstalados, con un kernel optimizado para gaming.

| Característica | Detalle |
|---|---|
| **Base** | Ubuntu LTS (22.04/24.04) |
| **Gestor de paquetes** | apt + Flatpak |
| **Init** | systemd |
| **DE** | KDE Plasma (personalizado) |
| **Orientación** | Gaming |
| **Kernel** | HWE o custom optimizado |

## Incluido de serie

- **Steam** + Proton (compatibilidad Windows)
- **Lutris** (gestor de launchers)
- **Wine** (ejecutar apps Windows)
- **Gamemode** de Feral Interactive (optimización automática)
- **MangoHud** (overlay de rendimiento)
- **KDE Plasma** (ligero y personalizable)

## Instalación

```bash
# Descargar ISO desde draugeros.com
# El instalador es Calamares (gráficaligero)
# Recomendado: instalar en SSD para tiempos de carga
```

## Configuración post-instalación

```bash
# Actualizar
sudo apt update && sudo apt upgrade

# Activar Gamemode para juegos
# En Steam:.getProperties → Compatibility → Force Proton

# MangoHud overlay
mangohud %command%   # añadir como variable de lanzamiento en Steam

# Driver NVIDIA (si aplica)
sudo ubuntu-drivers autoinstall
```

## Drauger OS vs otras distros gaming

| Distros | Ventaja |
|---|---|
| **Drauger OS** | Ubuntu base (estable), KDE ligero |
| **Bazzite** | Inmutable, atomic updates |
| **Pop!_OS** | COSMIC Desktop, soporte NVIDIA nativo |
| **Garuda Linux** | Arch-based, más reciente |
| **SteamOS** | Consola (Steam Deck) |

## Ver también

- [[Videojuegos en Linux]]
- [[Bazzite]]
- [[Videojuegos en Linux]]
- [[Wine]]

#distro #gaming #steam #kde #ubuntu
