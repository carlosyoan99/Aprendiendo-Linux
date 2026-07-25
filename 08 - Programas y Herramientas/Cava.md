---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: programa
prioridad: baja
---

# Cava

## Qué es

**Cava** (Console Audio Visualizer for ALSA) es un visualizador de audio por terminal. Muestra barras de frecuencia en tiempo real mientras se reproduce música, usando colores y animaciones. Funciona con cualquier servidor de sonido (ALSA, PulseAudio, PipeWire, sndio) y es compatible con casi cualquier emulador de terminal.

```bash
# Ejemplo de salida (en terminal):
#
# ┌─────────────────────────────────────────────────────────┐
# │ █ █ █   █ █ █                 █   █ █ █ █   █ █       │
# │ █ █ █ █ █ █ █ █   █ █ █ █   █ █ █ █ █ █ █ █ █ █ █ █  │
# │ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █  │
# │ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █  │
# └─────────────────────────────────────────────────────────┘
#   ⚡ BASS    MID · · · · · · · · · · · · · · · · TREBLE  →
```

## Instalación

```bash
# Debian/Ubuntu
sudo apt install cava

# Arch
sudo pacman -S cava

# Fedora
sudo dnf install cava

# Compilar desde fuente (última versión)
git clone https://github.com/karlstav/cava
cd cava
./autogen.sh
./configure
make
sudo make install
```

## Uso básico

```bash
# Ejecutar cava (se autoconecta al servidor de audio)
cava

# Con una fuente de audio específica
cava -p ~/.config/cava/config         # usar configuración específica

# Cava se detiene con Ctrl+C
```

### Conectar cava a la salida de audio actual

Cava captura el audio del **monitor de salida** (loopback). Para que funcione:

```bash
# PulseAudio: cargar módulo loopback (si no está activo)
pactl load-module module-loopback latency_msec=1

# PipeWire: ya debería funcionar automáticamente
# Si no, crear sink null y redirigir:
pw-cli create-node adapter { factory.name=support.null-audio-sink node.name=cava-sink }

# Probar con una fuente de música
mpv musica.mp3                     # en otra terminal
cava                               # debería visualizar el audio
```

## Configuración: `~/.config/cava/config`

```ini
[general]
# Método de entrada de audio
# pulse | pipewire | alsa | sndio | fifo
method = pulse

# Estéreo o mono
stereo = true

# Sensibilidad (0-100, más alto = más sensible)
sensitivity = 100

# Framerate del visualizador (mayor = más suave, más CPU)
framerate = 60

# Número de barras (más = más detalle, más CPU)
bars = 20

# Autosensibilidad (ajusta automáticamente la escala)
autosens = 1

[color]
# Modo de color: gradient | solid | wave
mode = gradient

# Colores del gradiente (de abajo a arriba)
gradient_color_1 = '#0088ff'        # azul (bajas frecuencias)
gradient_color_2 = '#00ff88'        # verde (medias)
gradient_color_3 = '#ff8800'        # naranja (agudas)

# O usar tema predefinido
# mode = wave
# wave_color = '#00ff00'

[smoothing]
# Suavizado entre frames (0-1)
noise_reduction = 0.77

# Factor de caída de las barras (0-1)
bars_sort = 1
```

## Temas populares

```bash
# Catppuccin (https://github.com/catppuccin/cava)
# Copiar el tema:
curl -sLO https://raw.githubusercontent.com/catppuccin/cava/main/catppuccin-config
mv catppuccin-config ~/.config/cava/config

# Temas manuales:
# 🌈 Arcoíris: gradient_color_1 = '#ff0000' → '#ffff00' → '#00ff00' → '#0088ff'
# 🔥 Fuego: gradient_color_1 = '#ff4400' → '#ff8800' → '#ffcc00' → '#ffffff'
# 🧊 Hielo: gradient_color_1 = '#0044ff' → '#0088ff' → '#00ccff' → '#ffffff'
# 🌿 Naturaleza: gradient_color_1 = '#00ff44' → '#44ff00' → '#88ff00' → '#ccff00'
```

## Cava + otros programas

```bash
# Con mpd (Music Player Daemon) + ncmpcpp
# Cava se conecta al sink de mpd automáticamente

# Con Spotify (usando Spotifyd o PulseAudio)
# Cava captura del monitor de salida

# En una terminal separada (tmux)
tmux new-session -d 'cava' \; split-window -h 'ncmpcpp'

# En un panel de waybar/hyprland
# No nativo, pero se puede mostrar en una ventana flotante
```

## Alternativas

| Herramienta | Diferencias con Cava |
|---|---|
| **ncpamixer** | Mezclador de PulseAudio con visualización básica |
| **glava** | Visualizador con efectos OpenGL (más vistoso, más pesado) |
| **cli-visualizer** | Similar a cava, con más modos de visualización |
| **fizsh** | Shell prompt con visualización de audio |

## Ver también

- [[Audio en Linux]] — pila de audio (ALSA, PulseAudio, PipeWire)
- [[PipeWire]] — servidor de audio moderno
- [[tmux]] — ejecutar cava junto a otros programas
- [[htop btop]] — otros monitores de sistema visuales

## Enlaces externos

- [GitHub — karlstav/cava](https://github.com/karlstav/cava)
- [Arch Wiki — Cava](https://wiki.archlinux.org/title/Cava)

#programa #audio #visualizacion
