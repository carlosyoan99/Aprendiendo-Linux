---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# GNU binutils

Conjunto de herramientas para trabajar con archivos binarios, object files y ejecutables. Viene preinstalado en prácticamente cualquier distro Linux.

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

## Ejemplos

```bash
# Extraer texto legible de un binario
strings /usr/bin/ls | head -20

# Ver símbolos de un programa
nm /usr/bin/cat | head -10

# Información ELF detallada
readelf -h /usr/bin/bash

# Reducir tamaño de un binario (stripped)
strip --strip-all binario
```

## Ver también

- [[Coreutils y util-linux]] — comandos base del sistema
- [[Utilidades Base del Sistema]] — índice de paquetes base
- [[procps-ng]] — utilidades de procesos

## Enlaces externos

- [Wikipedia — GNU Binutils](https://en.wikipedia.org/wiki/GNU_Binutils)
- [Sitio oficial — GNU Binutils](https://www.gnu.org/software/binutils/)

#programa #sistema
