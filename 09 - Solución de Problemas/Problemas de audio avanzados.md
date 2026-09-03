---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: troubleshooting
prioridad: media
---

# Problemas de audio avanzados

> Troubleshooting de audio más allá de "no hay sonido": routing entre múltiples dispositivos, perfiles Bluetooth (A2DP/HFP), audio HDMI, migración de PulseAudio a PipeWire, latencia profesional, y audio en Wayland. Para el caso básico de "sin sonido" ver [[Sin sonido]].

## Síntoma

- El audio sale por el dispositivo equivocado (altavoces en vez de auriculares).
- Auriculares Bluetooth suenan mal (perfil HFP en vez de A2DP).
- Audio HDMI no funciona al conectar monitor/TV.
- Se escucha audio duplicado o con eco.
- La latencia es alta para producción musical o streaming.
- El audio se corta (glitches) o suena distorsionado.
- Tras migrar a PipeWire, PulseAudio apps no funcionan correctamente.
- En Wayland, la captura de audio (OBS, screencasting) no funciona.

## Diagnóstico

```bash
# 1. Estado completo del audio
wpctl status                             # PipeWire + WirePlumber (moderno)
pactl info                               # PulseAudio / PipeWire-PulseAudio
pactl list sinks short                   # dispositivos de salida
pactl list sources short                 # dispositivos de entrada

# 2. Ver qué sink/source está activo
wpctl inspect @DEFAULT_AUDIO_SINK@       # sink por defecto
wpctl inspect @DEFAULT_AUDIO_SOURCE@     # source por defecto

# 3. Ver perfiles Bluetooth
pactl list cards                         # todas las tarjetas con perfiles
pactl list cards | grep -A 20 "bluez"   # solo Bluetooth

# 4. Verificar latency
pw-metadata -n settings                  # PipeWire settings
cat /proc/asound/card*/pcm*/sub*/params  # ALSA params

# 5. Verificar dispositivo HDMI
pactl list sinks | grep -i "hdmi\|hdmi-output"
wpctl status | grep -i hdmi

# 6. Verificar Bluetooth activo
bluetoothctl show
bluetoothctl devices
bluetoothctl info <MAC>

# 7. Logs de PipeWire/PulseAudio
journalctl --user -u pipewire -b --no-pager | tail -20
journalctl --user -u wireplumber -b --no-pager | tail -20
journalctl --user -u pulseaudio -b --no-pager | tail -20
```

### Logs relevantes

```bash
# PipeWire completo
journalctl --user -u pipewire -u wireplumber -b --no-pager | grep -iE "error|warn|fail" | tail -20

# Bluetooth audio
journalctl -u bluetooth --no-pager | grep -iE "a2dp|hfp|codec|connect" | tail -20

# ALSA errors
dmesg | grep -iE "snd|audio|sound|codec" | tail -10

# Verificar permisos de audio
groups $USER | grep -o "audio\|video\|pipewire"
ls -la /dev/snd/
```

## Caso 1: audio sale por dispositivo equivocado

```bash
# Ver todos los sinks disponibles
pactl list sinks short
# Ejemplo:
# 0  alsa_output.pci-0000_00_1f.3.analog-stereo  PipeWire  s32le 2ch 48000Hz
# 1  bluez_sink.XX_XX_XX_XX_XX_XX.a2dp-sink       PipeWire  s32le 2ch 48000Hz

# Cambiar sink por defecto
wpctl set-default 1                    # por número
wpctl set-default @DEFAULT_AUDIO_SINK@ # (no funciona directamente, usa número)

# O con pactl:
pactl set-default-sink 1

# Para una app específica (sin cambiar全局):
# Abrir pavucontrol (GUI) → pestaña "Playback" → cambiar dispositivo de la app
# O desde CLI:
pactl move-sink-input <input-id> <sink-id>

# Para HDMI:
wpctl set-default <hdmi-sink-id>
# Los sinks HDMI suelen aparecer al conectar el cable
```

## Caso 2: Bluetooth - perfil HFP en vez de A2DP

