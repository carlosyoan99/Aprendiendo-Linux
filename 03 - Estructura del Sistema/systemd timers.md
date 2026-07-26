---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: alta
---

# systemd timers

> Sistema de programación de tareas nativo de systemd. Reemplazo moderno de cron con mejor logging integrado (journald), dependencias entre servicios y persistencia.

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

A diferencia de cron, systemd timers ofrecen: logging integrado con journald, dependencias entre servicios, persistencia (ejecutar tareas perdidas al reiniciar), aleatorización de inicio y control preciso de recursos vía cgroups.

## Estructura de un timer

```ini
# /etc/systemd/system/mi-backup.timer
[Unit]
Description=Backup diario

[Timer]
OnCalendar=*-*-* 02:00:00          # cada día a las 2 AM
Persistent=true                     # ejecutar si se perdió (reboot)
RandomizedDelaySec=300              # ±5 min aleatorio (evitar thundering herd)

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

Sintaxis: `día-semana año-mes-día hora:minuto:segundo`

```ini
# ── Días fijos ──
OnCalendar=*-*-* 02:00:00          # todos los días a las 2 AM
OnCalendar=Mon *-*-* 09:00:00      # lunes a las 9 AM
OnCalendar=*-*-01 00:00:00         # primer día de cada mes
OnCalendar=Mon..Fri *-*-* 08:00:00 # laborables a las 8 AM
OnCalendar=*-*-1,15 12:00:00       # días 1 y 15 del mes
OnCalendar=Sat,Sun 10:00:00        # fines de semana

# ── Rangos horarios ──
OnCalendar=*-*-* 09..17:00/1:00:00   # cada hora de 9 AM a 5 PM
OnCalendar=*-*-* 00:00/15:00         # cada 15 minutos
OnCalendar=*-*-* 00/6:00:00          # cada 6 horas (00, 06, 12, 18)

# ── Fecha específica ──
OnCalendar=2026-12-31 23:59:00    # año nuevo

# ── Atajos ──
OnCalendar=hourly
OnCalendar=daily
OnCalendar=weekly
OnCalendar=monthly
OnCalendar=yearly
```

```bash
# Verificar expresión
systemd-analyze calendar "Mon..Fri *-*-* 08:00:00"
systemd-analyze calendar --iterations=5 "daily"   # próximas 5 ejecuciones
```

### Monotónicos (OnBootSec, OnUnitActiveSec)

Estas directivas no usan fecha fija sino tiempo transcurrido desde un evento:

```ini
OnBootSec=5min                     # 5 minutos después del arranque
OnBootSec=1h                       # 1 hora después del arranque
OnActiveSec=5min                   # ejecutar 5 min tras activar el timer
OnUnitActiveSec=30min              # cada 30 min tras última ejecución
OnUnitInactiveSec=2h               # cada 2h tras completar
```

### Persistencia

```ini
Persistent=true   # si el sistema estaba apagado, ejecutar la tarea al arrancar
```
> Solo aplica a `OnCalendar=`. No funciona con `OnBootSec` o `OnUnitActiveSec`.

## Timers de usuario (sin sudo)

```bash
mkdir -p ~/.config/systemd/user/

# Activar sin sudo:
systemctl --user daemon-reload
systemctl --user enable --now mi-backup.timer
systemctl --user list-timers
```

Los timers de usuario solo corren mientras el usuario tenga sesión activa. Para que corran siempre:

```bash
sudo loginctl enable-linger $(whoami)
```

## Cron vs systemd timers

| Aspecto | cron | systemd timers |
|---|---|---|
| **Sintaxis** | `0 2 * * *` (una línea) | `OnCalendar=*-*-* 02:00:00` (2 archivos) |
| **Logging** | syslog (separado) | journald (integrado) |
| **Persistencia** | ❌ pierde tareas si apagado | ✅ `Persistent=true` |
| **Dependencias** | ❌ No | ✅ `After=network.target`, etc. |
| **Control de recursos** | ❌ No | ✅ CPUQuota, MemoryMax vía cgroups |
| **Aleatorizar inicio** | ❌ No | ✅ `RandomizedDelaySec` |
| **Ejecutar al arrancar** | `@reboot` | `OnBootSec` |
| **Ejecutar tras última ejec.** | ❌ No | ✅ `OnUnitActiveSec` |
| **Frecuencia < 1 minuto** | ❌ No (mín. 1 min) | ✅ Sí (con segundos en OnCalendar) |
| **Variables de entorno** | En el crontab | `Environment=` en el .service |
| **Notificaciones de fallo** | Mail local | `OnFailure=unidad.service` |
| **Portabilidad** | ✅ Cualquier UNIX/Linux | ❌ Solo systemd |
| **Debug** | grep syslog | `systemctl status`, `journalctl -u` |
| **Comprobación** | ❌ | `systemd-analyze calendar` |

```bash
# ¿Cuándo usar cada uno?
# Usa cron si:     tareas simples, portabilidad, o contenedores sin systemd.
# Usa timers si:   logging integrado, recuperación tras apagón, o control de recursos.
```

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
# /etc/systemd/system/cleanup.service
[Unit]
Description=Limpiar caché del sistema

[Service]
Type=oneshot
ExecStart=/usr/bin/journalctl --vacuum-size=200M
ExecStart=/usr/bin/apt-get autoremove -y
```

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

