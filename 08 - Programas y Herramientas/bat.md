---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: alta
---

# bat

> `cat` con esteroides: resaltado de sintaxis, números de línea, integración con Git y paginación automática. Alternativa moderna a `cat` para leer archivos en terminal.

## Qué es

**bat** es un clon de `cat` con funcionalidades extra que lo hacen mucho más útil para el día a día: resalta la sintaxis de más de 200 lenguajes, muestra números de línea, integra cambios de Git en las líneas modificadas, y pagina automáticamente la salida si el archivo es largo.

Escrito en Rust, es un solo binario estático. Se puede usar como reemplazo directo de `cat` con un alias: `alias cat='bat'`.

## Instalación

```bash
# Debian/Ubuntu (el binario se llama batcat por conflicto con otro paquete)
sudo apt install bat
# Crear alias para usarlo como cat: echo \"alias cat='batcat'\" >> ~/.bashrc

# Arch
sudo pacman -S bat

# Fedora
sudo dnf install bat

# Desde GitHub (binario estático)
# https://github.com/sharkdp/bat/releases
```

## Uso básico

```bash
bat archivo.txt                      # mostrar con resaltado y números
bat -n archivo.txt                   # mostrar números de línea (siempre activos)
bat -A archivo.txt                   # mostrar caracteres especiales (tabs, saltos)
bat --language=python archivo        # forzar lenguaje de resaltado

# Paginación automática (usa less por defecto)
# Si el archivo es corto, bat imprime directamente
# Si es largo, lo envía a less

# Deshabilitar paginación
bat -p archivo.txt                   # --plain, sin números ni paginación
bat --paging=never archivo.txt
```

## Características destacadas

### Integración con Git

```bash
# Muestra signos + / - en las líneas modificadas respecto al índice de Git
bat archivo.py

# Salida:
#   1 │ import os
#  2 │ import sys
#  3 │
# 4 +│ print(\"nueva línea\")
#  5 │
```

### Temas de color

```bash
# Listar temas disponibles
bat --list-themes

# Temas populares:
# - Dracula, Nord, Solarized (dark/light)
# - OneHalfDark, OneHalfLight
# - gruvbox (dark/light)
# - GitHub, Monokai, TwoDark

# Probar un tema específico
bat --theme=Dracula archivo.txt

# Tema por defecto en ~/.bashrc:
# export BAT_THEME=\"Dracula\"
```

### Alias y reemplazo de cat

```bash
# En ~/.bashrc:
alias cat='batcat'              # Debian/Ubuntu
# o
alias cat='bat'                 # Arch/Fedora

# Para mantener compatibilidad con scripts que dependen de cat sin opciones:
# bat detecta cuando se usa en pipe y se comporta como cat normal
bat archivo.txt | grep algo     # bat desactiva resaltado al pipear
```

## Integración con otras herramientas

```bash
# man pages coloreadas (con bat como paginador)
export MANPAGER=\"sh -c 'col -bx | bat -l man -p'\"

# --help coloreado (con bat como paginador)
alias -g -- -h='-h 2>&1 | bat --language=help -p'
alias -g -- --help='--help 2>&1 | bat --language=help -p'

# diff con bat
diff archivo1.txt archivo2.txt | bat -l diff

# Ver JSON formateado
cat data.json | bat -l json
```

## Alternativas

| Herramienta | Diferencias |
|---|---|
| **cat** | Sin colores, sin números, preinstalado en todo sistema |
| **less** | Paginador, no tiene resaltado nativo (pero usa `source-highlight`) |
| **pygmentize** | Resaltado potente pero más lento, no paga automáticamente |
| **highlight** | Similar a bat pero sin integración Git ni paginación automática |
| **ccat** | Similar a bat, desactualizado |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `bat: command not found` | Binario se llama `batcat` en Debian/Ubuntu | Usar `batcat` o alias `alias bat='batcat'` |
| Sin colores en pipe | `bat` desactiva colores al pipear | Forzar con `bat --color=always archivo \| less -R` |
| Tema no aplica | Variable `BAT_THEME` no exportada | `export BAT_THEME=\"Nord\"` en `.bashrc` |
| Paginación molesta en archivos cortos | `bat` paga por defecto | `bat -p` o `--paging=never` |

## Ver también

- [[cat]] — el clásico, preinstalado en todo sistema
- [[less]] — paginador, complementa a bat
- [[diff]] — diferencias entre archivos
- [[TUI tools]] — otras herramientas TUI esenciales

## Enlaces externos

- [GitHub — sharkdp/bat](https://github.com/sharkdp/bat)
- [Arch Wiki — Bat](https://wiki.archlinux.org/title/Bat)

#programa #tui #terminal
