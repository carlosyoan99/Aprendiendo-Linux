---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: alta
---

# /proc y /sys — Sistemas de archivos virtuales

## Definición

`/proc` y `/sys` son **sistemas de archivos virtuales** — no existen en disco, sino que son interfaces generadas por el kernel en tiempo real que exponen información del sistema (hardware, procesos, kernel) y permiten modificar parámetros en caliente.

| Sistema | Montado en | Propósito principal |
|---|---|---|
| **procfs** | `/proc` | Información de procesos y kernel |
| **sysfs** | `/sys` | Información de dispositivos, drivers y buses |

```bash
# Verificar que están montados
mount | grep -E "proc|sys"              # proc on /proc, sysfs on /sys
df -h | grep -E "proc|sys"              # siempre 0 de uso (son virtuales)
```

## /proc — Información de procesos y kernel

Cada proceso en ejecución tiene una subcarpeta con su PID (`/proc/PID/`) que contiene información sobre el proceso.

```bash
# ── Información del sistema ──
cat /proc/cpuinfo                        # CPU: modelo, núcleos, flags, frecuencia
cat /proc/meminfo                        # RAM: total, libre, buffers, caché
cat /proc/version                        # versión del kernel y compilador
cat /proc/uptime                         # segundos desde el arranque
cat /proc/loadavg                        # load average (1, 5, 15 min)
cat /proc/partitions                     # particiones detectadas

# ── Información de procesos ──
ls /proc/1234/                           # info del proceso con PID 1234
cat /proc/1234/cmdline                   # comando exacto que ejecutó el proceso
cat /proc/1234/status                    # estado, memoria, usuario
ls -l /proc/1234/fd/                     # archivos abiertos (file descriptors)
cat /proc/1234/environ                   # variables de entorno del proceso

# ── Parámetros del kernel (sysctl) ──
cat /proc/sys/net/ipv4/ip_forward        # ¿está habilitado IP forwarding? (0/1)
echo 1 > /proc/sys/net/ipv4/ip_forward   # habilitar IP forwarding (hasta reinicio)
```

### Archivos útiles en /proc (sin PID)

| Archivo | Contenido | Equivalente comando |
|---|---|---|
| `/proc/cpuinfo` | Detalle de cada núcleo CPU | `lscpu` |
| `/proc/meminfo` | Uso de RAM y swap | `free -h` |
| `/proc/uptime` | Tiempo de actividad | `uptime` |
| `/proc/loadavg` | Carga promedio del sistema | `uptime` |
| `/proc/version` | Versión del kernel | `uname -a` |
| `/proc/devices` | Dispositivos con drivers cargados | `lsblk`, `lspci` |
| `/proc/modules` | Módulos del kernel cargados | `lsmod` |
| `/proc/diskstats` | Estadísticas de E/S de disco | `iostat` |
| `/proc/net/tcp` | Conexiones TCP activas | `ss -tln` |
| `/proc/swaps` | Particiones/archivos swap activos | `swapon --show` |

## /sys — Dispositivos, drivers y buses (sysfs)

`/sys` (**sysfs**) expone una visión estructurada del **árbol de dispositivos** del kernel. Fue introducido en Linux 2.6 para solucionar deficiencias del kernel 2.4:

- **Falta de un modelo unificado** para representar relaciones entre controladores y dispositivos
- **Ausencia de mecanismo hotplug estándar**
- **procfs sobrecargado** con información que no es de procesos

Implementado por **Patrick Mochel**, sysfs exporta el modelo de dispositivos del kernel al espacio de usuario. Más organizado que `/proc` pero menos usado directamente (herramientas como `lspci`, `lsusb`, `powertop` leen de aquí).

### Estructura de /sys

| Subdirectorio | Contenido |
|---|---|
| `/sys/devices/` | Árbol físico de dispositivos (relación padre/hijo) |
| `/sys/bus/` | Enlaces simbólicos agrupados por tipo de bus (PCI, USB, etc.) |
| `/sys/class/` | Dispositivos agrupados por clase (net, block, sound, input...) |
| `/sys/block/` | Dispositivos de bloque (discos) |
| `/sys/firmware/` | Información del firmware (EFI, ACPI, DMI) |
| `/sys/module/` | Parámetros de módulos del kernel cargados |
| `/sys/power/` | Estado de energía del sistema |

```bash
# /sys/devices refleja la topología física
ls /sys/devices/                          # CPU, PCI, platform, system, virtual...
ls /sys/devices/pci0000:00/              # todos los dispositivos PCI

# /sys/bus agrupa por tipo de conexión
ls /sys/bus/pci/devices/                 # dispositivos PCI con sus drivers
ls /sys/bus/usb/devices/                 # dispositivos USB

# /sys/class agrupa por funcionalidad
ls /sys/class/net/                       # interfaces de red
ls /sys/class/block/                     # discos
ls /sys/class/sound/                     # tarjetas de sonido
```

