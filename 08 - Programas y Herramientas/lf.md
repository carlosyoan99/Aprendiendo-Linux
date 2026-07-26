---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# lf

> Gestor de archivos TUI escrito en Go, inspirado en ranger pero mucho más rápido. Configuración simple, soporte de paneles y previsualización.

## Sintaxis

```bash
lf [directorio]
```

## Descripción

`lf` (list files) es un explorador de archivos terminal escrito en Go. Diseñado como alternativa rápida a ranger, con configuración vía shell scripts. Más rápido que ranger (Go vs Python) pero menos features out-of-the-box.

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `h/l` | Subir/bajar nivel |
| `j/k` | Mover arriba/abajo |
| `Enter` | Abrir archivo |
| `d` | Cortar (delete) |
| `r` | Renombrar |
| `a` | Crear archivo/directorio |
| `y` | Copiar |
| `p` | Pegar |
| `w` | Abrir con selector |
| `~` | Ir a home |
| `.` | Mostrar/ocultar ocultos |
| `z` | Frecuentes (cd frecuentes) |
| `:` | Ejecutar comando |

## Ejemplos

```bash
lf                              # abrir en directorio actual
lf ~/Documents                  # abrir en directorio específico
```

## Configuración

```bash
# ~/.config/lf/lfrc — configuración principal
set icons
set preview
set cursorpreviewinit
set ratios 1:2:3

# Previsualización de archivos
cmd clear &clear
cmd open &{{
    set -f ${f##*.}
    case $f in
        *) lf -remote "send clear load $fx" ;;
    esac
}}
```

## Alternativas

| Herramienta | Ventaja |
|---|---|
| **yazi** | Más features, async, mejor preview |
| **ranger** | Más maduro, más plugins |
| **nnn** | Extremadamente rápido, plugins C |

## Ver también

- [[ranger]] — gestor de archivos TUI (Python, más features)
- [[yazi]] — gestor de archivos TUI (Rust, más moderno)
- [[Gestores de Archivos]] — gestores gráficos

## Enlaces externos

- [GitHub — lf](https://github.com/gokcehan/lf)
- [Arch Wiki — lf](https://wiki.archlinux.org/title/lf)

#programa #tui #archivos
