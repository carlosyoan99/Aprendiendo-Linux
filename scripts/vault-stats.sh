#!/bin/bash
# vault-stats.sh — Muestra estadísticas del vault
# Ubicación: scripts/vault-stats.sh
# Uso: ./vault-stats.sh [opciones]
# Optimizado: single-pass grep con sort/uniq en vez de 5 grep -rl (~11s → <0.5s)

set -eo pipefail

# --- Configuración ---
VAULT_DIR="$(cd "$(dirname "$0")/../" && pwd)"

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

# --- Total de notas (excluyendo Templates) ---
TOTAL=$(find . -name "*.md" -not -path "./Templates/*" -not -path "./.obsidian/*" | wc -l)
TEMPLATES=$(find ./Templates -name "*.md" | wc -l)

# --- Single-pass: extraer estado + prioridad + categoría de una sola vez ---
# Un solo grep -rh con sort/uniq, procesado con awk
RAW=$(grep -rh "^estado:\|^prioridad:\|^categoria:" --include="*.md" . --exclude-dir=Templates --exclude-dir=.obsidian 2>/dev/null | sort | uniq -c)

# Parsear resultados
BORRADOR=0; EN_PROGRESO=0; RESUELTO=0
ALTA=0; MEDIA=0; BAJA=0
declare -A CATEGORIAS

while IFS=' ' read -r count key value; do
    [[ -z "$key" ]] && continue
    # key puede ser "estado:", "prioridad:" o "categoria:"
    case "$key" in
        estado:)
            case "$value" in
                borrador) BORRADOR=$count ;;
                "en progreso") EN_PROGRESO=$count ;;
                resuelto) RESUELTO=$count ;;
            esac ;;
        prioridad:)
            case "$value" in
                alta) ALTA=$count ;;
                media) MEDIA=$count ;;
                baja) BAJA=$count ;;
            esac ;;
        categoria:)
            CATEGORIAS["$value"]=$count ;;
    esac
done <<< "$RAW"

# --- Por carpeta: find + awk en vez de bash loop ---
declare -A DIR_COUNTS
while IFS=' ' read -r count dir; do
    [[ -z "$dir" ]] && continue
    DIR_COUNTS["$dir"]=$count
done < <(find . -name "*.md" -not -path "./Templates/*" -not -path "./.obsidian/*" 2>/dev/null | awk -F/ '{count[$2]++} END{for(d in count) print count[d], d}' | sort -rn)

# --- Salida CSV ---
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
    for cat in "${!CATEGORIAS[@]}"; do
        echo "categoria_${cat},${CATEGORIAS[$cat]}"
    done
    exit 0
fi

# --- Salida formateada ---
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

# Para categorías: ordenar alfabéticamente
echo -e "${VERDE}📂 Por categoría:${SIN_COLOR}"
for cat in "${!CATEGORIAS[@]}"; do
    printf "  %-20s %s\n" "${cat}:" "${CATEGORIAS[$cat]}"
done | sort
echo ""

# Salida temprana para --resumen
if [[ "${1:-}" == "--resumen" ]]; then
    exit 0
fi

echo -e "${AZUL}📁 Por carpeta:${SIN_COLOR}"
for dir in "${!DIR_COUNTS[@]}"; do
    printf "  %-30s %s notas\n" "${dir}:" "${DIR_COUNTS[$dir]}"
done | sort
echo ""

# --- Últimas modificaciones ---
echo -e "${CIAN}🕐 Últimas modificaciones:${SIN_COLOR}"
if find . -maxdepth 0 -printf '' 2>/dev/null; then
    # GNU find (Linux)
    find . -name "*.md" -not -path "./Templates/*" -not -path "./.obsidian/*" -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -10 | while IFS= read -r line; do
        timestamp=$(echo "$line" | awk '{print $1}')
        archivo=$(echo "$line" | cut -d' ' -f2-)
        fecha=$(date -d "@$timestamp" "+%Y-%m-%d %H:%M" 2>/dev/null || echo "desconocida")
        printf "  %s  %s\n" "$fecha" "$archivo"
    done
else
    # BSD find (macOS) — fallback simple
    ls -lt $(find . -name "*.md" -not -path "./Templates/*" -not -path "./.obsidian/*") 2>/dev/null | head -10 | awk '{print $6, $7, $8, $9}'
fi
echo ""

echo -e "${NEGRITA}${AZUL}══════════════════════════════════════${SIN_COLOR}"
echo -e "💡 Sugerencia: usa ${AMARILLO}--csv${SIN_COLOR} para salida pipeable"
echo -e "💡 Sugerencia: usa ${AMARILLO}--resumen${SIN_COLOR} para versión breve"
