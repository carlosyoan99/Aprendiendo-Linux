---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# strace

## Qué es

**strace** intercepta y registra todas las **llamadas al sistema** (system calls) que un programa hace al kernel: abrir archivos, leer/escribir, crear procesos, conexiones de red. Esencial para diagnosticar errores de permisos, archivos que no se encuentran, o problemas de rendimiento.

## Uso básico

```bash
# Trazar la ejecución de un comando
strace ./app

# Trazar un proceso ya en ejecución
strace -p 1234                           # PID 1234

# Opciones útiles combinadas
strace -f -e trace=open,read,write -o traza.log ./app
```

## Opciones principales

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

## Ejemplos prácticos

```bash
# ¿Qué archivos abre un programa al arrancar?
strace -e trace=open -o opens.log ./app
grep -E '\.(conf|ini|json)$' opens.log

# ¿Por qué un programa no encuentra un archivo?
strace -e trace=open,openat,stat ./app 2>&1 | grep -i "ENOENT"

# Resumen de llamadas al sistema
strace -c ./app

# Traza de red
strace -e trace=network connect,sendto,recvfrom curl http://example.com

# Diagnóstico de "archivo en uso"
strace -p PID -e trace=write -s 1000
```

## ltrace (llamadas a librerías)

Similar a strace pero intercepta llamadas a **librerías dinámicas** (malloc, printf, etc.) en lugar de llamadas al sistema:

```bash
sudo apt install ltrace
ltrace ./app
ltrace -e malloc+free ./app
```

## Alternativas modernas

| Herramienta clásica | Alternativa moderna | Diferencias |
|---|---|---|
| **strace** | **bpftrace** | Basado en eBPF, sin overhead, scripting potente |

## Ver también

- [[gcc]] — compilador de C/C++
- [[make]] — automatización de compilación
- [[gdb]] — depurador GNU
- [[Compilación desde Código Fuente]] — compilar e instalar programas

## Enlaces externos

- [Wikipedia — Strace](https://en.wikipedia.org/wiki/Strace)

#programa #desarrollo
