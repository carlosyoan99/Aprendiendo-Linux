---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: alta
---

# LXC y Contenedores del Sistema

## Definición

**LXC (LinuX Containers)** es una tecnología de **virtualización a nivel de sistema operativo** que permite ejecutar múltiples instancias de espacios de usuario aisladas —llamadas *jaulas*, *contenedores del sistema* o *Entornos Virtuales (EV)*— sobre un mismo kernel Linux.

A diferencia de [[Contenedores|Docker]] (contenedores de aplicación), **LXC crea contenedores que se comportan como máquinas virtuales ligeras**: cada uno tiene su propio **init**, sistema de archivos completo, red independiente y espacio de procesos.

LXC fue desarrollado inicialmente por **IBM** como parte de una colaboración para añadir espacios de nombres al kernel. Hoy es la base de tecnologías como [[Docker]] (en sus inicios), LXD y [[Proxmox VE]].

## LXC vs Docker vs Máquinas Virtuales

| Aspecto | LXC (contenedor sistema) | Docker (contenedor app) | KVM/QEMU (VM) |
|---|---|---|---|
| **Init propio** | ✅ Sí (systemd, openrc, etc.) | ❌ No (solo proceso único) | ✅ Sí |
| **Arranque** | Lento (~segundos, como un servidor) | Rápido (~ms, solo proceso) | Lento (~minutos, kernel propio) |
| **Aislamiento** | Kernel compartido + namespaces | Kernel compartido | Kernel propio |
| **Tamaño imagen** | 200 MB - 2 GB + | 5 - 500 MB | 2 - 20 GB + |
| **Uso típico** | VPS, hosting, entornos completos | Microservicios, CI/CD, apps cloud | Escritorios virtuales, SOs distintos |
| **Ecosistema** | LXD, [[Proxmox VE]], [[Incus]] | Docker Compose, Kubernetes | OpenStack, libvirt |

## Cómo funciona

LXC utiliza dos mecanismos del kernel Linux:

### 1. **Namespaces** — aislamiento de recursos
Cada contenedor ve su propia versión aislada de:

| Namespace | Aísla |
|---|---|
| **PID** | Árbol de procesos propio (PID 1 = init) |
| **Network** | Interfaces de red, IP, iptables, rutas |
| **Mount** | Sistema de archivos (`/`, `/proc`, `/sys` virtualizados) |
| **UTS** | Hostname y domain name |
| **IPC** | Memoria compartida, semáforos, colas de mensajes |
| **User** | UIDs/GIDs mapeados (root dentro = nobody fuera) |
| **Cgroup** | Límites de recursos (CPU, RAM, I/O) |

### 2. **Cgroups** — control de recursos
Cada contenedor tiene límites configurables en caliente:
- **CPU**: prioridad, afinidad, cuota
- **Memoria**: límite duro, límite blando, swap
- **I/O**: ancho de banda de disco
- **Disco**: cuota de bloques e inodos

## Comandos básicos de LXC

```bash
# Ver contenedores existentes
lxc-ls -f

# Crear un contenedor desde plantilla
lxc-create -n mi-contenedor -t download -- -d ubuntu -r jammy -a amd64

# Iniciar/detener
lxc-start -n mi-contenedor -d
lxc-stop -n mi-contenedor

# Acceder a la consola
lxc-attach -n mi-contenedor

# Ejecutar comando dentro
lxc-attach -n mi-contenedor -- systemctl status nginx

# Información del contenedor
lxc-info -n mi-contenedor

# Clonar contenedor
lxc-clone -o mi-contenedor -n clon-backup

# Eliminar
lxc-destroy -n mi-contenedor
```

Instalación:
```bash
# Debian/Ubuntu
sudo apt install lxc lxc-templates

# Arch Linux
sudo pacman -S lxc

# Fedora
sudo dnf install lxc lxc-templates
```

## LXD — el gestor moderno de LXC

**LXD** es una capa de gestión construida sobre LXC que proporciona:
- **API REST** (socket local y acceso remoto)
- **Imágenes optimizadas** (similar a Docker Hub)
- **Snapshot y migración en vivo**
- **Perfiles de configuración reutilizables**
- **Historial de operaciones**

```bash
# Inicializar LXD
sudo lxd init

# Lanzar contenedor
lxc launch ubuntu:22.04 mi-servidor

# Listar contenedores
lxc list

# Ejecutar comandos
lxc exec mi-servidor -- apt update

# Snapshot
lxc snapshot mi-servidor backup-previa

# Migrar a otro host
lxc move mi-servidor otro-host:
```

