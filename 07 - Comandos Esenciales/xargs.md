---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# xargs

## Sintaxis
```
comando | xargs [opciones] comando_destino
```

## Descripción
Convierte la salida de un comando en argumentos para otro comando. Esencial para procesar listas de archivos, nombres o IDs que salen de `find`, `grep`, `ls`, etc. Sin xargs, muchos pipes no podrían pasar listas largas porque el shell tiene un límite de longitud de argumentos.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-n <N>` | Máximo N argumentos por ejecución |
| `-I <reemplazo>` | Reemplazar texto en el comando destino (útil para comandos que no aceptan args al final) |
| `-P <N>` | Ejecutar en paralelo (N procesos simultáneos) |
| `-0` | Separar por null (seguro con `find -print0`) |
| `-p` | Preguntar antes de ejecutar cada comando (modo interactivo) |
| `-t` | Modo verbose: imprime el comando antes de ejecutarlo |

## Ejemplos
```bash
# Básico: pasar lista de archivos a rm
find . -name "*.tmp" | xargs rm -f

# Seguro con espacios en nombres (usando null)
find . -name "*.log" -print0 | xargs -0 rm -f

# Especificar cuántos args por ejecución
echo "1 2 3 4 5 6" | xargs -n 3 echo     # ejecuta echo dos veces: (1 2 3) y (4 5 6)

# Reemplazar en posición específica (-I)
find . -name "*.jpg" | xargs -I {} cp {} ~/backup/

# Ejecutar en paralelo (-P)
cat urls.txt | xargs -P 4 -n 1 curl -O   # descargar 4 URLs simultáneamente

# Modo interactivo (pregunta antes de ejecutar)
find . -name "*.bak" | xargs -p rm

# Contar líneas de archivos .md
find . -name "*.md" | xargs wc -l
```

## Casos de uso reales

### Descarga paralela de múltiples archivos

```bash
# Tienes un archivo urls.txt con URLs, una por línea
cat urls.txt | xargs -P 8 -n 1 wget -q
# Descarga 8 archivos simultáneamente (mucho más rápido que uno por uno)
```

### Copia de archivos encontrados a un directorio de backup

```bash
find /var/log -name "*.log" -mtime -1 | xargs -I {} cp {} ~/backup-logs/
# Copia los logs del último día a backup, {} se reemplaza por cada ruta
```

### Procesar archivos en lote (por grupos de N)

```bash
# git add en lotes de 100 archivos (evita "Argument list too long")
find . -name "*.js" | xargs -n 100 git add
```

## Combinaciones comunes con pipe

```bash
# xargs con sed para limpiar nombres de archivo
find . -name "*.txt" -print0 | xargs -0 -I {} sh -c 'echo "Procesando: {}"; wc -l "{}"'

# xargs con parallel processing y salida formateada
find . -name "*.py" | xargs -P 4 -I {} sh -c 'echo "=== {} ==="; head -3 "{}"'

# Contar archivos por extensión
find . -type f | awk -F. '{print $NF}' | sort | uniq -c | sort -rn | head -10
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `find ... | xargs comando` | `find ... -exec comando {} +` | Ejecución integrada en find, más fiable |
| `xargs -P` | `parallel` (GNU Parallel) | Control más fino: grupos, retry, progress bar |
| `xargs -I {} comando {}` | `xargs -d '\n' -I {} comando {}` | Manejo más seguro de espacios |

```bash
# GNU Parallel — alternativa más potente
sudo apt install parallel     # Debian/Ubuntu
cat urls.txt | parallel -j 8 wget -q {}  # similar a xargs -P 8
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| Archivos con espacios se rompen (tratados como argumentos separados) | `xargs` divide por espacios por defecto | Usar `find -print0` + `xargs -0` |
| `xargs: unterminated quote` | La entrada contiene comillas sin cerrar | Usar `xargs -0` con entrada null-separada |
| El comando se ejecuta 0 veces | No hay entrada (el pipe está vacío) | Usar `xargs -r` para no ejecutar si no hay entrada |
| `Argument list too long` incluso con xargs | Demasiados argumentos para una sola ejecución | Usar `xargs -n 1000` para partir en lotes |
| `xargs: command: Permission denied` | El comando destino no es ejecutable | Usar `chmod +x` o invocar con `sh -c "comando "` |

## Notas y advertencias
- Sin `-0`, xargs puede romperse con archivos que tengan espacios en el nombre. `find -print0` + `xargs -0` es la combinación más segura.
- `xargs` tiene un límite de argumentos por ejecución (getconf ARG_MAX, típicamente ~2M caracteres). Si hay más argumentos, ejecuta el comando varias veces.
- `xargs -P 4` es increíblemente útil para procesamiento paralelo sin instalar nada extra.
- Alternativa moderna: `find . -name "*.tmp" -delete` (no necesita xargs para borrar).
- Siempre probar con `-p` o `-t` primero si no estás seguro del resultado.

## Ver también
- [[find]]
- [[grep]]
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — xargs](https://en.wikipedia.org/wiki/Xargs)
- [GNU Findutils — xargs manual](https://www.gnu.org/software/findutils/manual/html_node/find_html/xargs.html)

#comando
