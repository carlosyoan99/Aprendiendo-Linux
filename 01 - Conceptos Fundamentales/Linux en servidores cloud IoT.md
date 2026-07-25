---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: concepto
prioridad: alta
---

# Linux en servidores, cloud e IoT

## Descripción general

Linux es el sistema operativo más versátil del mundo: impulsa desde servidores empresariales hasta routers caseros, pasando por la nube pública y dispositivos IoT. Entender sus diferentes variantes y casos de uso es clave para saber qué distribución y configuración elegir según el escenario.

```bash
┌──────────────────────────────────────────────────────────┐
│                    Linux en el mundo                       │
├────────────────┬─────────────────┬───────────────────────┤
│   Servidores    │     Cloud        │        IoT           │
│  (69% del       │  (90%+ de la     │  (75%+ de            │
│   mercado web)  │   nube pública)  │   dispositivos IoT)  │
├────────────────┴─────────────────┴───────────────────────┤
│  Distros típicas:                                         │
│  Ubuntu Server · Debian · RHEL · Alpine · Arch · Yocto    │
└──────────────────────────────────────────────────────────┘
```

---

## 1. Linux en servidores

### Por qué Linux domina los servidores

| Motivo | Explicación |
|---|---|
| **Estabilidad** | Los servidores Linux pueden funcionar años sin reiniciar |
| **Seguridad** | Permisos, SELinux/AppArmor, gestión de usuarios madura |
| **Rendimiento** | Bajo overhead, gestión de recursos eficiente |
| **Coste** | Sin licencias (a diferencia de Windows Server) |
| **Ecosistema** | Herramientas maduras para web, DBs, contenedores |
| **Control remoto** | SSH, gestión desde terminal sin GUI |

### Distribuciones para servidores

| Distro | Ideal para | Gestor de paquetes | Ciclo de vida |
|---|---|---|---|
| **Ubuntu Server LTS** | Propósito general, fácil | apt | 5 años (10 con ESM) |
| **Debian Stable** | Máxima estabilidad | apt | 3-5 años |
| **RHEL** / **Rocky Linux** / **AlmaLinux** | Enterprise, soporte oficial | dnf | 10 años |
| **Alpine Linux** | Contenedores, minimalista | apk | ~1 año |
| **openSUSE Leap** | SUSE empresarial | zypper | ~3 años |
| **Arch Linux** | Rolling, servers personales | pacman | Rolling |

```bash
# Un servidor Linux típico sin GUI usa:
# - ~200-500 MB RAM en idle
# - ~2-5 GB de disco
# - Sin entorno gráfico (multi-user.target)
```

### Servicios comunes en servidores

```bash
# Servicios que puedes encontrar en un servidor Linux:

# Web: Nginx / Apache
sudo systemctl status nginx

# Base de datos: PostgreSQL / MySQL / MariaDB
sudo systemctl status postgresql

# Aplicaciones: Node.js, Python, Go, Java
systemctl --user status mi-app

# Contenedores: Docker / Podman
sudo systemctl status docker

# Monitorización: Prometheus + node_exporter
sudo systemctl status prometheus
```

### Hardening básico para servidores

