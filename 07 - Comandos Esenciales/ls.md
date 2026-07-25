---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# ls

## Sintaxis
```bash
ls [opciones] [ruta...]
```

## Descripción
Lista el contenido de directorios. Es el comando más usado del sistema. Sin argumentos, lista el directorio actual.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-l` | Formato detallado (permisos, dueño, tamaño, fecha) |
| `-a` | Muestra archivos ocultos (.archivo) |
| `-la` | Combinación de -l y -a (la más usada) |
| `-h` | Tamaños legibles (KB, MB, GB) — siempre con `-l` |
| `-S` | Ordenar por tamaño (mayor primero) |
| `-t` | Ordenar por fecha (más reciente primero) |
| `-r` | Orden inverso |
| `-R` | Listar recursivamente subdirectorios |
| `-1` | Un archivo por línea |
| `-d` | Muestra info del directorio, no su contenido |
| `-lh` | Tamaños legibles (alias común) |

## Ejemplos
```bash
ls                      # lista simple
ls -l                   # detallado
ls -la                  # detallado + ocultos (el más común)
ls -lh                  # detallado + tamaños legibles
ls -lS                  # ordenado por tamaño
ls -lt                  # ordenado por fecha
ls -ltr                 # orden inverso por fecha (más viejos primero)
ls -d */                # solo directorios
ls -R src/              # recursivo
ls -la ~/               # contenido del home
ls /etc/                # archivos de configuración
```

## Casos de uso reales

### Ver el archivo más grande del directorio actual

```bash
ls -lSh | head -5                        # los 5 archivos más grandes
ls -lS --block-size=M                    # mostrar tamaño en MB explícitamente
```

### Ver los archivos modificados más recientemente

```bash
ls -lt | head -10                        # los 10 archivos más recientes
ls -lt | grep "^-.*2026"                 # archivos modificados en cierto año
```

### Ver solo directorios (útil para contar proyectos)

```bash
ls -d */                                 # lista solo directorios
ls -d .*/                                # lista solo directorios ocultos (.git, .config, etc.)
ls -la | grep "^d"                       # filtrar solo directorios con formato detallado
```

### Ver detalles de permisos para depurar accesos

```bash
ls -la archivo                           # permisos, dueño, grupo
# Ejemplo: -rwxr-xr-- 1 carlos devs  1024 Jul 24 14:30 script.sh
#           │││││││││││
#           │││││││││└── otros: lectura
#           ││││││││└── grupo: ejecución
#           │││││││└── grupo: lectura
#           ││││││└── dueño: ejecución
#           │││││└── dueño: escritura
#           ││││└── dueño: lectura
#           │││└── sticky/SUID/SGID
#           ││└── tipo: - archivo, d directorio, l symlink
```

## Combinaciones comunes con pipe

```bash
# Contar archivos (sin contar . y ..)
ls -1 | wc -l

# Contar archivos por tipo (incluyendo ocultos)
ls -la | grep -v ^d | grep -v ^l | wc -l    # solo archivos regulares
ls -la | grep "^d" | wc -l                  # solo directorios

# Buscar el archivo más antiguo
ls -ltr | tail -1                             # el más viejo o último modificado

# Ver tamaños totales por tipo en directorio actual
ls -l | awk '{sum+=$5} END {print sum/1024/1024 " MB"}'  # suma total
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `ls` | `exa` / `eza` | Colores por tipo de archivo, iconos, tree view, permisos legibles |
| `ls -la` | `eza -la --icons` | Mismo formato pero más legible y colorido |
| `ls -R` | `eza -T` | Vista de árbol (tree) sin instalar tree aparte |

```bash
# Instalar eza (fork activo de exa)
sudo apt install eza           # Debian/Ubuntu (en repos recientes)
sudo pacman -S eza             # Arch
# o: cargo install eza

eza -la --icons --git          # como ls -la con iconos y estado git
alias ls='eza'                 # reemplazar ls completamente
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| No se ven archivos que deberían estar | Son archivos ocultos (empiezan con `.`) | Usar `ls -la` en lugar de `ls -l` |
| La terminal muestra `ls --color=auto` pero sin colores | `TERM` no configurado o `dircolors` faltante | Verificar `echo $TERM`, debe ser xterm-256color o similar |
| `ls: cannot access 'dir': Permission denied` | No tienes permiso de lectura en el directorio | Usar `sudo ls -la /ruta` o cambiar permisos |
| `Argument list too long` al hacer `ls *` | Demasiados archivos en el directorio | Usar `ls | head` o `find . -maxdepth 1` |

## Notas
- `ls` no muestra archivos ocultos (los que empiezan con `.`) a menos que uses `-a`.
- `ls -l` muestra: tipo+permisos, enlaces, dueño, grupo, tamaño, fecha, nombre.
- Los colores de `ls` se configuran con `--color=auto` (activado por defecto en la mayoría de distros).

## Enlaces externos

- [Wikipedia — ls](https://en.wikipedia.org/wiki/Ls)
- [GNU Coreutils — ls manual](https://www.gnu.org/software/coreutils/manual/html_node/ls-invocation.html)

## Ver también
- [[cd]] — navegar entre directorios
- [[find]] — buscar archivos
- [[Cheat Sheet - Comandos Esenciales]]
- [[Permisos y Propietarios]]

#comando