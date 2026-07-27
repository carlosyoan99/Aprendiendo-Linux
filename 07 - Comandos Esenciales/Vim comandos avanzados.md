---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: media
---

# Vim / Neovim — Comandos avanzados

> Más allá de `i`, `:wq` y `dd`: macros, registros, plegados, sesiones, quickfix, vimdiff y personalización con Lua.

**Prerrequisito**: Esta nota asume que conoces lo básico de Vim/Neovim. Si no, ver [[Vim Neovim]] primero.

---

## Macros — automatización de acciones repetitivas

Las macros graban secuencias de teclas para reproducirlas cuantas veces quieras.

### Grabar y reproducir

```vim
qa                  " empezar a grabar en registro 'a'
...                 " secuencia de teclas (navegar, editar, etc.)
q                   " detener grabación

@a                  " reproducir macro una vez
5@a                 " reproducir 5 veces
@@                  " repetir la última macro
```

### Macro con búsqueda y movimiento

Ejemplo práctico: poner cada palabra de una lista en su propia línea con comillas:

```vim
" Texto inicial:  manzana pera uva fresa
" Queremos:
"   "manzana",
"   "pera",
"   "uva",
"   "fresa",

qa                    " grabar en 'a'
ciw""<Esc>            " cambiar palabra por "" + cursor entre comillas
P                     " pegar antes (deja: "manzana")
la,<Esc>              " añadir coma después "
w                     " siguiente palabra
q                     " detener

" Ahora: 99@a para procesar las 99 palabras restantes
```

### Macro recursiva

```vim
" Grabar una macro que se llama a sí misma
qb                    " grabar en 'b'
...                   " acciones
@b                    " al final, llamarse a sí misma
q                     " detener (¡cuidado con bucle infinito!)
```

> ⚠️ Siempre dejar una **condición de salida** (ej: mover cursor hasta que no haya más coincidencias).

### Editar una macro existente

```vim
:let @a = ''          " mostrar contenido del registro 'a'
:let @a = 'iHola mundo!^[j'   " escribir macro manualmente (^[ = Ctrl+v + Esc)
```

### Append a macro

```vim
qA                    " usar mayúscula para añadir al registro 'a'
...                   " acciones adicionales
q                     " detener (ahora 'a' tiene las originales + las nuevas)
```

---

## Registros — los portapapeles de Vim

Vim tiene **9 tipos de registros** para almacenar texto:

| Registro | Acceso | Uso |
|---|---|---|
| `""` | Por defecto | Todo lo borrado (`d`) o copiado (`y`) va aquí |
| `"0` | `"0p` | Último **yank** (no se sobrescribe al borrar) |
| `"a`-`"z` | `"ap` a `"zp` | Registros **nombrados** (almacenamiento manual) |
| `"A`-`"Z` | `"Ap` | **Append** al registro nombrado (mayúscula = añadir) |
| `"+` | `"+p` | Portapapeles del **sistema** (CLIPBOARD) |
| `"*` | `"*p` | Portapapeles de **selección** (PRIMARY, Ctrl+Shift+C/V) |
| `"=` | `"=5*5<CR>p` | **Expresión**: evalúa y pega el resultado |
| `"%` | `"%p` | Nombre del archivo actual |
| `":` | `":p` | Último comando ejecutado |
| `".` | `".p` | Último texto insertado |
| `"/` | `"/p` | Último patrón de búsqueda |

### Ejemplos prácticos

```vim
" Yank a registro nombrado y pegar
"ayw                  " copiar palabra al registro 'a'
"ap                   " pegar desde registro 'a'

" Append a registro
"Ayw                  " añadir palabra al registro 'a' (no sobrescribe)

" Intercambiar portapapeles del sistema
"+yy                  " copiar línea al clipboard del sistema
"+p                   " pegar desde clipboard

" Expresión: calcular y pegar
"=                     " entrar en modo expresión
5 * 12 + 3<CR>p       " → pega 63

" Ver contenido de todos los registros
:reg
:reg a b              " solo los registros a y b
```

> Para que `"+` sea el registro por defecto: `set clipboard=unnamedplus` (ver [[Vim Neovim]]).

---

## Quickfix y Location List — navegación estructurada

### Quickfix list (global)

```vim
:make                 " compilar y llenar quickfix con errores
:copen                " abrir ventana quickfix
:cclose               " cerrar
:cnext  :cprev        " siguiente/anterior error
:cfirst :clast        " primer/último error
:cnfile :cpfile       " siguiente/anterior archivo
:cdo /patrón/reemplazo/g   " ejecutar comando en todos los archivos del quickfix
:cfdo %s/foo/bar/g | update " reemplazar en todos los archivos y guardar
```

