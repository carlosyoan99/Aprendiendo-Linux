---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# dmidecode

## Qué es

Lee la tabla **DMI** (Desktop Management Interface) / **SMBIOS** del firmware para extraer información sobre la placa base, BIOS, RAM, chasis, número de serie, etc.

```bash
# Instalación
sudo apt install dmidecode                # Debian/Ubuntu
sudo pacman -S dmidecode                  # Arch
sudo dnf install dmidecode                # Fedora
```

> **Importante**: dmidecode requiere `sudo` para acceder a la memoria del firmware.

## Uso

```bash
sudo dmidecode -t system                  # fabricante, producto, serie
sudo dmidecode -t bios                    # versión BIOS/UEFI, fecha
sudo dmidecode -t baseboard              # placa base (modelo, revisión)
sudo dmidecode -t processor              # CPU (desde BIOS)
sudo dmidecode -t memory                  # módulos RAM (tipo, velocidad, tamaño)
sudo dmidecode -t chassis                # chasis (portátil, torre, etc.)
sudo dmidecode                            # todo (muy extenso)
```

### Atajos con `-s`

```bash
sudo dmidecode -s system-product-name     # solo el nombre del producto
sudo dmidecode -s system-serial-number    # número de serie
sudo dmidecode -s bios-version            # versión de BIOS
sudo dmidecode -s system-manufacturer     # fabricante
```

## Ejemplo práctico

```bash
sudo dmidecode -s system-manufacturer
sudo dmidecode -s system-product-name
# Lenovo
# ThinkPad X1 Carbon Gen 11
```

Útil para buscar drivers, piezas de repuesto o soporte técnico.

## Comprobar RAM instalada

```bash
sudo dmidecode -t memory | grep -E "Size:|Type:|Speed:|Manufacturer:|Part Number:"
```

## Casos de uso

- **Antes de comprar RAM**: `sudo dmidecode -t memory` para saber tipo, slots disponibles y máxima capacidad
- **Número de serie**: `sudo dmidecode -s system-serial-number` para garantía o soporte
- **Actualizar BIOS**: `sudo dmidecode -s bios-version` para saber la versión actual
- **VMs**: en máquinas virtuales (KVM/QEMU, VirtualBox) dmidecode reporta los datos que el hipervisor expone (ej. fabricante "QEMU") — útil para verificar virtualización
- **Inventario de flotas**: scriptear `dmidecode -s system-manufacturer/-product-name/-serial-number` para inventariar equipos

## Tipos de datos disponibles (DMI types)

| Type | Contenido | Comando |
|---|---|---|
| 0 | BIOS info (versión, fecha, vendor) | `sudo dmidecode -t bios` |
| 1 | Sistema (fabricante, producto, serie, UUID) | `sudo dmidecode -t system` |
| 2 | Placa base (modelo, chipset, serie) | `sudo dmidecode -t baseboard` |
| 3 | Chasis (tipo: portátil, torre, rack) | `sudo dmidecode -t chassis` |
| 4 | Procesador (socket, max speed, cores) | `sudo dmidecode -t processor` |
| 7 | Caché (L1/L2/L3) | `sudo dmidecode -t cache` |
| 16 | Memoria física (slots totales) | `sudo dmidecode -t memory` |
| 17 | Módulos de memoria (tipo, velocidad, fabricante) | `sudo dmidecode -t memory` |
| 20 | Memoria mapeada a dispositivos | `sudo dmidecode -t memory` |
| 25 | Puertos | `sudo dmidecode -t port` |
| 32 | Estado del arranque (boot status) | `sudo dmidecode -t system` |
| 39 | Alimentación (PSU) | `sudo dmidecode -t power` |
| 41 | Perfiles de firmware (onboard devices) | `sudo dmidecode -t onboard` |

## Salida filtrada con `--string` (extracción rápida)

```bash
# Campos soportados por -s (los más útiles):
sudo dmidecode -s bios-vendor            # Award, AMI, Dell, Lenovo...
sudo dmidecode -s bios-release-date
sudo dmidecode -s system-uuid            # UUID del sistema (único por máquina)
sudo dmidecode -s system-family
sudo dmidecode -s baseboard-manufacturer
sudo dmidecode -s baseboard-product-name
sudo dmidecode -s baseboard-serial-number
sudo dmidecode -s chassis-type           # Notebook, Desktop, Server, Rack Mount Chassis
sudo dmidecode -s processor-family
sudo dmidecode -s processor-frequency

# Encadenar varios campos en una línea (scripting):
sudo dmidecode -s system-manufacturer -s system-product-name -s system-serial-number
```

