---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: alta
---

# Proxmox VE

## Qué es

**Proxmox VE** (Proxmox Virtual Environment) es una **plataforma completa de virtualización** de código abierto basada en **Debian** que integra dos tecnologías en una sola interfaz web:

- **KVM/QEMU** — para máquinas virtuales completas (cada una con su propio kernel)
- **LXC** (vía LXD) — para contenedores del sistema ligeros (comparten el kernel del host)

Proxmox es desarrollado por **Proxmox Server Solutions GmbH** (Austria) y está licenciado bajo **AGPL-3.0**. Es la alternativa open source más popular a VMware vSphere y Microsoft Hyper-V.

```
┌──────────────────────────────────────────────────────────┐
│               Proxmox VE — Interfaz Web                   │
│              (https://servidor:8006)                      │
├──────────────────────────────────────────────────────────┤
│  ┌──────────────────┐  ┌──────────────────┐              │
│  │      VMs          │  │   Contenedores    │              │
│  │    (KVM/QEMU)     │  │     (LXC/LXD)     │              │
│  ├──────────────────┤  ├──────────────────┤              │
│  │ - Windows/Linux   │  │ - Init completo   │              │
│  │ - Kernel propio   │  │ - Kernel compart. │              │
│  │ - GPU passthrough │  │ - Alta densidad   │              │
│  └──────────────────┘  └──────────────────┘              │
├──────────────────────────────────────────────────────────┤
│  ZFS / Ceph / LVM — Almacenamiento                       │
│  Corosync + PMG — Clustering + Backup                    │
├──────────────────────────────────────────────────────────┤
│               Debian GNU/Linux + Kernel Proxmox           │
└──────────────────────────────────────────────────────────┘
```

## Filosofía

- **Todo en uno**: hypervisor, almacenamiento, red, backups y clustering desde una sola interfaz web
- **Enterprise listo**: backups programados, alta disponibilidad (HA), migración en vivo, snapshots, firewalls
- **Open source**: sin costes de licencia (soporte comercial opcional por suscripción)
- **Debian base**: estable, con repositorios propios para kernels actualizados (5.15 LTS +)
- **API REST**: todo se puede automatizar via API o CLI (`qm` para VMs, `pct` para contenedores)

## Historia

| Versión | Fecha | Novedades |
|---|---|---|
| **Proxmox VE 1.0** | 2008 | Primera versión basada en Debian + OpenVZ |
| **Proxmox VE 2.0** | 2012 | Migración de OpenVZ a LXC |
| **Proxmox VE 3.0** | 2013 | Integración con ZFS, Ceph |
| **Proxmox VE 4.0** | 2015 | Basado en Debian Jessie, interfaz moderna |
| **Proxmox VE 5.0** | 2017 | Basado en Debian Stretch, mejoras en HA |
| **Proxmox VE 6.0** | 2019 | Basado en Debian Buster, Ceph Nautilus |
| **Proxmox VE 7.0** | 2021 | Basado en Debian Bullseye, kernel 5.13 |
| **Proxmox VE 8.0** | 2023 | Basado en Debian Bookworm, kernel 6.2 |
| **Proxmox VE 9.0** | 2026 | Kernel 6.12+, Ceph Reef, mejoras en backups |

## Características clave

### 1. Hipervisor KVM/QEMU

- Máquinas virtuales completas con aceleración por hardware
- Soporte para UEFI y Secure Boot
- GPU Passthrough (IOMMU) para gaming/renderizado
- VirtIO drivers para rendimiento casi nativo
- Snapshots y clones (linked clones para ahorrar espacio)
- Migración en vivo entre nodos del cluster

### 2. Contenedores LXC (vía LXD)

- Contenedores del sistema con init completo (systemd)
- Mucho más ligeros que VMs (cientos por nodo)
- Plantillas preconfiguradas (Ubuntu, Debian, CentOS, Arch, Alpine, etc.)
- Gestión de recursos por contenedor (CPU, RAM, disco, red)

### 3. Interfaz Web

- Acceso vía HTTPS en `https://servidor:8006`
- No requiere cliente — funciona en cualquier navegador moderno
- Consolas VNC/SPICE integradas para VMs
- Terminal para contenedores desde el navegador
- Gestión de usuarios, roles y permisos (RBAC)
- Soporte para autenticación LDAP, Active Directory, TOTP (2FA)

### 4. Almacenamiento

| Tipo | Características |
|---|---|
| **ZFS** | RAID-Z, snapshots, compresión, deduplicación, arco de caché |
| **Ceph** | Almacenamiento distribuido, replicación, auto-rebalanceo |
| **LVM** | Thin provisioning, snapshots lógicos |
| **NFS / iSCSI** | Almacenamiento externo |
| **Directorios** | Almacenamiento simple en disco local |

