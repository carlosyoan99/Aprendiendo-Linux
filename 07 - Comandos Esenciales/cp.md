---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# cp

## Sintaxis
```
cp [opciones] origen destino
cp [opciones] origen... directorio/
```

## Descripción
Copia archivos y directorios de un lugar a otro. Si el destino es un directorio existente, copia el/los origen(es) dentro de ese directorio conservando sus nombres.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-r` / `-R` | Copia recursiva (necesaria para directorios) |
| `-i` | Pregunta antes de sobrescribir |
| `-u` | Copia solo si origen es más nuevo que destino o no existe |
| `-v` | Verboso — muestra lo que va copiando |
| `-a` | "Archive": preserva permisos, timestamps, y copia recursivamente |
| `-p` | Preserva atributos (permisos, timestamps) sin copiar recursivo |
| `-n` | No sobrescribir archivos existentes |
| `-l` | Crear hard links en vez de copiar |

## Ejemplos
```bash
cp archivo.txt backup/                    # copia a la carpeta backup/
cp archivo.txt backup/copia.txt           # copia y renombra en destino
cp -r mi-proyecto/ backup/                # copia recursiva de un directorio
cp -a origen/ destino/                    # copia recursiva preservando todo
cp *.jpg ~/fotos/                         # copia todos los JPG a ~/fotos/
cp -u *.txt ~/docs/                       # solo los más nuevos que los de destino
cp -iv archivo.txt backup/               # modo interactivo + verboso
```

## Casos de uso reales

### Backup rápido de un archivo de configuración antes de editarlo

```bash
cp /etc/nginx/nginx.conf{,.bak}            # copia como nginx.conf.bak
# Ahora edita el original sabiendo que tienes backup
sudo nano /etc/nginx/nginx.conf
```

### Clonar un proyecto completo (sin .git)

```bash
cp -a ~/proyecto/ ~/backup-proyecto/       # copia completa preservando atributos
cp -a ~/proyecto/ /mnt/usb/backup/        # backup a disco externo
```

### Copiar archivos por tipo a un directorio

```bash
cp ~/Descargas/*.{jpg,png,gif,webp} ~/Imagenes/  # solo imágenes
cp -r ~/proyecto/*.py ~/scripts/                 # solo Python scripts
```

## Combinaciones comunes con pipe

```bash
# Copiar archivos encontrados por find a un directorio
find . -name "*.conf" -exec cp {} ~/backup-configs/ \;

# Copiar archivos con confirmación (cp no acepta stdin, pero sí xargs)
ls *.txt | xargs -p -I {} cp {} ~/backup/

# Copiar archivos modificados en las últimas 24h
find . -name "*.md" -mtime -1 -exec cp {} ~/recent/ \;
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `cp archivo destino` | `rsync -av origen/ destino/` | Copia incremental, barra de progreso, reanudación |
| `cp -a origen/ destino/` | `rsync -av --delete origen/ destino/` | Sincronización exacta con borrado en destino |
| `cp archivo copia` | `cp --reflink=always archivo copia` | Copy-on-write (más rápido en Btrfs/ZFS, ocupa cero espacio extra hasta que modificas) |

```bash
# cp con reflink (solo Btrfs/ZFS)
cp --reflink=always archivo.iso copia.iso   # instantáneo, ocupa 0 espacio extra
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `cp: -r not specified; omitting directory 'dir'` | Falta `-r` para copiar directorios | Añadir `-r`: `cp -r directorio destino/` |
| `cp: cannot stat 'archivo': No such file or directory` | Origen no existe o ruta mal escrita | Usar tab completion o `ls -la` para verificar |
| `cp: overwrite 'destino'?` | `-i` implícito (alias) o destino existe | Usar `-f` para forzar sobrescritura |
| `cp: inter-device move...` con archivos grandes | Copia entre particiones puede ser lenta | Usar `rsync -avP` para ver progreso |

## Notas y advertencias
- Sin `-r`, `cp` ignora directorios y da error. Siempre usar `-r` o `-a` para copiar carpetas.
- `cp -a` es la opción más segura para backups porque preserva permisos, usuarios y fechas.
- Si el destino no existe y NO termina en `/`, `cp` interpreta que quieres renombrar el archivo copia.
- Usar `-i` por defecto evita sobrescribir archivos por accidente (se puede hacer alias: `alias cp='cp -i'`).

## Enlaces externos

- [Wikipedia — cp (Unix)](https://en.wikipedia.org/wiki/Cp_(Unix))
- [GNU Coreutils — cp manual](https://www.gnu.org/software/coreutils/manual/html_node/cp-invocation.html)

## Ver también
- [[mv]]
- [[rm]]
- [[Cheat Sheet - Comandos Esenciales]]
- [[Permisos y Propietarios]]

#comando