## Caso real: detectar máquina virtual

```bash
sudo dmidecode -t system | grep -E "Manufacturer|Product"
# En KVM/QEMU:      Manufacturer: QEMU / Product: Standard PC (i440FX + PIIX, 1996)
# En VirtualBox:    Manufacturer: innotek GmbH / Product: VirtualBox
# En VMware:        Manufacturer: VMware, Inc. / Product: VMware Virtual Platform
# En bare metal:    Manufacturer: Dell Inc. / Product: PowerEdge R740

# Script rápido para detectar virtualización:
sudo dmidecode -s system-manufacturer | grep -qiE "qemu|virtualbox|vmware|microsoft|xen" \
  && echo "Máquina virtual" || echo "Bare metal"
```

## Comparativa con alternativas

| Herramienta | Fuente de datos | Ventaja | Limitación |
|---|---|---|---|
| **dmidecode** | Tabla SMBIOS/DMI del firmware | Datos del fabricante (serie, BIOS, RAM exacta) | Requiere root; en VMs solo lo que expone el hipervisor |
| **lshw** | Hardware real + DMI | Info de dispositivos (red, disco, USB) sin tipo por tabla | Menos detallado en serie/BIOS; requiere root |
| **inxi** | Varias fuentes | Formato legible, resumen bonito | Menos preciso que dmidecode en RAM/serie |
| **lspci/lsusb** | Kernel + PCI/USB | Dispositivos por bus (GPU, WiFi, webcam) | No da serie/BIOS/RAM del fabricante |
| **smartctl** | Disco (S.M.A.R.T.) | Salud y temperatura del disco | Solo discos, no la máquina |
| **cpuinfo (/proc)** | Kernel | CPU actual (frecuencia real, flags) | No da serie del sistema ni datos de BIOS |

**Recomendación**: usa `dmidecode -t memory` para RAM, `-t system` para serie/garantía, y combínalo con `lspci -k` para dispositivos y `smartctl` para discos. Para un resumen general legible, `inxi -Fxxx` es el más cómodo.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `dmidecode` no puede acceder a la memoria | Requiere `root`/sudo para leer el SMBIOS | Ejecutar con `sudo` |
| Faltan datos de RAM o vienen en blanco | El firmware (BIOS/UEFI) no rellena bien la tabla SMBIOS | Probar con `sudo dmidecode -t memory`; si sigue vacío, usar `lshw` como alternativa |
| `dmidecode -s bios-version` devuelve vacío | Campo no poblado en esta máquina | Usar `sudo dmidecode -t bios | grep -i version` |
| Quiero la máxima RAM soportada | No siempre viene en la tabla | Revisar `dmidecode -t memory | grep -i max` o la documentación del fabricante |
| En VMs los datos parecen falsos | El hipervisor fabrica la tabla DMI | Normal — comparar con la documentación de la VM |
| Serie en blanco en portátiles | Fabricante no la rellena (lenovo usa otro campo) | Revisar `-t baseboard` o `-t chassis` por serie alternativa |

## Ver también

- [[lspci]] — dispositivos PCIe
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]] — índice + comparativa
- [[Firmware y BIOS-UEFI]]
- [[smartctl]] — salud de discos
- [[Virtualización (KVM QEMU libvirt)]] — detección de VMs con dmidecode

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `dmidecode` no puede acceder a la memoria | Requiere `root`/sudo para leer el SMBIOS | Ejecutar con `sudo` |
| Faltan datos de RAM o vienen en blanco | El firmware (BIOS/UEFI) no rellena bien la tabla SMBIOS | Probar con `sudo dmidecode -t memory`; si sigue vacío, usar `lshw` como alternativa |
| `dmidecode -s bios-version` devuelve vacío | Campo no poblado en esta máquina | Usar `sudo dmidecode -t bios | grep -i version` |
| Quiero la máxima RAM soportada | No siempre viene en la tabla | Revisar `dmidecode -t memory | grep -i max` o la documentación del fabricante |

## Ver también

- [[lspci]] — dispositivos PCIe
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]] — índice + comparativa
- [[Firmware y BIOS-UEFI]]

## Enlaces externos

- [Wikipedia — dmidecode](https://en.wikipedia.org/wiki/Dmidecode)
- [man7.org — dmidecode](https://man7.org/linux/man-pages/man8/dmidecode.8.html)

#programa
