---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: WM
motor_composicion: x11
lenguaje_config: Bash (herbstclient)
---

# herbstluftwm

> Gestor de ventanas de **mosaico manual** (manual tiling) para X11. El usuario decide la disposición dividiendo el espacio manualmente, sin algoritmos automáticos de layout. Configurable en tiempo real vía `herbstclient`.

## Qué es

herbstluftwm (abreviado **hlwm**) es un gestor de ventanas de tiling manual creado por **Thorsten Wißmann**. A diferencia de los WMs dinámicos (DWM, Awesome, Hyprland) que organizan ventanas automáticamente, hlwm delega el control total al usuario: tú construyes la estructura de **frames** (marcos) dividiendo la pantalla manualmente.

El enfoque **manual tiling** significa que el usuario decide dónde y cómo colocar cada ventana, construyendo un árbol de frames que persiste incluso cuando las ventanas se cierran. Es ideal para quienes quieren control absoluto sobre la disposición de su espacio de trabajo.

## Capturas / Imágenes

> ![herbstluftwm](https://herbstluftwm.org/screenshot.png)
> *herbstluftwm con polybar y terminal dividida (Fuente: herbstluftwm.org)*

## Instalación

```bash
# Debian/Ubuntu
sudo apt install herbstluftwm

# Arch Linux
sudo pacman -S herbstluftwm

# Fedora
sudo dnf install herbstluftwm

# NixOS
nix-env -i herbstluftwm

# Desde fuente
git clone https://github.com/herbstluftwm/herbstluftwm.git
cd herbstluftwm
make
sudo make install
```

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | `~/.config/herbstluftwm/autostart` |
| **Lenguaje** | Bash script (comandos `herbstclient`) |
| **Recarga en caliente** | `Mod + Shift + r` o `herbstclient reload` |
| **Herramienta principal** | `herbstclient` — envía comandos al WM |

### Configuración mínima (autostart)

```bash
#!/usr/bin/env bash
# ~/.config/herbstluftwm/autostart

# Quitar bordes de todas las ventanas
hc attr theme.tiling.reset 1
hc attr theme.floating.reset 1

# Establecer color de borde
hc set frame_border_active_color '#5a9cf5'
hc set frame_border_normal_color '#333333'
hc set frame_border_width 2

# Atajos básicos
hc keybind Mod4-Return spawn alacritty
hc keybind Mod4-p spawn dmenu_run
hc keybind Mod4-q quit
hc keybind Mod4-r remove
hc keybind Mod4-o split bottom 0.5
hc keybind Mod4-u split right 0.5

# Iniciar panel (polybar)
polybar example &

# Regla: terminal floating
hc rule class=XTerm pseudotile=on
```

> **Nota**: `herbstclient` puede abreviarse como `hc` para escribir configuraciones más compactas. La configuración es puramente Bash, lo que permite usar variables, bucles y funciones.

## Atajos de teclado clave (por defecto)

| Atajo | Acción |
|---|---|
| `Mod + Return` | Abrir terminal |
| `Mod + o` | Dividir frame: nuevo abajo (split bottom, pila vertical) |
| `Mod + u` | Dividir frame: nuevo a la derecha (split right, pila horizontal) |
| `Mod + h/j/k/l` | Navegar entre frames (vi-keys) |
| `Mod + Shift + h/j/k/l` | Redimensionar frame actual |
| `Mod + r` | Eliminar frame actual |
| `Mod + Shift + r` | Recargar autostart |
| `Mod + Space` | Cambiar layout del frame (tiling/max/vertical/horizontal) |
| `Mod + Tab` | Ciclar entre tags |
| `Mod + 1-9` | Ir al tag N |
| `Mod + Shift + 1-9` | Mover ventana al tag N |
| `Mod + Shift + q` | Cerrar ventana actual |
| `Mod + Shift + Space` | Alternar floating/tiling de la ventana actual |
| `Mod + LeftClick` | Mover ventana flotante |
| `Mod + RightClick` | Redimensionar ventana flotante |

## Filosofía: Manual Tiling vs Tiling Dinámico

| Aspecto | Manual Tiling (hlwm) | Tiling Dinámico (dwm, Hyprland, i3) |
|---|---|---|
| **Control** | Usuario construye los frames manualmente | El WM organiza automáticamente |
| **Persistencia** | Los frames existen aunque no haya ventanas | El layout cambia al abrir/cerrar apps |
| **Curva de aprendizaje** | Mayor (hay que aprender a dividir) | Menor (layouts predefinidos) |
| **Flexibilidad** | Absoluta (cada pantalla puede ser única) | Buena (pero limitada a algoritmos) |
| **Predictibilidad** | Sabes exactamente dónde irá cada ventana | Depende del algoritmo y orden de apertura |

## Tags (vs Workspaces)

hlwm usa **tags** en lugar de workspaces, con un sistema mucho más flexible:

| Característica | En herbstluftwm |
|---|---|
| **Tags** | Nombres arbitrarios (no números) |
| **Multi-monitor** | Cada monitor muestra cualquier tag independientemente |
| **Movimiento** | `herbstclient use N` cambia tag; `herbstclient move N` mueve ventana |
| **Unión** | Tags se pueden combinar mostrando varios a la vez |

```bash
# Comandos de tags útiles
herbstclient tag_status      # ver estado de todos los tags
herbstclient add work         # crear tag "work"
herbstclient rename work dev  # renombrar tag "work" a "dev"
herbstclient use dev          # cambiar al tag "dev"
herbstclient move dev         # mover ventana actual al tag "dev"
herbstclient merge_tags work dev  # fusionar tags
```

## Integración con paneles

hlwm es agnóstico al panel. Se integra con cualquier panel a través de `herbstclient --idle`, que emite eventos cuando cambia el estado del WM:

```bash
# polybar + hlwm (fragmento de autostart)
polybar example &

# lemonbar + hlwm (ejemplo de la comunidad)
herbstclient --idle | while read line; do
    # actualizar barra según eventos del WM
    echo "$(herbstclient tag_status)" > /tmp/hlwm-status
done
```

Paneles populares con hlwm:
- **polybar** — el más usado, configuración modular
- **lemonbar** — barra minimalista, scripts manuales
- **dzen2** — barra clásica, scripting shell
- **eww** — widgets modernos (si se desea algo más vistoso)

## Multi-monitor independiente

Cada monitor puede mostrar **cualquier tag** sin relación fija. No hay workspaces duplicados por monitor:

```bash
# Configuración multi-monitor
herbstclient set_monitors 1920x1080+0+0 1920x1080+1920+0

# Asignar tags específicos a cada monitor
herbstclient lock
herbstclient use_index 0
herbstclient use work      # monitor 1: tag "work"
herbstclient use_index 1
herbstclient use chat      # monitor 2: tag "chat"
herbstclient unlock
```

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Control absoluto sobre la disposición | Curva de aprendizaje alta |
| Configuración en Bash (familiar, potente) | Sin soporte Wayland (solo X11) |
| Tags flexibles multi-monitor independiente | Pocos themes/rices disponibles |
| Recarga en caliente sin perder estado | Documentación de la comunidad limitada |
| Extremadamente ligero y sin dependencias | No tiene barra integrada |
| herbstclient permite scripting ilimitado | No recomendado para principiantes en WMs |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Configuración no carga | autostart no ejecutable | `chmod +x ~/.config/herbstluftwm/autostart` |
| Atajos no funcionan | Mod key incorrecta | Verificar con `xmodmap` la tecla Super |
| Bordes/pestañas no se ven | `frame_border_width = 0` | `hc set frame_border_width 2` |
| Panel no aparece al iniciar | Orden incorrecto en autostart | Llamar al panel después de configurar WM |
| Ventanas no se dividen | Todas las ventanas en un solo frame | Dividir con `Mod+o` o `Mod+u` primero |
| Pantalla parpadea al redimensionar | Composición gráfica ausente | Añadir `picom &` al autostart |

## Comparativa con otros WMs de tiling

| Aspecto | herbstluftwm | i3 | bspwm |
|---|---|---|---|
| **Tipo** | Manual tiling (frames) | Tiling automático (split) | Árbol binario (bsp) |
| **Config** | Bash script + herbstclient | Archivo texto plano | Bash script + bspc |
| **Tags** | Nombres arbitrarios | Numerados | Nombres arbitrarios (desktops) |
| **Multi-monitor** | Tags independientes por monitor | Workspaces por monitor | Desktops por monitor |
| **Barra** | No incluida | i3status integrada | No incluida |
| **Aprendizaje** | Alta | Media | Alta |
| **Wayland** | No | No (pero existe sway) | No |

## Notas personales

- herbstluftwm es el WM con la curva de aprendizaje más pronunciada de todos los que he probado, pero también el que da más control. La primera semana es frustrante; después, es liberador.
- La clave está en entender que los frames persisten aunque no haya ventanas. Puedes construir una estructura compleja de frames y luego llenarlos con apps según las necesites.
- El sistema de tags con nombres (no números) es muy práctico para organizar el trabajo por proyecto.
- No lo recomiendo como primer WM. Empieza con i3, y si sientes que quieres más control manual, entonces prueba hlwm.
- Solo X11 y comunidad pequeña: tenlo en cuenta si piensas usar Wayland a corto plazo.

## Enlaces externos

- [Sitio oficial herbstluftwm](https://herbstluftwm.org/)
- [Tutorial oficial](https://herbstluftwm.org/tutorial.html)
- [Manual de herbstclient](https://herbstluftwm.org/herbstclient.html)
- [Repositorio GitHub](https://github.com/herbstluftwm/herbstluftwm)
- [Arch Wiki — herbstluftwm](https://wiki.archlinux.org/title/Herbstluftwm)
- [Reddit r/herbstluftwm](https://reddit.com/r/herbstluftwm)

## Ver también

- [[Comparativa gestores de ventanas]] — comparativa completa de todos los WMs
- [[bspwm]] — WM de árbol binario, similar en filosofía de scripting
- [[i3]] — tiling clásico, comparativa directa
- [[Sway]] — i3-compatible para Wayland
- [[DWM]] — WM dinámico minimalista de suckless

#entorno-escritorio