### 5. Clustering (HA)

- Hasta 32 nodos por cluster
- **Corosync** para comunicación entre nodos
- **HA (High Availability)**: si un nodo falla, las VMs/contenedores migran automáticamente a otro nodo
- **Migración en vivo**: mover VMs entre nodos sin tiempo de inactividad
- **Almacenamiento compartido** (Ceph) para clustering completo

### 6. Backups integrados

```bash
# Backups programados desde la interfaz web:
# Datacenter → Backup → Add backup job
# - Elegir nodo, almacenamiento, schedule
# - Compresión: gzip, lzo, zstd
# - Modo: snapshot (sin downtime) o stop

# Backups desde CLI:
vzdump 100 --dumpdir /backup           # backup de VM/CT con ID 100
vzdump 100 --mode snapshot --compress zstd

# Restaurar:
qmrestore /backup/vzdump-qemu-100.vma.lzo 100
```

### 7. Firewall

Proxmox incluye un firewall basado en **nftables** integrado:
- Reglas por datacenter, nodo, VM/contenedor
- IPSet para listas de IPs
- Rate limiting
- Logs de tráfico

## Instalación

```bash
# 1. Descargar ISO desde https://www.proxmox.com/downloads
# 2. Grabar en USB:
sudo dd if=proxmox-ve_*.iso of=/dev/sdX bs=4M status=progress

# 3. Arrancar e instalar:
#    - Particionado automático (ZFS, ext4, xfs)
#    - Configurar red (IP estática recomendada)
#    - Contraseña root
#    - Email (para notificaciones del sistema)

# 4. Acceder vía web:
#    https://IP_DEL_SERVIDOR:8006
#    Usuario: root
#    Contraseña: la que configuraste

# 5. Añadir repositorio sin suscripción (gratuito):
#    Tras instalar:
sed -i 's/^deb/#deb/' /etc/apt/sources.list.d/pve-enterprise.list
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" >> /etc/apt/sources.list.d/pve-no-sub.list
sudo apt update && sudo apt upgrade
```

## Comandos esenciales

### Gestión de VMs (qm)

```bash
# Listar VMs
qm list

# Crear VM
qm create 100 --name ubuntu-server --memory 2048 --net0 virtio,bridge=vmbr0
qm set 100 --scsi0 local-lvm:20
qm start 100

# Ciclo de vida
qm start 100               # encender
qm stop 100                # apagar (ACPI)
qm shutdown 100            # apagado ordenado
qm reboot 100              # reiniciar
qm reset 100               # reset en caliente
qm destroy 100             # eliminar

# Snapshots
qm snapshot 100 backup-pre
qm listsnapshot 100
qm rollback 100 backup-pre

# Migrar a otro nodo
qm migrate 100 nodo2 --online
```

### Gestión de contenedores (pct)

```bash
# Listar contenedores
pct list

# Crear contenedor desde plantilla
pct create 200 local:vztmpl/ubuntu-24.04-standard_24.04-1_amd64.tar.zst \
  --storage local-lvm --rootfs 8 --ostype ubuntu \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp

# Ciclo de vida
pct start 200
pct stop 200
pct shutdown 200
pct destroy 200

# Ejecutar comandos dentro
pct exec 200 -- apt update
pct enter 200                 # consola interactiva

# Snapshots
pct snapshot 200 antes-cambio
pct rollback 200 antes-cambio
```

### Cluster

```bash
# Crear cluster (en el primer nodo)
pvecm create mi-cluster

# Unir nodo al cluster (en cada nodo adicional)
pvecm add IP_DEL_PRIMER_NODO

# Ver estado del cluster
pvecm status
pvecm nodes
```

### Almacenamiento

```bash
# Listar almacenamiento
pvesm status

# Crear pool ZFS
zpool create pool /dev/sdX
pvesm add zfspool pool --pool pool --content images,rootdir

# Crear pool Ceph (en cada nodo)
pveceph install
pveceph init --network 10.10.10.0/24
pveceph createmon
pveceph osd create /dev/sdX
pvesm add cephfs cephfs --monitor-ips 10.10.10.1
```

## Proxmox vs alternativas

