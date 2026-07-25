---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# Multimedia (GStreamer, VLC, MPV, HandBrake)

## Descripción general

Linux dispone de un ecosistema multimedia muy completo. Desde frameworks de procesamiento como GStreamer hasta reproductores ligeros como MPV, pasando por conversores como HandBrake y la navaja suiza que es [[ffmpeg]].

```bash
Capas del ecosistema multimedia en Linux:

┌────────────────────────────────────────────────────────┐
│                  Aplicaciones multimedia                │
│  VLC · MPV · HandBrake · OBS · Kdenlive · Audacity    │
├────────────────────────────────────────────────────────┤
│              Frameworks / Motores                      │
│  GStreamer · FFmpeg · Qt Multimedia · SDL2             │
├────────────────────────────────────────────────────────┤
│              Codecs · Decodificadores                  │
│  libavcodec · libvpx · x264 · x265 · libmp3lame       │
├────────────────────────────────────────────────────────┤
│              Drivers · Servidores                      │
│  ALSA · PipeWire · VAAPI (HW accel) · Vulkan          │
└────────────────────────────────────────────────────────┘
```

---

## GStreamer

### Qué es

**GStreamer** es un framework multimedia modular. Es el backend multimedia de GNOME (Videos, Rhythmbox, Sound Juicer) y de muchas apps de escritorio. Está compuesto por **elementos** (source, filter, sink) que se encadenan en pipelines, similar a los pipes de Unix.

```bash
# Pipeline básico de GStreamer:
# source (archivo) → decoder → convert → sink (altavoz)
```

### Instalación

```bash
# Paquetes básicos
sudo apt install gstreamer1.0-tools gstreamer1.0-plugins-base  # Debian/Ubuntu
sudo pacman -S gstreamer gst-plugins-base                      # Arch

# Plugins para formatos adicionales
sudo apt install gstreamer1.0-plugins-good       # formatos libres (Vorbis, Theora, FLAC)
sudo apt install gstreamer1.0-plugins-bad        # formatos menos estables
sudo apt install gstreamer1.0-plugins-ugly       # formatos propietarios (MP3, MPEG)
sudo apt install gstreamer1.0-libav              # codecs de FFmpeg (H.264, H.265, AAC)

# En Arch:
sudo pacman -S gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
```

### Comandos básicos

```bash
# Ver elementos instalados
gst-inspect-1.0 | head -20          # listar elementos
gst-inspect-1.0 filesrc             # info de un elemento concreto

# Probar pipeline de audio
gst-launch-1.0 audiotestsrc ! audioconvert ! autoaudiosink  # tono de prueba

# Probar pipeline de video
gst-launch-1.0 videotestsrc ! videoconvert ! autovideosink  # barras de color

# Reproducir archivo
gst-play-1.0 video.mp4              # reproductor simple basado en GStreamer

# Transcodificar
gst-launch-1.0 filesrc location=entrada.mp4 ! qtdemux ! h264parse ! \
  avdec_h264 ! videoconvert ! vp8enc ! webmmux ! filesink location=salida.webm
```

### Uso en GNOME

GStreamer es el backend de todas las apps multimedia de GNOME:

```bash
# GNOME Videos (Totem)
# GNOME Music
# GNOME Sound Recorder
# Cheese (cámara web)
# Todas usan GStreamer por debajo
```

---

## VLC

### Qué es

**VLC** (VideoLAN Client) es el reproductor multimedia más popular en Linux. Reproduce prácticamente cualquier formato sin necesidad de codecs adicionales. También funciona como servidor de streaming y conversor de formatos.

### Instalación

```bash
sudo apt install vlc                   # Debian/Ubuntu
sudo pacman -S vlc                     # Arch
sudo dnf install vlc                   # Fedora (requiere RPM Fusion)
flatpak install flathub org.videolan.VLC
```

### Características destacadas

- Soporta todos los formatos (gracias a FFmpeg integrado)
- Streaming de red (UDP, HTTP, RTSP, HLS)
- Conversión de formatos (Media → Convert/Save)
- Captura de pantalla y grabación
- Efectos de audio y video (ecualizador, filtros)
- Plugins y extensiones (VLSub para subtítulos)
- Control por web (interfaz HTTP)
- Versión CLI: `cvlc` o `vlc -I ncurses`

### Comandos CLI útiles

