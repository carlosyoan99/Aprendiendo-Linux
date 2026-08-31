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

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh` + `cargo install atuin` |
| Arch | `sudo pacman -S atuin` |
| Fedora | `sudo dnf install atuin` |
| macOS | `brew install atuin` |

```bash
# Setup inicial (bash)
echo 'eval "$(atuin init bash)"' >> ~/.bashrc

# Setup inicial (zsh)
echo 'eval "$(atuin init zsh)"' >> ~/.zshrc

# Setup inicial (fish)
echo 'atuin init fish | source' >> ~/.config/fish/config.fish

# Setup inicial (nushell)
echo 'atuin init nushell' >> ~/.config/nushell/env.nu
```

## Sincronización

```bash
# Registrarse
atuin register

# Login
atuin login

# Verificar sync
atuin history list | head -5

# Auto-sync cada X minutos (configurar en systemd timer o cron)
# ~/.config/atuin/config.toml
[sync]
iterations = 300  # cada 5 minutos
```

## Configuración avanzada

```bash
# ~/.config/atuin/config.toml
[search]
# Ctrl+r muestra el UI interactivo, ↑ muestra la última coincidencia
filter_mode = "global"     # global | host | session
search_mode = "fuzzy"      # fuzzy | prefix

[stats]
enabled = false  # deshabilitar stats para sync más rápido

[dbus]
enable = true

[keymap]
# Personalizar bindings
```

## Búsqueda avanzada

```bash
# Buscar por directorio
atuin search --cwd /home/user/projects

# Buscar por fecha
atuin search --after "2026-01-01"

# Buscar por duración (>5s)
atuin search --min-duration 5s

# Excluir comandos específicos
atuin search --exclude "cd *" --exclude "ls"

# Historial de sesión actual
atuin search --session
```

## Comparativa con alternativas

| Herramienta | Enfoque |
|---|---|
| **atuin** | Historial encriptado, sync multi-máquina, SQLite |
| **mcfly** | Historial con contexto (directorio, rama git) |
| **fzf** | Búsqueda difusa general, no solo historial |
| **zsh-autosuggestions** | Sugerencias inline, no búsqueda |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `atuin: command not found` | No en PATH | Reinstalar o añadir `~/.cargo/bin` a PATH |
| Ctrl+r no muestra nada | Shell no configurado | Verificar `eval "$(atuin init bash)"` en .bashrc |
| Sync no funciona | Credenciales | `atuin login` + verificar `atuin status` |
| Historial duplicado | Bash/zsh guardan historial doble | Añadir `HISTFILE=` vacío en config del shell |

## Enlaces externos

- [GitHub — atuin](https://github.com/atuinsh/atuin)
- [Sitio oficial](https://atuin.sh/)
- [Arch Wiki — Atuin](https://wiki.archlinux.org/title/Atuin)

## Ver también

- [[Shells (bash zsh fish)]] — configuración de shells
- [[fzf]] — búsqueda difusa general
- [[history]] — comando historial clásico

#programa #tui #terminal
