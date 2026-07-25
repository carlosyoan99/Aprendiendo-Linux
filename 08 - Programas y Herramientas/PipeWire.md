---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# PipeWire

## Qué es

**PipeWire** es el servidor multimedia moderno de Linux, diseñado para reemplazar tanto a **PulseAudio** (audio de escritorio) como a **JACK** (audio profesional de baja latencia). Además, maneja captura de pantalla y streaming de video en **Wayland**, algo que ni PulseAudio ni ALSA pueden hacer por sí solos.

Es el estándar actual en: Fedora 34+, Arch, Ubuntu 23.04+, Debian 12+, openSUSE Tumbleweed.

### Ventajas clave

- **Menor latencia**: comparable a JACK (~5-20ms vs ~50-100ms de PulseAudio)
- **Menor consumo**: ~20-30 MB RAM frente a ~30-50 MB de PulseAudio
- **Unificado**: audio + video en un solo servicio
- **Compatibilidad nativa**: apps PulseAudio y JACK funcionan sin configuración adicional
- **Captura de pantalla en Wayland**: PipeWire es el backend de captura de pantalla en GNOME/KDE Wayland (xdg-desktop-portal)

## Arquitectura

```bash
┌──────────────────────────────────────────────────────┐
│                   Aplicaciones                        │
│  (múltiples a la vez: Firefox, Spotify, OBS, DAW)    │
├──────────────────────────────────────────────────────┤
│  ↑  pipewire-pulse  (compatibilidad PulseAudio)       │
│  ↑  pipewire-jack   (compatibilidad JACK)            │
│  ↑  WirePlumber     (gestor de sesiones/routing)     │
├──────────────────────────────────────────────────────┤
│  ↑  PipeWire (pw-cli, pw-metadata)                   │
├──────────────────────────────────────────────────────┤
│  ↑  ALSA (drivers del kernel, hardware)              │
├──────────────────────────────────────────────────────┤
│  ↑  Hardware (tarjeta de sonido, USB-C, HDMI)        │
└──────────────────────────────────────────────────────┘
```

## Instalación y activación

```bash
# PipeWire ya viene instalado por defecto en distros recientes
# Si no:
sudo apt install pipewire pipewire-pulse wireplumber    # Debian/Ubuntu
sudo pacman -S pipewire pipewire-pulse wireplumber      # Arch
sudo dnf install pipewire pipewire-pulse wireplumber    # Fedora

# Desactivar PulseAudio (si estaba instalado antes)
systemctl --user disable --now pulseaudio
systemctl --user enable --now pipewire pipewire-pulse
```

## Comandos esenciales

### Con `wpctl` (WirePlumber — recomendado)

```bash
# Estado general
wpctl status                         # sinks, sources, volumen, mute

# Control de volumen
wpctl set-volume @DEFAULT_SINK@ 0.8  # 80% (número entre 0.0 y 1.0)
wpctl set-volume @DEFAULT_SINK@ 50%  # 50% (porcentaje)
wpctl set-volume @DEFAULT_SINK@ 5%+  # subir 5%
wpctl set-volume @DEFAULT_SINK@ 5%-  # bajar 5%

# Silenciar
wpctl set-mute @DEFAULT_SINK@ 0      # unmute
wpctl set-mute @DEFAULT_SINK@ 1      # mute
wpctl set-mute @DEFAULT_SINK@ toggle # alternar

# Volumen del micrófono
wpctl set-volume @DEFAULT_SOURCE@ 70%

# Cambiar dispositivo por defecto
wpctl set-default <ID>               # ID del nuevo sink/source
```

### Con `pw-cli` (PipeWire nativo — más detallado)

```bash
# Información
pw-cli info                          # información del servidor PipeWire
pw-cli list-objects                  # todos los objetos (nodos, devices, links)
pw-cli list-objects | grep -A 10 'node.name'

# Enumerar dispositivos
pw-cli enumerate-objects | grep -E 'id|alias|name|node'
```

