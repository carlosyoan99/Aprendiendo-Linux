---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: baja
---

# tree

> Muestra la estructura de directorios en forma de árbol. Indispensable para visualizar la jerarquía de carpetas de un proyecto.

## Descripción

`tree` muestra recursivamente el contenido de un directorio en formato de árbol, con opciones para mostrar archivos ocultos, tamaño, permisos, y filtrar por profundidad o patrón.

## Sintaxis

```bash
tree [opciones] [directorio]
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `-a` | Mostrar archivos ocultos (incluyendo `.` y `..`) |
| `-d` | Solo directorios |
| `-L n` | Profundidad máxima (n niveles) |
| `-h` | Tamaño legible (KB, MB, GB) |
| `-s` | Tamaño en bytes |
| `-p` | Permisos del archivo |
| `-u` | Usuario propietario |
| `-g` | Grupo propietario |
| `-f` | Ruta completa |
| `-i` | Sin líneas de árbol (solo nombres) |
| `-Q` | Nombres entre comillas |
| `-F` | Añadir indicadores (/, *, @, =, \|) |
| `-P patrón` | Incluir solo archivos que coinciden con patrón glob |
| `-I patrón` | Excluir archivos que coinciden con patrón glob |
| `--prune` | Podar directorios vacíos |
| `--charset utf-8` | Usar caracteres Unicode para las líneas |
| `--dirsfirst` | Directorios primero |
| `--sort=name` | Ordenar por nombre (size, mtime, ctime) |
| `-o archivo.txt` | Guardar salida a archivo |

## Ejemplos

```bash
# Estructura básica del directorio actual
tree

# Con 2 niveles de profundidad
tree -L 2

# Solo directorios
tree -d

# Incluir archivos ocultos (hasta 1 nivel)
tree -a -L 1

# Con tamaño legible y permisos
tree -h -p ~/proyecto

# Excluir node_modules
tree -I 'node_modules|.git|*.pyc'

# Solo archivos .py
tree -P '*.py' -L 3

# Guardar estructura a archivo
tree -L 2 -o estructura.txt

# Caracteres Unicode (más bonito)
tree --charset utf-8

# Con ruta completa
tree -f src/
```

## Salida típica

```
proyecto/
├── README.md
├── src/
│   ├── main.rs
│   ├── lib.rs
│   └── utils/
│       ├── helpers.rs
│       └── parser.rs
├── tests/
│   └── test_main.rs
├── Cargo.toml
└── .gitignore
```

## Casos de uso

```bash
# Mostrar estructura de proyecto para documentación
tree -L 2 --charset utf-8 -I 'node_modules|.git|target'

# Encontrar directorios vacíos
tree -d --prune

# Ver cuánto pesa cada archivo en un proyecto
tree -h -s --sort=size -L 2

# Copiar estructura a README.md
tree -L 2 --charset utf-8 >> README.md

# Ver solo archivos de configuración
tree -P '*.{json,yaml,toml,conf}' -L 2
```

## Ver también

- [[ls]] — listar contenidos de directorio
- [[find]] — buscar archivos
- [[fd-find]] — buscar archivos rápido
- [[grep]] — buscar contenido en archivos

## Enlaces externos

- [Sitio oficial](http://mama.indstate.edu/users/ice/tree/)
- [Arch Wiki — Tree](https://wiki.archlinux.org/title/Tree)

#comando #directorios
