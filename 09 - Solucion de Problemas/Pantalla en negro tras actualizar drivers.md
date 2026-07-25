---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: troubleshooting
sistema: gráficos (NVIDIA/AMD/Intel)
prioridad: alta
---

# Pantalla en negro tras actualizar drivers gráficos

> El sistema arranca pero la pantalla se queda en negro después de la BIOS/UEFI, o solo se ve el cursor parpadeando, o el display manager no inicia.

## Síntoma

- Tras instalar/actualizar drivers NVIDIA, AMD o Intel, el sistema reinicia y la pantalla se queda en negro
- Se oyen sonidos de inicio (login, música) pero no hay imagen
- El monitor recibe señal pero muestra "No Signal" o pantalla completamente negra
- Solo se ve un cursor parpadeando en la esquina superior izquierda
- En algunos casos, se puede cambiar a TTY con `Ctrl+Alt+F2` pero el display manager (GDM/SDDM/LightDM) no arranca

## Diagnóstico

```bash
# 1. Cambiar a una TTY (esto casi siempre funciona aunque la pantalla esté negra)
Ctrl+Alt+F2          # o F3-F6 — te lleva a una terminal de texto
# Si ves el prompt de login, el sistema está funcionando — es problema gráfico

# 2. Una vez en TTY, revisar logs del display manager
journalctl -xe -u gdm      # GNOME (GDM)
journalctl -xe -u sddm     # KDE (SDDM)
journalctl -xe -u lightdm  # XFCE/Linux Mint (LightDM)

# 3. Ver qué driver de video está cargado
lspci -k | grep -A 3 -E "(VGA|3D)"

# 4. Revisar errores del kernel relacionados con GPU
dmesg | grep -iE "(nvidia|amdgpu|i915|firmware|drm)"

# 5. Ver modo de video actual y resoluciones disponibles
cat /sys/class/drm/*/status   # connected/disconnected
cat /sys/class/drm/*/modes    # modos disponibles

# 6. Si es NVIDIA, verificar si el módulo nouveau interfiere
lsmod | grep nouveau
lsmod | grep nvidia
```

### Logs relevantes

```
# Errores típicos en journalctl
gdm: GdmDisplay: display failed
sddm: Failed to start Display Server
kernel: NVRM: failed to initialize
kernel: [drm] *ERROR* Failed to load firmware
```

## Causa

1. **Driver incompatible con la versión del kernel** — drivers NVIDIA requieren versiones específicas del kernel; tras un `pacman -Syu` o `apt upgrade`, el kernel puede actualizarse pero no el módulo NVIDIA compilado contra la versión anterior.
2. **Secure Boot bloqueando el módulo** — los drivers NVIDIA/AMD no firmados no se cargan si Secure Boot está activo (salvo que uses MOK).
3. **nouveau vs nvidia en conflicto** — el driver libre nouveau y el propietario NVIDIA no pueden coexistir; uno debe estar en blacklist.
4. **Wayland incompatible con la GPU/driver** — ciertos drivers NVIDIA legacy no funcionan bien con Wayland; probar con X11.
5. **Kernel mode setting (KMS) falla** — parámetros del kernel como `nomodeset` pueden ser necesarios para tarjetas problemáticas.
6. **Problema de Plymouth/initramfs** — el splash screen de arranque oculta errores que solo ves en modo texto.

## Solución

### 1. Acceder al sistema y deshacer el cambio (desde TTY o recovery mode)

```bash
# Acceder desde TTY (Ctrl+Alt+F2) o desde el recovery mode en GRUB
# Si no puedes ni entrar en TTY, reinicia y selecciona "Advanced options" en GRUB
# y elige un kernel anterior

# Una vez en terminal:

# Si instalaste drivers NVIDIA
sudo apt purge nvidia-*           # Debian/Ubuntu
sudo pacman -Rns nvidia          # Arch
# Si actualizaste
sudo apt install --reinstall nvidia-driver-XXX  # Debian/Ubuntu (versión específica)
sudo pacman -S nvidia-dkms        # Arch (DKMS recompila con cada kernel)

# Volver a nouveau (driver libre, menos rendimiento pero estable)
sudo modprobe nouveau
```

### 2. Desactivar temporalmente los drivers problemáticos desde GRUB

```bash
# En la pantalla de GRUB, seleccionar el kernel y presionar 'e' para editar
# Buscar la línea que empieza con "linux" y agregar al final:
nomodeset
# O para NVIDIA específicamente:
nvidia-drm.modeset=0 rd.driver.blacklist=nouveau
# Presionar Ctrl+X o F10 para arrancar con esos parámetros
```

### 3. Reconstruir initramfs tras cambios de driver

```bash
# Debian/Ubuntu
sudo update-initramfs -u

# Arch
sudo mkinitcpio -P

# Fedora
sudo dracut --force
```

### 4. Secure Boot — firmar el módulo (si está activo)

```bash
# Verificar estado
mokutil --sb-state

# Firmar módulo NVIDIA (tras generarlo)
sudo mokutil --import /var/lib/dkms/mok.pub  # guía paso a paso
# O desactivar Secure Boot desde BIOS/UEFI
```

### 5. Forzar X11 (si el problema es Wayland)

```bash
# GDM: /etc/gdm/custom.conf
# Descomentar: WaylandEnable=false

# SDDM: /etc/sddm.conf
# [General]
# DisplayServer=x11

# LightDM usa X11 por defecto
```

### 6. Verificación

```bash
# Tras reiniciar, confirmar que el driver funciona
glxinfo | grep "OpenGL renderer"   # NVIDIA Corporation/AMD/Intel
nvidia-smi                          # solo NVIDIA
lsmod | grep nvidia                 # módulo cargado
sudo journalctl -xe -u gdm          # sin errores críticos
```

## Prevención

- Esperar antes de actualizar drivers NVIDIA en distros rolling release (Arch) — leer foros primero
- Usar **DKMS** para que los módulos se recompilen automáticamente al actualizar el kernel
- Mantener un kernel LTS como fallback (linux-lts en Arch, kernel antiguo en GRUB)
- Si tienes Secure Boot, firmar los módulos o desactivarlo antes de instalar drivers privativos
- Hacer snapshot del sistema con `timeshift` o `snapper` antes de cambios grandes de driver

## Notas adicionales

- Si no puedes acceder ni a TTY, arranca desde un **Live USB**, monta tu sistema y modifica la configuración desde ahí (`chroot`)
- `nomodeset` en los parámetros del kernel desactiva KMS y suele resolver cualquier pantalla negra relacionada con gráficos — pero limita la resolución a 1024×768
- En laptops con GPU híbrida (Intel + NVIDIA), intenta forzar solo la GPU integrada primero

## Enlaces externos

- [Arch Wiki — NVIDIA](https://wiki.archlinux.org/title/NVIDIA)
- [Arch Wiki — AMDGPU](https://wiki.archlinux.org/title/AMDGPU)
- [Ubuntu Help — Graphics drivers](https://help.ubuntu.com/community/BinaryDriverHowto/Nvidia)
- [Debian Wiki — NVIDIA](https://wiki.debian.org/NvidiaGraphicsDrivers)

## Ver también

- [[NVIDIA no detecta]] — problema relacionado: el driver NVIDIA no se carga
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — parámetros del kernel y arranque
- [[Bootloaders (GRUB Limine systemd-boot)]] — editar entradas de arranque
- [[Wayland vs X11]] — diferencias y cuándo usar cada uno
- [[Dual Boot con Windows]] — arranque compartido

#troubleshooting
