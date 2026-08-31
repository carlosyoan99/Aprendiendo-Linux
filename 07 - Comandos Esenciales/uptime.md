---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: comando
prioridad: baja
---

# uptime

> Muestra el tiempo que el sistema lleva encendido, el número de usuarios conectados y la carga media del sistema (load average).

## Sintaxis

```bash
uptime [opciones]
```

## Descripción

`uptime` muestra en una sola línea: hora actual, tiempo desde el último boot, usuarios conectados, y load average (1, 5 y 15 minutos). Es una de las primeras comandos que se ejecutan para diagnosticar un servidor.

## Formato de salida

```
 14:32:07 up 12 days,  3:24,  2 users,  load average: 0.42, 0.38, 0.35
```

| Campo | Significado |
|---|---|
| `14:32:07` | Hora actual |
| `up 12 days, 3:24` | Tiempo desde el último boot |
| `2 users` | Usuarios con sesiones abiertas (TTY + PTY) |
| `load average: 0.42, 0.38, 0.35` | Carga media en 1, 5 y 15 minutos |

## Load average

El load average representa el número promedio de procesos en estado **running** o **waiting** (Runnable + Uninterruptible Sleep).

| Valor vs CPUs | Significado |
|---|---|
| Load < núm CPUs | Sistema con capacidad libre |
| Load = núm CPUs | Sistema al 100% |
| Load > núm CPUs | Procesos en cola (posible cuello de botella) |
| Load >> núm CPUs | Sistema sobrecargado |

```bash
# Ver número de CPUs disponibles
nproc
# Si nproc=4 y load average=3.2 → sistema cómodo
# Si nproc=4 y load average=8.5 → sistema saturado
```

## Opciones

| Opción | Descripción |
|---|---|
| `-p` | Formato pretty (compatible con scripts) |
| `-s` | Solo la hora actual |
| `-V` | Mostrar versión |

## Ejemplos

```bash
uptime                         # salida estándar
uptime -p                      # "up 12 days, 3 hours, 24 minutes"
uptime -s                      # "2026-08-18 11:08:07" (fecha del último boot)

# Combinar con otros comandos
uptime && free -h              # uptime + memoria
watch -n 5 uptime              # actualizar cada 5 segundos
```

## Diferencia con `w`

```bash
# uptime: solo resumen
uptime
# 14:32 up 12 days,  2 users,  load: 0.42, 0.38, 0.35

# w: resume + lista de usuarios y sus procesos
w
# 14:32  up 12 days,  2 users,  load: 0.42, 0.38, 0.35
# USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
# carlos   pts/0    192.168.1.100    10:15    0.00s  1.23s  0.01s w
```

## Ver también

- `w` — usuarios conectados + actividad
- `who` — quién está conectado
- `last` — historial de sesiones
- `top` / [[htop btop]] — monitoreo en tiempo real
- `dmesg` — mensajes del kernel (útil tras un reboot inesperado)

## Enlaces externos

- [Man page — uptime](https://man7.org/linux/man-pages/man1/uptime.1.html)
- [Wikipedia — Load (computing)](https://en.wikipedia.org/wiki/Load_(computing))

#comando #sistema
