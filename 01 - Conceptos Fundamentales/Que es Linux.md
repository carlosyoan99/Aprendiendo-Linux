---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: concepto
prioridad: alta
---

# Qué es Linux

## Definición

Linux no es un sistema operativo completo por sí mismo, sino el **kernel** que actúa como núcleo del sistema. El término "Linux" suele referirse al conjunto formado por el kernel Linux + herramientas GNU + software adicional que conforma una **distribución** (distro). Richard Stallman aboga por llamarlo **GNU/Linux** para reconocer el rol del proyecto GNU.

## El Kernel (núcleo)

Creado por **Linus Torvalds** en 1991, el kernel es el software que:

- **Gestiona el hardware**: CPU, memoria, discos, dispositivos USB, GPU, red.
- **Administra procesos**: decide qué programa se ejecuta y por cuánto tiempo (scheduler).
- **Maneja memoria**: asigna y libera RAM a los procesos, gestiona swap.
- **Provee un sistema de archivos**: organiza cómo se almacenan los datos en disco.
- **Controla drivers**: módulos que permiten al sistema comunicarse con hardware específico.

```bash
uname -r          # versión del kernel en ejecución
uname -a          # información completa del kernel
ls /lib/modules/  # módulos de kernel disponibles
```

## La distribución

Cada distro combina el kernel con un conjunto específico de software y herramientas:

| Componente | Ejemplos |
|---|---|
| **Gestor de paquetes** | `apt` (Debian), `pacman` (Arch), `dnf` (Fedora) |
| **Init / gestor de servicios** | `systemd` (la mayoría), `openrc` (Gentoo, Alpine) |
| **Shell por defecto** | `bash` (casi todas), `zsh` (algunas), `fish` (ninguna) |
| **Entorno gráfico** | GNOME, KDE, XFCE (o ninguno en servidores) |

Ver [[Gestores de Paquetes]] y [[systemd]].

## Filosofía

- **Software libre**: el código es abierto y modificable. Libertad de usar, estudiar, compartir y modificar.
- **Modularidad**: cada pieza (kernel, shell, DE/WM, gestor de paquetes) es intercambiable. No hay un "Linux único" — cada distro elige su combinación.
- **Todo es un archivo**: dispositivos, procesos, configuraciones se representan como archivos en `/dev/`, `/proc/`, `/sys/`.
- **Haz una cosa y hazla bien**: cada herramienta hace una tarea específica y se combina con otras mediante pipes (`|`).

## ¿Dónde se usa Linux?

| Ámbito | Presencia |
|---|---|
| **Servidores** | ~96% de los servidores web (AWS, Google Cloud, Azure) |
| **Escritorio** | ~3-4% cuota global, pero creciendo |
| **Móviles** | Android usa el kernel Linux |
| **Embeddded** | Routers, smart TVs, Raspberry Pi, IoT |
| **Supercomputación** | 100% del Top500 ejecuta Linux |

## Por qué aprender Linux hoy

- Es la base de la nube: Docker, Kubernetes, la mayoría de servicios cloud corren sobre Linux.
- Entorno laboral: casi todo desarrollo backend, DevOps y ciberseguridad pasa por una terminal Linux.
- Libertad: entiendes cómo funciona tu ordenador por debajo, sin cajas negras.

## Relación con otros conceptos

- [[systemd]] — el sistema de init que arranca y gestiona servicios
- [[Permisos y Propietarios]] — cómo Linux controla quién accede a qué
- [[Gestores de Paquetes]] — cómo se instala y actualiza el software
- [[Wayland vs X11]] — el sistema de ventanas gráficas

## Enlaces externos

- [Wikipedia — Linux](https://en.wikipedia.org/wiki/Linux)
- [Kernel de Linux — sitio oficial](https://www.kernel.org/)
- [Linux Foundation](https://www.linuxfoundation.org/)

## Ver también

- [[La Shell]]
- [[Filesystem Hierarchy Standard]]
- [[Proceso de Instalacion General]]

#concepto #linux
