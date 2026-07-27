---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: concepto
prioridad: alta
---

# Regular Expressions

> Los **patrones de búsqueda** universales que usan grep, sed, awk, vim y casi todas las herramientas de texto en Linux. Dominarlas multiplica tu velocidad procesando logs, configuraciones y código.

## Definición

Una expresión regular (regex) es una secuencia de caracteres que define un **patrón de búsqueda**. Cada herramienta busca líneas (o partes de líneas) que coincidan con ese patrón y permite filtrar, extraer o transformar el texto.

En Linux hay **tres sabores** principales de regex, cada uno con diferente potencia:

| Sabor | Comandos | Características |
|---|---|---|
| **BRE** (Basic) | `grep` (default), `sed` (default) | Clásico: `( ) { } + ?` necesitan `\` para activarse |
| **ERE** (Extended) | `grep -E`, `egrep`, `awk`, `sed -E` | `(){} +?|` sin escapar — más legible |
| **PCRE** (Perl) | `grep -P`, lenguajes (Python, JS, PHP) | Lookahead/lookbehind, `\d \w \s`, non-greedy |

> ⚠️ **Regla de oro**: Siempre usar **ERE** a menos que necesites PCRE. BRE solo cuando no haya alternativa. ERE es el punto óptimo entre potencia y compatibilidad.

## Por qué importa

Sin regex, procesar texto es artesanal — línea por línea, ojo por ojo. Con regex:
- **Extraer IPs** de un log de acceso: `grep -oP '\d+\.\d+\.\d+\.\d+' access.log`
- **Validar formato** de email en un script: `[[ "$email" =~ ^[a-z]+@[a-z]+\.[a-z]{2,}$ ]]`
- **Transformar configs** en lote: `sed -E 's/Listen [0-9]+/Listen 8080/g' apache.conf`
- **Refactorizar código**: buscar todas las funciones que empiezan con `get_` en 100 archivos

Sin regex, Linux sería 90% menos potente para procesar texto — y el texto es el formato universal del sistema.

## Sintaxis de patrones

### Caracteres literales y especiales

| Patrón | Coincide con |
|---|---|
| `abc` | La cadena literal "abc" |
| `.` | **Cualquier** carácter (excepto newline) |
| `\.` | Un punto literal (escapado) |
| `\\` | Una barra invertida literal |
| `\n` | Newline (solo en PCRE y algunos ERE) |

### Clases de caracteres

| Patrón | Significado | ERE | PCRE |
|---|---|---|---|
| `[abc]` | Un carácter del conjunto | ✅ | ✅ |
| `[^abc]` | Un carácter **no** del conjunto | ✅ | ✅ |
| `[a-z]` | Rango: minúsculas | ✅ | ✅ |
| `[0-9]` | Rango: dígitos | ✅ | ✅ |
| `[a-zA-Z0-9_]` | Carácter de palabra | ✅ | ✅ |
| `\d` | Dígito (`[0-9]`) | ❌ | ✅ |
| `\w` | Carácter de palabra (`[a-zA-Z0-9_]`) | ❌ | ✅ |
| `\s` | Espacio en blanco | ❌ | ✅ |
| `\D` | No dígito | ❌ | ✅ |
| `\W` | No carácter de palabra | ❌ | ✅ |
| `\S` | No espacio | ❌ | ✅ |

### Cuantificadores

| Patrón | Significado | BRE | ERE | PCRE |
|---|---|---|---|---|
| `*` | 0 o más | ✅ | ✅ | ✅ |
| `\+` / `+` | 1 o más | `\+` | ✅ | ✅ |
| `\?` / `?` | 0 o 1 (opcional) | `\?` | ✅ | ✅ |
| `\{n\}` / `{n}` | Exactamente n | `\{n\}` | ✅ | ✅ |
| `\{n,\}` / `{n,}` | n o más | `\{n,\}` | ✅ | ✅ |
| `\{n,m\}` / `{n,m}` | Entre n y m | `\{n,m\}` | ✅ | ✅ |
| `*?` | Non-greedy (mínima coincidencia) | ❌ | ❌ | ✅ |
| `+?` | Non-greedy (1 o más mínimo) | ❌ | ❌ | ✅ |

### Anclas y límites

| Patrón | Significado | Ejemplo |
|---|---|---|
| `^` | **Inicio** de línea | `^error` → líneas que empiezan con "error" |
| `$` | **Final** de línea | `done$` → líneas que terminan con "done" |
| `\b` | Límite de palabra (PCRE) | `\berror\b` → "error" pero no "errors" |
| `\B` | No límite de palabra (PCRE) | `\Berro` → dentro de otra palabra |

### Alternancia y agrupación

| Patrón | Significado | BRE | ERE/PCRE |
|---|---|---|---|
| `\|` | OR (alternancia) | `\|` con `-E` | ✅ |
| `(patrón)` | Grupo de captura | `\(\)` | ✅ (`()`) |
| `(?:patrón)` | Grupo no capturador | ❌ | PCRE |
| `\1` a `\9` | Backreference (referencia a grupo) | ✅ | ✅ |

### Lookaround (solo PCRE)

| Patrón | Nombre | Coincide cuando... |
|---|---|---|
| `(?=...)` | Positive lookahead | El patrón va **seguido** de `...` |
| `(?!...)` | Negative lookahead | El patrón **no** va seguido de `...` |
| `(?<=...)` | Positive lookbehind | El patrón va **precedido** de `...` |
| `(?<!...)` | Negative lookbehind | El patrón **no** va precedido de `...` |

```bash
# Ejemplos de lookaround
grep -oP '\d+(?=€)' precios.txt         # números seguidos de €
grep -oP '(?<=user:)\w+' usuarios.txt    # palabra después de "user:"
grep -P 'foo(?!bar)' archivo.txt         # "foo" no seguido de "bar"
```

## Patrones prácticos comunes

### IPs y redes

```bash
# IPv4 (básico, captura 999.999.999.999 también)
grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' access.log