```bash
# Reproducir desde terminal
cvlc video.mp4                         # sin interfaz gráfica
vlc -I ncurses video.mp4               # interfaz ncurses
vlc -I rc                              # control remoto por terminal

# Streaming
vlc http://example.com/stream.m3u8     # reproducir stream HLS

# Convertir formato
vlc entrada.mp4 --sout='#transcode{vcodec=h264,vb=1024,acodec=mp3,ab=128}:standard{mux=mp4,dst=salida.mp4,access=file}' vlc://quit

# Grabar pantalla
vlc screen:// --screen-fps=15 --sout='#transcode{vcodec=h264}:file{dst=captura.mp4}'
```

### Atajos de teclado

| Tecla | Acción |
|---|---|
| `Space` | Play/Pause |
| `f` | Pantalla completa |
| `Ctrl+↑/↓` | Volumen +/- |
| `Ctrl+→/←` | Avanzar/retroceder 10s |
| `g` / `G` | Subtítulos +/- 50ms |
| `v` | Cambiar pista de video |
| `a` | Cambiar pista de audio |
| `s` | Captura de pantalla |
| `e` | Siguiente capítulo |
| `t` | Mostrar tiempo restante |
| `n` / `p` | Siguiente/anterior archivo de la lista |

---

## MPV

### Qué es

**MPV** es un reproductor de video minimalista y ultrarrápido, fork de MPlayer y mplayer2. Diseñado para ser usado desde terminal, con controles por teclado y sin interfaz gráfica pesada. Es el favorito de los usuarios avanzados y de gestores de ventanas tiling.

### Instalación

```bash
sudo apt install mpv                    # Debian/Ubuntu
sudo pacman -S mpv                      # Arch
sudo dnf install mpv                    # Fedora
```

### Características

- **Integración con Wayland nativa** (mejor rendimiento que VLC en Wayland)
- **GPU acceleration** (Vulkan, OpenGL, Vulkan, D3D11 en Windows)
- **Scripting en Lua** (scripts para YouTube, subídulos automáticos, etc.)
- **Configuración vía archivo de texto plano** (`~/.config/mpv/mpv.conf`)
- **Latencia mínima** (ideal para reproducción local)
- **Control por teclado sin GUI** (ideal en tiling WMs)

### Comandos básicos

```bash
mpv video.mp4                          # reproducir
mpv https://www.youtube.com/watch?v=... # reproducir desde YouTube (con yt-dlp)
mpv --playlist=lista.txt               # reproducir lista de reproducción
mpv audio.mp3 --no-video               # solo audio
mpv --shuffle *.mp3                    # aleatorio

# Control durante reproducción
# 9 / 0      → volumen -/+ 
# [ / ]      → velocidad -/+
# f          → pantalla completa
# , / .       → fotograma anterior/siguiente (pausa)
# l          → cargar subtítulos
# v          → alternar subtítulos
# j / J      → ciclar pistas de audio
# #          → mostrar/oscurar OSD
# s / S      → captura de pantalla
```

### Configuración (`mpv.conf`)

```bash
# ~/.config/mpv/mpv.conf
profile=gpu-hq                          # perfil de alta calidad
hwdec=auto-safe                        # aceleración por hardware (VAAPI, VDPAU, Vulkan)
volume=50                               # volumen inicial
save-position-on-quit=yes               # guardar posición al salir
ytdl=yes                                # integración con yt-dlp
ytdl-format=bestvideo[height<=?1080]+bestaudio/best
keep-open=yes                           # mantener ventana abierta al terminar
osd-bar=yes                             # barra de progreso OSD
osd-duration=2000                       # duración del OSD en ms
border=no                               # sin bordes
snap-window=yes                         # ajustar a bordes de pantalla
```

### Scripts esenciales

```bash
# Instalar yt-dlp (necesario para YouTube y otros sitios)
sudo apt install yt-dlp                 # o descargar binario

# Scripts populares (copiar a ~/.config/mpv/scripts/):
# - thumbnail.lua      # miniaturas en la línea de tiempo
# - autosub.lua        # subtítulos automáticos con OpenSubtitles
# - uosc.lua           # interfaz moderna superpuesta
# - playlistmanager    # gestión de listas de reproducción
git clone https://github.com/dylanaraps/mpv-config ~/.config/mpv
```

### MPV vs VLC

| Característica | MPV | VLC |
|---|---|---|
| Interfaz gráfica | Mínima (OSD) | Completa (GUI) |
| Peso | ~5 MB | ~50 MB |
| Aceleración GPU | ✅ Vulkan/OpenGL/D3D11 | ⚠️ Parcial |
| Wayland | ✅ Nativo | ⚠️ Con XWayland |
| Configuración | Texto plano | GUI + avanzado |
| Streaming | ✅ (con yt-dlp) | ✅ (nativo) |
| Scripting | ✅ Lua | ⚠️ Lua (limitado) |
| Ideal para | Usuarios avanzados, tiling WMs | Usuarios generales |

