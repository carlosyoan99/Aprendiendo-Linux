---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: comando
prioridad: baja
---

# comm

> Compara dos archivos **ordenados** línea por línea y muestra tres columnas: solo en archivo1, solo en archivo2, y líneas comunes. Útil para comparar listas, paquetes instalados, diff de listas.

## Sintaxis

```bash
comm [opciones] archivo1 archivo2
```

## Descripción

`comm` espera que ambos archivos estén **ordenados** (como salida de `sort`). Produce tres columnas separadas por tabs:

| Columna | Contenido |
|---|---|
| 1 | Líneas solo en archivo1 |
| 2 | Líneas solo en archivo2 |
| 3 | Líneas comunes a ambos |

## Opciones

| Opción | Descripción |
|---|---|
| `-1` | Suprimir columna 1 (solo en archivo1) |
| `-2` | Suprimir columna 2 (solo en archivo2) |
| `-3` | Suprimir columna 3 (comunes) |
| `--nocheck-order` | No verificar que los archivos estén ordenados |
| `-z` | Separador null en vez de newline |

## Ejemplos

```bash
# Comparar dos listas ordenadas
sort archivo1.txt > a.txt
sort archivo2.txt > b.txt
comm a.txt b.txt

# Líneas solo en archivo1 (qué tiene a1 que no tiene a2)
comm -23 a.txt b.txt

# Líneas solo en archivo2
comm -13 a.txt b.txt

# Líneas comunes
comm -12 a.txt b.txt

# Paquetes instalados en A pero no en B
comm -23 <(pacman -Qq | sort) <(cat paquetes-base.txt | sort)

# Diferencia de paquetes entre dos sistemas
comm -23 <(ssh sys1 "pacman -Qq" | sort) <(ssh sys2 "pacman -Qq" | sort)

# Comparar listas de usuarios
comm -23 <(cut -d: -f1 /etc/passwd | sort) <(cut -d: -f1 /etc/passwd.bak | sort)
```

## comm vs diff vs diff --minimal

| Aspecto | comm | diff | diff --minimal |
|---|---|---|---|
| **Archivos ordenados** | ✅ Requerido | No requerido | No requerido |
| **Formato** | 3 columnas | Unified/side-by-side | Unified |
| **Líneas comunes** | ✅ Columna 3 | ❌ Solo diferencias | ❌ |
| **Rendimiento** | ⚡ Muy rápido | ⚡ | ⚡ |
| **Ideal para** | Listas, paquetes | Código, configs | Código |

## Ver también

- `diff` — comparar archivos de texto
- `cmp` — comparar archivos byte a byte
- `sort` — ordenar líneas (necesario antes de comm)
- `uniq` — eliminar líneas duplicadas
- `join` — unir archivos por campo común

## Enlaces externos

- [Man page — comm](https://man7.org/linux/man-pages/man1/comm.1.html)
- [Wikipedia — comm (Unix)](https://en.wikipedia.org/wiki/Comm_(Unix))

#comando #texto
