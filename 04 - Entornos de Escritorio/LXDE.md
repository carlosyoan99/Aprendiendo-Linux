---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: DE
---

# LXDE

> Entorno de escritorio ultra-ligero basado en GTK 2. Ideal para hardware muy antiguo y máquinas con <512 MB de RAM. Sucesor espiritual: [[LXQt]].

## Qué es

**LXDE** (Lightweight X11 Desktop Environment) es un entorno de escritorio minimalista y rápido, diseñado para consumir la menor cantidad de recursos posible. Usa GTK 2 (toolkit legacy) y Openbox como gestor de ventanas. Fue creado por **Hong Jen Yee** (PCMan) en 2006.

Entre 2008 y 2018 fue el escritorio por defecto de **Lubuntu**, hasta que la distribución migró a LXQt. El proyecto LXDE está en **mantenimiento** — no recibe nuevas funcionalidades, solo parches de seguridad.

> **Estado**: 🟡 Mantenimiento (no activo). Se recomienda [[LXQt]] (sucesor moderno) o [[XFCE]] para instalaciones nuevas.

## Filosofía

- **Minimalismo extremo**: consume ~200-350 MB RAM en reposo
- **GTK 2**: toolkit legacy, sin dependencias pesadas
- **Modular**: cada componente es independiente y reemplazable
- **Rápido**: funciona en CPUs de un solo núcleo y HDDs lentos

## Componentes

| Componente | Nombre | Función |
|---|---|---|
| **Gestor ventanas** | Openbox | WM minimalista configurable |
| **Panel** | LXPanel | Panel con menú, lanzadores, bandeja |
| **Gestor archivos** | PCManFM | Gestor de archivos ligero con pestañas |
| **Terminal** | LXTerminal | Terminal sin pestañas (muy ligero) |
| **Editor texto** | Leafpad | Editor minimalista (tipo Notepad) |
| **Visor imágenes** | GPicView | Visor de imágenes ultraligero |
| **Gestor sesión** | LXSession | Gestión de sesión, salvado al cerrar |
| **Centro control** | LXAppearance | Temas GTK, iconos, fuentes |
| **Gestor redes** | Wicd (o Connman) | Conexiones WiFi/red (alternativa a NetworkManager) |
| **Captura pantalla** | LXShortCut | Atajos y capturas |

## Instalación

```bash
# Debian/Ubuntu (LXDE)
sudo apt install lxde                # escritorio completo
sudo apt install lxde-core           # solo lo esencial (sin extras)

# Arch Linux
sudo pacman -S lxde                  # grupo completo
# O manualmente:
sudo pacman -S lxde-common openbox lxpanel pcmanfm lxterminal

# Fedora (LXDE spin)
sudo dnf group install "LXDE Desktop"

# openSUSE
sudo zypper install -t pattern lxde
```

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `Alt+F1` | Menú de aplicaciones (LXPanel) |
| `Alt+F2` | Ejecutar comando |
| `Alt+Tab` | Cambiar entre ventanas |
| `Alt+F4` | Cerrar ventana |
| `Super+D` | Mostrar escritorio |
| `Ctrl+Alt+T` | Terminal (LXTerminal) |
| `Alt+Space` | Menú de ventana (mover, redimensionar) |

Los atajos se configuran desde Configuración → Atajos de teclado o editando `~/.config/openbox/lxde-rc.xml`.

## Personalización

```bash
# Configuración de apariencia (temas GTK, iconos, fuentes)
lxappearance

# Configuración del panel
lxpanelctl config
# O editar manualmente:
# ~/.config/lxpanel/LXDE/panels/panel

# Temas de Openbox (decoraciones de ventana)
# ~/.themes/ o /usr/share/themes/
```

### Temas recomendados

LXDE usa temas GTK 2 (no compatibles con GTK 3 sin capa de compatibilidad):

| Tema | Instalación |
|---|---|
| **Clearlooks** | Viene por defecto en la mayoría de distros |
| **Raleigh** | Tema clásico mínimo |
| **Numix** (GTK 2) | `sudo apt install numix-gtk-theme` (con soporte GTK 2) |

