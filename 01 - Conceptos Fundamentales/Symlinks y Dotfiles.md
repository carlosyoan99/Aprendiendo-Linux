---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: concepto
prioridad: media
---

# Symlinks y Dotfiles

## Definición

Un **symlink** (enlace simbólico, también llamado "soft link") es un archivo especial que apunta a otra ruta del sistema — similar a un acceso directo en Windows, pero a nivel del sistema de archivos. Los **dotfiles** son archivos de configuración que empiezan con `.` (ocultos por convención en Unix/Linux) y residen normalmente en `$HOME`.

---

## Symlinks (enlaces simbólicos)

### Crear y gestionar symlinks

```bash
# Crear un symlink (ln -s ORIGEN ENLACE)
ln -s /ruta/al/archivo-real /ruta/del/enlace

# Ejemplos concretos:
ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.config/i3/config ~/.config/i3/config
ln -s /media/disco1/fotos ~/fotos         # acceso rápido a otra partición

# Ver symlinks con ls -l (se muestran con "→")
ls -l ~/.bashrc
# lrwxrwxrwx 1 carlos carlos 22 jul 19 12:00 .bashrc → /home/carlos/dotfiles/.bashrc

# Detectar adónde apunta un symlink
readlink -f ~/.bashrc                      # ruta absoluta completa
realpath ~/.bashrc                         # también resuelve symlinks

# Encontrar symlinks rotos (apuntan a rutas que ya no existen)
find /home/carlos -xtype l 2>/dev/null     # symlinks rotos
find /home/carlos -type l ! -exec test -e {} \; -print
```

### Hard links vs Soft links

| Característica | Symlink (soft) | Hard link |
|---|---|---|
| **Código inodo** | Distinto al original | Mismo que el original |
| **Cruzar sistemas de archivos** | ✅ Sí | ❌ No (misma partición) |
| **Directorios** | ✅ Sí | ❌ No (solo archivos) |
| **Ruta rota si se mueve/mata** | ✅ Sí (link muerto) | ❌ No (sigue vivo) |
| **Comando** | `ln -s` | `ln` (sin -s) |

```bash
# Hard link (mismo inodo — indistinguible del original)
ln ~/documentos/informe.pdf ~/backups/informe.pdf

# Verificar que comparten inodo
ls -li ~/documentos/informe.pdf ~/backups/informe.pdf
# 123456 -rw-r--r-- 2 carlos  ...  informe.pdf   ← mismo inodo, cuenta 2
```

### Anatomía técnica: inodos

Un **inodo** (index node) es la estructura de datos del sistema de archivos que almacena los metadatos de un archivo o directorio (permisos, propietario, tamaño, timestamps), **excepto su nombre de archivo y contenido**. El contenido real se guarda en bloques de datos en el disco; el inodo apunta a esos bloques.

```
┌─────────────┐      ┌──────────────────┐
│  Hard link  │─────→│     Inodo #123   │
│  (nombre)   │      │  dueño: carlos   │
│  archivo1   │      │  tamaño: 10KB    │
└─────────────┘      │  permisos: 644   │
                      │  link count: 2   │←─── cuenta de hard links
┌─────────────┐      │  bloques: [A,B,C]│
│  Hard link  │─────→│                  │
│  (nombre)   │      └────────┬─────────┘
│  archivo2   │               │
└─────────────┘               ▼
                        ┌────────────┐
                        │ Contenido  │
                        │ (bloques)  │
                        └────────────┘
```

#### Link count (número de enlaces)

Cada inodo tiene un campo `nlink` que cuenta **cuántos nombres (hard links) apuntan a él**:

```bash
# El link count se ve en el tercer campo de ls -l
touch archivo.txt
ls -l archivo.txt
# -rw-r--r-- 1 carlos ... archivo.txt    ← link count = 1

ln archivo.txt archivo-hard.txt
ls -l archivo.txt archivo-hard.txt
# -rw-r--r-- 2 carlos ... archivo.txt     ← link count = 2
# -rw-r--r-- 2 carlos ... archivo-hard.txt

ls -li archivo.txt archivo-hard.txt       # mismo inodo, link count = 2
# 654321 -rw-r--r-- 2 carlos ... archivo.txt
# 654321 -rw-r--r-- 2 carlos ... archivo-hard.txt
```

**Comportamiento clave**:
- Cuando `link count = 0`, el kernel sabe que no hay nombres apuntando al inodo → elimina el inodo y libera los bloques de datos. Eso es **borrar un archivo**.
- `rm` **no borra el inodo inmediatamente** — solo decrementa el link count. Si `link count > 0`, el archivo sigue existiendo aunque ya no tenga el nombre original.
- Un proceso que tiene el archivo **abierto** (con un file descriptor) mantiene el inodo vivo aunque `link count = 0`. El espacio se libera solo cuando el proceso cierra el fd. Por eso `df` y `du` pueden no coincidir (ver [[df y du]] — `lsof | grep deleted`).

