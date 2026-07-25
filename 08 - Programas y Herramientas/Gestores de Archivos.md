---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: programa
prioridad: media
---

# Gestores de Archivos

## Qué es

Un gestor de archivos permite navegar, copiar, mover y eliminar archivos con una interfaz visual, ya sea gráfica o en la terminal. Cada DE trae su propio gestor gráfico por defecto; en WMs minimalistas se suele usar uno de terminal.

## Gestores gráficos (según DE)

| Gestor | DE asociado | Instalación sola | Atajos clave |
|---|---|---|---|
| **Nautilus (Files)** | [[GNOME]] | `sudo apt install nautilus` | `Ctrl+H` (ver ocultos), `Ctrl+T` (nueva pestaña) |
| **Dolphin** | [[KDE Plasma]] | `sudo apt install dolphin` | `F4` (abrir terminal incrustada), `F3` (split panel) |
| **Thunar** | [[XFCE]] | `sudo apt install thunar` | `Ctrl+T` (nueva pestaña), muy rápido incluso en equipos lentos |
| **Nemo** | [[Cinnamon]] | `sudo apt install nemo` | Fork de Nautilus con más opciones |

```bash
# También se pueden instalar de forma independiente (ej. en un WM):
sudo pacman -S thunar         # Thunar en Arch, funciona en cualquier entorno
```

### Características destacadas

| Gestor | Split panel | Terminal integrada | Renombrado batch | Búsqueda |
|---|---|---|---|---|
| Nautilus | ❌ | ❌ | ❌ | ✅ Básica |
| Dolphin | ✅ | ✅ (F4) | ✅ (seleccionar + F2 múltiple) | ✅ Avanzada |
| Thunar | ❌ | ❌ | ✅ (complemento) | ✅ Básica |
| Nemo | ✅ | ✅ (F4) | ✅ | ✅ Buena |

## Gestores de terminal (para WMs sin DE)

Cuando usas [[i3]], [[DWM]], [[Hyprland]] o [[Niri]], los gestores gráficos pueden no estar instalados o ser innecesarios. Alternativas en terminal:

### ranger

Navegador tipo vim con vista previa de archivos en el panel derecho.

```bash
sudo pacman -S ranger                           # Arch
sudo apt install ranger                         # Debian/Ubuntu
sudo dnf install ranger                         # Fedora

# Atajos rápidos (una vez dentro):
# ↑↓ o j/k → navegar
# Enter → abrir archivo / entrar carpeta
# q → salir
# h/l → subir/bajar directorio
# yy → copiar (yank)
# pp → pegar
# dd → marcar para borrar
# Space → seleccionar archivo
```

### nnn

Extremadamente ligero (escrito en C), con teclas configurables. Ideal si quieres mínimos recursos.

```bash
sudo apt install nnn                            # Debian/Ubuntu
sudo pacman -S nnn                              # Arch

# Atajos:
# ↑↓ → navegar
# / → buscar
# ! → abrir shell en el directorio actual
# . → toggle archivos ocultos
# d → detalle de tamaño de directorio
```

### yazi

Moderno, escrito en Rust, con previsualización rápida de imágenes, código, PDFs y metadatos.

```bash
sudo pacman -S yazi                             # Arch (o cargo install yazi-fm)
# Atajos tipo vim + ratas:

# ↑↓ o j/k → navegar
# ~ → ir al home
# / → buscar archivo
# yy → copiar, pp → pegar
# dd → cortar, Space → seleccionar
# ; → ejecutar comando
```

## Gestores gráficos adicionales (no dependen del DE)

| Gestor | Destaca por |
|---|---|
| **PCManFM** | Muy ligero (GTK), a menudo elegido para WMs minimalistas sobre ranger/nnn cuando se prefiere GUI |
| **Double Commander** | Estilo Total Commander, dos paneles, multiplataforma |
| **SpaceFM** | Similar a PCManFM con más funcionalidades (pestañas, plugins) |

## Por qué importa

- En WMs tiling, no hay un gestor de archivos por defecto. Tienes que elegir e instalar uno, o depender solo de la terminal.
- Los gestores de terminal como `nnn` o `yazi` son extremadamente eficientes para tareas repetitivas (mover lotes de archivos, renombrar, navegar rápido) una vez aprendidos los atajos.
- `dolphin` con terminal integrada (`F4`) es una combinación muy potente que elimina la necesidad de cambiar de ventana entre terminal y gestor.

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
