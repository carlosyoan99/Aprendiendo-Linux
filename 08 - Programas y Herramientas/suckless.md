---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: concepto
prioridad: baja
---

# suckless

Comunidad de desarrolladores que crean software **minimalista** siguiendo la filosofía "menos es más". Sus programas son conocidos por tener un código base extremadamente reducido (~2.000 líneas), sin dependencias innecesarias y priorizando la eficiencia sobre las funcionalidades.

## Filosofía

suckless defiende que el **software debe ser simple, claro y libre de código innecesario**. Su lema es *"do one thing and do it well"* (haz una cosa y hazla bien). Creen que la complejidad innecesaria lleva a bugs, vulnerabilidades y dependencias hinchadas.

Principios clave:
- **Código auditable**: cualquier persona con conocimientos de C puede leer y entender el código completo.
- **Sin dependencias**: evitan frameworks y librerías externas siempre que sea posible.
- **Configuración en código fuente**: los ajustes se hacen editando `config.h` y recompilando, no con archivos de configuración en runtime.
- **Parches**: en lugar de opciones configurables, la comunidad mantiene **parches** (patches) oficiales para añadir funcionalidades.

## Proyectos principales

| Proyecto | Qué es | Alternativa a |
|---|---|---|
| **[[DWM]]** | Window manager dinámico | i3, bspwm, Hyprland |
| **st** | Simple Terminal | GNOME Terminal, Alacritty |
| **dmenu** | Lanzador de aplicaciones | rofi, wofi |
| **slock** | Bloqueo de pantalla | i3lock, swaylock |
| **surf** | Navegador web minimalista | Firefox, Chromium |
| **slstatus** | Barra de estado para DWM | polybar, waybar |
| **sent** | Editor de texto simple (sin GUI) | — |

## Repositorio oficial

```bash
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu
```

El repositorio principal alberga todos los proyectos en `git.suckless.org/<proyecto>`.

## Flujo de trabajo práctico (compilar y configurar)

Todo el software suckless sigue el mismo ciclo: **editar `config.h` → compilar → instalar**.

```bash
cd dwm

# 1. Editar la configuración (definida en C, se recompila tras cada cambio)
$EDITOR config.h

# 2. Compilar (el Makefile usa los flags de config.mk)
make

# 3. Probar sin instalar (dwm corre solo si ya hay X11 o Wayland)
./dwm

# 4. Instalar en el sistema (requiere permisos)
sudo make clean install
```

El `make clean install` fuerza recompilación limpia y copia el binario + man page. Si solo cambias `config.h`, basta `sudo make install` (sin `clean`), pero es recomendable limpiar para evitar binarios obsoletos.

### Dependencias típicas

| Proyecto | Dependencias mínimas |
|---|---|
| dwm | libx11, libxft (fuentes), libxinerama (multi-monitor) |
| st | libx11, libxft, harfbuzz (para emoji/scripts complejos) |
| dmenu | libx11, libxinerama |
| slock | libx11, libxext, libxrandr |

En Arch: `sudo pacman -S base-devel libx11 libxft libxinerama harfbuzz`. En Debian/Ubuntu: `sudo apt install build-essential libx11-dev libxft-dev libxinerama-dev libharfbuzz-dev`.

## Aplicar parches

Los parches son diffs sobre el código fuente que añaden funcionalidades (barras de estado, gaps, transparencia, emoji…). Se aplican con `patch` desde la raíz del proyecto:

```bash
cd st
# Descargar el parche (p. ej. scrollback)
curl -O https://st.suckless.org/patches/scrollback/st-scrollback-20210507-4536f46.diff

# Aplicar (el -p1 elimina el prefijo a/ b/ del diff)
patch -p1 < st-scrollback-20210507-4536f46.diff

# Si algo falla, revisar los archivos .rej (rechazos) a mano
ls *.rej

# Recompilar e instalar
sudo make clean install
```

**Regla de oro**: aplicar parches **uno a uno** y compilar tras cada uno — varios parches del mismo tema (p. ej. dos de scrollback) suelen solaparse. Los parches se aplican sobre el código **sin modificar** de la versión indicada en el nombre del fichero.

## Montar una sesión completa con DWM

```bash
# ~/.xinitrc — arrancar dwm con su ecosistema
slstatus &      # barra de estado
slock &         # no hace falta lanzarlo; se invoca con un atajo
dwm             # último comando: el WM queda en primer plano
```

Atajo típico para bloquear con slock (en `config.h` de dwm):

```c
/* keybindings */
static const char *slockcmd[] = { "slock", NULL };
{ MODKEY, XK_l, spawn, {.v = slockcmd } },
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `make` falla con error de librerías | Faltan dependencias de desarrollo | Instalar `-dev`/`-devel` de libx11, libxft, libxinerama |
| Fuentes se ven cuadradas o sin emoji | st compilado sin harfbuzz | Añadir `harfbuzz` a `config.mk` y recompilar |
| Parche no aplica (`*.rej` generado) | Parche para otra versión u otro parche ya aplicado | Restaurar con `git checkout .` y aplicar en orden |
| dwm no arranca desde el gestor de sesión | Falta entry de sesión | Crear `/usr/share/xsessions/dwm.desktop` con `Exec=dwm` |
| Los cambios en `config.h` no se notan | Binario antiguo en memoria o sin reinstalar | `sudo make clean install` y reiniciar dwm (o la sesión) |
| Resolución/DPI incorrecto en st | st no es HiDPI por defecto | Parche `anysize`/`font2` o configurar fuente con tamaño adecuado |

## Ver también

- [[DWM]] — el WM más popular del ecosistema suckless
- [[st]] — terminal suckless
- [[Compilación desde Código Fuente]] — proceso de compilar software con `make clean install`
- [[Emuladores de Terminal]] — dónde encaja st frente al resto

## Enlaces externos

- [Web oficial suckless.org](https://suckless.org/)
- [Repositorio de parches](https://tools.suckless.org/)
- [Filosofía suckless](https://suckless.org/philosophy/)
- [Wikipedia — suckless](https://en.wikipedia.org/wiki/Suckless.org)

#concepto #suckless #minimalismo