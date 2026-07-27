---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
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

## Notas personales

- Niri es el WM más original que he visto en años. El scrollable tiling suena extraño, pero una vez te acostumbras tiene una lógica aplastante: cada ventana es una columna, scrollear horizontalmente es intuitivo en un monitor ultra-wide.
- El problema principal hoy (2026) es que es un proyecto joven. La documentación es escasa y hay pocos dotfiles de referencia. No es para principiantes.
- El formato KDL de configuración es peculiar pero legible. Me recuerda a los archivos .ini pero con jerarquía.
- Ideal para: desarrolladores que trabajan con muchos terminales uno al lado del otro (cada columna es un terminal), o para ultra-wide monitors.
- Escrito en Rust: se nota la solidez. No recuerdo la última vez que Niri me crasheó.

## Ver también

- [[Hyprland]] — el compositor Wayland tiling más popular
- [[i3]] — tiling clásico en X11
- [[Wayland vs X11]]
- [[Emuladores de Terminal]]

#entorno-escritorio
