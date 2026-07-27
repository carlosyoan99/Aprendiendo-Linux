---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: media
---

# type

## Sintaxis

```bash
type comando [comando...]       # describe cómo interpretaría la shell cada comando
type -t comando                 # solo el tipo (una palabra)
type -a comando                 # todas las definiciones (alias + binario)
type -p comando                 # solo la ruta del binario externo (como which)
type -P comando                 # busca en PATH incluso si hay alias (sin ver alias)
```

## Descripción

Muestra cómo interpretaría la shell un comando dado: si es un builtin, un alias, una función, un binario externo, o no existe. Es el **mejor comando para diagnosticar** "¿qué va a pasar cuando ejecute X?".

```
type ls   →  ls is /usr/bin/ls
type cd   →  cd is a shell builtin
type ll   →  ll is aliased to `ls -la'
type if   →  if is a shell keyword
```

> Ver [[which]] para buscar binarios externos y [[alias]] para entender cómo se definen.

---

## Opciones

| Flag | Efecto | Ejemplo de salida |
|---|---|---|
| (sin flags) | Descripción completa | `ls is /usr/bin/ls` |
| `-t` | Solo el tipo (una palabra) | `file`, `builtin`, `alias`, `function`, `keyword` |
| `-a` | **Todas** las definiciones (alias + binarios) | `ll is aliased`, `ll is /usr/bin/ls` |
| `-p` | Solo la ruta del disco (como which) | `/usr/bin/ls` |
| `-P` | Busca en PATH incluso si hay alias | `/usr/bin/ls` (ignora alias) |

---

## Tipos que puede devolver

| Salida de `type -t` | Significado | Ejemplo |
|---|---|---|
| `alias` | Es un alias definido en la shell | `type -t ll` después de `alias ll='ls -la'` |
| `builtin` | Comando interno de la shell (no tiene binario) | `type -t cd`, `type -t echo` |
| `file` | Binario externo en disco (encontrado en PATH) | `type -t ls`, `type -t firefox` |
| `function` | Función definida en la shell | `type -t mkcd` después de definirla |
| `keyword` | Palabra reservada del shell | `type -t if`, `type -t for`, `type -t while` |
| `not found` | No existe en ninguna categoría | `type -t comando_inexistente` |

---

## Ejemplos

```bash
# Diagnóstico básico
type ls                                   # ls is /usr/bin/ls (file)
type cd                                   # cd is a shell builtin
type ll                                   # ll is aliased to `ls -la`
type if                                   # if is a shell keyword
type myfunc                               # myfunc is a function
type foobar                               # -bash: type: foobar: not found

# Múltiples comandos a la vez
type ls cd ll if mkdir                    # muestra todos en orden

# Modo -t: solo el tipo (útil en scripts)
type -t ls                                # file
type -t cd                                # builtin
type -t ll                                # alias

# Modo -a: todas las definiciones (esencial para detectar conflictos)
type -a echo                              # echo is a shell builtin, /usr/bin/echo
type -a ls                                # ls is /usr/bin/ls (una sola, sin alias)
type -a ll                                # ll is aliased to `ls -la'
                                          # ll is /usr/bin/ls

# Modo -p: solo la ruta del binario (como which)
type -p ls                                # /usr/bin/ls
type -p cd                                # (sin salida, cd no tiene binario)

# Modo -P: busca en PATH ignorando alias
alias ls='ls --color=auto'
type -P ls                                # /usr/bin/ls (ignora el alias)
```

---

## type en scripts — Verificar existencia

```bash
# Verificar que un comando existe antes de usarlo
if type docker &>/dev/null; then
    echo "✅ Docker disponible en $(type -p docker)"
else
    echo "❌ Docker no instalado"
fi

# Verificar tipo específico
if [[ $(type -t apt) == "file" ]]; then
    echo "Estás en una distro basada en Debian"
fi

# Con -t para detección de alias en scripts interactivos
check_comando() {
    local tipo=$(type -t "$1")
    case "$tipo" in
        alias)    echo "$1 es un alias" ;;
        builtin)  echo "$1 es un builtin de la shell" ;;
        file)     echo "$1 es un binario externo" ;;
        function) echo "$1 es una función definida" ;;
        keyword)  echo "$1 es una palabra reservada" ;;
        *)        echo "$1 no encontrado" ;;
    esac
}
```

---

## type -a — Detectar conflictos

Cuando un alias, función y binario coexisten, `type -a` revela el orden de precedencia:

```bash
# Ejemplo: si tienes alias git='git --no-pager'
type -a git
# git is aliased to `git --no-pager'
# git is /usr/bin/git

