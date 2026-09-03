---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# zoxide

> Reemplazo inteligente de `cd` que aprende tus directorios frecuentes. Escribe parcialmente un nombre y zoxide te lleva al sitio correcto.

## Qué es

**zoxide** es un `cd` inteligente que registra los directorios que visitas frecuentemente y te permite navegar a ellos escribiendo solo unas letras. Funciona como un `cd` con memoria — cuanto más usas un directorio, más prioridad tiene en las sugerencias.

**Ventajas sobre `cd`:**
- Navegación por frecuencia (no por ruta exacta)
- Integración con fzf para selección interactiva
- Multi-shell (bash, zsh, fish, nushell, etc.)
- Rápido (escrito en Rust)
- Compatible con `cd` normal cuando no matchea

## Instalación

```bash
# Debian/Ubuntu
sudo apt install zoxide        # Ubuntu 24.04+
sudo snap install zoxide

# Arch / CachyOS
sudo pacman -S zoxide

# Fedora
sudo dnf install zoxide

# Script de instalación oficial
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

## Activar en la shell

```bash
# Bash (~/.bashrc)
eval "$(zoxide init bash)"

# Zsh (~/.zshrc)
eval "$(zoxide init zsh)"

# Fish (~/.config/fish/config.fish)
zoxide init fish | source

# Nushell
zoxide init nushell | save --force ~/.config/nushell/env.nu
```

## Uso

```bash
z foo                     # cd al directorio más frecuente que contenga "foo"
z bar baz                 # matchea "bar" y "baz" en la ruta
zi                        # selección interactiva con fzf
z -                      # volver al directorio anterior

# Normalmente sigues usando cd para rutas exactas
cd /usr/local/bin          # esto sigue funcionando igual
```

## Comandos

| Comando | Descripción |
|---|---|
| `z <patrón>` | Navegar al directorio más frecuente que matchee |
| `zi` | Selección interactiva con fzf |
| `z -` | Directorio anterior |
| `zoxide query` | Consultar la base de datos |
| `zoxide query -l` | Listar todos los directorios registrados |
| `zoxide remove <dir>` | Eliminar un directorio de la base de datos |
| `zoxide import --help` | Importar historial de `cd` |

## Ejemplo de uso diario

```bash
# Visitas frecuentes: ~/Documentos/proyectos/web
# En vez de:
cd ~/Documentos/proyectos/web

# Solo escribes:
z web

# O para ver todas las opciones:
zi
# → fzf muestra una lista filtrada de directorios frecuentes
```

## Integración con fzf

```bash
# Si fzf está instalado, zoxide lo usa automáticamente para `zi`
# Para forzar uso de fzf en `z`:
export ZOXIDE_FZF_OPTIONS='--height 40% --layout=reverse'
```

## Comparativa con alternativas

| Aspecto | zoxide | autojump | jump | bashmarks |
|---|---|---|---|---|
| **Velocidad** | ⚡ Rust | 🐌 Python | ⚡ Go | ⚡ Bash |
| **Multi-shell** | ✅ | ✅ | ❌ | ❌ |
| **Selección interactiva** | ✅ (fzf) | ❌ | ❌ | ❌ |
| **Instalación** | Simple | pip/brew | Go | Source |
| **Base de datos** | SQLite | SQLite | JSON | Bash vars |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `z` no se activa en la shell | No se añadió la línea de init | Añadir `eval "$(zoxide init bash)"` (zsh/fish según shell) al `.bashrc` |
| Cambios de dir no se registran | Shell no evalúa el hook | Asegurar que la línea de init va en el archivo correcto y tras export |
| Directorio antiguo no aparece | La base de datos no se actualiza | `zoxide add <ruta>` manualmente, o revisar `~/.local/share/zoxide/db.zo` |
| Comando ambiguo al saltar | Varias rutas parecidas | Especificar subcadena más larga: `z proy/libr` en vez de `z pro` |
| Config de autocompletado / fzf no funciona | Init y plugin de fzf por separado | Cargar zoxide init DESPUÉS de activar fzf |

## Ver también

- `cd` — el clásico
- `autojump` — alternativa Python (predecesor)
- `fzf` — fuzzy finder
- [[atuin]] — historial de comandos inteligente
- [[Fish]] — shell con autocompletado inteligente
- [[Shells (bash zsh fish)]] — shells disponibles

## Enlaces externos

- [GitHub — zoxide](https://github.com/ajeetdsouza/zoxide)
- [Sitio oficial](https://ajeetdsouza.github.io/zoxide/)
- [Arch Wiki — zoxide](https://wiki.archlinux.org/title/Zoxide)

#programa #terminal #navegacion
