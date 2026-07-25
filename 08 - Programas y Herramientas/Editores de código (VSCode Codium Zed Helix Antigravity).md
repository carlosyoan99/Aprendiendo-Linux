---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# Editores de código

## Qué son

A diferencia de los editores de texto básicos ([[Nano]], [[Vim Neovim]]), los editores de código están diseñados específicamente para programar: incluyen resaltado de sintaxis, autocompletado, depuración integrada, control de versiones, y terminal integrada. La mayoría son extensibles mediante plugins.

La oferta en Linux es amplia y diversa: desde editores nativos ultrarápidos como **Zed** y **Lapce** hasta el todoterreno **VS Code**, pasando por opciones modales modernas como **Helix**.

## Comparativa

| Editor | Tecnología | Nativo | Rendimiento | LSP | Depurador | Ideal para |
|---|---|---|---|---|---|---|
| **VS Code** | Electron/TypeScript | ❌ | Medio | ✅ | ✅ | Programación general, cualquier lenguaje |
| **VSCodium** | Electron/TypeScript | ❌ | Medio | ✅ | ✅ | VS Code sin telemetría |
| **Zed** | Rust (GPUI) | ✅ | Alto | ✅ | ✅ | Proyectos grandes, GPU-accelerado |
| **Helix** | Rust | ✅ | Alto | ✅ | ❌ (GDB externo) | Programación modal, Rust |
| **Lapce** | Rust (Druid) | ✅ | Alto | ✅ | ✅ | Alternativa nativa a VS Code |
| **Antigravity** | Rust | ✅ | Alto | ✅ | ❌ | LLM integrado, lightweight |
| **Kate** | C++ (Qt) | ✅ | Medio | ✅ | ❌ | Programación en KDE |
| **Geany** | C (GTK) | ✅ | Alto | ⚠️ Básico | ❌ | Equipos lentos, programación simple |

---

## VS Code

**Visual Studio Code** es el editor más popular del mundo. Corre sobre Electron, lo que lo hace pesado (~200 MB RAM) pero extremadamente extensible.

```bash
# Instalación oficial
# Descargar .deb/.rpm desde: https://code.visualstudio.com/

# O añadir repositorio:
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update && sudo apt install code

# Arch
yay -S visual-studio-code-bin
```

**Extensiones esenciales**:
| Extensión | Propósito |
|---|---|
| **Vim** | Modo Vim |
| **Remote - SSH** | Editar archivos remotos |
| **Remote - Containers** | Desarrollar en contenedores |
| **GitLens** | Git avanzado |
| **Error Lens** | Errores en línea |
| **Prettier** | Formateo automático |
| **GitHub Copilot** | AI autocompletado |
| **Python** | LSP, debug, Jupyter |
| **rust-analyzer** | LSP para Rust |

---

## VSCodium

VS Code **sin telemetría de Microsoft**, sin tracking ni cuentas. Compilado directamente desde el código fuente de VS Code pero sin los componentes propietarios de Microsoft.

```bash
# Flatpak (recomendado)
flatpak install flathub com.vscodium.codium

# Arch
yay -S vscodium-bin

# Debian/Ubuntu (.deb)
# Descargar desde: https://github.com/VSCodium/vscodium/releases
```

**Diferencias con VS Code**:
- Sin telemetría ni cuentas Microsoft
- Sin integración con GitHub Copilot (necesitas el plugin de código abierto)
- Sin sincronización de config con cuenta Microsoft
- Compatible con los mismos plugins y temas

---

## Zed

Editor creado por los fundadores de Atom (GitHub). Escrito en **Rust** con renderizado por GPU (GPUI), es significativamente más rápido que VS Code.

```bash
# Instalación
curl -f https://zed.dev/install.sh | sh

# Arch (AUR)
yay -S zed-editor
```

**Características**:
- Renderizado por GPU (GPUI) → muy fluido incluso con archivos grandes
- Colaboración en tiempo real (canales, llamadas de voz)
- LSP integrado para todos los lenguajes
- Vim mode completo
- Terminal integrada (multiplexor tipo tmux)
- AI Assistant integrado (propietario)
- **No requiere plugins para funciones básicas** (batteries included)

