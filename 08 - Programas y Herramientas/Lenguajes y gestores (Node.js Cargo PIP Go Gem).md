---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# Lenguajes y gestores de paquetes

## Visión general

Cada lenguaje de programación tiene su propio gestor de paquetes (y a veces varios). En Linux, estos gestores se integran con el sistema de paquetes nativo (apt, pacman, dnf) pero tienen sus propias reglas y peculiaridades.

## Notas individuales

Cada gestor tiene ahora su propia nota:

- [[Node.js]] — Node.js, npm, yarn y pnpm
- [[Cargo]] — Rust, Cargo, crates.io
- [[pip]] — Python, pip, pyenv, entornos virtuales, pipx
- [[Go]] — Go, go mod, go install
- [[Gem]] — Ruby, Gem, Bundler

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
