---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: automatizacion
prioridad: media
---

# Cron y Systemd Timers

## Definición

Dos formas de programar tareas periódicas en Linux. **cron** es la clásica y universal (disponible en cualquier UNIX/Linux). **systemd timers** es la alternativa moderna con mejor logging, recuperación de tareas perdidas y control de recursos.

> Ver [[systemd]] para la gestión de servicios, targets y systemctl en general.

---

## cron — La clásica universal

### Sintaxis del crontab

```bash
# Formato: minuto hora día-del-mes mes día-de-la-semana comando
#           0-59  0-23  1-31         1-12  0-7 (0=domingo, 7=domingo)
```

```bash
# ── Símbolos especiales ──
# *       → cualquier valor (cada minuto, cada hora, etc.)
# */N     → cada N unidades (ej: */15 → cada 15 minutos)
# N,M,O   → lista de valores específicos (ej: 0,15,30,45)
# N-M     → rango (ej: 9-17 → de 9 a 17)
```

```bash
# ── Atajos especiales ──
@reboot         # ejecutar al arrancar
@yearly         # 0 0 1 1 *      (1 de enero)
@monthly        # 0 0 1 * *      (1 de cada mes)
@weekly         # 0 0 * * 0      (domingo a las 00:00)
@daily          # 0 0 * * *      (cada día a las 00:00)
@hourly         # 0 * * * *      (al minuto 0 de cada hora)
```

### Ejemplos prácticos

```bash
# ── Cada 15 minutos ──
*/15 * * * * /home/user/scripts/check-disk.sh

# ── Cada día a las 3:00 AM ──
0 3 * * * /home/user/scripts/backup.sh

# ── Cada lunes a las 9:00 AM ──
0 9 * * 1 /home/user/scripts/reporte-semanal.sh

# ── Primer día de cada mes a las 2:00 AM ──
0 2 1 * * /home/user/scripts/trimestral.sh

# ── Días laborables (lunes a viernes) cada hora ──
0 * * * 1-5 /home/user/scripts/check-servicios.sh

# ── Cada 30 minutos en horario laboral (9-18) ──
*/30 9-18 * * 1-5 /home/user/scripts/ping-monitores.sh

# ── Al arrancar (con retardo) ──
@reboot sleep 30 && /home/user/scripts/arranque.sh
```

### Editar y gestionar crontab

```bash
crontab -e                              # editar tareas del usuario actual
crontab -l                              # listar tareas actuales
crontab -r                              # eliminar TODAS las tareas del usuario
crontab -u carlos -e                    # editar tareas de otro usuario (sudo)

# Probar sintaxis de crontab sin instalarlo
crontab -e                              # al guardar, cron valida la sintaxis automáticamente
```

### Redirigir salida (logging)

Por defecto, cron envía la salida de los comandos por correo al usuario local. Para evitar llenar el buzón, redirigir explícitamente:

```bash
# Redirigir stdout a archivo de log
0 3 * * * /home/user/backup.sh >> /var/log/backup.log 2>&1

# Descartar toda la salida (si no interesa)
0 3 * * * /home/user/backup.sh > /dev/null 2>&1

# Logging con timestamp
0 3 * * * echo "$(date) - Iniciando backup" >> /var/log/backup.log; /home/user/backup.sh >> /var/log/backup.log 2>&1
```

### Variables de entorno en crontab

```bash
# Las tareas cron se ejecutan con un entorno mínimo (PATH limitado).
# Definir variables al inicio del crontab (antes de las tareas):

# ── PATH completo (esencial para scripts que usan comandos del sistema) ──
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# ── Editor por defecto ──
EDITOR=nvim

# ── Shell (por defecto /bin/sh, cambiarlo a bash) ──
SHELL=/bin/bash

# ── Variables de entorno adicionales ──
HOME=/home/carlos
MAILTO=carlos@ejemplo.com                # enviar salida a este correo (vacío = no enviar)

# Ahora las tareas:
0 3 * * * /home/user/backup.sh
```

