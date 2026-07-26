---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: media
---

# NetworkManager

> Daemon de gestión de red que detecta y configura automáticamente conexiones de red. Es el gestor por defecto en la mayoría de distribuciones de escritorio.

## Sintaxis

```bash
nmcli [objeto] [comando] [opciones]
nmtui                              # interfaz TUI para gestionar red
```

## Descripción

`NetworkManager` gestiona interfaces de red (Ethernet, WiFi, VPN, Bluetooth) de forma automática. Detecta cambios de red, gestiona DHCP, y permite configuraciones manuales. Se controla con `nmcli` (CLI), `nmtui` (TUI) o herramientas gráficas.

## Opciones principales (nmcli)

| Objeto | Comandos útiles |
|---|---|
| `general` | `status`, `hostname`, `permissions` |
| `networking` | `on`, `off`, `connectivity check` |
| `radio` | `wifi on/off`, `wwan on/off` |
| `connection` | `show`, `up`, `down`, `add`, `modify`, `delete` |
| `device` | `status`, `show`, `connect`, `disconnect` |
| `wifi` | `list`, `scan`, `connect` |
| `monitor` | Monitorizar cambios de red en tiempo real |

## Ejemplos

### Ver estado de la red
```bash
nmcli general status                # connected/disconnected
nmcli device status                 # estado por interfaz
nmcli connection show               # conexiones configuradas
nmcli connection show "Wired"       # detalle de una conexión
```

### Gestionar WiFi
```bash
nmcli radio wifi on                 # activar WiFi
nmcli device wifi list              # ver redes disponibles
nmcli device wifi connect "MiRed" password "clave123"  # conectar
nmcli connection up "MiRed"         # activar conexión guardada
nmcli connection down "MiRed"       # desactivar conexión
```

### IP estática
```bash
nmcli connection modify "Wired" \
  ipv4.method manual \
  ipv4.addresses 192.168.1.100/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns "8.8.8.8 8.8.4.4"

nmcli connection up "Wired"         # aplicar cambios
```

### DNS manual
```bash
nmcli connection modify "Wired" ipv4.dns "1.1.1.1 1.0.0.1"
nmcli connection up "Wired"
```

### VPN
```bash
# Instalar soporte VPN
sudo apt install network-manager-openvpn-gnome

# Importar config VPN
nmcli connection import type openvpn file mi-vpn.ovpn

# Conectar/desconectar VPN
nmcli connection up "mi-vpn"
nmcli connection down "mi-vpn"
```

## nmtui (interfaz TUI)

```bash
sudo nmtui                        # menú principal
# Opciones:
# - Edit a connection    → configurar conexiones
# - Activate a connection → activar/conectar
# - Set system hostname  → cambiar hostname
```

## Configuración avanzada

```bash
# Ver configuración completa
nmcli connection show "Wired" | grep ipv4

# Desactivar auto-connect
nmcli connection modify "Wired" connection.autoconnect no

# DNS con prioridad
nmcli connection modify "Wired" ipv4.dns-priority -50

# Clonar MAC address
nmcli connection modify "Wired" ethernet.cloned-mac-address "AA:BB:CC:DD:EE:FF"

# Activar wake-on-LAN
nmcli connection modify "Wired" ethernet.wake-on-lan magic
```

## Formato de salida

```
DEVICE  TYPE      STATE         CONNECTION
eth0    ethernet  connected     Wired
wlan0   wifi      connected     MiRed
lo      loopback  unmanaged     --
```

## Casos de uso

### Configurar servidor con IP estática
```bash
# Ver interfaces disponibles
nmcli device status

# Crear conexión estática
nmcli connection add type ethernet con-name "static" \
  ipv4.method manual \
  ipv4.addresses 10.0.0.50/24 \
  ipv4.gateway 10.0.0.1 \
  ipv4.dns "1.1.1.1" \
  ifname eth0

nmcli connection up "static"
```

### Debug de conectividad
```bash
nmcli general status                # ¿conectado?
nmcli device status                 # ¿qué interfaz?
nmcli connection show --active      # ¿qué conexión activa?
nmcli networking connectivity check # ¿internet disponible?
```

## Combinaciones pipe

```bash
# Solo nombre de conexión activa
nmcli -t -f NAME,DEVICE connection show --active | head -1

# IP de una interfaz
nmcli -t -f IP4.ADDRESS device show eth0

# Verificar si WiFi está activo
nmcli radio wifi | grep -q enabled && echo "WiFi ON" || echo "WiFi OFF"
```

## Alternativas

| Herramienta | Cuándo usarla |
|---|---|
| **NetworkManager** | Escritorio, WiFi, VPN, automático |
| **systemd-networkd** | Servidores, configuración estática |
| **iwd** | Replacement ligero de wpa_supplicant |
| **connman** | Embedded, IoT |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No conecta WiFi | Radio off o driver | `nmcli radio wifi on`, verificar driver |
| IP no asignada | DHCP falló | `nmcli device reapply eth0` o IP estática |
| DNS no resuelve | DNS mal configurado | `nmcli connection modify "Wired" ipv4.dns "8.8.8.8"` |
| Conexión cayendo | Power management | `nmcli connection modify "Wired" 802-3-ethernet.wake-on-lan default` |

## Ver también

- [[Redes Basicas]] — conceptos de red
- [[systemd-networkd]] — alternativa para servidores
- [[nmcli]] — referencia completa de comandos
- [[WiFi no conecta]] — troubleshooting WiFi
- [[nftables]] — firewall que gestiona NetworkManager

## Enlaces externos

- [Wikipedia — NetworkManager](https://en.wikipedia.org/wiki/NetworkManager)
- [NetworkManager Docs](https://networkmanager.dev/docs/)
- [Arch Wiki — NetworkManager](https://wiki.archlinux.org/title/NetworkManager)
- [man nmcli(1)](https://networkmanager.dev/docs/api/latest/nmcli.html)

#sistema #redes
