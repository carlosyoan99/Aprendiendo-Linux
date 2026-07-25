---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: programa
prioridad: alta
---

# Gamescope

## Qué es

**Gamescope** es un **micro-compositor** desarrollado por **Valve** diseñado específicamente para **gaming en Linux**. Actúa como una capa intermedia entre el juego y el sistema operativo, permitiendo aplicar funciones avanzadas de renderizado independientemente del entorno de escritorio.

Es el sucesor moderno de **steamcompmgr** (el antiguo compositor de Steam Big Picture) y es el corazón del **Modo Gaming de SteamOS** en la Steam Deck, donde reemplaza todo el compositor del escritorio por un entorno optimizado exclusivamente para juegos.

```
┌──────────────────────────────────────────────────────┐
│                    Juego (game.exe)                   │
│          (corre dentro de su propio XWayland)          │
├──────────────────────────────────────────────────────┤
│  ┌────────────────────────────────────────────────┐  │
│  │              Gamescope                          │  │
│  │  ┌────────┬────────┬────────┬─────────────┐   │  │
│  │  │ FSR    │ FPS    │ Escala │ HDR / VRR   │   │  │
│  │  │ Upscale│ Limiter│ Entera │ Adaptive Sync│  │  │
│  │  └────────┴────────┴────────┴─────────────┘   │  │
│  │  ┌────────────────────────────────────────┐    │  │
│  │  │  DRM/KMS → Vulkan (async compute)      │    │  │
│  │  └────────────────────────────────────────┘    │  │
│  └────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────┤
│  Dispositivo de pantalla (KMS / DRM)                  │
└──────────────────────────────────────────────────────┘
```

## Filosofía

- **Menos latencia, más control**: Gamescope evita las copias extra de frames (compositing bypass) que introducen los compositores de escritorio genéricos
- **Aislamiento**: el juego se ejecuta dentro de un entorno virtual con su propio servidor XWayland — el juego \"cree\" que tiene su propia pantalla
- **Funciones de GPU sin depender del juego**: FSR, limitación de FPS, escalado entero, HDR — todo se aplica desde Gamescope, no requiere que el juego lo implemente
- **Independiente del escritorio**: funciona igual en GNOME, KDE, Sway o cualquier WM

## Instalación

```bash
# Arch Linux
sudo pacman -S gamescope

# Fedora (RPM Fusion)
sudo dnf install gamescope

# Debian/Ubuntu (no oficial, compilar desde fuente)
# Ver: https://github.com/ValveSoftware/gamescope

# Desde fuente (última versión, recomendado para NVIDIA)
git clone https://github.com/ValveSoftware/gamescope.git
cd gamescope
meson setup build
ninja -C build
sudo ninja -C build install
```

## Requisitos

Gamescope **requiere** Vulkan para funcionar. No funcionará con OpenGL únicamente. Verificar:

```bash
vulkaninfo --summary
# Buscar: "Vulkan Instance", "GPU", driver Vulkan activo
```

Especialmente importante en NVIDIA: requiere el driver propietario con `nvidia-drm.modeset=1`.

## Uso básico

### En Steam

Añade Gamescope como prefijo en las opciones de lanzamiento del juego:

```bash
# Sintaxis básica
gamescope -W 1920 -H 1080 -r 60 -- %command%

# En Steam: Botón derecho → Properties → Launch Options:
gamescope -W 1920 -H 1080 -r 60 -- %command%

# Explicación:
# -W, -H → resolución interna del juego (ancho, alto)
# -r     → límite de FPS
# --     → separador: lo que sigue es el comando del juego
# %command% → lo que Steam reemplaza por el lanzamiento del juego
```

### Desde terminal con cualquier juego

```bash
# Sin Steam, ejecutar cualquier binario con Gamescope
gamescope -W 1280 -H 720 -r 60 -- ./juego

# Con Wine
gamescope -W 1920 -H 1080 -r 60 -- wine juego.exe

# Con un emulador
gamescope -W 3840 -H 2160 -r 120 -- dolphin-emu
```

### En Lutris

```bash
# Preferencias del juego → System Options → Show advanced options
# → Command prefix:
gamescope -W 1920 -H 1080 -r 60 --
```

### En Bottles

```bash
# Botella → Config → Gamescope → activar
# Parámetros recomendados: -W 1920 -H 1080 -r 60
```

## Parámetros principales

