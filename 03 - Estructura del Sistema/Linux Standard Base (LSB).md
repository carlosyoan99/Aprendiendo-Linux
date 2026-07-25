---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: sistema
prioridad: baja
---

# Linux Standard Base (LSB)

> Conjunto de estándares que busca garantizar la **compatibilidad entre distribuciones Linux**, permitiendo que las aplicaciones compiladas para una distro funcionen en cualquier otra que cumpla con LSB.

## Qué es

La **Linux Standard Base (LSB)** es un proyecto conjunto de distribuciones de Linux bajo el antiguo **Free Standards Group** (hoy The Linux Foundation) con el objetivo de estandarizar la estructura interna de los sistemas Linux, basándose en **POSIX**, la **Single UNIX Specification** y otros estándares abiertos.

El objetivo es que un programa compilado para una distribución LSB-certificada funcione en cualquier otra distribución LSB-certificada, sin necesidad de recompilar.

## ¿Qué especifica LSB?

| Componente | Estándar |
|---|---|
| **Bibliotecas** | Versiones específicas de glibc, libstdc++, libX11, libQt, etc. |
| **Comandos** | Conjunto de utilidades que extienden POSIX |
| **Jerarquía del sistema** | Filesystem Hierarchy Standard (FHS) |
| **Niveles de ejecución** | Init scripts (SysV) |
| **Formato de paquetes** | RPM (especificado, aunque no obligatorio) |
| **Gráficos** | Extensiones a X11 y Wayland |
| **ABI** | Interfaz binaria de aplicación a nivel de sistema |

## Arquitectura

```
┌──────────────────────────────────────┐
│          Aplicación                   │
├──────────────────────────────────────┤
│             LSB Libraries             │
│  (glibc, libstdc++, libX11, libQt)   │
├──────────────────────────────────────┤
│         LSB Commands & Utilities      │
│  (ls, cp, grep, etc. versiones LSB)  │
├──────────────────────────────────────┤
│         File System Hierarchy (FHS)   │
├──────────────────────────────────────┤
│            Linux Kernel               │
└──────────────────────────────────────┘
```

## Críticas a LSB

| Crítica | Explicación |
|---|---|
| **Centrado en RPM** | LSB especifica RPM como formato de paquete, ignorando .deb, Pacman, etc. |
| **Lento en actualizarse** | Las versiones de bibliotecas especificadas quedan desactualizadas rápido |
| **Poco adoptado** | Muchas distribuciones no persiguen la certificación LSB |
| **Fragmentación** | Flatpak/Snap/AppImage resolvieron el problema de distribución de apps mejor que LSB |
| **Debian lo rechazó** | Debian consideró que LSB favorecía a Red Hat sobre otras distribuciones |

## Estado actual

LSB ya **no se mantiene activamente**. La última versión fue **LSB 5.0** (2015). El problema que LSB intentaba resolver — la compatibilidad entre distribuciones — fue solucionado por otros medios:

| Solución | Cómo resuelve la compatibilidad |
|---|---|
| **Flatpak** | Empaqueta la app con sus dependencias, corre en cualquier distro |
| **Snap** | Lo mismo, con sandboxing |
| **AppImage** | Aplicación portable sin instalación |
| **Docker/OCI** | Contenedores con sistema completo |
| **Contenedores** | Entornos aislados con la distro que necesites |

```bash
# Verificar si un sistema es LSB-compatible
lsb_release -a
# Si el comando no existe:
sudo apt install lsb-release
lsb_release -a

# Ver módulos LSB instalados
lsb_release -s
```

## El legado de LSB

Aunque LSB como certificación está obsoleto, algunos de sus componentes siguen siendo relevantes:

- **FHS (Filesystem Hierarchy Standard)** — sigue siendo la guía de estructura de directorios
- **LSB libraries** — muchas de las ABI especificadas siguen siendo compatibles
- **AppImage** hereda la idea de "un formato de paquete universal" pero implementado de forma más práctica

## Ver también

- [[Filesystem Hierarchy Standard]] — estándar de jerarquía del sistema
- [[Gestores de Paquetes]] — formatos de paquete y repositorios
- [[Snap y Flatpak]] — formato portable moderno
- POSIX — estándar base de sistemas Unix
- [[Canonical y su ecosistema]] — competencia de estándares

## Enlaces externos

- [LSB Workgroup (The Linux Foundation)](https://wiki.linuxfoundation.org/lsb/start)
- [Wikipedia — Linux Standard Base](https://en.wikipedia.org/wiki/Linux_Standard_Base)
- [FHS 3.0 Specification](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)

#sistema
