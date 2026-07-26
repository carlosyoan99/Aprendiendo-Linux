---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: automatizacion
prioridad: media
---

# Cron

> Daemon de programación de tareas, estándar en Unix/Linux. Ejecuta comandos en horarios definidos. Complementado por anacron para equipos con uptime irregular.

## Sintaxis

```bash
crontab -e                              # editar tareas del usuario actual
crontab -l                              # listar tareas actuales
crontab -r                              # eliminar TODAS las tareas del usuario
crontab -u carlos -e                    # editar tareas de otro usuario (sudo)
```

## Descripción

Cron lee tareas de `/etc/crontab` (sistema), `/etc/cron.d/` (snippets de paquetes), y los crontabs personales (`/var/spool/cron/crontabs/`). Cada tarea se ejecuta según una expresión de 5 campos: minuto, hora, día del mes, mes, día de la semana.

## Formato de crontab

```
┌───────────── minuto (0-59)
│ ┌───────────── hora (0-23)
│ │ ┌───────────── día del mes (1-31)
│ │ │ ┌───────────── mes (1-12)
│ │ │ │ ┌───────────── día de semana (0-7, 0=7=dom)
│ │ │ │ │
* * * * * comando
```

### Símbolos especiales

| Símbolo | Significado | Ejemplo |
|---|---|---|
| `*` | Cualquier valor (cada minuto, cada hora…) | `* * * * *` → cada minuto |
| `*/N` | Cada N unidades | `*/15 * * * *` → cada 15 minutos |
| `N,M,O` | Lista de valores específicos | `0,30 * * * *` → a las 0 y 30 |
| `N-M` | Rango | `9-17` → de 9 a 17 |

### Atajos especiales

| Atajo | Equivale a |
|---|---|
| `@reboot` | Al arrancar el sistema |
| `@yearly` / `@annually` | `0 0 1 1 *` (1 de enero) |
| `@monthly` | `0 0 1 * *` (1 de cada mes) |
| `@weekly` | `0 0 * * 0` (domingo a las 00:00) |
| `@daily` / `@midnight` | `0 0 * * *` (cada día a las 00:00) |
| `@hourly` | `0 * * * *` (al minuto 0 de cada hora) |

### Ejemplos prácticos

```bash
# Cada 15 minutos
*/15 * * * * /home/user/scripts/check-disk.sh

# Cada día a las 3:00 AM
0 3 * * * /home/user/scripts/backup.sh

# Cada lunes a las 9:00 AM
0 9 * * 1 /home/user/scripts/reporte-semanal.sh

# Primer día de cada mes a las 2:00 AM
0 2 1 * * /home/user/scripts/trimestral.sh

# Días laborables (lunes a viernes) cada hora
0 * * * 1-5 /home/user/scripts/check-servicios.sh

# Cada 30 minutos en horario laboral (9-18)
*/30 9-18 * * 1-5 /home/user/scripts/ping-monitores.sh

# Al arrancar (con retardo)
@reboot sleep 30 && /home/user/scripts/arranque.sh
```

## Estructura de archivos

```
/etc/crontab              # crontab del sistema (con campo USER)
/etc/cron.d/              # snippets de cron (por paquete)
/etc/cron.daily/          # scripts que se ejecutan diariamente
/etc/cron.hourly/         # scripts que se ejecutan cada hora
/etc/cron.weekly/         # scripts que se ejecutan semanalmente
/etc/cron.monthly/        # scripts que se ejecutan mensualmente
/var/spool/cron/crontabs/ # crontabs de usuarios
```

Colocar un script en estos directorios es más simple que editar crontab:

```bash
sudo cp mi-backup.sh /etc/cron.daily/
sudo chmod +x /etc/cron.daily/mi-backup.sh
```

## Redirigir salida (logging)

Por defecto, cron envía la salida de los comandos por correo al usuario local. Para evitar llenar el buzón, redirigir explícitamente:

```bash
# Redirigir stdout a archivo de log
0 3 * * * /home/user/backup.sh >> /var/log/backup.log 2>&1

# Descartar toda la salida (si no interesa)
0 3 * * * /home/user/backup.sh > /dev/null 2>&1

# Logging con timestamp
0 3 * * * echo "$(date) - Iniciando backup" >> /var/log/backup.log; /home/user/backup.sh >> /var/log/backup.log 2>&1
```

## Variables de entorno en crontab

Las tareas cron se ejecutan con un entorno mínimo (PATH limitado). Definir variables al inicio del crontab:

```bash
# ── PATH completo (esencial para scripts que usan comandos del sistema) ──
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# ── Editor por defecto ──
EDITOR=nvim

# ── Shell (por defecto /bin/sh, cambiarlo a bash) ──
SHELL=/bin/bash

# ── Variables de entorno adicionales ──
MAILTO=carlos@ejemplo.com     # enviar salida a este correo (vacío = no enviar)

# Ahora las tareas:
0 3 * * * /home/user/backup.sh
```

## System crontab (/etc/crontab)

El crontab del sistema tiene un campo adicional: el usuario que ejecuta la tarea:

```bash
# /etc/crontab — minuto hora día mes día-semana  usuario  comando
0     4    *   *   *           root    /usr/sbin/logrotate /etc/logrotate.conf
30    5    *   *   1           root    /usr/bin/apt update
```

Los archivos en `/etc/cron.d/` también usan este formato:

```bash
# /etc/cron.d/mi-tarea
0 3 * * * root /usr/local/bin/script.sh
```

## Anacron

Para equipos con uptime irregular (laptops), anacron ejecuta tareas periódicas aunque el sistema estuviera apagado cuando debieron ejecutarse.

```bash
# /etc/anacrontab — formato:
# periodo_días retardo_minutos nombre-del-trabajo comando
1              15              daily.clean        apt-get autoremove -y
7              30              weekly.backup      /home/user/backup.sh
30             60              monthly.logs       /home/user/clean-logs.sh
```

| Periodo | Retardo | Nombre | Comando | Efecto |
|---|---|---|---|---|
| `1` | `15` | `daily.clean` | `apt-get autoremove` | Cada 24 h (+15 min retardo) |
| `7` | `30` | `weekly.backup` | `backup.sh` | Cada 7 días (+30 min retardo) |
| `30` | `60` | `monthly.logs` | `clean-logs.sh` | Cada 30 días (+60 min retardo) |

> **Diferencia clave cron vs anacron**: cron ejecuta a hora exacta (si el PC está apagado, no se ejecuta). anacron ejecuta cuando el PC se enciende, si la tarea debió correr mientras estaba apagado. Se complementan.

## Cron vs systemd timers

| Aspecto | cron | systemd timers |
|---|---|---|
| **Sintaxis** | Simple (una línea) | Verbosa (2 archivos) |
| **Logging** | Manual (redirigir salida) | Automático (journalctl) |
| **Persistencia** | ❌ pierde tareas si apagado | ✅ `Persistent=true` |
| **Control de recursos** | ❌ No | ✅ CPUQuota, MemoryMax, etc. |
| **Dependencias** | ❌ No | ✅ `After=network.target`, etc. |
| **Aleatorizar inicio** | ❌ No | ✅ `RandomizedDelaySec` |
| **Frecuencia < 1 minuto** | ❌ No | ✅ Sí |
| **Notificaciones de fallo** | Mail local | ✅ `OnFailure=unidad.service` |
| **Portabilidad** | ✅ Cualquier UNIX/Linux | ❌ Solo systemd |
| **Curva de aprendizaje** | 🟢 Baja | 🟡 Media |

```bash
# ¿Cuándo usar cada uno?
# Usa cron si:     tareas simples, necesitas portabilidad, o trabajas en contenedores sin systemd.
# Usa timers si:   necesitas logging integrado, recuperación tras apagón, o control de recursos.
# Usa anacron si:  tareas diarias/semanales en laptops que se apagan frecuentemente.
```

Ver [[systemd timers]] para la alternativa moderna.

## Casos de uso

### Backup diario
```bash
0 2 * * * /home/carlos/scripts/backup.sh >> /var/log/backup.log 2>&1
```

### Limpieza semanal
```bash
0 3 * * 0 find /tmp -mtime +7 -delete
```

### Monitoreo cada 5 minutos con flock (evitar ejecución duplicada)
```bash
*/5 * * * * /usr/bin/flock -n /tmp/script.lock /home/user/scripts/health-check.sh
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `cron: can't open /var/run/crond.pid` | cron daemon no corre | `sudo systemctl enable --now cron` |
| Tarea no ejecuta | PATH incorrecto | Usar rutas absolutas o definir `PATH=` en crontab |
| Script falla en cron pero funciona en terminal | Entorno mínimo (sin PATH, HOME) | Definir `SHELL=/bin/bash`, `PATH=…` al inicio del crontab |
| `crontab -e` abre editor vacío | No hay crontab aún | Guardar: es normal, se crea uno nuevo |
| Tarea se ejecuta múltiples veces | Race condition | Usar `flock -n` (ver casos de uso) |
| cron envía correos no deseados | Salida sin redirigir | Añadir `>/dev/null 2>&1` o `MAILTO=""` |
| Expresión inválida | Error de sintaxis | Validar con `crontab -e` (valida al guardar) o [crontab.guru](https://crontab.guru/) |

## Ver también

- [[systemd timers]] — alternativa moderna con journald y dependencias
- [[systemd]] — sistema de init y gestión de servicios
- [[journalctl]] — logs de timers y servicios
- [[Automatización y Scripts]] — guía general de automatización
- [[Scripts del Vault]] — documentación de scripts existentes

## Enlaces externos

- [Wikipedia — Cron](https://en.wikipedia.org/wiki/Cron)
- [man crontab(5)](https://man7.org/linux/man-pages/man5/crontab.5.html)
- [man cron(8)](https://man.archlinux.org/man/cron.8)
- [Arch Wiki — Cron](https://wiki.archlinux.org/title/Cron)
- [Crontab Guru — validador online](https://crontab.guru/)

#automatizacion
