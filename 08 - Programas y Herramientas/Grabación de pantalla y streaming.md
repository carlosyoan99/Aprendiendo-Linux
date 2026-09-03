---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# Grabación de pantalla y streaming

> Guía práctica para grabar la pantalla y hacer streaming en Linux: **OBS Studio** como herramienta principal, alternativas CLI (ffmpeg, wf-recorder, gpu-screen-recorder), aceleración por GPU (VAAPI/NVENC), y configuración de baja latencia para streams en vivo.

## Qué es

Grabar la pantalla y transmitir en vivo requiere: **captura de video** (pantalla + cámara), **captura de audio** (micrófono + audio del sistema), **mezcla de escenas**, **codificación** (CPU o GPU) y **transmisión** (local o a plataformas). Linux soporta todo esto nativamente vía PipeWire + VAAPI/NVENC, pero cada pieza tiene sus peculiaridades según Wayland/X11 y la GPU.

---

## OBS Studio — la herramienta principal

### Instalación

```bash
# Debian/Ubuntu (repos oficiales de OBS, versión actual):
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update && sudo apt install obs-studio

# Arch:
sudo pacman -S obs-studio

# Fedora (RPM Fusion):
sudo dnf install obs-studio

# Flatpak (funciona bien en Wayland):
flatpak install flathub com.obsproject.Studio
```

### Captura en X11 vs Wayland

| Entorno | Método de captura | Estado |
|---|---|---|
| **X11** | `XSHM` (captura directa) | ✅ Excelente, 60fps |
| **Wayland (GNOME/KDE)** | PipeWire via `xdg-desktop-portal` | ✅ Bueno desde OBS 27 |
| **Wayland (Sway/Hyprland)** | PipeWire via `xdg-desktop-portal-wlr` | ✅ Bueno |
| **Grabar ventana específica** | PipeWire window capture | ✅ Soporta (OBS 28+) |

### Configuración inicial (ventana "Autoconfiguración")

```bash
# Archivo de configuración: ~/.config/obs-studio/
# - global.ini        → ajustes generales
# - scenes/           → escenas guardadas
# - basic/scenes.json → escenas por defecto

# Primer inicio: Archivo → Autoconfiguración → "Optimizar para streaming"
# OBS elige por ti: resolución 1920x1080, FPS 60, bitrate según prueba
```

### Escenas y fuentes

```bash
# Escenas típicas:
# 1. "Inicio"  → cámara + nombre + webcam
# 2. "Pantalla" → captura de pantalla completa
# 3. "Juego"   → captura de juego específico (Game Capture)
# 4. "BRB"     → pantalla negra con texto

# Fuentes más usadas:
# - Captura de pantalla (PipeWire / XSHM)
# - Captura de juego (solo X11, mejor rendimiento que pantalla completa)
# - Captura de ventana (ventana específica)
# - Dispositivo de captura de video (webcam /dev/video0)
# - Captura de audio (micrófono / audio de escritorio)
# - Texto (GDI+/FreeType)
# - Imagen / Slideshow
# - Browser (para overlays web)
```

### Atajos de teclado

| Atajo por defecto | Efecto |
|---|---|
| `Ctrl+R` | Iniciar/detener grabación |
| `Ctrl+Shift+R` | Reiniciar grabación |
| `Ctrl+S` | Iniciar/detener streaming |
| `Ctrl+Shift+S` | Reiniciar streaming |
| `Ctrl+M` | Mute/desmute micrófono |
| `Ctrl+Shift+M` | Mute/desmute audio de escritorio |
| `Ctrl+E` | Activar/desactivar studio mode |
| `Ctrl+F` | Activar/desactivar filtro |

### Filtros esenciales

```bash
# Por fuente:
# - Corrección de color (CC)
# - Recorte/Padding
# - Interacción de color (cropping)
# - Escala

# Por audio:
# - Supresor de ruido (RNNoise — gratis, buen resultado)
# - Compresor
# - Puerta de ruido (noise gate)
# - Ecualizador (10 bandas)

# Por video:
# - LUT (color grading)
# - Chroma Key (fondo verde)
# - Desenfoque (blur)
```

