---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: baja
---

# comm

> Compara dos archivos **ordenados** línea por línea y muestra tres columnas: solo en archivo1, solo en archivo2, y líneas comunes. Ideal para comparar listas, paquetes instalados, o diferencias entre configuraciones.

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

## Opciones principales

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

# Verificar si un paquete está instalado
pacman -Qq | sort | comm - - <(echo "git" | sort)
```

## Casos de uso

### Comparar paquetes entre dos sistemas

```bash
# Paquetes en A que no están en B
comm -23 <(ssh server-a "pacman -Qq" | sort) \
         <(ssh server-b "pacman -Qq" | sort)

# Paquetes en B que no están en A
comm -13 <(ssh server-a "pacman -Qq" | sort) \
         <(ssh server-b "pacman -Qq" | sort)

# Paquetes comunes
comm -12 <(ssh server-a "pacman -Qq" | sort) \
         <(ssh server-b "pacman -Qq" | sort)
```

### Verificar cambios en archivos de configuración

```bash
# Comparar configuración actual con original
sort /etc/nginx/nginx.conf > /tmp/actual.conf
sort /etc/nginx/nginx.conf.bak > /tmp/original.conf
comm -23 /tmp/actual.conf /tmp/original.conf   # líneas añadidas
comm -13 /tmp/actual.conf /tmp/original.conf   # líneas eliminadas
```

### Comparar listas de usuarios/grupos

```bash
# Usuarios en sistema actual vs backup
comm -23 <(cut -d: -f1 /etc/passwd | sort) \
         <(cut -d: -f1 /etc/passwd.bak | sort)

# Grupos diferentes
comm -23 <(getent group | cut -d: -f1 | sort) \
         <(cat grupos-base.txt | sort)
```

### Encontrar archivos duplicados

```bash
# Dos listas de nombres de archivo
comm -12 <(ls dir1/ | sort) <(ls dir2/ | sort)
```

## comm vs diff vs diff --minimal

| Aspecto | comm | diff | diff --minimal |
|---|---|---|---|
| **Archivos ordenados** | ✅ Requerido | No requerido | No requerido |
| **Formato** | 3 columnas | Unified/side-by-side | Unified |
| **Líneas comunes** | ✅ Columna 3 | ❌ Solo diferencias | ❌ |
| **Rendimiento** | ⚡ Muy rápido (O(n)) | ⚡ O(n²) worst case | ⚡ |
| **Ideal para** | Listas, paquetes | Código, configs | Código |

> **Regla simple**: usa `comm` para comparar **listas ordenadas** (paquetes, usuarios, archivos). Usa `diff` para comparar **archivos de texto** (configuración, código).

## Ver también

- `diff` — comparar archivos de texto
- `cmp` — comparar archivos byte a byte
- `sort` — ordenar líneas (necesario antes de comm)
- `uniq` — eliminar líneas duplicadas
- `join` — unir archivos por campo común
- [[Coreutils y util-linux]] — paquete que incluye comm

## Enlaces externos

- [Man page — comm](https://man7.org/linux/man-pages/man1/comm.1.html)
- [Wikipedia — comm (Unix)](https://en.wikipedia.org/wiki/Comm_(Unix))
- [GNU comm manual](https://www.gnu.org/software/coreutils/manual/html_node/comm-invocation.html)

#comando #texto #comparacion