```bash
# Ver perfiles disponibles de los auriculares
pactl list cards | grep -A 30 "bluez"
# Buscar: "Profiles:" → ver A2DP Sink y Hands-Free

# Cambiar a A2DP (alta calidad)
pactl set-card-profile <card-name> a2dp-sink
# Ejemplo: pactl set-card-profile bluez_sink.XX_XX.a2dp-sink a2dp-sink

# Verificar que cambió
pactl list cards | grep -A 5 "bluez" | grep "active profile"

# Si A2DP no funciona o suena mal:
# 1. Cambiar codec (si soportado)
wpctl inspect <bluez-sink-id> | grep codec
# En PipeWire, cambiar codec en /usr/share/wireplumber/bluetooth.lua.d/51-bluez-config.lua:
#   bluez_monitor.properties = {
--     ["bluez5.enable-sbc-xq"] = true,
--     ["bluez5.enable-msbc"] = true,
--     ["bluez5.codecs"] = "[sbc aac ldac aptx aptx-hd]",
--   }

# 2. Reconectar auriculares tras cambiar config
bluetoothctl disconnect <MAC>
bluetoothctl connect <MAC>
```

## Caso 3: audio HDMI no funciona

```bash
# Verificar sinks HDMI disponibles
wpctl status | grep -i hdmi
pactl list sinks | grep -i "hdmi"

# Si no aparece el sink HDMI:
# 1. Verificar que el cable está conectado (y el monitor encendido)
xrandr | grep -i "hdmi"                 # verificar conexión
wpctl status                             # verificar si PipeWire lo detectó

# 2. Forzar detección (PipeWire):
wpctl set-default <hdmi-sink-id>

# 3. Si el sink HDMI aparece pero sin audio:
# Verificar que no está muteado:
wpctl get-volume <hdmi-sink-id>
wpctl set-volume <hdmi-sink-id> 0.5     # 50% volumen

# 4. Verificar que la app está usando el sink correcto:
pavucontrol → pestaña Playback → cambiar dispositivo
```

## Caso 4: audio con eco / duplicado

```bash
# Causa típica: dos outputs activos al mismo tiempo
pactl list sinks short | grep -i "RUNNING"

# Desactivar eco (monitor de fuente):
pactl list sources | grep -i monitor
# Si hay un "monitor" source activo:
wpctl set-mute <monitor-source-id> 1   # mutear el monitor

# Causa: Loopback module activo
pactl list modules short | grep loopback
pactl unload-module module-loopback

# Verificar que solo un sink está activo:
wpctl status
# Solo el sink que usas debería estar en "RUNNING"
```

## Caso 5: latencia alta (producción musical)

```bash
# Ver latencia actual
pw-metadata -n settings
# Buscar: quantum, rate

# Reducir latencia (PipeWire)
# Crear ~/.config/pipewire/pipewire.conf.d/low-latence.conf:
mkdir -p ~/.config/pipewire/pipewire.conf.d/
cat > ~/.config/pipewire/pipewire.conf.d/low-latence.conf << 'EOF'
context.properties = {
    default.clock.quantum = 256
    default.clock.min-quantum = 128
    default.clock.max-quantum = 512
    default.clock.rate = 48000
}

# Para ultra-baja latencia (producción profesional):
# quantum = 64, min-quantum = 32
# ⚠️ Puede causar xruns (clics) si la CPU no aguanta
EOF

# Reiniciar PipeWire
systemctl --user restart pipewire pipewire-pulse

# Verificar latencia
pw-metadata -n settings
# O con jack_iodelay si usas JACK

# Para apps JACK (Ardour, Reaper):
qjackctl                                  # GUI de JACK
# O configurar PipeWire como reemplazo de JACK (ya lo hace por defecto)
```

## Caso 6: PipeWire + Wayland (screen sharing audio)

```bash
# En Wayland, el audio de captura (micrófono) y screen sharing
# depende de xdg-desktop-portal y PipeWire

# Verificar que xdg-desktop-portal funciona:
systemctl --user status xdg-desktop-portal

# Verificar que PipeWire maneja la captura:
wpctl status | grep -i "source"

# Para OBS en Wayland:
# 1. Usar PipeWire capture (no X11)
# 2. En OBS → Settings → Audio → Mic/Auxiliary → seleccionar PipeWire source

# Para screen sharing con audio:
# gnome-screencast ya usa PipeWire
# En Hyprland/Sway: xdg-desktop-portal-wlr con PipeWire
```

