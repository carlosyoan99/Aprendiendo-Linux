---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# nvtop

> Monitor de GPU en tiempo real para NVIDIA, AMD e Intel. Muestra uso de GPU, memoria, procesos y temperaturas con interfaz TUI.

## Sintaxis

```bash
nvtop [opciones]
```

## Descripción

`nvtop` es el `top` de las GPU: monitorea uso de procesadores gráficos, memoria VRAM, temperatura, procesos y más. Soporta NVIDIA (nvidia-smi), AMD (amdgpu) e Intel (i915). Es esencial para machine learning, gaming y rendering.

## Opciones

| Opción | Descripción |
|---|---|
| `-d <segundos>` | Intervalo de refresco |
| `-s <orden>` | Ordenar por: `gpu`, `mem`, `util`, `temp` |
| `-c <n>` | Número de GPU a monitorear (0-based) |
| `-C` | Mostrar solo GPU con procesos |
| `-p` | Modo compacto |
| `-t` | Sin colores |

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `f` | Filtro de procesos |
| `s` | Cambiar orden |
| `e` | Matar proceso GPU |
| `1/2/3/4/5` | Cambiar vista |
| `q` | Salir |

## Ejemplos

```bash
nvtop                                 # monitorear todas las GPU
nvtop -d 1                            # refresco cada 1s
nvtop -s util                         # ordenar por uso
nvtop -c 0                            # solo GPU 0
nvtop -C                              # solo GPU con procesos activos
```

## Formato de salida

```
GPU 0: NVIDIA GeForce RTX 3080 (PCI 0000:01:00.0)
GPU   78%   45°C   245W   10240/10240 MB
PID   USER   GPU   MEM   Command
1234  carlos  45%   2GB   python train.py
5678  carlos  33%   1GB   jupyter-notebook
```

## Casos de uso

### Monitorear entrenamiento ML
```bash
nvtop -d 2
# Verificar que la GPU está al 100% y la memoria no se llena
```

### Detectar procesos GPU
```bash
nvtop -C
# Ver solo las GPU con procesos activos
```

### Investigar GPU lenta
```bash
nvtop -s temp
# Ver si la GPU está thermal throttling
```

## Alternativas

| Herramienta | Plataforma |
|---|---|
| **nvidia-smi** | Solo NVIDIA, CLI |
| **rocm-smi** | Solo AMD, CLI |
| **intel_gpu_top** | Solo Intel |
| **btop** | CPU/RAM/Disk/GPU integrado |

## Ver también

- [[htop btop]] — monitor de CPU/RAM (btop incluye GPU)
- [[NVIDIA no detecta]] — troubleshooting GPU
- [[Optimización de rendimiento]] — kernel tuning, GPU
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]] — detectar GPU

## Enlaces externos

- [GitHub — nvtop](https://github.com/Syllo/nvtop)
- [Arch Wiki — nvtop](https://wiki.archlinux.org/title/nvtop)
- [Wikipedia — nvtop](https://en.wikipedia.org/wiki/Nvtop)

#programa #tui #gpu
