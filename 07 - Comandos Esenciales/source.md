---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# source (.)

## Sintaxis

```bash
source archivo [argumentos...]
. archivo [argumentos...]          # forma POSIX (más portable)
```

## Descripción

Ejecuta los comandos de un archivo en la **shell actual**, no en un subshell. Es la forma de recargar configuraciones de shell, activar entornos virtuales, y cargar funciones sin cerrar la terminal.

El punto (`.`) es la forma POSIX original. `source` es un alias más legible presente en bash y zsh. Es menos probable que `source` funcione en `/bin/sh` de algunas distros (Debian/Ubuntu usa dash, que lo entiende; pero en shells minimalistas, el punto es más seguro).

> Ver [[export]] para variables de entorno y [[alias]] para atajos de comandos.

---

## source vs ejecución normal

| Forma | Entorno | Efecto |
|---|---|---|
| `bash script.sh` | Subshell nuevo | Variables/funciones se pierden al terminar |
| `./script.sh` | Subshell nuevo (si tiene shebang) | Igual, no afecta a la shell actual |
| `source script.sh` | **Shell actual** | Variables, alias y funciones permanecen |
| `exec script.sh` | Reemplaza la shell actual | La shell actual es reemplazada por el script |

```bash
# Diferencia práctica:
# script.sh contiene: export NOMBRE="Carlos"
bash script.sh
echo $NOMBRE                  # vacío (subshell, no hereda)

source script.sh
echo $NOMBRE                  # "Carlos" (shell actual)

exec script.sh                # reemplaza bash por el script
echo "Esto nunca se ejecuta"  # no llega aquí
```

### source en scripts

`source` dentro de un script carga funciones o variables en ese script, **no** en la shell padre. No confundir con `source` desde la terminal interactiva.

```bash
#!/bin/bash
source /etc/os-release        # carga variables como ID, VERSION_ID
echo "Distro: $ID $VERSION_ID"
```

---

## Ejemplos de uso

### Recargar configuración del shell

```bash
# Después de editar .bashrc, los cambios no se aplican hasta que:
source ~/.bashrc               # bash
. ~/.zshrc                     # zsh (forma punto)
. ~/.profile                   # perfil de login

# También se puede hacer: exec $SHELL -l
# que reinicia la shell completamente (como abrir terminal nueva)
```

### Activar entornos virtuales (Python)

```bash
source venv/bin/activate       # entrar al entorno virtual
deactivate                     # salir

# Con virtualenvwrapper:
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
mkvirtualenv mi-proyecto

# Con conda:
source /opt/miniconda3/etc/profile.d/conda.sh
conda activate mi-ambiente
```

### Cargar variables desde .env

Útil para proyectos con variables de entorno (API keys, config):

```bash
# .env típico:
# DB_HOST=localhost
# DB_USER=admin
# API_KEY=sk-123abc

# Cargar en la shell actual:
source .env
echo "$DB_HOST"        # localhost

# Cargar para un solo comando sin contaminar la shell:
set -a                 # marca todas las variables para export
source .env
set +a                 # desmarca
```

⚠️ **Seguridad**: No versiones `.env` con claves reales. Usa `.env.example` como plantilla y añade `.env` a `.gitignore`.

### Cargar funciones de bibliotecas

```bash
# /usr/share/bash-completion/bash_completion
source /usr/share/bash-completion/bash_completion

# Script propio de funciones:
# ~/.bash_functions:
# function mkcd() { mkdir -p "$1" && cd "$1"; }
# function extract() { ... }

# En .bashrc:
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi
```

### Cargar variables de NVM (Node Version Manager)

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # carga nvm
```

---

## source con argumentos

El archivo sourceado puede recibir argumentos posicionales (`$1`, `$2`, etc.):

```bash
# archivo: saludar.sh
# echo "Hola, $1!"

source saludar.sh "Carlos"     # imprime "Hola, Carlos!"

# Sin argumentos, los $1 del script sourceado se pierden
# y se restauran los de la shell padre al terminar
```

---

## source vs exec

| Característica | `source` | `exec` |
|---|---|---|
| Proceso actual | Sigue ejecutándose después | Es reemplazado para siempre |
| Código de retorno | Vuelve al script/shell que hizo source | No vuelve (reemplazo completo) |
| Caso típico | Recargar config, activar entorno | Cambiar shell, lanzar proceso final |
| `exec bash -l` | ❌ | ✅ (reiniciar shell como nueva) |

```bash
# exec es útil para cambiar de shell en caliente:
exec zsh -l                  # cambia de bash a zsh (reemplaza la shell)
# Después de esto, bash ya no existe en esta terminal
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `source: No such file or directory` | La ruta es incorrecta | Usar ruta absoluta o verificar `pwd` |
| `source: .env: Permission denied` | Archivo sin permiso de lectura | `chmod +r .env` |
| Los cambios no se ven tras source | El archivo sourceado tiene errores | Probar `bash -n archivo.sh` para verificar sintaxis |
| `source` falla en scripts con `set -u` | Una variable en el archivo sourceado no está definida | Temporalmente: `set +u` antes de source, `set -u` después |
| `source` no encuentra el archivo en `$PATH` | `source` no busca en PATH (a diferencia de ejecución directa) | Siempre pasar ruta absoluta o relativa |
| Recargar .bashrc rompe el prompt | Una asignación en .bashrc pisó PS1 | Revisar la última línea de .bashrc que modificó PS1 |
| `source` carga dos veces el mismo archivo | Múltiples `source` sin protección | Usar guard condition: `[ -z "$_YA_CARGADO" ] && source archivo` |

### Verificar sintaxis de un archivo antes de sourcearlo

```bash
bash -n ~/.bashrc              # si hay error de sintaxis, lo reporta sin ejecutar
# Si sale sin mensaje, la sintaxis es correcta
```

### Proteger contra doble carga

```bash
# ~/.bashrc
if [ -z "$_BASHRC_LOADED" ]; then
    export _BASHRC_LOADED=1
    source ~/.bash_functions
    source ~/.bash_aliases
fi
```

---

## Buenas prácticas

1. **Usar `.` (punto) en scripts** para máxima portabilidad POSIX. `source` es más legible en shells interactivos.
2. **No sourcear archivos de fuentes no confiables**: `source` ejecuta código arbitrario en tu shell.
3. **Usar `bash -n` antes de sourcear**: detecta errores de sintaxis sin riesgos.
4. **Separar configuraciones**: en lugar de un `.bashrc` monolítico, tener `.bash_aliases`, `.bash_functions`, `.bash_env` y sourcearlos condicionalmente.
5. **Reiniciar en vez de recargar**: si `source ~/.bashrc` causa problemas de estado, `exec $SHELL -l` es más limpio (empieza de cero).

## Ver también

- [[export]] — hacer disponibles las variables a procesos hijo
- [[alias]] — atajos de comandos (también se recargan con source)
- [[Variables de Entorno y PATH]] — persistencia y alcance de variables
- [[Shells (bash zsh fish)]] — qué shell usas y cómo carga sus configs
- [[type]] — diagnosticar qué se ejecutará con un comando

## Enlaces externos

- [Wikipedia — source (command)](https://en.wikipedia.org/wiki/Source_(command))
- [GNU Bash manual — Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html)

#comando
