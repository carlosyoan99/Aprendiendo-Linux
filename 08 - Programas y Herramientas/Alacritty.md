---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: media
---

# Alacritty

Terminal acelerada por GPU, configurada enteramente en un archivo TOML. Muy popular en setups con [[i3]], [[Hyprland]], [[Niri]] y otros WMs tiling por su rendimiento y simplicidad.

## Qué es

- Emulador de terminal escrito en **Rust** que usa la GPU (OpenGL) para renderizar el texto, logrando un arranque y desplazamiento muy rápidos sin parpadeo.
- Tiene una filosofía minimalista: **una simple ventana, sin pestañas ni splits** (decoran eso a multiplexores como [[tmux]]).
- La configuración es un único archivo TOML, sencillo de versionar en Git (dotfiles).

## Instalación

```bash
sudo pacman -S alacritty     # Arch
sudo apt install alacritty   # Debian/Ubuntu (puede ser versión vieja)
sudo dnf install alacritty   # Fedora
flatpak install flathub org.alacritty.Alacritty
cargo install cargo-binstall && cargo binstall alacritty  # desde fuente/Rust
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

## Comandos / atajos

| Atajo | Acción |
|---|---|
| `Ctrl+Shift+V` | Pegar |
| `Ctrl+Shift+C` | Copiar |
| `Ctrl+=` / `Ctrl+-` | Aumentar/disminuir fuente |
| `Ctrl+0` | Restablecer tamaño de fuente |

```bash
alacritty                     # lanzar
alacritty --class nombre      # para reglas de WM (window rules)
alacritty -e fish             # ejecutar un shell concreto
```

## Ventajas

- Renderizado por GPU (muy rápido, sin parpadeo)
- Config limpia y versionable en TOML
- Cross-platform (Linux, macOS, Windows)

## Desventajas

- No tiene pestañas nativas (se puede emular con [[tmux]] o multiplexor)
- Sin splits nativos

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Fuente borrosa | Falta hinting/DOCn o DPI | Ajustar `font.size` y `window.opacity` a 1.0 |
| No inicia con render OpenGL | GPU/driver | `alacritty --gpu` debug, actualizar driver |
| No puede abrir `.toml` de config | Formato de versiones previas | Migrar de `alacritty.yml` a `.toml` |

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
