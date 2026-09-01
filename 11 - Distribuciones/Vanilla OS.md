---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-08-31
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

Está pensada para usuarios que quieren:
- La experiencia GNOME más pura posible
- La seguridad de un sistema inmutable
- Instalar apps de otras distros (Debian, Fedora, Arch) vía contenedores

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
apx --zypper install vim            # desde openSUSE

# Listar gestores disponibles
apx managers list

# Flatpak para apps de escritorio
flatpak install flathub org.mozilla.firefox

# Waydroid para apps Android
sudo apx install waydroid
```

## Lanzamientos

| Versión | Nombre | Base | Fecha |
|---|---|---|---|
| 22.10 | Kinetic | Ubuntu 22.10 | 2022-12-29 |
| 2 | Orchid | Debian Sid | 2024-07-28 |

## Instalación

```bash
# Descargar ISO desde vanillaos.org
# El instalador es propio (GTK4 + libadwaita)

# Requisitos:
# - CPU: 64-bit x86_64
# - RAM: 4 GB mínimo
# - Disco: 25 GB mínimo
# - EFI/UEFI (recomendado)

# Tras instalar:
# 1. Ejecutar el asistente de configuración inicial
# 2. Apx ya preinstalado — instalar apps de otras distros:
apx install neovim git htop
apx --pacman install visual-studio-code-bin
```

## Comparativa con alternativas

| Aspecto | Vanilla OS | Fedora Silverblue | NixOS | Ubuntu Core |
|---|---|---|---|---|
| **Base** | Debian Sid | Fedora | Independiente | Ubuntu |
| **Modelo** | Inmutable (ABRoot) | Inmutable (rpm-ostree) | Inmutable (declarativo) | Inmutable (snap) |
| **Multi-distro apps** | ✅ (apx) | ❌ (solo Flatpak) | ❌ (nixpkgs) | ❌ (solo snap) |
| **GNOME** | Puro (sin extensiones) | Con extensiones (Stock) | Electivo | No incluido |
| **DE** | Solo GNOME | GNOME (puede cambiar) | Cualquier DE | Solo core |
| **Comunidad** | Pequeña | Grande | Grande | Grande |
| **Madurez** | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `apx: package not found` | Gestor no instalado | `apx managers install debian` (o el que necesites) |
| Actualización falla | Conflicto entre A/B partitions | Reiniciar y seleccionar otra partición en GRUB |
| Flatpak apps no abren | Portal debus no configurado | `sudo systemctl restart xdg-desktop-portal` |
| Sistema se queda sin espacio | Contenedores apx acumulados | `apx remove --all` o limpiar contenedores no usados |
| Waydroid no inicia | Kernel sin módulos | `sudo modprobe binder_linux` + verificar GBA (Google Apps) |
| No se puede instalar paquete nativo | Sistema inmutable (raíz solo lectura) | Usar apx, Flatpak o distrobox en su lugar |

## Ver también

- [[Fedora]] — Fedora Silverblue, otro sistema inmutable
- [[GNOME]] — escritorio por defecto
- [[Debian]] — base del sistema
- [[NixOS]] — sistema inmutable declarativo
- [[Flatpak]] — formatos portables

## Enlaces externos

- [Sitio oficial](https://vanillaos.org/)
- [Wikipedia — Vanilla OS](https://es.wikipedia.org/wiki/Vanilla_OS)
- [Repositorio GitHub](https://github.com/Vanilla-OS)
- [Documentación](https://docs.vanillaos.org/)

#distribucion #inmutable #gnome
