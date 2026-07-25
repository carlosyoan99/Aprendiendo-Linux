---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: programa
prioridad: media
---

# Desarrollo en Linux (gcc, make, gdb, strace)

## Qué es

Linux es el entorno de desarrollo nativo para lenguajes compilados como C, C++ y Rust. El toolchain clásico incluye un compilador (gcc/clang), un sistema de construcción (make), un depurador (gdb) y herramientas de análisis (strace, ldd). Herramientas como gcc y make forman parte del estándar POSIX desde los años 70 y son la base sobre la que se construye prácticamente todo el software del sistema.

```
Flujo típico de desarrollo en C:

  Código fuente  ──►  Compilación  ──►  Binario  ──►  Depuración
  (main.c)            (gcc -o app)      (./app)       (gdb ./app)
                        │                              │
                   Optimización ──► strace/ltrace      │
                   (-O2 -march)      (llamadas al      │
                                      sistema)         │
                                  Análisis post-mortem ◄┘
                                  (gdb core dump)
```

---

## make — Automatización de compilación

Make lee un `Makefile` que describe **reglas** (targets, dependencias y comandos) para compilar un proyecto. Solo recompila lo necesario comparando timestamps.

### Instalación

```bash
# Prácticamente siempre instalado. Si no:
sudo apt install make                   # Debian/Ubuntu
sudo pacman -S make                     # Arch
sudo dnf install make                   # Fedora
```

### Sintaxis básica de un Makefile

```makefile
# Makefile mínimo
CC = gcc
CFLAGS = -Wall -Wextra -O2

app: main.c utilidades.c
	$(CC) $(CFLAGS) -o app main.c utilidades.c

clean:
	rm -f app *.o

.PHONY: clean
```

| Componente | Qué es |
|---|---|
| `CC` | Variable: el compilador a usar |
| `CFLAGS` | Variable: flags del compilador (`-Wall` activa warnings, `-O2` optimiza) |
| `app:` | Target: el archivo o acción a generar |
| `main.c utilidades.c:` | Dependencias: si cambian, se re-ejecuta la receta |
| `$(CC) ...` | Receta: comandos a ejecutar (deben ir precedidos de TAB, no espacios) |
| `clean:` | Target sin archivo: limpiar archivos generados |
| `.PHONY` | Marca targets que no son archivos reales |

### Uso

```bash
make              # compila el primer target (por defecto: app)
make app          # compila solo el target app
make clean        # ejecuta la receta clean
make -j4          # compilar en paralelo (4 procesos)
make -f Makefile.mi  # usar un archivo con nombre distinto
```

### Variables automáticas y patrones

```makefile
# Makefile más avanzado
CC = gcc
CFLAGS = -Wall -Wextra -O2 -g
LDFLAGS = -lm                          # librería matemática

# $@ → nombre del target
# $< → primera dependencia
# $^ → todas las dependencias

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

app: main.o utilidades.o
	$(CC) $(LDFLAGS) $^ -o $@

clean:
	rm -f app *.o
```

---

## gcc / g++ — Compiladores GNU

El compilador de C (gcc) y C++ (g++) por excelencia en Linux. También se puede usar **clang** (LLVM) como alternativa, compatible con los mismos flags.

### Instalación

```bash
# Debian/Ubuntu
sudo apt install build-essential        # paquete meta: gcc, g++, make, libc-dev

# Arch
sudo pacman -S base-devel               # paquete meta: gcc, make, autoconf, etc.

# Fedora
sudo dnf groupinstall "Development Tools"
sudo dnf install gcc gcc-c++ make

# Verificar versión
gcc --version
g++ --version
```

### Flags del compilador

| Flag | Significado | Cuándo usarlo |
|---|---|---|
| `-o archivo` | Nombre del binario de salida | Siempre |
| `-c` | Solo compilar (no enlazar), genera `.o` | Proyectos multi-archivo |
| `-Wall -Wextra` | Activar warnings | **Siempre** en desarrollo |
| `-Werror` | Tratar warnings como errores | CI, proyectos serios |
| `-O0` | Sin optimización (por defecto) | Depuración |
| `-O2` | Optimizar velocidad | Binarios de producción |
| `-Os` | Optimizar tamaño | Sistemas embebidos |
| `-g` | Incluir símbolos de depuración | Depuración con gdb |
| `-std=c11` / `-std=c++17` | Versión del estándar | Código moderno |
| `-march=native` | Optimizar para la CPU actual | Compilación local. ⚠️ El binario **no será portable** a otras CPUs |
| `-DNDEBUG` | Desactivar `assert()` | Release |
| `-fsanitize=address` | Detectar buffer overflows (AddressSanitizer) | **Depuración avanzada** |

### Ejemplos

