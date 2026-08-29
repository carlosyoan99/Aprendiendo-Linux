---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: terminal
prioridad: baja
---

# Nushell

> Shell estructurada que trata los datos como tablas tipadas en vez de strings. Alternativa moderna a bash/zsh/fish escrita en Rust.

## Qué es

Nushell (`nu`) es una shell que se aparta del paradigma clásico de texto plano: cada comando emite **datos estructurados** con tipos (string, int, float, date, path) en lugar de salida de texto que hay que parsear. Esto convierte los pipelines en canales de valores tipados que se pueden filtrar, ordenar, seleccionar y transformar como si fueran una base de datos.

- **Base tecnológica**: escrita en Rust (licencia MIT).
- **Filosofía**: si un formato es parseable (JSON, CSV, YAML, TOML), Nushell lo convierte en su modelo de datos interno, y se opera sobre él sin `awk`/`sed`/`jq`.
- **Público**: usuarios avanzados de terminal que quieren pipelines legibles y scripting con tipos, o gente que viene de PowerShell buscando algo similar en Linux.
- **Servidor gráfico**: al ser una shell da igual X11 o Wayland; corre en cualquier emulador de terminal.

```bash
# En bash: parsear la salida de ls obliga a awk/sed
ls -la | awk '{print $5, $9}'

# En Nushell: la salida YA es una tabla
ls | get size name
ls | where size > 1mb | sort-by size
```

## Sintaxis

Nushell conserva la sensación de una shell Unix (comandos, argumentos, flags con `--`), pero con una fuente propia de comandos integrados:

```bash
nu                            # iniciar la shell
nu -c "comando"               # ejecutar un comando sin entrar en la shell
nu --version                  # versión

ls --long                     # tabla con metadatos
help ls                       # ayuda de un comando integrado
```

### Conectores de pipelines

| Conector | Uso |
|---|---|
| `\|` | Encadenar comandos internos (valores tipados) |
| `\|>` | Encadenar comandos externos en versiones recientes |
| `;` | Separar comandos en una línea |
| `if/else` | Condicional (sintaxis moderna con `}` de cierre) |
| `match` | Coincidencia de patrones |

En los últimos lanzamientos `|>` se reserva para **externos** (que devuelven texto bruto) y `|` para **internos** (que devuelven valores tipados); cualquiera de los dos cubre el 90% de los usos diarios.

## Tuplas, tablas y pipelines

El corazón de Nushell son los **records** (tuplas con nombre: `{ nombre: "luis", edad: 30 }`), las **listas** y las **tablas** (filas + columnas tipadas). Casi cualquier comando devuelve una tabla:

- `ls` → `name`, `type`, `size`, `modified`
- `ps` → `pid`, `cpu`, `mem`, `name`
- `open archivo.csv` → tabla parseada automáticamente

Sobre esa tabla se encadenan filtros sin tocar texto:

```bash
ps | where cpu > 50 | sort-by mem | reverse
ls | where type == dir
ls | where name =~ "\.rs$"
```

Un `record` se mete en una tabla o se encadena en un pipeline igual que una fila:

```bash
{ nombre: "linux", version: 6 } | get nombre
```

## Comandos integrados

| Comando | Para qué |
|---|---|
| `get` | Extraer columnas o valores anidados (`get users.0.name`) |
| `select` | Recortar columnas (`select name size`) |
| `where` | Filtrar filas por condición |
| `sort-by` | Ordenar por columnas |
| `group-by` | Agrupar filas |
| `open` | Leer archivos y parsear su formato (JSON, CSV, YAML, TOML…) |
| `from json` / `from csv` | Parsificar texto bruto a tablas |
| `to json` / `to csv` / `to md` | Convertir tablas a otros formatos de salida |
| `each` | Iterar filas y transformarlas |
| `reduce` | Acumular valores en una lista |
| `str` | Manipular cadenas (`str upcase`, `str replace`) |
| `math` | Operaciones numéricas (`math avg`, `math sum`) |

```bash
open data.json | get users.0.name          # leer JSON sin jq
cat data.csv | from csv | where precio > 10
ls | group-by type | transpose
help commands | where name =~ "str"
```

## Diferencias con bash/zsh/fish

