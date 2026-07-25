#!/bin/bash
# setup.sh — Configuración inicial del vault: git hooks + cron + validación
# Ubicación: 10 - Automatizacion y Scripts/setup.sh
# Uso: bash setup.sh [opciones]
#
# Ejemplos:
#   bash setup.sh                    # Configura hooks + cron (interactivo)
#   bash setup.sh --hooks-only       # Solo git hooks
#   bash setup.sh --cron-only        # Solo cron jobs
#   bash setup.sh --cron-remove      # Eliminar cron jobs instalados
#   bash setup.sh --check            # Solo verificar estado
#   bash setup.sh --yes              # No interactivo (asume sí)
#   bash setup.sh --help             # Ayuda detallada

set -euo pipefail

# ─── Colores ──────────────────────────────────────────────
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[0;34m'
CIAN='\033[0;36m'
SIN_COLOR='\033[0m'
NEGRITA='\033[1m'

# ─── Rutas (relativas al script) ──────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_DIR="$VAULT_DIR/.githooks"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# Identificador único para las entradas cron de este vault
CRON_TAG="# VAULT:AprendiendoLinux"
CRON_ID="vault-$(echo "$VAULT_DIR" | md5sum | cut -c1-8 2>/dev/null || echo "default")"

# ─── Ayuda ────────────────────────────────────────────────
mostrar_ayuda() {
    cat <<EOF
${NEGRITA}setup.sh${SIN_COLOR} — Configuración inicial del vault

${NEGRITA}USO:${SIN_COLOR}
  bash setup.sh                         Configura hooks + cron (pregunta)
  bash setup.sh --hooks-only            Solo git hooks
  bash setup.sh --cron-only             Solo cron jobs
  bash setup.sh --cron-remove           Eliminar cron jobs instalados
  bash setup.sh --check                 Solo verificar estado actual
  bash setup.sh --yes                   No interactivo (asume sí a todo)
  bash setup.sh --help                  Esta ayuda

${NEGRITA}DESCRIPCIÓN:${SIN_COLOR}
  Configura todo lo necesario para que el vault funcione automáticamente:

  1. ${NEGRITA}Git hooks${SIN_COLOR} — Valida frontmatter, formato de commits y
     wikilinks rotos antes de cada commit/push.

  2. ${NEGRITA}Cron jobs${SIN_COLOR} — Actualiza fechas de modificación y
     genera estadísticas del vault semanalmente.

${NEGRITA}FUNCIONAMIENTO:${SIN_COLOR}
  Los hooks se activan via git config core.hooksPath.
  Los cron jobs se añaden al crontab del usuario actual (solo Linux).

${NEGRITA}EJEMPLOS:${SIN_COLOR}
  bash setup.sh --yes              # Configura todo sin preguntar
  bash setup.sh --check            # Muestra estado actual
  bash setup.sh --cron-remove      # Desinstala solo los cron jobs

EOF
    exit 0
}

# ─── Parsear argumentos ───────────────────────────────────
MODO="completo"
NO_INTERACTIVO=false

for arg in "$@"; do
    case "$arg" in
        --help|-h) mostrar_ayuda ;;
        --hooks-only) MODO="hooks" ;;
        --cron-only) MODO="cron" ;;
        --cron-remove) MODO="cron-remove" ;;
        --check) MODO="check" ;;
        --yes) NO_INTERACTIVO=true ;;
    esac
done

# ─── Utilidades ───────────────────────────────────────────
info()    { echo -e "${CIAN}ℹ️  $1${SIN_COLOR}"; }
ok()      { echo -e "${VERDE}✅ $1${SIN_COLOR}"; }
warn()    { echo -e "${AMARILLO}⚠️  $1${SIN_COLOR}"; }
error()   { echo -e "${ROJO}❌ $1${SIN_COLOR}"; }
titulo()  { echo -e "\n${NEGRITA}${AZUL}═══ $1 ═══${SIN_COLOR}"; }

preguntar() {
    if $NO_INTERACTIVO; then
        return 0  # sí automático
    fi
    local prompt="$1"
    local respuesta
    read -p "$(echo -e "${AMARILLO}?${SIN_COLOR} $prompt [Y/n]: ")" respuesta
    [[ -z "$respuesta" || "$respuesta" == "y" || "$respuesta" == "Y" || "$respuesta" == "yes" ]]
}

