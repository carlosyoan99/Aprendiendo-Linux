---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# Entorno de desarrollo Linux

> Linux es el hábitat natural del desarrollo de software. Esta nota es una guía práctica para montar un entorno de desarrollo completo: desde el toolchain de cada lenguaje hasta contenedores, editores, bases de datos y buenas prácticas.

## Filosofía general

Antes de instalar nada, conviene entender cómo se organiza el desarrollo en Linux:

```
┌─────────────────────────────────────────────────────┐
│                   CAPA 1: SISTEMA                    │
│  gcc/clang, make, cmake, system headers, glibc      │
├─────────────────────────────────────────────────────┤
│                   CAPA 2: LENGUAJES                  │
│  Python, Node.js, Rust, Go, Java, Ruby              │
│  Gestores: pyenv/nvm/rustup/gvm/rbenv               │
├─────────────────────────────────────────────────────┤
│                   CAPA 3: PROYECTOS                  │
│  Editores (VSCode, Zed, Helix, Vim)                 │
│  Git, Docker, bases de datos locales                │
│  Task runners, linters, formatters                  │
├─────────────────────────────────────────────────────┤
│                   CAPA 4: AISLAMIENTO                │
│  Entornos virtuales (venv, .node_modules)           │
│  Contenedores (Docker, Podman, Dev Containers)       │
│  Múltiples versiones (pyenv, nvm, rustup)           │
└─────────────────────────────────────────────────────┘
```

**Regla de oro**: No instales herramientas de desarrollo globalmente con `sudo` si existe una alternativa aislada. Usa gestores de versiones (`nvm`, `pyenv`, `rustup`) y entornos virtuales (`venv`, `node_modules/`, contenedores).

---

## 1. Toolchain base del sistema

El toolchain C/C++ es la base sobre la que se construyen casi todos los demás lenguajes:

```bash
# ── Debian / Ubuntu ──
sudo apt install build-essential         # gcc, g++, make, libc-dev
sudo apt install manpages-dev            # documentación (man 3 printf, etc.)
sudo apt install linux-headers-$(uname -r)  # headers del kernel

# ── Arch Linux ──
sudo pacman -S base-devel                # gcc, make, autoconf, pkg-config...

# ── Fedora ──
sudo dnf groupinstall "Development Tools"
sudo dnf install gcc gcc-c++ make
```

| Herramienta | Propósito | Alternativa moderna |
|---|---|---|
| **gcc/g++** | Compilador C/C++ | **clang** (LLVM) — errores más claros |
| **make** | Automatización de builds | **CMake** + **Ninja** (más portable y rápido) |
| **gdb** | Depurador | **lldb** (LLVM), **rr** (grabación/reproducción) |
| **strace** | Traza de llamadas al sistema | **bpftrace** (eBPF) |
| **valgrind** | Detección de fugas de memoria | **AddressSanitizer** (`-fsanitize=address`) |
| **ldd** | Dependencias de librerías dinámicas | **(misma)** |

> ⚡ Detalle importante: `build-essential` en Debian/Ubuntu instala la **versión del sistema** de estos tools. Si necesitas una versión más reciente de gcc o clang, instálala aparte (ver sección C/C++ abajo).

---

## 2. Stacks por lenguaje

### 🐍 Python

Python viene **preinstalado** en prácticamente todas las distribuciones, pero **NO uses el Python del sistema para desarrollo** (el sistema lo usa para apt, GNOME Software, etc.).

```bash
# Gestor de versiones
curl https://pyenv.run | bash
pyenv install 3.12.5                   # instalar Python específico
pyenv global 3.12.5                    # establecer versión global

# Gestor de paquetes moderno (uv — escrito en Rust, 10-100x más rápido que pip)
curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv                                # crear entorno virtual (instantáneo)
uv pip install flask                   # instalar dependencia

# O con poetry (gestor de proyectos completo)
pipx install poetry
poetry new mi-proyecto
cd mi-proyecto && poetry add flask

# Herramientas de desarrollo Python
pipx install black                     # formateador
pipx install ruff                      # linter + formateador (Rust)
pipx install mypy                      # type checker
pipx install pytest                    # test runner
pipx install pre-commit                # hooks de git
```

