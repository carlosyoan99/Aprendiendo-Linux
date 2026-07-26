---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# Gestores de Archivos — Índice

Un gestor de archivos permite navegar, copiar, mover y eliminar archivos con una interfaz visual, ya sea gráfica o en la terminal. Cada DE trae su propio gestor gráfico por defecto; en WMs minimalistas se suele usar uno de terminal.

## Gestores gráficos

| Gestor | DE asociado | Split | Terminal integrada | Renombrado batch |
|---|---|---|---|---|
| [[Nautilus]] | [[GNOME]] | ❌ | ❌ | ❌ |
| [[Dolphin]] | [[KDE Plasma]] | ✅ (F3) | ✅ (F4) | ✅ |
| [[Thunar]] | [[XFCE]] | ❌ | ❌ | ✅ (plugin) |
| [[Nemo]] | [[Cinnamon]] | ✅ (F3) | ✅ (F4) | ✅ |
| [[PCManFM]] | — | ❌ | ❌ | ❌ |
| [[Double Commander]] | — | ✅ | ❌ | ❌ |
| [[SpaceFM]] | — | ✅ | ❌ | ❌ |

## Gestores de terminal (TUI)

Cuando usas [[i3]], [[DWM]], [[Hyprland]] o [[Niri]], los gestores gráficos pueden no estar instalados. Alternativas en terminal:

| Gestor | Lenguaje | Destaca por |
|---|---|---|
| [[ranger]] | Python | Tipo vim, preview panel derecho |
| [[nnn]] | C | Ultra-ligero, teclas configurables |
| [[yazi]] | Rust | Preview rápida de imágenes y PDFs |
| [[lf]] | Go | Rápido, configuración minimalista |

## Por qué importa

- En WMs tiling, no hay un gestor de archivos por defecto. Tienes que elegir e instalar uno.
- Los gestores de terminal como `nnn` o `yazi` son extremadamente eficientes para tareas repetitivas una vez aprendidos los atajos.
- `dolphin` con terminal integrada (`F4`) elimina la necesidad de cambiar de ventana entre terminal y gestor.

## Notas personales

-

## Ver también

- [[Emuladores de Terminal]]
- [[La Shell]]
- [[Editores de Texto]]
- [[i3]]
- [[Hyprland]]

## Enlaces externos

- [Wikipedia — File manager](https://en.wikipedia.org/wiki/File_manager)
- [Wikipedia — Comparison of file managers](https://en.wikipedia.org/wiki/Comparison_of_file_managers)

#programa #archivos