```bash
# Compilar un solo archivo
gcc -Wall -Wextra -o hola hola.c

# Compilar con símbolos de depuración
gcc -g -o programa programa.c

# Compilar y enlazar múltiples archivos
gcc -c main.c -o main.o                  # paso 1: compilar
gcc -c utilidades.c -o utilidades.o       # paso 1
gcc main.o utilidades.o -o app           # paso 2: enlazar

# Compilar con AddressSanitizer (detecta desbordamientos)
gcc -fsanitize=address -g -o app app.c
# Al ejecutar, si hay buffer overflow, imprime un reporte detallado
```

### Errores comunes de compilación

| Error | Significado | Solución |
|---|---|---|
| `undefined reference to 'func'` | El enlazador no encuentra la función | Faltan librerías: añadir `-lm`, `-lpthread` al final |
| `fatal error: stdio.h: No such file or directory` | Falta el header del sistema | Instalar `build-essential` o `libc-dev` |
| `implicit declaration of function` | Usar función sin incluir su header | Añadir `#include <stdlib.h>` o el header adecuado |
| `expected ';' before '}'` | Error de sintaxis (falta `;`) | Revisar línea anterior |

---

## gdb — Depurador GNU

GDB permite ejecutar un programa paso a paso, inspeccionar variables, establecer breakpoints, y analizar un core dump después de un crash.

### Compilar para depuración

```bash
gcc -g -o app app.c     # -g incluye símbolos de depuración (necesario para gdb)
```

### Comandos básicos

```bash
gdb ./app                                # iniciar gdb con el binario

# Dentro de gdb:
run                                      # ejecutar el programa (sin argumentos)
run arg1 arg2                            # ejecutar con argumentos
run < input.txt                          # ejecutar redirigiendo stdin desde archivo
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

### Análisis de core dump

Cuando un programa crash, el sistema puede generar un archivo `core` que gdb puede leer:

```bash
# Habilitar core dumps
ulimit -c unlimited                      # permitir cores (sesión actual)
# O permanentemente en /etc/security/limits.conf:
# *               soft    core            unlimited

# Ejecutar el programa hasta que crashee
./app                                    # Segmentation fault (core dumped)

# Analizar el core dump con gdb
gdb ./app core                           # o core.1234 (nombre con PID)
# Dentro de gdb, usar:
backtrace                                # ¿dónde crasheó?
print variable                           # ¿qué valores tenían las variables?
frame N                                  # inspeccionar cada nivel de la pila
```

### Comandos avanzados

```bash
# Ejecutar comandos en cada breakpoint
break main.c:42
commands
  > print variable
  > continue
  > end

# Watchpoints (detectar cuándo cambia una variable)
watch variable                           # para cuando variable cambie

# Variables condicionales
break main.c:42 if x == 0               # breakpoint solo cuando x sea 0

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

---

## strace — Traza de llamadas al sistema

Strace intercepta y registra todas las **llamadas al sistema** (system calls) que un programa hace al kernel: abrir archivos, leer/escribir, crear procesos, conexiones de red. Esencial para diagnosticar "permiso denegado", archivos que no se encuentran, o problemas de rendimiento.

### Uso básico

```bash
# Trazar la ejecución de un comando
strace ./app

# Trazar un proceso ya en ejecución
strace -p 1234                           # PID 1234

# Opciones útiles combinadas
strace -f -e trace=open,read,write -o traza.log ./app
```

### Opciones principales

| Opción | Efecto | Ejemplo |
|---|---|---|
| `-f` | Seguir procesos hijo (fork) | `strace -f ./servidor` |
| `-e trace=open,read` | Filtrar por llamadas específicas | Solo open y read |
| `-e trace=network` | Solo llamadas de red | `strace -e trace=network curl google.com` |
| `-e trace=file` | Solo llamadas a archivos | `strace -e trace=file ./app` |
| `-o archivo` | Escribir salida a archivo | `strace -o salida.log ./app` |
| `-c` | Contar llamadas (resumen estadístico) | `strace -c ./app` |
| `-p PID` | Adjuntarse a proceso en ejecución | `strace -p $(pgrep nginx)` |
| `-s 256` | Mostrar hasta 256 bytes por llamada | `strace -s 256 ./app` |
| `-t` | Mostrar timestamp por llamada | `strace -t ./app` |
| `-T` | Mostrar tiempo empleado en cada llamada | `strace -T ./app` |

### Ejemplos prácticos

```bash
# ¿Qué archivos abre un programa al arrancar?
strace -e trace=open -o opens.log ./app
grep -E '\.(conf|ini|json)$' opens.log   # ver solo archivos de config

# ¿Por qué un programa no encuentra un archivo?
strace -e trace=open,openat,stat ./app 2>&1 | grep -i "ENOENT"
# Busca en la salida errores "No such file or directory"

# Resumen de llamadas al sistema (¿dónde gasta tiempo?)
strace -c ./app
# Muestra: % time, calls, errors por tipo de llamada

# Traza de red (para un cliente HTTP)
strace -e trace=network connect,sendto,recvfrom curl http://example.com

# Diagnóstico de "archivo en uso"
strace -p PID -e trace=write -s 1000     # ver qué está escribiendo un proceso
```

