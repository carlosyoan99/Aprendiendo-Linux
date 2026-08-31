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

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install lf` |
| Arch | `sudo pacman -S lf` |
| Fedora | `sudo dnf install lf` |
| Alpine | `sudo apk add lf` |
| macOS | `brew install lf` |
| Go | `go install github.com/gokcehan/lf@latest` |

## Configuración avanzada

```bash
# ~/.config/lf/lfrc — configuración completa

# Previsualización de archivos
set icons
set preview
set cursorpreviewinit
set ratios 1:2:3
set statfmt      %h%u   %t   %f   %S
set sortby size
set reverse
set hidden
set info size:time

# Previsualización de archivos de texto
cmd clear &clear
cmd open &{{
    set -f ${f##*.}
    case $f in
        *) lf -remote "send clear load $fx" ;;
    esac
}}

# Abrir con programa apropiado
cmd open &{
    case $f in
        *.tar.bz2) tar xjf $f ;;
        *.tar.gz) tar xzf $f ;;
        *.zip) unzip $f ;;
        *.rar) unrar x $f ;;
        *) $OPENER $f ;;
    esac
}

# Atajos personalizados
map <enter> open
map <backspace> cd ..
map <f1> help
map <f2> root
map <f3> detail
map <f4}  rename
map <f5}  copy
map <f6}  cut
map <f7}  paste
map <f8}  delete
map <f9}  sort
map <f10}  quit

# Soporte de iconos (nerd fonts)
set icons
set drawbox
```

## Integración con shell

```bash
# Definir variable de entorno para abrir lf
export LF_CD_CMD="\nset -f
while IFS= read -r d; do
  [ -d \"\$d\" ] && echo \"\$d\"
done <<EOF
$(find \"\${1:-.}\" -maxdepth 1 -type d)
EOF
"

# Usar lf como selector de directorios
cd() {
    if [ $# -eq 0 ]; then
        cd ..
    elif [ $# -eq 1 ] && [ -d "$1" ]; then
        cd "$1"
    else
        lf "$@"
    fi
}

# Ctrl+O para abrir en lf desde el shell
cd-lf() {
    tmpfile=$(mktemp)
    lf -last-dir-path="$tmpfile" "$@"
    if [ -f "$tmpfile" ]; then
        dir=$(cat "$tmpfile")
        [ -d "$dir" ] && cd "$dir"
    fi
    rm -f "$tmpfile"
}
bindkey '^O' cd-lf    # zsh
# bind -x '\C-o':cd-lf  # bash
```

## Comparativa con gestores TUI

| Característica | lf | ranger | yazi | nnn |
|---|---|---|---|---|
| Lenguaje | Go | Python | Rust | C |
| Velocidad | Muy rápido | Rápido | Muy rápido | Extremadamente rápido |
| Configuración | Shell scripts | Python | TOML | Shell scripts |
| Previsualización | Básica | Avanzada | Avanzada (async) | Plugins |
| Iconos | ✅ Nerd Fonts | ✅ | ✅ | ❌ |
| Plugins | ❌ | ✅ | ✅ | ✅ |
| Curva aprendizaje | Baja | Media | Media | Baja |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `lf: command not found` | No instalado | `sudo apt install lf` |
| No muestra previsualización | Terminal sin soporte | Usar `lf -last-dir-path` |
| Iconos no aparecen | Falta Nerd Font | Instalar `nerd-fonts` + configurar terminal |
| Atajos no funcionan | Configuración errónea | Verificar `~/.config/lf/lfrc` |
| No abre archivos | Falta `OPENER` | `export OPENER=xdg-open` o `export OPENER=wlr-randr` |

## Enlaces externos

- [GitHub — lf](https://github.com/gokcehan/lf)
- [Arch Wiki — lf](https://wiki.archlinux.org/title/lf)
- [lf Wiki](https://github.com/gokcehan/lf/wiki)

## Ver también

- [[ranger]] — gestor de archivos TUI (Python, más features)
- [[yazi]] — gestor de archivos TUI (Rust, más moderno)
- [[Gestores de Archivos]] — gestores gráficos
- [[nnn]] — gestor de archivos TUI extremadamente rápido

#programa #tui #archivos
