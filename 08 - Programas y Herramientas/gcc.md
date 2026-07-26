---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# GCC

## Qué es

**GCC** (GNU Compiler Collection) es el compilador de C (gcc) y C++ (g++) por excelencia en Linux. También se puede usar **clang** (LLVM) como alternativa, compatible con los mismos flags.

## Instalación

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

## Flags del compilador

| Flag | Significado | Cuándo usarlo |
|---|---|---|
| `-o archivo` | Nombre del binario de salida | Siempre |
| `-c` | Solo compilar (no enlazar), genera `.o` | Proyectos multi-archivo |
| `-Wall -Wextra` | Activar warnings | **Siempre** en desarrollo |
| `-Werror` | Tratar warnings como errores | CI, proyectos serios |
| `-O0` | Sin optimización | Depuración |
| `-O2` | Optimizar velocidad | Binarios de producción |
| `-Os` | Optimizar tamaño | Sistemas embebidos |
| `-g` | Incluir símbolos de depuración | Depuración con gdb |
| `-std=c11` / `-std=c++17` | Versión del estándar | Código moderno |
| `-march=native` | Optimizar para la CPU actual | Compilación local |
| `-fsanitize=address` | Detectar buffer overflows | Depuración avanzada |

## Ejemplos

```bash
# Compilar un solo archivo
gcc -Wall -Wextra -o hola hola.c

# Compilar con símbolos de depuración
gcc -g -o programa programa.c

# Compilar y enlazar múltiples archivos
gcc -c main.c -o main.o
gcc -c utilidades.c -o utilidades.o
gcc main.o utilidades.o -o app

# Compilar con AddressSanitizer
gcc -fsanitize=address -g -o app app.c
```

## Errores comunes

| Error | Significado | Solución |
|---|---|---|
| `undefined reference to 'func'` | El enlazador no encuentra la función | Añadir `-lm`, `-lpthread` al final |
| `fatal error: stdio.h: No such file or directory` | Falta el header del sistema | Instalar `build-essential` o `libc-dev` |
| `implicit declaration of function` | Usar función sin incluir su header | Añadir `#include <stdlib.h>` |
| `expected ';' before '}'` | Error de sintaxis (falta `;`) | Revisar línea anterior |

## Alternativas modernas

| Herramienta clásica | Alternativa moderna | Diferencias |
|---|---|---|
| **gcc** | **clang** (LLVM) | Mensajes de error más claros, compilación más rápida |

## Ver también

- [[make]] — automatización de compilación
- [[gdb]] — depurador GNU
- [[strace]] — traza de llamadas al sistema
- [[Compilación desde Código Fuente]] — compilar e instalar programas

## Enlaces externos

- [Sitio oficial — GCC](https://gcc.gnu.org/)
- [Wikipedia — GNU Compiler Collection (GCC)](https://en.wikipedia.org/wiki/GNU_Compiler_Collection)

#programa #desarrollo
