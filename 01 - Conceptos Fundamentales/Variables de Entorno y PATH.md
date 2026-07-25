---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: concepto
prioridad: media
---

# Variables de Entorno y PATH

> Las variables de entorno son pares **clave=valor** disponibles para todos los procesos de una sesión de shell. `PATH` es la más importante: lista de directorios donde el shell busca ejecutables cuando escribes un comando sin ruta absoluta.

## Qué son

Cada proceso en Linux hereda un conjunto de variables de entorno de su proceso padre. Modificarlas permite cambiar el comportamiento de programas sin tocar su código: idioma, editor por defecto, rutas de librerías, etc.

```bash
# Ver todas las variables de entorno activas
env
printenv

# Ver una variable específica
echo "$PATH"
echo "$HOME"
echo "$SHELL"

# Ver el valor de una variable con printenv
printenv USER
```

## Variables de entorno comunes

| Variable | Propósito | Ejemplo típico |
|---|---|---|
| `PATH` | Directorios donde buscar ejecutables | `/usr/local/bin:/usr/bin:/bin` |
| `HOME` | Directorio personal del usuario | `/home/user` |
| `USER` | Nombre del usuario actual | `carlos` |
| `SHELL` | Shell por defecto | `/bin/bash` o `/usr/bin/zsh` |
| `LANG` | Idioma y codificación | `es_AR.UTF-8` |
| `EDITOR` | Editor de texto por defecto | `vim`, `nano`, `code --wait` |
| `PAGER` | Paginador por defecto | `less` |
| `BROWSER` | Navegador web por defecto | `firefox` |
| `PWD` | Directorio de trabajo actual | `/home/user/proyectos` |
| `OLDPWD` | Directorio anterior (antes del último `cd`) | `/home/user` |
| `TERM` | Tipo de terminal | `xterm-256color` |
| `DISPLAY` | Pantalla X11 (entornos gráficos) | `:0` o `:1` |
| `WAYLAND_DISPLAY` | Pantalla Wayland | `wayland-0` |
| `XDG_CONFIG_HOME` | Directorio de configuraciones de usuario | `$HOME/.config` |
| `XDG_DATA_HOME` | Directorio de datos de usuario | `$HOME/.local/share` |
| `TMPDIR` | Directorio temporal | `/tmp` |
| `LD_LIBRARY_PATH` | Directorios extra para librerías compartidas (`.so`) | `/usr/local/lib` |
| `PKG_CONFIG_PATH` | Directorios extra para archivos `.pc` de pkg-config | `/usr/local/lib/pkgconfig` |

## PATH en detalle

`PATH` es una lista de directorios separados por `:`. Cuando escribes `firefox`, el shell recorre cada directorio del `PATH` en orden hasta encontrar un ejecutable llamado `firefox`.

```bash
# Ver PATH actual
echo "$PATH"
# /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

# Ver qué binario se ejecuta para un comando
which firefox      # /usr/bin/firefox
type firefox       # firefox is /usr/bin/firefox
command -v firefox # /usr/bin/firefox
```

### Cómo funciona la búsqueda en PATH

```bash
# Ejemplo de búsqueda manual de un ejecutable
IFS=':' read -ra dirs <<< "$PATH"
for dir in "${dirs[@]}"; do
    [ -x "$dir/firefox" ] && echo "Encontrado en: $dir/firefox" && break
done
```

## Definir variables

### Temporal (solo para la sesión actual)
```bash
export MI_VAR="valor"
echo "$MI_VAR"   # valor
```

### Temporal para un solo comando
```bash
EDITOR=nano crontab -e   # usa nano solo para este comando
LANG=en_US firefox       # abre firefox en inglés esta vez
```

### Eliminar una variable
```bash
unset MI_VAR
```

## Persistir variables

Para que las variables sobrevivan entre sesiones, hay que definirlas en los archivos de inicio del shell.

### Por usuario

