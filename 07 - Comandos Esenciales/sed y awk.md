---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: media
---

# sed y awk

> `sed` transforma **líneas** con búsqueda y reemplazo; `awk` procesa **columnas/campos** dentro de cada línea. Juntos cubren casi todo el procesamiento de texto desde la terminal.

## Qué son

Ambas son herramientas de procesamiento de texto **línea por línea**, esenciales para scripts que transforman logs, CSVs o salidas de otros comandos sin abrir un editor:

- **`sed`** (stream editor) — edita el flujo de texto: sustituciones `s/.../.../`, direcciones por rango de líneas, eliminaciones e impresiones selectivas. Sus patrones de búsqueda se apoyan en expresiones regulares.
- **`awk`** — un pequeño lenguaje de programación orientado a **campos**: divide cada línea por un delimitador (espacio por defecto) y permite acceder a cada columna (`$1`, `$NF`), filtrar por valor, sumar, contar y resumir con bloques `BEGIN`/`END`.

**Diferencia clave**: `sed` opera sobre **líneas** (búsqueda y reemplazo); `awk` opera sobre **columnas/campos** dentro de cada línea. Para sustituir texto usa `sed`; para extraer o resumir datos tabulares usa `awk`.

## Tabla comparativa

| Aspecto | `sed` | `awk` |
|---|---|---|
| Unidad de trabajo | Líneas | Campos/columnas |
| Función principal | Buscar y reemplazar | Extraer y resumir |
| Sintaxis | Comandos cortos (`s/x/y/g`) | `patrón {acción}` (lenguaje) |
| Variables integradas | No | Sí (`NF`, `NR`, `$N`) |
| Bloques BEGIN/END | No | Sí |
| Sumas y conteos | No | Sí (arrays asociativos) |
| Curva de aprendizaje | Baja | Media-alta |

## Cuándo usar cada uno

- **`sed`**: sustituir texto (IPs, espacios, etiquetas HTML), borrar líneas o rangos, limpiar la salida de otro comando antes de seguir el pipeline.
- **`awk`**: extraer columnas de un log o CSV, filtrar por el valor de un campo (p. ej. código HTTP), contar ocurrencias y calcular promedios.
- **Ambos combinados**: `sed` limpia el formato y `awk` resume la estructura. Son complementarios, no competidores.

## Ejemplos de uso combinado

```bash
# sed: sustitución básica (líneas)
sed 's/error/aviso/g' app.log          # reemplazar todas las ocurrencias
sed '/^#/d' config.conf                # eliminar líneas comentadas
sed -n '10,20p' archivo.txt            # imprimir solo esas líneas

# awk: procesamiento por campos (columnas)
awk '{print $1}' access.log            # primera columna (IP)
awk '{print $NF}' archivo.txt          # última columna
awk '$9 == 500' access.log             # líneas con código HTTP 500
awk '{sum+=$3} END {print sum}' datos.txt   # suma de una columna

# Combinación: limpiar con sed y resumir con awk
cat usuarios.txt | sed 's/:.*//' | awk '{count[$1]++} END {for (u in count) print u, count[u]}'

# Pipeline clásico de análisis de logs
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10
```

### Bloques BEGIN y END

Ejecutan acciones **una sola vez**, antes y después de procesar todas las líneas:

```bash
awk 'BEGIN {print "=== IPs ==="} {print $1} END {print "=== Fin ==="}' access.log
```

## Ver también

- [[sed]] — sustituciones, direcciones, eliminación y flags
- [[awk]] — campos, variables integradas, bloques BEGIN/END y scripts .awk
- [[grep]] — filtrar líneas por patrón (paso previo al procesamiento)
- [[sort]] — ordenar los resultados de un análisis
- [[uniq]] — contar y eliminar duplicados

## Enlaces externos

- [Wikipedia — sed](https://en.wikipedia.org/wiki/Sed)
- [Wikipedia — AWK](https://en.wikipedia.org/wiki/AWK)
- [GNU sed manual](https://www.gnu.org/software/sed/manual/sed.html)
- [GNU Awk Manual](https://www.gnu.org/software/gawk/manual/gawk.html)

#comando