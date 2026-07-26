---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: media
---

# nftables

> Framework de filtrado de paquetes que reemplaza a iptables. Es el firewall estándar en el kernel Linux desde 2014 (kernel 3.13), con sintaxis unificada para IPv4/IPv6, sets dinámicos y mejor rendimiento.

## Qué es

`nftables` es el sustituto moderno de `iptables`/`ip6tables`/`ebtables`/`arptables`. Opera con tablas, cadenas y reglas — similar a iptables — pero con ventajas clave:

| Ventaja | Detalle |
|---|---|
| **Sintaxis unificada** | Una sola familia `inet` para IPv4 + IPv6 |
| **Atomicidad** | Las reglas se cargan todas juntas o ninguna (sin race conditions) |
| **Sets y maps** | Lookups O(1) con tablas hash en kernel, vs O(n) lineal de iptables |
| **Bytecode** | Compila reglas a bytecode ejecutado por VM en kernel (no evaluación lineal) |
| **Contadores integrados** | Bytes y paquetes por regla sin módulos extra |

**Distros que ya usan nftables por defecto:** Debian 10+, Ubuntu 20.04+, Fedora, Arch Linux, RHEL 8+

---

## Sintaxis básica

### Tablas y cadenas

```bash
# Tabla inet (IPv4 + IPv6) — la más común
sudo nft add table inet filter

# Cadenas con hooks: input (entrante), output (saliente), forward (reenviado)
sudo nft add chain inet filter input { type filter hook input priority 0; policy drop; }
sudo nft add chain inet filter output { type filter hook output priority 0; policy accept; }
sudo nft add chain inet filter forward { type filter hook forward priority 0; policy drop; }
```

> ⚠️ `policy drop` en input significa que todo se deniega por defecto — solo lo que permitas explícitamente pasará.

### Reglas fundamentales

```bash
# 1. Tráfico establecido (siempre primero)
sudo nft add rule inet filter input ct state established,related accept

# 2. Loopback
sudo nft add rule inet filter input iif lo accept

# 3. ICMP (ping)
sudo nft add rule inet filter input icmpv6 type echo-request accept
sudo nft add rule inet filter input icmp type echo-request accept

# 4. Servicios específicos
sudo nft add rule inet filter input tcp dport 22 accept
sudo nft add rule inet filter input tcp dport { 80, 443 } accept

# 5. Log + drop (al final)
sudo nft add rule inet filter input log prefix "nft-drop: " drop
```

### Reglas con manages (IDs)

```bash
# Listar reglas con handles para borrar/modificar
sudo nft list ruleset -a

# Borrar por handle
sudo nft delete rule inet filter input handle 5

# Insertar al inicio (en vez de añadir al final)
sudo nft insert rule inet filter input tcp dport 2222 accept
```

---

## Archivo de configuración

El archivo principal es `/etc/nftables.conf`:

```bash
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;

        # Loopback
        iif lo accept

        # Tráfico establecido
        ct state established,related accept

        # ICMP
        icmp type echo-request accept
        icmpv6 type echo-request accept

        # Servicios
        tcp dport 22 accept      # SSH
        tcp dport 80 accept      # HTTP
        tcp dport 443 accept     # HTTPS

        # Log y denegar el resto
        log prefix \"nftables-input: \" counters drop
    }

    chain forward {
        type filter hook forward priority 0; policy drop;
    }

    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

```bash
# Cargar y habilitar
sudo nft -f /etc/nftables.conf
sudo systemctl enable --now nftables
```

---

## Sets (conjuntos)

Los sets son la gran ventaja de nftables sobre iptables: permiten agrupar IPs, puertos o protocolos y buscar en O(1).

### Set estático (nombrado)

```bash
# Crear set de IPs bloqueadas
sudo nft add set inet filter blacklist { type ipv4_addr; }

# Añadir elementos
sudo nft add element inet filter blacklist { 10.0.0.1, 10.0.0.2, 192.168.1.100 }

