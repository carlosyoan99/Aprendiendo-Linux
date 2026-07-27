---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# tig

> Visor de commits y log para Git en terminal. El clásico minimalista: navega el historial, diff, blame, stash — todo con teclas tipo Vim.

## Qué es

**tig** (Text-mode Interface for Git) es un navegador de repositorios Git para terminal. Muestra el log de commits, permite explorar el diff de cada commit, ver el blame de archivos, navegar branches y stash. Es más rápido que abrir lazygit solo para consultar el historial.

Escrito en C. Preinstalado en muchas distros o disponible como paquete pequeño.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install tig

# Arch
sudo pacman -S tig

# Fedora
sudo dnf install tig

# Desde fuente (última versión)
git clone https://github.com/jonas/tig.git
cd tig
make
sudo make install
```

## Uso básico

```bash
tig                                  # log de commits del repo actual
tig --all                            # todas las branches
tig diff                             # cambios sin stage
tig show <commit>                    # mostrar diff de un commit específico
tig blame archivo.txt                # blame de archivo
tig stash                            # ver stash
tig status                           # estado del working tree
tig refs                             # referencias (tags, branches)
```

## Atajos esenciales

| Tecla | Acción |
|---|---|
| `j` / `k` | Navegar arriba/abajo |
| `Enter` | Ver detalle del commit (diff) |
| `l` | Ver log completo del commit |
| `d` | Ver diff |
| `t` | Ver árbol del commit |
| `~` | Ver vista padre del commit |
| `,` / `.` | Commit anterior / siguiente |
| `/` | Buscar |
| `q` | Salir (o volver atrás) |
| `?` | Ayuda |
| `g` / `G` | Principio / final de la lista |

### Modo blame

```bash
tig blame src/main.rs
# j/k = navegar, Enter = ver diff del commit que modificó esa línea
# ,/. = commit anterior/siguiente
```

### Modo stash

```bash
tig stash
# Enter = ver contenido del stash
# ! = git stash pop
```

## Personalización: `~/.tigrc`

```bash
# Colores estilo Nord
set line-graphics = utf-8
set show-changes = true
set git-colors = true

# Atajos personalizados
bind generic G move-page-end
bind generic g move-page-start

# Tema
color default            white          black
color cursor             white          cyan    bold
color status             yellow         default bold
color title-blur         white          blue
color title-focus        white          blue    bold
```

## Comparativa

| Aspecto | tig | lazygit | gitui | Git CLI |
|---|---|---|---|---|
| **Log de commits** | ✅ Excelente | ✅ Bueno | ✅ Bueno | ✅ |
| **Blame** | ✅ Nativo | ❌ | ❌ | ✅ `git blame` |
| **Stage/commit** | ❌ Sólo ver | ✅ Completo | ✅ Completo | ✅ |
| **Branch management** | ❌ Sólo ver | ✅ Completo | ✅ | ✅ |
| **Rendimiento** | ⚡ Más rápido | Rápido | Muy rápido | N/A |
| **Tamaño** | ~1 MB | ~15 MB | ~5 MB | N/A |
| **Curva aprendizaje** | Media | Muy baja | Baja | Alta |

> tig es **el más rápido** para consultar el historial (log, blame, diff). Para trabajar (stage, commit, branch), [[lazygit]] o [[gitui]] son mejores.

## Ver también

- [[lazygit]] — Git TUI completo (stage, commit, branch, merge)
- [[gitui]] — Git TUI en Rust, rápido y con temas
- [[Git]] — nota general sobre Git en el vault
- [[GitHub CLI (gh)]] — GitHub desde terminal
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — jonas/tig](https://github.com/jonas/tig)
- [Sitio oficial](https://jonas.github.io/tig/)
- [Manual de tig](https://jonas.github.io/tig/doc/manual.html)

#programa #tui #git
