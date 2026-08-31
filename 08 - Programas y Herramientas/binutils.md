---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: baja
---

# GNU binutils

Conjunto de herramientas para trabajar con archivos binarios, object files y ejecutables. Viene preinstalado en prácticamente cualquier distro Linux.

## Qué es

**GNU binutils** es un conjunto de utilidades de bajo nivel para manipular archivos binarios: ejecutables ELF, object files, librerías estáticas, y más. Son herramientas esenciales para desarrolladores, investigadores de seguridad y administradores de sistemas que necesitan inspeccionar o modificar binarios.

**Componentes clave:** `ld` (linker), `as` (ensamblador), `objdump`, `readelf`, `nm`, `strip`, `strings`, `addr2line`.

## Componentes principales

| Comando | Función |
|---|---|
| `strings` | Extraer cadenas de texto de binarios |
| `objdump` | Desensamblar y mostrar info de object files |
| `nm` | Listar símbolos de un object file |
| `strip` | Eliminar símbolos (reduce tamaño de binarios) |
| `readelf` | Mostrar información detallada de ELF |
| `size` | Tamaño de secciones de un binario |
| `addr2line` | Convertir dirección a línea de código fuente |
| `ar` | Crear/modificar archivadores (.a estáticos) |
| `objcopy` | Copiar y transformar object files |
| `ld` | El enlazador (linker)GNU |
| `as` | El ensamblador GNU |

## Instalación

```bash
# Debian/Ubuntu
sudo apt install binutils

# Arch / CachyOS
sudo pacman -S binutils      # viene preinstalado

# Fedora
sudo dnf install binutils
```

> En la mayoría de distros, binutils ya viene instalado por defecto como parte del toolchain de desarrollo.

## Ejemplos

```bash
# Extraer texto legible de un binario
strings /usr/bin/ls | head -20

# Buscar cadenas sospechosas en un binario (seguridad)
strings malware.bin | grep -i "http\|passw\|key"

# Ver símbolos de un programa
nm /usr/bin/cat | head -10

# Clasificar símbolos por tipo
nm --numeric-sort /usr/bin/bash

# Información ELF detallada
readelf -h /usr/bin/bash       # cabecera ELF
readelf -S /usr/bin/bash       # secciones
readelf -l /usr/bin/bash       # segments (program headers)
readelf -s /usr/bin/bash       # tabla de símbolos

# Reducir tamaño de un binario (stripped)
strip --strip-all binario      # elimina todos los símbolos
ls -lh binario vs binario-stripped

# Ver tamaño de secciones
size /usr/bin/bash

# Convertir dirección a línea de fuente (con debug info)
addr2line -e /usr/bin/bash 0x12345

# Desensamblar un segmento
objdump -d /usr/bin/ls | head -30

# Ver headers de un object file
objdump -h program.o

# Copiar binario y convertir a formato differente
objcopy -O binary program.elf program.bin
```

## Casos de uso

### Investigación de seguridad

```bash
# Buscar URLs o IPs hardcoded en un binario
strings -n 8 binario | grep -E "https?://|[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"

# Detectar si un binario tiene SUID
readelf -l binario | grep "GNU_STACK"

# Ver dependencias dinámicas
readelf -d binario | grep NEEDED
```

### Desarrollo

```bash
# Ver si un binario tiene info de debug
file program && readelf -S program | grep debug

# Comparar símbolos entre dos versiones
diff <(nm old_version) <(nm new_version)

# Verificar que un binario está stripped
file program | grep "not stripped"
```

### Administración de sistemas

```bash
# Encontrar binarios con libs huérfanas
ldd /usr/bin/python3 | grep "not found"

# Verificar integridad de binarios del sistema
sha256sum /usr/bin/ls
```

## Comparativa con alternativas

| Herramienta | Función | binutils equivalente |
|---|---|---|
| `file` | Tipo de archivo | No tiene equivalente directo |
| `ltrace` | Llamadas a librerías | No |
| `strace` | System calls | No |
| `xxd` / `hexdump` | Hex dump | `objdump -s` |
| `nm` (llvm) | Símbolos | `nm` |
| `readelf` (llvm) | Info ELF | `readelf` |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `nm: no symbols` | Binario stripped | Usar `nm --dynamic` o buscar debug info |
| `addr2line: ?` | Sin info de debug | Compilar con `-g`: `gcc -g program.c` |
| `readelf` no reconoce formato | Binario corrupto o formato raro | Verificar con `file` primero |
| `strip` rompe binario | stripping símbolos necesarios | Usar `strip --strip-unwanted` en vez de `--strip-all` |

## Ver también

- [[Coreutils y util-linux]] — comandos base del sistema
- [[Utilidades Base del Sistema]] — índice de paquetes base
- [[procps-ng]] — utilidades de procesos
- [[Desarrollo en Linux (gcc make gdb strace)]] — toolchain de desarrollo
- [[strace]] — trazador de system calls

## Enlaces externos

- [Wikipedia — GNU Binutils](https://en.wikipedia.org/wiki/GNU_Binutils)
- [Sitio oficial — GNU Binutils](https://www.gnu.org/software/binutils/)
- [Arch Wiki — GNU binutils](https://wiki.archlinux.org/title/Binutils)
- [Man page — strings](https://man7.org/linux/man-pages/man1/strings.1.html)
- [Man page — readelf](https://man7.org/linux/man-pages/man1/readelf.1.html)

#programa #sistema #desarrollo
