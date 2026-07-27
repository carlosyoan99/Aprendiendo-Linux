---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: DE
motor_composicion: x11
lenguaje_config: GUI (Style Manager)
licencia: GPLv2 (desde 2012)
alternativas: KDE Plasma, GNOME, XFCE
---

# Common Desktop Environment (CDE)

> El escritorio estándar de Unix en los años 90. Desarrollado conjuntamente por **HP, IBM, Novell y Sun Microsystems** como parte de **COSE** (Common Open Software Environment). Liberado como código abierto en 2012 bajo GPLv2.

## Qué es

CDE fue el escritorio comercial estándar para sistemas Unix desde mediados de los 90 hasta principios de los 2000. Usado en **HP-UX, IBM AIX, Solaris, Tru64 UNIX, OpenVMS y IRIX**. Está basado en la biblioteca **Motif** y el gestor de ventanas **MWM (Motif Window Manager)**.

Con la llegada de KDE (1998) y GNOME (1999) como software libre, CDE fue gradualmente reemplazado. En 2012, **The Open Group** liberó el código fuente de CDE bajo licencia **GPLv2**, permitiendo su instalación en distribuciones Linux modernas.

## Capturas / Imágenes

> ![CDE Desktop](https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/CDE_under_OpenSolaris.png/320px-CDE_under_OpenSolaris.png)
> *CDE ejecutándose en Solaris (Fuente: Wikipedia)*

> ![CDE con aplicaciones](https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/CDE_Solaris.png/320px-CDE_Solaris.png)
> *CDE con aplicaciones clásicas (Fuente: Wikipedia)*

## Filosofía / Público objetivo

CDE fue diseñado siguiendo los principios de usabilidad de los 90: interfaz profesional, consistente entre diferentes Unix, con un **Style Manager** que permitía personalizar colores, fuentes y comportamientos. Su objetivo era proporcionar una experiencia de escritorio homogénea a través de diferentes sistemas Unix comerciales.

Hoy tiene un interés **histórico y nostálgico**. No es recomendable para uso diario, pero es fascinante para quienes quieren experimentar cómo era un escritorio Unix profesional en los 90.

## Historia

| Año | Hito |
|---|---|
| **1993** | Se anuncia COSE, un consorcio de HP, IBM, Novell, Sun, Univel y USL |
| **1994** | Primera versión de CDE incluida en sistemas comerciales |
| **1995-2000** | CDE es el escritorio estándar en HP-UX, AIX, Solaris, Tru64 |
| **2001** | GNOME 2 y KDE 2 empiezan a ganar tracción |
| **2005** | Solaris 10 incluye CDE y GNOME como opciones |
| **2010** | Solaris 11 elimina CDE por defecto, reemplazado por GNOME |
| **2012** | The Open Group libera CDE como **código abierto (GPLv2)** |
| **2015+** | CDE actualizado para compilar en Linux moderno por la comunidad |

## Sistemas que usaban CDE

| Sistema | Estado actual | Incluía CDE |
|---|---|---|
| **HP-UX** | Activo (v11.31+) | ✅ Por defecto |
| **IBM AIX** | Activo (v7.3+) | ✅ Por defecto |
| **Oracle Solaris** | Activo (v11.4+) | ❌ Sustituido por GNOME |
| **Tru64 UNIX** | Descontinuado (2012) | ✅ Por defecto |
| **OpenVMS** | Activo (v8.4+) | ✅ Por defecto (versión DECwindows) |
| **IRIX (SGI)** | Descontinuado (2006) | ✅ Por defecto (con IRIX Interactive Desktop) |

## Instalación en Linux moderno

```bash
# CDE no está en los repos oficiales de la mayoría de distros
# Hay que compilarlo desde fuente

# 1. Clonar repositorio
git clone https://git.code.sf.net/p/cdesktopenv/code cde
cd cde

# 2. Instalar dependencias
sudo apt install build-essential libmotif-dev libxm4 libxt-dev         # Debian/Ubuntu
sudo pacman -S base-devel motif libxt libxmu libxpm libxinerama        # Arch

# 3. Compilar (CDE requiere autoconf, automake, libtool)
cd cde
autoreconf -fi
./configure --prefix=/opt/cde
make -j$(nproc)
sudo make install

# 4. Añadir sesión CDE a tu display manager
echo "/opt/cde/bin/Xsession" | sudo tee /usr/share/xsessions/cde.desktop
```

> ⚠️ Compilar CDE en 2026 requiere paciencia y ajustes manuales. No es un proceso trivial.

## Componentes clave

| Componente | Función |
|---|---|
| **Motif Window Manager (mwm)** | Gestor de ventanas con decoraciones clásicas |
| **CDE Panel** | Panel inferior con menú de aplicaciones, reloj, workspace switcher |
| **File Manager** | Gestor de archivos visual para el escritorio |
| **Style Manager** | Centro de personalización (colores, fuentes, comportamiento) |
| **Workspace Manager** | Gestor de múltiples escritorios virtuales |
| **Calendar Manager** | Calendario y agenda |
| **Mailer** | Cliente de correo integrado |
| **Text Editor** | Editor de texto plano básico |
| **Terminal** | Emulador de terminal (dtterm) |
| **Help System** | Sistema de ayuda integrado |

### Toolkits: Motif

