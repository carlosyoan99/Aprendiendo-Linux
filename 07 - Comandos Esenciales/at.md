---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: baja
---

# at

## Sintaxis

```bash
at [hora]
atq          # ver cola de tareas
atrm [ID]    # borrar tarea
```

## Descripción

Programa la ejecución única de un comando en un momento futuro. A diferencia de cron (que es recurrente), at ejecuta una sola vez y luego olvida la tarea.

## Ejemplos

```bash
echo "reboot" | at 04:00               # reiniciar a las 4 AM
echo "/home/user/backup.sh" | at now + 2 hours  # en 2 horas
echo "shutdown -h now" | at 23:00       # apagar a las 11 PM
atq                                     # ver tareas pendientes
atrm 3                                  # borrar tarea #3
```

## Casos de uso

```bash
echo "find /tmp -mtime +7 -delete" | at midnight
```

## Ver también

- [[nohup]] — ejecutar sin depender de la terminal
- [[timeout]] — limitar tiempo de ejecución
- [[Cron]] · [[systemd timers]] — tareas programadas recurrentes

#comando
