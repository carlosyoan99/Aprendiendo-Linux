---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: baja
---

# Firmware y BIOS/UEFI

> Capa de software entre el hardware y el sistema operativo. BIOS legacy vs UEFI moderno, Secure Boot, actualización de firmware.

## Qué es

El firmware es el primer software que se ejecuta al encender el equipo. Proporciona la interfaz básica entre el hardware y el SO.

| Característica | BIOS (Legacy) | UEFI |
|---|---|---|
| **Partición de arranque** | MBR (2 TB max) | GPT (9.4 ZB) |
| **Interfaz** | Texto azul | Gráfica con ratón |
| **Arranque** | POST → Bootstrap | Gestor de arranque |
| **Seguridad** | Sin verificación | Secure Boot |
| **Arquitectura** | 16-bit real | 32/64-bit |
| **Dual boot** | Limitado | Nativo |
| **Velocidad arranque** | Más lento | Más rápido |

## BIOS Legacy

```
Encendido → POST → BIOS → MBR (446 bytes bootloader) → SO
```

- **MBR** (Master Boot Record): 512 bytes al inicio del disco
- **Partition table**: 4 entradas primarias (o 3 + 1 extendida)
- **Bootloader**: GRUB legacy se instala en el MBR

## UEFI

```
Encendido → POST → UEFI → EFI System Partition (FAT32) → bootloader → SO
```

- **GPT** (GUID Partition Table): particiones ilimitadas, 128+ por defecto
- **EFI System Partition** (ESP): partición FAT32 de ~512 MB en `/boot/efi`
- **Secure Boot**: verifica firmas digitales de bootloaders/kernels

## Secure Boot

```bash
# Verificar estado de Secure Boot
mokutil --sb-state          # Debian/Ubuntu
dmesg | grep -i secure      # Cualquier distro

# Desactivar (desde BIOS, no desde Linux)
# Setup → Security → Secure Boot → Disabled

# Para usar Secure Boot con Linux:
# 1. Desactivar temporalmente para instilar
# 2. Tras instalar, enrollar la key de shim
# 3. Reactivar Secure Boot
```

## EFI System Partition (ESP)

```bash
# Verificar ESP
lsblk -o NAME,FSTYPE,MOUNTPOINT | grep -i efi
# o
sudo fdisk -l /dev/sda | grep -i efi

# Montar ESP (si no está montado)
sudo mount /dev/sda1 /boot/efi

# Contenido típico
ls /boot/efi/EFI/
# debian/  ubuntu/  fedora/  systemd/  BOOT/  (cada distro su carpeta)
```

## Actualización de firmware

```bash
#/fwupd (Linux)
sudo fwupdmgr get-updates
sudo fwupdmgr update

# Dell
sudo fwupdmgr get-updates --force
sudo fwupdmgr update

# Lenovo
sudo fwupdmgr get-updates

# Ver dispositivos soportados
fwupdmgr get-devices

# Historial de actualizaciones
fwupdmgr get-history
```

## dual boot BIOS vs UEFI

| Escenario | Recomendación |
|---|---|
| Solo Linux nuevo | UEFI (nativo) |
| Dual boot Windows + Linux | UEFI (ambos lo soportan) |
| Hardware viejo sin UEFI | BIOS Legacy + GRUB |
| Migrar de BIOS a UEFI | `gdisk` + `grub-install --target=x86_64-efi` |

## Ver también

- [[Bootloaders (GRUB Limine systemd-boot)]]
- [[Proceso de Arranque (GRUB initramfs kernel params)]]
- [[Dual Boot con Windows]]
- [[Cifrado (LUKS dm-crypt GPG)]]

#sistema #firmware #bios #uefi #secureboot
