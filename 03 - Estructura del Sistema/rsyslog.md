---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: sistema
prioridad: alta
---

# rsyslog — Log en texto plano

Antes de systemd, rsyslog era el sistema de logging estándar en Linux. Hoy sigue activo en muchas distros (Debian/Ubuntu) coexistiendo con journald. Escribe en archivos de texto plano en `/var/log/`.

## Arquitectura

```
Facility (origen) → Priority (gravedad) → Destino (archivo/remoto)
authpriv           → info               → /var/log/auth.log
kern               → warn               → /var/log/kern.log
```

## Facilities y prioridades

### Facilities (orígenes)

| Facility | Qué genera |
|---|---|
| `kern` | Mensajes del kernel |
| `user` | Aplicaciones de usuario |
| `mail` | Sistema de correo |
| `daemon` | Servicios del sistema |
| `auth`/`authpriv` | Autenticación |
| `cron` | cron/at |
| `local0`-`local7` | Personalizable |

### Prioridades

| Prioridad | Código | Significado |
|---|---|---|
| `emerg` | 0 | Pánico, sistema inutilizable |
| `alert` | 1 | Acción inmediata |
| `crit` | 2 | Condición crítica |
| `err` | 3 | Error |
| `warning` | 4 | Advertencia |
| `notice` | 5 | Notificación |
| `info` | 6 | Informativo |
| `debug` | 7 | Depuración |

## Configuración

```bash
# Archivo principal: /etc/rsyslog.conf
# Fragmentos:      /etc/rsyslog.d/*.conf
```

```bash
# /etc/rsyslog.conf (sintaxis: facility.priority  destino)
*.info;mail.none;authpriv.none;cron.none    /var/log/messages
authpriv.*                                   /var/log/auth.log
mail.*                                       /var/log/mail.log
cron.*                                       /var/log/cron.log
kern.*                                       /var/log/kern.log

# Enviar a servidor remoto
*.* @logserver.local:514                     # UDP
*.* @@logserver.local:514                    # TCP

# Recibir logs remotos
module(load="imudp")
input(type="imudp" port="514")
```

## Comandos

```bash
sudo rsyslogd -N 1             # verificar sintaxis
sudo systemctl reload rsyslog  # recargar configuración
sudo systemctl status rsyslog  # ver estado
```

## Ver también

- [[journald]] — log binario de systemd
- [[journalctl]] — comando para consultar journald
- [[logrotate]] — rotación y compresión de logs
- [[Logging del sistema (rsyslog journald logrotate)]] — índice + comparativa

## Enlaces externos

- [Wikipedia — rsyslog](https://en.wikipedia.org/wiki/Rsyslog)
- [Arch Wiki — rsyslog](https://wiki.archlinux.org/title/Rsyslog)

#sistema #logging
