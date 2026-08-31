---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: comando
prioridad: media
---

# tr

> Traduce, elimina o comprime caracteres en la entrada. Útil para transformar texto en pipes sin abrir un editor.

## Sintaxis

```bash
tr [opciones] 'conjunto1' 'conjunto2'
```

## Descripción

`tr` (translate) lee de stdin, aplica las transformaciones indicadas, y escribe a stdout. No puede trabajar directamente sobre archivos — siempre necesita un pipe o redirección.

## Opciones principales

| Opción | Descripción |
|---|---|
| `-d` | Eliminar caracteres del conjunto1 |
| `-s` | Comprimir secuencias repetidas en conjunto1 a una sola |
| `-c` | Complemento del conjunto1 (todo lo que NO sea conjunto1) |
| `-t` | Truncar conjunto2 al largo de conjunto1 |
| `[:class:]` | Clases POSIX (lower, upper, digit, space, alnum...) |

## Ejemplos

```bash
# Convertir a mayúsculas
echo "hola mundo" | tr '[:lower:]' '[:upper:]'
# HOLA MUNDO

# Convertir a minúsculas
echo "HOLA MUNDO" | tr '[:upper:]' '[:lower:]'
# hola mundo

# Reemplazar espacios por tabs
echo "uno dos tres" | tr ' ' '\t'
# uno	dos	tres

# Eliminar todos los dígitos
echo "abc123def456" | tr -d '[:digit:]'
# abcdef

# Eliminar líneas vacías
cat archivo.txt | tr -s '\n'

# Comprimir espacios múltiples a uno
echo "uno   dos     tres" | tr -s ' '
# uno dos tres

# Reemplazar saltos de línea por espacios (unir líneas)
cat archivo.txt | tr '\n' ' '

# Eliminar caracteres no imprimibles
echo "hello\x03world" | tr -cd '[:print:]\n'
# helloworld

# Contar palabras (pipe con wc)
echo "hola mundo cruel" | tr ' ' '\n' | sort | uniq -c | sort -rn
```

## Clases POSIX

| Clase | Equivalente | Descripción |
|---|---|---|
| `[:lower:]` | a-z | Minúsculas |
| `[:upper:]` | A-Z | Mayúsculas |
| `[:digit:]` | 0-9 | Dígitos |
| `[:alnum:]` | a-zA-Z0-9 | Alfanuméricos |
| `[:space:]` | espacios/tabs/newlines | Espacios |
| `[:punct:]` | signos de puntuación | Puntuación |
| `[:print:]` | caracteres imprimibles | Imprimibles |

## Secuencias especiales

| Secuencia | Descripción |
|---|---|
| `\n` | Nueva línea |
| `\t` | Tabulador |
| `\r` | Retorno de carro |
| `\\` | Barra literal |
| `\ooo` | Carácter en octal |
| `\xHH` | Carácter en hex |

## Ver también

- `sed` — edición de flujo (más potente pero más complejo)
- `awk` — procesamiento por columnas
- `cut` — extraer columnas/posiciones
- `sed y awk` — índice de sed y awk

## Enlaces externos

- [Man page — tr](https://man7.org/linux/man-pages/man1/tr.1.html)
- [Wikipedia — tr (Unix)](https://en.wikipedia.org/wiki/Tr_(Unix))

#comando #texto
