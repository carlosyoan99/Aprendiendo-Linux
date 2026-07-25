---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# alias

## Sintaxis

```bash
alias                                      # lista todos los alias definidos
alias nombre='comando'                     # definir alias
alias nombre='comando1; comando2'          # alias con múltiples comandos
alias -p                                   # lista alias en formato reutilizable
```

## Descripción

Crea atajos para comandos largos o combinaciones de uso frecuente. Los alias son locales a la shell — se definen en `.bashrc`/`.zshrc` para que persistan entre sesiones.

```
Cómo funciona un alias:

  Escribes:  ll [opciones]
               │
  Shell busca en alias → encuentra ll='ls -la'
               │
  Ejecuta:    ls -la [opciones]
```

> Ver [[type]] para diagnosticar si un comando es un alias y [[which]] para buscar binarios externos.

---

## Opciones

| Flag | Efecto |
|---|---|
| (sin args) | Lista todos los alias definidos con su valor |
| `-p` | Lista alias en formato `alias nombre='valor'` (programable) |

---

## Ejemplos básicos

```bash
# Definir alias temporales (duran hasta cerrar la terminal)
alias ll='ls -la'
alias la='ls -A'
alias gs='git status'
alias gc='git commit'
alias ..='cd ..'

# Prevenir accidentes
alias rm='rm -i'                          # preguntar antes de borrar
alias cp='cp -i'                          # preguntar antes de sobrescribir
alias mv='mv -i'                          # preguntar antes de mover

# Ver alias existentes
alias                                      # lista completa
alias ll                                  # ver solo el alias "ll"
alias -p                                  # formato parseable

# Eliminar alias temporal
unalias ll                                # eliminar el alias ll
unalias -a                                # eliminar TODOS los alias (reset)
```

---

## Alias recomendados para `.bashrc`/`.zshrc`

```bash
# ── Navegación ──
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'

# ── ls mejorado ──
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lAh'
alias lt='ls -lth'                        # ordenado por fecha
alias l.='ls -d .*'                       # solo archivos ocultos

# ── Seguridad ──
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ── Comandos con flags comunes ──
alias df='df -h'
alias du='du -h -s'
alias free='free -h'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'                   # crear padres + verbose
alias ip='ip -color=auto'

# ── Git ──
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# ── Red ──
alias ports='ss -tulpn'
alias myip='curl -s ifconfig.me'
alias ping='ping -c 4'                    # solo 4 pings por defecto

# ── Sistema ──
alias update='sudo apt update && sudo apt upgrade -y'
alias ..fuck='sudo !!'                    # re-ejecuta el último comando con sudo
alias please='sudo $(fc -ln -1)'          # versión más precisa de sudo !!
alias reload='exec $SHELL -l'            # reiniciar shell completamente
```

---

## Alias dinámicos

Los alias se expanden en el momento en que se ejecutan, no cuando se definen:

```bash
# Incorrecto: "date" se evalúa al definir, no al ejecutar
alias log='echo "$(date) - Inicio de sesión"'
# Esto imprime SIEMPRE la fecha en que se definió el alias, no la actual

# Correcto: usar comillas simples para que date se evalúe al ejecutar
alias log='echo "$(date) - Inicio de sesión"'
# Ahora date se ejecuta cada vez que usas el alias

# Para alias que cambian según el contexto, mejor una función:
log() { echo "$(date) - $*"; }
```

### Alias con fecha/hora

```bash
# Backup con timestamp (mejor como función)
alias bak='cp "$1"{,.bak}'               # ❌ NO funciona, alias no acepta args

# ✅ Función equivalente:
bak() { cp -r "$1" "$1.bak"; }
```

---

## alias vs funciones

| Característica | alias | función |
|---|---|---|
| Acepta argumentos | ❌ (solo al final) | ✅ (en cualquier posición) |
| Soporta lógica (if, case, for) | ❌ | ✅ |
| Acceso a `$1`, `$2`, etc. | ❌ | ✅ |
| Composición simple | ✅ (atajos cortos) | ✅ |
| `type` lo detecta | Sí, como `alias` | Sí, como `function` |
| `export -f` | ❌ | ✅ |
| Cuándo usarlo | Comandos simples sin args | Cualquier lógica > 1 línea |

