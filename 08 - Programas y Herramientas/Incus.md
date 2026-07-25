---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: programa
prioridad: media
---

# Incus

## Qué es

**Incus** es un gestor de **contenedores del sistema** y **máquinas virtuales**, sucesor comunitario de **LXD**. Es un *drop-in replacement* de LXD que ofrece la misma experiencia cloud-like para gestionar contenedores y VMs, pero sin las restricciones de licencia que Canonical impuso sobre LXD.

Incus es mantenido por el proyecto **Linux Containers** (el mismo equipo que creó LXD originalmente) y está licenciado bajo **Apache 2.0**.

```
┌─────────────────────────────────────────────────────┐
│                 Incus (CLI + API REST)               │
├─────────────────────────────────────────────────────┤
│  ┌─────────────────────┐  ┌─────────────────────┐   │
│  │  Contenedores (LXC)  │  │  Máquinas Virtuales  │   │
│  │  - Init completo     │  │  - KVM/QEMU          │   │
│  │  - Namespaces        │  │  - UEFI/BIOS         │   │
│  │  - Cgroups           │  │  - Virtio drivers    │   │
│  └─────────────────────┘  └─────────────────────┘   │
├─────────────────────────────────────────────────────┤
│               Kernel Linux + Host                    │
└─────────────────────────────────────────────────────┘
```

## Historia: el fork de LXD

En agosto de 2023, **Canonical** cambió la licencia de LXD de **Apache 2.0** a **AGPL-3.0** y exigió un **CLA (Contributor License Agreement)** para todas las contribuciones. Esto centralizó el control del proyecto en Canonical.

La comunidad de Linux Containers (los creadores originales de LXD) consideró que esto iba en contra del modelo colaborativo del proyecto y **forkeó LXD** creando **Incus**, manteniendo la licencia Apache 2.0 y sin CLA.

| Fecha | Evento |
|---|---|
| 2014 | Lanzamiento de LXD por Canonical |
| 2023-08 | Canonical relicencia LXD a AGPL-3.0 + CLA |
| 2023-08 | La comunidad fork bajo el nombre **Incus** |
| 2024 | Incus alcanza paridad de features con LXD |
| 2025+ | Incus continúa desarrollo activo; LXD queda en manos de Canonical |

## Incus vs LXD

| Aspecto | Incus | LXD |
|---|---|---|
| **Mantenido por** | Linux Containers (comunidad) | Canonical |
| **Licencia** | Apache 2.0 | AGPL-3.0 |
| **CLA** | No requiere | Requiere CLA |
| **CLI** | `incus` | `lxc` |
| **Distribución** | Paquetes nativos (deb, rpm, apk) | Principalmente Snap |
| **Relación con Canonical** | Independiente | Propietaria |
| **Features** | Mismos + desarrollo propio | Mismos |
| **Virtualización** | Contenedores + VMs | Contenedores + VMs |
| **Versión actual** | 6.x (2026) | 6.x (Canonical) |

## Instalación

Incus está disponible como **paquete nativo** en las principales distribuciones (no requiere Snap):

```bash
# Debian 12+ / Ubuntu 24.04+
sudo apt install incus

# Arch Linux
sudo pacman -S incus

# Fedora 39+
sudo dnf install incus

# openSUSE
sudo zypper install incus

# Alpine Linux
sudo apk add incus

# Desde GitHub (binario estático)
# https://github.com/lxc/incus/releases

# Desde Snap (versión oficial de Canonical, LXD, no Incus)
# sudo snap install lxd
```

## Inicialización

```bash
# Inicializar Incus (almacenamiento, red, etc.)
sudo incus admin init

# Responde las preguntas:
# - ¿Usar clustering? → no
# - ¿Tamaño del pool de almacenamiento? → default (20 GB)
# - ¿Tipo de almacenamiento? → dir, btrfs, zfs, lvm
# - ¿Red bridge? → incusbr0 (por defecto)
# - ¿IPv4/IPv6? → sí

# Ver configuración
incus info
```

## Comandos esenciales

```bash
# Listar imágenes disponibles
incus image list images:ubuntu
incus image list images:debian
incus image list images:alpine

# Lanzar contenedor
incus launch ubuntu:24.04 mi-servidor

# Lanzar máquina virtual
incus launch ubuntu:24.04 mi-vm --vm

# Listar instancias
incus list

# Ejecutar comandos dentro
incus exec mi-servidor -- apt update
incus exec mi-servidor -- systemctl status nginx

# Obtener shell
incus shell mi-servidor

# Información
incus info mi-servidor

# Detener / iniciar / reiniciar
incus stop mi-servidor
incus start mi-servidor
incus restart mi-servidor

# Eliminar
incus delete mi-servidor
incus delete --force mi-servidor   # si está en ejecución
```

## Snapshots y backups

