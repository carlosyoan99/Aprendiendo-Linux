#!/bin/bash
# daily-log.sh — Crea una nota de log diaria en el vault
# Ubicación: 10 - Automatizacion y Scripts/scripts/daily-log.sh
# Uso: ./daily-log.sh [opciones]
#       ./daily-log.sh "Texto opcional para hoy"
#       ./daily-log.sh -e "error que encontré" -c "curl, jq" -s "seguir con..."

set -euo pipefail

# --- Configuración ---
VAULT_DIR="$(cd "$(dirname "$0")/../../" && pwd)"
LOG_DIR="$VAULT_DIR/10 - Automatizacion y Scripts"
TEMPLATE="$VAULT_DIR/Templates/Plantilla - Log Diario.md"
FECHA=$(date +%Y-%m-%d)
NOMBRE_ARCHIVO="Log - $FECHA.md"
RUTA_ARCHIVO="$LOG_DIR/$NOMBRE_ARCHIVO"

# --- Colores para output ---
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[0;34m'
SIN_COLOR='\033[0m'

# --- Ayuda ---
mostrar_ayuda() {
    cat <<EOF
daily-log.sh — Crea una nota de log diaria en el vault

USO:
  ./daily-log.sh                   # Crea log vacío
  ./daily-log.sh "Texto"           # Crea log con texto en "Qué exploré hoy"
  ./daily-log.sh -e "error"        # Rellena "Problemas encontrados"
  ./daily-log.sh -c "comando"      # Rellena "Comandos/conceptos nuevos"
  ./daily-log.sh -s "paso"         # Rellena "Próximos pasos"
  ./daily-log.sh -a "exploración"  # Rellena "Qué exploré hoy"

EJEMPLOS:
  ./daily-log.sh -e "Wifi no conecta al arrancar" -c "nmcli"
  ./daily-log.sh "Probando Hyprland por primera vez"

EOF
    exit 0
}

# --- Parsear argumentos ---
EXPLORE=""
COMANDOS=""
PROBLEMAS=""
PROXIMOS=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) mostrar_ayuda ;;
        -e|--problemas) PROBLEMAS="$2"; shift 2 ;;
        -c|--comandos) COMANDOS="$2"; shift 2 ;;
        -s|--proximos) PROXIMOS="$2"; shift 2 ;;
        -a|--explore) EXPLORE="$2"; shift 2 ;;
        *) EXPLORE="$1"; shift ;;  # primer argumento sin flag va a explore
    esac
done

# --- Verificar que no exista ya ---
if [ -f "$RUTA_ARCHIVO" ]; then
    echo -e "${AMARILLO}⚠️  Ya existe un log para hoy: $NOMBRE_ARCHIVO${SIN_COLOR}"
    echo -e "  Abriéndolo para editar..."
    ${EDITOR:-nano} "$RUTA_ARCHIVO" 2>/dev/null || xdg-open "$RUTA_ARCHIVO" 2>/dev/null || echo "  $RUTA_ARCHIVO"
    exit 0
fi

# --- Crear el archivo ---
cat > "$RUTA_ARCHIVO" <<EOF
---
fecha: $FECHA
categoria: log
---

# Log - $FECHA

## Qué exploré hoy
${EXPLORE:--}

## Comandos/conceptos nuevos
${COMANDOS:--}

## Problemas encontrados
${PROBLEMAS:--}

## Próximos pasos
${PROXIMOS:--}

#log
EOF

echo -e "${VERDE}✅ Log diario creado:${SIN_COLOR} $RUTA_ARCHIVO"
echo -e "${AZUL}📝 Recuerda registrarlo también en Log.md si es una sesión relevante.${SIN_COLOR}"
