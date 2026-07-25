---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# netstat

> Muestra conexiones de red, tablas de enrutamiento, estadísticas de interfaces y conexiones falsificadas. Es el comando legacy de diagnóstico de red — reemplazado por `ss` y `ip`.

## Sintaxis

```bash
netstat [opciones]
```

## Descripción

`netstat` (network statistics) fue durante décadas la herramienta estándar para diagnosticar redes en Linux. Hoy está obsoleta — su reemplazo moderno es `ss`. `netstat` pertenece al paquete `net-tools` (junto a `ifconfig`, `route`, `arp`), que ya no viene preinstalado en la mayoría de distros modernas.

> **⚠️**: Usar `ss` en vez de `netstat`. Si necesitas `netstat` por legacy/scripts: `sudo apt install net-tools`.

## Opciones frecuentes

| Flag | Efecto | Equivalente moderno |
|---|---|---|
| `-t` | Puertos TCP | `ss -t` |
| `-u` | Puertos UDP | `ss -u` |
| `-l` | Solo listening | `ss -l` |
| `-p` | Mostrar proceso | `ss -p` |
| `-n` | No resolver nombres | `ss -n` |
| `-a` | Todos los sockets | `ss -a` |
| `-r` | Tabla de rutas | `ip route` |
| `-i` | Estadísticas interfaces | `ip -s link` |
| `-s` | Estadísticas por protocolo | `ss -s` |

## Ver también

- [[ss]] — reemplazo moderno y rápido
- [[ip]] — reemplazo moderno de ifconfig y route
- [[Nmap]] — escaneo de puertos remoto
- [[Redes Basicas]] — fundamentos de red

#comando #redes
