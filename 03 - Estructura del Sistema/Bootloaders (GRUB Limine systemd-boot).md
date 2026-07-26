---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: sistema
prioridad: alta
---

# Bootloaders (GRUB, Limine, systemd-boot)

El **bootloader** es el programa que el firmware (BIOS/UEFI) carga y ejecuta para iniciar el sistema operativo.

```
Firmware (UEFI/BIOS) → Bootloader → Kernel + initramfs → systemd (PID 1)
```

## Componentes

- [[GRUB]] — bootloader por defecto en la mayoría de distros (BIOS + UEFI)
- [[systemd-boot]] — bootloader UEFI de systemd (simple, rápido)
- [[Limine]] — bootloader moderno minimalista (UEFI + BIOS)

## Comparativa rápida

| Bootloader | BIOS | UEFI | Secure Boot | Facilidad |
|---|---|---|---|---|
| **GRUB** | ✅ | ✅ | ✅ (shim) | Media |
| **systemd-boot** | ❌ | ✅ | ✅ | Alta |
| **Limine** | ✅ | ✅ | ⚠️ Parcial | Baja |

## rEFInd

Bootloader especializado en **multiboot**, popular en sistemas con múltiples SO (incluyendo Hackintosh).

```bash
sudo apt install refind     # Debian/Ubuntu
sudo pacman -S refind       # Arch
```

## Secure Boot

```bash
mokutil --sb-state          # enabled/disabled
mokutil --import MOK.der    # importar clave propia
```

## Ver también

- [[Proceso de Arranque (GRUB initramfs kernel params)]] — secuencia completa
- [[Particionado y Esquemas de Disco]] — partición EFI (ESP)
- [[Cifrado (LUKS dm-crypt GPG)]] — arranque desde disco cifrado
- [[Dual Boot con Windows]]

## Enlaces externos

- [Arch Wiki — Bootloaders](https://wiki.archlinux.org/title/Arch_boot_process#Boot_loader)
- [Wikipedia — GNU GRUB](https://en.wikipedia.org/wiki/GNU_GRUB)
- [Wikipedia — systemd-boot](https://en.wikipedia.org/wiki/Systemd-boot)

#sistema #arranque
