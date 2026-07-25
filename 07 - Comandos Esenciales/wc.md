---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# wc

## Sintaxis
```
wc [opciones] [archivo...]
```

## Descripción
Cuenta líneas, palabras, caracteres y bytes de uno o más archivos o de la entrada estándar. Es el comando de referencia para medir tamaño de logs, archivos de código, o la salida de cualquier otro comando vía pipe. Sin flags, imprime cuatro columnas: líneas, palabras, caracteres y nombre del archivo.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-l` | Cuenta solo líneas |
| `-w` | Cuenta solo palabras |
| `-c` | Cuenta solo bytes |
| `-m` | Cuenta solo caracteres (UTF-8, distingue multi-byte) |
| `-L` | Muestra la longitud de la línea **más larga** |
| `--files0-from=-` | Leer lista de archivos desde stdin (separados por null) |

## Ejemplos básicos

```bash
wc archivo.txt                            # líneas, palabras, bytes, nombre
wc -l archivo.txt                         # solo conteo de líneas
wc -w archivo.txt                         # solo conteo de palabras
wc -c archivo.txt                         # solo bytes
wc -m archivo.txt                         # solo caracteres (UTF-8)
wc -L archivo.txt                         # longitud de la línea más larga
```

## Casos de uso reales

### Contar resultados de otros comandos (pipe)

```bash
# Cuántos archivos .conf hay en /etc
find /etc -name "*.conf" | wc -l

# Cuántos procesos tiene el usuario actual
ps -u $(whoami) | wc -l

# Cuántos paquetes instalados
pacman -Q | wc -l                         # Arch
dpkg -l | wc -l                           # Debian/Ubuntu

# Cuántas líneas de código en un proyecto
find . -name "*.py" -exec cat {} + | wc -l

# Cuántos usuarios humanos (UID ≥ 1000)
awk -F: '$3 >= 1000 && $3 < 65534' /etc/passwd | wc -l

# Cuántos accesos HTTP 404 en un log
grep " 404 " access.log | wc -l

# Cuántos archivos modificados hoy
find . -mtime -1 -type f | wc -l
```

### Análisis de logs y datos

```bash
# Tamaño de un log en bytes (útil para monitorear crecimiento)
wc -c /var/log/syslog

# Ver cuántas líneas se agregaron a un log en los últimos 5 minutos
# 1. Guardar el conteo anterior
wc -l /var/log/syslog > /tmp/log-line-count.txt
# 2. Comparar después de 5 minutos
wc -l /var/log/syslog | awk '{print $1 - lineas} lineas=$1'

# Contar palabras únicas en un texto (wc -w + sort -u + wc -l)
cat texto.txt | tr ' ' '\n' | sort -u | wc -l
```

### Mediciones de código fuente

```bash
# Líneas totales de un proyecto (todos los lenguajes)
find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" \) -exec wc -l {} + | tail -1

# Líneas de código excluyendo comentarios y líneas vacías
grep -vE "^\s*(#|//|/\*|\*|$)" archivo.py | wc -l

# Línea más larga del código (útil para detectar líneas que deberían dividirse)
wc -L src/main.js

# Contar palabras en todos los .md del vault (útil para ver total de documentación)
find . -name "*.md" -exec wc -w {} + | tail -1
```

### Combinaciones con otros comandos

```bash
# top 10 procesos por consumo de memoria (wc cuenta, sort ordena, head limita)
ps aux | sort -nrk 4 | head -10 | wc -l    # confirmar que salen 10

# Cuántos archivos diferentes contribuyeron a un log
grep -roh "^[A-Z]" /var/log/ | sort -u | wc -l

# Contar archivos por extensión
find . -type f | awk -F. '{print $NF}' | sort | uniq -c | sort -rn
# Equivalente con wc -l después de filtrar:
find . -name "*.jpg" | wc -l   # cuántos JPG
find . -name "*.png" | wc -l   # cuántos PNG

# Con xargs: contar líneas de cada archivo por separado
find . -name "*.log" | xargs wc -l

# Con parallel: contar líneas en paralelo en logs grandes
find . -name "*.log" | parallel wc -l | awk '{s+=$1} END {print s}'
```

### Scripting

```bash
# Condicional: si un archivo tiene más de 100 líneas, procesarlo
if [ $(wc -l < archivo.txt) -gt 100 ]; then
    echo "El archivo es grande, procesando..."
fi

# Barra de progreso simple
total=$(wc -l < lista.txt)
actual=0
while read linea; do
    actual=$((actual + 1))
    echo -ne "Progreso: $actual/$total\r"
    # ... procesar línea
done < lista.txt
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `wc -l` muestra 1 menos de lo esperado | La última línea no tiene salto de línea (`\n`) al final | Es comportamiento normal. Muchos editores agregan `\n` automáticamente |
| `wc -c` y `ls -l` no coinciden en archivos sparse | Archivos con agujeros (sparse): `ls -l` muestra tamaño lógico, `du` muestra uso real en disco | `wc -c` lee byte por byte y reporta el tamaño lógico real. Para saber el espacio real en disco: `du --block-size=1 archivo` |
| UTF-8: `-c` vs `-m` dan resultados distintos | Caracteres multi-byte (acentos, emojis) | `-m` cuenta caracteres (más útil para texto), `-c` cuenta bytes |
| Pipeline lento con archivos muy grandes | `wc` debe leer todo el archivo | Usar `pv` para ver progreso: `pv archivo.log | wc -l` |
| `wc -L` devuelve 0 | Archivo vacío o solo contiene `\n` | Es correcto — un archivo vacío no tiene líneas con caracteres |

## Notas y advertencias
- Sin flags, `wc` imprime tres columnas: líneas, palabras y bytes.
- `wc -l` es probablemente el uso más frecuente, sobre todo con pipes para contar resultados.
- `wc -m` vs `-c`: en UTF-8, un carácter multi-byte (acentos, emojis) cuenta como 1 con `-m` y como varios con `-c`.
- `wc -l < archivo` (redirección de entrada) solo imprime el número, sin el nombre del archivo — útil para scripts que solo necesitan el valor numérico.
- Para archivos enormes (GB), `wc` es eficiente porque solo cuenta saltos de línea sin procesar el contenido. Pero si necesitas progreso, usa `pv archivo | wc -l`.

## Ver también
- [[sort]] — ordenar antes de contar
- [[uniq]] — eliminar duplicados antes de contar
- [[grep]] — filtrar antes de contar
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — wc](https://en.wikipedia.org/wiki/Wc_(Unix))
- [GNU Coreutils — wc manual](https://www.gnu.org/software/coreutils/manual/html_node/wc-invocation.html)

#comando
