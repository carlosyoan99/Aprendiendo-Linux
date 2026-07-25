---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-18
estado: resuelto
categoria: troubleshooting
sistema: PipeWire / PulseAudio
prioridad: alta
---

# Sin sonido (audio no funciona)

## Síntoma

No hay salida de audio: ni altavoces, ni auriculares, ni HDMI. El ícono de volumen aparece correctamente pero no se escucha nada.

## Diagnóstico

```bash
# 1. ¿El servidor de audio está corriendo?
pactl info                                 # info del servidor (PipeWire o PulseAudio)
systemctl --user status pipewire           # PipeWire (moderno)
systemctl --user status pulseaudio         # PulseAudio (legacy)

# 2. ¿Hay dispositivos de salida?
pactl list sinks short                     # listar salidas de audio (sinks)
pactl list sources short                   # listar entradas

# 3. ¿El volumen no está al mínimo?
pavucontrol                                # mezclador gráfico (PipeWire y PulseAudio)
alsamixer                                  # controles de hardware ALSA
amixer                                     # desde terminal

# 4. ¿La tarjeta de sonido es detectada?
lspci -v | grep -i audio                   # tarjeta de sonido PCIe
lsusb | grep -i audio                      # USB audio
aplay -l                                   # dispositivos de reproducción ALSA

# 5. ¿El módulo de kernel está cargado?
lsmod | grep -iE "snd|hda|sof"            # módulos de audio
dmesg | grep -iE "snd|hda|sof"            # errores de audio en el kernel
```

## Causa

1. **Servidor de audio caído** — PipeWire o PulseAudio no se iniciaron correctamente.
2. **Salida incorrecta** — el sistema está enviando audio al dispositivo equivocado (HDMI en vez de auriculares).
3. **ALSA muteado** — el canal de hardware está silenciado en `alsamixer`.
4. **PipeWire no configurado** — después de migrar de PulseAudio a PipeWire falta configurar.
5. **Módulo del kernel incorrecto** — especialmente en laptops con audio Intel SOF (Sound Open Firmware).

## Solución

```bash
# 1. Reiniciar servidor de audio
systemctl --user restart pipewire
systemctl --user restart pipewire-pulse    # capa de compatibilidad PulseAudio

# 2. Verificar y cambiar sink por defecto
pactl set-default-sink <nombre_del_sink>   # ejemplo: alsa_output.pci-0000_00_1f.3.analog-stereo

# 3. Desmutear canales en ALSA
alsamixer                                  # navegar con flechas, M para mutear/desmutear
# Asegurarse de que Master, Headphone y Speaker no tengan "MM" abajo

# 4. Forzar recarga de módulos del kernel
sudo modprobe -r snd_hda_intel && sudo modprobe snd_hda_intel

# 5. Instalar PipeWire si no está (reemplazo moderno de PulseAudio)
sudo apt install pipewire pipewire-pulse   # Debian/Ubuntu
sudo pacman -S pipewire pipewire-pulse     # Arch
sudo dnf install pipewire pipewire-pulse   # Fedora

# 6. Probar reproducción directa con ALSA
speaker-test -t sine -f 440               # tono de prueba (Ctrl+C para salir)
aplay /usr/share/sounds/alsa/Front_Center.wav  # archivo de prueba
```

## Referencias

- [[systemd]] — gestión de servicios de audio
- [[Utilidades Base del Sistema]] — PipeWire como componente base
- Arch Wiki: [PipeWire](https://wiki.archlinux.org/title/PipeWire)
- Fedora Wiki: [Audio troubleshooting](https://fedoraproject.org/wiki/Common_audio_problems)

#troubleshooting
