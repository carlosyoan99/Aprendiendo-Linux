---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: media
---

# nohup

## Sintaxis

```bash
nohup [comando] &
```

## Descripción

Ejecuta un proceso inmune a SIGHUP (señal de cierre de terminal). La salida va a `nohup.out` por defecto. Ideal para scripts que deben seguir ejecutándose aunque cierres la terminal.

## Ejemplos

```bash
nohup ./script.sh &                    # ejecutar en background
nohup ./script.sh > log.txt 2>&1 &     # redirigir salida
nohup rsync -avz src/ user@host:/dst/ & # sync en background
```

## Ver también

- [[timeout]] — limitar tiempo de ejecución
- [[at]] — ejecución programada única
- [[Cron]] · [[systemd timers]] — tareas recurrentes
- [[bash-avanzado]] — job control, signals

#comando
