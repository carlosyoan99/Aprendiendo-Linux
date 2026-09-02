---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: apt (Debian)
base: Debian
modelo_lanzamiento: Fixed (con versiones puntuales tipo Debian, incl. LTS)
init: sysvinit | openrc | runit | s6 (sin systemd)
arquitecturas:
  - x86_64
  - ARM
  - RISC-V
---

# Devuan

> Distribución basada en **Debian** que elimina por completo **systemd**, ofreciendo los repositorios APT de Debian con `sysvinit` (u openrc/runit/s6) como gestor de servicios, manteniendo la estabilidad de Debian para quienes prefieren init clásicos.

## Filosofía / público objetivo

Devuan nació de la controversia de systemd en Debian: es un **fork de Debian sin systemd**, manteniendo compatibilidad binaria con la mayoría del ecosistema Debian.

- **APT y repos de Debian** intactos (paquetes compilados, en su mayoría)
- **Inits alternativos**: sysvinit (por defecto), openrc, runit, s6
- **POSIX-friendly** y de filosofía minimalista/unix
- **Configuración clásica** (`/etc/rc*.d`, `init.d`), sin units
- **Estabilidad y modelo de lanzamiento de Debian** (testing/stable)

Va dirigida a aquellos que quieren Debian estable pero rechazan systemd por filosofía, rendimiento o compatibilidad; también a servidores y entornos embebidos pequeños donde un init ligero es deseable.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Debian (forja Debian Adapted Packages, eLLa) |
| **Gestor de paquetes** | `apt` / `dpkg` |
| **Init** | sysvinit (por defecto), openrc, runit o s6 |
| **Modelo** | Fixed release (Devuan 5 = "Daedalus", etc.) |
| **Arquitecturas** | `x86_64`, `ARM` (raspi), `RISC-V` |
| **Entorno por defecto** | XFCE en imágenes con escritorio; opcional GNOME-compatible |
| **Instalador** | Instalador Debian (preseed/curses) |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Cualquier soportado | Dual-core |
| **RAM** | 512 MB | 1-2 GB+ |
| **Disco** | 5 GB | 20 GB+ |
| **GPU** | Básica | Cualquiera compatible |

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
- Repos Debian estándar (Devuan usa los Debian Adapted Packages de Debian)
- `dpkg`/`apt` nativos; sin repos propios de grandes forjas

## Ciclo de lanzamiento

**Fixed release** siguiendo el ritmo de Debian: cada release tiene nombre de código (p. ej. Daedalus), ciclo estable y período LTS. El modelo `stable`/`testing`/`unstable` de Debian se mantiene.

## Actualización entre versiones mayores

Se actualiza igual que Debian, cambiando el repositorio de `stable` a la nueva versión en `sources.list` y ejecutando `dist-upgrade`.

```bash
sudo sed -i 's/oldcodename/newcodename/g' /etc/apt/sources.list
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt autoremove
```

Ver [[Actualización entre versiones mayores]].

## Instalación (resumen)

1. Descargar la ISO (Devuan Daedalus u ed.) desde devuan.org
2. Grabar a USB y arrancar
3. Seguir el instalador Debian (instalación gráfica o de texto)
4. Elegir init durante la instalación; el sistema arranca con sysvinit u openrc

### Post-instalación recomendada
- [ ] Configurar zona horaria y locale
- [ ] Instalar entorno de escritorio si no se eligió
- [ ] Configurar red (NetworkManager o interfaces clásicas)
- [ ] Configurar firewall

## Comandos asociados

| Comando | Para qué |
|---|---|
| `update-rc.d` | Activar/desactivar servicio en sysvinit |
| `service servicename status` | Ver estado de servicio |
| `sudo apt update && upgrade` | Actualizar |
| `systemctl` | NO disponible (sin systemd) |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Gestión de servicios confusa | Cambio de systemd a sysvinit | Usar `update-rc.d`, `service`, `rc.conf` |
| GNOME no empieza | Depende de logind | Instalar un entorno sin systemd o usar one-shot |
| Falta un servicio | No activado en runlevel | `update-rc.d nombre defaults` |

## Comparativa con otras distros

| Aspecto | Devuan | Debian | Artix Linux |
|---|---|---|---|
| **Facilidad** | Media | Media | Media |
| **Rendimiento** | Alto (init ligero) | Alto | Muy alto |
| **Paquetes** | apt | apt | pacman/AUR |
| **Comunidad** | Media | Gigante | Nicho |
| **Estabilidad** | Muy buena (fixed) | Muy buena | Buena (rolling) |

## Notas de instalación propias
- Su principal valor es poder quedarse en Debian sin systemd (sysvinit clásico).
- Compatibilidad binaria con Debian es excelente para runtime.

## Enlaces externos
- [Sitio oficial](https://www.devuan.org/)
- [Wiki oficial](https://dev1.tv/wiki/)
- [Wikipedia — Devuan](https://en.wikipedia.org/wiki/Devuan)
- [GitLab oficial](https://git.devuan.org/)
- [DistroWatch](https://distrowatch.com/table.php?distribution=devuan)

## Ver también
- [[Debian]] — distribución base
- [[Actualización entre versiones mayores]] — upgrade de versión mayor
- [[Proceso de Instalación General]] — instalación desde cero

#distro