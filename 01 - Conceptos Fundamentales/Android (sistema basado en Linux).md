---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: concepto
prioridad: alta
---

# Android — Sistema operativo basado en Linux

> El sistema operativo móvil más utilizado del mundo, construido sobre el kernel de Linux. Android es la implementación masiva de Linux: más de **3 mil millones de dispositivos activos** en 2025.

## Qué es

**Android** es un sistema operativo móvil desarrollado por **Google** (inicialmente por Android Inc., adquirida en 2005) basado en el **kernel de Linux**. Sin embargo, Android no es un Linux estándar: usa el kernel de Linux pero con un espacio de usuario completamente diferente al de las distribuciones GNU/Linux.

Android domina el mercado móvil global con aproximadamente el **70% de cuota de mercado** de smartphones, seguido por iOS.

## Android ≠ Linux (GNU/Linux)

| Aspecto | Android | GNU/Linux (escritorio) |
|---|---|---|
| **Kernel** | Linux (fork de Google) | Linux (mainline) |
| **Libc** | Bionic (propia de Google) | glibc / musl |
| **Display server** | SurfaceFlinger | Wayland / X11 |
| **Runtime** | ART (Android Runtime) | Ninguno (binarios ELF directamente) |
| **Gestor de paquetes** | APK + Play Store | apt/pacman/dnf + repos |
| **Shell** | No expuesta por defecto | Bash / Zsh |
| **GNU tools** | Toolbox → Toybox (BSD) | GNU Coreutils |
| **Init** | systemd (Android no lo usa) | systemd (estándar) |
| **Actualizaciones** | OTA, fragmentadas | Por distro, centralizadas |

## Arquitectura de Android

```
┌──────────────────────────────────────────────────┐
│           Aplicaciones (APKs)                      │
│  (Java/Kotlin, algunas nativas C++)                │
├──────────────────────────────────────────────────┤
│              Android Framework                     │
│  (Activity Manager, Window Manager, Content        │
│   Providers, Notification Manager, etc.)           │
├──────────────────────────────────────────────────┤
│          Android Runtime (ART)                     │
│  Compila apps a código nativo (AOT + JIT)          │
├──────────────────────────────────────────────────┤
│               HAL (Hardware Abstraction Layer)      │
│  (Cámara, Audio, GPS, Sensores, Bluetooth)         │
├──────────────────────────────────────────────────┤
│            Linux Kernel (modificado)                │
│  (Binder, Wakelocks, Low Memory Killer, etc.)      │
└──────────────────────────────────────────────────┘
```

### Diferencias del kernel Android

Google mantiene un **fork** del kernel de Linux con parches específicos:

- **Binder** — IPC optimizado para el framework Android
- **Wakelocks** — gestión de energía para dispositivos móviles
- **Low Memory Killer** — mata procesos cuando la RAM se agota
- **ashmem** — memoria compartida entre procesos
- **pstore/ramoops** — captura de logs tras un kernel panic
- **Schedtune** — ajustes de scheduler para rendimiento móvil

## Versiones de Android

| Nombre comercial | Versión API | Año | Característica clave |
|---|---|---|---|
| **Cupcake** | 3 | 2009 | Teclado virtual |
| **Ice Cream Sandwich** | 14 | 2011 | Unifica tablet y teléfono |
| **Lollipop** | 21 | 2014 | Material Design, ART por defecto |
| **Marshmallow** | 23 | 2015 | Permisos por app |
| **Pie** | 28 | 2018 | Gestos de navegación, Digital Wellbeing |
| **Android 10** | 29 | 2019 | Modo oscuro, gestos completos |
| **Android 12** | 31 | 2021 | Material You |
| **Android 14** | 34 | 2023 | Mejoras privacidad, tablets |
| **Android 15** | 35 | 2024 | Satellite messaging, Partial screen sharing |
| **Android 16** | 36 | 2025 | Mejoras en AI/ML, multitarea avanzada |

## Distribuciones basadas en Android

| Distribución | Propósito |
|---|---|
| **LineageOS** | El más popular, soporte extendido para dispositivos viejos |
| **GrapheneOS** | Privacidad/seguridad máxima, solo Pixel |
| **CalyxOS** | Privacidad con microG, soporte Pixel y algunos más |
| **DivestOS** | Para dispositivos muy antiguos, basado en LineageOS |
| **/e/OS** | Privacidad, ecosistema sin Google |
| **crDroid** | Personalización y rendimiento |
| **Paranoid Android** | Experiencia limpia, pocos cambios |