**Estructura típica de proyecto Python**:
```
mi-proyecto/
├── .venv/                 # Entorno virtual (no se commitea)
├── src/
│   └── mi_proyecto/
│       ├── __init__.py
│       └── main.py
├── tests/
│   └── test_main.py
├── pyproject.toml         # Configuración del proyecto
├── requirements.txt       # Dependencias (alternativa a pyproject.toml)
├── .gitignore
└── README.md
```

### 🟩 Node.js / JavaScript

```bash
# Gestor de versiones (recomendado sobre el paquete del sistema)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install --lts                      # instalar última LTS
nvm use --lts

# Gestores de paquetes
npm init                               # crear package.json
npm install express                    # instalar dependencia

# pnpm (más rápido, usa hard links — ahorra espacio en disco)
npm install -g pnpm
pnpm install
pnpm add express

# Herramientas globales
npm install -g typescript              # compilador TS
npm install -g eslint                  # linter
npm install -g prettier                # formateador
```

**Estructura típica de proyecto Node.js**:
```
mi-proyecto/
├── node_modules/          # Dependencias (no se commitea)
├── src/
│   ├── index.ts
│   └── app.ts
├── tests/
├── package.json
├── tsconfig.json
├── .gitignore
└── README.md
```

### 🦀 Rust

```bash
# Gestor de versiones (recomendado)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
rustup component add rust-analyzer      # LSP
rustup component add clippy             # linter
rustup component add rustfmt            # formateador

# Comandos de Cargo
cargo new mi-proyecto
cd mi-proyecto && cargo run             # compilar y ejecutar
cargo add serde --features derive       # añadir dependencia
cargo test                              # ejecutar tests
cargo clippy                            # lintear
cargo fmt                               # formatear
```

**Estructura típica de proyecto Rust**:
```
mi-proyecto/
├── src/
│   └── main.rs
├── tests/
├── Cargo.toml
├── Cargo.lock              # Lockfile (SI se commitea)
├── .gitignore
└── README.md
```

### 🔵 Go

```bash
# Instalación
wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
# Añadir /usr/local/go/bin al PATH

# Comandos
go mod init mi-proyecto                 # iniciar módulo
go mod tidy                             # limpiar dependencias
go build -o ./bin/app .                 # compilar
go run .                                # compilar y ejecutar
go test ./...                           # ejecutar todos los tests
go vet ./...                            # analizar código
```

### ☕ Java

```bash
# Instalar JDK (OpenJDK recomendado)
sudo apt install openjdk-21-jdk         # Debian/Ubuntu
sudo pacman -S jdk21-openjdk            # Arch

# O con SDKMAN (gestor de versiones para JDKs)
curl -s "https://get.sdkman.io" | bash
sdk install java 21-open                # instalar JDK 21
sdk install maven                       # gestor de builds
sdk install gradle                      # alternativa a Maven
sdk install springboot                  # Spring Boot CLI

# Maven
mvn archetype:generate -DgroupId=com.ejemplo -DartifactId=mi-app -DarchetypeArtifactId=maven-archetype-quickstart
mvn clean compile test package

# Gradle
gradle init --type java-application
gradle build
```

### 💎 Ruby

```bash
# Gestor de versiones
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
rbenv install 3.3.5
rbenv global 3.3.5

# Gestor de paquetes
gem install bundler
# Crear Gemfile:
#   source 'https://rubygems.org'
#   gem 'rails'
bundle install
bundle exec rails new mi-app
```


## 3. Testing frameworks por lenguaje

Cada lenguaje tiene su ecosistema de testing. Esta sección cubre los frameworks principales, cómo ejecutar tests y buenas prácticas para cada stack.

### Tabla rápida

