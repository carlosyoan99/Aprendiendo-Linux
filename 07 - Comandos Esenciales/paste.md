---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-31
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

## Descripción

`paste` combina líneas de archivos de forma paralela (columnas) o serial (una sola línea). Es útil para fusionar listas, crear CSVs, o transformar datos en formato columnar. El separador por defecto es tab.

## Opciones principales

| Opción | Descripción |
|---|---|
| `-d <delim>` | Delimitador entre columnas (por defecto: tab) |
| `-s` | Fusionar todas las líneas de un archivo en una sola |
| `-z` | Usar null (\0) como terminador de línea |

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

# Intercalar líneas de dos archivos
paste -d'\n' archivo1.txt archivo2.txt
# línea1_arch1
# línea1_arch2
# línea2_arch1
# línea2_arch2

# Crear tabla de multiplicar
seq 1 5 | paste -s -d'\t' -
# 1	2	3	4	5

# Convertir columnas a filas
paste -sd'\t' archivo.txt
```

## Casos de uso

### Crear CSV desde listas separadas

```bash
# Tener dos archivos con datos
cat nombres.txt
Ana
Carlos
María

cat edades.txt
25
30
28

# Crear CSV
paste -d',' nombres.txt edades.txt
# Ana,25
# Carlos,30
# María,28
```

### Fusionar logs de múltiples fuentes

```bash
# Interlevar líneas de dos logs
paste -d'\t' log1.txt log2.txt | head -20
```

### Formatear salida de comandos

```bash
# Crear tabla con datos de diferentes comandos
paste <(echo "Hostname: $(hostname)") \
      <(echo "Date: $(date +%F)") \
      <(echo "Uptime: $(uptime -p)")
```

### Transformar datos

```bash
# Convertir archivo vertical a horizontal (una línea)
cat lista.txt | paste -sd',' -
# resultado: item1,item2,item3,item4

# Añadir numeración a líneas
paste -d'\t' <(seq 1 $(wc -l < archivo.txt)) archivo.txt
```

## paste vs awk vs cut

| Operación | paste | awk | cut |
|---|---|---|---|
| Unir archivos en columnas | ✅ Simple | ✅ Más flexible | ❌ |
| Fusionar líneas en una | ✅ `-s` | ✅ `ORS=""` | ❌ |
| Delimitador personalizado | ✅ `-d` | ✅ `-F` | ✅ `-d` |
| Extraer columnas | ❌ | ✅ | ✅ Principal |
| Procesamiento condicional | ❌ | ✅ | ❌ |

> **Regla simple**: usa `paste` para unir/fusionar, `cut` para extraer columnas, y `awk` para procesamiento complejo.

## Ver también

- `cut` — extraer columnas (inverso de paste)
- `column` — alinear columnas de texto
- `join` — unir archivos por campo común
- `pr` — formatear archivos para impresión
- [[Coreutils y util-linux]] — paquete que incluye paste

## Enlaces externos

- [Man page — paste](https://man7.org/linux/man-pages/man1/paste.1.html)
- [Wikipedia — paste (Unix)](https://en.wikipedia.org/wiki/Paste_(Unix))
- [GNU paste manual](https://www.gnu.org/software/coreutils/manual/html_node/paste-invocation.html)

#comando #texto #datos
