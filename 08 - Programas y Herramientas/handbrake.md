---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL v2
alternativas: FFmpeg, VLC, MakeMKV
---

# HandBrake

> Conversor de video **open source** diseñado para comprimir y convertir archivos entre formatos. Tiene interfaz gráfica y CLI. Optimiza video para dispositivos específicos (Android, iPhone, Chromecast, Apple TV, etc.) con presets predefinidos.

## Qué es

HandBrake es un transcodificador de video que toma archivos de entrada (casi cualquier formato) y los convierte a H.264, H.265/HEVC o VP9 optimizados. Su interfaz gráfica muestra una vista previa en tiempo real, y su CLI (`HandBrakeCLI`) permite automatizar lotes de conversión. Es la herramienta ideal para comprimir vídeos de cámara sin perder calidad percibida.

- **Códecs de salida**: H.264 (x264), H.265 (x265), VP9
- **Contenedores**: MP4, MKV, WebM
- **Entrada**: casi cualquier formato (MKV, AVI, MP4, TS, DVD, Blu-ray)
- **Plataforma**: Linux, Windows, macOS

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install handbrake` (GUI) · `sudo apt install handbrake-cli` (CLI) |
| Arch | `sudo pacman -S handbrake` |
| Fedora | `sudo dnf install handbrake` |
| openSUSE | `sudo zypper install handbrake` |
| Flatpak | `flatpak install flathub fr.handbrake.ghb` |
| Snap | `snap install handbrake` |
| macOS | `brew install --cask handbrake` |

## Presets comunes

| Preset | Uso |
|---|---|
| **Fast 1080p30** | Bueno para la mayoría de usos |
| **Very Fast 1080p30** | Cuando la velocidad importa más que la calidad |
| **Super HQ 1080p30 Surround** | Máxima calidad (lento) |
| **Chromecast 1080p30** | Para streaming a Chromecast |
| **Gmail** | Comprimir para adjuntar por correo |
| **Discord Nitro** | Para subir a Discord (límite 500 MB) |
| **Android 1080p30** | Para reproducción en Android |
| **Apple 1080p30 Surround** | Para Apple TV/iOS |

## Uso CLI

```bash
# Convertir con preset
HandBrakeCLI -i entrada.mkv -o salida.mp4 --preset="Fast 1080p30"

# Comprimir con control de calidad (RF = Rate Factor, 18-30)
HandBrakeCLI -i entrada.mkv -o salida.mp4 -e x264 -q 22

# Información del archivo
HandBrakeCLI -i entrada.mkv --scan

# Listar presets disponibles
HandBrakeCLI --preset-list

# Comprimir con límite de tamaño (2-pass ABR)
HandBrakeCLI -i entrada.mkv -o salida.mp4 -b 2000 --two-pass

# Cambiar códec
HandBrakeCLI -i entrada.mkv -o salida.mp4 -e x265 -q 28

# Extraer solo audio
HandBrakeCLI -i entrada.mkv -o salida.m4a -E av_aac -B 160

# Cortar video (recorte temporal)
HandBrakeCLI -i entrada.mkv -o salida.mp4 --start-at 00:01:30 --stop-at 00:10:00

# Subtítulos embebidos
HandBrakeCLI -i entrada.mkv -o salida.mp4 --subtitle-lang spa --srt-correct

# Lote: comprimir todos los .mkv de una carpeta
for f in *.mkv; do
  HandBrakeCLI -i "$f" -o "${f%.mkv}.mp4" --preset="Fast 1080p30"
done
```

## Configuración avanzada

### Rate Factor (RF) — calidad vs tamaño

| RF | Calidad | Tamaño relativo |
|---|---|---|
| 18 | Excelente (casi lossless) | Muy grande |
| 20 | Muy buena | Grande |
| 22 | Buena (por defecto en muchos presets) | Moderado |
| 25 | Aceptable | Pequeño |
| 28 | Calidad baja | Muy pequeño |
| 30+ | Visible degradación | Extremadamente pequeño |

### Códecs comparados

| Códec | Velocidad | Compresión | Uso ideal |
|---|---|---|---|
| **x264** | Rápido | Buena | Compatibilidad universal |
| **x265/HEVC** | Lento | Excelente | Archivos grandes, 4K |
| **VP9** | Muy lento | Excelente | YouTube, Web |
| **AV1** | Extremadamente lento | Mejor | Futuro, YouTube |

## HandBrake vs FFmpeg

| Característica | HandBrake | FFmpeg |
|---|---|---|
| Interfaz gráfica | ✅ | ❌ (solo CLI) |
| Presets para dispositivos | ✅ (muchos) | ❌ (hay que crear manualmente) |
| Velocidad | Similar | Similar |
| Control fino | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Automatización lotes | CLI básico | Expresiones, scripts completos |
| Ideal para | Conversión simple | Procesamiento avanzado/scripts |

> **Regla práctica**: usa HandBrake para comprimir un vídeo rápido con la GUI; usa FFmpeg cuando necesites automatizar, encadenar filtros o procesar miles de archivos.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `HandBrakeCLI: command not found` | Solo instalada la GUI | Instalar `handbrake-cli` (paquete separado en Debian/Ubuntu) |
| Salida borrosa o pixelada | RF demasiado alto | Bajar RF a 20-22 (menor = mejor calidad) |
| Conversión muy lenta | x265 en CPU sin aceleración | Usar `-e x264` o habilitar QSV/VCE/NVENC |
| No detecta subtítulos | Subtítulos en formato externo | Embeber con `--srt-file sub.srt` |
| Error "NoNVNC" o GPU no encontrada | HandBrake no detecta aceleración GPU | Verificar drivers VAAPI/NVENC instalados |
| Salida con audio desincronizado | Problema con el contenedor | Cambiar a MKV o usar `--cfr` (framerate constante) |
| Archivo de entrada dañado/ilegible | Formato no soportado o corrupto | Verificar con `ffmpeg -i archivo` si el archivo es válido |

## Ver también

- [[vlc]] — reproductor multimedia con GUI completa
- [[mpv]] — reproductor minimalista y ultrarrápido
- [[gstreamer]] — framework multimedia de GNOME
- [[ffmpeg]] — navaja suiza multimedia por CLI

## Enlaces externos

- [Sitio oficial — HandBrake](https://handbrake.fr/)
- [Wikipedia — HandBrake](https://en.wikipedia.org/wiki/HandBrake)
- [GitHub — HandBrake](https://github.com/HandBrake/HandBrake)
- [Arch Wiki — HandBrake](https://wiki.archlinux.org/title/HandBrake)

#programa #multimedia
