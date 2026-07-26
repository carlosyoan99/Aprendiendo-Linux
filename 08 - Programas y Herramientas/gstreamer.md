---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# GStreamer

## Qué es

**GStreamer** es un framework multimedia modular. Es el backend multimedia de GNOME (Videos, Rhythmbox, Sound Juicer) y de muchas apps de escritorio. Está compuesto por **elementos** (source, filter, sink) que se encadenan en pipelines, similar a los pipes de Unix.

```
Pipeline básico: source (archivo) → decoder → convert → sink (altavoz)
```

## Instalación

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

## Comandos básicos

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

## Uso en GNOME

GStreamer es el backend de todas las apps multimedia de GNOME: Videos (Totem), Music, Sound Recorder, Cheese (cámara web).

## Ver también

- [[vlc]] — reproductor multimedia con GUI completa
- [[mpv]] — reproductor minimalista y ultrarrápido
- [[handbrake]] — conversor de video con presets
- [[ffmpeg]] — navaja suiza multimedia por CLI
- [[Audio en Linux]] — pila de audio (ALSA, PulseAudio, PipeWire)
- [[PipeWire]] — servidor multimedia moderno

## Enlaces externos

- [Sitio oficial — GStreamer](https://gstreamer.freedesktop.org/)
- [Wikipedia — GStreamer](https://en.wikipedia.org/wiki/GStreamer)

#programa #multimedia
