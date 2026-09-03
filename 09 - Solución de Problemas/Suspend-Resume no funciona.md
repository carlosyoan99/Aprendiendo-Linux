---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: troubleshooting
prioridad: alta
---

# Suspend/Resume no funciona

> La laptop no suspende al cerrar la tapa, se despierta sola, o al reanudar la pantalla queda negra, el teclado no responde, o el sistema se reinicia en vez de reanudar. Las causas van desde ACPI mal configurado hasta drivers que no manejan el ciclo suspend-resume.

## Síntoma

- Al cerrar la tapa, el sistema no suspende (queda encendido) o se apaga en vez de suspender.
- El sistema se despierta solo sin motivo (teclado, mouse, red, RTC).
- Al reanudar: pantalla negra, teclado/mouse no responde, o solo se ve el cursor.
- Al reanudar: el sistema se reinicia en vez de continuar donde estaba.
- `systemctl suspend` no hace nada o devuelve error.
- WiFi o audio no funcionan tras reanudar.
- El sistema entra en suspend pero no puede salir (hard freeze).

## Diagnóstico

```bash
# 1. ¿Qué soporte de suspend tiene el hardware?
sudo dmesg | grep -iE "suspend|freeze|sleep|PM:|s2idle|deep"
cat /sys/power/state                          # states disponibles: freeze, standby, mem, disk
cat /sys/power/mem_sleep                      # s2idle o deep?
cat /sys/power/disk                           # si soporta hibernate

# 2. ¿Qué causó la última reanudada (o fallo)?
sudo journalctl -b -1 | grep -iE "PM:|suspend|resume|freeze|wakeup" | tail -30
sudo journalctl -b | grep -iE "PM:|suspend|resume|freeze|wakeup" | tail -30

# 3. ¿Qué despertó el sistema?
cat /proc/acpi/wakeup                         # dispositivos con wakeup habilitado (enabled/disabled)
for f in /sys/bus/pci/devices/*/power/wakeup; do
  echo "$(dirname $f | xargs basename): $(cat $f)"
done

# 4. Verificar systemd-logind
sudo systemctl status systemd-logind
grep -i "lid\|suspend\|hibernate\|idle" /etc/systemd/logind.conf

# 5. Verificar TLP / power management
sudo tlp-stat -s                              # estado de TLP
sudo tlp-stat -r                              # runtime PM

# 6. Verificar drivers problemáticos
lspci -k | grep -A 3 -i vga                  # GPU driver (NVIDIA problemático)
lsmod | grep -E "nvidia|nouveau|amdgpu|i915"
dmesg | grep -iE "nvidia.*error|amdgpu.*error" | tail -5

# 7. Test manual de suspend
sudo systemctl suspend                        # intentar suspender
# Si falla, ver logs inmediatamente:
sudo journalctl -f                            # en otra terminal
```

### Logs relevantes

```bash
# Logs de PM (Power Management)
sudo journalctl -b | grep -iE "PM:|suspend|resume|freeze|wakeup|s2idle|deep" | tail -40

# Último intento de suspend fallido
sudo journalctl -b -1 | grep -iE "PM:|suspend|resume|freeze|error|fail" | tail -30

# Errores ACPI
dmesg | grep -iE "acpi|error" | tail -20

# Log de TLP
sudo tlp-stat -l                              # último event log

# Verificar si el kernel reportó errores de PM
sudo dmesg | grep -i "failed to suspend\|suspend failed\|resume failed"
```

## Causa

1. **Driver NVIDIA proprietary** — el driver NVIDIA no maneja bien el suspend/resume, especialmente en laptops híbridas (Optimus). Es la causa #1 en laptops con NVIDIA.
2. **Dispositivo ACPI despierta el sistema** — teclado, mouse, Ethernet, RTC o USB configurados para "wakeup" en `/proc/acpi/wakeup`.
3. **Systemd-logind mal configurado** — `HandleLidSwitch` no definido o conflicto con TLP/GNOME/KDE power management.
4. **Wayland + GPU** — algunos compositor Wayland tienen bugs con suspend en ciertas GPUs.
5. **Firmware BIOS buggy** — el ACPI del fabricante tiene implementación incompleta o incorrecta.
6. **Módulo del kernel no soporta PM** — módulo USB, WiFi o GPU sin callbacks de suspend/resume.
7. **Swap insuficiente o ausente** — para hibernate se necesita swap >= RAM.

