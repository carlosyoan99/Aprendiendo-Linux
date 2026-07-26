---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: baja
---

# ltrace

> Trazador de llamadas a librerías (shared libraries). Muestra qué funciones de libc y otras librerías invoca un programa durante su ejecución.

## Sintaxis

```bash
ltrace [opciones] [comando]
ltrace -p <PID>                     # adjuntar a proceso en ejecución
```

## Descripción

`ltrace` es complementario a `strace`: mientras strace traza syscalls (llamadas al kernel), ltrace traza llamadas a funciones en librerías compartidas (libc, libm, etc.). Útil para entender cómo un programa usa las librerías del sistema.

## Opciones principales

| Opción | Descripción |
|---|---|
| `-e <filtro>` | Filtrar por nombre de función |
| `-c` | Contar llamadas (resumen al salir) |
| `-p <PID>` | Adjuntar a proceso existente |
| `-o <archivo>` | Guardar salida en archivo |
| `-n <n>` | Indentar llamadas recursivas |
| `-S` | Mostrar syscalls junto con llamadas a libs |
| `-x <lib>` | Trazar solo llamadas de librería específica |

## Ejemplos

### Trazar un programa simple
```bash
ltrace ls /tmp
# Muestra todas las llamadas a funciones como malloc(), opendir(), readdir(), etc.
```

### Solo mostrar llamadas a malloc/free
```bash
ltrace -e malloc+free ./programa
# Útil para detectar memory leaks
```

### Contar llamadas a funciones
```bash
ltrace -c ./programa
# Resumen: cuántas veces se llamó cada función
#   % time    seconds  usecs/call     calls      function
#   45.23    0.012345         123       100 malloc
#   30.12    0.008234          82       100 free
```

### Adjuntar a proceso en ejecución
```bash
ltrace -p $(pidof nginx)
# Ver qué librerías está llamando nginx en vivo
```

### Filtrar por librería específica
```bash
ltrace -x libc.so.6 ./programa
# Solo mostrar llamadas de libc
```

### Combinar con strace
```bash
ltrace -S ./programa
# Muestra tanto llamadas a librerías como syscalls
```

## Formato de salida

```
__libc_start_main(0x401140, 2, 0x7ffd3a2b1230, ...)
malloc(1024)                                          = 0x55a1b2c3d4e0
opendir("/tmp")                                       = 0x55a1b2c3d500
readdir(0x55a1b2c3d500)                               = 0x55a1b2c3d520
strcmp("archivo.txt", ".")                             = 10
free(0x55a1b2c3d4e0)                                  = <void>
```

## Casos de uso

### Entender cómo usa memoria un programa
```bash
ltrace -e malloc+realloc+free ./programa
```

### Debug de librería compartida
```bash
ltrace -x libfoo.so ./programa
# Ver todas las llamadas a libfoo
```

### Contar llamadas a funciones de red
```bash
ltrace -e connect+send+recv -c ./programa
```

## Combinaciones pipe

```bash
# Contar llamadas y ordenar por frecuencia
ltrace -c ./programa 2>&1 | sort -rn -k4

# Guardar traza para análisis posterior
ltrace -o trace.log ./programa
grep malloc trace.log | wc -l    # cuántos mallocs
```

## Alternativas

| Herramienta | Enfoque |
|---|---|
| **strace** | Syscalls (llamadas al kernel) |
| **ltrace** | Llamadas a librerías |
| **LD_DEBUG** | Información de linker (dinámico) |
| **gdb** | Depuración completa |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| "not found" | No instalado | `sudo apt install ltrace` |
| Muy verboso | Muchas llamadas | Usar `-e` para filtrar |
| No muestra funciones | Binary stripped | Compilar sin strip o usar `-e` |

## Ver también

- [[strace]] — trazar syscalls
- [[gdb]] — depurador completo
- [[Desarrollo en Linux (gcc make gdb strace)]] — guía de desarrollo

## Enlaces externos

- [Wikipedia — ltrace](https://en.wikipedia.org/wiki/Ltrace)
- [man ltrace(1)](https://man7.org/linux/man-pages/man1/ltrace.1.html)
- [Arch Wiki — ltrace](https://wiki.archlinux.org/title/Ltrace)

#comando #desarrollo
