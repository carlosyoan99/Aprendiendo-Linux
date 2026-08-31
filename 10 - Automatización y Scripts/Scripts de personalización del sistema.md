---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: automatizacion
prioridad: alta
tipo: Nota de scripts personales
---

# Scripts de personalización del sistema

Scripts propios que añaden funcionalidad o ajustan el sistema en ejecución (CachyOS + niri + Noctalia). Viven en `~/.local/bin/` (en el PATH del usuario).

## niri-gov — alterna el governor de CPU

Cambia entre perfiles de energía escribiendo en `/sys` (requiere la regla sudoers `niri-gov` sin contraseña).

| Estado | Governor | Descripción |
|---|---|---|
| `schedutil` | performance | Máximo rendimiento (enchufado) |
| `performance` | powersave | Ahorro (batería) |
| `powersave` | schedutil | Balance automático |

```bash
niri-gov                      # alterna al siguiente modo
sudo visudo                   # regla necesaria (una vez)
```

Regla sudoers a añadir (ejemplo para el usuario `carlosyoan`):

```
carlosyoan ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor, /proc/sys/vm/drop_caches
```

## niri-ram — libera caché de RAM

Ejecuta `sync` y escribe `3` en `drop_caches` para liberar memoria cache en equipos con poca RAM. Muestra el antes/después como notificación.

```bash
niri-ram
```

## toggle_gaming_mode.sh — modo gaming/rendimiento en niri

Alterna entre la config normal de niri y `gaming-mode.kdl` (desactiva blur + animaciones + touchpad). No requiere sudo porque usa `niri msg action load-config-file`.

```bash
toggle_gaming_mode.sh toggle      # activa o desactiva según marcador
toggle_gaming_mode.sh enable      # forza activación
toggle_gaming_mode.sh disable     # fuerza desactivación
```

Crea un marcador `~/.config/niri/.gaming-mode` para recordar el estado.

## noctalia-ocr y noctalia-remind

Complementos de productividad construidos sobre Noctalia:

- `noctalia-ocr` — OCR de una región de pantalla (keybind `Mod+Print`), copia el texto al portapapeles. Véase [[OCR de pantalla con noctalia-ocr]].
- `noctalia-remind` — temporizador de recordatorios vía notificaciones de Noctalia. Véase [[Recordatorios con noctalia-remind]].

## Ver también

- [[Automatización y Scripts]] — base de scripting
- [[Git hooks para el vault]] — hooks del repositorio
- [[Niri]] — configuración del compositor (incluye gaming-mode.kdl)

#automatizacion #scripts #niri