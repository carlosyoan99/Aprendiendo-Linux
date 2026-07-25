---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# ip

> Gestiona interfaces de red, direcciones IP, rutas y conexiones. Reemplazo moderno de `ifconfig`, `route` y `arp`. Viene preinstalado en todo Linux moderno.

## Sintaxis

```bash
ip [opciones] objeto comando
```

## Descripción

`ip` es la herramienta de red del paquete `iproute2`, instalado por defecto en cualquier Linux moderno. Unifica en un solo comando lo que antes requería `ifconfig`, `route`, `arp` y `netstat`. Soporta IPv4, IPv6, namespaces, VRF, bridges, VLANs, túneles y más.

> **⚠️**: Todos los cambios con `ip` son **temporales** — se pierden al reiniciar. Para persistir, usa `nmcli`, `netplan`, `systemd-networkd`, o edita `/etc/network/interfaces`.

## Formato de salida

```bash
ip a
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 state UNKNOWN qlen 1000
#     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
#     inet 127.0.0.1/8 scope host lo
#        valid_lft forever preferred_lft forever
# 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP qlen 1000
#     link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
#     inet 192.168.1.10/24 brd 192.168.1.255 scope global eth0
#        valid_lft forever preferred_lft forever
```

**Campos clave del identificador:**
| Campo | Significado |
|---|---|
| `1:` | Número de interfaz (índice) |
| `lo`, `eth0` | Nombre de la interfaz |
| `UP` | Estado administrativo (interfaz activa) |
| `LOWER_UP` | Estado físico (cable conectado) |
| `mtu 1500` | Maximum Transmission Unit |
| `state UP/UNKNOWN` | Estado operativo |
| `link/ether` | Dirección MAC |
| `inet` | IPv4 |
| `inet6` | IPv6 |

## Opciones globales

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-4` | Solo IPv4 | `ip -4 a` |
| `-6` | Solo IPv6 | `ip -6 a` |
| `-c` | Colorear salida | `ip -c a` |
| `-d` | Mostrar detalles adicionales | `ip -d link show veth0` |
| `-s` | Estadísticas (repite para más detalle) | `ip -s link` |
| `-ss` | Estadísticas detalladas | `ip -s -s link` |
| `-r` | Resolver nombres DNS | `ip -r neigh` |
| `-n <ns>` | Ejecutar en namespace | `ip -n contenedor1 a` |
| `-j` | Salida JSON (para scripting) | `ip -j a \| jq '.[]'` |
| `-p` | Salida pretty-print (con -j) | `ip -j -p a` |
| `-b <archivo>` | Ejecutar comandos batch | `ip -b comandos.txt` |

## Objetos principales

| Objeto | Abreviatura | Función | Reemplaza a |
|---|---|---|---|
| `address` | `a` | Ver/configurar direcciones IP | `ifconfig` |
| `link` | `l` | Ver/configurar interfaces de red | `ifconfig` |
| `route` | `r` | Ver/configurar tabla de rutas | `route` |
| `neigh` | `n` | Ver tabla ARP/NDP | `arp` |
| `maddr` | `m` | Direcciones multicast | `ipmaddr` |
| `mroute` | `mr` | Rutas multicast | — |
| `monitor` | `m` | Monitorear eventos de red en tiempo real | — |
| `netns` | `ns` | Namespaces de red | — |
| `tcp_metrics` | `tcpmetrics` | Métricas TCP | — |
| `vrf` | — | Virtual Routing and Forwarding | — |
| `tunnel` | `t` | Túneles IPIP/GRE/VXLAN | — |
| `xfrm` | `x` | Políticas IPsec | — |

## Ejemplos detallados

### ip address — Direcciones IP

```bash
# ===== Ver direcciones =====
ip a                              # todas las interfaces (el más común)
ip -c a                           # con colores (iproute2 5.x+)
ip -4 a                           # solo IPv4
ip -6 a                           # solo IPv6
ip addr show dev eth0             # una interfaz específica
ip addr show dynamic              # solo IPs dinámicas (DHCP)
ip -j -p a                        # salida JSON (para jq)
ip -j a | jq '.[].addr_info[].local'  # extraer solo IPs

