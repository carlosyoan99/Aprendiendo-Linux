---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-30
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

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install btop` |
| Arch | `sudo pacman -S btop` |
| Fedora | `sudo dnf install btop` |
| Alpine | `sudo apk add btop` |
| openSUSE | `sudo zypper install btop` |

## Configuración

```bash
# ~/.config/btop/btop.conf (temas y opciones)
color_theme = dracula
true_color = 2
gpu_mode = graph
net_mode = combined
update_interval = 2000
proc_sorting = cpu lazy
proc_tree = true
```

```bash
# Cambiar tema desde la interfaz
# Presionar 'T' → seleccionar tema
# Temas populares: dracula, nord, monokai, solarized
```

## Comparativa con monitores similares

| Herramienta | Ventaja | Desventaja |
|---|---|---|
| **btop** | GPU, más métricas, temas | Más pesado |
| **htop** | Ligero, universal, flags | Sin GPU, sin disco/red |
| **atop** | Histórico, almacenamiento | Curva aprendizaje |
| **glances** | Web UI, API, plugins | Python, más lento |
| **nvtop** | GPU dedicado | Solo GPU, no general |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `btop: command not found` | No instalado | `sudo apt install btop` |
| Colores incorrectos en SSH | Terminal sin true color | `export TERM=xterm-256color` |
| No muestra GPU | GPU drivers no instalados | Verificar `lspci | grep VGA` + drivers |
| Uso de CPU al 100% | Intervalo demasiado bajo | `btop --tty_on` o incrementar intervalo |
| No muestra procesos root | Sin permisos | `sudo btop` |

## Enlaces externos

- [GitHub — btop](https://github.com/aristocratos/btop)
- [Arch Wiki — btop](https://wiki.archlinux.org/title/Btop)

#programa #tui #monitor
