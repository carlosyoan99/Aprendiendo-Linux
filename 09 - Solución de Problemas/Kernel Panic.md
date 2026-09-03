---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: troubleshooting
prioridad: alta
---

# Kernel Panic

> El kernel detiene toda actividad del sistema y muestra un mensaje de error crítico. El equipo se congela o se reinicia automáticamente. Las causas van desde initramfs corrupto hasta hardware defectuoso o módulos incompatibles.

## Síntoma

- Pantalla con texto blanco/negro mostrando "Kernel panic - not syncing" y un stack trace.
- El sistema se congela completamente (ni Ctrl+Alt+Del responde).
- Se reinicia solo después de mostrar el error.
- Error "VFS: Unable to mount root fs on unknown-block"
- Error "Attempted to kill init!"
- Ocurre al arrancar, al actualizar kernel, o tras instalar un módulo nuevo.

## Diagnóstico

```bash
# 1. Capturar el mensaje de error exacto
# Si el equipo se reinicia rápido, añadir al GRUB:
#   systemd.unit=rescue.target
# o grabar pantalla / sacar foto del error

# 2. Desde GRUB → presionar 'e' → editar línea linux:
#   init=/bin/bash          → shell root sin passwd
#   single                  → modo single-user
#   systemd.unit=rescue.target → modo rescate
#   nomodeset               → saltar drivers GPU

# 3. Verificar initramfs desde Live USB o shell root
ls -la /boot/initrd*       # ¿existe el initramfs?
file /boot/initrd*         # ¿es un gzip válido?
lsinitramfs /boot/initrd*  # contents del initramfs (Ubuntu/Debian)

# 4. Verificar espacio en /boot
df -h /boot
du -sh /boot/*

# 5. Verificar integridad del filesystem
sudo fsck -n /dev/sda2     # solo lectura (no modificar)

# 6. Verificar hardware
sudo memtest86+             # errores de RAM (desde GRUB o USB)
sudo dmesg | grep -iE "error|fail|panic|oops"  # errores kernel recientes
sudo journalctl -b -p err   # logs del último boot con errores

# 7. Verificar módulos del kernel
lsmod | head -20            # módulos cargados
dmesg | grep -i "module"    # errores de módulos
modinfo <modulo>            # info de un módulo específico
```

### Logs relevantes

```bash
# Último crash registrado
sudo journalctl -b -1 -p err  # logs del boot anterior (si hubo reinicio)
sudo journalctl -b -1 | grep -iE "panic|oops|bug|call trace"

# Leer logs del crash desde Live USB
sudo mount /dev/sda2 /mnt
sudo cat /mnt/var/log/kern.log | grep -iE "panic|oops|call trace" | tail -30
sudo cat /mnt/var/log/syslog | grep -iE "panic|oops" | tail -30

# Si se usa systemd-coredump
sudo coredumpctl list        # listar crashes recientes
sudo coredumpctl info <PID>  # info de un crash específico
```

## Causa

1. **initramfs corrupto o faltante** — la imagen initramfs no contiene los módulos necesarios para montar root (disco NVMe, controladora RAID, LVM).
2. **Disco /boot lleno** — al actualizar kernel no se genera initramfs nuevo porque no cabe en /boot.
3. **Módulo del kernel incompatible** — driver compilado para otra versión del kernel (VirtualBox, NVIDIA, módulos DKMS).
4. **Hardware defectuoso** — RAM con errores, disco con sectores dañados, CPU inestable.
5. **Actualización incompleta** — kernel nuevo instalado pero initramfs no regenerado, o paquetes dependencia rotos.
6. **Parámetros de arranque incorrectos** — UUID equivocado en GRUB, root device mal especificado.
7. **Filesystem corrompido** — bloques dañados impiden montar root.

## Solución

### Caso 1: initramfs corrupto o faltante (el más común)

```bash
# Desde Live USB:
sudo mount /dev/sda2 /mnt                    # partición root
sudo mount /dev/sda1 /mnt/boot               # partición boot (si separada)
for d in dev dev/pts proc sys run; do
  sudo mount --bind /$d /mnt/$d
done
sudo chroot /mnt

# Regenerar initramfs para todos los kernels instalados
update-initramfs -u -k all                    # Debian/Ubuntu
mkinitcpio -P                                 # Arch Linux
dracut --force --regenerate-all                # Fedora/RHEL

# Actualizar GRUB
update-grub                                   # Debian/Ubuntu
grub-mkconfig -o /boot/grub/grub.cfg          # Arch Linux

exit
```

### Caso 2: disco /boot lleno

```bash
# Desde Live USB o shell root:
sudo mount -o remount,rw /

# Ver qué kernels hay en /boot
ls -la /boot/vmlinuz* /boot/initrd*
dpkg -l | grep linux-image                     # Debian/Ubuntu
pacman -Q linux linux-lts                       # Arch

# Eliminar kernels antiguos (conservar el actual + uno anterior)
sudo apt remove --purge linux-image-X.X.X-*-generic  # Debian/Ubuntu
# Arch: eliminar paquetes linux-X.XX.X-1 (no el -2 más nuevo)

# Verificar espacio
df -h /boot
```

### Caso 3: módulo DKMS incompatible

```bash
# Desde shell root o rescue mode:
# Desinstalar módulo problemático
sudo dkms status                              # ver módulos instalados
sudo dkms remove <modulo>/<version> --all     # desinstalar

# O desactivar carga del módulo
echo "blacklist <nombre_modulo>" | sudo tee /etc/modprobe.d/blacklist-<modulo>.conf
sudo update-initramfs -u

# Para VirtualBox (caso típico):
sudo dkms remove vboxhost/7.0.0 --all
sudo apt purge virtualbox-dkms

# Para NVIDIA (caso típico):
sudo apt purge nvidia-*
sudo ubuntu-drivers autoinstall               # reinstalar limpio
```