### Location list (por ventana)

```vim
:lopen  :lclose       " abrir/cerrar location list
:lnext  :lprev        " navegar
:lfirst :llast        " ir al primero/último
:ldo /patrón/reemplazo/g   " ejecutar en location list
```

### Llenar quickfix con resultados de búsqueda

```vim
:vimgrep /patrón/ **/*.py      " buscar patrón en todos los .py
:vimgrep /TODO/ **/*.{js,ts,py,go}
:copen                          " abrir resultados

:grep -rn "TODO" src/           " usar grep externo
:copen                          " resultados en quickfix
```

### Llenar quickfix desde la shell

```vim
:set grepprg=rg\ --vimgrep      " usar ripgrep en lugar de grep
:grep "class.*Controller" app/
:copen
```

---

## Marcas (marks) — saltos rápidos

### Marcas locales (por archivo)

```vim
ma                    " marcar posición actual como 'a'
`a                    " ir a la columna exacta de la marca 'a'
'a                    " ir al primer carácter no vacío de la línea

:marks                " listar todas las marcas
:delmarks a           " eliminar marca 'a'
:delmarks!            " eliminar todas las marcas
```

### Marcas globales (entre archivos)

```vim
mA                    " marca global 'A' (persiste entre archivos)
`A                    " ir a la marca 'A' (abre el archivo si es necesario)
```

### Marcas especiales automáticas

