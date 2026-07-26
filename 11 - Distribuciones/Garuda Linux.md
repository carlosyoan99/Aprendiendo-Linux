---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: distribucion
prioridad: media
---

# Garuda Linux

> Arch-based con BTRFS + snapshots automáticos. Enfocado en gaming y rendimiento con kernel zen y drivers gráficos preinstalados.

## Filosofía / público objetivo

Garuda está pensado para usuarios que quieren la potencia de Arch sin la complejidad de la instalación manual. Su punto fuerte es el gaming: kernel zen, drivers NVIDIA/AMD, Steam, Lutris y Heroic preinstalados.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Arch Linux (rolling) |
| **Gestor de paquetes** | pacman + AUR (yay) |
| **Init** | systemd |
| **FS por defecto** | BTRFS con Snapper |
| **Kernel** | linux-zen (optimizado para gaming) |
| **DEs disponibles** | GNOME, KDE Plasma, XFCE, i3, Hyprland, Sway |
| **Snapper** | Snapshots automáticos preconfigurados |

## Requisitos

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 64-bit x86_64 | 4+ cores |
| **RAM** | 4 GB | 8+ GB |
| **Disco** | 30 GB | 50+ GB (BTRFS necesita espacio) |

## Comandos asociados

| Comando | Para qué |
|---|---|
| `garuda-assistant` | Asistente post-install |
| `garuda-dracut-support` | Soporte para snapshots |
| `sudo snapper list` | Ver snapshots BTRFS |
| `sudo snapper rollback` | Restaurar snapshot |

## Comparativa con otras distros gaming

| Aspecto | Garuda | Pop!_OS | Bazzite | CachyOS |
|---|---|---|---|---|
| **Base** | Arch | Ubuntu | Fedora | Arch |
| **Gaming** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Snaps BTRFS** | ✅ | ❌ | ✅ (rpm-ostree) | ❌ |
| **Estabilidad** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Comunidad** | Mediana | Grande | Grande | Mediana |

## Ver también

- [[Arch Linux]], [[CachyOS]], [[Bazzite]], [[Pop OS]], [[SteamOS]]

## Enlaces externos

- [Sitio oficial](https://garudalinux.org/)
- [Wikipedia — Garuda Linux](https://en.wikipedia.org/wiki/Garuda_Linux)
- [DistroWatch](https://distrowatch.com/table.php?distribution=garuda)

#distribucion #gaming
