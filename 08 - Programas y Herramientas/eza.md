---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# eza

> Reemplazo moderno de `ls` escrito en Rust. Colores, iconos, vista de árbol, Git status y/class y fechas legibles. Sucesor de `exa` (proyecto original discontinuado).

## Qué es

**eza** es un `ls` moderno que añade colores por tipo de archivo, iconos (nerd font), vista de árbol, header de columnas, yGit status integrado. Es el sucesor activo de `exa` (que dejó de mantenerse).

**Ventajas sobre `ls`:**
- Colores automáticos por tipo (ejecutable, enlace, imagen, vídeo, código...)
- Iconos con nerd fonts (📁 📄 🎵 🔧)
- Vista de árbol (`--tree`)
- Header de columnas con nombres
- Git status por archivo (modificado, nuevo, ignorado)
- Fechas legibles (`--date relative`)

## Instalación

```bash
# Debian/Ubuntu (desde repos recientes o snap)
sudo apt install eza        # Ubuntu 24.04+
sudo snap install eza

# Arch / CachyOS
sudo pacman -S eza

# Fedora
sudo dnf install eza

# Cargo (desde fuente)
cargo install eza
```

## Uso

```bash
eza                          # ls mejorado con colores
eza -la                      # detalle + ocultos
eza --tree                   # vista de árbol
eza --tree --level=2         # árbol con profundidad limitada
eza --icons                  # con iconos (requiere nerd font)
eza --git                    # con estado de Git
eza --header                 # header de columnas
eza --sort=size              # ordenar por tamaño
eza --group-directories-first  # directorios primero
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `-l` | Vista detallada (permisos, tamaño, fecha) |
| `-a` / `-A` | Mostrar ocultos (incluye `.` y `..` / solo `.`) |
| `-h` | Tamaño legible (KB, MB, GB) |
| `--tree` | Vista de árbol |
| `--level=N` | Profundidad del árbol |
| `--icons` | Mostrar iconos (nerd font) |
| `--git` | Estado de Git por archivo |
| `--header` | Header de columnas |
| `--sort=<campo>` | Ordenar por: name, size, date, type |
| `--group-directories-first` | Directorios antes que archivos |
| `--only-dirs` | Solo directorios |
| `--only-files` | Solo archivos |
| `--colour=auto` | Colores (always/never/auto) |
| `--date=relative` | Fechas relativas ("hace 2 horas") |
| `--no-permissions` | Ocultar permisos |
| `--no-user` | Ocultar propietario |
| `--no-time` | Ocultar hora |

## Aliases recomendados

```bash
# En .bashrc / .zshrc / .fish
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --header --git'
alias lt='eza --tree --level=2 --icons'
alias la='eza -a --icons --group-directories-first'
```

## Comparativa con alternativas

| Aspecto | eza | ls | exa | ls --color | lsd |
|---|---|---|---|---|---|
| **Colores** | ✅ Por tipo/permiso/git | ⚠️ `--color` | ✅ Igual que eza | ⚠️ Básico | ✅ Con iconos |
| **Iconos** | ✅ Nerd Font | ❌ | ❌ | ❌ | ✅ Nerd Font |
| **Git status** | ✅ `--git` inline | ❌ | ✅ | ❌ | ❌ |
| **Árbol** | ✅ `--tree` | ❌ (usa `tree`) | ✅ | ❌ | ✅ |
| **Fechas relativas** | ✅ `--date=relative` | ❌ | ✅ | ❌ | ❌ |
| **Cabecera** | ✅ `--header` | ❌ | ❌ | ❌ | ❌ |
| **Velocidad** | Muy rápida (Rust) | Muy rápida | Muy rápida | Muy rápida | Rápida |
| **Ideal para** | CLI moderno diario | Universal, scripts | Discontinuado | Fallback ligero | Terminal con iconos |

> **Nota:** `exa` fue abandonado en 2023; `eza` es su fork activo con mejoras. En scripts, `ls` sigue siendo universal.

## Ver también

- `ls` — el clásico
- `exa` — predecesor (discontinuado)
- [[lf]] · [[ranger]] · [[nnn]] — gestores de archivos TUI
- [[yazi]] — gestor de archivos TUI moderno

## Enlaces externos

- [GitHub — eza](https://github.com/eza-community/eza)
- [Sitio oficial](https://eza.rocks/)
- [Arch Wiki — eza](https://wiki.archlinux.org/title/Eza)

#programa #tui #archivos
