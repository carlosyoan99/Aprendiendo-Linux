---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# nc (netcat)

## Sintaxis
```
nc [opciones] host puerto
nc -l -p puerto [opciones]
```

## Descripción
Navaja suiza de redes en terminal. Lee y escribe datos a través de conexiones TCP/UDP. Sirve para diagnosticar puertos, transferir archivos, crear chats simples, testear servicios, y hacer de cliente o servidor TCP/UDP improvisado.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-l` | Modo escucha (servidor) |
| `-p <puerto>` | Puerto para escuchar o conectar |
| `-v` | Verboso (muestra detalles de la conexión) |
| `-z` | Solo escanear puertos sin enviar datos |
| `-w <N>` | Timeout en segundos |
| `-u` | Usar UDP en vez de TCP |
| `-n` | No resolver DNS (más rápido) |

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

# ── Copia de disco/partición por red (alternativa a dd por ssh) ──

# RECEPTOR
nc -l -p 9999 | sudo dd of=/dev/sdb bs=4M status=progress

# EMISOR
sudo dd if=/dev/sda bs=4M status=progress | nc 192.168.1.20 9999
```

## Alternativas

| Herramienta | Diferencias |
|---|---|
| **nmap** | Escaneo de puertos mucho más potente, scripts NSE |
| **socat** | Como netcat pero con más features (SSL, UNIX sockets, reutilización) |
| **telnet** | Protocolo legacy, netcat lo reemplaza para diagnósticos |

## Notas y advertencias
- La transferencia de archivos con nc **no está cifrada**. No usar en redes que no sean de confianza. Para transferencia segura, usar `rsync -avz` o `scp`.
- nc se cierra cuando termina la transferencia. No da feedback de progreso ni verifica integridad.
- La variante `ncat` (de nmap) es más moderna y feature-completa. En algunas distros, `nc` es un alias a `ncat` (Fedora, RHEL).
- Para escaneo de puertos serio, usar `nmap` en vez de nc.
- Socat es netcat con esteroides: soporta SSL, UNIX sockets, pty, fork, etc.

## Ver también
- [[Redes Basicas]]
- [[SSH]]
- [[ping]]
- [[curl]]
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — Netcat](https://en.wikipedia.org/wiki/Netcat)
- [Linux man page — nc](https://man7.org/linux/man-pages/man1/nc.1.html)

#comando
