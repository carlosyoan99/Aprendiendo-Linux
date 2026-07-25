---
fecha_creacion: 2026-07-20
estado: resuelto
categoria: programa
prioridad: alta
licencia: MIT
alternativas: hub, Git CLI (git), GitHub web, GitLab CLI (glab), BitBucket CLI
---

# GitHub CLI (gh)

> Interfaz de línea de comandos oficial de GitHub. Permite gestionar repositorios, pull requests, issues, Actions, Codespaces, releases, gists y cualquier recurso de GitHub **sin salir de la terminal**. A diferencia del antiguo `hub`, `gh` es un binario independiente que no envuelve a `git`.

## Instalación

```bash
# Debian/Ubuntu (repositorio oficial)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh

# Arch Linux
sudo pacman -S github-cli

# Fedora
sudo dnf install gh

# Snap
sudo snap install gh

# Verificar instalación
gh --version
```

## Autenticación

Antes de usar `gh`, necesitas autenticarte:

```bash
# Autenticación interactiva (recomendado)
gh auth login

# Te guiará por:
# 1. ¿Cuenta GitHub.com o GitHub Enterprise Server?
# 2. ¿HTTPS o SSH?
# 3. Autenticar en el navegador (pegar un código de 8 caracteres)
# 4. Configurar git credential helper (opcional)

# Autenticación con token (CI/CD, scripting)
gh auth login --with-token < ~/mi-token-github.txt
# o
echo "ghp_xxxxxxxxxxxx" | gh auth login --with-token

# Verificar autenticación
gh auth status

# Cambiar de cuenta
gh auth logout
gh auth login

# Ver token actual
gh auth token
```

```bash
# Configuración del host (útil si usas GitHub Enterprise)
gh config set git_protocol ssh          # o https
gh config set editor code               # editor para commits/issues
```

---

## Repositorios — `gh repo`

```bash
# Crear repositorio
gh repo create mi-proyecto              # interactivo
gh repo create mi-proyecto --public --clone  # público y clonado localmente
gh repo create mi-proyecto --private --push   # privado con push desde el directorio actual
gh repo create org/mi-proyecto --internal     # en una organización

# Clonar
gh repo clone owner/repo                # te evita escribir la URL completa + remote
gh repo clone owner/repo -- --depth=1   # shallow clone (pasa --depth a git)
gh repo clone owner/repo ~/mis-proyectos/nombre-local

# Ver información del repositorio
gh repo view                            # README + metadatos en terminal
gh repo view --web                      # abrir en navegador
gh repo view owner/repo                 # de otro repo

# Navegación rápida al navegador
gh browse                               # abrir repo actual en navegador
gh browse --issues                      # ir a Issues
gh browse -- pulls                      # ir a Pull Requests
gh browse --settings                    # ir a Settings
gh browse -- wiki                       # ir a Wiki
gh browse -- projects                   # ir a Projects
gh browse -- branch feature-x          # abrir una rama específica
gh browse -R owner/repo                # navegar a otro repo
gh browse src/main.ts                  # abrir un archivo específico
gh browse src/ --branch develop        # abrir directorio en una rama

# Fork y sincronización
gh repo fork owner/repo                 # fork con upstream configurado
gh repo fork --clone                    # fork + clonar localmente
gh repo sync                            # sincronizar fork con upstream

# Gestionar repositorios
gh repo list                            # listar tus repositorios
gh repo list owner --limit 50           # repos de otro usuario/org
gh repo list --language python          # filtrar por lenguaje
gh repo list --topic web,api            # filtrar por topic
gh repo delete owner/repo               # eliminar repositorio

# Archivar/desarchivar
gh repo archive owner/repo
gh repo unarchive owner/repo
```

---

## Pull Requests — `gh pr`

Esta es probablemente la funcionalidad más usada de `gh` — gestionar PRs sin abrir el navegador.

### Crear PRs