### Caso 4: UUID incorrecto en GRUB o fstab

```bash
# Desde Live USB:
blkid                                           # UUIDs reales del disco
cat /mnt/etc/fstab                              # UUIDs configurados
cat /mnt/etc/default/grub | grep_CMDLINE_LINUX  # UUID en GRUB

# Corregir fstab si hay UUIDs que no coinciden
sudo nano /mnt/etc/fstab
# También verificar GRUB:
sudo nano /mnt/etc/default/grub
# Buscar: GRUB_CMDLINE_LINUX="root=UUID=..."
# Corregir con el UUID real de blkid

# Regenerar GRUB
sudo chroot /mnt
update-grub
```

### Caso 5: filesystem corrompido

```bash
# Desde Live USB (IMPORTANTE: el disco NO debe estar montado):
sudo fsck -y /dev/sda2         # reparar filesystem
sudo fsck -y /dev/sda1         # reparar /boot si es separada

# Si fsck no puede reparar:
sudo fsck -y -f /dev/sda2      # forzar revisión completa

# Verificar integridad del disco
sudo smartctl -a /dev/sda      # SMART health
sudo badblocks -v /dev/sda2    # buscar bloques dañados
```

### Caso 6: panic al cargar módulo específico

```bash
# Desde GRUB → 'e' → añadir al final de la línea linux:
#   modprobe.blacklist=<nombre_modulo>

# Ejemplo: blacklist nouveau para NVIDIA
#   modprobe.blacklist=nouveau

# Una vez dentro del sistema:
echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
sudo update-initramfs -u
```

### Verificación

```bash
# Tras aplicar la solución:
sudo reboot
# Verificar que el sistema arranca correctamente

# Confirmar que el kernel funciona:
uname -r                                        # versión del kernel activo
dmesg | grep -iE "error|panic|oops" | head -5  # no debería haber errores
sudo journalctl -b -p err | wc -l              # errores del boot actual
```

## Escenarios / Variantes

| Variante / Síntoma | Causa típica | Solución rápida |
|---|---|---|
| **Panic tras actualizar kernel** | initramfs no regenerado | `update-initramfs -u -k all` desde Live USB |
| **Panic al cargar driver GPU** | Nouveau / NVIDIA incompatible | `nomodeset` en GRUB, purgar drivers problemáticos |
| **"VFS: Unable to mount root fs"** | initramfs no encuentra disco | Verificar drivers NVMe/SATA en initramfs, regenerar |
| **"Kernel panic - not syncing: VFS: Cannot open root device"** | UUID o root device equivocado | `blkid` + corregir GRUB y fstab |
| **Panic periódico (aleatorio)** | RAM defectuosa o CPU inestable | `memtest86+`, verificar temperaturas |
| **Panic tras instalar VirtualBox/DKMS** | Módulo compilado para kernel equivocado | `dkms remove`, blacklist del módulo |
| **Panic en Arch tras -Syu** | Paquetes parcialmente actualizados | Live USB → `pacman -Syu` completo en chroot |
| **Panic con ZFS/Btrfs** | Módulo ZFS/Btrfs incompatible con nuevo kernel | Regenerar módulo DKMS, o bootear kernel anterior |

## Prevención

1. **Mantener siempre 2 kernels** en /boot — no eliminar el anterior al actualizar.
2. **Usar `timeshift`** para snapshots antes de actualizar kernel o paquetes críticos.
3. **No llenar /boot** — monitorear con `df -h /boot` y limpiar kernels antiguos periódicamente.
4. **Verificar DKMS después de cada actualización** de kernel: `dkms status` debe mostrar "installed" para todos los módulos.
5. **Usar kernels LTS** si la estabilidad es prioritaria (arch-linux-lts, ubuntu-generic vs hwe).
6. **Ejecutar `memtest86+`** periódicamente si sospechas de hardware — errores de RAM causan panics aleatorios.
7. **Hacer snapshot antes de modificar drivers** — especialmente NVIDIA, VirtualBox, módulos DKMS.
8. **No forzar actualizaciones parciales** en Arch: siempre `pacman -Syu`, nunca `pacman -Sy <paquete>`.

## Notas adicionales

- En systemd, si el panic ocurre durante el arranque, puedes entrar en **emergency mode** con `systemd.unit=emergency.target` desde GRUB.
- Si el panic es "Attempted to kill init!", generalmente el problema es que `/sbin/init` o `/usr/lib/systemd/systemd` está corrupto o inaccesible.
- Los "oops" del kernel son errores no fatales que generan unoops.log pero no matan el sistema — son la antesala de un panic real.
- Si el panic muestra un "call trace" largo, busca el primer módulo propio (no del kernel base) — ahí está la causa.
- En servidores, `kdump` y `crash` permiten analizar el vmcore del crash sin Live USB.

## Enlaces externos

- [Arch Wiki — Kernel panic](https://wiki.archlinux.org/title/General_troubleshooting#Kernel_panic)
- [Debian Wiki — Bug tracking/Kernel](https://wiki.debian.org/Kernel/FAQ)
- [Ubuntu — Kernel Panic troubleshooting](https://help.ubuntu.com/community/KernelPanic)
- [Kernel.org — kdump documentation](https://www.kernel.org/doc/Documentation/kdump/kdump.txt)

## Ver también

- [[Sistema no arranca]] — troubleshooting general de arranque
- [[Pantalla en negro tras actualizar drivers]] — GPU-specific
- [[GRUB no arranca]] — reparación de bootloader
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — cómo arranca Linux
- [[Dual Boot con Windows]] — reparación de boot en dual boot

#troubleshooting #boot #kernel
