---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# KVM (Kernel-based Virtual Machine)

**KVM** es la tecnología de virtualización del kernel Linux. Convierte el kernel en un hipervisor tipo 1 (bare-metal), permitiendo ejecutar máquinas virtuales con rendimiento casi nativo.

KVM no emula hardware por sí mismo — delega esa tarea a [[QEMU]]. Juntos forman el stack de virtualización por defecto en Linux.

## Requisitos

### Verificar que la CPU soporta virtualización

```bash
# Intel: VT-x (vmx) · AMD: AMD-V (svm)
grep -E --color '(vmx|svm)' /proc/cpuinfo

# Verificación completa
kvm-ok                                  # si cpu-checker está instalado
# Salida esperada: "KVM acceleration can be used"

lsmod | grep kvm                        # módulos kvm cargados?
```

Si no ves `vmx` o `svm` en `/proc/cpuinfo`:
1. Reinicia y entra a la BIOS/UEFI
2. Busca "Intel Virtualization Technology (VT-x)" o "SVM Mode"
3. Actívalo y reinicia

## Arquitectura

```
┌──────────────────────────────────────┐
│            QEMU (emulación HW)        │
│         ↓                            │
│  KVM (aceleración /dev/kvm)          │
├──────────────────────────────────────┤
│  Hardware real (CPU con VT-x/AMD-V)  │
└──────────────────────────────────────┘
```

KVM expone el dispositivo `/dev/kvm` que QEMU usa para acelerar las VMs. Sin `/dev/kvm`, QEMU funciona como emulador puro (muy lento).

## Módulos del kernel

```bash
lsmod | grep kvm
# kvm                    # núcleo común
# kvm_intel              # para CPUs Intel
# kvm_amd                # para CPUs AMD
```

## Rendimiento y CPU tuning

### CPU pinning

Fijar vCPUs a cores físicos para evitar contención:

```bash
virsh vcpupin nombre-vm 0 0              # vCPU 0 → core 0
virsh vcpupin nombre-vm 1 2              # vCPU 1 → core 2
```

### Modo CPU

```bash
# Editar XML de la VM
virsh edit nombre-vm
# <cpu mode='host-passthrough'/>  ← el guest ve la CPU real (máximo rendimiento)
# <cpu mode='host-model'/>       ← el guest ve una CPU compatible
# <cpu mode='custom'/>           ← el guest ve un modelo específico
```

### NUMA tuning

Para servidores con múltiples CPUs:

```bash
virsh numatune nombre-vm --nodeset 0 --mode strict
```

### Hugepages

Reduce TLB misses y mejora rendimiento de memoria:

```bash
# En /etc/default/grub: default_hugepagesz=1G hugepagesz=1G hugepages=8
# En XML de VM:
# <memoryBacking>
#   <hugepages/>
# </memoryBacking>
```

## Ver también

- [[QEMU]] — emulación de hardware
- [[libvirt]] — capa de gestión (virsh, virt-manager)
- [[Virtualización (KVM QEMU libvirt)]] — índice del stack
- [[Módulos del kernel (lsmod modprobe blacklist)]] — módulos kvm, vfio
- [[Proxmox VE]] — plataforma basada en KVM

## Enlaces externos

- [Wikipedia — KVM](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine)
- [Sitio oficial — linux-kvm](https://www.linux-kvm.org/)

#programa #virtualizacion
