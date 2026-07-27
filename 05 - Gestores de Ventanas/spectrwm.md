---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: WM tiling
---

# spectrwm

## Qué es

Gestor de ventanas de mosaico (tiling) para **X11**, fork de **scrotwm**. Configurable sin scripts — todo en texto plano con una sintaxis simple y legible. Destaca por su barra de estado integrada, soporte de regiones y layouts dinámicos (vertical, horizontal, monocle, fibonacci).

Creado por **Marco Peereboom** (ex desarrollador de OpenBSD) como fork de scrotwm (que a su vez nació para demostrar que un WM tiling podía ser simple y seguro, influenciado por la filosofía OpenBSD). El nombre viene de "spectrum" + "wm" — por su énfasis en la productividad del desarrollador.

## Filosofía

- **Sin dependencias externas**: la barra de estado viene integrada, no necesita polybar/dzen
- **Configuración plana**: un solo archivo de texto, sin scripting, sin magia
- **Estabilidad heredada de OpenBSD**: código auditado, diseño seguro
- **Dinámico**: los layouts se ajustan automáticamente al añadir/cerrar ventanas

## Instalación

```bash
# Debian/Ubuntu
sudo apt install spectrwm

# Arch Linux
sudo pacman -S spectrwm

# Fedora
sudo dnf install spectrwm

# Desde fuente
git clone https://github.com/conformal/spectrwm
cd spectrwm
./configure
make
sudo make install
```

## Configuración

Archivo de configuración: `~/.spectrwm.conf` (texto plano):

```conf
# ~/.spectrwm.conf — configuración principal

# Modificador (MOD1=Alt, MOD4=Super/Windows)
modkey = Mod4

# Terminal
term = kitty

# Layout por defecto: vertical, horizontal, monocle, fibonnaci
layout = vertical

# Barra de estado (integrada)
bar_enabled = 1
bar_font = -*-terminus-*-r-*-*-14-*-*-*-*-*-*-*
bar_font_color = #cba6f7
bar_color = #1e1e2e
bar_border_color = #45475a
bar_border_width = 1
bar_format = +|0+2|+I+3|+N|+3+1+t|+3+1+f|+3+1+42+2+S+3+4+5+6+7+8+9+10+11+12+13+14+15+16+17+18+19+20+21+22+23+24+25+26+27+28+29+30+31+32+33+34+35+36+37+38+39+40+41+2+43+44|+3+2+45+4+d|+3+2+46|+2+47|+2+48+49

# Regiones (monitores virtuales dentro de un monitor físico)
region = ws[1]:1920x1080+0+0
region = ws[2-5]:960x1080+0+0
region = ws[6-9]:960x1080+960+0

# Gaps entre ventanas
gap_increment = 5
stack_enabled = 1
stack_initial_width = 333
```

### Barra de estado integrada

A diferencia de i3 (necesita i3status/polybar) o DWM (necesita slstatus/dwmblocks), spectrwm incluye su propia barra configurable desde `spectrwm.conf`. Los widgets se configuran con el formato `bar_format`:

```conf
# Formato de la barra (sintaxis propia):
# +N  = nombre del workspace actual
# +I  = layout icono
# +t  = reloj
# +f  = fecha
# +S  = estado de la batería
# +M  = uso de memoria
# +C  = uso de CPU
# +D  = fecha larga
```

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Mod + Enter` | Abrir terminal |
| `Mod + Space` | Siguiente layout (vertical → horizontal → monocle → fibonacci) |
| `Mod + J/K` | Siguiente/anterior ventana |
| `Mod + Shift + J/K` | Mover ventana en la pila |
| `Mod + H/L` | Redimensionar (encoger/agrandar) |
| `Mod + 1-9` | Ir al workspace N |
| `Mod + Shift + 1-9` | Mover ventana a workspace N |
| `Mod + T` | Modo flotante para la ventana actual (toggle) |
| `Mod + M` | Pantalla completa (toggle) |
| `Mod + P` | Lanzador de aplicaciones (dmenu por defecto) |
| `Mod + Q` | Cerrar ventana |
| `Mod + R` | Renombrar workspace |
| `Mod + F5` | Recargar configuración |

(`Mod` = Alt por defecto, configurable con `modkey` a Super/Mod4)

## Layouts disponibles

| Layout | Comportamiento |
|---|---|
| **vertical** | Master a la izquierda, stack a la derecha (como i3) |
| **horizontal** | Master arriba, stack abajo |
| **monocle** | Una ventana visible a la vez (maximizada) |
| **fibonacci** | Divisiones recursivas tipo espiral (dwm) |
| **floating** | Ventanas flotantes libres (manual) |

Se cambian con `Mod + Space` (cicla entre todos) o desde el menú contextual con clic derecho en la barra.

## Regiones (multi-monitor virtual)

spectrwm tiene un sistema único de **regiones**: divides un monitor físico en zonas virtuales donde los workspaces se asignan:

```conf
# Dos regiones en el mismo monitor: workspace 1-3 a la izquierda, 4-6 a la derecha
region = ws[1-3]:960x1080+0+0
region = ws[4-6]:960x1080+960+0

# Equivalente a tener dos monitores virtuales sin hardware extra
```

## Pros / Contras

- ✅ Barra de estado integrada — no necesitas polybar/dzen/i3status.
- ✅ Configuración en texto plano simple (no scripting, no C, no Lua).
- ✅ Regiones: partitioning virtual de monitores sin Xrandr.
- ✅ Estable y ligero (hereda filosofía OpenBSD).
- ✅ Layout fibonacci (único entre los WMs tiling).
- ❌ Solo X11 (no Wayland).
- ❌ Comunidad pequeña — menos dotfiles, menos ayuda online.
- ❌ Sintaxis de bar_format críptica (códigos numéricos).
- ❌ Menos flexible que i3 para configuraciones complejas.

## Notas personales

- spectrwm es un WM infravalorado. Si vienes de i3 y quieres algo igual de funcional pero con menos piezas móviles (barra incluida), spectrwm es una opción sólida.
- Las regiones son ideales para ultra-wide monitors sin usar Xrandr.
- La sintaxis de bar_format es lo más crítico — una vez configurada, no la tocas más.

## Enlaces externos

- [Repositorio oficial en GitHub](https://github.com/conformal/spectrwm)
- [Wiki de spectrwm](https://github.com/conformal/spectrwm/wiki)
- [Arch Wiki — spectrwm](https://wiki.archlinux.org/title/Spectrwm)
- [OpenBSD spectrwm page](https://man.openbsd.org/spectrwm.1)

## Ver también

- [[i3]] — el tiling WM clásico, similar en filosofía
- [[DWM]] — alternativa minimalista suckless
- [[Comparativa gestores de ventanas]] — comparativa de todos los WMs
- [[Comparativa gestores de ventanas]] — comparativa completa de todos los WMs

#entorno-escritorio
