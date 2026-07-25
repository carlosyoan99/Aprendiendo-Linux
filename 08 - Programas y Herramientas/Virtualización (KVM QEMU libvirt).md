---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: programa
prioridad: alta
---

# Virtualización con KVM/QEMU y libvirt

## ¿Qué es?

**KVM** (Kernel-based Virtual Machine) es la tecnología de virtualización del kernel Linux. Convierte el kernel en un hipervisor tipo 1 (bare-metal), permitiendo ejecutar máquinas virtuales con rendimiento casi nativo.

**QEMU** es el emulador que maneja la emulación de hardware (CPU, RAM, discos, redes, GPU, USB). KVM + QEMU = aceleración por hardware.

**libvirt** es la capa de gestión que unifica la administración de VMs: proporciona `virsh` (CLI), `virt-manager` (GUI), y una API estable sobre múltiples hipervisores (KVM, Xen, VMware ESXi, Hyper-V, LXC).

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

---

## Requisitos previos

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
3. Actívalo
4. Guarda y reinicia

---

## Instalación

```bash
# Arch / CachyOS
sudo pacman -S virt-manager qemu-desktop libvirt edk2-ovmf dnsmasq iptables-nft
sudo systemctl enable --now libvirtd

# Fedora
sudo dnf install @virtualization
sudo systemctl enable --now libvirtd

# Debian/Ubuntu
sudo apt install virt-manager virt-viewer qemu-system libvirt-daemon-system qemu-utils
sudo systemctl enable --now libvirtd

# Añadir al grupo libvirt
sudo usermod -aG libvirt $USER
# Cerrar sesión y volver a entrar, o: newgrp libvirt
```

### Verificar

```bash
systemctl status libvirtd
virsh capabilities | grep -i kvm
virt-install --name test --memory 512 --disk size=2 --cdrom /dev/null --graphics none --print-xml
```

---

## Libvirt en profundidad

### Arquitectura de libvirt

libvirt no es un único binario — es un ecosistema de componentes:

| Componente | Función |
|---|---|
| **libvirtd** | Demonio principal de virtualización. Gestiona VMs en el host local |
| **virtproxyd** | Proxy para conexiones de usuarios sin root (polkit) |
| **virtlogd** | Demonio de logging de VMs (almacena logs de consola de cada VM) |
| **virtlockd** | Demonio de bloqueo de archivos (evita que dos VMs usen el mismo disco) |
| **libvirt.so** | Librería compartida que usan virsh, virt-manager y apps externas |
| **libvirt-qemu.so** | Driver específico para QEMU/KVM |

```bash
# Servicios que debe tener activos:
sudo systemctl enable --now libvirtd virtlogd

# Verificar que están corriendo
sudo systemctl status libvirtd virtlogd virtlockd
```

### Connection URIs

libvirt se conecta a hipervisores mediante **URIs** que especifican el driver, transporte y destino:

```bash
# Conexión local
virsh -c qemu:///system                    # QEMU/KVM sistema (root/virtproxyd)
virsh -c qemu:///session                   # QEMU/KVM sesión de usuario (sin root)

# Conexión remota (SSH)
virsh -c qemu+ssh://user@192.168.1.100/system

# Conexión remota (TCP, no cifrado — solo en redes seguras)
virsh -c qemu+tcp://192.168.1.100/system

# Otros hipervisores
virsh -c xen:///                           # Xen
virsh -c esx://vcenter.example.com/        # VMware vSphere/ESXi
virsh -c hyperv://server.example.com/      # Hyper-V
virsh -c lxc:///                           # Contenedores LXC

# URI por defecto (se puede omitir)
export LIBVIRT_DEFAULT_URI='qemu:///system'
```

### Autenticación (polkit)

libvirt usa **polkit** (PolicyKit) para controlar quién puede hacer qué:

```bash
# El grupo 'libvirt' da permisos de administración
sudo usermod -aG libvirt $USER

# Políticas por acción: /usr/share/polkit-1/actions/org.libvirt.unix.policy
# Se pueden crear reglas personalizadas en /etc/polkit-1/rules.d/

# Verificar permisos actuales
virsh uri                                # debe mostrar "qemu:///system"
virsh capabilities                       # debe mostrar las capacidades del host
```

### Diagnóstico de libvirtd

```bash
# Logs del demonio
journalctl -u libvirtd -f                # seguir logs en vivo
journalctl -u libvirtd --since "1 hour ago"  # última hora

# Debug de conexión
LIBVIRT_DEBUG=1 virsh list              # modo debug, muestra conexiones XML

# Ver con qué permisos corre
ps aux | grep libvirtd

# Prueba de conectividad
virsh connect qemu:///system
```

