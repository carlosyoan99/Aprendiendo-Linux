---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# yt-dlp

> Fork activo de youtube-dl para descargar vídeos y audio de YouTube y 1000+ sitios. Más rápido, más compatible y mejor mantenido que el original.

## Qué es

**yt-dlp** es el fork activo de youtube-dl (el original está en pausa). Descarga vídeos y audio de YouTube, Vimeo, Twitter, TikTok, Twitch, y 1000+ sitios. Soporta calidad máxima, subtítulos, playlists, y formatos múltiples.

**Ventajas sobre youtube-dl:**
- Actualizaciones frecuentes (nuevos sitios constantemente)
- Más rápido (paralelización)
- Soporte de formatos modernos (WebM, VP9, AV1)
- Mejor manejo de playlists y canales
- Opciones de output personalizables

## Instalación

```bash
# Arch / CachyOS
sudo pacman -S yt-dlp

# pip (cualquier distro)
pip install yt-dlp

# Actualización automática (recomendado)
yt-dlp -U
```

## Uso básico

```bash
# Descargar vídeo (mejor calidad)
yt-dlp "https://www.youtube.com/watch?v=VIDEO_ID"

# Descargar solo audio (MP3)
yt-dlp -x --audio-format mp3 "URL"

# Descargar playlist completa
yt-dlp "https://www.youtube.com/playlist?list=PLAYLIST_ID"

# Elegir calidad
yt-dlp -f "bestvideo[height<=720]+bestaudio" "URL"

# Ver formatos disponibles
yt-dlp -F "URL"
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `-f <formato>` | Elegir formato (ver `-F` para opciones) |
| `-x` | Extraer solo audio |
| `--audio-format mp3` | Formato de audio (mp3, flac, wav, aac) |
| `--audio-quality 0` | Calidad de audio (0=mejor, 10=peor) |
| `-o <template>` | Nombre de archivo personalizado |
| `--playlist-items 1-5` | Descargar solo items 1-5 de playlist |
| `--write-subs` | Descargar subtítulos |
| `--embed-subs` | Incrustar subtítulos en el vídeo |
| `--list-subs` | Listar subtítulos disponibles |
| `-F` | Listar formatos disponibles |
| `-U` | Actualizar yt-dlp |

## Templates de nombre de archivo

```bash
# Nombre personalizado
yt-dlp -o "%(title)s.%(ext)s" "URL"

# Con autor
yt-dlp -o "%(uploader)s - %(title)s.%(ext)s" "URL"

# En carpeta por autor
yt-dlp -o "%(uploader)s/%(title)s.%(ext)s" "URL"
```

## Ejemplos prácticos

```bash
# Descargar en 720p
yt-dlp -f "bestvideo[height<=720]+bestaudio" "URL"

# Descargar playlist completa como MP3
yt-dlp -x --audio-format mp3 "PLAYLIST_URL"

# Descargar subtítulos en español
yt-dlp --write-subs --sub-lang es "URL"

# Descargar solo los primeros 3 vídeos de una playlist
yt-dlp --playlist-items 1-3 "PLAYLIST_URL"

# Buscar en YouTube
yt-dlp "ytsearch5:linux tutorial"   # 5 resultados
```

## Comparativa con alternativas

| Aspecto | yt-dlp | youtube-dl | you-get | tubeup |
|---|---|---|---|---|
| **Mantenimiento** | ✅ Activo | ❌ Pausado | ⚠️ Poco activo | ✅ |
| **Velocidad** | ⚡ Rápido | 🐌 Lento | ⚡ | ⚡ |
| **Sitios soportados** | 1000+ | 900+ | ~100 | 1000+ |
| **Playlists** | ✅ | ✅ | ✅ | ✅ |
| **Subtítulos** | ✅ | ✅ | ✅ | ❌ |

## Ver também

- [[ffmpeg]] — conversión de vídeo/audio
- `gallery-dl` — descargar imágenes de galerías
- [[Multimedia (GStreamer HandBrake VLC MPV)]] — multimedia

## Enlaces externos

- [GitHub — yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [Documentación](https://github.com/yt-dlp/yt-dlp#readme)
- [Sitio oficial](https://yt-dlp.org/)
- [Arch Wiki — yt-dlp](https://wiki.archlinux.org/title/Yt-dlp)

#programa #multimedia #descargas
