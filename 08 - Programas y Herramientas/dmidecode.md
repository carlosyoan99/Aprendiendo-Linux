---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
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

## Ver también

- [[lspci]] — dispositivos PCIe
- [[Diagnóstico de hardware]] — índice + comparativa
- [[Firmware y BIOS-UEFI]]

## Enlaces externos

- [Wikipedia — dmidecode](https://en.wikipedia.org/wiki/Dmidecode)
- [man7.org — dmidecode](https://man7.org/linux/man-pages/man8/dmidecode.8.html)

#programa
