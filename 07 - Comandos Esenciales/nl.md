---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: baja
---

# nl

> Numerar líneas de un archivo o de la entrada estándar. Más flexible que `cat -n` porque permite controlar el formato de numeración y qué líneas se numeran.

## Sintaxis

```bash
nl [opciones] [archivo...]
```

## Descripción

`nl` (number lines) añade números de línea a un archivo. A diferencia de `cat -n`, permite controlar qué líneas se numeran (todas, solo no vacías, por regex) y el formato del número (izquierda, derecha, con ceros). Es la herramienta estándar POSIX para numeración de líneas.

## Opciones principales

| Opción | Descripción |
|---|---|
| `-b <estilo>` | Qué líneas numerar: `a` (todas), `t` (no vacías), `p<regex>` (las que matcheen) |
| `-n <formato>` | Formato del número: `ln` (izq), `rn` (der), `rz` (der con ceros) |
| `-s <sep>` | Separador entre número y texto (por defecto: tab) |
| `-w <ancho>` | Ancho del campo numérico |
| `-v <inicio>` | Número inicial |
| `-l <N>` | No numerar las primeras N líneas vacías |

## Ejemplos

```bash
# Numerar todas las líneas (como cat -n)
nl -b a archivo.txt

# Numerar solo líneas no vacías (por defecto)
nl -b t archivo.txt

# Formato con ceros a la izquierda
nl -n rz archivo.txt

# Separador personalizado (espacio en vez de tab)
nl -s '  ' archivo.txt

# Empezar desde el número 100
nl -v 100 archivo.txt

# Numerar solo líneas que contienen "ERROR"
nl -b p'ERROR' log.txt

# Ancho de 4 dígitos
nl -w 4 archivo.txt

# Combinar: numerar todo, formato der, separador |
nl -b a -n rn -s '|' archivo.txt

# Numerar solo líneas de código (no comentarios ni vacías)
nl -b t -v 1 script.sh
```

## Casos de uso

### Numerar código fuente

```bash
# Numerar solo código (sin líneas vacías)
nl -b t script.py

# Numerar con formato legible
nl -b a -n rn -s ' ' script.py | head -20
#  1 #!/bin/bash
#  2
#  3 echo "Hola"
```

### Extraer rango de líneas con numeración

```bash
# Líneas 5-10 con números
nl -ba archivo.txt | sed -n '5,10p'

# Líneas que contienen un patrón
nl -bp'ERROR' /var/log/syslog | head -10
```

### Formatear salida para documentación

```bash
# Crear listing numerado de un archivo
nl -ba -n rz -w 3 -s '   ' archivo.txt > listing.txt
```

## nl vs cat -n

| Aspecto | nl | cat -n |
|---|---|---|
| Numerar solo no vacías | ✅ `-b t` (default) | ❌ (numera todo) |
| Formato personalizable | ✅ (`-n ln/rn/rz`) | ❌ (solo der) |
| Separador personalizado | ✅ `-s` | ❌ (siempre tab) |
| Empezar desde N | ✅ `-v` | ❌ |
| Filtrar por regex | ✅ `-b p` | ❌ |
| POSIX compatible | ✅ | ❌ (`-n` es extensión) |
| Rendimiento | ⚡ | ⚡ |

> **Regla simple**: para numeración rápida, `cat -n` es suficiente. Para control fino (formato, filtrado, separador), usa `nl`.

## Ver también

- `cat -n` — alternativa rápida sin formato
- `head` / `tail` — ver primeras/últimas líneas
- `wc -l` — contar líneas
- `less` — con `-N` muestra números de línea
- [[Coreutils y util-linux]] — paquete que incluye nl

## Enlaces externos

- [Man page — nl](https://man7.org/linux/man-pages/man1/nl.1.html)
- [GNU nl manual](https://www.gnu.org/software/coreutils/manual/html_node/nl-invocation.html)
- [Wikipedia — nl (command)](https://en.wikipedia.org/wiki/Nl_(command))

#comando #texto #formato
