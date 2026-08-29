---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: media
---

# nohup

## Sintaxis

```bash
nohup [comando] [argumentos...] &
```

## Descripción

Ejecuta un proceso **inmune a SIGHUP** (la señal que envía el cierre de terminal). Así, el proceso sigue corriendo aunque cierres la sesión SSH o la terminal. La salida (stdout/stderr) va a `nohup.out` por defecto si no se redirige. Ideal para scripts o servicios largos que deben continuar en segundo plano.

## Opciones frecuentes

| Flag / Opción | Efecto |
|---|---|
| `nohup comando &` | Ejecutar en background al cerrar la terminal |
| `--` | Indicar fin de opciones (comando con guiones) |
| `nohup comando </dev/null` | Redirigir stdin para evitar interrupciones |

## Ejemplos

```bash
nohup ./script.sh &                    # ejecutar en background
nohup ./script.sh > log.txt 2>&1 &     # redirigir salida a log
nohup rsync -avz src/ user@host:/dst/ & # sync en background
nohup java -jar app.jar > app.log 2>&1 &
```

## Casos de uso reales

```bash
# Lanzar un servidor y mantenerlo tras cerrar SSH
ssh servidor
nohup python3 -m http.server 8080 > server.log 2>&1 &

# Script largo de procesamiento que no debe morir al salir
nohup ./respaldo-grande.sh > respaldo.log 2>&1 &

# Combinar con disown para eliminar el job de la tabla
nohup ./tarea.sh > salida.log 2>&1 & disown
```

## Combinación con disown y setsid

| Técnica | Efecto |
|---|---|
| `nohup cmd &` | Ignora SIGHUP, pero sigue en la tabla de jobs |
| `nohup cmd & disown` | + elimina el job del shell (no se avisa al salir) |
| `setsid cmd &` | Nueva sesión, totalmente desacoplado |
| `systemd-run --user cmd` | Gestionado por systemd (la opción moderna) |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| La salida va a `nohup.out` inesperada | No redirigiste stdout/stderr | Redirige: `cmd > log 2>&1` |
| `nohup: ignoring input and appending output to 'nohup.out'` | Aviso normal, no error | Redirige entrada/salida si molesta |
| Proceso muere igualmente al cerrar | La terminal/SIGTERM o el proceso depende del shell hijo | Usar `setsid`, `systemd-run`, o `tmux`

## Notas y advertencias

- `nohup` **no** inmuniza contra `SIGTERM`/`SIGKILL` — solo contra `SIGHUP`.
- La salida no redirigida siempre acaba en `nohup.out` en el directorio actual.
- **Alternativa moderna**: para servicios reales, usar `systemd`/`systemd-run` en vez de `nohup` (gestión de dependencias, reinicio automático, logs).

## Enlaces externos

- [Wikipedia — nohup](https://en.wikipedia.org/wiki/Nohup)
- [man nohup(1)](https://man7.org/linux/man-pages/man1/nohup.1.html)

## Ver también

- [[timeout]] — limitar tiempo de ejecución
- [[at]] — ejecución programada única
- [[Cron]] · [[systemd timers]] — tareas recurrentes
- [[bash-avanzado]] — job control, signals

#comando
