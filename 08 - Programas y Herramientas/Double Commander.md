---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# Double Commander

Gestor de archivos de **dos paneles** (estilo Total Commander / Norton Commander), multiplataforma. Ideal para quienes vienen del mundo Windows y están acostumbrados a la interfaz de dos paneles con lista vertical.

## Instalación

```bash
sudo apt install doublecmd-gtk   # GTK (recomendado en GNOME)
sudo apt install doublecmd-qt    # Qt (recomendado en KDE)
sudo pacman -S doublecmd         # Arch (paquete unificado)
sudo dnf install doublecmd       # Fedora
```

## Atajos principales

| Atajo | Acción |
|---|---|
| `F3` | Ver archivo |
| `F4` | Editar archivo |
| `F5` | Copiar |
| `F6` | Mover |
| `F7` | Crear carpeta |
| `F8` | Eliminar |
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+Left/Right` | Navegar paneles |
| `Ctrl+\\` | Ir a raíz |
| `Alt+F1/F2` | Cambiar unidad/raíz en panel izquierdo/derecho |

## Características

- **Dos paneles laterales**: orientación horizontal y vertical intercambiable
- **Pestañas en cada panel**: organiza múltiples directorios abiertos
- **Operaciones en segundo plano**: copiar/mover sigue mientras trabajas
- **Comparación de archivos**: diff visual integrado (binario y texto)
- **Soporte de plugins**: WFX (sistemas de archivos), WCX (empaquetadores), WLX (visores)
- **Multiplataforma**: Linux, Windows, macOS, FreeBSD
- **Multi-rename tool**: renombrado masivo con expresiones regulares
- **Búsqueda avanzada**: por contenido, regex, fecha, tamaño, atributos
- **Conexiones de red**: FTP, SFTP, SCP, WebDAV, SMB integradas (plugins)
- **Historial de directorios**: navegación hacia atrás/adelante como en un navegador

## Ventajas

- Experiencia casi idéntica a Total Commander (quien viene de Windows no nota la diferencia)
- Operaciones en segundo plano sin bloquear la interfaz
- Plugins que extienden funcionalidades (ver imágenes, empaquetar, conexiones)
- Muy estable, años de desarrollo

## Desventajas

- Interfaz menos moderna que Dolphin o Nemo
- Dependencia de plugins para algunas conexiones de red
- No tiene vista integrada de miniaturas tan pulida como Nautilus

## Ver también

- [[Nautilus]] — gestor de panel único, integración GNOME
- [[Dolphin]] — gestor con split panel nativo (KDE)
- [[Gestores de Archivos]] — índice + comparativa
- [[Thunar]] — gestor ligero de XFCE

## Enlaces externos

- [Sitio oficial](https://doublecmd.sourceforge.io/)
- [GitHub](https://github.com/doublecmd/doublecmd)
- [Plugins disponibles](https://doublecmd.sourceforge.io/plugins/)

#programa #archivos