# ─── 1. Git hooks ─────────────────────────────────────────
configurar_hooks() {
    titulo "Git Hooks"

    if [[ ! -d "$HOOKS_DIR" ]]; then
        warn "No se encuentra el directorio .githooks/ en $HOOKS_DIR"
        return 1
    fi

    # Contar hooks disponibles
    HOOKS_COUNT=$(find "$HOOKS_DIR" -type f 2>/dev/null | wc -l)
    if [[ "$HOOKS_COUNT" -eq 0 ]]; then
        warn "No hay hooks en .githooks/"
        return 1
    fi

    info "Hooks encontrados: $(ls "$HOOKS_DIR" | tr '\n' ' ')"

    # Hacer hooks ejecutables
    chmod +x "$HOOKS_DIR"/* 2>/dev/null || true
    ok "Permisos de ejecución: hooks ejecutables"

    # Configurar git
    git config core.hooksPath "$HOOKS_DIR"
    ok "git config core.hooksPath = .githooks"

    # Verificar
    HOOKS_ACTUAL=$(git config core.hooksPath 2>/dev/null || echo "(no configurado)")
    if [[ "$HOOKS_ACTUAL" == "$HOOKS_DIR" ]]; then
        ok "Git hooks configurados correctamente → $HOOKS_DIR"
    else
        warn "No se pudo verificar la configuración de hooks"
    fi

    # Mostrar resumen de hooks
    echo ""
    for hook in "$HOOKS_DIR"/*; do
        if [[ -f "$hook" ]]; then
            hook_name=$(basename "$hook")
            hook_desc=$(head -3 "$hook" | grep -E '^#' | head -1 | sed 's/^# //')
            echo "  📌 ${NEGRITA}$hook_name${SIN_COLOR} — ${hook_desc:-sin descripción}"
        fi
    done
}

# ─── 2. Cron jobs ─────────────────────────────────────────
configurar_cron() {
    titulo "Cron Jobs"

    # Verificar que crontab está disponible
    if ! command -v crontab &>/dev/null; then
        error "crontab no está disponible en este sistema"
        return 1
    fi

    # Verificar que los scripts existen
    SCRIPT_FECHAS="$SCRIPTS_DIR/add-modification-date.sh"
    SCRIPT_STATS_WEEKLY="$SCRIPTS_DIR/vault-stats-weekly.sh"

    if [[ ! -f "$SCRIPT_FECHAS" ]]; then
        warn "add-modification-date.sh no encontrado — se omitirá la entrada de fechas"
        SCRIPT_FECHAS=""
    fi
    if [[ ! -f "$SCRIPT_STATS_WEEKLY" ]]; then
        warn "vault-stats-weekly.sh no encontrado — se omitirá la entrada de stats"
        SCRIPT_STATS_WEEKLY=""
    fi
    if [[ -z "$SCRIPT_FECHAS" && -z "$SCRIPT_STATS_WEEKLY" ]]; then
        error "No hay scripts para configurar en cron"
        return 1
    fi

    # Leer crontab actual
    CRONTAB_ACTUAL=$(crontab -l 2>/dev/null || true)

    # Generar nuevas entradas (con tag para poder identificarlas después)
    # NOTA: usar $'\n' para newlines reales — crontab no entiende \n literal
    NUEVAS_ENTRADAS=""
    if [[ -n "$SCRIPT_FECHAS" ]]; then
        NUEVAS_ENTRADAS+="0 8 * * 0 cd $VAULT_DIR && bash $SCRIPT_FECHAS$CRON_TAG:fechas:$CRON_ID"$'\n'
    fi
    if [[ -n "$SCRIPT_STATS_WEEKLY" ]]; then
        NUEVAS_ENTRADAS+="0 9 * * 0 cd $VAULT_DIR && bash $SCRIPT_STATS_WEEKLY$CRON_TAG:stats:$CRON_ID"$'\n'
    fi

    # Verificar si ya existen (por tag)
    EXISTE_FECHAS=false
    EXISTE_STATS=false
    if echo "$CRONTAB_ACTUAL" | grep -q "VAULT:AprendiendoLinux.*fechas.*$CRON_ID"; then
        EXISTE_FECHAS=true
    fi
    if echo "$CRONTAB_ACTUAL" | grep -q "VAULT:AprendiendoLinux.*stats.*$CRON_ID"; then
        EXISTE_STATS=true
    fi

    if $EXISTE_FECHAS && $EXISTE_STATS; then
        ok "Los cron jobs ya están instalados (usa --cron-remove para quitarlos)"
        echo ""
        echo "$CRONTAB_ACTUAL" | grep "VAULT:AprendiendoLinux" | while IFS= read -r line; do
            echo "  🕐 $line"
        done
        return 0
    fi

    # Añadir nuevas entradas
    CRONTAB_NUEVO="$CRONTAB_ACTUAL"
    if [[ -n "$NUEVAS_ENTRADAS" ]]; then
        CRONTAB_NUEVO+=$'\n'"$NUEVAS_ENTRADAS"
    fi

    echo "$CRONTAB_NUEVO" | crontab -
    ok "Cron jobs instalados en el crontab de $(whoami)"

    echo ""
    echo -e "${CIAN}📅 Entradas añadidas:${SIN_COLOR}"
    echo -e "$NUEVAS_ENTRADAS" | while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            echo "  🕐 $line"
        fi
    done
}

# ─── 3. Eliminar cron ─────────────────────────────────────
eliminar_cron() {
    titulo "Eliminar Cron Jobs"

    CRONTAB_ACTUAL=$(crontab -l 2>/dev/null || true)
    CRONTAB_LIMPIO=$(echo "$CRONTAB_ACTUAL" | grep -v "VAULT:AprendiendoLinux.*$CRON_ID" || true)

    if [[ "$CRONTAB_ACTUAL" == "$CRONTAB_LIMPIO" ]]; then
        ok "No se encontraron cron jobs del vault que eliminar"
        return 0
    fi

    echo "$CRONTAB_LIMPIO" | crontab -
    ok "Cron jobs del vault eliminados"
}

# ─── 4. Verificar estado ──────────────────────────────────
verificar_estado() {
    titulo "Estado actual del vault"

    # Git hooks
    HOOKS_CFG=$(git config core.hooksPath 2>/dev/null || echo "(no configurado)")
    if [[ "$HOOKS_CFG" == ".githooks" ]] || [[ "$HOOKS_CFG" == "$HOOKS_DIR" ]]; then
        ok "Git hooks: configurados ($HOOKS_CFG)"
    else
        warn "Git hooks: NO configurados ($HOOKS_CFG)"
    fi

    # Hook files
    HOOKS_ENABLED=0
    for hook in "$HOOKS_DIR"/*; do
        if [[ -x "$hook" ]]; then
            ((HOOKS_ENABLED++))
        fi
    done
    info "Hooks ejecutables: $HOOKS_ENABLED"

    # Cron
    CRONTAB_ACTUAL=$(crontab -l 2>/dev/null || true)
    CRON_FECHAS=$(echo "$CRONTAB_ACTUAL" | grep "VAULT:AprendiendoLinux.*fechas" || true)
    CRON_STATS=$(echo "$CRONTAB_ACTUAL" | grep "VAULT:AprendiendoLinux.*stats" || true)

    if [[ -n "$CRON_FECHAS" ]]; then
        ok "Cron fechas: instalado → $(echo "$CRON_FECHAS" | awk '{print $1,$2,$3,$4,$5}')"
    else
        warn "Cron fechas: NO instalado"
    fi
    if [[ -n "$CRON_STATS" ]]; then
        ok "Cron stats:  instalado → $(echo "$CRON_STATS" | awk '{print $1,$2,$3,$4,$5}')"
    else
        warn "Cron stats:  NO instalado"
    fi

    # Scripts
    titulo "Scripts disponibles"
    for script in "$SCRIPTS_DIR"/*.sh; do
        if [[ -f "$script" ]]; then
            nombre=$(basename "$script")
            # segunda línea de comentario (# nombre — descripción)
            desc=$(sed -n '2p' "$script" | sed 's/^# //')
            echo -e "  📜 ${NEGRITA}$nombre${SIN_COLOR} — ${desc:-sin descripción}"
        fi
    done
    # setup.sh está fuera de scripts/ pero es parte del ecosistema
    if [[ -f "$SCRIPT_DIR/setup.sh" ]]; then
        desc=$(sed -n '2p' "$SCRIPT_DIR/setup.sh" | sed 's/^# //')
        echo -e "  📜 ${NEGRITA}setup.sh${SIN_COLOR} — ${desc:-sin descripción}"
    fi

    echo ""
    info "Ejecuta 'bash setup.sh' para instalar lo que falte."
}

# ─── Main ─────────────────────────────────────────────────
main() {
    echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
    echo -e "${NEGRITA}${AZUL}  🔧 SETUP DEL VAULT — AprendiendoLinux${SIN_COLOR}"
    echo -e "${NEGRITA}${AZUL}════════════════════════════════════════════${SIN_COLOR}"
    echo -e "${CIAN}Vault:${SIN_COLOR} $VAULT_DIR"
    echo -e "${CIAN}Modo:${SIN_COLOR}  $MODO"
    echo ""

    case "$MODO" in
        completo)
            configurar_hooks || true
            echo ""
            if preguntar "¿Configurar cron jobs (stats semanales + fechas)?"; then
                configurar_cron || true
            else
                info "Cron omitido. Puedes configurarlo luego con --cron-only"
            fi
            ;;

        hooks)
            configurar_hooks || true
            ;;

        cron)
            configurar_cron || true
            ;;

        cron-remove)
            eliminar_cron || true
            ;;

        check)
            verificar_estado || true
            ;;
    esac

    echo ""
    if [[ "$MODO" != "check" && "$MODO" != "cron-remove" ]]; then
        echo -e "${VERDE}${NEGRITA}✅ Setup completado.${SIN_COLOR}"
        echo -e "${CIAN}💡 Ejecuta 'bash setup.sh --check' para verificar el estado.${SIN_COLOR}"
    fi
    echo -e "${CIAN}📖 Documentación completa en [[Scripts del Vault]].${SIN_COLOR}"
}

main "$@"