CDE está construido sobre **Motif**, un toolkit de widgets para X11 desarrollado por **OSF (Open Software Foundation)**. Motif define:

| Componente | Descripción |
|---|---|
| **Xm (Motif Toolkit)** | Widgets: botones, menús, diálogos, listas, texto |
| **Xbae** | Widgets extendidos (tablas, iconos) |
| **Mrm (Motif Resource Manager)** | Carga de interfaces desde archivos UIL |

Motif fue el toolkit estándar para aplicaciones Unix comerciales durante los 90. Su apariencia (botones 3D, bordes biselados, colores grises) define la estética de los Unix de esa década.

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Cualquier x86_64 | 1 GHz |
| **RAM** | 64 MB | 256 MB |
| **Disco** | 100 MB | 500 MB |
| **GPU** | Cualquier con soporte X11 | Cualquier |

## Características clave

| Aspecto | Detalle |
|---|---|
| **Toolkit** | Motif (Propietario → BSD-style → GPLv2) |
| **Gestor ventanas** | Motif Window Manager (mwm) |
| **Configuración** | Style Manager (GUI) + archivos de recursos `.Xdefaults` |
| **Workspaces** | Sí, múltiples escritorios virtuales |
| **Panel** | Inferior, con menú, reloj, workspaces y bandeja |
| **Drag & Drop** | Sí, entre componentes CDE |
| **RAM en idle** | ~100-200 MB |
| **Protocolo** | Solo X11 |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Escritorio histórico, patrimonio del software | Obsoleto técnicamente (Motif, X11, sin HW acceleration) |
| Consume muy pocos recursos | Instalación compleja en Linux moderno |
| Funciona en hardware de los 90 | Sin soporte de pantallas modernas (HiDPI, multi-monitor) |
| Código abierto desde 2012 | Sin Wayland, sin aceleración gráfica |
| Interfaz consistente y predecible | No compatible con apps GTK/Qt modernas |
| | Ecosistema muerto (sin desarrollo activo significativo) |

## CDE vs GNOME vs XFCE (perspectiva histórica)

| Aspecto | CDE (1994) | GNOME 2 (2002) | XFCE (2000s) |
|---|---|---|---|
| **Toolkit** | Motif (propietario → GPL) | GTK 2 | GTK 2 |
| **Estética** | Profesional, gris, biselada | Moderna para su época | Similar a CDE inicialmente |
| **RAM** | ~100-200 MB | ~200-400 MB | ~150-300 MB |
| **Extensibilidad** | Limitada | Buena (applets) | Buena (plugins) |
| **Legado** | Estándar Unix 90s | Inspiró MATE, Cinnamon | Sigue activo |
| **Estado** | Histórico | Forkeado como MATE | ✅ Activo |

## Notas personales

- CDE es historia viva del escritorio Unix. Fue el DE comercial estándar en los 90 (Solaris, HP-UX, AIX) y su influencia llega hasta hoy en diseño de paneles y menús.
- XFCE se inspiró inicialmente en CDE, aunque hoy son muy diferentes.
- Si quieres experimentar CDE, la forma más fácil es instalar Solaris 10 en una VM, o compilar la versión open-source en Linux.
- Como DE de uso diario en 2026 no tiene sentido. Pero como pieza de museo y para entender de dónde vienen los escritorios modernos, es imprescindible.
- La liberación del código en 2012 fue un acto importante de preservación del patrimonio del software.

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| No compila en GCC moderno | Código K&R C de los 90 | Usar `-std=c99` o parches de compatibilidad |
| Las fuentes se ven mal | Falta definición de fuentes X11 | Instalar `xfonts-100dpi xfonts-75dpi` |
| El ratón no funciona en Linux moderno | Configuración de input desactualizada | Editar `/opt/cde/config/Xresources` |
| Pantalla en negro al iniciar sesión | Display manager no compatible | Usar `startx` directamente con CDE |

## Comandos asociados

| Comando | Para qué |
|---|---|
| `/opt/cde/bin/Xsession` | Iniciar sesión CDE |
| `/opt/cde/bin/dtstyle` | Style Manager (personalización) |
| `/opt/cde/bin/dtwm` | Motif Window Manager |
| `/opt/cde/bin/dtterm` | Terminal CDE |
| `mwm` | Motif Window Manager (standalone) |

## Ver también

- [[Comparativa entornos de escritorio]] — comparativa de todos los DEs
- [[XFCE]] — inspirado inicialmente en CDE
- [[GNOME]] — sucesor moderno como DE libre dominante
- [[KDE Plasma]] — el otro gran escritorio libre
- [[Motif]] — toolkit base de CDE
- [[Desktop Shells (Noctalia Caelestia)]] — capas de personalización sobre DEs

## Enlaces externos

- [CDE en SourceForge](https://sourceforge.net/projects/cdesktopenv/) — código fuente
- [The Open Group — CDE](http://www.opengroup.org/cde/)
- [Wikipedia — Common Desktop Environment](https://es.wikipedia.org/wiki/Common_Desktop_Environment)
- [Wikipedia — Motif (widget toolkit)](https://en.wikipedia.org/wiki/Motif_(widget_toolkit))
- [CDE Wiki — documentación comunitaria](https://cdesktopenv.github.io/wiki/)
- [GitHub — CDE source](https://github.com/cdesktopenv/cdesktopenv)

#entorno-escritorio
