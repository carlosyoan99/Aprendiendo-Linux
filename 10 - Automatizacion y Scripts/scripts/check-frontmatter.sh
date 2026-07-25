#!/bin/bash
# check-frontmatter.sh — Verifica que todas las notas tengan frontmatter válido
# Ubicación: 10 - Automatizacion y Scripts/scripts/check-frontmatter.sh
# Uso: ./check-frontmatter.sh [opciones]

set -euo pipefail

# --- Configuración ---
VAULT_DIR="$(cd "$(dirname "$0")/../../" && pwd)"

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

# --- Determinar ruta a escanear ---
SEARCH_PATH="."
if [[ -n "${1:-}" && "$1" != "--fix" && "$1" != "--solo-errores" ]]; then
    SEARCH_PATH="$1"
fi

# --- Flags ---
FIX_MODE=false
SOLO_ERRORES=false
for arg in "$@"; do
    case "$arg" in
        --fix) FIX_MODE=true ;;
        --solo-errores) SOLO_ERRORES=true ;;
    esac
done

# --- Recolectar archivos .md (excluyendo Templates y .obsidian) ---
mapfile -t ARCHIVOS < <(find "$SEARCH_PATH" -name "*.md" -not -path "./Templates/*" -not -path "./.obsidian/*" | sort)

if [[ ${#ARCHIVOS[@]} -eq 0 ]]; then
    echo -e "${AMARILLO}⚠️  No se encontraron archivos .md en: $SEARCH_PATH${SIN_COLOR}"
    exit 1
fi

# --- Contadores ---
TOTAL=0
OK=0
SIN_FRONTMATTER=0
SIN_FECHA=0
SIN_ESTADO=0
SIN_CATEGORIA=0
SIN_HASHTAG=0
FIXEADOS=0

echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}  🔍 VERIFICACIÓN DE FRONTMATTER${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
echo ""

for archivo in "${ARCHIVOS[@]}"; do
    ((TOTAL++)) || true
    ERRORES=""
    BASENAME=$(basename "$archivo")

    # --- Verificar que empiece con ---
    PRIMERA_LINEA=$(head -1 "$archivo")
    if [[ "$PRIMERA_LINEA" != "---" ]]; then
        ERRORES+="  ❌ Sin frontmatter (no empieza con ---)\n"
        ((SIN_FRONTMATTER++)) || true
    else
        # --- Extraer campos del frontmatter (awk es más confiable que sed para esto) ---
        FRONT=$(awk '/^---/{c++; next} c==1{print}' "$archivo")
        if [[ -z "$FRONT" ]]; then
            ERRORES+="  ❌ Frontmatter sin cerrar (falta --- final)\n"
            ((SIN_FRONTMATTER++)) || true
        else

            # Verificar fecha_creacion
            if ! echo "$FRONT" | grep -q "^fecha_creacion:"; then
                ERRORES+="  ⚠️  Sin fecha_creacion\n"
                ((SIN_FECHA++)) || true
            fi

            # Verificar estado
            if ! echo "$FRONT" | grep -q "^estado:"; then
                ERRORES+="  ⚠️  Sin estado\n"
                ((SIN_ESTADO++)) || true
            fi

            # Verificar categoria
            if ! echo "$FRONT" | grep -q "^categoria:"; then
                ERRORES+="  ⚠️  Sin categoria\n"
                ((SIN_CATEGORIA++)) || true
            fi
        fi
    fi

    # --- Verificar hashtag al final ---
    ULTIMAS_LINEAS=$(tail -3 "$archivo")
    if ! echo "$ULTIMAS_LINEAS" | grep -q "^#"; then
        ERRORES+="  ⚠️  Sin hashtag al final\n"
        ((SIN_HASHTAG++)) || true
    fi

    # --- Reportar errores ---
    if [[ -n "$ERRORES" ]]; then
        echo -e "${AMARILLO}📄 $archivo${SIN_COLOR}"
        echo -e "$ERRORES"

        # --- Modo fix: intentar reparar ---
        if $FIX_MODE; then
            # Solo arreglamos hashtag faltante por ahora (lo demás requiere decisión humana)
            if ! echo "$ULTIMAS_LINEAS" | grep -q "^#"; then
                # Agregar un hashtag genérico de categoría
                CAT=$(echo "$FRONT" | grep "^categoria:" | sed 's/^categoria: *//' 2>/dev/null || echo "nota")
                echo "#${CAT}" >> "$archivo"
                echo -e "  ${VERDE}✅ Hashtag '#${CAT}' agregado${SIN_COLOR}"
                ((FIXEADOS++)) || true
            fi
        fi
    else
        if ! $SOLO_ERRORES; then
            echo -e "${VERDE}✅ $BASENAME${SIN_COLOR}"
        fi
        ((OK++)) || true
    fi
done

# --- Resumen ---
echo ""
echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}  📊 RESUMEN${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
echo -e "${CIAN}Total notas analizadas:${SIN_COLOR}  $TOTAL"
echo -e "${VERDE}Notas OK:${SIN_COLOR}              $OK"
echo -e "${ROJO}Sin frontmatter:${SIN_COLOR}        $SIN_FRONTMATTER"
echo -e "${AMARILLO}Sin fecha_creacion:${SIN_COLOR}    $SIN_FECHA"
echo -e "${AMARILLO}Sin estado:${SIN_COLOR}            $SIN_ESTADO"
echo -e "${AMARILLO}Sin categoria:${SIN_COLOR}         $SIN_CATEGORIA"
echo -e "${AMARILLO}Sin hashtag final:${SIN_COLOR}     $SIN_HASHTAG"
if $FIX_MODE; then
    echo -e "${VERDE}Reparaciones aplicadas:${SIN_COLOR}    $FIXEADOS"
fi
