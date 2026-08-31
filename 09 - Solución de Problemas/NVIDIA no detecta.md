---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: troubleshooting
sistema: NVIDIA / Linux graphics
prioridad: alta
---

# GPU NVIDIA no detectada / drivers no funcionan

> La GPU NVIDIA no se detecta, los drivers privativos no cargan tras la instalación, `nvidia-smi` falla, o hay artefactos/pantalla en negro al iniciar sesión. Es el problema gráfico más común en Linux.

## Síntoma

- `nvidia-smi` → `command not found` o `NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver`.
- Pantalla en negro o parpadeo al iniciar sesión.
- Resolución incorrecta (ej: 800x600 en un monitor 1080p).
- Artefactos gráficos, glitches, o crasheo al abrir aplicaciones 3D.
- `lsmod | grep nvidia` no muestra nada (módulo no cargado).
- El sistema usa `nouveau` (driver libre) en vez de `nvidia` (privativo).

## Diagnóstico

```bash
# 1. ¿Hay GPU NVIDIA? ¿Qué driver usa?
lspci | grep -i nvidia                    # hardware detectado
lspci -k | grep -A 3 -i nvidia           # driver en uso (nouveau o nvidia)

# 2. ¿El driver NVIDIA está instalado?
which nvidia-smi                          # ¿existe el binario?
nvidia-smi                                # ¿funciona? (temperatura, memoria, procesos)

# 3. ¿El módulo está cargado?
lsmod | grep -E "nvidia|nvidia_drm|nvidia_modeset"
sudo dmesg | grep -i nvidia | tail -20    # errores del driver

# 4. ¿Qué renderizador OpenGL usa el sistema?
glxinfo -B | grep -i "OpenGL renderer"    # "NVIDIA" o "Nouveau"

# 5. ¿X11 o Wayland?
echo $XDG_SESSION_TYPE                    # wayland o x11

# 6. ¿Secure Boot está activo?
mokutil --sb-state                        # SecureBoot: enabled/disabled
```

### Logs relevantes

```bash
# Errores del kernel relacionados con NVIDIA
dmesg | grep -iE "nvidia|nouveau|drm" | tail -30

# Errores de Xorg (X11)
cat /var/log/Xorg.0.log | grep -iE "nvidia|EE|WW" | tail -30

# Errores de Wayland
journalctl --user -b | grep -iE "nvidia|drm" | tail -20

# Si el módulo no se cargó por Secure Boot
journalctl -k | grep -i "Secure Boot\|locked"
```

## Causa

1. **Driver NVIDIA no instalado** — la distro usa el driver open-source `nouveau` por defecto. Hay que instalar los drivers privativos manualmente.
2. **Secure Boot bloqueando el módulo** — los módulos del kernel NVIDIA no están firmados y Secure Boot impide que se carguen.
3. **DKMS no reconstruyó el módulo tras actualizar el kernel** — el módulo compilado para el kernel anterior no es compatible con el nuevo.
4. **Laptop híbrida (Intel/AMD + NVIDIA) mal configurada** — la GPU NVIDIA está presente pero no se usa (el sistema usa solo la integrada).
5. **Instalación incorrecta tras actualización mayor de distro** — drivers de la versión anterior no compatibles con el nuevo kernel/Xorg.
6. **Nouveau no blacklisted** — ambos drivers compiten y nouveau gana por ser el que arranca primero.

## Solución

### Instalar driver NVIDIA según distro

