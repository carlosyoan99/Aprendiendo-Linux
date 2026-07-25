---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: apt (dpkg)
base: Debian
modelo_lanzamiento: Fixed
init: systemd
arquitecturas:
  - ARM (armhf/arm64)
---

# Raspberry Pi OS

> Sistema operativo oficial para la placa **Raspberry Pi**, basado en **Debian** y altamente optimizado para la arquitectura ARM. Anteriormente llamado **Raspbian**.

## Qué es

Raspberry Pi OS (antes Raspbian) es la distribución oficial de la **Raspberry Pi Foundation** para sus placas SBC (Single Board Computer). Está basada en **Debian** con soporte optimizado para la CPU ARM de la Raspberry Pi, incluyendo aceleración por hardware para operaciones de coma flotante.

Creado originalmente por **Mike Thompson** y **Peter Green** en 2012 como un port independiente de Debian armhf, fue adoptado como el sistema oficial por la Raspberry Pi Foundation.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Debian (stable/testing según versión) |
| **Gestor de paquetes** | `apt` |
| **Arquitectura** | armhf (32 bits) y arm64 (64 bits) |
| **Entorno por defecto** | PIXEL (basado en LXDE + Openbox) |
| **Instalador** | Raspberry Pi Imager |
| **Escritorio** | PIXEL Desktop (GTK, panel inferior, menú clásico) |

## Ediciones

| Edición | Descripción | Tamaño |
|---|---|---|
| **Desktop** | Escritorio completo + herramientas recomendadas | ~2 GB |
| **Desktop (Legacy)** | Basada en Debian Bullseye (no Bookworm) | ~2 GB |
| **Lite** | Solo terminal, sin interfaz gráfica | ~500 MB |
| **Full** | Desktop + suites completas (LibreOffice, etc.) | ~4 GB |
| **64-bit (arm64)** | Desde Raspberry Pi 3, mejor rendimiento | ~2 GB |

## Instalación

```bash
# Método recomendado: Raspberry Pi Imager (descargar desde raspberrypi.com)
# O manualmente:

# Descargar ISO desde https://www.raspberrypi.com/software/
# Escribir en tarjeta SD (mínimo 8 GB, recomendado 16 GB+)
sudo dd if=2026-07-raspios-bookworm-arm64.img of=/dev/sdX bs=4M status=progress

# Activar SSH sin monitor (headless):
# Crear archivo vacío "ssh" en la partición boot
touch /media/boot/ssh

# Configurar WiFi sin monitor:
# Crear /media/boot/wpa_supplicant.conf:
# network={
#     ssid="NombreWiFi"
#     psk="contraseña"
# }
```

### Herramienta raspi-config

```bash
# Configuración del sistema desde terminal
sudo raspi-config

# Opciones principales:
# - Expandir partición root (ocupar toda la SD)
# - Cambiar contraseña de usuario
# - Opciones de arranque (consola/escritorio)
# - Overclock (si aplica)
# - Activar/desactivar interfaces (cámara, I2C, SPI, UART)
# - Configurar localización (idioma, teclado, WiFi)
```

## Usos comunes

| Proyecto | Descripción |
|---|---|
| **Servidor doméstico** | Pi-hole, NAS, Jellyfin, Nextcloud |
| **Media center** | LibreELEC/Kodi |
| **IoT / Smart home** | Home Assistant, Node-RED, Mosquitto MQTT |
| **Emulación** | RetroPie, RecalBox |
| **Servidor web** | Nginx, Apache + PHP + MariaDB |
| **Cluster** | Kubernetes (k3s), MPI |
| **Educación** | Programación Python, Scratch, Minecraft Pi |
| **Servidor de impresión** | CUPS + AirPrint para impresoras viejas |

## Comandos útiles

```bash
# Información del hardware
vcgencmd measure_temp              # temperatura CPU
vcgencmd get_throttled              # throttling por calor/falta voltaje
pinout                              # diagrama de pines GPIO

# Activar interfaces
sudo raspi-config                   # menú de configuración
sudo apt install wiringpi           # librería GPIO para C
gpio readall                        # leer todos los GPIOs

# Ver versión de Raspberry Pi
cat /proc/device-tree/model         # modelo exacto
cat /proc/cpuinfo | grep Revision   # revisión del hardware
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No arranca (LED rojo fijo) | SD corrupta o sin sistema | Reescribir imagen con Raspberry Pi Imager |
| LED rojo parpadea | Voltaje insuficiente | Usar fuente de 5V/3A, cable USB grueso |
| No se ve pantalla | HDMI incompatible | Añadir `hdmi_force_hotplug=1` en config.txt |
| Wifi no funciona en headless | Falta configuración | Crear wpa_supplicant.conf en partición boot |
| Throttling (performance baja) | Sobrecalentamiento o falta voltaje | Añadir heatsink y fuente adecuada |

## Ver también

- [[Linux embebido]] — embedded Linux en SBCs
- [[Alpine Linux]] — distro ligera para ARM y contenedores
- Armbian — Debian/Ubuntu optimizado para SBCs ARM

## Enlaces externos

- [Raspberry Pi — Software oficial](https://www.raspberrypi.com/software/)
- [Documentación oficial](https://www.raspberrypi.com/documentation/)
- [Raspberry Pi OS GitHub](https://github.com/raspberrypi)
- [MagPi Magazine](https://magpi.raspberrypi.com/)
- [Wikipedia — Raspberry Pi OS](https://en.wikipedia.org/wiki/Raspberry_Pi_OS)

#distro