---

## Codificación por GPU (lo más importante)

### VAAPI (Intel/AMD — aceleración por hardware)

```bash
# Requisitos:
# Intel: paquetes intel-media-driver o libva-intel-driver
sudo apt install intel-media-driver            # Intel gen 8+
# AMD: mesa-va-drivers
sudo apt install mesa-va-drivers

# Verificar que VAAPI funciona:
vainfo | head -10
# Debe mostrar perfiles de codificación, ej:
# VAProfileH264Main, VAProfileHEVCMain

# En OBS → Ajustes → Salida → Codificador: "VAAPI H.264" o "VAAPI HEVC"
```

### NVENC (NVIDIA)

```bash
# Requisitos: driver NVIDIA + codecs propietarios
sudo apt install nvidia-driver-545            # o el que corresponda
sudo apt install nvidia-vaapi-driver          # para usar VAAPI sobre NVIDIA

# Verificar:
nvidia-smi | grep "Video Encode"
# Debe listar el motor NVENC

# En OBS → Ajustes → Salida → Codificador: "NVIDIA NVENC H.264" / "NVIDIA NVENC HEVC"
```

### Comparativa de codificadores

| Codificador | GPU | Calidad/bitrate | Latencia | Uso CPU | Ideal para |
|---|---|---|---|---|---|
| **libx264** | — (CPU) | Alta | Media | Alto | Grabaciones de máxima calidad |
| **VAAPI H.264** | Intel/AMD | Media-Alta | Baja | Bajo | Streaming en Intel/AMD |
| **NVENC H.264** | NVIDIA | Alta | Baja | Muy bajo | Streaming/grabación NVIDIA |
| **QSV H.264** | Intel (QuickSync) | Media | Baja | Muy bajo | Streaming Intel |
| **AV1 (VAAPI)** | Intel Arc / AMD RX7000+ | Muy alta | Baja | Bajo | Streaming alta calidad, poco bitrate |
| **AV1 (NVENC)** | NVIDIA 40xx | Muy alta | Baja | Muy bajo | Streaming alta calidad |

**Recomendación**:
- Grabar local → `libx264` con `preset slow` + CRF 18 (calidad)
- Streaming Intel/AMD → `VAAPI H.264` 6000kbps
- Streaming NVIDIA → `NVENC H.264` 6000kbps
- Streaming AV1 → 4500kbps equivale visualmente a 8000kbps H.264

### Parámetros de calidad (OBS → Salida → Avanzado)

```
# Grabación local (alta calidad):
# - Codificador: libx264
# - Rate Control: CRF
# - CRF: 18-21
# - Preset: slow o medium
# - FPS: 60

# Streaming 1080p60 (Twitch/YouTube):
# - Bitrate: 6000-8000 kbps
# - Rate Control: CBR
# - Keyframe interval: 2 segundos
# - Preset: medium

# Streaming 720p30 (conexión limitada):
# - Bitrate: 2500-3500 kbps
# - Keyframe interval: 2 segundos
```

---

## Configuración de baja latencia

### Para streaming en vivo (OBS)

```bash
# OBS → Ajustes → Avanzado:
# - "Minimizar impactos de streaming en juegos" → ON
# - "Usar tiempos de proceso livianos" → ON (si no capturas cámara 4K)

# OBS → Ajustes → Salida:
# - Keyframe interval: 2 (obligatorio en Twitch)
# - Rate Control: CBR
# - Bitrate: según conexión (subir 6000kbps requiere ~7Mbps de subida estable)

# Latencia en el monitor de OBS:
# - Modo Estudio: previsualiza sin latencia de streaming
# - "Mostrar retraso de stream" para ver qué llega a la plataforma
```

### Baja latencia para monitor local (ver tu propia pantalla)

