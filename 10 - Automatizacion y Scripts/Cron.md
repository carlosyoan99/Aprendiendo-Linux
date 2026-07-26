---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: automatizacion
prioridad: media
---

# Cron

> Daemon de programación de tareas el estándar en Unix/Linux. Ejecuta comandos en horarios definidos. Complementado por anacron para equipos con uptime irregular.

## Sintaxis

```bash
crontab -e                         # editar crontab del usuario
crontab -l                         # listar tareas del usuario
crontab -l -u carlos               # listar tareas de otro usuario (root)
```

## Descripción

Cron lee tareas de `/etc/crontab`, `/etc/cron.d/`, y los crontabs personales (`/var/spool/cron/crontabs/`). Cada tarea se ejecuta según una expresión de 5 campos: minuto, hora, día del mes, mes, día de la semana.

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

### Ejemplos de expresiones

```
30 2 * * *       # todos los días a las 2:30 AM
0 */4 * * *      # cada 4 horas
0 9 * * 1-5      # laborables a las 9 AM
0 0 1 * *        # primer día de cada mes
*/5 * * * *      # cada 5 minutos
0 22 * * 5       # viernes a las 10 PM
```

### Atajos

| Atajo | Equivale a |
|---|---|
| `@reboot` | Al arrancar el sistema |
| `@yearly` / `@annually` | `0 0 1 1 *` |
| `@monthly` | `0 0 1 * *` |
| `@weekly` | `0 0 * * 0` |
| `@daily` / `@midnight` | `0 0 * * *` |
| `@hourly` | `0 * * * *` |

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

## Anacron

Para equipos con uptime irregular (laptops), anacron ejecuta tareas periódicas aunque el sistema estuviera apagado cuando debieron ejecutarse.

```bash
# /etc/anacrontab
# period   delay   job-id     command
1          5       cron.daily  run-parts /etc/cron.daily
7          25      cron.weekly run-parts /etc/cron.weekly
@monthly   45      cron.monthly run-parts /etc/cron.monthly
```

## Cron vs systemd timers

| Aspecto | cron | systemd timers |
|---|---|---|
| **Complejidad** | Simple | Más complejo |
| **Logging** | syslog | journald (integrado) |
| **Persistencia** | ❌ pierde tareas | ✅ `Persistent=true` |
| **Dependencias** | ❌ | ✅ `After=`, `Requires=` |
| **Debug** | `grep syslog` | `systemctl status`, `journalctl` |

Ver [[systemd timers]] para el reemplazo moderno.

## Casos de uso

### Backup diario
```bash
# crontab -e
0 2 * * * /home/carlos/scripts/backup.sh >> /var/log/backup.log 2>&1
```

### Limpieza semanal
```bash
0 3 * * 0 find /tmp -mtime +7 -delete
```

### Monitoreo cada 5 minutos
```bash
*/5 * * * * /home/carlos/scripts/health-check.sh
```

## Troubleshooting

| Problema | Solución |
|---|---|
| Tarea no ejecuta | Verificar con `crontab -l`, revisar `/var/log/syslog` |
| Mail no configurada | Las salidas de cron van a correo; usar `>> logfile 2>&1` |
| Permisos | Script debe ser ejecutable (`chmod +x`) |
| Variables de entorno | Cron no carga `.bashrc`; definir PATH y vars en el script |

## Ver también

- [[systemd timers]] — reemplazo moderno de cron
- [[Automatizacion y Scripts]] — guía general
- [[Scripts del Vault]] — documentación de scripts existentes

## Enlaces externos

- [Wikipedia — Cron](https://en.wikipedia.org/wiki/Cron)
- [man crontab(5)](https://man7.org/linux/man-pages/man5/crontab.5.html)
- [Arch Wiki — Cron](https://wiki.archlinux.org/title/Cron)

#automatizacion