# Usar en regla
sudo nft add rule inet filter input ip saddr @blacklist drop
```

### Set de intervalos

```bash
# Flags interval permite rangos CIDR
sudo nft add set inet filter blocked_nets { type ipv4_addr; flags interval; }
sudo nft add element inet filter blocked_nets { 192.168.100.0/24, 10.10.0.0/16 }
```

### Verdict map (mapa de veredictos)

Asocia puertos a acciones directamente — más legible que múltiples reglas:

```bash
sudo nft add rule inet filter input tcp dport vmap { 22 : accept, 80 : accept, 443 : accept, 3306 : drop }
```

### Set dinámico (auto-poblado)

Puede rellenarse automáticamente desde las reglas:

```bash
# Crear set para rate limiting dinámico
sudo nft add set inet filter ssh_hosts { type ipv4_addr; flags dynamic; timeout 5m; }

# Auto-añadir IPs que hagan más de 5 conexiones/minuto
sudo nft add rule inet filter input tcp dport 22 meter ssh_rate { ip saddr limit rate 5/minute burst 5 packets } accept
```

---

## NAT (traducción de direcciones)

Para NAT necesitas una tabla `ip nat` (o `ip6 nat`) con cadenas `prerouting` y `postrouting`:

```bash
# Crear tabla NAT
sudo nft add table ip nat
sudo nft add chain ip nat prerouting { type nat hook prerouting priority -100; }
sudo nft add chain ip nat postrouting { type nat hook postrouting priority 100; }
```

### Masquerade (SNAT dinámico)

```bash
# Enrutador doméstico: enmascarar tráfico interno hacia internet
sudo nft add rule ip nat postrouting oif "eth0" masquerade
```

### SNAT (IP estático)

```bash
# Traducir origen a IP fija
sudo nft add rule ip nat postrouting oif "eth0" snat to 203.0.113.5
```

### DNAT (port forwarding)

```bash
# Redirigir puerto externo 8080 a servidor interno 192.168.1.100:80
sudo nft add rule ip nat prerouting iif "eth0" tcp dport 8080 dnat to 192.168.1.100:80
```

### Mapa de puertos (DNAT múltiple)

```bash
# Un solo puerto externo → varios servidores internos según el puerto
sudo nft add rule ip nat prerouting iif "eth0" tcp dport dnat to tcp dport map { 80 : 192.168.1.10, 8080 : 192.168.1.20, 3000 : 192.168.1.30 }
```

---

## Rate limiting

Limita la tasa de conexiones — útil para prevenir brute force:

```bash
# Máximo 5 conexiones SSH por minuto por IP
sudo nft add rule inet filter input tcp dport 22 meter ssh_meter { ip saddr limit rate 5/minute burst 5 packets } accept

# Límite global de paquetes SYN (anti-SYN flood)
sudo nft add rule inet filter input tcp flags syn meter syn_rate { limit rate 20/second burst 50 packets } accept
sudo nft add rule inet filter input tcp flags syn drop
```

---

## Logging

nftables permite `log` y `accept`/`drop` en la misma regla (iptables no):

```bash
# Log prefix para filtrar en journalctl
sudo nft add rule inet filter input tcp dport 22 log prefix \"SSH: \" accept
sudo nft add rule inet filter input log prefix \"DROPPED: \" drop

# nflog group (para ulogd2)
sudo nft add rule inet filter input log group 1 drop
```

```bash
# Ver logs
sudo journalctl -k | grep nftables
sudo dmesg | grep nft
```

---

## Contadores

Cada regla lleva contadores integrados (bytes/paquetes):

```bash
# Ver contadores
sudo nft list ruleset
# Cada regla muestra: counter bytes X packets Y ...

# Contador explícito (nombrado)
sudo nft add counter inet filter ssh_counter
sudo nft add rule inet filter input tcp dport 22 counter name ssh_counter accept
sudo nft list counter inet filter ssh_counter
```

---

## Migración desde iptables

### Traducción individual

```bash
# Traducir un comando iptables a nftables
iptables-translate -A INPUT -p tcp --dport 22 -j ACCEPT
# Salida: nft add rule ip filter INPUT tcp dport 22 counter accept
```

### Reglas completas

```bash
# Exportar reglas iptables actuales
sudo iptables-save > /tmp/iptables-rules.txt

# Traducir todo el archivo
sudo iptables-restore-translate -f /tmp/iptables-rules.txt > /tmp/nftables-rules.nft

# Revisar y aplicar
sudo nft -f /tmp/nftables-rules.nft
```

### Convivencia temporal

```bash
# iptables y nftables pueden coexistir (iptables usa bridge, nftables usa inet)
# Pero NO mezcles ambos para la misma tabla — elige uno
```

---

## Persistencia entre reinicios

```bash
# El servicio nftables carga /etc/nftables.conf al inicio
sudo systemctl enable nftables

