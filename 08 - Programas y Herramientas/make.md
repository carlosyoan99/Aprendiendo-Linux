---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: alta
---

# Make

## Qué es

**Make** lee un `Makefile` que describe **reglas** (targets, dependencias y comandos) para compilar un proyecto. Solo recompila lo necesario comparando timestamps. Es parte del estándar POSIX desde los años 70 y la base sobre la que se construye prácticamente todo el software del sistema.

## Instalación

```bash
# Prácticamente siempre instalado. Si no:
sudo apt install make                   # Debian/Ubuntu
sudo pacman -S make                     # Arch
sudo dnf install make                   # Fedora
```

## Sintaxis básica de un Makefile

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
| `CFLAGS` | Variable: flags del compilador |
| `app:` | Target: el archivo o acción a generar |
| `main.c utilidades.c:` | Dependencias: si cambian, se re-ejecuta la receta |
| `$(CC) ...` | Receta: comandos a ejecutar (deben ir con TAB, no espacios) |
| `clean:` | Target sin archivo: limpiar archivos generados |
| `.PHONY` | Marca targets que no son archivos reales |

## Uso

```bash
make              # compila el primer target (por defecto: app)
make app          # compila solo el target app
make clean        # ejecuta la receta clean
make -j4          # compilar en paralelo (4 procesos)
```

## Variables automáticas y patrones

```makefile
# $@ → nombre del target
# $< → primera dependencia
# $^ → todas las dependencias

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

app: main.o utilidades.o
	$(CC) $(LDFLAGS) $^ -o $@
```

## Alternativas modernas

| Herramienta clásica | Alternativa moderna | Diferencias |
|---|---|---|
| **make** | **CMake** | Genera Makefiles u otros (Ninja). Más portable |
| **make** | **Meson** | Más rápido, sintaxis Python-like |
| **make** | **Ninja** | Sistema de construcción minimalista, extremadamente rápido |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `make: *** No rule to make target 'clean'` | No existe un destino llamado `clean` en el Makefile | Comprobar el nombre exacto (`grep '^clean:' Makefile`) |
| "Error: missing separator" | Se usó espacio en vez de tab para las reglas | Las recetas DEBEN empezar con **tabulador**, no espacios |
| Recompila todo aunque no cambió nada | `.PHONY` roto o timestamps | Usar `.PHONY: all clean` y revisar `touch` |
| `make` no recoge un cambio en el `.h` | Los `.h` no se listaron como dependencia | Añadir el header en la línea del objetivo |
| "Nothing to be done for 'all'" | El destino ya está actualizado | Forzar: `make -B` (rebuild) |
| `pmake`/`gmake` instrucciones | Distro BSD vs GNU | En Linux usar `gmake` si traen Makefiles BSD |

## Ver también

- [[gcc]] — compilador de C/C++
- [[gdb]] — depurador GNU
- [[strace]] — traza de llamadas al sistema
- [[Compilación desde Código Fuente]] — compilar e instalar programas

## Enlaces externos

- [Wikipedia — Make (software)](https://en.wikipedia.org/wiki/Make_(software))

#programa #desarrollo