```bash
# Crear PR desde la rama actual
git checkout -b feat/login              # crear rama
# ... trabajar, commitear, pushear ...
git push -u origin feat/login
gh pr create                            # abre un asistente interactivo

# Crear PR directamente
gh pr create --title "feat: login con OAuth" \
             --body "Implementa autenticación OAuth2 con Google y GitHub" \
             --assignee @me \
             --label enhancement \
             --reviewer carlos

gh pr create --fill                     # usa el mensaje del commit como título y cuerpo
gh pr create --draft                    # PR en modo draft (no listo para review)
gh pr create --web                      # abrir el formulario en el navegador
```

### Listar y ver PRs

```bash
# Listar PRs
gh pr list                              # PRs abiertos
gh pr list --state merged               # PRs mergeados
gh pr list --state closed               # PRs cerrados
gh pr list --author @me                 # mis PRs
gh pr list --label bug                  # filtrados por label
gh pr list --limit 50                   # más resultados
gh pr list --base main                  # PRs contra main
gh pr list --search "login"             # búsqueda textual

# Ver detalle de un PR
gh pr view 42                           # información del PR #42
gh pr view 42 --web                     # abrir en navegador
gh pr view 42 --comments                # ver comentarios
gh pr view 42 -c                        # ver solo los commits del PR
```

### Revisar PRs

```bash
# Revisar un PR desde la terminal
gh pr review 42 --approve               # aprobar
gh pr review 42 --request-changes       # solicitar cambios
gh pr review 42 --comment               # comentar sin aprobar/rechazar
gh pr review 42 --approve --body "LGTM! 🚀"

# Añadir revisores
gh pr edit 42 --add-reviewer usuario1,usuario2
gh pr edit 42 --remove-reviewer usuario1
```

### Checkout de PRs

```bash
gh pr checkout 42                       # descargar PR en nueva rama local
gh pr checkout 42 --branch feat-mejorado  # con nombre personalizado
```

### Mergear PRs

```bash
gh pr merge 42                          # merge interactivo
gh pr merge 42 --merge                  # merge commit
gh pr merge 42 --squash                 # squash and merge
gh pr merge 42 --rebase                 # rebase and merge
gh pr merge 42 --delete-branch          # eliminar rama remota tras merge
gh pr merge 42 --auto                   # habilitar auto-merge
```

### Cerrar y reabrir

```bash
gh pr close 42                          # cerrar sin mergear
gh pr close 42 --comment "Ya no es necesario"
gh pr reopen 42                         # reabrir
```

### Diff y checks

```bash
gh pr diff 42                           # ver el diff del PR
gh pr checks 42                         # ver estado de los checks (Actions)
gh pr checks 42 --watch                 # ver checks en tiempo real
gh pr status                            # resumen: PRs abiertos, revisores pendientes, checks
```

---

## Issues — `gh issue`

```bash
# Crear issue
gh issue create                         # interactivo
gh issue create --title "Bug: login falla con email inválido" \
                --body "Pasos para reproducir: ..." \
                --label bug \
                --assignee @me

gh issue create --label "good first issue" --project "Q3 Sprint"

# Listar issues
gh issue list                           # issues abiertos
gh issue list --state closed            # issues cerrados
gh issue list --label bug               # filtrados por label
gh issue list --assignee @me            # asignados a mí
gh issue list --mention @me             # me mencionan
gh issue list --milestone "v2.0"        # issues de un milestone

# Ver issue
gh issue view 123                       # detalle del issue #123
gh issue view 123 --web                 # abrir en navegador
gh issue view 123 --comments            # ver comentarios

# Cerrar y reabrir
gh issue close 123 --comment "Resuelto en #42"
gh issue reopen 123

# Buscar issues
gh search issues "error de login" --repo owner/repo
gh search issues --label "help wanted" --language python
```

### Búsqueda global — `gh search`

`gh search` busca en todo GitHub (no solo en el repo actual):