```bash
# 1. SSH hardening
sudo nano /etc/ssh/sshd_config
#   Port 2222                    # cambiar puerto
#   PermitRootLogin no           # prohibir login root
#   PasswordAuthentication no    # solo claves SSH
#   PubkeyAuthentication yes
sudo systemctl restart sshd

# 2. Firewall
sudo ufw allow 2222/tcp           # puerto SSH personalizado
sudo ufw allow 80/tcp              # HTTP
sudo ufw allow 443/tcp             # HTTPS
sudo ufw enable

# 3. Fail2ban (protección contra fuerza bruta)
sudo apt install fail2ban
sudo systemctl enable fail2ban

# 4. Automatic updates (solo seguridad)
sudo apt install unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

---

## 2. Linux en la nube (Cloud)

### Proveedores cloud y sus imágenes Linux

| Proveedor | Imágenes Linux oficiales | Peculiaridades |
|---|---|---|
| **AWS (EC2)** | Amazon Linux 2/2023, Ubuntu, RHEL, Debian | Amazon Linux optimizado para AWS |
| **Google Cloud** | Ubuntu, Debian, RHEL, Rocky, Container-Optimized OS | COS optimizado para GKE |
| **Azure** | Ubuntu, Debian, RHEL, CentOS (legacy) | Azure Linux propio |
| **DigitalOcean** | Ubuntu, Debian, Fedora, Arch | Imágenes optimizadas, one-click apps |
| **Linode / Akamai** | Ubuntu, Debian, Alpine, Arch | Muy similar a DigitalOcean |
| **Vultr** | Ubuntu, Debian, Arch, FreeBSD | Amplia variedad |

### Linux en cloud: diferencias con servidor físico

```bash
# 1. Sin pantalla física ni teclado
# Todo se gestiona por SSH o consola web

# 2. Discos efímeros vs persistentes
lsblk                               # /dev/sda1 = disco raíz (persistente)
# /dev/nvme0n1 = disco efímero (se borra al apagar)
# Los datos importantes van en volúmenes EBS / Persistent Disk

# 3. IPs elásticas
# La IP pública puede cambiar al reiniciar
# Se asigna una IP elástica/fija para mantenerla

# 4. Metadata del cloud
# AWS: curl http://169.254.169.254/latest/meta-data/
# GCP: curl http://metadata.google.internal/computeMetadata/v1/
# Azure: curl http://169.254.169.254/metadata/instance?api-version=2021-02-01
```

### Cloud-init (configuración al arranque)

La mayoría de imágenes cloud usan **cloud-init** para configurarse al primer arranque:

```yaml
# user-data.yml — ejemplo de cloud-init
#cloud-config
package_upgrade: true
packages:
  - nginx
  - docker.io
  - fail2ban
users:
  - name: carlos
    ssh-authorized-keys:
      - ssh-rsa AAAAB3NzaC1yc2E... usuario@local
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
```

```bash
# Pasar cloud-init a un proveedor cloud
# Cada proveedor tiene su forma:
# AWS: pasado como User Data al lanzar instancia
# GCP: añadido como metadata
# DigitalOcean: en el panel de creación del droplet
```

### Contenedores en la nube

```bash
# La mayoría de servidores cloud modernos corren contenedores
# En vez de instalar directamente en el SO:

# Docker: la opción más común
docker run -d -p 80:80 nginx

# Kubernetes: orquestación de contenedores
# GKE (Google), EKS (AWS), AKS (Azure)

# Imágenes optimizadas para contenedores:
# - Alpine Linux (~5 MB)
# - Distroless (Google, ~15 MB)
# - Ubuntu minimal (~30 MB)
```

---

## 3. Linux en IoT (Internet of Things)

### Por qué Linux en IoT

| Ventaja | Ejemplo |
|---|---|
| Drivers y kernel maduros | Soporte para GPIO, I2C, SPI, UART |
| Gestión de energía | Suspend-to-RAM, frequency scaling |
| Networking | WiFi, Bluetooth, Zigbee, LoRa |
| Seguridad | Actualizaciones OTA, cifrado, firewalls |
| Herramientas | Python, Node.js, C/C++ para desarrollo rápido |

### Distribuciones para IoT

| Distribución | Ideal para | Tamaño | Gestor |
|---|---|---|---|
| **Raspberry Pi OS** | Raspberry Pi, educación | ~2 GB | apt |
| **Alpine Linux** | Dispositivos con poca RAM | ~5 MB | apk |
| **Yocto Project** | Dispositivos embedded personalizados | Personalizable | bitbake |
| **Buildroot** | Sistemas minimalistas | ~2 MB | make |
| **Ubuntu Core** | Snap packages, actualizaciones OTA | ~500 MB | snap |
| **OpenWrt** | Routers y Access Points | ~10 MB | opkg |
| **Armbian** | Single Board Computers (SBCs) no-RPi | ~1 GB | apt |
| **Fedora IoT** | IoT con ecosistema Fedora | ~1 GB | rpm-ostree |

### Dispositivos populares

```bash
# Raspberry Pi (el más popular)
# Modelos: Pi Zero W, Pi 4/5, Pi 400
# SO: Raspberry Pi OS (Debian-based)
# Usos: servidor doméstico, media center, retro gaming, domótica