## Herramientas GUI

```bash
# Patchbay gráfico (conexiones entre apps y dispositivos)
sudo apt install qpwgraph            # GTK, similar a Catia (JACK)
sudo pacman -S qpwgraph

# Alternativa más simple
sudo apt install helvum              # GTK, más minimalista que qpwgraph
sudo pacman -S helvum

# Mezclador de volumen (compatible con PipeWire)
pavucontrol                           # el mismo de PulseAudio, funciona igual
```

## Configuración

```bash
# Archivos de configuración
ls /usr/share/pipewire/              # configuración por defecto (no editar)
mkdir -p ~/.config/pipewire/
cp /usr/share/pipewire/pipewire.conf ~/.config/pipewire/  # copia editable

# WirePlumber (gestor de sesiones)
ls /etc/wireplumber/main.lua.d/      # reglas de configuración Lua
# Ejemplo: cambiar sink por defecto permanentemente
sudo nano /etc/wireplumber/main.lua.d/51-default-sink.lua
```

### Reducir latencia

```bash
# Reducir latencia de audio (útil para producción musical)
pw-metadata -n settings 0 clock.force-quantum 256
# Valores típicos: 256 (medio), 128 (bajo), 64 (muy bajo, requiere buen hardware)

# Hacer permanente:
# ~/.config/pipewire/pipewire.conf
# properties = {
#     default.clock.quantum = 256
#     default.clock.min-quantum = 128
# }
```

### Configurar ecualización (EasyEffects)

Para ecualización global, compresión, limitación y efectos:

```bash
# EasyEffects (antes PulseEffects)
sudo apt install easyeffects
sudo pacman -S easyeffects

# Añade ecualizador, compresor, limitador, reverberación, etc.
# Aplica a todo el audio del sistema
```

## Diagnóstico

```bash
# Verificar que PipeWire esté corriendo
systemctl --user status pipewire
systemctl --user status pipewire-pulse

# Logs en vivo
journalctl --user -u pipewire -f
journalctl --user -u wireplumber -f

# Reiniciar el stack de audio
systemctl --user restart pipewire wireplumber

# Resetear configuración (si algo sale mal)
rm -rf ~/.local/state/wireplumber/
systemctl --user restart pipewire wireplumber

# Probar sonido
speaker-test -t sine -f 440 -l 1      # tono de 440Hz (ALSA directo)
paplay /usr/share/sounds/freedesktop/stereo/bell.oga  # vía pipewire-pulse
```

## PipeWire vs PulseAudio vs JACK

| Característica | PulseAudio | JACK | PipeWire |
|---|---|---|---|
| Mezcla múltiples apps | ✅ | ❌ (una app a la vez) | ✅ |
| Latencia | ~50-100ms | ~5-20ms | ~5-20ms |
| Routing flexible | ✅ | ✅ | ✅ |
| Compatibilidad JACK | ❌ | — | ✅ (nativa) |
| Captura pantalla Wayland | ❌ | ❌ | ✅ |
| Consumo RAM | ~30-50 MB | ~10-20 MB | ~20-30 MB |
| Configuración | Compleja | Compleja | Moderada |
| Estado | ❌ Legado | ⚠️ Nicho profesional | ✅ Estándar actual |

## Ver también

- [[Audio en Linux]] — visión general de la pila de audio
- [[Sin sonido]] — troubleshooting paso a paso
- [[Wayland vs X11]] — PipeWire es necesario para compartir pantalla en Wayland
- [[systemd]] — units de usuario para pipewire

## Enlaces externos

- [Wikipedia — PipeWire](https://en.wikipedia.org/wiki/PipeWire)
- [Sitio oficial — PipeWire](https://pipewire.org/)
- [GitLab — PipeWire/pipewire](https://gitlab.freedesktop.org/pipewire/pipewire)
- [Arch Wiki — PipeWire](https://wiki.archlinux.org/title/PipeWire)

#programa #audio
