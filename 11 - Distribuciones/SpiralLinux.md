---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: borrador
categoria: distribucion
prioridad: media
gestor_paquetes: apt (Debian)
base: Debian (stable/testing)
modelo_lanzamiento: Fixed
init: systemd
arquitecturas:
  - x86_64
  - ARM
---

# SpiralLinux

> Distribución basada en **Debian** que ofrece una **instalación preconfigurada y pulida** lista para uso diario (escritorio, repositorios, gestión de paquetes) con la estabilidad de Debian, evitando la configuración manual posterior a la instalación.

## Filosofía / público objetivo

SpiralLinux nace del repositorio/método de instalación **SpiralLinux** de **d4ryus** (el mismo autor de GeckoLinux, su antecesor). Su objetivo:

- **Debian estable** con todo lo molesto de la post-instalación ya resuelto
- **Escritorios listos**: GNOME, KDE Plasma, XFCE, Cinnamon, Budgie, LXQt, etc.
- **Repos y codecs preconfigurados** (incl. firmware no libre)
- **Instalación simple** con **Calamares** en vez del instalador Debian clásico
- **Estabilidad de Debian** por encima de la novedad

Está dirigida a quien quiere Debian sin la curva de configuración, y viene de la tradición de scripts GeckoLinux/SpiralLinux que hacían de Debian un escritorio "plug & play".

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Debian (stable o testing según edición) |
| **Gestor de paquetes** | `apt` / `dpkg` (con flatpak opcional) |
| **Init** | systemd (Deja Stable/Testing) |
| **Modelo** | Fixed release (sigue debian stable/testing) |
| **Arquitecturas** | `x86_64`, `ARM` |
| **Entorno por defecto** | Vario: GNOME, KDE, XFCE, Cinnamon, Budgie, LXQt... |
| **Instalador** | **Calamares** |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Cualquier x86_64 | Dual-core |
| **RAM** | 2 GB | 4 GB+ |
| **Disco** | 20 GB | 50 GB+ |
| **GPU** | Básica | Compatible con deja/firmware |

## Gestor de paquetes

```bash
# Actualizar repos
sudo apt update

# Actualizar sistema
sudo apt upgrade

# Instalar paquete
sudo apt install paquete

# Buscar paquete
apt search termino

# Eliminar paquete
sudo apt remove paquete
```

### Repositorios adicionales (AUR, COPR, PPAs...)
- Repos Debian estándar + contrib/non-free (firmware)
- Flatpak/Flathub opcional preconfigurado

## Ciclo de lanzamiento

**Fixed release** siguiendo a Debian: ediciones basadas en `stable` (muy estable) y a veces `testing`. Cuando Debian publica, SpiralLinux regenera sus imágenes.

## Actualización entre versiones mayores

Igual que Debian — cambio de `stable`/`testing` en `sources.list` y `dist-upgrade`.

```bash
sudo sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt autoremove
```

Ver [[Actualización entre versiones mayores]].

## Instalación (resumen)

1. Descargar el ISO desde spirallinux.github.io
2. Grabar a USB y arrancar
3. Usar **Calamares** para instalar (elegir escritorio ya viene incluido)
4. Al terminar, el sistema queda listo con repos, audio y thumbnails configurados

### Post-instalación recomendada
- [ ] Actualizar sistema
- [ ] Configurar zona horaria y locale (ya suele venir)
- [ ] Instalar codecs adicionales si no están
- [ ] Configurar firewall

## Comandos asociados

| Comando | Para qué |
|---|---|
| `sudo apt update && upgrade` | Actualizar |
| `sudo apt install` | Instalar |
| `dpkg -i` | Instalar .deb |
| `systemctl status` | Ver servicios |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Sin audio | Falta pipewire/pulse | `sudo apt install pipewire-audio` |
| Falta firmware | Non-free ausente | `sudo apt install firmware-linux-nonfree` |
| Calamares falla (encryption) | Cifrado con ediciones determinadas | Reintentar con particionado manual |

## Comparativa con otras distros

| Aspecto | SpiralLinux | Debian | Ubuntu |
|---|---|---|---|
| **Facilidad** | Alta | Media | Media |
| **Rendimiento** | Alto | Alto | Alto |
| **Paquetes** | apt | apt | apt + snap |
| **Comunidad** | Pequeña | Gigante | Grande |
| **Estabilidad** | Muy buena | Muy buena | Buena |

## Notas de instalación propias
- Excelente puerta de entrada a Debian para quien no quiere el instalador clásico.
- Software suele ser más antiguo que en rolling releases (filosofía stable).

## Enlaces externos
- [Sitio oficial](https://spirallinux.github.io/)
- [Repositorio GitHub](https://github.com/spiralinux)
- [Wikipedia — SpiralLinux](https://en.wikipedia.org/wiki/SpiralLinux)
- [DistroWatch](https://distrowatch.com/table.php?distribution=spirallinux)

## Ver también
- [[Debian]] — distribución base
- [[Actualización entre versiones mayores]] — upgrade de versión mayor
- [[Proceso de Instalación General]] — instalación desde cero

#distro