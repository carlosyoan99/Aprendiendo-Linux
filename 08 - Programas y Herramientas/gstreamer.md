---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
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

## Elementos clave de un pipeline

| Tipo de elemento | Función | Ejemplos |
|---|---|---|
| **source** | Genera la señal de entrada | `filesrc`, `audiotestsrc`, `videotestsrc` |
| **filter** | Transforma/decodifica el flujo | `audioconvert`, `videoconvert`, `avdec_h264` |
| **sink** | Entrega la salida | `autoaudiosink`, `autovideosink`, `filesink` |

Los pipelines se escriben encadenando elementos con `!` y se pueden inspeccionar con `gst-inspect-1.0`.

## GStreamer vs FFmpeg vs mpv

| Aspecto | GStreamer | FFmpeg | mpv |
|---|---|---|---|
| Naturaleza | Framework/biblioteca | CLI/biblioteca | Reproductor |
| Pipelines | `gst-launch` | `ffmpeg` (filtros) | No |
| Integración GUI | Backend GNOME | Electrón | Interfaz propia |
| Caso de uso | Apps multimédia | Procesado por lotes | Reproducción |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `gst-launch` no encuentra el elemento | Falta el plugin | Instalar `gst-plugins-*` correspondiente |
| No reproduce MP3 en GNOME | Falta gst-plugins-ugly | `sudo apt install gstreamer1.0-plugins-ugly` |
| Pipeline corta en `negotiation failed` | Formato de entrada incompatible | Añadir `videoconvert`/`audioconvert` antes del sink |
| Sin video en Videos (Totem) | Falta `gst-libav` | Instalar `gstreamer1.0-libav` / `gst-libav` |

## Notas personales

- Como el backend de GNOME, instalar los `gst-plugins-*` adecuados resuelve la mayoría de codecs que faltan en Totem.
- Para pipelines de un solo uso prefiero [[ffmpeg]]; GStreamer lo reservo para entender la arquitectura de apps GNOME.

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
