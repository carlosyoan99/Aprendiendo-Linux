---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
licencia: GPL / LGPL / Comercial
alternativas: GTK, Motif, FLTK, wxWidgets
---

# Qt

> Toolkit de widgets multiplataforma (Linux, Windows, macOS, Android, embebido) escrito en **C++**, creado por **Trolltech** en 1995. Es el toolkit base del escritorio **KDE Plasma** y también usado por LXQt.

## Qué es

Qt es más que un toolkit de widgets: es un **framework completo** que incluye módulos de redes, bases de datos, multimedia, WebEngine (Chromium), sensores, Bluetooth, y un lenguaje declarativo de interfaces llamado **QML**.

| Aspecto | Detalle |
|---|---|
| **Creador** | Haavard Nord, Eirik Chambe-Eng (Trolltech, 1995) |
| **Mantenido por** | The Qt Company (anteriormente Digia) + KDE e.V. |
| **Lenguaje principal** | C++ (MOC: Meta-Object Compiler) |
| **Licencia** | GPL 3 / LGPL 3 / Comercial (doble/triple licencia) |
| **DE que lo usan** | KDE Plasma, LXQt, UKUI, Deepin |

## Versiones principales

| Versión | Lanzamiento | Estado | Novedades |
|---|---|---|---|
| **Qt 4** | 2005 | Obsoleto (EOL 2015) | QML introducido, Qt Quick |
| **Qt 5** | 2012 | Mantenimiento (último 5.15 LTS+) | Qt Quick 2, Qt Wayland, Qt WebEngine |
| **Qt 6** | 2020 | Activo | Qt Quick 3D, QML mejorado, CMake obligatorio, Qt Graph |

> Qt 6 requiere **CMake** (qmake fue eliminado). La migración de Qt 5 a 6 es menos traumática que la de Qt 4 a 5.

## Instalación

```bash
# Debian/Ubuntu — Qt 6
sudo apt install qt6-base-dev           # widgets base
sudo apt install qt6-tools-dev          # herramientas (designer, linguist)

# Qt 5 (legacy, todavía muy usado)
sudo apt install qtbase5-dev            # Qt 5 base

# Fedora
sudo dnf install qt6-qtbase-devel       # Qt 6
sudo dnf install qt5-qtbase-devel       # Qt 5

# Arch
sudo pacman -S qt6-base                # Qt 6
sudo pacman -S qt5-base                # Qt 5

# Verificar versión
qmake6 --version                        # Qt 6
qmake --version                         # Qt 5 (si está instalado)
```

## Ejemplo mínimo (Qt 6 en C++)

```cpp
#include <QApplication>
#include <QPushButton>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QPushButton button("¡Hola, Qt!");
    button.resize(300, 150);
    button.show();
    return app.exec();
}
```

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.16)
project(HolaQt)
find_package(Qt6 REQUIRED COMPONENTS Widgets)
qt_standard_project_setup()
qt_add_executable(hola-qt main.cpp)
target_link_libraries(hola-qt Qt6::Widgets)
```

```bash
# Compilar
mkdir build && cd build
cmake ..
make
./hola-qt
```

## Qt y el Meta-Object Compiler (MOC)

Qt extiende C++ estándar con señales/slots, propiedades e introspección mediante el **MOC**, un preprocesador que genera código C++ adicional:

```cpp
class Contador : public QObject {
    Q_OBJECT                          // macro MOC
    Q_PROPERTY(int valor READ valor)  // propiedad

public:
    explicit Contador(QObject *parent = nullptr) : QObject(parent), m_valor(0) {}

    int valor() const { return m_valor; }

signals:
    void alcanzado(int maximo);       // señal (emit)

public slots:
    void incrementar() {              // slot
        m_valor++;
        if (m_valor >= 100) emit alcanzado(m_valor);
    }

private:
    int m_valor;
};
```

## Qt vs GTK

| Aspecto | Qt 6 | GTK 4 |
|---|---|---|
| **Lenguaje** | C++ (MOC) | C (GObject) |
| **Licencia** | GPL / LGPL / Comercial | LGPL |
| **DE asociado** | KDE Plasma, LXQt | GNOME, XFCE, Budgie |
| **Widgets** | ~200+ + QML (declarativo) | ~100 (imperativo + CSS) |
| **Cross-platform** | Excelente (nativo en Win/macOS) | Bueno (nativo en Linux, emulado en Win) |
| **IDE oficial** | Qt Creator | Cambalache, Glade (legacy) |
| **Documentación** | Excelente (Qt Company) | Buena (GNOME) |
| **Curva de aprendizaje** | Alta (C++ + MOC + QML) | Media (C + GObject) |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `CMake Error: Qt6 not found` | Falta `qt6-base-dev` o `CMAKE_PREFIX_PATH` incorrecto | `export CMAKE_PREFIX_PATH=/usr/lib/qt6` o instalar el -dev |
| `QApplication: No such file or directory` | MOC no procesó el header | Asegurar `qt_standard_project_setup()` en CMakeLists.txt |
| `cannot find -lQt6::Widgets` | Enlace incorrecto en CMake | Usar `find_package(Qt6 REQUIRED COMPONENTS Widgets)` |
| Fuentes se ven mal en Qt 6 | Qt 6 cambió el renderizado de fuentes | Configurar `QT_ENABLE_HIGHDPI_SCALING` |

## Enlaces externos

- [Sitio oficial de Qt](https://www.qt.io/)
- [Qt 6 Documentation](https://doc.qt.io/qt-6/)
- [Qt Creator IDE](https://www.qt.io/product/development-tools)
- [Wikipedia — Qt](https://en.wikipedia.org/wiki/Qt_(software))
- [KDE — Qt y KDE Frameworks](https://develop.kde.org/)
- [PySide6 — Qt para Python](https://doc.qt.io/qtforpython/)

## Ver también

- [[KDE Plasma]] — DE principal que usa Qt
- [[GTK]] — toolkit alternativo (GNOME, XFCE)
- [[Motif]] — toolkit histórico (CDE)
- [[LXQt]] — DE ligero basado en Qt
- CMake — sistema de build requerido por Qt 6 (ver [[Compilación desde Código Fuente]])

#programa #toolkit #gui #kde