# Si además hay una función con el mismo nombre:
git() { echo "Función git envuelta"; command git "$@"; }
type -a git
# git is a function
# git () { ... }
# git is aliased to `git --no-pager'
# git is /usr/bin/git
```

**Orden de precedencia de la shell:**
1. Alias
2. Keywords (if, for, while...)
3. Funciones
4. Builtins (cd, echo, pwd...)
5. Binarios externos (encontrados en PATH)

```bash
# type -a muestra en orden inverso al de precedencia:
# Último = mayor prioridad
```

---

## hash table — Caché de rutas

La shell mantiene una **tabla hash** de rutas de comandos para no buscar en PATH cada vez:

```bash
# Ver la tabla hash actual
hash
# hits  command
#   3   /usr/bin/ls
#   1   /usr/bin/firefox
#   1   /usr/bin/git

# Limpiar la tabla hash (forzar nueva búsqueda en PATH)
hash -r

# Eliminar una entrada específica
hash -d ls

# Ver la ruta de un comando (almacenada en hash)
hash -t ls                                # /usr/bin/ls
```

### ¿Por qué importa hash?

Si instalas un programa nuevo y la shell tiene una entrada hash desactualizada (apuntando a un binario que ya no existe), puede decir "command not found" aunque el programa esté instalado:

```bash
# Síntoma: instalaste un programa pero la shell no lo encuentra
hash -r                                   # solución: limpiar caché
# o ejecutar: hash nombre_del_comando    (actualiza la entrada)
```

`type` y `hash` interactúan: `type` no usa la tabla hash (busca de nuevo), pero cuando ejecutas un comando, la shell actualiza el hash.

---

## command -v vs type vs which

```bash
# POSIX: la forma portable de verificar existencia
command -v ls                             # /usr/bin/ls (ruta del que se ejecutaría)
command -v cd                             # cd (builtins devuelven su nombre)
command -V ls                             # versión verbose (como type)
```

| Comando | Ve alias | Ve builtins | Ve funciones | Ve keywords | Estándar |
|---|---|---|---|---|---|
| `type` | ✅ | ✅ | ✅ | ✅ | Bash/Zsh (no POSIX) |
| `type -t` | ✅ | ✅ | ✅ | ✅ | Bash/Zsh |
| `type -a` | ✅ | ✅ | ✅ | ✅ | Bash/Zsh |
| `command -v` | ✅ | ✅ | ✅ | ❌ | ✅ POSIX |
| `command -V` | ✅ | ✅ | ✅ | ❌ | ✅ POSIX |
| `which` | ❌ | ❌ | ❌ | ❌ | ❌ (obsoleto) |

**Regla práctica:** En scripts POSIX usa `command -v`. En la terminal usa `type`. Evita `which`.

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `type comando` dice `not found` pero el programa está instalado | El directorio del binario no está en `$PATH` | Verificar `echo $PATH` y agregar la ruta |
| `type` muestra solo alias (no binario) y quieres el binario real | Usar `type -P` | `type -P comando` ignora alias |
| `type -a` muestra alias y función pero no binario | La función/alias está pisando al binario | Usar `\comando` para ejecutar el binario original |
| Comando funciona en terminal pero `type` dice `not found` en script | El alias no se expande en scripts | `shopt -s expand_aliases` o usar ruta completa |
| `hash` tiene ruta vieja desactualizada | Instalaste un programa pero la caché apunta a otro lado | `hash -r` para refrescar toda la caché |

### Diagnóstico rápido de comandos

```bash
# Ver QUÉ se va a ejecutar exactamente
type -a nombre_comando                    # todas las definiciones

# Verificar si un comando existe (para scripts)
if command -v docker &>/dev/null; then
    echo "Docker disponible"
fi

# Refrescar caché de rutas después de instalar algo
hash -r
```

## Ver también

- [[which]] — buscar binarios externos en PATH
- [[alias]] — cómo se definen los alias y su precedencia
- [[source]] — cargar funciones en la shell actual
- [[bash-avanzado]] — funciones y condicionales
- [[Variables de Entorno y PATH]] — cómo funciona la búsqueda en PATH

## Enlaces externos

- [Wikipedia — type (Unix)](https://en.wikipedia.org/wiki/Type_(Unix))
- [GNU Bash manual — Bash Builtins](https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html)

#comando
