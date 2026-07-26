---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: alta
---

# systemd timers

> Sistema de programación de tareas nativo de systemd. Reemplazo moderno de cron con mejor logging, dependencias y persistencia.

## Sintaxis

```bash
systemctl list-timers --all          # ver todos los timers
systemctl status nombre.timer        # estado de un timer
systemctl enable nombre.timer        # activar al inicio
systemctl start nombre.timer         # iniciar inmediatamente
systemd-analyze calendar "weekly"    # probar expresión de calendario
```

## Descripción

Un timer de systemd consta de dos archivos:
- **`.timer`** — define cuándo ejecutar (el schedule)
- **`.service`** — define qué ejecutar (el comando)

A diferencia de cron, systemd timers ofrecen: logging integrado con journald, dependencias entre servicios, persistencia (ejecutar tareas perdidas al reiniciar), y control preciso de recursos vía cgroups.

## Estructura de un timer

```ini
# /etc/systemd/system/mi-backup.timer
[Unit]
Description=Backup diario

[Timer]
OnCalendar=*-*-* 02:00:00          # cada día a las 2 AM
Persistent=true                     # ejecutar si se perdió (reboot)
RandomizedDelaySec=300              #±5 min aleatorio (evitar thundering herd)

[Install]
WantedBy=timers.target
```

```ini
# /etc/systemd/system/mi-backup.service
[Unit]
Description=Backup del vault

[Service]
Type=oneshot
User=carlos
ExecStart=/home/carlos/scripts/backup.sh
StandardOutput=journal
```

## Directivas de temporización

### Calendario (OnCalendar)

```bash
# Sintaxis: Día-Año-Mes Hora:Minuto:Segundo
OnCalendar=*-*-* 02:00:00          # todos los días a las 2 AM
OnCalendar=Mon *-*-* 09:00:00      # lunes a las 9 AM
OnCalendar=*-*-01 00:00:00         # primer día de cada mes
OnCalendar=Mon..Fri *-*-* 08:00:00 # laborables a las 8 AM
OnCalendar=*-*-1,15 12:00:00       # días 1 y 15 del mes
OnCalendar=Sat,Sun 10:00:00        # fines de semana

# Expresiones especiales
OnCalendar=hourly
OnCalendar=daily
OnCalendar=weekly
OnCalendar=monthly
OnCalendar=yearly

# Verificar expresión
systemd-analyze calendar "Mon..Fri *-*-* 08:00:00"
```

### Monotónicos (OnBootSec, OnUnitActiveSec)

```ini
OnBootSec=5min                     # 5 minutos después del arranque
OnBootSec=1h                       # 1 hora después del arranque
OnUnitActiveSec=30min               # cada 30 min tras última ejecución
OnUnitInactiveSec=2h                # cada 2h tras completar
```

### Persistencia

```ini
Persistent=true                     # si el sistema estaba apagado, ejecutar al arrancar
```

## Cron vs systemd timers

| Aspecto | cron | systemd timers |
|---|---|---|
| **Logging** | syslog (separado) | journald (integrado) |
| **Persistencia** | ❌ pierde tareas | ✅ `Persistent=true` |
| **Dependencias** | ❌ | ✅ `After=`, `Requires=` |
| **Recursos** | ❌ | ✅ límites vía cgroups |
| **Debug** | `grep /var/log/syslog` | `systemctl status`, `journalctl -u` |
| **Sintaxis** | `0 2 * * *` | `OnCalendar=*-*-* 02:00:00` |
| **Comprobación** | ❌ | `systemd-analyze calendar` |

## Casos de uso

### Backup diario
```ini
# ~/.config/systemd/user/backup.timer
[Unit]
Description=Backup diario

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

### Limpieza semanal de caché
```ini
# /etc/systemd/system/cleanup.timer
[Unit]
Description=Limpieza semanal

[Timer]
OnCalendar=weekly
RandomizedDelaySec=600

[Install]
WantedBy=timers.target
```

```ini
# /etc/systemd/system/cleanup.service
[Unit]
Description=Limpiar caché del sistema

[Service]
Type=oneshot
ExecStart=/usr/bin/journalctl --vacuum-size=200M
ExecStart=/usr/bin/apt-get autoremove -y
```

### Monitoreo cada 5 minutos
```ini
# Timer para health check
OnUnitActiveSec=5min
```

## Comandos de administración

```bash
# Listar timers
systemctl list-timers --all          # todos
systemctl list-timers                # solo próximos

# Gestionar
systemctl enable mi.timer
systemctl start mi.timer
systemctl stop mi.timer
systemctl disable mi.timer

# Ver estado y logs
systemctl status mi.timer
systemctl status mi.service
journalctl -u mi.service -f

# Probar expresión
systemd-analyze calendar "Mon *-*-* 09:00:00"
systemd-analyze calendar --iterations=5 "daily"
```

## Formato de salida

```
NEXT                        LEFT          LAST                        PASSED   UNIT           ACTIVATES
Mon 2026-07-28 02:00:00    6h left       Sun 2026-07-27 02:00:00    17h ago  mi-backup.timer mi-backup.service
Tue 2026-07-29 09:00:00    1 day left    Mon 2026-07-21 09:00:00    6 days  cleanup.timer   cleanup.service
```

## Troubleshooting

| Problema | Solución |
|---|---|
| Timer no ejecuta | `systemctl status mi.timer` + `journalctl -u mi.service` |
| Expresión inválida | `systemd-analyze calendar "expresión"` |
| Tarea perdida | Verificar `Persistent=true` |
| Permisos | Verificar `User=` en el .service |

## Ver también

- [[systemd]] — sistema de init
- [[systemd unidades personalizadas]] — service types, templates, sockets
- [[Cron y Systemd Timers]] — comparativa general
- [[Backups (borg restic duplicity rsync)]] — estrategias de backup

## Enlaces externos

- [systemd Timers documentation](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)
- [Arch Wiki — systemd/Timers](https://wiki.archlinux.org/title/Systemd/Timers)
- [Wikipedia — systemd](https://en.wikipedia.org/wiki/Systemd)

#sistema #automatizacion