---

## virt-manager (GUI) — Expandido

virt-manager es la interfaz gráfica de libvirt. Además de crear VMs, permite gestionar **almacenamiento**, **redes** y **rendimiento** visualmente.

### Gestión de almacenamiento desde virt-manager

```bash
virt-manager → Edit → Connection Details → Storage
```

Desde esta pantalla puedes:
- **Crear pools**: añadir directorios, discos físicos, LVM, iSCSI, Ceph, ZFS
- **Gestionar volúmenes**: crear, redimensionar, eliminar discos virtuales
- **Ver uso**: espacio usado y disponible por pool
- **Eliminar/desconectar pools**: sin perder datos

### Gestión de redes desde virt-manager

```bash
virt-manager → Edit → Connection Details → Virtual Networks
```

Aquí puedes:
- Crear redes NAT, aisladas, abiertas (open), routeadas
- Configurar DHCP (rango, DNS)
- Definir forwarding (NAT o bridge hacia interfaz física)
- Ver estadísticas de tráfico

### Gestión de rendimiento

Para una VM seleccionada: **View → Performance**

Muestra en tiempo real:
- **CPU**: uso porcentual y gráfico histórico
- **Memoria**: asignada vs usada
- **Disco**: I/O de lectura y escritura
- **Red**: tráfico de entrada y salida

Útil para diagnosticar cuellos de botella sin instalar agentes dentro de la VM.

### Clonación desde virt-manager

```bash
# VM apagada → botón derecho → Clone
# Opciones:
# - Nuevo nombre
# - Clon linked (thin clone, ahorra disco, usa backing chain)
# - Clon full (copia completa e independiente)
```

### Conexión a servidores remotos

```bash
virt-manager puede gestionar VMs en servidores remotos:

File → Add Connection →
  Hypervisor: QEMU/KVM
  Method: SSH
  Username: usuario
  Hostname: 192.168.1.100
  Autoconnect: (opcional)

# Equivalente en consola:
virsh -c qemu+ssh://usuario@192.168.1.100/system list --all
```

### virt-viewer (visor ligero)

**virt-viewer** es el visor de VMs independiente (no requiere virt-manager):

```bash
# Conectar a VM local
virt-viewer nombre-vm

# Conectar a VM remota
virt-viewer -c qemu+ssh://usuario@servidor/system nombre-vm

# Conectar por VNC/SPICE directo (sin libvirt)
virt-viewer -c vnc://192.168.1.100:5900
virt-viewer -c spice://192.168.1.100:5900
```

---

## virsh (CLI) — Expandido

### Gestión de VMs

```bash
# Listar
virsh list                                # en ejecución
virsh list --all                          # todas
virsh list --state-shutoff                # solo apagadas
virsh list --name                         # solo nombres (para scripting)
virsh list --uuid                         # solo UUIDs
virsh list --table                        # tabla completa (por defecto)

# Filtros
virsh list --inactive                     # apagadas
virsh list --persistent                   # definidas (persisten tras apagar)
virsh list --transient                    # efímeras (se pierden al apagar)
virsh list --autostart                    # con autostart habilitado

# Ciclo de vida
virsh start nombre-vm
virsh shutdown nombre-vm                  # ACPI limpio
virsh destroy nombre-vm                   # forzar (desconectar cable)
virsh reboot nombre-vm
virsh reset nombre-vm                     # reset en caliente
virsh suspend nombre-vm                   # pausar (en RAM)
virsh resume nombre-vm                    # reanudar

# Información detallada
virsh dominfo nombre-vm                   # UUID, estado, CPU, RAM, autoinicio
virsh domstate nombre-vm                  # estado: running, shut off, paused
virsh domid nombre-vm                     # ID numérico interno
virsh domuuid nombre-vm                   # UUID
virsh domname ID-o-UUID                   # nombre desde ID o UUID

# Recursos
virsh vcpuinfo nombre-vm                  # CPUs (cantidad, afinidad, tiempo)
virsh dommemstat nombre-vm                # memoria: actual, balón, usable
virsh domblklist nombre-vm                # discos: destino, fuente, tipo
virsh domblkstat nombre-vm vda            # estadísticas de I/O de disco
virsh domiflist nombre-vm                 # interfaces de red
virsh domifstat nombre-vm vnet0           # estadísticas de tráfico de red
```

### Gestión del dominio (definición XML)

Cada VM se define mediante un **dominio XML** que describe todo su hardware virtual:

