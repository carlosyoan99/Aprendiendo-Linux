---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: Compositor Wayland scrollable-tiling
---

# Niri

## Qué es

Compositor **Wayland** con un paradigma distinto al tiling clásico: **scrollable tiling** — las ventanas se organizan en una tira horizontal infinita en lugar de dividir la pantalla en espacios fijos como i3 o Hyprland. Desplazas el viewport horizontalmente para ver más ventanas, en vez de cambiar de workspace. Inspirado en **PaperWM** (extensión de GNOME).

Escrito en **Rust**, con énfasis en estabilidad y rendimiento. Es uno de los proyectos más jóvenes del ecosistema Wayland tiling.

## Instalación

```bash
# Arch (AUR)
yay -S niri                                # compila desde fuente (Rust)

# NixOS
# Agregar niri a environment.systemPackages

# Otras distros: requiere compilar desde fuente con cargo
# git clone https://github.com/YaLTeR/niri
# cd niri && cargo build --release
```

## Configuración inicial

- Archivo de config: `~/.config/niri/config.kdl` (formato **KDL** — no YAML ni JSON, un formato de configuración jerárquico similar a XML pero más conciso).
- Al igual que [[Hyprland]], se apoya en `waybar` (barra), `fuzzel`/`wofi`/`rofi-wayland` (lanzador), `mako`/`dunst` (notificaciones).

```kdl
// ~/.config/niri/config.kdl
input {
    keyboard {
        xkb-layout "latam"
        xkb-options "ctrl:nocaps"
    }
}

binds {
    "Mod+Return" { spawn "kitty"; }
    "Mod+D" { spawn "fuzzel"; }
    "Mod+Q" { close-window; }
    "Mod+H" { focus-column-left; }
    "Mod+L" { focus-column-right; }
    "Mod+Shift+H" { move-column-left; }
    "Mod+Shift+L" { move-column-right; }
    "Mod+1" { focus-workspace 1; }
    "Mod+Shift+1" { move-column-to-workspace 1; }
    "Mod+ScrollDown" { consume-window-into-column; }
    "Mod+ScrollUp" { expel-window-from-column; }
}

layout {
    gaps 8
    default-column-width { proportion 0.5; }
}

window-rules {
    // Regla: Firefox siempre flotante y con tamaño específico
    match app-id="firefox" {
        open-floating
        default-column-width { fixed 1200; }
    }
}
```

## El paradigma scrollable

En i3/Hyprland tienes **workspaces** independientes y las ventanas se reparten en el espacio fijo del monitor. En Niri:

- Las ventanas se apilan en **columnas** (una por ventana, ocupando la altura completa del monitor).
- El **viewport** (lo que ves) se desplaza horizontalmente.
- Es una cinta sin fin: siempre puedes scrollear a la derecha para ver más ventanas.
- También existen **workspaces** (conjuntos independientes de estas tiras), útiles para separar contextos.

