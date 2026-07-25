---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: programa
prioridad: media
---

# Editores de Texto

## Qué es

En Linux, los archivos de configuración son archivos de texto plano. Saber usar al menos un editor de terminal es indispensable, porque no siempre tendrás un entorno gráfico disponible (servidores, sesiones SSH, TTY).

| Editor | Curva | Tamaño | Filosofía |
|---|---|---|---|
| `nano` | Muy baja | ~1 MB | Minimalista, atajos visibles en pantalla |
| `micro` | Baja | ~5 MB | Atajos tipo editor moderno (Ctrl+S, Ctrl+Q, Ctrl+C/V) |
| `vim` / `neovim` | Alta | ~10-30 MB | Modal: editas con teclas, no menús. Extremadamente potente |
| `helix` | Media | ~5 MB | Modal y moderno: selección antes que acción |
| `zed` | Media | ~15 MB | Rápido, colaborativo, GPU-accelerated |
| `lapce` | Media | ~10 MB | Rápido, Vim-compatible, nativo |
| `antigravity` | Media | ~20 MB | Rápido, moderna interfaz, LLM integrado |

## nano (el básico universal)

Viene preinstalado en prácticamente **todas** las distros. Ideal para edits rápidos cuando no quieres pensar. Ver nota dedicada: [[Nano]]

## vim / neovim (el estándar profesional)

El editor modal por excelencia. Extremadamente potente una vez superada la curva de aprendizaje. Ver nota dedicada: [[Vim Neovim]]

## micro (el punto medio)

Atajos familiares para quien viene de editores GUI (VS Code, Sublime):

```bash
sudo apt install micro          # o descargar binario único
micro archivo.txt               # Ctrl+S guarda, Ctrl+Q sale, seleccionar con mouse
```

## Helix

Editor modal **post-Vim** que invierte la filosofía: primero seleccionas, luego actúas (a diferencia de Vim, donde primero actúas y afectas al texto bajo el cursor). Escrito en Rust, con LSP y Tree-sitter integrados.

```bash
sudo apt install helix           # Debian/Ubuntu (desde repos recientes)
sudo pacman -S helix             # Arch
sudo dnf install helix           # Fedora

# O compilar desde fuente:
git clone https://github.com/helix-editor/helix
cargo install --path helix-term
```

**Características clave**:
- LSP integrado (no requiere plugins ni config extra)
- Tree-sitter para resaltado sintáctico preciso
- Multi-cursor nativo
- Configuración en TOML
- Sin plugins (por ahora) — la filosofía es "batteries included"
- Atajos similares a Vim pero más consistentes

**Helix vs Vim**:
| Aspecto | Vim/Neovim | Helix |
|---|---|---|
| Selección | Acción → objeto | **Objeto → acción** |
| LSP | Plugins (coc.nvim, mason) | Integrado nativo |
| Tree-sitter | Neovim sí, Vim con plugins | Integrado |
| Config | Vimscript / Lua | TOML |
| Multi-cursor | Con plugins | Nativo |
| Curva de aprendizaje | Alta | Media |

## Zed

Editor de código moderno creado por los fundadores de Atom (GitHub). Escrito en **Rust** con renderizado por GPU. Enfocado en velocidad y colaboración en tiempo real.

```bash
# Instalación (binario desde web)
curl -f https://zed.dev/install.sh | sh

# O desde repos (Arch, Nix)
yay -S zed-editor               # AUR
nix-shell -p zed                # Nix
```

**Características clave**:
- Extremadamente rápido (GPU-accelerated rendering con GPUI)
- Colaboración en tiempo real (canales, llamadas)
- LSP integrado
- Vim mode (compatible con atajos básicos)
- Nativo (no Electron)
- Asistente AI integrado (Zed AI)

**Limitaciones**:
- Solo Linux y macOS (no Windows)
- Relativamente nuevo (menos extensiones)
- Sin soporte oficial para distros no-x86_64

## Lapce

Editor nativo escrito en **Rust** con renderizado por GPU (usando Druid o Floem), compatible con plugins Vim y LSP.

