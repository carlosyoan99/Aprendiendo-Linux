---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: alta
---

# Redes Básicas

## Definición

Conceptos mínimos para entender cómo tu máquina Linux se conecta y diagnosticar problemas de red sin adivinar.

## Conceptos clave

| Término | Qué es |
|---|---|
| **IP** | Dirección que identifica tu equipo en una red. IPv4 (192.168.1.10) o IPv6 (fe80::1) |
| **Máscara de red** | Define qué parte de la IP es red y qué parte es equipo. `/24` = `255.255.255.0` = 254 equipos posibles |
| **Puerto** | Punto de entrada/salida para un servicio (22=SSH, 80=HTTP, 443=HTTPS) |
| **DNS** | Traduce nombres de dominio (google.com) a IPs (142.250.184.46) |
| **Gateway** | El router por donde sale tu tráfico hacia otras redes |
| **Interfaz** | El dispositivo de red: `eth0`/`enp3s0` (cable), `wlan0`/`wlp2s0` (WiFi), `lo` (loopback) |
| **DHCP** | Protocolo que asigna IP, gateway y DNS automáticamente al conectar |
| **MAC** | Dirección física única de la tarjeta de red (capa 2). Se ve con `ip link` |

## Gestión de conexiones con NetworkManager

### nmcli (línea de comandos)

```bash
# Ver estado general
nmcli general status                   # conectado/desconectado
nmcli networking connectivity          # full/limited/none

# Ver interfaces y conexiones
nmcli device status                    # dispositivos y su estado
nmcli connection show                  # conexiones guardadas
nmcli connection show --active         # solo conexiones activas

# Conectarse a WiFi (si no hay GUI)
nmcli device wifi list                 # escanear redes disponibles
nmcli device wifi connect "MiRed" password "mipassword"  # conectar
nmcli device wifi connect "MiRed" --ask                # que pregunte la contraseña

# Conectar/desconectar una conexión guardada
nmcli connection up "MiCasa"
nmcli connection down "MiCasa"

# Crear/perfil de conexión manual (IP fija)
nmcli connection add type ethernet con-name "Trabajo" \
  ipv4.method manual \
  ipv4.addresses 192.168.1.100/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns "8.8.8.8 1.1.1.1"

# Eliminar una conexión
nmcli connection delete "ViejaRed"
```

### nmtui (interfaz de texto)

```bash
nmtui                                   # menú interactivo en terminal
# Útil en servidores sin GUI o cuando estás en TTY
# Permite: activar/desactivar conexiones, editar, crear nuevas
```

## Comandos de diagnóstico

```bash
# Interfaces y direcciones
ip a                                   # ver todas las interfaces e IPs
ip link set wlan0 up                   # activar interfaz (si está DOWN)

# Tabla de rutas (gateway)
ip route                               # ruta por defecto y rutas estáticas
ip route add default via 192.168.1.1   # añadir gateway manualmente

# Puertos abiertos y conexiones activas
ss -tulpn                              # TCP/UDP listening, con PID (reemplaza netstat)
ss -tunap                              # todas las conexiones activas

# Conectividad básica
ping -c 4 8.8.8.8                      # 4 paquetes, sin depender de DNS
ping -c 4 google.com                   # prueba completa con resolución DNS

# Resolución DNS
dig google.com                         # consulta DNS detallada
dig google.com +short                  # solo la IP
host google.com                        # versión simplificada
nslookup google.com                    # otra alternativa

# Resolución de nombres locales
getent hosts localhost                 # qué resuelve /etc/hosts
getent ahosts google.com              # consultar todas las IPs de un dominio

# Velocidad y calidad del enlace
ethtool enp3s0                         # velocidad, duplex, negociación

# Traceroute (camino hasta un host)
traceroute google.com                  # cada salto hasta el destino
```

## Archivos de configuración de red

```bash
# Resolución de nombres (orden de prioridad)
cat /etc/nsswitch.conf | grep hosts    # hosts: files dns ← primero /etc/hosts, luego DNS

# Hosts estáticos (sobrescribe DNS)
cat /etc/hosts                         # 127.0.0.1 localhost

# DNS servers (tradicional, NetworkManager lo sobreescribe)
cat /etc/resolv.conf                   # puede ser un symlink a /run/systemd/resolve/stub-resolv.conf

# Interfaz de red estática (ya casi no se usa, reemplazado por NetworkManager)
cat /etc/network/interfaces            # aún usado en Debian sin NetworkManager
```

