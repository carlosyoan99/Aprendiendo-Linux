---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: comando
prioridad: alta
---

# ip

## Sintaxis
```bash
ip [opciones] objeto comando
```

## Descripción
Gestiona interfaces de red, direcciones IP, rutas y vecinos. Es el reemplazo moderno de `ifconfig` y `route`. Forma parte del paquete `iproute2` (instalado en todo Linux moderno).

## Objetos principales

| Objeto | Abreviatura | Función | Reemplaza a |
|---|---|---|---|
| `address` | `a` | Ver/configurar direcciones IP | `ifconfig` |
| `link` | `l` | Ver/configurar interfaces de red | `ifconfig` |
| `route` | `r` | Ver/configurar tabla de rutas | `route` |
| `neigh` | `n` | Ver tabla ARP/NDP | `arp` |

## Opciones y subcomandos frecuentes

### ip address (o `ip a`) — Ver interfaces e IPs
```bash
ip a                             # todas las interfaces con IPs (el más común)
ip -c a                          # con colores (desde iproute2 5.x)
ip -4 a                          # solo IPv4
ip -6 a                          # solo IPv6
ip addr show dev eth0            # una interfaz específica
ip addr add 192.168.1.10/24 dev eth0   # asignar IP temporal
ip addr del 192.168.1.10/24 dev eth0   # eliminar IP
```

### ip link — Gestionar interfaces
```bash
ip link                          # listar interfaces de red
ip link set eth0 up              # activar interfaz
ip link set eth0 down            # desactivar interfaz
ip link set eth0 mtu 1500        # cambiar MTU
```

### ip route — Tabla de enrutamiento
```bash
ip route                         # ver tabla de rutas (gateway, subredes)
ip route show default            # ver solo el gateway por defecto
ip route add 10.0.0.0/8 via 192.168.1.1   # añadir ruta estática
ip route del 10.0.0.0/8                   # eliminar ruta
```

## Ejemplos de diagnóstico rápido
```bash
# ¿Cuál es mi IP?
ip -4 a | grep inet

# ¿Está la interfaz activa?
ip link show eth0 | grep state UP

# ¿Cuál es mi gateway?
ip route | grep default

# ¿Qué dispositivos de red tengo?
ip link | grep -E '^[0-9]' | cut -d: -f2
```

## ip vs ifconfig

| Característica | ip | ifconfig |
|---|---|---|
| **Reemplazo moderno** | ✅ Sí | ✅ Histórico (obsoleto) |
| **Disponibilidad** | ✅ Viene en toda distro moderna | ⚠️ Puede no venir en distros nuevas |
| **Rendimiento** | ⭐ Más rápido | 🐢 Más lento |
| **Características** | Más completo (namespaces, VRF, bridges) | Funcionalidad básica |
| **Scripting** | Salida consistente y parseable | Formato varía entre versiones |

## Notas
- `ip a` es el equivalente de `ifconfig` y es el primer comando que usas para ver tu IP.
- `ip route` muestra el gateway (reemplaza `route -n`).
- Todos los cambios con `ip` son **temporales** (se pierden al reiniciar). Para cambios permanentes se usa `nmcli`, `netplan`, o configurar `/etc/network/interfaces`.

## Ver también
- [[ss]] — puertos abiertos y conexiones
- [[ping]] — probar conectividad
- [[Redes Basicas]] — fundamentos
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia - iproute2](https://en.wikipedia.org/wiki/Iproute2)
- [Linux man page - ip](https://man7.org/linux/man-pages/man8/ip.8.html)

#comando