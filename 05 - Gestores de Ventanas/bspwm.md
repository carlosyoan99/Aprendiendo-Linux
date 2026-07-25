---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: WM
---

# bspwm

## Qué es

**bspwm** es un gestor de ventanas de mosaico (tiling) **minimalista** que organiza las ventanas como un **árbol binario** (Binary Space Partitioning — BSP). No maneja atajos de teclado — para eso usa **sxhkd** (Simple X HotKey Daemon) como programa separado.

Creado por **Bastián Winkler** en 2014. Escrito en C, sigue la filosofía suckless: hacer una cosa y hacerla bien.

## Filosofía

- **Minimalismo extremo**: bspwm solo gestiona ventanas — los atajos, la barra y el resto son programas externos
- **Árbol binario**: cada ventana divide el espacio en dos, creando una jerarquía de splits
- **Rápido y ligero**: escrito en C, sin dependencias innecesarias
- **IPC completo**: todo se controla mediante `bspc` (cliente de línea de comandos)

## Instalación

```bash
# Debian/Ubuntu
sudo apt install bspwm sxhkd

# Arch Linux
sudo pacman -S bspwm sxhkd

# Fedora
sudo dnf install bspwm sxhkd

# Desde fuente
git clone https://github.com/baskerville/bspwm.git
git clone https://github.com/baskerville/sxhkd.git
cd bspwm && make && sudo make install
cd ../sxhkd && make && sudo make install
```

## Configuración

bspwm se configura con un script de shell:

```bash
# ~/.config/bspwm/bspwmrc (debe ser ejecutable)
#!/bin/bash

# Configurar escritorios virtuales (monitores)
bspc monitor -d I II III IV V VI VII VIII IX X

# Reglas de ventanas
bspc rule -a Firefox desktop='^2' follow=on
bspc rule -a GIMP desktop='^9' follow=on state=floating
bspc rule -a Steam desktop='^4' state=floating

# Bordes y gap
bspc config border_width 2
bspc config window_gap 8
bspc config split_ratio 0.50
bspc config focused_border_color "#cba6f7"
bspc config normal_border_color "#45475a"

# Comportamiento
bspc config focus_follows_pointer false
bspc config pointer_follows_focus false
bspc config pointer_modifier mod4
```

### sxhkd (atajos de teclado)

```bash
# ~/.config/sxhkd/sxhkdrc
# Modificador: Super (Windows key)
super = Mod4

# Terminal
super + Return
    alacritty

# Cerrar ventana
super + q
    bspc node -c

# Cambiar focus entre ventanas
super + {h,j,k,l}
    bspc node -f {west,south,north,east}

# Mover ventana en dirección
super + Shift + {h,j,k,l}
    bspc node -s {west,south,north,east}

# Preset layout
super + {_,Shift + }o
    bspc node -{p,o}  # preseleccionar división

# Cambiar modo de ventana (tiled/monocle/floating)
super + space
    bspc node -t {tiled,monocle,floating}
```

## Control dinámico con bspc

bspc es el cliente IPC de bspwm. Permite controlar todo en tiempo real:

```bash
# Navegación
bspc node -f next.local          # siguiente ventana
bspc node -f last                # última ventana usada
bspc node -f biggest             # ventana más grande
bspc desktop -f next             # siguiente escritorio
bspc monitor -f next             # siguiente monitor

# Estado de ventana
bspc node -t floating            # cambiar a flotante
bspc node -t fullscreen          # pantalla completa
bspc node -t ~floating           # toggle flotante

# Mover ventanas
bspc node -d ^5                  # mover al escritorio 5
bspc node -s west                # intercambiar con la de la izquierda

# Árbol
bspc wm -d                       # mostrar estado del árbol
bspc node -p east                # preseleccionar split al este
```

## Herramientas complementarias

| Herramienta | Propósito |
|---|---|
| **polybar** / **lemonbar** | Barra de estado |
| **rofi** | Lanzador de aplicaciones |
| **picom** | Compositor (transparencias, sombras) |
| **feh** / **nitrogen** | Fondo de pantalla |
| **dunst** | Notificaciones |

## Notas personales

- bspwm es el WM que mejor equilibra minimalismo y flexibilidad. No necesitas recompilar como en DWM, pero tampoco tienes la rigidez de i3.
- La separación WM + sxhkd es genial porque puedes recargar atajos sin reiniciar el WM. Editas `sxhkdrc`, `pkill -USR1 sxhkd`, y los nuevos atajos están activos.
- bspc es una herramienta increíblemente potente. Puedes escribir scripts complejos que muevan ventanas, cambien layouts y reaccionen a eventos del sistema, todo desde Bash.
- La desventaja: hay que gestionar más piezas (bspwmrc + sxhkdrc + polybar + picom). No es "instalar y listo" como i3.

## Ver también

- [[DWM]] — WM minimalista similar (suckless)
- [[i3]] — WM tiling clásico con configuración más simple
- [[Sway]] — equivalente Wayland de i3/bspwm
- [[Hyprland]] — WM Wayland moderno con animaciones
- [[Comparativa gestores de ventanas]] — comparativa completa de todos los WMs

## Enlaces externos

- [bspwm — GitHub](https://github.com/baskerville/bspwm)
- [sxhkd — GitHub](https://github.com/baskerville/sxhkd)
- [bspwm Wiki](https://github.com/baskerville/bspwm/wiki)
- [ArchWiki — bspwm](https://wiki.archlinux.org/title/Bspwm)
- [r/unixporn (inspiración)](https://reddit.com/r/unixporn)

#entorno-escritorio
