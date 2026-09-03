---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: concepto
prioridad: media
---

# Gestión de energía y batería

> Configuración de ahorro de energía en portátiles Linux: TLP, powertop, auto-cpufreq, powerprofilesctl, umbrales de batería, suspend/hibernate y optimización del hardware para maximizar la autonomía.

## Qué es

La gestión de energía en Linux combina herramientas del kernel (ACPI, cpufreq, runtime PM) con daemons de usuariospace (TLP, powertop, power-profiles-daemon) que ajustan automáticamente CPU governors, dispositivos PCI, USB autosuspend y brillo de pantalla para maximizar la duración de la batería.

## Herramientas principales

| Herramienta | Tipo | Enfoque | Instalación |
|---|---|---|---|
| **TLP** | Daemon automático | Configuración completa de ahorro | `sudo apt install tlp tlp-rdw` |
| **powertop** | Diagnóstico + auto-tune | Análisis de consumo y auto-optimización | `sudo apt install powertop` |
| **auto-cpufreq** | Daemon automático | CPU governor dinámico | `sudo apt install auto-cpufreq` |
| **power-profiles-daemon** | Daemon (GNOME/KDE) | Perfiles de potencia integrado | `sudo apt install power-profiles-daemon` |
| **cpupower** | CLI | Control manual de CPU frequency | `sudo apt install linux-cpupower` |

> **⚠️ Regla de oro:** No usar TLP + powertop auto-tune + auto-cpufreq + power-profiles-daemon simultáneamente — se pisan entre sí. Elegir **una** estrategia principal.

## TLP — El daemon más completo

TLP es la solución más madura para laptops. Configura automáticamente CPU, disk, WiFi, USB y más sin intervención manual.

### Instalación

```bash
# Debian/Ubuntu
sudo apt install tlp tlp-rdw

# Arch
sudo pacman -S tlp tlp-rdw

# Fedora
sudo dnf install tlp tlp-rdw

# Activar e iniciar
sudo systemctl enable --now tlp
```

### Configuración básica (`/etc/tlp.conf`)

```bash
# ── CPU ──
CPU_SCALING_GOVERNOR_ON_AC=performance   # rendimiento con cargador
CPU_SCALING_GOVERNOR_ON_BAT=powersave    # ahorro en batería
CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power

# ── WiFi ──
WIFI_PWR_ON_AC=off          # desactivar ahorro WiFi con cargador
WIFI_PWR_ON_BAT=on          # activar ahorro WiFi en batería

# ── USB ──
USB_AUTOSUSPEND=1           # autosuspend de USB (1=activado)
USB_EXCLUDE_BTUSB=1         # excluir Bluetooth de autosuspend

# ── Disco ──
DISK_APM_LEVEL_ON_AC=254    # energía máxima con cargador
DISK_ASM_LEVEL_ON_BAT=128   # ahorro en batería
DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wwan"

# ── Pantalla ──
DESKTOP_NICE_LEVEL=-5       # prioridad del escritorio en batería

# ── Runtime PM (PCI) ──
RUNTIME_PM_ON_AC=auto
RUNTIME_PM_ON_BAT=auto
```

### Comandos TLP

```bash
sudo tlp start               # iniciar TLP manualmente
sudo tlp-stat                # estado completo del sistema
sudo tlp-stat -s             # resumen de energía
sudo tlp-stat -b             # estado de la batería
sudo tlp-stat -t             # temperatura
sudo tlp-stat -p             # estado de energía (PCI/Runtime PM)
sudo tlp-stat -c             # configuración activa
```

## powertop — Análisis de consumo

powertop diagnostica qué consume energía y puede auto-optimizar.

### Instalación

```bash
sudo apt install powertop     # Debian/Ubuntu
sudo pacman -S powertop       # Arch
```

### Uso

```bash
sudo powertop                 # vista interactiva
sudo powertop --html          # generar informe HTML
sudo powertop --auto-tune     # aplicar optimizaciones automáticamente
```

### Auto-tune permanente

```bash
sudo tee /etc/systemd/system/powertop.service << 'EOF'
[Unit]
Description=PowerTOP auto-tune
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable --now powertop
```

### Interpretar powertop

