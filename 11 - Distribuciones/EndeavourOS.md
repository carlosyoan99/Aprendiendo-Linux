---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: pacman (Arch)
base: Arch Linux
modelo_lanzamiento: Rolling
init: systemd
arquitecturas:
  - x86_64
---

# EndeavourOS

> Distribución basada en **Arch Linux** que ofrece la experiencia de Arch (rolling release, AUR, pacman) sin la complejidad de la instalación manual. Sucesor espiritual de **Antergos** (descontinuado en 2019).

## Filosofía / público objetivo

EndeavourOS está diseñado para usuarios que quieren:
- **Acceso directo a repos oficiales de Arch** (sin retrasos como Manjaro)
- **Instalación gráfica** (Calamares) en lugar de archinstall/manual
- **AUR preinstalado** (yay/paru) para acceso inmediato a miles de paquetes
- **Comunidad amigable** para nuevos usuarios de Arch

A diferencia de **Manjaro** (que retrasa paquetes de Arch para mayor estabilidad), EndeavourOS usa los **repositorios oficiales de Arch directamente** y añade su propio repositorio con herramientas y temas.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Gestor** | pacman + yay/paru (AUR helpers preinstalados) |
| **Base** | Arch Linux (repos oficiales directos) |
| **Instalador** | Gráfico (Calamares) |
| **DE por defecto** | XFCE (también online: KDE, GNOME, i3, etc.) |
| **Init** | systemd |
| **Tipo** | Rolling release |
| **Ideal para** | Quien quiere Arch sin la instalación manual |

### Herramientas exclusivas

| Herramienta | Función |
|---|---|
| **Welcome App** | Guía de inicio post-instalación (drivers, DE, wiki) |
| **eos-update-notifier** | Notificador de actualizaciones en bandeja |
| **eos-hooks** | Hooks de pacman para mantener el sistema limpio |
| **yay/paru** | AUR helpers preinstalados |

### DEs disponibles en instalación

| Entorno | Tipo |
|---|---|
| XFCE (por defecto) | Ligero, clásico |
| KDE Plasma | Pesado, moderno |
| GNOME | Pesado, minimalista |
| i3 | Tiling WM |
| bspwm | Tiling WM |
| Qtile | Tiling WM (Python) |
| Cinnamon | Tipo Windows |
| MATE | Clásico GNOME 2 |
| LXQt | Ultraligero |
| Budgie | Moderno, elegante |
| Sway | Tiling Wayland |

## Requisitos

| Componente | Mínimo | Recomendado |
|---|---|---|
| **RAM** | 2 GB | 4 GB |
| **Disco** | 20 GB | 40 GB |
| **Red** | Conexión a internet (instalador descarga paquetes) | — |

## Instalación

```bash
# Descargar ISO desde: https://endeavouros.com/download/
# Hay dos tipos:
# 1. ISO offline — XFCE preinstalado, sin necesidad de internet
# 2. ISO online — elegir DE durante la instalación (requiere internet)

# El instalador Calamares permite:
# - Particionado (manual o automático)
# - Elegir DE
# - Configurar bootloader (GRUB, systemd-boot)
# - Crear usuario
```

## Configuración post-instalación

```bash
# Welcome App — primer paso tras instalación
# - Instalar drivers NVIDIA/AMD
# - Elegir DE adicional
# - Acceso a la wiki y foro

# Actualizar sistema
yay -Syu                                # actualiza sistema + AUR

# Instalar paquetes AUR
yay -S visual-studio-code-bin           # desde AUR
paru -S google-chrome                   # alternativa con paru

# Hooks de EndeavourOS (se ejecutan automáticamente con pacman)
# /etc/pacman.d/hooks/ — mantienen el sistema limpio
```

## EndeavourOS vs Arch vs Manjaro vs CachyOS

| Aspecto | Arch Linux | EndeavourOS | Manjaro | CachyOS |
|---|---|---|---|---|
| **Instalación** | Manual (archinstall o paso a paso) | Gráfica (Calamares) | Gráfica (Calamares) | Gráfica (Calamares) |
| **Repos** | Oficiales de Arch | **Oficiales de Arch** + EOS | Propios (retrasados) | **Oficiales de Arch** + Cachy |
| **AUR** | Manual (instalar helper) | ✅ Preinstalado (yay) | Preinstalado (pamac) | ✅ Preinstalado (paru) |
| **Retraso paquetes** | 0 días | 0 días | ~2 semanas | 0 días |
| **Estabilidad** | Rolling (últimos paquetes) | Rolling (últimos paquetes) | Rolling (retrasados) | Rolling (optimizados) |
| **Complejidad** | Alta | Baja-Media | Baja | Baja-Media |
| **Comunidad** | Masiva (wiki) | Grande (foro) | Muy grande | Grande |
| **Ideal para** | Usuarios avanzados | Entusiastas de Arch | Usuarios que quieren rolling estable | Gaming + performance |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `pacman: error while loading shared libraries` | Sistema desactualizado tras install | `sudo pacman -Syu` primero |
| NVIDIA no funciona | Driver no instalado | Usar Welcome App → install NVIDIA driver |
| yay/paru no compila | Dependencias faltantes | `yay -S --needed base-devel` |
| Pantalla negra post-login (NVIDIA) | Wayland incompatible | Cambiar a X11 en login screen (gear icon) |
| `error: failed to commit transaction (conflicting files)` | Paquete en AUR conflicta con oficial | `yay -S --overwrite '*' paquete` |
| Actualización grande rompe algo | Rolling release upstream breakage | Restaurar con snapshots (si Btrfs) o `sudo pacman -U /var/cache/pacman/pkg/paquete-antiguo.pkg.tar.zst` |

## Ver también

- [[Arch Linux]] — base del sistema
- [[Manjaro]] — alternativa rolling basada en Arch
- [[CachyOS]] — Arch optimizado para gaming
- [[pacman]] — gestor de paquetes
- [[AUR]] — repositorio de usuario

## Enlaces externos

- [Sitio oficial de EndeavourOS](https://endeavouros.com/)
- [Foro de EndeavourOS](https://forum.endeavouros.com/)
- [Wikipedia — EndeavourOS](https://en.wikipedia.org/wiki/EndeavourOS)
- [GitHub — EndeavourOS](https://github.com/endeavouros-team/)
- [DistroWatch](https://distrowatch.com/table.php?distribution=endeavour)

#distribucion #arch #rolling
