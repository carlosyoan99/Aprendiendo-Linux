---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: DE
---

# Budgie

## Qué es

**Budgie** es un escritorio moderno y elegante desarrollado originalmente por el proyecto **Solus**. Escrito en **GTK 3/4**, sigue una filosofía similar a GNOME pero con un flujo de trabajo más tradicional: panel inferior con menú de aplicaciones, lista de ventanas y bandeja del sistema.

Creado por **Ikey Doherty** en 2014 como el escritorio nativo de Solus. Desde 2022 es mantenido por **Buddies of Budgie**, un equipo independiente de Solus.

## Filosofía

- **Moderno pero tradicional**: interfaz limpia y actual sin sacrificar productividad
- **Integración GNOME**: usa el stack de GNOME (GTK, Mutter, GLib) pero con personalidad propia
- **Flexibilidad sin complicación**: configurable sin ser abrumador
- **Raven**: centro de control lateral todo-en-uno (notificaciones, calendario, volumen, config rápida)

## Características clave

| Aspecto | Detalle |
|---|---|
| **Tipo** | Entorno de escritorio completo |
| **Toolkit** | GTK 3/4 |
| **Motor de ventanas** | Mutter (de GNOME) |
| **Panel** | Budgie Panel (menú, tareas, bandeja) |
| **Centro lateral** | Raven (notificaciones, calendario, audio) |
| **Wayland** | Experimental (estable la vía X11) |
| **RAM en idle** | ~600-800 MB |

## Componentes clave

### Budgie Panel

Panel altamente configurable con múltiples secciones:

- **Main menu**: menú de aplicaciones con categorías y búsqueda
- **Icon task list**: ventanas abiertas (similar a Windows 7+)
- **System tray**: indicadores de red, sonido, batería
- **Workspace switcher**: cambiar entre escritorios virtuales

### Raven

Panel lateral deslizante con:

- **Notificaciones**: historial de notificaciones del sistema
- **Calendario**: vista de calendario con eventos
- **Sonido**: control de volumen y fuentes de audio
- **Bluetooth**: dispositivos emparejados
- **Config rápida**: Wi-Fi, VPN, No molestar, Noche

## Instalación

```bash
# Debian/Ubuntu
sudo apt install budgie-desktop

# Arch Linux
sudo pacman -S budgie

# Fedora
sudo dnf install budgie-desktop

# openSUSE
sudo zypper install budgie-desktop

# Solus (nativo, preinstalado)
sudo eopkg install budgie-desktop
```

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `Super+Space` | Menú de aplicaciones |
| `Super+A` | Raven (notificaciones) |
| `Super+Tab` | Cambiar entre ventanas |
| `Super+D` | Mostrar escritorio |
| `Super+L` | Bloquear pantalla |
| `Ctrl+Alt+T` | Terminal |

## Personalización

```bash
# Budgie Desktop Settings
budgie-desktop-settings

# Instalar applets adicionales
# Desde Budgie Settings → Applets → Añadir

# Applets populares:
# - Budgie Workspace Switcher
# - Budgie User Indicator
# - Budgie Trash
# - Night Light
# - Network Manager
# - PulseAudio
```

## Comparativa con otras DEs

| Aspecto | Budgie | GNOME | XFCE |
|---|---|---|---|
| **Filosofía** | Moderno + tradicional | Moderno minimalista | Clásico ligero |
| **Panel** | Inferior clásico | Actividades (sin panel) | Inferior clásico |
| **RAM idle** | ~600-800 MB | ~1-1.2 GB | ~300-500 MB |
| **Toolkit** | GTK 3/4 | GTK 4 | GTK 3 |
| **Centro de control lateral** | Sí (Raven) | No | No |
| **Wayland** | Experimental | Nativo | En desarrollo |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Panel no responde tras instalar applets | Applet roto | Reiniciar sesión o `budgie-desktop-settings` → quitar applet |
| Sin notificaciones | Raven deshabilitado | `Super+A` y comprobar "No molestar" |
| Fondo no cambia | Config de pantalla | Ajustar en Settings → Escritorio → Fondo |
| Refresco de panel lento | Poco hardware | Desactivar efectos y reducir applets |

## Notas personales

- Budgie me parece el equilibrio perfecto entre modernidad y tradición. Tiene el aspecto limpio de GNOME pero con un panel inferior funcional desde el primer día.
- Raven (el panel lateral) es una idea excelente: notificaciones, calendario, volumen y configuración rápida en un solo sitio, accesible con `Super+A`.
- La separación de Budgie de Solus en 2022 (Buddies of Budgie) fue buena para el proyecto — ahora se actualiza independientemente y llega a más distros.
- Si te gusta GNOME pero el flujo de actividades no te convence, Budgie es una alternativa perfecta.

## Ver también

- [[GNOME]] — base técnica (Mutter, GTK)
- [[Solus]] — distro donde nació Budgie
- [[XFCE]] — alternativa ligera
- [[Comparativa entornos de escritorio]] — comparativa de todos los DEs

## Enlaces externos

- [Buddies of Budgie — Página oficial](https://buddiesofbudgie.org/)
- [Budgie Desktop — GitHub](https://github.com/BuddiesOfBudgie/budgie-desktop)
- [Solus Project](https://getsol.us/)
- [Wikipedia — Budgie](https://en.wikipedia.org/wiki/Budgie_(desktop_environment))

#entorno-escritorio
