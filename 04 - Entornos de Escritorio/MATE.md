---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: DE
---

# MATE

## Qué es

**MATE** es un entorno de escritorio que continúa el desarrollo de **GNOME 2** tras la migración de GNOME a GNOME 3/Shell. Mantiene el paradigma clásico de escritorio: panel inferior con menú de aplicaciones, lista de ventanas y bandeja del sistema.

Creado por **Perberos** (usuario de Arch Linux) en 2011, MATE toma su nombre de la infusión sudamericana *yerba mate*. Es mantenido por la comunidad MATE Desktop Environment.

## Filosofía

- **Tradición**: mantiene vivo el paradigma de escritorio GNOME 2 (que muchos consideran el mejor diseño de escritorio)
- **Familiaridad**: usuarios de Windows XP/7 o macOS clásico se sienten en casa
- **Rendimiento**: corre en hardware modesto (~350-550 MB RAM)
- **Tradición sobre innovación**: no busca reinventar el escritorio, sino hacerlo bien

## Componentes

| Componente | Nombre | Función |
|---|---|---|
| **Gestor ventanas** | Marco | Fork de Metacity (GNOME 2) |
| **Panel** | MATE Panel | Paneles configurables superior/inferior |
| **Menú** | MATE Menu | Menú clásico con categorías (similar a Windows XP) |
| **Gestor archivos** | Caja | Fork de Nautilus 2.x |
| **Editor texto** | Pluma | Fork de Gedit |
| **Terminal** | MATE Terminal | Fork de GNOME Terminal |
| **Visor imágenes** | Eye of MATE | Fork de Eye of GNOME |
| **Centro control** | MATE Control Center | Configuración del sistema |

## Instalación

```bash
# Debian/Ubuntu
sudo apt install mate-desktop-environment mate-extra
sudo apt install mate-desktop-environment-extras  # apps adicionales

# Arch Linux
sudo pacman -S mate mate-extra

# Fedora
sudo dnf group install mate-desktop

# openSUSE
sudo zypper install -t pattern mate
```

## Atajos de teclado esenciales

| Atajo | Acción |
|---|---|
| `Alt+F1` | Menú de aplicaciones |
| `Alt+F2` | Ejecutar comando |
| `Alt+Tab` | Cambiar entre ventanas |
| `Alt+F4` | Cerrar ventana |
| `Super+E` | Abrir gestor de archivos (Caja) |
| `Ctrl+Alt+Delete` | Bloquear pantalla |
| `Ctrl+Alt+L` | Bloquear pantalla |

## Configuración

```bash
# Centro de control (todas las configuraciones)
mate-control-center

# Editor de menús (personalizar menú de aplicaciones)
alacarte

# Gestor de temas
mate-appearance-properties

# Configurar paneles
mate-panel --replace
mate-tweak                       # ajustes adicionales de MATE
```

## Personalización

MATE soporta temas GTK 2/3, iconos, cursores y fondos. Los temas de **GNOME 2** suelen ser compatibles:

```bash
# Temas populares:
# Mint-Y (Linux Mint)
# Arc (GTK 2/3)
# Adwaita (GNOME)

# Instalar temas
sudo apt install arc-theme
```

## MATE vs GNOME

| Aspecto | MATE | GNOME |
|---|---|---|
| **Paradigma** | Clásico (menú + paneles) | Moderno (overview + actividades) |
| **RAM idle** | ~350-550 MB | ~800 MB - 1.2 GB |
| **Tema iconos** | Oxígeno, Mint | Adwaita |
| **Gestor ventanas** | Marco (fork Metacity) | Mutter |
| **Wayland** | Experimental | ✅ Nativo |
| **Extensiones** | Applets de panel | Extensiones GNOME Shell |
| **Popular en** | Ubuntu MATE, Linux Mint, Fedora | Ubuntu, Fedora, mayoría distros |

## Notas personales

- MATE es el DE que instalo en PCs muy antiguos donde XFCE no me convence del todo. Mantiene vivo el espíritu de GNOME 2, que para muchos fue la mejor época del escritorio Linux.
- La continuidad con GNOME 2 hace que sea familiar al instante si tienes experiencia con Linux de los 2000.
- Caja (el gestor de archivos) es Nautilus 2.x con otro nombre. Sigue siendo rápido y funcional, aunque carece de las integraciones modernas.
- Si te gusta el escritorio clásico pero quieres algo más moderno que MATE, prueba Cinnamon.

## Ver también

- [[GNOME]] — el DE moderno del que MATE se separó
- [[XFCE]] — alternativa ligera similar (pero sin herencia GNOME 2)
- [[Cinnamon]] — otro DE clásico moderno (Linux Mint)
- [[KDE Plasma]] — DE completo y personalizable
- [[Comparativa entornos de escritorio]] — comparativa de todos los DEs

## Enlaces externos

- [MATE Desktop — Página oficial](https://mate-desktop.org/)
- [MATE Wiki](https://wiki.mate-desktop.org/)
- [MATE GitHub](https://github.com/mate-desktop)
- [Ubuntu MATE](https://ubuntu-mate.org/)

#entorno-escritorio
