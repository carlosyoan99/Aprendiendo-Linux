---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: media
---

# diff

> Compara dos archivos línea por línea y muestra las diferencias. Esencial para versionar configuraciones, revisar cambios entre versiones, y verificar integridad de copias.

## Sintaxis

```bash
diff [opciones] archivo1 archivo2
diff [opciones] directorio1/ directorio2/
diff [opciones] --from-file archivo1 archivo2 archivo3...  # comparar varios contra uno
```

## Descripción

`diff` encuentra las diferencias entre dos archivos (o directorios) y las muestra en varios formatos. Es la herramienta base sobre la que se construyen sistemas de control de versiones (Git usa diff internamente). Sirve para revisar cambios en configuraciones, verificar que un backup es idéntico al original, o generar parches para aplicar en otro sistema.

**Códigos de salida**:
| Código | Significado |
|---|---|
| `0` | Archivos idénticos |
| `1` | Archivos diferentes |
| `2` | Error (archivo no encontrado, permiso denegado) |

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-u` | Formato unificado — el más legible (muestra contexto) | `diff -u v1.txt v2.txt` |
| `-c` | Formato contexto — muestra más líneas alrededor | `diff -c v1.txt v2.txt` |
| `-i` | Ignora diferencias de mayúsculas/minúsculas | `diff -i A.txt a.txt` |
| `-w` | Ignora **todos** los espacios y tabs | `diff -w archivo1 archivo2` |
| `-b` | Ignora cambios en espacios en blanco (no todos) | `diff -b archivo1 archivo2` |
| `-r` | Compara directorios **recursivamente** | `diff -r dir1/ dir2/` |
| `-q` | Solo indica si difieren (no muestra las diferencias) | `diff -q a.txt b.txt` |
| `-s` | Indica cuando dos archivos son iguales | `diff -s a.txt b.txt` → `identical` |
| `-y` | Muestra diferencias lado a lado en dos columnas | `diff -y a.txt b.txt` |
| `-N` | Trata archivos faltantes como vacíos (útil en directorios) | `diff -rN dir1/ dir2/` |
| `-x PATRON` | Excluye archivos que coinciden con el patrón | `diff -rx '.git' dir1/ dir2/` |
| `--color` | Colorea la salida (diff reciente, GNU diffutils 3.4+) | `diff --color -u a.txt b.txt` |

## Formato de salida (unificado `-u`)

```diff
--- archivo1.txt        2026-07-24 10:00:00.000000000 +0200
+++ archivo2.txt        2026-07-24 10:05:00.000000000 +0200
@@ -1,5 +1,5 @@
 línea 1
 línea 2
-línea 3 (archivo1)
+línea 3 (archivo2)
 línea 4
 línea 5
```

| Símbolo | Significado |
|---|---|
| `---` | Archivo original (archivo1) |
| `+++` | Archivo modificado (archivo2) |
| `@@ -x,y +x,y @@` | Contexto: desde línea x, y líneas en ambos archivos |
| `-` | Línea presente en original pero no en modificado |
| `+` | Línea presente en modificado pero no en original |
| ` ` (espacio) | Línea de contexto (igual en ambos) |

## Ejemplos

```bash
# 1. Diferencias básicas
diff archivo1.txt archivo2.txt

# 2. Formato unificado (recomendado para humanos)
diff -u config.old config.new

# 3. Generar parche (para aplicar con patch)
diff -u config.old config.new > cambios.patch
patch config.old < cambios.patch

# 4. Comparar dos directorios recursivamente
diff -r directorio1/ directorio2/

# 5. Solo saber si son diferentes (útil en scripts)
diff -q archivo1.txt archivo2.txt

# 6. Ignorar espacios
diff -w archivo1.txt archivo2.txt

# 7. Comparar dotfiles con su versión versionada
diff -u ~/.bashrc ~/dotfiles/.bashrc

# 8. Lado a lado (útil para comparativas visuales)
diff -y --width=120 archivo1.txt archivo2.txt

# 9. Comparar directorios excluyendo .git
 diff -rNx '.git' proyecto1/ proyecto2/

