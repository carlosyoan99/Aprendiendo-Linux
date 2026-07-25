---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# Diagnóstico de hardware (lspci, lsusb, lscpu, dmidecode, lshw, smartctl)

## Qué es

Conjunto de herramientas de terminal para inspeccionar el hardware del sistema sin abrir la carcasa ni instalar software gráfico. Permiten identificar componentes, verificar su estado, y diagnosticar fallos antes de que ocurran.

```
Herramientas y qué informan:

  ┌──────────────────────────────────────┐
  │           dmidecode                  │
  │  BIOS/UEFI, placa base, RAM,        │
  │  número de serie, fabricante         │
  └──────────────────────────────────────┘

  ┌──────────┐  ┌──────────┐  ┌──────────┐
  │  lspci   │  │  lsusb   │  │  lscpu   │
  │  PCIe:   │  │  USB:    │  │  CPU:    │
  │  GPU,    │  │  teclado │  │  núcleos,│
  │  NVMe,   │  │  mouse,  │  │  frec.,  │
  │  red     │  │  webcam  │  │  flags   │
  └──────────┘  └──────────┘  └──────────┘

  ┌──────────┐  ┌──────────┐  ┌──────────┐
  │ smartctl │  │  lshw    │  │   hdparm │
  │  discos: │  │  resumen │  │  disco:  │
  │  salud,  │  │  completo│  │  cache,  │
  │  S.M.A.R.│  │  en árbol│  │  DMA     │
  └──────────┘  └──────────┘  └──────────┘
```

---

## lspci — Dispositivos PCIe

Lista todos los dispositivos conectados al bus PCI/PCIe: GPU, NVMe, WiFi, Ethernet, controladores SATA, etc.

```bash
# Instalación (suele venir preinstalado)
sudo apt install pciutils                 # Debian/Ubuntu
sudo pacman -S pciutils                   # Arch
sudo dnf install pciutils                 # Fedora

# ── Listar dispositivos ──
lspci                                     # lista básica
lspci -v                                  # verbose (info detallada)
lspci -vv                                 # muy verbose (interrupciones, capabilidades)

# ── Filtros ──
lspci | grep -i vga                       # GPU/VGA
lspci | grep -i ethernet                  # interfaz de red
lspci | grep -i wireless                  # WiFi
lspci | grep -i nvme                      # disco NVMe
lspci | grep -i audio                     # tarjeta de sonido

# ── Mostrar fabricante y modelo ──
lspci -nn                                 # vendor:device IDs (ej: 10de:1b80)
lspci -nnk                                # IDs + driver del kernel cargado
lspci -s 01:00.0 -v                       # un dispositivo específico (bus:slot.func)

# ── Árbol de dispositivos PCIe ──
lspci -t                                  # jerarquía (puertos, bridges)
```

### Columnas de lspci

```
00:02.0 VGA compatible controller: Intel Corporation HD Graphics 630 (rev 04)
↑       ↑                              ↑
bus:    tipo de dispositivo            fabricante y modelo
slot.func
```

| Columna | Significado |
|---|---|
| `00:02.0` | Bus : Slot . Función (dirección PCI) |
| `VGA compatible controller` | Clase de dispositivo |
| `Intel Corporation HD Graphics 630` | Fabricante + modelo |
| `(rev 04)` | Revisión del hardware |
| `Kernel driver in use: i915` | Módulo del kernel que lo maneja (con `-k`) |

---

## lsusb — Dispositivos USB

Lista dispositivos USB conectados: teclado, ratón, webcam, impresora, discos externos, etc.

```bash
# Instalación
sudo apt install usbutils                 # Debian/Ubuntu
sudo pacman -S usbutils                   # Arch
sudo dnf install usbutils                 # Fedora

# ── Listar dispositivos USB ──
lsusb                                     # lista básica
lsusb -v                                  # verbose (descripciones completas)
lsusb -t                                  # árbol USB (hubs, puertos)

# ── Filtros ──
lsusb | grep -i hp                        # buscar por fabricante
lsusb | grep -i webcam                    # buscar por tipo

# ── Fabricante y producto específicos ──
lsusb -d 8087:0a2b                       # filtrar por vendor:product ID
lsusb -s 001:003                         # filtrar por bus:device

# ── Ver dispositivos de bloque USB ──
lsblk | grep usb                          # discos USB montados
```

