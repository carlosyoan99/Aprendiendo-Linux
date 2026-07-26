---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# Foot

Terminal **Wayland-nativa** y extremadamente ligera. Corre directamente sobre Wayland sin pasar por XWayland, ideal para compositores Wayland como [[Niri]], [[Hyprland]], [[Sway]] y [[River]].

Es la terminal por defecto de algunos entornos Wayland-puros y muy popular en setups minimalistas.

## Instalación

```bash
sudo pacman -S foot         # Arch (nativo)
sudo apt install foot       # Debian/Ubuntu
sudo dnf install foot       # Fedora
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

## Ventajas

- **Ultra-ligero**: ~8 MB RAM
- Sin dependencias X11 (no necesita XWayland)
- Arranque instantáneo
- Soporta True Color, emoji y clipboard sincronizado

## Desventajas

- **Solo corre en Wayland** (no funciona en X11)
- No tiene pestañas nativas
- Config menos flexible que Alacritty o Kitty

## Ver también

- [[Alacritty]] — terminal GPU cross-platform
- [[Kitty]] — terminal GPU con pestañas
- [[Emuladores de Terminal]] — índice + comparativa
- [[Wayland vs X11]]

## Enlaces externos

- [Sitio oficial](https://codeberg.org/dnkl/foot)
- [Documentación](https://codeberg.org/dnkl/foot/src/branch/master/doc/foot.ini.5)

#programa #terminal
