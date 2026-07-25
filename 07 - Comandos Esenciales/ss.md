---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: comando
prioridad: alta
---

# ss

## Sintaxis
```bash
ss [opciones]
```

## Descripción
Inspecciona sockets de red. Es el reemplazo moderno de `netstat`. Muestra conexiones activas, puertos en escucha, estadísticas de red y más. Esencial para diagnosticar qué servicios están corriendo y en qué puertos.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-t` | Solo sockets TCP |
| `-u` | Solo sockets UDP |
| `-l` | Solo sockets en escucha (listening) |
| `-p` | Mostrar el proceso dueño del socket (requiere sudo para procesos de otros usuarios) |
| `-n` | No resolver nombres (muestra IPs y puertos numéricos) |
| `-a` | Todos los sockets (no solo los conectados) |
| `-s` | Estadísticas resumidas |
| `-4` | Solo IPv4 |
| `-6` | Solo IPv6 |
| `-o` | Información de temporizadores |

## La combinación estrella: `ss -tulpn`

```bash
# Ver TODOS los puertos en escucha con sus procesos
sudo ss -tulpn

# Explicación:
# -t = TCP   -u = UDP
# -l = listening (escuchando)
# -p = proceso
# -n = numérico (no resuelve nombres)
```

Esta combinación reemplaza completamente a `netstat -tulpn`.

## Ejemplos
```bash
ss -tulpn                     # ¿qué puertos están abiertos y qué procesos los usan?
ss -tulpn | grep :80          # ¿algo escuchando en el puerto 80?
ss -tulpn | grep nginx        # ¿nginx está corriendo?
ss -s                         # estadísticas de conexiones
ss -tua                       # todas las conexiones TCP y UDP
ss -t state established       # solo conexiones establecidas
ss -o state time-wait         # conexiones en TIME-WAIT
ss -4                         # solo IPv4
ss -t -p '( dport = :80 or sport = :80 )'  # filtrar por puerto específico
```

## ss vs netstat

| Característica | ss | netstat |
|---|---|---|
| **Velocidad** | ⭐ Más rápido (lee /proc directamente) | 🐢 Más lento |
| **Disponibilidad** | ✅ Viene preinstalado en la mayoría de distros | ⚠️ Obsoleto, puede no venir |
| **Información** | Más detallada (temporizadores, TCP states) | Información básica |
| **Paquete** | `iproute2` (viene con el sistema) | `net-tools` (instalación separada) |

## Notas
- No necesitas instalar nada: `ss` viene en `iproute2`, que está en todo Linux moderno.
- Usa `sudo` para ver procesos de otros usuarios.
- Para filtrar por dirección IP: `ss -tun dst 192.168.1.1` o `ss -tun src 10.0.0.5`.

## Ver también
- [[ip]] — configurar interfaces de red
- [[ping]] — probar conectividad
- [[curl]] — probar servicios HTTP
- [[Redes Basicas]] — conceptos de red
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia - ss (Unix)](https://en.wikipedia.org/wiki/Ss_(Unix))
- [Linux man page - ss](https://man7.org/linux/man-pages/man8/ss.8.html)

#comando