# Guardar reglas actuales al archivo
sudo nft list ruleset | sudo tee /etc/nftables.conf

# Verificar que el servicio carga correctamente
sudo systemctl status nftables
```

---

## Familias de dirección

| Familia | Ámbito | Uso |
|---|---|---|
| `inet` | IPv4 + IPv6 | **Recomendado** — una sola tabla para ambos |
| `ip` | Solo IPv4 | Solo si necesitas separar |
| `ip6` | Solo IPv6 | Solo si necesitas separar |
| `bridge` | Tráfico bridge | Para bridges/switches virtuales |
| `arp` | ARP | Filtrado a nivel ARP (poco común) |

---

## Tablas, cadenas y hooks

| Tabla | Familia | Uso típico |
|---|---|---|
| `inet filter` | IPv4+IPv6 | Filtrado general |
| `ip nat` | IPv4 | NAT (masquerade, DNAT) |
| `inet nat` | IPv4+IPv6 | NAT unificado (si lo soporta tu kernel) |

| Hook | Momento | Dirección |
|---|---|---|
| `prerouting` | Antes de decidir ruta | Entrante temprano |
| `input` | Destinado al equipo local | Entrante |
| `forward` | Reenviado a otro equipo | Reenviado |
| `output` | Originado en el equipo | Saliente |
| `postrouting` | Después de decidir ruta | Saliente tardío |

**Prioridad de hooks:** numéricamente menor = se ejecuta primero. Valores típicos:
- `prerouting`: -100
- `input`/`output`/`forward`: 0
- `postrouting`: 100

---

## Comparativa con iptables

| Aspecto | nftables | iptables |
|---|---|---|
| **Familia** | inet (IPv4+IPv6) | Por separado |
| **Atomicidad** | ✅ actualización atómica | ❌ race conditions |
| **Lookups** | O(1) con sets | O(n) lineal |
| **Sets/maps** | ✅ nativos | ❌ módulo extra |
| **Logging + acción** | ✅ en misma regla | ❌ requiere chain separada |
| **Rendimiento (10k reglas)** | ~2x más rápido | Lineal |
| **Persistencia** | `/etc/nftables.conf` | `iptables-save` |

---

## Troubleshooting

```bash
# Ver todas las reglas activas
sudo nft list ruleset

# Ver reglas de una tabla específica
sudo nft list table inet filter
sudo nft list chain inet filter input

# Ver contadores (¿está cayendo paquetes?)
sudo nft list ruleset | grep -E "counter|drop"

# Probar conectividad
ss -tulpn | grep :22             # ¿el servicio escucha?
sudo nft list ruleset -a | grep 22  # ¿hay regla que lo permita?

# Ver logs de denegaciones
sudo journalctl -k -f | grep -i nft
sudo dmesg | tail -20

# Diagnóstico rápido de cadena INPUT
sudo nft flush chain inet filter input   # ⚠️ TEMPORAL — borra todas las reglas de input
# Si después del flush funciona → el problema está en tus reglas
sudo nft -f /etc/nftables.conf          # restaurar
```

### Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `Error: Could not process rule: No such file or directory` | Tabla/cadena no existe | Crear tabla/cadena primero |
| `Error: Could not add rule: Device or resource busy` | Regla referenciada en uso | Verificar dependencias con `-a` |
| `Connection timeout after enabling` | Política `drop` sin regla SSH | Añadir `tcp dport 22 accept` ANTES del drop |
| `NAT no funciona` | Falta tabla `ip nat` | `nft add table ip nat` + cadenas prerouting/postrouting |

---

## Ver también

- [[Firewall]] — guía general de firewalls (ufw, firewalld, iptables)
- [[Firewall]] — guía general incluyendo iptables legacy
- [[ufw]] — frontend simplificado (usa nftables internamente)
- [[Seguridad en Linux (Guía completa)]] — seguridad integral
- [[Redes Basicas]] — conceptos de red

## Enlaces externos

- [nftables Wiki (oficial)](https://wiki.nftables.org/)
- [Wikipedia — nftables](https://en.wikipedia.org/wiki/Nftables)
- [Arch Wiki — nftables](https://wiki.archlinux.org/title/Nftables)
- [man nft(8)](https://www.netfilter.org/projects/nftables/manpage.html)

#sistema #redes #firewall
