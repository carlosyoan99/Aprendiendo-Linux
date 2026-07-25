---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: comando
prioridad: media
---

# sed y awk

## Descripción

Herramientas de procesamiento de texto por línea, esenciales para scripts que transforman logs, CSVs, o salidas de otros comandos sin abrir un editor.

**Diferencia clave**: `sed` opera sobre **líneas** (búsqueda y reemplazo, impresión selectiva). `awk` opera sobre **columnas/campos** dentro de cada línea (procesamiento estructurado tipo hoja de cálculo).

---

## sed — editor de flujo

### Sintaxis básica

```bash
sed 'comando' archivo.txt                  # sobre archivo (solo pantalla)
comando | sed 'comando'                    # sobre entrada pipeada
sed -i 'comando' archivo.txt               # editar in-place (modifica el archivo)
sed -i.bak 'comando' archivo.txt           # editar + backup (.bak)
```

### Sustituciones (s/.../.../)

```bash
sed 's/viejo/nuevo/' archivo.txt              # reemplaza la 1ra ocurrencia por línea
sed 's/viejo/nuevo/g' archivo.txt             # todas las ocurrencias por línea (global)
sed 's/viejo/nuevo/2' archivo.txt             # solo la 2da ocurrencia de cada línea
sed 's/viejo/nuevo/gi' archivo.txt            # global + ignorar mayúsculas
sed 's/  */ /g' archivo.txt                   # colapsar espacios múltiples en uno
sed 's/^  *//' archivo.txt                    # eliminar espacios al inicio de línea
sed 's/[0-9]//g' archivo.txt                  # eliminar todos los dígitos
```

### Direcciones (rangos de líneas)

```bash
sed -n '5,10p' archivo.txt                   # imprimir solo líneas 5 a 10
sed -n '10q' archivo.txt                     # imprimir hasta la línea 10 y salir
sed '1,5d' archivo.txt                       # borrar líneas 1 a 5
sed '5,/^$/d' archivo.txt                    # desde línea 5 hasta la primera línea vacía
sed -n '/error/p' archivo.txt                # imprimir solo líneas que contengan "error"
sed -n '/error/,/fin/p' archivo.txt          # desde que aparece "error" hasta "fin"
sed '/^#/d' archivo.txt                      # eliminar líneas de comentario (que empiezan con #)
sed '/^$/d' archivo.txt                      # eliminar líneas vacías
```

### Eliminación y manipulación

```bash
sed '3d' archivo.txt                         # eliminar línea 3
sed '3,5d' archivo.txt                       # eliminar líneas 3 a 5
sed '$d' archivo.txt                         # eliminar la última línea
sed -n '1~2p' archivo.txt                    # imprimir líneas impares (1, 3, 5, ...)
sed 'G' archivo.txt                          # añadir línea en blanco después de cada línea
sed '=' archivo.txt | sed 'N;s/\n/ /'        # numerar líneas (1: contenido)
sed 'y/abc/ABC/' archivo.txt                 # transliterar (a→A, b→B, c→C)
```

### Ejemplos reales

```bash
# Reemplazar todas las IPs en un log por "REDACTED"
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/REDACTED/g' access.log

# Quitar etiquetas HTML simples
sed 's/<[^>]*>//g' pagina.html

# Descomentar líneas en un archivo de configuración
sed -i 's/^#*PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config

# Extraer sección entre marcadores de un archivo
sed -n '/### INICIO/,/### FIN/p' documento.md

# Poner cada oración en una línea nueva
sed 's/\. /.\n/g' texto.txt
```

### Banderas (flags) de sed

| Flag | Efecto |
|------|--------|
| `g` | Reemplazar todas las ocurrencias (no solo la primera) |
| `i` | Ignorar mayúsculas/minúsculas (GNU sed) |
| `p` | Imprimir la línea (usado con `-n`) |
| `d` | Borrar la línea |
| `w archivo` | Escribir el resultado a un archivo |
| `n` | Saltar a la siguiente línea (evitar impresión por defecto) |

---

## awk — procesamiento por columnas

### Sintaxis básica

```bash
awk 'patrón {acción}' archivo.txt
awk '{acción}' archivo.txt                     # acción sobre todas las líneas
awk '/patrón/' archivo.txt                     # imprime líneas que coinciden (= grep)
```

### Columnas ($1, $2, ..., $NF)

```bash
awk '{print $1}' archivo.txt                   # primera columna (separador: espacio/tab)
awk '{print $1, $3}' archivo.txt                # columnas 1 y 3
awk '{print $NF}' archivo.txt                  # última columna
awk '{print $(NF-1)}' archivo.txt              # penúltima columna
awk '{print NR, $0}' archivo.txt               # número de línea + línea completa ($0)
```

### Separador de campos (FS / -F)

```bash
awk -F',' '{print $2}' datos.csv               # CSV: separado por comas
awk -F':' '{print $1}' /etc/passwd             # usuarios del sistema
awk -F'/' '{print $NF}' rutas.txt              # nombre de archivo de una ruta completa
awk 'BEGIN {FS=":"} {print $1}' /etc/passwd    # equivalente con BEGIN
```