# 10. Con colores (GNU diffutils 3.4+)
diff --color -u archivo1.txt archivo2.txt
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Comparar configs** antes/después de cambios | `diff -u /etc/ssh/sshd_config.bak /etc/ssh/sshd_config` |
| **Verificar backup** — asegurar que una copia es idéntica | `diff -qr /original/ /backup/` |
| **Generar parche** para aplicar en otro servidor | `diff -u main.c.old main.c > fix.patch` |
| **Comparar salida de comandos** (con process substitution) | `diff -u <(ls dir1/) <(ls dir2/)` |
| **Encontrar archivos únicos** en un directorio | `diff -r dir1/ dir2/ \| grep "Only in"` |

## Combinaciones comunes con pipe

```bash
# Encontrar archivos únicos en cada directorio
diff -r dir1/ dir2/ | grep "Only in"

# Archivos que difieren (ignorando el detalle)
diff -qr dir1/ dir2/ | grep differ

# Contar líneas diferentes
diff -u archivo1.txt archivo2.txt | grep -c '^[+-]'
```

## Alternativas modernas

| Herramienta | Ventaja |
|---|---|
| **colordiff** | Wrapper que colorea la salida de `diff`. Alternativa si tu diff no soporta `--color` |
| **diff-so-fancy** | Diferencias mejor formateadas para humanos, con íconos y resaltado de palabras |
| **Delta** | (dandavison/delta) Visor de diferencias con sintaxis coloreada, usado como pager de Git |
| **difftastic** | Diff basado en AST (entiende sintaxis de cada lenguaje), muestra diferencias estructurales no solo textuales |
| **icdiff** | (interactive diff) Muestra diferencias lado a lado con colores, similar a `diff -y` pero más legible |
| **meld** / **kdiff3** | Herramientas gráficas para comparar archivos y directorios |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `diff: archivo: No such file or directory` | La ruta no existe | Verificar con `ls` que el archivo exista |
| `diff: archivo: Permission denied` | No tienes permiso de lectura | Usar `sudo diff ...` o verificar permisos |
| Salida muy larga y difícil de leer | Archivos muy grandes o muchas diferencias | Usar `diff -q` primero, o pipear a `less`: `diff -u a.txt b.txt \| less` |
| `diff -r` encuentra diferencias en archivos binarios | diff intenta leer binarios como texto para `-r` | Usar `diff -qr` para solo detectar diferencias, o `cmp` para binarios |
| `diff` no muestra colores | Versión antigua de GNU diffutils | Usar `colordiff` o `diff --color` (GNU diffutils 3.4+) |
| **Comparar con git diff** | Si los archivos están en un repo Git, `git diff` es más potente que `diff` | Para archivos bajo Git, usar `git diff archivo` que respeta staging y commits |

## Notas y advertencias

- **diff vs cmp**: `diff` compara línea por línea (archivos de texto), `cmp` compara byte por byte (archivos binarios). Usar `cmp` para imágenes, PDFs, ejecutables.
- **Exit codes en scripts**: `if diff -q a.txt b.txt > /dev/null; then echo "iguales"; fi` aprovecha el código de salida.
- **Process substitution**: `diff -u <(ls dir1/) <(ls dir2/)` compara la salida de comandos como si fueran archivos (Bash/ Zsh).
- **Patch**: el archivo generado con `diff -u` puede aplicarse con `patch -p1 < cambios.patch`. Git también acepta parches: `git apply cambios.patch`.
- **Archivos grandes**: para archivos de más de 100MB, `diff` puede ser lento. Considerar `cmp` o `rsync --dry-run`.
- **sdiff**: muestra diferencias lado a lado. `sdiff -s a.txt b.txt` solo muestra las líneas diferentes.

## Enlaces externos

- [Wikipedia — diff](https://en.wikipedia.org/wiki/Diff)
- [GNU Diffutils — diff manual](https://www.gnu.org/software/diffutils/manual/diffutils.html)
- [Arch Wiki — diff](https://wiki.archlinux.org/title/Diff)
- [diff-so-fancy GitHub](https://github.com/so-fancy/diff-so-fancy)
- [Delta GitHub](https://github.com/dandavison/delta)

## Ver también

- [[cmp]] — comparación byte a byte para archivos binarios
- [[patch]] — aplicar parches generados por diff
- [[grep]] — buscar patrones en archivos
- [[rsync]] — copia con verificación de cambios
- [[Git]] — control de versiones con diff integrado
- [[Cheat Sheet - Comandos Esenciales]]

#comando
