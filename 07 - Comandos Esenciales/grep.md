---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: comando
prioridad: alta
---

# grep

## Sintaxis
```bash
grep [opciones] patrón [archivo...]
```

## Descripción

`grep` busca líneas que coincidan con un patrón (texto literal o expresión regular) dentro de uno o más archivos o de la entrada estándar. Es la herramienta fundamental para buscar y filtrar texto en Linux, esencial para analizar logs, depurar código y procesar pipelines.

El nombre viene del comando `ed`: **g**lobal **r**egular **e**xpression **p**rint.

## Opciones frecuentes

### Búsqueda básica

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-i` | Ignora mayúsculas/minúsculas | `grep -i "error" log.txt` |
| `-v` | Invierte: muestra líneas que NO coinciden | `grep -v "#" config.conf` |
| `-c` | Cuenta cuántas líneas coinciden | `grep -c "TODO" *.py` |
| `-n` | Muestra número de línea | `grep -n "error" log.txt` |
| `-l` | Muestra solo nombres de archivo (no las líneas) | `grep -l "main" *.c` |
| `-L` | Muestra archivos que NO contienen el patrón | `grep -L "LICENSE" *` |
| `-o` | Muestra solo la parte coincidente (no toda la línea) | `grep -o "[0-9]\+" data.txt` |

### Búsqueda recursiva

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-r` o `-R` | Búsqueda recursiva en directorios | `grep -r "TODO" ./src` |
| `--include=*.txt` | Solo archivos que coincidan con el patrón glob | `grep -r --include="*.py" "class" .` |
| `--exclude=*.log` | Excluye archivos que coincidan | `grep -r --exclude="*.min.*" "error" .` |
| `--exclude-dir=.git` | Excluye directorios | `grep -r --exclude-dir=node_modules "import" .` |

### Contexto

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-A N` | N líneas **después** (After) de la coincidencia | `grep -A 3 "ERROR" log.txt` |
| `-B N` | N líneas **antes** (Before) | `grep -B 2 "CRITICAL" log.txt` |
| `-C N` | N líneas de **contexto** (antes y después) | `grep -C 5 "Segmentation" log.txt` |

### Expresiones regulares

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-E` | Regex extendida (ERE, como `egrep`) | `grep -E "foo|bar" file.txt` |
| `-P` | Regex Perl (PCRE, más potente) | `grep -P "\\d{3}-\\d{3}" file.txt` |
| `-w` | Coincidencia de **palabra completa** | `grep -w "class" file.py` |
| `-x` | Coincidencia de **línea completa** | `grep -x "// TODO" file.c` |
| `-e` | Múltiples patrones (o usa `\|` con `-E`) | `grep -e "error" -e "warning" log.txt` |
| `-f` | Patrones desde un archivo (uno por línea) | `grep -f patrones.txt datos.txt` |

## Expresiones regulares básicas

### BRE (Basic Regex): por defecto

| Patrón | Significado | Ejemplo |
|---|---|---|
| `.` | Cualquier carácter (1) | `g.rep` → "grep", "gxrep", "g3rep" |
| `*` | 0 o más repeticiones del carácter anterior | `ab*c` → "ac", "abc", "abbc" |
| `^` | Inicio de línea | `^Error` → líneas que empiezan por "Error" |
| `$` | Final de línea | `done$` → líneas que terminan en "done" |
| `[abc]` | Un carácter del conjunto | `gr[ae]y` → "gray" o "grey" |
| `[^abc]` | Un carácter NO del conjunto | `[^0-9]` → cualquier carácter no dígito |
| `\(` y `\)` | Grupo (escapado en BRE) | `\(foo\)bar` → grupo "foo" |
| `\1` a `\9` | Referencia a grupo anterior | `\(a\)b\1` → "aba" |

### ERE (Extended Regex): con `-E`

| Patrón | Significado | Ejemplo |
|---|---|---|
| `+` | 1 o más repeticiones | `ab+c` → "abc", "abbc" (no "ac") |
| `?` | 0 o 1 repetición | `ab?c` → "ac", "abc" |
| `{n,m}` | Entre n y m repeticiones | `a{3,5}` → "aaa", "aaaa", "aaaaa" |
| `\|` | Alternancia (OR) | `foo\|bar` → "foo" o "bar" |
| `()` | Grupo (sin escapar) | `(foo)+` → "foo", "foofoo" |

### PCRE (Perl Compatible): con `-P`

| Patrón | Significado | Ejemplo |
|---|---|---|
| `\d` | Dígito (como `[0-9]`) | `\d{3}` → tres dígitos |
| `\w` | Carácter de palabra (`[a-zA-Z0-9_]`) | `\w+` → una palabra |
| `\s` | Espacio en blanco | `\s+` → uno o más espacios |
| `\b` | Límite de palabra | `\berror\b` → "error" pero no "errors" o "error404" |
| `(?=...)` | Lookahead positivo | `foo(?=bar)` → "foo" solo si va seguido de "bar" |
| `(?!...)` | Lookahead negativo | `foo(?!bar)` → "foo" si NO va seguido de "bar" |

## Ejemplos de uso

