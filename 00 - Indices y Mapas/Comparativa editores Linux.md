---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: indice
prioridad: alta
---

# Comparativa de editores Linux

> Guía completa para elegir editor de texto o código en Linux según tu perfil, necesidades y recursos del equipo. Unifica la información dispersa sobre editores en una sola tabla de decisión.

Linux ofrece la mayor variedad de editores de cualquier sistema operativo: desde el minimalista `nano` (preinstalado en todas las distros) hasta entornos de desarrollo completos como VS Code o JetBrains. Esta nota te ayuda a **elegir cuál usar** basándote en criterios objetivos.

## Guía rápida de elección

| Si eres... | Y necesitas... | Editor recomendado |
|---|---|---|
| **Principiante absoluto** | Editar un archivo de configuración | [[Nano]] — ya está instalado, atajos visibles |
| **Usuario de Windows/Mac** | Algo familiar en terminal | [[Micro]] — Ctrl+S, Ctrl+Q, Ctrl+C/V |
| **Desarrollador backend** | Programar en terminal eficientemente | [[Vim Neovim]] o Helix |
| **Desarrollador full-stack** | IDE completo con plugins | VS Code / VSCodium o Zed (si tienes GPU) |
| **Rust developer** | LSP nativo, rápido, modal | Helix o Neovim |
| **KDE user** | Editor nativo KDE | **Kate** |
| **Equipo antiguo (< 4 GB RAM)** | Algo ligero que funcione | Geany, [[Nano]], [[Micro]] |
| **Sysadmin / DevOps** | Editar en SSH rápido | [[Vim Neovim]] (modal, sin ratón) |
| **Estudiante** | Aprender a programar con buenas herramientas | VS Code / VSCodium o Geany |
| **Entusiasta de Rust** | Editor nativo, moderno, rápido | Zed, Helix o Lapce |

---

## Tabla comparativa completa

### Editores de terminal

| Editor | Curva | Consumo RAM | Nativo | Vim mode | LSP integrado | Plugins | Ideal para |
|---|---|---|---|---|---|---|---|
| **[[Nano]]** | ⭐ Muy baja | ~2 MB | ✅ | ❌ | ❌ | ❌ | Edits rápidos, principiantes |
| **[[Vim Neovim\|Vim]]** | 🔴 Alta | ~5 MB | ✅ | ✅ (nativo) | ❌ (coc.nvim) | ✅ (.vimrc) | Programación, sysadmin |
| **[[Vim Neovim\|Neovim]]** | 🔴 Alta | ~20 MB | ✅ | ✅ (nativo) | ✅ (vim.lsp) | ✅ (Lua) | Programación avanzada |
| **[[Micro]]** | ⭐ Baja | ~5 MB | ✅ | ❌ | ❌ | ✅ (básico) | Migración desde GUI |
| **Helix** | 🟡 Media | ~15 MB | ✅ | ✅ (propio) | ✅ (nativo) | ❌ (batteries) | Programación Rust/modal |
| **Emacs** | 🔴 Alta | ~50 MB | ✅ | ✅ (evil) | ✅ | ✅ (ELPA) | Personalización máxima |

### Editores GUI nativos

| Editor | Curva | Consumo RAM | Nativo | Vim mode | LSP | Plugins | Ideal para |
|---|---|---|---|---|---|---|---|
| **Zed** | 🟡 Media | ~50 MB | ✅ (Rust/GPU) | ✅ | ✅ | ❌ (built-in) | Proyectos grandes, GPU |
| **Lapce** | 🟡 Media | ~30 MB | ✅ (Rust) | ✅ | ✅ | ✅ (WASM) | Alternativa nativa a VS Code |
| **Kate** | ⭐ Baja | ~80 MB | ✅ (Qt/C++) | ❌ | ✅ | ✅ (KDE) | Programación en KDE |
| **Geany** | ⭐ Baja | ~15 MB | ✅ (GTK/C) | ❌ | ⚠️ Básico | ✅ | PCs lentos, programación simple |
| **Gedit** | ⭐ Muy baja | ~10 MB | ✅ (GTK/C) | ❌ | ❌ | ❌ | Edits rápidos en GNOME |

