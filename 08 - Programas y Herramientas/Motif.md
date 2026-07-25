---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# Motif

> Toolkit de widgets GUI histórico para Unix, creado por la **Open Software Foundation (OSF)**. Base del **Common Desktop Environment (CDE)** y estándar de facto en sistemas Unix comerciales de los 90.

## Qué es

**Motif** es un conjunto de bibliotecas que proporcionan widgets (botones, menús, ventanas, scrollbars) con el aspecto "tallado en piedra" característico de los Unix comerciales. Construido sobre **X Toolkit Intrinsics (Xt)**, define tanto una API de programación como una especificación de **"look and feel"**.

### Open Motif vs LessTif

| Aspecto | Open Motif | LessTif |
|---|---|---|
| **Origen** | Código fuente oficial de OSF | Clon *clean-room* de código abierto |
| **Licencia** | Propietario → LGPL (2012) | LGPL |
| **Estado** | Activo (última release 2.3.8, 2017) | Obsoleto, superado por Open Motif |
| **Quién lo usa** | CDE, aplicaciones legacy Unix | Proyectos libres que necesitaban compatibilidad |

Tras la liberación por **The Open Group** en 2012 bajo **LGPL**, Open Motif se convirtió en la opción recomendada, dejando a LessTif como pieza histórica.

## Historia

| Año | Hito |
|---|---|
| **1988** | OSF inicia el desarrollo de Motif |
| **1989** | Primera versión pública (Motif 1.0) |
| **1993** | Motif 1.2 incluido en CDE 1.0 |
| **1994-2000** | Estándar en Unix comerciales: Solaris, AIX, HP-UX, Tru64 |
| **2000** | LessTif alcanza compatibilidad con Motif 2.1 |
| **2012** | Open Motif liberado como LGPL |
| **2017** | Última versión: Motif 2.3.8 |

## Instalación

```bash
# Debian/Ubuntu
sudo apt install libmotif-dev          # desarrollo
sudo apt install libxm4                # runtime

# Fedora/RHEL
sudo dnf install motif motif-devel

# Arch
sudo pacman -S motif

# Compilar desde fuente (Open Motif)
wget https://sourceforge.net/projects/motif/files/motif/2.3.8/motif-2.3.8.tar.gz
tar xzf motif-2.3.8.tar.gz
cd motif-2.3.8
./configure --prefix=/usr
make -j$(nproc)
sudo make install
```

## Componentes

| Componente | Función |
|---|---|
| **Xm (Motif Toolkit)** | Widgets base: botones, menús, scrollbars, listas, texto |
| **Mrm (Motif Resource Manager)** | Carga dinámica de interfaces desde archivos UID |
| **UIL (User Interface Language)** | Lenguaje declarativo para definir interfaces |
| **Xbae** | Widgets extendidos (tablas, iconos) |
| **mwm (Motif Window Manager)** | Gestor de ventanas con decoración clásica |

### mwm (Motif Window Manager)

`mwm` es el gestor de ventanas exclusivo de Motif. Proporciona las decoraciones de ventana (barra de título, bordes biselados, botones minimizar/maximizar) que definen la estética Motif. Configuración:

```bash
# Archivos de configuración
~/.mwmrc          # menús y atajos de teclado por usuario
/etc/X11/mwm/system.mwmrc  # configuración global

# Ejecutar standalone
mwm
```

## Ejemplo mínimo en C

```c
#include <Xm/Xm.h>
#include <Xm/PushB.h>

void salir(Widget w, XtPointer client_data, XtPointer call_data) {
    exit(0);
}

int main(int argc, char *argv[]) {
    Widget toplevel, boton;
    XtAppContext app;

    toplevel = XtVaAppInitialize(&app, "Hola", NULL, 0,
                                 &argc, argv, NULL, NULL);
    boton = XmCreatePushButton(toplevel, "boton", NULL, 0);
    XtVaSetValues(boton, XmNlabelString,
                  XmStringCreateLocalized("¡Hola, Motif!"), NULL);
    XtAddCallback(boton, XmNactivateCallback, salir, NULL);
    XtManageChild(boton);
    XtRealizeWidget(toplevel);
    XtAppMainLoop(app);
}
```

Compilar:
```bash
gcc hola-motif.c -o hola-motif -lXm -lXt -lX11
```

## Personalización con .Xresources

Motif lee la base de datos de recursos de X11 para su apariencia. Añadir a `~/.Xresources`:

```text
*background:           grey75
*foreground:           black
*activeBackground:     grey60
*activeForeground:     black
*fontList:             -*-helvetica-medium-r-*-*-12-*-*-*-*-*-*-*
*XmPushButton.shadowThickness: 2
```

Aplicar cambios:
```bash
xrdb -merge ~/.Xresources
```

## Motif vs toolkits modernos

| Aspecto | Motif | GTK 4 | Qt 6 |
|---|---|---|---|
| **Año inicial** | 1989 | 1998 | 1995 |
| **Lenguaje** | C | C | C++ |
| **Licencia** | LGPL | LGPL | GPL/LGPL |
| **Soporte Wayland** | ❌ Sólo X11 | ✅ Nativo | ✅ Nativo |
| **HiDPI** | ❌ | ✅ | ✅ |
| **Widgets modernos** | ❌ Básicos | ✅ Completo | ✅ Completo |
| **Uso actual** | Legacy / Histórico | GNOME, apps Linux | KDE, apps cross-platform |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `undefined reference to XmCreatePushButton` | Falta enlazar `-lXm` | Compilar con `-lXm -lXt -lX11` |
| Motif app no encuentra fuentes | Falta `xfonts-*` | `apt install xfonts-100dpi xfonts-75dpi` |
| mwm no muestra decoraciones | Sin gestor de ventanas activo | Ejecutar `mwm &` antes que la app |
| Colores no se aplican | `.Xresources` no cargado | Ejecutar `xrdb -merge ~/.Xresources` |

## Enlaces externos

- [Wikipedia — Motif (widget toolkit)](https://en.wikipedia.org/wiki/Motif_(software))
- [SourceForge — Open Motif](https://sourceforge.net/projects/motif/)
- [Wikipedia — LessTif](https://en.wikipedia.org/wiki/LessTif)
- [Linux Journal — X/Motif Programming](https://www.linuxjournal.com/article/3666)

## Ver también

- [[Common Desktop Environment (CDE)]] — DE que usa Motif como toolkit base
- [[GNUstep]] — implementación libre del framework Cocoa/OpenStep
- [[GTK]] — toolkit moderno de GNOME (sucesor conceptual)
- [[Qt]] — toolkit moderno de KDE (sucesor conceptual)
- [[Wayland vs X11]] — Motif solo funciona sobre X11

#programa #graficos #toolkit #gui
