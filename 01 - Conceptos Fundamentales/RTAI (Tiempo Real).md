---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-20
estado: resuelto
categoria: concepto
prioridad: baja
---

# RTAI (Real-Time Application Interface)

> Extensiones de **tiempo real** para el kernel Linux. Permiten ejecutar tareas con plazos estrictos para sistemas de control, robótica, automatización industrial y adquisición de datos.

## Definición

RTAI (y su predecesor **RTLinux**) añaden un micro-núcleo de tiempo real debajo del kernel Linux. Tratan a Linux como una tarea de menor prioridad que se ejecuta cuando no hay tareas de tiempo real activas. Esto proporciona tiempos de respuesta deterministas (microsegundos).

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

| Proyecto | Estado |
|---|---|
| **RTAI** | ✅ Activo (mantenido) |
| **Xenomai** | ✅ Activo (evolución de RTAI+RTLinux) |
| **PREEMPT_RT** | ✅ Parche oficial del kernel (kernel 6.x integrado) |
| **RT-Linux** | ❌ Comercial (FSMLabs) |

## Instalación

```bash
# RTAI requiere parchear y recompilar el kernel
# Ver: https://www.rtai.org/
```

## Enlaces externos

- [RTAI web oficial](https://www.rtai.org/)
- [Wikipedia — RTAI](https://es.wikipedia.org/wiki/RTAI)
- [Xenomai](https://xenomai.org/)

## Ver también

- [[Compilacion desde Codigo Fuente]] — compilación de kernel
- [[Módulos del kernel (lsmod modprobe blacklist)]] — módulos del kernel

#concepto #kernel #tiemporeal
