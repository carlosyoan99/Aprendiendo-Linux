---
fecha_creacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: alta
---

# Expresiones Regulares (Regex)

## Definición

Una **expresión regular** (regex) es una secuencia de caracteres que define un **patrón de búsqueda**. Permite encontrar, extraer, validar o reemplazar texto que sigue una estructura determinada, sin importar el contenido exacto.

```
Patrón:  \b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b
Coincide con:  usuario@ejemplo.com, test@dominio.co.uk
No coincide con:  @usuario, correo@, @.com
```

En Linux, las regex son ubicuas: aparecen en [[grep]], [[sed]], [[awk]], [[Vim Neovim]], [[less]], y prácticamente cualquier herramienta que procese texto.

## Por qué importa

- **Buscar con precisión**: encontrar un error en 10 GB de logs sin saber el texto exacto
- **Validar datos**: verificar que un input tenga formato de email, IP o fecha
- **Transformar texto**: renombrar 200 archivos, limpiar un CSV, extraer campos de un log
- **Automatizar**: las regex son el lenguaje común entre herramientas Linux — grep, sed, awk, find (con -regex), vim, y lenguajes de programación
- Sin regex tendrías que buscar texto literal o escribir programas enteros para patrones simples

## Sintaxis básica

### Caracteres literales

La mayoría de caracteres se representan a sí mismos:

| Patrón | Coincide con |
|---|---|
| `hola` | "hola" |
| `error 404` | exactamente "error 404" |
| `192.168.1.1` | "192.168.1.1" (el `.` coincide con cualquier carácter, ver abajo) |

### Metacaracteres

| Carácter | Significado | Ejemplo |
|---|---|---|
| `.` | Cualquier carácter (excepto nueva línea) | `h.lla` → "hola", "hxlla", "h3lla" |
| `*` | 0 o más del carácter anterior | `ab*c` → "ac", "abc", "abbc" |
| `+` | 1 o más del carácter anterior (ERE) | `ab+c` → "abc", "abbc" (no "ac") |
| `?` | 0 o 1 del carácter anterior (ERE) | `ab?c` → "ac", "abc" |
| `^` | Inicio de línea | `^Error` → líneas que empiezan con "Error" |
| `$` | Final de línea | `done$` → líneas que terminan en "done" |
| `\` | Escapa el siguiente carácter | `\.` → un punto literal (no cualquier carácter) |

### Clases de caracteres `[...]`

| Patrón | Significado | Ejemplo |
|---|---|---|
| `[abc]` | Un carácter del conjunto | `gr[ae]y` → "gray" o "grey" |
| `[a-z]` | Un carácter en el rango | `[0-9]` → cualquier dígito |
| `[^abc]` | Un carácter NO del conjunto | `[^0-9]` → cualquier no dígito |
| `[a-zA-Z]` | Cualquier letra mayúscula o minúscula | `[A-Z].*` → línea que empieza con mayúscula |

### Clases abreviadas (PCRE)

| Clase | Equivalente | Significado |
|---|---|---|
| `\d` | `[0-9]` | Dígito |
| `\D` | `[^0-9]` | No dígito |
| `\w` | `[a-zA-Z0-9_]` | Carácter de palabra (letra, dígito, guión bajo) |
| `\W` | `[^a-zA-Z0-9_]` | No carácter de palabra |
| `\s` | `[ \t\n\r\f]` | Espacio en blanco |
| `\S` | `[^ \t\n\r\f]` | No espacio |
| `\b` | — | Límite de palabra |
| `\B` | — | No límite de palabra |

### Cuantificadores

| Patrón | Significado | Ejemplo |
|---|---|---|
| `{n}` | Exactamente n repeticiones | `\d{3}` → 3 dígitos |
| `{n,}` | n o más repeticiones | `\d{3,}` → 3+ dígitos |
| `{n,m}` | Entre n y m repeticiones | `\d{2,4}` → 2 a 4 dígitos |
| `*` | 0 o más (= `{0,}`) | `ab*c` |
| `+` | 1 o más (= `{1,}`) | `ab+c` |
| `?` | 0 o 1 (= `{0,1}`) | `ab?c` |

### Agrupación y alternancia

| Patrón | Significado | Ejemplo |
|---|---|---|
| `(patrón)` | Grupo de captura | `(foo)+` → "foo", "foofoo" |
| `(?:patrón)` | Grupo no capturador | `(?:foo|bar)` → agrupa sin guardar |
| `a\|b` | Alternancia (OR) | `foo\|bar` → "foo" o "bar" |
| `\1`, `\2`... | Referencia a grupo anterior (backreference) | `(a)b\1` → "aba" |

### Anclas y límites

| Patrón | Significado |
|---|---|
| `^` | Inicio de línea (o de cadena, según flags) |
| `$` | Final de línea |
| `\b` | Límite de palabra (`\berror\b` → "error" pero no "errors") |
| `\B` | No límite de palabra (`\Berro\B` → dentro de "error" pero no al borde) |

### Lookahead / Lookbehind (PCRE)

| Patrón | Significado | Ejemplo |
|---|---|---|
| `(?=...)` | Lookahead positivo | `foo(?=bar)` → "foo" solo si sigue "bar" |
| `(?!...)` | Lookahead negativo | `foo(?!bar)` → "foo" si NO sigue "bar" |
| `(?<=...)` | Lookbehind positivo | `(?<=foo)bar` → "bar" solo si precede "foo" |
| `(?<!...)` | Lookbehind negativo | `(?<!foo)bar` → "bar" si NO precede "foo" |

## BRE vs ERE vs PCRE

En Linux conviven **tres dialectos** de regex. Es crucial saber cuál usa cada herramienta:

| Dialecto | Herramientas | Diferencias clave |
|---|---|---|
| **BRE** (Basic) | `grep` (por defecto), `sed` (por defecto) | `()+`, `{}`, `|` deben escaparse: `\(\)`, `\{\}`, `\|` |
| **ERE** (Extended) | `grep -E`, `sed -E`, `awk` | `()+`, `{}`, `|` sin escapar. `awk` tiene su propio sabor |
| **PCRE** (Perl-compatible) | `grep -P`, lenguajes de programación | `\d`, `\w`, `\s`, lookahead, lookbehind. El más potente |

```bash
# BRE: grupos y cuantificadores escapados
grep '\(foo\|bar\)\{2,\}' archivo.txt

