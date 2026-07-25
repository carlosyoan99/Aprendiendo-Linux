---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: automatizacion
prioridad: baja
---

# Git hooks y scripts para mantener el vault

> Git hooks son scripts que se ejecutan automáticamente en ciertos eventos de Git (commit, push, merge, etc.). Para un vault de Obsidian versionado, los hooks pueden validar frontmatter, detectar wikilinks rotos, y mantener la calidad del contenido sin esfuerzo manual.

## ¿Qué son los Git hooks?

Los hooks son scripts en `REPO/.git/hooks/` que Git ejecuta en momentos específicos del flujo de trabajo:

```
.git/hooks/
├── pre-commit          → antes de crear el commit (validar, rechazar si algo falla)
├── prepare-commit-msg  → antes de abrir el editor de mensaje
├── commit-msg          → validar el mensaje del commit
├── post-commit         → después del commit (notificaciones, stats)
├── pre-push            → antes de hacer push (tests, linting)
└── ... (más hooks)
```

Los hooks deben ser **ejecutables** y pueden escribirse en cualquier lenguaje (bash, Python, Node.js).

## Hooks recomendados para el vault

### 1. pre-commit: validar frontmatter y wikilinks

```bash
#!/bin/bash
# .git/hooks/pre-commit — validar notas nuevas o modificadas
set -euo pipefail

echo "🔍 Validando frontmatter y wikilinks..."

# Obtener archivos modificados que son .md
FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.md$' || true)

if [ -z "$FILES" ]; then
    echo "✅ Sin archivos .md para validar"
    exit 0
fi

ERROR=0

for FILE in $FILES; do
    # Verificar que el archivo existe
    if [ ! -f "$FILE" ]; then
        continue
    fi

    # 1. Validar frontmatter básico (fecha, estado, categoría)
    if ! head -20 "$FILE" | grep -q "^fecha_creacion:"; then
        echo "❌ $FILE: falta fecha_creacion en frontmatter"
        ERROR=1
    fi
    if ! head -20 "$FILE" | grep -q "^estado:"; then
        echo "❌ $FILE: falta estado en frontmatter"
        ERROR=1
    fi
    if ! head -20 "$FILE" | grep -q "^categoria:"; then
        echo "❌ $FILE: falta categoria en frontmatter"
        ERROR=1
    fi

    # 2. Validar que termina con hashtag
    if ! tail -1 "$FILE" | grep -q "^#"; then
        echo "⚠️  $FILE: sin hashtag al final (no bloqueante)"
    fi
done

if [ "$ERROR" -eq 1 ]; then
    echo "❌ Errores encontrados. Commit cancelado."
    echo "   Corrige los errores y vuelve a intentar."
    exit 1
fi

echo "✅ Validación exitosa"
```

**Instalación:**

```bash
# Copiar el hook al directorio de hooks de Git
cp scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Para que los hooks sean compartidos por todo el equipo (si clonan el repo),
# almacenarlos en el repo y hacer un script de instalación:
mkdir -p .githooks
mv scripts/pre-commit .githooks/pre-commit
git config core.hooksPath .githooks        # Git usará .githooks/ en vez de .git/hooks/
```

### 2. pre-push: verificar integridad antes de subir

```bash
#!/bin/bash
# .githooks/pre-push — verificar integridad del vault antes de push
set -euo pipefail

echo "📦 Verificando vault antes del push..."

# 1. Ejecutar el script de stats para detectar anomalías
if [ -f "scripts/vault-stats.sh" ]; then
    bash scripts/vault-stats.sh --resumen
fi

# 2. Buscar wikilinks rotos ([[notas]] que no existen)
echo "🔗 Buscando wikilinks rotos..."
git grep -oP '\[\[[^\]]+\]\]' -- '*.md' | \
    sed 's/.*\[\[\([^]]*\)\]\].*/\1/' | \
    sort -u | while read -r NOTE; do
    # Extraer el nombre base (sin alias |)
    BASENAME=$(echo "$NOTE" | cut -d'|' -f1)
    # Buscar archivo que coincida
    FOUND=$(find . -name "${BASENAME}.md" -not -path './.git/*' 2>/dev/null | head -1)
    if [ -z "$FOUND" ]; then
        echo "⚠️  Wikilink roto: [[${NOTE}]]"
    fi
done

# 3. Verificar CLAUDE.md existe (siempre debe estar)
if [ ! -f "CLAUDE.md" ]; then
    echo "❌ CLAUDE.md no encontrado"
    exit 1
fi

echo "✅ Vault listo para push"
```

### 3. commit-msg: validar formato del mensaje

```bash
#!/bin/bash
# .githooks/commit-msg — validar formato del mensaje de commit
set -euo pipefail

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Reglas de formato para este vault:
# - La primera línea debe empezar con tipo (feat/fix/docs/refactor/chore)

if ! echo "$COMMIT_MSG" | head -1 | grep -qE "^(feat|fix|docs|refactor|chore|expand)(\([a-z ]+\))?:"; then
    echo "❌ El mensaje del commit debe empezar con tipo:"
    echo "   feat(Fase):    nuevas notas"
    echo "   fix(Carpeta):  correcciones de contenido"
    echo "   docs:          cambios en MoC, README, Log"
    echo "   expand(Tema):  expandir nota existente"
    echo "   refactor:      reorganización de contenido"
    echo "   chore:         scripts, herramientas"
    echo ""
    echo "   Ejemplo: feat(Fase1): añadir troubleshooting de disco lleno"
    exit 1
fi

echo "✅ Formato de commit válido"
```