| Parámetro | Descripción | Ejemplo |
|---|---|---|
| `-W`, `-H` | Resolución interna del juego | `-W 1920 -H 1080` |
| `-w`, `-h` | Resolución de salida (por defecto = resolución nativa del monitor) | `-w 2560 -h 1440` |
| `-r` | Límite de FPS (frame rate limiter) | `-r 60`, `-r 144` |
| `-F` | Modo de escalado: `fsr`, `nis`, `linear`, `nearest`, `integer`, `stretch` | `-F fsr` |
| `-S` | Nitidez de FSR (0-20, por defecto 5) | `-S 10` |
| `--fsr-sharpness` | Nitidez de FSR (índice 0-20) | `--fsr-sharpness 8` |
| `--hdr-enabled` | Habilitar HDR10 | `--hdr-enabled` |
| `--hdr-itm-target-nits` | Pico de brillo HDR en nits | `--hdr-itm-target-nits 1000` |
| `--adaptive-sync` | Habilitar VRR (Variable Refresh Rate, FreeSync/GSync) | `--adaptive-sync` |
| `--fullscreen` | Forzar pantalla completa exclusiva | `--fullscreen` |
| `--borderless` | Ventana sin bordes (borderless fullscreen) | `--borderless` |
| `-O` | FPS de salida (frecuencia de refresco) | `-O 120` |
| `-e` | Forzar Steam Environment (modo Steam Deck) | `-e` |
| `--mangoapp` | Mostrar overlay de rendimiento (MangoHUD integrado) | `--mangoapp` |
| `--rt` | Prioridad de tiempo real para el compositor | `--rt` |
| `--expose-wayland` | Exponer socket Wayland a la aplicación | `--expose-wayland` |
| `--stats` | Mostrar estadísticas de Gamescope | `--stats` |
| `--cursor-scale` | Escalar cursor para HiDPI | `--cursor-scale 2` |

### Modos de escalado (`-F`)

| Modo | Descripción | Ideal para |
|---|---|---|
| **fsr** | AMD FidelityFX Super Resolution (escalado con IA) | Juegos 3D, mejora rendimiento |
| **nis** | NVIDIA Image Scaling (alternativa a FSR) | Juegos 3D con GPU NVIDIA |
| **linear** | Escalado lineal (suavizado, puede dar borroso) | Contenido fotográfico |
| **nearest** | Vecino más cercano (nítido, pixelado) | Pixel art, juegos retro |
| **integer** | Escalado entero (múltiplos exactos sin desenfoque) | Juegos 2D/pixel art |
| **stretch** | Estirar a pantalla completa (sin mantener proporción) | Casos extremos |

## Atajos de teclado en tiempo de ejecución

Mientras un juego se ejecuta dentro de Gamescope, puedes usar estos atajos:

| Atajo | Función |
|---|---|
| `Super + U` | Alternar FSR (on/off) |
| `Super + N` | Alternar filtro de escalado (nearest/linear/FSR) |
| `Super + F` | Alternar pantalla completa |
| `Super + I` | Mostrar/ocultar estadísticas (fps, resolución, escalado) |
| `Super + B` | Alternar borde de ventana |
| `Super + G` | Alternar GameMode (si está instalado) |
| `Super + W` | Alternar modo ventana |
| `Super + R` | Recargar configuración |
| `Super + T` | Alternar MangoHUD (overlay de rendimiento) |
| `F11` | Pantalla completa |
| `Alt + Enter` | Pantalla completa |

## Casos de uso avanzados

### FSR para juegos que no lo implementan nativamente

```bash
# Jugar a 720p escalado a 1080p con FSR (mejora FPS notable)
gamescope -W 1280 -H 720 -w 1920 -h 1080 -F fsr -- %command%

# ^ El juego renderiza a 720p, Gamescope escala a 1080p con FSR
```

### Integer scaling para juegos retro

```bash
# Juego pixel art a 640x480 → 1920x1440 (escala entera 3x)
gamescope -W 640 -H 480 -w 1920 -h 1440 -F integer -- %command%
# Sin desenfoque, píxeles perfectamente cuadrados
```

### Límite de FPS + VRR para gaming eficiente

```bash
# Límite a 60 FPS + FreeSync/GSync activo
gamescope -r 60 --adaptive-sync -- %command%
# La pantalla solo se refresca cuando hay un frame nuevo (ahorro energía)
```

### HDR en monitor compatible

```bash
# Juego en HDR10 con pico de 1000 nits
gamescope -W 1920 -H 1080 --hdr-enabled --hdr-itm-target-nits 1000 -- %command%
# Requiere monitor y GPU compatible con HDR
```

### Overlay de rendimiento (MangoHUD integrado)

