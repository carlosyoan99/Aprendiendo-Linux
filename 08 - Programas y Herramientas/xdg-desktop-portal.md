---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---
# xdg-desktop-portal

> Demonio del **XDG Desktop Portal** de freedesktop.org que da a las aplicaciones en *sandbox* (Flatpak, snap, paquetes porta… la shell) acceso controlado a los recursos del escritorio: captura de pantalla, notificaciones, apertura de archivos, impresión, etc. Es **la pieza clave que hace que apps Flatpak funcionen con normalidad en Wayland y X11**.

## Qué es

Un **portal** es una interfaz de Freedesktop (D-Bus) que actúa como puente entre una aplicación aislada y los servicios del escritorio. La app pide algo (p. ej. "captura de pantalla" o "el usuario eligió un archivo") a través de la API del portal, y es el demonio, ejecutándose fuera del sandbox, quien lo resuelve con permiso del usuario.

Esto es esencial en **Flatpak**: como la aplicación corre en una caja aislada (Bubblewrap) sin acceso directo a tu pantalla ni a tus archivos, necesita que algo externo (el portal) haga esas tareas por ella de forma segura y controlada.

**xdg-desktop-portal** es el demonio que provee esa API entre la app y el entorno de escritorio. Orquesta también a los **backends** específicos del escritorio (GNOME, KDE, wlroots, X11) que implementan las interfaces concretas.

## Por qué es importante en Wayland

En **X11**, capturar pantalla, mover el cursor o leer notificaciones eran cosas "globales" que cualquiera podía hacer. En **Wayland** no: las apps no pueden acceder a la pantalla de los demás ni a servicios del sistema. Wayland **bloquea** esos accesos de forma predeterminada y obliga a usar portales (o protocolos dedicados) para recuperar esa funcionalidad.

El caso más visible: **screen sharing / captura de pantalla**. En Wayland, una app no puede "hacer screenshot" directamente; necesita que el portal (con el backend **wlr** o el del escritorio) la capture vía **PipeWire**. Ver [[Compatibilidad Wayland]].

## Componentes

| Componente | Rol |
|---|---|
| **xdg-desktop-portal** | Demonio principal (interfaz D-Bus, lógica de permisos) |
| **xdg-desktop-portal-gnome** | Backend para GNOME (org.freedesktop.impl.portal.*) |
| **xdg-desktop-portal-kde** | Backend para KDE Plasma |
| **xdg-desktop-portal-wlr** | Backend para compositores wlroots (Sway, Wayfire…) |
| **xdg-desktop-portal-gtk / -hyprland** | Extra para Hyprland, etc. |
| **pipewire** | Graba/imita el stream de la pantalla en el portal |

## Instalación

```bash
# Debian/Ubuntu (GNOME)
sudo apt install xdg-desktop-portal xdg-desktop-portal-gnome pipewire

# KDE Plasma
sudo apt install xdg-desktop-portal xdg-desktop-portal-kde

# Fedora
sudo dnf install xdg-desktop-portal

# Arch Linux (instalar el backend del DE usado)
sudo pacman -S xdg-desktop-portal xdg-desktop-portal-gnome   # o -kde, -wlr

# Compositores wlroots (Sway, etc.)
sudo pacman -S xdg-desktop-portal xdg-desktop-portal-wlr
```

> Normalmente el portal y el backend correcto se instalan como dependencia de tu entorno de escritorio. Solo necesitas instalarlo manualmente en compositores minimalistas (p. ej. un WM/barrido wlroots).

## Configuración

### Elegir qué backend usa cada portal

Se puede forzar un backend en `~/.config/xdg-desktop-portal/portals/portal.conf` (o el global en `/usr/share`) y mediante variables de entorno:

```bash
# ~/.config/xdg-desktop-portal/portals/wlr.portal (conco: wlr por defecto)
[preferred]
default=wlr
```

### Ver portales disponibles

```bash
ls /usr/share/xdg-desktop-portal/portals/
```

## Comandos asociados

| Comando | Para qué |
|---|---|
| `systemctl --user status xdg-desktop-portal` | Estado del demonio (por usuario) |
| `systemctl --user restart xdg-desktop-portal` | Reiniciar el daemon |
| `journalctl --user -u xdg-desktop-portal -f` | Ver logs del portal |
| `dbus-monitor --session "type='signal'"` | Monitorizar llamadas D-Bus al portal |
| `ls /usr/share/xdg-desktop-portal/portals/` | Listar los `.portal` disponibles |
| `portal-bundle` | Ver qué backend corresponde |

## Comparativa / contextualización

| Aspecto | xdg-desktop-portal | captura X11 (clásica) | PipeWire crudo |
|---|---|---|---|
| **Enfoque** | API de permisos por sandbox | Global sin saneamiento | Graba stream de escritorio |
| **Control de acceso** | Sí (pide permiso) | No (acceso total) | Vía portal/señales |
| **Usado por Flatpak** | Sí (obligatorio) | No | En parte |
| **Esencial en Wayland** | Sí | No | Sí (screen sharing) |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Ciertas apps Flatpak no capturan pantalla en Sway/Hyprland | Falta backend wlr o no está el preferido | Instalar `xdg-desktop-portal-wlr` y definir `[preferred] default=wlr` |
| El portal no arranca | Daemon BORD / sesión sin sysess D-Bus | Reiniciar `systemctl --user restart xdg-desktop-portal` |
| Pantalla gris en screen share | PipeWire sin el módulo de captura | Asegurar `pipewire` ejecutándose y reiniciar sesión |
| Ventana de "guardar/abrir archivo" elegida en las apps | Flatpak sin portal de open | Instalar el backend del DE con `sudo apt install xdg-desktop-portal-gnome` (o kde) |

## Relación con Flatpak

xdg-desktop-portal es el puente que permite a una app **Flatpak en sandbox** hacer cosas del escritorio. Sin él, las apps Flatpak no podrían abrir archivos con el dialogo del sistema, notificar, imprimir ni capturar pantalla. Por eso conviene leer [[Flatpak]] (permisos vía `flatpak override`).

## Enlaces externos

- [freedesktop.org — xdg-desktop-portal](https://flatpak.github.io/xdg-desktop-portal/)
- [Documentación XDG Desktop Portal](https://flatpak.github.io/xdg-desktop-portal/docs/)
- [Portal de screenshots / PipeWire](https://wiki.archlinux.org/title/Screen_capture#Portal)
- [Arch Wiki — xdg-desktop-portal](https://wiki.archlinux.org/title/Xdg-desktop-portal)
- [GitHub — xdg-desktop-portal](https://github.com/flatpak/xdg-desktop-portal)

## Ver también

- [[Flatpak]] — formato de apps donde el portal es vital
- [[Compatibilidad Wayland]] — cómo encaja en el ecosistema Wayland
- [[PipeWire]] — middleware de audio/vídeo que graba la pantalla
- [[Wayland vs X11]] — por qué Wayland necesita portales

#programa #wayland #flatpak