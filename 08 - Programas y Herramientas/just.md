---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
---

# just

> Ejecutor de comandos tipo make. Definir tareas en `justfile` con syntax más simple que Make. Alternativa moderna a make para tareas de proyecto.

## Qué es

`just` es un ejecutor de comandos inspirado en Make pero con una syntax más limpia y orientada a desarrollo. Los `justfile` definen comandos que se ejecutan con `just nombre_tarea`.

| Característica | just | make |
|---|---|---|
| **Sintaxis** | Limpia, sin tabs | Requiere tabs, syntax de make |
| **Dependencias** | Opcional | Central |
| **Variables** | `$variable` | `$(variable)` |
| **Plataforma** | Multiplataforma | Multiplataforma |
| **Parsing** | Robusto | Propenso a errores |
| **Receta por defecto** | Primera o `default` | Primera |

## Instalación

```bash
# Arch Linux
sudo pacman -S just

# Debian/Ubuntu
sudo apt install just

# macOS
brew install just

# Cargo (cualquier plataforma)
cargo install just

# Verificar
just --version
```

## Sintaxis básica

```just
# justfile

# Comentario

# Tarea simple
build:
    cargo build --release

# Tarea con argumentos
greet nombre:
    echo "¡Hola, {{nombre}}!"

# Múltiples comandos
test:
    cargo test
    cargo clippy
    cargo fmt --check

# Tarea por defecto
default:
    @just --list

# Listar tareas
list:
    @just --list
```

## Variables

```just
# Variables locales
target := "x86_64-unknown-linux-gnu"
version := "1.0.0"

# Variables de entorno con fallback
profile := env_var_or_default("PROFILE", "dev")

# Uso
build:
    cargo build --target {{target}} --profile {{profile}}

# Argumentos con valores por defecto
greet nombre="Mundo":
    echo "¡Hola, {{nombre}}!"
```

## Dependencias

```just
# Dependencias lineales
deploy: build test
    ./deploy.sh

# Dependencias paralelas
all: build test lint

# Dependencias condicionales
release: build test
    cargo publish
```

## Características avanzadas

### Documentación

```just
# Documentación de tareas
[doc('Compilar el proyecto en modo release')]
build-release:
    cargo build --release

[doc('Ejecutar todos los tests')]
test:
    cargo test
```

### Condicionales

```just
# Detectar OS
[target.'cfg(target_os = "linux")']
install:
    sudo apt install myapp

[target.'cfg(target_os = "macos")']
install:
    brew install myapp
```

### Imports

```just
# Importar otro justfile
import './common.just'

# Cargar variables de .env
set dotenv-load

build:
    echo $DATABASE_URL
```

## Ejemplo completo

```just
# justfile para proyecto Rust
set dotenv-load

# Variables
binary := "mi-app"
target := "release"

# Tarea por defecto
default:
    @just --list

# Compilar
build:
    cargo build --{{target}}

# Test
test:
    cargo test

# Lint
lint:
    cargo clippy -- -D warnings
    cargo fmt -- --check

# Deploy
deploy: build test lint
    ./scripts/deploy.sh {{binary}}

# Dev server
dev:
    cargo watch -x run

# Limpiar
clean:
    cargo clean
    rm -rf target/

# Instalar globalmente
install: build
    cargo install --path .
```

## Just vs Make

| Make | Just | Ventaja |
|---|---|---|
| `target: deps` | `target: deps` | Just: más simple |
| `@echo` (silenciar) | `@echo` | Igual |
| `$(VAR)` | `{{VAR}}` | Just: más legible |
| `.PHONY` | No necesario | Just: más simple |
| `make -n` (dry run) | `just --evaluate` | Just: más potente |

## Casos de uso

- **Tareas de proyecto**: build, test, lint, deploy — más simple que Make.
- **Scripts multiplataforma**: funciona igual en Linux, macOS, Windows.
- **Proyectos de equipo**: justfile es auto-documentado con `just --list`.
- **CI/CD**: tareas que se ejecutan en pipelines.

## Ver también

- [[Compilacion desde Codigo Fuente]]
- [[DevOps]]
- [[git]]

#herramientas #tareas #just #make #automatizacion
