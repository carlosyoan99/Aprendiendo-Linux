---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: automatizacion
prioridad: media
---

# Automatización con Scripts

## Definición

Un script es un archivo de texto con una secuencia de comandos que se ejecutan en orden. Permite automatizar tareas repetitivas: backups, instalación de programas, limpieza del sistema, etc.

## La base: el shebang

Todo script de shell empieza con **shebang** (`#!`) que indica al sistema qué intérprete usar:

```bash
#!/bin/bash           # script de bash
#!/bin/sh             # script POSIX (máxima portabilidad)
#!/usr/bin/env python3 # script de Python
```

```bash
# Para que un script sea ejecutable:
chmod +x mi-script.sh
./mi-script.sh
```

## Variables

```bash
#!/bin/bash
NOMBRE="Carlos"                    # variable (sin espacios alrededor de =)
echo "Hola, $NOMBRE"               # usar variable con $
FECHA=$(date +%Y-%m-%d)            # capturar salida de un comando
echo "Hoy es $FECHA"
NUM=42
echo $((NUM + 8))                  # aritmética: 50
```

## Condicionales

```bash
#!/bin/bash
ARCHIVO="/etc/passwd"

if [ -f "$ARCHIVO" ]; then         # existe y es archivo regular?
    echo "$ARCHIVO existe"
elif [ -d "$ARCHIVO" ]; then       # existe y es directorio?
    echo "$ARCHIVO es un directorio"
else
    echo "No existe"
fi

# Operadores comunes: -f (archivo), -d (directorio), -e (existe), -z (string vacío)
# Comparación numérica: -eq, -ne, -lt, -gt, -le, -ge
# Strings: =, !=, -z, -n
```

## Bucles

```bash
#!/bin/bash

# For: iterar sobre lista
for archivo in *.txt; do
    echo "Procesando: $archivo"
done

# While: mientras se cumpla condición
CONTADOR=0
while [ $CONTADOR -lt 5 ]; do
    echo "Vuelta $CONTADOR"
    ((CONTADOR++))
done

# For tipo C
for ((i=0; i<5; i++)); do
    echo "i = $i"
done
```

## Funciones

```bash
#!/bin/bash

saludar() {
    local nombre=$1                # $1 = primer argumento
    echo "Hola, $nombre!"
}

saludar "Mundo"                    # → "Hola, Mundo!"

sumar() {
    echo $(($1 + $2))
}

resultado=$(sumar 3 4)
echo "3 + 4 = $resultado"
```

## Argumentos de línea

```bash
#!/bin/bash
echo "Script: $0"                  # nombre del script
echo "Args: $#"                    # cantidad de argumentos
echo "Primer arg: $1"              # primer argumento
echo "Todos los args: $@"          # todos los argumentos

# while + shift para procesar argumentos uno por uno
while [ $# -gt 0 ]; do
    echo "Argumento: $1"
    shift
done
```

## Buenas prácticas

```bash
#!/bin/bash
set -e                              # salir si un comando falla (exit code ≠ 0)
set -u                              # salir si se usa variable no definida
set -o pipefail                     # salir si un pipe falla

# Alternativa: set -euo pipefail (los tres a la vez)

# Verificar que se ejecuta como root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script requiere sudo" >&2
    exit 1
fi

# Crear directorio temporal que se borra al salir
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT          # cleanup automático
```

## Ejemplo completo: backup de dotfiles

```bash
#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_FILE="$HOME/backup-dotfiles-$(date +%Y%m%d).tar.gz"

echo "📦 Respaldando dotfiles en $BACKUP_FILE ..."

# Crear el backup con tar, excluyendo .cache y node_modules
tar -czf "$BACKUP_FILE" \
    --exclude=".cache" \
    --exclude="node_modules" \
    "$DOTFILES_DIR"

echo "✅ Backup creado: $BACKUP_FILE"
echo "   Tamaño: $(du -h "$BACKUP_FILE" | cut -f1)"
```

## Programar con cron

```bash
# Editar tareas del usuario actual
crontab -e

# Ejecutar backup.sh todos los días a las 3 AM
0 3 * * * /home/usuario/scripts/backup.sh

# Loggear la salida
0 3 * * * /home/usuario/scripts/backup.sh >> /home/usuario/logs/backup.log 2>&1
```

Ver [[Cron]] · [[systemd timers]] para más detalle.

## Por qué importa

- Un script de 5 líneas puede ahorrarte 30 minutos de trabajo manual cada semana.
- La automatización es el siguiente paso natural después de sentirte cómodo con la terminal.
- Si repites la misma secuencia de comandos más de 2 veces, probablemente deberías tener un script.

## Mis propios scripts

Todos en `scripts/`. Ejecutables con `chmod +x`.

### daily-log.sh

**Propósito**: crea una nota de log diaria usando `Templates/Plantilla - Log Diario.md`.

```bash
./scripts/daily-log.sh                        # log vacío para hoy
./scripts/daily-log.sh "Texto para hoy"       # con texto en "Qué exploré"
./scripts/daily-log.sh -e "error X" -c "curl" # flags específicos
./scripts/daily-log.sh --help                 # ayuda completa
```

Crea el archivo `10 - Automatizacion y Scripts/Log - YYYY-MM-DD.md`.

### vault-stats.sh

**Propósito**: muestra estadísticas del vault: total de notas, desglose por estado/categoría/prioridad/carpeta, últimas modificaciones.

```bash
./scripts/vault-stats.sh              # estadísticas completas
./scripts/vault-stats.sh --resumen    # solo resumen breve
./scripts/vault-stats.sh --csv        # salida CSV pipeable
```

### check-frontmatter.sh

**Propósito**: verifica que todas las notas tengan frontmatter válido (`fecha_creacion`, `estado`, `categoria`) y hashtag al final.

```bash
./scripts/check-frontmatter.sh                    # revisión completa
./scripts/check-frontmatter.sh --solo-errores     # solo notas con problemas
./scripts/check-frontmatter.sh --fix              # repara errores simples (agrega hashtag)
./scripts/check-frontmatter.sh "07 - Comandos"    # escanea solo una carpeta
```

### find-orphans.sh

**Propósito**: encuentra notas que no están enlazadas desde el MoC ni desde otras notas.

```bash
./scripts/find-orphans.sh                       # lista notas huérfanas
./scripts/find-orphans.sh --moc-only            # solo contra el MoC
./scripts/find-orphans.sh --sugerencias         # sugiere dónde enlazar
./scripts/find-orphans.sh --backlinks           # también busca backlinks entre notas
```

## Enlaces externos

- [GNU Bash Manual](https://www.gnu.org/software/bash/manual/bash.html)
- [Wikipedia — Bash (Unix shell)](https://en.wikipedia.org/wiki/Bash_(Unix_shell))
- [Arch Wiki — Bash](https://wiki.archlinux.org/title/Bash)
- [ShellCheck — analizador estático de scripts shell](https://www.shellcheck.net/)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Repositorio de scripts del vault (GitHub)](https://github.com/) — *enlazar cuando exista repo público*

## Ver también

- [[Cron]] — tareas programadas clásicas
- [[systemd timers]] — alternativa moderna con journald
- [[La Shell]]
- [[Shells (bash zsh fish)]]
- [[Cheat Sheet - Comandos Esenciales]]

#automatizacion #scripts
