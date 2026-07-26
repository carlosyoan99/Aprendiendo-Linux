---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: media
---

# history

## Sintaxis

```bash
history [opciones]
!n           # ejecutar comando número n
!!           # ejecutar el último comando
!texto       # ejecutar el último comando que empiece con "texto"
!?texto      # ejecutar el último que contenga "texto"
```

## Descripción

Muestra el historial de comandos ejecutados en la shell actual. Permite re-ejecutar, buscar y modificar comandos anteriores sin volver a escribirlos.

## Opciones

| Flag | Efecto |
|---|---|
| `-c` | Limpiar historial |
| `-d offset` | Eliminar línea específica |
| `-a` | Añadir sesión actual al archivo |
| `-w` | Escribir historial al archivo |
| `-r` | Leer archivo y añadirlo al actual |

## Ejemplos

```bash
history                      # lista numerada de comandos
history 20                   # últimos 20 comandos
!!                           # repetir el último comando
!100                         # ejecutar comando #100
!ssh                         # último comando que empiece con ssh
^pacman^yay                  # reemplazar en el último comando
```

## Control del historial

```bash
export HISTSIZE=10000         # comandos en memoria
export HISTFILESIZE=100000    # líneas en el archivo
export HISTCONTROL=ignoredups  # ignorar duplicados
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
```

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `↑` / `↓` | Navegar por el historial |
| `Ctrl+r` | Búsqueda inversa |
| `Alt+.` | Último argumento del comando anterior |

## Ver también

- [[touch]] — crear archivos y modificar timestamps
- [[Variables de Entorno y PATH]] — HISTFILE, HISTSIZE, HISTCONTROL
- [[XDG Base Directory y dotfiles modernos]] — mover .bash_history a ~/.local/share
- [[La Shell]] — cómo funciona el historial en diferentes shells
- [[Shells (bash zsh fish)]] — diferencias en el manejo del historial

## Enlaces externos

- [Wikipedia — history (command)](https://en.wikipedia.org/wiki/History_(command))

#comando
