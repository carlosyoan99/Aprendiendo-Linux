---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: comando
prioridad: alta
---

# ln

## Sintaxis
```bash
ln [opciones] origen destino
```

## Descripción
Crea enlaces entre archivos. Por defecto crea **hard links** (mismo inodo). Con `-s` crea **symlinks** (enlaces simbólicos — como accesos directos).

> Para una guía detallada de symlinks y gestión de dotfiles, ver [[Symlinks y Dotfiles]].

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-s` | Crea symlink (enlace simbólico) en lugar de hard link |
| `-f` | Forzar: sobrescribe el destino si existe |
| `-i` | Preguntar antes de sobrescribir |
| `-n` | Tratar el destino como archivo normal (no directorio) |
| `-v` | Verboso — mostrar qué enlaces se crearon |
| `-r` | Crear symlink con ruta relativa (GNU coreutils 8.16+) |

## Ejemplos
```bash
# Symlinks (los más usados)
ln -s /ruta/al/archivo /ruta/del/enlace    # symlink básico
ln -s ~/dotfiles/.bashrc ~/.bashrc         # gestionar dotfiles
ln -sf /nuevo/archivo enlace               # forzar sobrescritura

# Hard links (mismo inodo, mismo disco)
ln archivo.txt enlace-duro.txt             # hard link (indistinguible del original)
ln ~/documentos/informe.pdf ~/backups/     # hard link en otra carpeta

# Symlink relativo (portátil entre máquinas)
ln -rs /usr/local/bin/programa ~/bin/      # crea symlink con ruta relativa
```

## Hard vs Soft links

| Característica | Hard link | Symlink (soft) |
|---|---|---|
| **Comparte inodo** | ✅ Sí | ❌ No |
| **Misma partición** | ✅ Obligatorio | ❌ Puede cruzar discos |
| **Directorios** | ❌ No | ✅ Sí |
| **Se rompe si se mueve/mata origen** | ❌ No (el archivo sigue vivo) | ✅ Sí (link muerto) |
| **Comando** | `ln` (sin -s) | `ln -s` |

```bash
# Verificar que un hard link comparte inodo
ls -li archivo.txt enlace-duro.txt         # mismo número de inodo
```

## Casos de uso reales

### Gestionar dotfiles con symlinks (el caso más común)

```bash
# Tienes tus dotfiles en ~/dotfiles/ y quieres usarlos sin copiarlos
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
# Si modificas ~/.bashrc, modificas ~/dotfiles/.bashrc (es el mismo archivo)
# Esto permite tener todos los dotfiles versionados en un solo lugar
```

### Crear un acceso directo a un comando/programa

```bash
# Tienes un script personalizado en ~/scripts/mi-herramienta
# Quieres ejecutarlo como 'mi-herramienta' sin escribir la ruta completa
ln -s ~/scripts/mi-herramienta ~/.local/bin/
# Ahora puedes ejecutar 'mi-herramienta' desde cualquier lado
# (si ~/.local/bin/ está en PATH)
```

### Apuntar a una versión específica de un programa

```bash
ln -sf /usr/bin/python3.12 ~/bin/python    # usar Python 3.12 como default
ln -sf /usr/local/go1.23/bin/go ~/bin/go   # usar Go 1.23
# Cambiar la versión es tan simple como actualizar el symlink
```

## Combinaciones comunes con pipe

```bash
# Encontrar symlinks rotos
find . -xtype l                             # equivalente a: find . -type l ! -exec test -e {} \; -print

# Listar todos los symlinks de un directorio
ls -la | grep "^l"                          # la 'l' inicial indica symlink

# Crear symlinks para todos los dotfiles de un repo
for f in ~/dotfiles/.*; do ln -sf "$f" ~/"$(basename "$f")"; done 2>/dev/null
```

## Alternativas modernas

| Comando clásico | Alternativa | Nota |
|---|---|---|
| `ln -s ~/dotfiles/.bashrc ~/.bashrc` | `stow` (GNU Stow) | Gestiona symlinks de dotfiles automáticamente |
| `ln -sf` manual | `chezmoi` | Gestor de dotfiles con plantillas, versiones y más |
| `ln archivo enlace` (hard link) | `cp --reflink=always` | Copy-on-write (similar pero copia real) |

```bash
# GNU Stow — gestionar symlinks de dotfiles
sudo apt install stow
cd ~/dotfiles
stow -S nvim                               # crea symlinks de ~/dotfiles/nvim/ → ~/.config/nvim/

# chezmoi — gestor completo de dotfiles
sudo apt install chezmoi
chezmoi init --apply                        # inicializar y aplicar dotfiles
```

Ver [[Symlinks y Dotfiles]] para una guía completa de gestión de dotfiles.

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `ln: failed to create symbolic link 'enlace': File exists` | El destino ya existe | Usar `-f` para forzar sobrescritura: `ln -sf origen destino` |
| Symlink roto (target no existe) | El origen fue movido/borrado | `find . -xtype l` para encontrarlos, recrear o borrar |
| `ln: 'archivo': hard link not allowed for directory` | No se pueden hacer hard links a directorios | Usar symlink: `ln -s directorio enlace` |
| `Invalid cross-device link` | Hard link entre particiones diferentes | Usar symlink (`-s`) o copiar el archivo |
| Symlink absoluto no funciona al mover dotfiles a otra máquina | La ruta absoluta hardcodea la máquina de origen | Usar `ln -rs` para rutas relativas |

## Notas
- Los symlinks rotos se detectan con: `find . -xtype l`
- Los symlinks se muestran con `→` en `ls -l`: `lrwxr-xr-x ... .bashrc → /home/user/dotfiles/.bashrc`
- No uses symlinks a rutas absolutas si vas a mover los dotfiles a otra máquina — prefiere rutas relativas con `ln -rs`.
- Los hard links no se pueden crear para directorios ni entre sistemas de archivos distintos.

## Ver también
- [[Symlinks y Dotfiles]] — guía completa de symlinks y gestión de dotfiles
- [[cp]] — copiar archivos vs crear enlaces
- [[mv]] — mover/renombrar
- [[rm]] — eliminar (los hard links sobreviven si hay otro link al mismo inodo)
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia - ln (Unix)](https://en.wikipedia.org/wiki/Ln_(Unix))
- [GNU Coreutils - ln manual](https://www.gnu.org/software/coreutils/manual/html_node/ln-invocation.html)

#comando