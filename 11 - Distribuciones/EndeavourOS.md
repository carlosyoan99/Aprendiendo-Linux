---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: pacman (Arch)
base: Arch Linux
---

# EndeavourOS

## Qué es

**EndeavourOS** es una distribución basada en **Arch Linux** diseñada para ofrecer la experiencia de Arch (rolling release, AUR, pacman) sin la complejidad de la instalación manual. Es el sucesor espiritual de **Antergos** (descontinuado en 2019), y se ha convertido en una de las distribuciones rolling más populares.

A diferencia de **Manjaro** (que retrasa paquetes de Arch para mayor estabilidad), EndeavourOS usa los **repositorios oficiales de Arch directamente** y añade su propio repositorio con herramientas y temas.

## Filosofía

- **Arch sin el instalador**: acceso a todo el ecosistema Arch (pacman, AUR, wiki) sin instalar manualmente
- **Rolling release**: actualizaciones continuas, sin versiones
- **Elección**: el instalador permite elegir entre varios DEs/WMs: XFCE (por defecto), KDE, GNOME, i3, bspwm, Qtile, Cinnamon, MATE, LXQt, Budgie, Sway
- **Comunidad activa**: foro amigable, onboarding para nuevos usuarios de Arch

## Características

| Aspecto | Detalle |
|---|---|
| **Gestor** | pacman + yay/paru (AUR helpers preinstalados) |
| **Base** | Arch Linux (repos oficiales directos) |
| **Instalador** | Gráfico (Calamares) |
| **DE por defecto** | XFCE (también online: KDE, GNOME, i3, etc.) |
| **Init** | systemd |
| **Tipo** | Rolling release |
| **Ideal para** | Quien quiere Arch sin la instalación manual |

## Instalación

```bash
# Descargar ISO desde: https://endeavouros.com/download/
# Instalador gráfico Calamares: particionado, usuario, DE, bootloader

# Requisitos mínimos:
# - RAM: 2 GB (4 GB recomendados)
# - Disco: 20 GB
# - Conexión a internet (instalador descarga paquetes)
```

## Herramientas exclusivas

EndeavourOS incluye herramientas propias para facilitar la administración:

```bash
# Welcome App — guía de inicio post-instalación
# - Instalar drivers NVIDIA/AMD
# - Elegir DE adicional
# - Acceso a la wiki y foro

# eos-update-notifier — notificador de actualizaciones en la bandeja

# eos-hooks — hooks de pacman para mantener el sistema limpio

# yay preinstalado — acceso inmediato al AUR
yay -Syu                                 # actualizar sistema + AUR
```

## EndeavourOS vs Arch vs Manjaro

| Aspecto | Arch Linux | EndeavourOS | Manjaro |
|---|---|---|---|
| **Instalación** | Manual (archinstall o paso a paso) | Gráfica (Calamares) | Gráfica (Calamares) |
| **Repos** | Oficiales de Arch | **Oficiales de Arch** + EOS | Propios (retrasados) |
| **AUR** | Manual (instalar helper) | ✅ Preinstalado (yay) | Preinstalado (pamac) |
| **Estabilidad** | Rolling (últimos paquetes) | Rolling (últimos paquetes) | Rolling (retrasados) |
| **Complejidad** | Alta | Baja-Media | Baja |
| **Ideal para** | Usuarios avanzados | Entusiastas de Arch | Usuarios que quieren rolling estable |

## Enlaces externos

- [Sitio oficial de EndeavourOS](https://endeavouros.com/)
- [Foro de EndeavourOS](https://forum.endeavouros.com/)
- [Wikipedia — EndeavourOS](https://en.wikipedia.org/wiki/EndeavourOS)
- [GitHub — EndeavourOS](https://github.com/endeavouros-team/)

## Ver también

- [[Arch Linux]] — base del sistema
- [[Manjaro]] — alternativa rolling basada en Arch
- [[CachyOS]] — Arch optimizado para gaming
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]]

#distro
