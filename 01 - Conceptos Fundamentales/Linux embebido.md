---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: concepto
prioridad: media
---

# Linux embebido

> Uso del kernel de Linux en sistemas embebidos: dispositivos con recursos limitados que realizan una función específica. Desde routers y smart TVs hasta Raspberry Pi, sistemas IoT y electrodomésticos inteligentes.

## Qué es

**Linux embebido** (embedded Linux) se refiere al uso del kernel de Linux en **sistemas embebidos** — dispositivos diseñados para una función específica con recursos limitados de CPU, RAM y almacenamiento. A diferencia de un escritorio o servidor Linux, un sistema embebido ejecuta Linux en hardware restringido (a menudo con solo 2-64 MB de RAM y almacenamiento flash).

Es la implementación más extendida de Linux: está en routers, smart TVs, cámaras IP, sistemas de automoción, drones, dispositivos IoT, robótica industrial y prácticamente cualquier dispositivo inteligente moderno.

## Características

| Aspecto | Linux embebido | Escritorio/Servidor |
|---|---|---|
| **RAM típica** | 2 MB - 512 MB | 4 GB - 64 GB+ |
| **Almacenamiento** | Flash SPI/NAND (1-64 MB) | SSD/HDD (128 GB - 2 TB+) |
| **CPU** | ARM, MIPS, RISC-V | x86_64 |
| **Init** | BusyBox init, systemd mínimo | systemd completo |
| **Espacio de usuario** | BusyBox (2 MB) | GNU Coreutils (20 MB+) |
| **Display** | Framebuffer, LCD pequeño | GPU compleja, Wayland/X11 |
| **Conexión** | GPIO, SPI, I²C, UART | PCIe, USB, Ethernet |

## Componentes de un sistema Linux embebido

```
┌─────────────────────────────────────────────┐
│           Bootloader (U-Boot, Barebox)       │
├─────────────────────────────────────────────┤
│          Kernel Linux (mínimo)               │
│   Solo drivers necesarios para el hardware   │
├─────────────────────────────────────────────┤
│        Espacio de usuario (rootfs)           │
│   BusyBox, libc mínima (uClibc/musl)        │
│   Init (BusyBox init, OpenRC, s6)           │
├─────────────────────────────────────────────┤
│           Aplicación específica              │
│   La lógica del dispositivo (ej: router OS)  │
└─────────────────────────────────────────────┘
```

### 1. Bootloader

El bootloader inicializa el hardware mínimo y carga el kernel:

| Bootloader | Para qué |
|---|---|
| **U-Boot** | El más común en ARM/embedded |
| **Barebox** | Alternativa moderna a U-Boot |
| **coreboot** | Para x86 embebido |
| **GRUB** | Solo en x86 con suficiente espacio |

### 2. Kernel

El kernel se compila **a medida** para el hardware específico, incluyendo solo los drivers necesarios:

```bash
# Compilar kernel para ARM embebido
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j4
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dtbs
```

### 3. Root filesystem

Herramientas para construir el sistema de archivos raíz:

| Herramienta | Descripción |
|---|---|
| **Buildroot** | Sistema de compilación automatizado (el más popular) |
| **Yocto Project** | Framework completo, más complejo, más flexible |
| **OpenWrt** | Para routers y dispositivos de red |
| **Debian/Ubuntu base** | Para SBCs como Raspberry Pi (menos mínimo, más fácil) |

```bash
# Ejemplo con Buildroot
git clone https://github.com/buildroot/buildroot
cd buildroot
make menuconfig  # seleccionar target, toolchain, paquetes
make
# Output: output/images/rootfs.cpio, zImage, dtbs
```

### 4. Biblioteca C

| Biblioteca | Tamaño | Compatibilidad |
|---|---|---|
| **glibc** | ~2 MB | Completa, estándar |
| **musl** | ~400 KB | Compatible, rápida |
| **uClibc-ng** | ~300 KB | Mínima, para sistemas muy pequeños |

## SBCs populares para Linux embebido

