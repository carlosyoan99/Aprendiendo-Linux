---
fecha_creacion: 2026-08-31
fecha_modificacion: 2026-09-01
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

## Instalación

```bash
# Debian / Ubuntu
sudo apt install frr

# Arch Linux / CachyOS
sudo pacman -S frr

# Fedora / RHEL
sudo dnf install frr
```

## Configuración

FRR se configura en `/etc/frr/`. Los daemons se activan con `systemctl`:

```bash
# Habilitar BGP en frr.conf (activa el daemon en zebra + bgpd)
sudo systemctl enable --now frr
sudo vtysh          # consola integrada de FRR (tipo Cisco)

# En vtysh:
# configure terminal
# router bgp 65000
# neighbor 192.0.2.1 remote-as 65000
```

`vtysh` es la shell unificada de FRR que permite configurar todos los daemons desde un único prompt, con sintaxis tipo Cisco IOS.

## Casos de uso

- **SONiC**: FRR aporta el plano de control de enrutamiento (ver [[SONiC]]).
- **Laboratorios y homelab**: emular routers BGP/OSPF en una máquina Linux o VM.
- **Routers de software**: convertir un servidor en router con OSPF/BGP sin hardware propietario.
- **Cumulus Linux / VX**: radios con FRR como sistema de routing.

## FRR vs alternativas

| Aspecto | FRR | Quagga (legacy) | Bird |
|---|---|---|---|
| Soporte | Activo, usado por SONiC | Descontinuada en gran parte | Activo |
| Protocolos | BGP OSPF IS-IS RIP MPLS | BGP OSPF RIP | BGP principalmente |
| Config | vtysh estilo Cisco | vty antiguo | archivos de texto propios |
| Caso principal | Networking OS contenedores | Routing tradicional | BGP avanzado |

## Ver también

- [[SONiC]] — networking OS cuyo plano de control usa FRR
- [[NetworkManager]] — gestión de redes del escritorio
- [[traceroute]] · [[ping]] — diagnóstico de conectividad

## Enlaces externos

- [FRRouting — sitio oficial](https://frrouting.org/)
- [FRR — Wikipedia](https://en.wikipedia.org/wiki/FRRouting)
- [FRRouting — GitHub](https://github.com/FRRouting/frr)
#programa #red #networking