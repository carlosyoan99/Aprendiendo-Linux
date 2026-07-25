---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# sort

## Sintaxis
```
sort [opciones] [archivo...]
```

## Descripción
Ordena las líneas de un archivo o de la entrada estándar. Por defecto ordena alfabéticamente. No modifica el archivo original a menos que se use `-o` para escribir la salida al mismo archivo. Es una pieza fundamental en pipelines junto con `uniq -c` para análisis de frecuencias.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-n` | Orden numérico (10 va después de 2, no después de 1) |
| `-r` | Orden inverso (descendente) |
| `-k <N>` | Ordenar por columna N (separada por espacios/tabs) |
| `-t <sep>` | Especificar separador de columnas (ej. `-t,` para CSV) |
| `-u` | Único: igual que sort + uniq en un solo paso (más eficiente) |
| `-h` | Ordenar números con sufijos (K, M, G) — ideal con `du -h` |
| `-o archivo` | Guardar resultado en un archivo (seguro para escribir al mismo archivo) |
| `-V` | Orden de versiones (v1.2 < v1.10 < v1.20) |
| `-R` | Orden aleatorio (shuffle) |
| `-S <tamaño>` | Tamaño de buffer de memoria (ej. `-S 50%` = usar 50% de RAM) |
| `-m` | Merge: combinar archivos ya ordenados sin reordenar |
| `-s` | Orden estable: preserva el orden original de líneas con misma clave |
| `-b` | Ignora espacios al inicio al comparar |
| `-f` | Ignora mayúsculas/minúsculas |

## Ejemplos básicos

```bash
sort archivo.txt                          # orden alfabético ascendente
sort -r archivo.txt                       # orden alfabético descendente
sort -n numeros.txt                       # orden numérico
sort -u archivo.txt                       # ordenar y eliminar duplicados
sort -t, -k2 datos.csv                    # ordenar CSV por la 2da columna
du -h | sort -h                           # ordenar tamaños de archivos (humano)
sort -V versiones.txt                     # ordenar versiones (v1.2 < v1.10)
```

## Casos de uso reales

### Ordenar procesos y recursos

```bash
# Procesos ordenados por %CPU descendente (ps + sort)
ps aux | sort -nrk 3 | head -20

# Procesos ordenados por %MEM descendente
ps aux | sort -nrk 4 | head -20

# Procesos ordenados por PID (numérico)
ps aux | sort -nk 2

# Procesos de un usuario específico, ordenados por CPU
ps aux | grep "^carlos" | sort -nrk 3
```

### Análisis de logs

```bash
# IPs ordenadas por frecuencia (sort + uniq -c + sort -rn)
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# Las URLs más lentas (por tiempo de respuesta)
awk '{print $NF, $7}' access.log | sort -rn | head -10

# Logs ordenados por fecha (si la fecha es el primer campo)
sort -k1,2 /var/log/syslog | head -20

# Códigos de estado HTTP ordenados por código (numérico)
awk '{print $9}' access.log | sort -n | uniq -c
```

### Ordenar datos del sistema

```bash
# Directorios ordenados por tamaño
du -sh * | sort -h                         # ascendente (menor a mayor)
du -sh * | sort -rh                        # descendente (mayor a menor)

# Discos ordenados por uso
df -h | sort -hk 5                         # ordenar por columna "Use%"

# Paquetes instalados por fecha (Arch)
pacman -Qi | grep -E "^Name|^Install" | paste - - | sort -k3

# Usuarios ordenados por UID
sort -t: -k3 -n /etc/passwd | head -10

# Particiones ordenadas por tamaño
lsblk -b | sort -nk 4                      # ordenar por tamaño (bytes)
```

### Ordenar CSVs y datos tabulares

```bash
# CSV: ordenar por columna 2 (numérica)
sort -t, -k2 -n datos.csv

# CSV: ordenar por columna 1 (texto), luego columna 3 (numero descendente)
sort -t, -k1,1 -k3,3rn datos.csv

# CSV con header: omitir la primera línea, ordenar el resto
(head -n1 datos.csv && tail -n+2 datos.csv | sort -t, -k2 -n) > datos-ordenado.csv

# TSV: ordenar por columna 3
sort -t$'\t' -k3 -n datos.tsv

# /etc/passwd: ordenar por shell (columna 7) y dentro por UID (columna 3)
sort -t: -k7,7 -k3,3n /etc/passwd
```

### Ordenar versiones y nombres con números

```bash
# Versiones de software (V = version sort)
sort -V versiones.txt
# v1.1
# v1.2
# v1.10     ← correcto: 10 > 2, no alfabético
# v2.0

# Nombres de archivos con números (captura de pantalla)
ls screenshot*.png | sort -V
# screenshot1.png
# screenshot2.png
# screenshot10.png

# Kernels instalados
ls /boot/vmlinuz-* | sort -V
```

### Orden aleatorio (shuffle)

```bash
# Barajar líneas de un archivo (útil para listas de reproducción, tests)
sort -R playlist.txt

# Seleccionar 10 líneas al azar de un archivo grande
sort -R archivo.txt | head -10

