---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: media
---

# timeout

## Sintaxis

```bash
timeout [duración] [comando] [argumentos...]
timeout [opciones] [duración] [comando]
```

## Descripción

Ejecuta un comando con un **límite de tiempo**. Si el comando no termina antes de la duración especificada, recibe una señal (por defecto `TERM`) y es terminado. Esencial en scripts y tareas de diagnóstico para evitar que un comando cuelgue el proceso indefinidamente.

## Opciones

| Opción | Descripción |
|---|---|
| `--signal=SIG` | Señal a enviar al expirar (default: `TERM`) |
| `--kill-after=DUR` | Fuerza `KILL` tras DUR si la primera señal no mata |
| `--preserve-status` | Retornar el status del comando, no el de timeout |
| `--foreground` | No crear grupo de procesos propio |
| `--verbose` | Informar cuando se expire el tiempo |
| `-k DUR` | Abreviatura de `--kill-after` |

## Duración

| Formato | Significado |
|---|---|
| `10` | segundos (por defecto) |
| `5m` | minutos |
| `2h` | horas |
| `3d` | días |
| `1h 30m` | combinación |

## Ejemplos

```bash
timeout 10s ping google.com            # ping máximo 10 segundos
timeout 5m ./script-largo.sh           # abortar si tarda más de 5 min
timeout --signal=KILL 60s make -j4     # forzar kill tras 60s
timeout -k 5s 30s rsync -avz src/ dst/ # TERM a los 30s, KILL a los 35s
```

## Casos de uso

```bash
# En scripts: abortar si algo tarda demasiado
timeout 120 apt update || echo "apt update timeout"

# Evitar que un comando cuelgue el pipeline
timeout 10 ssh host 'comando_lento'

# Degradación elegante: TERM primero, KILL como respaldo
timeout --preserve-status -k 5 30 comando_importante
```

## Combinaciones comunes con pipe

```bash
# algoritmo de timeout + redirección de error
timeout 30 comando > out.log 2>&1 || echo "falló"

# timeout que conserva el código de salida del programa
timeout --preserve-status 30 comando
```

## Alternativas

| Herramienta | Uso |
|---|---|
| **`timeout`** | Límite de tiempo simple para un proceso |
| **`perl -e 'alarm...'` / `gtimeout`** | Variantes (macOS) |
| **`systemd-run --on-active`** | Para tareas con más garantías |
| **`nohup` + kill manual** | Control manual sin límite automático |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| El comando no muere con `TERM` | Algunos programas ignoran TERM | Usar `--signal=KILL` o `--kill-after` |
| Perdiste el código de salida real | timeout devuelve 124 por defecto | Usar `--preserve-status` |
| Tiempo no se aplica | `--foreground` en scripts por `setsid` | Revisar si el comando ejecuta procesos hijos |

## Notas y advertencias

- Código de salida **124** = el comando fue terminado por timeout; **125** = error propio de timeout.
- Sin `--kill-after`, un proceso que ignora `TERM` seguirá vivo.
- En macOS el comando se llama `gtimeout` (viene con coreutils).

## Enlaces externos

- [GNU Coreutils — timeout](https://www.gnu.org/software/coreutils/manual/html_node/timeout-invocation.html)
- [man timeout(1)](https://man7.org/linux/man-pages/man1/timeout.1.html)

## Ver también

- [[nohup]] — ejecutar sin depender de la terminal
- [[at]] — ejecución programada única
- [[sleep]] — pausar ejecución
- [[bash-avanzado]] — job control, signals

#comando
