---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# rm

## Sintaxis
```
rm [opciones] archivo...
```

## Descripción
Elimina archivos y directorios permanentemente. Linux no tiene "Papelera de reciclaje" global — lo que se borra con `rm` se libera del disco de inmediato. No pasa por la papelera del DE a menos que uses `trash-cli` o una interfaz gráfica.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-r` / `-R` | Recursivo — necesario para borrar directorios |
| `-f` | Forzar: no preguntar ni mostrar errores si el archivo no existe |
| `-i` | Preguntar antes de borrar cada archivo |
| `-v` | Verboso — muestra lo que va borrando |
| `-d` | Borrar directorio vacío (alternativa a `rmdir`) |

## Ejemplos
```bash
rm archivo.txt                            # borrar archivo
rm *.tmp                                  # borrar todos los .tmp del directorio actual
rm -r directorio/                         # borrar directorio y todo su contenido
rm -rf directorio/                        # borrar recursivo sin preguntar (⚠️)
rm -i *.log                               # preguntar antes de borrar cada .log
rm -rf ~/.cache/*                         # limpiar caché (no borra la carpeta, solo su contenido)
```

## Casos de uso reales

### Limpiar archivos temporales

```bash
rm -rf /tmp/*                             # limpiar /tmp (seguro, se vacía en cada reinicio)
rm -rf ~/.cache/*                         # limpiar caché de usuario
rm -f *.log *.tmp *.bak                   # limpiar archivos generados
```

### Eliminar una carpeta de proyecto completa (con git)

```bash
rm -rf ~/proyectos/experimento-fallido/   # borra todo, incluido .git
# Alternativa más segura: mover a la papelera
mv ~/proyectos/experimento-fallido/ ~/.local/share/Trash/files/
```

### Borrar archivos viejos (más de 30 días)

```bash
find ~/Descargas/ -name "*.deb" -mtime +30 -delete
# O con rm + xargs:
find ~/Descargas/ -name "*.iso" -mtime +30 | xargs rm -f
```

## Combinaciones comunes con pipe

```bash
# Borrar archivos que coinciden con un patrón específico
find . -name "*.pyc" -delete             # más seguro que xargs rm

# Borrar archivos que contienen cierta palabra
find . -name "*.log" -exec grep -l "ERROR" {} \; | xargs rm -f

# Borrar archivos vacíos (0 bytes)
find . -type f -empty -delete
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `rm archivo` | `trash-put archivo` (trash-cli) | Va a la papelera, recuperable |
| `rm -rf dir` | `trash-put dir` | Lo mismo, con `trash-list` y `trash-restore` |
| `rm archivo` (confirmar) | `rm -i` alias | `alias rm='rm -i'` en tu shell previene accidentes |

```bash
# Instalar trash-cli
sudo apt install trash-cli     # Debian/Ubuntu
sudo pacman -S trash-cli       # Arch

trash-put archivo              # en lugar de rm
trash-list                     # ver papelera
trash-restore                  # restaurar interactivamente
trash-empty                    # vaciar papelera
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `rm: cannot remove 'archivo': Permission denied` | Archivo protegido contra escritura o no eres dueño | Usar `sudo rm` o `chmod +w` primero |
| `rm: cannot remove 'dir': Is a directory` | Falta `-r` para borrar directorios | Añadir `-r`: `rm -r directorio/` |
| `rm: remove write-protected regular file 'archivo'?` | Archivo de solo lectura | Responder `y` o usar `-f` para forzar |
| `Argument list too long` | Demasiados archivos (wildcard `*`) | Usar `find . -name "*.log" -delete` en lugar de `rm *.log` |

## Notas y advertencias
- **`rm -rf /`** borra todo el sistema. Linux modernos tienen protección contra esto (`--no-preserve-root` para forzarlo igual), pero `rm -rf ~` o `rm -rf ./*` mal escrito pueden causar daños enormes.
- No hay comando "undo" para `rm` (no va a la papelera). Verifica siempre antes de presionar Enter, sobre todo con `-rf`.
- Alternativa segura: `trash-cli` (`trash-put archivo`, `trash-list`, `trash-restore`) mueve los archivos a una papelera desde la que se pueden recuperar.
- Usar `alias rm='rm -i'` en tu shell puede prevenir accidentes.
- Para borrar directorios vacíos existe `rmdir`, pero `rm -d` hace lo mismo.

## Enlaces externos

- [Wikipedia — rm (Unix)](https://en.wikipedia.org/wiki/Rm_(Unix))
- [GNU Coreutils — rm manual](https://www.gnu.org/software/coreutils/manual/html_node/rm-invocation.html)

## Ver también
- [[cp]]
- [[mv]]
- [[Cheat Sheet - Comandos Esenciales]]

#comando
