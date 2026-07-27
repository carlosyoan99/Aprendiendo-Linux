---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# kill

## Sintaxis
```
kill [opciones] <PID> [PID...]
kill -l
pkill [opciones] <nombre>
killall [opciones] <nombre>
```

## Descripción
Envía una **señal** a un proceso identificado por su PID. Por defecto envía `SIGTERM` (15), que pide al proceso que termine limpiamente. No solo sirve para "matar" procesos — también para recargar configuraciones, pausar procesos o consultar su estado.

Viene en el paquete `util-linux` / `procps-ng` — disponible en toda distro.

## Opciones frecuentes
| Flag / Señal | Efecto | Ejemplo |
|---|---|---|
| `-l` | Lista todas las señales disponibles | `kill -l` |
| `-s <señal>` | Enviar una señal específica por nombre | `kill -s HUP 1234` |
| `-<número>` | Especificar señal por número | `kill -9 1234` (SIGKILL) |
| `-L` | Lista ampliada de señales con valores (Linux) | `kill -L` |
| `-0` | Comprobar si el proceso existe (sin matar) | `kill -0 1234 && echo "vivo"` |

## Señales comunes

| Señal | # | Uso típico | ¿Se puede ignorar? |
|---|---|---|---|
| SIGTERM | 15 | **Terminación normal** — pide al proceso cerrar limpio (default de `kill`) | ✅ Sí (el proceso puede ignorarla) |
| SIGKILL | 9 | **Forzar terminación** — el proceso no puede ignorarlo ni hacer limpieza | ❌ No |
| SIGHUP | 1 | **Recargar configuración** — muchos servicios (nginx, sshd) lo interpretan como reload | ✅ Depende del proceso |
| SIGINT | 2 | **Interrupción** — equivalente a Ctrl+C | ✅ Sí |
| SIGQUIT | 3 | **Terminar con core dump** — equivalente a Ctrl+\ | ✅ Sí |
| SIGSTOP | 19 | **Pausar** el proceso (congelarlo, no terminarlo) | ❌ No |
| SIGCONT | 18 | **Reanudar** un proceso pausado | ❌ No (es la señal que reanuda) |
| SIGTSTP | 20 | **Pausar desde terminal** — equivalente a Ctrl+Z | ✅ Sí |

```bash
kill -l                                  # listar todas las señales (numeradas)
kill -L                                  # listado ampliado con valores
```

## Ejemplos
## Ejemplos de uso

```bash
# Caso 1: SIGTERM — pedir cierre limpio
kill 1234

# Caso 2: explícitamente SIGTERM
kill -15 1234

# Caso 3: SIGKILL — matar de inmediato (último recurso)
kill -9 1234

# Caso 4: SIGHUP — recargar configuración (nginx, sshd)
kill -1 nginx

# Caso 5: SIGSTOP — pausar proceso
kill -19 1234

# Caso 6: SIGCONT — reanudar proceso pausado
kill -18 1234

# Caso 7: matar múltiples procesos
kill 1234 5678 9012

# Caso 8: matar por nombre usando pgrep
kill -9 $(pgrep nombre-proceso)

# Caso 9: atajo: matar por nombre (sin buscar PID)
pkill nombre-proceso

# Caso 10: matar por patrón en la línea completa
pkill -f "python script.py"

# Caso 11: matar firefox solo del usuario carlos
pkill -u carlos firefox

# Caso 12: mata todos los procesos llamados nginx (cuidado en Solaris)
killall nginx
```

## Casos de uso reales

### Matar un proceso que no responde

```bash
# 1. Identificar el PID del proceso
ps aux | grep firefox
pgrep firefox

# 2. Probar cierre limpio primero
kill 1234
# Esperar unos segundos. Si no se cierra...

# 3. Escalar a señales más agresivas
kill -15 1234                            # explícitamente SIGTERM
kill -2 1234                             # SIGINT (como Ctrl+C)
kill -3 1234                             # SIGQUIT (genera core dump para debug)
kill -9 1234                             # SIGKILL — último recurso
```

