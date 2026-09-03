---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# Atajos de teclado - Vim

> Accesos rápidos de **Vim/Neovim** por defecto. Vim se controla casi íntegramente con el teclado a través de **modos**: Normal (navegar/editar), Insert (escribir), Visual (seleccionar) y Command (comandos Ex). Cambiar de modo es la base de todo.

## Modos y cambio de modo

| Atajo | Modo | Efecto |
|---|---|---|
| `i` | Normal → Insert | Insertar antes del cursor |
| `I` | Normal → Insert | Insertar al inicio de la línea |
| `a` | Normal → Insert | Insertar después del cursor |
| `A` | Normal → Insert | Insertar al final de la línea |
| `o` | Normal → Insert | Nueva línea debajo e insertar |
| `O` | Normal → Insert | Nueva línea arriba e insertar |
| `Esc` / `Ctrl+[` | Cualquier → Normal | Volver al modo Normal |
| `v` | Normal → Visual | Selección por caracteres |
| `V` | Normal → Visual Line | Selección por líneas |
| `Ctrl+V` | Normal → Visual Block | Selección en bloque rectangular |

## Movimiento básico (modo Normal)

| Atajo | Efecto |
|---|---|
| `h` / `j` / `k` / `l` | Izquierda / abajo / arriba / derecha |
| `w` / `b` / `e` | Siguiente palabra / palabra anterior / fin de palabra |
| `0` / `$` | Inicio / fin de línea |
| `^` | Primer carácter no vacío de la línea |
| `gg` / `G` | Inicio / fin del archivo |
| `:N` + `Enter` | Ir a línea N |
| `Ctrl+D` / `Ctrl+U` | Medio página abajo / arriba |
| `Ctrl+F` / `Ctrl+B` | Página abajo / arriba |
| `%` | Ir al paréntesis/llave/corchete coincidente |
| `f{char}` | Ir a la siguiente aparición de char en la línea |
| `F{char}` | Ir a la anterior aparición de char en la línea |

## Edición (modo Normal)

| Atajo | Efecto |
|---|---|
| `x` | Borrar carácter bajo el cursor |
| `dd` | Borrar línea completa |
| `D` | Borrar hasta el fin de línea |
| `dw` / `db` / `de` | Borrar palabra siguiente / anterior / hasta fin de palabra |
| `yy` | Copiar línea completa |
| `yw` / `y$` | Copiar palabra / hasta fin de línea |
| `p` / `P` | Pegar después / antes del cursor |
| `u` | Deshacer |
| `Ctrl+R` | Rehacer |
| `.` | Repetir último comando de edición |
| `J` | Unir línea actual con la siguiente |
| `~` | Alternar mayúsculas/minúsculas del carácter |
| `r{char}` | Reemplazar carácter bajo el cursor por char |
| `ciw` / `ci"` / `ci(` | Cambiar inner word / dentro de " / dentro de () |
| `diw` / `di"` / `di(` | Borrar inner word / dentro de " / dentro de () |
| `yiw` | Copiar inner word |
| `>i{` / `<i{` | Indentar / des-indentar dentro de {} |

## Búsqueda y reemplazo

| Atajo | Efecto |
|---|---|
| `/patrón` | Buscar hacia adelante |
| `?patrón` | Buscar hacia atrás |
| `n` / `N` | Siguiente / anterior coincidencia |
| `*` | Buscar palabra bajo el cursor (adelante) |
| `#` | Buscar palabra bajo el cursor (atrás) |
| `:%s/old/new/g` | Reemplazar todas las ocurrencias en el archivo |
| `:%s/old/new/gc` | Reemplazar con confirmación |
| `:s/old/new/g` | Reemplazar en la selección visual |

## Guardar y salir

| Atajo | Efecto |
|---|---|
| `:w` | Guardar |
| `:w archivo` | Guardar como |
| `:q` | Cerrar (si no hay cambios) |
| `:q!` | Cerrar sin guardar |
| `:wq` / `:x` / `ZZ` | Guardar y salir |
| `ZQ` | Salir sin guardar |
| `:w !sudo tee %` | Guardar como root cuando olvidaste sudo |

## Ventanas, splits y pestañas

| Atajo | Efecto |
|---|---|
| `:sp` / `Ctrl+W s` | Dividir horizontalmente |
| `:vsp` / `Ctrl+W v` | Dividir verticalmente |
| `Ctrl+W h/j/k/l` | Mover foco a izquierda/abajo/arriba/derecha |
| `Ctrl+W H/J/K/L` | Mover panel a izquierda/abajo/arriba/derecha |
| `Ctrl+W =` | Igualar tamaño de todos los paneles |
| `Ctrl+W _` / `Ctrl+W \|` | Maximizar alto / ancho del panel |
| `:tabnew` | Nueva pestaña |
| `gt` / `gT` | Siguiente / anterior pestaña |
| `:tabN` | Ir a pestaña N |

## Macros y registros

| Atajo | Efecto |
|---|---|
| `q{reg}` | Empezar a grabar macro en registro reg |
| `q` | Dejar de grabar |
| `@{reg}` | Ejecutar macro del registro reg |
| `@@` | Repetir última macro ejecutada |
| `"{reg}` | Usar registro reg (para yank/put) |
| `:reg` | Ver contenido de todos los registros |

## Ver también

- [[Vim]] — instalación, configuración, extensions
- [[Neovim]] — fork moderno con Lua, LSP, Telescope
- [[Vim comandos avanzados]] — macros, quickfix, marks, plegados, vimdiff
- [[Helix]] — editor modal moderno alternativo
- [[Atajos de teclado - VSCode]] — atajos del editor de código

## Enlaces externos

- [Vim documentation — Normal mode](https://vimhelp.org/usr_04.txt.html)
- [Vim Cheatsheet](https://vim.rtorr.com/)
- [Neovim — Mappings](https://neovim.io/doc/user/map.html)

#programa #atajos #editor
