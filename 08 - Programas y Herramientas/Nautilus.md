---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: media
licencia: GPL-3.0+
alternativas: [[Dolphin]], [[Nemo]], [[Thunar]]
---

# Nautilus (Files)

> Gestor de archivos por defecto de [[GNOME]]: también llamado GNOME Files, es el gestor gráfico más usado en distros como Ubuntu, Fedora Workstation y Debian.

## Qué es

**Nautilus** es el gestor de archivos oficial del escritorio [[GNOME]], construido sobre **GIO/GTK** y estrechamente integrado con el ecosistema de GNOME (tema Adwaita, portal de archivos y el demonio de escritorio). Es el gestor gráfico por defecto en distribuciones como **Ubuntu**, **Fedora Workstation** y **Debian** con GNOME. Su filosofía es la **simplicidad**: la interfaz se ha ido simplificando deliberadamente, priorizando una UX pulida sobre funciones avanzadas. Está orientado al usuario medio de escritorio que quiere un gestor estable y bien integrado, no a quienes buscan funciones de potencia máxima.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install nautilus

# Arch
sudo pacman -S nautilus

# Fedora
sudo dnf install nautilus

# Flatpak (cualquier distro)
flatpak install flathub org.gnome.Nautilus
```

## Configuración básica

La configuración se guarda en **GSettings** (dconf), gestionables con:

```bash
# Mostrar archivos ocultos por defecto
gsettings set org.gnome.nautilus.preferences show-hidden-files true

# Vista por defecto: lista
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

# Apertura de carpetas
gsettings set org.gnome.nautilus.preferences always-use-location-entry true
```

Primeros pasos: activar la barra de ubicaciones (`Ctrl+L`), marcar carpetas como favoritas (`Ctrl+D`) y añadir extensiones (`nautilus-*`) para ampliar funciones.

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `Ctrl+H` | Mostrar/ocultar archivos ocultos |
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+W` | Cerrar pestaña |
| `Ctrl+D` | Marcar favorito |
| `Ctrl+1` | Vista iconos |
| `Ctrl+2` | Vista lista |
| `Ctrl+L` | Ir a la barra de direcciones |
| `F2` | Renombrar |
| `Ctrl+A` | Seleccionar todo |
| `Ctrl+Shift+N` | Nueva carpeta |

## Uso avanzado

```bash
# Abrir una carpeta concreta
nautilus /ruta/al/directorio

# Abrir una ventana en la ubicación actual del terminal
nautilus .

# Buscar un archivo por nombre
nautilus --search "nombre"

# Abrir como administrador (requiere permisos)
pkexec nautilus
```

Las extensiones más útiles se instalan desde los repositorios: `nautilus-image-converter`, `nautilus-admin`, `nautilus-scripts` o `nautilus-dropbox`.

## Comparativa con alternativas

| Aspecto | Nautilus | Nemo | Dolphin |
|---|---|---|---|
| **Rendimiento** | Medio | Medio | Alto |
| **Facilidad** | Muy alta | Alta | Alta |
| **Características** | Básicas | Extensas | Muy extensas |
| **Licencia** | GPL-3.0 | GPL-2.0 | GPL-2.0 |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| No se ven las miniaturas | Previsualización desactivada | Activar en Preferencias → Vistas |
| No hay terminal integrada | Limitación de diseño | Instalar extensión o usar [[Nemo]] |
| Los favoritos no aparecen | Ruta de favoritos corrupta | Borrar `~/.config/gtk-3.0/bookmarks` |

## Notas y advertencias

- Está totalmente integrado con **GNOME**; usarlo en otro DE puede arrastrar dependencias GTK.
- Su diseño simplificado elimina funciones (split, terminal, renombrado batch) presentes en otros gestores.
- Funciona bien tanto en escritorios como en WMs, siempre que estén presentes los servicios de GTK.

## Enlaces externos

- [GNOME Files — Wiki de GNOME](https://wiki.gnome.org/Apps/Files)
- [Wikipedia — Nautilus](https://en.wikipedia.org/wiki/Nautilus_(file_manager))
- [Arch Wiki — GNOME Files](https://wiki.archlinux.org/title/GNOME_Files)

## Ver también

- [[Nemo]] — fork con más opciones
- [[Dolphin]] — gestor de KDE, más potente
- [[Thunar]] — alternativa ligera
- [[Atajos de teclado - Nautilus Thunar Dolphin]] — accesos rápidos por defecto
- [[GNOME]] — entorno de escritorio asociado
- [[Gestores de Archivos]] — índice + comparativa

#programa #archivos
