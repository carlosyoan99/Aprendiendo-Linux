---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: baja
---

# yes

## Sintaxis

```bash
yes [string]
```

## Descripción

Repite un string (por defecto `y`) infinitamente hasta que se interrumpe (Ctrl+C) o se cierra la tubería (`SIGPIPE`). Su uso principal es **auto-responder prompts interactivos** de forma no interactiva, especialmente en pipelines y scripts.

## Opciones frecuentes

| Flag / Opción | Efecto |
|---|---|
| `yes [string]` | Repetir un string personalizado |
| `yes ""` | Emitir línea en blanco (aceptar valor por defecto) |
| `yes --version` | Mostrar versión (GNU) |

> No tiene opciones complejas: todo el poder está en `string` y en el pipe.

## Ejemplos

```bash
yes                              # imprime "y" infinitamente
yes "instalar"                   # imprime "instalar" infinitamente
yes | sudo apt install paquete   # responder "y" automáticamente
yes '' | make install            # aceptar valores por defecto
```

## Casos de uso reales

```bash
# Auto-aceptar instaladores interactivos
yes | sh script-instalador.sh

# Reintentar un comando hasta que tenga salida (pipe + head)
yes | head -n 3                  # imprime solo 3 líneas y termina (SIGPIPE)

# Copiar/sobrescribir archivos en pipelines heredados
yes | cp -r origen/ destino/

# Generar mucho texto para pruebas de rendimiento
yes "línea de prueba" | head -n 1000 > demo.txt
```

## Combinaciones comunes con pipe

```bash
# limita la cantidad de salida (evita el bucle infinito)
yes | head -n 5

# alimenta comandos que preguntan continuamente
yes "opción" | comando-interactivo
```

## Alternativas

| Herramienta | Uso |
|---|---|
| **`yes`** | Auto-respuesta genérica |
| **`printf 'y\n'`** | Cuando solo necesitas una respuesta única |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `yes: write error: Broken pipe` | `head`/`sort` cerró la tubería | Normal — es `SIGPIPE`, no un fallo real |
| Bucle infinito sin fin | `yes` sin `head` ni cierre | Usar `Ctrl+C` o pipe a `head -n N` |

## Notas y advertencias

- **Peligro**: `yes | comando_destructivo` auto-acepta confirmaciones — úsalo con cuidado (ej. `yes | rm -rf`, `yes | dd`).
- En la mayoría de shells, `yes | ...` ya no es necesario porque los comandos modernos aceptan `-y` (apt) o `--assume-yes`.

## Enlaces externos

- [Wikipedia — yes (Unix)](https://en.wikipedia.org/wiki/Yes_(Unix))
- [GNU Coreutils — yes](https://www.gnu.org/software/coreutils/manual/html_node/yes-invocation.html)

## Ver también

- [[seq]] — generar secuencias numéricas
- [[sleep]] — pausar ejecución
- [[xargs]] — ejecutar comandos con argumentos
- [[bash-avanzado]] — pipelines y redirección

#comando
