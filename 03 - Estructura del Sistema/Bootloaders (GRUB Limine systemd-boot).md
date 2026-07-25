---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: sistema
prioridad: alta
---

# Bootloaders (GRUB, Limine, systemd-boot)

## Definición

El **bootloader** es el programa que el firmware (BIOS/UEFI) carga y ejecuta para iniciar el sistema operativo. Su trabajo: encontrar el kernel, cargarlo en memoria junto con el initramfs, y pasarle el control con los parámetros adecuados.

```bash
Secuencia:  Firmware (UEFI/BIOS) → Bootloader → Kernel + initramfs → systemd (PID 1)
```

## Comparativa de bootloaders

| Bootloader | Default en | UEFI | BIOS (Legacy) | Secure Boot | Facilidad |
|---|---|---|---|---|---|
| **GRUB** | Ubuntu, Debian, Fedora, Arch | ✅ | ✅ | ✅ (shim) | Media |
| **systemd-boot** | Pop!_OS, algunas configs Arch | ✅ | ❌ | ✅ | Alta |
| **Limine** | SerenityOS, algunas configs avanzadas | ✅ | ✅ | ⚠️ Parcial | Baja |
| **rEFInd** | Hackintosh, multiboot | ✅ | ❌ | ✅ | Alta |
| **ELILO / SYSLINUX** | Legado | Solo ELILO | ✅ | ❌ | Baja (obsoleto) |

---

## GRUB (Grand Unified Bootloader)

### Archivos principales

```bash
/boot/grub/grub.cfg                      # configuración generada (NO EDITAR)
/etc/default/grub                        # configuración editable del usuario
/etc/grub.d/                             # scripts que generan grub.cfg
```

### Configuración básica (`/etc/default/grub`)

```bash
# Editar:
sudo nano /etc/default/grub

# Variables principales:
GRUB_TIMEOUT=5                           # segundos de espera (0 = inmediato, -1 = infinito)
GRUB_DEFAULT=0                           # entrada por defecto (0 = primera, saved = última)
GRUB_SAVEDEFAULT=true                    # recordar última entrada seleccionada
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"  # params de kernel (arranque normal)
GRUB_CMDLINE_LINUX=\"\"                      # params de kernel adicionales (siempre)
GRUB_DISABLE_OS_PROBER=false             # detectar otros SO (true para solo Linux)
GRUB_ENABLE_CRYPTODISK=y                 # arranque desde LUKS
GRUB_GFXPAYLOAD_LINUX=keep               # mantener resolución al pasar al kernel

# Regenerar configuración
sudo update-grub                          # Debian/Ubuntu
sudo grub-mkconfig -o /boot/grub/grub.cfg  # Arch, Fedora
```

### Temas para GRUB

```bash
# Temas populares
# - Vimix (https://github.com/vinceliuice/grub2-themes)
# - CyberRe (https://github.com/ChrisTitusTech/grub-theme)
# - Tela (https://github.com/vinceliuice/grub2-themes)

# Instalar un tema (ej: Vimix)
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
sudo ./install.sh -t tela -s 2k         # instalación guiada
```

### GRUB Rescue Shell

Si GRUB no encuentra su configuración, cae en shell de rescate:

```bash
# En la shell grub>
ls                                  # listar discos (hd0, hd0,gpt1...)
set root=(hd0,gpt2)                 # partición con /boot
linux /vmlinuz-linux root=/dev/sda3  # cargar kernel
initrd /initramfs-linux.img          # cargar initramfs
boot                                # arrancar

# Para encontrar la partición correcta:
ls (hd0,gpt1)/                      # listar contenido
ls (hd0,gpt2)/boot                  # buscar /boot
```

### Reinstalar GRUB

```bash
# Desde el sistema funcionando (UEFI)
sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# Desde un Live USB (chroot)
sudo mount /dev/sda2 /mnt            # montar raíz
sudo mount /dev/sda1 /mnt/boot       # montar /boot (o EFI)
sudo arch-chroot /mnt                # entrar al sistema
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

---

## systemd-boot

### Ventajas sobre GRUB

- **Más simple**: archivos de entrada en texto plano, sin scripts complex
- **Más rápido**: arranque más rápido que GRUB
- **Solo UEFI**: no soporta BIOS legacy (especificación UEFI nativa)
- **Integración con systemd**: detecta kernels automáticamente

### Instalación

```bash
# Instalar systemd-boot en la partición EFI
sudo bootctl install

# Verificar estado
bootctl status

