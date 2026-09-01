---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-01
estado: resuelto
categoria: programa
prioridad: alta
---

# lspci

## Qué es

Lista todos los dispositivos conectados al bus **PCI/PCIe**: GPU, NVMe, WiFi, Ethernet, controladores SATA, etc. Forma parte del paquete `pciutils`.

```bash
# Instalación (suele venir preinstalado)
sudo apt install pciutils                 # Debian/Ubuntu
sudo pacman -S pciutils                   # Arch
sudo dnf install pciutils                 # Fedora
```

## Uso básico

```bash
lspci                                     # lista básica
lspci -v                                  # verbose (info detallada)
lspci -vv                                 # muy verbose (interrupciones, capabilidades)
```

## Filtros comunes

```bash
lspci | grep -i vga                       # GPU/VGA
lspci | grep -i ethernet                  # interfaz de red
lspci | grep -i wireless                  # WiFi
lspci | grep -i nvme                      # disco NVMe
lspci | grep -i audio                     # tarjeta de sonido
```

## Formato de salida

```bash
lspci -nn                                 # vendor:device IDs (ej: 10de:1b80)
lspci -nnk                                # IDs + driver del kernel cargado
lspci -s 01:00.0 -v                       # un dispositivo específico (bus:slot.func)
lspci -t                                  # árbol de jerarquía PCIe
```

### Columnas

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

## Casos de uso

- **Antes de instalar drivers**: `lspci -nnk | grep -A2 VGA` para saber GPU y driver
- **Diagnóstico de red**: verificar si la NIC es detectada (`lspci | grep Ethernet`)
- **Compatibilidad**: comprobar versión PCIe y ancho de enlace

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `lspci` no muestra la GPU | GPU integrada + devuelta desactivada en BIOS/UEFI | Revisar BIOS; `lspci -nnk | grep -A2 VGA` |
| No veo el driver en `lspci -nnk` | La línea `Kernel driver in use` solo sale con `-k` | Usar `lspci -nnk` (o `-v`). Si no hay driver, instalar el módulo del kernel |
| Un dispositivo no aparece | No está enclavado por el kernel o está en un slot deshabilitado | `lspci -t` para ver el árbol PCIe; verificar `dmesg` del dispositivo |
| Quiero saber si el ancho PCIe es el real | No se distingue el enlace activo del máximo | Espera; no se obtiene con lspci sino con `lspci -vv` y la línea `LnkCap`/`LnkSta`. Buscar `LnkSta Speed/Width` |

## Ver también

- [[lsusb]] — dispositivos USB
- [[dmidecode]] — BIOS, placa base, RAM
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]] — índice + comparativa
- [[Módulos del kernel (lsmod modprobe blacklist)]]

## Enlaces externos

- [Wikipedia — lspci](https://en.wikipedia.org/wiki/Lspci)
- [man7.org — lspci](https://man7.org/linux/man-pages/man8/lspci.8.html)

#programa
