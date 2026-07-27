---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: baja
---

# procs

> `ps` moderno con colores, árbol de procesos, búsqueda interactiva y filtros intuitivos. Alternativa moderna al clásico `ps aux`.

## Descripción

**procs** es un reemplazo de `ps` escrito en Rust. Muestra los procesos del sistema con información coloreada, vista de árbol, filtros por nombre, y una interfaz más legible que el clásico `ps`.

## Instalación

```bash
# Snap (recomendado para Linux)
sudo snap install procs

# Desde GitHub (binario estático)
# https://github.com/dalance/procs/releases

# Con cargo (Rust)
cargo install procs
```

## Uso básico

```bash
procs                               # lista todos los procesos (como ps aux)
procs ssh                           # filtrar por nombre (ssh, sshd, etc.)
procs --tree                        # vista de árbol (procesos hijos anidados)
procs -a                            # todos los procesos (incluyendo los sin terminal)
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `procs` | Listar todos los procesos |
| `procs ssh` | Filtrar procesos que contengan "ssh" |
| `procs --tree` | Vista de árbol |
| `procs -a` | Todos los procesos (incluyendo sin TTY) |
| `procs --sortd cpu` | Ordenar por CPU descendente |
| `procs --sortd mem` | Ordenar por memoria descendente |
| `procs --watch` | Modo monitor (como top/htop) |
| `procs --theme dracula` | Tema de color |
| `procs -W` | Columnas anchas |
| `procs --only <PID>` | Mostrar solo un PID específico |
| `procs --and` | AND lógico entre filtros |
| `procs --or` | OR lógico entre filtros |

## Temas de color

```bash
# Listar temas disponibles
procs --list-themes

# Temas incluidos:
#   default, dracula, github, gruvbox, monokai
#   nord, solarized, srcery, two

# Usar un tema específico
procs --theme nord
```

## Ejemplos

```bash
# Procesos del usuario actual
procs $USER

# Buscar procesos que consumen más CPU
procs --sortd cpu | head -10

# Buscar procesos que consumen más memoria
procs --sortd mem | head -10

# Vista de árbol de un proceso específico
procs --tree nginx

# Modo monitor en vivo
procs --watch

# Filtrar varios términos (AND)
procs --and ssh root

# Mostrar columnas específicas
procs --only 1234

# Matar un proceso desde procs (si tiene el permiso)
# procs --kill <PID>
```

## Comparativa

| Aspecto | procs | ps | htop |
|---|---|---|---|
| **Colores** | ✅ 10+ temas | ❌ Monocromo | ✅ Temas |
| **Árbol** | ✅ `--tree` | ✅ `f` option | ✅ F5 |
| **Filtro por nombre** | ✅ `procs ssh` | ❌ `ps aux \| grep ssh` | ✅ F4 |
| **Modo watch** | ✅ `--watch` | ❌ | ✅ Nativo |
| **Binario único** | ✅ | ✅ (coreutils) | ✅ |
| **Ideal para** | Consultas rápidas | Scripts | Monitoreo continuo |

> procs es excelente para consultas rápidas con colores y árbol. Para monitoreo continuo, [[htop btop]] es mejor. Para scripts, `ps` estándar es más compatible.

## Ver también

- [[ps]] — el clásico, preinstalado en todo sistema
- [[top]] — monitor de procesos interactivo
- [[htop btop]] — monitores de sistema modernos
- [[kill]] — matar procesos
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — dalance/procs](https://github.com/dalance/procs)
- [Crates.io — procs](https://crates.io/crates/procs)

#comando #procesos
