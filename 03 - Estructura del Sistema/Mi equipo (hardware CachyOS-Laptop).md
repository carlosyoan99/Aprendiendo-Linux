---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: sistema
prioridad: media
---

# Mi equipo (hardware CachyOS-Laptop)

> Especificaciones del laptop donde corre este vault y toda la configuración documentada. Equipo modesto (Haswell, ~2013) que justifica scripts de optimización (niri-gov, niri-ram, gaming mode) y el redimensionado de wallpapers.

## Especificaciones

| Componente | Detalle |
|---|---|
| Chasis | Laptop |
| CPU | Intel Core i5-4200U @ 1.60 GHz, 4 hilos, Haswell (~2013) |
| RAM | 7.6 GiB |
| GPU | Intel Haswell-ULT (iGPU) |
| Disco | sda 111.8G — `/boot` sda1 4G + root LUKS `luks-ecf4fe4c` (~107.8G, Btrfs) |
| Bluetooth | 28:C2:DD:DB:B9:9C |
| WiFi | wlan0 — `nauta_Hogar_011561` |
| Hostname | CachyOS-Laptop |
| OS | CachyOS, kernel 7.2.2-1-cachyos |

## Implicaciones de este hardware

- **CPU/memoria limitados** → se usan `niri-gov` (ciclar governor), `niri-ram` (liberar caché) y el modo gaming (desactiva blur/animaciones).
- **Wallpapers**: por rendimiento se redimensionan a 1366x768 (resolución de la pantalla, crop-to-fill) con `~/Imágenes/Wallpaper/resize_wallpapers.sh`.
- **Chrome + VAAPI**: `--enable-features=VaapiVideoDecoder` para descargar el vídeo a la iGPU.

## Ver también

- [[CachyOS]] — distribución instalada
- [[Niri]] — compositor (adaptado a este hardware)
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]]

## Enlaces externos

- [Intel Core i5-4200U — specs](https://www.intel.com/content/www/us/en/products/sku/75459.html)

#sistema #hardware