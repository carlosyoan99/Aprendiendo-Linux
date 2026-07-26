---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: media
---

# nohup, timeout, at

> Tres utilidades para controlar la ejecución de procesos: nohup desacopla de la terminal, timeout limita el tiempo, at programa una ejecución única.

## nohup — ejecutar sin depender de la terminal

```bash
nohup [comando] &
```

Ejecuta un proceso inmune a SIGHUP (señal de cierre de terminal). La salida va a `nohup.out` por defecto.

```bash
nohup ./script.sh &                    # ejecutar en background
nohup ./script.sh > log.txt 2>&1 &     # redirigir salida
nohup rsync -avz src/ user@host:/dst/ & # sync en background
```

## timeout — limitar tiempo de ejecución

```bash
timeout [duración] [comando]
```

```bash
timeout 10s ping google.com            # ping máximo 10 segundos
timeout 5m ./script-largo.sh           # abortar si tarda más de 5 min
timeout 30s ssh user@host "comando"    # abortar SSH lento
timeout --signal=KILL 60s make -j4     # forzar kill tras 60s
```

### Opciones

| Opción | Descripción |
|---|---|
| `--signal=SIG` | Señal a enviar al expirar (default: TERM) |
| `--preserve-status` | Retornar status del comando (no de timeout) |
| `--foreground` | No crear grupo de procesos |

## at — ejecutar una vez en el futuro

```bash
at [hora]                              # programar tarea
atq                                    # ver cola de tareas
atrm [ID]                              # borrar tarea
```

```bash
echo "reboot" | at 04:00               # reiniciar a las 4 AM
echo "/home/user/backup.sh" | at now + 2 hours  # en 2 horas
echo "shutdown -h now" | at 23:00       # apagar a las 11 PM
atq                                     # ver tareas pendientes
atrm 3                                  # borrar tarea #3
```

## Casos de uso

### Ejecutar script al cerrar terminal
```bash
nohup ./server.sh > /var/log/server.log 2>&1 &
disown    # aún más seguro: eliminar del job control
```

### Timeout para evitar procesos colgados
```bash
# En scripts: abortar si algo tarda demasiado
timeout 120 apt update || echo "apt update timeout"
```

### Tarea programada sin cron
```bash
echo "find /tmp -mtime +7 -delete" | at midnight
```

## Ver también

- [[Cron]] — tareas recurrentes
- [[systemd timers]] — reemplazo moderno de cron
- [[bash-avanzado]] — job control, background, signals

#comando