```vim
`.                    " última modificación
`0                    " última posición al cerrar Vim
`[  `]                " inicio/fin del último cambio o yank
`<  `>                " inicio/fin de la última selección visual
`"                    " última posición al salir del buffer
`^                    " última posición de inserción
```

### Uso práctico: marcas más navegación

```vim
" Marcar secciones de un archivo largo
ma                    " inicio de función
mb                    " TODO pendiente
mc                    " sección crítica

" Saltar entre ellas
'a 'b 'c
```

---

## Plegados (folds) — ocultar/secciones

```vim
zf                    " crear fold sobre texto seleccionado (visual)
za                    " toggle fold (abrir/cerrar)
zc                    " cerrar fold
zo                    " abrir fold
zM                    " cerrar todos los folds
zR                    " abrir todos los folds
zd                    " eliminar fold bajo cursor
zE                    " eliminar todos los folds

" Por nivel de indentación
:set foldmethod=indent
:set foldlevel=2       " plegar todo con 2+ niveles de indentación
:set foldcolumn=4      " mostrar indicador de folds en el margen
```

Modos de fold (`foldmethod`):

| Modo | Descripción |
|---|---|
| `manual` | Creados con `zf` |
| `indent` | Por nivel de indentación |
| `marker` | Por marcadores `{{{` y `}}}` |
| `syntax` | Por elementos sintácticos del lenguaje |
| `expr` | Por expresión personalizada |

---

## Sesiones — guardar y restaurar el workspace

```vim
:mksession            " guardar sesión en Session.vim
:mksession!           " sobrescribir
:mksession proyecto.vim   " con nombre personalizado

" Cargar sesión
:source Session.vim
" o desde terminal:
vim -S Session.vim
```

Lo que guarda una sesión:
- Archivos abiertos (buffers)
- Layout de ventanas y tabs
- Opciones de Vim
- Marcas globales
- Plegados

---

## Vimdiff — comparar archivos

```vim
" Desde terminal
vimdiff archivo1 archivo2
nvim -d archivo1 archivo2

" Desde Vim ya abierto
:vert diffsplit archivo2
```

### Comandos de diff

```vim
]c                    " siguiente diferencia
[c                    " anterior diferencia
:diffget              " obtener cambio del otro panel (do)
:diffput              " enviar cambio al otro panel (dp)
:diffupdate           " recalcular diferencias
:diffoff              " desactivar modo diff

" Merge a 3 vías (git mergetool)
nvim -d archivo archivo.base archivo.other
:diffget //2          " obtener del panel izquierdo (local)
:diffget //3          " obtener del panel derecho (remoto)
:diffget //1          " obtener del panel central (base)
```

---

## Comando `:global` — ejecutar en líneas que coinciden

```vim
:g/patrón/comando       " ejecutar comando en líneas que coinciden
:v/patrón/comando       " ejecutar en líneas que NO coinciden (inverso)

" Ejemplos
:g/^$/d                " borrar líneas vacías
:g/^#/d                " borrar comentarios
:g/TODO/normal A <-- PENDIENTE   " añadir texto al final de líneas con TODO
:g/error/tjump          " saltar a cada línea con 'error' (como quickfix)
:v/./d                  " borrar líneas vacías (con inverso: "v/./" = no vacías)
```

---

## Dot (`.`) — repetir el último cambio

El **punto** (`.`) repite el último cambio completo. No es solo la última tecla, sino toda la secuencia de comandos hasta volver a modo Normal:

```vim
" Ejemplo: añadir punto y coma al final de varias líneas
A;<Esc>               " añadir ; al final (1 cambio)
j.                    " bajar y repetir
j.                    " bajar y repetir
                      " sin el punto: A;<Esc> j A;<Esc> j A;<Esc>

" Ejemplo: comentar varias líneas
I// <Esc>             " insertar // al inicio
j. j. j.              " repetir en 3 líneas más
```

> El `.` es el atajo más potente que no sabías que necesitabas. Combinado con `n` (siguiente búsqueda), puedes hacer cambios rápidos en cadena: `:%s/foo/bar` → `n.n.n.` para aceptar/rechazar.

---

## Personalización con Lua (Neovim)

### Mapeos de teclado

```lua
-- En ~/.config/nvim/init.lua o ~/.config/nvim/options.lua

-- vim.keymap.set(modo, tecla, acción, opciones)
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Mapeo con función Lua
vim.keymap.set('n', '<leader>c', function()
    vim.cmd('let @+ = expand("%")')  -- copiar nombre de archivo al clipboard
    print("Filename copied: " .. vim.fn.expand("%"))
end)

-- Modos comunes: n=normal, i=insert, v=visual, x=visual block, t=terminal
```

### Autocomandos (eventos)

```lua
-- Ejecutar acciones en eventos específicos
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.py',
    callback = function()
        -- Eliminar espacios en blanco al final al guardar .py
        vim.cmd([[%s/\s\+$//e]])
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        -- Resaltar texto copiado brevemente
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
    end,
})
```

### Crear comandos personalizados

```lua
vim.api.nvim_create_user_command('Format', function()
    vim.lsp.buf.format()
end, { desc = 'Format current buffer with LSP' })
```

---

## Trucos avanzados combinados

### Macro + quickfix

```vim
" Buscar y ejecutar macro en cada coincidencia
:g/patrón/normal @a    " ejecutar macro 'a' en cada línea que coincide
:g/TODO/normal @q      " procesar todos los TODOs con macro en 'q'
```

### Dot + búsqueda

```vim
" Cambiar una palabra por otra usando búsqueda + punto
/foo<CR>               " buscar 'foo'
ciwnueva<Esc>          " cambiar por 'nueva' en la primera
n.n.n.                 " siguiente, repetir, siguiente, repetir...
```

### Registro de expresión para operaciones

```vim
" Sumar columna de números
:let i=0               " inicializar contador
:g/^\d/+1/              " para cada línea con número
:normal "=i<CR>p       " pegar el contador (requiere macro)

" Alternativa: numerar líneas con expresión
:let i=0 | g/^/let i+=1 | s/^/\=i.' '/
```

### :normal y :global combinados

```vim
" Ejecutar comando normal en líneas seleccionadas
:'<,'>normal I//       " añadir // al inicio de cada línea seleccionada
:g/foo/normal A;<Esc>  " añadir ; al final de líneas con 'foo'
:g/^$/normal o          " insertar línea vacía debajo de cada línea vacía
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Macro no funciona como esperaba | Movimiento impredecible | Usar `/búsqueda` para navegar en lugar de `w`/`j` |
| `"+` no pega desde el sistema | Vim sin `+clipboard` | `vim --version \| grep clipboard`, reinstalar con `vim-gtk3` |
| Quickfix vacío tras `:make` | Compilador no configurado | `:set makeprg=npm\ run\ build` o similar |
| Fold no se abre/cierra | `foldmethod` incorrecto | Probar `:set foldmethod=indent` o `marker` |
| `:g/patrón/normal @a` no funciona | La macro espera en modo Normal | Asegurar que la macro termina en modo Normal |
| Vimdiff muestra colores incorrectos | Tema de color | `:colorscheme default` o configurar `DiffAdd`, `DiffChange`, `DiffDelete` |

## Ver también

- [[Vim Neovim]] — comandos básicos, modos, configuración general
- [[Regular Expressions]] — patrones de búsqueda para :s y :g

## Enlaces externos

- [Vim Tips Wiki](https://vim.fandom.com/wiki/Vim_Tips_Wiki)
- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)
- [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html)
- [VimGolf](https://www.vimgolf.com/) — práctica de edición eficiente
- [:help quickref](https://neovim.io/doc/user/quickref.html) — referencia rápida en Vim

#comando
