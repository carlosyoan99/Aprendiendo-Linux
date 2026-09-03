---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# starship

> Prompt de shell cross-platform, rápido y personalizable. Escrito en Rust, muestra información del contexto (git, lenguaje, entorno) de forma concisa y configurable.

## Qué es

**starship** es un prompt minimalista que se adapta al contexto: muestra el estado de Git, la versión de Node/Python/Rust, el entorno virtual activo, el runtime de AWS/GCP/Kubernetes, y más — todo en una sola línea con emojis/colores.

**Ventajas clave:**
- Cross-shell (bash, zsh, fish, ion, nushell, elvish)
- Información contextual automática (git, lenguajes, cloud)
- Rápido (~1ms por prompt, escrito en Rust)
- Configuración en TOML limpia
- Cross-platform (Linux, macOS, Windows)
- Modo transductivo (oculta info irrelevante)

## Instalación

```bash
# Debian/Ubuntu
sudo apt install starship        # Ubuntu 24.04+
sudo snap install starship

# Arch / CachyOS
sudo pacman -S starship

# Fedora
sudo dnf install starship

# Script oficial
curl -sS https://starship.rs/install.sh | sh
```

## Activar en la shell

```bash
# Bash (~/.bashrc)
eval "$(starship init bash)"

# Zsh (~/.zshrc)
eval "$(starship init zsh)"

# Fish (~/.config/fish/config.fish)
starship init fish | source

# Nushell
starship init nu | save --force ~/.config/nushell/env.nu
```

## Configuración

Archivo: `~/.config/starship.toml`

```toml
# Símbolo del prompt
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

# Directorio
[directory]
truncation_length = 3
truncation_symbol = "…/"
style = "bold cyan"

# Git
[git_branch]
symbol = " "
style = "bold purple"

[git_status]
style = "bold red"

# Node.js
[nodejs]
symbol = " "
style = "bold green"

# Python
[python]
symbol = " "
style = "bold yellow"

# Rust
[rust]
symbol = "🦀 "
style = "bold orange"

# Docker
[docker_context]
symbol = " "
style = "bold blue"

# Kubernetes
[kubernetes]
symbol = "☸️ "
style = "bold blue"

# Tiempo (opcional)
[time]
disabled = false
format = "🕐 $time($style) "
style = "bold dimmed white"
```

## Módulos disponibles

| Módulo | Muestra |
|---|---|
| `git_branch` | Rama actual |
| `git_status` | Estado (staged, modified, untracked) |
| `nodejs` | Versión de Node.js |
| `python` | Versión de Python + virtualenv |
| `rust` | Versión de Rust/Cargo |
| `go` | Versión de Go |
| `docker_context` | Docker context activo |
| `kubernetes` | Namespace/K8s context |
| `aws` | AWS profile/region |
| `gcloud` | Google Cloud project |
| `cmd_duration` | Duración del último comando |
| `directory` | Directorio actual |
| `hostname` | Nombre del host |
| `username` | Usuario |
| `battery` | Nivel de batería |
| `line_break` | Salto de línea |

## Comparativa con alternativas

| Aspecto | starship | oh-my-posh | powerlevel10k | pure |
|---|---|---|---|---|
| **Lenguaje** | Rust | Go | Zsh | Zsh |
| **Cross-shell** | ✅ | ✅ | ❌ (solo zsh) | ❌ (solo zsh) |
| **Velocidad** | ⚡ <1ms | ⚡ <5ms | ⚡ <5ms | ⚡ <3ms |
| **Config** | TOML | JSON/JSONC | Zsh | Zsh |
| **Multi-shell** | ✅ 9 shells | ✅ | ❌ | ❌ |
| **Cross-platform** | ✅ | ✅ | ❌ | ❌ |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Prompt no cambia | Starship no inicializado | Añadir `eval "$(starship init bash)"` a `.bashrc`/config de shell |
| Íconos cuadrados | Falta Nerd Font | Instalar/asignar Nerd Font en la terminal |
| Rama Git no se muestra | Repo sin git actualizado | Verificar en repo git y módulo `git_branch` activo |
| Prompt lento | Ejecución de módulos | Desactivar en `toml` módulos costosos o cadencia mayor |
| Config desde git a nivel | Repo de config | Revisar perfil y entorno/shell global |

## Ver también

- `oh-my-zsh` — framework de plugins para Zsh
- `powerlevel10k` — prompt rápido para Zsh
- [[Fish]] — shell con prompt integrado
- [[Shells (bash zsh fish)]] — shells disponibles

## Enlaces externos

- [Sitio oficial](https://starship.rs/)
- [GitHub — starship](https://github.com/starship/starship)
- [Galería de configuraciones](https://starship.rs/presets/)
- [Arch Wiki — Starship](https://wiki.archlinux.org/title/Starship)

#programa #terminal #prompt
