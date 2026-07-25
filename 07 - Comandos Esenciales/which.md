---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: comando
prioridad: media
---

# which

## Sintaxis

```bash
which comando [comando...]     # muestra la ruta del binario
which -a comando               # todas las rutas coincidentes en PATH
which -s comando               # modo silencioso (solo código de salida)
```

## Descripción

Localiza la ruta absoluta de un **binario externo** buscando en los directorios listados en `$PATH`. Responde a la pregunta "¿dónde está instalado este programa?". Solo ve binarios externos — **no detecta alias, builtins ni funciones**.

```
which firefox   →  /usr/bin/firefox
which cd        →  (nada, cd no tiene binario)
which python3   →  /usr/bin/python3
```

> `which` es una herramienta externa (no un builtin de la shell). En sistemas modernos, `type` y `command -v` son alternativas más precisas. Ver [[type]] para diagnóstico completo.

---

## Opciones

| Flag | Efecto |
|---|---|
| (sin flags) | Muestra la primera ruta coincidente en PATH |
| `-a` | Muestra **todas** las rutas coincidentes en PATH |
| `-s` | Modo silencioso (sin salida, solo código de retorno) |

---

## Ejemplos

```bash
# Uso básico
which bash                                # /usr/bin/bash
which python3                             # /usr/bin/python3
which docker                              # /usr/bin/docker

# Múltiples comandos
which ls grep sed awk                     # busca todos y muestra las rutas

# Todas las ubicaciones
which -a python3                          # ¿cuántos Python hay instalados?
# /usr/bin/python3
# /usr/local/bin/python3
# /home/user/.pyenv/shims/python3

# Modo silencioso (para scripts)
which -s docker && echo "Docker instalado"
```

---

## which -a: múltiples versiones del mismo programa

Útil cuando tienes varias versiones del mismo binario instaladas:

```bash
# ¿Cuántos Python tengo instalados?
which -a python3
# /home/user/.pyenv/shims/python3     ← esta se ejecuta (primera en PATH)
# /usr/bin/python3                    ← la del sistema

# ¿Cuántos PHP?
which -a php
# /usr/bin/php
# /usr/local/bin/php                  ← versión compilada manualmente

# ¿Dónde está el Node.js que se ejecuta realmente?
which -a node
# /home/user/.nvm/versions/node/v20.0.0/bin/node  ← la activa (primera)
# /usr/bin/node                                  ← la del sistema
```

```bash
# Ver el orden de PATH y entender la precedencia:
echo "$PATH" | tr ':' '\n'
# /home/user/.pyenv/shims
# /home/user/.nvm/versions/node/v20.0.0/bin
# /usr/local/bin
# /usr/bin
# /bin
# /usr/games
# El primer directorio que contenga el binario gana
```

---

## which en scripts

```bash
# Ejemplo 1: verificar existencia con salida silenciosa
if which docker >/dev/null 2>&1; then
    echo "Docker está instalado en $(which docker)"
else
    echo "Docker no está instalado"
fi

# Ejemplo 2: modo -s (solo código de retorno, sin salida)
if which -s docker; then
    echo "Docker disponible"
fi

# ⚠️ En scripts modernos, prefiere command -v para portabilidad POSIX:
if command -v docker &>/dev/null; then
    echo "Docker disponible"
fi
```

---

## which vs type vs command -v

```bash
# Diferencia práctica:
alias la='ls -A'

which la                                  # /usr/bin/ls (ve el binario subyacente)
type la                                   # la is aliased to `ls -A'
type -t la                                # alias
command -v la                             # alias (el que se ejecutaría)
```

| Comando | Ve alias | Ve builtins | Ve funciones | Salida |
|---|---|---|---|---|
| `which` | ❌ | ❌ | ❌ | Solo ruta del binario externo |
| `type` | ✅ | ✅ | ✅ | Descripción textual completa |
| `type -t` | ✅ | ✅ | ✅ | Solo el tipo (alias, file, builtin...) |
| `type -a` | ✅ | ✅ | ✅ | Todas las definiciones |
| `command -v` | ✅ | ✅ | ✅ | Ruta o nombre del que se ejecuta |
| `command -V` | ✅ | ✅ | ✅ | Descripción verbose |

**Cuándo usar cada uno:**

- **`which`** — Consulta rápida: "¿dónde está instalado X?" (solo binarios)
- **`type`** — "¿qué va a ejecutarse exactamente?" (ve alias y builtins)
- **`command -v`** — En scripts POSIX para verificar existencia portátil
- **`type -a`** — "¿hay conflicto? ¿qué más existe con este nombre?"
- **`which -a`** — "¿cuántas versiones de X tengo instaladas?"

---

## hash — Caché de rutas

La shell interna mantiene una tabla hash para no buscar en PATH cada vez:

```bash
# Ver la tabla hash
hash
# hits  command
#   5   /usr/bin/firefox
#   3   /usr/bin/git

