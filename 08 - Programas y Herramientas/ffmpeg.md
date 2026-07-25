---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: programa
prioridad: media
---

# ffmpeg

## Qué es

ffmpeg es la navaja suiza del audio y video desde terminal. Convierte entre formatos, graba pantalla, extrae audio, comprime, corta, combina streams y mucho más. Es el motor por debajo de prácticamente todos los reproductores y editores multimedia de Linux (VLC, OBS, Kdenlive, etc.).

## Instalación

```bash
# Debian/Ubuntu
sudo apt install ffmpeg

# Arch
sudo pacman -S ffmpeg

# Fedora (requiere RPM Fusion primero)
sudo dnf install ffmpeg
```

## Comandos básicos

```bash
# Info de un archivo
ffmpeg -i video.mp4                       # ver metadatos, codecs, duración
ffprobe video.mp4                         # info detallada (solo metadata)

# Conversión de formatos
ffmpeg -i video.avi video.mp4             # convertir de AVI a MP4
ffmpeg -i audio.flac audio.mp3            # convertir FLAC a MP3
ffmpeg -i entrada.mkv -c copy salida.mp4  # copiar streams sin recodificar (rápido)

# Extraer audio de un video
ffmpeg -i video.mp4 -q:a 0 -map a audio.mp3   # extraer audio en MP3 calidad máxima
ffmpeg -i video.mp4 -vn audio.wav              # extraer audio en WAV (sin video)

# Redimensionar y comprimir
ffmpeg -i video.mp4 -vf "scale=1280:720" -crf 28 pequeño.mp4  # reducir a 720p, comprimir
ffmpeg -i video.mp4 -vf "scale=-1:720" salida.mp4    # escalar manteniendo aspecto

# Cortar sin recodificar
ffmpeg -i video.mp4 -ss 00:01:30 -t 00:00:30 -c copy clip.mp4   # cortar 30s desde 1:30

# Grabar pantalla
ffmpeg -f x11grab -r 30 -s 1920x1080 -i :0.0 -c:v libx264 output.mp4     # grabar pantalla X11
ffmpeg -f pipewire -i default -f v4l2 -i /dev/video0 output.mp4           # grabar con audio (Wayland)

# Unir varios videos
ffmpeg -f concat -i lista.txt -c copy unido.mp4
# lista.txt contiene:
# file 'parte1.mp4'
# file 'parte2.mp4'
```

## Tabla rápida de formatos

| Formato | Codecs comunes | Uso típico |
|---|---|---|
| `.mp4` | H.264 + AAC | Universal, compatible con todo |
| `.mkv` | Cualquiera | Contenedor flexible, subtítulos incluidos |
| `.webm` | VP9 + Opus | Web, navegadores |
| `.avi` | Sin comprimir o MJPEG | Legacy, muy grande |
| `.flac` | FLAC | Audio sin pérdida |
| `.mp3` | MP3 | Audio comprimido universal |

## Tips comunes

| Operación | Comando |
|---|---|
| Quitar audio | `ffmpeg -i video.mp4 -an salida.mp4` |
| Agregar audio a un video sin sonido | `ffmpeg -i video.mp4 -i audio.mp3 -c:v copy -c:a aac salida.mp4` |
| Crear GIF desde video | `ffmpeg -i video.mp4 -vf "fps=10,scale=640:-1" salida.gif` |
| Acelerar video (2x) | `ffmpeg -i video.mp4 -filter:v "setpts=0.5*PTS" salida.mp4` |
| Estabilizar video | `ffmpeg -i in.mp4 -vf vidstabdetect -f null -` (1er paso) |

## Notas y advertencias

- `-c copy` copia los streams sin recodificar. Es instantáneo pero no permite cambiar formato ni resolución. Úsalo para cortar o cambiar de contenedor (ej. MKV → MP4) sin pérdida de calidad.
- `-crf 23` es el valor por defecto en H.264. Menor = mejor calidad/archivo más grande (18 es casi sin pérdida, 28 es compacto aceptable, 35 es muy comprimido).
- ffmpeg tiene una sintaxis muy específica: el orden de los flags importa (primero inputs, luego outputs).
- OBS y muchas apps gráficas usan ffmpeg por debajo. Aprender la CLI te da control total.

## Alternativas

| Herramienta | Diferencias con ffmpeg |
|---|---|
| **GStreamer** | Framework multimedia más modular, usado por GNOME como backend. Curva más alta |
| **HandBrake** | GUI para convertir videos entre formatos. Usa ffmpeg por debajo |
| **OBS Studio** | Grabación y streaming en vivo, con GUI. No es un conversor de archivos |
| **VLC** | Reproductor que también convierte (Media → Convert/Save). Interfaz simple |

## Ver también

- [[Gestores de Paquetes]]
- [[Emuladores de Terminal]]
- [[scrcpy]] — usa ffmpeg internamente para codificación
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — FFmpeg](https://en.wikipedia.org/wiki/FFmpeg)
- [Sitio oficial — FFmpeg](https://ffmpeg.org/)
- [GitHub — FFmpeg/FFmpeg](https://github.com/FFmpeg/FFmpeg)

#programa