### System crontab (/etc/crontab)

El sistema tiene su propio crontab con un campo adicional: **el usuario que ejecuta la tarea**:

```bash
# /etc/crontab — requiere sudo para editar
# minuto hora día mes día-semana  usuario  comando
0     4    *   *   *           root       /usr/sbin/logrotate /etc/logrotate.conf
30    5    *   *   1           root       /usr/bin/apt update
```

Los archivos en `/etc/cron.d/` también usan este formato (con usuario):

```bash
# /etc/cron.d/mi-tarea
0 3 * * * root /usr/local/bin/script.sh
```

### Directorios cron por defecto

```bash
# Scripts colocados en estos directorios se ejecutan automáticamente:
ls /etc/cron.hourly/     # scripts que corren cada hora
ls /etc/cron.daily/      # scripts que corren cada día (a las 6:25 AM)
ls /etc/cron.weekly/     # scripts que corren cada semana (los domingos)
ls /etc/cron.monthly/    # scripts que corren cada mes
```

```bash
# Colocar un script aquí es más simple que editar crontab:
sudo cp mi-backup.sh /etc/cron.daily/
sudo chmod +x /etc/cron.daily/mi-backup.sh
```

---

## anacron — Para equipos que se apagan

`anacron` ejecuta tareas **que se perdieron** porque el equipo estaba apagado en el momento programado. Ideal para laptops y equipos de escritorio que no están encendidos 24/7.

```bash
# /etc/anacrontab — formato:
# periodo_días retardo_minutos nombre-del-trabajo comando
1              15              daily.clean        apt-get autoremove -y
7              30              weekly.backup      /home/user/backup.sh
30             60              monthly.logs       /home/user/clean-logs.sh
```

| Periodo | Retardo | Nombre | Comando | Efecto |
|---|---|---|---|---|
| `1` | `15` | `daily.clean` | `apt-get autoremove` | Cada 24h (+15 min retardo) |
| `7` | `30` | `weekly.backup` | `backup.sh` | Cada 7 días (+30 min retardo) |
| `30` | `60` | `monthly.logs` | `clean-logs.sh` | Cada 30 días (+60 min retardo) |

```bash
# Diferencia clave cron vs anacron:
# cron:      ejecuta a hora exacta. Si el PC está apagado, no se ejecuta.
# anacron:   ejecuta cuando el PC se enciende, si la tarea debió correr mientras estaba apagado.
# Se complementan: cron para tareas con hora fija, anacron para diarias/semanales sin hora exacta.
```

---

## systemd timers — Alternativa moderna

### Estructura básica

Requiere dos archivos: un `.service` (qué ejecutar) y un `.timer` (cuándo).

```ini
# /etc/systemd/system/mi-backup.service — define QUÉ ejecutar
[Unit]
Description=Backup semanal

[Service]
Type=oneshot
ExecStart=/home/user/backup.sh
# (No tiene [Install] — no se activa directamente)
```

```ini
# /etc/systemd/system/mi-backup.timer — define CUÁNDO ejecutar
[Unit]
Description=Ejecutar backup semanal

[Timer]
OnCalendar=weekly                     # atajos: daily, hourly, monthly
# OnCalendar=Mon..Fri 02:00           # días laborables a las 2 AM
# OnCalendar=*-*-1..7 03:00           # primeros 7 días de cada mes a las 3 AM
# OnCalendar=2026-12-31 23:59         # fecha específica
# OnCalendar=*-*-* 00/6:00:00         # cada 6 horas
Persistent=true                       # si el PC estaba apagado, ejecuta al encender
RandomizedDelaySec=60                 # evitar que todos los timers se disparen a la vez
OnActiveSec=5min                      # ejecutar 5 min después de activar el timer
OnBootSec=10min                       # ejecutar 10 min después de arrancar
OnUnitActiveSec=1h                    # ejecutar 1h después de la última ejecución

[Install]
WantedBy=timers.target
```

