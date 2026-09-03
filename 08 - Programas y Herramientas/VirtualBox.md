---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: alta
---

# VirtualBox

> VirtualBox es un hipervisor de tipo 2 (se ejecuta sobre el sistema operativo host) de código abierto, mantenido por Oracle. Permite crear y ejecutar máquinas virtuales con cualquier sistema operativo invitado. Es la opción más accesible para virtualización de escritorio aunque no alcanza el rendimiento de KVM/QEMU en servidores.

## Características

- **Multiplataforma**: Windows, macOS, Linux, Solaris como host
- **Soporte de invitados**: Windows (XP→11), Linux, macOS (no oficial), BSD, Solaris
- **Snapshot**: guardar/restaurar estado de la VM
- **Clonación**: duplicar VMs completas
- **Modo seamless**: integrar ventanas del invitado en el host
- **USB 2.0/3.0**: passthrough de dispositivos USB
- **Audio virtual**: dispositivos AC97, Intel HD Audio
- **Red**: NAT, bridged, internal, host-only, generic driver
- **Shared folders**: compartir carpetas entre host e invitado
- **RDP**: escritorio remoto integrado
- **CLI**: VBoxManage para automatización

## Instalación

### Debian/Ubuntu

```bash
# Añadir repositorio oficial de Oracle
wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

sudo apt update
sudo apt install virtualbox-7.0    # versión más reciente

# O desde repos de distro (versión antigua):
sudo apt install virtualbox
```

### Arch Linux

```bash
sudo pacman -S virtualbox virtualbox-host-dkms
# Para módulos del kernel:
sudo dkms autoinstall
# O usar virtualbox-bin de AUR (más actualizado):
yay -S virtualbox-bin
```

### Fedora/RHEL

```bash
sudo dnf install VirtualBox
# O desde RPM Fusion:
sudo dnf install VirtualBox
```

### Post-instalación

```bash
# Agregar usuario al grupo vboxusers
sudo usermod -aG vboxusers $USER
# Cerrar sesión y volver a entrar para que surta efecto

# Verificar que el módulo del kernel está cargado
lsmod | grep vbox
# vboxdrv, vboxnetadp, vboxnetflt

# Si el módulo no carga:
sudo virtualboxkernel
# O reinstalar:
sudo dkms autoinstall
```

## Uso básico

### Crear una VM

```bash
# Crear VM desde CLI
VBoxManage createvm --name "Ubuntu-22" --ostype Ubuntu_64 --register

# Configurar RAM y CPU
VBoxManage modifyvm "Ubuntu-22" --memory 4096 --cpus 4

# Crear disco virtual
VBoxManage createmedium disk --filename ~/VirtualBox\ VMs/Ubuntu-22/disk.vdi --size 50000 --format VDI

# Agregar controlador SATA y disco
VBoxManage storagectl "Ubuntu-22" --name "SATA" --add sata --controller IntelAhci
VBoxManage storageattach "Ubuntu-22" --storagectl "SATA" --port 0 --device 0 --type hdd --medium ~/VirtualBox\ VMs/Ubuntu-22/disk.vdi

# Agregar controlador IDE (para ISO)
VBoxManage storagectl "Ubuntu-22" --name "IDE" --add ide
VBoxManage storageattach "Ubuntu-22" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium ~/Downloads/ubuntu-22.04.iso

# Configurar red (NAT)
VBoxManage modifyvm "Ubuntu-22" --nic1 nat

# Iniciar la VM
VBoxManage startvm "Ubuntu-22"
```

### Gestión de VMs

| Comando | Efecto |
|---|---|
| `VBoxManage list vms` | Listar VMs |
| `VBoxManage list runningvms` | VMs en ejecución |
| `VBoxManage startvm "vm"` | Iniciar VM |
| `VBoxManage controlvm "vm" acpipowerbutton` | Apagar graceful |
| `VBoxManage controlvm "vm" poweroff` | Apagar forzado |
| `VBoxManage controlvm "vm" pause` | Pausar |
| `VBoxManage controlvm "vm" resume` | Reanudar |
| `VBoxManage controlvm "vm" reset` | Reiniciar |
| `VBoxManage controlvm "vm" savevm "snapshot"` | Crear snapshot |
| `VBoxManage controlvm "vm" restorevm "snapshot"` | Restaurar snapshot |
| `VBoxManage unregistervm "vm" --delete` | Eliminar VM y archivos |

### Snapshot

```bash
# Crear snapshot
VBoxManage controlvm "Ubuntu-22" savevm "antes-de-actualizar"

# Listar snapshots
VBoxManage snapshotvms "Ubuntu-22" list

# Restaurar snapshot
VBoxManage controlvm "Ubuntu-22" restorevm "antes-de-actualizar"

# Eliminar snapshot
VBoxManage snapshotvms "Ubuntu-22" delete "antes-de-actualizar"
```

### Clonación

