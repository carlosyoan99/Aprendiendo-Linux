---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: media
---

# awk

## Sintaxis
```bash
awk [opciones] 'patrón {acción}' [archivo...]
comando | awk 'patrón {acción}'
```

## Descripción
`awk` es un lenguaje de programación orientado a procesamiento de texto por **columnas** (campos). Opera línea por línea, dividiendo cada una en campos separados por un delimitador (espacio por defecto). Es la herramienta ideal para extraer, transformar y resumir datos tabulares, logs y CSVs directamente desde la terminal.

El nombre viene de las iniciales de sus creadores: **A**ho, **W**einberger, **K**ernighan.

> Para una guía completa de sed + awk combinados, ver [[sed y awk]].

---

## Opciones frecuentes

| Opción | Efecto | Ejemplo |
|---|---|---|
| `-F <separador>` | Especifica el separador de campos | `awk -F',' '{print $1}' datos.csv` |
| `-v var=valor` | Define una variable antes de ejecutar | `awk -v umbral=10 '$3 > umbral'` |
| `-f archivo.awk` | Lee el programa awk desde un archivo | `awk -f script.awk datos.txt` |

---

## Variables integradas

| Variable | Significado |
|---|---|
| `$0` | La línea completa |
| `$1`, `$2`, ..., `$NF` | Campos individuales (columnas) |
| `NF` | Número de campos en la línea actual |
| `NR` | Número de registro actual (línea) |
| `FS` | Separador de campos de entrada (default: espacio/tab) |
| `OFS` | Separador de campos de salida (default: espacio) |
| `RS` | Separador de registros (default: `\n`) |
| `ORS` | Separador de salida de registros |
| `FILENAME` | Nombre del archivo actual |
| `FNR` | Número de registro dentro del archivo actual |

---

## Estructura de un programa awk

```awk
BEGIN   { ... }   # se ejecuta antes de leer cualquier línea
/patrón/ { ... }  # se ejecuta por cada línea que coincide
        { ... }   # se ejecuta por cada línea (acción sin patrón)
END     { ... }   # se ejecuta después de procesar todas las líneas
```

---

## Ejemplos básicos

```bash
# Seleccionar columnas
awk '{print $1}' archivo.txt              # primera columna
awk '{print $1, $3}' archivo.txt           # columnas 1 y 3
awk '{print $NF}' archivo.txt             # última columna
awk '{print $(NF-1)}' archivo.txt         # penúltima columna

# Línea completa
awk '{print $0}' archivo.txt              # imprime todo (= cat)
awk '{print NR, $0}' archivo.txt          # con número de línea

# Contar líneas
awk 'END {print NR}' archivo.txt          # total de líneas (= wc -l)
```

---

## Casos de uso reales

### Análisis de logs

```bash
# Extraer IPs de un log de acceso
awk '{print $1}' /var/log/nginx/access.log

# Combinar IP + fecha + URL + código HTTP
awk '{print $1, $4, $7, $9}' access.log

# Líneas con código HTTP 500
awk '$9 == 500' access.log

# Líneas con código >= 400 (errores)
awk '$9 >= 400' access.log

# Contar IPs únicas (similar a sort | uniq -c)
awk '{count[$1]++} END {for (ip in count) print count[ip], ip}' access.log | sort -rn | head -10

# Resumen: cuántas peticiones de cada código HTTP
awk '{count[$9]++} END {for (code in count) print code, count[code]}' access.log | sort -n

# Tiempo de respuesta promedio de las URLs
awk '{sum[$7]+=$NF; count[$7]++} END {for (url in sum) print sum[url]/count[url], url}' access.log | sort -rn | head -10
```

### Análisis del sistema

```bash
# Procesos por usuario (de ps aux)
ps aux | awk '{print $1}' | sort | uniq -c | sort -rn

# PID y comando de los procesos que más CPU usan
ps aux | awk 'NR>1 {print $3, $2, $11}' | sort -rn | head -10

# Sumar el uso de memoria (RSS) de todos los procesos de un usuario
ps -u carlos -o rss | awk '{sum+=$1} END {print sum " KB"}'

# Tamaño total de archivos en un directorio
ls -l | awk 'NR>1 {sum+=$5} END {print sum " bytes"}'

# Particiones con uso > 80%
df -h | awk 'NR>1 {gsub(/%/, "", $5); if ($5 > 80) print $0}'
```

### Procesamiento de CSVs

```bash
# CSV: extraer columnas específicas
awk -F',' '{print $1, $3}' datos.csv

# CSV con cabecera: saltar primera línea
awk -F',' 'NR>1 {print $2}' datos.csv

# Filtrar filas donde columna 3 > 100
awk -F',' '$3 > 100' datos.csv

# Promedio de una columna numérica
awk -F',' '{sum+=$3; count++} END {print sum/count}' datos.csv

# Máximo y mínimo de una columna
awk -F',' 'NR==1 {min=max=$3} NR>1 {if ($3 > max) max=$3; if ($3 < min) min=$3} END {print "Min:", min, "Max:", max}' datos.csv

# Formatear como tabla (printf)
awk -F',' '{printf "%-20s %8d %5.2f\n", $1, $2, $3}' datos.csv
```

### Procesamiento de /etc/passwd

```bash
# Listar usuarios y su shell
awk -F':' '{print $1, $7}' /etc/passwd

# Usuarios con shell bash
awk -F':' '$7 ~ /bash/' /etc/passwd

# Usuarios con UID >= 1000 (humanos)
awk -F':' '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd

# Usuarios sin contraseña (shell /sbin/nologin)
awk -F':' '$7 ~ /nologin/ {print $1}' /etc/passwd

# Contar usuarios por shell
awk -F':' '{count[$7]++} END {for (shell in count) print count[shell], shell}' /etc/passwd | sort -rn
```