| Columna | Qué significa |
|---|---|
| **Package** | Consumo del CPU (C-states: C0=activo, C6=máximo ahorro) |
| **Device** | Consumo por dispositivo (WiFi, USB, disco) |
| **Process** | Consumo por proceso (top consumers) |
| **Tunables** | Qué se puede optimizar (Good/Bad) |

## auto-cpufreq — CPU dinámico

Gestiona el governor de CPU automáticamente basándose en la carga.

### Instalación

```bash
# Clonar e instalar
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq --install

# O desde repos
sudo apt install auto-cpufreq    # Debian/Ubuntu
```

### Uso

```bash
sudo auto-cpufreq --install      # instalar y activar daemon
sudo auto-cpufreq --remove       # desinstalar
auto-cpufreq --get                # ver config actual
auto-cpufreq --stats              # estadísticas en vivo
```

## power-profiles-daemon — Perfiles moderno (GNOME/KDE)

El daemon integrado en GNOME 42+ y KDE Plasma. Más ligero que TLP.

```bash
# Ver perfiles disponibles
powerprofilesctl get

# Cambiar perfil
power-profiles-daemon set-profile balanced
power-profiles-daemon set-profile power-saver
power-profiles-daemon set-profile performance

# Listar perfiles
powerprofilesctl list

# Ver energía actual
powerprofilesctl get
```

### Perfiles disponibles

| Perfil | Comportamiento |
|---|---|
| `balanced` | Balance entre rendimiento y batería (default) |
| `power-saver` | Máximo ahorro, CPU más lenta |
| `performance` | Máximo rendimiento, CPU más rápida |

### Integración con GNOME/KDE

GNOME muestra un interruptor "Modo de energía" en el menú rápido (battery icon). KDE tiene "Gestión de energía" en Ajustes.

## Umbrales de batería (battery thresholds)

Controlar a qué porcentaje carga y descarga la batería para prolongar su vida útil.

### TLP

```bash
# En /etc/tlp.conf
START_CHARGE_THRESH_BAT0=40     # empezar a cargar al 40%
STOP_CHARGE_THRESH_BAT0=80      # parar de cargar al 80%
```

### thinkpad-acpi (ThinkPads)

```bash
# Ver umbral actual
cat /sys/class/power_supply/BAT0/charge_control_start
cat /sys/class/power_supply/BAT0/charge_control_end

# Establecer umbrales (temporal)
echo 40 | sudo tee /sys/class/power_supply/BAT0/charge_control_start
echo 80 | sudo tee /sys/class/power_supply/BAT0/charge_control_end

# Permanente con udev rule
sudo tee /etc/udev/rules.d/90-battery-thresholds.rules << 'EOF'
SUBSYSTEM=="power_supply", ATTR{charge_control_start}="40", ATTR{charge_control_end}="80"
EOF
```

### Acer / ASUS / Dell

Algunos fabricantes tienen sus propios módulos del kernel. Verificar:

```bash
# Buscar módulos de batería
lsmod | grep battery
ls /sys/class/power_supply/
cat /sys/class/power_supply/BAT0/charge_control_end 2>/dev/null
```

## Suspend / Hibernate

### Suspender (suspend-to-RAM)

```bash
# GNOME
systemctl suspend

# Atajo: cerrar tapa del portátil (configurable en Ajustes → Energía)

# Verificar que funciona
journalctl | grep -i suspend
```

### Hibernar (suspend-to-disk)

```bash
# Requiere partición swap igual o mayor a la RAM
sudo swapoff /dev/sda2
sudo dd if=/dev/zero of=/dev/sda2 bs=1M
sudo mkswap /dev/sda2
sudo swapon /dev/sda2

# Activar hibernación en GRUB
# En /etc/default/grub:
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=/dev/sda2"
sudo update-grub

# Hibernar
sudo systemctl hibernate

# Verificar que la partición swap es suficiente
free -h | grep Swap
lsblk /dev/sda2
```

### Hybrid Sleep (suspend + hibernate)

```bash
# En /etc/systemd/sleep.conf
[Sleep]
HibernateMode=platform shutdown
HibernateDelaySec=180min

# HibernateDelaySec: tiempo antes de pasar de suspend a hibernate
```

### Configurar tapa del portátil

```bash
# GNOME
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'suspend'
gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action 'suspend'

# KDE
# Ajustes → Energía → Cuando se cierra la tapa → Suspender
```

