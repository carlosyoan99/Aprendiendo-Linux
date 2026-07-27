---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: APT + apx (gestor propio en contenedores)
base: Debian Sid (v1: Ubuntu 22.10)
modelo_lanzamiento: Fixed (immutable, atómico)
init: systemd
arquitecturas:
  - x86_64
---

# Vanilla OS

> Distribución Linux **inmutable** basada en Debian Sid, con escritorio GNOME puro (sin personalizaciones) y actualizaciones atómicas. Usa ABRoot para alternar entre sistemas raíz A/B similar a Fedora Silverblue.

## Filosofía / público objetivo

Vanilla OS apuesta por un **GNOME absolutamente vanilla** (sin extensiones, sin personalizaciones) combinado con un sistema **inmutable** donde el sistema raíz es de solo lectura y las actualizaciones son atómicas. Es mantenida por la empresa italiana **Fabricators SRL**.

Está pensada para usuarios que quieren la experiencia GNOME más pura posible con la seguridad de un sistema inmutable.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Debian Sid (versión 1 usaba Ubuntu 22.10) |
| **Gestor de paquetes** | APT + dpkg + apx (gestor propio basado en contenedores) |
| **Init** | systemd |
| **Modelo** | Immutable (raíz de solo lectura) |
| **Entorno por defecto** | GNOME puro (sin personalizaciones) |
| **Instalador** | Propio (GTK4 + libadwaita) |
| **Actualizaciones** | Atómicas vía ABRoot (dual root A/B) |

### ABRoot (actualizaciones atómicas)

Vanilla OS usa **ABRoot**, un sistema de dos particiones raíz: **A** y **B**. Las actualizaciones se aplican en la partición inactiva mientras el sistema sigue funcionando. Al reiniciar, el sistema arranca desde la partición actualizada. Si algo falla, puedes volver al estado anterior desde GRUB.

### Apx (gestor de paquetes en contenedores)

Apx permite instalar paquetes de **cualquier distribución** dentro de contenedores:

```bash
# Instalar paquetes de diferentes distros en contenedores
apx install nvim                    # desde Debian (por defecto)
apx --dnf install neofetch          # desde Fedora
apx --pacman install firefox        # desde Arch Linux
```

También soporta Flatpak, AppImage y Waydroid (apps Android).

## Lanzamientos

| Versión | Nombre | Base | Fecha |
|---|---|---|---|
| 22.10 | Kinetic | Ubuntu 22.10 | 2022-12-29 |
| 2 | Orchid | Debian Sid | 2024-07-28 |

## Enlaces externos

- [Sitio oficial](https://vanillaos.org/)
- [Wikipedia — Vanilla OS](https://es.wikipedia.org/wiki/Vanilla_OS)
- [Repositorio GitHub](https://github.com/Vanilla-OS)

## Ver también

- [[Fedora]] — Fedora Silverblue, otro sistema inmutable
- [[GNOME]] — escritorio por defecto
- [[Debian]] — base del sistema

#distro #inmutable
