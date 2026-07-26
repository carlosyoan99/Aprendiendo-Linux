---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: media
---

# systemd-boot

> Bootloader moderno, parte de systemd. UEFI-only, mínimo, rápido. Alternativa a GRUB para sistemas UEFI puros.

## Qué es

systemd-boot (anteriormente Gummiboot) es un bootloader UEFI simple incluido en systemd. Requiere firmware UEFI (no soporta BIOS legacy). Es el bootloader recomendado por varios proyectos modernos como Arch Linux y Fedora para instalaciones UEFI.

| Característica | systemd-boot | GRUB | Limine |
|---|---|---|---|
| **Tipo** | EFI applicación | Bootloader completo | Bootloader |
| **BIOS legacy** | ❌ | ✅ | ✅ |
| **UEFI** | ✅ | ✅ | ✅ |
| **Configuración** | Archivos `.conf` simples | `grub.cfg` complejo | `limine.cfg` |
| **Tamaño** | ~300 KB | ~5 MB | ~200 KB |
| **Editores de boot** | ❌ | ✅ | ❌ |
| **Entradas manuales** | Sí (directorio) | Sí | Sí |
| **Integración systemd** | Nativa | Manual | Manual |

## Instalación

```bash
# Arch Linux
sudo bootctl install

# Fedora
sudo bootctl install --esp-path=/boot/efi

# Verificar instalación
bootctl status
```

## Estructura de archivos

```
/boot/efi/                    # Partición EFI (FAT32)
├── EFI/
│   ├── systemd/
│   │   └── systemd-bootx64.efi    # El bootloader
│   └── debian/
│       └── grubx64.efi            # Si también está GRUB
└── loader/
    └── entries/
        ├── arch.conf              # Entrada para Arch
        ├── debian.conf            # Entrada para Debian
        └── windows.conf           # Entrada para Windows
```

## Configuración

### `loader/loader.conf` (configuración global)

```
# /boot/efi/loader/loader.conf
default  arch.conf
timeout  3
console-mode max
editor   no
```

### Entradas de boot (`loader/entries/*.conf`)

```
# /boot/efi/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=xxxx-xxxx rw
```

### Parámetros de kernel comunes

```
# Desactivar servicios innecesarios
options root=UUID=xxxx rw quiet loglevel=3

# Modo recovery
options root=UUID=xxxx rw single

# NVIDIA
options root=UUID=xxxx rw nvidia-drm.modeset=1

# ZRAM
options root=UUID=xxxx rw zswap.enabled=1
```

## Gestión de entradas

```bash
# Listar entradas disponibles
bootctl list

# Entradas manuales (sin archivo .conf)
bootctl install --entry-name="Custom"

# Cambiar entrada por defecto
sudoedit /boot/efi/loader/loader.conf
```

## systemd-boot vs GRUB

| Escenario | Recomendación |
|---|---|
| UEFI puro, sin dual boot | systemd-boot o Limine |
| Dual boot con Windows | GRUB (mejor compatibilidad) |
| BIOS legacy | GRUB (única opción) |
| Múltiples kernels | GRUB (auto-detecta mejor) |
| Sistema minimalista | systemd-boot |
| Servidor | systemd-boot o GRUB |

## Instalación en instaladores

```bash
# Arch Linux ( durante instalación)
sudo bootctl install
# Crear entrada
cat > /boot/efi/loader/entries/arch.conf << 'EOF'
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=$(blkid -s UUID -o value /dev/sda2) rw
EOF

# Fedora
sudo bootctl install
# Las entradas se crean automáticamente con kernel-install
```

## Actualización del kernel

systemd-boot carga automáticamente la última versión del kernel. No necesita regenerar configuración como GRUB.

```bash
# After kernel update, solo verificar
bootctl list

# Si necesitas regenerar initramfs
sudo mkinitcpio -P    # Arch
sudo dracut -f        # Fedora
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No aparece en BIOS | No es UEFI | Usar GRUB Legacy |
| No carga kernel | UUID incorrecto | Verificar con `blkid` |
| No aparece Windows | Falta entrada | Crear `windows.conf` |
| "File not found" |/initramfs roto | Regenerar con mkinitcpio |

## Ver también

- [[Bootloaders (GRUB Limine systemd-boot)]]
- [[Proceso de Arranque (GRUB initramfs kernel params)]]
- [[Dual Boot con Windows]]
- [[Kernel Linux]]

#sistema #bootloader #uefi #systemd #arranque