### Editores basados en Electron/Web

| Editor | Curva | Consumo RAM | Nativo | Vim mode | LSP | Plugins | Ideal para |
|---|---|---|---|---|---|---|---|
| **VS Code** | 🟡 Media | ~200 MB | ❌ (Electron) | ✅ (plugin) | ✅ | ✅ (24k+) | Programación general |
| **VSCodium** | 🟡 Media | ~200 MB | ❌ (Electron) | ✅ (plugin) | ✅ | ✅ (24k+) | VS Code sin telemetría |
| **Sublime Text** | 🟡 Media | ~150 MB | ⚠️ (propietario) | ❌ | ❌ | ✅ (Package Control) | Edición ligera, rápida (no Electron) |

### IDEs completos

| IDE | Curva | Consumo RAM | Lenguajes | Vim mode | Ideal para |
|---|---|---|---|---|---|
| **IntelliJ IDEA** | 🔴 Alta | ~1 GB+ | Java, Kotlin, JVM | ✅ (IdeaVim) | Desarrollo Java/Kotlin profesional |
| **PyCharm** | 🔴 Alta | ~1 GB+ | Python | ✅ (IdeaVim) | Python profesional (Django, ciencia) |
| **CLion** | 🔴 Alta | ~1 GB+ | C/C++ | ✅ (IdeaVim) | C/C++ profesional con CMake |
| **GoLand** | 🔴 Alta | ~1 GB+ | Go | ✅ (IdeaVim) | Go profesional |
| **RustRover** | 🔴 Alta | ~1 GB+ | Rust | ✅ (IdeaVim) | Rust profesional |
| **Eclipse** | 🟡 Media | ~500 MB | Java, C++, PHP | ❌ | Java legacy, Android clásico |
| **Qt Creator** | 🟡 Media | ~300 MB | C++, QML | ❌ | Desarrollo Qt/QML |
| **Android Studio** | 🔴 Alta | ~2 GB+ | Kotlin, Java | ✅ (IdeaVim) | Desarrollo Android |
| **Visual Studio** (Windows) | 🔴 Alta | ~1 GB+ | C#, .NET | ❌ | Solo Windows, .NET |

---

## Categorías de editores

### 1. Editores de terminal (TUI)

Ideales para SSH, servidores sin interfaz gráfica, y quienes prefieren trabajar desde la terminal.

| Editor | Por qué destaca | Limitación principal |
|---|---|---|
| **[[Nano]]** | Preinstalado en todas las distros, atajos visibles, imposible de romper | Sin LSP, sin plugins, funciones básicas |
| **[[Vim Neovim\|Vim]]** | Universal (preinstalado como `vi`), modal, extremadamente portable | Curva de aprendizaje alta |
| **[[Vim Neovim\|Neovim]]** | LSP nativo, Lua, Tree-sitter, terminal integrada, ecosistema moderno | Curva alta (pero mejor que Vim) |
| **[[Micro]]** | Atajos Ctrl+S/Q/C/V, binario único, resaltado sintaxis 130+ lenguajes | Sin LSP, ecosistema pequeño |
| **Helix** | LSP + Tree-sitter nativos, multi-cursor, filosofía objeto→acción | Sin plugins, ecosistema joven |
| **Emacs** | Personalizable al extremo (ELisp), `org-mode`, `magit` (Git), `evil` (Vim) | Consumo alto para TUI, curva alta |

### 2. Editores GUI nativos

Editores con interfaz gráfica escritos en lenguajes compilados (C++, Rust), rápidos y eficientes.

