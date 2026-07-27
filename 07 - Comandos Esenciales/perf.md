---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: baja
---

# perf — Rendimiento y profiling del sistema

## Definición

`perf` es el **profiler de rendimiento nativo de Linux**, basado en contadores de rendimiento de la CPU y eventos del kernel (PMU — Performance Monitoring Unit). Permite analizar dónde gasta tiempo un programa, detectar cuellos de botella, y generar reportes detallados.

```
perf data flow:

  ┌────────────┐    ┌──────────┐    ┌────────────┐
  │  CPU PMU   │───►│  perf    │───►│  perf.data │
  │ contadores │    │  record  │    │  (muestras)│
  └────────────┘    └──────────┘    └──────┬─────┘
                                           │
                              ┌────────────┴────────────┐
                              │                         │
                         ┌──────────┐            ┌──────────┐
                         │ perf.report│           │perf.script│
                         │  (call.   │           │ (eventos  │
                         │   graph)  │           │  raw)     │
                         └──────────┘            └──────────┘
```

> Herramientas complementarias: [[htop btop]] para monitorización general, [[strace]] para syscalls.

---

## Instalación

```bash
# Debian/Ubuntu
sudo apt install linux-tools-common linux-tools-generic
# Verificar versión de kernel:
sudo apt install linux-tools-$(uname -r)

# Arch
sudo pacman -S perf

# Fedora/RHEL
sudo dnf install perf

# Verificar instalación
perf --version
```

Si `perf` reporta que no hay eventos disponibles, puede ser necesario:
```bash
# Deshabilitar protección de paranoid (temporal)
sudo sysctl -w kernel.perf_event_paranoid=1
# 0 = permite contar eventos
# 1 = permite contar y muestrear (default en algunas distros)
# 2 = solo conteo de eventos (sin muestreo de callchains)

# Habilitar acceso de usuario
sudo sysctl -w kernel.kptr_restrict=0  # permite ver símbolos del kernel
```

---

## Subcomandos principales

| Comando | Propósito | Ejemplo |
|---|---|---|
| `perf list` | Listar eventos disponibles | `perf list \| grep cache` |
| `perf stat` | Estadísticas de contadores | `perf stat ./app` |
| `perf record` | Capturar muestras | `perf record -g ./app` |
| `perf report` | Analizar muestras recolectadas | `perf report` |
| `perf top` | Monitor en tiempo real | `perf top -p PID` |
| `perf annotate` | Mostrar código fuente/asm por función | `perf annotate funcion` |
| `perf script` | Volcar eventos raw | `perf script` |
| `perf trace` | Traza de syscalls (similar a strace) | `perf trace ./app` |

---

## perf stat — Estadísticas rápidas

Mide contadores de rendimiento de la CPU durante la ejecución de un programa.

```bash
# Estadísticas básicas
perf stat ./app

# Salida típica:
#  42,531.67 msec task-clock                #    1.000 CPUs utilized
#         3,456 context-switches             #    0.081 K/sec
#           123 cpu-migrations               #    0.003 K/sec
#        45,678 page-faults                  #    1.074 K/sec
#   150,234,567,890 cycles                   #    3.533 GHz
#    98,765,432,101 instructions              #    0.66  insn per cycle
#    12,345,678,901 branches                  #  290.153 M/sec
#       234,567 branch-misses                 #    1.90% of all branches

# Estadísticas detalladas de caché
perf stat -e cache-references,cache-misses,cycles,instructions ./app

# Estadísticas de TLB (page table lookups)
perf stat -e dTLB-load-misses,iTLB-load-misses ./app

# Múltiples ejecuciones
perf stat -r 5 ./app                        # ejecutar 5 veces y promediar
```

### Interpretación básica

