#!/bin/bash
# vault-stats-weekly.sh — Wrapper para ejecutar vault-stats.sh semanalmente vía cron
# Ubicación: scripts/vault-stats-weekly.sh
# Uso: ./vault-stats-weekly.sh
# Cron:   0 9 * * 0 /ruta/completa/vault-stats-weekly.sh

set -eo pipefail

# Determinar la raíz del vault (esté donde esté el script)
VAULT_DIR="$(cd "$(dirname "$0")/../" && pwd)"
SCRIPT="$VAULT_DIR/scripts/vault-stats.sh"
LOG="$VAULT_DIR/scripts/vault-stats-weekly.log"

# Verificar que el script existe
if [[ ! -f "$SCRIPT" ]]; then
    echo "[ERROR] vault-stats.sh no encontrado en $SCRIPT" >&2
    exit 1
fi

# Ejecutar y loguear
echo "══════════════════════════════════════" >> "$LOG"
echo "📊 VAULT STATS — $(date '+%Y-%m-%d %H:%M')" >> "$LOG"
echo "══════════════════════════════════════" >> "$LOG"
bash "$SCRIPT" --resumen >> "$LOG" 2>&1
echo "" >> "$LOG"

exit 0
