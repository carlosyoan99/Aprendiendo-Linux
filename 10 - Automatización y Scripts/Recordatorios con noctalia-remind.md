---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: automatizacion
prioridad: media
tipo: Tutorial de script
---

# Recordatorios con noctalia-remind

`noctalia-remind` es un temporizador CLI que, al cumplirse el tiempo, lanza una notificación de Noctalia. Vive en `~/.local/bin/`.

## Uso

```bash
noctalia-remind --in 30m "Reunión en 30 min"            # tiempo relativo
noctalia-remind --at 14:30 "Llamada al banco"           # hora concreta
noctalia-remind --in 1h30m --summary "Pausa" "Descanso" # con resumen propio
```

- `--in` parsea combinaciones de `s`/`m`/`h`/`d` (ej. `90s`, `1h30m`, `2d`).
- `--at` usa `date -d`; si la hora ya pasó hoy, asume mañana.
- Sin mensaje, lee de stdin (`echo "..." | noctalia-remind`). Sin mensaje válido → sale con código 2.
- Resumen por defecto: `Recordatorio`.

## Errores (salida 2)

| Caso | Mensaje |
|---|---|
| `--in 5x "msg"` | `Unidad desconocida 'x'` |
| `--in` y `--at` juntos | `Usa --in O --at, no ambos` |
| `--at 99:99` | `Hora inválida` |
| Sin mensaje | `No diste un mensaje` |

## Ver también

- [[Scripts de personalización del sistema]]
- [[Desktop Shells (Noctalia Caelestia)]]

#automatizacion #scripts #noctalia