| Métrica | Valor bueno | Valor malo | Qué indica |
|---|---|---|---|
| **instructions per cycle (IPC)** | > 1.0 | < 0.5 | Bajo IPC = cuellos de botella (memoria, branches, dependencias) |
| **branch-misses** | < 2% | > 5% | Predicción de saltos ineficiente (código con muchos condicionales impredecibles) |
| **cache-misses** | < 5% | > 20% | Mal uso de localidad de datos (reestructurar acceso a memoria) |
| **context-switches** | < 1000/s | > 10000/s | Demasiados procesos compitiendo por CPU |
| **page-faults** | < 100/s | > 1000/s | Uso de memoria ineficiente o swapping |

---

## perf record + perf report — Profiling detallado

Captura muestras del contador de programa (PC) a intervalos regulares.

```bash
# Capturar muestras (Ctrl+C para detener)
perf record ./app
perf record -g ./app                    # -g: capturar callchains (stack de llamadas)
perf record --call-graph dwarf ./app   # mejor resolución de callchains

# Capturar por tiempo
perf record -g -- sleep 30             # muestrear durante 30 segundos

# Capturar un proceso existente
perf record -g -p $(pgrep nginx)       # adjuntarse a proceso en ejecución
perf record -g -p 1234 -- sleep 10     # muestrear PID 1234 por 10 segundos

# Capturar eventos específicos
perf record -e cache-misses -g ./app
perf record -e LLC-load-misses -g ./app   # Last Level Cache misses
perf record -e branch-misses -g ./app

# Frecuencia de muestreo
perf record -F 99 -g ./app             # 99 muestras/segundo (evita Hz exactos)
perf record -F 1000 -g ./app           # 1000 muestras/segundo (precisión fina)
```

### Perf report — Análisis interactivo

```bash
# Ver reporte (interactivo)
perf report

# Órdenes dentro de perf report:
# Enter → expandir función para ver sus callers/callees
# a     → anotar código fuente/asm de la función seleccionada
# + / - → expandir/colapsar callchain
# q     → salir

# Reporte sin interfaz interactiva
perf report --stdio                     # volcar a terminal
perf report --stdio -i perf.data        # sobre archivo específico

# Ordenar por overhead
perf report -s overhead                 # por defecto

# Mostrar porcentaje relativo
perf report --percentage relative       # dentro de cada función
```

### Ejemplo de salida

```
Samples: 12K of event 'cycles', 4000 Hz
Event count (approx.): 8,500,000,000
Overhead  Command  Shared Object       Symbol
  12.50%  app      libc-2.35.so        [.] __memmove_avx_unaligned_erms
   8.33%  app      app                 [.] compress_block
   5.20%  app      libz.so.1           [.] deflate
   4.17%  app      app                 [.] proceso_datos
   3.12%  app      [kernel]            [k] do_sys_openat2
```

### Anotación de código (perf annotate)

```bash
# Anotar una función (muestra el código fuente con % de tiempo por línea)
perf annotate funcion_costosa
perf annotate --stdio funcion_costosa   # volcar a terminal

# La salida muestra qué líneas consumen más tiempo:
# Percent | Source code
# 0.00    | void funcion_costosa(char *buf, size_t sz) {
# 0.00    |     for (size_t i = 0; i < sz; i++) {
# 45.23   |         buf[i] = toupper(buf[i]);     ← 45% del tiempo aquí
# 0.00    |     }
# 0.00    | }
```

---

## perf top — Monitor en tiempo real

Similar a `top`/`htop` pero para funciones/hotspots del sistema.

```bash
# Top de funciones que más CPU consumen (todo el sistema)
sudo perf top

# Un proceso específico
sudo perf top -p $(pgrep firefox)

# Evento específico
sudo perf top -e cache-misses

# Con callchains
sudo perf top -g

# Salida interactiva (Enter para expandir, a para anotar, q para salir)
```

---

## perf stat — Comparación antes/después de optimizar

```bash
# Antes de optimizar
perf stat -r 5 ./app 2>&1 | grep "instructions per cycle"

# Hacer cambios en el código...

# Después de optimizar
perf stat -r 5 ./app 2>&1 | grep "instructions per cycle"

# Si el IPC subió, la optimización funcionó
```

---