```
| Ventana 1 | Ventana 2 | Ventana 3 | Ventana 4 | Ventana 5 | ...
|           |           |           |           |           |
|           |           |           |           |           |
     ↑         ↑
   viewport actual
```

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Mod + Enter` | Abrir terminal |
| `Mod + D` | Lanzador de apps (fuzzel/wofi) |
| `Mod + Q` | Cerrar ventana |
| `Mod + H/L` | Moverse entre columnas (izquierda/derecha) |
| `Mod + Shift + H/L` | Mover columna |
| `Mod + J/K` | Moverse entre ventanas dentro de la misma columna (si hay varias) |
| `Mod + F` | Pantalla completa |
| `Mod + Shift + F` | Toggle flotante |
| `Mod + ScrollDown` | Fusionar ventana en la columna actual (stack vertical) |
| `Mod + ScrollUp` | Expulsar ventana del stack |
| `Mod + 1-9` | Ir a workspace N |
| `Mod + Shift + 1-9` | Mover ventana a workspace N |
| `Mod + R` | Modo resize |
| `Mod + S` | Screenshot (región) |

## Multi-monitor

Cada monitor tiene su propia tira de ventanas independiente. Workspaces por monitor:

```kdl
binds {
    // Mover foco entre monitores
    "Mod+Period" { focus-monitor-left; }
    "Mod+Comma" { focus-monitor-right; }
}
```

## Pros / Contras

- ✅ Paradigma scrollable muy cómodo para monitores ultrawide o cuando trabajas con muchas ventanas en secuencia (ej. varios terminales).
- ✅ Escrito en Rust: rendimiento, menos crashes, buena gestión de memoria.
- ✅ Wayland nativo (mejor seguridad, mixed-DPI, sin tearing).
- ❌ Proyecto más joven: ecosistema de plugins/temas más reducido que Hyprland.
- ❌ El modelo scrollable tiene curva de adaptación — puede sentirse extraño si vienes de i3/Hyprland.
- ❌ Instalación menos amigable en distros que no sean Arch (compilar desde Rust).
- ❌ Menos documentación/ejemplos de configuración que i3 o Hyprland.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Pantalla en negro al arrancar | Falta compositor/pipeline | Revisar `niri-session` y `wayland` de la sesión |
| Scroll entre ventanas no responde | Atajo no configurado | Definir `Spaces`/scroll en config niri |
| FPS/Jank bajo | Render en software | Activar aceleración de GPU y backends Vulkan/Egl |
| Multi-monitor descolocado | Sin layout barragenerado | Configurar `Monitor` y switchers en niri config |

## Notas personales

- Niri es el WM más original que he visto en años. El scrollable tiling suena extraño, pero una vez te acostumbras tiene una lógica aplastante: cada ventana es una columna, scrollear horizontalmente es intuitivo en un monitor ultra-wide.
- El problema principal hoy (2026) es que es un proyecto joven. La documentación es escasa y hay pocos dotfiles de referencia. No es para principiantes.
- El formato KDL de configuración es peculiar pero legible. Me recuerda a los archivos .ini pero con jerarquía.
- Ideal para: desarrolladores que trabajan con muchos terminales uno al lado del otro (cada columna es un terminal), o para ultra-wide monitors.
- Escrito en Rust: se nota la solidez. No recuerdo la última vez que Niri me crasheó.

## Mi configuración real (CachyOS + Noctalia)

> Estado actual de mi equipo: Laptop con **CachyOS** (hostname `CachyOS-Laptop`), niri **26.04**, shell **Noctalia v5** (shell nativa Wayland que corre sobre niri).

### Estructura de `~/.config/niri/`

```
config.kdl        → solo `include` de módulos + noctalia.kdl (no añadir settings aquí)
cfg/
├── animation.kdl ├── autostart.kdl ├── display.kdl ├── input.kdl
├── keybinds.kdl  ├── layout.kdl    ├── misc.kdl    ├── rules.kdl
├── workspace.kdl
noctalia.kdl      → colores del tema (focus-ring/border/etc.), regenerado por Noctalia
```

- Los módulos se agrupan por *concern*; `config.kdl` solo los `include`.
- `noctalia.kdl` es **regenerado por el shell** → no editar a mano, usar la UI de Noctalia.
- `cfg/keybinds.kdl.save` es un backup, ignorar.
- `gaming-mode.kdl` (en `~/.config/niri/`) es una config alternativa completa que `include` `config.kdl`, desactiva blur/animaciones/touchpad y redefine `Mod+Shift+G` para salir; se carga con `niri msg action load-config-file --path ~/.config/niri/gaming-mode.kdl`.

### Verificación y recarga

```bash
niri validate                          # valida la config
niri msg action load-config-file       # recarga en caliente (desde el cliente)
```

### Atajos reales (extracto de `cfg/keybinds.kdl`)

| Atajo | Acción |
|---|---|
| `Mod+Shift+ESCAPE` | Hotkey overlay |
| `Mod+Q` | Cerrar ventana |
| `Mod+Shift+G` | Toggle modo gaming (`toggle_gaming_mode.sh`) |
| `Mod+Print` | OCR de la selección (`noctalia-ocr`) |
| `Print` / `Shift+Print` / `Ctrl+Print` | Capturas pantalla / ventana / todos los monitores |

Aplicaciones: `Mod+B` Chrome · `Mod+Z` Zed · `Mod+E` Nautilus · `Mod+N` kew · `Mod+X` Firefox · `Mod+Y` Obsidian · `Mod+G` LibreOffice · `Mod+U` VLC · `Mod+Shift+A` Quick Share (r-quick-share) · `Ctrl+Alt+T` alacritty.

Noctalia: `Mod+Shift+Return` wallpaper · `Mod+S` centro de control · `Mod+Shift+S` ajustes · `Mod+D` lanzador · `Mod+Shift+E` clipboard · `Mod+Shift+Q` menú sesión · `Mod+Alt+N` DND.

> ⚠️ Nota: en esta configuración **Noctalia** es quien gestiona wallpaper, barra, lanzador, centro de control, OSD, notificaciones y multimedia (no `waybar`/`fuzzel`/`mako` como en la config de ejemplo genérica de arriba).

### Detalle de los binds con argumentos

El config KDL solo permite `spawn` con comandos simples; para comandos con argumentos (ej. `noctalia msg ...`) se usa `spawn-sh "..."`:

```kdl
Mod+Shift+A hotkey-overlay-title="Quick Share: Compartir archivos" { spawn-sh "rquickshare"; }
```

## Ver también

- [[Hyprland]] — el compositor Wayland tiling más popular
- [[Desktop Shells (Noctalia Caelestia)]] — el shell que corre sobre niri
- [[i3]] — tiling clásico en X11
- [[Wayland vs X11]]
- [[Emuladores de Terminal]]

#entorno-escritorio
