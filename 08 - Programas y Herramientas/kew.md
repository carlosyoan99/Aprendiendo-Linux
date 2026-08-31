---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# kew

> Reproductor de música TUI minimalista para terminal, con soporte MPRIS. Es el reproductor principal en mi sistema y se integra con el widget de medios de Noctalia.

## Instalación

```bash
sudo pacman -S kew          # Arch / CachyOS
```

## Sintaxis

```bash
kew                              # abre la biblioteca en TUI
kew <directorio>                 # reproducir una carpeta
kew all --noui shuffle           # aleatorio de toda la biblioteca, sin UI
kew all --noui                   # seguir lista, sin UI
```

> **Gotcha**: `kew --noui play <dir>` falla sin una TTY real ("Music not found"). Para reproducir en segundo plano usa `kew all --noui shuffle`, que toma la ruta de la biblioteca del `kewrc`.

## Atajos de teclado

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

## Integración con Noctalia

- **MPRIS**: los controles de medios de Noctalia (barra/widget multimedia) controlan kew.
- **Colores**: por defecto sigue `$TERM`; se unifican con la paleta de Noctalia vía `~/.config/kew/gen-noctalia.sh` (genera `themes/noctalia.theme` desde el tema de Alacritty de Noctalia, vigilado por una unidad systemd de usuario `noctalia-kew.path`).
- **Autostart** en niri (`cfg/autostart.kdl`): `spawn-sh-at-startup "sleep 6 && kew all --noui shuffle"` (retraso de 6s evita carga al arrancar).

## Ver también

- [[Cava]] — visualizador de audio
- [[Alacritty]] — terminal donde corre
- [[Desktop Shells (Noctalia Caelestia)]] — integración MPRIS

## Enlaces externos

- [GitHub — kew](https://github.com/ravachol/kew)
- [Arch Wiki — Kew](https://wiki.archlinux.org/title/Kew)

#programa #tui #musica #mpris