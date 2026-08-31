---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: comando
prioridad: baja
---

# expr

> Evaluar expresiones aritméticas, de comparación y de cadenas. Útil en scripts bash antiguos (antes de `$(( ))`).

## Sintaxis

```bash
expr expresión
```

## Operaciones

### Aritméticas

```bash
expr 2 + 3          # 5
expr 10 - 4         # 6
expr 3 \* 5         # 15 (escapar *)
expr 15 / 3         # 5
expr 17 % 5         # 2 (módulo)
```

### Comparación

```bash
expr 5 \> 3         # 1 (true)
expr 5 \< 3         # 0 (false)
expr 5 = 5          # 1 (true)
expr 5 != 3         # 1 (true)
```

### Cadenas

```bash
expr length "hola"          # 4
expr substr "hola mundo" 1 4   # "hola"
expr index "hola" "l"      # 3 (posición del primer carácter)
expr match "hola123" '[a-z]*[0-9]*'  # 7 (largo del match)
```

## En scripts bash

```bash
# ANTES (expr, bash 2.x)
RESULTADO=$(expr $A + $B)

# AHORA (aritmética nativa, bash 3.x+)
RESULTADO=$((A + B))

# Comparación en scripts
if [ $(expr $A \> $B) -eq 1 ]; then
    echo "A es mayor que B"
fi

# AHORA (más limpio)
if [ "$A" -gt "$B" ]; then
    echo "A es mayor que B"
fi
```

## expr vs alternatives

| Operación | expr | $(( )) | bc | awk |
|---|---|---|---|---|
| Enteros simples | ✅ | ✅ Más rápido | ✅ | ✅ |
| Flotantes | ❌ | ❌ | ✅ | ✅ |
| Strings | ✅ | ❌ | ❌ | ✅ |
| Scripts antiguos | ✅ | ❌ (bash < 3) | ✅ | ✅ |
| Legibilidad | Baja | Alta | Media | Media |

> **Recomendación**: usa `$(( ))` para aritmética y `[ ]` para comparación. `expr` solo es necesario para compatibilidad con scripts POSIX antiguos o bash 2.x.

## Ver también

- `bc` — calculadora de precisión arbitraria (flotantes)
- `dc` — calculadora inversa (postfix)
- `jq` — procesador JSON (para cálculos en JSON)
- `python -c` — para cálculos complejos rápidos

## Enlaces externos

- [Man page — expr](https://man7.org/linux/man-pages/man1/expr.1.html)

#comando #scripts
