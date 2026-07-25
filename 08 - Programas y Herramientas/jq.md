---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# jq

> Procesador JSON de línea de comandos. Corta, filtra, mapea y transforma datos JSON con una sintaxis tipo sed/awk. Esencial para trabajar con APIs REST desde la terminal.

## Qué es

`jq` es como `sed` para JSON: permite filtrar, transformar y dar formato a datos JSON. Es la herramienta estándar para procesar respuestas de APIs, archivos de configuración JSON y logs estructurados.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install jq

# Arch
sudo pacman -S jq

# Fedora
sudo dnf install jq

# Verificar
jq --version
```

## Ejemplos rápidos

```bash
# Formatear JSON (pretty-print)
curl -s https://api.github.com/users/octocat | jq .

# Extraer un campo
curl -s https://api.github.com/users/octocat | jq '.name'

# Array: primer elemento
curl -s https://api.github.com/users/octocat/repos | jq '.[0].name'

# Filtrar por condición
curl -s https://api.github.com/users/octocat/repos | jq '.[] | select(.fork == false) | .name'
```

## Ver también

- [[curl]] — cliente HTTP (a menudo pipeado a jq)
- [[httpie]] — cliente HTTP alternativo
- [[grep]] — búsqueda clásica en texto
- [[api]] — APIs REST

#programa #herramientas #json
