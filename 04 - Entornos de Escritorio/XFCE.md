---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: DE (desktop environment)
---

# XFCE

## Qué es

Entorno ligero y rápido, ideal para hardware limitado (máquinas con 1-2 GB RAM, CPUs viejas, netbooks) o para quien prioriza rendimiento sobre efectos visuales. Usa GTK (similar a GNOME pero mucho más liviano) y sigue el paradigma clásico de escritorio: panel inferior, menú de aplicaciones, ventanas con decoraciones.

Filosofía: "hacer lo básico bien, sin florituras". No busca innovar en UX como GNOME o KDE, sino mantenerse predecible y eficiente.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install xfce4                   # base + panel + gestor ventanas
sudo apt install xfce4-goodies           # plugins extra (recomendado)

# Fedora
sudo dnf group install "Xfce Desktop"

# Arch
sudo pacman -S xfce4 xfce4-goodies
```

## Configuración inicial

- **Xfce Settings Manager** centraliza toda la configuración vía GUI: apariencia, escritorio, paneles, ventanas, atajos, sesión.
- Archivos de config en `~/.config/xfce4/`.

### xfce4-goodies

El paquete `xfce4-goodies` incluye plugins y herramientas adicionales que mejoran la experiencia:

| Plugin | Para qué |
|---|---|
| `xfce4-whiskermenu-plugin` | Menú de inicio tipo Windows 7 (búsqueda + categorías) |
| `xfce4-docklike-plugin` | Barra con íconos de apps abiertas tipo dock |
| `xfce4-clipman-plugin` | Historial del portapapeles |
| `xfce4-screenshooter` | Capturas de pantalla con región/ventana/pantalla completa |
| `xfce4-taskmanager` | Monitor de procesos gráfico (alternativa a `top`/`htop`) |
| `mousepad` | Editor de texto simple (tipo Notepad) |
| `ristretto` | Visor de imágenes |

### Temas

XFCE usa temas GTK. Se pueden instalar desde `xfce-look.org` o paquetes:

```bash
sudo apt install arc-theme               # tema plano moderno (Arc)
sudo apt install papirus-icon-theme       # iconos Papirus (muy completo)
```

## Sesiones y arranque

XFCE permite guardar el estado de la sesión (apps abiertas, posición de ventanas) al cerrar sesión:

```bash
# Configuración → Sesión e Inicio → General
# - "Guardar sesión automáticamente" / "Preguntar al cerrar"
```

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Alt + F2` | Lanzador de comandos (tipo "Run") |
| `Alt + Tab` | Cambiar de ventana |
| `Alt + F4` | Cerrar ventana |
| `Ctrl + Alt + D` | Mostrar escritorio |
| `Super + P` | Configuración de pantallas externas/proyector (xfce4-display-settings) |
| `Alt + F10` | Maximizar/restaurar ventana |
| `Alt + F7` | Mover ventana con teclado (flechas) |
| `Super + L` | Bloquear pantalla (xfce4-screensaver) |

Los atajos se personalizan desde Configuración → Teclado → Atajos de aplicación.

## Pros / Contras

- ✅ Muy rápido — consume ~300-500 MB RAM en reposo (frente a 1-2 GB de GNOME/KDE).
- ✅ Estable, no rompe con actualizaciones, interfaz predecible que no cambia de un año a otro.
- ✅ Funciona bien en hardware de 10-15 años de antigüedad (incluso en Raspberry Pi).
- ❌ Estética menos moderna por defecto (se puede mejorar con temas, pero no alcanza el pulido de GNOME/KDE).
- ❌ Soporte Wayland en desarrollo (X11 sigue siendo lo estable).
- ❌ Algunas funcionalidades (emulación de docks, notificaciones modernas) requieren plugins extra.

## Notas personales

- XFCE es mi DE de cabecera en máquinas secundarias y servidores con escritorio. Su consumo de RAM (~400 MB) es imbatible para un DE completo.
- No esperes innovación visual. XFCE no cambia porque ya hace bien lo que hace. Lleva 20 años con el mismo paradigma y no piensa cambiarlo.
- El paquete `xfce4-goodies` es obligatorio: sin él, la experiencia es demasiado básica. Whisker Menu cambia completamente la usabilidad.
- Ideal para darle vida nueva a un portátil de 2010. Con un SSD y XFCE, cualquier máquina vieja vuelve a ser usable.

## Enlaces externos

- [Wikipedia — Xfce](https://en.wikipedia.org/wiki/Xfce)
- [Sitio oficial](https://xfce.org/)
- [GitLab oficial](https://gitlab.xfce.org/xfce)

## Ver también

- [[GNOME]] — DE moderno, más pesado, con Wayland nativo
- [[KDE Plasma]] — DE pesado pero muy completo
- [[Cinnamon]] — otro DE basado en GTK, similar a XFCE en filosofía clásica pero más pesado
- [[Emuladores de Terminal]]

#entorno-escritorio
