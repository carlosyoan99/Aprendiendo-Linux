---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: sistema
prioridad: alta
---

# journald — Log binario de systemd

journald (systemd-journald) recolecta logs del kernel, de servicios gestionados por systemd, y de aplicaciones que escriben a stdout/stderr. Almacena en formato **binario** con metadatos estructurados (PID, UID, prioridad, timestamp, código de fuente).

## Consultas avanzadas

```bash
# ── Filtrar por prioridad ──
journalctl -p 0                   # emerg
journalctl -p 3                   # err
journalctl -p 4                   # warning

# ── Filtrar por kernel ──
journalctl -k                      # solo kernel
journalctl -k -p err

# ── Filtrar por metadata ──
journalctl _TRANSPORT=syslog       # logs vía syslog
journalctl _TRANSPORT=kernel       # logs del kernel
journalctl _COMM=sshd              # logs del comando sshd
journalctl _SYSTEMD_UNIT=nginx.service  # logs de la unidad systemd

# ── Salida con formato ──
journalctl -o verbose              # todos los metadatos
journalctl -o json                 # JSON
journalctl -o cat                  # solo el mensaje

# ── Combinaciones ──
journalctl -p err --since "30 min ago"
journalctl -u sshd --since today -o json | jq '. | {msg: .MESSAGE}'
journalctl --list-boots
journalctl -b -1 -p err
```

## Configuración

```ini
# /etc/systemd/journald.conf
[Journal]
Storage=auto                     # persistent si /var/log/journal existe
Compress=yes                     # comprimir logs viejos
Seal=yes                         # firmar logs (detectar manipulación)
SystemMaxUse=500M                # máximo espacio en disco
SystemMaxFileSize=100M           # tamaño máximo por archivo
MaxRetentionSec=2weeks           # tiempo máximo de retención
ForwardToSyslog=no               # ¿reenviar a rsyslog?
```

## Mantenimiento

```bash
sudo journalctl --rotate                        # rotación manual
sudo journalctl --vacuum-size=200M              # reducir a 200MB
sudo journalctl --vacuum-time=7d                # dejar últimos 7 días
sudo journalctl --verify                        # verificar integridad
journalctl -o export > logs-exportados.journal  # exportar
```

## Dónde están los logs

| Ubicación | Persistencia |
|---|---|
| `/run/log/journal/` | Volátil (se borra al reiniciar) |
| `/var/log/journal/` | Persistente (crear dir para activar) |

```bash
sudo mkdir -p /var/log/journal
sudo journalctl --flush
sudo systemctl restart systemd-journald
```

## Ver también

- [[journalctl]] — comando para consultar journald
- [[rsyslog]] — log en texto plano tradicional
- [[logrotate]] — rotación y compresión de logs
- [[systemd]] — configuración de journald
- [[Logging del sistema (rsyslog journald logrotate)]] — índice + comparativa

## Enlaces externos

- [systemd manual — journald](https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html)
- [Arch Wiki — Systemd journal](https://wiki.archlinux.org/title/Systemd/Journal)

#sistema #logging