# Otras SBCs populares:
# - Orange Pi (más barato que RPi)
# - ODROID (más potente que RPi)
# - BeagleBone Black (GPIO industriales)
# - Jetson Nano (AI/ML en el edge)

# Routers con OpenWrt:
# - TP-Link Archer C7
# - Linksys WRT32X
# - Raspberry Pi como router
```

### IoT: aplicaciones típicas

```bash
# Servidor multimedia (RPi + Kodi/OSMC)
# Domótica (Home Assistant, OpenHAB)
# Monitorización (Prometheus node_exporter en RPi)
# DNS local (Pi-hole)
# VPN casera (WireGuard en RPi)
# NAS personal (OpenMediaVault)
# Control industrial (PLC Linux, modbus)
```

### Ejemplo: Pi-hole (bloqueo de anuncios a nivel DNS)

```bash
# Instalar en Raspberry Pi
curl -sSL https://install.pi-hole.net | bash

# Configurar el router para usar el RPi como DNS
# Todas las peticiones DNS pasan por Pi-hole
# Los anuncios y rastreadores se bloquean antes de llegar al dispositivo

# Gestión desde web: http://pi.hole/admin
# o por CLI:
pihole -g                      # actualizar listas de bloqueo
pihole status                  # estado
pihole -up                     # actualizar Pi-hole
```

---

## Tabla comparativa de usos

| Aspecto | Servidores | Cloud | IoT |
|---|---|---|---|
| **RAM típica** | 2-64 GB | 0.5-256 GB | 0.05-8 GB |
| **Disco** | 20 GB - 10 TB | 8 GB - 10 TB | 2-128 GB (SD/eMMC) |
| **CPU** | x86_64 (Intel/AMD) | x86_64, ARM (Graviton) | ARM, RISC-V |
| **GUI** | ❌ Sin GUI | ❌ Sin GUI | ❌ Sin GUI (HDMI opcional) |
| **Gestión** | SSH, Ansible, Puppet | Web console, APIs | OTA, serial, SSH |
| **Uptime** | Años con parches en caliente | Meses (las instancias se reemplazan) | Meses-años |
| **Actualización** | Controlada, planificada | Rolling o inmutables | OTA con validación |
| **Coste** | Hardware propio + electricidad | Por hora/segundo de uso | Por dispositivo + mantenimiento |

## Enlaces externos

- [DigitalOcean Tutorials](https://www.digitalocean.com/community/tutorials) — guías de servidores Linux
- [Linux Foundation Training](https://training.linuxfoundation.org/) — certificaciones Linux
- [Raspberry Pi Foundation](https://www.raspberrypi.com/) — documentación oficial IoT
- [OpenWrt](https://openwrt.org/) — firmware Linux para routers
- [Yocto Project](https://www.yoctoproject.org/) — Linux para embedded

## Ver también

- [[SSH]] — acceso remoto a servidores
- [[Firewall]] — protección de servidores
- [[Contenedores]] — Docker, Podman, LXC
- [[WireGuard VPN]] — acceso remoto seguro
- [[Virtualización (KVM QEMU libvirt)]] — servidores virtualizados
- [[Monitorización (Prometheus node_exporter)]] — monitorización de servidores
- [[Redes Basicas]] — networking en servidores

#concepto #servidores