| Lenguaje | Framework unitario | Framework BDD/integrado | Cobertura | Mocking |
|---|---|---|---|---|
| **Python** | pytest | behave (BDD), tox (multi-version) | pytest-cov | unittest.mock, pytest-mock |
| **JavaScript/TS** | Vitest / Jest / Mocha | Playwright, Cypress (E2E) | c8, Istanbul | vi.fn() (Vitest), jest.mock() |
| **Rust** | cargo test (integrado) | — | tarpaulin, llvm-cov | mockall |
| **Go** | go test (integrado) | — (testing package nativo) | go test -coverprofile | interfaces + testify/mock |
| **Java** | JUnit 5 | Cucumber (BDD), Testcontainers (integración) | JaCoCo | Mockito, EasyMock |
| **Ruby** | RSpec (BDD) / Minitest | Capybara (E2E), Cucumber | simplecov | RSpec mocks, webmock |
| **C/C++** | Google Test (Catch2, CTest) | — | gcov, lcov | Google Mock |

---

### 🐍 Python — pytest

pytest es el estándar de facto. Se puede usar para tests unitarios, de integración y funcionales.

```bash
# Instalación
pipx install pytest
pipx install pytest-cov                 # cobertura
pipx install pytest-xdist                # tests en paralelo

# Ejecución
pytest                                 # descubre tests en tests/ y archivos test_*.py
pytest -v                               # verbose
pytest -x                               # parar al primer fallo
pytest -k "login"                       # filtrar por nombre
pytest --cov=src tests/                  # con cobertura
pytest -n auto                          # paralelo (xdist)
pytest --last-failed                    # solo tests que fallaron

# Test básico
# test_math.py
def test_suma():
    assert 1 + 1 == 2

# Test con fixtures
# test_api.py (usando pytest + requests)
import pytest
import requests

def test_health_endpoint():
    response = requests.get("http://localhost:3000/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"
```

**Configuración en pyproject.toml**:
```toml
[tool.pytest.ini_options]
minversion = "8.0"
testpaths = ["tests"]
pythonpath = ["src"]
markers = [
    "slow: tests lentos (deseleccionar con -m 'not slow')",
    "integration: tests que requieren base de datos",
]
```

```bash
pytest -m "not slow"                     # saltar tests lentos
pytest -m "integration"                  # solo tests de integración
```

---

### 🟩 JavaScript / TypeScript — Vitest / Jest

**Vitest** es el framework moderno para proyectos Vite/TypeScript (compatible con Jest API, más rápido). **Jest** sigue siendo el más usado en proyectos legacy.

```bash
# Vitest (recomendado para proyectos nuevos)
npm install -D vitest

# Jest (estándar consolidado)
npm install -D jest ts-jest @types/jest

# Playwright (E2E — pruebas de navegador)
npm install -D @playwright/test
npx playwright install                   # descarga navegadores
```

**Vitest ejemplo**:
```typescript
// src/suma.ts
export function suma(a: number, b: number): number {
  return a + b;
}

// tests/suma.test.ts
import { describe, it, expect } from 'vitest';
import { suma } from '../src/suma';

describe('suma', () => {
  it('suma dos números positivos', () => {
    expect(suma(2, 3)).toBe(5);
  });

  it('suma números negativos', () => {
    expect(suma(-1, -2)).toBe(-3);
  });
});
```

**package.json**:
```json
{
  "scripts": {
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "test:e2e": "playwright test"
  }
}
```

---

### 🦀 Rust — cargo test

Rust tiene testing **integrado en el compilador**. No necesita framework externo para tests unitarios. Para integración, se usa el directorio `tests/`.

```bash
# Ejecución
cargo test                              # todos los tests
cargo test -- --nocapture               # mostrar stdout (println!)
cargo test nombre_test                  # filtrar por nombre
cargo test --test integration_test      # solo tests de integración
cargo test -- --ignored                  # tests marcados como #[ignore]

# Cobertura
cargo install cargo-tarpaulin
cargo tarpaulin --out Html
```

```rust
// src/lib.rs (test unitario — integrado)
pub fn suma(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_suma_positivos() {
        assert_eq!(suma(2, 3), 5);
    }

    #[test]
    fn test_suma_negativos() {
        assert_eq!(suma(-1, -2), -3);
    }

    #[test]
    #[should_panic(expected = "división por cero")]
    fn test_division_cero() {
        dividir(1, 0);
    }
}

// tests/integration_test.rs (test de integración)
use mi_crate::suma;

#[test]
fn test_suma_desde_integracion() {
    assert_eq!(suma(10, 20), 30);
}
```

