---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: sistema
prioridad: alta
---

# Limine

Bootloader moderno, minimalista y altamente configurable. Soporta UEFI y BIOS Legacy, arranque por red (PXE), Secure Boot parcial, e interfaz gráfica con imágenes. Bootloader por defecto de SerenityOS.

## Características

- Soporte UEFI y BIOS Legacy
- Interfaz gráfica (bmp, tga, png)
- Configuración en texto plano (similar a systemd-boot)
- Arranque por red (PXE)
- Detección automática de kernels
- Soporte para initrd múltiple y microcódigo

## Instalación

```bash
git clone https://github.com/limine-bootloader/limine.git
cd limine
make
sudo make install
sudo ./limine-install-linux /dev/sda    # instalar en MBR o GPT (UEFI)
```

## Configuración

```bash
# /boot/limine.cfg
TIMEOUT=5

:Arch Linux
PROTOCOL=linux
KERNEL_PATH=boot:/vmlinuz-linux
MODULE_PATH=boot:/initramfs-linux.img
MODULE_PATH=boot:/intel-ucode.img
CMDLINE=root=UUID=1234-5678 rw quiet

:Arch Linux (fallback)
PROTOCOL=linux
KERNEL_PATH=boot:/vmlinuz-linux
MODULE_PATH=boot:/initramfs-linux-fallback.img
CMDLINE=root=UUID=1234-5678 rw
```

## Ventajas frente a GRUB

- Configuración más simple (no scripts)
- Arranque más rápido
- Mejor soporte gráfico (menús con imágenes)
- Consume menos recursos

## Ver también

- [[GRUB]] — bootloader tradicional
- [[systemd-boot]] — bootloader UEFI de systemd
- [[Bootloaders (GRUB Limine systemd-boot)]] — índice + comparativa
- [[Proceso de Arranque (GRUB initramfs kernel params)]]

## Enlaces externos

- [GitHub — limine-bootloader/limine](https://github.com/limine-bootloader/limine)
- [Wikipedia — Limine](https://en.wikipedia.org/wiki/Limine_(boot_loader))

#sistema #arranque
