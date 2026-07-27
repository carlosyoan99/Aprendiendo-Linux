---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# export

## Sintaxis

```bash
export NOMBRE=valor             # definir y exportar en un paso
export NOMBRE                   # exportar una variable ya definida
export -p                       # listar todas las variables exportadas
export -f NOMBRE_FUNCION        # exportar una función (bash)
export -n NOMBRE                # eliminar atributo de exportación (no la variable)
```

## Descripción

Asigna una **variable de entorno** disponible para todos los procesos hijos de la shell actual. Sin `export`, una variable es local a la shell — no la heredan los programas que ejecutes después.

```
Sin export:
  shell:  MI_VAR="hola"
            │
            ▼
  bash -c 'echo $MI_VAR'   → vacío (no hereda)

Con export:
  shell:  export MI_VAR="hola"
            │
            ▼
  bash -c 'echo $MI_VAR'   → "hola" (hereda)
```

> Ver [[Variables de Entorno y PATH]] para una guía completa de persistencia y variables del sistema.

---

## Ejemplos

```bash
# Variable local (solo en esta shell)
MI_VAR="hola"
echo $MI_VAR                              # funciona
bash -c 'echo $MI_VAR'                    # NO funciona (subshell no hereda)

# Variable exportada (hereda a procesos hijo)
export MI_VAR="hola"
bash -c 'echo $MI_VAR'                    # funciona: imprime "hola"

# Definir y exportar en un paso
export EDITOR=nano
export PATH="$HOME/.local/bin:$PATH"
export LANG=es_AR.UTF-8

# Forma alternativa: asignar primero, exportar después
EDITOR=nano
export EDITOR

# Exportar temporal para un solo comando
EDITOR=vim crontab -e                     # usa vim para esta ejecución, luego vuelve a nano
LANG=en_US firefox                        # abre firefox en inglés esta vez
```

---

## Variables de entorno comunes

| Variable | Propósito | Ejemplo típico |
|---|---|---|
| `PATH` | Directorios donde buscar ejecutables | `export PATH="$HOME/.local/bin:$PATH"` |
| `EDITOR` | Editor por defecto (crontab, git, etc.) | `export EDITOR=nvim` |
| `VISUAL` | Editor visual (similar a EDITOR) | `export VISUAL=nvim` |
| `PAGER` | Paginador por defecto | `export PAGER=less` |
| `LANG` | Idioma y encoding | `export LANG=es_AR.UTF-8` |
| `LC_ALL` | Forzar locale (sobrescribe LANG) | `export LC_ALL=en_US.UTF-8` |
| `BROWSER` | Navegador por defecto | `export BROWSER=firefox` |
| `TMPDIR` | Directorio temporal | `export TMPDIR=/tmp` |
| `TERM` | Tipo de terminal | `export TERM=xterm-256color` |
| `PS1` | Prompt del shell | `export PS1='\u@\h:\w\$ '` |
| `XDG_CONFIG_HOME` | Configuración de apps | `export XDG_CONFIG_HOME="$HOME/.config"` |
| `XDG_DATA_HOME` | Datos de apps | `export XDG_DATA_HOME="$HOME/.local/share"` |
| `LD_LIBRARY_PATH` | Rutas extra de librerías | `export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"` |
| `PKG_CONFIG_PATH` | Rutas extra de pkg-config | `export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"` |
| `MANPATH` | Rutas de páginas man | `export MANPATH="/usr/local/man:$MANPATH"` |
| `HISTSIZE` / `HISTFILESIZE` | Historial de comandos | `export HISTSIZE=10000` |
| `DISPLAY` | Pantalla X11 | `export DISPLAY=:0` |

---

## export -f — Exportar funciones

bash permite exportar funciones a subshells (no es POSIX):

```bash
# Definir función
saludar() { echo "Hola, $1!"; }

# Exportar para que esté disponible en subshells
export -f saludar

# Ahora funciona en bash hijo
bash -c 'saludar "Carlos"'      # "Hola, Carlos!"
```

Útil para scripts que usan `xargs` o `parallel` y necesitan funciones:

