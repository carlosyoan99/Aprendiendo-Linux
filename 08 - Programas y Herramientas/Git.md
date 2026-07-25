---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-20
estado: resuelto
categoria: programa
prioridad: alta
---

# Git

> Sistema de control de versiones distribuido. Creado por **Linus Torvalds** en 2005 para el desarrollo del kernel Linux tras la retirada de la licencia gratuita de BitKeeper. Hoy es el VCS más usado del mundo.

## Qué es

Git es el sistema de control de versiones más usado del mundo. Permite rastrear cambios en archivos, colaborar con otros desarrolladores, volver a versiones anteriores, y mantener múltiples ramas de desarrollo simultáneamente.

**¿Por qué fue creado?** En 2005, la relación entre la comunidad del kernel Linux y BitKeeper (el VCS que usaban) se rompió cuando la empresa retiró la licencia gratuita. Linus Torvalds, frustrado por las limitaciones de los sistemas existentes (CVS, Subversion), escribió Git en **un mes** con objetivos claros:

- **Rapidez**: las operaciones básicas (commit, diff, log) deben ser instantáneas
- **Distribuido**: cada copia de trabajo es un repositorio completo
- **No linealidad**: branching y merging rápidos y ligeros
- **Integridad**: todo se verifica con SHA-1 (ahora SHA-256 en transición)

Hoy Git es el estándar de facto — usado no solo en software, sino también en documentación, diseño, investigación, y prácticamente cualquier proyecto que requiera control de versiones.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install git

# Arch
sudo pacman -S git

# Fedora
sudo dnf install git

# Verificar instalación
git --version
```

## Configuración inicial

```bash
# Obligatorio (git necesita saber quién eres para los commits)
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"

# Recomendado
git config --global init.defaultBranch main        # rama por defecto: main (antes master)
git config --global color.ui auto                  # colores en la terminal
git config --global core.editor nano               # editor por defecto
git config --global pull.rebase true               # pull con rebase en vez de merge

# Ver configuración
git config --list
git config user.name                               # valor específico

# Configuración por repositorio (sin --global)
git config user.email "trabajo@empresa.com"
```

### Archivos de configuración

| Archivo | Ámbito | Editar con |
|---|---|---|
| `~/.gitconfig` o `~/.config/git/config` | Global (tu usuario) | `git config --global` |
| `.git/config` | Repositorio local | `git config` (sin `--global`) |
| `$(prefix)/etc/gitconfig` | Sistema (todos los usuarios) | `git config --system` |

### Alias útiles

```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.lg "log --oneline --graph --decorate --all"
git config --global alias.unstage "restore --staged"
git config --global alias.last "log -1 HEAD"
git config --global alias.undo "reset --soft HEAD~1"
git config --global alias.df diff
git config --global alias.dfc "diff --cached"
```

---

## Flujo básico

```
Working Directory    Staging Area (index)    Repositorio local
    ┌──────┐            ┌──────┐                ┌──────┐
    │      │   git add  │      │   git commit   │      │
    │  🗎   │ ────────► │  🗎   │ ────────────► │  🗎   │
    │      │            │      │                │      │
    └──────┘            └──────┘                └──────┘
```

```bash
# 1. Iniciar repositorio
cd mi-proyecto/
git init                                     # crear repositorio vacío

# 2. Agregar archivos al staging
git add archivo.txt                          # agregar un archivo
git add .                                    # agregar todos los archivos nuevos/modificados
git add -p                                   # agregar por partes (hunks) — muy útil

# 3. Confirmar cambios
git commit -m "Mensaje descriptivo del cambio"

# 4. Ver estado e historia
git status                                   # qué archivos cambiaron
git log                                      # historial de commits
git log --oneline --graph                    # historial compacto con gráfico
```

---

## Ramas en profundidad

### Conceptos básicos

Una rama en Git es simplemente un **puntero móvil** a un commit. Cuando haces un nuevo commit, la rama avanza automáticamente. `HEAD` es un puntero especial que indica dónde estás parado actualmente.

```bash
# Ver ramas
git branch                                   # ramas locales
git branch -a                                # todas (locales + remotas)
git branch -vv                               # con relación a tracking remoto

# Crear y cambiar
git branch feature-x                         # crear rama (no cambia)
git switch feature-x                         # cambiarse (Git 2.23+)
git checkout -b feature-y                    # crear y cambiarse en un paso
git switch -c feature-z                      # crear y cambiarse (moderno)