### Filtros y patrones

```bash
# Líneas que contienen "error" (= grep)
awk '/error/ {print}' /var/log/syslog

# Líneas entre dos patrones
awk '/INICIO/,/FIN/' archivo.txt

# Líneas con longitud > 80 caracteres
awk 'length($0) > 80' archivo.txt

# Líneas pares
awk 'NR % 2 == 0' archivo.txt

# Líneas impares
awk 'NR % 2 == 1' archivo.txt

# Líneas donde columna 3 contiene un patrón
awk '$3 ~ /^[0-9]+$/' archivo.txt
```

### Operaciones matemáticas

```bash
# Suma de una columna
awk '{sum+=$1} END {print sum}'

# Promedio
awk '{sum+=$1; n++} END {print sum/n}'

# Porcentajes
awk '{total+=$1; valor[NR]=$1} END {for (i=1; i<=NR; i++) print valor[i], 100*valor[i]/total "%"}'

# Redondear
awk '{printf "%.2f\n", $1/1024}' archivo.txt
```

---

## Formateo con printf

```bash
# Alinear columnas
awk '{printf "%-20s %8d %5.2f%%\n", $1, $2, $3}'

# Especificadores comunes:
# %s  → string
# %d  → entero
# %f  → float (%.2f = 2 decimales)
# %-20s → alineado a la izquierda (20 caracteres)
# %8d  → entero alineado a la derecha (8 caracteres)
```

---

## Combinaciones con otros comandos

```bash
# awk + sort + uniq: trío de análisis de logs
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# awk + sed: transformar columnas y limpiar
awk '{print $1, $3}' archivo.txt | sed 's/:/ - /g'

# awk + grep: prefiltrar y luego procesar
grep "ERROR" log.txt | awk '{print $1, $2, $NF}'

# awk + xargs: procesar salida de awk como argumentos
awk '{print $1}' archivo.txt | xargs -I {} echo "Archivo: {}"

# awk + head + tail: procesar un rango específico
awk '{print NR, $0}' archivo.txt | tail -n +10 | head -n 5
```

---

## Scripts awk (archivos .awk)

Para programas complejos, guarda el script en un archivo:

```awk
# analisis.awk
BEGIN {
    print "=== ANÁLISIS DE LOG ==="
    total = 0
}
{
    ip = $1
    codigo = $9
    ips[ip]++
    codigos[codigo]++
    total++
}
END {
    print "\nTop 10 IPs:"
    for (ip in ips) {
        printf "%s: %d peticiones\n", ip, ips[ip]
    }
    print "\nCódigos HTTP:"
    for (c in codigos) {
        printf "%s: %d\n", c, codigos[c]
    }
    printf "\nTotal peticiones: %d\n", total
}
```

```bash
# Ejecutar
awk -f analisis.awk access.log
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `awk` no muestra nada con `print $1` | El separador por defecto es espacio; si el archivo usa otro delimitador, no divide bien | Usar `-F,` o `-F':'` según el formato |
| `$NF` no devuelve el último campo | El delimitador no es espacio | Especificar el separador correcto con `-F` |
| `awk` con CSV tiene espacios en los valores | Los campos CS VS tienen espacios alrededor | Agregar `gsub(/^ +/,"",$1); gsub(/ +$/,"",$1)` para limpiar |
| `count[$1]++` en arrays no funciona como espero | Los arrays en awk son asociativos (como diccionarios) | La sintaxis es correcta pero el orden de los elementos no está garantizado |
| `awk -F,` no separa por comas si las comas están entre comillas | awk no entiende CSV con quoted fields por defecto | Usar `FPAT` de GNU awk para campos entrecomillados: `awk 'BEGIN {FPAT = \"([^,]+)|(\\\"[^\\\"]+\\\")\"}'` |
| Error: `awk: line 2: syntax error` | Error de sintaxis en el programa awk | Revisar llaves, paréntesis y punto y coma. Los bloques `{}` deben estar balanceados |
| `awk` procesa archivos binarios y sale con basura | awk intenta procesar cualquier archivo | Filtrar con `file` antes o usar `grep -I` para excluir binarios |

## Notas y advertencias
- awk opera **línea por línea**, ideal para archivos grandes: no carga todo en memoria (a menos que uses arrays grandes en `count[]`).
- La diferencia clave entre awk y sed: awk trabaja con **columnas/campos**, sed trabaja con **líneas/regex**. awk es más adecuado para datos estructurados (CSVs, logs tabulares).
- Si tu script awk se vuelve complejo (más de 20 líneas), considéralo moverlo a un archivo `.awk` separado o a Python/Perl.
- GNU awk (gawk) tiene características extendidas: `gensub()`, `asort()`, `FPAT`, `PROCINFO`. En sistemas BSD/macOS, `awk` puede ser la versión clásica sin estas extensiones.
- Para procesamiento de texto más simple (solo búsqueda y reemplazo), considera `sed` en lugar de awk.

## Ver también
- [[sed y awk]] — nota combinada con ejemplos de ambos y pipelines juntos
- [[grep]] — filtrar líneas por patrón (complementario)
- [[sort]] — ordenar resultados de awk
- [[uniq]] — contar ocurrencias con awk + arrays
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos
- [GNU Awk Manual](https://www.gnu.org/software/gawk/manual/gawk.html)
- [Arch Wiki — awk](https://wiki.archlinux.org/title/Awk)
- [Awk One-Liners Explained](https://catonmat.net/awk-one-liners-explained-part-one)
- [ExplainShell — awk](https://explainshell.com/explain?cmd=awk)

#comando
