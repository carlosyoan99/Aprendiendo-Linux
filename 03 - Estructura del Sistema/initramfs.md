---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: media
---

# initramfs

> Sistema de archivos inicial comprimido que se carga en memoria junto al kernel. Provee drivers y scripts necesarios para montar la raíz real del sistema.

## Qué es

El initramfs es un pequeño filesystem (típicamente 20-100 MB) que contiene los módulos del kernel y scripts mínimos necesarios para:
1. Montar el root filesystem real (puede estar en LVM, LUKS, RAID, NFS)
2. Cargar drivers (NVMe, USB, SCSI, GPU)
3. Ejecutar `switch_root` para pasar al sistema real

```
BIOS/UEFI → Bootloader → Kernel + initramfs → /init → mount root → switch_root → systemd/init
```

## Herramientas de generación

| Herramienta | Distribuciones |
|---|---|
| **update-initramfs** | Debian, Ubuntu, Mint |
| **mkinitcpio** | Arch, Manjaro, EndeavourOS |
| **dracut** | Fedora, RHEL, CentOS, openSUSE |

## Comandos

### Debian/Ubuntu
```bash
# Regenerar initramfs para el kernel actual
sudo update-initramfs -u

# Regenerar para todos los kernels instalados
sudo update-initramfs -u -k all

# Verificar tamaño
ls -lh /boot/initrd*
```

### Arch Linux
```bash
# Regenerar para todos los kernels
sudo mkinitcpio -P

# Verificar configuración
sudo mkinitcpio -v
```

### Fedora/RHEL
```bash
# Regenerar para el kernel actual
sudo dracut --force

# Regenerar con verbose
sudo dracut -f -v
```

## Cuándo regenerar

| Situación | Comando |
|---|---|
| Actualizar kernel | Automático (post-install hook) |
| Instalar driver NVIDIA/AMD | `sudo update-initramfs -u` |
| Cambiar a LUKS/LVM | `sudo update-initramfs -u` |
| Corrupto o faltante | Desde Live USB: `chroot` + `update-initramfs -u` |
| Cambiar root UUID | `sudo update-initramfs -u` + `update-grub` |

## Contenido típico

```
/init                    → script principal
/lib/modules/            → módulos del kernel
/bin/busybox             → utilidades mínimas
/etc/                    → configuración mínima
/usr/                    → herramientas de rescate (opcional)
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| "Kernel panic: unable to mount root" | initramfs faltante o corrupto | `update-initramfs -u` desde chroot |
| "Gave up waiting for root device" | UUID en fstab no coincide | `blkid` + corregir fstab |
| Boot lento (5+ seg en initramfs) | initramfs demasiado grande | `COMPRESS=zstd` en mkinitcpio.conf |
| No encuentra disco NVMe | Falta módulo nvme | Añadir `nvme` a MODULES en mkinitcpio.conf |

## Ver también

- [[Proceso de Arranque (GRUB initramfs kernel params)]] — flujo completo de arranque
- [[Bootloaders (GRUB Limine systemd-boot)]] — bootloader
- [[Módulos del kernel (lsmod modprobe blacklist)]] — gestión de módulos
- [[Cifrado (LUKS dm-crypt GPG)]] — cifrado que requiere initramfs

## Enlaces externos

- [Arch Wiki — initramfs](https://wiki.archlinux.org/title/Initramfs)
- [Debian Wiki — initramfs](https://wiki.debian.org/initramfs)
- [Wikipedia — initramfs](https://en.wikipedia.org/wiki/Initramfs)

#sistema #boot