# IPv4 (válido, solo 0-255) — PCRE
grep -oP '(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)' access.log

# Máscara CIDR
grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}' archivo
```

### URLs y web

```bash
# URLs HTTP/HTTPS
grep -oP 'https?://[^\s"<>]+' archivo.txt

# Extraer dominios
grep -oP '(?<=://)[^/]+' urls.txt

# Emails (razonable, no RFC)
grep -oP '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' datos.txt
```

### Fechas y horas

```bash
# Fecha ISO 8601: 2026-07-24
grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' log.txt

# Fecha DD/MM/AAAA
grep -oE '[0-9]{2}/[0-9]{2}/[0-9]{4}' log.txt

# Hora HH:MM:SS
grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}' log.txt

# Timestamp ISO completo
grep -oP '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}' archivo.json
```

### Logs y sistemas

```bash
# Líneas de error (case-insensitive)
grep -iE 'error|fail|critical|fatal' /var/log/syslog

# IDs numéricos entre corchetes [12345]
grep -oP '\[\K[0-9]+(?=\])' log.txt

# UUIDs
grep -oP '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' archivo

# Extraer valores entre comillas
grep -oP '"\K[^"]+(?=")' archivo.csv
```

### Programación

```bash
# Definiciones de función en Python
grep -P '^def \w+\(' *.py

# Imports en Go
grep -P '^\s*import\s+"[\w/]+"' *.go

# Comentarios TODO/FIXME
grep -rn --include='*.{py,js,ts,go,rs}' -E '(TODO|FIXME|HACK)' .
```

## Regex en cada herramienta

### grep

```bash
# BRE (por defecto)
grep 'error\.[a-z]\+' log.txt

# ERE (recomendado)
grep -E 'error\.[a-z]+' log.txt

# PCRE (lookaround, \d, \w)
grep -P '\d{3}-\d{3}-\d{4}' archivo.txt

# Texto literal (no regex) — más rápido
grep -F 'error: file not found' log.txt
```

### sed

```bash
# BRE por defecto
sed 's/\(error\)/\1 CRITICAL/' log.txt

# ERE con -E
sed -E 's/(error)/\1 CRITICAL/' log.txt

# Reemplazo con backreference
sed -E 's/([0-9]{1,3}\.){3}[0-9]{1,3}/REDACTED/g' access.log
```

### awk

```bash
# awk usa ERE por defecto
awk '/error|fail/ {print $1, $2, $NF}' /var/log/syslog

# Match de campo con ~
awk '$3 ~ /^5[0-9]{2}$/ {print $0}' access.log  # HTTP 5xx

# Match negado
awk '$3 !~ /^2[0-9]{2}$/ {print $0}' access.log  # NO 2xx
```

### vim

```bash
# Búsqueda (muy mágico con \v)
/\verror|fail|critical                    # ERE-like
/\<error\>                                # palabra completa

