---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# Lenguajes y gestores de paquetes

## Visión general

Cada lenguaje de programación tiene su propio gestor de paquetes (y a veces varios). En Linux, estos gestores se integran con el sistema de paquetes nativo (apt, pacman, dnf) pero tienen sus propias reglas y peculiaridades.

```bash
┌─────────────┬──────────────┬────────────────┬────────────────────┐
│  Lenguaje   │ Gestor       │ Archivo de     │ Dónde instala      │
│             │              │ dependencias   │ (por defecto)      │
├─────────────┼──────────────┼────────────────┼────────────────────┤
│ JavaScript  │ npm / yarn   │ package.json   │ node_modules/      │
│ Rust        │ Cargo        │ Cargo.toml     │ target/            │
│ Python      │ pip / poetry │ requirements   │ site-packages/     │
│             │ / conda      │ .txt /         │ (global o venv)    │
│             │              │ pyproject.toml │                    │
│ Go          │ go mod       │ go.mod         │ GOPATH/pkg/mod/    │
│ Ruby        │ gem / bundle │ Gemfile        │ vendor/            │
└─────────────┴──────────────┴────────────────┴────────────────────┘
```

---

## Node.js / npm

### Node.js

Entorno de ejecución de JavaScript del lado del servidor, construido sobre el motor V8 de Chrome.

```bash
# Instalación desde repos del sistema
sudo apt install nodejs npm          # Debian/Ubuntu
sudo pacman -S nodejs npm            # Arch
sudo dnf install nodejs npm          # Fedora

# ⚠️ Los repos suelen tener versiones antiguas. Mejor usar nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install --lts                    # instalar la última LTS
nvm use --lts                        # usar la LTS
nvm ls                               # listar versiones instaladas

# Ver versiones
node --version                       # v22.x
npm --version                        # 10.x
```

### npm (Node Package Manager)

```bash
# Comandos básicos
npm init                              # crear package.json
npm install paquete                   # instalar como dependencia
npm install -g paquete                # instalar global
npm install --save-dev paquete        # dependencia de desarrollo
npm uninstall paquete                 # desinstalar
npm update                            # actualizar dependencias
npm run script                        # ejecutar script del package.json
npm outdated                          # ver paquetes desactualizados
npm audit                             # auditoría de seguridad
```

### Alternativas a npm

```bash
# yarn — más rápido, determinista
sudo npm install -g yarn
yarn add paquete                      # equivalente a npm install
yarn install                          # instalar dependencias del yarn.lock

# pnpm — más rápido, usa hard links (ahorra espacio)
sudo npm install -g pnpm
pnpm install                          # instalar dependencias
pnpm add paquete                      # añadir dependencia
```

### Dónde se instalan los paquetes

```bash
ls ~/node_modules/                    # dependencias del proyecto local
npm list -g --depth=0                 # paquetes globales
npm root -g                           # ruta global: /usr/lib/node_modules/
```

---

## Cargo (Rust)

### Instalación de Rust

```bash
# Recomendado: rustup (gestor de versiones)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup update                         # actualizar Rust
rustc --version                       # compilador
cargo --version                       # gestor de paquetes

# O desde repos:
sudo apt install rustc cargo          # Debian/Ubuntu (suele estar desactualizado)
sudo pacman -S rust rustup            # Arch
```

### Comandos básicos de Cargo

```bash
cargo new mi-proyecto                 # crear nuevo proyecto
cargo build                           # compilar (debug)
cargo build --release                 # compilar (producción, optimizado)
cargo run                             # compilar y ejecutar
cargo test                            # ejecutar tests
cargo check                           # verificar sin compilar (rápido)
cargo add nombre_crate                # añadir dependencia (Cargo.toml)
cargo remove nombre_crate             # eliminar dependencia
cargo update                          # actualizar dependencias
cargo doc --open                      # generar documentación
cargo clippy                          # linter
cargo fmt                             # formatear código
```

### Cargo.toml (ejemplo)

```toml
[package]
name = "mi-proyecto"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1.0", features = ["full"] }
reqwest = "0.12"

[dev-dependencies]
criterion = "0.5"
```