## Flamegraphs — Visualización de callchains

Los **flamegraphs** son una representación visual de las callchains. Muestran qué funciones consumen más tiempo (ancho de la barra = tiempo).

```bash
# 1. Capturar muestras con callchains
perf record -F 99 -g ./app -- sleep 30

# 2. Generar archivo de script para flamegraph
perf script -i perf.data > out.perf

# 3. Descargar e instalar FlameGraph tools
git clone https://github.com/brendangregg/FlameGraph
cd FlameGraph

# 4. Generar SVG interactivo
./stackcollapse-perf.pl ../out.perf > out.folded
./flamegraph.pl out.folded > flamegraph.svg

# 5. Abrir en navegador
firefox flamegraph.svg
```

```
Interpretación de un flamegraph:

  ┌──────────────────────────────────────────────┐
  │ main (99%) ─── barra más ancha = más tiempo  │
  │ ├── process_data ── ancho = 60% de main     │
  │ │   ├── compress (40%)                       │
  │ │   │   └── deflate (38%)                    │
  │ │   └── write_output (20%)                   │
  │ └── init (10%)                               │
  └──────────────────────────────────────────────┘
  Cada rectángulo es una función en la pila.
  El ancho indica proporción de tiempo.
  "Montañas" altas y estrechas = código que se ejecuta en caminos profundos.
  "Mesetas" anchas = funciones que consumen mucho tiempo directo.
```

### Alternativa: hotspot (GUI)

```bash
# Instalar hotspot (GUI para perf.data)
sudo apt install hotspot                 # Debian/Ubuntu
# Abrir perf.data con interfaz gráfica
hotspot
```

---

## perf trace — Traza de syscalls

Alternativa moderna a `strace` con menor overhead:

```bash
# Trazar syscalls (como strace)
perf trace ./app

# Trazar solo ciertas syscalls
perf trace -e open,openat,read ./app

# Trazar un proceso existente
perf trace -p 1234

# Con timestamps
perf trace -T ./app
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `perf: command not found` | perf no instalado | Instalar `linux-tools-$(uname -r)` |
| `No permission to collect perf events` | `perf_event_paranoid` muy alto | `sudo sysctl -w kernel.perf_event_paranoid=1` |
| `Kernel address maps (/proc/{kallsyms,modules}) restricted` | `kptr_restrict` = 2 | `sudo sysctl -w kernel.kptr_restrict=0` |
| `perf record` no captura eventos | Frecuencia muy baja o evento incorrecto | Usar `-F 99` o evento `cycles` |
| `perf report` muestra `[unknown]` | Símbolos no disponibles | Compilar con `-g` (DWARF) o instalar `debuginfo` |
| Símbolos del kernel `[k]` no se ven | Falta `perf_event_paranoid` o privilegios | Ejecutar como root o bajar paranoid |

### Conseguir símbolos de depuración

```bash
# Para que perf muestre nombres de funciones (no direcciones hex):
# Debian/Ubuntu
sudo apt install libc6-dbg              # glibc debug symbols
sudo apt install linux-image-$(uname -r)-dbg  # kernel debug symbols

# Arch
sudo pacman -S debuginfod               # habilitar server de debug symbols
```

## Ver también

- [[htop btop]] — monitorización general del sistema
- [[Procesos y Senales]] — nice/renice para priorizar procesos
- [[Desarrollo en Linux (gcc make gdb strace)]] — strace para syscalls, gprof para profiling
- [[cgroups (control de recursos)]] — limitar recursos por grupo de procesos
- [[Monitorización (Prometheus node_exporter)]] — métricas para servidores
- [[Coreutils y util-linux]] — herramientas base del sistema

## Enlaces externos

- [Wikipedia - perf](https://en.wikipedia.org/wiki/Perf_(Linux))
- [Sitio oficial - perf wiki](https://perf.wiki.kernel.org/)
- [Linux man page - perf](https://man7.org/linux/man-pages/man1/perf.1.html)

#comando #rendimiento #kernel