# Renombrar rama
git branch -m feature-x feature-x-mejor      # renombrar

# Eliminar rama
git branch -d feature-x                      # eliminar (solo si ya se fusionó)
git branch -D feature-x                      # forzar eliminación (aunque no esté mergeada)
```

### Ramas remotas y tracking

```bash
# Subir rama local al remoto
git push -u origin feature-x                 # -u vincula local con remota (upstream)

# Ver ramas remotas
git branch -r                                # ramas en origin

# Sincronizar ramas remotas eliminadas
git fetch --prune                            # limpia referencias a ramas remotas borradas
git remote prune origin                      # lo mismo pero solo de origin

# Crear rama local que trackea una remota existente
git switch -c feature-x origin/feature-x
git checkout --track origin/feature-x        # forma clásica
```

### Estrategias de branching

| Estrategia | Flujo | Cuándo usarla |
|---|---|---|
| **GitHub Flow** | `main` → feature branch → PR → merge | Equipos pequeños, despliegue continuo |
| **GitFlow** | `main` + `develop` + feature/release/hotfix branches | Proyectos con versiones (lanzamientos) |
| **Trunk-based** | Todos trabajan en `main` o branches muy cortos | CI/CD, equipos maduros, despliegues frecuentes |
| **GitLab Flow** | `main` + environment branches (staging, production) | Entornos con múltiples stages |

#### GitHub Flow

```
main ───●───●───●───●───●───●───●───
         \         /   \         /
          ●───●───●     ●───●───●
               feat-a         feat-b
```

**Reglas:**
- `main` siempre desplegable
- Crear rama desde `main` para cada feature
- Hacer PR contra `main`
- Mergear y desplegar inmediatamente

#### GitFlow

```
        ┌─── release-2.0 ───┐
        │                    │
develop ─●────────────────────●───●──
        │                    │
feat-a ─●──●──●──────────────│───│───
                    │        │
hotfix ─────────────●────────●───│───
                                │
