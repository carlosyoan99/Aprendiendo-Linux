---
fecha_creacion: 2026-07-20
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL + Apache
alternativas: Cumulus Linux, FRRouting
---

# SONiC

> Sistema operativo de red **open source** basado en Linux, desarrollado originalmente por **Microsoft** para switches de centro de datos. Desde 2022 es un proyecto de la **Linux Foundation**. Usado en **Microsoft Azure** y por más de 850 miembros de la comunidad.

## Historia

| Hito | Año |
|---|---|
| Desarrollo inicial por Microsoft | 2015–2016 |
| Publicación como open source (OCP) | Marzo 2016 |
| Adopción en Azure | 2017 |
| Comunidad supera 850 miembros | 2022 |
| Cesión a la Linux Foundation | 2022 |

SONiC nació de la necesidad de Microsoft de ejecutar la misma pila de red en hardware de distintos fabricantes en Azure. Antes, cada switch requería su propio sistema operativo propietario, lo que ataba al hardware y dificultaba la innovación. Con SONiC, Microsoft desacopló el software del hardware usando la **API SAI (Switch Abstraction Interface)**.

## Arquitectura

SONiC se basa en un diseño **contenedorizado**: cada servicio de red corre en su propio contenedor Docker, lo que permite actualizaciones independientes y aislamiento de fallos.

```
+--------------------------------------------------+
|                   SONiC OS                         |
|  +--------+ +--------+ +--------+ +--------+      |
|  | BGP    | | OSPF   | | DHCP   | | SNMP   | ... |
|  | (FRR)  | | (FRR)  | | (ISC)  | | (NET)  |      |
|  +--------+ +--------+ +--------+ +--------+      |
|  +------------------------------------------------+ |
|  |        Switch State Service (SSS)               | |
|  +------------------------------------------------+ |
|  +------------------------------------------------+ |
|  |   SAI (Switch Abstraction Interface) API        | |
|  +------------------------------------------------+ |
|  +------------------------------------------------+ |
|  |   ASIC SDK del fabricante (Broadcom, Nvidia…)   | |
|  +------------------------------------------------+ |
+--------------------------------------------------+
```

### Componentes principales

| Componente | Función |
|---|---|
| **SAI** | API de abstracción de hardware (ASIC). Define una interfaz común para programar chips de red de cualquier fabricante. |
| **FRRouting** | Suite de protocolos de enrutamiento: BGP, OSPF, ISIS, RIP. Open source, también usado en routers Linux. |
| **Switch State Service (SSS)** | Base de datos centralizada que gestiona el estado del switch (tablas ARP, rutas, puertos). |
| **Docker** | Cada servicio de red corre en su propio contenedor, facilitando actualizaciones y aislamiento. |
| **syncd** | Demonio de sincronización que traduce las tablas de estado a llamadas SAI. |

### Hardware compatible

SONiC funciona en más de **100 plataformas** de switches, incluyendo:

- **Broadcom** — Tomahawk, Trident, Jericho
- **Nvidia/Mellanox** — Spectrum (1, 2, 3 y 4)
- **Cisco** — Catalyst 9000, Nexus 3000/9000
- **Dell** — PowerSwitch Z/S Series
- **Arista** — 7050X, 7260X, 7280R
- **Juniper** — QFX5200
- **Marvell/Prestera** — Aldrin, AC3

## Protocolos soportados

- **BGP** (Border Gateway Protocol) — enrutamiento entre dominios
- **OSPF** — enrutamiento interior
- **IS-IS** — alternativo a OSPF
- **RDMA** — Remote Direct Memory Access (RoCE v2)
- **VXLAN/EVPN** — overlays de red
- **QoS** — calidad de servicio
- **ACL** — listas de control de acceso
- **sFlow / netflow** — monitorización de tráfico

## Empresas que ofrecen soporte empresarial

| Empresa | Servicio |
|---|---|
| **Hedgehog** | SONiC para empresas, interfaz gráfica |
| **Aviz Networks** | Stack de soporte ONES, monitorización |
| **Nvidia** | SONiC certificado en switches Mellanox |
| **Arista** | Versión EOS con funcionalidad SONiC |

## Instalación

SONiC se despliega típicamente como una **imagen binaria** que se flashea directamente en el switch. No se instala como un paquete en una distribución existente.

```bash
# La imagen se descarga desde GitHub Releases
# y se flashea mediante ONIE (Open Network Install Environment)
# 1. Arrancar el switch en modo ONIE
# 2. Descargar la imagen:
#    wget https://github.com/sonic-net/SONiC/releases/.../sonic.bin
# 3. Instalar:
#    onie-nos-install sonic.bin
```

También se puede ejecutar en **VM** o en hardware de laboratorio para pruebas.

## Enlaces externos

- [Sitio oficial](https://sonic-net.github.io/SONiC/)
- [SONiC en GitHub](https://github.com/sonic-net/SONiC)
- [Wikipedia — SONiC](https://es.wikipedia.org/wiki/SONiC_(sistema_operativo))
- [SONiC en la Linux Foundation](https://www.linuxfoundation.org/projects/networking/)

## Ver también

- [[Docker]] — contenedores, base de SONiC
- [[Debian]] — distribución base de SONiC

#programa #red #redes