### Crates.io y cargo install

```bash
# Buscar paquetes: https://crates.io/

# Instalar binarios desde crates.io (equivalente a npm install -g)
cargo install ripgrep                 # instalar rg (búsqueda de texto)
cargo install bat                     # instalar bat (cat con syntax highlight)
cargo install fd-find                 # instalar fd (find moderno)

# Los binarios se instalan en ~/.cargo/bin/
ls ~/.cargo/bin/
```

---

## PIP (Python)

### pip

Gestor de paquetes oficial de Python.

```bash
# Instalación
sudo apt install python3-pip          # Debian/Ubuntu
sudo pacman -S python-pip             # Arch
sudo dnf install python3-pip          # Fedora

# Comandos básicos
pip install paquete                   # instalar paquete
pip install paquete==1.2.3            # instalar versión específica
pip install --upgrade paquete         # actualizar
pip uninstall paquete                 # desinstalar
pip list                              # listar paquetes instalados
pip list --outdated                   # paquetes desactualizados
pip show paquete                      # información del paquete
pip freeze > requirements.txt         # exportar dependencias actuales
pip install -r requirements.txt       # instalar desde archivo

# ⚠️ pip y sudo: NO USAR pip directamente con sudo
# sudo pip install → instala en sistema, puede romper paquetes del SO
# Mejor usar:
pip install --user paquete            # instalar para tu usuario (~/.local)
# O usar entornos virtuales (ver abajo)
```

### pyenv — gestionar versiones de Python

```bash
# Instalar pyenv
curl https://pyenv.run | bash
echo 'export PYTHON_BUILD_ARIA2_OPTS="-x 10 -k 1M"' >> ~/.bashrc

# Usar pyenv
pyenv install --list                  # versiones disponibles
pyenv install 3.12.5                  # instalar versión específica
pyenv global 3.12.5                   # establecer versión global
pyenv local 3.10.14                   # establecer versión local (proyecto)
pyenv versions                        # versiones instaladas
```

### Entornos virtuales (venv)

Siempre usa entornos virtuales para aislar dependencias de cada proyecto:

```bash
# Crear entorno virtual
python3 -m venv .venv                 # crear en carpeta .venv
source .venv/bin/activate             # activar (bash/zsh)
source .venv/bin/activate.fish        # activar (fish)

# Una vez activado, pip instala dentro del venv
pip install flask

# Salir del venv
deactivate

# Alternativas más modernas:
# - poetry: pip install poetry; poetry new proyecto; poetry add flask
# - pipx: instala herramientas Python de forma aislada (ver abajo)
# - uv: gestor ultrarápido en Rust (pip install uv)
```

### pipx

Instala herramientas Python de forma aislada (como `cargo install`):

```bash
sudo apt install pipx                 # Debian/Ubuntu
pip install --user pipx               # o con pip

# Instalar herramientas como comandos globales
pipx install black                    # formateador de código
pipx install ruff                     # linter rápido
pipx install poetry                   # gestor de proyectos
pipx install httpie                   # HTTP client (alternativa a curl)
pipx install cookiecutter             # generador de proyectos
```

---

## Go

### Instalación

```bash
# Desde repos
sudo apt install golang-go            # Debian/Ubuntu
sudo pacman -S go                     # Arch
sudo dnf install golang               # Fedora

# O desde la página oficial (versión más reciente)
wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
# Añadir /usr/local/go/bin al PATH
```

### GOPATH y módulos

```bash
# Go moderno (>1.16): módulos, no GOPATH
go version                            # go version go1.23.0 linux/amd64

# Variables de entorno
echo $GOPATH                          # ~/go por defecto
echo $GOROOT                          # /usr/local/go (o /usr/lib/go)
# Los binarios compilados van a $GOPATH/bin
```

### Comandos básicos

