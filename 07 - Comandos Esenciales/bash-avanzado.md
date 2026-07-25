---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# Bash Avanzado

## Definición

Más allá de los comandos básicos, bash ofrece construcciones de programación completas: condicionales, bucles, funciones, arrays, manejo de señales y opciones de robustez. Este documento cubre lo que distingue un script ocasional de un script profesional.

> Para fundamentos de la shell, ver [[La Shell]]. Para comparativa de shells, ver [[Shells (bash zsh fish)]].

---

## Modo estricto: `set -euxo pipefail`

Siempre comenzar los scripts con estas opciones para detectar errores temprano:

```bash
#!/bin/bash
set -euo pipefail

# -e  : salir si un comando falla (exit code ≠ 0)
# -u  : salir si se usa una variable no definida
# -o pipefail: si un comando en un pipe falla, el pipe completo falla
# -x  : (opcional) mostrar cada comando antes de ejecutarlo (debug)

# Sin -u: echo "$nombre" → imprime vacío si nombre no está definida
# Con -u: echo "$nombre" → error y salida

# Forma completa (debug):
set -euxo pipefail

# Para scripts en producción, sin -x (verbose):
set -euo pipefail
```

```bash
# Alternativa: activar/desactivar por sección
set -x                                 # debug ON
comando_peligroso
set +x                                 # debug OFF
```

---

## Condicionales: `[[ ]]` (moderno)

Usar **doble corchete** `[[ ]]` en lugar de single `[ ]` (test). `[[ ]]` es más potente y seguro:

```bash
# [[ ]] vs [ ] — diferencias clave:
# [[ ]] no necesita escapar variables con comillas
# [[ ]] soporta regex =~, patrones con ==, operadores && || dentro

# Strings
if [[ "$nombre" == "carlos" ]]; then
    echo "Hola carlos"
fi

if [[ "$nombre" != "" ]]; then         # más legible que [ -n "$nombre" ]
    echo "Nombre no vacío"
fi

if [[ -z "$nombre" ]]; then            # vacío
    echo "Nombre requerido"
fi

# Archivos
if [[ -f "$archivo" ]]; then           # existe y es archivo regular
if [[ -d "$directorio" ]]; then        # existe y es directorio
if [[ -e "$ruta" ]]; then              # existe (cualquier tipo)
if [[ -x "$binario" ]]; then           # es ejecutable
if [[ -L "$enlace" ]]; then            # es symlink
if [[ -r "$archivo" ]]; then           # tiene permiso de lectura

# Números
if (( numero > 10 )); then             # (( )) para aritmética (NO [[ ]])
    echo "Mayor que 10"
fi

# Regex (la joya de [[ ]])
if [[ "$email" =~ ^[a-z]+@[a-z]+\.[a-z]{2,}$ ]]; then
    echo "Email válido"
fi

# Múltiples condiciones
if [[ "$distro" == "ubuntu" || "$distro" == "debian" ]]; then
    echo "Usas apt"
fi

if [[ -f "$config" && -r "$config" ]]; then
    echo "Config existe y es legible"
fi
```

---

## Bucles

### for
```bash
# Rango
for i in {1..5}; do
    echo "Número $i"
done

# Lista explícita
for app in nginx postgresql redis; do
    systemctl is-active "$app"
done

# Comando (cuidado con espacios en nombres)
for archivo in *.log; do
    wc -l "$archivo"
done

# C-style (como C/Java)
for (( i=0; i<10; i++ )); do
    echo $i
done

# Sobre líneas de un archivo
while IFS= read -r linea; do
    echo "Línea: $linea"
done < archivo.txt

# Sobre salida de un comando
while IFS= read -r -d '' dir; do
    du -sh "$dir"
done < <(find /home -maxdepth 1 -type d -print0)
```

### while / until
```bash
# Loop infinito con salida controlada
while true; do
    ping -c 1 google.com > /dev/null 2>&1 && break
    echo "Esperando red..."
    sleep 5
done

# until (ejecuta mientras la condición sea FALSA)
until ping -c 1 google.com > /dev/null 2>&1; do
    echo "Esperando red..."
    sleep 2
done
echo "Red disponible"
```

---

## `case` — Múltiples condiciones

```bash
case "$1" in
    start)
        echo "Iniciando servicio..."
        ;;
    stop|kill)
        echo "Deteniendo servicio..."
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    --verbose|-v)
        echo "Modo verbose"
        ;;
    *.txt)
        echo "Es un archivo de texto"
        ;;
    [0-9])
        echo "Es un dígito: $1"
        ;;
    *)
        echo "Uso: $0 {start|stop|restart}"
        exit 1
        ;;
esac
```

---

## Arrays

```bash
# Declaración
frutas=("manzana" "pera" "uva")
numeros=(1 2 3 4 5)
mixto=("hola" 42 "mundo" 3.14)

# Acceso
echo "${frutas[0]}"                    # manzana
echo "${frutas[-1]}"                   # uva (último elemento)
echo "${frutas[@]}"                    # todos los elementos
echo "${#frutas[@]}"                   # longitud del array (3)

# Iterar
for fruta in "${frutas[@]}"; do
    echo "Me gusta la $fruta"
done

# Añadir elementos
frutas+=("mango")
frutas+=("limón" "fresa")

# Eliminar elemento
unset frutas[1]                        # elimina "pera" (queda hueco)

# Arrays asociativos (bash 4+)
declare -A usuario
usuario[nombre]="Carlos"
usuario[edad]=30
usuario[pais]="Argentina"
echo "${usuario[nombre]}"              # Carlos
echo "${!usuario[@]}"                  # nombre edad pais (keys)
```