# ERE: sin escape
grep -E '(foo|bar){2,}' archivo.txt
sed -E 's/(foo|bar)+/BAZ/g' archivo.txt

# PCRE: clases abreviadas y lookahead
grep -P '\d{3}-\d{3}-\d{4}(?=\s|$)' archivo.txt
```

> ⚠️ **awk** no es exactamente ERE: usa un dialecto propio cercano a POSIX ERE pero con diferencias sutiles. Para awk, siempre escapar `\` dentro de `//` si no quieres expansión del shell.

## Patrones comunes (cheatsheet)

| Qué buscar | Patrón (ERE) | Ejemplo de uso |
|---|---|---|
| **Dirección IP** | `\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b` | Extraer IPs de logs |
| **Email** | `\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b` | Validar/extraer correos |
| **URL** | `https?://[^\s<>"]+` | Extraer enlaces de texto |
| **Fecha ISO** | `\b\d{4}-\d{2}-\d{2}\b` | "2026-07-24" |
| **Hora** | `\b([01]\d\|2[0-3]):[0-5]\d\b` | "14:30" |
| **Número de teléfono** | `\+?\d{1,3}[\s-]?\d{3}[\s-]?\d{3}[\s-]?\d{4}` | "+34 612 345 678" |
| **Código postal** | `\b\d{5}\b` | "28001" |
| **Sangría (indent)** | `^[ \t]+` | Líneas con espacios/tabs al inicio |
| **Líneas vacías** | `^$` | Filtrar líneas en blanco |
| **Comentarios #** | `^\s*#` | Líneas de comentario |
| **Palabra completa** | `\berror\b` | "error" pero no "errors" ni "error404" |
| **Extensiones de archivo** | `\.(jpg\|png\|gif)$` | Archivos de imagen |
| **UUID** | `\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b` | Identificadores únicos |
| **Etiquetas HTML** | `<[^>]+>` | Tags HTML (básico) |
| **Cadenas entre comillas** | `"[^"]*"` | `"texto entre comillas"` |

## Comandos asociados

| Comando | Cómo usa regex | Dialecto |
|---|---|---|
| [[grep]] | `grep "patrón" archivo` — busca líneas | BRE (default), ERE con `-E`, PCRE con `-P` |
| [[sed]] | `sed 's/patrón/reemplazo/'` — busca y reemplaza | BRE (default), ERE con `-E` |
| [[awk]] | `awk '/patrón/ {acción}'` — filtra y procesa | ~ERE (dialecto propio) |
| [[Vim Neovim]] | `/patrón` — busca en editor | BRE con algunas extensiones |
| [[less]] | `/patrón` — busca en visor de archivos | BRE (como grep) |
| `find -regex` | `find . -regex '.*\.\(py\|js\)'` — busca archivos | Emacs-style (con opciones) |

## Casos prácticos

### Buscar errores en logs entre dos fechas

```bash
grep -E '^2026-07-2[0-9].*(ERROR|FATAL|CRITICAL)' /var/log/syslog
```

### Extraer todas las IPs de un log de acceso

