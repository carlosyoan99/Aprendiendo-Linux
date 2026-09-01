---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL
alternativas: PCManFM, Thunar, Double Commander, nnn
---

# SpaceFM

> Gestor de archivos gráfico con pestañas y vista dividida, basado en GTK. Similar a [[PCManFM]] pero con más funcionalidades integradas: paneles duales, plugins de usuario, gestor de dispositivos sin GVfs y diseño modular.

## Qué es

SpaceFM es un gestor de archivos que combina la **ligereza de GTK** con funcionalidades de power users: vista dividida (dual pane), cada panel con sus propias pestañas, plugins escritos como scripts bash integrados en el menú contextual, y un gestor de dispositivos propio que **no depende de GVfs**. Diseñado para ser autosuficiente.

- **Motor**: GTK2
- **Filosofía**: autosuficiente (sin GVfs, sin udisks2 estricto)
- **Plugins**: scripts bash ejecutables desde el menú contextual
- **Ideal para**: usuarios que quieren potencia sin depender del ecosistema GNOME

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install spacefm` |
| Arch | `sudo pacman -S spacefm` |
| Fedora | `sudo dnf install spacefm` |
| openSUSE | `sudo zypper install spacefm` |
| Void | `sudo xbps-install -S spacefm` |
| Alpine | `sudo apk add spacefm` |

## Características

- **Vista dividida**: dos paneles en una misma ventana (modo dual pane)
- **Pestañas**: cada panel puede tener sus propias pestañas
- **Plugins integrados**: scripts de usuario con integración en el menú contextual (`F4` para crear nuevos plugins)
- **Gestión de dispositivos**: montar/desmontar USBs, discos, imágenes ISO desde la interfaz
- **Diseñado para ser autosuficiente**: no depende de GVfs para montar dispositivos (usa udev + udisks)
- **Diálogo de búsqueda avanzada**: por nombre, contenido, regex, fecha
- **Tareas en segundo plano**: copiar/mover con barra de progreso sin bloquear la interfaz
- **Marcadores y historial**: acceso rápido a directorios frecuentes

## Atajos principales

| Atajo | Acción |
|---|---|
| `Ctrl+T` | Nueva pestaña |
| `F3` | Vista dividida (toggle) |
| `F4` | Editor de plugins |
| `F5` | Refrescar |
| `Ctrl+F` | Buscar archivos |
| `Ctrl+H` | Mostrar/ocultar ocultos |
| `Ctrl+D` | Añadir a marcadores |
| `Ctrl+L` | Barra de ubicación (type path) |
| `Ctrl+Shift+C` | Copiar ruta completa |
| `Alt+←` / `Alt+→` | Navegar atrás/adelante |

## Configuración

```bash
# Archivos de configuración
~/.config/spacefm/spacefm.conf           # Config principal
~/.config/spacefm/*.panel                # Config por panel

# Plugins: crear un script ejecutable en:
~/.config/spacefm/plugins/

# Ejemplo de plugin: "Abrir en terminal aquí"
# Crear ~/.config/spacefm/plugins/open-terminal.sh:
#!/bin/bash
gnome-terminal --working-directory="$PWD"

# Desactivar gestión de escritorio
spacefm --desktop=off

# Abrir con vista dividida
spacefm -2

# Abrir en directorio específico
spacefm /ruta/deseada/
```

### Crear un plugin

```bash
# Los plugins son scripts bash en ~/.config/spacefm/plugins/
# Se ejecutan con clic derecho → Plugins → [nombre del script]

# Ejemplo: comprimir selección en .tar.gz
#!/bin/bash
tar -czf "${FM_SEL_FILES[*]}.tar.gz" "${FM_SEL_FILES[@]}"
echo "Comprimido: ${FM_SEL_FILES[*]}.tar.gz"

# Variables disponibles en plugins:
# $FM_SCRIPT        - ruta del script
# $FM_PANEL         - panel activo (0 o 1)
# $FM_TAB           - pestaña activa
# $FM_CURRENT_FILE  - archivo bajo el cursor
# $FM_SEL_FILES     - archivos seleccionados (array)
```

## Ventajas

- No depende de GVfs → funciona incluso en entornos sin GNOME
- Gestión de dispositivos superior a PCManFM
- Vista dividida nativa (a diferencia de PCManFM o Thunar)
- Plugins con editor integrado (scripts personalizados fácilmente)
- Montaje de dispositivos vía udev (sin GVfs)

## Desventajas

- Interfaz menos pulida que Nautilus o Dolphin
- Proyecto con desarrollo menos activo en los últimos años
- Consume ~30 MB de RAM (más que PCManFM pero aún ligero)
- Sin integración con GVfs → problemas con montajes SMB/FUSE
- GTK2 (sin soporte Wayland nativo)

## Comparativa con alternativas

| Aspecto | SpaceFM | PCManFM | Thunar | Double Commander | nnn |
|---|---|---|---|---|---|
| **RAM** | ~30 MB | ~15 MB | ~30 MB | ~40 MB | ~3 MB |
| **Split panel** | ✅ | ❌ | ❌ | ✅ | ✅ |
| **Plugins** | Scripts bash | Pocos | Thunar-actions | Lister plugins | Config |
| **GVfs** | ❌ (udev) | ✅ | ✅ | ❌ | ❌ |
| **Pestañas** | ✅ (por panel) | ✅ | ✅ | ✅ | ❌ |
| **Ideal para** | Power users | LXDE, WMs | XFCE | DOS-like | Terminal |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No monta USBs | udev/udisks no configurados | Instalar `udisks2`, verificar reglas udev |
| Plugins no aparecen | No están en `~/.config/spacefm/plugins/` o sin permiso +x | `chmod +x ~/.config/spacefm/plugins/*.sh` |
| Barra de tareas no refresca | SpaceFM no gestiona escritorio | Ejecutar `spacefm --desktop` o configurar en autostart |
| Muy lento en directorios con miles de archivos | Búsqueda de miniaturas | Desactivar miniaturas en Preferencias |
| No accede a SMB/NFS | Sin GVfs (diseño intencional) | Usar `mount.cifs` manual o instalar `gvfs` + symlink |
| Errores "No se puede mostrar" en archivos | Falta `libfm` o versión incompatible | Reinstalar `libfm4` y `libfm-gtk4` |

## Ver también

- [[PCManFM]] — alternativa más ligera
- [[Thunar]] — gestor de XFCE
- [[Double Commander]] — gestor de dos paneles (teclas)
- [[Gestores de Archivos]] — índice + comparativa

## Enlaces externos

- [Sitio oficial](https://ignorantguru.github.io/spacefm/)
- [GitHub](https://github.com/IgnorantGuru/spacefm)
- [Wikipedia — SpaceFM](https://en.wikipedia.org/wiki/SpaceFM)
- [Arch Wiki — SpaceFM](https://wiki.archlinux.org/title/SpaceFM)

#programa #archivos
