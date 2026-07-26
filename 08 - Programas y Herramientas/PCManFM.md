---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# PCManFM

Gestor de archivos gráfico muy ligero, basado en **GTK**. Es el gestor de archivos por defecto de **LXDE** y una opción popular en WMs minimalistas como [[Openbox]] o [[i3]] cuando se prefiere GUI sobre terminal ([[ranger]], [[nnn]]).

## Instalación

```bash
sudo apt install pcmanfm         # Debian/Ubuntu
sudo pacman -S pcmanfm           # Arch
sudo dnf install pcmanfm         # Fedora
```

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

## Ventajas

- Extremadamente ligero: funciona en hardware con 256 MB de RAM
- Integración con Openbox (LXDE los usa juntos por defecto)
- Pestañas funcionales sin perder rendimiento
- Previsualización de imágenes sin ralentizaciones

## Desventajas

- Interfaz visualmente simple (poco moderna)
- Sin vista dividida (split panel) nativa
- Sin soporte de plugins tan amplio como Nemo o Dolphin
- Sin integración profunda con GVfs (acceso a SMB, SSH desde el gestor)

## Ver también

- [[Thunar]] — gestor de XFCE, similar en peso
- [[Nautilus]] — gestor de GNOME
- [[SpaceFM]] — gestor ligero con más funcionalidades
- [[Gestores de Archivos]] — índice + comparativa

## Enlaces externos

- [Sitio oficial](https://wiki.lxde.org/es/PCManFM)
- [Wikipedia — PCManFM](https://en.wikipedia.org/wiki/PCManFM)

#programa #archivos
