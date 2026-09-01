---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL + Apache
alternativas: Cumulus Linux, FRRouting
---

# SONiC

> Sistema operativo de red **open source** basado en Linux, desarrollado originalmente por **Microsoft** para switches de centro de datos. Desde 2022 es un proyecto de la **Linux Foundation**. Usado en **Microsoft Azure** y por más de 850 miembros de la comunidad.

## Qué es

SONiC (Software for Open Networking in the Cloud) es un sistema operativo completo para switches de red que ejecuta la **misma pila de software** en hardware de múltiples fabricantes. Usa la API **SAI (Switch Abstraction Interface)** para desacoplar el software del ASIC, permitiendo que un mismo switch pueda ejecutar SONiC independientemente del chip (Broadcom, Nvidia/Mellanox, Intel, etc.).

- **Enfoque**: switches de centro de datos (10G a 800G)
- **Modelo**: contenedorizado (Docker), cada servicio de red aislado
- **Base**: Debian Linux
- **Gestión**: CLI, SNMP, REST API, gNMI

## Historia

| Hito | Año |
|---|---|
| Desarrollo inicial por Microsoft | 2015–2016 |
| Publicación como open source (OCP) | Marzo 2016 |
| Adopción en Azure | 2017 |
| Comunidad supera 850 miembros | 2022 |
| Cesión a la Linux Foundation | 2022 |
| Soporte multi-ASIC (Broadcom, Nvidia, Intel) | 2023 |

SONiC nació de la necesidad de Microsoft de ejecutar la misma pila de red en hardware de distintos fabricantes en Azure. Antes, cada switch requería su propio sistema operativo propietario, lo que ataba al hardware y dificultaba la innovación.

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
| **teamsyncd** | Sincronización de Link Aggregation (LACP). |
| **lldpd** | Descubrimiento de vecinos en la capa 2 (LLDP). |

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

| Protocolo | Descripción |
|---|---|
| **BGP** | Enrutamiento entre dominios (eBGP, iBGP, route reflector) |
| **OSPF** | Enrutamiento interior (v2 IPv4, v3 IPv6) |
| **IS-IS** | Alternativo a OSPF, usado en redes de servicio |
| **VXLAN/EVPN** | Overlays de red, data center fabrics |
| **RDMA** | Remote Direct Memory Access (RoCE v2) |
| **QoS** | Calidad de servicio: colas, marcado, shaping |
| **ACL** | Listas de control de acceso |
| **sFlow/netflow** | Monitorización de tráfico |

## Configuración avanzada

```bash
# CLI de SONiC (basada en click)
show interface status              # estado de puertos
show ip route                     # tabla de rutas
show vlan brief                   # VLANs configuradas
show mac address-table            # tabla MAC
show bgp summary                  # resumen BGP
show interface counters           # contadores de tráfico

# Configurar interfaz
config interface ip address Ethernet0 10.0.0.1/24
config interface startup Ethernet0

# Configurar BGP
config bgp autonomous-system 65001
config bgp neighbor 10.0.0.2 remote-as 65002

# Guardar configuración (persistente tras reboot)
config save

# Backup de configuración
sonic-cfggen -d --print-data > config_backup.json
```

## Empresas que ofrecen soporte empresarial

| Empresa | Servicio |
|---|---|
| **Hedgehog** | SONiC para empresas, interfaz gráfica |
| **Aviz Networks** | Stack de soporte ONES, monitorización |
| **Nvidia** | SONiC certificado en switches Mellanox |
| **Arista** | Versión EOS con funcionalidad SONiC |

## Comparativa con alternativas

| Aspecto | SONiC | Cumulus Linux | Cisco NX-OS |
|---|---|---|---|
| **Licencia** | Open source (GPL/Apache) | Propietaria (Nvidia) | Propietaria (Cisco) |
| **Coste** | Gratis (hardware aparte) | Licencia por switch | Licencia + hardware Cisco |
| **Hardware** | Multi-vendor (100+ platforms) | Solo Nvidia/Mellanox | Solo Cisco |
| **Comunidad** | 850+ miembros, Linux Foundation | Nvidia-backed | Cisco-only |
| **Modelo** | Contenedorizado (Docker) | Monolítico | Monolítico |
| **Ideal para** | Data centers a gran escala | Redes enterprise | Entornos Cisco existentes |

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

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Contenedor Docker no arranca | Imagen corrupta o incompatibilidad SAI | `docker restart <container>` o re-flashear imagen |
| BGP no establece vecindad | AS remoto mal configurado, firewall | Verificar `show bgp summary`, comprobar ACLs |
| VLAN no pasa tráfico | Puerto no asignado a la VLAN | `show vlan brief`, verificar trunk/access mode |
| MAC table vacía | Switch en modo learning, puertos down | `show interface status`, verificar cables/LACP |
| Configuración se pierde tras reboot | No ejecutado `config save` | Siempre ejecutar `config save` tras cambios |
| ASIC no reconocido | SAI driver no incluido en la imagen | Usar imagen build específica para el hardware |

## Instalación

SONiC se despliega como imagen binaria ONIE — no es un paquete instalable en distros existentes.

```bash
# Flash desde ONIE
onie-nos-install sonic-[platform].bin

# Verificar tras arranque
show version
show platform summary
```

## Enlaces externos

- [Sitio oficial](https://sonic-net.github.io/SONiC/)
- [SONiC en GitHub](https://github.com/sonic-net/SONiC)
- [Wikipedia — SONiC](https://es.wikipedia.org/wiki/SONiC_(sistema_operativo))
- [SONiC en la Linux Foundation](https://www.linuxfoundation.org/projects/networking/)
- [SONiC Documentation](https://sonic-net.github.io/SONiC/)

## Ver también

- [[Docker]] — contenedores, base de SONiC
- [[Debian]] — distribución base de SONiC
- [[FRRouting]] — suite de enrutamiento usada dentro de SONiC

#programa #red #redes
