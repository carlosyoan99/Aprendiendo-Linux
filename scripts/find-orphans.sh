#!/bin/bash
# find-orphans.sh — Encuentra notas no enlazadas desde el MoC ni desde otras notas
# Ubicación: scripts/find-orphans.sh
# Uso: ./find-orphans.sh [opciones]
# Optimizado: arrays asociativos en vez de O(n*m) loop (~30s → <1s)

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
find-orphans.sh — Encuentra notas huérfanas (sin enlaces desde otras notas ni desde el MoC)

USO:
  ./find-orphans.sh              # Lista todas las notas huérfanas
  ./find-orphans.sh --moc-only   # Solo verifica contra el MoC
  ./find-orphans.sh --backlinks  # Además busca backlinks (quién enlaza a cada nota)
  ./find-orphans.sh --sugerencias  # Muestra sugerencias de dónde enlazar cada huérfana

EXCLUYE: Templates/ y .obsidian/

EOF
    exit 0
fi

cd "$VAULT_DIR"

MOC_FILE="00 - Indices y Mapas/MoC - Linux.md"
MOC_ONLY=false
BACKLINKS=false
SUGERENCIAS=false

for arg in "$@"; do
    case "$arg" in
        --moc-only) MOC_ONLY=true ;;
        --backlinks) BACKLINKS=true ;;
        --sugerencias) SUGERENCIAS=true ;;
    esac
done

# --- Verificar que el MoC existe ---
if [[ ! -f "$MOC_FILE" ]]; then
    echo -e "${ROJO}❌ No se encontró el MoC: $MOC_FILE${SIN_COLOR}"
    echo "   Asegúrate de ejecutar el script desde la raíz del vault."
    exit 1
fi

echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}  🔍 NOTAS HUÉRFANAS${SIN_COLOR}"
echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
echo ""

# ────────────────────────────────────────────────────────────
# Fase 1: Recolectar todas las notas del vault en un array asociativo
# Fase 2: Extraer todos los wikilinks del MoC en un array asociativo
# Fase 3: Comparar (O(1) lookup por nota)
# ────────────────────────────────────────────────────────────

# --- 1. Recolectar todas las notas .md ---
declare -A NOTAS_MAP  # nombre_sin_ext → ruta
declare -a NOTAS_LIST # lista ordenada para output
while IFS= read -r archivo; do
    basename=$(basename "$archivo" .md)
    NOTAS_MAP["$basename"]="$archivo"
    NOTAS_LIST+=("$archivo")
