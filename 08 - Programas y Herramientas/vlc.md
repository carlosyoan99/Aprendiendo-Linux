---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# VLC

## Qué es

**VLC** (VideoLAN Client) es el reproductor multimedia más popular en Linux. Reproduce prácticamente cualquier formato sin necesidad de codecs adicionales. También funciona como servidor de streaming y conversor de formatos.

## Instalación

```bash
sudo apt install vlc                   # Debian/Ubuntu
sudo pacman -S vlc                     # Arch
sudo dnf install vlc                   # Fedora (requiere RPM Fusion)
flatpak install flathub org.videolan.VLC
```

## Características destacadas

- Soporta todos los formatos (gracias a FFmpeg integrado)
- Streaming de red (UDP, HTTP, RTSP, HLS)
- Conversión de formatos (Media → Convert/Save)
- Captura de pantalla y grabación
- Efectos de audio y video (ecualizador, filtros)
- Plugins y extensiones (VLSub para subtítulos)
- Control por web (interfaz HTTP)
- Versión CLI: `cvlc` o `vlc -I ncurses`

## Comandos CLI útiles

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

## Atajos de teclado

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

## Ver también

- [[mpv]] — reproductor minimalista y ultrarrápido
- [[gstreamer]] — framework multimedia de GNOME
- [[handbrake]] — conversor de video con presets
- [[ffmpeg]] — navaja suiza multimedia por CLI

## Enlaces externos

- [Sitio oficial — VLC](https://www.videolan.org/vlc/)
- [Wikipedia — VLC media player](https://en.wikipedia.org/wiki/VLC_media_player)

#programa #multimedia
