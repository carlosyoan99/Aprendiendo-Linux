---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: media
---

# gdb

> GNU Debugger — el depurador estándar de Linux. Permite inspeccionar programas en ejecución, 设置 breakpoints, rastrear variables y analizar crashes.

## Sintaxis

```bash
gdb [opciones] [ejecutable]
gdb -p <PID>                       # adjuntar a proceso en ejecución
gdb -batch -ex run -ex bt ./prog    # modo batch (para scripts)
```

## Descripción

`gdb` es el depurador más poderoso de Linux. Depura C, C++, Rust, Go y otros lenguajes compilados. Es esencial para entender crashes (segfaults), memory leaks y comportamiento inesperado.

## Opciones principales

| Opción | Descripción |
|---|---|
| `run` / `r` | Ejecutar el programa |
| `break <línea/función>` / `b` | Poner breakpoint |
| `next` / `n` | Ejecutar siguiente línea (sin entrar en funciones) |
| `step` / `s` | Ejecutar siguiente línea (entrando en funciones) |
| `continue` / `c` | Continuar ejecución hasta siguiente breakpoint |
| `print <expr>` / `p` | Imprimir valor de variable |
| `backtrace` / `bt` | Mostrar pila de llamadas |
| `info locals` | Ver todas las variables locales |
| `watch <var>` | Poner watchpoint (para) en variable |
| `quit` / `q` | Salir de gdb |

## Ejemplos

### Depurar un crash (segfault)
```bash
# Compilar con información de depuración
gcc -g -o programa programa.c

# Ejecutar en gdb
gdb ./programa
(gdb) run                          # ejecutar
# ... crash occurs ...
(gdb) bt                           # ver pila de llamadas
(gdb) bt full                      # pila con valores de variables
(gdb) frame 2                      # ir al frame #2
(gdb) print variable               # ver valor de variable
```

### Poner breakpoints y rastrear
```bash
(gdb) break main                   # breakpoint en main()
(gdb) break 42                     # breakpoint en línea 42
(gdb) break foo                    # breakpoint en función foo()
(gdb) info breakpoints             # listar breakpoints
(gdb) delete 1                     # borrar breakpoint #1
(gdb) run                          # ejecutar hasta breakpoint
(gdb) next                         # siguiente línea
(gdb) print x                      # ver valor de x
(gdb) set x = 10                   # modificar valor
(gdb) continue                     # continuar
```

### Depurar core dump
```bash
# Generar core dump
ulimit -c unlimited
./programa                         # crashea → core generado

# Analizar core dump
gdb ./programa core
(gdb) bt full                      # ver dónde crasheó con variables
(gdb) info registers               # ver registros CPU
(gdb) x/20x $rsp                   # ver stack en hexadecimal
```

### Adjuntar a proceso en ejecución
```bash
gdb -p $(pidof nginx)              # depurar nginx en vivo
(gdb) bt                           # ver qué está haciendo
(gdb) thread apply all bt          # ver todos los hilos
(gdb) detach                       # soltar proceso
```

## Formato de salida

```
(gdb) bt
#0  0x00007ffff7a2d1f7 in __GI_raise (sig=6) at ../sysdeps/unix/sysv/linux/raise.c:50
#1  0x00007ffff7a16859 in __GI_abort () at abort.c:79
#2  0x00005555555551b7 in main (argc=2, argv=0x7fffffffe1a8) at programa.c:15
```

## Casos de uso

### Memory leak con valgrind + gdb
```bash
valgrind --leak-check=full ./programa 2>&1 | tee valgrind.log
# Luego usar gdb para inspeccionar las líneas reportadas
```

### Core dump para análisis posterior
```bash
# Habilitar core dumps
ulimit -c unlimited
echo '/tmp/core.%e.%p' | sudo tee /proc/sys/kernel/core_pattern

# Ejecutar programa
./programa

# Analizar después
gdb ./programa /tmp/core.programa.12345
```

### Debug con source files
```bash
# Si gdb no encuentra el source
(gdb) set directory /path/to/source
(gdb) list                         # ver código fuente
(gdb) list 10,20                   # líneas 10-20
```

## Combinaciones pipe

```bash
# Ejecutar gdb en batch mode (para CI/CD)
gdb -batch -ex "run" -ex "bt" ./programa 2>&1 | tail -20

# Extraer backtrace de core dump
gdb -batch -ex "bt" ./programa core 2>/dev/null | grep "#"
```

## Alternativas modernas

| Herramienta | Cuándo usarla |
|---|---|
| **gdb** | Depuración completa, C/C++/Rust |
| **lldb** | Depurador LLVM (alternativa moderna) |
| **valgrind** | Memory leaks y errores de memoria |
| **strace** | Trazar syscalls (no breakpoints) |
| **rr** | Record & Replay debugging |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| "no symbols" | No compilado con `-g` | Recompilar con `gcc -g` |
| "Cannot find" source | Source path incorrecto | `set directory /path/to/src` |
| Core dump no generado | ulimit no configurado | `ulimit -c unlimited` |
| Programa optimizado | Compiled with `-O2` | Recompilar con `-O0 -g` |

## Ver también

- [[strace]] — trazar syscalls
- [[Desarrollo en Linux (gcc make gdb strace)]] — guía completa de desarrollo
- [[ltrace]] — trazar llamadas a librerías
- [[Entorno de desarrollo Linux]] — configurar toolchain completo

## Enlaces externos

- [Wikipedia — GNU Debugger](https://en.wikipedia.org/wiki/GNU_Project_Debugger)
- [GDB Documentation](https://www.sourceware.org/gdb/documentation/)
- [GDB Quick Reference](https://darkdust.net/files/GDB%20Quick%20Reference.pdf)
- [Arch Wiki — GDB](https://wiki.archlinux.org/title/GDB)

#comando #desarrollo