```bash
# Si quieres minimizar latencia entre acción y pantalla (competición):
# - Desactivar VSync en juegos (OBS no controla esto)
# - Usar exclusión de OBS del compositor:
#   En GNOME: GNOME → Tweaks → Extensions → disable compositor delay

# PipeWire puede introducir latencia de audio; verificar:
wpctl status | grep -i "audio"
# Si hay delay notable en el audio de monitor:
pactl set-sink-latency-msec <sink> 20
```

### Latencia de red (streaming)

```bash
# La latencia de stream depende de:
# 1. Codificador (baja latencia: NVENC/VAAPI vs CPU)
# 2. Keyframe interval (2s para Twitch)
# 3. Plataforma (Twitch ~3-6s, YouTube ~5-15s, Bilibili ~2-5s)
# 4. Tu ping al servidor de ingest

# Medir ping al servidor de ingest (Twitch):
ping ingest.twitch.tv
# Ejemplo de servidores: rtmp://iad02.contribute.live-video.net

# Subir a YouTube con latencia ultra-baja (unms):
# 1. YouTube Studio → Emitir en directo → Habilitar "Latencia ultrabaja"
# 2. OBS → Ajustes → Salida → "Bajar retraso del stream" ON
```

---

## Alternativas a OBS

### wf-recorder (Wayland, simple)

```bash
# Grabar pantalla en Wayland directamente (sin OBS)
sudo pacman -S wf-recorder        # Arch
sudo apt install wf-recorder      # Debian/Ubuntu (si está en repos)

# Grabar pantalla completa
wf-recorder -o output.mp4

# Grabar con audio (micrófono)
wf-recorder -o output.mp4 --audio

# Grabar región específica
slurp | wf-recorder -g - -o region.mp4

# Detener: Ctrl+C (finaliza el archivo correctamente)
```

### gpu-screen-recorder (NVIDIA, mínima latencia)

```bash
# Grabador enfocado a gaming con NVENC — latencia casi nula
# AUR:
yay -S gpu-screen-recorder

# Grabar pantalla completa 1080p60
gpu-screen-recorder -w screen -f 60 -c mp4 -r 60 -o ~/Videos/rec.mp4

# Grabar una ventana
gpu-screen-recorder -w "Nombre de ventana" -f 60 -c mp4 -o ~/Videos/rec.mp4
```

### ffmpeg (CLI puro)

```bash
# X11:
ffmpeg -f x11grab -framerate 60 -video_size 1920x1080 -i :0.0 \
  -c:v libx264 -crf 18 output.mp4

# Wayland (via PipeWire):
ffmpeg -f pipewire -i default -c:v libx264 -crf 18 output.mp4

# Con audio (audio de sistema):
ffmpeg -f x11grab -framerate 60 -i :0.0 \
  -f pulse -i default -c:v libx264 -c:a aac output.mp4

# NVENC:
ffmpeg -f x11grab -framerate 60 -i :0.0 -c:v h264_nvenc -preset p4 -b:v 6000k output.mp4

# VAAPI:
ffmpeg -vaapi_device /dev/dri/renderD128 -f x11grab -framerate 60 -i :0.0 \
  -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v 6000k output.mp4
```

### Comparativa de herramientas