| Tipo | Comando | Descripción |
|---|---|---|
| **Repos** | `gh search repos "machine learning" --limit 20` | Buscar repositorios por nombre/descripción |
| **Issues** | `gh search issues "bug" --label help-wanted` | Issues con ciertas etiquetas |
| **PRs** | `gh search prs --review-required=@me` | PRs que requieren tu revisión |
| **Code** | `gh search code "function main" --language go` | Buscar código en repositorios públicos |
| **Commits** | `gh search commits "fix" --author @me` | Commits que coinciden con el mensaje |

```bash
gh search repos "todo-app" --stars=">=100" --language=python
gh search prs --author @me --state open
gh search code "import React" --extension=tsx -R facebook/react
```

---

## Actions Secrets y Variables — `gh secret` / `gh variable`

```bash
# Secrets (encriptados)
gh secret list                          # listar secrets del repo
gh secret list --org mi-org             # secrets de organización
gh secret set API_KEY < api_key.txt     # crear secret desde archivo
gh secret set API_KEY -b "valor-secreto" # desde inline
gh secret set DEPLOY_KEY --env production # secreto de entorno
gh secret delete API_KEY

# Variables (no encriptadas)
gh variable list                        # listar variables del repo
gh variable set NODE_VERSION -b "20"
gh variable set DB_HOST -b "prod.example.com"
gh variable delete NODE_VERSION
```

---

## GitHub Actions — `gh run` y `gh workflow`

```bash
# Ver workflows disponibles
gh workflow list                        # todos los workflows del repo
gh workflow list --all                  # incluir workflows deshabilitados

# Activar/desactivar workflow
gh workflow enable build.yml
gh workflow disable build.yml

# Ejecutar workflow manualmente
gh workflow run build.yml               # con valores por defecto
gh workflow run build.yml --ref main    # en una rama específica
gh workflow run deploy.yml -f env=production -f tag=v2.0  # con inputs

# Ver ejecuciones (runs)
gh run list                             # últimas ejecuciones
gh run list --workflow=build.yml        # de un workflow específico
gh run list --branch main               # de una rama específica
gh run list --status failure            # solo las que fallaron
gh run list --limit 30                  # más resultados

# Ver detalle de una ejecución
gh run view 1234567890                  # información de la ejecución
gh run view 1234567890 --log            # logs completos
gh run view 1234567890 --log-failed     # solo logs de pasos que fallaron

# Seguir ejecución en tiempo real
gh run watch 1234567890                 # mostrar progreso en vivo

# Cancelar / re-ejecutar
gh run cancel 1234567890
gh run rerun 1234567890                 # re-ejecutar
gh run rerun 1234567890 --failed        # solo los jobs que fallaron

# Descargar artefactos
gh run download 1234567890              # descargar artefactos del run
gh run download 1234567890 -n build-zip # descargar un artefacto específico
```

```bash
# Verificar estado de CI de un PR específico
gh pr checks 42

# Revisar si los checks pasaron antes de mergear
gh pr merge 42 --auto --squash          # auto-merge cuando checks pasen
```

---

## Codespaces — `gh codespace`

```bash
# Listar codespaces activos
gh codespace list

# Crear codespace
gh codespace create                     # del repo actual
gh codespace create -r owner/repo       # de un repo específico
gh codespace create -b feature-x        # de una rama específica

# Conectarse a un codespace
gh codespace ssh                        # SSH interactivo (elige codespace si hay varios)
gh codespace ssh -c codespace-name      # a uno específico
gh codespace code                       # abrir VS Code remoto
gh codespace jupyter                    # abrir Jupyter Notebook

# Ver recursos y puertos
gh codespace logs                       # logs del codespace
gh codespace ports                      # puertos reenviados
gh codespace ports visibility 3000:public  # hacer público un puerto

# Gestionar
gh codespace stop -c codespace-name     # detener
gh codespace start -c codespace-name    # iniciar
gh codespace rebuild -c codespace-name  # reconstruir contenedor
gh codespace delete -c codespace-name   # eliminar
gh codespace cp archivo.txt remote:~/   # copiar archivo (como scp)
gh codespace cp remote:~/output.txt .   # copiar archivo del codespace
```

