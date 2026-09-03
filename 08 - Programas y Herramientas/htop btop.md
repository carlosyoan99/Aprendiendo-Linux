---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: alta
---

# htop / btop (monitores de sistema)

## Qué son

**htop** y **btop** son visualizadores de procesos interactivos que mejoran al [[top]] clásico. Muestran uso de CPU, memoria, procesos, y permiten matar procesos con teclas/flechas sin recordar comandos.

- **htop**: el estándar de facto. Sencillo, coloreado, funciona en toda distro.
- **btop**: moderno, con gráficos, soporte para GPU, más vistoso, más pesado (escrito en C++).

## Instalación

```bash
# ── htop ──
sudo apt install htop                    # Debian/Ubuntu
sudo pacman -S htop                      # Arch
sudo dnf install htop                    # Fedora

# ── btop ──
sudo apt install btop                    # Debian/Ubuntu
sudo pacman -S btop                      # Arch
sudo dnf install btop                    # Fedora

# ── nvtop (GPU NVIDIA/AMD) ──
sudo apt install nvtop                   # Debian/Ubuntu
sudo pacman -S nvtop                     # Arch
```

## Uso básico

```bash
htop                                     # lanzar monitor interactivo
btop                                     # lanzar btop (interfaz más moderna)
nvtop                                    # monitor de GPU (NVIDIA/AMD)
```

## Atajos de htop

| Tecla | Acción |
|---|---|
| `F10` o `q` | Salir |
| `F5` | Vista de árbol (procesos hijos anidados) |
| `F4` | Filtrar por nombre de proceso |
| `F3` | Buscar |
| `F6` | Ordenar por columna |
| `F9` | Matar proceso (menú con señales) |
| `F2` | Configuración (columnas, colores, opciones) |
| `F1` | Ayuda |
| `u` | Filtrar por usuario específico |
| `p` | Ocultar/mostrar procesos en curso |
| `t` | Vista de árbol (toggle) |
| `H` | Ocultar/mostrar hilos |
| `l` | Mostrar/layers de procesos |
| `s` | strace del proceso seleccionado |
| `Mouse` | Click en columnas para ordenar |

## Atajos de btop

btop tiene un menú en la parte superior que se navega con teclado o mouse:

| Tecla | Acción |
|---|---|
| `q` o `Esc` | Salir |
| `1-4` | Cambiar entre pestañas (CPU, Memoria, Discos, Red) |
| `f` | Filtrar procesos |
| `t` | Vista de árbol |
| `d` | Detalles de un proceso |
| `p` | Pausar/Reanudar |
| `c` | Configuración |
| `?` | Ayuda |
| `Flechas` | Navegar entre procesos |
| `Supr` | Matar proceso (pide confirmación) |

## Modo batch (para scripts)

```bash
# htop: modo batch (una instantánea, útil para logs)
htop -d 10 -t --no-color -C | head -50    # 10 décimas de segundo, sin color

# htop: solo mostrar procesos de un usuario
htop -u www-data

# htop: ordenar por memoria sin interactuar
htop -t --sort-key=PERCENT_MEM

# btop: exportar snapshot
btop --tty_on                             # forzar modo TTY
```

## Personalización de htop

```bash
# Config en: ~/.config/htop/htoprc
# O desde F2 dentro de htop:

# Columnas recomendadas para añadir:
# - PERCENT_CPU, PERCENT_MEM, PID, USER, COMMAND, TIME+

# Ordenar por memoria:
# F6 → PERCENT_MEM

# Colores: F2 → Colors → elegir tema
```

### Columnas útiles de htop

| Columna | Qué muestra |
|---|---|
| `PID` | ID del proceso |
| `USER` | Propietario |
| `PRI` | Prioridad |
| `NI` | Nice value |
| `VIRT` | Memoria virtual |
| `RES` | Memoria residente (física) |
| `S` | Estado (S=sleeping, R=running, Z=zombie) |
| `CPU%` | Uso de CPU |
| `MEM%` | Uso de memoria |
| `TIME+` | Tiempo total de CPU |
| `COMMAND` | Nombre del comando |

## htop vs btop vs top vs glances vs nvtop

| Herramienta | GPU | Gráficos | Consumo RAM | Ideal para |
|---|---|---|---|---|
| **top** | ❌ | Tabla simple | ~5 MB | Diagnóstico rápido en servidores |
| **htop** | ❌ | Colores + barras | ~10 MB | Uso diario en escritorio |
| **btop** | ✅ | Gráficos realtime | ~30 MB | Monitoreo completo con GPU |
| **glances** | ❌ | TUI + web | ~30 MB | Monitoreo remoto vía web |
| **nvtop** | ✅ (NVIDIA/AMD) | Simplificado | ~10 MB | Monitoreo exclusivo de GPU |

## nvtop (monitor de GPU)

nvtop (NVIDIA TOP) monitorea exclusivamente la GPU: temperatura, uso, memoria VRAM y procesos que la utilizan:

```bash
nvtop                                    # lanzar monitor de GPU
# Atajos: q=salir, Flechas=navegar, F9=matar proceso en GPU
```

## Notas y advertencias

- **htop** es el equilibrio perfecto entre funcionalidad y ligereza. Si solo vas a instalar uno, que sea htop.
- **btop** es más vistoso pero también más pesado y tiene más dependencias. Ideal para setups modernos con 8GB+ RAM.
- **nvtop** reemplaza a `nvidia-smi dmon` pero en interactivo. Muestra por proceso el uso de VRAM y Compute.
- Todos tienen modo de monitorización batch pero no reemplazan del todo a `top -b` para scripts.

## Alternativas

| Herramienta | Diferencias |
|---|---|
| **glances** | Monitor todo-en-uno (CPU, RAM, disco, red, procesos) con soporte web. Python |
| **nmon** | Clásico de IBM, muy usado en servidores. Guarda logs para análisis histórico |
| **bashtop** (antiguo btop) | Predecesor de btop, escrito en Bash. Ya no se mantiene |
| **atop** | Snapshots históricos, análisis retroactivo. Ideal para servidores |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| htop no muestra los núcleos/I/O | Permisos o config | Revisar vista de CPU y perms de `/proc`; medir I/O con flags adecuados |
| btop sin gráficas de GPU | Falta driver/lib | Instalar dependencias (rocm-smi, nvidia-smi) para métricas de GPU |
| htop muerto con cgroups | Vista parcial | Ver niño/árbol con F5, o permisos para `/proc` |
| CPU% de procesos erróneo | Recolector | Ajustar `update_delay`/prioridad o preferir `btop` con verbose |

## Ver también

- [[top]] — el monitor clásico del sistema
- [[ps]] — ver procesos desde terminal
- [[kill]] — matar procesos
- [[Procesos y Senales]]
- [[glances]] — monitor con servidor web

## Enlaces externos

- [Wikipedia — Htop](https://en.wikipedia.org/wiki/Htop)
- [Wikipedia — Btop](https://en.wikipedia.org/wiki/Btop)
- [GitHub — htop-dev/htop](https://github.com/htop-dev/htop)
- [GitHub — aristocratos/btop](https://github.com/aristocratos/btop)
- [Arch Wiki — htop](https://wiki.archlinux.org/title/Htop)

#programa
