---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: WM tiling (dinámico, minimalista)
---

# DWM (Dynamic Window Manager)

## Qué es

El WM más minimalista de los tres grandes del tiling: ~2000 líneas de código en C. Filosofía **suckless** — sin archivo de configuración en runtime; toda la configuración se hace editando `config.h` y **recompilando**. Tampoco tiene barra de estado propia (necesita una externa como `dwmblocks` o `slstatus`).

Es parte del ecosistema suckless junto con `dmenu` (lanzador), `st` (terminal), `slock` (bloqueo de pantalla), `surf` (navegador web).

## Instalación

```bash
# No suele estar en repos oficiales para instalación directa; se compila desde fuente:
git clone https://git.suckless.org/dwm
cd dwm
sudo make clean install

# También suele estar en repos de la comunidad:
# Arch
sudo pacman -S dwm

# Debian/Ubuntu
sudo apt install dwm                      # versión estable (puede ser vieja)
```

## Configuración: el modelo suckless

1. Clonas el código fuente.
2. Editas `config.h` (colores, atajos, layouts, reglas de ventanas, fuentes, tags).
3. Aplicas **parches** (patches) descargados de [dwm.suckless.org/patches/](https://dwm.suckless.org/patches/) para añadir funcionalidad (gaps, barra de estado, layouts adicionales, etc.).
4. Recompilas con `sudo make clean install`.
5. Reinicias dwm o haces "Mod + Shift + Q" para recargar la sesión.

```c
// Fragmento de config.h (C)
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const char *termcmd[] = { "st", NULL };        // terminal (st, alacritty, kitty...)
static const char *dmenucmd[] = { "dmenu_run", NULL }; // lanzador

static Key keys[] = {
    { MODKEY,         XK_Return, spawn,          {.v = termcmd } },
    { MODKEY,         XK_p,      spawn,          {.v = dmenucmd } },
    { MODKEY,         XK_j,      focusstack,     {.i = +1 } },
    { MODKEY,         XK_k,      focusstack,     {.i = -1 } },
    { MODKEY|ShiftMask, XK_q,    killclient,     {0} },
};
```

### Parches populares

| Parche | Añade |
|---|---|
| **gaps** | Espacios entre ventanas (como i3-gaps) |
| **status2d** | Colores y formato en la barra de estado (con `dwmblocks`) |
| **attachaside** | Nuevas ventanas se añaden al final, no al principio |
| **pertag** | Layout independiente por tag |
| **hide_vacant_tags** | Oculta tags sin ventanas activas |
| **actualfullscreen** | Pantalla completa real (no solo maximizado) |

```bash
# Aplicar un parche:
cd dwm
wget https://dwm.suckless.org/patches/gaps/dwm-gaps-6.4.diff
patch -p1 < dwm-gaps-6.4.diff
sudo make clean install
```

## Barra de estado externa

DWM no tiene barra incorporada. Alternativas:

```bash
# 1. slstatus (del mismo proyecto suckless)
git clone https://git.suckless.org/slstatus
# Editar config.h y compilar igual que dwm

# 2. dwmblocks (más modular, permite scripts externos)
git clone https://github.com/torrinfail/dwmblocks
# Cada "bloque" es un script que se ejecuta cada N segundos

# 3. polybar (también funciona con dwm si desactivas la barra nativa)
```

## Atajos de teclado clave (configuración por defecto)

| Atajo | Acción |
|---|---|
| `Mod + Shift + Enter` | Abrir terminal |
| `Mod + P` | Lanzador (dmenu) |
| `Mod + J/K` | Moverse entre ventanas |
| `Mod + Shift + J/K` | Mover ventana en la pila |
| `Mod + H/L` | Redimensionar ventana activa |
| `Mod + Shift + C` | Cerrar ventana |
| `Mod + 1-9` | Ir a tag N |
| `Mod + Shift + 1-9` | Mover ventana a tag N |
| `Mod + T` | Layout tiling |
| `Mod + F` | Layout flotante |
| `Mod + M` | Layout monocle (una ventana visible) |
| `Mod + Space` | Alternar entre layout actual y flotante |
| `Mod + Shift + Space` | Toggle flotante para la ventana actual |

(Mod = Alt por defecto en DWM, no Super como en i3. Se configura en `config.h`.)

## Pros / Contras

- ✅ Extremadamente ligero: corre en cualquier máquina, consume ~10-50 MB RAM.
- ✅ Código pequeño y auditable (~2000 líneas).
- ✅ No hay surprises: haces `make`, obtienes exactamente lo que configuraste.
- ❌ Cada cambio de configuración requiere recompilar. No es "editar y recargar" como i3.
- ❌ Sin parches, la experiencia base es muy minimalista (ni gaps, ni barra bonita, ni atajos complejos).
- ❌ Mantener parches puede ser tedioso al actualizar dwm (los parches pueden no aplicar limpio en la nueva versión).
- ❌ Soport Only X11 (no Wayland).

## Notas personales

- DWM fue mi primer WM tiling y el que más me enseñó sobre cómo funciona realmente un gestor de ventanas. Tener que editar C y recompilar para cambiar la configuración suena arcaico, pero te obliga a entender qué hace cada parte.
- El ecosistema de parches es la clave de DWM. Sin parches, DWM es casi inusable hoy (sin gaps, sin colores en la barra, sin pertag). Mi recomendación: empieza con `dwm-flexipatch` que te permite elegir parches desde un solo `config.def.h`.
- Si no quieres recompilar cada vez que cambias un color, este WM no es para ti. Para eso existe i3 o bspwm.
- DWM brilla en máquinas muy limitadas (Raspberry Pi, VPS sin GPU, PCs con 1 GB RAM) donde cualquier otro WM con efectos sería derroche.

## Ver también

- [[i3]] — más fácil de configurar, buena alternativa si DWM es demasiado minimalista
- [[Awesome WM]] — igual de configurable pero en Lua (más amigable que C)
- [[Hyprland]] — alternativa Wayland con efectos modernos
- [[Compilación desde Código Fuente]]

#entorno-escritorio
