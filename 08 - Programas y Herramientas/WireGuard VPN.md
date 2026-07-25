---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: programa
prioridad: alta
---

# WireGuard / VPN

## Definición

WireGuard es un protocolo y software de VPN moderno, integrado en el kernel Linux desde 2020 (kernel 5.6+). Crea **túneles cifrados** entre pares (peer-to-peer) usando criptografía moderna (Curve25519, ChaCha20, Poly1305). Es más rápido, simple y seguro que OpenVPN e IPsec.

```
Concepto de VPN sitio a sitio:

  ┌───────────┐          Túnel WireGuard          ┌───────────┐
  │           │  ─────────────────────────────►   │           │
  │ Servidor  │  UDP :51820  ────  UDP :51820     │ Servidor  │
  │ (oficina) │  ◄─────────────────────────────   │ (nube)    │
  │           │          Cifrado extremo a extremo │           │
  └───────────┘                                    └───────────┘
       │ 192.168.1.0/24                                │ 10.0.0.0/24
       │                                                │
       ▼                                                ▼
  Clientes LAN                                     Servidores nube

Concepto de VPN cliente → servidor (road warrior):

  ┌──────────┐  ──── UDP :51820 ───►  ┌──────────┐
  │ Portátil │                        │ Servidor │
  │ (cafetería)│  ◄───────────────────  │ VPN      │
  └──────────┘                        └──────────┘
  10.0.0.2/32                           10.0.0.1/32
  Todo el tráfico → WireGuard → internet → servidor → destino
```

### Por qué WireGuard

| Característica | WireGuard | OpenVPN | IPsec |
|---|---|---|---|
| **Líneas de código** | ~4,000 | ~600,000+ | ~400,000+ |
| **Rendimiento** | Muy alto (cifrado en kernel) | Medio | Alto |
| **Latencia de conexión** | < 1s | 5-15s | 5-30s |
| **Complejidad** | Baja | Alta | Muy alta |
| **Movilidad (cambio de red)** | ✅ Nativa (roaming) | ❌ Se reconecta | ❌ Se reconecta |
| **Integración en kernel** | ✅ Desde 5.6 | ❌ (userspace) | ❌ (kernel module) |
| **Configuración** | 1 archivo por peer | Certificados + config | Configuración muy verbosa |

---

## Instalación

```bash
# WireGuard está en el kernel. Solo necesitas las herramientas userspace:

# Debian/Ubuntu
sudo apt install wireguard

# Arch
sudo pacman -S wireguard-tools

# Fedora
sudo dnf install wireguard-tools

# Verificar que el módulo del kernel está disponible
sudo modprobe wireguard
lsmod | grep wireguard                   # debería aparecer cargado
```

---

## Configuración básica: servidor + cliente

WireGuard funciona con pares. Cada peer tiene una **clave privada** y una **clave pública**. La comunicación es autenticada con criptografía asimétrica.

### 1. Generar claves

```bash
# En ambos lados (servidor y cliente)
wg genkey | tee privatekey | wg pubkey > publickey

# Ver claves generadas
cat privatekey                            # ← NUNCA compartir
cat publickey                             # ← compartir con el otro peer
```

### 2. Configurar el servidor

```bash
# /etc/wireguard/wg0.conf
[Interface]
Address = 10.0.0.1/24                    # IP del servidor en la red VPN
ListenPort = 51820                        # Puerto UDP
PrivateKey = <clave-privada-del-servidor>  # ← la que genera el archivo privatekey

# Reglas de iptables/nftables para NAT (reenviar tráfico de clientes a internet)
# Ajustar -o según tu interfaz de red externa (ip link show)
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Cliente 1: portátil
[Peer]
PublicKey = <clave-pública-del-cliente-1>
AllowedIPs = 10.0.0.2/32                 # solo esta IP puede usar el túnel

# Cliente 2: móvil
[Peer]
PublicKey = <clave-pública-del-cliente-2>
AllowedIPs = 10.0.0.3/32
```

> **Abrir puerto en el firewall**: el servidor necesita el puerto UDP 51820 abierto. Ver [[Firewall]].
> ```bash
> sudo ufw allow 51820/udp
> # o con nftables
> sudo nft add rule inet filter input udp dport 51820 accept
> ```

### 3. Configurar el cliente

```bash
# /etc/wireguard/wg0.conf (en el cliente)
[Interface]
Address = 10.0.0.2/32                    # IP del cliente en la VPN
PrivateKey = <clave-privada-del-cliente>  # ← la del cliente
DNS = 1.1.1.1                             # DNS a usar (opcional, evita fugas DNS)

[Peer]
PublicKey = <clave-pública-del-servidor>
Endpoint = vpn.mi-servidor.com:51820      # IP o dominio público del servidor
AllowedIPs = 0.0.0.0/0, ::/0             # enrutar TODO el tráfico por la VPN
# AllowedIPs = 10.0.0.0/24               # solo tráfico a la red VPN
PersistentKeepalive = 25                  # mantener conexión activa (segundos)
```

> **AllowedIPs** es crítico:
> - `0.0.0.0/0, ::/0` → **túnel completo** (todo el tráfico va por la VPN — tipo "kill switch")
> - `10.0.0.0/24` → **split tunnel** (solo tráfico a la red VPN, el resto sale directo)
> - `10.0.0.0/24, 192.168.1.0/24` → múltiples redes

---

## Uso

```bash
# Activar/desactivar la interfaz
sudo wg-quick up wg0                      # levantar túnel
sudo wg-quick down wg0                    # bajar túnel

# Activar al arrancar (systemd)
sudo systemctl enable wg-quick@wg0

# Ver estado del túnel
sudo wg show                              # peers conectados, transferencia, handshake
sudo wg show wg0                          # solo interfaz wg0

# Ver la interfaz de red
ip addr show wg0
ip link show wg0
```

