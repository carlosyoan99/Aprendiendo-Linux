---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# QEMU

**QEMU** (Quick EMUlator) es el emulador de hardware que maneja la emulación de CPU, RAM, discos, redes, GPU y USB. Combinado con [[KVM]] (aceleración por hardware en `/dev/kvm`), ofrece rendimiento casi nativo para máquinas virtuales.

## Instalación

```bash
# Arch
sudo pacman -S qemu-desktop

# Debian/Ubuntu
sudo apt install qemu-system qemu-utils

# Fedora
sudo dnf install qemu
```

## Componentes principales

| Componente | Función |
|---|---|
| `qemu-system-x86_64` | Emulador de AMD64/Intel 64 |
| `qemu-img` | Herramienta de gestión de imágenes de disco |
| `qemu-utils` | Utilidades adicionales |
| `edk2-ovmf` | Firmware UEFI para VMs |

## qemu-img

### Crear discos

```bash
# qcow2 (con copia en escritura, snapshots, compresión)
qemu-img create -f qcow2 disco.qcow2 20G

# raw (más rápido, sin features)
qemu-img create -f raw disco.raw 20G
```

### Información y conversión

```bash
# Ver información del disco (tamaño real, virtual, backing chain)
qemu-img info disco.qcow2

# Ver cadena completa de backing files
qemu-img info --backing-chain overlay.qcow2

# Convertir formato
qemu-img convert -O qcow2 disco.raw disco.qcow2

# Backup completo (resuelve backing chain)
qemu-img convert -O qcow2 overlay.qcow2 backup-completo.qcow2

# Backup comprimido
qemu-img convert -c -O qcow2 overlay.qcow2 backup-comprimido.qcow2
```

### Backing chains (cadenas de respaldo)

Permiten crear discos en capas, compartiendo un disco base de solo lectura:

```bash
# Disco base (inmutable)
qemu-img create -f qcow2 base.qcow2 20G

# Overlay (escribe solo cambios, apunta al base)
qemu-img create -f qcow2 -b base.qcow2 -F qcow2 overlay.qcow2

# Fusionar overlay con base (commit)
qemu-img commit overlay.qcow2

# Rebasing: cambiar a qué base apunta un overlay
qemu-img rebase -b nuevo-base.qcow2 -F qcow2 overlay.qcow2
```

Útil para: snapshots rápidos, thin clones, plantillas compartidas.

## VirtIO drivers

Los drivers VirtIO ofrecen rendimiento casi nativo a los guests:

| Componente | Guest antiguo | Guest moderno (VirtIO) |
|---|---|---|
| **Disco** | IDE (lento) | VirtIO-blk o VirtIO-scsi |
| **Red** | e1000/rtl8139 (emulado) | virtio-net (casi nativo) |
| **GPU** | VGA/QXL | virtio-gpu |
| **Balloon** | No | virtio-balloon (RAM dinámica) |
| **RNG** | No | virtio-rng (entropía) |

```bash
# En XML de VM:
# Disco: <target dev='vda' bus='virtio'/>
# Red:   <model type='virtio'/>
```

## Ver también

- [[KVM]] — aceleración por hardware
- [[libvirt]] — capa de gestión (virsh, virt-manager)
- [[Virtualización (KVM QEMU libvirt)]] — índice del stack
- [[Proxmox VE]] — plataforma basada en KVM+QEMU

## Enlaces externos

- [Sitio oficial — QEMU](https://www.qemu.org/)
- [Wikipedia — QEMU](https://en.wikipedia.org/wiki/QEMU)

#programa #virtualizacion