---

## HandBrake

### Qué es

**HandBrake** es un conversor de video diseñado para **comprimir y convertir** archivos de video entre formatos. Tiene interfaz gráfica y CLI. Está enfocado en optimizar video para dispositivos específicos (Android, iPhone, Chromecast, etc.).

### Instalación

```bash
sudo apt install handbrake              # Debian/Ubuntu (GTK GUI)
sudo apt install handbrake-cli          # CLI
sudo pacman -S handbrake                # Arch (incluye GUI + CLI)
flatpak install flathub fr.handbrake.ghb
```

### Presets comunes

HandBrake incluye presets para:

| Preset | Uso |
|---|---|
| **Fast 1080p30** | Bueno para la mayoría de usos |
| **Very Fast 1080p30** | Cuando la velocidad importa más que la calidad |
| **Super HQ 1080p30 Surround** | Máxima calidad (lento) |
| **Chromecast 1080p30** | Para streaming a Chromecast |
| **Gmail** | Comprimir para adjuntar por correo |

### Uso CLI

```bash
# Convertir con preset
HandBrakeCLI -i entrada.mkv -o salida.mp4 --preset=\"Fast 1080p30\"

# Comprimir con control de calidad (RF = Rate Factor, 18-30)
HandBrakeCLI -i entrada.mkv -o salida.mp4 -e x264 -q 22

# Información del archivo
HandBrakeCLI -i entrada.mkv --scan

# Listar presets disponibles
HandBrakeCLI --preset-list
```

### HandBrake vs ffmpeg

| Característica | HandBrake | FFmpeg |
|---|---|---|
| Interfaz gráfica | ✅ | ❌ (solo CLI) |
| Presets para dispositivos | ✅ (muchos) | ❌ (hay que crear manualmente) |
| Velocidad | Similar | Similar |
| Control fino | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Ideal para | Conversión simple | Procesamiento avanzado/scripts |

---

## Instalación de codecs multimedia

Para reproducir formatos propietarios (MP3, H.264, AAC, MPEG-4), necesitas los codecs:

```bash
# Debian/Ubuntu
sudo apt install ubuntu-restricted-extras     # incluye: MP3, H.264, Flash, fonts
sudo apt install libavcodec-extra              # codecs adicionales de FFmpeg
sudo apt install libdvd-pkg                   # reproducción de DVDs comerciales
sudo dpkg-reconfigure libdvd-pkg              # configurar

# Arch
sudo pacman -S codecs                         # meta-paquete con codecs
# O individualmente:
sudo pacman -S x264 x265 libvpx libvorbis flac lame libfdk-aac

# Fedora (requiere RPM Fusion)
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf groupinstall multimedia              # todos los codecs multimedia
```

## Aceleración por hardware (VAAPI)

Para reproducción y transcodificación con uso mínimo de CPU:

```bash
# Verificar soporte VAAPI
sudo apt install vainfo
vainfo                                     # mostrar perfiles VAAPI soportados

# VAAPI en MPV (configuración automática con hwdec=auto-safe)
# VAAPI en ffmpeg:
ffmpeg -vaapi_device /dev/dri/renderD128 -i entrada.mp4 -vf 'format=nv12,hwupload' -c:v h264_vaapi salida.mp4

# Paquetes VAAPI
sudo apt install mesa-va-drivers           # Intel/AMD
sudo apt install nvidia-vaapi-driver       # NVIDIA (open source driver)
```

## Ver también

- [[ffmpeg]] — navaja suiza multimedia por CLI
- [[Audio en Linux]] — pila de audio (ALSA, PulseAudio, PipeWire)
- [[PipeWire]] — servidor multimedia moderno
- [[scrcpy]] — grabación de pantalla Android (usa ffmpeg internamente)
- [[Gestores de Paquetes]] — instalar codecs y reproductores

## Enlaces externos

- [Wikipedia — GStreamer](https://en.wikipedia.org/wiki/GStreamer)
- [Wikipedia — VLC media player](https://en.wikipedia.org/wiki/VLC_media_player)
- [Wikipedia — HandBrake](https://en.wikipedia.org/wiki/HandBrake)
- [Wikipedia — MPV (media player)](https://en.wikipedia.org/wiki/Mpv_(media_player))
- [Sitio oficial — GStreamer](https://gstreamer.freedesktop.org/)
- [Sitio oficial — VLC](https://www.videolan.org/vlc/)

#programa #multimedia