### Output de `wg show`

```
interface: wg0
  public key: xxxx...
  private key: (hidden)
  listening port: 51820

peer: xxxx...                        ← clave pública del cliente
  endpoint: 203.0.113.5:51820        ← IP pública del cliente
  allowed ips: 10.0.0.2/32
  latest handshake: 1 minute ago     ← última vez que se autenticó
  transfer: 1.24 GiB received, 3.50 GiB sent
  persistent keepalive: every 25 seconds
```

### Comandos de diagnóstico

```bash
# Verificar conectividad dentro de la VPN
ping 10.0.0.1                           # ping al servidor desde el cliente

# Ver qué tráfico pasa por la interfaz
sudo tcpdump -i wg0 -n

# Verificar que el puerto está accesible desde fuera
# (ejecutar desde el cliente):
nc -zv vpn.mi-servidor.com 51820

# Logs de WireGuard
sudo journalctl -u wg-quick@wg0          # logs de activación
sudo dmesg | grep wireguard              # mensajes del kernel
```

---

## Configuración avanzada

### VPN sitio a sitio (conectar dos redes)

```bash
# /etc/wireguard/wg0.conf — Servidor A (oficina, 192.168.1.0/24)
[Interface]
Address = 10.0.0.1/24
PrivateKey = <privada-A>
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -i wg0 -o eth0 -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -i wg0 -o eth0 -j ACCEPT

[Peer]
PublicKey = <pública-B>
AllowedIPs = 10.0.0.2/32, 10.0.0.0/24   # IP del peer + red remota
Endpoint = 203.0.113.10:51820
```

### Múltiples pares (road warrior)

```bash
# Un servidor, muchos clientes — solo añadir secciones [Peer]
[Peer]  # Cliente 1
PublicKey = <p1>
AllowedIPs = 10.0.0.2/32

[Peer]  # Cliente 2
PublicKey = <p2>
AllowedIPs = 10.0.0.3/32

[Peer]  # Cliente 3
PublicKey = <p3>
AllowedIPs = 10.0.0.4/32
```

### Configurar como cliente de servicios comerciales (Mullvad, ProtonVPN, etc.)

Muchos proveedores de VPN comerciales ofrecen config de WireGuard:

```bash
# 1. Descargar o copiar el archivo de configuración del proveedor
# 2. Guardarlo en /etc/wireguard/
sudo mv mullvad-us.conf /etc/wireguard/mullvad-us.conf

# 3. Conectar
sudo wg-quick up mullvad-us

# 4. Verificar IP
curl ifconfig.me                          # debería mostrar la IP del proveedor
```

---

## Q&A / Troubleshooting

| Problema | Causa probable | Solución |
|---|---|---|
| **No se conecta** | Puerto UDP bloqueado | Verificar firewall: `nc -zv IP 51820` desde fuera |
| **Handshake no progresa** | Endpoint incorrecto | Verificar IP/DNS en `Endpoint =` |
| **No hay internet después de conectar** | NAT no configurado | Revisar `PostUp` con iptables MASQUERADE |
| **Cliente se conecta pero no llega a la red local** | IP forwarding desactivado | `sudo sysctl -w net.ipv4.ip_forward=1` (y persistir en /etc/sysctl.conf) |
| **El túnel se cae solo** | Keepalive demasiado bajo | `PersistentKeepalive = 25` en el peer |
| **WireGuard consume CPU** | Muy raro — verificar aceleración criptográfica del kernel | `cat /proc/crypto | grep -A2 chacha20` |
| **El cliente solo usa DNS del proveedor pero quiero otro** | DNS forzado en el Interface | Cambiar o quitar `DNS =` en la interfaz del cliente |

### Habilitar IP forwarding (necesario para servidor)

```bash
# Temporal
sudo sysctl -w net.ipv4.ip_forward=1

# Permanente
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/99-ipforward.conf
# o editar /etc/sysctl.conf
```

---

## Seguridad y consideraciones

- **Kill switch**: con `AllowedIPs = 0.0.0.0/0`, si el túnel se cae, no hay conectividad (no hay ruta por defecto fuera de la VPN). Esto evita fugas de tráfico.
- **Claves**: la clave privada NO debe salir del equipo. Si se compromete, generar un nuevo par y actualizar `PublicKey` en el otro peer.
- **Firmware/App**: existen clientes WireGuard oficiales para Android, iOS, Windows, macOS y Linux.
- **No tiene logs**: WireGuard no registra conexiones por defecto. Si necesitas auditoría, configura el nivel de log del kernel.
- **No tiene autenticación de usuario**: WireGuard autentica **máquinas** (por clave pública), no usuarios. Para VPN corporativa combínalo con autenticación adicional.

---

## Ver también

- [[Firewall]] — abrir puerto UDP para WireGuard
- [[Redes Basicas]] — conceptos de red subyacentes
- [[SSH]] — alternativa para túneles simples (forwarding de puertos)
- [[Cifrado (LUKS dm-crypt GPG)]] — criptografía en Linux
- [[systemd]] — systemd-networkd puede gestionar WireGuard
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — módulos del kernel

## Enlaces externos

- [Wikipedia — WireGuard](https://en.wikipedia.org/wiki/WireGuard)
- [Sitio oficial — WireGuard](https://www.wireguard.com/)
- [GitHub — WireGuard/wireguard-linux](https://github.com/WireGuard/wireguard-linux)

#programa #redes
