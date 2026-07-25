---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: sistema
prioridad: alta
---

# Audio en Linux

## Visión general (la pila de audio)

El audio en Linux funciona en **capas**. Entender qué hace cada capa es clave para diagnosticar problemas de sonido:

```
┌──────────────────────────────────────────────┐
│  Aplicaciones (Firefox, Spotify, OBS, juego)  │
├──────────────────────────────────────────────┤
│  ↑ PipeWire (moderno) / PulseAudio (legacy)   │
│    Mezcla múltiples apps, routing, ecualización │
├──────────────────────────────────────────────┤
│  ↑ ALSA (kernel)                              │
│    Drivers de hardware, acceso a la tarjeta    │
├──────────────────────────────────────────────┤
│  ↑ Hardware (tarjeta de sonido, USB, HDMI)    │
└──────────────────────────────────────────────┘
```

**Regla práctica**: si una app no suena, el problema suele estar en la capa que conecta esa app con el hardware — y la herramienta correcta depende de qué capa estés debuggeando.

---

## ALSA (Advanced Linux Sound Architecture)

**Capa más baja**: drivers del kernel y acceso directo al hardware. No hace mezcla por sí misma (una sola app puede usar la tarjeta a la vez, a menos que se use `dmix`).

### Ver hardware detectado

```bash
# Listar tarjetas de sonido
aplay -l                                # dispositivos de reproducción
arecord -l                              # dispositivos de grabación
cat /proc/asound/cards                  # tarjetas detectadas por el kernel
lspci | grep -i audio                   # tarjeta PCI
lsusb | grep -i audio                   # dispositivos USB de audio

# Información detallada de una tarjeta
cat /proc/asound/card0/codec#0 | head -20
```

### Comandos ALSA útiles

```bash
# Mezclador de volumen en terminal
alsamixer                               # navegar con flechas, M para silenciar
# F6 → cambiar tarjeta, F3 → playback, F4 → capture

# Subir/bajar volumen desde terminal
amixer scontrols                         # listar nombres de controles disponibles
amixer set Master 80%                   # volumen al 80% (o "PCM" si Master no existe)
amixer set Master 5%+                   # subir 5%
amixer set Master 5%-                   # bajar 5%
amixer set Master toggle                # mute/unmute
# ⚠️  En tarjetas USB/HDMI el control puede llamarse "PCM" o "Headphone"
# Usa alsamixer o amixer scontrols para ver el nombre exacto

# Probar sonido directo (sin PulseAudio/PipeWire)
speaker-test -t sine -f 440 -l 1        # tono de 440Hz
aplay /usr/share/sounds/alsa/Front_Center.wav

# Grabar audio directo desde ALSA
arecord -d 5 -f cd test.wav             # grabar 5 segundos, formato CD
```

### Archivos de configuración

```bash
cat /etc/asound.conf                     # configuración global
cat ~/.asoundrc                          # configuración por usuario
# Se usa para: definir dispositivo por defecto, configurar dmix (mezcla por software)
```

### dmix (software mixing)

Por defecto ALSA solo permite que **una** app reproduzca a la vez. `dmix` es un plugin que permite mezcla por software:

```bash
# Verificar si dmix está activo
cat /proc/asound/card0/pcm0p/sub0/hw_params
# Si ves "dmix" en la configuración, está activo
```

En la práctica, si usas PulseAudio o PipeWire, **dmix no hace falta** — ellos ya gestionan la mezcla.

---

## PulseAudio

**Servidor de sonido** que se sitúa entre las aplicaciones y ALSA. Permite:
- Múltiples apps reproduciendo a la vez (mezcla)
- Routing flexible (app A → auriculares, app B → HDMI)
- Control de volumen por aplicación
- Streaming de red (módulo `module-raop-discover` para AirPlay, `module-simple-protocol-tcp` para streaming)

PulseAudio fue el estándar de facto durante ~15 años. Hoy está siendo reemplazado por **PipeWire**, pero sigue siendo el backend en distros antiguas (Ubuntu < 22.04, Debian < 12, etc.).

### Comandos útiles

```bash
# Información
pactl info                               # servidor, formato por defecto, sinks
pactl list sinks short                   # dispositivos de salida disponibles
pactl list sources short                 # dispositivos de entrada (micrófonos)
pactl list clients                       # aplicaciones conectadas al servidor

# Volumen
pactl set-sink-volume 0 80%              # volumen del sink 0 al 80%
pactl set-sink-mute 0 toggle             # mute/unmute del sink 0
pactl set-source-volume 0 70%            # volumen del micrófono

# Mover una app a otro dispositivo de salida
pactl move-sink-input <ID> <sink-name>   # ID del cliente, nombre del sink destino

# Aplicación por defecto (salida)
pavucontrol                              # GUI para gestionar todo lo anterior
```

### Solucionar problemas comunes de PulseAudio

