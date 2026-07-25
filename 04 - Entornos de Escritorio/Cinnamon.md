---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
tipo: DE (desktop environment)
---

# Cinnamon

## Qué es

Entorno de escritorio desarrollado por el equipo de [[Linux Mint]] — originalmente un fork de GNOME Shell 3 cuando este adoptó el escritorio "moderno" (vista de actividades, dock oculto), diseñado para mantener un **layout tradicional tipo Windows**: barra de tareas inferior con menú de inicio, ventanas con decoraciones clásicas, bandeja del sistema. Construido sobre GTK, usa **Muffin** (fork de Mutter) como compositor.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install cinnamon
# También existe Ubuntu Cinnamon como sabor oficial desde 23.10

# Fedora
sudo dnf group install "Cinnamon Desktop"

# Arch
sudo pacman -S cinnamon
sudo pacman -S xorg-server xorg-xinit     # si es una instalación mínima sin DE
```

## Configuración inicial

### Applets, Desklets y Extensiones

Cinnamon se personaliza desde **Configuración del Sistema**:

- **Applets**: pequeños paneles en la barra de tareas (reloj, menú de inicio, bandeja del sistema, monitor de red).
- **Desklets**: widgets en el escritorio (notas, calendario, clima, monitor del sistema).
- **Extensiones**: modifican el comportamiento del escritorio (efectos de ventana, shortcuts adicionales, etc.).

```bash
# Applets y extensiones populares:
# - "Menu" (el menú de inicio mejorado con búsqueda y categorías)
# - "Panel Launchers" (iconos de apps favoritas)
# - "Window List" (lista de ventanas abiertas como Windows)
# - "System Monitor" (CPU, RAM, red en el panel)
```

### Temas

Cinnamon usa temas propios (`.cinnamon-theme`) además de temas GTK:

```bash
# Instalar desde Configuración → Apariencia → Tema / Iconos / Controles
# Descargar desde: cinnamon-spices.linuxmint.com
```

### Hot Corners (esquinas activas)

```bash
# Configuración → Esquinas activas
# Puedes asignar acciones a cada esquina: mostrar todas las ventanas,
# mostrar escritorio, abrir menú de inicio, cambiar workspace...
```

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Super` (Meta) | Abrir menú de inicio |
| `Alt + Tab` | Cambiar de ventana (con vista previa) |
| `Ctrl + Alt + T` | Abrir terminal (depende de la distro) |
| `Super + E` | Abrir gestor de archivos (Nemo) |
| `Super + D` | Mostrar escritorio |
| `Super + L` | Bloquear pantalla |
| `Super + Flechas` | Ajustar ventana a mitades/esquinas |
| `Ctrl + Alt + Flechas` | Cambiar de workspace |
| `Super + Shift + Flechas` | Mover ventana a otro workspace |
| `Alt + F2` | Ejecutar comando (Run Command) |

## Pros / Contras

- ✅ Curva de aprendizaje mínima si vienes de Windows — no tienes que cambiar hábitos.
- ✅ Muy estable, predecible, no cambia drásticamente entre versiones (a diferencia de GNOME).
- ✅ Consume menos que GNOME/KDE (~500-700 MB RAM) pero más que XFCE.
- ❌ Menos moderno visualmente que GNOME o KDE (se nota que mantiene compatibilidad con el layout clásico).
- ❌ Soporte Wayland todavía en desarrollo (no listo para uso diario en 2026).
- ❌ Ecosistema de desarrolladores/applets mucho menor que GNOME Extensions o KDE Widgets.

## Wayland vs X11 en Cinnamon

Cinnamon usa **X11** por defecto. El soporte experimental para Wayland está en desarrollo, pero no se recomienda para uso diario. Si necesitas Wayland, [[GNOME]] o [[KDE Plasma]] son mejores opciones.

## Notas personales

- Cinnamon es el DE que recomiendo a cualquier persona que migra de Windows y quiere algo que funcione igual desde el primer minuto. Linux Mint con Cinnamon es la experiencia más "aburrida" (en el buen sentido) de Linux.
- El soporte Wayland está llegando pero aún no está listo. Si necesitas Wayland, GNOME o KDE son mejores opciones.
- El gestor de archivos Nemo es, para mí, el mejor gestor GTK: tiene split panel (F3), terminal integrada (F4), y es rápido.
- Cinnamon no innova, pero no falla. Para un escritorio de producción donde la estabilidad importa más que la estética, es perfecto.

## Enlaces externos

- [Wikipedia — Cinnamon (desktop environment)](https://en.wikipedia.org/wiki/Cinnamon_(desktop_environment))
- [Repositorio oficial en GitHub](https://github.com/linuxmint/cinnamon)
- [Sitio oficial de Linux Mint](https://linuxmint.com/)

## Ver también

- [[Linux Mint]] — el hogar principal de Cinnamon
- [[GNOME]] — el ancestro técnico de Cinnamon
- [[XFCE]] — alternativa ligera con filosofía similar
- [[Wayland vs X11]]

#entorno-escritorio
