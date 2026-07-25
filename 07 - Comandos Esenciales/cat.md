---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: comando
prioridad: alta
---

# cat

## Sintaxis
```
cat [opciones] archivo...
```

## Descripción
Concatena archivos y los muestra en la salida estándar. Es la forma más rápida de ver el contenido de un archivo (si es corto). También se usa para combinar archivos, crear archivos desde la terminal y redirigir contenido.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-n` | Numera todas las líneas |
| `-b` | Numera solo líneas no vacías |
| `-s` | Suprime líneas vacías repetidas (las colapsa en una) |
| `-E` | Muestra `$` al final de cada línea |
| `-T` | Muestra `^I` en lugar de tabs |
| `-A` | Equivalente a `-vET` (muestra todo) |

## Ejemplos
```bash
cat archivo.txt                           # ver contenido (archivos cortos ¡solo!)
cat -n archivo.txt                        # ver con número de línea
cat archivo1.txt archivo2.txt             # ver dos archivos seguidos
cat archivo1.txt archivo2.txt > combinado.txt   # concatenar en un archivo nuevo
cat > nuevo.txt                           # crear archivo escribiendo directo (Ctrl+D para terminar)
cat archivo.txt | grep "error"            # pipear a grep (aunque grep acepta archivos directo)
cat -s archivo.txt                        # colapsar líneas en blanco repetidas
```

## Casos de uso reales

### Ver el contenido de un archivo de configuración

```bash
cat /etc/hosts                            # ver el mapa host → IP
cat /etc/os-release                       # ver qué distro y versión tienes
cat /proc/cpuinfo | grep "model name" | head -1  # ver modelo del procesador
```

### Concatenar fragmentos de un archivo partido

```bash
# Si un archivo grande se partió en fragmentos:
cat parte1.sql parte2.sql parte3.sql > base_completa.sql

# Concatenar todos los archivos .part de un directorio
cat *.part > archivo_completo.bin
```

### Crear un archivo rápido desde terminal (sin editor)

```bash
cat > notas.txt << 'EOF'
Esto es una nota rápida
Escrita directamente desde la terminal
Sin necesidad de abrir nano/vim
EOF
```

## Combinaciones comunes con pipe

```bash
# Ver un archivo con números de línea (más rápido que abrir editor)
cat -n /etc/fstab | grep -E '^[[:space:]]*[^#]'  # lineas no comentadas con numeración

# Concatenar y comprimir en un paso
cat log1.txt log2.txt log3.txt | gzip > logs-combinados.gz

# Pasar contenido a un script sin crear archivo intermedio
cat datos.csv | while IFS=',' read -r col1 col2; do echo "$col1 → $col2"; done
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `cat archivo` | `bat archivo` | Resaltado de sintaxis, números de línea, paginación integrada |
| `cat -n archivo` | `bat archivo` | Lo mismo + git integration |
| `cat archivo` (largo) | `less archivo` | Paginación (no vuelca todo en pantalla) |

```bash
# Instalar bat
sudo apt install bat          # Debian/Ubuntu (se ejecuta como `batcat`)
sudo pacman -S bat            # Arch
# o: cargo install bat
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| Terminal se llena de caracteres raros | Abriste un archivo binario con `cat` | Pulsa `reset` y usa `cat -v` o `strings` para binarios |
| `cat: archivo: Permission denied` | No tienes permisos de lectura | Usar `sudo cat /ruta/archivo` |
| `cat: archivo: No such file or directory` | El archivo no existe | Verificar ruta con `ls -la` o `find . -name "archivo"` |
| El archivo se muestra sin saltos de línea | Archivo sin `\n` al final o formato Windows (CRLF) | Usar `cat -v` para ver caracteres ocultos, `dos2unix` para convertir |

## Notas y advertencias
- `cat` es útil para archivos **pequeños** (pocas líneas). Para archivos largos (logs, configs extensas), usar [[less]] o `head`/`tail`.
- Si haces `cat archivo` en un binario, la terminal se llena de caracteres extraños. Algunas terminales se desconfiguran y hay que resetear con `reset`.
- `cat` no es necesario si el comando acepta archivos directamente: `grep "error" archivo.txt` es mejor que `cat archivo.txt | grep "error"` (Useless Use of Cat — UUOC).
- Crear archivos con `cat > archivo` es práctico pero sin editor: no puedes corregir errores fácilmente. Para texto multilínea breve sirve; para algo serio usar un editor.

## Enlaces externos

- [Wikipedia — cat (Unix)](https://en.wikipedia.org/wiki/Cat_(Unix))
- [GNU Coreutils — cat manual](https://www.gnu.org/software/coreutils/manual/html_node/cat-invocation.html)

## Ver también
- [[less]]
- [[Cheat Sheet - Comandos Esenciales]]

#comando
