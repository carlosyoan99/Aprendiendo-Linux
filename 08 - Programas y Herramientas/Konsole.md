---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL-2.0+
alternativas: [[Xfce Terminal]], [[GNOME Terminal]]
---

# Konsole

> Terminal por defecto de KDE Plasma: potente y altamente configurable, con pestañas, splits, perfiles de SSH guardados y un consumo moderado.

## Qué es

**Konsole** (`konsole`) es el emulador de terminal oficial de **[[KDE Plasma]]**, parte de KDE Gear. Se caracteriza por ser **potente y muy configurable**: pestañas, **división de pantalla** (splits), perfiles de sesión guardados (p.ej. ubicaciones de SSH con comandos iniciales), transparencia y blur con el compositor KWin, y marcadores de directorios. Consume alrededor de **30 MB de RAM**, algo más que alternativas minimalistas, pero a cambio ofrece una de las terminales más completas del ecosistema Linux.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install konsole

# Arch
sudo pacman -S konsole

# Fedora
sudo dnf install konsole

# Flatpak
flatpak install flathub org.kde.konsole
```

## Configuración básica

- Los perfiles se crean desde **Settings → Edit Current Profile**.
- Los perfiles y configuración se almacenan en `~/.local/share/konsole/`.
- Se puede integrar completamente con el **tema Breeze** de KDE y su esquema de colores.

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+Shift+T` | Nueva pestaña |
| `Ctrl+Shift+Right/Left` | Cambiar de pestaña |
| `Ctrl+Shift+E` / `Ctrl+Shift+O` | Dividir horizontal / vertical |
| `Ctrl+Shift+W` | Cerrar vista actual |
| `Ctrl+Shift+F` | Buscar en la salida |
| `Ctrl+Shift+I` | Seleccionar siguiente marca (bookmark) |
| `Ctrl+Shift+S` | Cambiar perfil/sesión |

## Uso avanzado

```bash
# Lanzar Konsole con un perfil y comando específico
konsole --profile MiPerfil -e "ssh servidor"

# Abrir con varias pestañas o en un directorio
konsole --workdir /ruta

# Dividir la vista por línea de comandos
konsole --hold -e "htop"
```

- Los **perfiles de sesión** pueden guardar opciones como directorio inicial, comando al arrancar y esquema de colores.
- Soporta **marcadores avanzados** sobre la salida (bookmarking de líneas).

## Comparativa con alternativas

| Aspecto | Konsole | Xfce Terminal | GNOME Terminal |
|---|---|---|---|
| **Escritorio** | KDE | XFCE | GNOME |
| **Splits** | Sí | No | No |
| **Perfiles SSH/Proyectos** | Sí | Limitado | No |
| **Consumo/RAM** | ~30 MB | ~15 MB | ~20 MB |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| El blur/transparencia no aparece | Composición KWin desactivada | Activar la composición en Efectos del escritorio |
| Los perfiles de SSH no conectan | Falta guardar la sesión con host | Editar el perfil y añadir el comando SSH en "Comando inicial" |

## Notas y advertencias

- El proyecto KDE también ofrece **Yakuake**, una terminal desplegable tipo Quake basada en parte de Konsole.
- Por su integración y splits, es una de las mejores opciones para trabajo multitarea dentro de KDE.

## Enlaces externos

- [Konsole — KDE Aplicaciones](https://konsole.kde.org/)
- [Wikipedia — Konsole](https://en.wikipedia.org/wiki/Konsole)
- [Arch Wiki — Konsole](https://wiki.archlinux.org/title/Konsole)

## Ver también

- [[KDE Plasma]] — entorno de escritorio asociado
- [[Emuladores de Terminal]] — índice + comparativa
- [[GNOME Terminal]] — alternativa en GNOME
- Yakuake — terminal desplegable tipo Quake del proyecto KDE

#programa #terminal