```bash
# Activar el timer (no el servicio)
sudo systemctl daemon-reload
sudo systemctl enable --now mi-backup.timer

# Ver timers activos
systemctl list-timers --all

# Probar ejecución inmediata (sin esperar la fecha programada)
sudo systemctl start mi-backup.service

# Ver logs del timer y del servicio
journalctl -u mi-backup.timer
journalctl -u mi-backup.service
```

### Formato OnCalendar (sintaxis extendida)

```
Formato:   día-semana año-mes-día hora:minuto:segundo
Ejemplo:  Mon         2026-*-*   02:00:00

Atajos:   hourly, daily, weekly, monthly, yearly

Especificaciones comunes:
  Mon..Fri 09:00:00         → lunes a viernes a las 9 AM
  Sat,Sun 10:00:00          → fines de semana a las 10 AM
  *-*-1,15 03:00:00         → días 1 y 15 de cada mes a las 3 AM
  *-01-01 00:00:00          → cada año nuevo
  *-*-* 00/6:00:00          → cada 6 horas (00, 06, 12, 18)
  *-*-* 09..17:00/1:00:00   → cada hora de 9 AM a 5 PM
  *-*-* 00:00/15:00         → cada 15 minutos
```

### Timers de usuario (sin sudo)

```bash
# Los servicios y timers de usuario van en ~/.config/systemd/user/
mkdir -p ~/.config/systemd/user/

# Activar sin sudo:
systemctl --user daemon-reload
systemctl --user enable --now mi-backup.timer

# Ver timers del usuario
systemctl --user list-timers

# Importante: los timers de usuario solo corren mientras el usuario tenga sesión activa
# Para que corran siempre: loginctl enable-linger $USER
sudo loginctl enable-linger $(whoami)
```

---

## cron vs systemd timers — Comparativa detallada

| Característica | cron | systemd timers |
|---|---|---|
| **Sintaxis** | Simple (una línea) | Verbosa (2 archivos) |
| **Logging** | Manual (redirigir salida) | Automático (journalctl) |
| **Recuperar tareas perdidas** | ❌ No (PC apagado = tarea perdida) | ✅ `Persistent=true` |
| **Control de recursos** | ❌ No | ✅ CPUQuota, MemoryMax, etc. |
| **Dependencias** | ❌ No | ✅ `After=network.target`, etc. |
| **Aleatorizar inicio** | ❌ No | ✅ `RandomizedDelaySec` |
| **Ejecutar al arrancar** | `@reboot` | `OnBootSec` |
| **Ejecutar tras última ejecución** | ❌ No | ✅ `OnUnitActiveSec` |
| **Frecuencia < 1 minuto** | ❌ No (mínimo 1 minuto) | ✅ Sí (con `OnCalendar=*-*-* *:*:0/30`) |
| **Variables de entorno** | En el crontab | `Environment=` en el .service |
| **Notificaciones de fallo** | Mail local | `OnFailure=unidad.service` |
| **Portabilidad** | ✅ Cualquier UNIX/Linux | ❌ Solo systemd |
| **Curva de aprendizaje** | 🟢 Baja | 🟡 Media |

```bash
# ¿Cuándo usar cada uno?
# Usa cron si:     tareas simples, necesitas portabilidad, o trabajas en contenedores sin systemd.
# Usa timers si:   necesitas logging integrado, recuperación tras apagón, o control de recursos.
# Usa anacron si:  tareas diarias/semanales en laptops que se apagan frecuentemente.
```

---

## Troubleshooting

### cron