```bash
# PulseAudio no arranca
pulseaudio --start                       # iniciar manualmente
pulseaudio -k                            # matar (se reinicia solo después)

# Resetear configuración de PulseAudio (para empezar de cero)
rm -rf ~/.config/pulse/
pulseaudio -k

# Ver logs de PulseAudio
pulseaudio --log-target=stderr           # log en terminal

# Desactivar PulseAudio temporalmente (para probar ALSA directo)
pasuspender -- speaker-test -t sine -f 440
```

### Módulos de PulseAudio

PulseAudio funciona con módulos que se cargan desde `/etc/pulse/default.pa`:

```bash
# Cargar un módulo manualmente
pactl load-module module-echo-cancel     # cancelación de eco (útil para micrófono)
pactl load-module module-loopback latency_msec=20  # loopback con latencia controlada
```

---

## PipeWire

**El reemplazo moderno** de PulseAudio y JACK. Sirve para audio, video y captura de pantalla en Wayland. Es el estándar actual en: Fedora, Arch, Ubuntu 23.04+, Debian 12+.

**Ventajas clave**: menor latencia que PulseAudio, menor consumo de RAM, manejo unificado audio+video, compatible con apps PulseAudio y JACK sin configuración adicional.

### Comandos básicos

```bash
# Estado y control de volumen
wpctl status                             # sinks, sources, volumen
wpctl set-volume @DEFAULT_SINK@ 0.8      # 80%
wpctl set-mute @DEFAULT_SINK@ toggle     # mute/unmute

# Información detallada
pw-cli list-objects | grep -A 10 'node.name'
```

### Diagnóstico rápido

```bash
systemctl --user status pipewire pipewire-pulse
journalctl --user -u pipewire -f          # logs en vivo
systemctl --user restart pipewire wireplumber  # reiniciar stack
```

> Para información completa sobre PipeWire (configuración, herramientas GUI, latencia, ecualización, comparativa con PulseAudio y JACK) → [[PipeWire]]

---

## JACK (JACK Audio Connection Kit)

Para **audio profesional**: baja latencia, conexión flexible entre apps (patchbay), ideal para producción musical. No reemplaza a PulseAudio/PipeWire para uso diario, sino que se usa **además**.

Con PipeWire, **no hace falta instalar JACK por separado**: PipeWire es compatible con JACK a través de `pipewire-jack`.

```bash
# Apps JACK funcionando sobre PipeWire
# Solo instalar el puente:
sudo apt install pipewire-jack          # Debian/Ubuntu
sudo pacman -S pipewire-jack            # Arch
```

---

## Flujo de diagnóstico (\"no hay sonido\")

```
1. ¿El hardware está detectado?
   aplay -l  →  ¿muestra tu tarjeta?
   ├── No → problema de kernel/drivers
   │        lspci | grep -i audio
   │        dmesg | grep -i snd
   └── Sí → siguiente

2. ¿El servidor de sonido está corriendo?
   systemctl --user status pipewire  (o pulseaudio)
   ├── No → systemctl --user start pipewire
   └── Sí → siguiente

3. ¿El volumen no está al 0 o muted?
   wpctl status   (o pactl list sinks)
   alsamixer      (verificar Master y PCM no estén en MM)
   ├── Muted → desmutear
   └── OK → siguiente

4. ¿El sink por defecto es el correcto?
   wpctl status   → DEFAULT SINK
   ├── No → wpctl set-default <ID>
   └── Sí → siguiente

5. ¿La app está usando el dispositivo correcto?
   pavucontrol → pestaña Playback
   ├── La app sale por otro dispositivo → mover a sink correcto
   └── No aparece → la app usa ALSA directo y dmix no está configurado
```

## Comparativa rápida

| Característica | ALSA | PulseAudio | PipeWire |
|---|---|---|---|
| **Capa** | Kernel | Servidor de sonido | Servidor multimedia |
| **Mezcla múltiples apps** | ❌ (sin dmix) | ✅ | ✅ |
| **Routing por app** | ❌ | ✅ | ✅ |
| **Latencia** | Muy baja | Media | Baja |
| **Compatibilidad JACK** | ❌ | ❌ | ✅ (nativa) |
| **Captura pantalla Wayland** | ❌ | ❌ | ✅ |
| **Consumo RAM** | ~0 MB | ~30-50 MB | ~20-30 MB |
| **¿Sigue en uso?** | Sí (base del kernel) | Sí (legacy) | Sí (estándar actual) |

## Ver también

- [[Sin sonido]] — troubleshooting específico paso a paso
- [[Procesos y Senales]] — gestión de procesos de audio
- [[systemd]] — unit de usuario para pipewire
- [[Wayland vs X11]] — PipeWire necesario para compartir pantalla en Wayland
- [[Redes Basicas]] — streaming de audio por red

## Enlaces externos

- [Wikipedia — ALSA](https://en.wikipedia.org/wiki/Advanced_Linux_Sound_Architecture)
- [Wikipedia — PipeWire](https://en.wikipedia.org/wiki/PipeWire)
- [Wikipedia — PulseAudio](https://en.wikipedia.org/wiki/PulseAudio)
- [Arch Wiki — Professional audio](https://wiki.archlinux.org/title/Professional_audio)

#sistema
#audio