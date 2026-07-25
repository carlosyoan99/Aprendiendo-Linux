---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: sistema
prioridad: alta
---

# systemd-networkd — Red nativa de systemd

## Definición

systemd-networkd es el servicio de gestión de red de systemd. Gestiona interfaces de red, direcciones IP, rutas, DNS, bridges, VLANs y túneles de forma declarativa mediante archivos `.network` y `.netdev`. Es el gestor de red por defecto en Arch Linux (base), NixOS, CoreOS, y una alternativa ligera y rápida a NetworkManager en servidores.

```
Arquitectura de red con systemd-networkd:

  ┌─────────────────────────────────────────────────┐
  │                  systemd-networkd                │
  │  ┌──────────────┐  ┌──────────────┐             │
  │  │ .link files  │  │ .network     │  ┌────────┐ │
  │  │ (udev rules  │  │ files        │  │.netdev │ │
  │  │  para renom- │  │ (IP, DHCP,   │  │files   │ │
  │  │  brar ifaces)│  │  DNS, rutas) │  │(bridges│ │
  │  └──────────────┘  └──────┬───────┘  │, VLANs,│ │
  │                           │          │ túneles)│ │
  │                           │          └────────┘ │
  └───────────────────────────┼─────────────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          ▼                   ▼                   ▼
     ┌─────────┐        ┌─────────┐        ┌─────────┐
     │  eth0   │        │  wlan0  │        │  br0    │
     │  cable  │        │  WiFi   │        │  bridge │
     └─────────┘        └─────────┘        └─────────┘
```

---

## Instalación y activación

```bash
# Verificar si ya está corriendo
systemctl status systemd-networkd

# Instalar (suele venir con systemd, pero si no):
sudo apt install systemd                   # Debian/Ubuntu
sudo pacman -S systemd                     # Arch (ya incluido)

# Activar servicio
sudo systemctl enable --now systemd-networkd
sudo systemctl enable --now systemd-resolved   # DNS (opcional, recomendado)

# ⚠️  Si usabas NetworkManager, detenerlo para evitar conflictos
sudo systemctl stop NetworkManager
sudo systemctl disable NetworkManager

# O hacer que coexistan: systemd-networkd para interfaces cableadas,
# NetworkManager para WiFi. Se configura con .network files y
# 'Unmanaged=*' en NetworkManager para las interfaces que gestiona networkd.
```

---

## Archivos de configuración

| Ruta | Propósito | Prioridad |
|---|---|---|
| `/etc/systemd/network/` | Configuración del administrador (editar aquí) | 🔴 Más alta |
| `/run/systemd/network/` | Configuración temporal | 🟡 |
| `/lib/systemd/network/` | Configuración por defecto (paquetes) | 🟢 Más baja |

### Tipos de archivos

| Extensión | Configura |
|---|---|
| `.link` | Parámetros de la interfaz a nivel de link (renombrar, MAC, wake-on-lan) |
| `.netdev` | Dispositivos virtuales (bridge, bond, VLAN, tun, veth) |
| `.network` | Dirección IP, DHCP, DNS, rutas, enrutamiento |

> Los archivos se leen en orden **lexicográfico** (alfabético). Convención: usar números para el orden:
> `10-eth0.link`, `20-wired.network`, `30-wifi.network`, `40-bridge.netdev`

---

## Configuración básica

### DHCP (cliente típico)

```bash
# /etc/systemd/network/20-wired.network
[Match]
Name=eth0                                  # aplicar a esta interfaz

[Network]
DHCP=ipv4                                  # usar DHCP para IPv4

[DHCPv4]
UseDNS=true                                # usar DNS del servidor DHCP
UseDomains=true                            # usar dominio de búsqueda DHCP
```

### IP estática

```bash
# /etc/systemd/network/20-wired.network
[Match]
Name=eth0

[Network]
Address=192.168.1.100/24                  # IP + máscara (CIDR)
Gateway=192.168.1.1                        # puerta de enlace
DNS=1.1.1.1                                # DNS primario
DNS=8.8.8.8                                # DNS secundario
DNS=2001:4860:4860::8888                   # DNS IPv6
Domains=mi-dominio.local                   # dominio de búsqueda

[Link]
MTUBytes=1500                              # MTU (opcional)
```

### WiFi

systemd-networkd no gestiona WPA directamente. Usa **iwd** (iNet Wireless Daemon) o **wpa_supplicant** como backend:

```bash
# Opción A: con wpa_supplicant
sudo pacman -S wpa_supplicant              # Arch
# /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
network={
    ssid="MiRedWifi"
    psk="mi-contraseña"
    key_mgmt=WPA-PSK
}

sudo systemctl enable --now wpa_supplicant@wlan0

# /etc/systemd/network/25-wifi.network
[Match]
Name=wlan0

[Network]
DHCP=ipv4

# Opción B: con iwd (más moderno, recomendado — evita conflictos con NetworkManager)
sudo pacman -S iwd                         # Arch
# /etc/iwd/main.conf:
# [General]
# EnableNetworkConfiguration=true

sudo systemctl enable --now iwd

# 💡 iwd es la opción recomendada con systemd-networkd porque:
#   - No depende de D-Bus (más ligero)
#   - No entra en conflicto con NetworkManager si está instalado
#   - Se integra mejor con systemd
# wpa_supplicant puede causar conflictos si NetworkManager también
# intenta gestionar la misma interfaz WiFi (ambos usan D-Bus).
```

---

## Dispositivos virtuales (.netdev)

### Bridge (puente de red)

```bash
# /etc/systemd/network/30-br0.netdev
[NetDev]
Name=br0
Kind=bridge                                # tipo: bridge

[Bridge]
STP=true                                   # Spanning Tree Protocol

# /etc/systemd/network/30-br0.network (IP del bridge)
[Match]
Name=br0

[Network]
Address=192.168.1.10/24
Gateway=192.168.1.1
DNS=1.1.1.1

# /etc/systemd/network/20-eth0.network (interfaz física → bridge)
[Match]
Name=eth0

[Network]
Bridge=br0                                 # asignar al bridge
```

### VLAN

```bash
# /etc/systemd/network/40-vlan10.netdev
[NetDev]
Name=vlan10
Kind=vlan

[VLAN]
Id=10

# /etc/systemd/network/40-vlan10.network
[Match]
Name=vlan10

[Network]
Address=10.0.10.1/24
# La VLAN necesita la interfaz física:
# /etc/systemd/network/20-eth0.network:
# [Network]
# VLAN=vlan10
```

### Bonding (agregación de enlaces)

```bash
# /etc/systemd/network/30-bond0.netdev
[NetDev]
Name=bond0
Kind=bond

[Bond]
Mode=802.3ad                               # LACP (mode 4)
MIIMonitorSec=100ms
UpDelaySec=200ms
DownDelaySec=200ms

# /etc/systemd/network/30-bond0.network
[Match]
Name=bond0

[Network]
Address=192.168.1.10/24
Gateway=192.168.1.1

# /etc/systemd/network/20-eth0.network + 21-eth1.network
[Match]
Name=eth0                                   # (y eth1 para el otro)
[Network]
Bond=bond0
```

### MACVLAN / Bridge para contenedores

```bash
# /etc/systemd/network/40-mvlan.netdev
[NetDev]
Name=mvlan0
Kind=macvlan

[MACVLAN]
Mode=bridge                                 # bridge, private, vepa, passthru

# /etc/systemd/network/40-mvlan.network
[Match]
Name=mvlan0

[Network]
DHCP=ipv4
```

---

## systemd-resolved — DNS

systemd-resolved gestiona la resolución DNS de forma local. Al activarse, reemplaza `/etc/resolv.conf`:

```bash
# Activar
sudo systemctl enable --now systemd-resolved

# El stub resolver corre en 127.0.0.53
resolvectl status                          # estado actual
resolvectl query google.com               # resolver dominio
resolvectl statistics                     # estadísticas

# Configuración: /etc/systemd/resolved.conf
[Resolve]
DNS=1.1.1.1 8.8.8.8                       # servidores DNS
FallbackDNS=9.9.9.9                        # DNS de respaldo
Domains=~.                                 # buscar todos los dominios aquí
DNSSEC=allow-downgrade                    # validar DNSSEC si el servidor lo soporta
DNSOverTLS=yes                            # DNS cifrado (DoT)
MulticastDNS=yes                          # mDNS para resolución local (.local)

# Enlazar /etc/resolv.conf a systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Ver servidores DNS por interfaz
resolvectl dns                             # servidores por interfaz
resolvectl domain                          # dominios de búsqueda por interfaz
```

---

## Uso diario y diagnóstico