```bash
# Ejemplo: borrar un archivo mientras un proceso lo tiene abierto
echo "datos importantes" > ~/test.log
less ~/test.log &
rm ~/test.log
# El archivo ya no aparece en ls, pero el proceso less sigue teniendo los datos
# El espacio solo se libera cuando matas el proceso less
lsof | grep '(deleted)'    # busca archivos borrados pero retenidos
```

#### Diferencia clave: inodo de symlink vs hard link

| Aspecto | Hard link | Symlink |
|---|---|---|
| **Inodo** | **Comparte el mismo inodo** que el archivo original | **Tiene su propio inodo** distinto (un inodo de tipo symlink) |
| **Contenido del inodo** | Apunta a los bloques de datos del archivo | Almacena la **ruta de texto** del destino (no los datos) |
| **Link count del original** | Aumenta (pasa de 1 a 2, 3, etc.) | **No cambia** |
| **Espacio en disco** | 0 bytes extra (solo una entrada de directorio) | Ocupa el tamaño de la ruta (unos pocos bytes) + un inodo |
| **Restricción** | Misma partición (mismo filesystem) | Cualquier partición, cualquier máquina (ruta) |
| **Si el original se borra** | El archivo sigue vivo (link count > 0) | **El symlink se rompe** (apunta a una ruta que ya no existe) |

#### ¿Por qué no se permiten hard links a directorios?

Porque rompería la estructura acíclica del sistema de archivos. Si pudieras hacer un hard link a `/`, crearías un ciclo que `find`, `du` y el propio kernel no podrían resolver.

**Excepción**: los directorios `.` y `..` son hard links implícitos que el kernel gestiona internamente:

```bash
# Cada directorio tiene:
# - Un hard link para .  (link a sí mismo)
# - Un hard link para .. (link al padre)
# - Un hard link por cada subdirectorio (en su entrada ..)
ls -la /tmp
# drwxrwxrwt 2 root root ... .             ← link count del directorio
# Un directorio vacío tiene link count = 2 (. y ..)
# Un directorio con 1 subdirectorio tiene link count = 3 (. y .. del hijo)
```

### Usos comunes de symlinks

| Uso | Ejemplo |
|---|---|
| **Versionar dotfiles** | `~/dotfiles/.bashrc` → `~/.bashrc` |
| **Montajes persistentes** | `~/fotos` → `/media/disco1/fotos` |
| **Atajos a ejecutables** | `~/bin/latest-version` → `/opt/programa-3.2/bin/prog` |
| **Compatibilidad de rutas** | `/usr/bin/python` → `/usr/bin/python3.12` |
| **Cache o logs en otro disco** | `/var/log/apache` → `/mnt/disco-grande/logs` |

### Symlinks rotos: cómo encontrarlos y arreglarlos

```bash
# Encontrar y listar symlinks rotos
find . -type l ! -exec test -e {} \; -print 2>/dev/null

# Contar cuántos hay
find . -type l ! -exec test -e {} \; | wc -l

# Arreglar un symlink roto (reapuntar)
ln -sf /nueva/ruta /ruta/del/symlink-roto

# Eliminar symlinks rotos que ya no quieres
find ~/bin -type l ! -exec test -e {} \; -delete
```

---

## Dotfiles

Los dotfiles son archivos de configuración que comienzan con `.` (punto), lo que los hace **ocultos** por defecto en `ls` sin la flag `-a`. Viven principalmente en `$HOME`.

### Dotfiles esenciales por categoría

| Shell | Archivos | Propósito |
|---|---|---|
| **Bash** | `~/.bashrc`, `~/.bash_profile`, `~/.bash_logout` | Configuración de shell interactivo y login |
| **Zsh** | `~/.zshrc`, `~/.zprofile`, `~/.zshenv` | Lo mismo para Zsh |
| **Fish** | `~/.config/fish/config.fish` | Config de Fish shell |

| Apps | Archivos | Propósito |
|---|---|---|
| **Git** | `~/.gitconfig`, `~/.gitignore_global` | Config de Git, alias, exclusión global |
| **Vim/Neovim** | `~/.vimrc` / `~/.config/nvim/init.lua` | Editor de texto |
| **tmux** | `~/.tmux.conf` | Terminal multiplexor |
| **i3/Hyprland** | `~/.config/i3/config` / `~/.config/hypr/hyprland.conf` | Window manager |
| **SSH** | `~/.ssh/config` | Configuración de conexiones SSH |
| **npm/pip/cargo** | `~/.npmrc`, `~/.pip/pip.conf`, `~/.cargo/config.toml` | Gestores de paquetes |

### Estrategias para gestionar dotfiles

#### 1. Symlinks (la más simple)

La estrategia más directa: tener un repo `~/dotfiles/` y crear symlinks desde `$HOME`:

```bash
mkdir ~/dotfiles && cd ~/dotfiles
git init
cp ~/.bashrc ~/.bashrc.orig              # backup por si acaso
mv ~/.bashrc ~/dotfiles/
ln -s ~/dotfiles/.bashrc ~/.bashrc
# Repetir para cada archivo...
```

