---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# atuin

> Shell history sincronizado entre máquinas con búsqueda difusa y encriptación. Reemplaza el historial de bash/zsh/fish con una base de datos SQLite.

## Sintaxis

```bash
atuin [comando]
```

## Opciones

| Opción | Descripción |
|---|---|
| `history` | Ver historial |
| `search` | Buscar en historial |
| `import` | Importar historial existente |
| `export` | Exportar historial |
| `login` | Iniciar sesión (sync) |
| `register` | Registrar cuenta |

## Ejemplos

```bash
atuin history list                  # ver historial
atuin search "docker"               # buscar por comando
atuin search --cwd /home/user       # buscar por directorio
atuin import bash                   # importar historial de bash
```

## Atajos (en shell)

| Tecla | Acción |
|---|---|
| `Ctrl+r` | Búsqueda difusa de historial |
| `↑` | Buscar historial que empiece con lo escrito |

## Configuración

```bash
# ~/.config/atuin/config.toml
[dbus]
enable = true

[stats]
enabled = false
```

## Ver también

- [[Shells (bash zsh fish)]], [[fzf]], [[history]]

#programa #tui #terminal