### LineageOS

LineageOS (antes CyanogenMod) es el ROM custom más popular de Android. Ofrece:

```bash
# Requisitos para instalar LineageOS
# 1. Bootloader desbloqueado
# 2. Recovery personalizado (TWRP / Lineage Recovery)
# 3. Descargar ROM de https://lineageos.org/
# 4. Flashear desde recovery

# En el recovery:
adb sideload lineage-*.zip
# Opcional: Google Apps
adb sideload MindTheGapps-*.zip
```

### GrapheneOS

GrapheneOS es el ROM más seguro para Android, con mejoras como:

- **Hardened malloc** — previene heap exploitation
- **Network permission toggle** — control granular de red por app
- **Sensor permission toggle** — control de cámara/micrófono
- **PIN scrambling** — evita que se deduzca el PIN por las marcas en pantalla
- **Vanadium** — navegador Chromium hardened

## El kernel Android y el Linux mainline

Google está moviendo gradualmente parches de Android al kernel mainline de Linux:

| Estado | Componente |
|---|---|
| ✅ Integrado | Binder, memoria compartida |
| ✅ Integrado | Wakelocks (reimplementados) |
| ✅ Integrado | pstore/ramoops |
| 🟡 En progreso | Schedtune, mejoras de energía |
| 🔴 Proyecto | Generic Kernel Image (GKI) para separar kernel de vendor |

> **Project Treble** (Android 8+) y **GKI** (Android 12+) permiten actualizar el kernel independientemente del vendor, reduciendo la fragmentación.

## ADB — Android Debug Bridge

ADB es la herramienta clave para interactuar con Android desde Linux:

```bash
# Conectar dispositivo
adb devices

# Shell remota
adb shell

# Instalar APK
adb install app.apk

# Ver logs del sistema
adb logcat

# Capturar pantalla
adb shell screencap /sdcard/screen.png
adb pull /sdcard/screen.png

# Transferir archivos
adb push archivo.txt /sdcard/
adb pull /sdcard/archivo.txt .
```

Ver [[scrcpy]] para controlar Android desde el escritorio Linux.

## Android en el escritorio Linux

Herramientas para integrar Android con Linux:

- **scrcpy** — controlar Android desde el PC (ver nota)
- **KDE Connect** — integración entre dispositivos (notificaciones, archivos, clipboard)
- **GSConnect** — implementación de KDE Connect para GNOME
- **Anbox / Waydroid** — ejecutar apps Android en Linux
- **ADB** — debugging y control avanzado

```bash
# Waydroid — ejecutar apps Android en Linux
sudo apt install waydroid
sudo waydroid init
waydroid session start
waydroid show-full-ui
waydroid install app.apk
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `adb: command not found` | ADB no instalado | `sudo apt install adb` |
| `device unauthorized` | Permiso no aceptado en Android | Aceptar en pantalla del dispositivo |
| `no devices/emulators found` | USB debugging desactivado | Activar Opciones de desarrollador → USB Debugging |
| Waydroid no inicia | Faltan módulos del kernel | `sudo modprobe binder_linux ashmem_linux` |
| No se puede flashear ROM | Bootloader bloqueado | Desbloquear: `fastboot oem unlock` |

## Ver también

- [[Linux embebido]] — Linux en sistemas embebidos (Android es un caso particular)
- [[scrcpy]] — controlar Android desde Linux
- [[Wayland vs X11]] — Android no usa ni X11 ni Wayland, usa SurfaceFlinger
- [[Kernel Linux]] — historia del kernel
- [[Debate Tanenbaum-Torvalds]] — arquitectura de kernels
- GrapheneOS — distribución Android enfocada en seguridad

## Enlaces externos

- [Android Open Source Project (AOSP)](https://source.android.com/)
- [LineageOS](https://lineageos.org/)
- [GrapheneOS](https://grapheneos.org/)
- [ADB — Android Debug Bridge](https://developer.android.com/studio/command-line/adb)
- [Waydroid — Android en Linux](https://waydro.id/)
- [Android Kernel Evolution](https://source.android.com/docs/core/architecture/kernel)
- [Wikipedia — Android](https://en.wikipedia.org/wiki/Android_(operating_system))

#concepto