**Problema**: si tienes muchos archivos, hacer los symlinks uno por uno es tedioso.

#### 2. GNU Stow (organizado por directorios)

**GNU Stow** automatiza la creación de symlinks. Organizas tus dotfiles en carpetas por programa:

```
~/dotfiles/
├── bash/
│   └── .bashrc
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
├── nvim/
│   └── .config/
│       └── nvim/
│           └── init.lua
└── i3/
    └── .config/
        └── i3/
            └── config
```

```bash
cd ~/dotfiles
stow bash                               # crea ~/.bashrc → ~/dotfiles/bash/.bashrc
stow git                                # crea ~/.gitconfig → ...
stow nvim                               # crea ~/.config/nvim/init.lua → ...

# Eliminar symlinks de un paquete
stow -D bash

# Simular (ver qué haría sin hacerlo)
stow -n bash
```

**Ventaja**: los dotfiles quedan organizados por programa, no todo mezclado en la raíz del repo.

#### 3. chezmoi (gestor avanzado con plantillas)

**chezmoi** es un gestor de dotfiles más completo que permite plantillas por máquina, ejecutar scripts en cada actualización, y manejar permisos:

```bash
# Instalar
sudo pacman -S chezmoi                   # Arch
sudo apt install chezmoi                 # Debian/Ubuntu

# Inicializar un repo
chezmoi init

# Añadir un dotfile
chezmoi add ~/.bashrc
chezmoi add ~/.config/hypr/hyprland.conf

# Aplicar cambios (desde el repo)
chezmoi apply

# Editar un dotfile gestionado
chezmoi edit ~/.bashrc

# Ver diferencias entre el repo y el sistema
chezmoi diff

# Sincronizar desde GitHub
chezmoi init https://github.com/tu-usuario/dotfiles.git
chezmoi apply
```

**Plantillas por máquina** (chezmoi permite tener `<archivo>_<hostname>`):

```bash
# Ejemplo: ~/.local/share/chezmoi/dot_bashrc_<hostname> — solo se aplica en esa máquina
# Variables: .chezmoi.hostname, .chezmoi.os, .chezmoi.username
```

| Característica | Symlinks | GNU Stow | chezmoi |
|---|---|---|---|
| **Curva de aprendizaje** | Mínima | Baja | Media |
| **Plantillas por máquina** | ❌ | ❌ | ✅ |
| **Gestión de permisos** | ❌ | ❌ | ✅ |
| **Simular cambios** | ❌ | ✅ (`stow -n`) | ✅ (`chezmoi diff`) |
| **Scripts post-aplicación** | ❌ | ❌ | ✅ (run_scripts) |

### Buenas prácticas

1. **No versiones archivos con secretos** — usa `.gitignore` para `~/.ssh/`, tokens, API keys. O usa `chezmoi` con `age` para cifrarlos.
2. **Organiza por programa**, no por tipo — más fácil de mantener.
3. **No pongas todo el `$HOME`** — solo los dotfiles que realmente cambias.
4. **Haz commits con sentido** — cada cambio de configuración debería tener su propio commit.
5. **Documenta dependencias** — si usas plugins de Zsh/Vim, deja un `README.md` indicando qué instalar primero.

### Script simple para gestionar dotfiles manualmente

```bash
#!/bin/bash
# Uso: ./dotfiles.sh add|apply <archivo>

DOTFILES_DIR="$HOME/dotfiles"

case "$1" in
  add)
    # Mover al repo y crear symlink
    mv "$2" "$DOTFILES_DIR/"
    ln -s "$DOTFILES_DIR/$(basename "$2")" "$2"
    cd "$DOTFILES_DIR" && git add . && git commit -m "Add $(basename $2)"
    ;;
  apply)
    # Restaurar todos los symlinks desde el repo
    for f in "$DOTFILES_DIR"/.*; do
      [ -f "$f" ] && ln -sf "$f" "$HOME/$(basename $f)"
    done
    ;;
  *)
    echo "Uso: $0 add|apply <archivo>"
    ;;
esac
```

> Para una guía más detallada sobre la especificación de directorios, ver [[XDG Base Directory y dotfiles modernos]].

---

## Por qué importa

Es la base para **versionar y portar toda la configuración** de shell/WM/apps entre máquinas o tras una reinstalación. Una vez que hayas configurado [[i3]], [[Hyprland]], [[Niri]] o cualquier otro WM con todos tus atajos y temas, querrás poder replicarlo en 5 minutos en cualquier máquina nueva.

---

## Ver también

- [[XDG Base Directory y dotfiles modernos]] — estándar moderno para directorios de configuración
- [[GNU y Linux]] — concepto de archivos ocultos y filosofía Unix
- [[i3]] · [[Hyprland]] — WMs cuyos config files son dotfiles clásicos
- [[Git]] — cómo versionar dotfiles
- [[Shells (bash zsh fish)]] — archivos de configuración de cada shell
- [[Permisos y Propietarios]] — los dotfiles también tienen dueño y permisos

#concepto #dotfiles
