---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: sistema
prioridad: alta
---

# Módulos del kernel (lsmod, modprobe, modinfo, blacklist)

## Definición

El kernel de Linux es modular: los **módulos** son piezas de código que se pueden cargar y descargar en caliente para añadir funcionalidad (drivers de dispositivo, sistemas de archivos, firewalls, etc.) sin necesidad de recompilar el kernel ni reiniciar el sistema.

```
Arquitectura de módulos:

  ┌──────────────────────────────────────┐
  │              Kernel                  │
  │  ┌────────────────────────────────┐  │
  │  │  Módulos cargados              │  │
  │  │  ┌─────────┐ ┌─────────┐      │  │
  │  │  │ nvidia  │ │ ext4    │      │  │
  │  │  │ (GPU)   │ │ (FS)   │      │  │
  │  │  └─────────┘ └─────────┘      │  │
  │  │  ┌─────────┐ ┌─────────┐      │  │
  │  │  │ vfio_pci│ │ zfs     │      │  │
  │  │  │ (GPU    │ │ (FS)   │      │  │
  │  │  │ passt.) │ │         │      │  │
  │  │  └─────────┘ └─────────┘      │  │
  │  └────────────────────────────────┘  │
  └──────────────────────────────────────┘
        ▲              │          ▲
        │ modprobe     │ rmmod    │ modinfo
        │              ▼          │
  ┌──────────┐   ┌──────────┐  ┌──────────┐
  │ /lib/    │   │ Descargar│  │ Informa- │
  │ modules/ │   │ módulo   │  │ ción del │
  │ (archivo)│   │          │  │ módulo   │
  └──────────┘   └──────────┘  └──────────┘
```

---

## Comandos principales

```bash
# ── lsmod — listar módulos cargados ──
lsmod                                     # todos los módulos
lsmod | grep nvidia                       # buscar un módulo específico
lsmod | wc -l                             # cuántos módulos hay cargados

# ── modinfo — información de un módulo ──
modinfo nvidia                            # descripción, autor, licencia, parámetros
modinfo -p nvidia                         # solo parámetros configurables
modinfo -F filename nvidia                # ruta del archivo .ko
modinfo -F depends nvidia                 # dependencias del módulo
modinfo -F parm nvidia                    # parámetros del módulo

# ── modprobe — cargar/descargar módulos ──
sudo modprobe vfio-pci                    # cargar módulo (y sus dependencias)
sudo modprobe -r vfio-pci                 # descargar módulo (solo si no está en uso)
sudo modprobe -r nvidia                   # descargar NVIDIA (requiere cerrar X11 antes)

# ── insmod / rmmod — carga/descarga directa (sin resolver dependencias) ──
sudo insmod /lib/modules/.../mikmod.ko    # cargar directamente (ruta completa)
sudo rmmod mikmod                         # descargar por nombre (sin ruta)

# ── modprobe --show-depends — qué dependencias tiene ──
sudo modprobe --show-depends nvidia       # muestra qué otros módulos necesita
```

### Formato de salida de lsmod

```
Module                  Size  Used by
nvidia_uvm           1753088  0
nvidia_drm             57344  5
nvidia_modeset       1339392  6  nvidia_drm
nvidia              41023552  186  nvidia_uvm, nvidia_modeset
```

| Columna | Significado |
|---|---|
| **Module** | Nombre del módulo |
| **Size** | Tamaño en bytes |
| **Used by** | Número de procesos que lo usan + nombres de módulos dependientes |

---

## Dónde están los módulos

```bash
# Los módulos compilados están en:
ls /lib/modules/$(uname -r)/              # todos los módulos para el kernel actual
# kernel/drivers/    — drivers de dispositivos
# kernel/fs/         — sistemas de archivos
# kernel/net/        — protocolos de red
# kernel/sound/      — drivers de audio

# Archivo .ko (kernel object):
ls /lib/modules/$(uname -r)/kernel/drivers/net/wireless/
# ej: iwlwifi.ko, ath9k.ko, etc.

# Ver el módulo correspondiente a un dispositivo
modinfo -F filename $(lsmod | grep -i wifi | awk '{print $1}')
```

---

## Configuración del kernel: /etc/modprobe.d/

Los archivos en `/etc/modprobe.d/` contienen opciones, blacklists y aliases para los módulos.

### Blacklist — evitar que un módulo se cargue automáticamente

```bash
# /etc/modprobe.d/blacklist.conf
# Evitar que cierto módulo se cargue al arrancar
blacklist pcspkr                          # desactivar el pitido del altavoz interno
blacklist nouveau                         # evitar driver nouveau (para usar NVIDIA)
```

### Parámetros de módulos

```bash
# /etc/modprobe.d/nvidia.conf
# Pasar parámetros al módulo al cargarse
options nvidia_drm modeset=1              # habilitar modesetting de NVIDIA
options nvidia NVreg_UsePageAttributeTable=1

# /etc/modprobe.d/vfio.conf (GPU passthrough)
options vfio-pci ids=10de:1b80,10de:10f0 softdep nvidia pre: vfio-pci

# Ver parámetros disponibles para un módulo
modinfo -p nvidia
# NVreg_UsePageAttributeTable: boolean
# NVreg_EnableMSI: boolean
# ...
```

### Aliases — nombrar módulos

```bash
# /etc/modprobe.d/aliases.conf
alias eth0 e1000                          # la interfaz eth0 usa el módulo e1000
alias wlan0 iwlwifi                       # la interfaz wlan0 usa iwlwifi
```

---

## Carga en el arranque (initramfs)

