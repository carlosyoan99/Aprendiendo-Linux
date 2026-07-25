---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# strace

> Intercepta y registra las llamadas al sistema (syscalls) que realiza un programa. Esencial para depurar problemas de permisos, archivos faltantes, errores de conexión, y entender qué hace realmente una aplicación.

## Sintaxis

```bash
strace [opciones] comando [args...]
strace -p PID                     # adjuntarse a proceso en ejecución
strace -f comando                 # seguir procesos hijo (fork)
```

## Descripción

`strace` (system trace) captura las llamadas al sistema que un programa hace al kernel: abrir archivos, leer/escribir, conectar sockets, etc. Es la herramienta definitiva para responder preguntas como:

- ¿Por qué este programa dice "Permission denied"?
- ¿Qué archivos de configuración está intentando leer?
- ¿Por qué no puede conectar a ese servidor?
- ¿Dónde está pasando el 90% del tiempo?

Cada syscall se muestra con sus argumentos (truncados según opciones) y su valor de retorno.

## Formato de salida

```bash
$ strace cat /etc/hostname
execve("/usr/bin/cat", ["cat", "/etc/hostname"], [/* 58 vars */]) = 0
openat(AT_FDCWD, "/etc/hostname", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=12, ...}) = 0
read(3, "myhostname\\n", 131072)           = 11
write(1, "myhostname\\n", 11)              = 11
read(3, "", 131072)                        = 0
close(3)                                   = 0
exit_group(0)                              = ?
+++ exited with 0 +++
```

| Componente | Significado |
|---|---|
| `execve(...)` | Syscall para ejecutar el binario |
| `openat(..., \"/etc/hostname\", ...)`=3 | Abre archivo → devuelve fd=3 |
| `read(3, ..., 131072)=11` | Lee 11 bytes del fd 3 |
| `write(1, ..., 11)=11` | Escribe 11 bytes al fd 1 (stdout) |
| `close(3)=0` | Cierra el fd (éxito) |
| `+++ exited with 0 +++` | Programa terminó con código 0 |

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-f` | Seguir procesos hijo (fork, clone) | `strace -f nginx` |
| `-ff` | Cada hijo a su propio archivo (-o archivo) | `strace -ff -o log ./app` |
| `-o archivo` | Escribir salida a archivo (no stderr) | `strace -o salida.log ./app` |
| `-e trace=syscall` | Filtrar por syscall específica | `strace -e trace=open,openat,read,write` |
| `-e trace=file` | Solo syscalls de archivos | `strace -e trace=file ./app` |
| `-e trace=network` | Solo syscalls de red | `strace -e trace=network nc google.com 80` |
| `-e trace=process` | Solo gestión de procesos | `strace -e trace=process ./app` |
| `-e trace=signal` | Solo señales | `strace -e trace=signal ./app` |
| `-p PID` | Adjuntarse a proceso en ejecución | `strace -p 1234` |
| `-c` | Resumen de syscalls (contar + tiempo) | `strace -c ./app` |
| `-t` | Timestamps (hora del día) | `strace -t ./app` |
| `-r` | Timestamps relativos (entre syscalls) | `strace -r ./app` |
| `-T` | Tiempo gastado DENTRO de cada syscall | `strace -T ./app` |
| `-s N` | Mostrar hasta N bytes de cada string | `strace -s 1024 ./app` |
| `-v` | Verboso (no abreviar structs) | `strace -v ./app` |
| `-e fault=syscall:error=ENOENT` | Inyectar errores (testing) | `strace -e fault=open:error=EACCES:when=3 ./app` |

## Ejemplos

```bash
# 1. Traza básica (salida a stderr)
strace cat /etc/hostname

# 2. Guardar traza a archivo
strace -o traza.log ./app

# 3. Adjuntarse a proceso en ejecución (Ctrl+C para detener)
strace -p $(pgrep nginx)
strace -p 1234

# 4. Solo syscalls de archivos (útil para permisos)
strace -e trace=file ./app
# Muestra qué archivos abre, si falla con EACCES (permiso) o ENOENT (no existe)

# 5. Solo syscalls de red
strace -e trace=network curl https://example.com
# connect, sendto, recvfrom...

# 6. Resumen estadístico (útil para optimización)
strace -c ./app
# % time     seconds  usecs/call     calls    errors syscall
# 45.23    0.452345         123      3672           read
# 30.12    0.301234          45      6678           write
# ...

# 7. Buscar errores EACCES (permiso denegado)
strace -e trace=file ./app 2>&1 | grep EACCES

