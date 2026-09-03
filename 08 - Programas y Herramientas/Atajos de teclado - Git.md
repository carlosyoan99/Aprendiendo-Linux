---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# Atajos de teclado - Git

> Aliases, atajos de shell y funciones rápidas para trabajar con **Git** de forma eficiente. Git es una herramienta de línea de comandos, así que los "atajos" son aliases en `~/.gitconfig` y funciones shell que simplifican comandos frecuentes.

## Aliases esenciales (~/.gitconfig)

```ini
[alias]
  #$status
  s = status -sb
  st = status

  #commit
  c = commit
  ca = commit --amend
  cn = commit --no-verify
  cm = commit -m

  #log
  l = log --oneline --graph --decorate --all -20
  lg = log --oneline --graph --decorate --all -30
  ll = log --pretty=format:'%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]' --decorate --graph
  ld = log --diff-filter=D --summary

  #diff
  d = diff
  ds = diff --staged
  dw = diff --word-diff
  dc = diff --cached

  #branch
  b = branch
  bd = branch -d
  bD = branch -D
  bm = branch -m

  #checkout/switch
  co = checkout
  sw = switch
  swc = switch -c

  #merge/rebase
  m = merge
  rb = rebase
  rbi = rebase -i
  rbc = rebase --continue
  rba = rebase --abort

  #stash
  ss = stash
  sp = stash pop
  sd = stash drop
  sl = stash list

  #reset
  unstage = reset HEAD --
  undo = reset --soft HEAD~1
  last = reset --hard HEAD~1

  #show
  show = show --stat
  who = shortlog -sn

  #clean
  clean = clean -fd
```

---

## Comandos Git rápidos (sin alias)

### Básicos

| Comando | Alias equivalente | Efecto |
|---|---|---|
| `git s` | `git status -sb` | Estado compacto (rama + archivos) |
| `git add .` | — | Añadir todos los cambios al staging |
| `git add -p` | — | Añadir hunks individuales (interactivo) |
| `git add -i` | — | Modo interactivo de staging |
| `git commit -m "msg"` | `git cm "msg"` | Commit con mensaje |
| `git commit --amend` | `git ca` | Modificar último commit (mensaje o archivos) |
| `git commit --amend --no-edit` | — | Añadir archivos al último commit sin cambiar mensaje |

### Ramas

| Comando | Efecto |
|---|---|
| `git b` | Listar ramas locales |
| `git b -a` | Listar todas las ramas (remotas incluidas) |
| `git b -vv` | Ramas con跟踪 de upstream |
| `git sw main` | Cambiar a rama main |
| `git sw -c feature/nueva` | Crear y cambiar a rama nueva |
| `git bd feature/vieja` | Eliminar rama (mergeada) |
| `git bD feature/vieja` | Eliminar rama (fuerza) |

### Historial

| Comando | Efecto |
|---|---|
| `git l` | Log decorado con graph (últimas 20) |
| `git lg` | Log ampliado (últimas 30) |
| `git ll` | Log con autor y colores |
| `git ld` | Archivos eliminados en el historial |
| `git show HEAD` | Ver último commit completo |
| `git show HEAD~3` | Ver commit hace 3 atrás |
| `git blame archivo` | Quién modificó cada línea |

### Diff

| Comando | Efecto |
|---|---|
| `git d` | Diff de cambios sin staging |
| `git ds` | Diff de archivos staged |
| `git dw` | Diff con word-diff (palabras, no líneas) |
| `git diff HEAD~3` | Diff vs hace 3 commits |
| `git diff main..feature` | Diff entre ramas |

### Stash

| Comando | Efecto |
|---|---|
| `git ss` | Guardar cambios en stash |
| `git ss -m "msg"` | Stash con mensaje |
| `git sp` | Sacar último stash (pop) |
| `git sp --index` | Pop preservando el staging |
| `git sl` | Listar stashes |
| `git sd` | Eliminar último stash |

### Reset y deshacer

| Comando | Efecto |
|---|---|
| `git undo` | Deshacer último commit (manteniendo cambios staged) |
| `git last` | Deshacer último commit y sus cambios |
| `git unstage archivo` | Quitar archivo del staging |
| `git restore archivo` | Descartar cambios en archivo (⚠️ irreversible) |
| `git restore --staged archivo` | Quitar del staging |

---

## Funciones shell útiles (~/.bashrc o ~/.zshrc)