## Solución

### Caso 1: NVIDIA — pantalla negra al reanudar (el más común)

```bash
# Opción A: Usar Nouveau en vez de NVIDIA (más estable en PM)
sudo apt purge 'nvidia-*'                     # Debian/Ubuntu
sudo pacman -Rns nvidia-utils nvidia          # Arch
sudo apt install xserver-xorg-video-nouveau
sudo reboot

# Opción B: Mantener NVIDIA pero configurar PM correctamente
# En /etc/modprobe.d/nvidia.conf:
#   options nvidia NVreg_PreserveVideoMemoryAllocations=1
#   options nvidia NVreg_TemporaryFilePath=/var/tmp
#   options nvidia-drm fbdev=1
sudo update-initramfs -u
sudo systemctl enable nvidia-suspend.service nvidia-resume.service nvidia-hibernate.service

# Opción C: Desactivar suspensión completely (workaround)
# En /etc/systemd/sleep.conf:
#   [Sleep]
#   AllowSuspend=no
#   AllowHibernation=no
#   AllowHybridSleep=no
#   AllowSuspendThenHibernate=no
```

### Caso 2: sistema se despierta solo

```bash
# Ver qué dispositivos pueden despertar el sistema
cat /proc/acpi/wakeup

# Desactivar wakeup para dispositivos problemáticos
# Ejemplo: desactivar wakeup por USB y Ethernet
echo "XHC" | sudo tee /proc/acpi/wakeup       # USB (XHCI)
echo "GLAN" | sudo tee /proc/acpi/wakeup      # Ethernet
echo "XGBE" | sudo tee /proc/acpi/wakeup      # Ethernet 2.5G

# Para hacerlo permanente, crear udev rule o systemd unit:
sudo tee /etc/systemd/system/disable-wakeup.service << 'EOF'
[Unit]
Description=Disable wakeup devices
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'for dev in XHC GLAN XGBE EHC; do echo $dev > /proc/acpi/wakeup; done'

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable disable-wakeup.service
```

### Caso 3: lid switch no funciona (tapas)

```bash
# Verificar configuración de logind
grep -v "^#\|^$" /etc/systemd/logind.conf

# Configurar para laptops:
sudo nano /etc/systemd/logind.conf
# [Login]
# HandleLidSwitch=suspend          # suspender al cerrar tapa
# HandleLidSwitchExternalPower=suspend  # con cargador
# HandleLidSwitchDocked=ignore     # docking station
# LidSwitchIgnoreInhibited=yes     # ignorar inhibitorios
sudo systemctl restart systemd-logind

# Si TLP conflicta con logind:
# En /etc/tlp.conf:
#   SUSPEND_METHOD="systemd"        # usar systemd en vez de TLP para suspend
sudo tlp start
```

### Caso 4: teclado/mouse no responden tras reanudar

```bash
# Reiniciar módulos USB
sudo modprobe -r xhci_pci && sudo modprobe xhci_pci   # USB 3.x
sudo modprobe -r ehci_pci && sudo modprobe ehci_pci    # USB 2.0

# O reiniciar servicios de input
sudo systemctl restart systemd-logind
sudo systemctl restart gdm3  # o sddm, lightdm

# Para mouse/libinput:
sudo modprobe -r hid_generic && sudo modprobe hid_generic
```

### Caso 5: WiFi no funciona tras reanudar

```bash
# Reiniciar módulo WiFi
sudo modprobe -r iwlwifi && sudo modprobe iwlwifi      # Intel
sudo modprobe -r ath9k && sudo modprobe ath9k          # Atheros

# Crear servicio systemd para reanudar WiFi
sudo tee /etc/systemd/system/wifi-resume.service << 'EOF'
[Unit]
Description=WiFi resume
After=suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
Before=network-pre.target

[Service]
Type=oneshot
ExecStart=/sbin/modprobe -r iwlwifi
ExecStart=/sbin/modprobe iwlwifi

[Install]
WantedBy=suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
EOF
sudo systemctl enable wifi-resume.service
```

### Caso 6: sistema se reinicia en vez de reanudar