# 8. Buscar archivos de configuración que intenta abrir
strace -e trace=open,openat,stat ./app 2>&1 | grep -E '\.(conf|ini|cfg)$'

# 9. Timestamps + tiempos de syscall
strace -t -T ./app

# 10. Inyectar error (para testing de manejo de errores)
strace -e fault=open:error=EACCES:when=1 ./app
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **"Permission denied" — ¿qué archivo?** | `strace -e trace=file ./app 2>&1 \| grep -i EACCES` |
| **App no encuentra un archivo** | `strace -e trace=open,openat ./app 2>&1 \| grep ENOENT` |
| **¿Qué archivos de config lee?** | `strace -e trace=open ./app 2>&1 \| grep '\\.conf'` |
| **App lenta — ¿dónde pierde tiempo?** | `strace -c ./app` (estadísticas) |
| **¿A qué IP se conecta?** | `strace -e trace=network ./app` |
| **Problema de permisos en web server** | `sudo strace -p $(pgrep nginx \| head -1) -e trace=file -o /tmp/nginx-trace.log` |
| **Script no ejecuta un comando esperado** | `strace -f -e trace=execve ./script.sh` |
| **Depurar error de conexión SSH** | `strace -e trace=network ssh server 2>&1 \| grep connect` |

## Combinaciones comunes con pipe

```bash
# Buscar errores específicos
strace ./app 2>&1 | grep -E '= -1 (EACCES|ENOENT|ECONNREFUSED)'

# Ver qué archivos modifica (solo escritura)
strace -e trace=write ./app 2>&1 | grep 'fd.*O_WRONLY\|O_RDWR'

# Contar cuántas veces abre cada archivo
strace -e trace=openat ./app 2>&1 | grep -oP '"([^"]+)"' | sort | uniq -c | sort -rn

# Ver progreso de lectura/escritura
strace -e trace=read,write ./app 2>&1 | grep -oP '\d+$' | awk '{s+=$1} END {print s}'
```

## Alternativas modernas

| Herramienta | Ventaja |
|---|---|
| **perf trace** | Menor overhead que strace, parte de `perf` | `perf trace ./app` |
| **bpftrace** | Traza con eBPF — mucho menor overhead, scripting avanzado | Requiere Linux 4.x+ |
| **ltrace** | Traza llamadas a librerías (no syscalls) — complementa strace | `ltrace ./app` |
| **strace** | Estándar — 99% de los casos es suficiente | Más simple que bpftrace |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `strace: ptrace(PTRACE_TRACEME): Operation not permitted` | Sin permisos para trazar | Usar `sudo strace` |
| `strace: attach: ptrace(PTRACE_SEIZE, XXX): Operation not permitted` | El proceso pertenece a otro usuario o es setuid | Usar `sudo strace -p PID` |
| `strace: attach: ptrace(PTRACE_SEIZE, XXX): Is a directory` | El PID no existe o ya se trazó a sí mismo | Verificar PID con `ps aux \| grep PID` |
| Salida muy larga | Programas con muchas syscalls | Filtrar con `-e trace=file` o pipear a `less` |
| `strace: arch_prctl: ...` | Syscalls de inicio del programa | Ignorar — son normales al cargar el binario |

## Notas y advertencias

- **strace ralentiza el programa**: cada syscall se intercepta, lo que puede hacer que el programa vaya 10-100× más lento. No usar en producción sin cuidado.
- **Siempre usar `-o archivo`**: la salida de strace va a stderr, que puede mezclarse con la salida del programa. Redirigir a archivo con `-o`.
- **strace no ve syscalls del kernel**: solo ve la interfaz entre userspace y kernel. Para tracing del kernel, usar `perf` o `bpftrace`.
- **Seguir hijos con `-f`**: si el programa crea procesos hijo (servidores web, scripts), strace sin `-f` solo ve al padre.
- **Requiere `ptrace`**: strace usa la llamada al sistema `ptrace`. Docker containers por defecto no tienen esta capacidad (necesitan `--cap-add=SYS_PTRACE`).

## Enlaces externos

- [Wikipedia — strace](https://en.wikipedia.org/wiki/Strace)
- [strace.io](https://strace.io/)
- [Linux man page — strace(1)](https://man.archlinux.org/man/strace.1)
- [Arch Wiki — strace](https://wiki.archlinux.org/title/Strace)

## Ver también

- [[perf]] — profiling de rendimiento (menos overhead)
- [[Error de permisos]] — troubleshooting Permission denied
- [[ltrace]] — traza de librerías (complemento)
- [[gdb]] — depurador de código fuente
- [[Cheat Sheet - Comandos Esenciales]]

#comando #debug