---

## Releases — `gh release`

```bash
# Crear release
gh release create v1.0.0               # desde el tag v1.0.0
gh release create v1.0.0 --title "v1.0.0 - Release inicial" \
                    --notes "Primera versión estable" \
                    --target main
gh release create v1.0.0 dist/*.tar.gz  # con archivos adjuntos
gh release create v1.0.0 --generate-notes  # notas generadas automáticamente
gh release create v1.0.0 --draft       # release en borrador
gh release create v1.0.0 --prerelease # pre-release

# Listar releases
gh release list                         # releases publicados
gh release list --limit 30              # más resultados
gh release list --exclude-drafts        # excluir borradores

# Ver release
gh release view v1.0.0                 # detalle del release
gh release view v1.0.0 --web           # abrir en navegador

# Descargar assets
gh release download v1.0.0             # descargar todos los assets
gh release download v1.0.0 -p "*.tar.gz"  # descargar solo .tar.gz
gh release download v1.0.0 -D ./dist   # descargar a directorio específico
```

---

## Gists — `gh gist`

```bash
# Crear gist
gh gist create archivo.txt              # gist público
gh gist create archivo.txt --secret     # gist secreto
gh gist create src/*.py                 # múltiples archivos
gh gist create -d "Utilidad para..."    # con descripción

# Listar gists
gh gist list                            # tus gists
gh gist list --public                   # solo públicos
gh gist list --limit 50

# Ver gist
gh gist view gist_id                    # contenido del gist
gh gist view gist_id --web              # abrir en navegador
gh gist view gist_id --files src/main.py  # archivo específico

# Editar y eliminar
gh gist edit gist_id                    # editar gist
gh gist delete gist_id                  # eliminar gist
```

---

## API de GitHub — `gh api`

`gh api` permite hacer llamadas directas a la API REST de GitHub (o GraphQL) sin necesidad de `curl` + tokens:

```bash
# API REST
gh api user                             # tu perfil (/user)
gh api repos/owner/repo                 # información del repo
gh api repos/owner/repo/issues          # issues del repo
gh api repos/owner/repo/pulls           # PRs del repo
gh api repos/owner/repo/releases/latest # última release

# Con parámetros
gh api repos/owner/repo/issues --method POST \
  -f title="Nuevo issue desde CLI" \
  -f body="Creado con gh api"

# Paginación (--paginate)
gh api repos/owner/repo/issues --paginate

# GraphQL
gh api graphql -f query='
  query {
    repository(owner: "owner", name: "repo") {
      name
      stargazerCount
      forkCount
    }
  }
'

# Salida en bruto (útil para jq)
gh api repos/owner/repo/releases --jq '.[].tag_name'
# gh api user --jq '.login'
# gh api repos/owner/repo/issues --jq '.[].title'
```

---

## Extensiones — `gh extension`

`gh` se puede extender con plugins de la comunidad:

```bash
# Listar extensiones instaladas
gh extension list

# Instalar extensiones
gh extension install github/gh-copilot  # GitHub Copilot CLI
gh extension install nektos/gh-act      # ejecutar Actions localmente
gh extension install dlvhdr/gh-dash     # dashboard de PRs/issues
gh extension install seachicken/gh-poi  # limpiar ramas locales mergeadas

# Ejecutar una extensión
gh copilot suggest "how to list all branches"
gh act --help
gh dash
gh poi

# Crear tu propia extensión
# gh-<nombre> es un script ejecutable (bash, Python, Go...)
mkdir gh-saluda && cd gh-saluda
cat > gh-saluda << 'EOF'
#!/bin/bash
echo "¡Hola desde gh saluda! 🎉"
EOF
chmod +x gh-saluda
gh extension install .
gh saluda                                # ejecuta el script
```