## Brillo de pantalla

```bash
# Ver brillo actual
cat /sys/class/backlight/*/brightness

# Cambiar brillo (temporal)
echo 500 | sudo tee /sys/class/backlight/intel_backlight/brightness

# Con brightnessctl (recomendado)
sudo apt install brightnessctl
brightnessctl set 50%          # establecer al 50%
brightnessctl set +10%         # aumentar 10%
brightnessctl set 10%-         # disminuir 10%
brightnessctl max              # brillo máximo

# Integrado en GNOME/KDE
# Super → menú rápido → slider de brillo
```

## Monitorización de batería

```bash
# Estado de batería
upower -i /org/freedesktop/UPower/devices/battery_BAT0

# Consumo en tiempo real
sudo powertop

# Historial de batería (GNOME)
gnome-power-statistics

# Batería con TLP
sudo tlp-stat -b
```

## Optimización por hardware

### SSD

```bash
# TRIM automático (mantener disco rápido)
sudo systemctl enable --now fstrim.timer

# Verificar
sudo fstrim -av
```

### WiFi

```bash
# Power save en WiFi
sudo iw dev wlan0 set power_save on    # activar
sudo iw dev wlan0 set power_save off   # desactivar
sudo iw dev wlan0 get power_save       # ver estado
```

### GPU

```bash
# NVIDIA — battery mode
sudo nvidia-smi -pl 50               # limitar potencia GPU

# Intel — RC6 (render standby)
cat /sys/class/drm/card0/device/power/rc6_enable

# AMD — power dpm
cat /sys/class/drm/card0/device/power_dpm_state
```

## Tabla de configuración por perfil

| Parámetro | Con cargador | En batería |
|---|---|---|
| CPU governor | `performance` | `powersave` |
| WiFi power save | `off` | `on` |
| USB autosuspend | `off` | `on` |
| Screen brightness | 100% | Auto (50-80%) |
| Disk APM | 254 (max) | 128 (balanced) |
| Runtime PM PCI | `auto` | `auto` |
| NVMe controller | `max_performance` | `min_power` |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Batería no carga al 100% | Umbrales configurados en TLP o BIOS | Verificar `sudo tlp-stat -b` y ajustar umbrales |
| Sistema no suspende | Driver no compatible o servicio bloqueando | `sudo systemctl mask sleep.target suspend.target` y des-`mask` tras diagnosticar |
| Sistema no hiberna | Falta swap suficiente o resume= no configurado | Verificar swap ≥ RAM y configurar `resume=` en GRUB |
| TLP y powertop se pisan | Ambos intentan optimizar | Usar solo TLP (deshabilitar powertop auto-tune) |
| Consumo alto en batería | Dispositivos PCI sin runtime PM | `sudo powertop --auto-tune` y verificar en powertop |
| Batería se degrada rápido | Cargando al 100% constantemente | Configurar umbrales 40-80% con TLP |
| WiFi se desconecta en batería | Power save demasiado agresivo | `iw dev wlan0 set power_save off` o excluir en TLP |
| Brillo no cambia | Driver backlight no detectado | Probar `acpi_backlight=vendor` o `native` en kernel params |

## Ver también

- [[Optimización de rendimiento]] — tuning general del sistema
- [[systemd]] — gestión de servicios (suspend, hibernate)
- [[systemctl]] — comandos de gestión de energía
- [[Proc y Sys]] — parámetros del kernel en /proc y /sys
- [[Btrfs]] · [[snapper]] — snapshots para rollback antes de cambios de kernel
- [[CachyOS]] — distro con optimización de energía integrada

## Enlaces externos

- [Arch Wiki — Power management](https://wiki.archlinux.org/title/Power_management)
- [Arch Wiki — TLP](https://wiki.archlinux.org/title/TLP)
- [Arch Wiki — PowerTOP](https://wiki.archlinux.org/title/PowerTOP)
- [TLP — Documentation](https://linrunner.de/tlp/)
- [powertop — Intel](https://01.org/powertop)
- [auto-cpufreq — GitHub](https://github.com/AdnanHodzic/auto-cpufreq)
- [power-profiles-daemon — freedesktop](https://gitlab.freedesktop.org/hadess/power-profiles-daemon)

#concepto #energia #laptop #bateria
