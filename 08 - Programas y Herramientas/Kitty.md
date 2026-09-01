---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: media
---

# Kitty

Terminal acelerada por GPU con funcionalidades integradas: pestañas, split panes, visualización de imágenes inline, emoji y ligaduras.

## Qué es

- Emulador de terminal basado en GPU (OpenGL), escrito en Python+C y mantenido por Kovid Goyal (autor de calibre).
- A diferencia de Alacritty, incluye **de serie** pestañas, splits, render de imágenes inline y sitios render de SSH — funciona como una terminal + un multiplexor ligero.
- Muy popular entre usuarios de WMs tiling, por sus funciones avanzadas sin recurrir a `tmux`.

## Instalación

```bash
sudo pacman -S kitty        # Arch
sudo apt install kitty      # Debian/Ubuntu
sudo dnf install kitty      # Fedora
flatpak install flathub org.kovidgoyal.kitty
# macOS: brew install --cask kitty ; Windows: kitty.build
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

## Comandos / atajos útiles

| Atajo | Acción |
|---|---|
| `Ctrl+Shift+T` | Nueva pestaña |
| `Ctrl+Shift+Enter` | Nuevo split |
| `Ctrl+Shift+Tab` | Cambiar pestaña |
| `Ctrl+Shift+←/→` | Cambiar de pane |
| `Ctrl+Shift+Q` | Cerrar ventana |

```bash
kitty +kitten icat imagen.png   # ver imagen en terminal
kitten ssh server              # ssh con kitty (render remoto)
```

## Ventajas

- Todo en uno: terminal + multiplexor básico
- Muy configurable
- Renderizado SSH remoto

## Desventajas

- Más consumo de RAM que Alacritty (~50-60 MB)
- Config en formato propio (no TOML/YAML)

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Imagen no se muestra inline | Config de terminal no kitty | Usar `kitty +kitten icat` |
| SSH distancia con render | Conexión no kitty-to-kitty | Usar `kitten ssh` |
| Fuente/ligaduras no aplican | Fuente no instalada | Instalar Nerd Font en el sistema |

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