# Limpiar caché (útil si instalaste un programa nuevo)
hash -r
```

`which` no usa la tabla hash (siempre busca en PATH directamente). Pero la shell sí usa hash cuando ejecutas un comando, lo que puede causar que un binario recién instalado no se encuentre aunque `which` lo muestre.

```bash
# Síntoma: instalaste un programa, which lo encuentra, pero la shell dice "not found"
which mi-nuevo-programa   # /usr/local/bin/mi-nuevo-programa (lo encuentra)
mi-nuevo-programa         # command not found (la hash apunta a vieja ubicación o no existe)
hash -r                   # limpiar caché → ahora funciona
```

---

## which y symlinks

```bash
# which sigue symlinks y muestra la ruta real
which node
# /home/user/.nvm/versions/node/v20.0.0/bin/node

# Si node es un symlink a /usr/bin/node20, which muestra adónde apunta
ls -l "$(which node)"
# lrwxrwxrwx ... node -> /usr/bin/node20
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `which comando` no muestra nada pero el comando funciona | Es un builtin de la shell (cd, echo, pwd) | Usar `type comando` |
| `which comando` no muestra nada y el comando tampoco funciona | El programa no está instalado | Instalarlo o revisar PATH está bien |
| `which comando` muestra una ruta, pero ejecutar `comando` dice otra cosa | Hay un alias/función pisando al binario | `type -a comando` para ver todas las definiciones |
| `which -a` muestra rutas que no esperabas | Hay versiones duplicadas del programa | Revisar PATH y reordenar |
| `which` dice que existe pero la shell no lo encuentra | hash desactualizada | `hash -r` |
| `which` no existe en la shell | which no es un builtin y puede no estar instalado | `apt install which` o usar `command -v` |
| `which docker` lo encuentra pero docker falla | El binario está pero sin permisos de ejecución | `chmod +x $(which docker)` |

### which no está instalado

Algunas distros minimalistas (como contenedores Docker Alpine) no incluyen `which`:

```bash
# En Alpine:
which docker                              # which: not found
# Solución: instalar o usar alternativas
apk add which                             # instalarlo
# O mejor: usar command -v que es POSIX y siempre está disponible
command -v docker                         # /usr/bin/docker
```

---

## Buenas prácticas

1. **En scripts, prefiere `command -v`** sobre `which`. Es POSIX, siempre disponible, y más rápido (es builtin, no ejecuta un binario externo).
2. **Usa `type -a` para diagnosticar conflictos** entre alias, funciones y binarios.
3. **`which -a` es útil para depurar múltiples versiones** del mismo programa (Python, PHP, Node).
4. **Recuerda que `which` no ve alias**: si un alias está pisando a un binario, `which` te engañará mostrando el binario subyacente.
5. **Después de instalar software nuevo**, ejecuta `hash -r` para evitar falsos "command not found".

## Ver también

- [[type]] — diagnóstico completo: alias, builtins, funciones, keywords
- [[alias]] — atajos de comandos (que which no detecta)
- [[Variables de Entorno y PATH]] — cómo se construye y ordena PATH
- [[source]] — cargar funciones en la shell
- [[bash-avanzado]] — funciones y scripts
- [[Cheat Sheet - Comandos Esenciales]] — resumen de comandos

## Enlaces externos

- [Wikipedia — which](https://en.wikipedia.org/wiki/Which_(command))
- [GNU which — official](https://www.gnu.org/software/which/)

#comando
