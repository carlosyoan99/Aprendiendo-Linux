---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: DE
---

# LXQt

## Qué es

**LXQt** es un entorno de escritorio **ligero y rápido** escrito en **Qt**. Es el sucesor de **LXDE** (que usaba GTK) tras la unificación del desarrollo entre LXDE-Qt y Razor-Qt. Es la opción ligera ideal para quienes prefieren Qt sobre GTK.

Creado tras la decisión de **Hong Jen Yee** (PCMan, desarrollador de LXDE y PCManFM) de migrar PCManFM a Qt en 2013. Se unió con el proyecto Razor-Qt para formar LXQt.

## Filosofía

- **Ligereza**: funciona en hardware antiguo (~250-400 MB RAM)
- **Qt nativo**: sin dependencias GTK, ideal para quienes usan apps Qt
- **Modular**: puedes elegir qué componentes instalar
- **Rápido**: arranque casi instantáneo, respuesta inmediata

## Componentes

| Componente | Nombre | Función |
|---|---|---|
| **Gestor ventanas** | Openbox | WM ligero configurable |
| **Panel** | LXQt Panel | Panel con menú, barra de tareas, bandeja |
| **Gestor archivos** | PCManFM-Qt | Gestor de archivos rápido y completo |
| **Terminal** | QTerminal | Terminal con pestañas |
| **Editor texto** | FeatherPad | Editor minimalista |
| **Visor imágenes** | LXImage-Qt | Visor de imágenes |
| **Captura pantalla** | Screengrab | Captura de pantalla |
| **Centro control** | LXQt Control Center | Configuración del sistema |

## Instalación

```bash
# Debian/Ubuntu
sudo apt install lxqt

# Arch Linux
sudo pacman -S lxqt

# Fedora
sudo dnf group install lxqt-desktop

# openSUSE
sudo zypper install -t pattern lxqt
```

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `Alt+F1` | Menú de aplicaciones |
| `Alt+F2` | Ejecutar comando |
| `Alt+Tab` | Cambiar entre ventanas |
| `Alt+F4` | Cerrar ventana |
| `Super+D` | Mostrar escritorio |
| `Ctrl+Alt+T` | Terminal (QTerminal) |

## Personalización

```bash
# Configuración del panel
lxqt-config-panel

# Configuración de apariencia
lxqt-config-appearance

# Atajos de teclado
lxqt-config-globalkeyshortcuts
```

## LXQt vs LXDE vs XFCE

| Aspecto | LXQt | LXDE | XFCE |
|---|---|---|---|
| **Toolkit** | Qt 5/6 | GTK 2 | GTK 3 |
| **RAM idle** | ~250-400 MB | ~200-350 MB | ~350-500 MB |
| **Gestor ventanas** | Openbox | Openbox | XFWM |
| **Wayland** | En desarrollo | No | Experimental |
| **Estética** | Moderna (Qt) | Anticuada (GTK 2) | Equilibrada |
| **Configuración** | Buena | Básica | Muy buena |

## Notas personales

- LXQt es mi DE ligero favorito cuando quiero Qt en lugar de GTK. Es primo hermano de KDE Plasma pero sin el peso.
- PCManFM-Qt (gestor de archivos) es sorprendentemente rápido. En máquinas con HDD, la diferencia con Nautilus o Dolphin se nota.
- Al usar Openbox como WM, puedes aprovechar toda la configuración de Openbox para atajos y comportamiento de ventanas.
- Si vienes de Lubuntu, LXQt es la evolución natural de LXDE. Mismo concepto, tecnología más moderna.

## Ver también

- [[XFCE]] — alternativa ligera en GTK
- [[MATE]] — alternativa más completa
- [[Openbox]] — WM por defecto de LXQt
- [[KDE Plasma]] — DE Qt completo (LXQt es primo ligero de Plasma)
- [[Comparativa entornos de escritorio]] — comparativa de todos los DEs

## Enlaces externos

- [LXQt — Página oficial](https://lxqt-project.org/)
- [LXQt GitHub](https://github.com/lxqt)
- [Wikipedia — LXQt](https://en.wikipedia.org/wiki/LXQt)

#entorno-escritorio
