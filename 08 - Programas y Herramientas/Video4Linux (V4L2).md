---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# Video4Linux (V4L2)

## Definición

**Video4Linux** (V4L2) es la API de captura de video del kernel Linux. Proporciona una interfaz unificada para webcams USB, sintonizadoras de TV, capturadoras HDMI, cámaras CSI (Raspberry Pi), y cualquier dispositivo de video. V4L2 es la segunda versión (incluida desde kernel 2.5.x) y reemplazó al V4L original (kernel 2.1.x).

Está integrada directamente en el kernel y es la base sobre la que funcionan aplicaciones como:

- **OBS Studio** (streaming/grabación)
- **FFmpeg** / **GStreamer** (procesamiento de video)
- **Zoom**, **Skype**, **Google Meet** (videollamadas via `v4l2loopback`)
- **MPlayer**, **VLC**, **MPV** (reproducción)
- **Motion** / **ZoneMinder** (vigilancia)

---

## Comandos básicos (v4l-utils)

El paquete esencial para trabajar con V4L2 es `v4l-utils`:

```bash
# Instalar
sudo apt install v4l-utils                   # Debian/Ubuntu
sudo pacman -S v4l-utils                      # Arch

# Listar dispositivos V4L2 disponibles
v4l2-ctl --list-devices
# Ejemplo de salida:
# HD Webcam C525 (usb-0000:00:14.0-9):
#         /dev/video0
#         /dev/video1    ← (metadata, solo para ciertas cámaras)

# Información detallada de un dispositivo
v4l2-ctl -d /dev/video0 --all                 # toda la info
v4l2-ctl -d /dev/video0 --list-formats        # formatos de video soportados
v4l2-ctl -d /dev/video0 --list-formats-ext    # formatos + resoluciones (MUY detallado)

# Ver formatos de compresión
v4l2-ctl -d /dev/video0 --list-formats-out

# Cambiar propiedades (brillo, contraste, etc.)
v4l2-ctl -d /dev/video0 --list-ctrls         # lista controles disponibles
v4l2-ctl -d /dev/video0 --set-ctrl brightness=128
v4l2-ctl -d /dev/video0 --set-ctrl contrast=64
v4l2-ctl -d /dev/video0 --set-ctrl white_balance_temperature_auto=0
v4l2-ctl -d /dev/video0 --set-ctrl white_balance_temperature=4600

# Resolución y framerate
v4l2-ctl -d /dev/video0 --set-fmt-video=width=1920,height=1080,pixelformat=MJPG
v4l2-ctl -d /dev/video0 --set-parm=30         # 30 fps
```

### Ver la cámara en vivo

```bash
# Con ffplay (parte de ffmpeg)
ffplay /dev/video0

# Con MPV
mpv av://v4l2:/dev/video0

# Con OBS Studio: añadir fuente "Dispositivo de captura de video" → /dev/video0
```

### Capturar foto o video desde terminal

```bash
# Capturar una foto (JPEG) — si la cámara soporta MJPG
v4l2-ctl -d /dev/video0 --set-fmt-video=width=1920,height=1080,pixelformat=MJPG
v4l2-ctl -d /dev/video0 --stream-mmap --stream-to=foto.jpg --stream-count=1

# Capturar video con ffmpeg
ffmpeg -f v4l2 -i /dev/video0 -c:v libx264 -preset ultrafast captura.mp4

# Capturar con formato específico
ffmpeg -f v4l2 -input_format mjpeg -video_size 1920x1080 -framerate 30 -i /dev/video0 salida.mp4
```

---

## Formatos de píxel comunes

| Formato | Descripción | Compresión | Ancho de banda |
|---|---|---|---|
| **YUYV** | YUV 4:2:2 sin comprimir | ❌ | Alto |
| **MJPG** | Motion JPEG (cada frame es JPEG) | ✅ | Bajo (recomendado) |
| **H264** | H.264 comprimido por hardware | ✅ | Muy bajo |
| **NV12** | YUV 4:2:0 planar (usado por OBS) | ❌ | Medio |
| **RGB3** | RGB sin comprimir | ❌ | Muy alto |

> 💡 **Siempre que puedas, usa MJPG o H264** — reducen drásticamente el ancho de banda USB y la carga de CPU. YUYV a 1080p@30 requiere ~124 MB/s; MJPG son ~10-20 MB/s.

```bash
# Ver qué formatos soporta tu cámara
v4l2-ctl -d /dev/video0 --list-formats
```

---

## v4l2loopback — Cámaras virtuales

**v4l2loopback** es un módulo del kernel que crea dispositivos V4L2 virtuales. Es esencial para OBS + videollamadas (enviar ventanas/presentaciones como si fueran una cámara).

