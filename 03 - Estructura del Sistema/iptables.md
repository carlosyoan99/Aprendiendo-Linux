---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: baja
---

# iptables

> Firewall legacy de Linux. Aunque deprecado en favor de [[nftables]], todavía se usa ampliamente en guías antiguas, Docker y muchas distribuciones.

## Sintaxis

```bash
iptables [opciones] [cadena] [regla]
```

## Descripción

`iptables` fue el frontend de firewall estándar desde Linux 2.4 hasta que [[nftables]] lo reemplazó en 2014. Usa tablas (filter, nat, mangle, raw) con cadenas (INPUT, OUTPUT, FORWARD) para filtrar tráfico. Aunque deprecado, sigue instalado en casi todas las distribuciones y es el backend de muchas herramientas como Docker.

## Diferencia clave con nftables

| Aspecto | iptables | nftables |
|---|---|---|
| **Familia** | IPv4 + IPv6 por separado | inet (unificado) |
| **Atomicidad** | ❌ Race conditions | ✅ Atómico |
| **Sets/maps** | ❌ Módulo extra | ✅ Nativos |
| **Logging** | Chain separada | Misma regla |
| **Rendimiento** | O(n) lineal | O(1) bytecode |

## Comandos esenciales

```bash
# Ver reglas
sudo iptables -L -n -v                    # lista detallada
sudo iptables-save                         # dump completo
sudo iptables -L -n --line-numbers         # con números de línea

# Política por defecto
sudo iptables -P INPUT DROP                # denegar todo entrante
sudo iptables -P FORWARD DROP              # denegar reenvío
sudo iptables -P OUTPUT ACCEPT             # permitir saliente

# Reglas
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -j DROP

# Borrar
sudo iptables -F                           # flush todas las reglas
sudo iptables -D INPUT -p tcp --dport 80 -j ACCEPT  # borrar una

# Persistir
sudo iptables-save | sudo tee /etc/iptables/rules.v4
sudo ip6tables-save | sudo tee /etc/iptables/rules.v6
```

## Traducción a nftables

```bash
# Traducir un comando iptables
iptables-translate -A INPUT -p tcp --dport 22 -j ACCEPT
# Salida: nft add rule ip filter INPUT tcp dport 22 counter accept

# Traducir todas las reglas
sudo iptables-save > /tmp/rules.txt
sudo iptables-restore-translate -f /tmp/rules.txt > /tmp/nftables.nft
```

## Casos de uso

### Migrar a nftables
```bash
# 1. Exportar reglas actuales
sudo iptables-save > ~/iptables-backup.txt

# 2. Traducir
sudo iptables-restore-translate -f ~/iptables-backup.txt > ~/nftables.nft

# 3. Revisar y aplicar
sudo nft -f ~/nftables.nft
```

## Troubleshooting

| Problema | Solución |
|---|---|
| Docker rompe reglas | Usar `DOCKER-USER` chain |
| IPv6 bloqueado | Configurar ip6tables también |
| Reglas se pierden | Persistir con iptables-persistent |

## Ver también

- [[nftables]] — sucesor moderno
- [[ufw]] — frontend simplificado
- [[Firewall]] — guía general

## Enlaces externos

- [Wikipedia — iptables](https://en.wikipedia.org/wiki/Iptables)
- [man iptables(8)](https://man7.org/linux/man-pages/man8/iptables.8.html)
- [Arch Wiki — iptables](https://wiki.archlinux.org/title/Iptables)

#sistema #redes #firewall
