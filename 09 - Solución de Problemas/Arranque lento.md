---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: troubleshooting
prioridad: media
---

# Arranque lento

> El sistema tarda demasiado en llegar al login o al escritorio. Puede ser un arranque de 30+ segundos,.services que fallan y retrasan el boot, o un systemd que se queda esperando. Las causas van desde servicios lentos hasta disco mecánico, fstab mal configurado, o initramfs inflado.

## Síntoma

- El sistema tarda más de 15-20 segundos en llegar al login (en SSD debería ser <10s).
- Aparecen mensajes como "A start job is running for..." durante el arranque.
- La barra de progreso de GRUB se atasca por mucho tiempo.
- `systemd-analyze` muestra tiempos excesivos en servicios específicos.
- El login aparece rápido pero el escritorio tarda en cargar.
- Después de una actualización, el arranque se volvió significativamente más lento.

## Diagnóstico

```bash
# 1. Medir el tiempo total de arranque
systemd-analyze                              # tiempo total: firmware + loader + kernel + initrd + userspace

# 2. Ver los servicios más lentos
systemd-analyze blame                        # servicios ordenados por tiempo (mayor primero)
systemd-analyze blame | head -20             # top 20 más lentos

# 3. Ver qué servicios fallan o se demoran
systemd-analyze critical-chain               # cadena crítica de servicios
systemd-analyze critical-chain --no-pager    # sin pager

# 4. Verificar servicios que fallan
systemctl --failed                           # servicios en estado "failed"
systemctl list-units --state=failed          # lo mismo, más detalle

# 5. Verificar fstab (mounts que retrasan el boot)
cat /etc/fstab | grep -v "^#" | grep -v "^$"
systemd-analyze blame | grep -i "mnt\|media\|mount"

# 6. Verificar si el kernel o initramfs es lento
systemd-analyze blame | grep -i "initrd\|kernel"

# 7. Verificar espacio en disco (disco lleno = lento)
df -h / /boot /tmp /home

# 8. Verificar si hay swap insuficiente (thrashing)
free -h
cat /proc/swaps

# 9. Ver logs del arranque anterior
journalctl -b -1 | grep -iE "slow|timeout|fail|error" | head -20
```

### Logs relevantes

```bash
# Tiempos de arranque detallados
systemd-analyze blame --no-pager | head -30

# Cadena crítica
systemd-analyze critical-chain --no-pager

# Servicios que tardan más de 5 segundos
systemd-analyze blame | awk '$1 ~ /min|s/ && ($1+0 > 5 || $1 ~ /min/)'

# Verificar si plymouth (splash screen) retrasa
journalctl -b | grep -i plymouth | tail -10

# Verificar network-online.target (red retrasando boot)
systemd-analyze blame | grep -i "network"
systemctl status NetworkManager-wait-online.service
```

## Causa

1. **NetworkManager-wait-online** — el servicio espera a que la red esté completamente configurada antes de continuar el boot. Puede tardar 30+ segundos en conexiones lentas.
2. **fstab con mounts que no existen** — una entrada en fstab con un UUID o dispositivo que no está disponible causa timeout de 90 segundos.
3. **Disco mecánico (HDD)** — un HDD lento es la causa más común de boot lento.
4. **initramfs inflado** — módulos innecesarios en el initramfs lo hacen más grande y lento de cargar.
5. **Plymouth (splash screen)** — puede retrasar el boot en algunos hardware.
6. **Servicios dependientes de red** — muchos servicios esperan a que la red esté lista.
7. **Swap insuficiente o en disco lento** — el sistema thrashea durante el arranque.
8. **Filesystem check (fsck)** — en discos grandes o dañados, fsck puede tardar mucho.

## Solución

### Caso 1: NetworkManager-wait-online (el más común)

```bash
# Desactivar el servicio que espera a la red
sudo systemctl disable NetworkManager-wait-online.service

# Si usas systemd-networkd:
sudo systemctl disable systemd-networkd-wait-online.service

# Verificar
systemctl status NetworkManager-wait-online.service  # debe mostrar "masked" o "disabled"
```

### Caso 2: fstab con mounts que no existen

```bash
# Verificar qué entries de fstab están causando timeout
cat /etc/fstab | grep -v "^#" | grep -v "^$"

# Buscar entradas con UUIDs que no existen
for uuid in $(grep UUID /etc/fstab | awk '{print $1}' | sed 's/UUID=//'); do
  echo "UUID $uuid: $(blkid -o value -s UUID /dev/sd* 2>/dev/null | grep -c $uuid) matches"
done

# Si hay entradas con UUIDs que no existen, commenterlas:
sudo nano /etc/fstab
# Añadir # al inicio de la línea problemática

# Añadir nofail para que no bloquee el boot si el dispositivo no está:
# /dev/sdb1  /mnt/datos  ext4  defaults,nofail  0  2
```

### Caso 3: optimizar initramfs

```bash
# Ver tamaño del initramfs actual
ls -lh /boot/initrd*

# Regenerar initramfs más pequeño (solo módulos necesarios)
# Debian/Ubuntu: editar /etc/initramfs-tools/initramfs.conf
#   MODULES=dep          # solo módulos del hardware actual (en vez de "most")
sudo update-initramfs -u

# Arch: editar /etc/mkinitcpio.conf
#   HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)
# Remover hooks innecesarios: plymouth, filesystems extras
sudo mkinitcpio -P

# Verificar tamaño
ls -lh /boot/initrd*
```

