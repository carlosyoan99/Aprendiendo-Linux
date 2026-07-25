---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: indice
prioridad: media
---

# Comparativa de gestores de ventanas (Windows Managers)

> Guía completa para elegir Window Manager en Linux. Cubre todos los WMs documentados en el vault, organizados por tipo, protocolo y público objetivo.

Linux ofrece una variedad inmensa de gestores de ventanas: desde minimalistas como DWM (2000 líneas de C) hasta completos como Awesome WM (programable en Lua), pasando por los modernos compositores Wayland como Hyprland y Niri.

---

## Guía rápida de elección

| Si eres... | Y quieres... | WM recomendado |
|---|---|---|
| **Principiante en tiling** | Algo que funcione desde el inicio | **[[i3]]** — el clásico, documentación excelente |
| **Minimalista extremo** | Lo más ligero posible, sin moverte de C | **[[DWM]]** — suckless, ~2000 líneas |
| **Programador Python** | Configurar WM con Python | **[[qtile]]** |
| **Programador Lua** | WM programable como Openbox pero en tiling | **[[Awesome WM]]** |
| **Amante de Wayland** | El más moderno y vistoso | **[[Hyprland]]** — animaciones, blur, efectos |
| **Ex-usuario de i3 en Wayland** | i3 pero nativo Wayland | **[[Sway]]** |
| **Fan de Rust** | WM minimalista moderno | **[[Niri]]** — scrollable, Wayland |
| **Usuario de teclado táctil** | WM para tablet/convertible | **[[Sway]]** (mejor soporte táctil) |
| **Sistema muy antiguo (< 2 GB RAM)** | Máxima eficiencia | **[[DWM]]**, **[[Openbox]]** o **[[spectrwm]]** |
| **Vienes de Windows** | Experiencia flotante pero ligera | **[[Openbox]]** o **[[Fluxbox]]** |
| **Vienes de macOS** | Algo pulido sin perder productividad | **[[Hyprland]]** con animaciones |
| **Quieres scroll infinito** | Metáfora scrollable en vez de workspaces | **[[Niri]]** — scroll horizontal infinito |

---

## Tabla comparativa general

### Por tipo y protocolo

| WM | Tipo | Protocolo | Config | Barra | Atajos | Lenguaje |
|---|---|---|---|---|---|---|
| **[[i3]]** | Tiling manual | X11 | Texto plano | i3status/polybar | Integrados | C |
| **[[DWM]]** | Tiling dinámico | X11 | C (recompilar) | dwmblocks/slstatus | Integrados | C |
| **[[bspwm]]** | Tiling BSP | X11 | Script shell | polybar/lemonbar | sxhkd externo | C |
| **[[qtile]]** | Tiling dinámico | X11 + Wayland | Python | Integrada | Integrados | Python |
| **[[Awesome WM]]** | Tiling manual | X11 | Lua | Integrada | Integrados | C + Lua |
| **[[Hyprland]]** | Tiling dinámico | Wayland | Texto plano | waybar | Integrados | C++ |
| **[[Sway]]** | Tiling manual | Wayland | Texto plano | waybar/i3status | Integrados | C |
| **[[Niri]]** | Tiling scrollable | Wayland | Texto plano | Integrada | Integrados | Rust |
| **[[Openbox]]** | Flotante | X11 | XML | tint2/polybar | Integrados | C |
| **[[Fluxbox]]** | Flotante | X11 | Texto plano | Integrada (toolbar) | Integrados | C++ |
| **[[River]]** | Tiling dinámico | Wayland | riverctl | waybar | riverctl + script | Zig |
| **[[herbstluftwm]]** | Tiling manual | X11 | Script shell | polybar/dzen | herbstclient | C |
| **[[spectrwm]]** | Tiling dinámico | X11 | Texto plano | **Integrada** | Integrados | C |

### Por recursos y facilidad