LXD es el motor de contenedores por defecto de [[Proxmox VE]] y de [[Incus]] (fork comunitario de LXD tras su adquisición por Canonical).

## OpenVZ — el predecesor

**OpenVZ** es una tecnología similar anterior a LXC, desarrollada por SWsoft/Parallels. Fue muy popular en **hosting compartido y VPS** durante los 2000.

### Diferencias clave con LXC

| Aspecto | OpenVZ | LXC |
|---|---|---|
| **Kernel** | Requiere kernel modificado específico | Kernel vanilla (mainline desde 2.6.29) |
| **Herramientas** | `vzctl`, `vzpkg` | `lxc-*`, `lxd` |
| **Estado actual** | Obsoleto (reemplazado por LXC/LXD) | Activo y en desarrollo |
| **Migración en vivo** | Sí (desde 2006) | Sí (vía LXD) |

### Comandos clásicos de OpenVZ

```bash
# Crear y arrancar EV
vzctl create 101 --ostemplate ubuntu-22.04
vzctl start 101

# Ejecutar comando
vzctl exec 101 apt update

# Entrar al EV
vzctl enter 101

# Configurar recursos
vzctl set 101 --ram 512M --swap 1G --save

# Detener y eliminar
vzctl stop 101
vzctl destroy 101
```

### /proc/user_beancounters

OpenVZ usaba un sistema de contadores de recursos visible desde dentro del contenedor:

```bash
cat /proc/user_beancounters
```

Esta salida mostraba: uso actual, uso máximo, barrera (soft limit), límite (hard limit) y fallos para cada recurso (memoria, objetos IPC, buffers de red, etc.).

## Escenarios de uso

### 1. Hosting y VPS
Cada cliente tiene su propio contenedor con acceso root completo. Alta densidad: cientos de contenedores en un servidor.

### 2. Consolidación de servidores
Migrar servidores infrautilizados a contenedores en un solo host físico. Ahorro en electricidad, espacio y administración.

### 3. Seguridad por aislamiento
Cada servicio (Apache, DNS, correo) en su propio contenedor. Un fallo de seguridad en uno no compromete los demás.

### 4. Desarrollo y pruebas
Entornos completos de distintas distribuciones sin reiniciar. Clonar un contenedor para probar cambios es cuestión de segundos.

```bash
lxc-clone -o ubuntu-dev -n ubuntu-test-v2
```

### 5. Educación
Cada alumno tiene su propio contenedor Linux. Se pueden recrear desde cero en minutos.

## Casos de éxito

- **Docker** usó LXC como runtime en sus primeras versiones (0.9 y anteriores) antes de migrar a libcontainer.
- [[Proxmox VE]] usa LXC (vía LXD) como su sistema de contenedores nativo, ofreciendo VMs y contenedores en la misma interfaz.
- **Empresas de hosting** como OVH, DigitalOcean y Linode usaron/han usado OpenVZ y LXC para sus planes VPS más económicos.
- **Incus** es el fork comunitario de LXD que continúa el desarrollo tras el cambio de licencia de Canonical.
- **Ubuntu Core** usa snap + LXD para dispositivos IoT.

## Alternativas

| Tecnología | Tipo | Estado |
|---|---|---|
| **Linux-VServer** | Contenedores sistema | Obsoleto (no usa namespaces modernos) |
| **FreeBSD Jails** | Contenedores BSD | Activo (solo FreeBSD) |
| **Solaris Zones** | Contenedores Solaris | Activo (solo Solaris/illumos) |
| **systemd-nspawn** | Contenedores ligeros | Activo (integrado en systemd) |

Ver [[systemd-nspawn]].

## Ver también

- [[Contenedores]] — concepto general de contenedores
- [[Docker]] — contenedores de aplicación vs sistema
- [[systemd-nspawn]] — contenedores nativos de systemd
- [[cgroups (control de recursos)]] — base técnica del control de recursos
- [[Virtualización (KVM QEMU libvirt)]] — VMs tradicionales
- [[Proceso de Arranque (GRUB initramfs kernel params)]]

## Enlaces externos

- [Página oficial de LXC](https://linuxcontainers.org/)
- [Página oficial de LXD](https://ubuntu.com/lxd)
- [Página oficial de Incus](https://linuxcontainers.org/incus/)
- [Proxmox VE — Contenedores](https://www.proxmox.com/en/proxmox-ve)
- [ArchWiki — LXC](https://wiki.archlinux.org/title/LXC)
- [OpenVZ (archivo histórico)](https://openvz.org/)

#concepto
