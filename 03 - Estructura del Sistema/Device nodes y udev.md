---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: baja
---

# Device nodes y udev

> Cómo Linux gestiona dispositivos de hardware: /dev, nodos de dispositivo, udev como daemon de reglas.

## Qué es

Linux trata todo como archivos. Los dispositivos de hardware aparecen como archivos especiales en `/dev/`. **udev** es el daemon que crea automáticamente estos nodos cuando se detecta hardware.

## Nodos de dispositivo

| Tipo | Ubicación | Ejemplo |
|---|---|---|
| **Carácter** | Lee/escribe byte a byte | `/dev/ttyS0`, `/dev/null` |
| **Bloque** | Lee/escribe bloques | `/dev/sda`, `/dev/nvme0n1` |

```bash
# Ver tipo de archivo
ls -l /dev/sda
# brw-rw---- 1 root disk 8, 0 ...

# b = bloque, c = carácter
# 8 = major number (driver), 0 = minor number (dispositivo)
```

## /dev importante

| Archivo | Uso |
|---|---|
| `/dev/null` | Basurero (descarta todo lo que recibe) |
| `/dev/zero` | Genera ceros infinitos |
| `/dev/random` | Entropía del sistema (bloquea si se agota) |
| `/dev/urandom` | Entropía no bloqueante (recomendado) |
| `/dev/tty` | Terminal actual |
| `/dev/sda` | Primer disco SCSI/SATA/NVMe |
| `/dev/nvme0n1` | Primer disco NVMe |

## udev

udev monitorea el hardware via netlink y aplica reglas para crear/modificar nodos en `/dev/`.

### Reglas udev

```bash
# /etc/udev/rules.d/99-custom.rules

# Regla por MAC de red
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="aa:bb:cc:dd:ee:ff", NAME="mired"

# Regla por USB vendor/product
SUBSYSTEM=="usb", ATTR{idVendor}=="1234", ATTR{idProduct}=="5678", MODE="0666"

# Regla por nombre de dispositivo
SUBSYSTEM=="block", KERNEL=="sd[a-z]", ENV{ID_SERIAL}=="MiDisco", SYMLINK+="mi-disco"
```

### Comandos udev

```bash
# Recargar reglas
sudo udevadm control --reload-rules
sudo udevadm trigger

# Ver info de un dispositivo
udevadm info -a -n /dev/sda

# Monitorizar eventos en vivo
udevadm monitor

# Buscar regla que creó un nodo
udevadm info -a -p /sys/class/block/sda
```

## sysfs (/sys)

`/sys` expone información del kernel sobre dispositivos:

```bash
# Info de un disco
cat /sys/block/sda/size          # tamaño en bloques
cat /sys/block/sda/device/model  # modelo

# Info de un USB
lsusb
cat /sys/bus/usb/devices/1-1/idVendor
```

## Ver también

- [[lsblk]]
- [[Módulos del kernel (lsmod modprobe blacklist)]]
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]]
- [[Filesystem Hierarchy Standard]]

#sistema #udev #dev #hardware #dispositivos
