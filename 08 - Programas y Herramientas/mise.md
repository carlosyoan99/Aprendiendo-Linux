---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: baja
---

# mise

> Gestor de versiones universal (reemplaza nvm, pyenv, rbenv, goenv). Una sola herramienta para gestionar versiones de Node, Python, Ruby, Go, Java, Rust y más.

## Qué es

- Herramienta escrita en Rust que instala, gestiona y activa **versiones de lenguajes y herramientas** a nivel de proyecto o de usuario.
- Lee archivos de configuración (`.mise.toml`, `.mise.local.toml`, `mise.toml`) y define qué versión usar en cada directorio, descargando la versión elegida automáticamente.
- Es un **sustituto moderno** de *asdf* y de los gestores individuales (nvm, pyenv, rbenv). Usa shims en el `PATH` que redirigen al binario correcto según el directorio de trabajo.
- Compatible con plugins de asdf y con `rtx` (su predecesor); también sirve como gestor de *shims* y de paquetes (modo análogo a npm/nix para binarios cargo, nomad, etc.).

## Instalación

```bash
sudo pacman -S mise          # Arch / CachyOS
curl https://mise.run | sh   # instalador oficial (cualquier distro)
sudo apt install mise        # Debian/Ubuntu (según repo)
brew install mise            # macOS/Linux (Homebrew)
```

Tras instalar, añadir al shell (Iniciación):

```bash
echo 'eval "$(mise activate bash)"' >> ~/.bashrc
```

## Sintaxis

```bash
mise [comando]
```

## Comandos principales

| Comando | Descripción |
|---|---|
| `mise install` | Instalar herramientas desde .mise.toml |
| `mise use node@22` | Cambiar versión de Node |
| `mise use python@3.12` | Cambiar versión de Python |
| `mise ls` | Ver versiones instaladas |
| `mise ls-remote node` | Ver versiones disponibles |
| `mise trust` | Confiar en .mise.toml del proyecto |
| `mise uninstall node@20` | Desinstalar una versión |
| `mise exec node -- node --version` | Ejecutar con versión puntual sin cambiar |

## Ejemplos

```bash
mise use --global node@22 python@3.12
mise install
mise trust .mise.toml
mise use node@20          # versión local solo en este directorio
```

## Archivo de configuración

```toml
# .mise.toml
[tools]
node = "22"
python = "3.12"
ruby = "3.3"
```

## mise vs asdf vs gestores individuales

| Aspecto | mise | asdf | nvm/pyenv |
|---|---|---|---|
| Lenguaje | 1 (Rust) | 1 | 1 por herramienta |
| Velocidad | Muy rápido | Lento | Suficiente |
| Config | `.mise.toml` TOML | `.tool-versions` | scripts shell |
| Instalación paralela | Sí | Sí | Sí |
| Curva | Media | Media | Baja |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `mise: command not found` | No se añadió al shell | Añadir `eval "$(mise activate bash)"` a `~/.bashrc` |
| Usa una versión errónea | `.mise.toml` sin `trust` o shim mal | `mise trust` y reabrir terminal |
| Versión no encontrada | Nombre mal (ej. `node@lts`) | Usar una versión exacta con `mise ls-remote` |

## Ver también

- [[Entorno de desarrollo Linux]], [[Node.js]], [[Cargo]], [[pip]], [[Go]], [[Gem]]

#programa #devops
