---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: troubleshooting
prioridad: media
---

# USB no detecta

> Un dispositivo USB (memoria, disco externo, teclado, ratón, impresora, adaptador) no es reconocido por el sistema. No aparece en `lsusb`, no se monta automáticamente, o genera errores en `dmesg`.

## Síntoma

- El dispositivo no aparece en el gestor de archivos ni se monta.
- `lsusb` no muestra el dispositivo conectado.
- `dmesg` muestra errores como "device descriptor read/64, error -71" o "USB device not accepting address".
- El dispositivo se conecta y desconecta repetidamente (ciclo de conexión).
- Funciona en Windows/otro equipo pero no en Linux.
- El dispositivo necesita mucha energía y no funciona en un hub USB.

## Diagnóstico

```bash
# 1. ¿El dispositivo aparece en lsusb?
lsusb                              # lista todos los dispositivos USB
lsusb -v | grep -A 5 "ID <vid>:<pid>"  # info detallada del dispositivo

# 2. ¿El kernel lo detectó?
dmesg | tail -30                    # últimos mensajes del kernel
dmesg | grep -i usb                # todos los mensajes USB
dmesg | grep -iE "error|fail|reject|unable" | tail -10

# 3. ¿Aparece en /dev/?
ls -la /dev/sd*                    # discos USB (sdb, sdc, etc.)
lsblk                             # bloques montados
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,MODEL

# 4. Verificar hub USB y energía
lsusb -t                          # árbol USB con bus y dispositivo
cat /sys/bus/usb/devices/*/power/control  # estado de energía
lspci | grep -i usb               # controladoras USB

# 5. Verificar driver y módulos
lsmod | grep -iE "usb|storage|xhci|ehci"
modinfo usb-storage               # info del módulo USB storage

# 6. Verificar errores de energía
dmesg | grep -iE "over-current|power|reset"
lsusb -v | grep -i "MaxPower"    # consumo máximo del dispositivo

# 7. Verificar si el dispositivo tiene particiones
sudo fdisk -l /dev/sdb            # ver particiones del USB
sudo blkid /dev/sdb               # UUIDs y tipos de filesystem
```

### Logs relevantes

```bash
# Mensajes USB completos del boot
dmesg | grep -iE "usb|sd[a-z]|storage" | head -40

# Errores de USB (últimos 50 mensajes)
dmesg | grep -iE "usb.*error|usb.*fail|usb.*reset|descriptor" | tail -20

# Info del dispositivo USB específico
lsusb -v -d <vid>:<pid> 2>/dev/null | head -50

# Historial de conexión USB
journalctl -k | grep -iE "usb|sd[a-z]" | tail -30

# Verificar si el dispositivo es reconocido como SCSI
cat /proc/scsi/scsi | grep -A 5 "Host:"
```

## Causa

1. **USB suspend / power management** — el sistema apaga el puerto USB para ahorrar energía y no lo reactiva al conectar.
2. **Driver USB storage no cargado** — el módulo `usb-storage` no está en el initramfs o está blacklist.
3. **Controladora USB incompatible** — xHCI (USB 3.x) o EHCI (USB 2.0) con firmware buggy.
4. **Dispositivo consume demasiada energía** — un disco externo o hub sin alimentación externa.
5. **Filesystem corrupto en el dispositivo** — el dispositivo se conecta pero no se puede montar.
6. **Kernel no soporta el dispositivo** — dispositivo muy nuevo o muy exótico.
7. **AppArmor / udev rules bloquean** — reglas de seguridad impiden el acceso al dispositivo.

## Solución

### Caso 1: USB power management (el más común)

```bash
# Desactivar suspensión USB para todos los puertos
echo 'ACTION=="add", SUBSYSTEM=="usb", ATTR{power/control}="on"' | \
  sudo tee /etc/udev/rules.d/50-usb-power.rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# O para un puerto específico:
echo 'on' | sudo tee /sys/bus/usb/devices/X-Y/power/control

# Desactivar suspend USB en general (runtime PM):
echo 'auto' | sudo tee /sys/module/usbcore/parameters/autosuspend
# O permanentemente:
echo 'options usbcore autosuspend=-1' | sudo tee /etc/modprobe.d/usb-power.conf

# Para laptops: desactivar USB autosuspend en TLP
# En /etc/tlp.conf:
#   USB_AUTOSUSPEND=0
# sudo tlp start
```

### Caso 2: módulo usb-storage no cargado

```bash
# Cargar módulo manualmente
sudo modprobe usb-storage

# Verificar que está cargado
lsmod | grep usb_storage

# Si falta, instalar el paquete
sudo apt install linux-modules-extra-$(uname -r)  # Debian/Ubuntu
sudo pacman -S linux-firmware                       # Arch (incluye la mayoría)

# Para que cargue automáticamente en el arranque:
echo "usb-storage" | sudo tee /etc/modules-load.d/usb-storage.conf
```

### Caso 3: dispositivo no monta (filesystem corrupto o sin formato)

```bash
# Ver si hay particiones
sudo fdisk -l /dev/sdb
lsblk /dev/sdb

# Si hay particiones pero no monta
sudo fsck -y /dev/sdb1             # reparar filesystem

# Si no tiene filesystem
sudo mkfs.ext4 /dev/sdb1           # ⚠️ borra todo el contenido
# O
sudo mkfs.vfat -F 32 /dev/sdb1    # para compatibilidad Windows

# Montar manualmente
sudo mkdir -p /mnt/usb
sudo mount /dev/sdb1 /mnt/usb
ls /mnt/usb/
```