| WM | RAM típica | Curva aprendizaje | Comunidad | Documentación | Efectos visuales |
|---|---|---|---|---|---|
| **i3** | ~50 MB | 🟡 Media | ⭐⭐⭐⭐⭐ | Excelente (User Guide) | ❌ No |
| **DWM** | ~10 MB | 🔴 Alta | ⭐⭐⭐⭐ | Wiki suckless + parches | ❌ No |
| **bspwm** | ~30 MB | 🔴 Alta | ⭐⭐⭐⭐ | GitHub Wiki + Arch Wiki | ❌ No |
| **qtile** | ~80 MB | 🟡 Media | ⭐⭐⭐ | Documentación oficial | ❌ No |
| **Awesome WM** | ~60 MB | 🔴 Alta | ⭐⭐⭐⭐ | Documentación oficial | ⚠️ Básicos |
| **Hyprland** | ~200 MB | 🟡 Media | ⭐⭐⭐⭐⭐ | Wiki muy completa | ✅ Muchos (blur, sombras, animaciones) |
| **Sway** | ~60 MB | 🟡 Media | ⭐⭐⭐⭐ | Arch Wiki + i3 docs | ⚠️ Básicos |
| **Niri** | ~50 MB | 🟡 Media | ⭐⭐ | GitHub + Wiki | ⚠️ Básicos |
| **Openbox** | ~20 MB | ⭐ Baja | ⭐⭐⭐⭐ | Arch Wiki + documentación | ❌ No |
| **Fluxbox** | ~15 MB | ⭐ Baja | ⭐⭐⭐ | Arch Wiki | ❌ No |
| **River** | ~40 MB | 🔴 Alta | ⭐⭐ | GitHub README | ❌ No |
| **herbstluftwm** | ~30 MB | 🔴 Alta | ⭐⭐ | man page + Arch Wiki | ❌ No |
| **spectrwm** | ~20 MB | 🟡 Media | ⭐⭐ | man page + Arch Wiki | ❌ No |

---

## Categorías detalladas

### WMs de mosaico (Tiling) para X11

| WM | Filosofía | Layout único | Ideal para |
|---|---|---|---|
| **[[i3]]** | Manual: tú decides cómo partir cada contenedor | Split horizontal/vertical, stacked, tabbed | El mejor punto de entrada al tiling |
| **[[DWM]]** | Dinámico: dwm decide el layout, tú cambias entre modos | Tiling, monocle, floating | Minimalistas, amantes de suckless |
| **[[bspwm]]** | Binary Space Partitioning: árbol binario de splits | Partición binaria recursiva | Usuarios que quieren control total via CLI (bspc) |
| **[[qtile]]** | Dinámico + programable en Python | Varios (tile, max, floating, etc.) | Programadores Python |
| **[[Awesome WM]]** | Manual + programable en Lua | Varios (tag-based) | Usuarios que quieren personalizar hasta el último detalle |
| **[[herbstluftwm]]** | Manual con layout en árbol | Split manual como i3 | Usuarios que quieren control desde terminal (herbstclient) |
| **[[spectrwm]]** | Dinámico con barra integrada | Vertical, horizontal, monocle, fibonacci | Usuarios que quieren un i3 con menos piezas |

### WMs de mosaico para Wayland

| WM | Filosofía | Compatibilidad i3 | Ideal para |
|---|---|---|---|
| **[[Hyprland]]** | Dinámico con efectos visuales | No (sintaxis propia) | Usuarios que quieren un escritorio bonito y moderno |
| **[[Sway]]** | Manual, compatible con i3 | ✅ **Sí** (misma sintaxis config) | Migrar de i3 a Wayland sin cambiar config |
| **[[Niri]]** | Scrollable (desplazamiento horizontal infinito) | No | Usuarios que quieren una metáfora diferente |
| **[[River]]** | Dinámico, Zig, minimalista | No | Fans de Zig, minimalismo extremo en Wayland |
| **[[qtile]]** (Wayland) | El mismo qtile, ahora en Wayland | No (config Python) | Programadores Python en Wayland |

### WMs flotantes (Floating)

| WM | Filosofía | Ideal para |
|---|---|---|
| **[[Openbox]]** | Clásico flotante, config XML, extremadamente ligero | PCs viejos, usuarios de escritorio tradicional |
| **[[Fluxbox]]** | Fork de Blackbox, pestañas en ventanas (tabbing) | Usuarios que quieren un escritorio ligero con pestañas |
| **[[Openbox]]** | Sin dependencias pesadas, pipe-menu para scripts | Usuarios que quieren un reemplazo ligero de DE |

---

## Por ecosistema

### WMs independientes (solo el WM, todo lo demás por separado)

| WM | Barra | Lanzador | Compositor | Notificador | Wallpaper |
|---|---|---|---|---|---|
| **i3** | polybar/i3status | dmenu/rofi | picom | dunst | feh/nitrogen |
| **DWM** | slstatus/dwmblocks | dmenu | picom | dunst | feh |
| **bspwm** | polybar/lemonbar | rofi/dmenu | picom | dunst | feh/nitrogen |
| **spectrwm** | **Integrada** | dmenu | picom | dunst | feh |
| **herbstluftwm** | polybar/dzen | rofi/dmenu | picom | dunst | feh |

### WMs con ecosistema propio

