---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: troubleshooting
sistema: PipeWire / PulseAudio
prioridad: alta
---

# Sin sonido (audio no funciona)

> No hay salida de audio en altavoces, auriculares ni HDMI. La causa puede estar en el servidor de audio, los canales de hardware, el módulo del kernel o la configuración del sink.

## Síntoma

- No se escucha nada al reproducir audio (música, vídeos, notificaciones del sistema).
- El ícono de volumen aparece en la bandeja sin indicar error.
- `pactl info` muestra un servidor de audio en ejecución pero los tests de sonido no se oyen.
- O bien: `systemctl --user status pipewire` muestra el servicio **failed** o **inactive**.

## Diagnóstico

```bash
# 1. ¿El servidor de audio está corriendo?
pactl info                                 # info del servidor (PipeWire o PulseAudio)
systemctl --user status pipewire           # PipeWire (moderno)
systemctl --user status pulseaudio         # PulseAudio (legacy)

# 2. ¿Hay dispositivos de salida (sinks)?
pactl list sinks short                     # listar salidas
pactl list sinks | grep -E "Name:|State:"  # ver estado de cada sink

# 3. ¿El volumen no está al mínimo?
pavucontrol                                # mezclador gráfico
alsamixer                                  # controles de hardware ALSA
amixer                                     # desde terminal, sin interfaz gráfica

# 4. ¿La tarjeta de sonido es detectada por el kernel?
lspci -v | grep -i audio                   # tarjeta PCIe (Intel HDA, Realtek, etc.)
lsusb | grep -i audio                      # dispositivos USB (DAC, auriculares USB)
aplay -l                                   # lista de dispositivos de reproducción ALSA
arecord -l                                 # lista de dispositivos de grabación

# 5. ¿El módulo de kernel está cargado?
lsmod | grep -iE "snd|hda|sof"            # módulos de audio cargados
dmesg | grep -iE "snd|hda|sof"            # errores de audio en el kernel
```

### Logs relevantes

```bash
# Logs del servidor de audio
journalctl --user -u pipewire --no-pager -n 30
journalctl --user -u pipewire-pulse --no-pager -n 30
journalctl --user -u pulseaudio --no-pager -n 30    # legacy

# Errores del kernel relacionados con audio
dmesg | grep -iE "snd|hda|sof|audio" | tail -20

# Verificar si hay conflicto de módulos
dmesg | grep -i "conflict.*audio\|audio.*conflict"
```

## Causa

1. **Servidor de audio caído** — PipeWire o PulseAudio no se iniciaron o crashearon.
2. **Salida incorrecta (sink equivocado)** — el sistema envía audio al dispositivo HDMI cuando quieres auriculares, o viceversa.
3. **ALSA muteado** — el canal de hardware está silenciado en `alsamixer` (muestra `MM`).
4. **PipeWire no configurado tras migración** — después de instalar PipeWire sobre PulseAudio, falta activar `pipewire-pulse`.
5. **Módulo del kernel incorrecto o no cargado** — laptops con audio Intel necesitan el módulo `snd_hda_intel` o `sof-audio-pci`; algunas requieren parámetros específicos.
6. **Dispositivo de audio ocupado exclusivamente** — otro proceso acaparó el dispositivo (ej: HDMI de una gráfica NVIDIA como sink por defecto).

## Solución

```bash
# 1. Reiniciar servidor de audio
systemctl --user restart pipewire
systemctl --user restart pipewire-pulse    # capa de compatibilidad PulseAudio

# 2. Ver sinks disponibles y cambiar el predeterminado
pactl list sinks short                     # listar IDs y nombres
pactl set-default-sink <nombre_del_sink>   # ej: alsa_output.pci-0000_00_1f.3.analog-stereo

# Probar audio después de cada cambio:
speaker-test -t sine -f 440 -l 1          # tono de 1 segundo

# 3. Desmutear canales en ALSA
alsamixer                                  # navegar con ← →, mutear/desmutear con M
# Los canales críticos: Master, Headphone, Speaker, PCM
# "MM" abajo = muteado, "OO" = unmuteado

# Alternativa desde terminal:
amixer set Master unmute
amixer set Headphone unmute
amixer set Speaker unmute
amixer set PCM unmute

# 4. Instalar PipeWire si no está (reemplazo moderno de PulseAudio)
sudo apt install pipewire pipewire-pulse wireplumber   # Debian/Ubuntu
sudo pacman -S pipewire pipewire-pulse wireplumber     # Arch
sudo dnf install pipewire pipewire-pulse wireplumber   # Fedora

# Activar servicios
systemctl --user --now enable pipewire pipewire-pulse wireplumber

# 5. Forzar recarga de módulos del kernel
sudo modprobe -r snd_hda_intel
sudo modprobe snd_hda_intel

# 6. Si hay conflicto entre GPUs NVIDIA y audio integrado:
# Desactivar audio HDMI de NVIDIA (si no lo usas)
sudo modprobe -r snd_hda_intel
sudo modprobe snd_hda_intel enable=0,1     # activar solo la primera tarjeta HDA
```

