---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: baja
---

# at

## Sintaxis

```bash
at [opciones] [hora]
atq          # ver cola de tareas
atrm [ID]    # borrar tarea
at -c [ID]   # mostrar el contenido/job de una tarea
```

## Descripción

Programa la **ejecución única** de un comando en un momento futuro. A diferencia de `cron` (recurrente), `at` ejecuta una sola vez y luego olvida la tarea. El sistema `atd` (daemon) gestiona la cola. Requiere que `atd` esté corriendo.

## Opciones frecuentes

| Flag / Opción | Efecto |
|---|---|
| `at [hora]` | Programar tarea (lee comandos desde stdin) |
| `at -f script.sh [hora]` | Ejecutar comandos desde un archivo |
| `atq` | Listar tareas pendientes de tu usuario |
| `atrm [ID]` | Eliminar una tarea |
| `at -c [ID]` | Mostrar el contenido de una tarea |
| `batch` | Ejecutar cuando la carga del sistema lo permita |

## Formatos de hora

```bash
at now + 5 minutes
at 04:00
at 23:00
at midnight
at noon
at now + 2 hours
at 2026-12-31 23:59
```

## Ejemplos

```bash
echo "reboot" | at 04:00               # reiniciar a las 4 AM
echo "/home/user/backup.sh" | at now + 2 hours  # en 2 horas
echo "shutdown -h now" | at 23:00       # apagar a las 11 PM
at -f tarea.sh 22:00                    # ejecutar script a las 10 PM
atq                                     # ver tareas pendientes
atrm 3                                  # borrar tarea #3
```

## Casos de uso

```bash
# Limpieza puntual nocturna
echo "find /tmp -mtime +7 -delete" | at midnight

# Aplazar un backup de una sola vez
echo "rsync -avz datos/ backup/" | at now + 3 days

# Lanzar script sin terminal adjunta
at -f /opt/scripts/actualizar.sh 09:00 2>/dev/null
```

## Control de acceso

| Archivo | Efecto |
|---|---|
| `/etc/at.allow` | Solo los usuarios listados pueden usar `at` |
| `/etc/at.deny` | Usuarios listados NO pueden usar `at` |
| (ninguno de los dos) | Todos pueden usar `at` |

> Si existe `/etc/at.allow`, solo los usuarios de ese archivo usan `at`. Si solo existe `at.deny`, todos menos esos lo usan.

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `Can't open /var/run/atd.pid` | El daemon `atd` no está activo | `systemctl enable --now atd` |
| `Garbled time` | Hora mal formada | Revisar formato `at now + 2 hours` |
| `You do not have permission` | No estás en `at.allow` / estás en `at.deny` | Contactar admin o revisar `/etc/at.*` |
| La tarea no se ejecutó | `atd` no corre o path no accesible | Verificar `systemctl status atd` y rutas absolutas |

## Notas y advertencias

- `at` lee los comandos desde **stdin** o `-f archivo`; no ejecuta directamente en el comando como argumento.
- La salida de una tarea `at` se envía por correo al usuario (a `/var/mail`) a menos que la redirijas: `echo "cmd > /tmp/out.log 2>&1" | at now + 1 minute`.
- `at` no persiste tras reinicios: para tareas recurrentes o de arranque usa `cron` o `systemd timers`.

## Enlaces externos

- [Arch Wiki — cron#at (at)](https://wiki.archlinux.org/title/Cron#at)
- [man at(1)](https://man7.org/linux/man-pages/man1/at.1.html)

## Ver también

- [[nohup]] — ejecutar sin depender de la terminal
- [[timeout]] — limitar tiempo de ejecución
- [[Cron]] · [[systemd timers]] — tareas programadas recurrentes
- [[bash-avanzado]] — job control

#comando
