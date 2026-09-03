---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: alta
---

# Go y go mod

## Qué es

**Go** es un lenguaje compilado y tipado estáticamente creado por Google. Su gestor de paquetes integrado es **go mod** (desde Go 1.16, reemplazando el antiguo GOPATH). Descarga dependencias desde [pkg.go.dev](https://pkg.go.dev/).

## Instalación

```bash
# Desde repos del sistema
sudo apt install golang-go            # Debian/Ubuntu
sudo pacman -S go                     # Arch
sudo dnf install golang               # Fedora

# O desde la página oficial (versión más reciente)
wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
# Añadir /usr/local/go/bin al PATH
```

## GOPATH y módulos

```bash
# Go moderno (>1.16): módulos, no GOPATH
go version                            # go version go1.23.0 linux/amd64

# Variables de entorno
echo $GOPATH                          # ~/go por defecto
echo $GOROOT                          # /usr/local/go (o /usr/lib/go)
# Los binarios compilados van a $GOPATH/bin
```

## Comandos básicos

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

## Ejemplo de go.mod

```
module github.com/usuario/mi-proyecto

go 1.23

require (
    github.com/gin-gonic/gin v1.10.0
    github.com/lib/pq v1.10.9
)
```

## Buenas prácticas

1. **Usa módulos** (go mod) en lugar del antiguo GOPATH.
2. **Commitea `go.sum`** para verificaciones de integridad.
3. **No instales herramientas Go con apt** — usa `go install` para tener la última versión.

## Comparativa con alternativas

| Aspecto | Go | Rust (Cargo) | Node.js (npm) | Python (pip) | Ruby (Gem) |
|---|---|---|---|---|---|
| **Velocidad** | Muy rápida (compilado) | Muy rápida (compilado) | Lenta (interprete) | Lenta (interprete) | Lenta (interprete) |
| **Binarios** | ✅ Estáticos, 1 binario | ✅ Estáticos, 1 binario | ❌ Require runtime | ❌ Require runtime | ❌ Require runtime |
| **Gestor** | `go` (integrado) | `cargo` | `npm`/`pnpm`/`yarn` | `pip`/`poetry`/`uv` | `gem`/`bundler` |
| **Registro** | pkg.go.dev | crates.io | npmjs.com | pypi.org | rubygems.org |
| **Cross-compile** | ✅ `GOOS/GOARCH` trivial | ⚠️ `cross` | ❌ | ❌ | ❌ |
| **Curva aprendizaje** | Baja | Media | Baja | Baja | Baja |
| **Uso típico** | CLI, microservicios, DevOps | Sistemas, web, embebido | Web, scripts, APIs | ML, scripting, web | Web (Rails), scripts |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `command not found: go` | `PATH` sin el binario tras instalar | Añadir `export PATH=$PATH:/usr/local/go/bin` |
| `go build` descarga red lentamente | Red/proxy mal configurado | `go env -w GOPROXY=https://proxy.golang.org,direct` |
| `undefined: fmt` u otro paquete | No se importó el paquete | Añadir el `import "fmt"` correcto |
| `go.sum` desincronizado | Cambiaron hashes | `go mod tidy` |
| Compilación cruzada falla por CGO | Librerías del host | `CGO_ENABLED=0 go build` para builds estáticos |
| `no required module provides package` | Dependencia en `go.mod` faltante | `go get <paquete>` o `go mod tidy` |

## Ver también

- [[Node.js]] — gestor de paquetes de JavaScript
- [[Cargo]] — gestor de paquetes de Rust
- [[pip]] — gestor de paquetes de Python
- [[Gem]] — gestor de paquetes de Ruby
- [[Gestores de Paquetes]] — gestores del sistema (apt, pacman, dnf)

## Enlaces externos

- [pkg.go.dev](https://pkg.go.dev/) — registro de paquetes Go
- [Go dev](https://go.dev/) — sitio oficial

#programa #desarrollo