```bash
go mod init mi-proyecto               # iniciar módulo
go mod tidy                           # limpiar y añadir dependencias
go get paquete                        # añadir dependencia
go build                              # compilar
go build -o salida                    # compilar con nombre específico
go run main.go                        # compilar y ejecutar
go test                               # ejecutar tests
go test -v ./...                      # tests de todos los paquetes
go vet                                # analizar código
go fmt                                # formatear código

# Instalar binarios (equivalente a cargo install)
go install github.com/xxx/yyy@latest
ls ~/go/bin/                          # los binarios se instalan aquí
```

### Ejemplo de go.mod

```
module github.com/usuario/mi-proyecto

go 1.23

require (
    github.com/gin-gonic/gin v1.10.0
    github.com/lib/pq v1.10.9
)
```

---

## Gem (Ruby)

### Instalación

```bash
# Ruby + Gem
sudo apt install ruby ruby-dev ruby-bundler   # Debian/Ubuntu
sudo pacman -S ruby                           # Arch
sudo dnf install ruby ruby-devel              # Fedora

ruby --version                           # Ruby 3.3.x
gem --version                            # Gem 3.5.x
```

### Comandos de Gem

```bash
gem list                                 # paquetes instalados
gem list --local                         # solo locales
gem install paquete                      # instalar gema
gem install paquete -v 1.2.3            # instalar versión específica
gem uninstall paquete                    # desinstalar
gem update paquete                       # actualizar
gem update --system                      # actualizar gem mismo
gem search texto                         # buscar gemas
gem environment                          # información del entorno
```

### Bundler

Gestor de dependencias de Ruby:

```bash
sudo gem install bundler

# En un proyecto:
# Crear Gemfile:
# source 'https://rubygems.org'
# gem 'rails'
# gem 'pg'

bundle install                           # instalar dependencias del Gemfile
bundle exec comando                      # ejecutar comando con las gemas del proyecto
bundle update                            # actualizar gemas
bundle outdated                          # gemas desactualizadas
```

---

## Tabla comparativa de gestores

| Lenguaje | Gestor | Archivo deps | Instalación global | Sandbox | Lockfile |
|---|---|---|---|---|---|
| JS/TS | npm | package.json | `npm install -g` | `node_modules/` | package-lock.json |
| JS/TS | yarn | package.json | `yarn global add` | `node_modules/` | yarn.lock |
| Rust | Cargo | Cargo.toml | `cargo install` | Compilación por crate | Cargo.lock |
| Python | pip | requirements.txt | `pip install --user` | `venv`/`poetry` | pip freeze |
| Python | poetry | pyproject.toml | `pipx` | Virtualenv automático | poetry.lock |
| Go | go mod | go.mod | `go install` | GOPATH/mod | go.sum |
| Ruby | gem | Gemfile | `gem install` | `bundle` | Gemfile.lock |

## Buenas prácticas

1. **No uses `sudo pip install`** — puede romper paquetes del sistema. Usa `--user`, `venv` o `pipx`.
2. **Usa `nvm` para Node.js** — los repos del sistema suelen tener versiones antiguas.
3. **Usa `rustup` para Rust** — gestiona múltiples toolchains (stable, nightly, beta).
4. **Commitea los lockfiles** (`Cargo.lock`, `package-lock.json`, `go.sum`) para builds reproducibles.
5. **No commitees `node_modules/`** — añádelo a `.gitignore`.
6. **Usa entornos virtuales** en Python (venv, poetry, conda) para aislar proyectos.

## Enlaces externos

- [nvm](https://github.com/nvm-sh/nvm) — gestor de versiones de Node.js
- [rustup](https://rustup.rs/) — gestor de versiones de Rust
- [crates.io](https://crates.io/) — registro de paquetes Rust
- [PyPI](https://pypi.org/) — registro de paquetes Python
- [pkg.go.dev](https://pkg.go.dev/) — registro de paquetes Go
- [rubygems.org](https://rubygems.org/) — registro de gemas Ruby

## Ver también

- [[Python en Linux]] — gestión de Python en profundidad
- [[Gestores de Paquetes]] — gestores del sistema (apt, pacman, dnf)
- [[Desarrollo en Linux (gcc make gdb strace)]] — herramientas de desarrollo

#programa #desarrollo