---

### 🔵 Go — go test

Go también tiene testing **integrado** en el toolchain. Sin frameworks externos para lo básico.

```bash
# Ejecución
go test ./...                           # tests de todos los paquetes
go test -v                              # verbose
go test -run TestSuma                   # filtrar

go test -cover                          # cobertura
go test -coverprofile=coverage.out
go tool cover -html=coverage.out        # ver en navegador

go test -bench .                        # benchmarks
go test -fuzz .                         # fuzzing (Go 1.18+)
```

```go
// math.go
package math

func Suma(a, b int) int {
    return a + b
}

// math_test.go
package math

import "testing"

func TestSuma(t *testing.T) {
    got := Suma(2, 3)
    want := 5
    if got != want {
        t.Errorf("Suma(2,3) = %d; want %d", got, want)
    }
}

func TestSumaTabla(t *testing.T) {
    tests := []struct {
        name string
        a, b int
        want int
    }{
        {"positivos", 2, 3, 5},
        {"negativos", -1, -2, -3},
        {"cero", 0, 0, 0},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            if got := Suma(tt.a, tt.b); got != tt.want {
                t.Errorf("Suma(%d,%d) = %d; want %d", tt.a, tt.b, got, tt.want)
            }
        })
    }
}
```

---

### ☕ Java — JUnit 5

JUnit 5 es el estándar para tests unitarios en Java. Con Mockito para mocking y Testcontainers para tests de integración con bases de datos.

```bash
# Dependencias Maven (pom.xml):
# <dependency>
#   <groupId>org.junit.jupiter</groupId>
#   <artifactId>junit-jupiter</artifactId>
#   <version>5.11</version>
#   <scope>test</scope>
# </dependency>
# <dependency>
#   <groupId>org.mockito</groupId>
#   <artifactId>mockito-core</artifactId>
#   <scope>test</scope>
# </dependency>
# <dependency>
#   <groupId>org.testcontainers</groupId>
#   <artifactId>postgresql</artifactId>
#   <scope>test</scope>
# </dependency>

# Ejecución (Maven)
mvn test                                # ejecuta todos los tests
mvn test -Dtest=ClaseTest               # filtrar por clase
mvn test -Dtest=*ServiceTest            # patrón
mvn verify                              # incluye tests de integración

# Gradle
gradle test
gradle test --tests "*ServiceTest"
gradle test --info
```

```java
// src/test/java/com/ejemplo/MathTest.java
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

class MathTest {

    @BeforeEach
    void setUp() {
        // preparar antes de cada test
    }

    @Test
    @DisplayName("Suma de dos números positivos")
    void testSuma() {
        assertEquals(5, Math.add(2, 3));
    }

    @Test
    void testDivisionPorCero() {
        assertThrows(ArithmeticException.class, () -> {
            Math.divide(1, 0);
        });
    }

    @Nested
    @DisplayName("Tests de resta")
    class RestaTests {
        @Test
        void testResta() {
            assertEquals(1, Math.subtract(3, 2));
        }
    }
}
```

---

### 💎 Ruby — RSpec

RSpec es el framework BDD estándar de Ruby. Minitest viene incluido en Ruby y es más simple.

```bash
# Gemfile
group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'               # fábricas de datos
  gem 'shoulda-matchers'                # matchers adicionales
  gem 'capybara'                        # tests de navegador
end

bundle install
rails generate rspec:install            # inicializar (Rails)

# Ejecución
rspec                                   # todos los tests
rspec spec/models                       # por carpeta
rspec spec/models/user_spec.rb:25       # línea específica
rspec --tag slow                        # solo tests con tag :slow
```

```ruby
# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe '#full_name' do
    it 'returns the full name' do
      user = User.new(first_name: 'Juan', last_name: 'Pérez')
      expect(user.full_name).to eq('Juan Pérez')
    end
  end

  context 'when user is admin' do
    it 'has admin privileges' do
      user = build(:user, role: :admin)
      expect(user).to be_admin
    end
  end
end
```

---

### 🔧 C/C++ — Google Test

