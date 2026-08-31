---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPLv2
alternativas: Pacemaker, Keepalived, Corosync
---

# Heartbeat (Linux-HA)

> Demonio de alta disponibilidad (HA) para Linux que proporciona comunicación y pertenencia a clúster. Parte del proyecto **Linux-HA**, predecesor de **Pacemaker**.

## Qué es

Heartbeat es la capa de mensajería del proyecto Linux-HA. Envía señales periódicas ("latidos") entre nodos de un clúster para detectar caídas. Cuando un nodo deja de responder, los recursos (IPs, servicios) se migran automáticamente a otro nodo.

Actúa como infraestructura base para gestores de recursos como **Pacemaker** (el CRM recomendado).

## Arquitectura tradicional

```
┌──────────────┐    Heartbeat     ┌──────────────┐
│   Nodo A     │◄──────────────►│   Nodo B     │
│  (activo)    │                 │  (pasivo)    │
└──────┬───────┘                 └──────┬───────┘
       │                                │
    Servicio                        Servicio
    (Apache, DB...)                 (standby)
```

## Componentes del stack HA

| Componente | Rol |
|---|---|
| **Heartbeat** | Capa de mensajería entre nodos |
| **Pacemaker** | Gestor de recursos del clúster (CRM) |
| **Cluster Glue** | Infraestructura (STONITH, LRM) |
| **Resource Agents** | Scripts que gestionan servicios |

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install heartbeat pacemaker` |
| Arch | `sudo pacman -S heartbeat pacemaker` |
| Fedora | `sudo dnf install heartbeat pacemaker` |

```bash
# Verificar versión
heartbeat --version
pacemaker --version

# Servicios
systemctl start heartbeat
systemctl enable heartbeat
```

## Configuración de Heartbeat

```bash
# /etc/heartbeat/ha.cf
logfacility local0
keepalive 2
deadtime 30
warntime 10
initdead 60
udpport 694
bcast eth0
auto_failback on
node node1
node node2

# /etc/heartbeat/authkeys
auth 1
1 sha1 CLAVE_SUPER_SECRETA

# /etc/heartbeat/haresources
node1  IPaddr::192.168.1.100/24/eth0 httpd
```

## Gestión con crmsh (Pacemaker)

```bash
# Ver estado del clúster
crm status
crm configure show

# Crear un recurso VIP
crm configure primitive VIP ocf:heartbeat:IPaddr2 params ip=192.168.1.100 cidr_netmask=24 op monitor interval=10s

# Crear recurso de servicio
crm configure primitive WebSvc ocf:heartbeat:apache params configfile=/etc/httpd/conf/httpd.conf

# Restringir recursos a un nodo
crm configure colocation VIP-with-WebSvc inf: VIP WebSvc

# Habilitar/deshabilitar clúster
crm cluster start
crm cluster stop
```

## Modelos de clúster HA

| Modelo | Ejemplo | Failover |
|---|---|---|
| **Active-Passive** | 1 activo, 1 standby | Automático |
| **Active-Active** | 2 activos (balanceados) | Redistribución |
| **N+1** | N servidores, 1 de reserva | Automático |
| **N+N** | Pares activos-activos | Redistribución |

## Enlaces externos

- [ClusterLabs](http://clusterlabs.org/)
- [Wikipedia — Heartbeat](https://es.wikipedia.org/wiki/Heartbeat_(Linux-HA_Daemon))
- [High-Availability Linux](https://es.wikipedia.org/wiki/High-Availability_Linux)
- [Pacemaker Explained](https://clusterlabs.org/pacemaker/doc/en-US/Pacemaker/2.1/html/Pacemaker_Explained/)

## Ver también

- [[systemd]] — init moderno, también gestiona servicios
- [[Firewall]] — seguridad en HA
- [[RAID (mdadm)]] — redundancia a nivel de disco

#programa #alta-disponibilidad