### ltrace (llamadas a librerías)

Similar a strace pero intercepta llamadas a **librerías dinámicas** (malloc, printf, etc.) en lugar de llamadas al sistema:

```bash
# Instalación
sudo apt install ltrace                  # Debian/Ubuntu
sudo pacman -S ltrace                    # Arch
sudo dnf install ltrace                  # Fedora

# Uso
ltrace ./app                             # traza llamadas a funciones de librerías
ltrace -e malloc+free ./app              # solo malloc y free
ltrace -p PID                            # adjuntarse a proceso
```

---

## ldd — Dependencias de librerías dinámicas

Muestra qué librerías compartidas necesita un binario. Útil para diagnosticar "error while loading shared libraries":

```bash
ldd /usr/bin/git                        # ver librerías que necesita git
ldd /usr/bin/git | grep "not found"     # ¿falta alguna librería?
```

```bash
# Si una librería no se encuentra:
# 1. Verificar que está instalada
dpkg -S libssl.so                       # buscar paquete que contiene la librería

# 2. Si está instalada pero en ruta no estándar, añadir al cache
sudo ldconfig                           # actualizar cache de librerías

# 3. Añadir ruta personalizada
export LD_LIBRARY_PATH=/ruta/libreria:$LD_LIBRARY_PATH
```

---

## Toolchain completo de desarrollo

```bash
# ── Debian/Ubuntu ──
sudo apt install build-essential         # gcc, g++, make, libc-dev
sudo apt install gdb                     # depurador
sudo apt install strace ltrace           # trazadores
sudo apt install valgrind                # detector de fugas de memoria (opcional)
sudo apt install manpages-dev            # documentación (man 3 printf, etc.)

# ── Arch Linux ──
sudo pacman -S base-devel                # gcc, make, autoconf, pkg-config...
sudo pacman -S gdb strace valgrind

# ── Fedora ──
sudo dnf groupinstall "Development Tools"
sudo dnf install gcc gcc-c++ gdb strace ltrace valgrind
```

---

## Flujo de troubleshooting con estas herramientas

Cuando un programa se comporta de forma inesperada (crash, rendimiento, permisos):

```bash
# 1. ¿Falta una librería?
ldd ./app | grep "not found"

# 2. ¿Error de permisos o archivo faltante?
strace -e trace=open,stat -o traza.log ./app
grep -i "enoent\|eacces" traza.log

# 3. Crash: ¿dónde?
gcc -g -fsanitize=address -o app app.c   # recompilar con ASan
./app                                     # reporta desbordamientos

# 4. Crash: análisis post-mortem
ulimit -c unlimited
./app                                     # esperar crash
gdb ./app core
(gdb) backtrace

# 5. Rendimiento: ¿en qué gasta tiempo?
strace -c ./app                           # resumen de syscalls

# 6. Profiling (compilar con gcc -pg primero)
gcc -pg -o app app.c                      # compilar con profiling habilitado
./app                                      # ejecutar normalmente (genera gmon.out)
gprof ./app gmon.out                      # mostrar perfil de ejecución
```

---

## Alternativas modernas

| Herramienta clásica | Alternativa moderna | Diferencias |
|---|---|---|
| **gcc** | **clang** (LLVM) | Mensajes de error más claros, compilación más rápida, mejor integración con IDEs |
| **make** | **CMake** | Genera Makefiles u otros (Ninja). Más portable, manejo de dependencias automático |
| **make** | **Meson** | Más rápido que CMake, sintaxis Python-like. Usado por GNOME, Systemd |
| **gdb** | **lldb** (LLVM) | Similar a gdb, pero para binarios compilados con clang |
| **strace** | **bpftrace** | Basado en eBPF, sin overhead de strace, scripting potente |
| **valgrind** | **AddressSanitizer** (-fsanitize=address) | Integrado en el compilador, mucho más rápido que valgrind |
| **make** | **Ninja** | Sistema de construcción minimalista, extremadamente rápido |

## Ver también

- [[Compilacion desde Codigo Fuente]] — compilar e instalar programas desde código
- [[Editores de Texto]] — elegir editor para escribir código
- [[Gestores de Paquetes]] — instalar dependencias de desarrollo
- [[Shells (bash zsh fish)]] — entornos para desarrollo
- [[Automatizacion y Scripts]] — automatizar builds y tests
- [[Git]] — control de versiones para proyectos de desarrollo

## Enlaces externos

- [Wikipedia — GNU Compiler Collection (GCC)](https://en.wikipedia.org/wiki/GNU_Compiler_Collection)
- [Wikipedia — Make (software)](https://en.wikipedia.org/wiki/Make_(software))
- [Wikipedia — GDB](https://en.wikipedia.org/wiki/GNU_Debugger)
- [Wikipedia — Strace](https://en.wikipedia.org/wiki/Strace)
- [Sitio oficial — GCC](https://gcc.gnu.org/)
- [Sitio oficial — GDB](https://www.sourceware.org/gdb/)

#programa
