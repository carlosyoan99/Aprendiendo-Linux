---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: media
---

# Foot

Terminal **Wayland-nativa** y extremadamente ligera. Corre directamente sobre Wayland sin pasar por XWayland, ideal para compositores Wayland como [[Niri]], [[Hyprland]], [[Sway]] y [[River]].

Es la terminal por defecto de algunos entornos Wayland-puros y muy popular en setups minimalistas.

## Qué es

- Emulador de terminal escrito en C que usa **Wayland puro** (protocolo nativo) — no depende de X11 ni de XWayland, por lo que arranca en milisegundos y consume muy poca RAM (~8 MB).
- Pensado para sesiones de escritorio Wayland modernas (niri, hyprland, sway, river, wayfire) donde se valora la ligereza y la fidelidad al protocolo.
- Soporta True Color, emoji, texto vertical y clipboard sincronizado (primary selection).

## Instalación

```bash
sudo pacman -S foot         # Arch (nativo)
sudo apt install foot       # Debian/Ubuntu
sudo dnf install foot       # Fedora
# Compilar desde fuente: meson setup build && ninja -C build
```

## Configuración

Archivo de configuración: `~/.config/foot/foot.ini`

```ini
[main]
font=monospace:size=10
dpi-aware=yes

[colors]
background=1e1e2e
foreground=cdd6f4
```

## Comandos / uso

```bash
foot                      # lanzar terminal
foot -e fish              # ejecutar comando/shell al iniciar
foot --server             # modo servidor (más rápido al lanzar varias)
foot -W 80x24             # tamaño inicial en columnas x filas
```

También sirve como **terminal de drop-down/overlay** en compositores (leagueofoverlays, etc.) lanzándose con un atajo y feet del WM.

## Ventajas

- **Ultra-ligero**: ~8 MB RAM
- Sin dependencias X11 (no necesita XWayland)
- Arranque instantáneo
- Soporta True Color, emoji y clipboard sincronizado

## Desventajas

- **Solo corre en Wayland** (no funciona en X11)
- No tiene pestañas nativas
- Config menos flexible que Alacritty o Kitty

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No abre en sesión X11 | Requiere Wayland | Usar otra terminal en X11, Foot es solo Wayland |
| Fuente pixelada | DPI no detectado | `dpi-aware=yes` y tamaño correcto |
| Desplazamiento congelado | server mode y font still | Reiniciar `foot --server` |

## Ver también

- [[Alacritty]] — terminal GPU cross-platform
- [[Kitty]] — terminal GPU con pestañas
- [[Emuladores de Terminal]] — índice + comparativa
- [[Wayland vs X11]]

## Enlaces externos

- [Sitio oficial](https://codeberg.org/dnkl/foot)
- [Documentación](https://codeberg.org/dnkl/foot/src/branch/master/doc/foot.ini.5)

#programa #terminal
