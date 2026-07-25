---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# nmcli

> Herramienta de línea de comandos para gestionar NetworkManager. Permite configurar conexiones WiFi, Ethernet, VPN y dispositivos de red con cambios persistentes.

## Sintaxis

```bash
nmcli [opciones] objeto comando [args]
```

## Descripción

`nmcli` (NetworkManager CLI) es la interfaz de terminal para NetworkManager, el gestor de red estándar en la mayoría de distros Linux. A diferencia de `ip` (cambios temporales), `nmcli` persiste las configuraciones automáticamente.

## Comandos esenciales

```bash
# Estado de red
nmcli                       # resumen de conexiones activas
nmcli general status        # estado de NetworkManager
nmcli device                # dispositivos de red
nmcli device wifi list      # redes WiFi disponibles
nmcli connection show       # conexiones guardadas

# Conectar WiFi
nmcli device wifi connect "MiRed" password "contraseña"

# Conectar Ethernet
nmcli device connect eth0

# Desconectar
nmcli device disconnect eth0

# Gestionar conexiones
nmcli connection up "MiRed"           # activar conexión
nmcli connection down "MiRed"         # desactivar conexión
nmcli connection delete "MiRed"       # eliminar conexión guardada
```

## Ver también

- [[ip]] — config temporal de red
- [[ss]] — puertos y conexiones activas
- [[Redes Basicas]] — fundamentos de red
- [[NetworkManager]] — gestor de red

#comando #redes
