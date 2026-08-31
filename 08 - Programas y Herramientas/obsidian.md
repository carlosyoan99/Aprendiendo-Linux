---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# Obsidian

> Aplicación de notas basada en Markdown con grafo de conocimiento, backlinks y plugins. Es donde vivo mi conocimiento personal (vault) y donde se mantiene este mismo AprendiendoLinux.

## Instalación

```bash
sudo pacman -S obsidian      # Arch / CachyOS
```

## Sintaxis

- Notas: archivos `.md` con frontmatter YAML y contenido Markdown.
- Wikilinks: `[[Nota]]` para enlazar notas; creates grafo con backlinks.
- Canvas: lienzo visual para ideas (archivos `.canvas`).
- Plugins core: graph, backlink, outgoing-link, tag-pane, templates, properties, bases, outline, daily-notes, canvas, bookmarks.

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `Ctrl+O` | Cambiar rápido de nota |
| `Ctrl+P` | Paleta de comandos |
| `Ctrl+G` | Abrir grafo |
| `Ctrl+Shift+V` | Pegar como texto sin formato |
| `Ctrl+N` | Nueva nota |

## Vault

- Ruta principal: `~/Documentos/Obsidian Vault` (estructura por carpetas `00-Inicio` → `99-Plantillas`, hub `Inicio.md`, MOCs por categoría).
- AprendiendoLinux también es un vault Obsidian (abrir carpeta del repo como vault).

## Ver también

- [[Neovim]] — alternativa en terminal
- [[Git]] — los vaults se versionan

## Enlaces externos

- [Sitio oficial](https://obsidian.md)
- [Obsidian Help](https://help.obsidian.md)

#programa #notas #markdown #grafos