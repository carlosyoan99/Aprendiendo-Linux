---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# mise

> Gestor de versiones universal (reemplaza nvm, pyenv, rbenv, goenv). Un solo工具 para gestionar versiones de Node, Python, Ruby, Go, Java, Rust y más.

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

## Ejemplos

```bash
mise use --global node@22 python@3.12
mise install
mise trust .mise.toml
```

## Archivo de configuración

```toml
# .mise.toml
[tools]
node = "22"
python = "3.12"
ruby = "3.3"
```

## Ver también

- [[Entorno de desarrollo Linux]], [[Node.js]], [[Cargo]], [[pip]], [[Go]], [[Gem]]

#programa #devops
