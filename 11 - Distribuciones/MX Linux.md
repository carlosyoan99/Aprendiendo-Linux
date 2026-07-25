---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: apt (Debian)
base: Debian Stable
---

# MX Linux

## Qué es

**MX Linux** es una distribución basada en **Debian Stable** con un enfoque en **equilibrio**: potente, eficiente y fácil de usar. Usa **XFCE** como escritorio por defecto y es conocida por sus **herramientas MX** (MX Tools) que simplifican tareas administrativas.

Desarrollada por el equipo de **MX Dev Team** (comunidad de los antiguos foros de MEPIS + antiX). Ha sido consistentemente **#1 en DistroWatch** durante años (2020-2026), reflejando su popularidad entre usuarios que buscan estabilidad sin sacrificar usabilidad.

## Filosofía

- **Estable pero útil**: basada en Debian Stable pero con kernels, drivers y software más actualizados que los repos de Debian
- **Tools que marcan la diferencia**: MX Tools hacen que tareas complejas sean accesibles
- **Rendimiento**: funciona bien tanto en hardware moderno como en equipos con pocos recursos
- **Sin systemd como obligación**: se puede arrancar con sysV init en vez de systemd

## Características clave

### MX Tools

MX Linux incluye una colección de herramientas gráficas que simplifican la administración:

```bash
# MX Snapshot — crear ISO de tu sistema actual
mx-snapshot

# MX Boot Repair — reparar el bootloader
mx-boot-repair

# MX Cleanup — limpiar paquetes, cachés, logs
mx-cleanup

# MX Tweak — ajustes de apariencia y rendimiento
mx-tweak

# MX Codecs — instalación de códecs multimedia
mx-codecs

# MX Installer — instalador rápido del sistema
mx-installer

# MX Live USB Maker — crear USB booteable persistente
live-usb-maker

# MX Network Assistant — gestión de redes
mx-network-assistant
```

### Init configurable

MX permite elegir entre **systemd** y **sysV** (sin systemd) en el arranque:

```bash
# En el menú GRUB, seleccionar:
# "MX Linux (systemd)" → arranca con systemd
# "MX Linux (sysV)"   → arranca con sysV init

# O desde terminal:
sudo update-initramfs -u
```

## Gestor de paquetes

```bash
# Basada en Debian, usa apt + MX Package Installer (gráfico)
sudo apt update
sudo apt install paquete

# MX Package Installer (gráfico):
# - Repos Debian Stable + Backports
# - Repos MX (kernels actualizados, drivers)
# - Flatpak
# - Deb packages manuales
```

## Escritorios disponibles

| Edición | Escritorio | Público |
|---|---|---|
| **MX-23 XFCE** | XFCE 4.18 | Por defecto, equilibrado |
| **MX-23 KDE** | KDE Plasma 5.27 | Usuarios que quieren más features |
| **MX-23 Fluxbox** | Fluxbox | Hardware antiguo, minimalista |
| **MX-23 AHS** | XFCE + kernel 6.x + firmware | Hardware muy reciente (AMD) |

## Instalación

```bash
# 1. Descargar ISO desde https://mxlinux.org/download/
# 2. Grabar en USB:
sudo dd if=mx-23.4_x64.iso of=/dev/sdX bs=4M status=progress
# 3. Arrancar e instalar con MX Installer
# 4. Post-instalación:
mx-codecs                                   # instalar códecs
mx-tweak                                    # ajustar escritorio
sudo apt update && sudo apt upgrade         # actualizar
```

## Ver también

- [[Debian]] — base de MX Linux
- [[Linux Mint]] — alternativa Debian/Ubuntu fácil
- [[XFCE]] — escritorio por defecto
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]]

## Enlaces externos

- [MX Linux — Página oficial](https://mxlinux.org/)
- [MX Linux Forum](https://forum.mxlinux.org/)
- [MX Documentation — Manual](https://mxlinux.org/manual/)
- [DistroWatch — MX Linux](https://distrowatch.com/table.php?distribution=mx)

#distro