### Recargar un servicio sin detenerlo

```bash
# En lugar de reiniciar, usar SIGHUP para recargar configuración
sudo kill -1 $(cat /var/run/nginx.pid)    # recargar nginx

# Más fácil con systemd:
sudo systemctl reload nginx               # equivalente a kill -HUP
sudo systemctl reload sshd
```

### Pausar y reanudar procesos

```bash
# Pausar un proceso que consume mucha CPU
kill -STOP 1234                           # congelar
# En este momento el proceso no consume CPU ni progresa

# Reanudar más tarde
kill -CONT 1234                           # descongelar
# Útil para liberar CPU temporalmente sin perder el estado del proceso
```

## Combinaciones comunes con pipe

```bash
# Matar todos los procesos de un usuario
ps -u carlos -o pid= | xargs kill

# Matar procesos por nombre (más seguro con pgrep)
kill $(pgrep -u carlos chrome)           # matar chrome del usuario carlos

# Matar procesos que llevan más de X horas
ps -eo pid,etime,cmd --sort=etime | grep "firefox" | awk '{if ($2 ~ /-/) print $1}' | xargs kill

# Buscar y matar procesos zombie
ps aux | awk '$8 ~ /Z/ {print $2}' | xargs kill -9 2>/dev/null

# Matar solo los N procesos que más memoria usan
ps aux --sort=-%mem | head -4 | tail -3 | awk '{print $2}' | xargs kill
```

## Alternativas modernas

| Comando | Ventaja |
|---|---|
| **pkill** | Matar por nombre directamente, sin buscar PID primero |
| **pgrep** | Buscar PID por nombre (útil en scripts) |
| **killall** | Matar todos los procesos con un nombre (cuidado: en Solaris mata todo el sistema) |
| **systemctl** | `systemctl stop/reload/restart` para servicios gestionados por systemd |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `Operation not permitted` | No tienes permiso para señalar ese proceso (no es tuyo o es de root) | Usar `sudo kill` |
| `No such process` | El proceso ya terminó o el PID es incorrecto | Verificar con `ps -p <PID>` |
| `kill: usage: kill [-s sigspec | -n signum | -sigspec] pid` | El PID no es un número válido | Verificar con `pgrep` que el PID sea correcto |
| SIGKILL no funciona | El proceso está en estado D (uninterruptible sleep) — esperando I/O | Esperar a que el kernel complete la operación o reiniciar |
| `pkill` mata más procesos de los esperados | `pkill` coincide con el nombre parcial del proceso | Usar `pkill -x nombre` para coincidencia exacta, o `-f` solo si necesitas patrón completo |

## Notas y advertencias
- **Siempre probar SIGTERM (15) primero**. Un proceso bien escrito guarda datos y cierra conexiones al recibir SIGTERM.
- SIGKILL (`-9`) es el último recurso: el proceso no puede limpiar nada (archivos temporales, conexiones de red, sockets). Puede dejar datos corruptos.
- `killall` en sistemas Linux mata por nombre exacto. En Solaris/Unix, `killall` sin argumentos mata **todos los procesos** del sistema.
- Para recargar servicios de sistema con systemd es mejor usar `systemctl reload <servicio>`.
- `kill -0 <PID>` no mata el proceso — solo verifica si existe y si tienes permiso para señalar. Útil en scripts: `if kill -0 $PID 2>/dev/null; then echo "El proceso sigue vivo"; fi`.

## Enlaces externos

- [Wikipedia — kill (command)](https://en.wikipedia.org/wiki/Kill_(command))
- [Wikipedia — Signal (IPC)](https://en.wikipedia.org/wiki/Signal_(IPC))
- [Linux man page — signal(7)](https://man.archlinux.org/man/signal.7)

## Ver también
- [[ps]] — encontrar PIDs
- [[top]] — monitorización en tiempo real
- [[Procesos y Senales]] — señalización y gestión de procesos
- [[systemd]] — systemctl para servicios gestionados
- [[bash-avanzado]] — kill -0 en scripts
- [[Cheat Sheet - Comandos Esenciales]]

#comando
