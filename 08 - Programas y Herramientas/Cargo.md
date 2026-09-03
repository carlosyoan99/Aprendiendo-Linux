---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: alta
---

# Cargo (Rust)

## Qué es

**Cargo** es el gestor de paquetes y sistema de compilación de **Rust**. Descarga dependencias desde [crates.io](https://crates.io/), compila tu código y gestiona versiones. Es equivalente a npm + webpack en JavaScript, o pip + setuptools en Python, pero todo en uno.

## Instalación de Rust

```bash
# Recomendado: rustup (gestor de versiones)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup update                         # actualizar Rust
rustc --version                       # compilador
cargo --version                       # gestor de paquetes

# O desde repos (suele estar desactualizado):
sudo apt install rustc cargo          # Debian/Ubuntu
sudo pacman -S rust rustup            # Arch
```

## Comandos básicos de Cargo

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

## Cargo.toml (ejemplo)

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

## Crates.io y cargo install

```bash
# Buscar paquetes: https://crates.io/

# Instalar binarios desde crates.io (equivalente a npm install -g)
cargo install ripgrep                 # instalar rg (búsqueda de texto)
cargo install bat                     # instalar bat (cat con syntax highlight)
cargo install fd-find                 # instalar fd (find moderno)

# Los binarios se instalan en ~/.cargo/bin/
ls ~/.cargo/bin/
```

## Buenas prácticas

1. **Usa `rustup`** — gestiona múltiples toolchains (stable, nightly, beta).
2. **Commitea `Cargo.lock`** para builds reproducibles en proyectos binarios.
3. **No commitees `target/`** — añádelo a `.gitignore`.

## Ver también

## Comparativa con alternativas

| Aspecto | Cargo | npm | pip | go | gem |
|---|---|---|---|---|---|
| **Gestión de deps** | ✅ `Cargo.lock` determinista | ✅ `package-lock.json` | ⚠️ `requirements.txt` o `poetry.lock` | ✅ `go.sum` | ✅ `Gemfile.lock` |
| **Compilación** | ✅ Integrada (build.rs) | ❌ | ❌ | ✅ Integrada | ❌ |
| **Tests** | ✅ `cargo test` integrado | ⚠️ `npm test` | ⚠️ `pytest` externo | ✅ `go test` | ⚠️ `rspec` externo |
| **Cross-compile** | ✅ `cross` | ❌ | ❌ | ✅ `GOOS/GOARCH` | ❌ |
| **Docs** | ✅ `cargo doc` → docs.rs | ⚠️ readthedocs | ⚠️ pypi.org | ✅ `go doc` | ⚠️ rdoc |
| **Velocidad binarios** | Muy rápida | Lenta (JS) | Lenta (Python) | Muy rápida | Lenta (Ruby) |
| **Ideal para** | Rust systems/web/CLI | JavaScript full-stack | Python ML/Scripting | Go CLI/DevOps | Ruby on Rails |

- [[Node.js]] — gestor de paquetes de JavaScript
- [[pip]] — gestor de paquetes de Python
- [[Go]] — gestor de módulos de Go
- [[Gem]] — gestor de paquetes de Ruby
- [[Rust for Linux]] — Rust en el kernel de Linux
- [[Gestores de Paquetes]] — gestores del sistema (apt, pacman, dnf)

## Enlaces externos

- [rustup](https://rustup.rs/) — gestor de versiones de Rust
- [crates.io](https://crates.io/) — registro de paquetes Rust
- [Cargo Book](https://doc.rust-lang.org/cargo/) — documentación oficial

#programa #desarrollo