### Caso 4: desactivar Plymouth (splash screen)

```bash
# Desactivar Plymouth
sudo systemctl disable plymouth-quit-wait.service
sudo systemctl disable plymouth-start.service

# En GRUB, quitar "splash" de la línea kernel:
sudo nano /etc/default/grub
# GRUB_CMDLINE_LINUX_DEFAULT="quiet"  # quitar splash
sudo update-grub
```

### Caso 5: optimizar servicios

```bash
# Ver servicios lentos y decidir cuáles desactivar
systemd-analyze blame | head -20

# Desactivar servicios que no necesitas:
sudo systemctl disable cups.service          # impresión (si no imprimes)
sudo systemctl disable avahi-daemon.service  # mDNS (si no lo usas)
sudo systemctl disable bluetooth.service     # Bluetooth (si no lo usas)
sudo systemctl disable ModemManager.service  # módem (si no lo usas)

# NO desactivar servicios críticos:
# - systemd-journald, systemd-udevd, dbus, network-manager
```

### Caso 6: disco lento → migrar a SSD

```bash
# Verificar si el disco es HDD o SSD
lsblk -d -o name,rota,model
# rota=0 → SSD, rota=1 → HDD

# Si es HDD y el boot es lento, migrar a SSD:
# 1. Clonar disco con dd o clonezilla
# 2. O reinstalar la distro en el SSD
# 3. Mantener HDD como datos (montar en /home o /mnt/datos)

# Optimizar disco mecánico (temporal):
# Añadir noatime para reducir escrituras:
# En fstab: defaults,noatime
sudo mount -o remount,noatime /
```

### Caso 7: filesystem check lento

```bash
# Ver si fsck está tardando
journalctl -b | grep -i "fsck\|e2fsck" | tail -5

# Forzar fsck en el próximo boot (si es necesario):
sudo touch /forcefsck

# Si el disco es grande, considerar:
# - Reducir particiones
# - Usar filesystem más rápido (ext4 con features, btrfs)
# - Desactivar fsck en fstab (⚠️ no recomendado):
#   /dev/sda1  /  ext4  defaults,noatime,fsck=0  0  0
```

### Verificación

```bash
# Tras aplicar la solución:
sudo reboot
# Medir tiempo de arranque:
systemd-analyze
systemd-analyze blame | head -10
systemctl --failed                           # no debería haber servicios failed
```

## Escenarios / Variantes

| Variante / Síntoma | Causa típica | Solución rápida |
|---|---|---|
| **Boot > 30 segundos** | NetworkManager-wait-online | `sudo systemctl disable NetworkManager-wait-online.service` |
| **"A start job is running for..."** | Servicio esperando timeout | `systemd-analyze blame` → identificar → desactivar |
| **Boot lento tras actualización** | initramfs inflado o servicio nuevo | `systemd-analyze blame` → ver qué cambió |
| **Login rápido pero escritorio lento** | DE cargando servicios pesados | Reducir autostart apps, desactivar extensiones |
| **Solo HDD, boot lento siempre** | Disco mecánico | Migrar a SSD (mejor upgrade posible) |
| **fstab timeout 90 segundos** | UUID de dispositivo ausente | `nofail` en fstab o comentar la línea |
| **initramfs > 50MB** | Módulos innecesarios | `MODULES=dep` en initramfs.conf |
| **Boot lento en Arch** | systemd services habilitados de más | `systemctl list-unit-files --state=enabled` → desactivar innecesarios |

## Prevención

1. **Medir el boot después de cada cambio significativo** — `systemd-analyze` es tu amigo.
2. **Usar `nofail` en fstab** para dispositivos externos que no siempre están conectados.
3. **Migrar a SSD** si aún usas HDD como disco principal — es la mejora más impactante.
4. **Revisar `systemctl --failed` periódicamente** — servicios failed retrasan el boot.
5. **Mantener el initramfs limpio** — usar `MODULES=dep` en vez de `most`.
6. **No instalar servicios innecesarios** — cada servicio instalado puede retrasar el boot.

## Notas adicionales

- Un SSD moderno debería lograr boots de <10 segundos. Si tu SSD tarda más, busca otro problema.
- Si `systemd-analyze blame` muestra un servicio con 30+ segundos, casi seguro es el culpable.
- En Arch Linux, `systemd-analyze plot > boot.svg` genera un diagrama visual del boot que puedes abrir en un navegador.
- `systemd-analyze condition` verifica si un servicio podría haberse saltado.
- Para comparar boots antes/después: `systemd-analyze > /tmp/boot-antes.txt` y repetir después.

## Enlaces externos

- [Arch Wiki — Boot process](https://wiki.archlinux.org/title/Boot_process)
- [Arch Wiki — systemd/Optimizing boot](https://wiki.archlinux.org/title/Systemd/Optimizing_boot)
- [systemd-analyze docs](https://www.freedesktop.org/software/systemd/man/systemd-analyze.html)
- [Ubuntu Wiki — Boot performance](https://help.ubuntu.com/community/BootPerformance)

## Ver también

- [[Sistema no arranca]] — troubleshooting general de arranque
- [[Kernel Panic]] — panic durante el boot
- [[Disco lleno (No space left on device)]] — disco lleno puede ralentizar boot
- [[Gestión de energía y batería]] — TLP que puede afectar el boot
- [[systemd]] — gestión de servicios y targets

#troubleshooting #boot #performance
