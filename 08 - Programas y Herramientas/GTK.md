---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
licencia: LGPL
alternativas: Qt, Motif, FLTK, wxWidgets
---

# GTK (GIMP Toolkit)

> Toolkit de widgets libre para interfaces gráficas, creado originalmente para **GIMP** (1998). Es el toolkit base del escritorio **GNOME** y también usado por XFCE, Cinnamon, Budgie y MATE.

## Qué es

GTK es un conjunto de bibliotecas multiplataforma (Linux, Windows, macOS) para crear interfaces gráficas. Escrito en **C** con el sistema GObject, ofrece bindings para C++, Python, Rust, JavaScript, Vala y más.

| Aspecto | Detalle |
|---|---|
| **Creador** | Spencer Kimball, Peter Mattis (1998, para GIMP) |
| **Mantenido por** | GNOME Foundation / Freedesktop.org |
| **Lenguaje principal** | C (GObject) |
| **Licencia** | LGPL (excepto GTK 1.x y 2.x legacy) |
| **DE que lo usan** | GNOME, XFCE, Cinnamon, Budgie, MATE |

## Versiones principales

| Versión | Lanzamiento | Estado | Widgets destacados |
|---|---|---|---|
| **GTK 2** | 2002 | Obsoleto (EOL 2018) | GtkEntry, GtkTreeView |
| **GTK 3** | 2011 | Mantenimiento (último 3.24) | CSS theming, GtkHeaderBar, GtkStack |
| **GTK 4** | 2020 | Activo | GtkListView, GtkColumnView, renderer Vulkan/OpenGL |

> GTK 4 cambió radicalmente la API: eliminó `GtkWidget.show()`, introdujo `GtkApplication` obligatorio y renderizado por GL. GTK 3 sigue siendo el más usado en producción.

## Instalación

```bash
# Debian/Ubuntu — GTK 4 (desarrollo)
sudo apt install libgtk-4-dev

# GTK 3 (estable, más compatible)
sudo apt install libgtk-3-dev

# Fedora
sudo dnf install gtk4-devel
sudo dnf install gtk3-devel

# Arch
sudo pacman -S gtk4
sudo pacman -S gtk3

# Verificar versión instalada
pkg-config --modversion gtk4
pkg-config --modversion gtk+-3.0
```

## Ejemplo mínimo (GTK 4 en C)

```c
#include <gtk/gtk.h>

static void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "Hola GTK");
    gtk_window_set_default_size(GTK_WINDOW(window), 300, 200);
    gtk_window_present(GTK_WINDOW(window));
}

int main(int argc, char **argv) {
    GtkApplication *app = gtk_application_new(
        "org.ejemplo.holagtk", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    return g_application_run(G_APPLICATION(app), argc, argv);
}
```

```bash
# Compilar
gcc $(pkg-config --cflags gtk4) -o hola-gtk hola-gtk.c $(pkg-config --libs gtk4)
```

## GTK vs Qt

| Aspecto | GTK 4 | Qt 6 |
|---|---|---|
| **Lenguaje** | C (GObject) | C++ (QMetaObject) |
| **Licencia** | LGPL | GPL / LGPL / Comercial |
| **DE asociado** | GNOME, XFCE, Budgie | KDE Plasma, LXQt |
| **Widgets nativos** | ~100 | ~200+ (con Qt Quick: QML) |
| **CSS theming** | Nativo (CSS-like) | QSS (similar a CSS) |
| **IDE oficial** | Cambalache, Glade (legacy) | Qt Creator |
| **Bindings** | Python (PyGObject), Rust (gtk4-rs), JS, Vala | Python (PySide6), Rust (qmetaobject) |
| **Curva de aprendizaje** | Media | Alta (C++ + MOC) |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `cannot find -lgtk-4` | Falta `libgtk-4-dev` | Instalar el paquete -dev correspondiente |
| `Gtk-ERROR **: cannot open display` | Sin servidor X11 | GTK necesita DISPLAY (o Wayland con GDK backend) |
| Theming no funciona en GTK4 | API de temas cambió | GTK4 usa CSS en `.css` en `$XDG_CONFIG_HOME/gtk-4.0/` |

## Enlaces externos

- [Sitio oficial de GTK](https://www.gtk.org/)
- [GTK 4 — Getting Started](https://www.gtk.org/docs/getting-started/hello-world)
- [GNOME — GTK Documentation](https://docs.gtk.org/gtk4/)
- [Wikipedia — GTK](https://en.wikipedia.org/wiki/GTK)
- [PyGObject — GTK for Python](https://pygobject.readthedocs.io/)

## Ver también

- [[GNOME]] — DE principal que usa GTK
- [[Qt]] — toolkit alternativo (KDE, LXQt)
- [[Motif]] — toolkit histórico (CDE)
- [[Wayland vs X11]] — GTK corre nativamente sobre ambos
- [[Cava]] — ejemplo de app TUI que no necesita toolkit gráfico

#programa #toolkit #gui #gnome