```bash
# Búsqueda básica recursiva
grep -rn "TODO" ./src

# Buscar en logs de sistema
sudo grep -i "error" /var/log/syslog
sudo journalctl | grep -i "failed"

# Buscar palabras completas
grep -w "class" *.py

# Filtrar comentarios y líneas vacías de un archivo de configuración
grep -v "^#" /etc/ssh/sshd_config | grep -v "^$"

# Buscar múltiples patrones
grep -E "ERROR|WARN|CRITICAL" app.log

# Buscar con contexto
grep -C 3 "Segmentation fault" ~/.xsession-errors

# Contar ocurrencias de una palabra en varios archivos
grep -ro "function" ./src | wc -l

# Buscar archivos que contienen un patrón (solo nombres)
grep -rl "main" *.c

# Buscar IPs en logs
grep -E "\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b" access.log

# Buscar correos electrónicos
grep -E "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b" data.txt

# Excluir directorios específicos
grep -r --exclude-dir=node_modules --exclude-dir=.git "import" .

# Mostrar solo la parte coincidente
grep -oP "https?://[^\s]+" archivo.txt

# Buscar líneas que NO contienen un patrón EN UN ARCHIVO
grep -v "success" log.txt
```

## Casos de uso reales

```bash
# 1. Buscar todos los FIXME y TODO en un proyecto
grep -rn --include="*.{js,ts,py,go,rs}" -e "TODO" -e "FIXME" -e "HACK" .

# 2. Analizar logs de acceso web (top IPs)
grep -oP "\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b" access.log | sort | uniq -c | sort -rn | head -10

# 3. Filtrar procesos por nombre
ps aux | grep firefox | grep -v grep

# 4. Buscar en todos los archivos de configuración
sudo grep -r "PermitRootLogin" /etc/

# 5. Verificar que un puerto está en uso (combinado con netstat)
sudo netstat -tlnp | grep :80

# 6. Buscar palabras en PDFs (combinado con pdftotext)
pdftotext documento.pdf - | grep "importante"

# 7. Encontrar archivos con BOM (UTF-8 BOM)
grep -rl $'\xEF\xBB\xBF' .

# 8. Buscar en logs del kernel
dmesg | grep -i "error\|fail\|warn"
```

## Variantes de grep

| Comando | Equivale a | Diferencia |
|---|---|---|
| `grep` | — | BRE (Basic Regular Expressions) por defecto |
| `grep -E` | `egrep` | ERE (Extended) — +, ?, \|, {n,m} sin escapar |
| `grep -F` | `fgrep` | Texto literal (no regex) — más rápido |
| `grep -P` | — | PCRE (Perl Compatible) — más potente, no siempre disponible |
| `rg` o `ripgrep` | — | Alternativa moderna, más rápida, busca en binarios |

> **Nota**: `egrep`, `fgrep` y `rgrep` están obsoletos. Siempre usar `grep -E`, `grep -F` o `grep -r`.

## grep vs ripgrep (rg)

| Característica | grep | ripgrep |
|---|---|---|
| **Velocidad** | Buena | Excelente (ignora .gitignore, binarios, paralelismo) |
| **Regex por defecto** | BRE (básico) | ERE completo |
| **Unicode** | Limitado | Excelente |
| **Disponibilidad** | En toda distro | Instalación adicional |
| **Sintaxis** | Universal | Similar a grep pero con extras |

```bash
# ripgrep (instalación)
sudo apt install ripgrep        # Debian/Ubuntu
sudo pacman -S ripgrep          # Arch
sudo dnf install ripgrep        # Fedora

# grep vs ripgrep (misma búsqueda)
grep -rn --include="*.py" "class" .
rg -t py "class" .              # más simple y rápido
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `grep: argument list too long` | Demasiados archivos | Usar `find . -exec grep "p" {} +` o `grep -r` |
| No encuentra nada con `^` o `$` | Usando `^` en medio de línea | `^` solo coincide al inicio, `$` solo al final |
| El patrón con `*` no funciona como espera | `*` en regex ≠ `*` en shell | En regex, `*` = \"0 o más del carácter anterior\" |
| `grep -P` no disponible | PCRE no compilado en esta versión | Usar `grep -E` o instalar `pcregrep` |
| Archivos binarios: `Binary file matches` | grep detecta binario | `grep -a` (tratar como texto) o `grep -I` (ignorar binarios) |
| Resultados muestra todo el archivo | El patrón es demasiado general | Usar `-w` (palabra completa) o refinar la regex |
| `grep -r` incluye archivos binarios | Sin filtro de extensión | Usar `--include=*.{py,js,txt}` o `-I` |

## Buenas prácticas

1. **Siempre usar `-n`** para saber la línea exacta de la coincidencia
2. **Usar `-r` en lugar de `-l` solo** — combina con `-n` para contexto completo
3. **Citar el patrón** con comillas simples para evitar que el shell lo expanda
4. **Usar `--exclude-dir`** en proyectos con node_modules, .git, build, etc.
5. **Prefijar con `LC_ALL=C`** si buscas en ASCII puro (hasta 5× más rápido):
   ```bash
   LC_ALL=C grep -r "DEBUG" .
   ```
6. **Combinar con `sort | uniq -c`** para contar ocurrencias
7. **Usar `ripgrep`** si haces búsquedas frecuentes en proyectos grandes

## Ver también

- [[find]] — buscar archivos por nombre, fecha, tamaño
- [[sed y awk]] — procesar y transformar texto
- [[xargs]] — construir comandos desde resultados
- [[less]] — ver archivos con búsqueda integrada (/patrón)
- [[tail]] — ver final de archivos en tiempo real (-f)

## Enlaces externos

- [GNU Grep manual](https://www.gnu.org/software/grep/manual/grep.html)
- [Arch Wiki — grep](https://wiki.archlinux.org/title/Grep)
- [Linux man page — grep](https://man.archlinux.org/man/grep.1)
- [ExplainShell — grep](https://explainshell.com/explain?cmd=grep)
- [Regex101](https://regex101.com/) — probar expresiones regulares online
- [ripgrep GitHub](https://github.com/BurntSushi/ripgrep)

#comando