# Barajar preguntas de un examen
sort -R preguntas.txt
```

### Técnicas avanzadas

```bash
# Ordenar archivos grandes con poca RAM (sort usa disco temporal)
sort -S 10M archivo-gigante.txt -o salida.txt   # limitar a 10 MB de RAM

# Merge de archivos ya ordenados (muy rápido)
sort -m ordenado1.txt ordenado2.txt -o combinado.txt

# Orden estable: mantener orden original de elementos con misma clave
sort -s -k2 archivo.txt

# Ordenar ignorando mayúsculas y espacios
sort -fb archivo.txt

# Ordenar por el primer carácter después de un prefijo (con -s)
sort -s -k1.3 archivo.txt             # ordenar desde el 3er carácter

# Orden numérico inverso de la tercera columna en CSV
sort -t, -k3 -n -r datos.csv
```

### Combinaciones clásicas (pipeline de frecuencias)

```bash
# El pipeline de análisis de frecuencias (memorizarlo):
<comando> | sort | uniq -c | sort -rn | head -N

# Variantes:
#   sort           → agrupar elementos iguales
#   uniq -c        → contar ocurrencias de cada grupo
#   sort -rn       → ordenar por frecuencia descendente
#   head -N        → mostrar solo los top N

# Ejemplos concretos:
ps aux | awk '{print $1}' | sort | uniq -c | sort -rn
#    45 root
#    12 carlos
#     3 www-data

cut -d' ' -f1 access.log | sort | uniq -c | sort -rn | head -5
# 4520 192.168.1.1
# 1203 10.0.0.5
#  894 192.168.1.100
```

## sort en scripts

```bash
# Declarar una variable con opciones comunes
SORT_OPTS="-t, -k2 -n"

# Aplicar en varias llamadas
sort $SORT_OPTS datos1.csv
sort $SORT_OPTS datos2.csv

# Verificar que un archivo está ordenado (comparar con la versión ordenada)
if cmp -s <(sort archivo.txt) archivo.txt; then
    echo "El archivo ya está ordenado"
else
    echo "El archivo NO está ordenado"
fi

# Ordenar archivos .tmp y reemplazar el original (seguro)
sort -o archivo.txt archivo.txt   # -o es seguro para escribir al mismo archivo
# NO hacer: sort archivo.txt > archivo.txt  (¡sobrescribe antes de leer!)
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `10` aparece antes que `2` | Orden alfabético, no numérico | Usar `sort -n` |
| Orden por columna no funciona | El separador por defecto es espacio/tab, no coincide con tu formato | Especificar `-t,` para CSV, `-t:` para /etc/passwd, etc. |
| `sort` tarda mucho con archivos grandes | Usa poca RAM y escribe a disco temporal | Aumentar buffer: `-S 50%` o `-S 2G` |
| `sort archivo > archivo` deja el archivo vacío | La redirección `>` se ejecuta **antes** que sort, truncando el archivo | Usar `-o archivo archivo` |
| Números con unidades (K, M, G) no ordenan bien | Orden alfabético no entiende sufijos | Usar `sort -h` |
| La salida de `ls -la` no se ordena por fecha con `sort` | El formato de fecha de ls tiene varias formas | Mejor usar `ls -lt` (por fecha) o `ls -lS` (por tamaño) |
| `sort -u` elimina menos duplicados de los esperados | Diferencias invisibles: espacios, tabs al final | Normalizar con `sed 's/[[:space:]]*$//' \| sort -u` |
| Diferencia de locale: `ñ` o `ç` no se ordenan como esperas | El orden varía según el locale | Forzar: `LC_ALL=C sort archivo` (ASCII puro, más rápido) |
| `sort -R` no es realmente aleatorio | `sort -R` usa un hash, no es criptográficamente aleatorio | Para verdadero shuffle, usar `shuf` |

## Notas y advertencias
- `sort` por defecto ordena alfabéticamente, no numéricamente. `sort -n` es necesario para números.
- `sort -u` es equivalente a `sort archivo | uniq` pero más eficiente (un solo paso).
- La columna en `-k` empieza en 1. Se puede especificar rango: `-k2,2` = solo columna 2, `-k2,3` = columnas 2 a 3.
- `sort -k 2` sin especificar fin usa desde columna 2 hasta el final de la línea.
- Con `-h` puedes ordenar salida de `du -h`, `ls -lh` y comandos con sufijos de tamaño.
- Nunca hacer `sort archivo > archivo` (trunca el archivo). Siempre usar `sort -o archivo archivo`.
- `LC_ALL=C sort -u` es significativamente más rápido en archivos grandes porque el locale C no procesa Unicode.
- `shuf` es la herramienta correcta para aleatorizar líneas; `sort -R` solo si no tienes `shuf`.

## Ver también
- [[uniq]] — eliminar duplicados y contar (después de sort)
- [[wc]] — contar líneas
- [[grep]] — filtrar antes de ordenar
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — sort](https://en.wikipedia.org/wiki/Sort_(Unix))
- [GNU Coreutils — sort manual](https://www.gnu.org/software/coreutils/manual/html_node/sort-invocation.html)

#comando
