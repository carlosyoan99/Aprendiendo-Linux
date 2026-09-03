---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# fail2ban

## Definición

**fail2ban** es un sistema de prevención de intrusiones que escanea logs del sistema en busca de intentos fallidos de autenticación (SSH, web, correo, etc.) y **banea temporalmente** las IPs ofensivas mediante reglas del firewall local (iptables/nftables).

Esencial para servidores expuestos a internet: los bots escanean puertos SSH constantemente, y fail2ban los bloquea automáticamente.

```bash
# Instalar
sudo apt install fail2ban                 # Debian/Ubuntu
sudo pacman -S fail2ban                   # Arch
sudo dnf install fail2ban                 # Fedora
```

## Cómo funciona

```
1. fail2ban monitorea archivos de log (SSH, nginx, etc.)
2. Cuando detecta N intentos fallidos en M minutos
3. → Añade una regla en el firewall para bloquear esa IP
4. → La IP queda bloqueada por un tiempo configurable (bantime)
5. → El bloqueo expira automáticamente (o se puede desbloquear antes)
```

## Configuración

Los archivos de configuración están en `/etc/fail2ban/`:

| Archivo | Propósito |
|---|---|
| `fail2ban.conf` | Config global (log level, socket) |
| `jail.conf` | Definiciones de cárceles (jails) — NO EDITAR |
| `jail.local` | Overrides de jail.conf (crear este) |
| `jail.d/*.conf` | Jails por servicio (nginx, sshd, etc.) |

### Configurar jail.local

```bash
# /etc/fail2ban/jail.local
[DEFAULT]
# Configuración global (aplica a todas las cárceles)
bantime = 3600                    # 1 hora de baneo (en segundos)
findtime = 600                    # ventana de tiempo: 10 minutos
maxretry = 5                      # máximos intentos antes del baneo

# Ignorar IPs de confianza (nunca banear)
ignoreip = 127.0.0.1/8 192.168.1.0/24

# Acción por defecto: banear con iptables/nftables
banaction = nftables[type=multiport]
```

### Cárceles (jails) comunes

```bash
# /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled = true                    # activar monitoreo SSH
port = 22                         # puerto a monitorear (o 'ssh')
logpath = %(sshd_log)s            # ruta del log (fail2ban conoce las rutas comunes)
maxretry = 3                      # 3 intentos y baneo

# /etc/fail2ban/jail.d/nginx.local
[nginx-http-auth]
enabled = true
port = http,https
logpath = /var/log/nginx/error.log
maxretry = 5

# /etc/fail2ban/jail.d/postfix.local
[postfix]
enabled = true
port = smtp,ssmtp
logpath = /var/log/mail.log
maxretry = 3
```

## Comandos esenciales

```bash
# Estado del servicio
sudo systemctl status fail2ban            # ¿está corriendo?
sudo systemctl enable --now fail2ban      # activar al arranque

# Ver estado de todas las cárceles
sudo fail2ban-client status               # lista de jails activos

# Ver una cárcel específica (IPs baneadas)
sudo fail2ban-client status sshd
# Status for the jail: sshd
# |- Total banned: 42
# |- IP list: 192.168.1.100 203.0.113.5

# Desbanear una IP manualmente
sudo fail2ban-client set sshd unbanip 192.168.1.100

# Banear una IP manualmente
sudo fail2ban-client set sshd banip 192.168.1.200

# Recargar configuración (sin reiniciar)
sudo fail2ban-client reload

# Ver log de fail2ban
sudo journalctl -u fail2ban -f
sudo tail -f /var/log/fail2ban.log
```

## Análisis de ataques

```bash
# Ver IPs que han sido baneadas (todas las cárceles)
sudo fail2ban-client status | grep "Jail list" | cut -d: -f2 | tr ',' '\n' | \
  while read jail; do echo "=== $jail ==="; sudo fail2ban-client status "$jail" | \
  grep "IP list"; done

# Top IPs baneadas en SSH (ordenadas por frecuencia)
sudo grep "Ban" /var/log/fail2ban.log | awk '{print $NF}' | sort | uniq -c | sort -rn

# Ver cuántos intentos de SSH hubo antes de fail2ban
sudo journalctl -u sshd | grep "Failed password" | wc -l
```

## Buenas prácticas

1. **No banear tu propia IP**: añadir `ignoreip = tu-ip` en `jail.local`
2. **Bantime progresivo**: `bantime = 10m; bantime.increment = true`
3. **Notificaciones por email**: configurar `action = %(action_mwl)s` (envía email con whois + log)
4. **Monitorear regularmente**: `sudo fail2ban-client status sshd`
5. **No confiar solo en fail2ban**: es una capa más, no reemplaza claves SSH seguras, cambio de puerto, ni desactivar root login

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| fail2ban no bloquea nada | El logpath no coincide con el log real | Verificar con `sudo fail2ban-client get sshd logpath` |
| `error: permission denied` | fail2ban no puede leer el log | Añadir usuario fail2ban al grupo `adm`: `sudo usermod -aG adm fail2ban` |
| IP baneada pero sigue conectando | El firewall no está usando nftables/iptables | Verificar `banaction` en jail.local |
| Muchos falsos positivos | `maxretry` demasiado bajo | Subir a 5-10 según el servicio |

## Comparativa con alternativas

| Aspecto | fail2ban | CrowdSec | DenyHosts | sshguard | UFW limit |
|---|---|---|---|---|---|
| **Enfoque** | Baneo por regex en logs | Baneo colaborativo (shared blocklist) | Baneo SSH específico | Baneo SSH firewall-based | Baneo a nivel UFW |
| **Servicios** | ✅ SSH, Apache, Nginx, Postfix, etc. | ✅ 80+ parsers | ❌ Solo SSH | ⚠️ SSH + Apache | ❌ Solo SSH |
| **Collaborativo** | ❌ | ✅ Comparte blocklists en la nube | ❌ | ❌ | ❌ |
| **Acciones** | iptables, nftables, systemd-nspawn, cloudflare | iptables, nftables, cloudflare, geo-ip | iptables | iptables, PF | UFW reject |
| **Config** | ✅ INI simple (`jail.local`) | ✅ YAML + dashboard | ⚠️ Config.txt | ⚠️ CLI flags | `ufw limit ssh` |
| **Dashboard** | ❌ | ✅ Web UI incluido | ❌ | ❌ | ❌ |
| **Ideal para** | Control manual, flexibilidad total | Protección colaborativa multi-host | Solo SSH, mínimo setup | SSH básico, ligero | Fuerza bruta SSH rápida |

> **Elegir fail2ban si:** quieres control total sobre baneos y no necesitas blocklists colaborativas.
> **Elegir CrowdSec si:** quieres protección colaborativa con blocklists compartidas y dashboard.

## Ver también
- [[SSH]] — servicio a proteger primero (cambio de puerto, claves, desactivar root)
- [[Firewall]] — iptables/nftables (donde fail2ban aplica los baneos)
- [[Logging del sistema (rsyslog journald logrotate)]] — logs que fail2ban monitorea
- [[Solución de Problemas - Recursos]] — diagnóstico general

## Enlaces externos

- [Wikipedia — Fail2ban](https://en.wikipedia.org/wiki/Fail2ban)
- [Sitio oficial — Fail2ban](https://www.fail2ban.org/)
- [GitHub — fail2ban/fail2ban](https://github.com/fail2ban/fail2ban)

#programa #seguridad