```bash
# Mostrar FPS, temperaturas, uso de GPU/CPU
gamescope --mangoapp -- %command%

# Presiona Super + T durante el juego para alternar el overlay
```

## Gamescope en Steam Deck

En la Steam Deck, Gamescope es el compositor por defecto del Modo Gaming. El usuario puede ajustar parámetros desde el menú de acceso rápido (botón \"...\"):

- **TDP (Potencia)**: limitar consumo de batería
- **FPS limit**: 30, 60, sin límite
- **FSR**: activar con nitidez ajustable
- **Escalado**: entero, lineal
- **Filtro de escalado**: FSR, linear, nearest

SteamOS gestiona Gamescope automáticamente, pero los parámetros avanzados se pueden configurar mediante:

```bash
# ~/.config/gamescope-config.cfg
# (archivo de configuración adicional en SteamOS)
```

## Requisitos y compatibilidad

| Componente | AMD/Intel | NVIDIA |
|---|---|---|
| **Driver** | Mesa 20.3+ (AMD), Mesa 21.2+ (Intel) | NVIDIA 515.43.04+ |
| **Kernel param** | Ninguno | `nvidia-drm.modeset=1` |
| **Vulkan** | Vulkan 1.3+ | Vulkan 1.3+ |
| **Wayland** | ✅ Nativo | ✅ Con nvidia-drm.modeset |
| **FSR** | ✅ | ✅ |
| **HDR** | ✅ | ⚠️ Limitado |
| **VRR** | ✅ | ✅ |
| **Estado** | ✅ Excelente | ⚠️ Puede tener problemas de estabilidad |

## Troubleshooting

```bash
# 1. Gamescope no arranca
# Verificar soporte Vulkan:
vulkaninfo --summary | grep "GPU"

# 2. NVIDIA: pantalla negra
# Asegurar nvidia-drm.modeset=1 en /etc/default/grub:
# GRUB_CMDLINE_LINUX=\"... nvidia-drm.modeset=1...\"
sudo update-grub

# 3. FSR no funciona
# Verificar que se usa -F fsr (no teclear Fsr o FSR, debe ser minúsculas)
gamescope -W 1280 -H 720 -w 1920 -h 1080 -F fsr -- %command%

# 4. El juego se ve borroso con FSR
# Aumentar la nitidez:
gamescope -W 1280 -H 720 -w 1920 -h 1080 -F fsr -S 10 -- %command%

# 5. El cursor no se ve / parpadea
gamescope --cursor-scale 2 -- %command%

# 6. Ver versión de Gamescope
gamescope --version

# 7. Logs de Gamescope
GAMESCOPE_LOG_LEVEL=debug gamescope -- %command%
```

## Gamescope vs otros compositores

| Aspecto | Gamescope | Compositor DE (KWin, Mutter) | Compositor WM (Hyprland) |
|---|---|---|---|
| **Propósito** | Gaming exclusivamente | Escritorio general | Escritorio + productividad |
| **Latencia** | Mínima (bypass compositor) | Media (composita todo) | Baja-media |
| **FSR / Upscaling** | ✅ Integrado | ❌ No | ❌ No |
| **HDR** | ✅ | ⚠️ Parcial (KWin) | ⚠️ Varía |
| **VRR** | ✅ | ✅ KWin, ❌ Mutter | ✅ Sway/Hyprland |
| **Límite FPS** | ✅ | ❌ | ❌ |
| **MangoHUD** | ✅ Integrado | ❌ | ❌ |
| **Uso típico** | Arrancar juego y salir | Usar el PC | Usar el PC |

## Ver también

- [[Videojuegos en Linux]] — gaming en Linux en general
- [[SteamOS]] — SO que usa Gamescope como compositor por defecto
- [[Wayland vs X11]] — protocolo base de Gamescope
- [[Wine]] — Proton + Gamescope = combinación ideal
- [[Bottles]] — Bottles puede ejecutar juegos con Gamescope
- [[Hyprland]] — compositor Wayland para escritorio (no gaming)

## Enlaces externos

- [Gamescope — GitHub (Valve)](https://github.com/ValveSoftware/gamescope)
- [Gamescope — ArchWiki](https://wiki.archlinux.org/title/Gamescope)
- [MangoHUD — GitHub](https://github.com/flightlessmango/MangoHud)
- [AMD FSR — Página oficial](https://www.amd.com/en/technologies/fidelityfx-super-resolution)
- [Steam Deck Tech — Gamescope](https://www.steamdeck.com/en/tech)

#programa #gaming #wayland
