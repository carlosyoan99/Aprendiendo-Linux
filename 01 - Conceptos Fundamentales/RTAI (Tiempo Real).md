---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: concepto
prioridad: baja
---

# RTAI (Real-Time Application Interface)

> Extensiones de **tiempo real** para el kernel Linux. Permiten ejecutar tareas con plazos estrictos para sistemas de control, robótica, automatización industrial y adquisición de datos.

## Definición

RTAI (y su predecesor **RTLinux**) añaden un micro-núcleo de tiempo real debajo del kernel Linux. Tratan a Linux como una tarea de menor prioridad que se ejecuta cuando no hay tareas de tiempo real activas. Esto proporciona tiempos de respuesta deterministas (microsegundos).

**Diferencia clave con PREEMPT_RT**: RTAI usa un micro-núcleo separado que intercapa al kernel, mientras que PREEMPT_RT parchea directamente el kernel estándar. RTAI ofrece latencias más bajas pero es más difícil de mantener.

## Arquitectura

```
┌─────────────────────────────────┐
│     Tareas de tiempo real       │  (máxima prioridad)
├─────────────────────────────────┤
│  │ Micro-kernel RTAI   │        │  (gestiona interrupciones)
├─────────────────────────────────┤
│      Kernel Linux estándar      │  (mínima prioridad)
├─────────────────────────────────┤
│            Hardware             │
└─────────────────────────────────┘
```

## Componentes

| Componente | Descripción |
|---|---|
| **RTHAL** | Capa de abstracción de hardware para interceptar interrupciones |
| **LXRT** | Módulo para desarrollo de tiempo real en espacio de usuario |
| **IPC** | FIFOs, semáforos, memoria compartida, mailboxes |
| **Planificadores** | UP, SMP, MUP (multi-uniprocessor) |

## Predecesor: RTLinux

RTLinux fue el primer proyecto que implementó esta arquitectura, desarrollado por Victor Yodaiken y Michael Barabanov (FSMLabs). RTAI comenzó como un fork de RTLinux y actualmente usa **ADEOS** como capa de abstracción.

## Alternativas

| Proyecto | Estado | Latencia típica | Complejidad |
|---|---|---|---|
| **RTAI** | ✅ Activo | ~5-50 μs | Alta (recompilar kernel) |
| **Xenomai** | ✅ Activo | ~5-50 μs | Alta (recompilar kernel) |
| **PREEMPT_RT** | ✅ Integrado (kernel 6.x) | ~50-100 μs | Baja (solo config) |
| **cyclictest** | ✅ Herramienta de test | — | — |

### PREEMPT_RT vs RTAI

| Aspecto | PREEMPT_RT | RTAI |
|---|---|---|
| **Integración** | Oficial en kernel mainline | Parche externo |
| **Instalación** | Config de kernel (`CONFIG_PREEMPT_RT`) | Compilar kernel con RTAI |
| **Mantenimiento** | Mantenido por comunidad kernel | Mantenido por proyecto RTAI |
| **Latencia** | 50-100 μs (suficiente para la mayoría) | 5-50 μs (crítico) |
| **Uso actual** | ✅ Estándar de facto | Nicho (investigación, industria) |

> **Recomendación**: para la mayoría de casos, PREEMPT_RT es suficiente. RTAI solo es necesario si se requieren latencias sub-50μs (robótica de alta velocidad, control CNC).

## Casos de uso

| Caso | Requisito | Solución recomendada |
|---|---|---|
| **Audio profesional (DAW)** | <10 ms latencia | PREEMPT_RT |
| **Control CNC** | <1 ms jitter | RTAI o Xenomai |
| **Robótica** | <100 μs respuesta | RTAI |
| **Adquisición de datos** | Timestamps precisos | PREEMPT_RT |
| **Automatización industrial** | Determinismo estricto | RTAI o hardware dedicado |
| **Impresión 3D** | <1 ms (stepper timing) | PREEMPT_RT |

## Instalación

```bash
# RTAI requiere parchear y recompilar el kernel
# Ver: https://www.rtai.org/

# Para PREEMPT_RT (más fácil):
# En Arch:
sudo pacman -S linux-rt

# En Debian/Ubuntu:
# Descargar kernel RT de los repos o compilar con CONFIG_PREEMPT_RT=y
```

### Verificar si PREEMPT_RT está activo

```bash
uname -v
# Si dice "PREEMPT_RT" → activo
# Si dice "SMP preempt=voluntary" → no RT
```

## Enlaces externos

- [RTAI web oficial](https://www.rtai.org/)
- [Wikipedia — RTAI](https://es.wikipedia.org/wiki/RTAI)
- [Xenomai](https://xenomai.org/)
- [PREEMPT_RT wiki (kernel.org)](https://wiki.linuxfoundation.org/realtime/documentation/howto/start)
- [cyclictest — test de latencia](https://wiki.linuxfoundation.org/realtime/documentation/howto/tools/cyclictest)

## Ver también

- [[Compilación desde Código Fuente]] — compilación de kernel
- [[Módulos del kernel (lsmod modprobe blacklist)]] — módulos del kernel
- [[Procesos y Senales]] — gestión de procesos

#concepto #kernel #tiemporeal