### Monitoreo cada 5 minutos
```ini
[Timer]
OnUnitActiveSec=5min
```

### Ejemplo completo: backup diario con notificación de fallo

```ini
# /etc/systemd/system/backup.service
[Unit]
Description=Backup diario
OnFailure=notificacion-fallo@%n.service

[Service]
Type=oneshot
ExecStart=/home/user/backup.sh
StandardOutput=journal
StandardError=journal
```

```ini
# /etc/systemd/system/backup.timer
[Unit]
Description=Timer para backup diario

[Timer]
OnCalendar=daily
Persistent=true
RandomizedDelaySec=30

[Install]
WantedBy=timers.target
```

```ini
# /etc/systemd/system/notificacion-fallo@.service
[Unit]
Description=Notificar fallo de %i

[Service]
Type=oneshot
ExecStart=/usr/local/bin/notificar.sh "Servicio %i falló"
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now backup.timer
```

## Prevenir ejecuciones duplicadas

Con systemd no hay race condition por defecto: el timer espera a que el servicio termine antes de volver a dispararlo (a menos que se use `Type=simple`).

Para cron, en cambio, usar `flock`:

```bash
*/5 * * * * root /usr/bin/flock -n /var/lock/mi-script /home/user/script.sh
```

## Comandos de administración

```bash
# Listar timers
systemctl list-timers --all          # todos (pasados y futuros)
systemctl list-timers                # solo próximos

# Gestionar
sudo systemctl daemon-reload
sudo systemctl enable --now mi.timer
sudo systemctl start mi.timer
sudo systemctl stop mi.timer
sudo systemctl disable mi.timer

# Probar ejecución inmediata (sin esperar el schedule)
sudo systemctl start mi.service

# Ver estado y logs
systemctl status mi.timer
systemctl status mi.service
journalctl -u mi.service -f
journalctl -u mi.timer
```

## Formato de salida (systemctl list-timers)

```
NEXT                        LEFT          LAST                        PASSED   UNIT           ACTIVATES
Mon 2026-07-28 02:00:00    6h left       Sun 2026-07-27 02:00:00    17h ago  mi-backup.timer mi-backup.service
Tue 2026-07-29 09:00:00    1 day left    Mon 2026-07-21 09:00:00    6 days   cleanup.timer   cleanup.service
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Timer no ejecuta | No está activado | `sudo systemctl enable --now timer.timer` |
| Timer activo pero no dispara | El servicio asociado falla | `journalctl -u servicio.service -p err` |
| `Persistent=true` no funciona | Solo aplica a `OnCalendar=` | Verificar que uses `OnCalendar`, no `OnBootSec` |
| Timer no aparece en `list-timers` | Falta `[Install]` o no habilitado | Añadir `WantedBy=timers.target` y `enable` |
| Timer de usuario no corre sin sesión | `linger` no activado | `sudo loginctl enable-linger $USER` |
| `OnCalendar` con formato incorrecto | Sintaxis inválida | Probar con `systemd-analyze calendar "formato"` |
| Expresión inválida | Error de sintaxis | `systemd-analyze calendar "expresión"` para validar |

## Ver también

- [[Cron]] — alternativa clásica, tareas simples
- [[systemd]] — sistema de init, gestión de servicios
- [[systemd unidades personalizadas]] — service types, templates, sockets, drop-ins
- [[journalctl]] — logs de timers y servicios
- [[Backups (borg restic duplicity rsync)]] — estrategias de backup

## Enlaces externos

- [systemd.timer manual](https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html)
- [Arch Wiki — systemd/Timers](https://wiki.archlinux.org/title/Systemd/Timers)
- [Wikipedia — systemd](https://en.wikipedia.org/wiki/Systemd)
- [systemd-analyze](https://www.freedesktop.org/software/systemd/man/latest/systemd-analyze.html)

#sistema #automatizacion
