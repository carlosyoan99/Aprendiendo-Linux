---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: sistema
prioridad: alta
---

# GRUB — Grand Unified Bootloader

Bootloader por defecto en Ubuntu, Debian, Fedora y Arch. Soporta BIOS legacy y UEFI, Secure Boot (via shim), arranque desde LUKS y temas gráficos.

## Archivos principales

```bash
/boot/grub/grub.cfg              # configuración generada (NO EDITAR)
/etc/default/grub                # configuración editable del usuario
/etc/grub.d/                     # scripts que generan grub.cfg
```

## Configuración básica

```bash
sudo nano /etc/default/grub

GRUB_TIMEOUT=5                           # segundos de espera
GRUB_DEFAULT=0                           # entrada por defecto
GRUB_SAVEDEFAULT=true                    # recordar última entrada
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash" # params de kernel
GRUB_CMDLINE_LINUX=""                    # params adicionales
GRUB_DISABLE_OS_PROBER=false             # detectar otros SO
GRUB_ENABLE_CRYPTODISK=y                 # arranque desde LUKS
GRUB_GFXPAYLOAD_LINUX=keep               # mantener resolución

# Regenerar configuración
sudo update-grub                         # Debian/Ubuntu
sudo grub-mkconfig -o /boot/grub/grub.cfg  # Arch, Fedora
```

## Temas para GRUB

```bash
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
sudo ./install.sh -t tela -s 2k
```

## GRUB Rescue Shell

```bash
# En la shell grub>
ls                                  # listar discos
set root=(hd0,gpt2)                 # partición con /boot
linux /vmlinuz-linux root=/dev/sda3 # cargar kernel
initrd /initramfs-linux.img         # cargar initramfs
boot                                # arrancar
```

## Reinstalar GRUB

```bash
# Desde sistema funcionando (UEFI)
sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# Desde Live USB (chroot)
sudo mount /dev/sda2 /mnt
sudo mount /dev/sda1 /mnt/boot
sudo arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

## Ver también

- [[Limine]] — bootloader moderno minimalista
- [[systemd-boot]] — bootloader UEFI de systemd
- [[Bootloaders (GRUB Limine systemd-boot)]] — índice + comparativa
- [[Proceso de Arranque (GRUB initramfs kernel params)]]
- [[Cifrado (LUKS dm-crypt GPG)]] — arranque desde disco cifrado
- [[Dual Boot con Windows]]

## Enlaces externos

- [Wikipedia — GNU GRUB](https://en.wikipedia.org/wiki/GNU_GRUB)
- [Arch Wiki — GRUB](https://wiki.archlinux.org/title/GRUB)

#sistema #arranque