```bash
# Instalación
sudo apt install libgtest-dev           # Google Test
sudo apt install cmake                  # para compilar tests

# O con CMake FetchContent (más moderno)
# CMakeLists.txt:
# include(FetchContent)
# FetchContent_Declare(
#   googletest
#   URL https://github.com/google/googletest/archive/refs/tags/v1.15.0.zip
# )
# FetchContent_MakeAvailable(googletest)
#
# add_executable(test_suite test_main.cpp)
# target_link_libraries(test_suite GTest::gtest_main)
# enable_testing()
# add_test(NAME test_suite COMMAND test_suite)

# Ejecución
cmake -B build && cmake --build build
./build/test_suite
ctest                                  # si usas CTest (CMake)
```

```cpp
// test_main.cpp
#include <gtest/gtest.h>

int suma(int a, int b) { return a + b; }

TEST(SumaTest, Positivos) {
    EXPECT_EQ(suma(2, 3), 5);
}

TEST(SumaTest, Negativos) {
    EXPECT_EQ(suma(-1, -2), -3);
}

class MathTest : public ::testing::Test {
protected:
    void SetUp() override {
        // se ejecuta antes de cada TEST_F
    }
};

TEST_F(MathTest, Resta) {
    EXPECT_EQ(10 - 3, 7);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
```

---

### Buenas prácticas de testing (general)

| Práctica | Descripción |
|---|---|
| **Unitario vs Integración** | Tests unitarios: rápidos, sin E/S. Tests de integración: con BD, API, red. Separarlos en carpetas o con tags |
| **AAA Pattern** | Arrange (preparar) → Act (ejecutar) → Assert (verificar) |
| **Nomenclatura** | `test_[nombre]_[escenario]_[resultado]` o `should_[comportamiento]` |
| **Cobertura** | Apunta a >80% en código crítico, pero no obsesionarse con el 100% |
| **CI/CD** | Ejecutar tests en cada push. `pre-commit` para tests rápidos, CI para la suite completa |
| **Fixtures** | Usar fábricas (FactoryBot, factory_boy) o builders, no datos del sistema real |
| **Tests flaky** | Test que a veces falla sin razón → aislar, mockear E/S, o marcarlo como `#[ignore]` |

---

## 4. Contenedores para desarrollo

### Docker

Instalar Docker y usarlo como entorno de desarrollo aislado:

```bash
# Instalación oficial
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER          # añadir usuario al grupo docker

# Docker Compose (plugin)
sudo apt install docker-compose-plugin  # Debian/Ubuntu 22.04+

# Ejemplo de docker-compose.yml para desarrollo:
# services:
#   app:
#     build: .
#     volumes:
#       - .:/app          # montar código local
#     ports:
#       - "3000:3000"
#   db:
#     image: postgres:16
#     environment:
#       POSTGRES_PASSWORD: devpassword
```

### Dev Containers (VS Code + GitHub Codespaces)

Los Dev Containers definen entornos completos (lenguaje, herramientas, extensiones) en un archivo `.devcontainer/devcontainer.json`:

```json
{
  "name": "Python 3.12",
  "image": "mcr.microsoft.com/devcontainers/python:3.12",
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
  "extensions": ["ms-python.python", "charliermarsh.ruff"],
  "postCreateCommand": "pip install --upgrade pip"
}
```

Ventajas:
- Entorno **reproducible** para todo el equipo
- Sin contaminar el sistema anfitrión
- Funciona en local y en la nube (Codespaces)
- Cada proyecto puede tener su propio toolchain

### Podman — alternativa a Docker sin daemon

```bash
sudo apt install podman                 # Debian/Ubuntu
sudo pacman -S podman                   # Arch

# Uso idéntico a Docker:
podman run -it --rm ubuntu:22.04 bash
podman compose up -d                    # con docker-compose
```

---

## 5. Editores e IDEs

