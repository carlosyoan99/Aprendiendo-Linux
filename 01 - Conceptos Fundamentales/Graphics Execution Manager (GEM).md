---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: baja
---

# Graphics Execution Manager (GEM)

> Sistema de gestión de memoria para GPUs en el kernel Linux. Desarrollado por Intel en 2008 como alternativa minimalista a TTM (Translation Table Maps). Incluido desde Linux 2.6.28.

## Definición

GEM es una unidad de manejo de memoria especializada para controladores gráficos. Gestiona la memoria de video, controla contextos de ejecución y administra el acceso NUMA en GPUs modernas. Múltiples procesos pueden compartir recursos gráficos sin conflictos.

## Historia

| Año | Evento |
|---|---|
| 2008-05 | Anuncio por Keith Packard (Intel) en LWN |
| 2008-12 | Incluido en Linux 2.6.28 |
| 2009+ | Adoptado por drivers Intel, AMD (radeon) y Nouveau |

## GEM vs TTM

GEM fue creado como alternativa minimalista a **TTM (Translation Table Maps)**, desarrollado por Tungsten Graphics. La filosofía de GEM era aprovechar subsistemas existentes del kernel en lugar de reinventarlos, resultando en un código mucho más pequeño y simple.

| Aspecto | GEM | TTM |
|---|---|---|
| **Autor** | Intel (Keith Packard) | Tungsten Graphics |
| **Filosofía** | Minimalista, reusa subsistemas del kernel | Completo, auto-gestionado |
| **Tamaño de código** | Pequeño (pocos cientos de líneas) | Grande |
| **Drivers que lo usan** | Intel, radeon (antiguo), Nouveau | amdgpu (moderno) |
| **Soporte BSD** | Sí (compatible con kernels BSD) | No |

> GEM ganó la partida en la mayoría de drivers por su simplicidad, pero TTM sigue siendo necesario para GPUs AMD modernas (amdgpu) por su gestión más sofisticada de memoria VRAM.

## API y funcionamiento

GEM expone una API de bajo nivel a los drivers gráficos:

| Operación | Función |
|---|---|
| Crear buffer | `gem_create` |
| Mapear a espacio de usuario | `gem_mmap` |
| Registrar en GPU | `gem_set_domain` |
| Sincronizar acceso | `gem_wait` / `gem_busy` |
| Cerrar buffer | `gem_close` |

El diseño de GEM asume que múltiples procesos (Xorg, Wayland compositor, aplicaciones) pueden compartir buffers gráficos sin conflictos, gestionando la sincronización de memoria a nivel de kernel.

### Integración con otros subsistemas

GEM se apoya en:
- **DRM (Direct Rendering Manager)** — gestión de acceso a la GPU
- **DMA-BUF** — compartición de buffers entre dispositivos
- **NUMA** — gestión de memoria no-uniforme en GPUs

### Compatibilidad con BSD

GEM fue diseñado para ser portable a kernels BSD, no solo Linux. Esto contrasta con TTM, que está más atado a la arquitectura del kernel Linux.

## Enlaces externos

- [Wikipedia — Direct Rendering Manager (sección GEM)](https://en.wikipedia.org/wiki/Direct_Rendering_Manager#Graphics_Execution_Manager)
- [libdrm (interfaz de usuario para GEM/DRM) — GitHub](https://github.com/mesa3d/drm)
- [Anuncio original de GEM por Keith Packard (LWN)](https://lwn.net/Articles/277973/)

## Ver también

- [[Nouveau (controlador)]] — driver NVIDIA libre que usa GEM
- [[Video4Linux (V4L2)]] — API de video del kernel
- [[Procesos y Senales]] — gestión de procesos en Linux

#concepto #graficos #kernel