done < <(find . -name "*.md" -not -path "./Templates/*" -not -path "./.obsidian/*" -not -path "./scripts/*" | sort)
TOTAL=${#NOTAS_LIST[@]}

# --- 2. Extraer wikilinks del MoC (nombre [[link]] o [[link|alias]]) ---
declare -A MOC_LINKS_MAP
while IFS= read -r link; do
    # Extraer nombre real: [[nombre]] o [[nombre|alias]] → nombre
    nombre="${link##*|}"
    nombre="${nombre## }"
    nombre="${nombre%% }"
    MOC_LINKS_MAP["$nombre"]=1
done < <(grep -oP '\[\[([^\]]+)\]\]' "$MOC_FILE" 2>/dev/null | sed 's/\[\[//;s/\]\]//' || true)
MOC_COUNT=${#MOC_LINKS_MAP[@]}

# --- 3. Si --backlinks, extraer TODOS los wikilinks de todas las notas ---
declare -A ALL_LINKS_MAP
if $BACKLINKS || $SUGERENCIAS; then
    while IFS= read -r link; do
        nombre="${link##*|}"
        nombre="${nombre## }"
        nombre="${nombre%% }"
        ALL_LINKS_MAP["$nombre"]=1
    done < <(grep -roP '\[\[([^\]]+)\]\]' --include="*.md" . 2>/dev/null | \
             grep -v "./Templates/" | grep -v "./.obsidian/" | \
             sed 's/.*\[\[//;s/\]\]//' || true)
fi

# --- 4. Detectar huérfanas: nota no está en el MoC ---
HUERFANAS=()
HUERFANAS_MOC=()

for archivo in "${NOTAS_LIST[@]}"; do
    BASENAME=$(basename "$archivo" .md)

    # Saltar archivos de estructura
    case "$BASENAME" in
        "Log"|"MoC - Linux"|"Dashboard"|"Rutas de Aprendizaje"|"CLAUDE"|"README")
            continue ;;
    esac

    # Saltar MoC y Log
    [[ "$archivo" == *"MoC - Linux.md" || "$archivo" == *"Log.md" ]] && continue

    # Verificar si está en el MoC (O(1) lookup)
    IN_MOC=false
    [[ -v MOC_LINKS_MAP["$BASENAME"] ]] && IN_MOC=true

    if ! $IN_MOC; then
        HUERFANAS_MOC+=("$archivo")
    fi

    # Si --moc-only, terminamos
    if $MOC_ONLY; then
        if ! $IN_MOC; then
            HUERFANAS+=("$archivo")
        fi
        continue
    fi

    # Verificar backlinks (O(1) lookup)
    if $BACKLINKS; then
        if ! $IN_MOC && [[ ! -v ALL_LINKS_MAP["$BASENAME"] ]]; then
            HUERFANAS+=("$archivo")
        fi
    else
        if ! $IN_MOC; then
            HUERFANAS+=("$archivo")
        fi
    fi
done

# --- 5. Mostrar resultados ---
if [[ ${#HUERFANAS[@]} -eq 0 ]]; then
    echo -e "${VERDE}✅ No hay notas huérfanas. Todas están enlazadas desde el MoC.${SIN_COLOR}"
    echo ""
    echo -e "${CIAN}📊 Total notas analizadas:${SIN_COLOR} $TOTAL"
    echo -e "${CIAN}📊 Links en el MoC:${SIN_COLOR}      $MOC_COUNT"
    exit 0
fi

echo -e "${AMARILLO}📄 ${#HUERFANAS[@]} nota(s) huérfana(s)${SIN_COLOR}"
echo ""

for nota in "${HUERFANAS[@]}"; do
    BASENAME=$(basename "$nota" .md)
    echo -e "${ROJO}⚠️  ${SIN_COLOR}${NEGRITA}$nota${SIN_COLOR}"

    if $SUGERENCIAS; then
        DIR=$(dirname "$nota")
        SUGERENCIA=""
        case "$DIR" in
            *"Conceptos"*)  SUGERENCIA="Agregar bajo '## Fundamentos' en el MoC" ;;
            *"Comandos"*)   SUGERENCIA="Agregar bajo '## Terminal y comandos' en el MoC" ;;
            *"Programas"*)  SUGERENCIA="Agregar bajo '## Programas comunes' en el MoC" ;;
            *"Instalacion"*) SUGERENCIA="Agregar bajo '## Instalación' en el MoC" ;;
            *"Distribuciones"*) SUGERENCIA="Agregar bajo '## Distribuciones' en el MoC" ;;
            *"Escritorio"*|*"Gestores"*) SUGERENCIA="Agregar bajo '## Entornos gráficos' en el MoC" ;;
            *"Automatizacion"*) SUGERENCIA="Agregar bajo '## Operativa' en el MoC" ;;
            *) SUGERENCIA="Agregar en la sección correspondiente del MoC" ;;
        esac
        echo -e "   💡 ${CIAN}$SUGERENCIA${SIN_COLOR}"
    fi
    echo ""
done

# --- Resumen ---
echo -e "${CIAN}📊 Total notas analizadas:${SIN_COLOR} $TOTAL"
echo -e "${CIAN}📊 Links en el MoC:${SIN_COLOR}      $MOC_COUNT"
echo ""
echo -e "${AMARILLO}💡 Para agregar una nota al MoC, edita:${SIN_COLOR}"
echo "   $MOC_FILE"
