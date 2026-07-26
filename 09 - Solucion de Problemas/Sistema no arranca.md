---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: troubleshooting
prioridad: alta
---

# Sistema no arranca

> Troubleshooting completo cuando Linux no llega al login: desde la pantalla negra hasta GRUB, kernel panic, y filesystem roto.

## Síntoma

El sistema no muestra el escritorio ni la pantalla de login. Puede quedarse en negro, mostrar GRUB, o mostrar un error del kernel.

## Diagnóstico según dónde falla

### 1. Pantalla negra (sin GRUB)

```bash
# Si GRUB no aparece:
# - BIOS: verificar boot order en BIOS/UEFI
# - UEFI: verificar Secure Boot, CSM
# - Live USB: bootear y reparar GRUB

# Desde Live USB:
sudo mount /dev/sda2 /mnt          # partición raíz
sudo mount /dev/sda1 /mnt/boot     # partición boot (si separada)
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo chroot /mnt
grub-install /dev/sda
update-grub
exit
```

### 2. GRUB aparece pero no arranca Linux

```bash
# En GRUB: presionar 'e' para editar
# Buscar la línea que empieza con 'linux'
# Añadir al final:
#   init=/bin/bash          → entrar en shell root
#   single                  → modo single-user
#   nomodeset               → saltar drivers gráficos
#   systemd.unit=rescue.target → modo rescate

# Una vez en shell root:
mount -o remount,rw /         # montar root lectura/escritura
passwd                        # cambiar contraseña root si olvidada
exec /sbin/init               # continuar arranque normal
```

### 3. Kernel panic

```bash
# Mensaje típico:
# "Kernel panic - not syncing: VFS: Unable to mount root fs"
# "Kernel panic - attempted to kill init!"

# Causas comunes:
# - initramfs corrupto o faltante
# - disco lleno en /boot
# - driver incompatible con kernel actualizado

# Solución desde Live USB:
sudo mount /dev/sda2 /mnt
ls /mnt/boot/initrd*           # ¿existe initramfs?
# Si falta o está corrupto:
sudo chroot /mnt
update-initramfs -u -k all
update-grub
```

### 4. Filesystem roto / disco lleno

```bash
# Desde Live USB o modo rescate:
sudo fsck -y /dev/sda2         # reparar filesystem

# Si disco lleno en /:
sudo mount -o remount,rw /
du -sh /* | sort -rn | head    # qué carpeta más pesa
journalctl --vacuum-size=100M  # limpiar logs
sudo apt clean                 # limpiar caché apt
sudo rm /tmp/*                 # limpiar tmp
```

### 5. Initramfs no encuentra root

```bash
# Error: "Gave up waiting for root device"
# Causa: UUID del fstab no coincide con el disco

# Desde Live USB:
blkid                          # ver UUIDs reales
cat /mnt/etc/fstab             # ver UUIDs configurados
# Editar fstab para corregir UUIDs
sudo nano /mnt/etc/fstab
```

### 6. Pantalla negra post-driver

```bash
# Si falla tras instalar drivers NVIDIA/AMD:
# Desde GRUB → 'e' → añadir:
#   nomodeset

# Una vez dentro:
sudo apt purge nvidia-*        # desinstalar drivers problemáticos
sudo ubuntu-drivers autoinstall # reinstalar correctamente
```

## Flujo de decisión

```
¿Aparece GRUB?
├── NO → verificar BIOS/UEFI, boot order, Secure Boot
├── SÍ → ¿qué error muestra?
│   ├── "error: file not found" → GRUB apunta a kernel equivocado
│   │   └── update-grub desde Live USB
│   ├── Kernel panic → initramfs o root device
│   │   ├── "unable to mount root" → initramfs corrupto
│   │   │   └── update-initramfs -u desde chroot
│   │   └── "VFS: Cannot open root" → fstab/UUID mal
│   │       └── blkid + corregir fstab
│   ├── Pantalla negra → drivers gráficos
│   │   └── nomodeset, purgar drivers
│   └── "Root filesystem ro" → disco lleno o dañado
│       └── fsck + limpiar espacio
```

## Prevención

- Mantener 2 kernels en `/boot` (no eliminar el anterior al actualizar)
- Usar `timeshift` para snapshots antes de actualizar
- No llenar `/boot` — monitorear con `df -h /boot`
- Mantener Live USB de rescate lista
- No instalar drivers desde fuentes no oficiales sin verificar compatibilidad

## Ver también

- [[Pantalla en negro tras actualizar drivers]] — troubleshooting específico GPU
- [[GRUB no arranca]] — reparación de bootloader
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — cómo arranca Linux
- [[Bootloaders (GRUB Limine systemd-boot)]] — opciones de bootloader
- [[Dual Boot con Windows]] — reparación de boot en dual boot

## Enlaces externos

- [Arch Wiki — Boot troubleshooting](https://wiki.archlinux.org/title/General_troubleshooting)
- [Ubuntu Recovery Mode](https://help.ubuntu.com/community/RecoveryMode)
- [systemd emergency mode](https://www.freedesktop.org/software/systemd/man/systemd.special.html)

#troubleshooting #boot
