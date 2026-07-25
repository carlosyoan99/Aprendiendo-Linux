---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: comando
prioridad: alta
---

# top

## Sintaxis
```
top [opciones]
```

## Descripción
Monitor interactivo de procesos en tiempo real. Muestra una lista de procesos que se actualiza cada pocos segundos, ordenada por defecto por uso de CPU. Esencial para diagnosticar qué está consumiendo recursos del sistema.

Viene en el paquete `procps-ng` — disponible en toda distro.

## Formato de salida (cabecera)

| Línea | Significado |
|---|---|
| `top - 14:23:01` | Hora actual |
| `up 3 days, 2:15` | Tiempo desde el arranque (uptime) |
| `1 user` | Usuarios logueados |
| `load average: 0.5, 0.3, 0.2` | Carga promedio (1, 5, 15 min) — < núcleos = buena |
| `Tasks: 120 total` | Procesos totales: running, sleeping, stopped, zombie |
| `%Cpu(s): 5.0 us` | CPU: us (usuario), sy (sistema), ni (nice), id (idle), wa (I/O wait), hi (hardware IRQ), si (software IRQ), st (steal) |
| `MiB Mem: 15874 total` | Memoria RAM: total, free, used, buff/cache |
| `MiB Swap: 2048 total` | Swap: total, free, used. avail Mem (mem disponible) |

## Opciones frecuentes
| Flag | Efecto | Ejemplo |
|---|---|---|
| `-u <user>` | Muestra solo procesos de un usuario | `top -u carlos` |
| `-p <PID>` | Monitorea solo los PIDs especificados | `top -p 1234,5678` |
| `-n <N>` | Actualiza N veces y luego sale | `top -n 5` |
| `-b` | Modo batch — útil para scripts o logs | `top -b -n 1` |
| `-H` | Mostrar hilos individuales (threads) | `top -H -p 1234` |
| `-E <k/m/g>` | Unidad de memoria en cabecera (KB/MB/GB) | `top -E m` |
| `-w <N>` | Ancho de salida en columnas | `top -w 200` |
| `-d <N>` | Intervalo de actualización en segundos | `top -d 2` |
| `-o <campo>` | Columna de ordenación inicial | `top -o %MEM` |

## Comandos interactivos (una vez dentro de top)

| Tecla | Acción |
|---|---|
| `q` | Salir |
| `k` | Matar un proceso (pide PID y señal) |
| `u` | Filtrar por nombre de usuario |
| `1` | Ver uso individual de cada núcleo CPU |
| `M` | Ordenar por uso de memoria (%MEM) |
| `P` | Ordenar por uso de CPU (%CPU) (vuelta al default) |
| `T` | Ordenar por tiempo acumulado de CPU (TIME+) |
| `c` | Alternar entre comando corto y ruta completa |
| `e` | Cambiar unidad de memoria (KB/MB/GB) |
| `W` | Guardar configuración actual para futuras sesiones |
| `x` | Resaltar columna de ordenación |
| `y` | Resaltar procesos en ejecución |
| `V` | Vista de árbol (forest view) |
| `r` | Renice (cambiar prioridad de un proceso) |
| `?` | Ayuda completa de atajos |

## Ejemplos de uso

```bash
# Caso 1: monitor interactivo por defecto
top

# Caso 2: solo procesos de un usuario específico
top -u carlos

# Caso 3: monitorear PIDs específicos
top -p 1234,5678

# Caso 4: una sola captura batch (para scripts)
top -b -n 1

# Caso 5: 5 capturas batch del usuario www-data
top -b -n 5 -u www-data

# Caso 6: ver hilos de un proceso específico
top -H -p 1234
```

## Casos de uso reales

### Diagnóstico: ¿qué está consumiendo la CPU?

```bash
top -b -n 1 | head -20                # ver los procesos que más CPU consumen
# Si un proceso consume >90% CPU constantemente → puede ser un bucle infinito
# Si el load average es alto pero %CPU bajo → cuello de botella en I/O (disco)
```

### Capturar uso para análisis posterior

```bash
top -b -n 60 -d 2 > /tmp/cpu-log.txt   # 60 capturas cada 2 segundos (2 min)
# Útil para diagnosticar picos intermitentes
```

### Verificar que un servicio responde correctamente

```bash
top -b -n 3 -p $(pgrep -d',' nginx)   # monitorear solo procesos nginx
```

## Combinaciones comunes con pipe

```bash
# Captura batch formateada para scripting
top -b -n 1 | grep "Cpu(s)" | awk '{print $2 + $4}'  # % CPU usado actual

# Extraer el proceso que más memoria consume
top -b -n 1 | tail -n +8 | sort -k10 -rn | head -1

# Loggear uso de CPU cada minuto
while true; do top -b -n 1 | grep "Cpu(s)" >> cpu.log; sleep 60; done
```

## Alternativas modernas

| Herramienta | Ventaja |
|---|---|
| **htop** | Colores, navegación con flechas, kill con F9, árbol de procesos |
| **btop** | Más moderno, gráficos, mouse support, menús |
| **systemd-cgtop** | Muestra consumo agrupado por servicio systemd (cgroups) |
| **bpytop** | Versión Python de btop (obsoleta, reemplazada por btop) |

```bash
sudo apt install htop btop             # Debian/Ubuntu
sudo pacman -S htop btop               # Arch
```

## Troubleshooting / Errores comunes

| Síntoma | Causa | Solución |
|---|---|---|
| `wa` (I/O wait) alto > 30% | Disco lento o saturado | `iotop` para ver qué proceso escribe/lee, `df -h` para ver espacio |
| `st` (steal) alto en VM | Hipervisor asignando CPU a otras VMs | Contactar proveedor cloud, migrar a instancia dedicada |
| `load average` alto pero CPU libre | Muchos procesos en I/O wait | El disco es el cuello de botella, no la CPU |
| `zombie` count > 0 | Procesos hijo no recolectados por el padre | Identificar padre con `ps -o pid,ppid,stat,cmd`, reiniciar proceso padre |

## Notas y advertencias
- `top` está en toda distro por defecto. `htop` y `btop` hay que instalarlos aparte.
- El **load average** es engañoso: en un CPU de 4 núcleos, load 4.0 significa "cada núcleo está al 100%". No es equivalente a % de uso.
- Si ves `wa` (I/O wait) alto, el cuello de botella es el disco, no la CPU.
- `htop` permite desplazarse horizontalmente para ver la línea completa del comando, y matar procesos con F9 sin recordar señales.
- Para scripting, `-b` (batch) y `-n 1` (una iteración) son esenciales.

## Enlaces externos

- [Wikipedia — top (Unix)](https://en.wikipedia.org/wiki/Top_(Unix))
- [procps-ng — top manual](https://man.archlinux.org/man/top.1)

## Ver también
- [[ps]] — instantánea de procesos
- [[kill]] — enviar señales a procesos
- [[free]] — memoria RAM y swap
- [[Procesos y Senales]] — estados de procesos y señales
- [[htop btop]] — alternativas modernas
- [[systemd]] — systemd-cgtop para monitoreo por servicio
- [[Cheat Sheet - Comandos Esenciales]]

#comando
