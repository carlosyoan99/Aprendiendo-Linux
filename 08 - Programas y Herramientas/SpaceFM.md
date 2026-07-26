---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# SpaceFM

Gestor de archivos gráfico con pestañas, basado en **GTK**. Similar a [[PCManFM]] pero con más funcionalidades integradas: vista dividida, plugins, gestor de dispositivos y diseño modular.

## Instalación

```bash
sudo apt install spacefm         # Debian/Ubuntu
sudo pacman -S spacefm           # Arch
sudo dnf install spacefm         # Fedora
```

## Características

- **Vista dividida**: dos paneles en una misma ventana (modo dual pane)
- **Pestañas**: cada panel puede tener sus propias pestañas
- **Plugins integrados**: scripts de usuario con integración en el menú contextual (<kbd>F4</kbd> para crear nuevos plugins)
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

## Ventajas

- No depende de GVfs → funciona incluso en entornos sin GNOME
- Gestión de dispositivos superior a PCManFM
- Vista dividida nativa (a diferencia de PCManFM o Thunar)
- Plugins con editor integrado (scripts personalizados fácilmente)

## Desventajas

- Interfaz menos pulida que Nautilus o Dolphin
- Proyecto con desarrollo menos activo en los últimos años
- Consume ~30 MB de RAM (más que PCManFM pero aún ligero)
- Sin integración con GVfs → problemas con montajes SMB/FUSE

## Ver también

- [[PCManFM]] — alternativa ligera
- [[Thunar]] — gestor de XFCE
- [[Double Commander]] — gestor de dos paneles (teclas)
- [[Gestores de Archivos]] — índice + comparativa

## Enlaces externos

- [Sitio oficial](https://ignorantguru.github.io/spacefm/)
- [GitHub](https://github.com/IgnorantGuru/spacefm)
- [Wikipedia — SpaceFM](https://en.wikipedia.org/wiki/SpaceFM)

#programa #archivos
