---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# kew

> Reproductor de música TUI minimalista para terminal, con soporte MPRIS. Es el reproductor principal en mi sistema y se integra con el widget de medios de Noctalia.

## Qué es

**kew** es un reproductor de música de línea de comandos escrito en C, diseñado para ser rápido y minimalista. Muestra la carátula del álbum en la terminal (si la terminal lo soporta) y controles básicos de reproducción. Soporta MPRIS2, lo que permite controlarlo desde widgets multimedia de DE/WM.

## Instalación

```bash
sudo pacman -S kew                # Arch / CachyOS
sudo apt install kew              # Debian / Ubuntu (ppa o snap)
sudo dnf install kew              # Fedora
# desde source (ultima version):
git clone https://github.com/ravachol/kew.git
cd kew && make && sudo make install
```

## Sintaxis

```bash
kew                              # abre la biblioteca en TUI
kew <directorio>                 # reproducir una carpeta
kew all --noui shuffle           # aleatorio de toda la biblioteca, sin UI
kew all --noui                   # seguir lista, sin UI
kew play <cancion>               # reproducir cancion especifica
kew pause                        # pausar
kew next                         # siguiente cancion
kew previous                     # cancion anterior
kew seek <segundos>              # adelantar/retroceder
kew volume <0-100>               # ajustar volumen
```

> **Gotcha**: `kew --noui play <dir>` falla sin una TTY real ("Music not found"). Para reproducir en segundo plano usa `kew all --noui shuffle`, que toma la ruta de la biblioteca del `kewrc`.

## Atajos de teclado (TUI)

| Tecla | Acción |
|---|---|
| `Espacio` | Pausar/reanudar |
| `n` / `p` | Siguiente / anterior |
| `q` | Salir del UI (sigue sonando con `--noui`) |
| `s` | Detener |
| `m` | Silenciar |
| `=` / `-` | Volumen |
| `b` | Biblioteca |
| `f` | Archivos de la pista |

## Configuración

Archivos: `~/.config/kew/kewrc` (principal, define la ruta de la biblioteca) y `kewstaterc` (estado: último volumen, DWIM).

```bash
# kewrc basico
music_path=/home/user/Music
```

Soporta formatos: MP3, FLAC, OGG, WAV, AAC, M4A.

## Integración con Noctalia

- **MPRIS**: los controles de medios de Noctalia (barra/widget multimedia) controlan kew.
- **Colores**: por defecto sigue `$TERM`; se unifican con la paleta de Noctalia vía `~/.config/kew/gen-noctalia.sh` (genera `themes/noctalia.theme` desde el tema de Alacritty de Noctalia, vigilado por una unidad systemd de usuario `noctalia-kew.path`).
- **Autostart** en niri (`cfg/autostart.kdl`): `spawn-sh-at-startup "sleep 6 && kew all --noui shuffle"` (retraso de 6s evita carga al arrancar).

## Uso avanzado

```bash
# Reproducir en segundo plano con notificacion
kew all --noui shuffle &
disown

# Buscar cancion por nombre
kew list | grep "nombre"

# Ver informacion de la cancion actual
kew status
```

## kew vs cmus vs ncmpcpp vs mpd

| Aspecto | kew | cmus | ncmpcpp | mpd+client |
|---|---|---|---|---|
| Backend | ffmpeg propio | ffmpeg/libav | mpd | mpd |
| Carátula en terminal | Sí (blocks) | Sí (w3m) | Sí (w3m) | Depende del cliente |
| Configuración | `kewrc` | `~/.config/cmus/` | `~/.config/mpd/` | `~/.config/mpd/` |
| Complejidad | Baja | Media | Alta | Alta |
| MPRIS | Sí | Sí (plugin) | Sí | Sí (mpd) |
| Ideal | Uso diario simple | Colecciones grandes | Power users | Configuración total |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| "Music not found" con `--noui play` | Falta TTY real | Usar `kew all --noui shuffle` |
| No muestra carátula | Terminal no soporta blocks | Usar terminales compatibles (kitty, alacritty, wezterm) |
| MPRIS no responde | Servicio D-Bus no activo | Verificar con `busctl --user list` y reiniciar sesión |
| Falla al reproducir FLAC | Codec no instalado | Instalar `ffmpeg` o `libFLAC` |

## Comparativa con alternativas

| Aspecto | kew | cmus | ncmpcpp | mpc + MPD | nushell + yt-dlp |
|---|---|---|---|---|---|
| **Interfaz** | TUI con carátula | TUI completa | TUI con playlist | CLI simple | CLI |
| **MPRIS** | ✅ Nativo | ⚠️ Con plugin | ⚠️ Con MPD | ✅ Via MPD | ❌ |
| **Formatos** | FLAC, MP3, OGG, M4A, WAV | Todo (via FFmpeg) | Todo (via MPD) | Todo (via MPD) | ❌ |
| **Playlist** | ✅ Archivos/directorio | ✅ Completa | ✅ Avanzada | ✅ Via MPD | ❌ |
| **Filtros** | ❌ | ✅ | ✅ | ✅ | ❌ |
| **Dependencias** | Pocas (libavcodec) | FFmpeg | MPD corriendo | MPD corriendo | FFmpeg |
| **Ideal para** | Escuchar música rápido en terminal | Colecciones grandes, fans de terminal | Control avanzado de MPD | Múltiples clientes MPD | Scripts rápidos |

## Ver también

- [[Cava]] — visualizador de audio
- [[Alacritty]] — terminal donde corre
- [[Desktop Shells (Noctalia Caelestia)]] — integración MPRIS

## Enlaces externos

- [GitHub — kew](https://github.com/ravachol/kew)
- [Arch Wiki — Kew](https://wiki.archlinux.org/title/Kew)

#programa #tui #musica #mpris