| Editor | Tecnología | Por qué destaca |
|---|---|---|
| **Zed** | Rust (GPUI) | Renderizado GPU, colaboración tiempo real, ultrarrápido |
| **Lapce** | Rust (Druid) | Plugins con WASM, nativo, Vim mode |
| **Kate** | C++ (Qt) | Integración KDE, LSP, multipestaña, veterano y estable |
| **Geany** | C (GTK) | Extremadamente ligero (~15 MB RAM), 0 config, ideal para PCs viejos |
| **Gedit** | C (GTK) | Simple, viene con GNOME, para edits rápidos gráficos |

### 3. Editores Electron

Basados en Chromium+Node.js — potentes pero pesados.

| Editor | Por qué destaca | Cuándo evitarlo |
|---|---|---|
| **VS Code** | Mayor ecosistema de plugins, GitHub Copilot, Remote Development | PCs con < 4 GB RAM, batería portátil |
| **VSCodium** | VS Code sin telemetría Microsoft | Mismas limitaciones que VS Code |

### 4. IDEs comerciales

Entornos completos con todo integrado (compilación, debug, tests, VCS, deploy).

| IDE | Casa | Por qué destaca |
|---|---|---|
| **IntelliJ IDEA** | JetBrains | El mejor para Java/Kotlin, refactorización inteligente |
| **PyCharm** | JetBrains | El mejor para Python profesional |
| **CLion** | JetBrains | CMake integrado, análisis estático avanzado |
| **RustRover** | JetBrains | IDE Rust con todo incluido |
| **Eclipse** | Eclipse Foundation | Gratuito, legacy Java, SDK Android (histórico) |
| **Qt Creator** | Qt Project | El mejor para desarrollo Qt/QML |

---

## Criterios detallados de elección

### Por consumo de recursos

```bash
# Memoria RAM típica en reposo (sin proyecto abierto)
nano / micro         ~2-5 MB
vim (terminal)       ~5 MB
neovim               ~15-30 MB
helix                ~10-20 MB
geany                ~15 MB
gedit / kate         ~10-80 MB
zed                  ~30-80 MB
lapce                ~30-50 MB
sublime text         ~80-150 MB
VS Code / Codium     ~150-250 MB
emacs                ~30-80 MB
JetBrains IDE        ~500 MB - 1 GB+

# Regla: si tienes menos de 4 GB RAM → editor de terminal o nativo ligero
```

### Por experiencia previa

| Vienes de... | Editor más natural en Linux |
|---|---|
| **Windows (Notepad++)** | [[Micro]] (atajos similares) o Kate |
| **Windows (VS Code)** | VS Code / VSCodium o Zed |
| **macOS (TextEdit)** | Gedit o Kate |
| **macOS (BBEdit/Coda)** | VS Code |
| **Sublime Text** | Zed o Lapce |
| **Ninguna experiencia** | [[Nano]] → [[Micro]] → VS Code / VSCodium |

### Por tipo de trabajo

| Trabajo | Editor primario | Alternativa |
|---|---|---|
| **Shell scripting** | [[Vim Neovim]] | [[Nano]] |
| **Python (data science)** | VS Code + Jupyter | PyCharm |
| **Python (web)** | VS Code / VSCodium | PyCharm |
| **Rust** | Helix o Neovim | RustRover |
| **JavaScript/TypeScript** | VS Code / VSCodium | Zed |
| **Go** | VS Code + gopls | GoLand |
| **Java** | IntelliJ IDEA | VS Code + Java Extension Pack |
| **C/C++** | Neovim o CLion | VS Code + clangd |
| **Kotlin/Android** | Android Studio | IntelliJ IDEA |
| **C#/.NET** | VS Code + C# Dev Kit | JetBrains Rider |
| **Ruby** | VS Code + Ruby LSP | RubyMine |
| **PHP** | VS Code + PHP Inteliphense | PhpStorm |
| **Sistemas/DevOps** | [[Vim Neovim]] | [[Nano]] |
| **Markdown/documentación** | VS Code / VSCodium | [[Micro]] o Zed |

---

## Stack recomendado por perfil

### 🧑‍💻 Desarrollador full-stack moderno

