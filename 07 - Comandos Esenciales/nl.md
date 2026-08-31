---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
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

## Opciones principales

| Opción | Descripción |
|---|---|
| `-b <estilo>` | Qué líneas numerar: `a` (todas), `t` (no vacías), `n` (ninguna), `p<regex>` (las que matcheen) |
| `-n <formato>` | Formato del número: `ln` (izq), `rn` (der), `rz` (der con ceros) |
| `-s <sep>` | Separador entre número y texto (por defecto: tab) |
| `-w <ancho>` | Ancho del campo numérico |
| `-v <inicio>` | Número inicial |
| `-p` | No resetear numeración en archivos nuevos |
| `-l <N>` | No numerar las primeras N líneas vacías |

## Ejemplos

```bash
# Numerar todas las líneas (como cat -n)
nl archivo.txt

# Numerar solo líneas no vacías (por defecto)
nl -b t archivo.txt

# Numerar todas las líneas
nl -b a archivo.txt

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
```

## nl vs cat -n

| Aspecto | nl | cat -n |
|---|---|---|
| Numerar solo no vacías | ✅ `-b t` (default) | ❌ (numera todo) |
| Formato personalizable | ✅ (`-n ln/rn/rz`) | ❌ (solo der) |
| Separador personalizado | ✅ `-s` | ❌ (siempre tab) |
| Empezar desde N | ✅ `-v` | ❌ |
| Filtrar por regex | ✅ `-b p` | ❌ |
| Rendimiento | ⚡ | ⚡ |

## Ver también

- `cat -n` — alternativa rápida sin formato
- `head` / `tail` — ver primeras/últimas líneas
- `wc -l` — contar líneas
- `less` — con `-N` muestra números de línea

## Enlaces externos

- [Man page — nl](https://man7.org/linux/man-pages/man1/nl.1.html)

#comando #texto
