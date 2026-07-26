---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# GDB

## Qué es

**GDB** (GNU Debugger) permite ejecutar un programa paso a paso, inspeccionar variables, establecer breakpoints, y analizar un core dump después de un crash.

## Compilar para depuración

```bash
gcc -g -o app app.c     # -g incluye símbolos de depuración (necesario para gdb)
```

## Comandos básicos

```bash
gdb ./app                                # iniciar gdb con el binario

# Dentro de gdb:
run                                      # ejecutar el programa
run arg1 arg2                            # ejecutar con argumentos
break main                               # breakpoint al inicio de main()
break app.c:42                           # breakpoint en línea 42
break funcion                            # breakpoint al entrar en funcion()
info breakpoints                         # listar breakpoints
delete 1                                 # eliminar breakpoint 1
next                                     # ejecutar siguiente línea (sin entrar en funciones)
step                                     # ejecutar siguiente línea (entrando en funciones)
continue                                 # continuar hasta el siguiente breakpoint
print variable                           # mostrar valor de variable
print array[0..5]                        # mostrar rango de un array
backtrace                                # mostrar pila de llamadas (stack trace)
frame 2                                  # moverse al frame 2 de la pila
list                                     # mostrar código fuente alrededor
quit                                     # salir de gdb
```

## Análisis de core dump

```bash
# Habilitar core dumps
ulimit -c unlimited

# Ejecutar el programa hasta que crashee
./app                                    # Segmentation fault (core dumped)

# Analizar el core dump con gdb
gdb ./app core
# Dentro de gdb, usar:
backtrace                                # ¿dónde crasheó?
print variable                           # ¿qué valores tenían las variables?
```

## Comandos avanzados

```bash
# Watchpoints (detectar cuándo cambia una variable)
watch variable

# Variables condicionales
break main.c:42 if x == 0

# Depuración remota
# En el objetivo:
gdbserver :2345 ./app
# En el host de desarrollo:
gdb ./app
target remote 192.168.1.100:2345

# Interfaz TUI (modo texto con ventanas)
gdb -tui ./app
# Ctrl+X+A alterna entre modo TUI y línea de comandos
```

## Alternativas modernas

| Herramienta clásica | Alternativa moderna | Diferencias |
|---|---|---|
| **gdb** | **lldb** (LLVM) | Similar a gdb, para binarios compilados con clang |

## Ver también

- [[gcc]] — compilador de C/C++
- [[make]] — automatización de compilación
- [[strace]] — traza de llamadas al sistema
- [[Compilación desde Código Fuente]] — compilar e instalar programas

## Enlaces externos

- [Sitio oficial — GDB](https://www.sourceware.org/gdb/)
- [Wikipedia — GDB](https://en.wikipedia.org/wiki/GNU_Debugger)

#programa #desarrollo