```bash
# Casos donde una función es mejor que un alias:

# 1. Argumentos en medio — alias no puede
mkcd() { mkdir -p "$1" && cd "$1"; }     # ✅ función
# alias mkcd='mkdir -p ...'  ¡no sabe qué es "$1"!

# 2. Lógica condicional — alias no puede
extract() {
    case "$1" in
        *.tar.gz) tar xzf "$1" ;;
        *.zip)    unzip "$1" ;;
        *)        echo "Formato no soportado: $1" ;;
    esac
}

# 3. Comandos compuestos — alias puede pero se vuelve ilegible
update() {
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
}

# 4. Necesitas exportar la función a subshells
export -f update
```

---

## Persistencia de alias

```bash
# Los alias definidos en la terminal se pierden al cerrarla.
# Para hacerlos permanentes:

# 1. En ~/.bashrc (bash) o ~/.zshrc (zsh):
echo 'alias ll="ls -la"' >> ~/.bashrc

# 2. O mejor, en archivo separado:
echo 'alias ll="ls -la"' >> ~/.bash_aliases

# 3. Cargarlo desde .bashrc:
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# 4. Recargar
source ~/.bashrc
```

---

## Expandir o escapar alias

```bash
# Prevenir expansión de alias (usar el comando original):
\rm archivo.txt                           # ejecuta el rm real, no alias rm -i
"rm" archivo.txt                          # también funciona
'rm' archivo.txt                          # también

# Ver el comando que se ejecutaría sin ejecutarlo:
type -a rm                                # muestra: alias + binario
# rm is aliased to `rm -i'
# rm is /usr/bin/rm

# Expandir el alias (mostrar el comando sin ejecutarlo):
# Ctrl+Alt+E  (en bash con expand_aliases activado)
# O simplemente: type ll

# Para scripting: desactivar expansión de alias
shopt -u expand_aliases                   # desactivar (bash)
unalias -a                                # eliminar todos los alias
```

---

## alias en scripts

Los alias **no se expanden en scripts no interactivos** por defecto:

```bash
#!/bin/bash
# ❌ Esto NO funciona aunque el alias esté definido en .bashrc
ll /tmp                                   # command not found

# Soluciones:
# 1. Usar el comando completo:
ls -la /tmp

# 2. Activar expansión de alias en el script:
#!/bin/bash
shopt -s expand_aliases
alias ll='ls -la'
ll /tmp                                   # ahora funciona

# 3. Mejor aún: usar funciones en lugar de alias (funciones sí funcionan en scripts)
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `alias: ll: not found` | El alias no está definido en esta sesión | Definirlo temporalmente o cargar `.bashrc` |
| Alias no disponible al abrir terminal | No está en `.bashrc` | Agregar `alias ll='ls -la'` a `.bashrc` |
| Alias definido pero no funciona | El alias tiene el mismo nombre que el comando y algo lo pisó | `type nombre` para ver qué hay; reordenar definiciones |
| `ll` funciona pero no en scripts | Los alias no se expanden en scripts no interactivos | Usar función o comando completo |
| `sudo ll` no funciona | sudo no hereda alias (ejecuta binario real) | Usar `sudo -E ll` o `sudo $(type -P comando)` |
| Alias recursivo (se llama a sí mismo) | `alias ll='ll -la'` | Usar `command ll` dentro del alias: `alias ll='command ls -la'` |
| Alias con espacios se rompe | Las comillas no rodearon correctamente | Usar comillas simples: `alias algo='comando con espacios'` |

---

## Buenas prácticas

1. **alias para atajos simples** (sin argumentos). **funciones para todo lo demás**.
2. **Usar comillas simples** siempre para evitar expansión de variables al definir.
3. **No abusar**: tener 100 alias hace que tu shell sea indescifrable para otros. 10-20 bien elegidos bastan.
4. **Agrupar por tema**: comentarios `# --- Git ---`, `# --- Navegación --` en `.bash_aliases`.
5. **Evitar sobrescribir comandos del sistema** con alias contradictorios (ej: `alias ls='rm'` es peligroso).
6. **Usar `command` para llamar al binario original** dentro de alias/funciones que sobrescriben.

## Ver también

- [[type]] — diagnosticar si un comando es alias, builtin o binario
- [[which]] — buscar binarios externos
- [[Shells (bash zsh fish)]] — dónde definir alias según tu shell
- [[source]] — recargar alias sin cerrar terminal
- [[export]] — variables de entorno (junto con alias forman el perfil de shell)
- [[bash-avanzado]] — funciones, condicionales y scripting avanzado

## Enlaces externos

- [Wikipedia — alias (command)](https://en.wikipedia.org/wiki/Alias_(command))
- [GNU Bash manual — Aliases](https://www.gnu.org/software/bash/manual/html_node/Aliases.html)

#comando
