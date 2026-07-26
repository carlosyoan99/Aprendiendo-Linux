---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: media
---

# timeout

## Sintaxis

```bash
timeout [duración] [comando]
```

## Descripción

Ejecuta un comando con un límite de tiempo. Si el comando no termina antes de la duración especificada, recibe una señal y es terminado.

## Opciones

| Opción | Descripción |
|---|---|
| `--signal=SIG` | Señal a enviar al expirar (default: TERM) |
| `--preserve-status` | Retornar status del comando (no de timeout) |
| `--foreground` | No crear grupo de procesos |

## Ejemplos

```bash
timeout 10s ping google.com            # ping máximo 10 segundos
timeout 5m ./script-largo.sh           # abortar si tarda más de 5 min
timeout --signal=KILL 60s make -j4     # forzar kill tras 60s
```

## Casos de uso

```bash
# En scripts: abortar si algo tarda demasiado
timeout 120 apt update || echo "apt update timeout"
```

## Ver también

- [[nohup]] — ejecutar sin depender de la terminal
- [[at]] — ejecución programada única
- [[sleep]] — pausar ejecución
- [[bash-avanzado]] — job control, signals

#comando
