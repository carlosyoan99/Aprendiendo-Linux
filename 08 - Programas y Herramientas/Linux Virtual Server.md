---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL
alternativas: HAProxy, NGINX, keepalived
---

# Linux Virtual Server (LVS)

> Solución de **balanceo de carga** y alta disponibilidad integrada en el kernel Linux. Proyecto iniciado por Wensong Zhang en 1998. Usado por Wikimedia y otros proyectos grandes.

## Qué es

LVS implementa balanceo de carga a nivel de **kernel** (IPVS - IP Virtual Server) para distribuir tráfico entre múltiples servidores reales. Opera en la capa de red (TCP/UDP) y es extremadamente rápido porque no necesita copiar datos al espacio de usuario.

## Componentes

| Componente | Descripción |
|---|---|
| **IPVS** | Balanceo IP a nivel de kernel (incluido en Linux 2.4+) |
| **KTCPVS** | Balanceo a nivel de aplicación (en desarrollo) |
| **keepalived** | Herramienta de monitorización + VRRP para HA |

### Algoritmos de balanceo

- Round-Robin
- Weighted Least-Connection
- Source/Destination Hashing
- Shortest Expected Delay

## Usos comunes

- Servidores web de alta disponibilidad
- Balanceo de bases de datos
- Servicios de correo y VoIP
- Infraestructura Wikimedia (desde 2006)

## Enlaces externos

- [Proyecto LVS](http://www.linuxvirtualserver.org/)
- [Wikipedia — LVS](https://es.wikipedia.org/wiki/Linux_Virtual_Server)

## Ver también

- [[Heartbeat (Linux-HA)]] — HA clustering básico
- [[Firewall]] — seguridad de red
- [[nginx]] — balanceo a nivel de aplicación

#programa #balanceo #red