```bash
# Causa: kernel panic durante resume o swap insuficiente

# Verificar swap
sudo swapon --show
free -h
# Si no hay swap o es menor que RAM:
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Verificar logs del reinicio
sudo journalctl -b -1 | grep -iE "panic|resume.*fail|oom" | tail -10

# Si el problema es NVIDIA:
# Añadir al kernel: nvidia.power_check=0
# En GRUB: nomodeset (temporal)
```

### Verificación

```bash
# Test completo de suspend/resume:
sudo systemctl suspend
# Esperar 10 segundos
# Reanudar (botón power o abrir tapa)
# Verificar:
uname -r                                      # sistema sigue corriendo
date                                          # hora correcta
nmcli connection show --active                # WiFi reconectado
aplay -l                                      # audio presente
xrandr                                        # pantalla correcta
```

## Escenarios / Variantes

| Variante / Síntoma | Causa típica | Solución rápida |
|---|---|---|
| **Pantalla negra al reanudar** (NVIDIA) | Driver NVIDIA sin PM | `nvidia-drm fbdev=1` en modprobe + servicios nvidia-suspend/resume |
| **Se despierta solo cada pocos minutos** | Dispositivo ACPI wakeup habilitado | `cat /proc/acpi/wakeup` → desactivar enabled |
| **Tapas no suspenden** | logind.conf sin HandleLidSwitch | Configurar `HandleLidSwitch=suspend` en logind.conf |
| **Reinicia en vez de reanudar** | Swap insuficiente o kernel panic en resume | Aumentar swap, verificar logs del boot anterior |
| **Audio muere tras reanudar** | PulseAudio/PipeWire no reanuda | `systemctl --user restart pipewire` o `pulseaudio -k` |
| **Bluetooth no funciona tras reanudar** | Módulo btusb no se reinicia | `sudo modprobe -r btusb && sudo modprobe btusb` |
| **Hibernate no disponible** | Sin swap o swap menor que RAM | Crear swapfile >= RAM, añadir `resume=` al kernel |
| **suspend-then-hibernate no funciona** | systemd no configurado | En `/etc/systemd/sleep.conf`: `HibernateDelaySec=3600` |

## Prevención

1. **Probar suspend/resume después de instalar la distro** — no asumas que funciona.
2. **Actualizar BIOS/UEFI** del fabricante — muchos fixes de ACPI llegan en actualizaciones de BIOS.
3. **Configurar TLP correctamente** desde el inicio — `SUSPEND_METHOD="systemd"` evita conflictos.
4. **Mantener swap suficiente** — al menos 2GB o igual a RAM si usas hibernate.
5. **Desactivar wakeup innecesario** — revisar `/proc/acpi/wakeup` después de cada actualización de kernel.

## Notas adicionales

- En laptops con NVIDIA Optimus (GPU integrada + dedicada), usar `prime-select` o `envycontrol` para gestionar qué GPU activa puede afectar el suspend.
- Si `systemctl suspend` no hace nada, verifica que `systemd-logind` esté corriendo y que no haya inhibitorios activos: `systemd-inhibit --list`.
- `suspend-then-hibernate` (hybrid sleep) es útil si no quieres configurar hibernate por separado — suspende a RAM y si la batería baja mucho, hibernate a disco.
- En Wayland, algunos compositors (Sway, Hyprland) manejan el suspend de forma diferente a GNOME/KDE — consultar su wiki específica.
- Para servidores, `suspend` generalmente no se usa — se prefiere `hibernate` o simplemente no suspender.

## Enlaces externos

- [Arch Wiki — Power management/Suspend](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate)
- [Arch Wiki — NVIDIA/Troubleshooting](https://wiki.archlinux.org/title/NVIDIA/Troubleshooting)
- [systemd-logind docs](https://www.freedesktop.org/software/systemd/man/logind.conf.html)
- [TLP documentation](https://linrunner.de/tlp/settings/)
- [Ubuntu Wiki — Suspend](https://help.ubuntu.com/community/PowerManagement/Suspend)

## Ver también

- [[Gestión de energía y batería]] — TLP, powertop, configuración de batería
- [[NVIDIA no detecta]] — troubleshooting GPU NVIDIA
- [[USB no detecta]] — USB suspend que afecta dispositivos
- [[WiFi no conecta]] — WiFi tras suspensión
- [[Sistema no arranca]] — si el sistema no reanuda en absoluto

#troubleshooting #power-management #suspend
