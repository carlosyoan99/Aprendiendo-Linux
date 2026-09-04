---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: pacman + Flatpak
base: SteamOS 3.x (Arch Linux)
modelo_lanzamiento: Rolling
init: systemd
arquitecturas:
  - x86_64
---

# HoloISO

> **⚠️ Proyecto discontinuado (2023).** HoloISO intentaba llevar **SteamOS 3.x** a PCs genéricos parchando las imágenes de recuperación de la Steam Deck. Fue discontinuado por insostenibilidad del mantenimiento.

## Qué es

**HoloISO** fue un proyecto que intentaba llevar **SteamOS 3.x** (nombre en clave "Holo") a PCs genéricos. Parcheaba las imágenes de recuperación oficiales de la Steam Deck para que funcionaran en hardware de PC común, ofreciendo la experiencia exacta de SteamOS fuera del hardware de Valve.

**Estado actual**: el proyecto fue **discontinuado por su creador (TheVaan) en 2023** debido a la insostenibilidad del mantenimiento. Actualmente se considera un proyecto en abandono con soporte muy limitado. **No se recomienda para instalaciones nuevas** — usar [[Bazzite]] o [[ChimeraOS]] en su lugar.

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

## Características (histórico)

| Aspecto | Detalle |
|---|---|
| **Base** | SteamOS 3.x (Arch Linux) |
| **Gestor** | pacman + Flatpak (SteamOS-style) |
| **Init** | systemd |
| **Rama** | Rolling (actualizaciones de SteamOS) |
| **DE** | KDE Plasma (modo escritorio) + Gamescope (modo gaming) |
| **Gamescope** | Nativo (hereda de SteamOS) |
| **Soporte NVIDIA** | Prácticamente nulo |
| **Multi-arch** | Solo x86_64 |

```bash
# HoloISO usaba los mismos comandos que SteamOS:
steamos-readonly disable               # deshabilitar modo inmutable
sudo pacman -Syu                       # actualizar sistema
sudo pacman -S paquete                 # instalar paquete
steamos-readonly enable                # re-habilitar modo inmutable

# Flatpak para apps de escritorio
flatpak install flathub org.mozilla.firefox
```

## Por qué fracasó

| Factor | Detalle |
|---|---|
| **Base cerrada** | SteamOS está diseñado para un hardware específico (Steam Deck). Adaptarlo a PC genérico requería parchear componentes críticos. |
| **Drivers NVIDIA** | SteamOS solo soporta AMD. Añadir soporte NVIDIA requería mantener módulos del kernel y configuraciones fuera del ecosistema de Valve. |
| **Actualizaciones** | Valve puede cambiar cualquier componente de SteamOS sin aviso. HoloISO tenía que actualizarse cada vez, a menudo con semanas de retraso. |
| **Equipo pequeño** | Un solo desarrollador manteniendo un fork enorme. |
| **Alternativas mejores** | Bazzite y ChimeraOS ofrecen experiencia similar con mejor soporte. |

## Alternativas recomendadas (reemplazos)

| Alternativa | Por qué es mejor | Soporte NVIDIA | Estado |
|---|---|---|---|
| **[[Bazzite]]** | Experiencia más similar a SteamOS, soporte NVIDIA, activo, gran comunidad | ✅ | ✅ Activa |
| **[[ChimeraOS]]** | Experiencia consola pura, minimalista, para living room | ❌ (AMD only) | ✅ Activa |
| **[[SteamOS]]** | Si tienes Steam Deck, es la opción oficial | ❌ (solo Steam Deck) | ✅ Valve |
| **[[Garuda Linux]]** | Arch-based con gaming + BTRFS snapshots | ✅ | ✅ Activa |
| **[[CachyOS]]** | Arch optimizado para gaming, kernel custom | ✅ | ✅ Activa |

> **Regla simple**: si quieres SteamOS en PC → usa **Bazzite**. Si quieres consola living room → usa **ChimeraOS**.

## Comparativa rápida

| Aspecto | HoloISO (histórico) | Bazzite | ChimeraOS |
|---|---|---|---|
| **Base** | SteamOS 3.x | Fedora Atomic | Arch Linux |
| **Estado** | ❌ Discontinuado | ✅ Activa | ✅ Activa |
| **NVIDIA** | ❌ No soportado | ✅ Soportado | ❌ AMD only |
| **Inmutable** | ✅ (SteamOS-style) | ✅ (rpm-ostree) | ✅ (read-only) |
| **Gamescope** | ✅ Nativo | ✅ Nativo | ✅ Nativo |
| **Comunidad** | Muerta | Grande | Mediana |
| **Recomendado** | ❌ No | ✅ Sí | ✅ Sí (HTPC) |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No arranca en hardware NVIDIA | HoloISO no soporta NVIDIA | Cambiar a Bazzite o ChimeraOS (que sí soportan NVIDIA); es un proyecto descontinuado |
| Gamescope no lanza el juego | falta hardware AMD o config de GPU | Asegurar Mesa Vulkan (`libvulkan_radeon`) y correr `gamescope -- %command%` en Steam |
| Sin updates ni seguridad | proyecto descontinuado | Migrar a Bazzite/ChimeraOS; no hay repositorios mantenidos de HoloISO |
| Steam no detecta la cuenta en modo gaming | sesión por defecto Steam Deck | Arrancar el modo escritorio (KDE) e iniciar sesión normal de Steam una vez |

## Ver también

- [[ChimeraOS]] — alternativa activa para living room
- [[Bazzite]] — fork activo de SteamOS para PC con soporte NVIDIA
- [[SteamOS]] — la distro gaming original de Valve
- [[Videojuegos en Linux]] — gaming en Linux en general
- [[Gamescope]] — compositor micro-gráfico de Valve
- [[Proton]] — compatibilidad de juegos Windows en Linux

## Enlaces externos

- [HoloISO — GitHub (archivo)](https://github.com/HoloISO/releases)
- [Bazzite — Alternativa activa](https://bazzite.gg/)
- [ChimeraOS — Alternativa activa](https://chimeraos.org/)
- [SteamOS — Valve](https://store.steampowered.com/steamos)

#distribucion #gaming #descontinuado