```bash
# Crear snapshot
incus snapshot mi-servidor backup-pre-upgrade

# Listar snapshots
incus list snapshots
incus info mi-servidor

# Restaurar snapshot
incus restore mi-servidor backup-pre-upgrade

# Exportar instancia (backup completo)
incus export mi-servidor mi-servidor-backup.tar.gz

# Importar instancia
incus import mi-servidor-backup.tar.gz
```

## Perfiles (configuración reutilizable)

```bash
# Listar perfiles
incus profile list

# Crear perfil personalizado
incus profile create servidor-web

# Configurar recursos
incus profile set servidor-web limits.cpu 2
incus profile set servidor-web limits.memory 2GB
incus profile set servidor-web limits.memory.swap false

# Configurar red
incus profile device add servidor-web eth0 nic network=incusbr0

# Aplicar perfil a instancia
incus launch ubuntu:24.04 mi-web --profile servidor-web

# Editar perfil en YAML
incus profile edit servidor-web
```

## Red

```bash
# Listar redes
incus network list

# Crear red bridge
incus network create mi-red --type=bridge
incus network set mi-red ipv4.address=10.10.10.1/24

# Conectar instancia a red
incus network attach mi-red mi-servidor eth0

# Forwarding de puertos
incus config device add mi-servidor proxy-nginx proxy listen=tcp:0.0.0.0:8080 connect=tcp:127.0.0.1:80
```

## Almacenamiento

```bash
# Listar pools
incus storage list

# Crear pool con ZFS
incus storage create pool-zfs zfs source=/dev/sdX

# Crear pool con Btrfs
incus storage create pool-btrfs btrfs source=/dev/sdY

# Asignar pool a instancia
incus launch ubuntu:24.04 mi-servidor -s pool-zfs
```

## Clustering

Incus soporta clustering para escalar horizontalmente:

```bash
# Inicializar cluster (primer nodo)
incus admin init --auto --cluster

# Agregar nodo (desde otro servidor)
incus cluster add nodo2

# Listar miembros del cluster
incus cluster list

# Migrar instancia a otro nodo
incus move mi-servidor nodo2:
```

## Incus vs LXD vs Docker vs Proxmox

| Aspecto | Incus | LXD | Docker | Proxmox |
|---|---|---|---|---|
| **Enfoque** | Contenedores sistema + VMs | Contenedores sistema + VMs | Contenedores de app | VMs + Contenedores |
| **CLI** | `incus` | `lxc` | `docker` | Web + `qm` / `pct` |
| **Init en contenedor** | ✅ Sí (systemd) | ✅ Sí (systemd) | ❌ No | ✅ Sí |
| **VMs** | ✅ (KVM/QEMU) | ✅ (KVM/QEMU) | ❌ No | ✅ (KVM/QEMU) |
| **Licencia** | Apache 2.0 | AGPL 3.0 | Apache 2.0 | AGPL 3.0 |
| **Comunidad** | Linux Containers | Canonical | Docker Inc. | Proxmox SS |
| **Paquete nativo** | ✅ (deb, rpm) | ❌ (Snap) | ✅ | ✅ (ISO completo) |
| **API REST** | ✅ | ✅ | ✅ | ✅ |
| **Clustering** | ✅ Nativo | ✅ Nativo | Swarm/K8s | ✅ Nativo |
| **OCI/Docker** | ✅ Soporte parcial | ✅ Soporte parcial | ✅ Nativo | ❌ |

## Incus y Proxmox

Proxmox VE utiliza **LXC/LXD** para sus contenedores, no Incus. Sin embargo, Incus comparte la misma base tecnológica (LXC a bajo nivel + KVM/QEMU para VMs). La diferencia clave es que Proxmox es una plataforma completa (hypervisor, web UI, backup, clustering) mientras que Incus es una herramienta que se instala sobre cualquier distribución Linux estándar.

## Incus en contenedores Docker

Se puede ejecutar Incus dentro de un contenedor Docker privilegiado para gestionar contenedores anidados:

```bash
docker run --privileged -d --name incus -v /var/lib/incus linuxcontainers/incus
docker exec incus incus admin init --auto
docker exec incus incus launch ubuntu:24.04 inner-container
```

## Ver también

- [[LXC y Contenedores del Sistema]] — LXC como base tecnológica
- [[Contenedores]] — concepto general de contenedores
- [[Docker]] — contenedores de aplicación
- [[Virtualización (KVM QEMU libvirt)]] — VMs tradicionales
- [[Proxmox VE]] — plataforma de virtualización

## Enlaces externos

- [Incus — Página oficial](https://linuxcontainers.org/incus/)
- [Incus — GitHub](https://github.com/lxc/incus)
- [Incus Documentation](https://linuxcontainers.org/incus/docs/main/)
- [Incus Tutorial — First steps](https://linuxcontainers.org/incus/docs/main/tutorial/first_steps/)
- [Diferencias Incus vs LXD](https://linuxcontainers.org/incus/docs/main/incus_vs_lxd/)
- [Linux Containers — Proyecto](https://linuxcontainers.org/)
- [ArchWiki — Incus](https://wiki.archlinux.org/title/Incus)

#programa #contenedores
