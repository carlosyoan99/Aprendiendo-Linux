---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: media
---

# Gestores de Archivos — Índice

> Un gestor de archivos permite navegar, copiar, mover y eliminar archivos con una interfaz visual, ya sea gráfica (GUI) o en la terminal (TUI). Cada DE trae su gestor gráfico por defecto; en WMs minimalistas se suele usar uno de terminal.

## Qué es

Un **gestor de archivos** es un programa que ofrece una interfaz para operar con el sistema de archivos: navegar entre carpetas, copiar, mover, renombrar, eliminar o buscar archivos de forma visual, sin depender de la línea de comandos. Puede ser **gráfico** (con ventanas e iconos, anclado a un entorno de escritorio) o de **terminal** (TUI), que se ejecuta dentro de un [[Emuladores de Terminal]] y se controla con el teclado. Los escritorios modernos traen su propio gestor por defecto, mientras que los WMs tiling dejan la elección total al usuario.

## Tipos de gestores

### Gráficos (GUI)

| Tipos | Característica distintiva |
|---|---|
| **Gestores de DE** | Anclados a la integración del escritorio (Nautilus→GNOME, Dolphin→KDE) |
| **Independientes** | Funcionan en cualquier escritorio/WM (PCManFM, Double Commander, SpaceFM) |
| **Dos paneles** | Comparar y transferir archivos entre carpetas (Double Commander, SpaceFM) |

### De terminal (TUI)

| Tipos | Característica distintiva |
|---|---|
| **Tipo vim** | Navegación por teclado con modos (ranger, lf) |
| **Ultraligeros** | Mínimo consumo y arranque instantáneo (nnn) |
| **Modernos con preview** | Vista previa rápida de imágenes/PDF (yazi) |

## Gestores gráficos

| Gestor | DE asociado | Split | Terminal integrada | Renombrado batch |
|---|---|---|---|---|
| [[Nautilus]] | [[GNOME]] | ❌ | ❌ | ❌ |
| [[Dolphin]] | [[KDE Plasma]] | ✅ (F3) | ✅ (F4) | ✅ |
| [[Thunar]] | [[XFCE]] | ❌ | ❌ | ✅ (plugin) |
| [[Nemo]] | [[Cinnamon]] | ✅ (F3) | ✅ (F4) | ✅ |
| [[PCManFM]] | — | ❌ | ❌ | ❌ |
| [[Double Commander]] | — | ✅ | ❌ | ❌ |
| [[SpaceFM]] | — | ✅ | ❌ | ❌ |

## Gestores de terminal (TUI)

Cuando usas [[i3]], [[DWM]], [[Hyprland]] o [[Niri]], los gestores gráficos pueden no estar instalados. Alternativas en terminal:

| Gestor | Lenguaje | Destaca por |
|---|---|---|
| [[ranger]] | Python | Tipo vim, preview panel derecho |
| [[nnn]] | C | Ultra-ligero, teclas configurables |
| [[yazi]] | Rust | Preview rápida de imágenes y PDFs |
| [[lf]] | Go | Rápido, configuración minimalista |

## Cómo elegir

- **Si usas un DE** ([[GNOME]], [[KDE Plasma]], [[XFCE]], [[Cinnamon]]), lo más cómodo es quedarte con el gestor predeterminado por la integración con el escritorio.
- **Si usas un WM tiling** ([[i3]], [[DWM]], [[Hyprland]], [[Niri]]), no hay gestor por defecto: elige uno GUI ligero ([[Thunar]], [[PCManFM]]) o uno TUI ([[nnn]], [[ranger]], [[yazi]]).
- **Rendimiento > funciones**: un TUI supera a la mayoría de GUIs en recursos, pero exige aprender atajos.
- **Funciones de potencia**: el *split panel* y la terminal integrada están en [[Dolphin]] (KDE) y [[Nemo]] (Cinnamon).

## Formato de archivos y URL

Los gestores gráficos suelen soportar **URI schemes** como `file:///ruta` en la barra de direcciones y la apertura de carpetas remotas (sftp, smb) mediante puertas de enlace de GNOME/KDE. En un TUI la navegación se hace únicamente por rutas de archivo locales, o a través de montajes remotos del sistema.

## Notas de uso

- En WMs tiling, no hay un gestor de archivos por defecto. Tienes que elegir e instalar uno.
- Los gestores de terminal como `nnn` o `yazi` son extremadamente eficientes para tareas repetitivas una vez aprendidos los atajos.
- `dolphin` con terminal integrada (`F4`) elimina la necesidad de cambiar de ventana entre terminal y gestor.
- Para tareas de automatización, la línea de comandos ([[La Shell]]) sigue siendo el método más potente y portable.

## Notas personales

-

## Ver también

- [[Emuladores de Terminal]]
- [[La Shell]]
- [[Editores de Texto]]
- [[i3]]
- [[Hyprland]]

## Enlaces externos

- [Wikipedia — File manager](https://en.wikipedia.org/wiki/File_manager)
- [Wikipedia — Comparison of file managers](https://en.wikipedia.org/wiki/Comparison_of_file_managers)

#programa #archivos
