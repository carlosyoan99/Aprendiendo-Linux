---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
---

# btop

> Monitor de sistema todo-en-uno: CPU, RAM, disco, red, GPU, procesos. Sucesor de bpytop, escrito en C++ con interfaz TUI.

## Sintaxis

```bash
btop [opciones]
```

## Opciones

| Opción | Descripción |
|---|---|
| `-d` / `--tty_on` | Forzar modo TTY |
| `-p` / `--tty_off` | Forzar modo no-TTY |
| `--utf-force` | Forzar UTF-8 |
| `-t` / `--tree` | Vista de árbol de procesos |

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `1/2/3/4` | Cambiar vista (procesos/mem/disk/net/cpu) |
| `m` | Cambiar modo de memoria |
| `t` | Toggle tree view |
| `e` | Expandir/contraer |
| `f` | Filtro de procesos |
| `Esc` | Salir |

## Ejemplos

```bash
btop                                  # monitor completo
btop -t                               # vista de árbol
```

## Ver también

- [[htop btop]], [[glances]], [[nvtop]], [[free]]

## Enlaces externos

- [GitHub — btop](https://github.com/aristocratos/btop)
- [Arch Wiki — btop](https://wiki.archlinux.org/title/Btop)

#programa #tui #monitor
