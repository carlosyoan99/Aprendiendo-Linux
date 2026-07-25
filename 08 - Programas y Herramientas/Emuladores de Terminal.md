---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: programa
prioridad: media
---

# Emuladores de Terminal

## Qué es

El emulador de terminal es la **ventana** donde se ejecuta tu shell. Cada DE trae uno por defecto, pero hay muchas alternativas, especialmente en setups con WMs minimalistas donde hay que elegir uno manualmente.

Ver [[La Shell]] para entender la diferencia entre emulador de terminal y shell.

## Por DE (los que vienen por defecto)

| Terminal | DE asociado | Paquete | Consumo RAM |
|---|---|---|---|
| GNOME Terminal | [[GNOME]] | `gnome-terminal` | ~25 MB |
| Konsole | [[KDE Plasma]] | `konsole` | ~30 MB |
| Xfce Terminal | [[XFCE]] | `xfce4-terminal` | ~15 MB |
| Nemo Terminal | [[Cinnamon]] | `nemo-terminal` | ~20 MB |
| Foot | Wayland nativo | `foot` | ~8 MB |

```bash
# Instalar terminal de otro DE (se puede usar cualquier combinación)
sudo apt install konsole          # en Ubuntu con GNOME
sudo pacman -S gnome-terminal     # en Arch con KDE
```

## Alternativas populares (especialmente en WMs)

### Alacritty

Terminal acelerada por GPU, configurada enteramente en un archivo TOML. Muy popular en setups con [[i3]], [[Hyprland]] y [[Niri]].

```bash
sudo pacman -S alacritty     # Arch
sudo apt install alacritty   # Debian/Ubuntu (puede ser versión vieja)
sudo dnf install alacritty   # Fedora

# Config en: ~/.config/alacritty/alacritty.toml
```

**Ventajas**: renderizado por GPU (muy rápido), config limpiamente versionable, cross-platform.
**Desventajas**: no tiene pestañas nativas (se puede emular con `tmux`).

### Kitty

Similar a Alacritty (GPU), pero con más funcionalidades integradas: pestañas, split panes, visualización de imágenes inline, emoji y ligaduras.

```bash
sudo pacman -S kitty        # Arch
sudo apt install kitty      # Debian/Ubuntu
sudo dnf install kitty      # Fedora

# Config en: ~/.config/kitty/kitty.conf
```

**Ventajas**: pestañas + splits nativos (no necesitas tmux para eso), renderizado remoto SSH con `kitten ssh`, muy configurable.
**Desventajas**: más consumo que Alacritty.

### Foot

Terminal **Wayland-nativa** y extremadamente ligera. Corre directamente sobre Wayland sin XWayland, ideal para compositores Wayland como [[Niri]] y [[Hyprland]].

```bash
sudo pacman -S foot         # Arch (nativo)
sudo apt install foot       # Debian/Ubuntu
```

**Ventajas**: ~8 MB RAM, sin dependencias X11, arranque instantáneo.
**Desventajas**: solo corre en Wayland (no en X11), no tiene pestañas.

### Otras opciones

| Terminal | Destaca por |
|---|---|
| `st` (simple terminal) | Extremadamente minimalista (~2k líneas de código), de suckless (los mismos de [[DWM]]) |
| `wezterm` | Multiplexor + terminal escrito en Rust, configurable en Lua |
| `termite` | Ligero, configuración simple (sucesor espiritual: Alacritty) |
| `urxvt` (rxvt-unicode) | Clásico para X11, configurable con Perl extensions |

## Características a considerar

| Característica | Por qué importa |
|---|---|
| **Aceleración GPU** | Desplazamiento y renderizado más suaves, menos CPU |
| **Pestañas** | Varias sesiones en una ventana (o puedes usar tmux en cualquier terminal) |
| **Ligaduras** | Fuentes como Fira Code o JetBrains Mono: `!=`, `=>`, `>=` se ven unidos |
| **Soporte 256 colores / True color** | Temas y resaltado de sintaxis correctos |
| **Soporte Wayland** | Si usas Wayland nativo, evita la capa de compatibilidad XWayland |
| **Imágenes inline** | Kitty e iTerm2 pueden mostrar imágenes dentro de la terminal |

## Configuración de opacidad / transparencia

Muchas terminales permiten fondo transparente o borroso (muy usado en WMs tiling para estética):

```bash
# Alacritty (alacritty.toml)
[window]
opacity = 0.9

# Kitty (kitty.conf)
background_opacity 0.85

# GNOME Terminal (vía perfil)
# Preferencias → Perfil → Fondo → Transparencia
```

## Por qué importa

- La terminal es la herramienta que más vas a usar — elegir una que te guste visual y funcionalmente mejora la experiencia.
- En WMs minimalistas ([[i3]], [[DWM]], [[Hyprland]]), la terminal no viene preinstalada: **tienes que elegir una** y asignarle el atajo `Mod + Enter`.
- Si usas Wayland, una terminal nativa como Foot evita la dependencia de XWayland.

## Notas personales

-

## Ver también

- [[La Shell]]
- [[Shells (bash zsh fish)]]
- [[Editores de Texto]]
- [[Hyprland]]
- [[Niri]]

## Enlaces externos

- [Wikipedia — Terminal emulator](https://en.wikipedia.org/wiki/Terminal_emulator)
- [Wikipedia — Comparison of terminal emulators](https://en.wikipedia.org/wiki/Comparison_of_terminal_emulators)

#programa #terminal
