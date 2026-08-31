---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: concepto
prioridad: baja
---

# Int 80h

> Instrucción en lenguaje ensamblador x86 que invoca **llamadas al sistema (syscalls)** en Linux. Fue el mecanismo principal de syscalls antes de `sysenter`/`syscall` (x86-64).

## Definición

En sistemas x86 de 32 bits, la instrucción `int 80h` (interrupción 0x80) era la puerta de entrada desde el espacio de usuario al kernel Linux para ejecutar servicios del sistema (abrir archivos, leer, escribir, crear procesos, etc.).

## Funcionamiento

- **EAX**: número de servicio (syscall number)
- **EBX, ECX, EDX, ESI, EDI**: argumentos
- Resultado devuelto en **EAX**

### Ejemplos

```assembly
; Salir del programa (syscall 1)
mov eax, 1
mov ebx, 0
int 80h

; Escribir en stdout (syscall 4)
mov eax, 4
mov ebx, 1        ; stdout
mov ecx, mensaje
mov edx, 100
int 80h

; Leer de teclado (syscall 3)
mov eax, 3
mov ebx, 0        ; stdin
mov ecx, buffer
mov edx, 100
int 80h
```

### Syscalls comunes (x86 32-bit)

| N° | Nombre | Función |
|---|---|---|
| 1 | exit | Salir del proceso |
| 2 | fork | Crear proceso hijo |
| 3 | read | Leer de un descriptor |
| 4 | write | Escribir en un descriptor |
| 5 | open | Abrir archivo |
| 6 | close | Cerrar archivo |
| 11 | execve | Ejecutar programa |
| 13 | lseek | Mover puntero del archivo |
| 19 | write | Escribir |
| 45 | brk | Aumentar tamaño del heap |

## Evolución: de int 80h a syscall

| Mecanismo | Arquitectura | Velocidad | Instrucción |
|---|---|---|---|
| `int 80h` | x86 (32-bit) | Lenta (~100 ciclos) | Interrupción por software |
| `sysenter` | x86 (32-bit, Intel) | Rápida (~25 ciclos) | Instrucción especial |
| `sysexit` | x86 (32-bit, Intel) | Rápida | Retorno de sysenter |
| `syscall` | x86-64 (AMD64) | Rápida (~25 ciclos) | Instrucción especial |
| `sysret` | x86-64 (AMD64) | Rápida | Retorno de syscall |

### Por qué int 80h es lenta

`int 80h` genera una **interrupción de software** completa: el procesador busca la tabla de interrupciones (IDT), cambia de privilege level, salva todos los registros, ejecuta el handler, y restaura. Esto impone overhead innecesario para una llamada que siempre va al mismo lugar.

`sysenter`/`syscall` evitan toda esa sobrecarga usando un registro dedicado (`MSR`) que contiene la dirección del kernel, saltando directamente al handler sin pasar por la tabla de interrupciones.

## En x86-64

En sistemas de 64 bits, `int 80h` fue reemplazado por las instrucciones **`syscall`** (AMD64) / **`sysenter`** (Intel), que son mucho más rápidas porque evitan la sobrecarga de una interrupción.

> `int 80h` sigue funcionando en x86-64 por compatibilidad, pero es ~4x más lento que `syscall`. Las bibliotecas C modernas (glibc, musl) usan `syscall` directamente.

## Cómo ver syscalls en acción

```bash
# Trazar syscalls de un programa
strace ls /tmp

# Salida (ejemplo):
# openat(AT_FDCWD, "/tmp", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
# getdents64(3, /* 5 entries */, 32768)       = 128
# write(1, "file1\nfile2\n", 12)              = 12
# close(3)                                     = 0
# exit_group(0)                                = ?
```

```bash
# Contar syscalls totales de un programa
strace -c ls /tmp

# Salida:
# % time     seconds  usecs/call     calls    errors
# ------ ----------- ----------- --------- ---------
#  45.23    0.000012           4         3
#  30.15    0.000008           8         1
#  24.62    0.000006           2         3
# ------ ----------- ----------- --------- ---------
# 100.00    0.000026                     7 total
```

## Referencia rápida de números de syscall

Los números varían por arquitectura. Consultar la tabla oficial:

```bash
# Ver números de syscall del sistema actual
ausyscall --dump          # si audit está instalado
# O buscar en: /usr/include/asm/unistd_64.h
```

## Enlaces externos

- [Linux Syscall Table](http://www.informatik.htw-dresden.de/~beck/ASM/syscall_list.html)
- [Wikipedia — Int 80h](https://es.wikipedia.org/wiki/Int_80h)
- [Unix Assembly Language Programming](http://www.int80h.org/)
- [Linux system call table (x86-64)](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/)

## Ver también

- [[strace]] — trazador de system calls
- [[Compilación desde Código Fuente]] — relación con el kernel
- [[Proc y Sys]] — interacción con el kernel
- [[Procesos y Senales]] — gestión de procesos

#concepto #kernel #ensamblador
