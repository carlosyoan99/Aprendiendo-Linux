---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# fzf

> Fuzzy finder interactivo para la terminal. Filtra cualquier lista de forma difusa: historial de comandos, archivos, procesos, incluso resultados de otros comandos vía pipe.

## Qué es

`fzf` (fuzzy finder) es un filtro difuso interactivo. Toma una lista de líneas por stdin, y permite filtrarlas escribiendo parcialmente cualquier parte — no solo prefijos. Integración directa con **bash**, **zsh**, **fish** para reemplazar Ctrl+R (historial), Ctrl+T (archivos), Alt+C (cd).

## Instalación

```bash
# Debian/Ubuntu
sudo apt install fzf

# Arch
sudo pacman -S fzf

# Fedora
sudo dnf install fzf

# Activar integración con shell (se añade a .bashrc automáticamente)
# O manual:
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
```

## Ver también

- [[fd-find]] — búsqueda rápida de archivos
- [[find]] — búsqueda clásica
- [[locate]] — búsqueda indexada
- [[La Shell]] — integración con el shell

#programa #herramientas #busqueda