```bash
# ── Arch / CachyOS / EndeavourOS ──
sudo pacman -S nvidia nvidia-utils        # driver + utilidades
sudo pacman -S nvidia-settings            # panel de control gráfico
# Si usas kernel linux-lts:
sudo pacman -S nvidia-lts
# Si usas kernel linux-zen:
sudo pacman -S nvidia-dkms                # módulo DKMS (se reconstruye solo)

# ── Debian/Ubuntu / Linux Mint / Pop OS ──
sudo apt install nvidia-driver            # driver recomendado (detecta versión)
sudo ubuntu-drivers auto                  # instalar el driver recomendado automáticamente

# Pop OS tiene su propio gestor NVIDIA:
sudo apt install system76-cuda-latest     # Pop OS (versión más reciente)

# ── Fedora (requiere RPM Fusion) ──
sudo dnf install akmod-nvidia             # módulo con auto-reconstrucción vía akmod
sudo dnf install xorg-x11-drv-nvidia-cuda # soporte CUDA

# ── openSUSE ──
sudo zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed nvidia
sudo zypper install kernel-devel kernel-source
sudo zypper install nvidia-driver-G06
```

### Pasos posteriores a la instalación

```bash
# Blacklist nouveau (para que no compita con nvidia)
echo -e "blacklist nouveau\noptions nouveau modeset=0" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf

# Regenerar initramfs
# Arch:
sudo mkinitcpio -P
# Debian/Ubuntu:
sudo update-initramfs -u
# Fedora:
sudo dracut --force

# Cargar módulos (si no cargaron automáticamente)
sudo modprobe nvidia
sudo modprobe nvidia_drm modeset=1
sudo modprobe nvidia_modeset
sudo modprobe nvidia_uvm

# Verificar
nvidia-smi                                # debe mostrar info de la GPU
```

### Secure Boot

```bash
# Opción 1: Desactivar Secure Boot desde BIOS/UEFI
# (entrar al menú de boot y desactivarlo)

# Opción 2: Importar la clave MOK y firmar el módulo (mantiene Secure Boot activo)
# Generar/obtener la clave MOK (MOK.der) y registrarla para poder firmar el módulo NVIDIA
sudo mokutil --import MOK.der                 # registrar la clave MOK (pedirá contraseña)
# (requiere reinicio y seguir el asistente MOK para confirmar la importación)

# Opción 3 (Avanzado): Firmar el módulo manualmente
# /usr/src/nvidia-*/sign_module.sh
# Requiere: la clave MOK ya creada
```

### Laptops híbridas (NVIDIA Optimus)

```bash
# ── nvidia-prime (Ubuntu/Pop) ──
sudo apt install nvidia-prime
# Ejecutar app con GPU NVIDIA:
prime-run nombre_app

# ── optimus-manager (Arch) ──
yay -S optimus-manager
optimus-manager --switch nvidia            # cambiar a GPU dedicada (requiere logout)

# ── EnvyControl (todas las distros) ──
pipx install envycontrol
sudo envycontrol -s nvidia --force-integrated

# ── Ejecutar app específica sin cambiar todo el sistema ──
# X11:
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxgears

# Wayland:
nvidia-offload glxgears                   # si tienes nvidia-prime configurado
```

### Verificación

```bash
nvidia-smi                                # estado: driver, memoria, procesos
nvidia-settings                           # panel de control (si está instalado)
glxinfo -B | grep "OpenGL renderer"       # debe decir "NVIDIA"
lsmod | grep nvidia                       # módulos cargados
```

## Escenarios / Variantes

