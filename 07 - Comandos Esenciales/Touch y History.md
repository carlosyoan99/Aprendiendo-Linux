---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# Touch y History

## Touch

### Sintaxis
```
touch [opciones] archivo...
```

### Descripción

`touch` actualiza las marcas de tiempo (atime, mtime) de un archivo a la hora actual. Si el archivo no existe, **lo crea vacío** (su uso más común). Esencial para scripts que necesitan crear archivos vacíos, o forzar recompilaciones (make usa timestamps).

### Opciones frecuentes

| Flag | Efecto |
|---|---|
| `-a` | Cambiar solo el atime (access time) |
| `-m` | Cambiar solo el mtime (modify time) |
| `-c` | No crear el archivo si no existe |
| `-t timestamp` | Usar un timestamp específico (YYYYMMDDhhmm[.ss]) |
| `-d "fecha"` | Usar una fecha en formato texto |
| `-r archivo` | Usar las marcas de tiempo de otro archivo |

### Ejemplos

```bash
# Crear archivo vacío
touch nota.txt

# Crear múltiples archivos
touch archivo1.txt archivo2.txt archivo3.txt
touch archivo-{1..5}.txt         # crea archivo-1.txt ... archivo-5.txt

# No crear si no existe (solo actualizar timestamp)
touch -c solo-si-existe.txt

# Timestamp específico (YYYYMMDDhhmm)
touch -t 202612251200 año-nuevo.txt      # 25 Dic 2026, 12:00

# Timestamp en formato legible
touch -d "2 weeks ago" viejo.txt
touch -d "2025-01-01 00:00:00" arranque.txt

# Copiar timestamp de otro archivo
touch -r modelo.txt nuevo.txt            # nuevo.txt tendrá las mismas fechas que modelo.txt
```

---

## History

### Sintaxis
```
history [opciones]
!n           # ejecutar comando número n del historial
!!           # ejecutar el último comando (equivalente a !-1)
!texto       # ejecutar el último comando que empiece con "texto"
!?texto      # ejecutar el último comando que contenga "texto"
^viejo^nuevo # reemplazar en el último comando y ejecutar
```

### Descripción

`history` muestra el historial de comandos ejecutados en la shell actual (bash, zsh). Es una de las herramientas de productividad más potentes del terminal, permitiendo re-ejecutar, buscar y modificar comandos anteriores sin volver a escribirlos.

### Opciones frecuentes

| Flag | Efecto |
|---|---|
| `-c` | Limpiar el historial completo (sesión actual) |
| `-d offset` | Eliminar una línea específica del historial |
| `-a` | Añadir la sesión actual al archivo de historial |
| `-w` | Escribir el historial actual al archivo |
| `-r` | Leer el archivo de historial y añadirlo al actual |
| `-p` | Expandir un patrón de historial sin ejecutarlo |
| `-s comando` | Añadir un comando al historial sin ejecutarlo |

### Ejemplos

```bash
# Mostrar historial
history                      # lista numerada de comandos
history 20                   # últimos 20 comandos

# Re-ejecutar comandos
!!                           # repetir el último comando
!100                         # ejecutar el comando #100 del historial
!-3                          # ejecutar el tercer comando desde el final
!ssh                         # ejecutar el último comando que empiece con ssh
!?systemctl                  # ejecutar el último comando que contenga "systemctl"

# Modificar y ejecutar
^pacman^yay                  # reemplazar "pacman" por "yay" en el último comando

# Añadir comentario al historial (útil para recordar contexto)
# Este comando instaló el driver NVIDIA y reinició GDM
sudo pacman -S nvidia-dkms; history -s "# instalar nvidia"
```

### Control del historial (variables de entorno)

```bash
# Tamaño del historial (en ~/.bashrc o ~/.zshrc)
export HISTSIZE=10000         # comandos en memoria (por defecto 1000)
export HISTFILESIZE=100000    # líneas en el archivo ~/.bash_history (~/.zsh_history)

# Cómo se guarda
export HISTCONTROL=ignoredups   # no guardar duplicados consecutivos
export HISTCONTROL=ignorespace  # no guardar comandos que empiecen con espacio
export HISTCONTROL=erasedups    # no guardar duplicados en todo el historial

# HISTFILE (dónde se guarda)
echo $HISTFILE                  # ~/.bash_history por defecto
export HISTFILE=~/.config/bash/history  # personalizado + XDG

# Formato de timestamp
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
```

