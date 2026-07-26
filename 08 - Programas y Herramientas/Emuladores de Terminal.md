---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# Emuladores de Terminal — Índice

El emulador de terminal es la **ventana** donde se ejecuta tu shell. Cada DE trae uno por defecto, pero hay muchas alternativas, especialmente en setups con WMs minimalistas donde hay que elegir uno manualmente.

Ver [[La Shell]] para entender la diferencia entre emulador de terminal y shell.

## Tabla comparativa

| Terminal | Tipo | Consumo RAM | Pestañas | GPU | Wayland |
|---|---|---|---|---|---|
| [[Alacritty]] | GPU | ~30 MB | ❌ (usa [[tmux]]) | ✅ | ✅ |
| [[Kitty]] | GPU + funciones | ~50 MB | ✅ nativas | ✅ | ✅ |
| [[Foot]] | Wayland nativa | ~8 MB | ❌ | ❌ | ✅ (solo WL) |
| [[st]] | Suckless minimal | <5 MB | ❌ | ❌ | Parche |
| [[wezterm]] | Rust + Lua | ~40 MB | ✅ nativas | ✅ | ✅ |
| [[GNOME Terminal]] | GTK (DE) | ~25 MB | ✅ | ❌ | ✅ |
| [[Konsole]] | Qt (KDE) | ~30 MB | ✅ | ❌ | ✅ |
| [[Xfce Terminal]] | GTK (XFCE) | ~15 MB | ✅ | ❌ | ✅ |

```bash
# Instalar terminal de otro DE (se puede usar cualquier combinación)
sudo apt install konsole          # en Ubuntu con GNOME
sudo pacman -S gnome-terminal     # en Arch con KDE
```

## Características a considerar

| Característica | Por qué importa |
|---|---|
| **Aceleración GPU** | Desplazamiento y renderizado más suaves, menos CPU |
| **Pestañas** | Varias sesiones en una ventana (o puedes usar tmux en cualquier terminal) |
| **Ligaduras** | Fuentes como Fira Code o JetBrains Mono: `!=`, `=>`, `>=` se ven unidos |
| **Soporte 256 colores / True color** | Temas y resaltado de sintaxis correctos |
| **Soporte Wayland** | Si usas Wayland nativo, evita la capa de compatibilidad XWayland |
| **Imágenes inline** | Kitty puede mostrar imágenes dentro de la terminal |

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

## Enlaces externos

- [Wikipedia — Terminal emulator](https://en.wikipedia.org/wiki/Terminal_emulator)
- [Wikipedia — Comparison of terminal emulators](https://en.wikipedia.org/wiki/Comparison_of_terminal_emulators)

#programa #terminal