```bash
# ── Estado de la red ──
networkctl                                # resumen de interfaces y estado
networkctl status                         # detalle de todas las interfaces
networkctl status eth0                    # detalle de una interfaz
networkctl lldp                          # información LLDP (si está activo)

# ── Aplicar cambios sin reiniciar ──
sudo networkctl reload                    # recargar archivos .network sin cortar conexiones
sudo networkctl reconfigure eth0          # reconfigurar una interfaz específica

# ⚠️  networkctl reload solo afecta a archivos .network.
# Los cambios en archivos .netdev (nuevos bridges, VLANs, bonds)
# requieren reiniciar el servicio:
# sudo systemctl restart systemd-networkd

# ── Logs ──
journalctl -u systemd-networkd            # logs del servicio
journalctl -u systemd-resolved            # logs del DNS resolver

# ── Ver enlaces y rutas gestionadas ──
ip link                                   # interfaces (siempre funciona)
ip addr                                   # direcciones IP
ip route                                  # rutas
resolvectl dns                            # DNS por interfaz
```

### Salida de networkctl

```
IDX LINK   TYPE     OPERATIONAL SETUP
  1 lo     loopback carrier     unmanaged
  2 eth0   ether    routable    configured
  3 wlan0  wifi     off         unmanaged

2 links listed.
```

| Estado | Significado |
|---|---|
| `routable` | Tiene IP y puede enrutar (✅ todo bien) |
| `degraded` | Interfaces esperando enlace o DHCP |
| `off` | Apagada administrativamente |
| `carrier` | Cable conectado pero sin IP |
| `no-carrier` | Sin cable conectado |
| `enslaved` | Parte de un bridge o bond |
| `unmanaged` | Gestionada por otro servicio (NetworkManager) |

---

## systemd-networkd vs NetworkManager

| Característica | systemd-networkd | NetworkManager |
|---|---|---|
| **Complejidad** | Baja (archivos .network) | Media (GUI + CLI + D-Bus) |
| **Rendimiento** | Muy rápido (nativo de systemd) | Rápido |
| **WiFi** | Requiere wpa_supplicant/iwd | ✅ Integrado |
| **Perfiles portátiles** | ❌ No tiene (un archivo por interfaz) | ✅ Conexiones por perfil |
| **Integración escritorio** | ❌ Sin GUI | ✅ applet GNOME/KDE |
| **Ideal para** | Servidores, containers, IoT, Arch base | Escritorios, portátiles, usuarios móviles |
| **Hotplug (USB WiFi)** | Limitado | ✅ Excelente |

### Convivencia: networkd para cableado, NetworkManager para WiFi

```bash
# /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
[keyfile]
unmanaged-devices=interface-name:eth0    # eth0 la gestiona systemd-networkd
# NetworkManager gestionará wlan0 y otras interfaces
```

---

## Buenas prácticas

- **Nombres de archivo**: usa prefijos numéricos (`10-`, `20-`, `30-`) para controlar el orden de aplicación.
- **Match específico**: usa `MACAddress=` o `Path=` en lugar de `Name=` si necesitas identificar una interfaz que puede cambiar de nombre.
- **systemd-resolved**: activarlo junto con networkd para tener DNS consistente. Enlazar `/etc/resolv.conf` al stub-resolver.
- **Probar cambios**: `sudo networkctl reconfigure eth0` aplica cambios sin reiniciar el servicio (aunque algunos cambios requieren reload).
- **Coexistencia**: si usas NetworkManager para WiFi, marca las interfaces cableadas como `unmanaged-devices` en NM y gestiona solo WiFi desde ahí.

## Ver también

- [[systemd]] — systemd en general, gestión de servicios
- [[Redes Basicas]] — conceptos de red (IP, DHCP, DNS, rutas)
- [[Firewall]] — filtrar tráfico en interfaces gestionadas por networkd
- [[WireGuard VPN]] — túneles WireGuard con archivos .netdev
- [[Logging del sistema (rsyslog journald logrotate)]] — logs de networkd via journalctl
- [[Contenedores]] — bridges y macvlan para contenedores con networkd

## Enlaces externos

- [Wikipedia — systemd#networkd](https://en.wikipedia.org/wiki/Systemd#networkd)
- [systemd manual — networkd](https://www.freedesktop.org/software/systemd/man/systemd-networkd.html)
- [Arch Wiki — systemd-networkd](https://wiki.archlinux.org/title/Systemd-networkd)

#sistema
#redes