```bash
# ── Dispositivos ──
ls /sys/class/                           # clases de dispositivos (block, net, input, sound...)
ls /sys/class/net/                       # interfaces de red
cat /sys/class/net/wlp2s0/address        # MAC address de la WiFi
cat /sys/class/net/eth0/speed            # velocidad de la interfaz (Mbps)
ls /sys/class/block/                     # dispositivos de bloque (discos)
cat /sys/class/block/sda/size            # tamaño del disco en sectores

# ── Energía (laptops) ──
cat /sys/class/power_supply/BAT0/capacity    # porcentaje de batería
cat /sys/class/power_supply/BAT0/status      # Charging / Discharging / Full
cat /sys/class/backlight/intel_backlight/brightness  # brillo actual (se puede escribir)

# ── Dispositivos PCI ──
ls /sys/bus/pci/devices/                 # todos los dispositivos PCI
cat /sys/bus/pci/devices/0000:00:02.0/driver  # driver del dispositivo

# ── USB ──
ls /sys/bus/usb/devices/                 # dispositivos USB conectados
```

### Escribir en /sys (config en caliente)

Algunos archivos en `/sys` son escribibles y permiten cambiar configuración del hardware sin reiniciar:

```bash
# Cambiar brillo de pantalla (laptop)
echo 500 > /sys/class/backlight/intel_backlight/brightness

# Activar/desactivar WiFi
echo 1 > /sys/class/rfkill/rfkill0/soft  # 0=desbloquear, 1=bloquear

# Activar LED del teclado (CapsLock, NumLock)
echo 1 > /sys/class/leds/input3::capslock/brightness
```

## /proc vs /sys — ¿cuándo usar cada uno?

| Situación | Usar |
|---|---|
| Ver info de un proceso (PID) | `/proc/PID/` |
| Configurar parámetros del kernel | `/proc/sys/` (o `sysctl`) |
| Ver info de CPU, RAM, uptime | `/proc/cpuinfo`, `/proc/meminfo`, `/proc/uptime` |
| Ver/enumerar dispositivos por tipo | `/sys/class/` |
| Modificar hardware en caliente | `/sys/class/...` o `/sys/devices/...` |
| Info de energía/batería | `/sys/class/power_supply/` |

## sysctl — la interfaz amigable para /proc/sys

En lugar de escribir directo en `/proc/sys/`, se usa `sysctl`:

```bash
# Leer parámetros
sysctl net.ipv4.ip_forward                # 0 o 1
sysctl vm.swappiness                      # tendencia a usar swap (0-100)

# Escribir (solo sesión actual)
sudo sysctl -w net.ipv4.ip_forward=1

# Persistir cambios
# Editar /etc/sysctl.conf o /etc/sysctl.d/*.conf:
# net.ipv4.ip_forward = 1
net.ipv4.conf.all.rp_filter = 1           # protección IP spoofing
vm.swappiness = 10                        # minimizar uso de swap
```

## Por qué importa

- `/proc/cpuinfo` y `/proc/meminfo` son la fuente de información más directa sobre el hardware — las herramientas gráficas solo leen de aquí.
- Modificar `/proc/sys/` o `/sys/` permite cambiar comportamiento del kernel o hardware **sin reiniciar**, esencial en servidores.
- Entender que estos archivos son virtuales (no ocupan espacio, no están en disco) aclara por qué `du -sh /proc` muestra 0.
- Muchos comandos cotidianos (`ps`, `free`, `uptime`, `lsmod`, `mount`) leen de `/proc` y `/sys` por detrás — saberlo ayuda a diagnosticar cuando una herramienta no está disponible.

## Ver también

- [[Filesystem Hierarchy Standard]] — contexto de dónde queda `/proc` y `/sys` en el árbol
- [[Procesos y Senales]] — los procesos que aparecen en `/proc/PID/`
- [[systemd]] — systemd también expone info en `/sys` y `/proc`
- [[Redes Basicas]] — `/proc/net/` contiene info de red

## Enlaces externos

- [Wikipedia — procfs](https://en.wikipedia.org/wiki/Procfs)
- [Wikipedia — sysfs](https://en.wikipedia.org/wiki/Sysfs)
- [Arch Wiki — /proc](https://wiki.archlinux.org/title/Proc)
- [Kernel docs — sysfs](https://www.kernel.org/doc/html/latest/filesystems/sysfs.html)

#sistema
