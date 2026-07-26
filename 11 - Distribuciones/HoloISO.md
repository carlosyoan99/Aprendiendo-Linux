---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: distribucion
prioridad: baja
---

# HoloISO

## Qué es

**HoloISO** fue un proyecto que intentaba llevar **SteamOS 3.x** (nombre en clave "Holo") a PCs genéricos. Parcheaba las imágenes de recuperación oficiales de la Steam Deck para que funcionaran en hardware de PC común, ofreciendo la experiencia exacta de SteamOS fuera del hardware de Valve.

**Estado actual**: el proyecto fue **discontinuado por su creador (TheVaan) en 2023** debido a la insostenibilidad del mantenimiento. Actualmente se considera un proyecto en abandono con soporte muy limitado. **No se recomienda para instalaciones nuevas** — usar [[Bazzite]] o [[ChimeraOS]] en su lugar.

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

## Historia

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

## Por qué fracasó

| Factor | Detalle |
|---|---|
| **Base cerrada** | SteamOS está diseñado para un hardware específico (Steam Deck). Adaptarlo a PC genérico requería parchear componentes críticos. |
| **Drivers NVIDIA** | SteamOS solo soporta AMD. Añadir soporte NVIDIA requería mantener módulos del kernel y configuraciones fuera del ecosistema de Valve. |
| **Actualizaciones** | Valve puede cambiar cualquier componente de SteamOS sin aviso. HoloISO tenía que actualizarse cada vez, a menudo con semanas de retraso. |
| **Equipo pequeño** | Un solo desarrollador manteniendo un fork enorme. |
| **Alternativas mejores** | Bazzite y ChimeraOS ofrecen experiencia similar con mejor soporte. |

## Alternativas recomendadas

| Alternativa | Por qué |
|---|---|
| **[[Bazzite]]** | Experiencia más similar a SteamOS, soporte NVIDIA, activo, gran comunidad. Ideal para PC gaming. |
| **[[ChimeraOS]]** | Experiencia consola pura, minimalista, para living room. Ideal para HTPC. |
| **[[SteamOS]]** | Si tienes Steam Deck, es la opción oficial. |

## Ver también

- [[ChimeraOS]] — alternativa activa para living room
- [[Bazzite]] — fork activo de SteamOS para PC con soporte NVIDIA
- [[SteamOS]] — la distro gaming original de Valve
- [[Videojuegos en Linux]] — gaming en Linux en general
- [[Gamescope]] — compositor micro-gráfico de Valve

## Enlaces externos

- [HoloISO — GitHub (archivo)](https://github.com/HoloISO/releases)
- [Bazzite — Alternativa activa](https://bazzite.gg/)
- [ChimeraOS — Alternativa activa](https://chimeraos.org/)

#distro #gaming