# ===== Añadir/eliminar IPs (temporales) =====
sudo ip addr add 192.168.1.10/24 dev eth0       # añadir IP
sudo ip addr add 192.168.1.11/24 dev eth0       # añadir IP secundaria
sudo ip addr del 192.168.1.11/24 dev eth0       # eliminar IP
sudo ip addr flush dev eth0                     # eliminar TODAS las IPs de eth0
sudo ip addr add 10.0.0.5/32 dev lo             # alias en loopback
```

### ip link — Interfaces físicas y virtuales

```bash
# ===== Ver interfaces =====
ip link                          # listar interfaces (sin IPs)
ip -s link                       # con estadísticas de tráfico
ip -d link show eth0             # detalles de la interfaz
ip link show type bridge         # solo bridges
ip link show type vlan           # solo VLANs
ip link show type veth           # solo veth (pares virtuales)

# ===== Gestionar interfaces =====
sudo ip link set eth0 up         # activar interfaz
sudo ip link set eth0 down       # desactivar interfaz
sudo ip link set eth0 mtu 1500   # cambiar MTU
sudo ip link set eth0 address 52:54:00:aa:bb:cc  # cambiar MAC (temporal)
sudo ip link set eth0 promisc on # modo promiscuo (para sniffing)
sudo ip link set eth0 multicast on   # habilitar multicast
sudo ip link set eth0 txqueuelen 1000  # cola de transmisión

# ===== Interfaces virtuales =====
sudo ip link add name br0 type bridge              # crear bridge
sudo ip link add veth0 type veth peer name veth1   # crear par veth
sudo ip link add vlan10 link eth0 type vlan id 10   # VLAN 10

# ===== Eliminar interfaces virtuales =====
sudo ip link del veth0                              # eliminar veth
sudo ip link del br0                                # eliminar bridge
```

### ip route — Tabla de enrutamiento

```bash
# ===== Ver rutas =====
ip route                         # tabla de rutas completa
ip route show default            # solo el gateway por defecto
ip route list                    # lista detallada
ip route show table all          # todas las tablas de rutas
ip route get 8.8.8.8             # qué ruta se usaría para llegar a 8.8.8.8
ip route get 192.168.1.100 from 10.0.0.1 iif eth1  # ruta desde IP origen
ip route show cache              # caché de rutas (FIB)
# ===== Añadir/eliminar rutas estáticas =====
sudo ip route add 10.0.0.0/8 via 192.168.1.1       # ruta estática
sudo ip route add 10.0.0.0/8 via 192.168.1.1 dev eth0  # con interfaz específica
sudo ip route del 10.0.0.0/8                        # eliminar ruta
sudo ip route replace default via 192.168.1.1 dev eth0   # cambiar gateway

# ===== Rutas en tablas múltiples =====
sudo ip route add 10.0.0.0/8 via 192.168.1.1 table 100   # ruta en tabla 100
sudo ip rule add from 192.168.1.0/24 table 100           # regla de enrutamiento
```

### ip neigh — Tabla de vecinos (ARP/NDP)

```bash
ip neigh                        # tabla ARP completa (IPv4) y NDP (IPv6)
ip neigh show dev eth0          # vecinos en una interfaz específica
ip neigh list nud reachable     # solo vecinos alcanables
sudo ip neigh add 192.168.1.5 lladdr aa:bb:cc:dd:ee:ff dev eth0  # añadir entrada estática
sudo ip neigh del 192.168.1.5 dev eth0         # eliminar entrada
sudo ip neigh flush dev eth0                   # limpiar toda la tabla de eth0
sudo ip neigh change 192.168.1.5 lladdr ff:ee:dd:cc:bb:aa dev eth0  # cambiar MAC
```

### ip monitor — Eventos de red en tiempo real

```bash
ip monitor                       # monitorear todos los eventos de red
ip monitor all                   # incluir neigh, route, link
ip monitor link dev eth0         # solo eventos de eth0
ip monitor route                 # solo cambios en rutas
# Abre un proceso en vivo: muestra cambios conforme ocurren (¡no termina solo!)
# Útil para depurar: conecta/desconecta un cable y ves el evento en vivo
```

## Casos de uso reales

| Escenario | Comandos |
|---|---|
| **Saber mi IP** | `ip -4 a \| grep inet` o más directo: `hostname -I` |
| **¿Está la interfaz activa?** | `ip link show eth0 \| grep -o 'state [A-Z]*'` |
| **¿Cuál es mi gateway?** | `ip route \| grep default` |
| **¿Qué dispositivos de red tengo?** | `ip link \| grep -E '^[0-9]' \| cut -d: -f2 \| tr -d ' '` |
| **Añadir IP temporal a un contenedor** | `sudo ip addr add 10.0.0.5/24 dev veth0` |
| **Saber qué ruta toma un paquete** | `ip route get 8.8.8.8` |
| **Ver estadísticas de tráfico por interfaz** | `ip -s link` |
| **Crear bridge para LXC/Docker** | `sudo ip link add br0 type bridge; sudo ip link set br0 up` |
| **Aislar aplicación en namespace** | `sudo ip netns add aislamiento; sudo ip netns exec aislamiento bash` |
| **Monitorear cambios de red en vivo** | `ip monitor` (dejar corriendo en otra terminal) |
| **Flushear IPs de una interfaz** | `sudo ip addr flush dev eth0` (útil al cambiar de DHCP a estática) |

## Combinaciones comunes con pipe

```bash
# Mostrar solo IPs
ip -4 a | grep inet | awk '{print $2}'