### Búsqueda interactiva

```bash
# Ctrl+r en bash/zsh: búsqueda inversa en el historial
# (reverse-i-search)`'`: 
# Escribe parte del comando y muestra la coincidencia más reciente
# Pulsa Ctrl+r de nuevo para ir a la siguiente coincidencia
# Enter para ejecutar, Esc para editar, Ctrl+g para cancelar

# Si usas zsh con historial compartido entre sesiones:
setopt SHARE_HISTORY          # compartir historial entre terminales
setopt INC_APPEND_HISTORY     # escribir al instante (no al cerrar sesión)

# En bash:
shopt -s histappend           # append, no overwrite
```

### Atajos de teclado para history

| Atajo | Acción |
|---|---|
| `↑` / `↓` | Navegar por el historial |
| `Ctrl+r` | Búsqueda inversa |
| `Ctrl+s` | Búsqueda hacia adelante (quizá desactivado por stty) |
| `Alt+.` / `Alt+_` | Último argumento del comando anterior |
| `Alt+Ctrl+y` | Último argumento del comando anterior (bash) |
| `Ctrl+p` / `Ctrl+n` | Anterior / siguiente comando (como ↑/↓ en emacs mode) |

### Expansión de argumentos

```bash
!$                          # último argumento del comando anterior
!:0                         # el comando en sí (primer palabra)
!:1                         # primer argumento
!:2-4                       # argumentos 2 a 4
!:*                         # todos los argumentos
!:^                         # primer argumento
!:$                         # último argumento

# Ejemplo práctico
mkdir -p proyecto/src proyecto/docs proyecto/test
cd !$                        # cd proyecto/test
# Equivalente a: cd proyecto/test

vim /etc/hosts
sudo !!                      # sudo vim /etc/hosts

mkdir -p /var/www/misitio
cd !:1                       # cd /var/www/misitio
```

### Compartir historial entre sesiones (zsh)

```bash
# ~/.zshrc — historial compartido entre terminales
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

export HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000
```

### Limpiar historial sensible

```bash
# Eliminar un comando específico
history -d 150               # eliminar comando #150

# Eliminar rangos
for i in {150..200}; do history -d $i; done

# Limpiar todo y empezar de nuevo
history -c                   # borrar historial en memoria
> ~/.bash_history            # borrar archivo de historial

# Evitar que un comando se guarde (poner espacio al inicio)
#  secret_token     ← no se guarda si HISTCONTROL=ignorespace
```

## Notas y advertencias

- **Touch** no modifica el contenido del archivo — solo sus metadatos de tiempo.
- `touch` es útil en scripts para crear archivos de lock o marca (`.flag`).
- **History** guarda los comandos en `~/.bash_history` (bash) o `~/.zsh_history` (zsh).
- Los comandos que empiezan con espacio **no se guardan** si `HISTCONTROL=ignorespace`.
- `HISTFILE` se puede reubicar según [[XDG Base Directory y dotfiles modernos]].
- Si usas `!!` en un script, asegúrate de que el historial tenga el comando esperado — no es fiable en scripts.

## Ver también

- [[cat]] — ver contenido de archivos (touch crea archivos vacíos)
- [[Variables de Entorno y PATH]] — HISTFILE, HISTSIZE, HISTCONTROL
- [[XDG Base Directory y dotfiles modernos]] — mover .bash_history a ~/.local/share
- [[La Shell]] — cómo funciona el historial en diferentes shells
- [[Shells (bash zsh fish)]] — diferencias en el manejo del historial

## Enlaces externos

- [Wikipedia - touch](https://en.wikipedia.org/wiki/Touch_(Unix))
- [Wikipedia - history (command)](https://en.wikipedia.org/wiki/History_(command))
- [GNU Coreutils - touch manual](https://www.gnu.org/software/coreutils/manual/html_node/touch-invocation.html)

#comando