# Configuración global (crear si no existe)
sudo mkdir -p /boot/loader/
sudo tee /boot/loader/loader.conf << 'EOF'
default  arch.conf
timeout  4
console-mode max
editor   no
EOF
```

### Entradas de kernel

```bash
# Las entradas son archivos .conf en /boot/loader/entries/
sudo mkdir -p /boot/loader/entries/

# Ejemplo: /boot/loader/entries/arch.conf
sudo tee /boot/loader/entries/arch.conf << 'EOF'
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=UUID=1234-5678-... rw quiet
EOF

# systemd-boot detecta automáticamente kernels de:
# - /boot/vmlinuz-* (si no hay entradas manuales, genera automáticas)
# - /boot/loader/entries/*.conf (entradas manuales)
```

### Gestión de entradas automáticas

```bash
# En algunas distros, los kernels se detectan automáticamente
# Para regenerar entradas automáticas (Arch con mkinitcpio):
sudo mkinitcpio -P

# Para añadir microcódigo:
# Asegurar que /boot/intel-ucode.img o /boot/amd-ucode.img existan
```

---

## Limine

### Qué es

**Limine** es un bootloader moderno, minimalista y altamente configurable, diseñado para soportar arranque desde redes, discos y particiones con soporte para múltiples protocolos (Linux, Multiboot1/2, Limine propio). Es el bootloader por defecto de SerenityOS y está ganando popularidad en configuraciones Linux avanzadas.

### Características

- Soporte UEFI y BIOS Legacy
- Soporte para Secure Boot (parcial)
- Interfaz gráfica moderna (bmp, tga, png)
- Configuración en texto plano (similar a systemd-boot)
- Soporte para arranque por red (PXE)
- Detección automática de kernels
- Carga de módulos del kernel antes del arranque
- Soporte para initrd múltiple y microcódigo

### Instalación

```bash
# Compilar desde fuente
git clone https://github.com/limine-bootloader/limine.git
cd limine
make
sudo make install

# Instalar en disco
# Para UEFI:
sudo ./limine-install-linux /dev/sda      # instalar en MBR o GPT

# Configuración: /boot/limine.cfg
# (similar en sintaxis a systemd-boot)
```

### Ejemplo de configuración

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

### Ventajas frente a GRUB

- Configuración más simple (no scripts)
- Arranque más rápido
- Mejor soporte gráfico (menús con imágenes)
- Consume menos recursos

---

## rEFInd

Bootloader especializado en **multiboot**, popular en sistemas con múltiples SO (incluyendo Hackintosh). Interfaz gráfica elegante que detecta automáticamente kernels y sistemas operativos:

```bash
# Instalación
sudo apt install refind                  # Debian/Ubuntu
sudo pacman -S refind                    # Arch

# rEFInd escanea automáticamente:
# - /EFI/BOOT/, /EFI/arch/, /EFI/ubuntu/, /EFI/Microsoft/
# - kernels en /boot/vmlinuz-*
```

---

## Secure Boot

El firmware UEFI verifica que el bootloader esté firmado por una clave de confianza:

```bash
# Verificar estado
mokutil --sb-state                       # enabled/disabled

# Las distros firman su bootloader con shim (firmado por Microsoft)
# Si compilas tu propio kernel o usas un bootloader no firmado:
mokutil --import MOK.der                 # importar tu propia clave
# Luego reiniciar: el firmware mostrará un menú MOK para confirmar

# Desactivar Secure Boot (si no necesitas)
# Desde la BIOS/UEFI → Security → Secure Boot → Disabled
```

---

## Ver también

- [[Proceso de Arranque (GRUB initramfs kernel params)]] — secuencia completa de arranque
- [[Particionado y Esquemas de Disco]] — partición EFI (ESP) para UEFI
- [[Cifrado (LUKS dm-crypt GPG)]] — arranque desde disco cifrado
- [[Dual Boot con Windows]] — bootloaders con múltiples SO

## Enlaces externos

- [Wikipedia — GNU GRUB](https://en.wikipedia.org/wiki/GNU_GRUB)
- [Wikipedia — systemd-boot](https://en.wikipedia.org/wiki/Systemd-boot)
- [Wikipedia — Limine](https://en.wikipedia.org/wiki/Limine_(boot_loader))
- [Wikipedia — rEFInd](https://en.wikipedia.org/wiki/REFInd)
- [GitHub — limine-bootloader/limine](https://github.com/limine-bootloader/limine)
- [Arch Wiki — Bootloaders](https://wiki.archlinux.org/title/Arch_boot_process#Boot_loader)

#sistema #arranque