```bash
# Ver ramas con último commit relativo
git-recent() {
  git log --oneline --decorate --all -20 --format='%C(yellow)%h%C(reset) %s %C(green)(%cr)%C(reset) %C(blue)%D%C(reset)'
}

# Cambiar al último commit anterior
git-undo() {
  git reset --soft HEAD~1
}

# Añadir y commit en un paso
git-ac() {
  if [ -z "$1" ]; then
    echo "Uso: git-ac \"mensaje del commit\""
    return 1
  fi
  git add -A && git commit -m "$1"
}

# Pull con rebase por defecto
git-pull() {
  git pull --rebase origin "$(git branch --show-current)"
}

# Ver archivos modificados en la última hora
git-recently-changed() {
  find . -name "*.md" -mmin -60 -not -path "./.git/*"
}

# Eliminar ramas mergeadas localmente
git-cleanup() {
  git branch --merged main | grep -v "main\|master\|develop" | xargs git branch -d
}

# Abbreviaciones en shell (funcionan en cualquier terminal)
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --oneline --graph -20'
alias gp='git push'
alias gs='git status'
```

---

## Atajos de teclado del shell para Git

| Atajo | Efecto |
|---|---|
| `Ctrl+R` | Buscar en historial de comandos (útil para encontrar commits anteriores) |
| `Ctrl+C` | Cancelar operación Git en curso |
| `Ctrl+Z` | Suspender Git (fg para continuar) |
| `Tab` | Autocompletar nombres de archivos y ramas |
| `Tab Tab` | Listar todas las opciones de autocompletado |

---

## Git interactive: atajos en `git add -p`

| Atajo | Efecto |
|---|---|
| `y` | Añadir este hunk |
| `n` | No añadir este hunk |
| `s` | Dividir el hunk en partes más pequeñas |
| `e` | Editar el hunk manualmente |
| `q` | Salir sin más cambios |
| `a` | Añadir este hunk y todos los restantes |
| `d` | No añadir este hunk ni los restantes |

---

## Git rebase interactivo: atajos

| Atajo | Efecto |
|---|---|
| `pick` (p) | Mantener commit como está |
| `reword` (r) | Mantener commit pero cambiar mensaje |
| `edit` (e) | Pausar en este commit para editar |
| `squash` (s) | Fusionar con commit anterior, combinar mensajes |
| `fixup` (f) | Fusionar con commit anterior, descartar este mensaje |
| `drop` (d) | Eliminar commit |
| `Ctrl+X` | Guardar y salir (nano/vim) |
| `:wq` | Guardar y salir (vim) |

---

## Git mergetool: atajos

| Atajo | Efecto |
|---|---|
| `Ctrl+\` | Cancelar merge y salir |
| `:wqa` | Guardar y salir de todas las ventanas |
| `]c` | Siguiente conflicto (vim) |
| `[c` | Conflicto anterior (vim) |
| `:diffget LOCAL` | Usar versión local |
| `:diffget REMOTE` | Usar versión remota |
| `:diffget BASE` | Usar versión base |

---

## Atajos de teclado de navegación en terminal (útil para Git)

| Atajo | Efecto |
|---|---|
| `Ctrl+A` | Ir al inicio de la línea |
| `Ctrl+E` | Ir al final de la línea |
| `Ctrl+U` | Borrar hasta el inicio de la línea |
| `Ctrl+K` | Borrar hasta el final de la línea |
| `Ctrl+W` | Borrar palabra anterior |
| `Alt+B` | Retroceder una palabra |
| `Alt+F` | Avanzar una palabra |
| `Ctrl+R` | Buscar en historial |
| `Ctrl+L` | Limpiar pantalla |

---

## Comparativa de herramientas Git

| Herramienta | Tipo | Ventaja |
|---|---|---|
| **git (CLI)** | Terminal | Control total, scripting, eficiencia |
| **lazygit** | TUI | Visual, rápido, fluoride keys |
| **tig** | TUI | Log visual, blame, diff |
| **gitui** | TUI | Minimalista, Rust, rápido |
| **VSCode Git** | GUI | Integrado en editor, visual |
| **GitKraken** | GUI | Gráfico de ramas, colaboración |

---

## Ver también

- [[Git]] — conceptos y uso completo de Git
- [[lazygit]] — interfaz TUI para Git
- [[tig]] — navegador de historial Git
- [[Shells (bash zsh fish)]] — atajos generales de shell
- [[Atajos de teclado - VSCode]] — atajos de teclado del editor

#atajos #git #terminal #cli