## Caso 7: migración de PulseAudio a PipeWire

```bash
# Si actualizaste y PipeWire reemplazó a PulseAudio pero algo falla:

# Verificar que PipeWire-PulseAudio está activo:
systemctl --user status pipewire-pulse

# Verificar compatibilidad:
pactl info                               # debe mostrar "PipeWire" como servidor
pactl list sinks short                   # debe mostrar sinks de PipeWire

# Si PulseAudio aún está corriendo (conflicto):
systemctl --user stop pulseaudio
systemctl --user disable pulseaudio
systemctl --user start pipewire pipewire-pulse

# Si una app antigua usa PulseAudio directamente:
# PipeWire-PulseAudio emula la API de PulseAudio — debería funcionar
# Si no, instalar el wrapper:
# sudo apt install pipewire-pulse

# Verificar que la API de JACK funciona:
pw-jack <app>                            # ejecutar app con PipeWire-JACK
# O instalar pw-jack: sudo apt install pipewire-jack
```

## Caso 8: audio se corta (glitches/xruns)

```bash
# Causa típica: quantum demasiado bajo o CPU ocupada

# 1. Ver si hay xruns:
pw-metadata -n settings | grep xrun     # contar xruns

# 2. Aumentar quantum (temporal):
wpctl set-metadata settings default.clock.quantum 1024

# 3. Aumentar quantum (permanente):
# ~/.config/pipewire/pipewire.conf.d/low-latence.conf:
context.properties = {
    default.clock.quantum = 1024
    default.clock.min-quantum = 512
    default.clock.max-quantum = 2048
}

# 4. Priorizar PipeWire:
# En /etc/security/limits.conf:
#   @audio - rtprio 95
#   @audio - memlock unlimited
# sudo usermod -aG audio $USER

# 5. Desactivar power saving del audio (laptops):
# En /etc/pulse/default.log: no hay pulse, usar PipeWire
# En TLP:/audioel德尔ays>0
```

## Verificación

```bash
# Test completo de audio:
wpctl status                             # todos los dispositivos
wpctl get-volume @DEFAULT_AUDIO_SINK@    # volumen del sink por defecto
wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5

# Test con speaker-test (sine wave):
speaker-test -D hw:0,0 -c 2 -t wav -l 1

# Test conPipeWire:
pw-play /usr/share/sounds/freedesktop/stereo/bell.oga

# Verificar Bluetooth:
pactl list cards | grep -A 3 "bluez" | grep "active profile"

# Verificar latencia:
pw-metadata -n settings
```

## Tabla de referencia de comandos

| Herramienta | Comando | Uso |
|---|---|---|
| **wpctl** | `wpctl status` | Estado de PipeWire/WirePlumber |
| **wpctl** | `wpctl set-default <id>` | Cambiar sink/source por defecto |
| **wpctl** | `wpctl set-volume <id> 0.5` | Ajustar volumen |
| **wpctl** | `wpctl inspect <id>` | Info detallada de dispositivo |
| **pactl** | `pactl list sinks short` | Listar salidas |
| **pactl** | `pactl list cards` | Tarjetas con perfiles Bluetooth |
| **pactl** | `pactl set-card-profile <card> <profile>` | Cambiar perfil Bluetooth |
| **pavucontrol** | GUI | Volumen por app, cambiar dispositivos |
| **pw-top** | Terminal | Top en tiempo real de dispositivos PipeWire |
| **pw-metadata** | Terminal | Configuración de PipeWire |

## Ver también

- [[Sin sonido]] — troubleshooting básico de audio
- [[PipeWire]] — conceptos, instalación, configuración completa
- [[Audio en Linux]] — pila de audio completa (ALSA/PulseAudio/PipeWire/JACK)
- [[Bluetooth no conecta]] — troubleshooting Bluetooth general
- [[Compatibilidad Wayland]] — apps y audio en Wayland
- [[Gestión de energía y batería]] — power saving que afecta audio

#troubleshooting #audio #pipewire #pulseaudio #bluetooth
