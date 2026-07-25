---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: comando
prioridad: alta
---

# free

## Sintaxis

```bash
free [opciones]
```

## Descripción

Muestra la cantidad de **memoria RAM y swap** libre y usada en el sistema. Es la herramienta de diagnóstico básica para saber si la falta de memoria está causando lentitud, swapping excesivo, o Out-Of-Memory (OOM).

Viene en el paquete `procps-ng` / `procps` — disponible en toda distro sin instalación adicional.

## Opciones frecuentes

| Flag | Efecto |
|---|---|
| `-h` | Mostrar en formato legible (GiB, MiB) |
| `-w` | Ancho de columnas (muestra "buff/cache" separado) |
| `-t` | Mostrar total de RAM + swap |
| `-s <N>` | Actualizar cada N segundos (monitoreo) |
| `-c <N>` | Número de iteraciones (con -s) |
| `--si` | Usar prefijos SI (1000 en vez de 1024) |

## Formato de salida

```bash
$ free -h
               total        used        free      shared  buff/cache   available
Mem:            15 Gi       3.2 Gi       8.1 Gi       1.2 Gi       4.1 Gi        11 Gi
Swap:          2.0 Gi       0.0 Gi       2.0 Gi
```

| Columna | Significado |
|---|---|
| `total` | Cantidad total de memoria instalada |
| `used` | Memoria en uso (total - free - buff/cache) |
| `free` | Memoria completamente sin usar |
| `shared` | Memoria compartida entre procesos (tmpfs) |
| `buff/cache` | Memoria usada por buffers del kernel y caché de disco |
| `available` | Memoria disponible para nuevas aplicaciones (free + parte de caché que se puede liberar) |

> **Importante**: `available` es la métrica real a mirar, no `free`. Linux usa memoria libre como caché de disco, lo que hace que `free` sea baja incluso cuando hay mucha memoria disponible. Si `available` es baja (<10% de `total`), el sistema necesita más RAM o estás haciendo swap.

## Ejemplos

```bash
free -h                                      # lo más común: formato legible, todo el sistema
free -hw                                     # separar buff/cache en columna propia
free -ht -s 5                                # monitoreo cada 5 segundos con total
free -ht -s 2 -c 5                           # 5 muestras cada 2 segundos
watch -n 2 free -h                           # monitoreo continuo con watch
```

## Casos de uso reales

### ¿Mi sistema necesita más RAM?

```bash
free -h
# Si available = 0.5 GiB de 16 GiB total → el sistema está al límite
# Si available > 20% del total → no hay problema
# Si swap used > 0 (especialmente si usas SSD, no HDD) → estás usando swap, señal de poca RAM
```

### Capturar uso de memoria en un script

```bash
# Guardar en log para análisis posterior
free -h >> /var/log/mem-usage.log

# Extraer solo el porcentaje usado
free | grep Mem | awk '{print $3/$2 * 100.0 "%"}'
```

### Monitorear fuga de memoria en una aplicación

```bash
# Ejecutar free cada 30 segundos y ver si available baja progresivamente
free -h -s 30 | ts '%Y-%m-%d %H:%M:%S'
```

## Troubleshooting / Errores comunes

| Síntoma | Causa | Solución |
|---|---|---|
| `available` < 1 GiB constantemente | Poca RAM física | Cerrar aplicaciones, añadir swap, o ampliar RAM |
| `swap used` alto (> 1 GiB) | RAM insuficiente, el kernel está moviendo páginas a swap | `sudo swapoff -a && sudo swapon -a` para reiniciar swap (liberará RAM si hay suficiente) |
| `buff/cache` muy alto (> 80% de RAM) | Linux usa RAM libre como caché — normal | `sudo sync && echo 3 > /proc/sys/vm/drop_caches` (solo para diagnóstico) |
| free muestra 0 swap aunque tengas swap configurado | Swap no activado o partición swap no montada | Verificar con `swapon --show`, activar con `sudo swapon -a` |
| Memoria compartida muy alta | Aplicaciones como Chromium o contenedores Docker | Normal en sistemas con muchas pestañas/containers |

## Notas y advertencias

- **No te fíes del campo `free`**: Linux usa la memoria libre para caché de disco, por lo que `free` siempre será baja en sistemas que llevan tiempo encendidos. Mira siempre `available`.
- `available` es una estimación del kernel, no un valor exacto, pero es mucho más fiable que `free`.
- `buffers` son metadatos del sistema de archivos (inodos, superblocks); `cache` son datos de archivos leídos recientemente (páginas de memoria).
- Un sistema con 32 GiB de RAM puede mostrar `free: 500 MiB, buff/cache: 28 GiB` y estar perfectamente sano — la caché se libera automáticamente cuando una aplicación necesita memoria.
- Para ver memoria usada por procesos individuales, usar `top` o `ps aux --sort=-%mem`.

## Enlaces externos

- [Wikipedia — free](https://en.wikipedia.org/wiki/Free_(Unix))
- [Arch Wiki — free](https://man.archlinux.org/man/free.1)
- [Linux man page online](https://man7.org/linux/man-pages/man1/free.1.html)

## Ver también

- [[top]] — monitorización de procesos en tiempo real
- [[ps]] — instantánea de procesos
- [[df y du]] — espacio en disco
- [[Procesos y Senales]] — gestión de procesos y memoria
- [[Cheat Sheet - Comandos Esenciales]]

#comando