| Placa | CPU | RAM | Usos típicos |
|---|---|---|---|
| **Raspberry Pi 5** | ARM Cortex-A76 | 4-8 GB | Servidor doméstico, media center, IoT |
| **Raspberry Pi Zero 2** | ARM Cortex-A53 | 512 MB | Proyectos pequeños, embebido |
| **BeagleBone Black** | ARM Cortex-A8 | 512 MB | IoT industrial, PRUs |
| **Orange Pi** | ARM varios | 512 MB - 4 GB | Alternativa económica a RPi |
| **ODROID** | ARM Cortex-A72 | 2-8 GB | NAS, emulación, servidores |
| **Banana Pi** | ARM Cortex-A7 | 1-2 GB | Router, servidor |

## Distribuciones para sistemas embebidos

| Distribución | Para qué |
|---|---|
| **Raspberry Pi OS** | La oficial para Raspberry Pi (Debian-based) |
| **Armbian** | Para SBCs ARM (Orange Pi, Banana Pi, etc.) |
| **OpenWrt** | Routers y dispositivos de red |
| **Buildroot + custom** | Sistemas ultra-minimalistas |
| **Yocto + custom** | Sistemas industriales/comerciales |
| **Alpine Linux** | Contenedores y sistemas ligeros (ARM) |

## Linux embebido en dispositivos cotidianos

| Dispositivo | Sistema operativo | Base |
|---|---|---|
| **Router WiFi** | OpenWrt / DD-WRT / Stock | Linux embebido |
| **Smart TV** | webOS / Tizen / Android TV | Linux |
| **Termostato Nest** | Nest OS | Linux embebido |
| **Tesla** | Tesla OS | Linux embebido |
| **Cámara IP** | Firmware personalizado | Linux embebido |
| **Kindle** | Kindle OS | Linux embebido |
| **Android TV** | Android TV | Linux (Android) |
| **Automóvil (infoentretenimiento)** | Android Automotive / QNX | Linux |

## Desarrollo de sistemas embebidos

```bash
# Cadena de herramientas típica (cross-compilation)
# Host: x86_64, Target: ARM

# Instalar toolchain
sudo apt install gcc-arm-linux-gnueabihf

# Compilar programa para ARM
arm-linux-gnueabihf-gcc -o hola hola.c

# Verificar que es para ARM
file hola
# hola: ELF 32-bit LSB executable, ARM, EABI5

# Transferir al dispositivo
scp hola root@192.168.1.100:/tmp/
ssh root@192.168.1.100 /tmp/hola
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Kernel panic al arrancar | Rootfs no encontrado | Verificar `root=` en cmdline del kernel |
| No bootea | Bootloader mal configurado | Revisar U-Boot env, console en puerto serie |
| USB no funciona | Falta driver en kernel | Recompilar kernel con CONFIG_USB* |
| Wifi no detecta | Firmware no incluido | Agregar firmware al rootfs |
| GPIO no responde | Permisos incorrectos | `echo 17 > /sys/class/gpio/export` o usar libgpiod |

## Ver también

- [[Busybox]] — la suite de herramientas estándar en embedded
- [[Linux en servidores cloud IoT]] — Linux en servidores y cloud
- [[Rust for Linux]] — Rust en el kernel (relevante para embedded)
- [[coreboot]] — firmware libre para arranque
- [[Alpine Linux]] — distro ligera para contenedores y embebido
- [[Compilacion desde Codigo Fuente]] — cross-compilation

## Enlaces externos

- [Buildroot](https://buildroot.org/) — sistema de compilación embebido
- [Yocto Project](https://www.yoctoproject.org/) — framework completo
- [OpenWrt](https://openwrt.org/) — Linux para routers
- [Raspberry Pi](https://www.raspberrypi.com/) — SBC más popular
- [Wikipedia — Linux embebido](https://en.wikipedia.org/wiki/Embedded_Linux)
- [Bootlin — Engineering](https://bootlin.com/) — consultoría embedded Linux

#concepto