| Editor | Ideal para | Rendimiento | LSP | Depurador |
|---|---|---|---|---|
| **[[Editores de código (VSCode Codium Zed Helix Antigravity)\|VS Code]]** | Cualquier lenguaje, Dev Containers | Medio (Electron) | ✅ | ✅ |
| **[[Editores de código (VSCode Codium Zed Helix Antigravity)\|Zed]]** | Proyectos grandes, GPU-accelerado | Alto (Rust+GPU) | ✅ | ✅ |
| **[[Editores de código (VSCode Codium Zed Helix Antigravity)\|Helix]]** | Programación modal, Rust | Alto (Rust) | ✅ Nativo | ❌ (GDB externo) |
| **[[Vim Neovim]]** | Usuarios avanzados, terminal | Máximo | ✅ (plugins) | ✅ (vimspector) |
| **IntelliJ IDEA** | Java/Kotlin, Android | Medio (JVM) | Nativo | ✅ |

**Configuración básica post-instalación** para cualquier editor:
1. Instalar LSP para los lenguajes que uses (rust-analyzer, pyright, typescript-language-server, clangd, gopls)
2. Configurar formateo automático al guardar
3. Activar linting en tiempo real
4. Configurar terminal integrada (bash/fish + tmux)

---

## 6. Terminal y multiplexores

```bash
# Terminal moderna con GPU-acceleración
# Alacritty, Kitty, WezTerm o Foot (Wayland)

# Shell moderna (alternativa a bash)
sudo apt install fish                   # autosugerencias + completado
sudo pacman -S fish
chsh -s /usr/bin/fish                   # cambiar shell por defecto

# Multiplexor (esencial para desarrollo)
sudo apt install tmux                   # múltiples sesiones en una terminal
# O alternativas modernas:
# - zellij (Rust, más amigable que tmux)
# - screen (clásico, viene instalado)
```

---

## 7. Bases de datos locales para desarrollo

```bash
# Usar contenedores para bases de datos (no instalar en el sistema):

# PostgreSQL
docker run -d --name pg-dev \
  -e POSTGRES_PASSWORD=dev \
  -p 5432:5432 \
  postgres:16

# MySQL / MariaDB
docker run -d --name mysql-dev \
  -e MYSQL_ROOT_PASSWORD=dev \
  -p 3306:3306 \
  mysql:8

# Redis (caché / colas)
docker run -d --name redis-dev \
  -p 6379:6379 \
  redis:7

# SQLite (embebida, no necesita servidor)
sudo apt install sqlite3                # cliente CLI
```

**Alternativa**: Usar **Podman** en vez de Docker para ejecución sin root de los contenedores.

---

## 8. Git y control de versiones

```bash
# Configuración inicial
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
git config --global init.defaultBranch main
git config --global pull.rebase true    # rebase por defecto al hacer pull

# Herramientas Git avanzadas
sudo apt install git-lfs                # archivos grandes (modelos ML, assets)
sudo apt install tig                    # explorador de Git en terminal
sudo apt install gh                     # GitHub CLI (PRs, issues, codespaces)
```

**Flujo de trabajo recomendado para desarrollo**:
```
1. git checkout -b feature/nombre      # rama por feature
2. git add -p                          # añadir cambios interactivamente
3. git commit -m "feat: descripción"   # commits atómicos
4. git push -u origin feature/nombre   # subir rama
5. Crear PR en GitHub / GitLab         # revisión de código
6. git checkout main && git pull       # actualizar main
7. git branch -d feature/nombre        # limpiar rama local
```

---

## 9. Dockerfile de desarrollo multi-etapa (ejemplo completo)

```dockerfile
# Dockerfile de desarrollo para Python + Node.js
FROM python:3.12-slim AS base

RUN apt-get update && apt-get install -y \
    curl git make gcc g++ \
    && rm -rf /var/lib/apt/lists/*

# Node.js (instalado dentro del contenedor)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pnpm

# Usuario no-root
RUN useradd -m dev
USER dev
WORKDIR /workspace

# Herramientas de desarrollo
RUN pip install --user --upgrade pip \
    && pip install --user black ruff mypy pytest

COPY --chown=dev:dev . .
RUN pip install --user -r requirements.txt

CMD ["bash"]
```

---

## 10. Checklist: entorno de desarrollo completo

Al instalar Linux para desarrollo, este es el orden recomendado:

- [ ] **Toolchain base**: `build-essential`, `manpages-dev`
- [ ] **Git**: instalar, configurar nombre/email, generar clave SSH
- [ ] **Shell**: instalar fish/zsh, configurar prompt + aliases
- [ ] **Terminal**: Alacritty/Kitty/WezTerm
- [ ] **Multiplexor**: tmux o zellij
- [ ] **Gestores de versiones**: nvm, pyenv, rustup, sdkman (según lenguajes)
- [ ] **Editor**: VS Code / Zed / Helix + LSPs + extensiones
- [ ] **Docker**: instalar, grupo docker, Docker Compose
- [ ] **Bases de datos locales**: contenedores PostgreSQL, Redis, etc.
- [ ] **Herramientas auxiliares**: `httpie`, `jq`, `ripgrep`, `fd`, `bat`, `htop`
- [ ] **Pre-commit hooks**: `pipx install pre-commit` + configuración
- [ ] **.dotfiles**: gestionar con Git + stow (ver [[XDG Base Directory y dotfiles modernos]])

---

## 11. Troubleshooting común

| Problema | Causa | Solución |
|---|---|---|
| `gcc: command not found` | build-essential no instalado | `sudo apt install build-essential` |
| `node: command not found` | NVM no activado | `nvm use --lts` o cargar nvm en `.bashrc` |
| `Permission denied` al instalar con pip | Usando `pip` sin `--user` | Usar `--user`, `venv`, o `pipx` |
| Docker: `permission denied` | Usuario no en grupo docker | `sudo usermod -aG docker $USER && newgrp docker` |
| `command not found: cargo` | Rust no en PATH | `source ~/.cargo/env` o añadir a `.bashrc` |
| `ModuleNotFoundError` al importar | Entorno virtual no activado | Activar `.venv/bin/activate` |
| `EACCES` al hacer `npm install -g` | Permisos de npm global | Usar `nvm` (instala en home) o configurar prefix |
| LSP no funciona en editor | LSP no instalado para el lenguaje | Instalar con gestor del lenguaje (rust-analyzer, pyright, etc.) |

---

## 12. Flujo completo: de cero a proyecto funcionando

```bash
# ── 1. Instalar toolchain ──
sudo apt update && sudo apt install build-essential curl git docker.io

# ── 2. Gestor de versiones + lenguaje ──
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# ── 3. Crear proyecto ──
cargo new mi-api
cd mi-api

# ── 4. Añadir dependencias ──
cargo add actix-web
cargo add serde --features derive
cargo add tokio --features full

# ── 5. Desarrollar ──
cargo run                                 # en una terminal
# En otra terminal:
curl http://localhost:8080/health          # probar endpoint

# ── 6. Testear ──
cargo test
cargo clippy                              # lintear
cargo fmt                                 # formatear

# ── 7. Contenerizar ──
# Crear Dockerfile + .dockerignore
docker build -t mi-api .
docker run -d -p 8080:8080 mi-api
```

---

## Ver también

- [[Desarrollo en Linux (gcc make gdb strace)]] — toolchain C/C++ en profundidad
- [[Python en Linux]] — gestión de Python, entornos virtuales, pip, poetry, uv
- [[Lenguajes y gestores (Node.js Cargo PIP Go Gem)]] — comparativa de gestores por lenguaje
- [[Editores de código (VSCode Codium Zed Helix Antigravity)]] — elegir editor según perfil
- [[La Shell]] — fundamentos de la terminal para desarrollo
- [[Git]] — control de versiones
- [[Contenedores]] — Docker, Podman, LXC
- [[Docker]] — build, ship, run
- [[Compilación desde Código Fuente]] — compilar programas manualmente
- [[Variables de Entorno y PATH]] — gestionar rutas de herramientas

## Enlaces externos

- [GitHub — nvm](https://github.com/nvm-sh/nvm)
- [GitHub — pyenv](https://github.com/pyenv/pyenv)
- [rustup.rs](https://rustup.rs/)
- [SDKMAN](https://sdkman.io/)
- [Dev Containers](https://containers.dev/)
- [Docker Dev Environments](https://docs.docker.com/desktop/dev-environments/)
- [The Twelve-Factor App](https://12factor.net/) — buenas prácticas para apps

#programa #desarrollo
