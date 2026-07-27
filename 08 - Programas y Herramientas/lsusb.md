---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# lsusb

## Qué es

Lista dispositivos USB conectados: teclado, ratón, webcam, impresora, discos externos, etc. Forma parte del paquete `usbutils`.

```bash
# Instalación
sudo apt install usbutils                 # Debian/Ubuntu
sudo pacman -S usbutils                   # Arch
sudo dnf install usbutils                 # Fedora
```

## Uso básico

```bash
lsusb                                     # lista básica
lsusb -v                                  # verbose (descripciones completas)
lsusb -t                                  # árbol USB (hubs, puertos)
```

## Filtros comunes

```bash
lsusb | grep -i hp                        # buscar por fabricante
lsusb | grep -i webcam                    # buscar por tipo
lsusb -d 8087:0a2b                        # filtrar por vendor:product ID
lsusb -s 001:003                          # filtrar por bus:device
lsblk | grep usb                          # discos USB montados
```

## Formato de salida

```bash
Bus 001 Device 003: ID 8087:0a2b Intel Corp. Bluetooth wireless interface
↑              ↑        ↑               ↑
bus            número   vendor:product   descripción
               de       ID
               dispositivo
```

| Columna | Significado |
|---|---|
| `Bus 001` | Bus USB al que está conectado |
| `Device 003` | Número de dispositivo asignado |
| `ID 8087:0a2b` | Vendor ID : Product ID |
| `Intel Corp. Bluetooth...` | Fabricante y descripción |

## Casos de uso

- **Detectar webcam**: `lsusb | grep -i camera` para ver si el sistema reconoce la cámara
- **Identificar dispositivo desconocido**: el vendor:product ID permite buscar drivers
- **Verificar hubs**: `lsusb -t` muestra la jerarquía de puertos USB

## Ver también

- [[lspci]] — dispositivos PCIe
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]] — índice + comparativa
- [[Video4Linux (V4L2)]] — cámaras y video

## Enlaces externos

- [Wikipedia — lsusb](https://en.wikipedia.org/wiki/Lsusb)
- [man7.org — lsusb](https://man7.org/linux/man-pages/man8/lsusb.8.html)

#programa