| Problema | Causa | Solución |
|---|---|---|
| `cron: can't open or create /var/run/crond.pid` | cron daemon no corre | `sudo systemctl enable --now cron` |
| Tarea cron no se ejecuta | PATH incorrecto | Usar rutas absolutas o definir `PATH=/usr/bin:/bin` en crontab |
| Script cron falla pero funciona en terminal | Entorno diferente (sin PATH, sin HOME) | Las tareas cron se ejecutan con entorno mínimo. Definir PATH, SHELL y variables al inicio |
| `crontab -e` abre editor vacío | No hay crontab para el usuario | Guardar: es normal, se crea uno nuevo |
| `crontab: installing new crontab` reporta error | Sintaxis incorrecta | Revisar espacios, formato, y que el comando exista |
| Tarea se ejecuta múltiples veces | Cron race condition | Usar `flock`: `*/5 * * * * /usr/bin/flock -n /tmp/script.lock /ruta/script.sh` |
| cron envía correos no deseados | Salida de comandos sin redirigir | Añadir `>/dev/null 2>&1` o `MAILTO=""` |

### systemd timers

| Problema | Causa | Solución |
|---|---|---|
| Timer no se ejecuta | No está activado | `sudo systemctl enable --now timer.timer` |
| Timer activo pero no dispara | El servicio asociado falla | `journalctl -u servicio.service -p err` |
| `Persistent=true` no funciona | Solo aplica a `OnCalendar=` | Verificar que uses `OnCalendar` (no `OnBootSec` o `OnUnitActiveSec`) |
| Timer no aparece en `list-timers` | No tiene `[Install]` o no está habilitado | Añadir `WantedBy=timers.target` y hacer `enable` |
| Timer de usuario no corre si no hay sesión | `linger` no activado | `sudo loginctl enable-linger $USER` |
| `OnCalendar` con formato incorrecto | Sintaxis inválida | Probar con `systemd-analyze calendar "mi-formato"` para validar |

### Validar sintaxis

```bash
# Validar formato OnCalendar de systemd
systemd-analyze calendar "Mon..Fri 02:00"
# Muestra: Normalized form: Mon..Fri 2026-*-* 02:00:00
# Si sale error, el formato es inválido

# Ver próximas ejecuciones de un timer
systemd-analyze calendar --iterations 5 "Mon..Fri 09:00:00"
# Muestra las próximas 5 fechas en que se ejecutaría

# Para cron: usar una web de validación online (sintaxis de cron puede ser engañosa)
```

### Prevenir ejecuciones duplicadas (lock)

Cuando una tarea tarda más que el intervalo de repetición, puede haber múltiples instancias ejecutándose:

```bash
# Con cron — usar flock (file lock):
# /etc/crontab
*/5 * * * * root /usr/bin/flock -n /var/lock/mi-script /home/user/script.sh

# Con systemd — no hay problema de raza porque el timer espera a que el servicio termine
# (a menos que se use Type=simple, en cuyo caso el servicio corre en background)
```

---

## Ejemplo completo: backup diario con notificación

### Con cron

```bash
# crontab -e
MAILTO=carlos@ejemplo.com
0 3 * * * /home/user/backup.sh >> /var/log/backup.log 2>&1
```

### Con systemd timer

```ini
# /etc/systemd/system/backup.service
[Unit]
Description=Backup diario
OnFailure=notificacion-fallo@%n.service       # si falla, dispara notificación

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

---

## Enlaces externos

- [Wikipedia — cron](https://en.wikipedia.org/wiki/Cron)
- [Wikipedia — systemd (timers)](https://en.wikipedia.org/wiki/Systemd#Timers)
- [Arch Wiki — systemd/Timers](https://wiki.archlinux.org/title/Systemd/Timers)
- [Arch Wiki — cron](https://wiki.archlinux.org/title/Cron)
- [man page cron(8)](https://man.archlinux.org/man/cron.8)
- [man page crontab(5)](https://man.archlinux.org/man/crontab.5)
- [systemd.timer manual](https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html)
- [Crontab Guru — validador online de cron](https://crontab.guru/)
- [systemd-analyze — validar OnCalendar](https://www.freedesktop.org/software/systemd/man/latest/systemd-analyze.html)

## Ver también

- [[systemd]] — gestión de servicios, targets, systemctl
- [[journalctl]] — logs de timers y servicios
- [[Automatizacion y Scripts]] — scripts de automatización del vault
- [[Administracion y Diagnostico]] — MoC de administración del sistema

#automatizacion #programacion
