---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# Virtualización con KVM/QEMU y libvirt — Índice

Stack de virtualización nativo de Linux. KVM acelera por hardware, QEMU emula dispositivos, libvirt gestiona todo.

```
┌──────────────────────────────────────────────┐
│  virt-manager (GUI)     virsh (CLI)           │
│           ↓                     ↓             │
│              libvirt (libvirtd)               │
├──────────────────────────────────────────────┤
│  QEMU (emulación de hardware)                 │
│         ↓                                    │
│  KVM (aceleración por hardware en /dev/kvm)   │
├──────────────────────────────────────────────┤
│  Hardware real (CPU con virtualización)       │
└──────────────────────────────────────────────┘
```

## Componentes del stack

| Componente | Rol | Instalación |
|---|---|---|
| [[KVM]] | Hipervisor del kernel (módulo kvm, /dev/kvm) | Incluido en el kernel Linux |
| [[QEMU]] | Emulador de hardware (CPU, RAM, discos, red, GPU) | `qemu-system`, `qemu-utils` |
| [[libvirt]] | Capa de gestión (virsh, virt-manager, virt-viewer) | `libvirtd`, `virt-manager` |

## Instalación conjunta

```bash
# Arch
sudo pacman -S virt-manager qemu-desktop libvirt edk2-ovmf dnsmasq iptables-nft
sudo systemctl enable --now libvirtd

# Fedora
sudo dnf install @virtualization
sudo systemctl enable --now libvirtd

# Debian/Ubuntu
sudo apt install virt-manager virt-viewer qemu-system libvirt-daemon-system qemu-utils
sudo systemctl enable --now libvirtd

sudo usermod -aG libvirt $USER
```

## Alternativas

| Herramienta | Diferencias con KVM/libvirt |
|---|---|
| **VirtualBox** | GUI amigable, más lento, no usa KVM por defecto |
| **VMware Workstation** | Propietario, buen soporte GPU, caro |
| **Docker/Podman** | Comparten kernel, más ligeros, no ejecutan otro kernel |
| **Vagrant** | Automatización sobre VirtualBox/libvirt (VMs como código) |
| [[Proxmox VE]] | Distribución completa basada en KVM + LXC, interfaz web |
| **Xen** | Hipervisor tipo 1, usado en la nube (AWS) |
| [[Incus]] | Contenedores + VMs, API REST, sin interfaz web |

## Ver también

- [[Docker]] — contenedores vs VMs
- [[Incus]] — gestión de contenedores y VMs
- [[Proxmox VE]] — plataforma de virtualización completa
- [[Contenedores]] — conceptos generales
- [[Redes Basicas]] — bridges, NAT, subnets
- [[RAID (mdadm)]] — almacenamiento redundante
- [[Sistemas de Archivos]] — ZFS, Btrfs para pools de almacenamiento
- [[Módulos del kernel (lsmod modprobe blacklist)]] — módulos kvm, vfio

## Enlaces externos

- [Wikipedia — KVM](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine)
- [Wikipedia — QEMU](https://en.wikipedia.org/wiki/QEMU)
- [Wikipedia — Libvirt](https://en.wikipedia.org/wiki/Libvirt)
- [Sitio oficial — QEMU](https://www.qemu.org/)
- [Sitio oficial — libvirt](https://libvirt.org/)
- [GitHub — libvirt/libvirt](https://github.com/libvirt/libvirt)

#programa #virtualizacion