```bash
Editor principal:    Zed o VS Code / VSCodium
Editor secundario:   Neovim (para ediciones rápidas en terminal)
Terminal:            tmux + zsh + fzf + ripgrep
Git:                 lazygit + gh CLI
Complementos:        Docker, Dev Containers, GitHub Copilot
```

### 🔧 Sysadmin / DevOps

```bash
Editor principal:    Neovim (con LSP básico)
Editor secundario:   Nano (para servidores ajenos)
Terminal:            tmux + bash + fzf + htop
Git:                 git CLI + gh CLI
Complementos:        kubectl, ansible, terraform
```

### 🐍 Científico de datos / Python

```bash
Editor principal:    VS Code + Jupyter + Python extension
Editor secundario:   Neovim (scripts rápidos)
Terminal:            zsh + conda/pyenv + htop
Git:                 git CLI
Complementos:        Jupyter notebooks, Docker para ML
```

### 🦀 Rust backend developer

```bash
Editor principal:    Helix o Neovim
Editor secundario:   VS Code (para debugging visual)
Terminal:            tmux + zsh + cargo-watch + htop
Git:                 git CLI + gh CLI
Complementos:        cargo-edit, cargo-expand, just
```

---

## Tutorial / Comandos asociados

```bash
# Verificar qué editor tienes instalado
which nano vim nvim micro helix code zed lapce emacs
editor --version 2>/dev/null || echo "No default editor set"

# Cambiar editor por defecto del sistema
sudo update-alternatives --config editor    # Debian/Ubuntu
export EDITOR=nvim                          # variable de entorno (~/.bashrc)
export VISUAL=nvim                          # para terminales

# Editar archivo con EDITOR desde terminal
git config --global core.editor "nvim"      # Git usa Neovim para commits
crontab -e                                  # usa $EDITOR
sudo visudo                                 # usa $EDITOR (o vi por defecto)
systemctl edit servicio                     # usa $EDITOR
```

---

## Notas personales

- No hay editor \"mejor\" — hay editor **adecuado para tu flujo de trabajo**. Lo importante es conocer al menos dos: uno de terminal (Nano o Vim) y uno gráfico (VS Code o Zed).
- Recomiendo aprender **Nano** primero (5 minutos) como red de seguridad, y luego invertir tiempo en **Vim/Neovim** (semanas) si trabajas en terminal regularmente.
- Los IDEs de JetBrains son caros (~$150-500/año), pero la licencia anual incluye todos los productos. PyCharm Community y IntelliJ Community son gratuitos y muy capaces.
- Para servidores: siempre tener **Nano** o **Vim** disponible. No asumas que Micro/Helix/Zed estarán instalados cuando hagas SSH a un servidor ajeno.

## Enlaces externos

- [Wikipedia — Comparison of text editors](https://en.wikipedia.org/wiki/Comparison_of_text_editors)
- [Arch Wiki — List of applications/Documents#Text editors](https://wiki.archlinux.org/title/List_of_applications/Documents#Text_editors)
- [Editor Wars: Vim vs Emacs vs VS Code](https://www.freecodecamp.org/news/vim-vs-emacs-vs-vs-code/)
- [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/) — gestor de IDEs JetBrains
- [GitHub — awesome-editors](https://github.com/guillaumechereau/awesome-editors)

## Ver también

- [[Editores de Texto]] — tabla rápida de editores de terminal
- [[Editores de código (VSCode Codium Zed Helix Antigravity)]] — editores GUI para programar
- [[Vim Neovim]] — el estándar modal
- [[Nano]] — el básico universal
- [[Micro]] — el punto medio en terminal
- [[Desarrollo en Linux (gcc make gdb strace)]] — toolchain de desarrollo
- [[Entorno de desarrollo Linux]] — montar un entorno completo
- [[La Shell]] — la terminal como base
- [[Emuladores de Terminal]] — dónde ejecutar los editores TUI

#indice #editores #comparativa