### Patrones de filtrado

```bash
awk '/error/' /var/log/syslog                  # líneas que contienen "error" (como grep)
awk '/error/ {print $1, $2, $NF}' /var/log/syslog  # fecha + última columna
awk 'length($0) > 80' archivo.txt              # líneas de más de 80 caracteres
awk '$3 > 50' datos.txt                        # líneas donde la columna 3 > 50
awk 'NR > 1' datos.csv                         # saltar la primera línea (header)
awk 'NR % 2 == 0' archivo.txt                  # solo líneas pares
```

### Variables integradas

| Variable | Significado | Ejemplo de uso |
|---|---|---|
| `NR` | Número de registro actual (línea) | `awk 'NR==1'` = primera línea |
| `NF` | Número de campos en la línea actual | `awk '{print $NF}'` = último campo |
| `FS` | Separador de campos de entrada | `awk 'BEGIN{FS=\",\"}'` |
| `OFS` | Separador de campos de salida | `awk 'BEGIN{OFS=\"|\"}{print $1,$2}'` |
| `RS` | Separador de registros (default: newline) | `awk 'BEGIN{RS=\"\"}'` = párrafos |
| `ORS` | Separador de salida de registros | |
| `$0` | La línea completa | `awk '{print $0}'` |
| `FILENAME` | Nombre del archivo actual | Útil al procesar múltiples archivos |

### Ejemplos con awk

```bash
# Mostrar procesos con su PID y nombre (columnas 2 y 11 de ps aux)
ps aux | awk '{print $2, $11}'

# Sumar una columna (ej: tamaño de archivos)
ls -l | awk '{sum += $5} END {print sum " bytes"}'

# Promedio de la columna 3
awk '{sum += $3; count++} END {print sum/count}' datos.txt

# Formatear /etc/passwd como tabla
awk 'BEGIN {FS=":"; OFS=" | "; print "Usuario", "Shell", "Home"} 
     {print $1, $7, $6}' /etc/passwd | head -5

# Contar ocurrencias (como un mini uniq -c)
awk '{count[$1]++} END {for (word in count) print count[word], word}' archivo.txt

# Líneas entre dos patrones
awk '/INICIO/,/FIN/' archivo.txt

# Convertir CSV a TSV
awk 'BEGIN {FS=","; OFS="\t"} {$1=$1; print}' datos.csv

# Filtro de logs por fecha y nivel
awk '$3 == "ERROR" && $1 ~ /2026-07/' sistema.log

# Mostrar el proceso con más memoria (de ps aux)
ps aux | awk 'NR>1 {print $4, $11}' | sort -rn | head -5
```

### Formateo con printf

```bash
awk '{printf "%-20s %8d %5.2f%%\n", $1, $2, $3}' datos.txt
# %-20s → texto alineado a la izquierda (20 chars)
# %8d   → entero (8 chars)
# %5.2f → decimal con 2 dígitos (5 chars)
```

### BEGIN y END (antes/después de procesar)

```bash
awk 'BEGIN {print "=== REPORTE ==="} 
     {print NR, $0} 
     END {print "=== FIN ==="}' archivo.txt

# Resumen
awk 'END {print "Total líneas:", NR, "| Promedio col3:", sum/NR}' 
    '{sum += $3}' datos.txt
```

---

## Combinando sed + awk (+ grep)

```bash
# Pipeline típico: filtrar + transformar + extraer
grep "ERROR" /var/log/syslog \
  | sed 's/\[[0-9]*\]//g' \
  | awk '{print $1, $2, $3, $NF}' \
  | sort | uniq -c | sort -rn | head -10

# Explicación:
# grep → líneas con ERROR
# sed → elimina IDs entre corchetes [12345]
# awk → fecha (columnas 1-3) + último campo (el mensaje)
# sort | uniq -c | sort -rn → contar ocurrencias, más frecuentes primero
```

---

## Por qué importa

Junto a [[grep]], forman el trío clásico para procesar texto en la terminal. Donde otros abrirían un archivo en Python o harían 30 clics en Excel, un pipeline de `grep | sed | awk` resuelve en una línea: filtrar logs, extraer columnas de CSVs, transformar configuraciones, calcular estadísticas rápidas.

## Ver también

- [[awk]] — nota individual de awk (más ejemplos detallados)
- [[grep]] — filtrar líneas por patrón
- [[sort]] — ordenar resultados
- [[uniq]] — contar/eliminar duplicados
- [[diff]] — comparar archivos

## Enlaces externos

- [Wikipedia - sed](https://en.wikipedia.org/wiki/Sed)
- [Wikipedia - AWK](https://en.wikipedia.org/wiki/AWK)
- [GNU sed manual](https://www.gnu.org/software/sed/manual/sed.html)
- [GNU awk manual](https://www.gnu.org/software/gawk/manual/gawk.html)

#comando