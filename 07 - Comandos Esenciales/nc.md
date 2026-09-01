---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: media
---

# nc (netcat)

> Navaja suiza de redes en terminal. Lee y escribe datos a través de conexiones TCP/UDP. Diagnosticar puertos, transferir archivos, crear chats, testear servicios, y hacer de cliente/servidor TCP/UDP improvisado.

## Sintaxis

```bash
nc [opciones] host puerto
nc -l -p puerto [opciones]
```

## Descripción

`nc` (netcat) es la herramienta más versátil para diagnóstico de red en terminal. Conecta a cualquier host:puerto y permite enviar/recibir datos raw. Esencial para verificar si un puerto está abierto, transferir archivos por red, o testear protocols manualmente.

## Opciones principales

| Flag | Efecto |
|---|---|
| `-l` | Modo escucha (servidor) |
| `-p <puerto>` | Puerto para escuchar o conectar |
| `-v` | Verboso (muestra detalles de la conexión) |
| `-z` | Solo escanear puertos sin enviar datos |
| `-w <N>` | Timeout en segundos |
| `-u` | Usar UDP en vez de TCP |
| `-n` | No resolver DNS (más rápido) |
| `-q <N>` | Terminar tras N segundos sin entrada |
| `-k` | Mantener escucha tras desconexión (ncat) |

## Ejemplos

```bash
# ── Diagnóstico de red ──

# Verificar si un puerto está abierto
nc -zv google.com 443                    # "Connection succeeded" = abierto
nc -zv 192.168.1.1 22                    # probar SSH en el router
nc -zv -w 2 192.168.1.10 1-1000         # escanear puertos 1-1000 (rápido)

# Probar conexión a un servidor SMTP manualmente
nc -v smtp.gmail.com 25
# 220 smtp.gmail.com ESMTP
# EHLO prueba.com

# ── Transferencia de archivos ──

# RECEPTOR (escucha, espera archivo)
nc -l -p 9999 > archivo_recibido.zip

# EMISOR (envía archivo)
nc 192.168.1.20 9999 < archivo_a_enviar.zip

# ── Chat simple entre dos terminales ──

# Terminal A (servidor)
nc -l -p 5555

# Terminal B (cliente)
nc 192.168.1.10 5555
# Todo lo que se escriba en una terminal aparece en la otra

# ── Copia de disco/partición por red ──

# RECEPTOR
nc -l -p 9999 | sudo dd of=/dev/sdb bs=4M status=progress

# EMISOR
sudo dd if=/dev/sda bs=4M status=progress | nc 192.168.1.20 9999
```

## Casos de uso

### Verificar servicios en un servidor

```bash
# Probar que nginx responde
echo -e "GET / HTTP/1.0\r\nHost: example.com\r\n\r\n" | nc example.com 80

# Probar que MySQL acepta conexiones
nc -zv 192.168.1.10 3306

# Verificar firewall — qué puertos están abiertos
nc -zv -w 1 192.168.1.1 22 80 443 3306 8080
```

### Transferencia segura con compresión

```bash
# Receptor: recibe y descomprime
nc -l -p 9999 | tar -xzf -

# Emisor: comprime y envía
tar -czf - directorio/ | nc 192.168.1.20 9999
```

### Proxy simple (forwarding de puerto)

```bash
# Redirigir puerto 8080 a otro servidor
nc -l -p 8080 | nc 192.168.1.10 80
```

## Comparativa con alternativas

| Herramienta | Diferencias |
|---|---|
| **nmap** | Escaneo de puertos mucho más potente, scripts NSE, detección de servicios |
| **socat** | Como netcat pero con más features (SSL, UNIX sockets, fork, reutilización) |
| **telnet** | Protocolo legacy, netcat lo reemplaza para diagnósticos |
| **curl** | HTTP específico, más fácil para APIs pero menos versátil |
| **ncat** | Variante moderna de nmap: combines netcat + nmap features |

> **Regla práctica**: usa `nc -zv` para verificar si un puerto está abierto rápido, `nmap` para escaneo serio, y `socat` cuando necesites SSL/sockets.

## Notas y advertencias

- La transferencia de archivos con nc **no está cifrada**. No usar en redes que no sean de confianza. Para transferencia segura, usar `rsync -avz` o `scp`.
- nc se cierra cuando termina la transferencia. No da feedback de progreso ni verifica integridad.
- La variante `ncat` (de nmap) es más moderna y feature-completa. En algunas distros, `nc` es un alias a `ncat` (Fedora, RHEL).
- Para escaneo de puertos serio, usar `nmap` en vez de nc.
- Socat es netcat con esteroides: soporta SSL, UNIX sockets, pty, fork, etc.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `nc: connect refused` | Servicio no corriendo o puerto cerrado | Verificar con `ss -tlnp` que el servicio escucha |
| `nc: connection timed out` | Firewall bloqueando | Probar `nc -zv -w 2 host port` con timeout corto |
| `nc: Permission denied` | Puerto <1024 requiere root | `sudo nc -l -p 80` o usar puerto >1024 |
| Transferencia incompleta | Emisor cierra antes de terminar | Añadir `sleep 2` al emisor después del pipe |
| `nc: command not found` | No instalado | `sudo apt install ncat` / `sudo pacman -S nmap` |

## Ver también

- [[Redes Basicas]] — conceptos de red
- [[SSH]] — acceso remoto seguro
- [[ping]] — verificar conectividad
- [[curl]] — cliente HTTP
- [[ss]] — estadísticas de sockets
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — Netcat](https://en.wikipedia.org/wiki/Netcat)
- [Linux man page — nc](https://man7.org/linux/man-pages/man1/nc.1.html)
- [Arch Wiki — Netcat](https://man.archlinux.org/man/nc.1)
- [Socat — alternativa avanzada](http://www.dest-unreach.org/socat/)

#comando #red #diagnostico
