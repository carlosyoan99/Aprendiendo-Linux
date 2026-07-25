#!/bin/bash
# vault-stats.sh — Muestra estadísticas del vault
# Ubicación: 10 - Automatizacion y Scripts/scripts/vault-stats.sh
# Uso: ./vault-stats.sh [opciones]

set -eo pipefail

# --- Configuración ---
VAULT_DIR="$(cd "$(dirname "$0")/../../" && pwd)"

# --- Colores ---
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARILLO='\033[1;33m'
MAGENTA='\033[0;35m'
CIAN='\033[0;36m'
SIN_COLOR='\033[0m'
NEGRITA='\033[1m'

# --- Ayuda ---
if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
    cat <<EOF
vault-stats.sh — Muestra estadísticas del vault

USO:
  ./vault-stats.sh              # Estadísticas completas
  ./vault-stats.sh --resumen    # Solo resumen breve
  ./vault-stats.sh --csv         # Salida en CSV (pipeable)

EOF
    exit 0
fi

cd "$VAULT_DIR"

# --- Contar notas (excluyendo Templates y .obsidian) ---
TOTAL=$(find . -name "*.md" -not -path "./Templates/*" -not -path "./.obsidian/*" | wc -l)
TEMPLATES=$(find ./Templates -name "*.md" | wc -l)

# --- Por estado ---
BORRADOR=$(grep -rl "estado: borrador" --include="*.md" . | grep -v "./Templates/" | grep -v "./.obsidian/" | wc -l)
EN_PROGRESO=$(grep -rl "estado: en progreso" --include="*.md" . | grep -v "./Templates/" | grep -v "./.obsidian/" | wc -l)
RESUELTO=$(grep -rl "estado: resuelto" --include="*.md" . | grep -v "./Templates/" | grep -v "./.obsidian/" | wc -l)

# --- Por categoría ---
declare -A CAT_COUNTS=()
while IFS= read -r line; do
    cat="${line#categoria: }"
    cat="${cat%%$'\r'}"
    if [[ -n "$cat" ]]; then
        CAT_COUNTS["$cat"]=$(( ${CAT_COUNTS["$cat"]:-0} + 1 ))
    fi
done < <(grep -rh "^categoria:" --include="*.md" . | grep -v "./Templates/" | grep -v "./.obsidian/")

# --- Por prioridad ---
ALTA=$(grep -rl "prioridad: alta" --include="*.md" . | grep -v "./Templates/" | grep -v "./.obsidian/" | wc -l)
MEDIA=$(grep -rl "prioridad: media" --include="*.md" . | grep -v "./Templates/" | grep -v "./.obsidian/" | wc -l)
BAJA=$(grep -rl "prioridad: baja" --include="*.md" . | grep -v "./Templates/" | grep -v "./.obsidian/" | wc -l)

# --- Por carpeta ---
declare -A DIR_COUNTS
while IFS= read -r archivo; do
    dir=$(dirname "$archivo" | sed 's|^\./||')
    if [[ "$dir" != "." && "$dir" != "Templates" && "$dir" != ".obsidian" && "$dir" != *".obsidian"* ]]; then
        ((DIR_COUNTS["$dir"]++)) || true
    fi
done < <(find . -name "*.md" -not -path "./Templates/*" -not -path "./.obsidian/*" 2>/dev/null)

# --- Últimas modificaciones ---
if find . -maxdepth 0 -printf '' 2>/dev/null; then
    # GNU find (Linux)
    ULTIMOS=$(find . -name "*.md" -not -path "./Templates/*" -not -path "./.obsidian/*" -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -10)
else
    # BSD find (macOS) — fallback simple
    ULTIMOS=$(ls -lt $(find . -name "*.md" -not -path "./Templates/*" -not -path "./.obsidian/*") 2>/dev/null | head -10 | awk '{print $6, $7, $8, $9}')
fi

# --- Output ---

if [[ "${1:-}" == "--csv" ]]; then
    echo "metrico,valor"
    echo "total,$TOTAL"
    echo "templates,$TEMPLATES"
    echo "borrador,$BORRADOR"
    echo "en_progreso,$EN_PROGRESO"
    echo "resuelto,$RESUELTO"
    echo "prioridad_alta,$ALTA"
    echo "prioridad_media,$MEDIA"
    echo "prioridad_baja,$BAJA"
    for cat in "${!CAT_COUNTS[@]}"; do
        echo "categoria_${cat},${CAT_COUNTS[$cat]}"
    done
    exit 0
fi

echo -e "${NEGRITA}${AZUL}══════════════════════════════════════${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}  📊 ESTADÍSTICAS DEL VAULT${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}══════════════════════════════════════${SIN_COLOR}"
echo ""
echo -e "${CIAN}📄 Total de notas:${SIN_COLOR}       ${NEGRITA}$TOTAL${SIN_COLOR} (excl. templates)"
echo -e "${CIAN}📋 Plantillas:${SIN_COLOR}           ${NEGRITA}$TEMPLATES${SIN_COLOR}"
echo ""

echo -e "${AMARILLO}📌 Por estado:${SIN_COLOR}"
printf "  %-20s %s\n" "Borrador:" "$BORRADOR"
printf "  %-20s %s\n" "En progreso:" "$EN_PROGRESO"
printf "  %-20s %s\n" "Resuelto:" "$RESUELTO"
echo ""

echo -e "${MAGENTA}🎯 Por prioridad:${SIN_COLOR}"
printf "  %-20s %s\n" "Alta:" "$ALTA"
printf "  %-20s %s\n" "Media:" "$MEDIA"
printf "  %-20s %s\n" "Baja:" "$BAJA"
echo ""

echo -e "${VERDE}📂 Por categoría:${SIN_COLOR}"
for cat in "${!CAT_COUNTS[@]}"; do
    printf "  %-20s %s\n" "${cat}:" "${CAT_COUNTS[$cat]}"
done
echo ""

echo -e "${AZUL}📁 Por carpeta:${SIN_COLOR}"
for dir in "${!DIR_COUNTS[@]}"; do
    printf "  %-30s %s notas\n" "${dir}:" "${DIR_COUNTS[$dir]}"
done | sort
echo ""

echo -e "${CIAN}🕐 Últimas modificaciones:${SIN_COLOR}"
echo "$ULTIMOS" | while IFS= read -r line; do
    if [[ -n "$line" ]]; then
        timestamp=$(echo "$line" | awk '{print $1}')
        archivo=$(echo "$line" | cut -d' ' -f2-)
        fecha=$(date -d "@$timestamp" "+%Y-%m-%d %H:%M" 2>/dev/null || echo "desconocida")
        printf "  %s  %s\n" "$fecha" "$archivo"
    fi
done
echo ""

if [[ "${1:-}" == "--resumen" ]]; then
    exit 0
fi

echo -e "${NEGRITA}${AZUL}══════════════════════════════════════${SIN_COLOR}"
echo -e "💡 Sugerencia: usa ${AMARILLO}--csv${SIN_COLOR} para salida pipeable"
echo -e "💡 Sugerencia: usa ${AMARILLO}--resumen${SIN_COLOR} para versión breve"
