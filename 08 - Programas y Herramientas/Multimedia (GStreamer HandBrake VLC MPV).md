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

## Notas individuales

Cada herramienta multimedia tiene ahora su propia nota:

- [[gstreamer]] — framework multimedia modular (backend de GNOME)
- [[vlc]] — reproductor universal con GUI completa
- [[mpv]] — reproductor minimalista y ultrarrápido
- [[handbrake]] — conversor de video con presets y GUI
- [[ffmpeg]] — navaja suiza multimedia por CLI (nota dedicada)

## Instalación de codecs multimedia

Para reproducir formatos propietarios (MP3, H.264, AAC, MPEG-4), necesitas los codecs:

```bash
# Debian/Ubuntu
sudo apt install ubuntu-restricted-extras
sudo apt install libavcodec-extra
sudo apt install libdvd-pkg
sudo dpkg-reconfigure libdvd-pkg

# Arch
sudo pacman -S codecs

# Fedora (requiere RPM Fusion)
sudo dnf groupinstall multimedia
```

## Aceleración por hardware (VAAPI)

```bash
# Verificar soporte VAAPI
sudo apt install vainfo
vainfo

# Paquetes VAAPI
sudo apt install mesa-va-drivers           # Intel/AMD
sudo apt install nvidia-vaapi-driver       # NVIDIA
```

## Ver también

- [[ffmpeg]] — navaja suiza multimedia por CLI
- [[Audio en Linux]] — pila de audio (ALSA, PulseAudio, PipeWire)
- [[PipeWire]] — servidor multimedia moderno
- [[Gestores de Paquetes]] — instalar codecs y reproductores

## Enlaces externos

- [Wikipedia — GStreamer](https://en.wikipedia.org/wiki/GStreamer)
- [Wikipedia — VLC media player](https://en.wikipedia.org/wiki/VLC_media_player)
- [Wikipedia — HandBrake](https://en.wikipedia.org/wiki/HandBrake)
- [Wikipedia — MPV (media player)](https://en.wikipedia.org/wiki/Mpv_(media_player))

#programa #multimedia
