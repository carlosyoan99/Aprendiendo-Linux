---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: apt (Debian)
base: Debian (stable)
modelo_lanzamiento: Fixed
init: systemd
arquitecturas:
  - x86_64
  - ARM
---

# Q4OS

> Distribución ligera basada en **Debian** con un escritorio **KDE Plasma (Trinity opcional)** diseñada para ser rápida y familiar, incluida para equipos antiguos, con la estabilidad de Debian y su instalador APT.

## Filosofía / público objetivo

Q4OS está pensada para:

- **Equipos antiguos/ligeros**: funciona bien con HW modesto (Plasma o Trinity)
- **Usuarios que quieren un escritorio KDE estable y rápido** sin bloat
- **Familiaridad con Windows** (la interfaz recuerda a versiones de Windows en su configuración por defecto)
- **Estabilidad de Debian** con mantenimiento activo y LTS

Incluye **Trinity Desktop** (fork de KDE 3) como opción muy ligera. Es ideal como reemplazo de Windows en hardware viejo.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Debian (stable) |
| **Gestor de paquetes** | `apt` / `dpkg` |
| **Init** | systemd |
| **Modelo** | Fixed release (basado en Debian stable) |
| **Arquitecturas** | `x86_64`, `ARM` |
| **Entorno por defecto** | KDE Plasma (también Trinity, escritorio muy ligero) |
| **Instalador** | Instalador gráfico propio + editorial |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Pentium/ARM débil | Dual-core |
| **RAM** | 512 MB (Trinity) / 2 GB (Plasma) | 2-4 GB |
| **Disco** | 10 GB | 30 GB |
| **GPU** | Básica | Compatible con drivers KDE |

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
- Repos Debian estándar
- Flatpak/Flathub opcional (Centro de software)

## Ciclo de lanzamiento

**Fixed release** siguiendo a Debian stable; cada versión de Q4OS se basa en una release de Debian y recibe mantenerlo estable y LTS durante años.

## Actualización entre versiones mayores

Cambiar en `sources.list` de la versión vieja a la nueva y `dist-upgrade`, siguiendo el patrón de Debian.

```bash
sudo sed -i 's/oldcodename/newcodename/g' /etc/apt/sources.list
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt autoremove
```

Ver [[Actualización entre versiones mayores]].

## Instalación (resumen)

1. Descargar ISO de q4os.org
2. Grabar a USB y arrancar
3. Elegir escritorio (Plasma o Trinity) e instalador (gráfico)
4. Terminar e instalar extras vía el centro de software Q4OS

### Post-instalación recomendada
- [ ] Actualizar sistema
- [ ] Activar el Centro de software Q4OS para extras
- [ ] Instalar codecs/soporte multimedia
- [ ] Configurar firewall

## Comandos asociados

| Comando | Para qué |
|---|---|
| `sudo apt update && upgrade` | Actualizar |
| `sudo apt install` | Instalar |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Escritorio lento en HW viejo | Plasma pesado en RAM | Instalar edición **Trinity** en vez de Plasma |
| Falta audio/codecs | No instalados | `sudo apt install ffmpeg nomacs` o usar centro Q4OS |

## Comparativa con otras distros

| Aspecto | Q4OS | Debian | Linux Lite |
|---|---|---|---|
| **Facilidad** | Alta | Media | Alta |
| **Rendimiento** | Muy alto (ligera) | Alto | Muy alto |
| **Paquetes** | apt | apt | apt |
| **Comunidad** | Pequeña/activa | Gigante | Media |
| **Estabilidad** | Muy buena (Debian) | Muy buena | Buena |

## Notas de instalación propias
- La opción **Trinity** la hace única para resucitar portátiles antiguos con KDE 3.
- Muy estable al basarse en Debian stable.

## Enlaces externos
- [Sitio oficial](https://www.q4os.org/)
- [Wiki oficial](https://www.q4os.org/docs/)
- [Wikipedia — Q4OS](https://en.wikipedia.org/wiki/Q4OS)
- [Repositorio GitHub](https://github.com/q4os)
- [DistroWatch](https://distrowatch.com/table.php?distribution=q4os)

## Ver también
- [[Debian]] — distribución base
- [[KDE Plasma]] — entorno por defecto
- [[MATE]] y [[LXQt]] — alternativas ligeras
- [[Actualización entre versiones mayores]] — upgrade de versión mayor

#distro