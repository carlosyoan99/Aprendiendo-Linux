---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: pacman (AUR, yay)
base: Arch Linux
modelo_lanzamiento: Rolling
init: systemd
arquitecturas:
  - x86_64
---

# Garuda Linux

> Arch-based con **BTRFS + snapshots automáticos**. Enfocado en gaming y rendimiento con kernel zen y drivers gráficos preinstalados. Diseñado para ser la forma más fácil de usar Arch para gaming.

## Filosofía / público objetivo

Garuda está pensado para usuarios que quieren la potencia de Arch sin la complejidad de la instalación manual. Su punto fuerte es el gaming: kernel zen, drivers NVIDIA/AMD, Steam, Lutris y Heroic preinstalados. El sistema BTRFS con Snapper ofrece rollback automático — si algo falla tras una actualización, puedes volver a un snapshot anterior desde GRUB.

- **Público**: gamers, usuarios de escritorio que quieren Arch sin complicaciones
- **Enfoque**: gaming + BTRFS snapshots + estética llamativa
- **Garuda DragoNix**: versión administrada para empresas/educación

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
| **Peso RAM (idle)** | ~600-800 MB |

### Herramientas propias

| Herramienta | Función |
|---|---|
| `garuda-assistant` | Asistente gráfico post-install (drivers, apps, tweaks) |
| `garuda-dracut-support` | Soporte para snapshots BTRFS con Dracut |
| `garuda-settings-manager` | Configuración del kernel, drivers, red |
| `garuda-welcome` | Panel de bienvenida con accesos rápidos |

## Requisitos

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 64-bit x86_64 | 4+ cores |
| **RAM** | 4 GB | 8+ GB |
| **Disco** | 30 GB | 50+ GB (BTRFS necesita espacio) |
| **GPU** | Cualquier compatible con Linux | NVIDIA dedicada para gaming |

## Instalación

```bash
# Descargar ISO desde garudalinux.org
# Hay versiones por DE: KDE, GNOME, XFCE, i3, Hyprland, Sway

# El instalador es Calamares (gráfico)
# Opciones recomendadas:
# 1. BTRFS como filesystem (por defecto)
# 2. Snapshots con Snapper (activado por defecto)
# 3. Kernel linux-zen (por defecto)
# 4. NVIDIA driver (si aplica)

# Tras instalar:
sudo garuda-assistant    # asistente post-install
sudo pacman -Syu         # actualizar
```

## Snapper y rollback

```bash
# Listar snapshots
sudo snapper list

# Crear snapshot manual
sudo snapper -c root create -d "antes de instalar paquete"

# Restaurar desde GRUB (si el sistema no arranca):
# 1. Reiniciar → en GRUB, seleccionar "Garuda Snapshots"
# 2. Elegir snapshot deseado
# 3. El sistema arranca desde ese snapshot

# Restaurar snapshot actual
sudo snapper rollback
sudo reboot

# Configurar retención de snapshots (limpieza automática)
sudo snapper -c root set-config "TIMELINE_LIMIT_HOURLY=5"
sudo snapper -c root set-config "TIMELINE_LIMIT_DAILY=7"
sudo snapper -c root set-config "TIMELINE_LIMIT_WEEKLY=0"
sudo snapper -c root set-config "TIMELINE_LIMIT_MONTHLY=0"
sudo snapper -c root set-config "TIMELINE_LIMIT_YEARLY=0"
```

## Comandos asociados

| Comando | Para qué |
|---|---|
| `garuda-assistant` | Asistente post-install gráfico |
| `garuda-dracut-support` | Soporte BTRFS snapshots |
| `garuda-settings-manager` | Config kernel, drivers, red |
| `sudo snapper list` | Ver snapshots BTRFS |
| `sudo snapper rollback` | Restaurar snapshot |

## Comparativa con otras distros gaming

| Aspecto | Garuda | Pop!_OS | Bazzite | CachyOS | SteamOS |
|---|---|---|---|---|---|
| **Base** | Arch | Ubuntu | Fedora | Arch | Arch (Valve) |
| **Gaming** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Snaps BTRFS** | ✅ (Snapper) | ❌ | ✅ (rpm-ostree) | ❌ (Btrfs pero sin snapper) | ✅ (read-only) |
| **Kernel** | linux-zen | HWE | Custom (bore) | linux-cachyos | Custom Valve |
| **Estabilidad** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Comunidad** | Mediana | Grande | Grande | Grande | Masiva |
| **RAM idle** | ~600 MB | ~800 MB | ~500 MB | ~400 MB | ~400 MB |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Snapshots no aparecen en GRUB | dracut no configurado | `sudo garuda-dracut-support` + reiniciar |
| BTRFS "no space left" | BTRFS necesita espacio para snapshots | `sudo btrfs filesystem resize /` ampliar, o limpiar snapshots: `sudo snapper delete 1..N` |
| Pantalla negra tras login | NVIDIA + Wayland incompatible | Cambiar a X11 en login screen, o instalar nvidia-dkms |
| Gamescope no funciona | Versión incompatible | `sudo pacman -S gamescope-git` (AUR) |
| `yay` no compila paquete | Dependencias faltantes | `yay -S --needed base-devel` |
| Sistema lento tras actualización | Paquete conflicto | Restaurar snapshot: `sudo snapper rollback` |

## Ver también

- [[Arch Linux]] — base del sistema
- [[Bazzite]] — alternativa inmutable para gaming
- [[CachyOS]] — Arch optimizado para gaming (sin BTRFS automático)
- [[Pop OS]] — gaming en base Ubuntu
- [[Videojuegos en Linux]] — gaming general
- [[SteamOS]] — la distro gaming de Valve

## Enlaces externos

- [Sitio oficial](https://garudalinux.org/)
- [Wikipedia — Garuda Linux](https://en.wikipedia.org/wiki/Garuda_Linux)
- [DistroWatch](https://distrowatch.com/table.php?distribution=garuda)
- [GitHub](https://github.com/garuda-linux)

#distribucion #gaming #arch #btrfs
