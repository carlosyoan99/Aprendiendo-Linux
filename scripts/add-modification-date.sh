#!/bin/bash
# add-modification-date.sh — Añade fecha_modificacion al frontmatter de todas las notas
# Basado en la fecha de modificación del archivo (mtime)
# Ubicación: scripts/add-modification-date.sh
# Uso: ./add-modification-date.sh

set -e

VAULT_DIR="$(cd "$(dirname "$0")/../" && pwd)"
cd "$VAULT_DIR"

COUNT=0
SKIPPED=0
UPDATED=0

while IFS= read -r -d '' file; do
    # Saltar archivos en .obsidian, .git y Templates
    case "$file" in
        */.obsidian/*|*/.git/*|*/Templates/*) continue ;;
    esac

    # Verificar que tiene frontmatter (empieza con ---)
    if ! head -1 "$file" | grep -q '^---$'; then
        ((SKIPPED++)) || true
        continue
    fi

    # Obtener fecha de modificación del archivo
    mtime=$(date -r "$file" +%Y-%m-%d 2>/dev/null || date -r "$file" +%Y-%m-%d)

    # Verificar si ya tiene fecha_modificacion
    if grep -q '^fecha_modificacion:' "$file"; then
        # Actualizar fecha existente
        sed -i "s/^fecha_modificacion:.*/fecha_modificacion: $mtime/" "$file"
        ((UPDATED++)) || true
    else
        # Añadir después de fecha_creacion
        sed -i "/^fecha_creacion:/a\\fecha_modificacion: $mtime" "$file"
        ((COUNT++)) || true
    fi

done < <(find . -name '*.md' -print0)

echo "=== RESULTADOS ==="
echo "Notas con fecha_modificacion añadida: $COUNT"
echo "Notas con fecha_modificacion actualizada: $UPDATED"
echo "Archivos sin frontmatter (skipped): $SKIPPED"
echo "Total procesadas: $((COUNT + UPDATED + SKIPPED))"
