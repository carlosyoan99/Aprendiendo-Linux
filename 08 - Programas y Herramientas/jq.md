---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-08-30
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

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install jq` |
| Arch | `sudo pacman -S jq` |
| Fedora | `sudo dnf install jq` |
| Alpine | `sudo apk add jq` |
| macOS | `brew install jq` |

## Filtros avanzados

```bash
# Construir objetos nuevos
curl -s api | jq '{nombre: .name, email: .email}'

# Convertir array a objeto
echo '[{"k":"a","v":1},{"k":"b","v":2}]' | jq 'from_entries'

# Agrupar por campo
curl -s api | jq 'group_by(.type) | map({type: .[0].type, count: length})'

# Reducir/sumar
echo '[1,2,3,4]' | jq 'add'    # → 10

# Condiciones
curl -s api | jq '.[] | if .age > 18 then .name else empty end'

# Slot $(@base64)
echo -n 'hello' | jq -Rr '@base64'    # → aGVsbG8=
echo 'aGVsbG8=' | jq -Rr '@base64d'   # → hello

# CSV
jq -r '.[] | [.name, .email] | @csv' data.json
jq -r '.[] | [.name, .age] | @tsv' data.json

# Escape HTML
jq -R '<div>\(.)</div>' <<< 'hola'

# Desde archivos
jq '.users[] | select(.active == true)' data.json
jq --slurpfile conf config.json '.setting = $conf[0]' data.json
```

## Pipelines comunes

```bash
# Contar por campo
curl -s api | jq 'group_by(.status) | map({status: .[0].status, count: length})'

# Obtener el más reciente
curl -s api | jq 'sort_by(.date) | last'

# Paginación manual
curl -s api | jq '.items[:10]'   # primeros 10

# Merge de objetos
echo '{"a":1}' '{"b":2}' | jq -s 'add'   # → {"a":1,"b":2}

# Verificar si existe un campo
curl -s api | jq 'has("email")'

# Recorrer recursivamente
jq '.. | .name? // empty' data.json
```

## Configuración y colores

```bash
# Color output (por defecto)
jq . file.json

# Sin colores (para piping)
jq -r '.[] | .name' file.json

# Tabla compacta
curl -s api | jq -r '.[] | [.name, .status, (.age | tostring)] | @tsv'

# Pretty-print con indentación personalizada
jq --indent 4 . file.json
```

## Enlaces externos

- [Sitio oficial de jq](https://jqlang.github.io/jq/)
- [GitHub — jqlang/jq](https://github.com/jqlang/jq)
- [jq play (entorno interactivo)](https://jqplay.org/)
- [Arch Wiki — Jq](https://wiki.archlinux.org/title/Jq)
- [jq manual oficial](https://jqlang.github.io/jq/manual/)

## Ver también

- [[curl]] — cliente HTTP (a menudo pipeado a jq)
- [[httpie]] — cliente HTTP alternativo
- [[grep]] — búsqueda clásica en texto
- [[fx]] — visor JSON interactivo
- yq — procesador YAML similar a jq (sin nota propia)
- APIs REST

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `parse error: Invalid numeric literal` | JSON malformado | `cat -v file.json` para ver caracteres raros |
| `null` en salida | Campo no existe | Usar `? // empty` o `// "default"` |
| Command not found | No instalado | `sudo apt install jq` |
| Out of memory | Archivo muy grande | `jq --stream` para procesar streaming |

#programa #herramientas #json
