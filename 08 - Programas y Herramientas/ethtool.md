---
fecha_creacion: 2026-08-31
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL v2
alternativas: ip link, mii-tool, nmcli
---

# ethtool

> Herramienta CLI para **configurar y diagnosticar** interfaces de red Ethernet. Permite ver y modificar parámetros del adaptador de red: velocidad, duplex, autonegociación, Wake-on-Linux, offloading, y estadísticas del driver.

## Qué es

`ethtool` consulta y modifica los parámetros del controlador de la interfaz de red directamente a través de `ioctl()`. Es la herramienta estándar para diagnosticar problemas de conectividad de red a nivel de capa 2, verificar que la NIC negocia correctamente con el switch, y configurar funciones avanzadas como offloading o Wake-on-LAN.

- **Nivel**: Capa 2 (enlace de datos) — por debajo de `ip`/`nmcli`
- **Uso principal**: diagnóstico de negociación, offloading, Wake-on-LAN
- **No confundir con**: `ip link` (configura direcciones, ethtool configura la NIC)

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install ethtool` |
| Arch | `sudo pacman -S ethtool` |
| Fedora | `sudo dnf install ethtool` |
| openSUSE | `sudo zypper install ethtool` |
| Void | `sudo xbps-install -S ethtool` |
| Alpine | `sudo apk add ethtool` |
| macOS | No disponible (usar `networksetup` o `ifconfig`) |

> **Nota**: en muchas distros modernas `ethtool` ya viene preinstalado. Verificar con `ethtool --version`.

## Sintaxis

```bash
ethtool [opciones] <interfaz>
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `<interfaz>` | Consultar estado de la interfaz (sin flags) |
| `-i <interfaz>` | Mostrar información del driver |
| `-S <interfaz>` | Estadísticas detalladas del driver |
| `-s <interfaz> speed N` | Cambiar velocidad (10/100/1000/10000) |
| `-s <interfaz> duplex full\|half` | Cambiar modo duplex |
| `-s <interfaz> autoneg on\|off` | Activar/desactivar autonegociación |
| `-s <interfaz> wol p\|u\|m\|b\|a\|g\|s\|d` | Configurar Wake-on-LAN |
| `-K <interfaz> feature on\|off` | Activar/desactivar offloading |
| `-g <interfaz>` | Mostrar buffers de ring (TX/RX) |
| `-l <interfaz>` | Mostrar colas de interrupciones |
| `-L <interfaz> combined N` | Cambiar número de colas combinadas |

## Ejemplos

```bash
# Consultar estado completo de la interfaz
ethtool eth0

# Salida típica:
# Settings for eth0:
#   Supported ports: [ TP MII ]
#   Supported link modes:   10baseT/Half 10baseT/Full
#                           100baseT/Half 100baseT/Full
#                           1000baseT/Full
#   Speed: 1000Mb/s
#   Duplex: Full
#   Auto-negotiation: on
#   Link detected: yes

# Información del driver
ethtool -i eth0
# driver: r8169
# version: 6.1.0
# firmware-version: rtl8168h-2.0.0
# bus-info: 0000:03:00.0

# Estadísticas detalladas (contadores de errores, paquetes, etc.)
ethtool -S eth0

# Cambiar velocidad a 100 Mbps full duplex
sudo ethtool -s eth0 speed 100 duplex full autoneg off

# Activar Wake-on-LAN (magic packet)
sudo ethtool -s eth0 wol g

# Desactivar Wake-on-LAN
sudo ethtool -s eth0 wol d

# Activar offloading de TCP segmentation
sudo ethtool -K eth0 tso on

# Ver buffers de ring
ethtool -g eth0

# Cambiar número de colas de interrupciones
sudo ethtool -L eth0 combined 4

# Ver hashtable de hashing
ethtool -x eth0
```

## Casos de uso

- **Diagnosticar negociación**: verificar que la NIC y el switch acuerdan velocidad/duplex correctos
- **Problemas de rendimiento**: comprobar offloading, buffers, colas de interrupción
- **Wake-on-LAN**: configurar encendido remoto para servers
- **Desactivar autonegociación**: en entornos donde el switch está hardcodeado
- **Auditoría de red**: verificar drivers, firmware, velocidades en servidores
- **NIC en modo legacy**: forzar 10/100 en hardware viejo

## Comparativa con alternativas

| Herramienta | Nivel | Función principal |
|---|---|---|
| **ethtool** | Capa 2 (NIC) | Configurar/diagnosticar parámetros del adaptador |
| **ip link** | Capa 2 | Subir/bajar interfaz, MTU, alias |
| **nmcli** | Capa 2-3 | Gestión completa de NetworkManager |
| **mii-tool** | Capa 2 | Obsoleta, solo autonegociación básica |
| **ip addr** | Capa 3 | Direcciones IP, subredes |
| **ifconfig** | Capa 2-3 | Obsoleta (usa `ip` en su lugar) |

> **Regla práctica**: usa `ip link` para subir/bajar interfaces y `ethtool` para diagnosticar y configurar la NIC a nivel de hardware.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `ethtool: command not found` | No instalado | `sudo apt install ethtool` |
| `Cannot get current device settings` | Interfaz inexistente o sin permisos | Verificar nombre con `ip link`, usar `sudo` |
| `Speed unknown` | Driver no soporta ioctl | Driver genérico — instalar driver específico del fabricante |
| Negociación a 100 Mbps en puerto gigabit | Cable CAT5 (no CAT5e/CAT6) | Cambiar cable a CAT5e o superior |
| `Link detected: no` | Cable desconectado o NIC dañada | Verificar cable, switch, y LEDs de la NIC |
| Offloading no se desactiva | Driver no soporta ese feature | `ethtool -k eth0` para ver qué features soporta |
| Wake-on-LAN no funciona | BIOS/UEFI lo desactiva | Habilitar WOL en BIOS/UEFI además de ethtool |
| Cambios no persisten tras reboot | ethtool no guarda configuración | Añadir a `/etc/network/interfaces` o crear systemd service |

### Persistir configuración de ethtool

```bash
# Opción 1: NetworkManager dispatcher script
sudo nano /etc/NetworkManager/dispatcher.d/50-ethtool
#!/bin/bash
if [ "$2" = "up" ]; then
  ethtool -s "$1" speed 1000 duplex full autoneg off
fi
sudo chmod +x /etc/NetworkManager/dispatcher.d/50-ethtool

# Opción 2: systemd service
# Crear /etc/systemd/system/ethtool-eth0.service
[Unit]
Description=Configure eth0 with ethtool
After=network-pre.target
Before=network.target

[Service]
Type=oneshot
ExecStart=/sbin/ethtool -s eth0 speed 1000 duplex full autoneg off
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

# Opción 3: /etc/network/interfaces (Debian/Ubuntu)
# iface eth0 inet static
#   pre-up ethtool -s $IFACE speed 1000 duplex full autoneg off
```

## Ver también

- [[nmcli]] — gestión de red con NetworkManager
- [[ip]] — configuración de interfaces y rutas
- [[Redes Basicas]] — conceptos de red en Linux
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]] — auditoría hardware

## Enlaces externos

- [Wikipedia — ethtool](https://en.wikipedia.org/wiki/Ethtool)
- [Man page — ethtool](https://man7.org/linux/man-pages/man8/ethtool.8.html)
- [Arch Wiki — ethtool](https://wiki.archlinux.org/title/Ethtool)
- [Kernel.org — ethtool](https://kernel.org/doc/html/latest/networking/ethtool.html)

#programa #red