| Variante / Síntoma | Causa | Solución |
|---|---|---|
| **Pantalla en negro al iniciar sesión (X11)** | El driver NVIDIA no es compatible con la versión de Xorg o hay conflictos | Arrancar en modo recovery, purgar driver (`sudo apt purge nvidia-*`), reinstalar versión correcta, o usar `nomodeset` en kernel params |
| **nvidia-smi: "No devices were found"** | Driver instalado pero no detecta la GPU (NVIDIA Optimus mal configurado) | Verificar con `lspci \| grep -i nvidia`; instalar `nvidia-prime` o `optimus-manager` |
| **"Failed to initialize NVML: Driver/library version mismatch"** | Driver actualizado pero módulo del kernel no coincide | `sudo modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia && sudo modprobe nvidia && nvidia-smi` |
| **Artefactos gráficos / glitches** | Sobrecalentamiento, overclock inestable, o versión de driver incorrecta | `nvidia-smi -q -d TEMPERATURE`; reducir overclock; probar versión anterior del driver (470xx para GPUs viejas) |
| **Sin audio HDMI desde GPU NVIDIA** | Módulo snd_hda_intel con parámetros incorrectos | `sudo modprobe snd_hda_intel enable=0,1` o blacklist del audio NVIDIA si no se usa |
| **Wayland no funciona con NVIDIA** | Controlador propietario no soporta Wayland completamente (especialmente GPUs < RTX 30) | Usar X11 (`sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf` y reiniciar) |
| **Pop OS: solo pantalla externa funciona** | Modo híbrido mal configurado | Cambiar modo en Settings → About → Graphics → NVIDIA (render offload) |
| **"NVIDIA-SMI: command not found"** tras instalar | nvidia-utils no instalado o PATH incorrecto | Instalar `nvidia-utils` (Arch) o `nvidia-driver` (Debian). Buscar con `find /usr -name nvidia-smi` |
| **Kernel panic al cargar nvidia** | Módulo compilado para kernel incorrecto | Reconstruir con DKMS: `sudo dkms autoinstall` o reinstalar driver |

## Prevención

1. **Antes de instalar Linux en una laptop con NVIDIA**, investigar si el modelo específico tiene buen soporte (especialmente Optimus).
2. **No actualizar el driver NVIDIA** justo antes de una presentación o trabajo crítico — hacerlo cuando haya tiempo para resolver problemas.
3. **Mantener DKMS funcionando**: `sudo dkms autoinstall` corrige automáticamente módulos tras actualizar el kernel.
4. **Al actualizar la distro** (ej: Ubuntu 22.04 → 24.04), purgar los drivers NVIDIA viejos antes de instalar los nuevos.
5. **Si usas Secure Boot**, configurar la firma MOK del módulo NVIDIA para evitar sorpresas tras cada actualización del driver.
6. **Usar `nvidia-dkms`** en vez de `nvidia` en Arch si cambias de kernel frecuentemente.

## Notas adicionales

- La serie **NVIDIA 470xx** es la última que soporta GPUs Kepler (GTX 600/700). GPUs muy antiguas (GTX 400/500) solo funcionan con nouveau.
- En laptops híbridas **Intel + NVIDIA**, el modo más estable suele ser **NVIDIA on-demand** (render offload) o **NVIDIA only** si la batería no es problema.
- Si tienes **AMD + NVIDIA** (laptop con AMD iGPU + NVIDIA dGPU), el soporte es mejor que Intel + NVIDIA porque AMD tiene drivers open-source en el kernel.
- `nouveau` ha mejorado mucho pero sigue sin soportar reclocking completo en GPUs modernas (menor rendimiento, mayor consumo).
- Para gaming con NVIDIA en Linux, ver [[Videojuegos en Linux]].

## Enlaces externos

- [Arch Wiki — NVIDIA](https://wiki.archlinux.org/title/NVIDIA)
- [Arch Wiki — NVIDIA Optimus](https://wiki.archlinux.org/title/NVIDIA_Optimus)
- [Ubuntu Help — NVIDIA drivers](https://help.ubuntu.com/community/BinaryDriverHowto/Nvidia)
- [Fedora Wiki — NVIDIA](https://rpmfusion.org/Howto/NVIDIA)
- [NVIDIA Official — Linux drivers](https://www.nvidia.com/en-us/drivers/unix/)
- [Gentoo Wiki — NVIDIA](https://wiki.gentoo.org/wiki/NVIDIA)

## Ver también

- [[Nouveau (controlador)]] — driver libre NVIDIA, el que viene por defecto
- [[Wayland vs X11]] — implicaciones del servidor gráfico con NVIDIA
- [[Videojuegos en Linux]] — gaming con GPU NVIDIA
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — parámetro `nomodeset` para NVIDIA
- [[Pantalla en negro tras actualizar drivers]] — cuando la pantalla queda negra tras instalar drivers
- [[Resolución de pantalla y multi-monitor]] — problemas de resolución y múltiples monitores

#troubleshooting
