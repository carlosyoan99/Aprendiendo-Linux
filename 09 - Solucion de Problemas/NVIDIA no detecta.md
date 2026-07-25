---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-20
estado: resuelto
categoria: troubleshooting
sistema: NVIDIA / Linux graphics
prioridad: alta
---

# GPU NVIDIA no detectada / drivers no funcionan

## Síntoma

La GPU NVIDIA no se detecta, los drivers privativos no cargan, la resolución de pantalla es incorrecta, o hay parpadeo/artefactos gráficos. Al ejecutar `nvidia-smi` aparece "command not found" o "NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver".

## Diagnóstico

```bash
# 1. ¿Hay GPU NVIDIA?
lspci | grep -i nvidia                    # verificar que el hardware está presente
lspci -k | grep -A 3 -i nvidia           # driver actual (nouveau? nvidia?)

# 2. ¿Está cargado el driver?
lsmod | grep nvidia                       # nvidia, nvidia_drm, nvidia_modeset, nvidia_uvm
nvidia-smi                                # estado del driver (temperatura, memoria, procesos)

# 3. ¿El display manager usa NVIDIA?
glxinfo | grep -i "OpenGL renderer"       # qué GPU está usando OpenGL

# 4. Wayland vs X11
echo $XDG_SESSION_TYPE                    # wayland o x11
```

## Causa

1. **Driver NVIDIA no instalado** — la distro usa el driver open-source `nouveau` por defecto.
2. **Secure Boot bloqueando el módulo** — los drivers NVIDIA necesitan Secure Boot desactivado o firmar el módulo.
3. **Conflicto con el kernel** — después de actualizar el kernel, el módulo NVIDIA no se reconstruyó (DKMS).
4. **Laptop híbrida (Intel/AMD + NVIDIA)** — no está usando la GPU dedicada.
5. **Instalación incorrecta tras actualización mayor** — los drivers de la versión anterior no son compatibles.

## Solución

```bash
# ── Arch / CachyOS ──
sudo pacman -S nvidia nvidia-utils        # driver + utilidades
# Si usas kernel linux-lts:
sudo pacman -S nvidia-lts

# ── Debian/Ubuntu ──
sudo apt install nvidia-driver            # driver recomendado
sudo ubuntu-drivers auto                  # detección automática

# ── Fedora ──
# (requiere RPM Fusion primero)
sudo dnf install akmod-nvidia             # módulo con auto-reconstrucción

# ── Pasos posteriores ──
# Regenerar initramfs
sudo mkinitcpio -P                        # Arch
sudo update-initramfs -u                  # Debian/Ubuntu

# Cargar módulos (si no cargaron automáticamente)
sudo modprobe nvidia
sudo modprobe nvidia_drm modeset=1

# Verificar instalación
nvidia-smi                                # muestra info de la GPU

# Para laptops híbridas: asegurar que las apps usen la GPU dedicada
# Ejecutar app con GPU dedicada:
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxgears
```

### Desactivar Secure Boot (si bloquea los módulos)

```bash
# Desde BIOS/UEFI: entrar al menú de boot y desactivar Secure Boot
# O, en algunas distros, firmar el módulo NVIDIA:
sudo mokutil --disable-validation          # desactivar validación de módulos
# (requiere reinicio y seguir el asistente MOK)
```

## Ver también

- [[Nouveau (controlador)]] — driver libre NVIDIA, el que viene por defecto
- [[Wayland vs X11]] — implicaciones del servidor gráfico con NVIDIA
- [[Videojuegos en Linux]] — gaming con GPU NVIDIA
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — parámetro `nomodeset` para NVIDIA

## Referencias

- Arch Wiki: [NVIDIA](https://wiki.archlinux.org/title/NVIDIA)
- Ubuntu Help: [NVIDIA drivers](https://help.ubuntu.com/community/BinaryDriverHowto/Nvidia)
- Fedora Wiki: [NVIDIA](https://rpmfusion.org/Howto/NVIDIA)

#troubleshooting
