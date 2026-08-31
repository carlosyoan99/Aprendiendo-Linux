---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# Kitty

Terminal acelerada por GPU con funcionalidades integradas: pestañas, split panes, visualización de imágenes inline, emoji y ligaduras.

## Instalación

```bash
sudo pacman -S kitty        # Arch
sudo apt install kitty      # Debian/Ubuntu
sudo dnf install kitty      # Fedora
```

## Configuración

Archivo de configuración: `~/.config/kitty/kitty.conf`

```conf
# Opacidad/transparencia
background_opacity 0.85

# Fuente con ligaduras
font_family      FiraCode Nerd Font Mono
font_size        12

# Atajos
map ctrl+shift+t new_tab
map ctrl+shift+enter new_window
```

## Características destacadas

- **Pestañas** y **splits** nativos — no necesitas `tmux` para eso
- **Imágenes inline**: muestra imágenes directamente en la terminal con `kitty +kitten icat`
- **Renderizado remoto SSH** con `kitten ssh`
- Ligaduras y emoji

## Ventajas

- Todo en uno: terminal + multiplexor básico
- Muy configurable
- Renderizado SSH remoto

## Desventajas

- Más consumo de RAM que Alacritty (~50-60 MB)
- Config en formato propio (no TOML/YAML)

## Ver también

- [[Alacritty]] — terminal GPU minimalista
- [[Foot]] — terminal Wayland nativa ultra-ligera
- [[Emuladores de Terminal]] — índice + comparativa
- [[Atajos de teclado - GNOME Terminal y Kitty]] — accesos rápidos por defecto
- [[La Shell]]

## Enlaces externos

- [Sitio oficial](https://sw.kovidgoyal.net/kitty/)
- [GitHub — Kitty](https://github.com/kovidgoyal/kitty)

#programa #terminal
