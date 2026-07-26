---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# Alacritty

Terminal acelerada por GPU, configurada enteramente en un archivo TOML. Muy popular en setups con [[i3]], [[Hyprland]], [[Niri]] y otros WMs tiling por su rendimiento y simplicidad.

## Instalación

```bash
sudo pacman -S alacritty     # Arch
sudo apt install alacritty   # Debian/Ubuntu (puede ser versión vieja)
sudo dnf install alacritty   # Fedora
```

## Configuración

Archivo de configuración: `~/.config/alacritty/alacritty.toml`

```toml
# Tamaño de fuente
[font]
size = 12.0

# Opacidad/transparencia
[window]
opacity = 0.9

# Esquema de colores
[colors]
primary = { background = "#1e1e2e", foreground = "#cdd6f4" }
```

## Ventajas

- Renderizado por GPU (muy rápido, sin parpadeo)
- Config limpia y versionable en TOML
- Cross-platform (Linux, macOS, Windows)

## Desventajas

- No tiene pestañas nativas (se puede emular con [[tmux]] o multiplexor)
- Sin splits nativos

## Ver también

- [[Kitty]] — alternativa con pestañas
- [[Foot]] — terminal Wayland nativa ultra-ligera
- [[Emuladores de Terminal]] — índice + comparativa
- [[La Shell]]
- [[tmux]]

## Enlaces externos

- [GitHub — Alacritty](https://github.com/alacritty/alacritty)
- [Sitio oficial](https://alacritty.org)

#programa #terminal
