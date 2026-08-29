---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: media
licencia: GPL-2.0+
alternativas: [[PCManFM]], [[Nautilus]], [[Nemo]]
---

# Thunar

> Gestor de archivos por defecto de [[XFCE]]: ligero, rápido y sencillo, ideal para equipos con pocos recursos o WMs minimalistas que prefieren una GUI ligera.

## Qué es

**Thunar** es el gestor de archivos del entorno [[XFCE]], escrito en **C/GIO/GTK**. Su objetivo principal es la **velocidad y el bajo consumo de recursos**, arrancando casi al instante y usando muy poca RAM (~15 MB). Funciona de forma independiente en cualquier escritorio o ventana y es la opción preferida en **máquinas antiguas, netbooks o sistemas embebidos**. Está orientado al usuario que busca un gestor estable y minimalista, sin abandonar funciones útiles como pestañas, renombrado batch (gracias a extensiones) y una buena integración con el escritorio XFCE.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install thunar

# Arch
sudo pacman -S thunar

# Fedora
sudo dnf install thunar

# Flatpak (opcional)
flatpak install flathub org.xfce.Thunar
```

## Configuración básica

La configuración se guarda en `~/.config/xfce4/` (ficheros `thunar/*.rc`). Primeros pasos:

```bash
# Abrir Thunar en la carpeta actual
thunar .

# Abrir el gestor de renombrado por lotes
thunar -R

# Establecer Thunar como gestor de archivos por defecto
xdg-mime default thunar.desktop inode/directory
```

Añade los complementos más usados: `thunar-archive-plugin`, `thunar-media-tags-plugin`, `thunar-volman` y `thunar-renamer`.

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+W` | Cerrar pestaña |
| `Ctrl+F` | Buscar |
| `Ctrl+D` | Marcar favorito |
| `Ctrl+L` | Ir a la barra de ubicaciones |
| `F2` | Renombrar |
| `Ctrl+Shift+N` | Nueva carpeta |
| `Ctrl+H` | Mostrar archivos ocultos |

## Uso avanzado

```bash
# Renombrado por lotes desde línea de comandos (thunar-renamer)
thunar-renamer --path=/ruta/con/archivos

# Búsqueda por nombre/patrón
thunar /ruta --search "patrón"

# Definir qué aplicación abre un tipo de archivo
thunar-collect-modules
```

Los scripts personalizados se colocan en `~/.config/Thunar/` y se pueden añadir acciones personalizadas desde el menú *Editar → Configurar acciones*.

## Comparativa con alternativas

| Aspecto | Thunar | PCManFM | Nautilus |
|---|---|---|---|
| **Rendimiento** | Muy alto | Muy alto | Medio |
| **Facilidad** | Alta | Alta | Muy alta |
| **Características** | Moderadas | Moderadas | Básicas |
| **Licencia** | GPL-2.0 | GPL-2.0 | GPL-3.0 |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| No hay renombrado batch | Falta `thunar-renamer` | Instalarlo y reiniciar Thunar |
| Los discos/volúmenes no aparecen | Falta `thunar-volman` | Instalarlo y reiniciar el gestor |
| No abre comprimidos | Falta `thunar-archive-plugin` | Instalarlo y configurar la acción |

## Notas y advertencias

- Es extremadamente ligero y estable, ideal para equipos muy lentos.
- Al fijarse en la simplicidad, carece de *split panel* y terminal integrada (opción GNU Emacs/GUI contraparte).
- Se integra de forma natural con el escritorio **XFCE** y funciona bien en WMs con otras barras.

## Enlaces externos

- [Thunar — Documentación XFCE](https://docs.xfce.org/xfce/thunar/start)
- [Wikipedia — Thunar](https://en.wikipedia.org/wiki/Thunar)
- [Arch Wiki — Thunar](https://wiki.archlinux.org/title/Thunar)

## Ver también

- [[Nautilus]] — gestor de GNOME
- [[Dolphin]] — gestor de KDE, más potente
- [[PCManFM]] — alternativa ultra-ligera
- [[Nemo]] — fork con más opciones
- [[XFCE]] — entorno de escritorio asociado
- [[Gestores de Archivos]] — índice + comparativa

#programa #archivos
