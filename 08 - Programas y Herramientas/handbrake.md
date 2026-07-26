---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# HandBrake

## Qué es

**HandBrake** es un conversor de video diseñado para **comprimir y convertir** archivos de video entre formatos. Tiene interfaz gráfica y CLI. Está enfocado en optimizar video para dispositivos específicos (Android, iPhone, Chromecast, etc.).

## Instalación

```bash
sudo apt install handbrake              # Debian/Ubuntu (GTK GUI)
sudo apt install handbrake-cli          # CLI
sudo pacman -S handbrake                # Arch (incluye GUI + CLI)
flatpak install flathub fr.handbrake.ghb
```

## Presets comunes

| Preset | Uso |
|---|---|
| **Fast 1080p30** | Bueno para la mayoría de usos |
| **Very Fast 1080p30** | Cuando la velocidad importa más que la calidad |
| **Super HQ 1080p30 Surround** | Máxima calidad (lento) |
| **Chromecast 1080p30** | Para streaming a Chromecast |
| **Gmail** | Comprimir para adjuntar por correo |

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
```

## HandBrake vs ffmpeg

| Característica | HandBrake | FFmpeg |
|---|---|---|
| Interfaz gráfica | ✅ | ❌ (solo CLI) |
| Presets para dispositivos | ✅ (muchos) | ❌ (hay que crear manualmente) |
| Velocidad | Similar | Similar |
| Control fino | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Ideal para | Conversión simple | Procesamiento avanzado/scripts |

## Ver también

- [[vlc]] — reproductor multimedia con GUI completa
- [[mpv]] — reproductor minimalista y ultrarrápido
- [[gstreamer]] — framework multimedia de GNOME
- [[ffmpeg]] — navaja suiza multimedia por CLI

## Enlaces externos

- [Wikipedia — HandBrake](https://en.wikipedia.org/wiki/HandBrake)

#programa #multimedia