# Mostrar solo nombres de interfaces activas
ip link | grep 'state UP' | grep -oP '^\d+: \K[^:]+'

# Contar direcciones IP por interfaz
ip -4 a | grep -E '^[0-9]|inet' | grep -B1 inet | grep -v '^--$'

# Estadísticas de tráfico: RX/TX
ip -s link show eth0 | grep -E 'RX:|TX:|bytes'

# Ver tabla ARP en formato legible
ip neigh | column -t

# Exportar IPs en JSON y filtrar con jq
ip -j -p a | jq '.[] | select(.ifname != "lo") | {ifname, addr_info: [.addr_info[] | {local, family}]}' | head -50

# Ver qué interfaces tienen IP asignada
ip -4 a | grep -B2 inet | grep -E '^[0-9]' | awk -F: '{print $2}'

# Mostrar tabla de rutas sin líneas de metadatos
ip route | grep -v 'proto'
```

## iproute2 avanzado

### Namespaces de red (ip netns)

```bash
# Crear y gestionar namespaces
sudo ip netns add cliente                  # crear namespace
sudo ip netns list                         # listar namespaces
sudo ip netns exec cliente bash            # ejecutar comando dentro del ns

# Conectar dos namespaces con veth
sudo ip link add veth-a type veth peer name veth-b
sudo ip link set veth-a netns cliente      # mover veth-a al namespace cliente
sudo ip link set veth-b netns servidor     # mover veth-b al ns servidor

# Configurar IPs dentro del namespace
sudo ip -n cliente addr add 10.0.0.1/24 dev veth-a
sudo ip -n servidor addr add 10.0.0.2/24 dev veth-b
sudo ip -n cliente link set veth-a up
sudo ip -n servidor link set veth-b up

# Probar conectividad
sudo ip netns exec cliente ping 10.0.0.2
```

### Bridges (puentes de red)

```bash
# Bridge básico
sudo ip link add br0 type bridge
sudo ip link set eth0 master br0          # añadir eth0 al bridge
sudo ip link set eth1 master br0          # añadir eth1 al bridge
sudo ip link set br0 up
sudo ip addr add 192.168.1.10/24 dev br0  # IP del bridge

# Bridge con STP (Spanning Tree)
sudo ip link add br0 type bridge stp_state 1

# Ver bridges y sus puertos
bridge link show
bridge vlan show
```

### Túneles (si aplica)
```bash
# Tunnel GRE
ip tunnel add gre1 mode gre remote 10.0.0.1 local 192.168.1.10 ttl 255
ip link set gre1 up
ip addr add 10.0.1.1/30 dev gre1