### 4. Hook compartido: instalar todos los hooks automáticamente

```bash
#!/bin/bash
# scripts/install-hooks.sh — instalar hooks en el repo (ejecutar una vez)
set -euo pipefail

HOOK_SOURCE=".githooks"
HOOK_TARGET=".git/hooks"

if [ ! -d "$HOOK_SOURCE" ]; then
    echo "❌ Directorio $HOOK_SOURCE no encontrado"
    exit 1
fi

echo "🔗 Instalando hooks desde $HOOK_SOURCE..."

for HOOK in "$HOOK_SOURCE"/*; do
    HOOK_NAME=$(basename "$HOOK")
    cp "$HOOK" "$HOOK_TARGET/$HOOK_NAME"
    chmod +x "$HOOK_TARGET/$HOOK_NAME"
    echo "   ✅ $HOOK_NAME instalado"
done

# Configurar Git para usar .githooks como fuente
git config core.hooksPath .githooks

echo "🎉 Todos los hooks instalados correctamente"
```

## Scripts auxiliares para el vault

Además de los hooks, estos scripts complementan el mantenimiento del vault:

### check-wikilinks.sh — verificar enlaces entre notas

```bash
#!/bin/bash
# scripts/check-wikilinks.sh — encuentra wikilinks que apuntan a notas inexistentes
set -euo pipefail

echo "🔍 Buscando wikilinks rotos..."

ALL_NOTES=$(find . -name '*.md' -not -path './.git/*' | sed 's|.*/||; s|\.md$||' | sort -u)
BROKEN=0

# Extraer todos los wikilinks de todas las notas
for NOTE in $(find . -name '*.md' -not -path './.git/*'); do
    # Extraer contenido entre [[ ]] que sean wikilinks (no enlaces externos)
    LINKS=$(grep -oP '\[\[[^\]]+\]\]' "$NOTE" | sed 's/\[\[//; s/\]\]//; s/|.*//' || true)

    for LINK in $LINKS; do
        # Verificar si existe un archivo con ese nombre
        FOUND=$(find . -name "${LINK}.md" -not -path './.git/*' 2>/dev/null | head -1)
        if [ -z "$FOUND" ]; then
            echo "⚠️  $NOTE → [[${LINK}]] (no encontrado)"
            BROKEN=$((BROKEN + 1))
        fi
    done
done

if [ "$BROKEN" -eq 0 ]; then
    echo "✅ Todos los wikilinks son válidos"
else
    echo "📊 $BROKEN wikilinks rotos encontrados"
fi
```

### update-readme.sh — mantener README.md actualizado

```bash
#!/bin/bash
# scripts/update-readme.sh — actualizar cifras en README.md
set -euo pipefail

TOTAL_NOTES=$(find . -name '*.md' -not -path './.git/*' -not -path './node_modules/*' | wc -l)
TOTAL_COMMANDS=$(find '07 - Comandos Esenciales' -name '*.md' | wc -l)
TOTAL_DISTROS=$(find '02 - Instalacion y Configuracion/Distribuciones' -name '*.md' | wc -l)
TOTAL_PROBLEMS=$(find '09 - Solucion de Problemas' -name '*.md' | wc -l)

echo "=== Estadísticas del vault ==="
echo "Notas totales:     $TOTAL_NOTES"
echo "Comandos:          $TOTAL_COMMANDS"
echo "Distribuciones:    $TOTAL_DISTROS"
echo "Troubleshooting:   $TOTAL_PROBLEMS"

# Opcional: actualizar README.md automáticamente
if [ -f "README.md" ]; then
    sed -i "s/notas totales: [0-9]*/notas totales: $TOTAL_NOTES/i" README.md
    echo "✅ README.md actualizado"
fi
```

## Integración con scripts existentes

El vault ya tiene scripts en `10 - Automatizacion y Scripts/scripts/`:

| Script existente | Integración con hooks |
|---|---|
| `check-frontmatter.sh` | Puede ejecutarse en pre-commit (validar frontmatter antes de commitear) |
| `find-orphans.sh` | Puede ejecutarse en pre-push (verificar que no haya notas huérfanas) |
| `vault-stats.sh` | Puede ejecutarse en post-commit (actualizar stats tras cada cambio) |

```bash
# Ejemplo: enganchar vault-stats.sh en post-commit
#!/bin/bash
# .githooks/post-commit
bash scripts/vault-stats.sh --resumen >> /dev/null
```

## Buenas prácticas

- **Almacenar hooks en el repo** (`.githooks/`) para que sean compartidos — no en `.git/hooks/` que no se versiona
- **Configurar `core.hooksPath`** en el README del repo para que los hooks se activen automáticamente al clonar
- **Hooks rápidos**: los hooks deben ejecutarse en <1 segundo. Si son lentos, los developers los saltarán con `--no-verify`
- **No ser demasiado restrictivo**: los hooks deben prevenir errores, no ralentizar el flujo de trabajo. Perdonar (warning) antes que prohibir (error)
- **Documentar los hooks** en el README del repo para que los colaboradores sepan qué esperar

## Enlaces externos

- [Git SCM — Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
- [Git SCM — core.hooksPath](https://git-scm.com/docs/git-config#Documentation/git-config.txt-corehooksPath)
- [Atlassian — Git Hooks Guide](https://www.atlassian.com/git/tutorials/git-hooks)

## Ver también

- [[Git]] — control de versiones
- [[Automatizacion y Scripts]] — scripts del vault
- [[Cron y Systemd Timers]] — automatización periódica
- [[Mis Dotfiles]] — gestión de archivos de configuración

#automatizacion #git
