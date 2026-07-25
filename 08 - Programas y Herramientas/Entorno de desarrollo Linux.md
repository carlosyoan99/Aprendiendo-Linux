---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# Entorno de desarrollo Linux

> Guía práctica para montar un entorno de desarrollo completo en Linux. Cubre desde el toolchain básico hasta stacks específicos por lenguaje.

## Qué es

Linux es el sistema operativo por excelencia para desarrollo de software. La mayoría de herramientas clave — compiladores, servidores, bases de datos, contenedores — se crearon primero en Linux y funcionan de forma nativa sin capas de emulación. Un entorno de desarrollo en Linux incluye:

- **Editor o IDE** — el programa donde escribes código (ver [[Comparativa editores Linux]])
- **Toolchain** — compiladores, intérpretes, linters
- **Gestor de paquetes del lenguaje** — dependencias del proyecto
- **Sistema de control de versiones** — Git
- **Contenedores** — entornos aislados y reproducibles
- **Terminal** — la interfaz principal para todo lo anterior

```bash
# Un entorno típico de desarrollo podría incluir:
# Editor:      Neovim o VS Code
# Terminal:    kitty/alacritty + tmux + zsh
# Toolchain:   gcc, make, cmake, python3, node, cargo
# VCS:         git + gh (GitHub CLI)
# Contenedor:  Docker o Podman
# Debug:       gdb, strace, lsof
```

## Toolchain base: instalar todo de una vez

```bash
# ── Debian/Ubuntu ──
sudo apt update
sudo apt install build-essential         # gcc, g++, make, libc-dev
sudo apt install git curl wget           # esenciales
sudo apt install python3 python3-pip     # Python
sudo apt install nodejs npm              # Node.js (version del repo, suele ser antigua)
sudo apt install gdb strace ltrace       # depuración
sudo apt install manpages-dev            # documentación

# ── Arch Linux ──
sudo pacman -S base-devel                # gcc, make, autoconf, pkg-config
sudo pacman -S git curl wget
sudo pacman -S python python-pip
sudo pacman -S nodejs npm
sudo pacman -S gdb strace ltrace

# ── Fedora ──
sudo dnf groupinstall "Development Tools"
sudo dnf install git curl wget
sudo dnf install python3 python3-pip
sudo dnf install nodejs npm
sudo dnf install gdb strace ltrace
```

## Stack por lenguaje

### Python

```bash
# Python 3 ya viene instalado en la mayoría de distros
python3 --version
pip3 --version

# Entornos virtuales (siempre usarlos, nunca pip global)
python3 -m venv .venv                    # crear entorno virtual
source .venv/bin/activate                # activar
pip install requests flask django        # instalar en el entorno
deactivate                               # salir del entorno

# Gestor moderno: uv (ultrarrápido, Rust)
curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv                                  # crear entorno (más rápido)
uv pip install requests                  # instalar (10-100x más rápido)

# Poetry: gestor de dependencias + empaquetado
pip install poetry
poetry new mi-proyecto
poetry add requests
```

**Herramientas clave**: `flake8` (linter), `black` (formateador), `mypy` (tipos), `pytest` (tests), `ipython` (REPL mejorado). Ver [[Python en Linux]].

### Node.js / JavaScript

```bash
# ⚠️ No instalar nodejs del repo del sistema (versiones muy antiguas)
# Usar nvm (Node Version Manager):
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install --lts                        # última LTS
nvm use --lts
node --version                           # v22.x
npm --version                            # 10.x

# Gestores alternativos
npm install -g yarn                      # yarn (más rápido, determinista)
npm install -g pnpm                      # pnpm (hard links, ocupa menos)
```

**Herramientas clave**: `typescript` (tipado), `eslint` (linter), `prettier` (formato), `vitest` (tests), `vercel/pkg` (compilar a binario). Ver [[Lenguajes y gestores (Node.js Cargo PIP Go Gem)]].

