---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
---

# fzf

> Fuzzy finder interactivo para la terminal. Filtra cualquier lista de forma difusa: historial de comandos, archivos, procesos, incluso resultados de otros comandos vía pipe.

## Qué es

**fzf** (fuzzy finder) es un filtro difuso interactivo universal. Toma una lista de líneas por stdin, muestra un cuadro de búsqueda, y permite filtrarlas escribiendo parcialmente cualquier parte del texto — no solo prefijos. Cuanto más escribes, más se estrecha la búsqueda.

**Integración directa** con bash/zsh/fish para reemplazar:
- `Ctrl+R` — buscar en historial de comandos
- `Ctrl+T` — buscar archivos
- `Alt+C` — cd a un directorio

## Instalación

```bash
# Debian/Ubuntu
sudo apt install fzf

# Arch
sudo pacman -S fzf

# Fedora
sudo dnf install fzf

# Desde GitHub (binario estático)
# https://github.com/junegunn/fzf/releases

# Activar integración con shell (en ~/.bashrc):
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
```

## Key bindings integrados

| Atajo | Acción |
|---|---|
| `Ctrl+R` | Buscar en historial de comandos |
| `Ctrl+T` | Buscar archivo (pega la ruta) |
| `Alt+C` | Buscar directorio (hace cd) |
| `Ctrl+Espacio` | Múltiple selección (en `Ctrl+T`) |
| `Tab` / `Shift+Tab` | Seleccionar/deseleccionar en modo múltiple |

## Atajos dentro de fzf

| Tecla | Acción |
|---|---|
| `Ctrl+J` / `Ctrl+K` | Navegar arriba/abajo |
| `Ctrl+N` / `Ctrl+P` | Arriba/abajo (alternativo) |
| `Enter` | Confirmar selección |
| `Esc` | Cancelar |
| `Ctrl+C` | Cancelar |
| `Ctrl+Espacio` | Seleccionar múltiple (toggle) |
| `Tab` / `Shift+Tab` | Seleccionar/deseleccionar |
| `Ctrl+R` | Alternar modo fuzzy/exacto |
| `Ctrl+W` | Borrar palabra |
| `Ctrl+U` | Borrar línea |

## Uso desde terminal

```bash
# Básico: pipear cualquier lista
echo -e \"rojo\\nverde\\nazul\" | fzf     # elige un color
ls | fzf                                # elige un archivo
ps aux | fzf                            # elige un proceso

# Modo múltiple
echo -e \"a\\nb\\nc\" | fzf -m              # seleccionar varios con Tab

# Con preview
ls | fzf --preview 'cat {}'            # preview de archivos
fd -t f | fzf --preview 'bat --style=numbers {}'  # preview con bat
ps aux | fzf --preview 'echo {}'       # preview simple

# Mostrar solo 1 resultado
ls | fzf -1                             # selección automática si hay 1

# Query inicial
ls | fzf -q \"config\"                    # empieza filtrado por \"config\"
```

## Casos de uso prácticos

```bash
# 1. Matar un proceso por nombre
kill -9 \"$(ps aux | fzf | awk '{print $2}')\"

# 2. Abrir archivo con vim
vim \"$(fd -t f | fzf)\"

# 3. cd a un directorio con preview
cd \"$(fd -t d | fzf --preview 'ls -la {}')\"

# 4. Instalar paquetes con apt search + fzf
apt list --installed 2>/dev/null | fzf | awk '{print $1}' | xargs sudo apt remove

# 5. Buscar en historial de comandos (ya integrado con Ctrl+R)
# Pero también se puede customizar:
history | fzf --tac | awk '{$1=\"\"; print $0}' | bash

# 6. Gestión de branches Git
git branch | fzf | xargs git checkout

# 7. Conectar por SSH a un host del config
cat ~/.ssh/config | grep -i \"^Host \" | awk '{print $2}' | fzf | xargs ssh
```

## Configuración avanzada: `~/.fzfrc` o variables de entorno

```bash
# Estas variables se pueden definir en ~/.bashrc

# Usar fd como fuente de archivos (más rápido)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
export FZF_CTRL_T_COMMAND=\"$FZF_DEFAULT_COMMAND\"

# Preview con bat
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border
  --preview \"bat --style=numbers --color=always {}\"'

# Tema (colores)
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#d0d0d0,bg:#1e1e2e,hl:#f9e2af
  --color=fg+:#cdd6f4,bg+:#313244,hl+:#f9e2af
  --color=info:#cba6f7,prompt:#fab387,pointer:#f38ba8
  --color=marker:#f38ba8,spinner:#f38ba8,header:#f38ba8'
```

## Integración con herramientas

```bash
# fzf + fd (búsqueda rápida de archivos)
fd -t f | fzf

# fzf + ripgrep (búsqueda de contenido)
rg -l \"TODO\" | fzf --preview 'bat {}'

# fzf + git
git branch | fzf | xargs git checkout
git log --oneline | fzf | awk '{print $1}' | xargs git show

# fzf + kill (matar procesos)
kill -9 \"$(ps aux | fzf -m | awk '{print $2}')\"
```

## Comparativa

| Aspecto | fzf | fnf (rust) | skim (rust) | peco (go) |
|---|---|---|---|---|
| **Integración shell** | ✅ Ctrl+R, Ctrl+T, Alt+C | ❌ | ❌ | ❌ |
| **Preview** | ✅ `--preview` | ❌ | ✅ | ❌ |
| **Modo múltiple** | ✅ `-m` | ✅ | ✅ | ❌ |
| **Velocidad** | Rápido | ⚡ Muy rápido | Rápido | Rápido |
| **Ecosistema** | ✅ Enorme (plugins, tutoriales) | Pequeño | Pequeño | Pequeño |
| **Peso** | ~5 MB | ~3 MB | ~4 MB | ~5 MB |

> fzf es el estándar de facto y la mejor opción por su integración directa con el shell y su enorme comunidad.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Ctrl+R no abre fzf | `source` no está en .bashrc | Añadir `source /usr/share/fzf/key-bindings.bash` |
| Preview no funciona | Falta `bat` o el comando de preview | Instalar bat: `sudo apt install bat` |
| Ventana muy pequeña | `--height` no configurado | `export FZF_DEFAULT_OPTS='--height 60%'` |
| Colores feos | Usar tema personalizado | Configurar `FZF_DEFAULT_OPTS` con colores |

## Ver también

- [[fd-find]] — búsqueda rápida de archivos (combinación ideal con fzf)
- [[find]] — búsqueda clásica
- [[locate]] — búsqueda indexada
- [[ripgrep]] — búsqueda de contenido en archivos
- [[La Shell]] — integración con el shell

## Enlaces externos

- [GitHub — junegunn/fzf](https://github.com/junegunn/fzf)
- [Arch Wiki — Fzf](https://wiki.archlinux.org/title/Fzf)

#programa #herramientas #busqueda