```bash
grep -oE '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b' access.log | sort | uniq -c | sort -rn | head -10
```

### Validar formato de email en un script

```bash
#!/bin/bash
email="usuario@ejemplo.com"
if [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    echo "Email válido"
else
    echo "Email inválido"
fi
```

### Limpiar un archivo: quitar comentarios y líneas vacías

```bash
sed -E '/^\s*#/d; /^$/d' config.conf > config-limpio.conf
```

### Renombrar archivos masivamente con regex

```bash
# Cambiar .JPG a .jpg en todos los archivos
for f in *.JPG; do mv "$f" "$(echo "$f" | sed 's/\.JPG$/.jpg/')"; done
```

### Buscar TODOs, FIXMEs y HACKs en un proyecto

```bash
grep -rn --include='*.{py,js,ts,go,rs}' -E '(TODO|FIXME|HACK|XXX)\b' .
```

## Diagrama / Esquema

```
Componentes de una expresión regular:

  ^(?=.{8,})(?=.*[A-Z])(?=.*[0-9]).*$
  │└──┬───┘└──────┬──────┘└──┬──┘│
  │   │           │          │   └── $ = final de cadena
  │   │           │          └── .* = cualquier contenido
  │   │           └── (?=.*[0-9]) = debe tener un dígito (lookahead)
  │   └── (?=.*[A-Z]) = debe tener una mayúscula (lookahead)
  └── ^ = inicio de cadena
      (?=.{8,}) = debe tener 8+ caracteres (lookahead)

  Patrón completo: validación de contraseña segura
```

## Troubleshooting / Problemas comunes

| Problema | Causa probable | Solución |
|---|---|---|
| El patrón no encuentra nada | BRE vs ERE incorrecto | Usar `-E` en grep/sed para ERE, o escapar `()+` en BRE |
| `*` no funciona como esperas | En regex, `*` = "0+ del anterior" | `.*` = cualquier cosa, `[0-9]*` = cualquier número de dígitos |
| El `.` encuentra demasiado | `.` coincide con CUALQUIER carácter | Escapar como `\.` para un punto literal |
| `grep -P` da error | PCRE no compilado en esta versión | Usar `grep -E` o instalar `ripgrep` |
| Patrón con espacios falla | El shell expande el patrón | Usar **comillas simples** siempre: `grep -E 'mi patrón'` |
| Backreference `\1` no funciona | BRE vs ERE: en ERE los grupos son `()` sin escapar | En BRE: `\(a\)\1`. En ERE: `(a)\1` (a veces requiere `-E`) |
| Buscar IP pero encuentra falsos | `[0-9]{1,3}` permite 999 | Usar `(25[0-5]\|2[0-4][0-9]\|[01]?[0-9][0-9]?)` para IPs válidas |
| Regex muy lenta (catastrophic backtracking) | Cuantificadores anidados como `(a+)+b` | Simplificar: evitar cuantificadores anidados, usar `.*?` en vez de `.*` |

## Notas personales

- `grep -P` es cómodo pero no siempre disponible (no es POSIX). Preferir `grep -E` para portabilidad
- Para regex complejas, usar [regex101.com](https://regex101.com/) con el sabor correcto (PCRE, ECMAScript, etc.)
- `ripgrep` (rg) usa PCRE por defecto y es más rápido que grep para proyectos grandes
- Aprender regex en orden: primero BRE/ERE (grep, sed), luego PCRE (Perl, Python, JS)
- El comodín `*` del shell NO es lo mismo que `*` en regex — es el error más común

## Enlaces externos

- [Wikipedia — Expresión regular](https://es.wikipedia.org/wiki/Expresi%C3%B3n_regular)
- [Wikipedia — Regular expression](https://en.wikipedia.org/wiki/Regular_expression)
- [Regex101](https://regex101.com/) — probar y depurar regex online
- [Regular-Expressions.info](https://www.regular-expressions.info/) — tutorial completo
- [RexEgg](https://www.rexegg.com/) — guía avanzada de regex
- [Arch Wiki — Regular expression](https://wiki.archlinux.org/title/Regular_expression)
- [GNU Grep manual — Regular expressions](https://www.gnu.org/software/grep/manual/grep.html#Regular-Expressions)
- [Rust regex crate docs](https://docs.rs/regex/latest/regex/)

## Ver también

- [[grep]] — busca texto con regex en archivos y pipes
- [[sed y awk]] — transformación de texto con regex
- [[awk]] — procesamiento por columnas con patrones regex
- [[Vim Neovim]] — búsqueda y reemplazo con regex en el editor
- [[bash-avanzado]] — regex con `[[ =~ ]]` en scripts bash
- [[less]] — búsqueda con `/patrón` dentro de archivos

#concepto #regex #texto