# Reemplazo con backreference
:%s/\v([a-z]+)_([a-z]+)/\u\1\U\2/g       # snake_case → CamelCase

# Global: ejecutar comando en líneas que coinciden
:g/^#/d                                   # borrar líneas de comentario
:g/TODO/normal A <-- PENDIENTE            # añadir texto al final
```

## Cuantificadores greedy vs non-greedy

```bash
# GREEDY (por defecto) — coincide lo MÁXIMO posible
# Sobre el texto: <div>hola</div><p>mundo</p>
grep -oP '<.+>'            # → <div>hola</div><p>mundo</p>  (todo junto)

# NON-GREEDY — coincide lo MÍNIMO posible
grep -oP '<.+?>'           # → <div>  (solo la primera etiqueta)
```

## Catastrophic Backtracking

Cuidado con patrones que pueden explotar el motor de regex:

```bash
# PELIGRO — si el texto NO coincide, el motor prueba TODAS las combinaciones
grep -P '(a|b)+$' texto.txt      # con cadenas largas, puede colgarse

# SEGURO — possessive quantifier (++) o atomic group (?>)
grep -P '(a|b)++$' texto.txt     # ++ = possessive, no backtrackea
grep -P '(?>(a|b)+)$' texto.txt  # (?>...) = atomic group, mismo efecto

# El possessive quantifier existe en otros cuantificadores
grep -P '[a-z]++'               # ++ = possessive en +
grep -P 'pattern*+'              # *+ = possessive en *
```

> **Regla**: si ves `(.*)*` o `(.+)+` o `(.|..)+`, sospecha. El motor de regex puede tardar exponencialmente más en fallar que en acertar.

## Buenas prácticas

1. **Siempre usar `-E` en grep/sed** a menos que necesites PCRE — BRE es confuso con los escapes
2. **Citar el patrón con comillas simples** para evitar que el shell expanda `$`, `\`, `*`
3. **Probar en [regex101.com](https://regex101.com/)** antes de usarlo en producción
4. **Usar `-o` en grep** para ver solo la parte coincidente (no toda la línea)
5. **Prefijar comandos lentos con `LC_ALL=C`** cuando busques solo ASCII (hasta 5× más rápido)
6. **Comentar regex complejas** en scripts — nadie entiende `(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.)` a primera vista
7. **No validar emails con regex** contra RFC 5322 — usa una librería. Una regex básica para sanity check basta

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `grep -P` no funciona | PCRE no compilado en grep | Usar `grep -E` o `pcregrep` |
| El patrón no encuentra nada | Escape incorrecto (BRE vs ERE) | Probar con `-E` primero |
| `*` encuentra demasiado | Greedy por defecto | Usar `*?` non-greedy (PCRE) |
| Shell expande `$` o `*` | Sin comillas en el patrón | Siempre usar `'comillas simples'` |
| Regex es lentísima o se cuelga | Catastrophic backtracking | Simplificar, evitar `(.*)*` |
| `^` y `$` no funcionan como esperas | Están en medio de un patrón | `^` solo al inicio del patrón, `$` al final |

## Comandos asociados

| Comando | Para qué |
|---|---|
| `grep -E` | Buscar con ERE |
| `grep -P` | Buscar con PCRE (lookaround, \d, \w) |
| `sed -E` | Buscar y reemplazar con ERE |
| `awk` | Procesar columnas con ERE |
| `vim /patrón` | Buscar en editor |
| `rg` (ripgrep) | Alternativa moderna a grep con ERE por defecto |
| `regex101.com` | Probar y depurar regex online |

## Ver también

- [[grep]] — filtrado de líneas con regex
- [[sed y awk]] — transformación y procesamiento de texto
- [[find]] — búsqueda de archivos por nombre (no regex, globs)
- [[Vim Neovim]] — editor con búsqueda y reemplazo regex
- [[Vim comandos avanzados]] — macros, registros y búsqueda avanzada

## Enlaces externos

- [Regex101 — probar regex online](https://regex101.com/)
- [Regular-Expressions.info — tutorial completo](https://www.regular-expressions.info/)
- [Wikipedia — Expresiones regulares](https://es.wikipedia.org/wiki/Expresi%C3%B3n_regular)
- [GNU Grep manual](https://www.gnu.org/software/grep/manual/grep.html)
- [RexEgg — regex tutorial avanzado](https://www.rexegg.com/)
- [Debuggex — visualizador de regex](https://www.debuggex.com/)

#concepto