```bash
# Sin export -f falla:
procesar() { echo "Procesando $1"; }
seq 1 5 | xargs -I {} bash -c 'procesar "{}"'   # falla: procesar no existe

# Con export -f funciona:
export -f procesar
seq 1 5 | xargs -I {} bash -c 'procesar "{}"'   # funciona
```

---

## export en scripts vs shell interactiva

### En scripts

```bash
#!/bin/bash
# Las exportaciones dentro de un script NO afectan a la shell padre
export DB_HOST=localhost
./otro-script.sh              # DB_HOST está disponible para otro-script.sh
# Pero al terminar, DB_HOST no existe en la terminal que ejecutó el script
```

### En shell interactiva

```bash
# Las exportaciones persisten mientras la terminal esté abierta
export API_KEY="sk-123abc"
# Cualquier comando que ejecutes después puede leer API_KEY
# Al cerrar la terminal, se pierde
```

### Persistir entre sesiones

Agregar a `~/.bashrc`, `~/.zshrc` o `~/.profile`:

```bash
# ~/.bashrc
export EDITOR=nvim
export PAGER=less
export BROWSER=firefox
export PATH="$HOME/.local/bin:$PATH"
```

```bash
# Aplicar cambios
source ~/.bashrc
```

> Ver [[source]] para recargar configuración sin cerrar terminal.

---

## Modo debug: env, printenv, declare -p

```bash
# Listar todas las variables exportadas (entorno completo)
env
printenv

# Listar todas las variables de shell (incluyendo no exportadas)
declare -p | head -20              # variables y sus valores

# Ver una variable específica
printenv PATH
echo "$PATH"                       # más rápido pero no siempre exacto en shells raros

# Ver si una variable está exportada (vs solo definida)
declare -p MI_VAR                  # -x en la salida indica exportada
# declare -x MI_VAR="valor"       ← está exportada
# declare -- MI_VAR="valor"       ← solo local
```

### env para ejecutar con entorno modificado

```bash
# Ejecutar un comando con un entorno limpio (hereda solo lo mínimo)
env -i HOME="$HOME" PATH="$PATH" bash

# Ejecutar con una variable extra sin contaminar la shell
env DB_HOST=localhost ./script.sh

# Ver qué recibe un script
env | grep DB_HOST                # confirmar que la variable llegó
```

---

## unset vs variable vacía

```bash
# Variable vacía (definida pero sin contenido)
export MI_VAR=""
echo "${MI_VAR:-default}"         # "default" (porque la variable está vacía)

# Variable indefinida (eliminada)
unset MI_VAR
echo "${MI_VAR:-default}"         # "default" (porque no existe)

# Diferencia sutil:
[ -z "$MI_VAR" ] && echo "vacía o indefinida"   # true en ambos casos
[ -v MI_VAR ] && echo "está definida"           # solo true si no se hizo unset
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Variable no disponible en app GUI | Las apps gráficas no cargan `.bashrc` | Definir en `~/.profile` o `/etc/environment` |
| `export` no persiste al reiniciar | No está en ningún archivo de inicio | Agregar a `~/.bashrc` y hacer `source` |
| `env` muestra la variable pero el programa no la ve | El programa puede estar sanitizando el entorno | Ejecutar con `env -u VAR programa` para depurar |
| Variable se pierde en `sudo` | sudo no hereda entorno por defecto | `sudo -E comando` (preserva entorno) |
| `declare -x` aparece pero no en `env` | La variable es local al shell, no exportada realmente | Usar `export` explícito |
| `PATH` duplicado cada vez que abres terminal | Múltiples archivos agregan la misma ruta | Revisar y limpiar `~/.bashrc`, `~/.profile`, `~/.bash_profile` |

## Ver también

- [[source]] — recargar configuraciones con exportaciones
- [[Variables de Entorno y PATH]] — guía completa de variables del sistema
- [[alias]] — atajos de comandos
- [[Shells (bash zsh fish)]] — cómo carga cada shell sus variables
- [[env]] — ejecutar con entorno modificado (nota detallada si existe)

## Enlaces externos

- [Wikipedia — environment variable](https://en.wikipedia.org/wiki/Environment_variable)
- [GNU Bash manual — Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html)

#comando
