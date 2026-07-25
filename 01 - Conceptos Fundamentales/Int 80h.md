---
fecha_creacion: 2026-07-20
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

### Syscalls comunes

| N° | Nombre | Función |
|---|---|---|
| 1 | exit | Salir del proceso |
| 3 | read | Leer de un descriptor |
| 4 | write | Escribir en un descriptor |
| 5 | open | Abrir archivo |
| 6 | close | Cerrar archivo |
| 13 | lseek | Mover puntero del archivo |

## En x86-64

En sistemas de 64 bits, `int 80h` fue reemplazado por las instrucciones **`syscall`** (AMD64) / **`sysenter`** (Intel), que son mucho más rápidas porque evitan la sobrecarga de una interrupción.

## Enlaces externos

- [Linux Syscall Table](http://www.informatik.htw-dresden.de/~beck/ASM/syscall_list.html)
- [Wikipedia — Int 80h](https://es.wikipedia.org/wiki/Int_80h)
- [Unix Assembly Language Programming](http://www.int80h.org/)

## Ver también

- [[Compilacion desde Codigo Fuente]] — relación con el kernel
- [[Proc y Sys]] — interacción con el kernel
- [[Procesos y Senales]] — gestión de procesos

#concepto #kernel #ensamblador