### Columnas de lsusb

```
Bus 001 Device 003: ID 8087:0a2b Intel Corp. Bluetooth wireless interface
↑              ↑        ↑               ↑
bus            número   vendor:product   descripción
               de       ID
               dispositivo
```

---

## lscpu — Información de la CPU

```bash
# Sin instalación (parte de util-linux, siempre instalado)
lscpu                                     # toda la info
lscpu --all                               # todos los núcleos
lscpu --extended                          # tabla por núcleo individual
lscpu --json                              # salida JSON (pipeable)
lscpu --caches                            # solo info de caché
lscpu --parse=CORE,SOCKET,CPU            # columnas específicas
```

### Qué muestra lscpu

```bash
# Ejemplo de salida:
Architecture:             x86_64
CPU op-mode(s):          32-bit, 64-bit
CPU(s):                   8                 # núcleos lógicos (con hyperthreading)
Thread(s) per core:       2                 # hyperthreading activo
Core(s) per socket:       4                 # núcleos físicos
Socket(s):                1                 # zócalos (CPU físicas)
Model name:               Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz
CPU max MHz:              3800.0000        # frecuencia máxima en turbo
CPU min MHz:              800.0000         # frecuencia mínima
L1d cache:                128 KiB          # caché de datos L1
L1i cache:                128 KiB          # caché de instrucciones L1
L2 cache:                 1 MiB
L3 cache:                 8 MiB
Flags:                    fpu vme de pse tsc msr pae mce cx8 apic sep...  # capacidades CPU
```

```bash
# Flags importantes (verificar con grep flags /proc/cpuinfo | head -1)
# aes      → aceleración hardware AES
# avx2     → AVX2 (procesamiento vectorial)
# svm      → virtualización AMD (AMD-V)
# vmx      → virtualización Intel (VT-x)
# ssse3, sse4_1, sse4_2 → instrucciones SIMD
```

---

## dmidecode — BIOS, placa base, RAM (DMI/SMBIOS)

Lee la tabla DMI (Desktop Management Interface) del firmware para extraer información sobre la placa base, BIOS, RAM, chassis, etc.

```bash
# Instalación
sudo apt install dmidecode                # Debian/Ubuntu
sudo pacman -S dmidecode                  # Arch
sudo dnf install dmidecode                # Fedora

# ── Resumen del sistema (siempre usar sudo) ──
sudo dmidecode -t system                  # fabricante, producto, serie
sudo dmidecode -t bios                    # versión BIOS/UEFI, fecha
sudo dmidecode -t baseboard              # placa base (modelo, revisión)
sudo dmidecode -t processor              # CPU (desde BIOS)
sudo dmidecode -t memory                  # módulos RAM (tipo, velocidad, tamaño)
sudo dmidecode -t chassis                # chasis (portátil, torre, etc.)

# ── Información completa ──
sudo dmidecode                            # todo (muy extenso)
sudo dmidecode -s system-product-name     # solo el nombre del producto (portátil)
sudo dmidecode -s system-serial-number    # número de serie
sudo dmidecode -s bios-version            # versión de BIOS

# ── Comprobar RAM instalada ──
sudo dmidecode -t memory | grep -E "Size:|Type:|Speed:|Manufacturer:|Part Number:"
```

### Ejemplo práctico: saber el modelo de portátil

```bash
sudo dmidecode -s system-manufacturer
sudo dmidecode -s system-product-name
# Lenovo
# ThinkPad X1 Carbon Gen 11

# Útil para buscar drivers, piezas de repuesto, o soporte técnico
```

---

## lshw — Resumen de hardware en árbol

Muestra una vista jerárquica de todo el hardware, combinando información de múltiples fuentes.

