---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: comando
prioridad: alta
---

# find

## Sintaxis
```bash
find [ruta...] [expresión]
```

## Descripción

`find` busca archivos y directorios recorriendo el árbol de directorios recursivamente, filtrando por nombre, tipo, tamaño, fecha, permisos y otros atributos. Es la herramienta más potente para localizar archivos en Linux y base de muchas operaciones automatizadas.

## Opciones frecuentes

### Filtros por nombre

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-name "patrón"` | Busca por nombre exacto (admite `*`, `?`, `[]`) | `-name "*.log"` |
| `-iname "patrón"` | Como `-name` pero ignorando mayúsculas/minúsculas | `-iname "*.jpg"` |
| `-path "patrón"` | Busca por ruta completa relativa | `-path "*/src/*"` |
| `-ipath "patrón"` | `-path` case-insensitive | `-ipath "*/.git/*"` |
| `-regex "patrón"` | Usa regex en lugar de wildcards | `-regex ".*\.log\.[0-9]+"` |

### Filtros por tipo

| Flag | Efecto |
|---|---|
| `-type f` | Solo archivos regulares |
| `-type d` | Solo directorios |
| `-type l` | Solo enlaces simbólicos |
| `-type s` | Solo sockets |
| `-type p` | Solo named pipes (FIFO) |
| `-type b` | Solo dispositivos de bloque |
| `-type c` | Solo dispositivos de caracter |

### Filtros por fecha y tiempo

| Flag | Efecto |
|---|---|
| `-atime -7` | Accedido hace menos de 7 días |
| `-atime +30` | Accedido hace más de 30 días |
| `-mtime -1` | Modificado hace menos de 24h |
| `-mtime +90` | No modificado en 90+ días |
| `-amin -60` | Accedido hace menos de 60 minutos |
| `-mmin -30` | Modificado hace menos de 30 minutos |
| `-newer archivo` | Modificado más recientemente que `archivo` |
| `-daystart` | Calcula desde el inicio del día (no de 24h atrás) |

### Filtros por tamaño

| Flag | Efecto |
|---|---|
| `-size +100M` | Mayor a 100 MB |
| `-size -1G` | Menor a 1 GB |
| `-size 1024k` | Exactamente 1024 KB |
| `-empty` | Archivos vacíos o directorios vacíos |

Sufijos de tamaño: `c` (bytes), `k` (KiB), `M` (MiB), `G` (GiB)

### Filtros por permisos

| Flag | Efecto |
|---|---|
| `-perm 644` | Permisos exactamente 644 |
| `-perm -4000` | Bit SUID activado (permiso 4xxx) |
| `-perm /u=w` | El usuario propietario puede escribir |
| `-perm /g+w` | El grupo puede escribir |

## Acciones sobre los resultados

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-print` | Muestra rutas (por defecto) | `-print` |
| `-ls` | Muestra en formato `ls -dils` | `-ls` |
| `-exec comando {} ;` | Ejecuta comando por cada resultado | `-exec rm {} ;` |
| `-exec comando {} +` | Ejecuta comando una vez con todos los resultados | `-exec chmod 644 {} +` |
| `-ok comando {} ;` | Como `-exec` pero pide confirmación | `-ok rm {} ;` |
| `-printf "formato"` | Formato personalizado de salida | `-printf "%s %p\n"` |
| `-delete` | Elimina los archivos encontrados | `-delete` |

## Ejemplos de uso

