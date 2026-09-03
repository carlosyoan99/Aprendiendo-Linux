---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: baja
---

# WezTerm

Multiplexor + terminal escrito en **Rust**, configurable en **Lua**. Soporta GPU acceleration, pestañas, splits y ligaduras. Es una alternativa moderna que combina las capacidades de [[tmux]] con las de un emulador de terminal GPU.

## Instalación

```bash
# Arch
sudo pacman -S wezterm

# Debian/Ubuntu (descargar .deb del release)
# https://github.com/wez/wezterm/releases

# Fedora
sudo dnf install wezterm

# También disponible via flatpak
flatpak install flathub org.wezfurlong.wezterm
```

## Configuración

Archivo de configuración: `~/.config/wezterm/wezterm.lua`

```lua
local wezterm = require 'wezterm'
return {
  font_size = 12.0,
  font = wezterm.font_with_fallback({
    'JetBrains Mono',
    'Noto Sans Mono CJK SC',  -- fallback para chino
    'Noto Color Emoji',        -- fallback para emoji
  }),
  color_scheme = 'Catppuccin Mocha',
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  default_cursor_style = 'SteadyBlock',
  window_background_opacity = 0.95,
  macos_window_background_blur = 20,
}
```

## Atajos principales

| Atajo | Acción |
|---|---|
| `Ctrl+Shift+T` | Nueva pestaña |
| `Ctrl+Shift+N` | Nueva ventana |
| `Ctrl+Shift+Left/Right` | Navegar pestañas |
| `Ctrl+Shift+1-9` | Ir a pestaña 1-9 |
| `Ctrl+Shift+\|` | Split vertical |
| `Ctrl+Shift+-` | Split horizontal |
| `Ctrl+Shift+Z` | Zoom en panel actual |
| `Ctrl+Shift+W` | Cerrar panel/pestaña |
| `Ctrl+Shift+K` | Scroll de búsqueda (modo copia) |
| `Ctrl+Shift+Up/Down/Left/Right` | Navegar entre splits |

## Características

- **Multiplexor integrado**: pestañas, splits, paneles — no necesita tmux externo
- **Config en Lua**: muy potente y flexible (lógica condicional, imports, funciones)
- **Renderizado GPU**: scroll suave, ligaduras, imágenes inline, animaciones
- **Cross-platform**: Linux, macOS, Windows (misma configuración en todos)
- **Soporte Unicode y emoji**: fuentes fallback configurables, no necesita parches
- **Hyperlinks**: detección automática de URLs con `Ctrl+Click`
- **Modo copia**: selección de texto estilo Vim con `Ctrl+Shift+K`
- **Workspaces**: grupos de pestañas/sessions independientes
- **SSH nativo**: lanzar sesiones SSH directamente desde WezTerm

## Ventajas

- Multiplexor + terminal en uno (elimina la necesidad de tmux)
- Lua permite configuraciones muy avanzadas (temas dinámicos, perfiles)
- Excelente soporte para ligaduras y fuentes Nerd Font
- Renderizado GPU con scroll suave y transparencias
- Sesiones SSH nativas sin configuración extra

## Desventajas

- Mayor consumo de RAM que alternativas minimalistas (~80-120 MB)
- Config en Lua más compleja que Alacritty (YAML/TOML)
- Sin soporte oficial de paquetes en Debian/Ubuntu (hay que descargar .deb manual)
- Puede ser abrumador para quien solo quiere una terminal simple

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Fuente de iconos/nerd font se ve cuadrada | Falta ligadura/glyphs | Instalar una Nerd Font y configurar `font = wezterm.font_with_fallback(...)` |
| Layout con pestañas desordenado | Config de workspace | Ajustar `initial_cols`/arrangement en `wezterm.gui` |
| Escapos ANSI raros con tmux | Divergencia de `TERM` | Ajustar `TERM`/`wezterm` compatibility con tmux |
| Lento con mucho contenido | Render | Use Accelerated/Direct2D si disponible en config |
| Config inválida | Error de lua al arrancar | `wezterm --config-file` para depurar o validar con linter |

## Ver también

- [[Alacritty]] — terminal GPU minimalista (YAML, sin multiplexor)
- [[Kitty]] — terminal GPU con pestañas y ligaduras
- [[Emuladores de Terminal]] — índice + comparativa
- [[tmux]] — multiplexor externo (alternativa a WezTerm para quien prefiere terminal + tmux)

## Enlaces externos

- [Sitio oficial](https://wezfurlong.org/wezterm/)
- [GitHub](https://github.com/wez/wezterm)
- [Config examples](https://github.com/wez/wezterm/tree/main/docs/examples)


#programa #terminal