| Herramienta | GUI | Wayland | GPU enc. | Latencia | Ideal para |
|---|---|---|---|---|---|
| **OBS Studio** | ✅ | ✅ | ✅ VAAPI/NVENC | Baja | Todo: grabación + streaming |
| **wf-recorder** | ❌ | ✅ | ✅ | Baja | Grabación rápida en Wayland |
| **gpu-screen-recorder** | ❌ | Parcial | ✅ NVENC | Muy baja | Gaming NVIDIA |
| **ffmpeg** | ❌ | ✅ | ✅ | Baja | Scripting, automatización |
| **GNOME Screen Recording** | ✅ | ✅ | ❌ | Alta | Captura casual (Ctrl+Shift+Alt+R) |
| **Kooha** | ✅ | ✅ | ✅ | Media | Grabación simple con GUI |

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| **Captura de pantalla en negro (Wayland)** | Portal no funcionando | `systemctl --user restart xdg-desktop-portal-wlr`, verificar `wpctl status` |
| **Captura de pantalla en negro (X11)** | Falta permisos X | Ejecutar OBS con `DISPLAY=:0`, verificar Xauthority |
| **Sin audio en grabación** | PipeWire-Pulse no captura monitor | OBS → Audio → "Audio de escritorio" seleccionar sink monitor |
| **Audio de escritorio no se captura** | No existe "monitor" source | `pactl list sources` buscar "monitor"; si no: PipeWire loopback |
| **NVENC no disponible** | Driver sin codecs | Instalar driver completo: `sudo apt install nvidia-driver-<ver>` (no open) |
| **VAAPI no disponible** | Falta paquete de VAAPI | Instalar `intel-media-driver` (Intel) o `mesa-va-drivers` (AMD) |
| **60fps pero lag en juego** | OBS compite por GPU | Limitar a 60fps en juego, usar NVENC (no CPU), `render` en segunda GPU si existe |
| **Streaming se corta** | Subida insuficiente | Bajar bitrate, usar 720p30 en vez de 1080p60, cerrar apps con red |
| **Audio desincronizado del video** | Buffer de PipeWire | OBS → Ajustes → Audio → "Sincronizar audio" ajustar ms |
| **AV1 no disponible** | GPU antigua | Verificar `vainfo` para perfiles AV1; solo Arc/RX7000+/RTX40 |

### Verificación

```bash
# Verificar captura de PipeWire:
wpctl status | grep -i "video\|capture"

# Verificar VAAPI:
vainfo

# Verificar NVENC:
nvidia-smi | grep "Video Encode"

# Test rápido de grabación (5 segundos):
ffmpeg -f x11grab -framerate 30 -video_size 640x480 -i :0.0 -t 5 -c:v libx264 test.mp4
# ¿Archivo generado? → funciona
```

---

## Streaming a plataformas

### Twitch

```bash
# OBS → Ajustes → Transmisión:
# - Servicio: Twitch
# - Servidor: auto (o el más cercano)
# - Clave de transmisión: dashboard.twitch.tv → Settings → Stream

# Parámetros recomendados 1080p60:
# - Bitrate: 6000 kbps
# - Encoder: NVENC o VAAPI
# - Keyframe: 2s
# - FPS: 60 (solo si tienes subida estable; 30fps si no)
```

### YouTube

```bash
# OBS → Ajustes → Transmisión:
# - Servicio: YouTube Live
# - Clave de stream: YouTube Studio → Emitir en directo → Obtener clave

# Para baja latencia en YouTube:
# YouTube Studio → Emitir → Configuración → Latencia: ultrabaja

# YouTube acepta hasta 51000 kbps (1440p) — puedes subir bitrate si la subida lo permite
```

### Baja latencia general

```bash
# La latencia total = encoder + network + plataforma:
# - Encoder: NVENC/VAAPI ≈ 50-100ms
# - Network: tu ping al ingest ≈ 10-50ms
# - Plataforma: Twitch ≈ 3-6s, YouTube normal ≈ 5-15s

# Para minimizar:
# 1. Usar NVENC/VAAPI (no CPU)
# 2. Keyframe interval 2s
# 3. Twitch en vez de YouTube (si la audiencia lo permite)
# 4. No usar "buffer" extra en OBS (Rate Control CBR)
```

---

## Ver también

- [[ffmpeg]] — grabación/conversión CLI
- [[PipeWire]] — servidor multimedia (captura de audio/video)
- [[Problemas de audio avanzados]] — captura de audio, latencia
- [[Compatibilidad Wayland]] — screen sharing y captura en Wayland
- [[Multimedia (GStreamer HandBrake VLC MPV)]] — ecología multimedia
- [[NVIDIA no detecta]] — drivers NVIDIA para NVENC

#multimedia #streaming #obs #grabacion #gpu