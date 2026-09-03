---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: alta
---

# libvirt

**libvirt** es la capa de gestión que unifica la administración de máquinas virtuales. Proporciona `virsh` (CLI), `virt-manager` (GUI), y una API estable sobre múltiples hipervisores: [[KVM]]/[[QEMU]], Xen, VMware ESXi, Hyper-V y LXC.

## Arquitectura

| Componente | Función |
|---|---|
| **libvirtd** | Demonio principal de virtualización |
| **virtproxyd** | Proxy para conexiones de usuarios sin root (polkit) |
| **virtlogd** | Logging de VMs (consola de cada VM) |
| **virtlockd** | Bloqueo de archivos (evita que dos VMs usen el mismo disco) |
| **libvirt.so** | Librería compartida para virsh, virt-manager y apps externas |
| **libvirt-qemu.so** | Driver específico para QEMU/KVM |

## Instalación

```bash
# Arch
sudo pacman -S virt-manager libvirt edk2-ovmf dnsmasq iptables-nft

# Debian/Ubuntu
sudo apt install virt-manager virt-viewer libvirt-daemon-system

# Fedora
sudo dnf install @virtualization

# Activar servicios
sudo systemctl enable --now libvirtd virtlogd

# Añadir usuario al grupo
sudo usermod -aG libvirt $USER
```

## virsh (CLI)

### Gestión de VMs

```bash
virsh list                           # en ejecución
virsh list --all                     # todas
virsh list --name                    # solo nombres (scripting)

virsh start nombre-vm
virsh shutdown nombre-vm             # ACPI limpio
virsh destroy nombre-vm              # forzar
virsh reboot nombre-vm
virsh suspend nombre-vm              # pausar
virsh resume nombre-vm               # reanudar

virsh dominfo nombre-vm              # info detallada
virsh vcpuinfo nombre-vm             # CPUs
virsh dommemstat nombre-vm           # memoria
virsh domblklist nombre-vm           # discos
virsh domiflist nombre-vm            # redes
```

### Dominios XML

Cada VM se define con un XML de dominio:

```bash
virsh dumpxml nombre-vm              # ver XML
virsh edit nombre-vm                 # editar XML
virsh define dominio.xml             # definir desde XML
virsh create dominio.xml             # crear e iniciar
virsh undefine nombre-vm             # eliminar definición
virsh undefine --nvram nombre-vm     # también borra vars UEFI
```

### Autostart

```bash
virsh autostart nombre-vm            # arrancar al iniciar host
virsh autostart --disable nombre-vm  # deshabilitar
```

### Connection URIs

```bash
virsh -c qemu:///system              # local QEMU/KVM
virsh -c qemu+ssh://user@server/system  # remoto SSH
virsh -c xen:///                     # Xen
virsh -c esx://vcenter/              # VMware

export LIBVIRT_DEFAULT_URI='qemu:///system'
```

## virt-manager (GUI)

Interfaz gráfica de libvirt para gestionar VMs, almacenamiento y redes:

```bash
virt-manager                         # lanzar GUI
```

- **Storage**: `Edit → Connection Details → Storage` — pools (dir, LVM, iSCSI, Ceph, ZFS)
- **Redes**: `Edit → Connection Details → Virtual Networks` — NAT, bridge, aislada
- **Rendimiento**: `View → Performance` — CPU, RAM, disco, red en tiempo real
- **Clonación**: VM apagada → botón derecho → Clone
- **Conexión remota**: `File → Add Connection → QEMU/KVM → SSH`

## virt-viewer

Visor ligero de VMs (no requiere virt-manager):

```bash
virt-viewer nombre-vm
virt-viewer -c qemu+ssh://user@server/system nombre-vm
virt-viewer -c vnc://192.168.1.100:5900
```

## Almacenamiento

### Tipos de pools

| Tipo | Uso |
|---|---|
| **dir** | Directorio simple (por defecto) |
| **logical** | Volumen LVM |
| **disk** | Disco físico sin particionar |
| **fs** | Partición formateada |
| **iscsi** | SAN iSCSI |
| **ceph** | Ceph/RBD |
| **zfs** | ZFS datasets |

```bash
virsh pool-define-as pool dir --target /ruta
virsh pool-start pool
virsh pool-autostart pool
```

## Redes

### Tipos

| Tipo | Salida internet |
|---|---|
| **NAT** (default) | ✅ Por NAT del host |
| **Bridge** | ✅ IP propia en LAN |
| **Aislada** | ❌ |
| **Routeada** | ✅ Ruteo IP |

### Network filters (firewall por VM)

```bash
virsh nwfilter-define filtro.xml
virsh attach-interface nombre-vm network default --filterref no-ssh
```

## Snapshots

### Internal (dentro del qcow2)

