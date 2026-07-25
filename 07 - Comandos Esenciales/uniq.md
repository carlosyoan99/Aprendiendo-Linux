---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: comando
prioridad: media
---

# uniq

## Sintaxis
```
uniq [opciones] [archivo_entrada [archivo_salida]]
```

## Descripción
Reporta u omite líneas repetidas. **Solo elimina duplicados consecutivos** — por eso se usa casi siempre con `sort` antes. También sirve para contar ocurrencias (`-c`), mostrar solo duplicados (`-d`), o solo líneas únicas (`-u`). Es la herramienta estándar para análisis de frecuencias en pipelines de texto.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-c` | Precede cada línea con el número de ocurrencias |
| `-d` | Muestra solo las líneas duplicadas (repetidas) |
| `-u` | Muestra solo las líneas únicas (no repetidas) |
| `-i` | Ignora mayúsculas/minúsculas al comparar |
| `-f <N>` | Ignora los primeros N campos al comparar (delimitados por espacio/tab) |
| `-s <N>` | Ignora los primeros N caracteres al comparar |
| `-w <N>` | Compara solo los primeros N caracteres de cada línea |

## Ejemplos básicos

```bash
sort archivo.txt | uniq                  # eliminar duplicados (sort necesario)
sort archivo.txt | uniq -c               # contar ocurrencias de cada línea
sort archivo.txt | uniq -d               # solo líneas que aparecen más de una vez
sort archivo.txt | uniq -u               # solo líneas que aparecen exactamente una vez
```

## Casos de uso reales

### Análisis de frecuencias

```bash
# Las IPs más frecuentes en un log de acceso (el clásico)
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# Los códigos de estado HTTP más comunes
awk '{print $9}' access.log | sort | uniq -c | sort -rn

# Las URLs más solicitadas
awk '{print $7}' access.log | sort | uniq -c | sort -rn | head -20

# Los navegadores más usados (User-Agent)
awk -F\" '{print $6}' access.log | sort | uniq -c | sort -rn | head -10

# Las páginas que más errores 404 generan
grep " 404 " access.log | awk '{print $7}' | sort | uniq -c | sort -rn | head -10
```

### Análisis del sistema

```bash
# Cuántos procesos por usuario
ps aux | awk '{print $1}' | sort | uniq -c | sort -rn

# Cuántas sesiones abiertas por usuario (SSH)
last | awk '{print $1}' | sort | uniq -c | sort -rn

# Paquetes instalados por tamaño (pacman)
pacman -Qi | grep -E "^Name|^Installed" | paste - - | sort | uniq -c

# Puertos en uso
ss -tuln | awk '{print $4}' | sort | uniq -c | sort -rn

# Comandos más usados del historial (bash_history)
cut -d' ' -f1 ~/.bash_history | sort | uniq -c | sort -rn | head -20

# Archivos más comunes por extensión
find . -type f | awk -F. '{print $NF}' | sort | uniq -c | sort -rn | head -10
```

### Análisis de logs del vault

```bash
# Cuántas notas por categoría (como el vault-stats.sh)
grep -h "^categoria:" *.md 2>/dev/null | sed 's/categoria: //' | sort | uniq -c | sort -rn

# Cuántas notas por prioridad
grep -h "^prioridad:" *.md 2>/dev/null | sed 's/prioridad: //' | sort | uniq -c | sort -rn

# Cuántas notas creadas por fecha
grep -h "^fecha_creacion:" *.md 2>/dev/null | sed 's/fecha_creacion: //' | sort | uniq -c | sort -rn

# Autores en commits de git
git log --format="%an" | sort | uniq -c | sort -rn

# Tags más usados en el vault
grep -h "^#" *.md 2>/dev/null | sort | uniq -c | sort -rn | head -10
```

### Procesamiento de datos

```bash
# Combinaciones únicas de columnas en un CSV
cut -d, -f1,2 datos.csv | sort | uniq -c | sort -rn

# Ignorar la primera columna (por ejemplo, una fecha)
sort archivo.txt | uniq -f1 -c

# Comparar solo los primeros 10 caracteres de cada línea
sort archivo.txt | uniq -w10 -c

# Ignorar mayúsculas/minúsculas
sort archivo.txt | uniq -i -c

# Encontrar líneas que aparecen exactamente 3 veces
sort archivo.txt | uniq -c | awk '$1 == 3'

# Filtrar duplicados que aparecen más de 5 veces
sort archivo.txt | uniq -c | awk '$1 > 5'
```

### Combinaciones con otros comandos

```bash
# uniq + sort + head: el trío de análisis de frecuencias
# Pipeline completo: extraer → ordenar → contar → ordenar por frecuencia → top N
cat archivo | comando_extraer | sort | uniq -c | sort -rn | head -10

# Con awk para filtrar por umbral de ocurrencias
sort datos.txt | uniq -c | awk '$1 >= 5 {print $2}'    # elementos que aparecen ≥5 veces

# Con grep para filtrar por patrón y luego contar
grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+" access.log | sort | uniq -c | sort -rn

# Con cut para seleccionar columnas específicas
cut -d' ' -f1 /var/log/auth.log | sort | uniq -c | sort -rn | head -5

# Con find + xargs para contar ocurrencias en varios archivos
find . -name "*.log" -exec cat {} + | sort | uniq -c | sort -rn | head -20
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `uniq` no elimina duplicados que ves repetidos | Las líneas no son **consecutivas** — hay otras líneas entre ellas | Siempre usar `sort` antes de `uniq`, o usar `sort -u` |
| `uniq -c` muestra 1 para todas las líneas | Las líneas son diferentes (quizá espacios, tabs, o trailing whitespace) | Normalizar con `sed 's/^[ \t]*//; s/[ \t]*$//'` antes de uniq |
| `uniq -f2` no ignora los campos esperados | El separador de campos es tab/espacio; si usas otro delimitador no funciona | `uniq` no soporta separador personalizado. Usar `cut -d, -f3- \| sort \| uniq` en su lugar |
| Diferencia entre `sort -u` y `sort \| uniq` | `sort -u` es más eficiente (un solo paso) pero no tiene flags de conteo | Para conteo: usar `sort \| uniq -c`. Para solo deduplicar: `sort -u` |
| Archivos CSV: `uniq -f` salta campos con espacios | `uniq` entiende \"campo\" como tokens separados por espacios | Preprocesar con `awk -F, '{print $3}'` para aislar la columna deseada |

## Notas y advertencias
- `uniq` sin `sort` previo solo elimina duplicados **adyacentes**. No detecta repeticiones en distintas partes del archivo.
- `sort -u` combina sort + uniq en un solo comando, más eficiente y con menos uso de pipe/buffer.
- `uniq -c` es muy usado para análisis rápidos de logs y frecuencias — es el pilar del patrón `sort | uniq -c | sort -rn`.
- La combinación `sort | uniq -c | sort -rn | head -N` es el pipeline de análisis de frecuencias más usado en Linux. Memorizarlo.
- Para archivos enormes, `sort` puede ser el cuello de botella. Considerar `awk` para conteos en una sola pasada si la memoria lo permite: `awk '{count[$1]++} END {for (k in count) print count[k], k}'`.

## Ver también
- [[sort]] — ordenar antes de uniq (esencial)
- [[wc]] — contar líneas (complementario)
- [[grep]] — filtrar antes de contar
- `awk` — procesamiento más complejo sin depender de uniq
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — uniq](https://en.wikipedia.org/wiki/Uniq)
- [GNU Coreutils — uniq manual](https://www.gnu.org/software/coreutils/manual/html_node/uniq-invocation.html)

#comando
