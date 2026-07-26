---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: troubleshooting
sistema: GRUB
prioridad: alta
---

# GRUB no arranca / sistema no bootea

## Síntoma

Al encender el equipo aparece una pantalla negra, un mensaje de **"GRUB rescue"**, **"No bootable device"**, un **kernel panic**, o el sistema arranca directamente a Windows ignorando Linux.

## Diagnóstico inicial

```bash
# Desde un live USB (cualquier distro):
lsblk                                      # identificar particiones (root, EFI)
sudo fdisk -l /dev/sda                     # ver tabla de particiones

# Identificar la partición EFI
sudo blkid | grep vfat                     # la partición FAT32 es la EFI
# Normalmente es /dev/sda1 o /dev/nvme0n1p1

# Identificar la partición root de Linux
sudo blkid | grep ext4                     # o btrfs, o LUKS

# Verificar estado de Secure Boot
mokutil --sb-state                         # enabled/disabled

# Verificar si arranca en UEFI o BIOS legacy
ls /sys/firmware/efi/                      # si existe → UEFI
```

## Causas

1. **GRUB no instalado o sobrescrito** — Windows Update o una reinstalación de Windows pisó el bootloader
2. **Orden de arranque incorrecto** — la BIOS/UEFI no arranca desde la partición EFI correcta
3. **Configuración de GRUB corrupta** — tras una actualización, GRUB no se regeneró
4. **Secure Boot bloqueando GRUB** — shim no firmado o MOK no enrolado
5. **LUKS + GRUB mal configurado** — falta `GRUB_ENABLE_CRYPTODISK=y` o el initramfs no tiene los módulos de cifrado
6. **Kernel panic** — root UUID incorrecto, initramfs corrupto o faltante

---

## Escenarios de recuperación

### 1. Reparar GRUB desde live USB (chroot recovery)

El método universal para cualquier distro:

```bash
# Arrancar desde el live USB, abrir terminal

# Identificar particiones
lsblk
# Suponiendo: /dev/sda2 = root (ext4/btrfs), /dev/sda1 = EFI (FAT32)

# Montar el sistema
sudo mount /dev/sda2 /mnt
sudo mount /dev/sda1 /mnt/boot/efi         # o /mnt/boot si EFI está en /boot

# Si el root está cifrado con LUKS:
sudo cryptsetup luksOpen /dev/sda2 root    # desbloquear (pedirá passphrase)
sudo mount /dev/mapper/root /mnt

# Chroot al sistema (dos métodos):

# Método A — arch-chroot (Arch Linux, recomendado si disponible)
sudo arch-chroot /mnt

# Método B — chroot manual (todas las distros)
for i in /dev /dev/pts /proc /sys /run; do
    sudo mount --bind "$i" "/mnt$i"
done
sudo chroot /mnt /bin/bash

# Ya dentro del chroot:
grub-install /dev/sda                      # instalar en el disco (no partición)
update-grub                                # regenerar config (Debian/Ubuntu)
# O: grub-mkconfig -o /boot/grub/grub.cfg  # Arch, Fedora

# Si el sistema es UEFI, especificar target:
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

exit
sudo reboot
```

### 2. Sin live USB (GRUB rescue shell)

Si llegas a la pantalla `grub rescue>` sin necesidad de live USB:

```bash
# En la shell grub rescue>
ls                                         # listar particiones (hd0,msdos1, hd0,gpt1...)
set root=(hd0,2)                           # probar particiones hasta encontrar /boot
set prefix=(hd0,2)/boot/grub
insmod normal
normal                                     # si funciona, carga GRUB completo

# Si normal falla, arrancar manualmente:
insmod ext4                                # o btrfs, xfs según tu FS
linux /vmlinuz-linux root=/dev/sda2        # o root=UUID=...
initrd /initramfs-linux.img
boot

# Una vez dentro de Linux:
sudo update-grub
sudo grub-install /dev/sda
```

### 3. Secure Boot bloquea GRUB

Si al arrancar ves mensajes de **"Invalid signature"** o **"Security violation"**, Secure Boot está bloqueando GRUB:

```bash
# Solución A — desactivar Secure Boot (temporal)
# Desde BIOS/UEFI → Security → Secure Boot → Disabled

# Solución B — firmar GRUB con MOK (Machine Owner Key, permanente)
# Instalar sbctl (recomendado frente a sbsigntools manual):
sudo pacman -S sbctl                       # Arch
sudo apt install sbctl                     # Debian/Ubuntu (si disponible)

# Enrolar claves propias más las de Microsoft
sudo sbctl enroll-keys -m                  # -m = incluye claves Microsoft

# Firmar GRUB y kernel
sudo sbctl sign -s /boot/vmlinuz-linux     # firmar kernel
sudo sbctl sign -s /boot/efi/EFI/GRUB/grubx64.efi  # firmar GRUB

# Verificar estado
sbctl status                               # Setup Mode: User, Secure Boot: enabled
sbctl verify                               # ver qué archivos están firmados

# Solución C — importar MOK manualmente (cuando sbctl no está disponible)
sudo mokutil --import MOK.der              # importar clave
# Tras reinicio, el firmware mostrará un menú azul MOK para confirmar
```

### 4. LUKS + GRUB (root cifrado)

Si el disco raíz está cifrado con LUKS y GRUB no pide la passphrase:

```bash
# Configurar GRUB para soportar LUKS
# Editar /etc/default/grub:
echo 'GRUB_ENABLE_CRYPTODISK=y' | sudo tee -a /etc/default/grub

# Reinstalar GRUB con los módulos cripto necesarios
sudo grub-install --target=x86_64-efi --efi-directory=/boot \
    --modules="cryptodisk luks2 gcry_rijndael gcry_sha256" \
    --bootloader-id=GRUB

# Regenerar configuración
sudo update-grub

# Notas importantes:
# — GRUB soporta LUKS2, pero el PBKDF Argon2 puede ser lentísimo en GRUB
# — Si el sistema se cuelga 30+ segundos pidiendo passphrase, considera
#   crear un keyslot LUKS1 aparte solo para GRUB:
#   sudo cryptsetup luksAddKey /dev/sda2 --pbkdf pbkdf2

# Si ya tienes GRUB_ENABLE_CRYPTODISK=y y sigue sin funcionar:
# Verificar que /boot esté dentro de la partición cifrada
# Si /boot está fuera (partición separada sin cifrar), GRUB no necesita cryptodisk
```

### 5. Kernel panic al arrancar

Aparece un error como:

```
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
```

**Causas y soluciones:**

| Causa | Diagnóstico | Solución |
|---|---|---|
| **UUID de root incorrecto** | `cat /proc/cmdline` muestra UUID que no coincide con `blkid` | Arreglar `GRUB_CMDLINE_LINUX` en `/etc/default/grub` y regenerar |
| **initramfs corrupto o faltante** | `/boot/initramfs-*` no existe o está vacío | Regenerar: `update-initramfs -u -k all` (Debian/Ubuntu) o `mkinitcpio -P` (Arch) o `dracut -f` (Fedora) |
| **Falta driver del FS en initramfs** | El kernel no reconoce ext4/btrfs/xfs | Añadir módulo a `/etc/mkinitcpio.conf` (Arch) o `/etc/initramfs-tools/modules` (Debian) |
| **Cambio de disco o clonación** | UUID cambió al clonar | Actualizar `/etc/fstab` y regenerar initramfs |

**Solución rápida desde live USB:**
```bash
# Chroot como en el escenario 1, luego:
sudo update-initramfs -u -k all            # Debian/Ubuntu
# o
sudo mkinitcpio -P                         # Arch
# o
sudo dracut -f                             # Fedora

# Siempre regenerar GRUB después:
sudo update-grub
```

### 6. Rescue mode (modo rescate del sistema)

Cuando el sistema arranca pero no llega al login:

```bash
# En el menú de GRUB: seleccionar entrada, presionar e
# En la línea linux / vmlinuz... añadir al final:
systemd.unit=rescue.target                 # servicios básicos + shell root
# o
systemd.unit=emergency.target              # shell mínima (ni FS montados)
# o
init=/bin/bash rw                          # arranque directo a bash (como último recurso)

# Presionar Ctrl+X o F10 para arrancar

# Ya en rescue shell:
mount -o remount,rw /                      # si no se montó en rw

# Diagnosticar:
# Nota: en emergency.target puede que journald no esté disponible.
# Usar dmesg como alternativa:
dmesg | tail -50                           # logs del kernel
journalctl -xb                             # logs de arranque (si journald está activo)
systemctl list-units --failed              # servicios que fallaron
fsck /dev/sda2                             # verificar sistema de archivos
```

### 7. Arreglar orden de arranque en UEFI

Cuando el sistema está intacto pero la BIOS arranca a Windows o no encuentra GRUB:

```bash
# Desde Linux funcionando:
sudo efibootmgr -v                         # listar entradas de arranque
sudo efibootmgr -o 0000,0001               # cambiar orden (poner Linux primero)

# Si no aparece la entrada de GRUB, crearla:
sudo efibootmgr -c -d /dev/sda -p 1 -L "GRUB" -l \\EFI\\GRUB\\grubx64.efi

# Desde BIOS: entrar a boot menu (F2/F12/Del) y mover "GRUB" o "Linux" al primer lugar
```

## Prevención

```bash
# 1. Regenerar GRUB tras cada actualización del kernel
#    (la mayoría de distros lo hacen automáticamente via hooks)

# 2. Tener siempre un live USB a mano (de la misma distro si posible)

# 3. Configurar GRUB para mostrar el menú (útil para rescue mode):
sudo sed -i 's/GRUB_TIMEOUT_STYLE=hidden/#GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub
sudo update-grub

# 4. Mantener al menos un kernel antiguo en el sistema (para fallback)
#    No ejecutar limpiezas automáticas sin revisar cuántos kernels quedan

# 5. Si usas LUKS: asegurar que GRUB_ENABLE_CRYPTODISK=y está configurado
#    antes de cifrar la raíz — si lo activas después, reinstalar GRUB
```

## Ver también

- [[Proceso de Arranque (GRUB initramfs kernel params)]] — boot process completo
- [[Bootloaders (GRUB Limine systemd-boot)]] — comparativa de bootloaders
- [[Dual Boot con Windows]] — gestión de GRUB con Windows
- [[Cifrado (LUKS dm-crypt GPG)]] — si el root está cifrado, GRUB necesita configuración extra
- [[Pantalla en negro tras actualizar drivers]] — solución al añadir `nomodeset`

## Enlaces externos

- [Arch Wiki — GRUB](https://wiki.archlinux.org/title/GRUB)
- [Arch Wiki — Secure Boot](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot)
- [Ubuntu Help — GRUB2/Troubleshooting](https://help.ubuntu.com/community/Grub2/Troubleshooting)
- [Fedora — GRUB and Secure Boot](https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/kernel-module-driver-configuration/Working_with_the_GRUB_2_Boot_Loader/)
- [sbctl — GitHub](https://github.com/Foxboron/sbctl)
- [Dmitry Frank — LUKS + GRUB guide](https://dmitry.gr/?r=05e3b48c-266f-41c1-96c7-3b1b9c18c9b3)

#troubleshooting