```bash
virsh snapshot-create-as nombre-vm antes-actualizar
virsh snapshot-revert nombre-vm antes-actualizar
virsh snapshot-delete nombre-vm antes-actualizar
```

### External (overlay qcow2)

```bash
virsh snapshot-create-as --domain nombre-vm --name backup-pre --disk-only --atomic
virsh blockcommit nombre-vm vda --active --pivot
```

## Secrets (contraseñas cifradas)

```bash
virsh secret-define --file secret.xml
virsh secret-set-value <uuid> $(echo -n 'pass' | base64)
```

## Hooks

Scripts que se ejecutan en eventos del ciclo de vida de una VM:

```bash
# /etc/libvirt/hooks/qemu
# Argumentos: $1=nombre-VM, $2=operación (prepare/start/stopped...), $3=suboperación
```

## Polkit (autenticación)

```bash
sudo usermod -aG libvirt $USER       # grupo de administración
```

## virt-top — monitorización de VMs

Monitor interactivo similar a `top` pero para máquinas virtuales gestionadas por libvirt.

### Instalación

```bash
sudo apt install virt-top             # Debian/Ubuntu
sudo pacman -S virt-top               # Arch
sudo dnf install virt-top             # Fedora
```

### Uso

```bash
virt-top                              # lanzar monitor interactivo
# Muestra: nombre VM, estado, CPU%, RAM%, tiempo de actividad

virt-top -s cpu                       # ordenar por uso de CPU
virt-top -s mem                       # ordenar por uso de RAM
virt-top -b -n 1                      # batch mode, una iteración (para scripting)
```

## Comparativa con alternativas

| Aspecto | libvirt | virt-manager (GUI sobre libvirt) | Incus/LXD | VirtualBox CLI | Podman |
|---|---|---|---|---|---|
| **Rol** | API/daemon de gestión | Interfaz gráfica | Gestor de contenedores + VMs | Hipervisor propio | Contenedores |
| **Hipervisor soportado** | KVM, QEMU, Xen, LXC, ESXi, Hyper-V... | Los de libvirt | QEMU (para VMs) | Solo VirtualBox | runc/crun |
| **Automatización** | ✅ Excelente (virsh, Python) | ⚠️ Parcial | ✅ incus CLI | ⚠️ Limitado | ✅ Podman |
| **Multi-host (remote)** | ✅ vía TLS/SSH | ✅ | ✅ cluster nativo | ❌ | ⚠️ Podman farm |
| **Snapshots** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Granularidad** | Muy alta (XML completo) | Media | Media-alta | Media | Baja (apps) |
| **Curva de aprendizaje** | Alta | Baja | Media | Baja | Baja |
| **Ideal para** | Admins de virtualización, scripting | Desktop management | Homelab contenedores+VM | Desktop casual | Containers rootless |

**Recomendación**: libvirt es la capa correcta si gestionas VMs de forma seria (scripts, multiples hosts, varios hipervisores). Para homelab con contenedores + alguna VM, Incus es más sencillo. Para un escritorio casual, virt-manager sobre libvirt ofrece GUI + toda la potencia detrás.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `Could not access KVM kernel module` | VT-x/AMD-V desactivado o módulo no cargado | Activar virtualización en BIOS; cargar `kvm_intel`/`kvm_amd` (`sudo modprobe`) |
| `error: Failed to connect socket to '/var/run/libvirt/libvirt-sock'` | Daemon libvirtd no está corriendo | `sudo systemctl start libvirtd` (y `enable`) |
| `Permission denied` al acceder a libvirt | Usuario no pertenece al grupo `libvirt` | `sudo usermod -aG libvirt $USER` y volver a iniciar sesión |
| VM no arranca: `CPU doesn't support ... 'vmx'` | CPU sin passthru completo | Habilitar `vmx`/`svm` en BIOS o restringir `<cpu mode='custom' match='exact'>` |
| Guest con red pero sin DNS | El bridge por defecto no da DHCP a la máquina | Revisar la red virtual `default` (`virsh net-start default`; `virsh net-autostart default`) |
| Storage se ve lento | Formato qcow2 fragmentado o sin preallocation | `qemu-img check` y si hace falta `qemu-img convert -O qcow2 -p src dst` |

## Ver también

- [[KVM]] — hipervisor del kernel
- [[QEMU]] — emulación de hardware
- [[Virtualización (KVM QEMU libvirt)]] — índice del stack
- [[Proxmox VE]] — plataforma basada en libvirt
- [[Incus]] — gestión de contenedores y VMs

## Enlaces externos

- [Sitio oficial — libvirt](https://libvirt.org/)
- [Wikipedia — libvirt](https://en.wikipedia.org/wiki/Libvirt)
- [GitHub — libvirt/libvirt](https://github.com/libvirt/libvirt)

#programa #virtualizacion