| WM | Barra | Lanzador | Bloqueo | Idle | Wallpaper |
|---|---|---|---|---|---|
| **qtile** | **Integrada** | Integrado | — | — | feh |
| **Awesome WM** | **Integrada** | Integrado | — | — | feh |
| **Hyprland** | waybar | wofi/rofi | hyprlock | hypridle | hyprpaper |
| **Sway** | waybar/i3status | wofi/rofi | swaylock | swayidle | swaybg |

---

## Recomendaciones por caso de uso

### 🖥️ Escritorio personal moderno

```bash
# Si quieres algo bonito y funcional
sudo pacman -S hyprland waybar wofi dunst hyprpaper
# ⭐ Hyprland: mejor equilibrio entre estética y productividad
```

### 💻 Portátil con batería limitada

```bash
# Si priorizas duración de batería sobre efectos visuales
sudo pacman -S i3-wm polybar rofi picom
# ⭐ i3 o Sway: ligeros, sin efectos innecesarios
```

### 🏢 Servidor / Máquina remota (SSH/TTY)

```bash
# Sin X11 ni Wayland — solo terminal
# ⭐ No necesitas WM, usa tmux para multiplexar terminales
# Si necesitas X11 forwarding: Openbox o DWM
```

### 🐌 PC muy antiguo (1-2 GB RAM)

```bash
# Máxima eficiencia
sudo apt install openbox tint2
# ⭐ Openbox (~20 MB RAM) o DWM (~10 MB)
```

### 🔧 Desarrollador/productividad

```bash
# Mínima fricción, todo por teclado
sudo pacman -S i3-wm polybar rofi
# ⭐ i3 para X11, Sway para Wayland — curva media, máxima productividad
```

---

## Evolución histórica

```
X11 ─────────────────────────────────────────────────────────────
│
├── Floating ─── Openbox ─── Fluxbox (Blackbox fork)
│
└── Tiling ───── i3 ─────── Sway (Wayland port)
                ├── bspwm ── (BSP tree)
                ├── DWM ──── (suckless)
                ├── Awesome WM ── (Lua)
                ├── qtile ─── (Python, ahora con Wayland)
                ├── spectrwm ── (scrotwm fork, barra integrada)
                ├── herbstluftwm ── (herbstclient)
                └──

Wayland ─────────────────────────────────────────────────────────
│
├── i3-compatible ── Sway
├── Moderno ──────── Hyprland (animaciones, efectos)
├── Scrollable ───── Niri
├── Dinámico ─────── River (Zig)
└── Python ───────── qtile (también en X11)
```

---

## Notas personales

- No necesitas probar todos los WMs. Empieza con **i3** (X11) o **Sway** (Wayland) — son los más documentados y con comunidad más grande.
- Si quieres aprender sobre WMs: **DWM** es el más interesante porque su código fuente es legible (~2000 líneas de C). Compilarlo y parchearlo te enseña cómo funciona un WM por dentro.
- **Hyprland** es el que más hype tiene hoy (2026) por sus animaciones, pero requiere hardware relativamente moderno (GPU con aceleración 3D).
- La mayoría de WMs tiling comparten los mismos atajos base (`Mod+Enter` terminal, `Mod+J/K` navegar, `Mod+1-9` workspaces). Una vez aprendes uno, los otros se parecen.
- Los WMs flotantes (Openbox, Fluxbox) son excelentes para PCs muy antiguos o para usuarios que no quieren cambiar su flujo de trabajo.

## Enlaces externos

- [Wikipedia — Comparison of tiling window managers](https://en.wikipedia.org/wiki/Comparison_of_tiling_window_managers)
- [Arch Wiki — Window managers](https://wiki.archlinux.org/title/Window_manager)
- [Arch Wiki — List of applications/Other#Tiling window managers](https://wiki.archlinux.org/title/List_of_applications/Other#Tiling_window_managers)
- [r/unixporn](https://reddit.com/r/unixporn) — inspiración de configuraciones
- [suckless.org](https://suckless.org/) — filosofía DWM

## Ver también

- [[i3]] · [[DWM]] · [[bspwm]] · [[qtile]] · [[Awesome WM]]
- [[Hyprland]] · [[Sway]] · [[Niri]] · [[River]]
- [[Openbox]] · [[Fluxbox]] · [[spectrwm]] · [[herbstluftwm]]
- [[Wayland vs X11]] — diferencias entre los dos protocolos
- [[Emuladores de Terminal]] — terminales para usar con WMs
- [[Comparativa editores Linux]] — otra comparativa del vault

#indice #entorno-escritorio #comparativa