```bash
# Ver XML completo de una VM
virsh dumpxml nombre-vm

# Editar XML (abre editor, valida al guardar)
virsh edit nombre-vm

# Definir VM desde archivo XML
virsh define /ruta/a/dominio.xml

# Crear VM desde XML (inicia inmediatamente)
virsh create /ruta/a/dominio.xml

# Eliminar definición (sin borrar discos)
virsh undefine nombre-vm
virsh undefine --nvram nombre-vm          # también borra vars UEFI
virsh undefine --remove-all-storage nombre-vm  # también borra discos
```

### Estructura del XML de dominio

```xml
<domain type='kvm'>
  <name>ubuntu-server</name>
  <memory unit='GiB'>2</memory>
  <vcpu placement='static'>2</vcpu>
  <os>
    <type arch='x86_64' machine='q35'>hvm</type>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/><apic/><pae/>
  </features>
  <cpu mode='host-passthrough'/>
  <devices>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/ubuntu.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <interface type='network'>
      <source network='default'/>
      <model type='virtio'/>
    </interface>
    <graphics type='spice' port='5900'/>
    <video><model type='virtio'/></video>
  </devices>
</domain>
```

### Autostart

```bash
# Que una VM arranque automáticamente al iniciar el host
virsh autostart nombre-vm

# Deshabilitar autostart
virsh autostart --disable nombre-vm

# Ver qué VMs tienen autostart
virsh list --autostart
```

### Eventos y hooks

libvirt puede ejecutar **scripts hook** cuando ocurren eventos en el ciclo de vida de una VM:

```bash
# Los hooks se colocan en /etc/libvirt/hooks/
# Se nombran: qemu (para QEMU/KVM), lxc, etc.

# Ejemplo: /etc/libvirt/hooks/qemu
#!/bin/bash
# Argumentos: $1=nombre-VM, $2=operación, $3=suboperación
# Operaciones: prepare, start, started, stopped, release, migrate

case "$2" in
  prepare)
    echo "VM $1 preparándose para iniciar" >> /var/log/libvirt-hooks.log
    ;;
  start)
    # Montar almacenamiento adicional
    mount /dev/sdb1 /mnt/vm-$1
    ;;
  stopped)
    # Backup automático al detener
    vzdump $1 --dumpdir /backup/ 2>/dev/null
    ;;
esac

# Hacer ejecutable
sudo chmod +x /etc/libvirt/hooks/qemu
```

---

## Almacenamiento — Expandido

### Tipos de pools de almacenamiento

| Tipo | Comando | Caso de uso |
|---|---|---|
| **dir** | `pool-define-as pool dir --target /ruta` | Directorio simple (por defecto) |
| **logical** | `pool-define-as pool logical --target /dev/VG` | Volumen LVM |
| **disk** | `pool-define-as pool disk --source-dev /dev/sdb` | Disco físico sin particionar |
| **fs** | `pool-define-as pool fs --source-dev /dev/sda1` | Partición formateada |
| **iscsi** | `pool-define-as pool iscsi --source-host 10.0.0.1 --source-dev iqn.2024-...` | SAN iSCSI |
| **ceph** | `pool-define-as pool rbd --source-name pool-ceph --source-host mon1,mon2,mon3` | Ceph/RBD |
| **zfs** | `pool-define-as pool zfs --source-name zpool/vms` | ZFS datasets |
| **scsi** | `pool-define-as pool scsi --source-adapter scsi_host0` | Backend SCSI genérico |

```bash
# Ejemplo: crear pool LVM
sudo vgcreate vg_vms /dev/sdb /dev/sdc
virsh pool-define-as vg_vms logical --target /dev/vg_vms
virsh pool-start vg_vms
virsh pool-autostart vg_vms

# Ejemplo: crear pool NFS
virsh pool-define-as nfs_pool netfs --source-host 192.168.1.10 --source-path /export/vms --target /mnt/nfs_vms
virsh pool-start nfs_pool
```

### Backing chains (cadenas de respaldo)

qcow2 permite crear discos en **capa sobre capa** (backing chain):

```bash
# Disco base (immutable, de solo lectura)
qemu-img create -f qcow2 base.qcow2 20G

# Disco overlay (escribe solo los cambios, apunta al base)
qemu-img create -f qcow2 -b base.qcow2 -F qcow2 overlay.qcow2

# Ver la cadena de respaldo
qemu-img info --backing-chain overlay.qcow2

# Fusionar overlay con base (commit)
qemu-img commit overlay.qcow2

# Rebasing: cambiar a qué base apunta un overlay
qemu-img rebase -b nuevo-base.qcow2 -F qcow2 overlay.qcow2
```

