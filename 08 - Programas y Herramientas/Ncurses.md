---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: programa
prioridad: media
licencia: MIT
alternativas: Termbox, Notcurses
---

# Ncurses

> Biblioteca de programación que permite crear **interfaces de usuario en terminal** (TUI) con ventanas, menús, formularios y colores. Es la base de herramientas como `top`, `htop`, `nano`, `midnight commander` y `aptitude`.

## Qué es

Ncurses (*new curses*) es una biblioteca de programación que provee una API para escribir interfaces basadas en texto en terminales. Optimiza el refresco de pantalla, permitiendo reducir la latencia en conexiones remotas, y abstrae las diferencias entre tipos de terminal (xterm, VT100, Linux console).

Forma parte del proyecto **GNU** y está licenciada bajo **licencia MIT** (no GPL, para permitir su uso en software propietario).

Origen del nombre: sucesora de la biblioteca **curses** de 4.4BSD. La N viene de *new*.

## Capturas / Imágenes

> ![htop — monitor del sistema basado en ncurses](https://upload.wikimedia.org/wikipedia/commons/thumb/3/3d/Htop.png/480px-Htop.png)
> *htop, uno de los programas TUI más conocidos basados en ncurses*

> ![Midnight Commander](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Mc_4.6.1.png/480px-Mc_4.6.1.png)
> *Midnight Commander (mc), gestor de archivos TUI que usa ncurses*

## Instalación

```bash
# Debian/Ubuntu (runtime)
sudo apt install ncurses-bin

# Debian/Ubuntu (desarrollo)
sudo apt install libncurses-dev

# Arch Linux
sudo pacman -S ncurses

# Fedora
sudo dnf install ncurses ncurses-devel
```

## Programas que usan ncurses

| Programa | Categoría |
|---|---|
| **htop** / **btop** | Monitor del sistema |
| **nano** | Editor de texto |
| **Midnight Commander (mc)** | Gestor de archivos |
| **screen** / **tmux** | Multiplexor de terminal |
| **aptitude** | Gestor de paquetes |
| **YaST** (modo TUI) | Configuración del sistema |
| **w3m** | Navegador web |
| **cmus** | Reproductor de música |
| **nmtui** | Configuración de red |
| **calcurse** | Calendario/agenda |
| **newsbeuter/newsboat** | Lector RSS |
| **vim** (versión TUI) | Editor de texto (usa su propio sistema) |

### Ncurses como usuario

Como usuario, no interactúas directamente con ncurses — es invisible. Pero las herramientas que usas a diario (`top`, `nano`, `screen`) dependen de ella.

```bash
# Verificar ncurses instalada
ldconfig -p | grep ncurses
# libncurses.so.6
# libncursesw.so.6 (soporte Unicode)

# Probar una app ncurses básica
sudo apt install mc
mc      # Midnight Commander (TUI)
```

## Arquitectura

```
┌────────────────────────────────────────────┐
│           Aplicación TUI                    │
│         (htop, nano, mc, cmus)             │
├────────────────────────────────────────────┤
│              Ncurses API                    │
│  Ventanas | Menús | Formularios | Colores  │
├────────────────────────────────────────────┤
│        terminfo / termcap DB               │
│   (capacidades de la terminal)             │
├────────────────────────────────────────────┤
│           Terminal (xterm, alacritty)       │
└────────────────────────────────────────────┘
```

## Bases de datos de terminal (terminfo vs termcap)

Ncurses puede usar ambas bases de datos para saber qué capacidades tiene cada terminal:

| Base | Formato | Dónde se usa |
|---|---|---|
| **terminfo** | Compilada (`/usr/share/terminfo/`) | Modo moderno, más rápido |
| **termcap** | Texto plano (`/etc/termcap`) | Legacy, compatibilidad BSD |

```bash
# Ver capacidades de la terminal actual
infocmp

# Listar tipos de terminal disponibles
ls /usr/share/terminfo/x/

# Ver definición de xterm-256color
infocmp xterm-256color | head -20
```

## Desarrollo básico (API de ejemplo)

```c
#include <ncurses.h>

int main() {
    initscr();            // Inicializar pantalla
    printw("¡Hola, ncurses!");  // Escribir texto
    refresh();            // Refrescar pantalla
    getch();              // Esperar tecla
    endwin();             // Finalizar modo ncurses
    return 0;
}
```

```bash
# Compilar
gcc programa.c -lncurses -o programa
./programa
```

## Casos prácticos

### Diagnosticar problemas de terminal (terminfo)

```bash
# ¿La terminal detecta bien el número de colores?
tput colors                      # debe devolver 256 para xterm-256color

# Probar que ncurses funciona correctamente
sudo apt install mc              # Midnight Commander (usa ncurses)
mc                               # probar que la interfaz se ve bien

# Forzar un tipo de terminal si la actual falla
TERM=xterm-256color htop         # ejecutar htop con un tipo de terminal específico
```

### Verificar qué librería ncurses necesita una app

```bash
# Una app compilada contra ncurses5 no funcionará con ncurses6
ldd /usr/bin/nano | grep curses
# libncursesw.so.6 → necesita ncurses6 (w = wide char / Unicode)

# Si falta, instalar la versión correcta
sudo apt install libncurses6      # ncurses6
sudo apt install libncurses5      # ncurses5 (legacy)
```

## Alternativas

| Biblioteca | Lenguaje | Licencia | Características |
|---|---|---|---|
| **Notcurses** | C | LGPL | Moderna, renderizado directo, más rápida |
| **Termbox** | C | MIT | Minimalista, simple |
| **tui-rs** | Rust | MIT | TUI para Rust |
| **blessed** | JS | MIT | TUI para Node.js |
| **Textual** | Python | MIT | TUI moderna para Python |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Caracteres raros en la terminal | TERM incorrecto | `export TERM=xterm-256color` |
| Colores no funcionan | Terminal sin soporte 256 colores | Verificar con `tput colors` |
| Apps ncurses lentas en SSH | Conexión lenta + refresco completo | Usar `-C` (compresión SSH) |
| `libncurses.so.5` not found | Versión obsoleta de la app | Instalar compatibilidad: `sudo apt install libncurses5` |

## Notas personales

- La mayoría de problemas con apps ncurses en sistemas modernos se resuelven instalando `libncursesw` (la versión con soporte Unicode). Sin `w`, los caracteres UTF-8 aparecen como `??` o recuadros.
- Si una TUI se ve mal en SSH, el culpable suele ser `$TERM` incorrecto en el cliente SSH, no en el servidor. Configurar el terminal local primero.
- Para desarrollo TUI moderno en 2026, **Notcurses** es más rápido y tiene mejor soporte de gráficos directos, pero ncurses sigue siendo el estándar por compatibilidad y documentación.

## Enlaces externos

- [Sitio oficial Ncurses](https://invisible-island.net/ncurses/)
- [Ncurses Programming HOWTO](https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/)
- [Wikipedia — Ncurses](https://en.wikipedia.org/wiki/Ncurses)
- [Comparativa de TUI libraries](https://github.com/danbev/learning-curses)

## Ver también

- [[Shells (bash zsh fish)]] — la shell que corre las apps ncurses
- [[htop btop]] — monitores del sistema que usan ncurses
- [[tmux]] — multiplexor de terminal que usa ncurses
- [[Nano]] — editor ncurses básico
- [[screen]] — multiplexor ncurses clásico
- [[La Shell]] — terminal y TUI

#programa
