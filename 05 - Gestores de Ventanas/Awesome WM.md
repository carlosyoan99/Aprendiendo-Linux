---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: WM tiling (dinámico)
---

# Awesome WM

## Qué es

WM extremadamente configurable mediante scripts en **Lua**. Soporta layouts tiling (automático), flotantes y mixtos, tags etiquetadas (en vez de workspaces rígidos) y widgets personalizados directamente en la barra. Si i3 es el punto de entrada al tiling, Awesome es el siguiente nivel para quien quiere programar su escritorio.

> "Awesome is a framework for making your desktop, not a desktop you use as-is."

## Instalación

```bash
# Debian/Ubuntu
sudo apt install awesome

# Arch
sudo pacman -S awesome
```

## Configuración inicial

- Archivo de config: `~/.config/awesome/rc.lua` — no es un archivo key-value, es **código Lua real**.
- La primera vez que se inicia, copia un `rc.lua` de ejemplo a `~/.config/awesome/`.
- Al ser un lenguaje de programación real, permite lógica compleja: condicionales, bucles, funciones, APIs del sistema.

```lua
-- Fragmento de rc.lua (ejemplo)
-- Tags (workspaces) y sus layouts
awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1:web", "2:code", "3:term", "4:media" }, s, awful.layout.layouts[1])
end)

-- Regla: Firefox siempre en tag 1 con layout flotante
awful.rules.rules = {
    { rule = { class = "Firefox" },
      properties = { tag = "1", floating = true } },
}
```

### Tags vs Workspaces

i3 usa workspaces lineales (1, 2, 3...). Awesome usa **tags** (etiquetas): una ventana puede tener múltiples tags activas a la vez, apareciendo en varias "pantallas virtuales" simultáneamente.

```bash
# Mod + Ctrl + número → añadir tag N a la ventana actual
# Mod + Shift + Ctrl + número → eliminar tag N de la ventana actual
```

## Layouts principales

| Layout | Comportamiento |
|---|---|
| **Tile** | Ventana principal a la izquierda, resto apiladas a la derecha |
| **Fair** | Divide el espacio equitativamente entre todas las ventanas |
| **Spiral** | Ventanas en espiral (dinámico) |
| **Max** | Ventana activa maximizada, resto ocultas |
| **Floating** | Ventanas flotantes (como DE tradicional) |
| **Magnifier** | Ventana activa grande al centro, resto pequeñas alrededor |

```bash
# Mod + Space → ciclar entre layouts
```

## Widgets y barra

Awesome tiene su propia barra (wibar) integrada. Se pueden añadir widgets desde el `rc.lua`:

| Widget | Función |
|---|---|
| `awful.widget.clock` | Reloj |
| `awful.widget.taglist` | Lista de tags |
| `awful.widget.tasklist` | Lista de ventanas abiertas |
| `awful.widget.prompt` | Lanzador de comandos |
| Widgets de terceros | Red, batería, volumen, temperatura (escritos en Lua) |

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Mod + Enter` | Abrir terminal |
| `Mod + R` | Lanzador de apps (prompt) |
| `Mod + Space` | Ciclar layout |
| `Mod + J/K` | Moverse entre ventanas |
| `Mod + Shift + J/K` | Mover ventana |
| `Mod + Ctrl + N` | Ir a tag N |
| `Mod + Shift + N` | Mover ventana a tag N |
| `Mod + Shift + C` | Cerrar ventana |
| `Mod + F` | Pantalla completa |
| `Mod + Esc` | Menú de Awesome (recargar config, reiniciar, salir) |

## Pros / Contras

- ✅ Configuración = código real (Lua): potencia casi ilimitada.
- ✅ Sistema de tags más flexible que workspaces lineales.
- ✅ Gran variedad de layouts integrados.
- ❌ Requiere saber programar en Lua para sacarle el máximo provecho.
- ❌ Curva más alta que i3: si no tocas el `rc.lua`, no tienes un escritorio usable.
- ❌ Ecosistema de widgets de terceros menor que el de KDE/GNOME.
- ❌ Solo X11 (Wayland no soportado — hay forks experimentales como awesome-git o Hyprland como alternativa).

## Notas personales

- Awesome es el WM que más recomiendo a programadores que quieren "hackear" su escritorio. Si ya sabes Lua (o quieres aprenderlo), las posibilidades son casi infinitas.
- El sistema de tags (no workspaces) es más flexible de lo que parece: una ventana puede estar visible en varios tags a la vez. Muy útil para tener, por ejemplo, un terminal con logs visible desde cualquier tag.
- La pega: si no tocas el `rc.lua`, el escritorio por defecto es feo y poco funcional. Awesome no es "instalar y usar" — requiere inversión inicial.
- La comunidad de Awesome ha migrado en parte a Hyprland. Si empiezas hoy, plantéate Hyprland a menos que quieras específicamente la potencia de Lua.

## Enlaces externos

- [Wikipedia — Awesome (window manager)](https://en.wikipedia.org/wiki/Awesome_(window_manager))
- [Repositorio oficial en GitHub](https://github.com/awesomeWM/awesome)
- [Sitio oficial](https://awesomewm.org/)

## Ver también

- [[i3]] — el tiling WM más simple, buena alternativa si Awesome es demasiado
- [[DWM]] — aún más minimalista que i3, configurable en C
- [[Hyprland]] — alternativa moderna en Wayland

#entorno-escritorio
