#!/bin/bash
# check-frontmatter.sh — Verifica que todas las notas tengan frontmatter válido
# Optimizado: procesa todas las notas en un solo pase de awk (~0.15s en 318 notas)
# Ubicación: scripts/check-frontmatter.sh
# Uso: ./check-frontmatter.sh [opciones]

set -euo pipefail

# --- Configuración ---
VAULT_DIR="$(cd "$(dirname "$0")/../" && pwd)"

# --- Colores ---
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[0;34m'
CIAN='\033[0;36m'
SIN_COLOR='\033[0m'
NEGRITA='\033[1m'

# --- Ayuda ---
if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
    cat <<EOF
check-frontmatter.sh — Verifica el frontmatter de las notas del vault

USO:
  ./check-frontmatter.sh              # Verifica todas las notas
  ./check-frontmatter.sh --fix        # Intenta reparar errores simples
  ./check-frontmatter.sh --solo-errores  # Muestra solo las notas con errores
  ./check-frontmatter.sh "07 - Comandos Esenciales"  # Verifica solo una carpeta

REQUISITOS: Las notas de contenido deben tener:
  fecha_creacion (YYYY-MM-DD)
  estado (borrador | en progreso | resuelto)
  categoria (según CLAUDE.md)

EOF
    exit 0
fi

cd "$VAULT_DIR"

# --- Parsear argumentos ---
SEARCH_PATH="."
FIX_MODE=false
SOLO_ERRORES=false

for arg in "$@"; do
    case "$arg" in
        --fix) FIX_MODE=true ;;
        --solo-errores) SOLO_ERRORES=true ;;
        -h|--help) ;;  # ya manejado arriba
        *) SEARCH_PATH="$arg" ;;
    esac
done

