---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: comando
prioridad: alta
---

# mv

## Sintaxis
```
mv [opciones] origen destino
mv [opciones] origen... directorio/
```

## Descripción
Mueve o renombra archivos y directorios. A diferencia de `cp`, el origen desaparece de su ubicación original. Es la herramienta para renombrar en Linux — no hay comando "rename" nativo (existe `rename` externo).

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-i` | Pregunta antes de sobrescribir |
| `-u` | Mueve solo si origen es más nuevo o destino no existe |
| `-v` | Verboso — muestra lo que va moviendo |
| `-n` | No sobrescribir archivos existentes |
| `-f` | Forzar: no preguntar aunque sobrescriba |

## Ejemplos
```bash
mv archivo.txt nuevo-nombre.txt           # renombrar archivo
mv carpeta/ nueva-ubicacion/              # renombrar/mover directorio
mv archivo.txt ~/Documentos/              # mover a otra carpeta
mv *.log ~/logs/                          # mover varios archivos
mv -i documento.docx ~/backup/            # preguntar antes de sobrescribir
mv ~/Descargas/*.pdf ~/Documentos/        # mover todos los PDFs
```

## Casos de uso reales

### Organizar archivos por tipo

```bash
# Mover todos los archivos por extensión a carpetas
mv *.jpg ~/Imagenes/
mv *.mp3 ~/Musica/
mv *.pdf ~/Documentos/
```

### Renombrar archivos con patrón (usando brace expansion)

```bash
# Añadir prefijo a varios archivos
for f in *.txt; do mv "$f" "backup_$f"; done

# Cambiar extensión (sin rename externo)
for f in *.JPG; do mv "$f" "${f%.JPG}.jpg"; done
```

### Backup rápido antes de editar

```bash
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
# Editar el original sabiendo que tienes backup
sudo nano /etc/nginx/nginx.conf
```

## Combinaciones comunes con pipe

```bash
# Mover archivos encontrados por find (con xargs)
find . -name "*.bak" | xargs -I {} mv {} ~/Trash/

# Mover archivos por fecha (más antiguos de 30 días)
find . -name "*.log" -mtime +30 -exec mv {} ~/Archived/ \;

# Renombrar archivos con expresión regular (usando sed)
for f in *; do mv "$f" "$(echo "$f" | sed 's/ /_/g')"; done  # espacios → guiones bajos
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `mv archivo nuevo` | — | `mv` ya es la herramienta estándar y no tiene alternativas directas |
| `for f in *; do mv ...` | `rename 's/patrón/reemplazo/' *` | Renombrado con regex en un solo comando |
| `find ... -exec mv ...` | `nmcli` / `rnm` | Herramientas GUI/TUI para renombrar masivamente |

```bash
# rename (Perl rename) — disponible en la mayoría de distros
sudo apt install rename          # Debian/Ubuntu
rename 's/\.JPG$/.jpg/' *.JPG   # cambiar extensión con regex
rename 'y/A-Z/a-z/' *            # convertir todos los nombres a minúsculas
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `cannot move 'archivo' to 'destino': Permission denied` | No tienes permiso de escritura en destino | Usar `sudo mv` o cambiar permisos con `chmod` |
| `mv: cannot stat 'archivo': No such file or directory` | El origen no existe o el path tiene espacios sin escapar | Usar comillas o tab completion |
| `mv: inter-device move failed` | Moviendo entre discos/particiones — mv hace copy+delete | Es normal, solo será más lento con archivos grandes |
| `mv: overwrite 'destino'?` | Sin `-f` o `-i`, mv pregunta si sobrescribe | Usar `-f` para forzar, `-i` para preguntar, `-n` para no sobrescribir |

## Notas y advertencias
- Si el destino es un directorio existente, el origen se mueve **dentro** de ese directorio.
- Si el destino no existe, se interpreta como renombrar.
- Si mueves entre discos/particiones distintas, `mv` hace una copia + borrado, no un simple cambio de metadatos (puede ser lento con archivos grandes).
- Es seguro para renombrar: si algo falla a mitad, no deja el archivo a medias (es una operación atómica dentro del mismo sistema de archivos).

## Enlaces externos

- [Wikipedia — mv](https://en.wikipedia.org/wiki/Mv)
- [GNU Coreutils — mv manual](https://www.gnu.org/software/coreutils/manual/html_node/mv-invocation.html)

## Ver también
- [[cp]]
- [[rm]]
- [[Cheat Sheet - Comandos Esenciales]]

#comando