# VXLAN
ip link add vxlan0 type vxlan id 100 dev eth0 remote 10.0.0.2 dstport 4789
```

## ip vs ifconfig vs nmcli

| Característica | ip | ifconfig | nmcli |
|---|---|---|---|
| **Estado** | ✅ Moderno, activo | ❌ Obsoleto | ✅ Moderno |
| **Disponibilidad** | ✅ Viene en toda distro | ⚠️ Paquete separado (`net-tools`) | ✅ Viene con NetworkManager |
| **Rendimiento** | ⭐ Rápido | 🐢 Lento | 🐢 Más lento (habla con D-Bus) |
| **Cambios persistentes** | ❌ Solo temporales | ❌ Solo temporales | ✅ Sí, persistentes |
| **WiFi** | ❌ No | ❌ No | ✅ Sí |
| **Scripting** | ⭐ Salida estable y parseable | ❌ Inconsistente | ⭐ Salida estable |
| **JSON output** | ✅ Sí (`-j`) | ❌ No | ✅ Sí (`--json`) |
| **Namespaces/VRF** | ✅ Sí | ❌ No | ❌ No |
| **Completitud** | ✅ Unifica todo | ❌ Básico | ✅ WiFi + Ethernet + VPN |

**Cuándo usar cada uno:**
- **`ip`**: Diagnóstico rápido, scripting, config temporal, features avanzadas (namespaces, bridges, túneles)
- **`nmcli`**: Cambios permanentes de red (WiFi, Ethernet, VPN), gestión de conexiones NetworkManager
- **`ifconfig`**: Solo si estás en un sistema legacy que no tiene ip (casi extinto)

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `RTNETLINK answers: Operation not permitted` | Falta `sudo` | Ejecutar con `sudo` |
| `Cannot find device "eth0"` | La interfaz no existe o tiene otro nombre | `ip link` para listar interfaces disponibles |
| `Device "eth0" does not exist` | Nombre incorrecto (systemd renombra: ens33, enp2s0) | Verificar con `ip link` |
| `RTNETLINK answers: File exists` | IP ya asignada o ruta ya existe | Verificar con `ip a` o `ip route` |
| `RTNETLINK answers: Network is unreachable` | No hay ruta al destino | Verificar gateway con `ip route` |
| `RTNETLINK answers: Permission denied` | Namespace no accesible o falta permiso | Ejecutar con sudo dentro del ns |
| `ip: command not found` | iproute2 no instalado (muy raro) | `sudo apt install iproute2` |
| La IP no persiste al reiniciar | `ip addr add` es temporal | Usar `nmcli`, `netplan` o config de red de la distro |

## Notas y advertencias

- **`ip a` es el `ifconfig` moderno**: es el primer comando que usas para diagnosticar red.
- **Cambios temporales por diseño**: `ip` opera en caliente. Úsalo para pruebas y diagnosis. Para persistir, usa la herramienta de red de tu distro (`nmcli`, `netplan`, `systemd-networkd`).
- **`ip -c` requiere terminal a color**: si ves la salida sin color, asegúrate de que tu terminal lo soporte.
- **systemd renombra interfaces**: ya no verás `eth0` sino `enp2s0`, `ens33`, etc. (Predictable Network Interface Names). Usa `ip link` para descubrir el nombre correcto.
- **JSON output (`-j`)**: Ideal para scripting desde Bash con `jq`. Las propiedades están bien documentadas.
- **Interfaces virtuales**: Docker, LXC y Podman crean `docker0`, `veth*`, `br-*`. `ip link show type veth` las lista todas.
- **Compatibilidad hacia atrás**: `iproute2` sigue recibiendo actualizaciones. No va a desaparecer.

## Enlaces externos

- [Wikipedia - iproute2](https://en.wikipedia.org/wiki/Iproute2)
- [Linux man page - ip(8)](https://man7.org/linux/man-pages/man8/ip.8.html)
- [Arch Wiki - Network configuration](https://wiki.archlinux.org/title/Network_configuration)
- [iproute2 GitHub](https://github.com/shemminger/iproute2)
- [iproute2 cheat sheet (Baturin)](https://baturin.org/docs/iproute2/)

## Ver también

- [[ss]] — puertos abiertos y conexiones
- [[ping]] — probar conectividad
- [[nc]] — pruebas de puerto TCP/UDP
- [[curl]] — pruebas HTTP
- [[Redes Basicas]] — fundamentos de red
- [[Namespaces (Linux)]] — aislamiento de red con namespaces
- [[nmcli]] — gestión persistente de redes
- [[Cheat Sheet - Comandos Esenciales]]

#comando #redes