```bash
# Instalación
sudo apt install lshw                     # Debian/Ubuntu
sudo pacman -S lshw                       # Arch
sudo dnf install lshw                     # Fedora

# ── Vista completa (requiere sudo para info precisa) ──
sudo lshw                                 # todo el hardware
sudo lshw -short                          # resumen en tabla (muy útil)
sudo lshw -class display                  # solo GPU
sudo lshw -class network                  # solo interfaces de red
sudo lshw -class disk                     # solo discos
sudo lshw -class memory                   # solo RAM

# ── Guardar reporte ──
sudo lshw -html > hardware-report.html   # reporte HTML (para compartir)
sudo lshw -xml > hardware-report.xml     # formato XML (para parsear)
```

---

## smartctl — Salud de discos (S.M.A.R.T.)

Monitorea la salud de discos duros (HDD) y SSDs mediante S.M.A.R.T. (Self-Monitoring, Analysis and Reporting Technology). Detecta fallos inminentes antes de que ocurran.

```bash
# Instalación
sudo apt install smartmontools            # Debian/Ubuntu
sudo pacman -S smartmontools              # Arch
sudo dnf install smartmontools            # Fedora

# ── Verificar si un disco soporta S.M.A.R.T. ──
sudo smartctl -i /dev/sda                 # info del disco + capacidades SMART
sudo smartctl -H /dev/sda                 # health status (PASSED/FAILED)

# ── Ver todos los atributos SMART ──
sudo smartctl -A /dev/sda                 # todos los atributos
sudo smartctl -a /dev/sda                 # todo (info + atributos + logs)

# ── Escanear discos disponibles ──
sudo smartctl --scan                      # detectar todos los discos con SMART

# ── Pruebas de diagnóstico ──
sudo smartctl -t short /dev/sda           # test corto (~2 min)
sudo smartctl -t long /dev/sda            # test largo (~horas, según tamaño)
sudo smartctl -l selftest /dev/sda        # ver resultados de tests anteriores
sudo smartctl -l error /dev/sda           # logs de errores del disco
```

### Atributos SMART clave

| Atributo | ID | Qué mide | Valor saludable |
|---|---|---|---|
| **Reallocated_Sector_Ct** | 5 | Sectores reasignados por daño | 0. Si crece, el disco está fallando |
| **Power_On_Hours** | 9 | Horas de funcionamiento totales | Depende |
| **Temperature_Celsius** | 194 | Temperatura del disco | < 50°C ideal, > 60°C peligro |
| **Current_Pending_Sector** | 197 | Sectores inestables pendientes | 0. Si > 0, backup YA |
| **Offline_Uncorrectable** | 198 | Sectores que no se pudieron leer | 0 |
| **Media_Wearout_Indicator** | 233 | Desgaste de SSD | > 90% (SSD nuevo), < 10% (reemplazar) |
| **Wear_Leveling_Count** | 177 | Ciclos de desgaste en SSD | Depende del modelo |

```bash
# ── Script: resumen rápido de salud de discos ──
for disk in /dev/sd[a-z]; do
    echo "=== $disk ==="
    sudo smartctl -H $disk | grep -E "SMART overall-health|SMART Health Status"
    sudo smartctl -A $disk | grep -E "Reallocated_Sector_Ct|Current_Pending_Sector|Temperature_Celsius"
done

# ── Activar SMART automático ──
sudo smartctl -s on /dev/sda              # activar SMART en el disco
# (normalmente ya viene activado de fábrica)
```

### NVMe — Discos NVMe (no usan SMART tradicional)

Los discos NVMe tienen su propio protocolo de diagnóstico:

```bash
# Instalación
sudo apt install nvme-cli                 # Debian/Ubuntu
sudo pacman -S nvme-cli                   # Arch
sudo dnf install nvme-cli                 # Fedora

# Listar discos NVMe
sudo nvme list
# Node             SN                   Model                                    Usage
# ---------------- -------------------- ---------------------------------------- ----------
# /dev/nvme0n1     S46HNA0T123456L     Samsung SSD 980 PRO 1TB                  800.00 GB

# Salud del NVMe
sudo nvme smart-log /dev/nvme0n1
# temperature: 42°C
# percentage_used: 5%                    # desgaste (0-100%)
# data_units_written: 123,456,789
# media_errors: 0                        # errores físicos (debe ser 0)

# Identificar el modelo exacto
sudo nvme id-ctrl /dev/nvme0n1 | grep -E "sn|mn"
# sn     : S46HNA0T123456L               # serial number
# mn     : Samsung SSD 980 PRO 1TB        # model number
```

---

## hdparm — Rendimiento de discos

```bash
# Instalación
sudo apt install hdparm                   # Debian/Ubuntu
sudo pacman -S hdparm                     # Arch

# ── Info del disco (caché, DMA, seguridad) ──
sudo hdparm -I /dev/sda                   # información detallada

# ── Prueba de velocidad de lectura (segura en discos montados) ──
sudo hdparm -Tt /dev/sda                  # benchmark (caché + disco)
# Timing cached reads:    10234 MB in 2.00 seconds
# Timing buffered disk reads:  456 MB in 3.00 seconds
```

---

## Tabla de herramientas

| Herramienta | Paquete | Para qué | Alternativa |
|---|---|---|---|
| **lspci** | pciutils | Dispositivos PCIe (GPU, NVMe, red) | `cat /sys/bus/pci/devices/` |
| **lsusb** | usbutils | Dispositivos USB | `cat /sys/kernel/debug/usb/devices` |
| **lscpu** | util-linux | CPU (núcleos, frecuencias, flags) | `cat /proc/cpuinfo` |
| **dmidecode** | dmidecode | BIOS, placa base, RAM, serie | `cat /sys/class/dmi/id/` |
| **lshw** | lshw | Resumen completo en árbol | `lspci -v` + `lsusb -v` combinado |
| **smartctl** | smartmontools | Salud de discos (S.M.A.R.T.) | `udisksctl` (para discos) |
| **hdparm** | hdparm | Rendimiento y configuración de discos | `fio` (más preciso) |

---

## Buenas prácticas

- **smartctl semanal**: programa un cron/systemd timer para monitorear la salud de los discos. Si `Reallocated_Sector_Ct` o `Current_Pending_Sector` suben de 0, haz backup inmediato.
- **dmidecode para specs**: antes de comprar RAM o preguntar en foros, ejecuta `sudo dmidecode -t memory` y `sudo dmidecode -t baseboard`.
- **lspci antes de instalar drivers**: ejecuta `lspci -nnk | grep -A2 VGA` para saber qué GPU tienes y qué driver usa.
- **Reporte completo**: `sudo lshw -short` da una tabla completa y legible de todo el hardware.
- **lscpu para virtualización**: verifica que `svm` (AMD) o `vmx` (Intel) aparezcan en `lscpu | grep Flags` para saber si tu CPU soporta virtualización.

## Ver también

- [[Proc y Sys]] — /proc/cpuinfo, /proc/meminfo (/proc como fuente de datos crudos)
- [[Módulos del kernel (lsmod modprobe blacklist)]] — drivers que manejan el hardware
- [[RAID (mdadm)]] — monitoreo de discos en RAID
- [[Monitorización (Prometheus node_exporter)]] — node_exporter expone métricas SMART y de hardware
- [[Particionado y Esquemas de Disco]] — trabajar con discos detectados
- [[htop btop]] — monitoreo de recursos en tiempo real

## Enlaces externos

- [Wikipedia — Lspci](https://en.wikipedia.org/wiki/Lspci)
- [Wikipedia — Lsusb](https://en.wikipedia.org/wiki/Lsusb)
- [Wikipedia — Dmidecode](https://en.wikipedia.org/wiki/Dmidecode)
- [Wikipedia — S.M.A.R.T.](https://en.wikipedia.org/wiki/Self-Monitoring,_Analysis_and_Reporting_Technology)
- [Sitio oficial — smartmontools](https://www.smartmontools.org/)

#programa
