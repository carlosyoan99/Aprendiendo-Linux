---
fecha_creacion: 2026-08-31
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPLv2
---

# FRRouting (FRR)

> Suite de **routing de red** open source, sucesora de Quagga, que implementa protocolos de enrutamiento (BGP, OSPF, IS-IS, RIP) como daemons independientes. Es el motor de enrutamiento de muchos networking OS como SONiC o Cumulus Linux.

## Qué es

**FRRouting** (FRR) es un conjunto de daemons de enrutamiento modular para Linux, derivado de Quagga. Cada protocolo corre como un proceso separado (`bgpd`, `ospfd`, `isisd`, `ripd`, `zebra`…) que comparte estado a través del daemon central **`zebra`**, el cual gestiona el kernel de red y las rutas.

FRR es clave en el ecosistema *network OS*: **SONiC** (Microsoft) lo usa como su capa de enrutamiento, y distro networking como Cumulus VX lo incluyen. Reemplaza routers dedicados por software sobre hardware estándar.

## Arquitectura

| Daemon | Función |
|---|---|
| `zebra` | Núcleo: maneja rutas, conecta los protocolos con el kernel (netlink) |
| `bgpd` | Border Gateway Protocol (BGP), para interconexión de redes/autónomos |
| `ospfd` | Open Shortest Path First (OSPFv2, IPv4) |
| `ospf6d` | OSPFv3 (IPv6) |
| `isisd` | IS-IS |
| `ripd` / `ripngd` | RIP / RIPng |
| `ldpd` | MPLS LDP |
| `staticd` | Rutas estáticas centralizadas (evita duplicar en cada daemon) |
| `pimd` | Multicast PIM |

## Instalación

```bash
# Debian / Ubuntu
sudo apt install frr

# Arch Linux / CachyOS
sudo pacman -S frr

# Fedora / RHEL
sudo dnf install frr

# Tras instalar, descomentar los daemons que quieras activar:
sudo sed -i 's/^bgpd=no/bgpd=yes/' /etc/frr/daemons
sudo sed -i 's/^ospfd=no/ospfd=yes/' /etc/frr/daemons
sudo systemctl restart frr
```

En Debian/Ubuntu los daemons vienen **desactivados por defecto** en `/etc/frr/daemons` — hay que ponerlos a `yes` explícitamente o `zebra` correrá sin protocolos.

## Configuración

FRR se configura en `/etc/frr/`. Los daemons se activan con `systemctl`:

```bash
sudo systemctl enable --now frr
sudo vtysh          # consola integrada de FRR (tipo Cisco)
```

`vtysh` es la shell unificada de FRR que permite configurar todos los daemons desde un único prompt, con sintaxis tipo Cisco IOS. La configuración se guarda en `/etc/frr/frr.conf` con `write memory`.

### Ejemplo: BGP básico

```
vtysh> enable
vtysh# configure terminal
vtysh(config)# router bgp 65000
vtysh(config-router)# neighbor 192.0.2.1 remote-as 65000
vtysh(config-router)# neighbor 198.51.100.2 remote-as 65001
vtysh(config-router)# network 203.0.113.0/24
vtysh(config-router)# exit
vtysh(config)# write memory
```

### Ejemplo: OSPF

```
vtysh(config)# router ospf
vtysh(config-router)# network 10.0.0.0/24 area 0
vtysh(config-router)# network 10.0.1.0/24 area 0
vtysh(config-router)# passive-interface default
vtysh(config-router)# exit
```

### Comandos de verificación

```bash
sudo vtysh -c "show ip route"            # tabla de rutas gestionada por zebra
sudo vtysh -c "show bgp summary"         # estado de vecinos BGP
sudo vtysh -c "show bgp ipv4 unicast"    # rutas BGP aprendidas
sudo vtysh -c "show ip ospf neighbor"    # vecinos OSPF
sudo vtysh -c "show interfaces"          # interfaces conocidas por FRR
sudo vtysh -c "ping 192.0.2.1"           # ping desde el contexto FRR
sudo vtysh -c "show running-config"      # config activa
```

También se puede consultar con `vtysh -c "comando"` desde scripts — útil para monitorizar vecinos BGP con cron o un exporter.

## Recarga sin cortar sesiones

```bash
# Recargar la configuración en caliente (compara frr.conf con la config activa)
sudo frr-reload.py /etc/frr/frr.conf

# Alternativa en distribuciones con systemd:
sudo systemctl reload frr
```

`frr-reload.py` aplica solo los cambios incrementales (nuevos vecinos, prefijos) sin reiniciar los daemons — evita cortar sesiones BGP existentes.

## Casos de uso

- **SONiC**: FRR aporta el plano de control de enrutamiento (ver [[SONiC]]).
- **Laboratorios y homelab**: emular routers BGP/OSPF en una máquina Linux o VM.
- **Routers de software**: convertir un servidor en router con OSPF/BGP sin hardware propietario.
- **Cumulus Linux / VX**: radios con FRR como sistema de routing.
- **Homelab con BGP**: anunciar una red pública (con un VPS y AS propio) usando FRR en lugar de un router físico.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Los daemons no arrancan | Activados a `no` en `/etc/frr/daemons` | Ponerlos a `yes` y `systemctl restart frr` |
| `vtysh` no muestra el daemon | Daemon caído o socket ausente | Verificar `systemctl status frr` y el socket `/run/frr/*.vty` |
| Vecino BGP no establece sesión | ACL/firewall bloqueando puerto 179 | Permitir TCP 179 bidireccional; `show bgp summary` para ver el estado |
| `write memory` falla | Permisos del usuario vtysh | Asegurar que el usuario está en el grupo `frrvty` |
| Rutas aprendidas no entran en el kernel | `zebra` sin autoridad sobre la tabla | Comprobar `show ip route` en zebra y el reenvío `net.ipv4.ip_forward=1` |
| MTU/MTU mismatch con el vecino | OSPF/BGP con MTU distinto | Configurar mismo MTU en ambas interfaces o `ip ospf mtu-ignore` |

## FRR vs alternativas

| Aspecto | FRR | Quagga (legacy) | Bird |
|---|---|---|---|
| Soporte | Activo, usado por SONiC | Descontinuada en gran parte | Activo |
| Protocolos | BGP OSPF IS-IS RIP MPLS | BGP OSPF RIP | BGP principalmente |
| Config | vtysh estilo Cisco | vty antiguo | archivos de texto propios |
| Caso principal | Networking OS contenedores | Routing tradicional | BGP avanzado |

**Cuándo elegir cada uno**: FRR si necesitas multi-protocolo, estilo Cisco y compatibilidad con SONiC/Cumulus; Bird si solo necesitas BGP ligero con config en texto plano (muy usado en homelab y Anycast); Quagga solo si mantienes un sistema legacy.

## Ver también

- [[SONiC]] — networking OS cuyo plano de control usa FRR
- [[NetworkManager]] — gestión de redes del escritorio
- [[traceroute]] · [[ping]] — diagnóstico de conectividad
- [[nftables]] — firewall para permitir sesiones BGP/OSPF

## Enlaces externos

- [FRRouting — sitio oficial](https://frrouting.org/)
- [FRR — Wikipedia](https://en.wikipedia.org/wiki/FRRouting)
- [FRRouting — GitHub](https://github.com/FRRouting/frr)
#programa #red #networking