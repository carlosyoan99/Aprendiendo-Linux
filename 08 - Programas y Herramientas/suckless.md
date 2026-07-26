---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
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

## Ver también

- [[DWM]] — el WM más popular del ecosistema suckless
- [[st]] — terminal suckless
- [[Compilación desde Código Fuente]] — proceso de compilar software con `make clean install`

## Enlaces externos

- [Web oficial suckless.org](https://suckless.org/)
- [Repositorio de parches](https://tools.suckless.org/)
- [Filosofía suckless](https://suckless.org/philosophy/)
- [Wikipedia — suckless](https://en.wikipedia.org/wiki/Suckless.org)

#concepto #suckless #minimalismo
