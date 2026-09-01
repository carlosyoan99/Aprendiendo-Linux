---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-09-01
estado: resuelto
categoria: comando
prioridad: media
---

# cut

> Extrae columnas, campos o caracteres específicos de cada línea. Ideal para procesar CSV, TSV y salida de comandos con delimitadores fijos.

## Sintaxis

```bash
cut [opciones] [archivo...]
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `-d <delim>` | Delimitador (por defecto: tab) |
| `-f <campos>` | Extraer campos específicos (ej: 1,3 o 1-3 o 2-) |
| `-c <chars>` | Extraer por posición de caracteres |
| `-b <bytes>` | Extraer por posición de bytes |
| `--complement` | Invertir selección (todo lo NO seleccionado) |
| `--output-delimiter` | Cambiar delimitador de salida |

## Ejemplos

```bash
# Extraer segundo campo de un CSV
echo "nombre,edad,ciudad" | cut -d',' -f2
# edad

# Extraer campos 1 y 3
cat datos.csv | cut -d',' -f1,3

# Extraer desde el campo 2 hasta el final
cat datos.csv | cut -d',' -f2-

# Extraer caracteres 1-5 de cada línea
echo "hola mundo" | cut -c1-5
# hola

# Extraer los primeros 3 bytes
echo "abcdef" | cut -b1-3
# abc

# Delimitador personalizado
cat /etc/passwd | cut -d':' -f1,6
# carlos:/home/carlos

# Extraer IPs de un log
cat access.log | cut -d' ' -f1

# Mostrar solo el PATH (sin export)
echo $PATH | tr ':' '\n' | cut -d'/' -f3 | sort -u
```

## Casos de uso

```bash
# Extraer usuarios y shells del /etc/passwd
cut -d: -f1,7 /etc/passwd

# Columnas de un log con el campo 1 como fecha (IMPORTANTE: se repite el espacio como delimitador)
cat access.log | cut -d' ' -f1,4

# Forzar delimitador de salida para normalizar
cut -d',' -f1,2 datos.csv | tr ',' '\t'

# Invertir la selección: todo EXCEPTO los campos 2 y 3
cut -d',' -f1,3 --complement datos.csv

# Campos 2 a 5 de un archivo TSV
cut -f2-5 datos.tsv

# Extraer campos con múltiples apariciones usando rangos abiertos
echo "a:b:c:d:e" | cut -d: -f3-5
# c:d:e
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `cut: invalid byte, character or field list` | Formato incorrecto en `-f`/`-c` | Revisa comas, rangos (`1-3`, `2-`) y que no haya espacios |
| Devuelve la línea entera | Delimitador no presente en la línea | Comprueba que el delimitador real coincida (`-d`, tab por defecto) |
| Campos con espacios se cortan mal | Delimitador no es un carácter único utilizable (p.ej. CSV con quoted fields) | Usar `awk`/`csvkit` que entienden comillas |

## cut vs awk vs sed

| Operación | cut | awk | sed |
|---|---|---|---|
| Extraer columna por delimitador | ✅ Rápido | ✅ Más flexible | ⚠️ Posible |
| Extraer por posición caracteres | ✅ | ⚠️ | ⚠️ |
| Múltiples delimitadores | ❌ | ✅ | ✅ |
| Procesamiento condicional | ❌ | ✅ | ✅ |
| Rendimiento en archivos grandes | ⚡ | ⚡ | ⚡ |

> **Regla**: si solo necesitas extraer una columna de un archivo con delimitador fijo, `cut` es la opción más rápida y simple. Si necesitas filtrar, formatear o procesar, usa `awk`.

## Ver también

- `awk` — procesamiento por columnas más potente
- `sed` — editor de flujo
- `column` — alinear columnas de texto
- `paste` — unir líneas de archivos

## Enlaces externos

- [Man page — cut](https://man7.org/linux/man-pages/man1/cut.1.html)
- [Wikipedia — cut (Unix)](https://en.wikipedia.org/wiki/Cut_(Unix))

#comando #texto
