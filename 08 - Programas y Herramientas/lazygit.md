---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: alta
---

# lazygit

> Interfaz TUI para Git que permite hacer todas las operaciones comunes (stage, commit, branch, merge, rebase, stash, diff) sin recordar comandos. El reemplazo visual de `git`.

## Qué es

**lazygit** es un cliente Git interactivo para terminal. Muestra el estado del repositorio en paneles: archivos modificados, staging area, branches, commits, stash, y permite operar con teclas sin escribir comandos Git. No reemplaza `git` para operaciones avanzadas, pero cubre el 95% del uso diario.

Escrito en Go, binario único. Creado por el mismo autor de **lazydocker**.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install lazygit

# Arch
sudo pacman -S lazygit

# Fedora
sudo dnf install lazygit

# Homebrew (macOS/Linux)
brew install lazygit

# Desde GitHub (binario estático)
# https://github.com/jesseduffield/lazygit/releases
```

## Atajos esenciales

### Globales

| Tecla | Acción |
|---|---|
| `q` | Salir |
| `?` | Ayuda completa con todos los atajos |
| `x` | Abrir menú de extensiones |
| `Ctrl+r` | Refrescar |
| `:` | Ejecutar comando personalizado |

### Archivos (panel izquierdo)

| Tecla | Acción |
|---|---|
| `espacio` | Stage/unstage archivo |
| `a` | Stage/unstage todo |
| `d` | Abrir menú de cambios (discard, reset) |
| `c` | Hacer commit |
| `C` | Hacer commit con mensaje (usando editor) |
| `e` | Editar archivo |
| `s` | Stash archivos |
| `S` | Stash de cambios |

### Branches (panel superior)

| Tecla | Acción |
|---|---|
| `n` | Nueva branch |
| `espacio` | Checkout branch |
| `d` | Eliminar branch |
| `m` | Merge branch actual con la seleccionada |
| `Ctrl+f` | Hacer force checkout |
| `r` | Rebase sobre la branch seleccionada |

### Commits (panel medio)

| Tecla | Acción |
|---|---|
| `espacio` | Checkout commit |
| `d` | Drop commit (solo si es el último) |
| `s` | Squash (fusionar con commit anterior) |
| `r` | Renombrar commit |
| `R` | Renommar con editor |
| `g` | Reset a este commit (soft/mixed/hard) |
| `f` | Fixup (fusionar cambios sin modificar mensaje) |
| `Ctrl+j/k` | Mover commit arriba/abajo (reorder) |

### Stash

| Tecla | Acción |
|---|---|
| `espacio` | Aplicar stash |
| `d` | Eliminar stash |
| `g` | Pop stash (aplicar y eliminar) |

## Flujo de trabajo típico

```bash
cd ~/proyecto
lazygit

# 1. Ver archivos modificados (panel izquierdo)
# 2. Presionar espacio en cada archivo para staggear
#    o 'a' para staggear todo
# 3. Presionar 'c' para hacer commit (escribir mensaje)
# 4. Presionar 'P' para hacer push
# 5. Presionar 'p' para hacer pull

# Sin lazygit esto sería:
# git add .
# git commit -m \"mensaje\"
# git push
```

## Personalización: `~/.config/lazygit/config.yml`

```yaml
gui:
  theme:
    lightTheme: false
    activeBorderColor:
      - green
      - bold
    inactiveBorderColor:
      - white
    selectedLineBgColor:
      - blue
  authorColors:
    '*': blue
  nerdFontsVersion: "3"
git:
  paging:
    colorArg: always
    pager: delta
    useConfig: true
  commitPrefix:
    pattern: "^\\w+/(\\w+-\\w+)"
    replace: "[$1] "
os:
  editPreset: "nvim"
  edit: "nvim {{filename}}"
```

## Comparativa

| Aspecto | lazygit | gitui | tig | Git CLI |
|---|---|---|---|---|
| **Curva aprendizaje** | Muy baja | Baja | Media | Alta |
| **Stage/commit** | ✅ Panel visual | ✅ Panel visual | ❌ Sólo ver | ✅ Línea de comandos |
| **Branch management** | ✅ Muy completo | ✅ Completo | ❌ Sólo ver | ✅ |
| **Rebase interactivo** | ✅ Visual | ❌ | ❌ | ✅ Terminal |
| **Merge conflicts** | ✅ Resolución asistida | ❌ | ❌ | ✅ Manual |
| **Stash** | ✅ Visual | ✅ | ❌ | ✅ |
| **Rendimiento** | Muy rápido | ⚡ El más rápido | Rápido | N/A |
| **Idioma** | Go | Rust | C | C |

> Para ver commits y log sin modificar nada, **tig** es más rápido que abrir lazygit. Para trabajar, **lazygit** es más completo.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No se ve el diff | Falta un diff tool configurado | Configurar `git.paging.pager` en config.yml |
| Editor incorrecto | `os.editPreset` no coincide | Cambiar a `nvim`, `code`, `micro`, etc. |
| Lento en repos grandes | Demasiados archivos unstaged | Antes de abrir lazygit: `git stash` o `.gitignore` |
| Pantalla corrupta | Terminal no compatible | Probar con `TERM=xterm-256color` |

## Ver también

- [[tig]] — visor de commits y log (más rápido para consultas)
- [[gitui]] — alternativa a lazygit en Rust
- [[Git]] — nota general sobre Git en el vault
- [[GitHub CLI (gh)]] — GitHub desde terminal
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — jesseduffield/lazygit](https://github.com/jesseduffield/lazygit)
- [Documentación oficial](https://github.com/jesseduffield/lazygit/blob/master/docs/README.md)
- [Arch Wiki — Lazygit](https://wiki.archlinux.org/title/Lazygit)

#programa #tui #git