```bash
# Clonar VM completa
VBoxManage clonevm "Ubuntu-22" --name "Ubuntu-22-copia" --register

# Clonar solo el disco
VBoxManage clonmedium disk ~/VirtualBox\ VMs/Ubuntu-22/disk.vdi ~/VirtualBox\ VMs/copia.vdi
```

## Configuración avanzada

### Virtualización anidada

```bash
# Habilitar nested VT-x/AMD-V
VBoxManage modifyvm "Ubuntu-22" --nested-hw-virt on

# Verificar que funciona dentro del invitado:
# grep -E "vmx|svm" /proc/cpuinfo
```

### Passthrough USB

```bash
# Listar dispositivos USB
VBoxManage list usbhost

# Agregar filtro USB
VBoxManage usbfilter add 0 --target "Ubuntu-22" --name "Mouse" --action "hold" --vendorid "046d" --productid "c077"
```

### Red bridged

```bash
# Configurar red bridged (acceso directo a la red física)
VBoxManage modifyvm "Ubuntu-22" --nic1 bridged --bridgeadapter1 enp3s0

# Ver interfaces disponibles:
VBoxManage list bridgedifs
```

### Carpetas compartidas

```bash
# Crear carpeta compartida
VBoxManage sharedfolder add "Ubuntu-22" --name "datos" --hostpath /home/user/datos --automount

# Montar dentro del invitado:
# sudo mount -t vboxsf datos /mnt/datos
# (requiere Guest Additions instaladas)
```

### GPU passthrough (limited)

```bash
# VirtualBox NO soporta GPU passthrough real
# Para GPU passthrough usar KVM/QEMU con VFIO
# VirtualBox solo ofrece renderizador 3D virtual (VBoxVGA/VMSVGA)
```

## Guest Additions

```bash
# Las Guest Additions mejoran rendimiento e integración:
# - Shared clipboard
# - Drag and drop
# - Resolución automática de pantalla
# - Mounted shared folders
# - Time synchronization
# - Seamless mode

# Instalar en Linux guest:
sudo apt install build-essential dkms linux-headers-$(uname -r)
# Menú VM → Insert Guest Additions CD → montar → ejecutar:
sudo mount /dev/cdrom /mnt
sudo /mnt/VBoxLinuxAdditions.run

# Instalar en Windows guest:
# Menú VM → Insert Guest Additions CD → ejecutar VBoxWindowsAdditions.exe

# Verificar:
VBoxManage guestproperty get "Ubuntu-22" "/VirtualBox/GuestAdd/Version"
```

## Comparativa con alternativas

| Aspecto | VirtualBox | KVM/QEMU | VMware Workstation | Proxmox VE |
|---|---|---|---|---|
| **Tipo** | Type 2 | Type 1 | Type 2 | Type 1 |
| **Licencia** | GPLv2 (OSE) / PUEL | GPLv2 | Comercial | GPLv2 (Community) |
| **Rendimiento** | Medio | Alto | Alto | Alto |
| **GPU passthrough** | ❌ No | ✅ VFIO | ✅ Limited | ✅ VFIO |
| **Nested virt** | ✅ Limited | ✅ Completo | ✅ Completo | ✅ Completo |
| **Snapshots** | ✅ | ✅ (virsh) | ✅ | ✅ |
| **CLI** | VBoxManage | virsh/qemu-img | vmrun | qm |
| **Snapshots con diff** | ✅ | ✅ | ✅ | ✅ |
| **Ideal para** | Desktop, testing | Servidores, prod | Desktop enterprise | Datacenter |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `Kernel driver not installed` | Módulo vboxdrv no cargado | `sudo virtualboxkernel` o `sudo dkms autoinstall` |
| VM no inicia (VT-x deshabilitado) | BIOS no tiene virtualización | Habilitar VT-x/AMD-V en BIOS/UEFI |
| Pantalla negra en guest | Resolución incompatible | Instalar Guest Additions, cambiar a VMSVGA |
| Clipboard no funciona | Guest Additions no instaladas | Instalar/reinstalar Guest Additions |
| Red no funciona en guest | NIC deshabilitada | Verificar `VBoxManage showvminfo "vm" | grep NIC` |
| Audio no funciona | Dispositivo audio deshabilitado | `VBoxManage modifyvm "vm" --audioenabled on` |
| USB no funciona | Usuario no en grupo vboxusers | `sudo usermod -aG vboxusers $USER` + re-login |
| VM muy lenta | Sin aceleración硬件 | Habilitar VT-x/AMD-V + nested-virt en BIOS |
| Error `E_FAIL` | Corrupción de estado VM | Eliminar `.vbox` lock files en la carpeta de la VM |

## Ver también

- [[KVM]] — virtualización Type 1 con QEMU/libvirt
- [[Virtualización (KVM QEMU libvirt)]] — comparativa completa de virtualización
- [[QEMU]] — emulador/hypervisor
- [[libvirt]] — gestión unificada de VMs
- [[Proxmox VE]] — plataforma de virtualización empresarial
- [[LXC y Contenedores del Sistema]] — alternativa ligera a VMs

#virtualizacion #virtualbox #vm #oracle