### Caso 4: dispositivo no aparece en lsusb

```bash
# Reiniciar el subsistema USB
sudo usbreset                      # si tienes usbutils
# O manualmente:
echo '-1' | sudo tee /sys/bus/usb/drivers/usb/unbind  # ⚠️ peligroso, mejor:
sudo udevadm trigger --subsystem-match=usb

# Verificar controladora USB
lspci | grep -i usb
lsmod | grep -iE "xhci_pci|ehci_pci|xhci_hcd|ehci_hcd"

# Cargar módulos de controladora
sudo modprobe xhci_pci             # USB 3.x
sudo modprobe ehci_pci              # USB 2.0

# Reiniciar udev
sudo systemctl restart systemd-udevd
```

### Caso 5: dispositivo conecta y desconecta (ciclo)

```bash
# Causa típica: falta energía o descriptor corrupto
# Desde dmesg:
dmesg | tail -10  # ver si dice "device not accepting address" o "over-current"

# Si es problema de energía:
# - Usar hub USB con alimentación externa
# - Conectar directamente al puerto (sin hub)
# - Probar otro puerto USB (frontal vs trasero)

# Si es problema de descriptor:
sudo udevadm trigger --subsystem-match=usb
# O reiniciar el USB completo:
echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind
sleep 2
echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind
```

### Caso 6: dispositivo USB funciona pero es lento (USB 2.0 en puerto 3.x)

```bash
# Verificar velocidad del puerto
lsusb -t                          # muestra "M" (high speed) o "G" (super speed)
cat /sys/bus/usb/devices/*/speed  # 12, 480, 5000, etc.

# Si está a 12 Mbps (USB 1.x) o 480 Mbps (USB 2.0) en puerto 3.0:
# - Probar otro puerto físico
# - Verificar cables (USB 2.0 vs 3.0)
# - Verificar que xhci_hcd está cargado (no ehci_hcd)
lsmod | grep -E "xhci|ehci"
```

### Verificación

```bash
# Tras aplicar la solución:
lsusb                              # dispositivo debe aparecer
dmesg | tail -5                    # sin errores
lsblk                              # partición visible
sudo mount /dev/sdb1 /mnt/usb     # monta correctamente
ls /mnt/usb/                      # archivos accesibles
```

## Escenarios / Variantes

| Variante / Síntoma | Causa típica | Solución rápida |
|---|---|---|
| **Disco externo no monta** | power management o sin filesystem | `echo on > /sys/bus/usb/devices/*/power/control` + `fdisk -l` |
| **Teclado/ratón USB no funciona** | driver HID no cargado | `sudo modprobe hid-generic`, probar otro puerto |
| **USB 3.0 muy lento** | funciona en modo 2.0 | Verificar cable, verificar `xhci_hcd` cargado, probar otro puerto |
| **Memoria USB no aparece** | udev rules o AppArmor | `dmesg \| grep usb`, verificar `/etc/udev/rules.d/` |
| **Adaptador Ethernet USB no conecta** | driver específico faltante | `lsusb` → identificar chipset → instalar driver (rtl8152, ax88179) |
| **USB no funciona tras suspender** | módulo USB no se reinicia | `sudo modprobe -r ehci_pci && sudo modprobe ehci_pci` o configurar TLP |
| **Dispositivo USB en VM** | no passthrough a la VM | En VirtualBox: USB filter, en KVM: `virsh edit` con `<hostdev>` |
| **"USB device not responding"** | controladora USB con firmware buggy | Actualizar BIOS, desactivar USB 3.1 en BIOS, probar puerto 2.0 |

## Prevención

1. **Desactivar USB autosuspend** en TLP para dispositivos que necesitan estar siempre conectados.
2. **Usar hubs con alimentación externa** para dispositivos de alto consumo (discos externos, cámaras).
3. **No desconectar discos externos sin desmontar** — usa `umount` o el botón de expulsar del gestor de archivos.
4. **Mantener el kernel actualizado** — muchos fixes de USB se lanzan en point releases.
5. **Verificar la compatibilidad** del adaptador USB antes de comprarlo (especialmente WiFi, Ethernet y Bluetooth).

## Notas adicionales

- Los puertos USB delanteros de un PC de escritorio suelen tener menos energía que los traseros — conectar dispositivos de alto consumo en los traseros.
- Algunos chipsets AMD (X570, B550) tienen bugs conocidos con USB 3.x — actualizar BIOS frecuentemente.
- Si un USB funciona pero no otro, puede ser un problema físico del puerto — probar con un hub externo para descartar.
- `usbutils` (paquete que contiene `lsusb`) es esencial para diagnosticar — instalar con `sudo apt install usbutils`.
- Para discos USB con particiones NTFS, instalar `ntfs-3g`: `sudo apt install ntfs-3g`.

## Enlaces externos

- [Arch Wiki — USB storage](https://wiki.archlinux.org/title/USB_storage_devices)
- [Arch Wiki — General troubleshooting (USB)](https://wiki.archlinux.org/title/General_troubleshooting#Troubleshooting_USB_devices)
- [Linux USB project](https://www.linux-usb.org/)
- [Ubuntu Wiki — USB troubleshooting](https://help.ubuntu.com/community/USB/)

## Ver también

- [[Disco lleno (No space left on device)]] — problemas de espacio en discos
- [[Error de permisos]] — permisos al acceder a dispositivos
- [[lsusb]] — comandos para inspeccionar USB
- [[lsblk]] — comandos para ver discos y particiones
- [[Gestión de energía y batería]] — power management que afecta USB

#troubleshooting #usb #hardware