Útil para:
- **Snapshots rápidos**: crear un overlay, revertir es borrar el overlay
- **Thin clones**: múltiples VMs comparten el mismo disco base de solo lectura
- **Plantillas**: un disco base común y cada VM su overlay

---

## Redes — Expandido

### Tipos de redes virtuales

| Tipo | Aislamiento | Salida internet | Accesible desde LAN |
|---|---|---|---|
| **NAT** (default) | VM ↔ VM sí, VM → host sí | ✅ Por NAT del host | ❌ No |
| **Bridge** | VM en la misma LAN | ✅ IP propia en LAN | ✅ Sí |
| **Aislada** (isolated) | Solo entre VMs del mismo host | ❌ No | ❌ No |
| **Abierta** (open) | Sin firewall, solo switch | ❌ Sin NAT | ❌ No |
| **Routeada** | Como NAT pero sin enmascarar | ✅ Ruteo IP | ✅ Depende del router |

### Crear red aislada

```bash
cat > isolated-network.xml << 'EOF'
<network>
  <name>aislada</name>
  <forward mode='none'/>
  <ip address='10.10.10.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='10.10.10.10' end='10.10.10.100'/>
    </dhcp>
  </ip>
</network>
EOF
virsh net-define isolated-network.xml
virsh net-start aislada
```

### Network filters (firewall por VM)

libvirt permite aplicar reglas de firewall a nivel de VM mediante **network filters** XML:

```bash
# Ejemplo: filtrar tráfico de una VM
cat > no-ssh-filter.xml << 'EOF'
<filter name='no-ssh' chain='ipv4'>
  <rule action='drop' direction='in'>
    <tcp dstportstart='22'/>
  </rule>
  <rule action='accept' direction='in'>
    <all/>
  </rule>
</filter>
EOF

# Asignar filtro a interfaz de VM
virsh nwfilter-define no-ssh-filter.xml
virsh attach-interface nombre-vm network default --filterref no-ssh
```

---

## Snapshots — Ampliado

### Tipos de snapshots

| Tipo | Disco | RAM | Estado VM | Archivo |
|---|---|---|---|---|
| **Internal disk-only** | ✅ dentro del qcow2 | ❌ | Apagada | Mismo qcow2 |
| **Internal full** | ✅ dentro del qcow2 | ✅ en qcow2 | En ejecución | Mismo qcow2 (gran tamaño) |
| **External disk-only** | ✅ overlay qcow2 | ❌ | Apagada | Nuevo overlay qcow2 |
| **External full** | ✅ overlay qcow2 | ✅ archivo .save | En ejecución | Overlay + archivo RAM |

### Internal snapshots (dentro del qcow2)

Son los más simples: el snapshot se guarda dentro del propio archivo qcow2. No requieren archivos adicionales pero la VM debe estar **apagada** para disk-only.

```bash
# Crear snapshot interno (VM apagada)
virsh snapshot-create-as nombre-vm antes-actualizar

# Los snapshots internos crecen el archivo qcow2
# Ver cuánto ocupa cada snapshot
qemu-img info /var/lib/libvirt/images/nombre-vm.qcow2
# En la salida: Snapshot list con su tamaño

# Revertir
virsh snapshot-revert nombre-vm antes-actualizar

# Eliminar snapshot (libera espacio dentro del qcow2)
virsh snapshot-delete nombre-vm antes-actualizar
```

### External snapshots (overlay qcow2)

Crean un **nuevo archivo qcow2 overlay** que escribe solo los cambios desde el snapshot. El disco original queda congelado como backing file de solo lectura.

```bash
# 1. Crear snapshot externo (VM en ejecución)
virsh snapshot-create-as \
  --domain nombre-vm \
  --name backup-pre \
  --disk-only \
  --atomic

# Esto crea: nombre-vm.backup-pre.qcow2 (overlay)
# El original queda como backing file

# 2. Ver la cadena
virsh domblklist nombre-vm
qemu-img info --backing-chain /var/lib/libvirt/images/nombre-vm.backup-pre.qcow2

# 3. Para "committear" los cambios al disco original:
virsh blockcommit nombre-vm vda --active --pivot
# Esto fusiona el overlay en el backing file y pivota automáticamente
```

### Snapshot con RAM (con memoria)

Captura también el estado de la RAM, permitiendo restaurar la VM exactamente como estaba (programas abiertos, conexiones de red, etc.):

```bash
# VM en ejecución — snapshot con RAM y disco
virsh snapshot-create-as \
  --domain nombre-vm \
  --name instante-x \
  --disk-only --memspec file=/var/lib/libvirt/images/nombre-vm.ram,snapshot=internal

# Restaurar: la VM vuelve exactamente al mismo estado
virsh snapshot-revert nombre-vm instante-x
```

