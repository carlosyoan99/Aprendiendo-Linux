---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: comando
prioridad: alta
---

# Nano

## Sintaxis
```
nano [opciones] archivo
```

## Descripción

**GNU Nano** es un editor de texto por terminal, sencillo e intuitivo. Es el editor por defecto en muchas distribuciones (Debian, Ubuntu) y una alternativa ligera a [[Vim Neovim]] para quienes prefieren una interfaz más tradicional, con comandos visibles en pantalla.

Ideal para: editar archivos de configuración rápidamente, usuarios nuevos en Linux, y tareas donde Vim/Neovim sería excesivo.

## Atajos esenciales

Todos los atajos se muestran en la barra inferior del editor. `^` significa **Control**, `M-` significa **Alt**.

### Archivo y navegación

| Atajo | Acción |
|---|---|
| `^O` | Guardar archivo (WriteOut) |
| `^X` | Salir (eXit) |
| `^R` | Insertar archivo (Read) |
| `^W` | Buscar (WhereIs) |
| `^\` | Buscar y reemplazar |
| `^C` | Mostrar posición del cursor |
| `^_` | Ir a línea y columna |

### Edición

| Atajo | Acción |
|---|---|
| `^K` | Cortar línea completa |
| `^U` | Pegar (Uncut) |
| `^J` | Justificar párrafo |
| `^T` | Corregir ortografía (si aspell está instalado) |
| `^6` | Marcar texto para selección |
| `M-6` | Copiar línea |
| `M-U` | Deshacer (Undo) |
| `M-E` | Rehacer (Redo) |

### Avanzados

| Atajo | Acción |
|---|---|
| `^G` | Ayuda integrada |
| `^F` / `^B` | Avanzar / Retroceder carácter |
| `M-F` / `M-B` | Avanzar / Retroceder palabra |
| `^P` / `^N` | Línea anterior / siguiente |
| `M-\` | Ir al inicio del archivo |
| `M-/` | Ir al final del archivo |
| `M-]` | Ir al paréntesis/llave correspondiente |
| `M-T` | Activar/desactivar modo de escritura (readonly toggle) |
| `M-#` | Mostrar/ocultar números de línea |
| `M-$` | Activar/desactivar soft wrap |
| `^L` | Refrescar pantalla |

## Opciones frecuentes

| Flag | Efecto |
|---|---|
| `-l` | Mostrar números de línea |
| `-m` | Activar soporte de ratón |
| `-i` | Auto-indentar |
| `-k` | Cortar desde la posición del cursor (no línea completa) |
| `-w` | Desactivar wrap de palabras (útil para configs) |
| `-c` | Mostrar posición constantemente |
| `-T n` | Tamaño de tab = n espacios |
| `-S` | Smooth scrolling (desplazamiento suave) |
| `-B` | Hacer backup del archivo antes de guardar |
| `--syntax=python` | Resaltado de sintaxis para un lenguaje |

```bash
# Ejemplos de invocación
nano -lw                          # con números de línea y sin wrap
nano -lw -T 4                     # tab = 4 espacios
nano -B /etc/hosts                 # backup antes de editar
nano --syntax=sh script.sh        # resaltado para shell
```

## Configuración: `~/.nanorc`

```bash
# ~/.nanorc — configuración personal de nano
set linenumbers                   # mostrar números de línea
set tabsize 4                     # tamaño de tabulación
set tabstospaces                  # convertir tabs a espacios
set autoindent                    # auto-indentar
set mouse                         # soporte de ratón
set smooth                        # scroll suave
set backup                        # crear .bak al guardar
set backupdir ~/.cache/nano/backups/
set constantshow                  # mostrar posición del cursor
set softwrap                      # wrap de líneas largas
set casesensitive                 # búsqueda sensible a mayúsculas

# Incluir resaltado de sintaxis para lenguajes comunes
include "/usr/share/nano/*.nanorc"
```

## Resaltado de sintaxis

```bash
# Los archivos .nanorc de sintaxis están en:
ls /usr/share/nano/*.nanorc

# Activar todos en /etc/nanorc (global) o ~/.nanorc (personal):
include "/usr/share/nano/*.nanorc"
```

## Nano vs Vim

| Característica | Nano | Vim |
|---|---|---|
| Curva de aprendizaje | Baja | Alta |
| Atajos visibles | Sí (barra inferior) | No |
| Modos (insertar/comando) | No | Sí (modal) |
| Plugins | No | Sí (vundle, packer) |
| Peso | Ligero (~500 KB) | Moderado (~5 MB) |
| Portabilidad | Muy alta | Alta |
| Ideal para | Edits rápidos, principiantes | Edits complejos, programación |

## Notas y advertencias

- Nano muestra atajos en la barra inferior — mírala si olvidas comandos.
- `^O` para guardar, `^X` para salir. Si el archivo tiene cambios sin guardar, pregunta automáticamente.
- Si accidentalmente abres un binario grande, pulsa `^C` varias veces hasta que puedas salir con `^X`.
- En sistemas embebidos o contenedores mínimos (Alpine), nano puede no estar instalado — usa `vi` o `busybox vi`.

## Ver también

- [[Vim Neovim]] — alternativa modal más potente
- [[Editores de Texto]] — comparativa de editores
- [[Gestores de Paquetes]] — instalar nano si no viene preinstalado

## Enlaces externos

- [Wikipedia - Nano (text editor)](https://en.wikipedia.org/wiki/Nano_(text_editor))
- [Sitio oficial - Nano](https://www.nano-editor.org/)
- [GitHub - nano](https://git.savannah.gnu.org/cgit/nano.git)

#comando