### Rust

```bash
# Instalación oficial con rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup update
rustc --version
cargo --version

# Componentes útiles
rustup component add rust-analyzer       # LSP (para el editor)
rustup component add clippy              # linter
rustup component add rustfmt             # formateador
rustup target add wasm32-unknown-unknown # compilar a WebAssembly

# Proyecto nuevo
cargo new mi-proyecto
cd mi-proyecto
cargo build
cargo run
cargo test
cargo doc --open                         # documentación
```

**Herramientas clave**: `cargo-edit` (gestionar dependencias), `cargo-watch` (auto-ejecutar al cambiar), `cargo-expand` (expandir macros), `just` (make alternativo para Rust). Ver [[Lenguajes y gestores (Node.js Cargo PIP Go Gem)]].

### Go

```bash
# Instalación oficial
wget https://go.dev/dl/go1.23.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.23.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
go version

# O desde repos (puede estar desactualizado)
sudo apt install golang-go               # Debian/Ubuntu
sudo pacman -S go                        # Arch

# Proyecto nuevo
mkdir mi-proyecto && cd mi-proyecto
go mod init github.com/usuario/mi-proyecto
go get github.com/gin-gonic/gin
go run main.go
```

**Herramientas clave**: `gopls` (LSP oficial), `golint` / `staticcheck` (linter), `go vet` (análisis), `delve` (depurador).

### C / C++

```bash
# El toolchain ya está instalado con build-essential/base-devel
gcc --version
g++ --version
make --version
cmake --version                          # si no está: sudo apt install cmake

# Compilar un proyecto típico con CMake
mkdir build && cd build
cmake ..                                 # genera Makefile
make -j$(nproc)                          # compila en paralelo
./app                                    # ejecutar
```

**Herramientas clave**: `clang` (alternativa a gcc), `clangd` (LSP), `gdb` (depurador), `valgrind` / `-fsanitize=address` (fugas de memoria). Ver [[Desarrollo en Linux (gcc make gdb strace)]].

## Gestión de versiones múltiples

Para lenguajes que evolucionan rápido, tener varias versiones instaladas es esencial:

| Lenguaje | Gestor de versiones | Comando básico |
|---|---|---|
| **Node.js** | nvm | `nvm install --lts`, `nvm use 18` |
| **Python** | pyenv | `pyenv install 3.12`, `pyenv global 3.12` |
| **Rust** | rustup | `rustup install nightly`, `rustup default stable` |
| **Go** | g (binario) | `go install` (múltiples versiones con go.mod) |
| **Java** | sdkman | `sdk install java 21`, `sdk use java 17` |
| **Ruby** | rbenv / rvm | `rbenv install 3.3`, `rbenv global 3.3` |

```bash
# pyenv — Python
curl https://pyenv.run | bash
pyenv install 3.12.5
pyenv install 3.10.14
pyenv global 3.12.5                     # versión por defecto

# sdkman — Java, Scala, Kotlin, Maven
curl -s "https://get.sdkman.io" | bash
sdk list java                           # ver versiones disponibles
sdk install java 21-temurin             # Eclipse Temurin JDK 21
sdk use java 17-temurin                 # cambiar versión
```

## Contenedores para desarrollo

Usar contenedores como entorno de desarrollo garantiza que el equipo completo (y CI/CD) use las mismas versiones:

### Docker para desarrollo local

```bash
# Base de datos sin instalar en el sistema
docker run -d --name pg-dev -e POSTGRES_PASSWORD=dev -p 5432:5432 postgres:16

# Entorno de desarrollo completo con Docker Compose
cat > docker-compose.yml << 'EOF'
services:
  app:
    image: node:22
    working_dir: /app
    volumes:
      - .:/app
    ports:
      - "3000:3000"
    command: npm run dev
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: dev
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
EOF
docker compose up -d
```

### Dev Containers (VS Code)

VS Code soporta abrir proyectos dentro de contenedores:

```bash
# Requiere: Docker + extensión "Dev Containers"
# Crear .devcontainer/devcontainer.json
{
  "name": "Python Dev",
  "image": "mcr.microsoft.com/devcontainers/python:3.12",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {}
  },
  "extensions": ["ms-python.python"],
  "postCreateCommand": "pip install -r requirements.txt"
}
```

### Podman (alternativa sin daemon)

```bash
# Podman es compatible con Docker CLI pero no requiere daemon
podman run -d --name pg-dev -e POSTGRES_PASSWORD=dev -p 5432:5432 postgres:16
podman ps

# Podman Compose (alternativa a docker-compose)
podman-compose up -d
```

Ver [[Docker]] y [[Virtualización (KVM QEMU libvirt)]].

## Terminal y productividad

Un buen entorno de desarrollo no es solo el editor — la terminal es igual de importante:

| Herramienta | Para qué | Alternativas |
|---|---|---|
| [[tmux]] | Multiplexor de terminal (sesiones, paneles, ventanas) | [[screen]] |
| [[Shells (bash zsh fish)|zsh]] | Shell moderna con autocompletado, temas | bash, fish |
| `fzf` | Búsqueda fuzzy en terminal (historial, archivos) | — |
| `ripgrep` / `fd` | grep/find ultrarrápidos en proyectos grandes | grep, find |
| `lazygit` | TUI para Git | git CLI, `tig` |
| `bat` | cat con resaltado de sintaxis | cat, `less` |
| `htop` | Monitor de procesos interactivo | top, btop |

```bash
# Instalación rápida del set recomendado
# Debian/Ubuntu
sudo apt install tmux zsh fzf ripgrep fd-find bat htop

# Arch
sudo pacman -S tmux zsh fzf ripgrep fd bat htop
```

## Flujo de trabajo típico

```
1.  terminal                # abrir terminal
2.  tmux                    # crear sesión con paneles
3.  cd ~/proyecto           # ir al proyecto
4.  nvm use --lts           # activar versión Node
5.  source .venv/bin/activate  # activar entorno Python
6.  code .                  # o: nvim .
7.  npm run dev             # en otro panel de tmux
8.  git checkout -b feature # empezar una rama
9.  (editar, probar, commit)
10. gh pr create             # crear pull request
```

## Ver también

- [[Desarrollo en Linux (gcc make gdb strace)]] — toolchain C/C++, depuración
- [[Lenguajes y gestores (Node.js Cargo PIP Go Gem)]] — gestores de paquetes por lenguaje
- [[Python en Linux]] — Python específicamente
- [[Compilacion desde Codigo Fuente]] — compilar programas desde fuente
- [[Editores de código (VSCode Codium Zed Helix Antigravity)]] — IDEs y editores
- [[Comparativa editores Linux]] — cómo elegir editor según perfil
- [[Git]] — control de versiones
- [[GitHub CLI (gh)]] — GitHub desde terminal
- [[Docker]] — contenedores para desarrollo
- [[tmux]] — multiplexor de terminal
- [[Shells (bash zsh fish)]] — elegir shell
- [[Automatizacion y Scripts]] — automatizar builds, tests, deploys

## Enlaces externos

- [Wikipedia — Software development](https://en.wikipedia.org/wiki/Software_development)
- [Arch Wiki — Development environment](https://wiki.archlinux.org/title/Developer_workspace)
- [The Missing Semester of CS Education (MIT)](https://missing.csail.mit.edu/) — curso de herramientas de desarrollo
- [Dev Containers specification](https://containers.dev/)
- [nvm — Node Version Manager](https://github.com/nvm-sh/nvm)
- [rustup — Rust toolchain installer](https://rustup.rs/)
- [pyenv — Python version manager](https://github.com/pyenv/pyenv)
- [sdkman — SDK manager](https://sdkman.io/)

#programa #desarrollo #entorno