### Buenas prácticas con snapshots

1. **Internal snapshots** → rápidos, simples, ideales para backups temporales antes de una actualización
2. **External snapshots** → ideales para backups incrementales y thin clones
3. **No mantengas cadenas largas**: más de 5-10 snapshots internos degradan el rendimiento del qcow2
4. **Libera espacio regularmente**: `virsh snapshot-delete` para snapshots internos; `virsh blockcommit` para fusionar externos
5. **Snapshots no son backups**: un snapshot depende del disco original. Si el disco original se corrompe, pierdes todos los snapshots
6. **Para backups reales**, usa `qemu-img convert` para exportar a un archivo independiente:

```bash
# Backup completo exportando la cadena completa (resuelve backing chain)
qemu-img convert -O qcow2 overlay.qcow2 backup-completo.qcow2

# Backup comprimido
qemu-img convert -c -O qcow2 overlay.qcow2 backup-comprimido.qcow2
```

---

## Rendimiento y optimización

### VirtIO drivers

| Componente | Guest antiguo | Guest moderno (VirtIO) |
|---|---|---|
| **Disco** | IDE (lento) | VirtIO-blk o VirtIO-scsi (rápido) |
| **Red** | e1000/rtl8139 (emulado) | virtio-net (casi nativo) |
| **GPU** | VGA/QXL | virtio-gpu (mejor, no para gaming) |
| **Balloon** | No | virtio-balloon (gestión dinámica RAM) |
| **RNG** | No | virtio-rng (entropía para el guest) |

```bash
# Cambiar controladores en VM existente
virsh edit nombre-vm
# Disco: <target dev='hda' bus='ide'/> → <target dev='vda' bus='virtio'/>
# Red: <model type='e1000'/> → <model type='virtio'/>
```

### CPU tuning

```bash
# CPU pinning: fijar vCPUs a cores físicos
virsh vcpupin nombre-vm 0 0              # vCPU 0 → core 0
virsh vcpupin nombre-vm 1 2              # vCPU 1 → core 2

# Modo CPU (passthrough da el máximo rendimiento)
virsh edit nombre-vm
# <cpu mode='host-passthrough'/>  ← el guest ve la CPU real
# <cpu mode='host-model'/>       ← el guest ve una CPU compatible
# <cpu mode='custom'/>           ← el guest ve un modelo específico

# NUMA tuning (para servidores con múltiples CPUs)
virsh numatune nombre-vm --nodeset 0 --mode strict
```

### Memoria

```bash
# Ballooning: la VM puede devolver RAM al host
virsh dommemstat nombre-vm              # ver: balloon_actual, balloon_maximum
virsh setmem nombre-vm 1G              # reducir RAM en caliente (si hay balloon)

# Hugepages (rendimiento, reduce TLB misses)
# En /etc/default/grub: default_hugepagesz=1G hugepagesz=1G hugepages=8
# En XML de VM:
# <memoryBacking>
#   <hugepages/>
# </memoryBacking>
```

### virt-top — monitorización de VMs

```bash
# Instalar
sudo apt install virt-top                # Debian/Ubuntu
sudo pacman -S virt-top                  # Arch

# Uso (similar a top, pero para VMs)
virt-top
# Muestra: nombre, estado, CPU%, RAM%, tiempo de actividad

# Ordenar por uso
virt-top -s cpu                          # ordenar por CPU
virt-top -s mem                          # ordenar por RAM

# Batch mode (para scripting)
virt-top -b -n 1                         # una iteración, stdout
```

---

## Secrets (contraseñas cifradas)

libvirt puede almacenar contraseñas (iSCSI, Ceph, discos cifrados) de forma segura:

```bash
# Generar secreto UUID
uuidgen > /tmp/ceph-secret-uuid.txt

# Definir secreto
virsh secret-define --file - <<EOF
<secret ephemeral='no' private='yes'>
  <uuid>$(cat /tmp/ceph-secret-uuid.txt)</uuid>
  <usage type='ceph'>
    <name>ceph-client-secret</name>
  </usage>
</secret>
EOF

# Asignar contraseña (base64)
virsh secret-set-value $(cat /tmp/ceph-secret-uuid.txt) $(echo -n 'mi-contraseña-ceph' | base64)

# Usar en pool Ceph
virsh pool-define-as pool-ceph rbd --source-host mon1 --source-name pool-rbd --secret-uuid $(cat /tmp/ceph-secret-uuid.txt)
```

---

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