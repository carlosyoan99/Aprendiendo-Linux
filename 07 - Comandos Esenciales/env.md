---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# env

> Ejecuta un comando con un entorno modificado o muestra las variables de entorno actuales. Esencial para depurar variables, limpiar el entorno, o ejecutar con configuraciones temporales.

## Sintaxis

```bash
env                          # mostrar todas las variables de entorno
env VAR=valor comando        # ejecutar comando con variable extra
env -i comando               # ejecutar con entorno vacío
env -u VAR comando           # eliminar variable antes de ejecutar
```

## Descripción

`env` (environment) tiene dos usos principales:

1. **Sin argumentos**: lista todas las variables de entorno activas (equivalente a `printenv`)
2. **Con comando**: ejecuta un programa con un entorno modificado, sin contaminar la shell actual

Es útil para:
- Depurar por qué un programa no ve ciertas variables
- Ejecutar un comando con `LANG=C` para salida en inglés (parseable)
- Probar scripts con un entorno limpio (`env -i`)

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-i` / `--ignore-environment` | Entorno completamente vacío | `env -i bash` |
| `-u` / `--unset=VAR` | Eliminar una variable antes de ejecutar | `env -u DISPLAY ./app` |
| `-0` / `--null` | Separar salida con null (para xargs -0) | `env -0 \| xargs -0 ...` |
| `--help` | Muestra ayuda | `env --help` |

## Formato de salida

```bash
$ env | head -5
SHELL=/bin/bash
HOME=/home/carlos
USER=carlos
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
LANG=es_AR.UTF-8
```

Cada línea: `NOMBRE=valor`, uno por variable.

## Ejemplos

```bash
# 1. Mostrar entorno actual
env

# 2. Ejecutar comando con variable extra (temporal, no afecta la shell)
env DB_HOST=localhost ./script.sh
env DEBUG=1 npm run dev

# 3. Forzar locale a inglés (útil para parsear salida)
env LANG=C date
# Fri Jul 24 12:00:00 UTC 2026  (en vez de español)

# 4. Eliminar variable del entorno
env -u DISPLAY xeyes    # xeyes no podrá abrir ventana X11 (para test)

# 5. Entorno limpio (solo hereda lo mínimo)
env -i HOME="$HOME" PATH="$PATH" bash
# bash arranca sin las variables de usuario

# 6. Entorno completamente vacío
env -i bash --norc
# sin PATH, sin HOME, sin nada

# 7. Buscar una variable específica
env | grep -i path

# 8. Contar variables de entorno
env | wc -l
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Ejecutar app con locale inglés** para parsear output | `env LANG=C some_command` |
| **Depurar variable faltante** — ¿qué ve realmente el script? | `env -i ./script.sh` (entorno vacío → falla si necesita `PATH`) |
| **Probar script en entorno aislado** | `env -i HOME=/tmp PATH=/usr/bin ./test.sh` |
| **Ejecutar con variable temporal** sin modificar la shell | `env EDITOR=vim crontab -e` |
| **Sanitizar entorno** antes de ejecutar binarios peligrosos | `env -u LD_PRELOAD ./comando` |

## Combinaciones comunes con pipe

```bash
# Filtrar variables por nombre
env | grep -E ^PATH

# Contar variables
env | wc -l

# Ver variables en orden alfabético
env | sort

# Exportar entorno a archivo (para depuración)
env > /tmp/entorno.log

# Ejecutar con varias variables
env LANG=C LC_ALL=C TZ=UTC date
```

## Alternativas

| Herramienta | Función |
|---|---|
| `printenv` | Similar a `env` pero permite consultar variables específicas: `printenv PATH` |
| `declare -p` (bash) | Muestra variables de shell (incluyendo no exportadas) con metadatos |
| `set` | Muestra TODAS las variables (entorno + shell + funciones) |
| `compgen -v` (bash) | Lista solo nombres de variables (útil para scripting) |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `env: 'comando': No such file or directory` | El comando no existe en el PATH actual | Verificar PATH o usar ruta absoluta |
| `env -i` no encuentra nada | Entorno vacío no tiene PATH | Especificar PATH explícitamente: `env -i PATH=/usr/bin comando` |
| `env VAR=valor` no persiste al salir | env ejecuta en un subproceso | La variable SOLO existe durante la ejecución del comando — es el comportamiento deseado |
| `env` no muestra una variable que esperas | La variable no está exportada | Usar `export VAR=valor` antes, o `declare -p VAR` para ver su estado |

## Notas y advertencias

- **`env` no modifica la shell actual**: cuando haces `env VAR=val cmd`, la variable solo existe para `cmd`. Tu shell no se contamina.
- **`env -i` es drástico**: elimina TODO el entorno, incluyendo `PATH`, `HOME`, `USER`. Puede que muchos comandos no funcionen.
- **`env -u` es mejor que `unset`**: `unset VAR` elimina la variable de la shell actual; `env -u VAR cmd` solo la elimina para ese comando.
- **Variables con espacios**: `env MI_VAR="hola mundo" bash -c 'echo "$MI_VAR"'`.
- **Usar en shebang**: `#!/usr/bin/env bash` es más portable que `#!/bin/bash` (encuentra bash en cualquier PATH).

## Enlaces externos

- [Wikipedia — env](https://en.wikipedia.org/wiki/Env_(shell))
- [GNU Coreutils — env manual](https://www.gnu.org/software/coreutils/manual/html_node/env-invocation.html)
- [Linux man page — env(1)](https://man.archlinux.org/man/env.1)

## Ver también

- [[export]] — declarar variables para que hereden los procesos hijo
- [[source]] — ejecutar script en la shell actual (no en subproceso)
- [[Variables de Entorno y PATH]] — guía completa de variables
- [[Shells (bash zsh fish)]] — variables de inicio de cada shell
- [[Cheat Sheet - Comandos Esenciales]]

#comando #coreutils
