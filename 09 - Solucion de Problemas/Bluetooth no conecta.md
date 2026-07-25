---
fecha_creacion: 2026-07-23
estado: resuelto
categoria: troubleshooting
sistema: Bluetooth
prioridad: alta
---

# Bluetooth no conecta / no se empareja

> El dispositivo Bluetooth (auriculares, ratón, teclado) no aparece, no se empareja, o la conexión se cae constantemente.

## Síntoma

- Bluetooth no aparece en la configuración del escritorio
- El adaptador Bluetooth no se detecta (ni siquiera aparece en los ajustes)
- El dispositivo se empareja pero no se conecta (especialmente auriculares)
- El audio por Bluetooth se corta o entrecorta
- El dispositivo aparece pero "Connection failed" o "Device disconnected"
- Solo funciona después de reiniciar `bluetooth.service`

## Diagnóstico

```bash
# 1. ¿El hardware Bluetooth está presente?
lsusb | grep -i bluetooth                  # adaptadores USB
lsusb | grep -i "0a12\|0b05\|8087"         # IDs comunes Intel/MediaTek/Realtek
dmesg | grep -i bluetooth                  # kernel: detección y errores

# 2. ¿El servicio está activo?
systemctl status bluetooth
bluetoothctl show                          # estado del controlador

# 3. Listar dispositivos conocidos y escanear
bluetoothctl
  power on                                 # encender adaptador
  agent on                                 # activar agente de emparejamiento
  default-agent                            # agente por defecto
  scan on                                  # escanear dispositivos cercanos
  devices                                  # listar dispositivos conocidos
  info <MAC>                              # info del dispositivo

# 4. Probar conectividad básica
hciconfig -a                               # info del adaptador (legacy, requiere bluez-utils)
rfkill list                                # ¿bloqueado por software/hardware?
```

### Logs relevantes

```bash
journalctl -u bluetooth -n 50              # últimas 50 líneas del servicio Bluetooth
dmesg | grep -i "bluetooth\|btusb\|btrtl"
```

## Causa

1. **Servicio Bluetooth no iniciado** — `bluetooth.service` puede estar deshabilitado tras la instalación.
2. **rfkill bloquea el hardware** — el interruptor de software bloquea la antena Bluetooth.
3. **Firmware del chipset faltante** — chipsets Intel, Realtek y Broadcom necesitan firmware que no siempre viene incluido.
4. **PulseAudio/PipeWire mal configurado** — los auriculares se emparejan pero el perfil de audio (A2DP vs HSP/HFP) no se carga correctamente.
5. **Módulo del kernel no cargado** — `btusb` es el módulo principal para USB Bluetooth; algunos chipsets necesitan módulos adicionales.
6. **Conflicto con el adaptador WiFi** — ciertos chipsets combinados WiFi+Bluetooth (especialmente en laptops) tienen conflictos de coexistencia.

## Solución

```bash
# 1. Iniciar y habilitar el servicio Bluetooth
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# 2. Desbloquear con rfkill
rfkill list                                # ver qué está bloqueado
sudo rfkill unblock bluetooth              # desbloquear solo Bluetooth
sudo rfkill unblock all                    # desbloquear WiFi + Bluetooth

# 3. Recargar módulos del kernel
sudo modprobe -r btusb && sudo modprobe btusb
# Para chipsets específicos:
sudo modprobe btrtl                        # Realtek
sudo modprobe btbcm                        # Broadcom/Cypress
sudo modprobe btintel                      # Intel

# 4. Emparejar desde terminal (si la GUI falla)
bluetoothctl
  power on
  agent on
  default-agent
  scan on                                  # esperar a que aparezca el dispositivo
  trust <MAC>                              # confiar en el dispositivo
  pair <MAC>                               # emparejar
  connect <MAC>                            # conectar

# 5. Para auriculares: forzar perfil A2DP (audio de alta calidad)
# Con PulseAudio
pactl set-card-profile bluez_card.<MAC> a2dp_sink
# O para siempre: editar /etc/bluetooth/audio.conf
# [General]
# Enable=Source,Sink,Media,Socket

# Con PipeWire (moderno)
# Editar /etc/bluetooth/main.conf:
# AutoEnable=true
```

### Si el audio Bluetooth se corta o entrecorta

```bash
# Solución 1: Desactivar modo batido (experimental)
# En /etc/bluetooth/main.conf:
# Experimental = false

# Solución 2: Cambiar codec (PipeWire)
# Instalar codecs adicionales
sudo apt install libspa-0.2-bluetooth     # Debian/Ubuntu
sudo pacman -S pipewire-aptx              # Arch (AUR)

# Solución 3: Desconectar otros dispositivos USB 3.0 cercanos
# La interferencia electromagnética USB 3.0 afecta Bluetooth 2.4GHz
```

### Verificación

```bash
bluetoothctl show                         # Powered: yes, Discovering: no
bluetoothctl devices                      # dispositivo listado
bluetoothctl info <MAC>                   # Connected: yes, Trusted: yes
pactl list sinks | grep -i bluetooth      # sink de audio Bluetooth disponible
```

## Prevención

- Habilitar `bluetooth.service` con `systemctl enable` desde la instalación
- En laptops, revisar que el interruptor físico (Fn+F* o switch lateral) no apague Bluetooth
- Mantener `bluez` y `bluez-utils` actualizados
- Para escritorios Linux con chipsets Intel, instalar `linux-firmware` completo
- Usar PipeWire en lugar de PulseAudio para mejor soporte de códecs Bluetooth modernos (LDAC, aptX, AAC)

## Enlaces externos

- [Arch Wiki — Bluetooth](https://wiki.archlinux.org/title/Bluetooth)
- [Arch Wiki — Bluetooth headset](https://wiki.archlinux.org/title/Bluetooth_headset)
- [Debian Wiki — Bluetooth](https://wiki.debian.org/Bluetooth)
- [Ubuntu Help — Bluetooth](https://help.ubuntu.com/stable/ubuntu-help/bluetooth.html)

## Ver también

- [[Redes Basicas]] — configuración de red y conectividad
- [[Audio en Linux]] — gestión de audio (PulseAudio/PipeWire)
- [[WiFi no conecta]] — problemas de conectividad inalámbrica

#troubleshooting
