---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: baja
---

# seq

## Sintaxis

```bash
seq [opciones] [inicio] [paso] [fin]
seq [opciones] fin
```

## Descripción

Genera una secuencia de números (uno por línea). Muy útil en **loops**, creación de archivos numerados, y como **generador de rangos** en pipelines. Es la base de la expansión por llaves `{1..5}` del shell, aunque ambas son independientes.

## Opciones frecuentes

| Flag / Opción | Efecto | Ejemplo |
|---|---|---|
| `-f FORMAT` | Formato estilo C (`%g`, `%02g`, `%.2f`) | `seq -f "%03g" 5` |
| `-s STRING` | Separador entre números (default: `\n`) | `seq -s ", " 5` |
| `-w` | Igualar ancho con ceros a la izquierda | `seq -w 10` |
| `-t STRING` | Terminador de línea (GNU) | `seq -t ";" 3` |

## Formato de salida

| Comando | Salida |
|---|---|
| `seq 5` | `1 2 3 4 5` (una por línea) |
| `seq 2 2 10` | `2 4 6 8 10` |
| `seq -f "%03g" 5` | `001 002 003 004 005` |
| `seq -s ", " 5` | `1, 2, 3, 4, 5` |
| `seq -w 10` | `01 02 ... 10` |

## Ejemplos

```bash
seq 5                            # 1 2 3 4 5
seq 2 2 10                       # 2 4 6 8 10
seq -f "%03g" 5                  # 001 002 003 004 005
seq -s ", " 5                    # 1, 2, 3, 4, 5
seq -w 10                        # 01 02 03 ... 10 (ancho fijo)
seq 10 -2 0                      # descendente: 10 8 6 4 2 0
seq 1.0 0.5 3.0                  # decimales: 1.0 1.5 ... 3.0
```

## Casos de uso

```bash
# Crear 100 archivos vacíos
seq -f "file_%03g.txt" 100 | xargs touch

# Loop numerado
for i in $(seq 1 5); do echo "Paso $i"; done

# Crear un directorio por día del mes
seq -f "dia%02g" 30 | xargs mkdir

# Nombres con padding para ordenación correcta
seq -w 1 20 | xargs -I{} touch "capitulo-{}.txt"
```

## Combinaciones comunes con pipe

```bash
# range + xargs (paralelo)
seq 1 100 | xargs -P4 -I{} curl -s "https://api/{}"

# secuencia usada como líneas de entrada
yes | seq 1 5 | paste -sd+
```

## Alternativas

| Herramienta | Uso |
|---|---|
| **`{1..5}`** | Expansión por llaves del shell (sin proceso extra) |
| **`echo {1..10..2}`** | Con paso en la expansión |
| **`awk 'BEGIN{for(i=1;i<=5;i++)print i}'`** | Secuencias programáticas |
| **`''` vs GNU seq** | BSD `seq` no tiene `--` — compatibilidad |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `seq: invalid floating point argument` | Argumento no numérico | Revisar espacios/separador decimal |
| Falta el `%` en el formato | `seq -f 03g` (sin `%`) | Usar `-f "%03g"` |
| Ceros no alinean | Mezcla de `-f` y `-w` | Usar solo `-w` para ancho automático |

## Notas y advertencias

- `seq` **no** está en POSIX — para máxima portabilidad usa la expansión `{n..m}` del shell (más rápida y sin subproceso).
- Con `-f`, el formato se reutiliza para todos los números; `%g` sin ancho no paddea.

## Enlaces externos

- [GNU Coreutils — seq](https://www.gnu.org/software/coreutils/manual/html_node/seq-invocation.html)
- [Arch Wiki Bash/Prompt — brace expansion](https://wiki.archlinux.org/title/Bash/Prompt_customization)

## Ver también

- [[yes]] — repetir string infinitamente
- [[sleep]] — pausar ejecución
- [[xargs]] — ejecutar comandos con argumentos
- [[bash-avanzado]] — loops y expansión de llaves

#comando
