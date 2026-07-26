---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: alta
---

# ufw

> Uncomplicated Firewall — frontend simplificado para iptables/nftables. El firewall por defecto en Ubuntu. Ideal para servidores y escritorios donde no necesitas control fino.

## Sintaxis

```bash
ufw [comando] [opciones]
```

## Descripción

`ufw` abstrae la complejidad de iptables/nftables con comandos en lenguaje natural. Detrás, gestiona reglas en nftables (Ubuntu 22.04+) o iptables (versiones anteriores).

| Aspecto | Detalle |
|---|---|
| **Backend** | nftables (Ubuntu 22.04+) o iptables |
| **Por defecto en** | Ubuntu, Debian, Linux Mint |
| **Política por defecto** | `deny incoming`, `allow outgoing` |
| **Estado** | Habilitado/deshabilitado con `ufw enable/disable` |

## Comandos esenciales

```bash
# Estado
sudo ufw status                    # ver reglas activas
sudo ufw status verbose            # con política por defecto
sudo ufw status numbered           # reglas numeradas (para borrar)

# Activar/desactivar
sudo ufw enable                     # activar firewall
sudo ufw disable                    # desactivar (⚠️ solo en local)
sudo ufw reset                      # borrar todas las reglas y desactivar

# Política por defecto
sudo ufw default deny incoming      # denegar todo entrante
sudo ufw default allow outgoing     # permitir todo saliente
sudo ufw default deny forward       # denegar reenvío
```

## Opciones

| Opción | Descripción | Ejemplo |
|---|---|---|
| `allow` | Permitir tráfico | `ufw allow 22/tcp` |
| `deny` | Denegar tráfico | `ufw deny 23/tcp` |
| `reject` | Rechazar con respuesta | `ufw reject 80/tcp` |
| `limit` | Limitar intentos (6/min) | `ufw limit 22/tcp` |
| `delete` | Borrar regla | `ufw delete allow 80` |
| `insert` | Insertar al inicio | `ufw insert 1 allow 22/tcp` |

## Ejemplos

### Abrir servicios comunes
```bash
# SSH (IMPORTANTE: abrir ANTES de habilitar ufw en remoto)
sudo ufw allow ssh
sudo ufw allow 22/tcp

# Web server
sudo ufw allow http                # puerto 80
sudo ufw allow https               # puerto 443
sudo ufw allow 80,443/tcp          # ambos juntos

# Base de datos (solo LAN)
sudo ufw allow from 192.168.1.0/24 to any port 3306
```

### Desde IP específica
```bash
# Permitir SSH solo desde tu IP
sudo ufw allow from 203.0.113.50 to any port 22

# Permitir todo desde LAN
sudo ufw allow from 192.168.1.0/24
```

### Perfiles de aplicación
```bash
# ufw conoce aplicaciones comunes
sudo ufw app list                  # ver perfiles disponibles
sudo ufw app info "OpenSSH"        # info de un perfil
sudo ufw allow "OpenSSH"
sudo ufw allow "Apache Full"       # HTTP + HTTPS
```

### Borrar reglas
```bash
# Por número
sudo ufw status numbered
sudo ufw delete 3                  # borrar regla #3

# Por contenido
sudo ufw delete allow 8080/tcp
sudo ufw delete allow "Apache Full"
```

## Formato de salida

```
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
80,443/tcp                 ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
80,443/tcp (v6)            ALLOW       Anywhere (v6)
```

## Casos de uso

### Servidor web seguro
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80,443/tcp
sudo ufw enable
```

### Escritorio con acceso limitado
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 631                 # CUPS (impresión)
sudo ufw allow 5353/udp            # mDNS (descubrimiento local)
sudo ufw allow from 192.168.1.0/24 # todo desde LAN
sudo ufw enable
```

## Combinaciones pipe

```bash
# Ver solo reglas allow
sudo ufw status | grep ALLOW

# Ver reglas con contadores
sudo ufw status verbose | grep -E "ALLOW|DENY"

# Exportar reglas
sudo ufw status > ~/ufw-rules-backup.txt
```

## Alternativas modernas

| Herramienta | Cuándo usarla |
|---|---|
| **nftables** | Control fino, rendimiento máximo |
| **firewalld** | Zonas dinámicas (Fedora/RHEL) |
| **ufw** | Simplicidad, servidores simples |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Bloqueado tras habilitar | No se abrió SSH antes | `sudo ufw disable` (si tienes consola física) |
| Puerto no accesible | Regla mal configurada | `sudo ufw status numbered` y verificar |
| Docker conflicto | Docker gestiona iptables | `DOCKER-USER` chain o `ufw` con `--before- rules` |
| IPv6 no funciona | Solo IPv4 configurado | `ufw` maneja IPv6 automáticamente si está habilitado |

### Nunca hacer en servidor remoto
```bash
# ❌ Esto te deja fuera:
sudo ufw default deny incoming && sudo ufw enable

# ✅ Secuencia segura:
sudo ufw allow ssh                 # primero abrir SSH
sudo ufw default deny incoming     # luego política restrictiva
sudo ufw enable                    # finalmente activar
```

## Ver también

- [[Firewall]] — guía general de firewalls
- [[nftables]] — firewall moderno (backend de ufw)
- [[iptables]] — firewall legacy
- [[Seguridad en Linux (Guía completa)]] — hardening integral
- [[SSH]] — servicio a proteger primero

## Enlaces externos

- [Wikipedia — Uncomplicated Firewall](https://en.wikipedia.org/wiki/Uncomplicated_Firewall)
- [Ubuntu Community Help — UFW](https://help.ubuntu.com/community/UFW)
- [man ufw(8)](https://manpages.ubuntu.com/manpages/jammy/man8/ufw.8.html)

#sistema #redes #firewall