| Aspecto | Proxmox VE | VMware vSphere | Hyper-V | Incus | VirtualBox |
|---|---|---|---|---|---|
| **Tipo** | Plataforma completa | Plataforma completa | Plataforma completa | Herramienta CLI | Virtualización escritorio |
| **VMs** | ✅ KVM/QEMU | ✅ Propietario | ✅ Propietario | ✅ KVM/QEMU | ✅ Propietario |
| **Contenedores** | ✅ LXC | ❌ | ❌ | ✅ LXC | ❌ |
| **Interfaz web** | ✅ Nativa | ✅ vCenter | ✅ Windows Admin Center | ❌ (CLI) | ❌ (GUI local) |
| **Clustering HA** | ✅ Corosync + Ceph | ✅ vSAN/VSAN | ✅ Failover Cluster | ✅ Nativo | ❌ |
| **Backups** | ✅ Integrados (vzdump) | ✅ Veeam (externo) | ✅ DPM (externo) | ❌ (manual) | ❌ (snapshots) |
| **Licencia** | AGPL-3.0 (gratis) | Propietaria ($$$) | Windows Server ($$) | Apache 2.0 | GPL-2.0 |
| **Soporte comercial** | ✅ Por suscripción | ✅ Por contrato | ✅ Por contrato | ❌ | ❌ |
| **API REST** | ✅ Completa | ✅ vSphere API | ✅ WMI/API | ✅ | ❌ |
| **ZFS/Ceph** | ✅ Integrados | ❌ (VMware FS) | ❌ (NTFS/ReFS) | ❌ (manual) | ❌ |
| **Ideal para** | Servidores, homelab, production | Empresas grandes, entornos VMware | Entornos Windows | Usuarios avanzados, dev/test | Desktop, pruebas |

## Proxmox en homelab

Proxmox es la opción más popular para **homelabs** (servidores caseros de aprendizaje/pruebas):

```bash
# Requisitos mínimos recomendados:
# - CPU: x86_64 con virtualización (cualquier Intel Core 4ª gen+ o AMD Ryzen)
# - RAM: 8 GB mínimo, 16 GB+ recomendado
# - Disco: 64 GB+ (SSD recomendado para ZFS)
# - Red: 1 Gbps

# Instalación típica en homelab:
# 1. Instalar Proxmox en un PC/servidor dedicado
# 2. Crear pool ZFS con mirror de 2 SSDs
# 3. Configurar backup semanal a disco externo/NAS
# 4. Desplegar VMs: router (pfSense/OPNsense), NAS (TrueNAS), servidor de medios (Jellyfin)
```

## Proxmox Backup Server (PBS)

**PBS** es un producto complementario de Proxmox para backups centralizados:

- **Deduplicación**: solo guarda bloques únicos, ahorra 90%+ de espacio
- **Compresión**: zstd configurable
- **Cifrado**: backups cifrados del lado del cliente
- **Verificación**: checksum automático para detectar corrupción
- **Incremental**: solo transfiere bloques cambiados desde el último backup
- **Integración directa** con Proxmox VE

```bash
# PBS se instala como una máquina virtual o dedicada
# Se configura desde la interfaz web de Proxmox VE:
# Datacenter → Storage → Add → Proxmox Backup Server
```

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| **No hay repositorio enterprise** | Sin suscripción paga | Cambiar a `pve-no-subscription` |
| **Warning \"No subscription\"** | Sin suscripción en el repositorio | Añadir `pve-no-sub` o ignorar |
| **ZFS consume mucha RAM** | ARC usa hasta el 50% de RAM | Limitar ARC: `echo 4G > /sys/module/zfs/parameters/zfs_arc_max` |
| **Ceph consume CPU** | Procesos de monitoreo | Ajustar parámetros de Ceph |
| **Migración en vivo lenta** | Red lenta o disco ocupado | Usar red dedicada 10 Gbps para migraciones |
| **No arranca VM UEFI** | Falta firmware OVMF | `apt install proxmox-ve` lo incluye |

## Ver también

- [[Incus]] — gestor de contenedores/VMs similar pero sin interfaz web
- [[Virtualización (KVM QEMU libvirt)]] — base tecnológica de Proxmox
- [[LXC y Contenedores del Sistema]] — LXC como base de los contenedores Proxmox
- [[Docker]] — contenedores de aplicación (pueden correr dentro de Proxmox)
- [[Backups (borg restic duplicity rsync)]] — estrategias de backup complementarias
- [[RAID (mdadm)]] — redundancia de discos
- [[Sistemas de Archivos]] — ZFS como sistema de archivos principal

## Enlaces externos

- [Proxmox VE — Página oficial](https://www.proxmox.com/en/proxmox-ve)
- [Proxmox VE Documentation](https://pve.proxmox.com/wiki/Main_Page)
- [Proxmox VE Downloads](https://www.proxmox.com/en/downloads)
- [Proxmox Backup Server](https://www.proxmox.com/en/proxmox-backup-server)
- [Proxmox VE YouTube (tutoriales)](https://www.youtube.com/@Proxmox)
- [Proxmox VE Community Forum](https://forum.proxmox.com/)
- [ArchWiki — Proxmox](https://wiki.archlinux.org/title/Proxmox)
- [Proxmox VE API — Documentación](https://pve.proxmox.com/wiki/Proxmox_VE_API)

#programa #virtualizacion #servidores