### Verificación

```bash
# Probar reproducción directa (ignora PulseAudio/PipeWire)
aplay /usr/share/sounds/alsa/Front_Center.wav  # archivo de prueba ALSA
speaker-test -t sine -f 440 -l 1               # tono de 1 segundo

# Verificar que el sink por defecto es correcto
pactl info | grep "Default Sink"

# Probar grabación (si el micrófono también falla)
arecord -d 3 test.wav && aplay test.wav
```

## Escenarios / Variantes

| Variante / Síntoma | Causa | Solución |
|---|---|---|
| **Sonido por HDMI no funciona** | NVIDIA/AMD no envía audio por HDMI, o el sink HDMI no es el predeterminado | `pactl set-default-sink <sink_hdmi>`, o instalar firmware de GPU |
| **Audio USB (DAC) no detectado** | Módulo USB no cargado, o el DAC requiere drivers específicos | Verificar con `lsusb`, `dmesg \| grep USB`, probar otro puerto USB |
| **Sonido con chirridos/ruido** | Buffer insuficiente, freq. de muestreo incorrecta, o problema de energía USB | En PipeWire: editar `~/.config/pipewire/pipewire.conf`, ajustar `default.clock.rate = 48000` |
| **Microfono no funciona** | Source equivocado o muteado | `pactl list sources short`, `pactl set-default-source`, verificar alsamixer |
| **Sin sonido tras actualizar kernel** | DKMS no reconstruyó el módulo de audio | `sudo dkms autoinstall` y reiniciar |
| **PulseAudio (legacy) no arranca** | Conflicto con PipeWire | `systemctl --user mask pulseaudio` y usar solo PipeWire |
| **Sin sonido en una app específica** | App enviando audio al sink equivocado | En pavucontrol, pestaña "Reproducción", cambiar la salida de la app al sink correcto |

## Prevención

1. **Usar PipeWire en lugar de PulseAudio**: PipeWire es el estándar actual y tiene mejor manejo de dispositivos.
2. **Antes de actualizar el kernel**, verificar que los módulos de audio están incluidos (si usas módulos externos como `sof-firmware`).
3. **Si tienes GPU NVIDIA**, considera desactivar su audio HDMI si no usas monitor con altavoces: `sudo modprobe.d/blacklist-nvidia-audio.conf` con `blacklist snd_hda_intel` con el ID correcto.
4. **Mantener `alsa-ucm-conf` actualizado** para perfiles de audio correctos (especialmente en laptops).

## Notas adicionales

- ALSA opera a nivel de kernel y es independiente de PipeWire/PulseAudio. Si `speaker-test` funciona pero el resto no, el problema está en el servidor de audio.
- `wireplumber` es el gestor de sesiones moderno para PipeWire, reemplaza a `pipewire-media-session`.
- En Fedora, PipeWire viene por defecto desde Fedora 34. En Debian/Ubuntu, está disponible desde Debian 12 / Ubuntu 22.04.

## Enlaces externos

- [Arch Wiki — PipeWire](https://wiki.archlinux.org/title/PipeWire)
- [Arch Wiki — PulseAudio/Troubleshooting](https://wiki.archlinux.org/title/PulseAudio/Troubleshooting)
- [Fedora Wiki — Audio troubleshooting](https://fedoraproject.org/wiki/Common_audio_problems)
- [PipeWire Documentation](https://docs.pipewire.org/)
- [ALSA project](https://www.alsa-project.org/wiki/Main_Page)

## Ver también

- [[Audio en Linux]] — arquitectura de audio (ALSA, PulseAudio, PipeWire, JACK)
- [[systemd]] — gestión de servicios de audio
- [[PipeWire]] — servidor de audio moderno
- [[Utilidades Base del Sistema]] — PipeWire como componente base
- [[NVIDIA no detecta]] — audio HDMI vinculado a GPU

#troubleshooting
