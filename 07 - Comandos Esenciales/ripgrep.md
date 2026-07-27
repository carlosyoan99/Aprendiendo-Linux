---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# ripgrep (rg)

> `grep` moderno escrito en Rust. Busca recursivamente archivos respetando `.gitignore` por defecto. Entre 5× y 10× más rápido que `grep -r`.

## Descripción

**ripgrep** (comando: `rg`) es un reemplazo de `grep` diseñado para ser rápido, intuitivo y respetar las convenciones modernas (`.gitignore`, `.ignore`). A diferencia de `grep -r`, no necesita que le digas que ignore binarios o archivos ocultos — lo hace automáticamente.

| Característica | ripgrep | grep -r |
|---|---|---|
| Respeta `.gitignore` | ✅ Por defecto | ❌ Hay que excluir manual |
| Ignora archivos ocultos | ✅ Por defecto | ❌ |
| Ignora binarios | ✅ Por defecto | ❌ (usa `-I`) |
| Regex PCRE2 | ✅ | ❌ (ERE básico, PCRE con `-P`) |
| Velocidad | ⚡ 5-10× más rápido | Moderada |
| Colores | ✅ Por defecto | ✅ Con `--color=auto` |

## Sintaxis

```bash
rg [opciones] patrón [ruta]
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `-i`, `--ignore-case` | Ignorar mayúsculas/minúsculas |
| `-l`, `--files-with-matches` | Solo nombres de archivo |
| `-c`, `--count` | Contar coincidencias por archivo |
| `-n` | Mostrar número de línea |
| `-C 3`, `--context 3` | 3 líneas de contexto antes y después |
| `-A 3` | 3 líneas después (after) |
| `-B 3` | 3 líneas antes (before) |
| `-g '*.py'` | Filtrar por patrón glob |
| `-g '!*.min.js'` | Excluir patrón glob |
| `-t py` | Buscar solo archivos Python (type) |
| `-T js` | Excluir archivos JavaScript (type not) |
| `-u` | No ignorar archivos ocultos |
| `-U` | No ignorar `.gitignore` |
| `-w` | Palabra completa (word regex) |
| `-F` | Texto literal (no regex) |
| `-z` | Buscar dentro de archivos comprimidos |
| `--no-ignore` | Ignorar todos los archivos de ignore |
| `--hidden` | Buscar archivos ocultos |
| `--json` | Salida JSON (para procesar con [[jq]]) |
| `--type-list` | Listar todos los tipos de archivo conocidos |

## Ejemplos

```bash
# Búsqueda básica recursiva (respeta .gitignore)
rg \"TODO\" .

# Case-insensitive
rg -i \"error\" src/

# Solo nombres de archivo con coincidencias
rg -l \"class.*Controller\" app/

# Contar coincidencias
rg -c \"function\" src/

# Buscar en un tipo específico
rg -t py \"def test_\" tests/
rg -t md \"# TODO\" .

# Excluir un directorio
rg \"TODO\" --glob '!node_modules/*'

# Buscar palabra completa (no parcial)
rg -w \"main\" src/

# Contexto alrededor de la coincidencia
rg -C 5 \"panic\" src/main.rs

# Buscar literalmente (sin regex)
rg -F \"std::collections::HashMap\" src/

# No ignorar nada (como grep -r)
rg -uu \"patrón\" .

# Buscar archivos ocultos y en .gitignore
rg -U --hidden \"contraseña\" .

# Salida JSON
rg --json \"error\" . | jq 'select(.type==\"match\") | .data.path.text'
```

## Casos de uso reales

```bash
# Encontrar qué archivos importan una librería
rg \"from django import\" project/

# Buscar en logs (archivos .log)
rg -z \"ERROR 500\" /var/log/nginx/

# Buscar código que no debería estar en producción
rg \"console.log\" src/ --type js
rg \"print(\" src/ --type py

# Auditoría de seguridad rápida
rg \"password|secret|api_key\" --no-ignore --hidden -i .

# Encontrar definiciones de funciones
rg \"^func \" --type go .
rg \"^def \" --type py .
rg \"^pub (fn|struct|enum|trait) \" --type rs .

# Contar líneas de código por tipo (sin comentarios)
rg -c \"^[^#/\"' ]\" --type md .
```

## Alternativas modernas

| Herramienta | Diferencias |
|---|---|
| **grep** | El clásico, preinstalado en todo sistema |
| **ag** (The Silver Searcher) | Similar a ripgrep, más lento |
| **ack** | Perl-based, más lento |
| **ugrep** | Compatible con GNU grep, más rápido |

> ripgrep es el más rápido y el que mejor integración tiene con editores modernos. Vim, Neovim, VS Code y Helix lo usan internamente para búsquedas.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No encuentra archivos esperados | `.gitignore` lo está excluyendo | Usar `--no-ignore` o `-U` |
| Demasiados resultados en `node_modules` | `rg` no ignora node_modules | Por defecto sí lo ignora si está en `.gitignore` |
| Quiero buscar en archivos ocultos | Por defecto los ignora | Usar `--hidden` o `-u` |

## Ver también

- [[grep]] — el clásico, preinstalado en todo sistema
- [[find]] — buscar archivos por nombre
- [[fd-find]] — buscar archivos más rápido que find
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)
- [Documentación oficial](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md)
- [Arch Wiki — Ripgrep](https://wiki.archlinux.org/title/Ripgrep)

#comando #busqueda #texto
