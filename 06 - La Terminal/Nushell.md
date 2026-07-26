---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: terminal
prioridad: baja
---

# Nushell

> Shell estructurada donde los datos fluyen como tablas tipadas en vez de strings. Alternativa moderna a bash/zsh/fish.

## Qué es

Nushell (nu) trata la salida de comandos como **tablas de datos estructurados** con tipos (string, int, float, date, path). Esto permite filtrar, ordenar y transformar datos sin解析ar strings.

```bash
# En bash: parsear salida de ls es complicado
ls -la | awk '{print $5, $9}'

# En Nushell: la salida YA es una tabla
ls | get size name
ls | where size > 1mb | sort-by size
```

## Sintaxis

```bash
nu                                  # iniciar shell
nu -c "comando"                     # ejecutar comando
```

## Ejemplos

```bash
ls | where size > 1mb              # filtrar archivos grandes
ls | sort-by modified              # ordenar por fecha
ps | where cpu > 50                # procesos con >50% CPU
open data.json | get users.0.name  # leer JSON directamente
cat data.csv | from csv            # parsear CSV
```

## Ver también

- [[Shells (bash zsh fish)]], [[La Shell]]

#terminal #shell