```bash
# Instalación
sudo pacman -S lapce             # Arch
# O descargar binario desde: https://lapce.dev/
curl -fsSL https://github.com/lapce/lapce/releases/latest/download/lapce-linux-amd64.tar.gz | tar xzf -
./lapce
```

**Características**:
- Nativo (no Electron), interfaz fluida
- Plugin system con WASM
- Vim mode competente
- LSP integrado
- Editor split nativo

## VS Code / VSCodium (Electron)

**VS Code** (Visual Studio Code) es el editor más popular, basado en Electron. **VSCodium** es lo mismo pero sin telemetría de Microsoft.

```bash
# VS Code oficial
# Descargar .deb/.rpm desde: https://code.visualstudio.com/
# O añadir repositorio:
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update && sudo apt install code

# VSCodium (sin telemetría)
flatpak install flathub com.vscodium.codium
sudo pacman -S vscodium-bin       # Arch (AUR)
# O descargar .deb: https://github.com/VSCodium/vscodium/releases

# Arch (desde AUR)
yay -S visual-studio-code-bin      # VS Code oficial
yay -S vscodium-bin                # VSCodium
```

**Extensiones esenciales**:
| Extensión | Propósito |
|---|---|
| **Vim** | Modo Vim en VS Code |
| **Remote - SSH** | Editar archivos remotos |
| **GitLens** | Navegación Git avanzada |
| **Prettier** | Formateo automático |
| **Error Lens** | Errores en línea |
| **GitHub Copilot** | AI autocompletado |

## Geany

IDE ligero y rápido (GTK). Ideal para programación ocasional en equipos modestos:
```bash
sudo apt install geany            # Debian/Ubuntu
sudo pacman -S geany              # Arch
```

## Kate (KDE)

Editor avanzado de KDE, multipestaña, muy completo:
```bash
sudo apt install kate             # Debian/Ubuntu
sudo pacman -S kate               # Arch
# Viene con KDE Plasma por defecto
```

## Gedit (GNOME)

Editor simple de GNOME:
```bash
sudo apt install gedit            # Debian/Ubuntu
sudo pacman -S gedit              # Arch
# Viene con GNOME por defecto
```

## Comparativa rápida

| Editor | Nativo | Modo Vim | LSP | Consumo RAM | Ideal para |
|---|---|---|---|---|---|
| **Nano** | ✅ | ❌ | ❌ | ~2 MB | Edits rápidos en terminal |
| **Micro** | ✅ | ❌ | ❌ | ~5 MB | Edits en terminal con atajos familiares |
| **Vim/Neovim** | ✅ | ✅ | ✅ (nvim) | ~20 MB | Programación en terminal |
| **Helix** | ✅ | ✅ (propio) | ✅ | ~15 MB | Programación, fanáticos de Rust |
| **Lapce** | ✅ | ✅ | ✅ | ~30 MB | Alternativa nativa a VS Code |
| **Zed** | ✅ | ✅ | ✅ | ~50 MB | Programación, GPU-accelerated |
| **Antigravity** | ✅ | ⚠️ Básico | ✅ | ~50 MB | Programación con LLM integrado |
| **VS Code** | ❌ (Electron) | Con plugin | ✅ | ~200 MB | Programación general, plugins |
| **VSCodium** | ❌ (Electron) | Con plugin | ✅ | ~200 MB | VS Code sin telemetría |
| **Kate** | ✅ | ❌ | ✅ | ~80 MB | KDE, programación ligera |
| **Geany** | ✅ | ❌ | ⚠️ Básico | ~15 MB | Equipos lentos, programación simple |

## Notas personales

-

## Ver también

- [[Nano]] — nota dedicada
- [[Vim Neovim]] — nota dedicada
- [[La Shell]]
- [[Utilidades Base del Sistema]]
- [[Emuladores de Terminal]]
- [[Desarrollo en Linux (gcc make gdb strace)]]

## Enlaces externos

- [Wikipedia — Text editor](https://en.wikipedia.org/wiki/Text_editor)
- [Wikipedia — List of text editors](https://en.wikipedia.org/wiki/List_of_text_editors)
- [Wikipedia — Comparison of text editors](https://en.wikipedia.org/wiki/Comparison_of_text_editors)

#programa #editores
