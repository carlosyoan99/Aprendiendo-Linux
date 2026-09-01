---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: baja
---

# expr

> Evaluar expresiones aritméticas, de comparación y de cadenas. Útil en scripts bash antiguos (antes de `$(( ))`). Herramienta POSIX para compatibilidad con shells antiguos.

## Sintaxis

```bash
expr expresión
```

## Descripción

`expr` evalúa expresiones en la línea de comandos y imprime el resultado. Es una herramienta POSIX que existía antes de que bash tuviera aritmética nativa (`$(( ))`). Aún se encuentra en scripts legacy y en situaciones donde se necesita portabilidad POSIX pura.

> **Recomendación general**: usa `$(( ))` para aritmética y `[ ]` para comparación. `expr` solo es necesario para compatibilidad con scripts POSIX antiguos o bash 2.x.

## Operaciones

### Aritméticas

```bash
expr 2 + 3          # 5
expr 10 - 4         # 6
expr 3 \* 5         # 15 (escapar * para evitar glob)
expr 15 / 3         # 5
expr 17 % 5         # 2 (módulo)

# Variables
A=10; B=3
expr $A + $B        # 13
expr $A \* $B       # 30
```

### Comparación

```bash
expr 5 \> 3         # 1 (true)
expr 5 \< 3         # 0 (false)
expr 5 = 5          # 1 (true)
expr 5 != 3         # 1 (true)
expr 5 \>= 5        # 1 (true)
expr 5 \<= 4        # 0 (false)

# Nota: en shells POSIX, \> y \< son necesarios
# En bash, puedes usar [ 5 -gt 3 ] en su lugar
```

### Cadenas

```bash
expr length "hola"              # 4
expr substr "hola mundo" 1 4    # "hola"
expr index "hola" "l"           # 3 (posición del primer carácter)
expr match "hola123" '[a-z]*[0-9]*'  # 7 (largo del match)
expr "hello" : 'h\(.*\)o'      # "ell" (grupo de captura)
```

### Lógica

```bash
# AND lógico (ambos deben ser true)
expr 1 \& 1         # 1
expr 1 \& 0         # 0

# OR lógico
expr 1 \| 0         # 1
expr 0 \| 0         # 0
```

## En scripts bash

```bash
# ── ANTES (expr, bash 2.x / POSIX) ──
RESULTADO=$(expr $A + $B)
if [ $(expr $A \> $B) -eq 1 ]; then
    echo "A es mayor que B"
fi
CONTADOR=$(expr $CONTADOR + 1)

# ── AHORA (aritmética nativa, bash 3.x+) ──
RESULTADO=$((A + B))
if [ "$A" -gt "$B" ]; then
    echo "A es mayor que B"
fi
((CONTADOR++))
```

## expr vs alternativas

| Operación | expr | $(( )) | bc | awk |
|---|---|---|---|---|
| Enteros simples | ✅ | ✅ Más rápido | ✅ | ✅ |
| Flotantes | ❌ | ❌ | ✅ | ✅ |
| Strings | ✅ | ❌ | ❌ | ✅ |
| Scripts antiguos | ✅ | ❌ (bash < 3) | ✅ | ✅ |
| Legibilidad | Baja | Alta | Media | Media |
| POSIX puro | ✅ | ❌ (bashism) | Depende | Depende |

### Cuándo usar cada uno

| Necesidad | Herramienta |
|---|---|
| Aritmética en bash moderno | `$(( ))` |
| Comparación en scripts | `[ "$a" -gt "$b" ]` |
| Flotantes / precisión | `bc` |
| Strings en scripts | `[[ "$a" == *patron* ]]` |
| Portabilidad POSIX estricta | `expr` |
| Cálculos complejos | `awk` o `python -c` |

## Casos de uso

### Iterar con expr (scripts antiguos)

```bash
# POSIX-compatible: bucle con expr
i=1
while [ $i -le 10 ]; do
    echo "Iteración $i"
    i=$(expr $i + 1)
done
```

### Validar argumentos

```bash
# Verificar que se pasó un argumento
if [ $# -eq 0 ]; then
    echo "Uso: $0 <archivo>"
    exit 1
fi
```

## Ver también

- [[Coreutils y util-linux]] — paquete que incluye expr
- `bc` — calculadora de precisión arbitraria (flotantes)
- `dc` — calculadora inversa (postfix)
- `jq` — procesador JSON (para cálculos en JSON)
- `python -c` — para cálculos complejos rápidos

## Enlaces externos

- [Man page — expr](https://man7.org/linux/man-pages/man1/expr.1.html)
- [GNU expr manual](https://www.gnu.org/software/coreutils/manual/html_node/expr-invocation.html)
- [POSIX expr specification](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/expr.html)

#comando #scripts #posix
