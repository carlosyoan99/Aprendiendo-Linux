---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
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

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install ipvsadm keepalived` |
| Arch | `sudo pacman -S ipvsadm keepalived` |
| Fedora | `sudo dnf install ipvsadm keepalived` |
| openSUSE | `sudo zypper install ipvsadm keepalived` |

```bash
# Verificar que IPVS está cargado
lsmod | grep ip_vs
modprobe ip_vs
modprobe ip_vs_rr   # round-robin
modprobe ip_vs_wrr  # weighted round-robin
modprobe ip_vs_lc   # least connections
```

## Modos de operación

| Modo | Descripción | Retorno del tráfico |
|---|---|---|
| **NAT** | Director reescribe IPs destino | A través del director |
| **DR (Direct Routing)** | Director solo cambia MAC | Directamente al real (más rápido) |
| **TUN (IP Tunneling)** | Encapsulación IP-over-IP | Directamente al real |
| **Full-NAT** | Reescrita completa de IPs | A través del director |

```
NAT:    Client → Director → Real → Director → Client
DR:     Client → Director → Real → Client (directo)
TUN:    Client → Director → Real → Client (túnel)
```

## Comandos con ipvsadm

```bash
# Añadir servicio virtual
ipvsadm -A -t 192.168.1.100:80 -s rr

# Añadir real al servicio
ipvsadm -a -t 192.168.1.100:80 -r 192.168.1.101:80 -g   # DR mode
ipvsadm -a -t 192.168.1.100:80 -r 192.168.1.102:80 -g

# Listar reglas
ipvsadm -Ln
ipvsadm -Ln --stats    # con estadísticas
ipvsadm -Ln --rate     # con tasas

# Eliminar servicio
ipvsadm -D -t 192.168.1.100:80

# Guardar/cargar reglas
ipvsadm-save > /etc/sysconfig/ipvsadm
ipvsadm-restore < /etc/sysconfig/ipvsadm
```

## Integración con keepalived

```bash
# /etc/keepalived/keepalived.conf (simplificado)
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.1.100/24
    }
}

virtual_server 192.168.1.100 80 {
    delay_loop 6
    lb_algo rr
    lb_kind DR
    protocol TCP
    real_server 192.168.1.101 80 {
        HTTP_GET {
            url { path / status_code 200 }
            connect_timeout 3
        }
    }
    real_server 192.168.1.102 80 {
        HTTP_GET {
            url { path / status_code 200 }
            connect_timeout 3
        }
    }
}
```

## Usos comunes

- Servidores web de alta disponibilidad
- Balanceo de bases de datos
- Servicios de correo y VoIP
- Infraestructura Wikimedia (desde 2006)

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `ip_vs` no aparece en lsmod | Módulo no cargado | `modprobe ip_vs && modprobe ip_vs_rr` |
| Real aparece como `DOWN` | Real no responde al health check | Verificar HTTP en el real: `curl http://192.168.1.101` |
| Tráfico no llega a reales | IPVS rules vacías | `ipvsadm -Ln` para verificar, re-añadir con `-a` |
| Persistencia perdida tras reboot | Reglas no guardadas | `ipvsadm-save > /etc/sysconfig/ipvsadm` + servicio |
| keepalived no inicia VRRP | Interface errónea o ID duplicado | Verificar `interface` y `virtual_router_id` único |

## Enlaces externos

- [Proyecto LVS](http://www.linuxvirtualserver.org/)
- [Wikipedia — LVS](https://es.wikipedia.org/wiki/Linux_Virtual_Server)

## Ver también

- [[Heartbeat (Linux-HA)]] — HA clustering básico
- [[Firewall]] — seguridad de red
- [[Nginx]] — balanceo a nivel de aplicación

#programa #balanceo #red