**Limitaciones**:
- Solo Linux y macOS (sin Windows)
- Relativamente nuevo (menos extensiones de terceros)
- Sin soporte oficial ARM64 en Linux

---

## Helix

Editor modal post-Vim con una filosofía diferente: **primero seleccionas, luego actúas**. Escrito en Rust, con LSP y Tree-sitter integrados.

```bash
sudo apt install helix           # Debian/Ubuntu (repos recientes)
sudo pacman -S helix             # Arch
sudo dnf install helix           # Fedora

# O compilar:
git clone https://github.com/helix-editor/helix
cargo install --path helix-term
```

**Características**:
- LSP integrado (sin plugins ni config extra)
- Tree-sitter para resaltado sintáctico preciso
- Multi-cursor nativo
- Configuración en TOML (no Lua ni Vimscript)
- Filosofía "batteries included" (sin gestor de plugins)

**Helix vs Vim**:
| Aspecto | Vim/Neovim | Helix |
|---|---|---|
| Selección | Acción → objeto | **Objeto → acción** |
| LSP | Plugins | Integrado nativo |
| Tree-sitter | ❌ (Vim) / ✅ (Neovim) | Integrado nativo |
| Config | Vimscript / Lua | TOML |
| Multi-cursor | Con plugins | Nativo |
| Curva | Alta | Media |

---

## Lapce

Editor nativo en Rust con renderizado GPU (Druid/Floem), compatible con atajos de Vim y LSP.

```bash
# Arch
sudo pacman -S lapce

# O binario portable:
curl -fsSL https://github.com/lapce/lapce/releases/latest/download/lapce-linux-amd64.tar.gz | tar xzf -
./lapce
```

**Características**:
- Nativo (no Electron), interfaz fluida
- Sistema de plugins con WASM
- Vim mode competente
- LSP integrado con auto-instalación
- Editor con split nativo
- Terminal integrada

---

## Antigravity

Editor de código ligero y moderno, con énfasis en la integración de **LLMs** (modelos de lenguaje) para asistencia de código. Escrito en Rust, nativo, sin Electron.

```bash
# Instalación desde GitHub
git clone https://github.com/antigravity-editor/antigravity
cd antigravity
cargo build --release
./target/release/antigravity
```

**Características**:
- Integración nativa con LLMs (local y remoto)
- Interfaz minimalista
- LSP básico integrado
- Nativo, consumo moderado de recursos
- Vim mode parcial
- Proyecto en desarrollo activo

---

## Tabla resumen de instalación

| Editor | Debian/Ubuntu | Arch | Fedora | Flatpak |
|---|---|---|---|---|
| **VS Code** | `.deb` oficial | `yay -S visual-studio-code-bin` | `.rpm` oficial | ❌ |
| **VSCodium** | `.deb` GitHub | `yay -S vscodium-bin` | `.rpm` GitHub | ✅ |
| **Zed** | `curl ... \| sh` | `yay -S zed-editor` | `curl ... \| sh` | ❌ |
| **Helix** | `apt install helix` | `pacman -S helix` | `dnf install helix` | ❌ |
| **Lapce** | `apt install lapce` | `pacman -S lapce` | `dnf install lapce` | ❌ |
| **Antigravity** | Desde fuente | Desde fuente | Desde fuente | ❌ |

## Ver también

- [[Editores de Texto]] — comparativa general con editores de terminal
- [[Nano]] — editor simple para terminal
- [[Vim Neovim]] — editor modal para terminal
- [[Desarrollo en Linux (gcc make gdb strace)]] — herramientas de desarrollo

## Enlaces externos

- [Wikipedia — Visual Studio Code](https://en.wikipedia.org/wiki/Visual_Studio_Code)
- [Wikipedia — VSCodium](https://en.wikipedia.org/wiki/VSCodium)
- [Wikipedia — Zed (editor)](https://en.wikipedia.org/wiki/Zed_(text_editor))
- [Wikipedia — Helix (text editor)](https://en.wikipedia.org/wiki/Helix_(text_editor))
- [Sitio oficial — VSCode](https://code.visualstudio.com/)
- [Sitio oficial — VSCodium](https://vscodium.com/)

#programa #desarrollo
