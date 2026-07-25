---
fecha_creacion: 2026-07-24
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
---

# Gestores de ventanas adicionales

Además de los WMs con nota individual más detallada, esta nota recoge todos los gestores de ventanas documentados en el vault y sirve como índice rápido con resúmenes de cada uno.

Todos los WMs listados aquí tienen su propia nota individual con información detallada de instalación, configuración y atajos.

## Notas individuales

### Tiling para X11

- [[i3]] — el clásico del tiling manual, documentación excelente, configuración declarativa
- [[DWM]] — minimalismo extremo (~2000 líneas de C), suckless, se configura recompilando
- [[bspwm]] — árbol binario (BSP), control total vía `bspc`, usa sxhkd para atajos
- [[qtile]] — escrito en Python, configuración en Python puro, backend dual X11+Wayland
- [[Awesome WM]] — altamente configurable en Lua, sistema de tags flexible, barra integrada
- [[spectrwm]] — fork de scrotwm, barra integrada, regiones virtuales, layout fibonacci
- [[herbstluftwm]] — manual tiling con frames persistentes, se configura con Bash + `herbstclient`

### Tiling para Wayland

- [[Hyprland]] — el más popular y vistoso, animaciones fluidas, blur, sombras, comunidad enorme
- [[Sway]] — reemplazo de i3 para Wayland, config compatible, Wayland nativo
- [[Niri]] — scrollable tiling (desplazamiento horizontal infinito), escrito en Rust
- [[River]] — minimalista, escrito en Zig, tags flexibles, arquitectura modular
- [[qtile]] (Wayland) — el mismo qtile funciona en Wayland con el backend `-b wayland`

### Flotantes (Floating) para X11

- [[Openbox]] — el flotante ligero por excelencia, config XML, ~20 MB RAM
- [[Fluxbox]] — fork de Blackbox con tabbing nativo, slit, barra integrada

---

## Tabla comparativa rápida

### Por tipo y protocolo

| WM | Tipo | Protocolo | Lenguaje | Config | Barra | RAM idle |
|---|---|---|---|---|---|---|
| **[[i3]]** | Tiling manual | X11 | C | Texto plano | i3status/polybar | ~50 MB |
| **[[DWM]]** | Tiling dinámico | X11 | C | C (recompilar) | dwmblocks/slstatus | ~10 MB |
| **[[bspwm]]** | Tiling BSP | X11 | C | Script shell + bspc | polybar/lemonbar | ~30 MB |
| **[[qtile]]** | Tiling dinámico | X11 + Wayland | Python | Python puro | **Integrada** | ~80 MB |
| **[[Awesome WM]]** | Tiling manual | X11 | C + Lua | Lua | **Integrada** | ~60 MB |
| **[[Hyprland]]** | Tiling dinámico | Wayland | C++ | hyprland.conf | waybar | ~200 MB |
| **[[Sway]]** | Tiling manual | Wayland | C | i3-compatible | swaybar/waybar | ~60 MB |
| **[[Niri]]** | Tiling scrollable | Wayland | Rust | KDL | waybar | ~50 MB |
| **[[River]]** | Tiling dinámico | Wayland | Zig | riverctl | waybar | ~40 MB |
| **[[Openbox]]** | Flotante | X11 | C | XML | tint2/polybar | ~20 MB |
| **[[Fluxbox]]** | Flotante | X11 | C++ | Texto plano | **Integrada** | ~15 MB |
| **[[spectrwm]]** | Tiling dinámico | X11 | C | Texto plano | **Integrada** | ~20 MB |
| **[[herbstluftwm]]** | Tiling manual | X11 | C | Bash + herbstclient | polybar/dzen | ~30 MB |

### Por facilidad y características

| WM | Curva aprendizaje | Comunidad | Efectos visuales | Wayland | Ideal para |
|---|---|---|---|---|---|
| **i3** | 🟡 Media | ⭐⭐⭐⭐⭐ | ❌ No | ❌ | Primer WM tiling |
| **DWM** | 🔴 Alta | ⭐⭐⭐⭐ | ❌ No | ❌ | Minimalistas extremos |
| **bspwm** | 🔴 Alta | ⭐⭐⭐⭐ | ❌ No | ❌ | Control total vía CLI |
| **qtile** | 🟡 Media | ⭐⭐⭐ | ❌ No | ✅ Ambos | Programadores Python |
| **Awesome WM** | 🔴 Alta | ⭐⭐⭐⭐ | ⚠️ Básicos | ❌ | Programadores Lua |
| **Hyprland** | 🟡 Media | ⭐⭐⭐⭐⭐ | ✅ Muchos | ✅ | Escritorio bonito y moderno |
| **Sway** | 🟡 Media | ⭐⭐⭐⭐ | ⚠️ Básicos | ✅ | Migrar de i3 a Wayland |
| **Niri** | 🟡 Media | ⭐⭐ | ⚠️ Básicos | ✅ | Scrollable, ultrawide, Rust |
| **River** | 🔴 Alta | ⭐⭐ | ❌ No | ✅ | Minimalistas Wayland |
| **Openbox** | 🟢 Baja | ⭐⭐⭐⭐ | ❌ No | ❌ | PCs antiguos, migrantes |
| **Fluxbox** | 🟢 Baja | ⭐⭐⭐ | ❌ No | ❌ | PCs muy antiguos, tabbing |
| **spectrwm** | 🟡 Media | ⭐⭐ | ❌ No | ❌ | Barra integrada, regiones |
| **herbstluftwm** | 🔴 Alta | ⭐⭐ | ❌ No | ❌ | Control manual absoluto |

---

## Enlaces externos

- [Arch Wiki — Window managers](https://wiki.archlinux.org/title/Window_manager)
- [Wikipedia — Comparison of tiling window managers](https://en.wikipedia.org/wiki/Comparison_of_tiling_window_managers)
- [r/unixporn](https://reddit.com/r/unixporn) — inspiración de configuraciones

## Ver también

- [[Comparativa gestores de ventanas]] — guía para elegir WM según perfil y caso de uso
- [[i3]] · [[DWM]] · [[bspwm]] · [[qtile]] · [[Awesome WM]]
- [[Hyprland]] · [[Sway]] · [[Niri]] · [[River]]
- [[Openbox]] · [[Fluxbox]] · [[spectrwm]] · [[herbstluftwm]]
- [[Comparativa entornos de escritorio]] — comparativa de DEs (la otra cara de la moneda)
- [[Wayland vs X11]] — diferencias de protocolo

#entorno-escritorio
