---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: media
---

# Obsidian

> Aplicación de notas basada en Markdown con grafo de conocimiento, backlinks y plugins. Es donde vivo mi conocimiento personal (vault) y donde se mantiene este mismo AprendiendoLinux.

## Qué es

- Editor Markdown de escritorio multilinea (Windows, macOS, Linux, Android, iOS) que gestiona un **vault**: una carpeta local de archivos `.md`.
- La filosofía es "tus notas son tuyas": se almacenan en texto plano local, sin base de datos ni formato propietario, por lo que se pueden versionar con Git y portar a cualquier otra herramienta.
- Se construyó en torno a los **wikilinks** `[[Nota]]` y a la vista de **grafo**, que convierten notas aisladas en una red de conocimiento navegable.
- El núcleo es gratuito; solo se pagan funciones extra (sync y publish). Los plugins de la comunidad son gratuitos y amplían casi cualquier funcionalidad.

## Instalación

```bash
sudo pacman -S obsidian          # Arch / CachyOS (crustal)
sudo apt install obsidian        # Debian / Ubuntu (Flatpak/AppImage según distro)
sudo dnf install obsidian        # Fedora (paquete oficial)
flatpak install flathub md.obsidian.Obsidian   # Flatpak (cualquier distro)
```

No hay imágenes locales: usa capturas de las webs oficiales.

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

## Comandos útiles

```bash
# Abrir el vault desde la terminal (aplicación de escritorio)
obsidian "vault://?vault=AprendiendoLinux"

# Los archivos son texto plano: se pueden procesar con grep/sed
grep -l "wikilink" notas/*.md
```

## Vault

- Ruta principal: `~/Documentos/Obsidian Vault` (estructura por carpetas `00-Inicio` → `99-Plantillas`, hub `Inicio.md`, MOCs por categoría).
- AprendiendoLinux también es un vault Obsidian (abrir carpeta del repo como vault).

## Obsidian vs otras herramientas

| Aspecto | Obsidian | Neovim | Markdown con editor genérico |
|---|---|---|---|
| Grafo y backlinks | Nativo | Con plugins | No |
| Curva de aprendizaje | Baja | Alta | Media |
| Plataforma | Escritorio + móvil | Terminal | Cualquiera |
| Plugins | Gran comunidad | Amplia (Lua) | Limitado |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No aparece el vault en el selector | Carpeta sin `/.obsidian` | `Notas` → `Abrir otra carpeta como vault` |
| Backlink no aparece | Falta abrir correctamente el vault o nombre con espacios | Verificar que ambos estén en el mismo vault |
| Sync lento | Vault grande con imágenes | Filtro de folders en Settings → Sync |

## Ver también

- [[Neovim]] — alternativa en terminal
- [[Git]] — los vaults se versionan
- [[Personalización en Linux]] — dotfiles y configuración del entorno

## Enlaces externos

- [Sitio oficial](https://obsidian.md)
- [Obsidian Help](https://help.obsidian.md)

#programa #notas #markdown #grafos