### Extensiones populares

| Extensión | Comando | Propósito |
|---|---|---|
| `github/gh-copilot` | `gh copilot suggest` | Asistente AI en terminal (GitHub Copilot CLI) |
| `nektos/gh-act` | `gh act` | Ejecutar Actions localmente (sin push) |
| `dlvhdr/gh-dash` | `gh dash` | Dashboard TUI de PRs, issues y Actions |
| `seachicken/gh-poi` | `gh poi` | Eliminar ramas locales que ya se mergearon |
| `kawarimidoll/gh-qldb` | `gh qldb` | Query Language para PRs/issues filtrados |
| `yusukebe/gh-hg` | `gh hg` | Abrir repo en browser con `gh hg` |

---

## Alias — Atajos personalizados

```bash
# Crear alias
gh alias set co "pr checkout"           # gh co 42 → gh pr checkout 42
gh alias set iv "issue view"            # gh iv 123 → gh issue view 123
gh alias set pc "pr create --fill"      # gh pc → gh pr create --fill
gh alias set prs "pr list --author @me" # gh prs → mis PRs abiertos
gh alias set todos "issue list --assignee @me --label todo"

# Alias con argumentos
gh alias set find "!gh issue list --label \"$1\" | gh issue view \"$(fzf)\""
gh alias set open "!gh repo view --web"

# Listar alias
gh alias list

# Eliminar alias
gh alias delete co
```

---

## Flujos de trabajo comunes

### Flujo completo: feature → PR → merge

```bash
# 1. Partir de main actualizado
git switch main
git pull --rebase

# 2. Crear rama de feature
git switch -c feat/autenticacion-oauth

# 3. Trabajar, commitear, pushear
git add .
git commit -m "feat: implementar autenticación OAuth"
git push -u origin feat/autenticacion-oauth

# 4. Crear PR
gh pr create --title "feat: autenticación OAuth" \
             --body "Implementa login con Google y GitHub" \
             --assignee @me \
             --reviewer carlos

# 5. Mientras esperas revisión, puedes ver el estado
gh pr status
gh pr checks 42 --watch                  # ver CI en tiempo real

# 6. Cuando te aprueben, mergear
gh pr review 42 --approve
gh pr merge 42 --squash --delete-branch

# 7. Volver a main actualizado
git switch main
git pull --rebase
```

### Revisar PRs de otros

```bash
# 1. Ver qué PRs necesitan review
gh search prs --review-required=@me --json=number,title,author
# o usar gh-dash: gh dash

# 2. Checkout del PR localmente
gh pr checkout 42

# 3. Revisar cambios
gh pr diff 42
# o: code .  (vs code con diff)

# 4. Aprobar o solicitar cambios
gh pr review 42 --approve --body "Código limpio, tests pasan ✅"
# gh pr review 42 --request-changes --body "Falta validación de email"
```

### CI/CD con GitHub Actions

```bash
# 1. Ver estado del CI del proyecto
gh run list --limit 5

# 2. Ver si un PR específico pasa los checks
gh pr checks 42

# 3. Si un workflow falló, ver logs
gh run view 1234567890 --log-failed

# 4. Corregir y re-ejecutar
gh run rerun 1234567890 --failed

# 5. Habilitar auto-merge en PR para cuando pase CI
gh pr merge 42 --auto --squash
```

### Publicar una release

```bash
# 1. Crear tag
git tag -a v2.0.0 -m "v2.0.0"
git push origin v2.0.0

# 2. Crear release con assets
gh release create v2.0.0 \
  --title "v2.0.0 - Nueva API" \
  --notes "**Cambios:**\n- Nueva API REST\n- Corrección de bugs" \
  dist/*.tar.gz dist/*.deb

# 3. Verificar
gh release view v2.0.0
```

---

## gh vs hub

