---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
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
