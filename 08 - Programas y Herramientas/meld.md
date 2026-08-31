---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# meld

> Herramienta gráfica de comparación y fusión de archivos, carpetas y cambios de Git. Muy útil como `difftool`/`mergetool` a la hora de resolver conflictos.

## Qué es

**Meld** es un comparador visual de diffs que permite ver diferencias entre archivos, carpetas y revisiones de Git de forma lado a lado. Es especialmente potente para **fusionar cambios** (merge) ya que muestra los bloques conflictivos con colores y permite aceptar cambios de izquierda, derecha o ambos.

**Ventajas clave:**
- Comparación de 2 o 3 archivos lado a lado
- Comparación recursiva de carpetas (con filtrado)
- Fusión visual de conflictos (aceptar izquierda/derecha/ambos)
- Integración nativa con Git como difftool/mergetool
- Resaltado de diferencias por línea y por bloque

## Instalación

```bash
# Debian/Ubuntu
sudo apt install meld

# Arch / CachyOS
sudo pacman -S meld

# Fedora
sudo dnf install meld

# Flatpak
flatpak install flathub org.gnome.meld
```

## Uso

```bash
meld <archivo1> <archivo2>        # comparar dos archivos
meld <dir1> <dir2>                # comparar directorios
meld <archivo1> <archivo2> <archivo3>  # comparar tres archivos
```

## Configurar con Git

```bash
# Usar como difftool (para git diff)
git config --global diff.tool meld
git config --global difftool.prompt false

# Usar como mergetool (para resolver conflictos de git merge)
git config --global merge.tool meld
git config --global mergetool.prompt false
```

### Uso con Git

```bash
# Comparar working tree vs último commit
git difftool

# Comparar entre ramas
git difftool main..feature

# Resolver conflictos tras merge
git merge feature     # hay conflictos
git mergetool         # abre Meld para resolver cada conflicto
```

## Funcionalidad

| Modo | Descripción |
|---|---|
| **Dos archivos** | Compara dos archivos lado a lado |
| **Tres archivos** | Compara tres archivos (útil para ver original vs local vs remoto) |
| **Carpetas** | Compara dos directorios recursivamente, mostrando archivos que difieren, faltan o son nuevos |
| **Sync view** | Sincroniza el scroll para ver la misma zona en ambos paneles |

### Atajos de teclado

| Atajo | Acción |
|---|---|
| `Ctrl+F` | Siguiente diferencia |
| `Ctrl+B` | Diferencia anterior |
| `Ctrl+Left` | Aceptar cambio del lado izquierdo |
| `Ctrl+Right` | Aceptar cambio del lado derecho |
| `Ctrl+Up` | Aceptar cambio en ambos lados |
| `Ctrl+S` | Guardar archivo actual |

## Uso avanzado

### Comparar carpetas con filtrado

```bash
# Comparar dos directorios excluyendo archivos .git
meld --ignore=.git dir1/ dir2/
```

### Temas de colores

Meld usa los temas de GTK. Para cambiar el tema:
1. Ir a Editar → Preferencias → Colores
2. Seleccionar esquema de colores para additions/deletions/changes

## Comparativa con alternativas

| Aspecto | meld | vimdiff | diff-so-fancy | delta |
|---|---|---|---|---|
| **Interfaz** | Gráfica (GTK) | Terminal (Vim) | Terminal (Pager) | Terminal (Pager) |
| **Comparación carpetas** | ✅ | ❌ | ❌ | ❌ |
| **Fusión visual** | ✅ | ✅ | ❌ | ❌ |
| **Git integration** | ✅ difftool/mergetool | ✅ vimdiff | ✅ pager | ✅ pager |
| **3 archivos** | ✅ | ✅ | ❌ | ❌ |
| **Aprendizaje** | Fácil | Alta | Mínima | Mínima |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No abre desde `git mergetool` | meld no está en PATH | Verificar `which meld` y `git config merge.tool` |
| Muestra basura en archivos binarios | Comparando archivos no-texto | Usar `git diff` solo para texto; omitir binarios |
| Conflictos no se marcan | Falta configurar merge.tool | `git config --global merge.tool meld` |
| Archivos muy grandes lentos | Meld carga todo en memoria | Usar `delta` o `diff-so-fancy` para diffs enormes |

## Notas personales

- En mi flujo de Git, uso meld para resolver conflictos de merge cuando `git mergetool` los detecta.
- Para diffs rápidos en terminal, prefiero `delta` (más rápido, no abre GUI).

## Enlaces externos

- [Sitio oficial](https://meldmerge.org/)
- [Documentación Meld](https://meldmerge.org/documentation.html)
- [Arch Wiki — Meld](https://wiki.archlinux.org/title/Meld)
- [Wikipedia — Meld](https://en.wikipedia.org/wiki/Meld_(software))

## Ver también

- [[Git]] — control de versiones
- [[lazygit]] — interfaz TUI de Git
- [[gitui]] — Git TUI en Rust
- [[delta]] — pager de diff alternativo (terminal)
- [[tig]] — visor de commits Git

#programa #diff #merge
