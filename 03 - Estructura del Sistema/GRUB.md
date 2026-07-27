---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: sistema
prioridad: alta
---

# GRUB — Grand Unified Bootloader

Bootloader por defecto en Ubuntu, Debian, Fedora y Arch. Soporta BIOS legacy y UEFI, Secure Boot (via shim), arranque desde LUKS y temas gráficos.

## Archivos principales

```bash
/boot/grub/grub.cfg              # configuración generada (NO EDITAR)
/etc/default/grub                # configuración editable del usuario
/etc/grub.d/                     # scripts que generan grub.cfg
```

## Configuración básica

```bash
sudo nano /etc/default/grub

GRUB_TIMEOUT=5                           # segundos de espera
GRUB_DEFAULT=0                           # entrada por defecto
GRUB_SAVEDEFAULT=true                    # recordar última entrada
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash" # params de kernel
GRUB_CMDLINE_LINUX=""                    # params adicionales
GRUB_DISABLE_OS_PROBER=false             # detectar otros SO
GRUB_ENABLE_CRYPTODISK=y                 # arranque desde LUKS
GRUB_GFXPAYLOAD_LINUX=keep               # mantener resolución

# Regenerar configuración
sudo update-grub                         # Debian/Ubuntu
sudo grub-mkconfig -o /boot/grub/grub.cfg  # Arch, Fedora
```

### Parámetros de kernel (CMDLINE_LINUX)

```bash
# Seguridad
GRUB_CMDLINE_LINUX_DEFAULT="quiet mitigations=auto"

# cgroups v2
GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1"

# Deshabilitar IPv6 a nivel kernel
GRUB_CMDLINE_LINUX="ipv6.disable=1"

# Rendimiento (intel_idle.max_cstate=1 reduce latencia)
GRUB_CMDLINE_LINUX="intel_idle.max_cstate=1 processor.max_cstate=1"

# Nomodeset (cuando los drivers gráficos fallan al arrancar)
GRUB_CMDLINE_LINUX_DEFAULT="nomodeset"
```

## Contraseña encriptada (PBKDF2)

Para proteger GRUB, generar hash con PBKDF2:

```bash
grub-mkpasswd-pbkdf2
# Introducir contraseña dos veces → genera hash largo
```

```bash
# /etc/grub.d/40_custom o /boot/grub/user.cfg
set superusers="admin"
password_pbkdf2 admin grub.pbkdf2.sha512.10000.HEX...
```

En RHEL/Fedora: `sudo grub2-setpassword` (gestiona automáticamente el usuario root).

## Entradas personalizadas (/etc/grub.d/)

GRUB ejecuta los scripts de `/etc/grub.d/` en orden numérico:

| Script | Propósito |
|---|---|
| `00_header` | Configuración global |
| `10_linux` | Kernels Linux detectados |
| `30_os-prober` | Otros SO (Windows, etc.) |
| `40_custom` | **Entradas manuales del usuario** |

```bash
#!/bin/sh
# /etc/grub.d/40_custom (debe ser ejecutable: chmod +x)

exec tail -n +3 $0

menuentry "Mi rescate personalizado" {
  insmod luks
  insmod cryptodisk
  insmod ext2
  cryptomount (hd0,gpt2)
  set root='cryptouuid/uuid'
  linux /vmlinuz-linux root=/dev/mapper/root
  initrd /initramfs-linux.img
}
```

Luego regenerar: `sudo update-grub`.

## Arranque desde disco cifrado (LUKS2)

GRUB 2.06+ soporta LUKS2 nativamente. Requiere partición /boot separada o uninitramfs que maneje el desbloqueo.

```bash
# /etc/default/grub
GRUB_ENABLE_CRYPTODISK=y
GRUB_CMDLINE_LINUX="rd.luks.uuid=UUID-del-disco-cifrado"
```

```bash
# Instalar GRUB con soporte cryptodisk
grub-install --target=x86_64-efi --efi-directory=/boot \
  --bootloader-id=GRUB --recheck
```

## Temas para GRUB

```bash
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
sudo ./install.sh -t tela -s 2k
```

## GRUB Rescue Shell

Cuando GRUB no encuentra la configuración, cae en la shell de rescate `grub>`.

```bash
grub> ls                           # listar discos y particiones
grub> set root=(hd0,gpt2)          # partición con /boot
grub> ls (hd0,gpt2)/               # explorar contenido
grub> linux /vmlinuz-linux root=/dev/sda3  # cargar kernel
grub> initrd /initramfs-linux.img  # cargar initramfs
grub> boot                         # arrancar
```

### Comandos útiles en shell GRUB

| Comando | Descripción |
|---|---|
| `ls` | Listar particiones |
| `ls (hd0,gpt1)/` | Explorar contenido de partición |
| `set` | Ver variables de entorno |
| `insmod luks` | Cargar módulo LUKS |
| `insmod cryptodisk` | Cargar módulo de discos cifrados |
| `cryptomount (hd0,gpt2)` | Montar partición cifrada |
| `videoinfo` | Mostrar resoluciones de video disponibles |
| `gfxmode` | Configurar resolución de video |

## Troubleshooting

| Problema | Causa probable | Solución |
|---|---|---|
| "disk not found" | Módulo luks/cryptodisk no cargado | `insmod luks` + `insmod cryptodisk` |
| Pantalla negra tras GRUB | Resolución incompatible | `GRUB_GFXPAYLOAD_LINUX=1024x768` |
| GRUB no aparece | Secure Boot deshabilitado o partición ESP incorrecta | Verificar `ls /sys/firmware/efi` |
| update-grub no cambia nada | Script en /etc/grub.d/ no ejecutable | `chmod +x /etc/grub.d/40_custom` |
| error: symbol not found | GRUB desactualizado | `sudo grub-install --version` vs distro |

> ⚠️ **Advertencia**: Cualquier modificación en el gestor de arranque puede dejar el sistema sin inicio. Ten siempre un **Live USB** de rescate y una copia de `/boot/grub/grub.cfg` antes de cambios profundos.

## Reinstalar GRUB

```bash
# Desde sistema funcionando (UEFI)
sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# Desde Live USB (chroot)
sudo mount /dev/sda2 /mnt
sudo mount /dev/sda1 /mnt/boot
sudo arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

## Ver también

- [[Limine]] — bootloader moderno minimalista
- [[systemd-boot]] — bootloader UEFI de systemd
- [[Bootloaders (GRUB Limine systemd-boot)]] — índice + comparativa
- [[Proceso de Arranque (GRUB initramfs kernel params)]]
- [[Cifrado (LUKS dm-crypt GPG)]] — arranque desde disco cifrado
- [[Dual Boot con Windows]]

## Enlaces externos

- [Wikipedia — GNU GRUB](https://en.wikipedia.org/wiki/GNU_GRUB)
- [Arch Wiki — GRUB](https://wiki.archlinux.org/title/GRUB)

#sistema #arranque