## DHCP (obtención automática de IP)

Cuando te conectas a una red, tu máquina pide IP automáticamente por DHCP. No suele necesitar configuración manual, pero si algo falla:

```bash
# Renovar IP (soltar y pedir de nuevo)
sudo dhclient -v wlan0                 # cliente DHCP tradicional
sudo dhcpcd wlan0                      # alternativa en Arch
sudo nmcli connection up "MiRed"       # con NetworkManager (renueva automáticamente)

# Ver qué servidor DHCP te asignó la IP
journalctl -u NetworkManager | grep -i dhcp
```

## Troubleshooting paso a paso

```
¿No tienes internet?

1. ip a                ¿la interfaz está UP? ¿tiene IP?
   ├── No → ip link set wlan0 up
   └── Sí → siguiente

2. ip route            ¿hay gateway?
   ├── No → falta configuración DHCP o IP fija sin gateway
   └── Sí → siguiente

3. ping -c 3 8.8.8.8    ¿llega a internet?
   ├── No → problema de gateway/router, no de tu PC
   └── Sí → siguiente

4. dig google.com       ¿resuelve DNS?
   ├── No → /etc/resolv.conf vacío o incorrecto
   └── Sí → todo funciona, problema en otra capa
```

### Casos comunes

| Síntoma | Causa probable | Solución |
|---|---|---|
| `ip a` muestra `NO-CARRIER` | Cable desconectado o WiFi apagado | Verificar conexión física o rfkill |
| WiFi visible pero no conecta | Contraseña incorrecta o red oculta | `nmcli device wifi list`, verificar SSID |
| Conectado pero sin IP | DHCP fallando | `sudo dhclient -v wlan0` |
| IP asignada pero no hay internet | Gateway incorrecto o router caído | `ip route`, verificar con ping al gateway |
| Ping a IP funciona, ping a nombre no | DNS no configurado | Verificar `/etc/resolv.conf`, añadir `1.1.1.1` |
| Se conecta pero muy lento | Interferencia WiFi, driver bug, IPv6 | Probar con `ethtool`, desactivar IPv6 |
| WiFi se desconecta aleatoriamente | Ahorro de energía | `iwconfig wlan0 power off` |

## Wi-Fi: herramientas adicionales

```bash
# Ver intensidad de señal y canales
iwconfig                             # info básica de WiFi
iw dev wlan0 link                    # señal, frecuencia, tasa de bits

sudo iwlist wlan0 scan | grep -E "SSID|Signal|Channel"   # escaneo detallado (requiere sudo)

# Desbloquear WiFi si está bloqueado por hardware (rfkill)
rfkill list                          # ver estado de switches
sudo rfkill unblock wifi             # desbloquear

# Modo avión en software
nmcli radio wifi off                  # apagar WiFi
nmcli radio wifi on                   # encender WiFi
```

## Perfiles de conexión (NetworkManager)

```bash
# Las conexiones se guardan en /etc/NetworkManager/system-connections/
# Puedes copiar/editar estos archivos para duplicar perfiles
ls /etc/NetworkManager/system-connections/
```

## Por qué importa

"No tengo internet" es el problema más común. Entender las capas (interfaz → IP → gateway → DNS) y saber usar `ip`, `ping`, `nmcli` y `dig` convierte la adivinanza en diagnóstico sistemático.

## Ver también

- [[Utilidades Base del Sistema]] — ethtool, iw, rfkill
- [[SSH]] — conexión remota
- [[WiFi no conecta]] — troubleshooting específico
- [[systemd]] — systemd-resolved para DNS

## Enlaces externos

- [Wikipedia — Computer network](https://en.wikipedia.org/wiki/Computer_network)
- [Wikipedia — OSI model](https://en.wikipedia.org/wiki/OSI_model)
- [Wikipedia — Internet Protocol Suite (TCP/IP)](https://en.wikipedia.org/wiki/Internet_protocol_suite)
- [Arch Wiki — Network configuration](https://wiki.archlinux.org/title/Network_configuration)

#sistema
