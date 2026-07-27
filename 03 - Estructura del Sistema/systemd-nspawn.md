---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: baja
---

# systemd-nspawn

## Qué es

**systemd-nspawn** (namespace spawn) es un contenedor ligero nativo de [[systemd]] que crea un entorno aislado similar a un contenedor Docker, pero sin necesidad de demonios adicionales ni configuraciones complejas. Está disponible en cualquier sistema con systemd (la gran mayoría de distros modernas). Es como un "chroot con esteroides": ofrece aislamiento de procesos, sistema de archivos, red y hostname.

A diferencia de Docker, no construye imágenes a partir de Dockerfiles — trabaja con árboles de directorios (pueden ser instalaciones completas de una distro).

## Instalación

```bash
# systemd-nspawn viene CON systemd — no hay que instalar nada extra:
which systemd-nspawn                     # debería existir en cualquier sistema con systemd

# En distros que separan los paquetes de systemd-nspawn:
# Debian/Ubuntu
sudo apt install systemd-container

# Arch
sudo pacman -S systemd                   # ya viene incluido

# Fedora
sudo dnf install systemd-container
```

## Uso básico

```bash
# 1. Crear un árbol de directorios con una distro mínima
sudo debootstrap stable /var/lib/machines/debian  # instalar Debian minimal en un directorio

# 2. Iniciar el contenedor
sudo systemd-nspawn -D /var/lib/machines/debian   # arranca y te da una shell dentro

# 3. Opciones útiles al arrancar
sudo systemd-nspawn -D /var/lib/machines/debian --boot        # arrancar con init completo
sudo systemd-nspawn -D /var/lib/machines/debian --private-network  # red aislada
sudo systemd-nspawn -D /var/lib/machines/debian -b --bind=/home/usuario:/mnt/host  # montar directorio
```

## Gestión con machinectl

```bash
# machinectl es la herramienta de gestión de contenedores nspawn
machinectl list-images                   # imágenes disponibles
machinectl list                          # contenedores en ejecución
sudo machinectl start debian             # iniciar contenedor
sudo machinectl login debian             # abrir shell dentro
sudo machinectl poweroff debian          # apagar contenedor
sudo machinectl enable debian            # iniciar automáticamente en boot
```

## Configuración persistente

```ini
# /etc/systemd/nspawn/debian.nspawn
[Exec]
Boot=yes
PrivateNetwork=no

[Files]
Bind=/home/usuario/compartido:/mnt/compartido

[Network]
VirtualEthernet=yes
Bridge=br0
```

## Cuándo usar systemd-nspawn vs Docker

| Situación | Recomendado |
|---|---|
| Aislar una app para desarrollo/producción | Docker |
| Probar otra distro en el mismo equipo | systemd-nspawn |
| Entorno tipo "VM ligera" sin hypervisor | systemd-nspawn |
| Necesitas imágenes portátiles y registry | Docker |
| Ya usas systemd y no quieres otro daemon | systemd-nspawn |
| Despliegue multi-servidor (orquestación) | Docker + Kubernetes |

## Alternativas

- [[Docker]] — contenedores para aplicaciones, ecosistema más grande
- Podman — como Docker pero sin daemon
- `chroot` — el ancestro, sin aislamiento de procesos/red

## Ver también

- [[systemd]]
- [[Contenedores]]
- [[Docker]]
- [[Alpine Linux]] — buena candidata para contenedores nspawn por su tamaño mínimo

## Enlaces externos

- [Wikipedia — systemd-nspawn](https://en.wikipedia.org/wiki/Systemd#systemd-nspawn)
- [Arch Wiki — systemd-nspawn](https://wiki.archlinux.org/title/Systemd-nspawn)
- [systemd manual — nspawn](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html)

#sistema