```bash
# Buscar archivos .log modificados en la última semana
find /var/log -name "*.log" -mtime -7

# Buscar archivos de más de 100 MB en home
find ~ -type f -size +100M

# Buscar y eliminar archivos temporales
find /tmp -type f -atime +7 -delete

# Buscar archivos con permisos incorrectos
find /etc -type f -perm -o+w

# Buscar directorios vacíos
find ~ -type d -empty

# Buscar archivos SUID (riesgo de seguridad)
find /usr -type f -perm -4000

# Buscar archivos por extensión (ignorando mayúsculas)
find . -iname "*.jpg" -o -iname "*.png"

# Ejecutar comando sobre resultados
find . -name "*.bak" -exec rm {} \;

# Contar archivos por tipo
find . -type f -name "*.js" | wc -l
find . -type f -name "*.css" | wc -l

# Copiar archivos encontrados a otro directorio
find . -name "*.conf" -exec cp {} /backup/ \;

# Buscar archivos modificados después de una fecha de referencia
touch /tmp/reference
find . -newer /tmp/reference -type f

# Buscar archivos sin permiso de lectura para el propietario
find ~ -type f ! -readable

# Buscar y mostrar tamaño de archivos ordenados (combinado con sort)
find . -type f -size +10M -printf "%s %p\n" | sort -rn | head -10

# Buscar archivos que no sean ni .git ni node_modules
find . -type f -not -path "*/.git/*" -not -path "*/node_modules/*"
```

## Casos de uso reales

```bash
# Limpiar logs de más de 30 días
sudo find /var/log -name "*.log" -mtime +30 -delete

# Encontrar y eliminar archivos duplicados (por nombre y tamaño)
find . -type f -name "*.mp3" -printf "%f %s %p\n" | sort | uniq -d

# Buscar archivos con caracteres extraños (espacios, paréntesis)
find . -name "*[()]*" -o -name "* *"

# Buscar core dumps del sistema
find / -name "core" -o -name "*.core" 2>/dev/null

# Verificar permisos inseguros en archivos compartidos
find /home -type f -perm /o+w -not -type l
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `find: paths must precede expression` | Olvidaste comillas en el patrón | Usar `find . -name "*.txt"` (con comillas) |
| `Permission denied` | Sin permisos en directorios del sistema | Redirigir errores: `find / -name "x" 2>/dev/null` |
| `Argument list too long` con `-exec {} +` | Demasiados resultados | Usar `-exec {} ;` (uno por uno) o `xargs` |
| No encuentra nada con `-regex` | La regex debe coincidir con la **ruta completa** | `-regex ".*\.txt"` para archivos .txt |
| `find -perm -4000` muestra archivos sin SUID | Confundir `-` y `/` | `-perm -4000` = todos los bits; `-perm /4000` = cualquier bit |
| Buscar archivos por contenido | `find` no busca contenido | Usar `grep -r` o combinar: `find . -exec grep -l "patrón" {} +` |

## Buenas prácticas

1. **Siempre probar con `-print`** antes de usar `-delete` o `-exec rm`
2. **Usar `-exec {} +`** en lugar de `-exec {} ;` cuando sea posible (mucho más rápido)
3. **Comillas alrededor de patrones** con `*` para evitar que el shell los expanda
4. **Redirigir errores** con `2>/dev/null` al buscar en `/` (permisos denegados)
5. **Usar `-iname`** para búsquedas más flexibles
6. **Combinar con `xargs`** para operaciones masivas:
   ```bash
   find . -name "*.log" -print0 | xargs -0 rm
   ```
7. **Limitar profundidad** en directorios grandes:
   ```bash
   find . -maxdepth 3 -name "*.py"
   ```

## Ver también

- [[grep]] — buscar contenido dentro de archivos
- [[xargs]] — construir y ejecutar comandos desde stdin
- locate — alternativa más rápida (base de datos indexada, instalar con `sudo apt install locate`)
- [[tee]] — redirigir salida a archivo y terminal
- [[sed y awk]] — procesar archivos encontrados

## Enlaces externos

- [Arch Wiki — find](https://wiki.archlinux.org/title/Find)
- [GNU Findutils manual](https://www.gnu.org/software/findutils/manual/html_mono/find.html)
- [Linux man page — find](https://man.archlinux.org/man/find.1)
- [ExplainShell — find](https://explainshell.com/explain?cmd=find)

#comando