```bash
# Instalar
sudo apt install v4l2loopback-dkms           # Debian/Ubuntu
sudo pacman -S v4l2loopback-dkms             # Arch

# Cargar módulo (crea /dev/videoX virtual)
sudo modprobe v4l2loopback

# Cargar con opciones: varios dispositivos, nombre personalizado
sudo modprobe v4l2loopback devices=2 video_nr=10,11 card_label="Cámara Virtual","Pantalla Compartida"

# Usar desde OBS: Tools → V4L2 Sink → elegir dispositivo virtual
# Ahora la app de videollamada puede ver /dev/video10 como una cámara más

# Ver módulo cargado
lsmod | grep v4l2loopback
v4l2-ctl --list-devices
# Salida esperada:
# Dummy video device (0x0000) (platform:v4l2loopback-000):
#         /dev/video10
#         /dev/video11
```

**Caso de uso típico**: OBS Studio → composición de escenas (cámara real + pantalla compartida + overlays) → v4l2loopback → Google Meet/Zoom/Skype como cámara.

---

## Troubleshooting de webcams en Linux

| Problema | Causa | Solución |
|---|---|---|
| **No aparece /dev/video*** | Cámara no detectada por el kernel | `lsusb` para ver si el USB reconoce el dispositivo. `dmesg \| grep video` para logs del kernel |
| **La cámara aparece pero no muestra imagen** | Formato/resolución incorrectos | Probar con `v4l2-ctl --list-formats-ext` y elegir una resolución soportada |
| **Imagen en blanco/negra en Zoom/Meet** | La app no puede acceder al dispositivo V4L2 | Usar `v4l2loopback` + OBS como intermediario |
| **Error: "Device or resource busy"** | Otro proceso está usando la cámara | `fuser /dev/video0` para ver qué PID está usándola |
| **Cámara funciona pero muy lenta** | Resolución muy alta o formato sin comprimir | Cambiar a MJPG: `sudo v4l2-ctl -d /dev/video0 --set-fmt-video=width=1280,height=720,pixelformat=MJPG` |
| **La cámara no es reconocida en absoluto** | Falta el driver (USB class compatible no siempre funciona) | Buscar en Google: "[modelo cámara] linux" y verificar soporte en kernel |
| **Solo funciona en una app a la vez** | V4L2 no permite acceso simultáneo por defecto | Usar `v4l2loopback` con `exclusive_caps=1` para re-streaming |

### Diagnóstico rápido

```bash
# ¿Se detecta el dispositivo USB?
lsusb
# Bus: 001 Device 005: ID 046d:0825 Logitech, Inc. Webcam C525

# ¿El kernel cargó un driver para video?
dmesg | grep -i video | tail -5
# uvcvideo: Found UVC 1.00 device HD Webcam C525 (046d:0825)

# ¿Aparece /dev/video*?
ls -la /dev/video*

# ¿Qué formato/resolución está usando ahora?
v4l2-ctl -d /dev/video0 --get-fmt-video

# ¿Qué permisos tiene el dispositivo?
ls -la /dev/video0
# crw-rw----+ 1 root video 81, 0 jul 19 12:00 /dev/video0
# Tu usuario necesita estar en el grupo `video`:
sudo usermod -aG video $USER
# Cerrar sesión y volver a entrar
```

---

## Aplicaciones populares que usan V4L2

| App | Uso | Instalación |
|---|---|---|
| **OBS Studio** | Streaming, grabación, cámara virtual vía v4l2loopback | `sudo apt install obs-studio` |
| **FFmpeg** | Capturar/procesar/transcodificar desde V4L2 | `sudo apt install ffmpeg` |
| **guvcview** | GUI sencilla para webcam, ajustes en vivo | `sudo apt install guvcview` |
| **Kamoso** | Captura de fotos/webcam (KDE) | `sudo apt install kamoso` |
| **Cheese** | Captura de fotos/webcam (GNOME) | `sudo apt install cheese` |
| **Motion** | Detección de movimiento con webcam | `sudo apt install motion` |
| **v4l2loopback** | Cámaras virtuales para OBS+Meet | `sudo apt install v4l2loopback-dkms` |

---

## Ver también

- [[ffmpeg]] — captura y procesamiento de video desde V4L2
- [[Multimedia (GStreamer HandBrake VLC MPV)]] · [[vlc]] · [[mpv]] — reproductores que soportan V4L2
- [[Navegadores Web]] — videollamadas en el navegador
- [[Módulos del kernel (lsmod modprobe blacklist)]] — cómo cargar v4l2loopback
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]] — detectar cámaras USB

## Enlaces externos

- [Documentación V4L2 del kernel](https://docs.kernel.org/media/uapi/v4l/v4l2.html)
- [v4l-utils (GitHub)](https://github.com/tomba/kmsxx/tree/master/v4l-utils) — paquete de utilidades
- [v4l2loopback (GitHub)](https://github.com/umlaeute/v4l2loopback) — módulo de cámaras virtuales
- [Arch Wiki — Webcam](https://wiki.archlinux.org/title/Webcam_setup)
- [Wikipedia: Video4Linux](https://es.wikipedia.org/wiki/Video4Linux)

#programa #v4l2 #video
