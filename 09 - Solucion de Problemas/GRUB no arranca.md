---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: troubleshooting
sistema: GRUB
prioridad: alta
---

# GRUB no arranca / sistema no bootea

## Síntoma

Al encender el equipo aparece una pantalla negra, un mensaje de "GRUB rescue", "No bootable device", o el sistema arranca directamente a Windows ignorando Linux.

## Diagnóstico

```bash
# Desde un live USB (cualquier distro):
lsblk                                      # identificar particiones (root, EFI)
sudo fdisk -l /dev/sda                    # ver tabla de particiones

# Identificar la partición EFI
sudo blkid | grep vfat                     # la partición FAT32 es la EFI
# Normalmente es /dev/sda1 o /dev/nvme0n1p1

# Identificar la partición root de Linux
sudo blkid | grep ext4                     # o btrfs
```

## Causa

1. **GRUB no instalado o sobrescrito** — Windows Update o una reinstalación de Windows pisó el bootloader.
2. **Orden de arranque incorrecto** — la BIOS/UEFI no arranca desde la partición EFI correcta.
3. **Configuración de GRUB corrupta** — tras una actualización del kernel, GRUB no se regeneró.
4. **Secure Boot bloqueando GRUB** — algunas distros necesitan Secure Boot desactivado o con shim.

## Solución

### 1. Reparar GRUB desde live USB

```bash
# Arrancar desde el live USB, abrir terminal

# Identificar particiones
lsblk
# Suponiendo: /dev/sda2 = root (ext4/btrfs), /dev/sda1 = EFI (FAT32)

# Montar el sistema
sudo mount /dev/sda2 /mnt
sudo mount /dev/sda1 /mnt/boot/efi         # o /mnt/boot si EFI está en /boot

# Chroot al sistema instalado
for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
sudo chroot /mnt

# Reinstalar GRUB
grub-install /dev/sda                      # instalar en el disco (no partición)
update-grub                                # regenerar config
exit
sudo reboot
```

### 2. Sin live USB (si llegas al rescue shell de GRUB)

```bash
# En la pantalla "grub rescue>" :
ls                                         # listar particiones (hd0,msdos1, etc.)
set root=(hd0,msdos1)                      # partición donde está /boot
set prefix=(hd0,msdos1)/boot/grub
insmod normal
normal                                     # si funciona, arranca GRUB completo
# Una vez dentro de Linux:
sudo update-grub
sudo grub-install /dev/sda
```

### 3. Arreglar orden de arranque en UEFI

```bash
# Desde Linux funcionando:
sudo efibootmgr -v                        # listar entradas de arranque
sudo efibootmgr -o 0000,0001              # cambiar orden (poner Linux primero)

# Desde BIOS: entrar a boot menu (F2/F12/Del) y mover "Linux" o "GRUB" al primer lugar
```

## Ver también

- [[Proceso de Arranque (GRUB initramfs kernel params)]] — boot process completo
- [[Bootloaders (GRUB Limine systemd-boot)]] — comparativa de bootloaders
- [[Dual Boot con Windows]] — gestión de GRUB con Windows
- [[Cifrado (LUKS dm-crypt GPG)]] — si el root está cifrado, GRUB necesita configuración extra

## Referencias

- Arch Wiki: [GRUB](https://wiki.archlinux.org/title/GRUB)
- Ubuntu Help: [GRUB/Troubleshooting](https://help.ubuntu.com/community/Grub2/Troubleshooting)

#troubleshooting
