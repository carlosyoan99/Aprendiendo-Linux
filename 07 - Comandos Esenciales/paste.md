---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: comando
prioridad: baja
---

# paste

> Unir líneas de uno o más archivos lado a lado (columnas) o fusionar líneas en una sola. El inverso conceptual de `cut`.

## Sintaxis

```bash
paste [opciones] archivo1 archivo2 ...
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `-d <delim>` | Delimitador entre columnas (por defecto: tab) |
| `-s` | Fusionar todas las líneas de un archivo en una sola |
| `--serial` | Procesar un archivo a la vez (con -s) |

## Ejemplos

```bash
# Unir dos archivos lado a lado (columnas)
paste archivo1.txt archivo2.txt

# Unir con delimitador personalizado
paste -d',' archivo1.txt archivo2.txt

# Fusionar todas las líneas en una sola (separadas por tab)
paste -s archivo.txt

# Fusionar con separador personalizado
paste -s -d',' archivo.txt
# línea1,línea2,línea3

# Crear CSV a partir de dos listas
paste -d',' nombres.txt edades.txt

# Alternativa a `cat -n` con nl
paste -d'\t' <(seq 1 $(wc -l < archivo.txt)) archivo.txt

# Intercalar líneas de dos archivos
paste -d'\n' archivo1.txt archivo2.txt
# línea1_arch1
# línea1_arch2
# línea2_arch1
# línea2_arch2

# Crear tabla de multiplicar
seq 1 5 | paste -s -d'\t' -
```

## paste vs awk vs sed

| Operación | paste | awk | sed |
|---|---|---|---|
| Unir archivos en columnas | ✅ Simple | ✅ Más flexible | ⚠️ |
| Fusionar líneas en una | ✅ `-s` | ✅ `ORS=""` | ⚠️ |
| Delimitador personalizado | ✅ `-d` | ✅ `-F` | ⚠️ |
| Procesamiento condicional | ❌ | ✅ | ✅ |

## Ver también

- `cut` — extraer columnas (inverso de paste)
- `column` — alinear columnas de texto
- `join` — unir archivos por campo común
- `pr` — formatear archivos para impresión

## Enlaces externos

- [Man page — paste](https://man7.org/linux/man-pages/man1/paste.1.html)
- [Wikipedia — paste (Unix)](https://en.wikipedia.org/wiki/Paste_(Unix))

#comando #texto
