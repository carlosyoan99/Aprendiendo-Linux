---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# MPV

## Qué es

**MPV** es un reproductor de video minimalista y ultrarrápido, fork de MPlayer y mplayer2. Diseñado para ser usado desde terminal, con controles por teclado y sin interfaz gráfica pesada. Es el favorito de los usuarios avanzados y de gestores de ventanas tiling.

## Instalación

```bash
sudo apt install mpv                    # Debian/Ubuntu
sudo pacman -S mpv                      # Arch
sudo dnf install mpv                    # Fedora
```

## Características

- **Integración con Wayland nativa** (mejor rendimiento que VLC en Wayland)
- **GPU acceleration** (Vulkan, OpenGL)
- **Scripting en Lua** (scripts para YouTube, subtítulos automáticos, etc.)
- **Configuración vía archivo de texto plano** (`~/.config/mpv/mpv.conf`)
- **Latencia mínima** (ideal para reproducción local)
- **Control por teclado sin GUI** (ideal en tiling WMs)

## Comandos básicos

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
# , / .      → fotograma anterior/siguiente
# l          → cargar subtítulos
# v          → alternar subtítulos
# j / J      → ciclar pistas de audio
# #          → mostrar/oscurar OSD
# s / S      → captura de pantalla
```

## Configuración (`mpv.conf`)

```bash
# ~/.config/mpv/mpv.conf
profile=gpu-hq                          # perfil de alta calidad
hwdec=auto-safe                        # aceleración por hardware
volume=50                               # volumen inicial
save-position-on-quit=yes               # guardar posición al salir
ytdl=yes                                # integración con yt-dlp
ytdl-format=bestvideo[height<=?1080]+bestaudio/best
keep-open=yes                           # mantener ventana abierta al terminar
osd-bar=yes                             # barra de progreso OSD
border=no                               # sin bordes
```

## Scripts esenciales

```bash
# Instalar yt-dlp (necesario para YouTube y otros sitios)
sudo apt install yt-dlp

# Scripts populares (copiar a ~/.config/mpv/scripts/):
# - uosc.lua           # interfaz moderna superpuesta
# - playlistmanager    # gestión de listas de reproducción
git clone https://github.com/dylanaraps/mpv-config ~/.config/mpv
```

## MPV vs VLC

| Característica | MPV | VLC |
|---|---|---|
| Interfaz gráfica | Mínima (OSD) | Completa (GUI) |
| Peso | ~5 MB | ~50 MB |
| Aceleración GPU | ✅ Vulkan/OpenGL | ⚠️ Parcial |
| Wayland | ✅ Nativo | ⚠️ Con XWayland |
| Configuración | Texto plano | GUI + avanzado |
| Streaming | ✅ (con yt-dlp) | ✅ (nativo) |
| Scripting | ✅ Lua | ⚠️ Lua (limitado) |
| Ideal para | Usuarios avanzados, tiling WMs | Usuarios generales |

## Ver también

- [[vlc]] — reproductor con GUI completa
- [[gstreamer]] — framework multimedia de GNOME
- [[handbrake]] — conversor de video con presets
- [[ffmpeg]] — navaja suiza multimedia por CLI

## Enlaces externos

- [Wikipedia — MPV (media player)](https://en.wikipedia.org/wiki/Mpv_(media_player))

#programa #multimedia