Algunos módulos deben cargarse **durante el arranque** (antes de montar la raíz), por lo que deben incluirse en el initramfs:

```bash
# Arch Linux — /etc/mkinitcpio.conf
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
# Luego regenerar:
sudo mkinitcpio -P

# Debian/Ubuntu — /etc/initramfs-tools/modules
echo "nvidia" | sudo tee -a /etc/initramfs-tools/modules
echo "nvidia_modeset" | sudo tee -a /etc/initramfs-tools/modules
echo "nvidia_uvm" | sudo tee -a /etc/initramfs-tools/modules
echo "nvidia_drm" | sudo tee -a /etc/initramfs-tools/modules
sudo update-initramfs -u

# Fedora/RHEL — añadir a dracut
sudo dracut --force
```

---

## depmod — Mapa de dependencias

depmod genera el archivo `modules.dep` que modprobe usa para resolver dependencias automáticamente.

```bash
# Regenerar mapa de dependencias (tras instalar un módulo nuevo)
sudo depmod -a

# Ver qué módulos necesita otro (usando modprobe)
sudo modprobe --show-depends nvidia

# O directamente desde el archivo de dependencias
grep nvidia /lib/modules/$(uname -r)/modules.dep

# Buscar qué módulo corresponde a un dispositivo PCI (vendor:device)
grep pci:v000010DEd00001B80 /lib/modules/$(uname -r)/modules.alias
```

---

## Firmware

Muchos módulos (especialmente WiFi, GPU, NVMe) requieren **firmware** — microcódigo que se carga en el dispositivo durante la inicialización. El firmware está en `/lib/firmware/`.

```bash
# Ver firmwares cargados
ls /lib/firmware/

# Ver qué firmware necesita un módulo
modinfo -F firmware iwlwifi
# iwlwifi-7265D-29.ucode  ← archivo que debe existir en /lib/firmware/

# Instalar firmware adicional
sudo apt install firmware-iwlwifi        # Debian/Ubuntu
sudo pacman -S linux-firmware             # Arch
sudo dnf install linux-firmware           # Fedora

# Cargar firmware manualmente (en caliente)
sudo modprobe -r iwlwifi && sudo modprobe iwlwifi
```

---

## Troubleshooting

| Problema | Causa probable | Solución |
|---|---|---|
| `modprobe: FATAL: Module not found` | Módulo no existe o no está compilado | `modinfo nombre` para buscar; verificar con `ls /lib/modules/$(uname -r)/` |
| `modprobe: ERROR: could not insert 'nvidia': Key was rejected by service` | Secure Boot bloquea módulo sin firmar | Firmar módulo o deshabilitar Secure Boot |
| `modinfo: could not find module` | Módulo no disponible para este kernel | Verificar versión del kernel con `uname -r` |
| **Módulo no se descarga** (`modprobe -r`) | Otro módulo o proceso lo está usando | `lsmod | grep modulo` para ver dependencias |
| **Dispositivo no funciona** | Falta firmware | `dmesg | grep firmware` para ver errores |
| **Pantalla negra tras instalar NVIDIA** | Módulo nouveau conflictivo | Blacklist nouveau en `/etc/modprobe.d/` |

### Ver logs de carga de módulos

```bash
# Mensajes del kernel sobre módulos
dmesg | grep -i "module\|nvidia\|iwlwifi"

# Errores al cargar módulos (último reinicio)
journalctl -k --since "1 hour ago" | grep -i "module\|firmware\|fail"

# ¿Un módulo se cargó correctamente?
lsmod | grep iwlwifi                     # si aparece, está cargado
modinfo -F parm iwlwifi                  # parámetros con los que se cargó
```

---

## Buenas prácticas

- **Solo cargar lo necesario**: cada módulo cargado consume memoria y reduce la superficie de ataque. Revisa qué tienes cargado con `lsmod` y blacklist lo que no uses.
- **Secure Boot**: si está activo, los módulos deben estar firmados o usarás `mokutil` para inscribir la firma. Las distros principales firman sus módulos.
- **Blacklist por archivo separado**: crea `/etc/modprobe.d/blacklist.conf` o archivos específicos por módulo (`/etc/modprobe.d/nvidia-blacklist.conf`) para mantener el orden.
- **Probar antes de añadir a initramfs**: carga el módulo con `modprobe` primero. Si funciona, entonces lo añades a initramfs para que esté disponible al arrancar.
- **Actualizar initramfs tras cambios**: después de modificar `mkinitcpio.conf` o `/etc/initramfs-tools/modules`, regenerar el initramfs.

## Ver también

- [[Proceso de Arranque (GRUB initramfs kernel params)]] — initramfs carga módulos esenciales
- [[Proc y Sys]] — `/proc/modules` (lo mismo que lsmod via kernel)
- [[Virtualización (KVM QEMU libvirt)]] — módulos vfio, kvm, kvm_amd/intel
- [[Firewall]] — módulos nftables, iptables (netfilter en kernel)
- [[SELinux y AppArmor]] — módulos de seguridad
- [[Cifrado (LUKS dm-crypt GPG)]] — módulo dm_crypt
- [[RAID (mdadm)]] — módulo md_mod

## Enlaces externos

- [Wikipedia — Loadable kernel module](https://en.wikipedia.org/wiki/Loadable_kernel_module)
- [Arch Wiki — Kernel modules](https://wiki.archlinux.org/title/Kernel_module)
- [Linux kernel documentation — modules](https://www.kernel.org/doc/html/latest/admin-guide/modules.html)

#sistema #kernel
