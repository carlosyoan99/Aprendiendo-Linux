---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: pacman (Arch)
base: Arch Linux
modelo_lanzamiento: Rolling
init: openrc | runit | s6 | dinit
arquitecturas:
  - x86_64
  - ARM
---

# Artix Linux

> Distribución **rolling** basada en **Arch Linux** pero **sin systemd**, que ofrece los repositorios oficiales de Arch y pacman/AUR con tus init de preferencia: **openrc**, **runit**, **s6** o **dinit**.

## Filosofía / público objetivo

Artix está pensada para usuarios que quieren la experiencia **Arch** (rolling release, AUR, pacman, paquetes frescos) pero prefieren no usar **systemd**. Responde a la filosofía **init-agnostic**: el usuario elige el gestor de servicios en el arranque.

- **pacman y AUR** completos, igual que Arch
- **Múltiples inits**: openrc, runit, s6, dinit (nada de systemd)
- **Repositorios propios** con los paquetes parcheados para funcionar sin systemd
- **SO prescinde de systemd** también a nivel de usuarios y login (sin logind por defecto, aunque es instalable)

Se diferencia de **Arch** en que reemplaza todo el ecosistema systemd por el init elegido, y de **Devuan** en que usa los repos de Arch en lugar de Debian.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Arch Linux (repos `core`/`extra` de Artix) |
| **Gestor de paquetes** | `pacman` + AUR (yay/paru) |
| **Init** | openrc, runit, s6 o dinit (a elegir) |
| **Modelo** | Rolling release |
| **Arquitecturas** | `x86_64`, `ARM` |
| **Entorno por defecto** | Ninguno fijo (instalador con opciones: LXQt, KDE, MATE, XFCE...) |
| **Instalador** | `iso` con instalador gráfico (Calamares) u opción base CLI |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Cualquier x86_64 | Dual-core |
| **RAM** | 1 GB | 2 GB+ |
| **Disco** | 10 GB | 30 GB |
| **GPU** | Básica | Cualquiera con repos |

## Gestor de paquetes

```bash
# Actualizar repos y sistema
sudo pacman -Syu

# Instalar paquete
sudo pacman -S paquete

# Buscar paquete
pacman -Ss termino

# Eliminar paquete
sudo pacman -Rns paquete
```

### Repositorios adicionales (AUR, COPR, PPAs...)
- AUR completo (via `yay` o `paru`)
- Repos oficiales parcheados de Artix (reemplazan los de Arch)

## Ciclo de lanzamiento

**Rolling release**: actualizaciones continuas directamente de los repos, sin versiones puntuales. La base sigue a Arch, así que los cambios de packages fechan continuamente.

## Actualización entre versiones mayores

No hay versiones mayores — se actualiza constantemente con `pacman -Syu`. Es un modelo continuo sin pasos de upgrade.

```bash
sudo pacman -Syu
```

Ver [[Actualización entre versiones mayores]].

## Instalación (resumen)

1. Descargar el ISO desde artixlinux.org (elige el init deseado)
2. Grabar a USB y arrancar
3. Usar el instalador gráfico (Calamares) o la instalación CLI con `basestrap`
4. Elegir el init (openrc/runit/s6/dinit) al descargar el ISO o en la instalación

### Post-instalación recomendada
- [ ] Configurar AUR (yay/paru)
- [ ] Activar el servicio del entorno gráfico según el init elegido (ej. `rc-update`, `ln -s /etc/runit/runsvdir/default`)
- [ ] Configurar red (dhcpcd, NetworkManager)
- [ ] Configurar firewall

## Comandos asociados

| Comando | Para qué |
|---|---|
| `sudo pacman -Syu` | Actualizar sistema |
| `sudo basestrap` | Instalar sistema base |
| `rc-update add` (openrc) | Activar servicio en arranque |
| `sv enable` (runit) | Activar servicio en arranque |
| `sudo pacman -S yay` | Instalar ayudante AUR |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Servicios no arrancan | Sintaxis de init distinta a systemd | Usar `rc-service`, `sv`, `s6-rc` según el init |
| Sin audio/gráficos | Falta configurar el servicio | Activar el servicio del entorno en el init elegido |
| Paquete espera systemd | Paquete no parcheado | Mirar en los repos de Artix o AUR por variante sin systemd |

## Comparativa con otras distros

| Aspecto | Artix Linux | Arch Linux | Devuan |
|---|---|---|---|
| **Facilidad** | Media | Baja | Media |
| **Rendimiento** | Muy alto (init ligero) | Muy alto | Alto |
| **Paquetes** | pacman/AUR | pacman/AUR | apt + deb |
| **Comunidad** | Nicho | Grande | Media |
| **Estabilidad** | Buena (rolling) | Buena | Muy buena |

## Notas de instalación propias
- Útil para quien quiere Arch pero evita systemd (por filosofía, rendimiento o curiosidad técnica).
- La documentación de Arch Wiki sirve en su mayoría, salvo todo lo relativo a systemd/unit.

## Enlaces externos
- [Sitio oficial](https://artixlinux.org/)
- [Wiki oficial](https://wiki.artixlinux.org/)
- [Wikipedia — Artix Linux](https://en.wikipedia.org/wiki/Artix_Linux)
- [Repositorio GitHub](https://github.com/artix-linux)
- [DistroWatch](https://distrowatch.com/table.php?distribution=artix)

## Ver también
- [[Arch Linux]] — distribución base
- [[AUR]] — repositorio de usuarios de Arch
- [[Proceso de Instalación General]] — instalación desde cero
- [[Actualización entre versiones mayores]] — upgrade de versión mayor
- [[s6 init]] — uno de los inits soportados

#distro