## LXDE vs LXQt vs XFCE

| Aspecto | LXDE | LXQt | XFCE |
|---|---|---|---|
| **Toolkit** | GTK 2 (legacy) | Qt 5/6 | GTK 3 |
| **RAM idle** | ~200-350 MB | ~250-400 MB | ~350-500 MB |
| **Gestor ventanas** | Openbox | Openbox | XFWM |
| **Estado** | 🟡 Mantenimiento | ✅ Activo | ✅ Activo |
| **Wayland** | ❌ No | En desarrollo | Experimental |
| **Estética** | Anticuada (GTK 2) | Moderna (Qt) | Equilibrada |
| **Componentes** | Ligeros pero antiguos | Modernos y ligeros | Maduros y completos |
| **Arranque** | Muy rápido (~5s) | Rápido (~7s) | Rápido (~10s) |

## Distros que usan/usaron LXDE

| Distro | Estado |
|---|---|
| **Lubuntu** (hasta 18.04) | Migró a LXQt en 18.10 |
| **LXLE Linux** | Descontinuada |
| **Debian LXDE spin** | Disponible pero no oficial |
| **Fedora LXDE spin** | Mantenimiento comunitario |
| **Peppermint OS** (versiones antiguas) | Migró a XFCE |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Extremadamente ligero (~200 MB RAM) | GTK 2 — sin soporte de apps modernas (GTK 3/4) |
| Funciona en hardware de >15 años | Sin soporte Wayland |
| Arranque casi instantáneo | Estética anticuada por defecto |
| Componentes modulares y reemplazables | Sin nuevas funcionalidades (solo mantenimiento) |
| PCManFM sigue siendo excelente | LXTerminal sin pestañas |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| **LXAppearance no cambia temas GTK 3** | LXAppearance solo configura GTK 2 | Usar `gnome-tweaks` o `lxappearance-obconf` para GTK 3 |
| **Iconos rotos o cuadrados** | Faltan temas de iconos | `sudo apt install gnome-icon-theme` o `papirus-icon-theme` |
| **Panel no responde** | LXPanel se colgó | `killall lxpanel && lxpanel &` |
| **Fondo de pantalla no se muestra** | PCManFM no gestiona el escritorio | `pcmanfm --desktop &` o configurar en LXSession |
| **Openbox no guarda configuración** | Permisos de ~/.config/openbox/ | `chown -R $USER:$USER ~/.config/openbox/` |

## Notas personales

- LXDE fue mi primer DE en Linux (Lubuntu 12.04). En un Pentium 4 con 512 MB de RAM, arrancaba en ~10 segundos. Hoy sigue siendo útil para máquinas muy justas donde ni XFCE corre bien.
- PCManFM (gestor de archivos) es una joya: pesa ~5 MB en RAM y tiene pestañas, vista dividida, montaje de volumen con un clic.
- Leafpad es el editor de texto más minimalista que existe: abre en 0.2 segundos incluso en un Celeron.
- Para instalaciones nuevas ligeras, recomendaría [[LXQt]] o [[XFCE]] sobre LXDE. LXDE solo si el hardware es realmente limitado (<512 MB RAM).

## Enlaces externos

- [LXDE — Página oficial](https://lxde.org/)
- [Wikipedia — LXDE](https://en.wikipedia.org/wiki/LXDE)
- [LXDE SourceForge](https://sourceforge.net/projects/lxde/)
- [Arch Wiki — LXDE](https://wiki.archlinux.org/title/LXDE)
- [PCManFM en GitHub](https://github.com/lxde/pcmanfm)

## Ver también

- [[LXQt]] — sucesor moderno en Qt
- [[Lubuntu]] — distro que usó LXDE hasta 2018
- [[LXLE Linux]] — distro basada en Lubuntu+LXDE (descontinuada)
- [[XFCE]] — alternativa ligera en GTK 3
- [[Openbox]] — WM por defecto de LXDE
- [[Comparativa entornos de escritorio]] — comparativa de todos los DEs

#entorno-escritorio #ligero
