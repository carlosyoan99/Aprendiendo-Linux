---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: sistema
prioridad: alta
---

# Limine

Bootloader moderno, minimalista y altamente configurable. Soporta UEFI y BIOS Legacy, arranque por red (PXE), Secure Boot parcial, e interfaz gráfica con imágenes. Bootloader por defecto de SerenityOS. Es el bootloader más rápido del ecosistema Linux.

## Ventajas frente a GRUB

| Aspecto | Limine | GRUB |
|---|---|---|
| **Complejidad** | Baja (config en texto plano) | Alta (scripts, grub-mkconfig) |
| **Velocidad de arranque** | Muy rápida | Más lenta (arquitectura modular) |
| **Sistemas de archivos** | FAT, ISO9660 | Ext*, XFS, Btrfs, ZFS, etc. |
| **Gráficos** | Imágenes BMP/TGA/PNG nativas | Temas mediante scripts |
| **Cifrado /boot** | Limitado (sin LUKS nativo) | LUKS2 completo con cryptodisk |
| **Secure Boot** | Vía firmas personalizadas | Via shim (firmado por Microsoft) |
| **Mejor uso** | Sistemas modernos, OS custom | BIOS legacy, /boot cifrado |

## Instalación

### Compilación desde fuente
```bash
git clone https://github.com/limine-bootloader/limine.git
cd limine
make
sudo make install
```

### Instalación UEFI

Limine no crea entradas NVRAM automáticamente. Hay que registrarlo manualmente:

```bash
# Copiar el binario al ESP
sudo mkdir -p /boot/efi/EFI/limine
sudo cp bin/BOOTX64.EFI /boot/efi/EFI/limine/BOOTX64.EFI

# Registrar en NVRAM
sudo efibootmgr --create --disk /dev/sda --part 1 \
  --label "Limine" --loader '\\EFI\\limine\\BOOTX64.EFI'

# Alternativa: usar ruta por defecto (fallback)
sudo cp bin/BOOTX64.EFI /boot/efi/EFI/BOOT/BOOTX64.EFI
```

### Instalación BIOS
```bash
sudo ./limine-bios-install /dev/sda         # escribir stage 1 al MBR/GPT
sudo cp bin/limine-bios.sys /boot/limine-bios.sys  # stage 3
```

### Instalación desatendida (script)
```bash
sudo ./limine-install-linux /dev/sda        # instalar + copia automática
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

### Directivas avanzadas

| Directiva | Descripción |
|---|---|
| `TIMEOUT=5` | Segundos antes de arrancar la entrada por defecto |
| `INTERFACE_RESOLUTION=1920x1080` | Resolución del menú |
| `MAX_RESOLUTION=1920x1080` | Resolución máxima del modo gráfico |
| `BACKGROUND_PATH=boot:/fondo.bmp` | Imagen de fondo (BMP, TGA, PNG) |
| `TERMINAL_FONT=ter-122n.psf` | Fuente para el terminal |
| `SERIAL=yes` | Salida por puerto serie (headless) |
| `VERBOSE=yes` | Modo verbose para debugging |

### Soporte Multiboot

Limine soporta los protocolos **Multiboot 1**, **Multiboot 2** y **Linux Boot Protocol**, además de su propio protocolo nativo.

```bash
# Entrada para kernel multiboot (Xen, custom OS)
:Custom Kernel
PROTOCOL=multiboot2
KERNEL_PATH=boot:/mi-kernel.elf
MODULE_PATH=boot:/initrd.img
```

### Chainloading
```bash
# Arrancar otro bootloader o Windows
:Windows
PROTOCOL=chainload
CHAINLOAD_PATH=boot:/EFI/Microsoft/Boot/bootmgfw.efi
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| "Failed to open image" | Ruta incorrecta en limine.cfg | Verificar rutas relativas a la partición |
| No aparece en boot menu | Falta entrada NVRAM | Usar `efibootmgr` o ruta fallback |
| Pantalla negra en el menú | Resolución no soportada | Probar con `INTERFACE_RESOLUTION=1024x768` o sin resolución |
| No detecta kernel | Protocolo incorrecto | Usar `PROTOCOL=linux` (no `multiboot2`) para kernels Linux |
| Secure Boot bloquea | Binario no firmado | Firmar manualmente con `sbsign` o usar shim |
| MSI UEFI no arranca GRUB | Firmware no compatible | Limine suele funcionar donde GRUB falla en MSI |

## Ver también

- [[GRUB]] — bootloader tradicional
- [[systemd-boot]] — bootloader UEFI de systemd
- [[Bootloaders (GRUB Limine systemd-boot)]] — índice + comparativa
- [[Proceso de Arranque (GRUB initramfs kernel params)]]

## Enlaces externos

- [GitHub — limine-bootloader/limine](https://github.com/limine-bootloader/limine)
- [Arch Wiki — Limine](https://wiki.archlinux.org/title/Limine)
- [Wikipedia — Limine](https://en.wikipedia.org/wiki/Limine_(boot_loader))

#sistema #arranque
