---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: troubleshooting
prioridad: alta
---

# Red no conecta

> Troubleshooting general de conectividad de red: DNS, DHCP, firewall, cable, interfaz. No solo WiFi — aplica a Ethernet, VPN y cualquier conexión.

## Síntoma

El sistema no tiene acceso a internet o a recursos de red. Puede ser total (nada funciona) o parcial (algunos hosts sí, otros no).

## Diagnóstico

```bash
# 1. Verificar interfaz activa
ip addr show
ip link show

# 2. Verificar connectivity básica
ping -c 3 8.8.8.8              # ¿hay IP?
ping -c 3 google.com           # ¿resuelve DNS?

# 3. Verificar routing
ip route show
ip route get 8.8.8.8

# 4. Verificar DNS
cat /etc/resolv.conf
resolvectl status              # systemd-resolved
dig google.com

# 5. Verificar firewall
sudo nft list ruleset | grep -i drop
sudo iptables -L -n | grep DROP

# 6. Ver logs
journalctl -u NetworkManager --since "10 min ago"
journalctl -k | grep -i net
```

## Causas y soluciones

### 1. Interfaz no activa

```bash
# Verificar estado
ip link show

# Activar interfaz
sudo ip link set eth0 up

# Con NetworkManager
nmcli device status
nmcli device connect eth0
```

### 2. No obtiene IP (DHCP falla)

```bash
# Renovar DHCP
sudo dhclient -r eth0 && sudo dhclient eth0

# Con NetworkManager
nmcli device reapply eth0

# IP estática manual (emergencia)
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip route add default via 192.168.1.1
```

### 3. DNS no resuelve

```bash
# Probar con DNS directo
ping 8.8.8.8                    # funciona → es DNS
ping google.com                 # falla → es DNS

# Solución temporal
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# Solución permanente
sudo resolvectl dns eth0 8.8.8.8 1.1.1.1
# o en /etc/resolv.conf:
# nameserver 8.8.8.8
# nameserver 1.1.1.1
```

### 4. Gateway no responde

```bash
# Ver gateway actual
ip route show default

# Probar reachability
ping -c 3 192.168.1.1           # gateway

# Resetear routing
sudo ip route del default
sudo ip route add default via 192.168.1.1
```

### 5. Firewall bloquea

```bash
# Ver reglas de firewall
sudo nft list ruleset
sudo iptables -L -n -v

# Desactivar temporalmente (⚠️ solo para testing)
sudo nft flush ruleset
# o
sudo iptables -F

# Verificar que no es Docker
sudo iptables -L DOCKER -n 2>/dev/null
```

### 6. Cable físico / hardware

```bash
# Verificar link
ethtool eth0 | grep "Link detected"

# Ver errores de interfaz
ip -s link show eth0
# Si hay errores RX/TX → cable o puerto defectuoso
```

### 7. Problema con VPN

```bash
# Verificar interfaz VPN
ip addr show tun0

# Verificar routing VPN
ip route get 8.8.8.8

# Reconectar VPN
sudo openvpn --config mi-vpn.ovpn
```

## Flujo de decisión

```
¿Ping a 8.8.8.8 funciona?
├── SÍ → problema es DNS o routing
│   ├── ¿Ping a google.com funciona?
│   │   ├── SÍ → problema de aplicación/firewall
│   │   └── NO → problema DNS
│   │       └── Fix: nameserver 8.8.8.8
│   └── Verificar routing: ip route get 8.8.8.8
└── NO → problema de capa 2/3
    ├── ¿Interfaz tiene IP?
    │   ├── NO → DHCP o cable
    │   │   └── Fix: dhclient o IP estática
    │   └── SÍ → gateway o firewall
    │       └── Fix: ping gateway, flush rules
    └── ¿Link detected?
        ├── NO → cable/switch defectuoso
        └── SÍ → driver o configuración
```

## Prevención

- Configurar DNS redundante (8.8.8.8 + 1.1.1.1)
- Usar NetworkManager o systemd-networkd (no configuración manual permanente)
- Documentar IP estática y gateway en un archivo de referencia
- Mantener backup de configuración de red

## Ver también

- [[WiFi no conecta]] — troubleshoot específico WiFi
- [[Redes Basicas]] — conceptos de red
- [[NetworkManager]] — gestión de red
- [[nftables]] — firewall moderno
- [[ufw]] — firewall simplificado
- [[systemd-networkd]] — alternativa a NetworkManager

## Enlaces externos

- [Arch Wiki — Network troubleshooting](https://wiki.archlinux.org/title/Network_configuration)
- [Linux Network Administrators Guide](https://tldp.org/LDP/nag/html/)
- [Wikipedia — TCP/IP model](https://en.wikipedia.org/wiki/Internet_protocol_suite)

#troubleshooting #redes
