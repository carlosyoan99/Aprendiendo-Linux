---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL
alternativas: Thunar, Nautilus, SpaceFM, nnn, ranger
---

# PCManFM

> Gestor de archivos gráfico **ultraligero** basado en GTK. Es el gestor por defecto de **LXDE** y una opción popular en WMs minimalistas como [[Openbox]] o [[i3]] cuando se prefiere GUI sobre terminal ([[ranger]], [[nnn]]). Consume ~15 MB de RAM y arranca instantáneamente.

## Qué es

PCManFM (PCMan File Manager) es un gestor de archivos que prioriza **ligereza y velocidad** sobre funcionalidad avanzada. Usa GTK2 (o GTK3 en versiones recientes) y se integra nativamente con GVfs para montaje de dispositivos y redes. Es la columna vertebral del escritorio LXDE (junto con Openbox).

- **Motor**: GTK2/GTK3
- **Dependencias mínimas**: PCManFM-qt (Qt), pcmanfm (GTK)
- **Integración**: GVfs, udisks,管理 de escritorio opcional
- **Ideal para**: hardware viejo, WMs minimalistas, LXDE/LXQt

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install pcmanfm` |
| Arch | `sudo pacman -S pcmanfm` |
| Fedora | `sudo dnf install pcmanfm` |
| openSUSE | `sudo zypper install pcmanfm` |
| Void | `sudo xbps-install -S pcmanfm` |
| Alpine | `sudo apk add pcmanfm` |
| Flatpak | `flatpak install flathub org.pcmanfm.pcmanfm` |

## Características

- **Ligero**: consume ~15 MB de RAM, arranque instantáneo
- **Pestañas**: múltiples directorios en una sola ventana
- **Vista de iconos y miniaturas**: previsualización de imágenes
- **Gestión de escritorio opcional**: puede manejar los iconos del escritorio (se desactiva si usas otro gestor)
- **Soporte de complementos**: extensiones para acciones personalizadas
- **Montaje de dispositivos**: detecta e integra USBs, discos externos vía GVfs/udisks
- **Navegación por historial**: botones atrás/adelante
- **Marcadores**: acceso rápido a directorios frecuentes

## Atajos principales

| Atajo | Acción |
|---|---|
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+W` | Cerrar pestaña |
| `Ctrl+F` | Buscar archivos |
| `Ctrl+H` | Mostrar archivos ocultos |
| `F2` | Renombrar |
| `F5` | Refrescar vista |
| `Del` | Mover a papelera |
| `Ctrl+L` | Abrir barra de ubicación (type path) |
| `Ctrl+Shift+C` | Copiar ruta del archivo |
| `Alt+←` / `Alt+→` | Navegar atrás/adelante |

## Configuración

```bash
# Archivos de configuración
~/.config/pcmanfm/default/pcmanfm.conf    # Config principal
~/.config/libfm/libfm.conf                # Config de libfm

# Cambiar tema de iconos
# Editar ~/.config/libfm/libfm.conf:
[config]
quick_list_mode=places

# Desactivar gestión de escritorio (si usas otro WM)
# En autostart: pcmanfm --disable-desktop

# Abrir en un directorio específico
pcmanfm /ruta/deseada/

# Gestión de escritorio con fondo
pcmanfm --desktop --profile LXDE
pcmanfm --wallpaper-mode=stretch
```

## Ventajas

- Extremadamente ligero: funciona en hardware con 256 MB de RAM
- Integración con Openbox (LXDE los usa juntos por defecto)
- Pestañas funcionales sin perder rendimiento
- Previsualización de imágenes sin ralentizaciones
- GVfs integrado: acceso a SMB, SSH, FTP desde el gestor

## Desventajas

- Interfaz visualmente simple (poco moderna)
- Sin vista dividida (split panel) nativa
- Sin soporte de plugins tan amplio como Nemo o Dolphin
- GTK2 por defecto (versión más antigua, menos integración con Wayland)

## Comparativa con alternativas

| Aspecto | PCManFM | Thunar | Nautilus | SpaceFM | nnn |
|---|---|---|---|---|---|
| **RAM** | ~15 MB | ~30 MB | ~50 MB | ~30 MB | ~3 MB |
| **Pestañas** | ✅ | ✅ | ❌ | ✅ | ❌ |
| **Split panel** | ❌ | ❌ | ❌ | ✅ | ✅ |
| **GVfs** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Plugins** | Pocos | Thunar-actions | Extensiones | Scripts | Config |
| **Ideal para** | LXDE, WMs | XFCE | GNOME | Power users | Terminal |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No monta USBs | GVfs/udisks no instalado | `sudo apt install gvfs udisks2` |
| Miniaturas no aparecen | Falta `gnome-desktop` o configuración | Habilitar en Preferencias → Vista |
| Iconos del escritorio desaparecen | Gestión de escritorio desactivada | Ejecutar `pcmanfm --desktop` o desactivar en autostart |
| `pcmanfm` muy lento en directorios grandes | Generación de miniaturas | Desactivar miniaturas en Preferencias |
| No accede a SMB/SSH | GVfs no configurado o sin backends | Instalar `gvfs-backends`, usar `smb://` en la barra de ubicación |
| Se cierra al cerrar última pestaña | Configuración por defecto | Cambiar en pcmanfm.conf: `always_show_tabs=1` |

## Ver también

- [[Thunar]] — gestor de XFCE, similar en peso
- [[Nautilus]] — gestor de GNOME
- [[SpaceFM]] — gestor ligero con más funcionalidades
- [[Gestores de Archivos]] — índice + comparativa
- [[Openbox]] — WM que acompaña PCManFM en LXDE

## Enlaces externos

- [Sitio oficial](https://wiki.lxde.org/es/PCManFM)
- [Wikipedia — PCManFM](https://en.wikipedia.org/wiki/PCManFM)
- [Arch Wiki — PCManFM](https://wiki.archlinux.org/title/PCManFM)
- [GitHub — pcmanfm](https://github.com/nicman23/pcmanfm)

#programa #archivos