| Aspecto | `gh` (GitHub CLI) | `hub` |
|---|---|---|
| **Desarrollo** | Oficial (GitHub) | Comunidad (antiguo oficial) |
| **Dependencia** | Independiente de git | Envuelve comandos git |
| **Instalación** | Binario único | Ruby gem o binario |
| **Compatibilidad** | Git 2.27+ | Git legacy |
| **Soporte** | Activo, nuevas features | Mantenimiento, sin nuevas features |
| **Comandos** | `gh pr create` | `git pull-request` |
| **Codespaces** | ✅ Nativo | ❌ |
| **Actions** | ✅ `gh run`, `gh workflow` | ❌ |
| **API directa** | ✅ `gh api` | ❌ |

> **¿Cuál usar?** `gh` es el recomendado. `hub` sigue funcionando pero no recibe nuevas funcionalidades. Ambos pueden coexistir.

---

## Configuración

```bash
# Ver configuración actual
gh config list

# Configurar opciones
gh config set git_protocol ssh          # ssh | https (protocolo git)
gh config set editor code               # editor para gh edit, gh issue create
gh config set browser firefox           # navegador para gh ... --web
gh config set pager delta              # pager para salidas largas (delta, bat, less)

# Configuración por host (GitHub Enterprise)
gh config set git_protocol https --host github.empresa.com
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `gh: command not found` | gh no instalado o no en PATH | Verificar instalación: `which gh`. En Snap: `snap install gh` |
| `You are not logged into any GitHub hosts` | No autenticado | `gh auth login` |
| `HTTP 403: Resource not accessible by integration` | Token sin permisos | Regenerar token con los scopes necesarios (repo, workflow) |
| `gh pr create: must have push access` | No tienes permisos de escritura | Hacer fork: `gh repo fork` y crear PR desde el fork |
| `gh pr merge: merge conflict` | Conflictos sin resolver | `gh pr checkout 42`, resolver conflictos, pushear de nuevo |
| `gh run view: no runs found` | Workflow no ejecutado o filtro incorrecto | `gh run list --workflow=build.yml` para filtrar por workflow |
| `gh codespace: no codespaces found` | No tienes codespaces activos | `gh codespace create` para crear uno nuevo |
| `Authentication failed` | Token expirado o mal configurado | `gh auth logout && gh auth login` |
| `Extension not found` | Error en nombre de extensión | Verificar formato: `gh extension install owner/repo` |

---

## Notas y advertencias

- `gh` es **independiente de `git`** — no necesitas `gh` para usar Git, pero se complementan muy bien
- Los comandos `gh pr create` y `gh issue create` son **mucho más rápidos** que hacerlo en el navegador
- `gh run watch` es excelente para CI/CD: te permite ver logs en tiempo real sin abrir GitHub
- Usa `gh api` para cualquier cosa que no tenga un comando específico (cubre toda la API REST de GitHub)
- Las extensions son scripts que cualquiera puede crear — revisa `gh extension create` para la tuya

## Ver también

- [[Git]] — sistema de control de versiones, base sobre la que opera gh
- [[alias]] — alias en bash, complementarios a los alias de gh
- [[Desarrollo en Linux (gcc make gdb strace)]] — toolchain de desarrollo
- [[Python en Linux]] — automatización con gh + Python
- [[Shells (bash zsh fish)]] — plugins de gh en Oh My Zsh

## Enlaces externos

- [GitHub CLI — Documentación oficial](https://cli.github.com/manual/)
- [GitHub CLI — Repositorio](https://github.com/cli/cli)
- [GitHub CLI — Extensiones](https://github.com/topics/gh-extension)
- [GitHub CLI — Guía de extensiones](https://docs.github.com/en/github-cli/github-cli/creating-github-cli-extensions)
- [GitHub: gh vs hub](https://github.com/cli/cli/blob/trunk/docs/gh-vs-hub.md)
- [gh act — Ejecutar Actions localmente](https://github.com/nektos/act)
- [gh dash — Dashboard TUI](https://github.com/dlvhdr/gh-dash)

#programa #github #cli