main ──●────────────────────────●───
```

**Reglas:**
- `main` = código en producción
- `develop` = integración de features
- `feature/*` = features nuevas (se mergean a develop)
- `release/*` = preparación de release (se mergea a main y develop)
- `hotfix/*` = parche urgente desde main

> **⚠️ GitFlow es complejo.** Para la mayoría de proyectos, GitHub Flow o trunk-based son suficientes. GitFlow tiene sentido cuando mantienes múltiples versiones en paralelo.

---

## Merge

### Fast-forward vs 3-way merge

```bash
# Situación: main está en C, feature tiene C → D → E
# main:  A → B → C
# feat:  A → B → C → D → E
#
# Fast-forward (por defecto):
git merge feature                            # main avanza a E, sin commit extra
# A → B → C → D → E
# resultado: historial lineal

# 3-way merge (cuando las ramas divergieron):
# main: A → B → C → F
# feat: A → B → C → D → E
git merge feature                            # crea un merge commit M
# A → B → C → F ─── M
#            \     /
#             D → E
# resultado: historial con bifurcación

# Forzar merge commit aunque sea fast-forward posible
git merge --no-ff feature                    # útil para mantener trazabilidad
```

### Tipos de merge

```bash
# Merge con squash (comprime todos los cambios en un solo commit)
git merge --squash feature
git commit -m "feat: agregar login con OAuth"
# Útil para: mantener historial limpio cuando una rama tiene muchos commits WIP

# Merge con nuestra versión (ignora cambios de la rama mergeada)
git merge -X ours feature                    # ante conflicto, gana nuestra versión

# Merge con la versión de ellos
git merge -X theirs feature                  # ante conflicto, gana la versión de feature
```

### Resolución de conflictos

```bash
# Cuando ocurre un conflicto:
git merge feature
# CONFLICT (content): Merge conflict in index.html
# Automatic merge failed; fix conflicts and then commit the result.

# El archivo en conflicto muestra:
<<<<<<< HEAD
<div class="header">Bienvenido</div>
=======
<header>Bienvenido a mi sitio</header>
>>>>>>> feature

# Resolver manualmente → editar archivo, dejar lo que quieras
git add index.html                           # marcar como resuelto
git commit                                   # completar el merge

# Herramientas visuales:
git mergetool                                # abre herramienta configurada (vimdiff, meld, etc.)
git config --global merge.tool meld

# Abortar merge
git merge --abort                            # volver al estado anterior al merge

# Ver conflictos de forma estructurada
git diff                                     # muestra diferencias con marcadores de conflicto
git status                                   # muestra archivos en conflicto (UU, AA, DD)
```

### Merge strategies

Git usa algoritmos internos para mergear. Puedes forzar una estrategia específica:

```bash
# Recursive (default para 2 ramas): detecta renombres, maneja conflictos bien
git merge -s recursive feature

# Octopus: mergea múltiples ramas a la vez (3+)
git merge -s octopus feature-a feature-b feature-c

# Ours: mantiene nuestra versión, ignora la rama mergeada
git merge -s ours feature
# (no confundir con `-X ours` que ante conflicto elige nuestra versión,
#  `-s ours` descarta completamente la rama que mergeas)

# Resolve: merge simple con 3-way (obsoleto, solo 2 ramas)
git merge -s resolve feature
```

---

## Rebase

### Rebase básico

Rebase **re-escribe el historial** moviendo commits de una rama a otra base:

```bash
# Situación: feature se separó de main en B
# main:  A → B → C → D
# feat:  A → B → E → F

git switch feature
git rebase main

# Resultado: feat ahora parte de D:
# main:  A → B → C → D
# feat:  A → B → C → D → E' → F'
# (E' y F' son nuevos commits con nuevos hashes)
```

### Merge vs Rebase — Cuándo usar cada uno

```
Merge:                                Rebase:
A → B → C ─── M                      A → B → C → D → E
            \     /
             D → E
- Preserva historial exacto           - Historial lineal y limpio
- Los commits de feature quedan       - Los commits de feature parecen
  agrupados bajo el merge commit        haber sido hechos sobre main
- Seguro para ramas compartidas       - Re-escribe hashes (⚠️ peligroso)
```

| Situación | Usa merge | Usa rebase |
|---|---|---|
| Rama compartida con otros | ✅ Merge | ❌ Rebase (reescribe historia) |
| Rama personal (feature branch) | Opcional | ✅ Rebase (historial limpio) |
| Integrar cambios de main a feature | ❌ | ✅ Rebase (evita merge commits) |
| Necesitas preservar topología | ✅ Merge | ❌ |
| PR a main en equipo pequeño | ❌ | ✅ Rebase + fast-forward |

### La regla de oro del rebase

> **NUNCA hagas rebase a commits que ya están en un repositorio remoto compartido.**
> 
> `git rebase` re-escribe el historial (cambia los hashes de los commits). Si alguien más tiene esos commits, su historial y el tuyo divergirán para siempre. Usa merge para ramas compartidas.

### Rebase interactivo

El rebase interactivo es la herramienta más poderosa de Git para **limpiar el historial local** antes de compartirlo:

```bash
# Rebase interactivo de los últimos 5 commits
git rebase -i HEAD~5

# Rebase interactivo de una rama completa contra main
git rebase -i main

# Se abre un editor con:
pick a1b2c3 feat: agregar login
pick d4e5f6 fix: typo en login
pick g7h8i9 feat: agregar logout
pick j0k1l2 fix: error en logout
pick m3n4o5 chore: lint

# Opciones disponibles:
# pick   = mantener el commit tal cual
# reword = cambiar el mensaje del commit
# edit   = detener el rebase para modificar el commit
# squash = fusionar con el commit anterior (combina mensajes)
# fixup  = fusionar con el anterior (descarta mensaje)
# drop   = eliminar el commit

# Ejemplo: dejar el primer commit, fusionar corrections:
pick a1b2c3 feat: agregar login con OAuth
fixup d4e5f6 fix typo
fixup g7h8i9 add missing validation
pick j0k1l2 feat: agregar logout
```

**Casos de uso del rebase interactivo:**

```bash
# 1. Limpiar WIP commits antes de PR
git rebase -i main
# squash/fixup todos los "wip", "fix", "typo" en commits significativos

# 2. Reordenar commits (solo cortar y pegar líneas)
git rebase -i HEAD~4

# 3. Eliminar un commit (drop)
git rebase -i HEAD~10
# Cambiar pick a drop en la línea del commit a eliminar

# 4. Partir un commit en varios: marcar como edit
git rebase -i HEAD~3
# ...cuando se detenga:
git reset HEAD~1                    # deshace el commit, mantiene cambios en staging
git add -p                          # agregar solo parte de los cambios
git commit -m "feat: parte 1"
git add .
git commit -m "feat: parte 2"
git rebase --continue
```

### Rebase onto

Te permite mover una rama a una base distinta:

```bash
# Situación: tienes feature-b basada en feature-a, pero quieres:
# que feature-b se base en main en vez de en feature-a
# main ─●───●───●───●
#        \
#         ●──●── feat-a
#              \
#               ●──●── feat-b

git switch feat-b
git rebase --onto main feat-a feat-b
# feat-b ahora se basa en main, sin feat-a

# main ─●───●───●───●
#        \             \
#         ●──●──         ●──●
#         feat-a        feat-b

# Forma más clara:
git rebase --onto main feat-a
# (desde feat-a hasta donde estás, rebasear sobre main)
```

### Rebase vs merge pull

```bash
# Por defecto, git pull hace fetch + merge
git pull                              # fetch + merge (crea merge commit)

# Preferible: fetch + rebase
git pull --rebase                     # fetch + rebase (historial lineal)

# Hacer permanentemente:
git config --global pull.rebase true  # todos tus pulls serán con rebase

# También:
git pull --rebase=interactive         # rebase interactivo al traer cambios
```

---

## Cherry-pick

Aplica un commit específico de otra rama sin traer toda la rama:

```bash
git cherry-pick a1b2c3                        # aplicar commit en la rama actual
git cherry-pick a1b2c3 d4e5f6                 # múltiples commits
git cherry-pick a1b2c3..f6g7h8                # rango (desde después de a1b2c3 hasta f6g7h8)
git cherry-pick main~5..main~2                # de hace 5 a hace 2 commits de main

# Opciones
git cherry-pick --no-commit a1b2c3            # aplicar cambios sin commitear (para modificar)
git cherry-pick -x a1b2c3                     # agregar "(cherry-picked from commit ...)" al mensaje

# En caso de conflicto
git cherry-pick --abort                       # abortar cherry-pick
git cherry-pick --skip                        # saltar este commit
git cherry-pick --continue                    # continuar tras resolver conflicto
```

**¿Cuándo usar cherry-pick?**
- Aplicar un hotfix de `main` a una rama de release antigua
- Llevar un cambio específico de development a producción (sin todo lo demás)
- Recuperar un commit que se perdió en un rebase

---

## Stash — Guardado temporal

Guarda cambios sin commitear para limpiar el working directory temporalmente:

```bash
# Guardar cambios
git stash                                  # guarda tracked files
git stash push -m "WIP: login feature"     # con mensaje descriptivo
git stash -u                               # incluye untracked files
git stash -a                               # incluye untracked e ignored files

# Recuperar cambios
git stash pop                             # recupera y elimina del stash
git stash apply                           # recupera pero mantiene en stash
git stash apply stash@{2}                 # recuperar stash específico

# Gestionar stash
git stash list                            # ver todos los stashes
git stash show                            # ver resumen de cambios
git stash show -p stash@{1}               # ver diff completo
git stash drop stash@{1}                  # eliminar stash específico
git stash clear                           # eliminar todos los stashes

# Crear rama desde un stash
git stash branch fix-urgente stash@{0}    # crea rama con los cambios del stash
```

---

## Reflog — El diario de Git

`git reflog` registra **todos los movimientos de HEAD** en tu repositorio local. Es el salvavidas para recuperar cambios "perdidos":

```bash
git reflog                                # historial de movimientos de HEAD
# a1b2c3 HEAD@{0}: commit: feat: agregar login
# d4e5f6 HEAD@{1}: reset: moving to HEAD~1
# g7h8i9 HEAD@{2}: commit: fix: error en login
# j0k1l2 HEAD@{3}: rebase: checkout main
# m3n4o5 HEAD@{4}: commit: wip: probando algo

# Recuperar un commit "perdido" tras un reset --hard
git reflog                                # encontrar el hash
git reset --hard a1b2c3                   # volver a ese commit

# Recuperar commits después de un rebase
git reflog                                # los commits originales aún están
git cherry-pick d4e5f6                    # recuperar commit específico

# Limpiar reflog (entradas de más de 30 días)
git reflog expire --expire=30.days --all
git gc                                    # recolección de basura (libera espacio)
```

> **⚠️ Importante:** El reflog es **local**. No se comparte con remotos. Si clonas el repo en otra máquina, el reflog no está. Para cambios remotos, usa `git fsck` en el remoto (si tienes acceso).

---

## Bisect — Encontrar el commit culpable

`git bisect` realiza una **búsqueda binaria** en el historial para encontrar el commit exacto que introdujo un bug:

```bash
# 1. Iniciar bisect
git bisect start
git bisect bad                            # commit actual está roto

# 2. Marcar un commit bueno conocido
git bisect good v1.0                      # la versión v1.0 funcionaba

# 3. Git selecciona un commit intermedio. Pruébalo.
# Si funciona:
git bisect good                           # el bug está en commits posteriores
# Si no funciona:
git bisect bad                            # el bug está en commits anteriores

# 4. Repetir hasta que Git encuentre el primer commit malo
# a1b2c3 es el primer commit malo

# 5. Finalizar
git bisect reset                          # volver a HEAD
```

### Bisect automatizado con `git bisect run`

Si tienes un script que devuelve 0 (bueno) o distinto de 0 (malo), puedes automatizar todo el proceso:

```bash
# Script de prueba (e.g., test-bug.sh)
#!/bin/bash
npm test                                   # 0 = pasa, !=0 = falla
make test                                  # o cualquier comando

# Automatizar bisect:
git bisect start HEAD v1.0                 # bad=HEAD, good=v1.0
git bisect run npm test                    # git ejecuta npm test en cada commit
# ... git encuentra el commit culpable solo ...

# Bisect con script personalizado
git bisect run ./test-bug.sh
```

### Consejos para bisect

```bash
# Bisect con saltos (evita commits de merge)
git bisect skip                            # saltar este commit (si no se puede probar)

# Bisect visual (ver progreso)
git bisect visualize                       # abre gitk mostrando el rango

# Bisect con log
git bisect log > bisect.log                # guardar estado para reanudar después
git bisect replay bisect.log               # reanudar

# Bisect con rango de fechas
git bisect start --first-parent            # solo sigue la rama principal (evita merges)
```

---

## Hooks — Automatización con Git

Los hooks son **scripts que se ejecutan automáticamente** en ciertos eventos. Se almacenan en `.git/hooks/` y deben tener permiso de ejecución.

### Tipos de hooks

#### Client-side (locales)

| Hook | Cuándo se ejecuta | Caso de uso típico |
|---|---|---|
| `pre-commit` | Antes de crear el commit | Linter, formateo, verificar tests rápidos |
| `prepare-commit-msg` | Antes de abrir el editor del mensaje | Agregar información automática al mensaje |
| `commit-msg` | Después de escribir el mensaje | Validar formato del mensaje (conventional commits) |
| `post-commit` | Después del commit | Notificaciones, actualizar issue tracker |
| `post-checkout` | Después de `git checkout` / `git switch` | Restaurar dependencias (`npm install`) |
| `pre-push` | Antes de enviar al remoto | Ejecutar tests completos, verificar builds |
| `pre-rebase` | Antes de un rebase | Validar que no se está rebaseando una rama protegida |

#### Server-side (remotos)

| Hook | Cuándo se ejecuta | Caso de uso |
|---|---|---|
| `pre-receive` | Al recibir push en el servidor | Validar que el push cumple políticas |
| `update` | Por cada rama actualizada | Restringir acceso a ramas específicas |
| `post-receive` | Después de aceptar el push | Hacer deploy, CI/CD, notificar |
| `post-update` | Similar a post-receive | Actualizar servidores |

### Ejemplos de hooks

```bash
# pre-commit: ejecutar linter antes de commitear
# .git/hooks/pre-commit
#!/bin/bash
echo "🔍 Ejecutando linter..."
npx eslint src/
if [ $? -ne 0 ]; then
    echo "❌ Linter falló. Corrige los errores antes de commitear."
    exit 1
fi
echo "✅ Linter OK"
```

```bash
# commit-msg: validar conventional commits
# .git/hooks/commit-msg
#!/bin/bash
COMMIT_MSG=$(cat "$1")
PATTERN="^(feat|fix|docs|style|refactor|test|chore|perf)(\(.+\))?: .{1,72}"

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
    echo "❌ El mensaje debe seguir conventional commits:"
    echo "   feat: nueva funcionalidad"
    echo "   fix: corrección de bug"
    echo "   docs: cambios en documentación"
    echo "   refactor: refactorización"
    echo "   test: cambios en tests"
    echo "   chore: mantenimiento"
    exit 1
fi
```

```bash
# post-checkout: instalar dependencias al cambiar de rama
# .git/hooks/post-checkout
#!/bin/bash
# $1 = ref anterior, $2 = ref nuevo, $3 = 1 si fue checkout de archivos

if [ "$3" -eq 1 ] && [ -f "package.json" ]; then
    OLD_HASH=$(git rev-parse "$1")
    NEW_HASH=$(git rev-parse "$2")
    OLD_LOCK=$(git show "$OLD_HASH:package-lock.json" 2>/dev/null | md5sum)
    NEW_LOCK=$(git show "$NEW_HASH:package-lock.json" 2>/dev/null | md5sum)

    if [ "$OLD_LOCK" != "$NEW_LOCK" ]; then
        echo "📦 package-lock.json cambió, ejecutando npm install..."
        npm install
    fi
fi
```

```bash
# pre-push: ejecutar tests antes de subir
# .git/hooks/pre-push
#!/bin/bash
echo "🧪 Ejecutando tests..."
npm test
if [ $? -ne 0 ]; then
    echo "❌ Tests fallaron. Corrige antes de hacer push."
    exit 1
fi
```

### Compartir hooks (para el equipo)

Los hooks en `.git/hooks/` **no se versionan** (están en `.gitignore` por defecto). Para compartirlos:

```bash
# 1. Guardar hooks en el repo (e.g., en .githooks/)
mkdir -p .githooks
# ... poner hooks aquí ...
chmod +x .githooks/*

# 2. Configurar git para que use esa carpeta
git config core.hooksPath .githooks/

# 3. O, mejor aún, automatizarlo en setup:
# git config core.hooksPath .githooks/
```

### Framework de hooks: Husky (Node.js)

Para equipos JavaScript/TypeScript, **Husky** gestiona hooks desde `package.json`:

```bash
npm install husky --save-dev
npx husky init

# .husky/pre-commit
#!/usr/bin/env sh
npx lint-staged

# .husky/commit-msg
#!/usr/bin/env sh
npx --no -- commitlint --edit "$1"
```

---

## Worktrees — Múltiples directorios de trabajo

`git worktree` permite tener **varias copias del mismo repositorio** en diferentes ramas simultáneamente, sin hacer clone:

```bash
# Crear un worktree para feature-x
git worktree add ../mi-proyecto-feature-x feature-x
# Ahora puedes trabajar en ../mi-proyecto-feature-x sin afectar el main

# Crear worktree para revisar un PR
git worktree add ../review-pr-42 feature-pr

# Listar worktrees
git worktree list
# /home/user/mi-proyecto          e1a2b3c [main]
# /home/user/mi-proyecto-feature-x f4g5h6 [feature-x]

# Eliminar worktree
git worktree remove ../mi-proyecto-feature-x

# Limpiar worktrees huérfanos (si se eliminó la carpeta manualmente)
git worktree prune
```

**¿Cuándo usar worktrees?**
- Revisar un PR mientras trabajas en otra cosa
- Tener la documentación abierta en otra rama
- Compilar y probar diferentes ramas sin stash/checkout constante

---

## Submodules — Dependencias externas

Los submódulos permiten incluir otros repositorios Git dentro del tuyo:

```bash
# Agregar submodule
git submodule add https://github.com/usuario/libreutil.git lib/libreutil

# Clonar repositorio CON submódulos
git clone --recurse-submodules https://github.com/usuario/mi-proyecto.git

# Clonar repositorio y luego inicializar submódulos
git clone https://github.com/usuario/mi-proyecto.git
git submodule init                          # registrar submódulos en .git/config
git submodule update                        # descargar contenido de submódulos
git submodule update --remote               # actualizar al último commit de cada submódulo

# Ver submódulos configurados
git submodule status

# Actualizar submódulo a nuevo commit
cd lib/libreutil
git checkout v2.0.0
cd ../..
git add lib/libreutil
git commit -m "chore: actualizar libreutil a v2.0.0"
```

**⚠️ Advertencias sobre submódulos:**

- Añaden complejidad: cada persona debe acordarse de `git submodule update`
- Los submódulos quedan en un commit específico (detached HEAD), no en una rama
- Para equipos, considera alternativas modernas como **dependencias gestionadas por el ecosistema** (npm, Cargo, pip, etc.)

---

## Tagging — Marcadores de versión

```bash
# Tag ligero (solo un nombre para un commit)
git tag v1.0.0

# Tag anotado (con mensaje, autor, fecha — recomendado)
git tag -a v1.0.0 -m "Versión 1.0.0 - Release inicial"

# Ver tags
git tag                                     # listar tags
git tag -l "v2.*"                           # filtrar
git show v1.0.0                             # detalle del tag

# Subir tags al remoto
git push origin v1.0.0                      # subir tag específico
git push --tags                             # subir todos los tags (⚠️ cuidado)

# Eliminar tag
git tag -d v1.0.0                           # local
git push origin --delete v1.0.0             # remoto
```

---

## Deshacer cambios (referencia rápida)

```bash
# Antes de commit
git restore archivo.txt                     # descartar cambios locales
git restore --staged archivo.txt            # sacar del staging (mantener cambios)
git checkout -- archivo.txt                 # forma clásica

# Después de commit (local)
git commit --amend -m "Nuevo mensaje"       # corregir mensaje del último commit
git reset --soft HEAD~1                     # deshacer commit, mantener cambios en staging
git reset --mixed HEAD~1                    # deshacer commit, mantener cambios en working dir
git reset --hard HEAD~1                     # deshacer commit Y descartar cambios (❗)
git reset --hard a1b2c3                     # volver a un commit específico

# Después de push (⚠️ destructivo)
git revert HEAD                             # crear nuevo commit que deshace el último (seguro)
git revert a1b2c3                           # deshacer commit específico
git revert a1b2c3..d4e5f6                   # revertir rango de commits

# Recuperar commits del reflog
git reflog                                  # encontrar el hash perdido
git cherry-pick a1b2c3                      # recuperar commit específico
```

### git reset — Los 3 modos

| Modo | HEAD | Staging | Working Directory |
|---|---|---|---|
| `--soft` | ✅ Cambia | ❌ No toca | ❌ No toca |
| `--mixed` (default) | ✅ Cambia | ✅ Limpia | ❌ No toca |
| `--hard` | ✅ Cambia | ✅ Limpia | ✅ Limpia |

```bash
# Ejemplos por situación:
# Quieres rehacer el commit pero mantener los cambios staged
git reset --soft HEAD~1

# Quieres rehacer el commit y volver a seleccionar qué incluir
git reset --mixed HEAD~1                    # o simplemente git reset HEAD~1

# Quieres borrar todo el último commit y sus cambios (¡cuidado!)
git reset --hard HEAD~1
```

---

## Comandos útiles del día a día

```bash
git diff                                     # cambios sin staging
git diff --staged                            # cambios en staging
git diff main..feature                      # diferencias entre dos ramas
git diff main...feature                     # diferencias desde que feature se separó
git show                                     # detalle del último commit
git show <commit-hash>                       # detalle de un commit específico
git blame archivo.txt                        # quién cambió cada línea y cuándo
git shortlog -sne                            # contribuciones por autor

# Filtrar log
git log --author="Carlos"                    # commits de un autor
git log --since="2024-01-01"                 # commits desde fecha
git log --grep="feat:"                       # commits con "feat:" en el mensaje
git log -S "funcionBuscada"                  # commits que modifican una función
git log --oneline --graph --all              # árbol completo del repo

# Encontrar archivos y cambios
git whatchanged archivo.txt                  # qué cambió en este archivo
git log --all --full-history -- "*.ts"       # historial completo de archivos .ts

# Guardar credenciales (para no escribir usuario/contraseña cada vez)
git config --global credential.helper store           # guarda en texto plano
git config --global credential.helper 'cache --timeout=3600'  # cachea por 1 hora

# Comprobar estado del repositorio
git status --short                           # formato compacto (ideal para scripts)
git status -sb                               # aún más compacto, con branch info
```

### Comandos de emergencia

```bash
# Me equivoqué en el último commit y quiero agregar más cambios
git add .
git commit --amend --no-edit                 # agrega cambios al último commit sin cambiar mensaje

# Quiero volver un archivo a como estaba en main
git restore --source=main archivo.txt

# Estoy en medio de un conflicto y quiero la versión de una rama específica
git checkout --ours archivo.txt              # versión de la rama actual
git checkout --theirs archivo.txt            # versión de la rama que estás mergeando

# Eliminar archivo del historial de Git (⚠️ peligroso, reescribe historial)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch archivo-secreto.txt" \
  --prune-empty --tag-name-filter cat -- --all
# Alternativa moderna: git-filter-repo
```

---

## Nomenclatura de commits

Un buen mensaje de commit sigue esta estructura:

```
<tipo>: <descripción breve>

Cuerpo opcional explicando el por qué y el cómo.
```

| Tipo | Cuándo usarlo |
|---|---|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `docs` | Cambios en documentación |
| `style` | Cambios de formato (espacios, comillas, etc.) |
| `refactor` | Cambio de código que no agrega funcionalidad ni corrige bugs |
| `test` | Agregar o modificar tests |
| `chore` | Tareas de mantenimiento (dependencias, config) |
| `perf` | Mejora de rendimiento |

```bash
git commit -m "feat: agregar login con GitHub"
git commit -m "fix: error al calcular impuestos con valores negativos"
git commit -m "docs: actualizar README con instrucciones de instalación"

# Mensaje completo (con cuerpo):
git commit -m "feat: agregar autenticación OAuth

Implementa login con Google y GitHub usando OAuth 2.0.
Agrega middleware de verificación de tokens JWT.

Closes #42"
```

---

## Alternativas y complementos

| Herramienta | Diferencias con Git CLI |
|---|---|
| **Git GUI** | Interfaz gráfica incluida con Git (`git gui`) |
| **GitKraken** | GUI multiplataforma, muy visual, de pago para uso avanzado |
| **LazyGit** | TUI (terminal UI) para Git, navegación con teclas |
| **tig** | TUI para explorar el historial (como `git log` interactivo) |
| **Hub / Gh** | Extensiones CLI para GitHub (`gh pr create`, `gh issue list`) |
| **delta** | Pager para `git diff` con syntax highlighting y side-by-side |
| **gitflow** | Extensiones para el flujo GitFlow (`git flow feature start`) |
| **diff-so-fancy** | Mejora la salida de `git diff` con colores y formato |

---

## Buenas prácticas y advertencias

- **Commits pequeños y atómicos**: un cambio por commit. Si tienen que revertir uno, no arrastra cambios no relacionados.
- **Mensajes descriptivos**: el `git log --oneline` debe contar la historia del proyecto.
- **`git push --force`** sobreescribe el historial remoto. **Peligroso** en ramas compartidas. Preferir `--force-with-lease` que verifica que nadie más haya subido cambios.
- **`.gitignore` se versiona** (va en el repo). `.env` y archivos con secretos **nunca** deben commiteare.
- **`git reset --hard`** descarta cambios sin posibilidad de recuperación a menos que tengas el hash en el reflog.
- **Revisa siempre** lo que vas a commitear: `git diff --staged` antes de commitear, `git status` antes de hacer push.
- **Protege `main`**: usa branch protection en GitHub/GitLab para evitar pushes directos y requerir PRs + approvals.

```bash
# Buen .gitignore típico
cat .gitignore
.DS_Store
*.log
.env
node_modules/
dist/
build/
*.swp
__pycache__/
.venv/
```

## Notas y advertencias

- `git reset --hard` descarta cambios **sin posibilidad de recuperación** (a menos que tengas el commit hash en el reflog: `git reflog`). Usar con cuidado.
- `git push --force` sobreescribe el historial remoto. Peligroso en ramas compartidas. Preferir `--force-with-lease` que verifica que nadie más haya subido cambios.
- Hacer commits pequeños y frecuentes, no acumular todo para un solo commit grande.
- `.gitignore` se versiona (va en el repo). `.env` y archivos con secretos **nunca** deben commiteare.
- Los hooks en `.git/hooks/` no se versionan. Usa `core.hooksPath` para compartirlos con el equipo.
- El reflog es local. No esperes recuperar commits en otro clon del repositorio.

## Ver también

- [[alias]] — crear alias para comandos git frecuentes (`alias gs='git status'`)
- [[diff]] — herramienta que Git usa internamente para mostrar diferencias
- [[source]] — recargar config tras editar `.bashrc`
- [[Editores de Texto]] — elegir editor para mensajes de commit
- [[Shells (bash zsh fish)]] — plugins de Git en Oh My Zsh
- [[Desarrollo en Linux (gcc make gdb strace)]] — Git es esencial en desarrollo

## Enlaces externos

- [Git — Documentación oficial](https://git-scm.com/doc)
- [Git — Pro Git Book (gratuito)](https://git-scm.com/book/es/v2)
- [GitHub — Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Atlassian — Tutoriales de Git](https://www.atlassian.com/git/tutorials)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Husky — Git hooks para Node.js](https://typicode.github.io/husky/)
- [Arch Wiki — Git](https://wiki.archlinux.org/title/Git)

#programa