| Archivo | Cuándo se carga | Para qué |
|---|---|---|
| `~/.bashrc` / `~/.zshrc` | Cada shell interactiva | Variables de uso diario, alias, funciones |
| `~/.profile` | Sesión de login (gráfica o TTY) | Variables de entorno que heredan todos los procesos |
| `~/.bash_profile` / `~/.zlogin` | Solo login shell | Similar a .profile, específico de Bash/Zsh |
| `~/.config/environment.d/*.conf` | systemd --user | Variables para servicios de systemd por usuario |

Ejemplo de `~/.bashrc`:
```bash
# Agregar ~/.local/bin al PATH
export PATH="$HOME/.local/bin:$PATH"

# Editor por defecto
export EDITOR=nvim
export VISUAL=nvim

# Idioma
export LANG=es_AR.UTF-8
export LC_ALL=es_AR.UTF-8
```

### A nivel de sistema

| Archivo | Cuándo se carga | Para qué |
|---|---|---|
| `/etc/environment` | Variable independiente del shell (PAM) | Rutas globales, locale del sistema |
| `/etc/profile` | Login shell de todos los usuarios | Variables globales heredadas |
| `/etc/bash.bashrc` / `/etc/zshrc` | Cada shell interactiva (todos los usuarios) | Config global del shell |
| `/etc/security/pam_env.conf` | Variables PAM | Variables de autenticación |

```bash
# Formato de /etc/environment (sin export, sin comillas)
PATH=/usr/local/bin:/usr/bin:/bin
LANG=es_AR.UTF-8
```

## Usos prácticos

```bash
# Agregar ~/.local/bin al PATH (para pip install --user, cargo, etc.)
export PATH="$HOME/.local/bin:$PATH"

# Agregar directorio de Go al PATH
export PATH="$HOME/go/bin:$PATH"

# Agregar directorios de flatpak
export PATH="/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin:$PATH"

# Editor por defecto para git, crontab, sudo
export EDITOR=nvim

# Tema de Oh My Zsh o plugin manager
export ZSH_THEME="agnoster"

# Deshabilitar telemetría
export DO_NOT_TRACK=1
export HOMEBREW_NO_ANALYTICS=1
```

## Troubleshooting

| Error | Causa | Solución |
|---|---|---|
| `command not found: foo` | `foo` no está en ningún directorio del PATH | `which foo` o `find /usr -name foo` para localizarlo |
| `command not found` tras instalar con pip/cargo | El directorio de instalación no está en PATH | Agregar `$HOME/.local/bin` o `$HOME/go/bin` al PATH |
| Variable no disponible al abrir terminal | Definida en el archivo equivocado | Mover a `~/.bashrc` o `~/.profile` según cuándo se necesite |
| Las variables no se ven en apps GUI | Las apps gráficas no cargan `.bashrc` | Definir en `~/.profile` o `/etc/environment` |
| `PATH` duplicado tras mucho tiempo | Múltiples archivos de inicio agregan lo mismo | Revisar y limpiar `~/.bashrc`, `~/.profile`, `~/.bash_profile` |

## Buenas prácticas

1. **Usar rutas absolutas** en scripts (evita depender del PATH del usuario)
2. **No poner `.` en el PATH** (riesgo de seguridad: ejecutar scripts maliciosos desde el directorio actual)
3. **Agregar al principio del PATH** para priorizar versiones locales sobre las del sistema
4. **Separar variables de entorno de alias/funciones**: variables en `~/.profile`, alias en `~/.bashrc`
5. **Usar `export` solo una vez**: `export PATH="$HOME/bin:$PATH"` es suficiente
6. **Verificar cambios** con `exec $SHELL` o `source ~/.bashrc` sin cerrar la terminal

## Ver también

- [[Shells (bash zsh fish)]] — cómo carga cada shell sus variables
- [[Symlinks y Dotfiles]] — gestión de archivos de configuración
- [[XDG Base Directory y dotfiles modernos]] — estándar de directorios de configuración
- [[sudo]] — cómo sudo maneja las variables de entorno

## Enlaces externos

- [Arch Wiki — Environment Variables](https://wiki.archlinux.org/title/Environment_variables)
- [Debian Wiki — Environment](https://wiki.debian.org/EnvironmentVariables)
- [Wikipedia — Variable de entorno](https://es.wikipedia.org/wiki/Variable_de_entorno)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)

#concepto
