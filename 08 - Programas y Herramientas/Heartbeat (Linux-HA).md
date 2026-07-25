---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
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

## Enlaces externos

- [ClusterLabs](http://clusterlabs.org/)
- [Wikipedia — Heartbeat](https://es.wikipedia.org/wiki/Heartbeat_(Linux-HA_Daemon))
- [High-Availability Linux](https://es.wikipedia.org/wiki/High-Availability_Linux)

## Ver también

- [[systemd]] — init moderno, también gestiona servicios
- [[Firewall]] — seguridad en HA
- [[RAID]] — redundancia a nivel de disco

#programa #alta-disponibilidad
