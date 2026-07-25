---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: zypper (rpm)
base: independiente
---

# openSUSE

## Filosofía / público objetivo

Distro alemana con dos ediciones muy distintas según el caso de uso, y una herramienta de administración propia (**YaST**) que centraliza casi toda la configuración del sistema con GUI y terminal. Es una de las distros más veteranas (1994), con gran tradición en Europa.

## Ediciones

| Edición | Tipo | Ideal para |
|---|---|---|
| **Leap** | Release fija (~cada año) | Escritorio estable, servidores, conservadores |
| **Tumbleweed** | Rolling release continuo | Entusiastas, desarrolladores, usuarios que quieren lo último |

Leap usa paquetes compartidos con **SUSE Linux Enterprise (SLE)**, lo que le da una base extremadamente probada. Tumbleweed es rolling pero con un proceso automatizado de testeo (OpenQA) que detecta regresiones antes de publicar las actualizaciones — más seguro que el rolling de Arch en ese sentido.

## Gestor de paquetes: zypper

```bash
sudo zypper install <paquete>          # instalar
sudo zypper update                     # actualizar
sudo zypper search <termino>           # buscar
sudo zypper remove <paquete>           # eliminar
sudo zypper info <paquete>             # info detallada
sudo zypper ps                         # procesos que usan librerías actualizadas (pedir reinicio)
sudo zypper patch                      # solo parches de seguridad (en lugar de update completo)

# Añadir repositorio
sudo zypper addrepo <url> nombre
sudo zypper lr                         # listar repositorios
```

## YaST (Yet another Setup Tool)

Es el centro de control de openSUSE — permite configurar casi todo sin terminal:

```bash
sudo yast                              # lanzar YaST en modo GUI (si hay DE)
sudo yast2                             # versión GTK
sudo yast                              # modo terminal si no hay DE
```

Desde YaST se puede configurar:
- Particionado y gestor de volúmenes
- Red (interfaces, DNS, firewall)
- Usuarios y grupos
- Repositorios de software
- Servicios (habilitar/deshabilitar systemd)
- Impresoras y escáneres
- Arranque (GRUB, EFI)

## Snapper + Btrfs (rollback integrado)

openSUSE (especialmente Tumbleweed) configura **snapshots automáticos de Btrfs** antes de cada actualización / instalación de paquetes:

```bash
snapper list                           # ver snapshots disponibles
sudo snapper -c root create -d "antes de experimento"  # crear snapshot manual
snapper status XX..YY                  # diferencias entre dos snapshots
```

Si una actualización rompe el sistema:
1. Reiniciar y elegir un snapshot anterior en el menú de GRUB (aparece automáticamente).
2. O desde el sistema en funcionamiento: `sudo snapper rollback XX`

## OBS (Open Build System)

Plataforma de empaquetado que permite compilar paquetes para múltiples distros (openSUSE, Fedora, Debian, Ubuntu, Arch, etc.) desde un solo archivo de especificaciones. Es el motor detrás de build.opensuse.org.

## Ciclo de lanzamiento

| Edición | Ciclo |
|---|---|
| **Leap** | ~1 año entre releases, ~4 años de soporte |
| **Tumbleweed** | Rolling continuo, actualizaciones múltiples por semana |

## Notas de instalación propias

## Enlaces externos

- [Wikipedia — openSUSE](https://en.wikipedia.org/wiki/OpenSUSE)
- [Sitio oficial](https://www.opensuse.org/)
- [Organización en GitHub](https://github.com/opensuse)

## Ver también

- [[Rocky Linux]] — otra distro empresarial (pero RHEL-based)
- [[Fedora]] — otra distro con adopción temprana de tecnologías
- [[Gestores de Paquetes]]
- [[Cron y Systemd Timers]]

#distro
