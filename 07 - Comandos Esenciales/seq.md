---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: baja
---

# seq

## Sintaxis

```bash
seq [inicio] [paso] [fin]
```

Genera una secuencia de números. Útil para loops y crear archivos numerados.

## Ejemplos

```bash
seq 5                            # 1 2 3 4 5
seq 2 2 10                       # 2 4 6 8 10
seq -f "%03g" 5                  # 001 002 003 004 005
seq -s ", " 5                    # 1, 2, 3, 4, 5
seq -w 10                        # 01 02 03 ... 10 (ancho fijo)
```

## Casos de uso

```bash
# Crear 100 archivos vacíos
seq -f "file_%03g.txt" 100 | xargs touch

# Loop numerado
for i in $(seq 1 5); do echo "Paso $i"; done
```

## Ver también

- [[yes]] — repetir string infinitamente
- [[sleep]] — pausar ejecución
- [[xargs]] — ejecutar comandos con argumentos

#comando