| Aspecto | bash / zsh | fish | Nushell |
|---|---|---|---|
| **Modelo de datos** | Texto plano / strings | Texto plano | Tablas tipadas |
| **Lenguaje** | POSIX + extensiones | Sintaxis propia | Sintaxis propia (Rust) |
| **Configuración** | `~/.bashrc`, `~/.zshrc` | `~/.config/fish/` | `~/.config/nushell/` (XDG) |
| **Scripting** | POSIX, ubiquitous | No POSIX | Tipado, aún joven |
| **Tipos de datos** | No | No | Sí (string, int, date, path, list, record) |

Nushell no es compatible con scripts POSIX: se escribe en su sintaxis propia. Para scripts de sistema sigue usando bash; Nushell brilla en la **interacción diaria** y en el procesamiento de datos.

## Lenguaje de scripting

Nushell es además un lenguaje con variables, funciones y closures:

```bash
let nombre = "Linux"                 # variable inmutable
mut saludo = "hola"                  # variable mutable
print $"($saludo), ($nombre)!"

def fecha_archivo [path] {           # función
    open $path | get modified
}

ls | where {|it| $it.size > 1mb }    # closure sobre cada fila
ls | each {|it| { nombre: $it.name, mega: ($it.size / 1mb) } }
```

Los closures capturan el entorno como en Rust/PowerShell y se pasan como argumentos a `each`, `where`, `map`, `reduce`.

## Configuración

Nushell usa las rutas XDG en `~/.config/nushell/`:

| Archivo | Rol |
|---|---|
| `config.nu` | Comandos, atajos, prompt, plugins |
| `env.nu` | Variables de entorno (`$env.PATH`, `$env.HOME`, etc.) |
| `startup.nu` | Comandos que corren al arrancar cada sesión (versiones recientes) |

```bash
# Editar la configuración desde dentro de Nushell
config nu                            # abre y recarga config.nu
config env                           # edita env.nu
```

```bash
# config.nu — ejemplo
$env.config.show_banner = false
$env.PATH = ($env.PATH | prepend '/usr/local/bin')
alias ll = ls --long
```

Para validar los cambios sin reiniciar:

```bash
source ~/.config/nushell/config.nu
```

## Ejemplos

```bash
# Procesos con más del 50% de CPU, los 5 primeros
ps | where cpu > 50 | sort-by cpu --reverse | first 5

# Archivos grandes de cada carpeta en una tabla legible
ls | where type == dir | each {|it| {
    carpeta: $it.name,
    tamaño: (du $it.name | get total)
}}

# Informe final en Markdown
ls --recursive | where type == file | sort-by size --reverse | first 10 \
    | select name size | to md
```

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Datos estructurados: nada de parsear strings con awk/sed | No compatible con scripts/alias POSIX existentes |
| `open` + `get`/`where` sustituyen a jq en muchos usos | Comunidad y plugins aún pequeños frente a zsh/fish |
| Sintaxis moderna, escrita en Rust | Algunas operaciones más lentas que los clásicos equivalentes |
| Hace el piping legible y divertido | Curva de aprendizaje si vienes solo de bash |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| `command not found` al configurar PATH | `env.nu` no recargado tras editarlo | `source env.nu` o reinicia la sesión |
| Un externo (git, cargo…) devuelve una sola cadena | La salida no es parseable como tabla | Usar `\|>` o convertir con `lines` / `from text` |
| Scripts copiados de internet no funcionan | Sintaxis POSIX no válida en Nushell | Reescribirlos o ejecutarlos con `bash` |
| `&&` y `\|\|` dan error | Nushell usa `;`, `and` y `or` | Sustituir por `;` o `and`/`or` |
| El prompt se ve mal en `tmux` | Terminfo incompleto | `$env.TERM = "tmux-256color"` |

## Enlaces externos

- [Sitio oficial de Nushell](https://www.nushell.sh)
- [Documentación (the Nushell book)](https://www.nushell.sh/book/)
- [Repositorio GitHub — nushell/nushell](https://github.com/nushell/nushell)

## Ver también

- [[Shells (bash zsh fish)]] — el panorama clásico de shells
- [[Fish]] — otra alternativa moderna, ya documentada aquí
- [[La Shell]] — qué es una shell y qué no
- [[Emuladores de Terminal]] — dónde corre `nu`

#terminal #shell