# --- Recolectar archivos .md (excluyendo Templates y .obsidian) ---
mapfile -t ARCHIVOS < <(find "$SEARCH_PATH" -name "*.md" -not -path "*/Templates/*" -not -path "*/.obsidian/*" | sort)
TOTAL=${#ARCHIVOS[@]}

if [[ $TOTAL -eq 0 ]]; then
    echo -e "${AMARILLO}⚠️  No se encontraron archivos .md en: $SEARCH_PATH${SIN_COLOR}"
    exit 1
fi

# --- Cabecera ---
echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}  🔍 VERIFICACIÓN DE FRONTMATTER${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
echo ""

# ────────────────────────────────────────────────────────────
# Validación: un solo pase awk para TODAS las notas
# Cada línea de salida: FILENAME|código|mensaje
# ────────────────────────────────────────────────────────────
ERROR_RAW=$(awk '
BEGINFILE {
    has_fm = 0; fm_closed = 0
    has_fecha = 0; has_estado = 0; has_categoria = 0
    in_fm = 0
    last_nc = ""
}

# Primera línea: debe empezar con ---
FNR == 1 {
    if ($0 == "---") { has_fm = 1; in_fm = 1; next }
}

# Dentro del frontmatter
in_fm {
    if ($0 == "---") { in_fm = 0; fm_closed = 1; next }
    fm_lines++
    if (/^fecha_creacion:/)  has_fecha     = 1
    if (/^estado:/)           has_estado    = 1
    if (/^categoria:/)        has_categoria = 1
    next
}

# Fuera del frontmatter: última línea no vacía para hashtag
!in_fm && $0 !~ /^$/ { last_nc = $0 }

ENDFILE {
    if (!has_fm) {
        print FILENAME "|NOFM|Sin frontmatter (no empieza con ---)"
    } else if (!fm_closed) {
        print FILENAME "|NOEND|Frontmatter sin cerrar (falta --- final)"
    } else {
        if (!has_fecha)     print FILENAME "|NOFECHA|Sin fecha_creacion"
        if (!has_estado)    print FILENAME "|NOEST|Sin estado"
        if (!has_categoria) print FILENAME "|NOCAT|Sin categoria"
    }
    if (last_nc !~ /^#/)    print FILENAME "|NOHASH|Sin hashtag al final"
}
' "${ARCHIVOS[@]}" 2>/dev/null || true)

# ────────────────────────────────────────────────────────────
# Procesar resultados del awk
# ────────────────────────────────────────────────────────────
# Inicializar arrays asociativos (importante: los valores por defecto evitan errores con set -u)
declare -A COUNTS
COUNTS[NOFM]=0; COUNTS[NOEND]=0; COUNTS[NOFECHA]=0
COUNTS[NOEST]=0; COUNTS[NOCAT]=0; COUNTS[NOHASH]=0

declare -A ARCHIVOS_ERROR=()
declare -A ARCHIVOS_NOHASH=()  # para --fix

if [[ -n "$ERROR_RAW" ]]; then
    while IFS='|' read -r archivo codigo mensaje; do
        [[ -z "$archivo" || -z "$codigo" ]] && continue
        ARCHIVOS_ERROR["$archivo"]=1
        ((COUNTS[$codigo]++)) || true
        if [[ "$codigo" == "NOHASH" ]]; then
            ARCHIVOS_NOHASH["$archivo"]=1
        fi
    done <<< "$ERROR_RAW"
fi

# ────────────────────────────────────────────────────────────
# Mostrar errores
# ────────────────────────────────────────────────────────────
if [[ ${#ARCHIVOS_ERROR[@]} -gt 0 ]]; then
    # Agrupar mensajes por archivo para mostrar
    for archivo in "${!ARCHIVOS_ERROR[@]}"; do
        echo -e "${AMARILLO}📄 $archivo${SIN_COLOR}"
        # Extraer líneas de este archivo del RAW
        grep "^$archivo|" <<< "$ERROR_RAW" | while IFS='|' read -r _ codigo mensaje; do
            if [[ "$codigo" == "NOFM" || "$codigo" == "NOEND" ]]; then
                echo -e "  ${ROJO}❌ $mensaje${SIN_COLOR}"
            else
                echo -e "  ${AMARILLO}⚠️  $mensaje${SIN_COLOR}"
            fi
        done
        echo ""
    done
fi

OK=$((TOTAL - ${#ARCHIVOS_ERROR[@]}))

if ! $SOLO_ERRORES && [[ $OK -gt 0 ]]; then
    echo -e "${VERDE}✅ $OK notas sin errores${SIN_COLOR}"
    echo ""
fi

# ────────────────────────────────────────────────────────────
# Modo fix: reparar hashtags faltantes
# ────────────────────────────────────────────────────────────
FIXEADOS=0
if $FIX_MODE && [[ ${#ARCHIVOS_NOHASH[@]} -gt 0 ]]; then
    echo -e "${CIAN}🔧 Modo fix: reparando hashtags faltantes...${SIN_COLOR}"
    for archivo in "${!ARCHIVOS_NOHASH[@]}"; do
        # Extraer categoría del frontmatter (rápido con awk en un solo archivo)
        cat_=$(awk '/^---/{c++; next} c==1 && /^categoria:/{print $2; exit}' "$archivo" 2>/dev/null || echo "nota")
        echo "#${cat_}" >> "$archivo"
        echo -e "  ${VERDE}✅ Hashtag '#${cat_}' agregado: $archivo${SIN_COLOR}"
        ((FIXEADOS++)) || true
    done
fi

# ────────────────────────────────────────────────────────────
# Resumen
# ────────────────────────────────────────────────────────────
echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}  📊 RESUMEN${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
echo -e "${CIAN}Total notas analizadas:${SIN_COLOR}  $TOTAL"
echo -e "${VERDE}Notas OK:${SIN_COLOR}              $OK"
echo -e "${ROJO}Sin frontmatter:${SIN_COLOR}        ${COUNTS[NOFM]:-0}"
echo -e "${ROJO}Frontmatter sin cerrar:${SIN_COLOR} ${COUNTS[NOEND]:-0}"
echo -e "${AMARILLO}Sin fecha_creacion:${SIN_COLOR}    ${COUNTS[NOFECHA]:-0}"
echo -e "${AMARILLO}Sin estado:${SIN_COLOR}            ${COUNTS[NOEST]:-0}"
echo -e "${AMARILLO}Sin categoria:${SIN_COLOR}         ${COUNTS[NOCAT]:-0}"
echo -e "${AMARILLO}Sin hashtag final:${SIN_COLOR}     ${COUNTS[NOHASH]:-0}"
if $FIX_MODE; then
    echo -e "${VERDE}Reparaciones aplicadas:${SIN_COLOR}    $FIXEADOS"
fi
