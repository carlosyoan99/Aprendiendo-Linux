---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL/LGPL
alternativas: Cocoa (Apple), Qt, GTK
---

# GNUstep

> Implementación libre del framework **OpenStep/Cocoa** de NeXT/Apple. Permite desarrollar aplicaciones de escritorio en Objective-C con aspecto NeXTSTEP, funcionando en Linux, BSD y otros Unix.

## Qué es

GNUstep es una reimplementación **libre y multiplataforma** de las APIs de Cocoa (las bibliotecas que Apple heredó de NeXTSTEP). Permite compilar en Linux, BSD y macOS aplicaciones escritas en Objective-C que usan las mismas clases Foundation/AppKit que las apps de macOS, pero con un look and feel NeXTSTEP nativo.

- **Lenguaje**: Objective-C (también soporta Swift vía gnustep-swift)
- **Toolkit**: Foundation (NS*), AppKit (ventanas, controles)
- **Backend**: X11, Wayland (experimental), Cairo
- **Ventana**: WindowMaker (integración nativa), cualquier WM X11

> GNUstep es a Cocoa lo que GCC es a Xcode: una implementación libre y multiplataforma de una API propietaria.

## Historia

| Hito | Año |
|---|---|
| Creación de especificaciones OpenStep por NeXT | 1994 |
| Apple adquiere NeXT, OpenStep → Cocoa | 1997 |
| Inicio del proyecto GNUstep | ~1998 |
| Madurez de paquetes Make/Base/GUI/Back | 2000s |
| Apple lanza Mac OS X (basado en OpenStep) | 2001 |
| GNUstep-on-Articles (integración Wayland experimental) | 2020s |

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

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install gnustep gnustep-devel` |
| Arch | `sudo pacman -S gnustep gnustep-make` |
| Fedora | `sudo dnf install gnustep gnustep-base gnustep-gui gnustep-make` |
| openSUSE | `sudo zypper install gnustep gnustep-devel` |
| Void | `sudo xbps-install -S gnustep gnustep-make` |
| macOS | `brew install gnustep-make` |

```bash
# Verificar instalación
gnustep-config --version
gnustep-config --variable=GNUSTEP_SYSTEM_HEADERS

# Compilar un proyecto
. /usr/share/GNUstep/Makefiles/GNUstep.sh
make
```

## Configuración

```bash
# Archivos de configuración GNUstep
~/.GNUstepDefaults          # Preferencias del usuario (NSUserDefaults)
~/.GNUstep/                 # Directorio de configuración

# Cambiar aspecto (defaults)
defaults write NSGlobalDomain GSRightMouseDraggedMask 0
defaults write NSGlobalDomain NSThemeChromeStyle 1

# Forzar estilo clásico NeXTSTEP
defaults write NSGlobalDomain GSUseBackgroundColor YES

# WindowMaker + GNUstep = escritorio NeXTSTEP completo
# En WindowMaker: Info menu → Appearance → usa los temas GNUstep
```

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

## Casos de uso

- **Portar apps macOS a Linux**: cualquier app Cocoa moderate puede compilarse con GNUstep
- **Desarrollo Objective-C multiplataforma**: IDEs como Project Center + GORM
- **Escritorio NeXTSTEP**: WindowMaker + GNUstep = replicar el look de NeXTSTEP en Linux
- **Herencia educativa**: entender la arquitectura de Cocoa/Mac desde una perspectiva libre

## Comparativa con alternativas

| Aspecto | GNUstep | GTK | Qt |
|---|---|---|---|
| **Lenguaje** | Objective-C | C (con GObject) | C++ |
| **Look** | NeXTSTEP clásico | GNOME moderno | KDE moderno |
| **Madurez** | Desde ~1998 | Desde 1997 | Desde 1991 |
| **Licencia** | GPL/LGPL | LGPL | LGPL/GPL comercial |
| **Documentación** | Buena (Apple docs aplicables) | Excelente | Excelente |
| **Ecosistema apps** | Pequeño | Grande | Grande |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `gnustep-config: command not found` | Paquete gnustep-make no instalado | `sudo apt install gnustep-make` |
| Errores de compilación "GNUSTEP_SYSTEM_HEADERS" | Variable de entorno no configurada | `. /usr/share/GNUstep/Makefiles/GNUstep.sh` |
| Aplicaciones sin menú vertical | Usando WM diferente a WindowMaker | Configurar `NSMenuDisabled` o usar WindowMaker |
|_look and feel feo/desactualizado| Tema GTK por defecto en Back | Configurar `GSTheme` o usar Cairo backend |
| `ld: library not found -lgnustep-base` | Runtime GNUstep no instalado | Instalar paquete gnustep-base (runtime) |

## Ver también

- [[Wayland vs X11]] — sistemas de ventanas donde corre GNUstep
- [[GNOME]] — toolkit alternativo basado en GTK
- [[KDE Plasma]] — toolkit alternativo basado en Qt
- [[Comparativa gestores de ventanas]] — incluye WindowMaker, gestor de ventanas con integración GNUstep

## Enlaces externos

- [Wikipedia — GNUstep](https://en.wikipedia.org/wiki/GNUstep)
- [Sitio oficial — GNUstep](http://www.gnustep.org/)
- [GitHub — gnustep](https://github.com/gnustep)
- [GNUstep Documentation](https://wiki.gnustep.org/)

#programa #framework