---

## Funciones

```bash
# Definición (sin palabra function es más portable)
saludar() {
    local nombre="$1"                  # local = variable local (no global)
    local mensaje="${2:-Hola}"         # valor por defecto
    echo "$mensaje, $nombre!"
}

# Llamar
saludar "Carlos" "Buenos días"

# Función con retorno
es_numero() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

if es_numero "42"; then
    echo "Es número"
fi

# Función que devuelve valor (con echo, no return)
get_os() {
    case "$(uname -s)" in
        Linux)  echo "linux" ;;
        Darwin) echo "macos" ;;
        *)      echo "unknown" ;;
    esac
}

os=$(get_os)
echo "Sistema: $os"
```

---

## `trap` — Manejo de señales

```bash
#!/bin/bash
set -euo pipefail

# Limpiar archivos temporales al salir (incluso si falla)
temp_dir=$(mktemp -d)
trap "rm -rf '$temp_dir'; echo '🧹 Limpieza completada'" EXIT

# Capturar Ctrl+C (SIGINT) y ejecutar algo antes de salir
trap "echo 'Interrupción recibida'; exit 1" INT

# Ignorar SIGTERM en procesos hijo
trap '' TERM

# Múltiples traps: el último prevalece, a menos que se encadenen
cleanup() {
    echo "Limpiando..."
    rm -rf "$temp_dir"
}
trap cleanup EXIT

# Señales comunes
# EXIT   → se ejecuta siempre al salir (incluso con exit o error)
# INT    → Ctrl+C
# TERM   → kill
# HUP    → recargar configuración (hangup)
# ERR    → cuando un comando falla (con set -e)
```

```bash
# Ejemplo práctico: script que monitorea y limpia
#!/bin/bash
set -euo pipefail

log_file="/tmp/mi-app.log"
pid_file="/tmp/mi-app.pid"

cleanup() {
    echo "Deteniendo..."
    [[ -f "$pid_file" ]] && kill "$(cat "$pid_file")" 2>/dev/null
    rm -f "$pid_file"
}
trap cleanup EXIT INT TERM
```

---

## Procesamiento con awk y sed

### awk — Procesar columnas y reportes

```bash
# awk es un lenguaje completo de procesamiento de texto
# Estructura: awk 'patrón {acción}' archivo

# Imprimir columnas específicas
awk '{print $1, $3}' /var/log/syslog     # primera y tercera columna
awk -F: '{print $1, $6}' /etc/passwd     # separador personalizado (:)

# Filtrar por patrón
awk '/error/ {print $1, $NF}' log.txt    # líneas con "error", primera y última columna

# Variables especiales
awk '{print NR, $0}' archivo.txt         # NR = número de línea

# Sumar columna numérica
awk '{sum += $3} END {print sum}' datos.csv

# Formatear salida
awk '{printf "%-20s %8.2f\\n", $1, $3}' datos.txt
```

> Ver [[awk]] para guía completa.

### sed — Stream editor

```bash
# sed procesa texto línea por línea (streaming)
# Estructura: sed 'rango/patrón/acción' archivo

# Sustitución básica
sed 's/viejo/nuevo/' archivo.txt         # primera ocurrencia por línea
sed 's/viejo/nuevo/g' archivo.txt        # todas las ocurrencias (g = global)
sed -i 's/viejo/nuevo/g' archivo.txt     # in-place (modifica el archivo)

# En líneas específicas
sed '5s/error/warning/' log.txt          # solo línea 5
sed '10,20s/debug/info/' log.txt         # líneas 10 a 20

# Eliminar líneas
sed '/^#/d' config.txt                   # eliminar comentarios
sed '/^$/d' archivo.txt                  # eliminar líneas vacías
sed -n '/patrón/p' archivo.txt           # solo mostrar líneas que coinciden

# Múltiples comandos
sed -e 's/foo/bar/g' -e 's/abc/xyz/g' archivo.txt
```

> Ver [[sed y awk]] para guía completa.

---

## Expansiones útiles

```bash
# ${var:-default} — valor por defecto si var no está definida
echo "${EDITOR:-nano}"

# ${var:+alternativo} — usar alternativo si var está definida
echo "${DEBUG:+Modo debug activado}"

# ${var:?mensaje} — error si var no está definida
: "${DB_PASSWORD:?Variable DB_PASSWORD requerida}"

# ${var%sufijo} — eliminar sufijo
archivo="imagen.jpg"
echo "${archivo%.jpg}"                   # imagen

# ${var#prefijo} — eliminar prefijo
ruta="/home/user/docs/file.txt"
echo "${ruta#/home/user/}"               # docs/file.txt

# ${var^^} — mayúsculas
# ${var,,} — minúsculas
nombre="carlos"
echo "${nombre^^}"                       # CARLOS
```

---

## Ver también

- [[sed y awk]] — procesamiento de texto avanzado
- [[awk]] — lenguaje de procesamiento de columnas
- [[La Shell]] — fundamentos de la terminal
- [[grep]] — búsqueda con regex
- [[Procesos y Senales]] — señales del sistema (SIGTERM, SIGKILL)
- [[Automatizacion y Scripts]] — scripts de automatización del vault

## Enlaces externos

- [Wikipedia - Bash (Unix shell)](https://en.wikipedia.org/wiki/Bash_(Unix_shell))
- [GNU Bash manual](https://www.gnu.org/software/bash/manual/)

#comando #scripting