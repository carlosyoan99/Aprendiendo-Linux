---
fecha_creacion: 2026-07-20
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL/LGPL
alternativas: Cocoa (Apple), Qt, GTK
---

# GNUstep

> Implementación libre del framework **OpenStep/Cocoa** de NeXT/Apple. Permite desarrollar aplicaciones de escritorio en Objective-C con aspecto NeXTSTEP, funcionando en Linux, BSD y otros Unix. Una alternativa libre a Cocoa para quienes buscan un paradigma de desarrollo orientado a objetos maduro.

## Historia

| Hito | Año |
|---|---|
| Creación de especificaciones OpenStep por NeXT | 1994 |
| Apple adquiere NeXT, OpenStep → Cocoa | 1997 |
| Inicio del proyecto GNUstep | ~1998 |
| Madurez de paquetes Make/Base/GUI/Back | 2000s |
| Apple lanza Mac OS X (basado en OpenStep) | 2001 |

GNUstep nació como una reimplementación libre de las bibliotecas **OpenStep** que NeXT (posteriormente Apple) definió para su sistema operativo NeXTSTEP. Cuando Apple lanzó Mac OS X sobre los restos de NeXTSTEP, GNUstep también apuntó a compatibilidad con **Cocoa**, el nombre que Apple dio a las mismas APIs.

> GNUstep es a Cocoa lo que GCC es a Xcode: una implementación libre y multiplataforma de una API propietaria.

## Arquitectura

GNUstep se compone de cuatro paquetes principales, todos escritos en **Objective-C**:

| Paquete | Función |
|---|---|
| **Make** | Sistema de compilación: facilita la creación de Makefiles para proyectos GNUstep. Simplifica configuración, instalación y empaquetado. |
| **Base** | Clases no visuales: colecciones, hilos, sockets, fechas, archivos. Las clases originales heredan el prefijo **NS** (NeXTSTEP), las añadidas por GNUstep usan **GS**. |
| **GUI** | Clases visuales: ventanas, botones, menús, tablas, sliders. Misma convención de prefijos (NS/GS). |
| **Back** | Backend gráfico: traduce las llamadas del framework GUI a primitivas de dibujo del sistema (X11, Cairo, cairo-xlib, etc.). |

### Apariencia

Las aplicaciones GNUstep tienen un aspecto distintivo que recuerda a **NeXTSTEP**:

- Menú vertical desligado de la ventana (estilo NeXT/macOS clásico)
- AppIcons y Miniwindows gestionables con **IconManager**
- Integración nativa con **WindowMaker** (gestor de ventanas que emula el escritorio NeXTSTEP)
- Configurable: se puede usar barra de tareas tradicional o menú en ventana
- En macOS, se comporta como una app nativa de Cocoa

## Aplicaciones hechas con GNUstep

| Aplicación | Descripción |
|---|---|
| **GWorkspace** | Gestor de archivos y escritorio para GNUstep |
| **Project Center** | IDE similar a Project Builder/Xcode para gestionar proyectos |
| **GORM** | Editor visual de interfaces (similar a Interface Builder) |
| **Oolite** | Juego de simulación espacial (clon de Elite) |
| **FísicaLab** | Laboratorio virtual de física |
| **Cenon** | Software de dibujo vectorial (portado de macOS vía GNUstep) |
| **GRR** | Herramienta de desarrollo rápido en Objective-C |

### Empresas que usan GNUstep

- **TestPlant** — herramientas de test automático
- **Orange Concept** — desarrollo de software
- **IntarS** — consultoría informática

## Instalación

```bash
# Debian/Ubuntu
sudo apt install gnustep gnustep-devel

# Arch Linux
sudo pacman -S gnustep

# Fedora
sudo dnf install gnustep*
```

## Ver también

- [[Wayland vs X11]] — sistemas de ventanas donde corre GNUstep
- [[GNOME]] — toolkit alternativo basado en GTK
- [[KDE Plasma]] — toolkit alternativo basado en Qt
- [[Comparativa gestores de ventanas]] — incluye WindowMaker, gestor de ventanas con integración GNUstep

## Enlaces externos

- [Wikipedia — GNUstep](https://en.wikipedia.org/wiki/GNUstep)
- [Sitio oficial — GNUstep](http://www.gnustep.org/)
- [GitHub — gnustep](https://github.com/gnustep)

#programa #framework
