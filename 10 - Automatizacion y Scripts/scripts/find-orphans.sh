#!/bin/bash
# find-orphans.sh — Encuentra notas no enlazadas desde el MoC ni desde otras notas
# Ubicación: 10 - Automatizacion y Scripts/scripts/find-orphans.sh
# Uso: ./find-orphans.sh [opciones]

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

# --- 1. Recolectar todas las notas .md ---
mapfile -t TODAS_LAS_NOTAS < <(find . -name "*.md" -not -path "./Templates/*" -not -path "./.obsidian/*" -not -path "./10 - Automatizacion y Scripts/scripts/*" | sort)

# --- 2. Extraer wikilinks del MoC ---
MOC_LINKS=$(grep -oP '\[\[([^\]]+)\]\]' "$MOC_FILE" | sed 's/\[\[//;s/\]\]//' | sort -u)

# --- 3. Extraer TODOS los wikilinks de todas las notas (si --backlinks) ---
if $BACKLINKS || $SUGERENCIAS; then
    ALL_LINKS=$(grep -roP '\[\[([^\]]+)\]\]' --include="*.md" . | \
                grep -v "./Templates/" | grep -v "./.obsidian/" | \
                sed 's/.*\[\[//;s/\]\]//' | sort -u)
fi

# --- 4. Para cada nota, verificar si está enlazada ---
HUERFANAS=()
HUERFANAS_MOC=()

for nota in "${TODAS_LAS_NOTAS[@]}"; do
    # Extraer el nombre del archivo sin extensión y sin ruta
    BASENAME=$(basename "$nota" .md)

    # Saltar archivos que son parte de la estructura (Log, MoC, Dashboard, Rutas)
    if [[ "$BASENAME" == "Log" ]] || [[ "$BASENAME" == "MoC - Linux" ]] || \
       [[ "$BASENAME" == "Dashboard" ]] || [[ "$BASENAME" == "Rutas de Aprendizaje" ]] || \
       [[ "$BASENAME" == "CLAUDE" ]]; then
        continue
    fi

    # Saltar el propio MoC y el Log
    if [[ "$nota" == *"MoC - Linux.md" ]] || [[ "$nota" == *"Log.md" ]]; then
        continue
    fi

    # Verificar si está en el MoC
    IN_MOC=false
    while IFS= read -r link; do
        LINK_NAME="${link##*|}"
        LINK_NAME="${LINK_NAME## }"
        if [[ "$LINK_NAME" == "$BASENAME" ]] || [[ "$link" == "$BASENAME" ]]; then
            IN_MOC=true
            break
        fi
    done <<< "$MOC_LINKS"

    if ! $IN_MOC; then
        HUERFANAS_MOC+=("$nota")
    fi

    # Si --moc-only, saltar verificación de backlinks
    if $MOC_ONLY; then
        if ! $IN_MOC; then
            HUERFANAS+=("$nota")
        fi
        continue
    fi

    # Verificar si tiene backlinks (otras notas que la mencionan)
    if $BACKLINKS; then
        TIENE_BACKLINK=false
        while IFS= read -r link; do
            LINK_NAME="${link##*|}"
            LINK_NAME="${LINK_NAME## }"
            if [[ "$LINK_NAME" == "$BASENAME" ]] || [[ "$link" == "$BASENAME" ]]; then
                # Verificar que el enlace no venga de la misma nota
                TIENE_BACKLINK=true
                break
            fi
        done <<< "$ALL_LINKS"

        if ! $TIENE_BACKLINK && ! $IN_MOC; then
            HUERFANAS+=("$nota")
        fi
    else
        # Modo simple: cualquier nota no enlazada desde el MoC
        if ! $IN_MOC; then
            HUERFANAS+=("$nota")
        fi
    fi
done

# --- 5. Mostrar resultados ---
if [[ ${#HUERFANAS[@]} -eq 0 ]]; then
    echo -e "${VERDE}✅ No hay notas huérfanas. Todas están enlazadas desde el MoC.${SIN_COLOR}"
    echo ""
    echo -e "${CIAN}📊 Total notas analizadas:${SIN_COLOR} ${#TODAS_LAS_NOTAS[@]}"
    echo -e "${CIAN}📊 Links extraídos del MoC:${SIN_COLOR} $(echo "$MOC_LINKS" | wc -l)"
    exit 0
fi

echo -e "${AMARILLO}📄 ${#HUERFANAS[@]} nota(s) huérfana(s)${SIN_COLOR}"
echo ""

for nota in "${HUERFANAS[@]}"; do
    BASENAME=$(basename "$nota" .md)
    echo -e "${ROJO}⚠️  ${SIN_COLOR}${NEGRITA}$nota${SIN_COLOR}"

    if $SUGERENCIAS; then
        # Sugerir posible ubicación basada en la carpeta
        DIR=$(dirname "$nota")
        SUGERENCIA=""
        case "$DIR" in
            *"Conceptos"*) SUGERENCIA="Agregar bajo '## Fundamentos' en el MoC" ;;
            *"Comandos"*)  SUGERENCIA="Agregar bajo '## Terminal y comandos' en el MoC" ;;
            *"Programas"*) SUGERENCIA="Agregar bajo '## Programas comunes' en el MoC" ;;
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
echo -e "${CIAN}📊 Total notas analizadas:${SIN_COLOR} ${#TODAS_LAS_NOTAS[@]}"
echo -e "${CIAN}📊 Links en el MoC:${SIN_COLOR}      $(echo "$MOC_LINKS" | wc -l)"
echo ""
echo -e "${AMARILLO}💡 Para agregar una nota al MoC, edita:${SIN_COLOR}"
echo "   $MOC_FILE"
