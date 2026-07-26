---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# Desarrollo en Linux (gcc, make, gdb, strace)

## Qué es

Linux es el entorno de desarrollo nativo para lenguajes compilados como C, C++ y Rust. El toolchain clásico incluye un compilador (gcc/clang), un sistema de construcción (make), un depurador (gdb) y herramientas de análisis (strace, ldd).

```
Flujo típico de desarrollo en C:

  Código fuente  ──►  Compilación  ──►  Binario  ──►  Depuración
  (main.c)            (gcc -o app)      (./app)       (gdb ./app)
```

## Notas individuales

Cada herramienta del toolchain tiene ahora su propia nota:

- [[gcc]] — compilador de C/C++ (flags, errores comunes, optimización)
- [[make]] — automatización de compilación (Makefile, targets, variables)
- [[gdb]] — depurador GNU (breakpoints, core dumps, análisis)
- [[strace]] — traza de llamadas al sistema (syscalls, filtros, ltrace)

## Toolchain completo de instalación

```bash
# Debian/Ubuntu
sudo apt install build-essential gdb strace ltrace valgrind manpages-dev

# Arch
sudo pacman -S base-devel gdb strace valgrind

# Fedora
sudo dnf groupinstall "Development Tools"
sudo dnf install gdb strace ltrace valgrind
```

## Flujo de troubleshooting

```bash
# 1. ¿Falta una librería?
ldd ./app | grep "not found"

# 2. ¿Error de permisos o archivo faltante?
strace -e trace=open,stat -o traza.log ./app

# 3. Crash: ¿dónde?
gcc -g -fsanitize=address -o app app.c
./app

# 4. Análisis post-mortem
ulimit -c unlimited
./app
gdb ./app core

# 5. Rendimiento
strace -c ./app

# 6. Profiling
gcc -pg -o app app.c
./app
gprof ./app gmon.out
```

## Alternativas modernas

| Herramienta clásica | Alternativa moderna | Diferencias |
|---|---|---|
| **gcc** | **clang** (LLVM) | Mensajes de error más claros |
| **make** | **CMake** / **Meson** | Más portable, manejo de dependencias automático |
| **gdb** | **lldb** (LLVM) | Para binarios compilados con clang |
| **strace** | **bpftrace** | Basado en eBPF, sin overhead |
| **valgrind** | **AddressSanitizer** (-fsanitize=address) | Integrado en el compilador, más rápido |

## Ver también

- [[Compilación desde Código Fuente]] — compilar e instalar programas
- [[Editores de Texto]] — elegir editor para escribir código
- [[Gestores de Paquetes]] — instalar dependencias de desarrollo
- [[Git]] — control de versiones

## Enlaces externos

- [Wikipedia — GNU Compiler Collection (GCC)](https://en.wikipedia.org/wiki/GNU_Compiler_Collection)
- [Wikipedia — Make (software)](https://en.wikipedia.org/wiki/Make_(software))
- [Wikipedia — GDB](https://en.wikipedia.org/wiki/GNU_Debugger)
- [Wikipedia — Strace](https://en.wikipedia.org/wiki/Strace)
- [Sitio oficial — GCC](https://gcc.gnu.org/)
- [Sitio oficial — GDB](https://www.sourceware.org/gdb/)

#programa #desarrollo
