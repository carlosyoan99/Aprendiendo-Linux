---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
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
# ── Autenticación ──
gh auth login                            # interactiva (guía paso a paso)
gh auth login --with-token < token.txt   # con token (CI/CD)
echo "ghp_xxx" | gh auth login --with-token
gh auth status                           # verificar sesión activa
gh auth logout                           # cerrar sesión
gh auth token                            # mostrar token actual

# ── Configuración del cliente ──
gh config set git_protocol ssh           # ssh | https
gh config set editor code                # editor para commits/issues
gh config set browser firefox            # navegador para gh ... --web
gh config list                           # ver configuración actual
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

```bash
# ── Crear PRs ──
git checkout -b feat/login && git push -u origin feat/login
gh pr create                            # interactivo (asistente)
gh pr create --title "feat: login" --body "Implementa OAuth" --label enhancement
gh pr create --fill                     # usa mensaje del commit como título/cuerpo
gh pr create --draft                    # modo draft (no listo para review)
gh pr create --web                      # abrir formulario en navegador

# ── Listar y ver ──
gh pr list                              # PRs abiertos
gh pr list --state merged --author @me --label bug --limit 50
gh pr list --base main --search "login"
gh pr view 42                           # detalle del PR
gh pr view 42 --web --comments          # en navegador o con comentarios
gh pr view 42 -c                        # solo los commits del PR

# ── Revisar ──
gh pr review 42 --approve               # aprobar
gh pr review 42 --request-changes       # solicitar cambios
gh pr review 42 --comment               # solo comentar
gh pr edit 42 --add-reviewer usuario1    # añadir revisor
gh pr edit 42 --remove-reviewer usuario1 # quitar revisor
gh pr checkout 42                       # descargar PR localmente

# ── Merge, cerrar, diff ──
gh pr merge 42 --squash --delete-branch  # squash + eliminar rama
gh pr merge 42 --auto --squash           # auto-merge cuando checks pasen
gh pr close 42                           # cerrar sin mergear
gh pr reopen 42                          # reabrir
gh pr diff 42                            # ver diff
gh pr checks 42 --watch                  # checks en tiempo real
gh pr status                             # resumen de PRs del repo
```

---

## Issues — `gh issue`

```bash
# ── Issues ──
gh issue create                         # interactivo
gh issue create --title "Bug: ..." --body "Pasos..." --label bug --assignee @me
gh issue list                           # abiertos
gh issue list --state closed --label bug --assignee @me
gh issue list --milestone "v2.0"
gh issue view 123                       # detalle
gh issue view 123 --web --comments
gh issue close 123 --comment "Resuelto en #42"
gh issue reopen 123

# ── Búsqueda global (en todo GitHub, no solo el repo actual) ──
# Tipos de búsqueda:
#   Repos:   gh search repos "machine learning" --limit 20 --stars=">=100"
#   Issues:  gh search issues "bug" --label help-wanted
#   PRs:     gh search prs --review-required=@me
#   Code:    gh search code "function main" --language go
#   Commits: gh search commits "fix" --author @me --repo owner/repo
gh search issues "error de login" --repo owner/repo
gh search issues --label "help wanted" --language python
gh search prs --author @me --state open
gh search code "import React" --extension=tsx -R facebook/react
```

---

## Actions, Secrets y Variables — `gh run`, `gh secret`, `gh variable`

```bash
# ── Secrets (encriptados) ──
gh secret list                          # listar secrets del repo
gh secret list --org mi-org             # secrets de organización
gh secret set API_KEY < api_key.txt     # desde archivo
gh secret set API_KEY -b "valor-secreto" # inline
gh secret set DEPLOY_KEY --env production
gh secret delete API_KEY

# ── Variables (no encriptadas) ──
gh variable list
gh variable set NODE_VERSION -b "20"
gh variable delete NODE_VERSION

# ── Workflows ──
gh workflow list                        # listar workflows
gh workflow enable build.yml
gh workflow disable build.yml
gh workflow run build.yml --ref main    # ejecutar manualmente
gh workflow run deploy.yml -f env=production -f tag=v2.0  # con inputs

# ── Runs (ejecuciones) ──
gh run list --workflow=build.yml --branch main --status failure
gh run view 1234567890 --log            # logs completos
gh run view 1234567890 --log-failed     # solo pasos fallidos
gh run watch 1234567890                 # progreso en tiempo real
gh run cancel 1234567890
gh run rerun 1234567890 --failed        # solo jobs fallidos
gh run download 1234567890 -n build-zip # descargar artefactos
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
# ── Crear ──
gh release create v1.0.0               # desde el tag v1.0.0
gh release create v1.0.0 --notes "Primera versión" --target main
gh release create v1.0.0 dist/*.tar.gz  # con archivos adjuntos
gh release create v1.0.0 --generate-notes --draft --prerelease

# ── Listar / Ver / Descargar ──
gh release list --limit 30 --exclude-drafts
gh release view v1.0.0 --web
gh release download v1.0.0 -p "*.tar.gz" -D ./dist
```

---

## Gists — `gh gist`

```bash
# ── Crear ──
gh gist create archivo.txt              # público
gh gist create archivo.txt --secret     # secreto
gh gist create src/*.py -d "Utilidad"   # múltiples archivos + descripción

# ── Listar / Ver / Editar ──
gh gist list --public --limit 50
gh gist view gist_id --web
gh gist view gist_id --files src/main.py
gh gist edit gist_id                    # editar
gh gist delete gist_id                  # eliminar
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
# ── Alias simples ──
gh alias set co "pr checkout"           # gh co 42 → gh pr checkout 42
gh alias set iv "issue view"            # gh iv 123 → gh issue view 123
gh alias set pc "pr create --fill"      # gh pc → gh pr create --fill
gh alias set prs "pr list --author @me"
gh alias set todos "issue list --assignee @me --label todo"

# ── Alias con argumentos (usando ! para shell) ──
gh alias set open "!gh repo view --web"
gh alias set find "!gh issue list --label \"$1\" | gh issue view \"$(fzf)\""

# ── Gestionar alias ──
gh alias list                            # listar todos
gh alias delete co                       # eliminar
```

---

## Flujos de trabajo comunes

```bash
# ── Feature → PR → Merge ──────────────────────────
git switch main && git pull --rebase
git switch -c feat/autenticacion
# trabajar, commitear...
git push -u origin feat/autenticacion
gh pr create --title "feat: ..." --body "Implementa..." --assignee @me --reviewer carlos
# mientras esperas review:
gh pr status
gh pr checks 42 --watch                  # CI en tiempo real
# cuando aprueben:
gh pr review 42 --approve
gh pr merge 42 --squash --delete-branch
git switch main && git pull --rebase

# ── Revisar PRs de otros ───────────────────────────
gh search prs --review-required=@me      # qué PRs necesitan review
gh pr checkout 42                        # descargar localmente
gh pr diff 42                            # revisar cambios
gh pr review 42 --approve --body "LGTM ✅"

# ── CI/CD con Actions ──────────────────────────────
gh run list --limit 5                    # estado del CI
gh pr checks 42                          # checks de un PR
gh run view 1234567890 --log-failed      # logs de paso fallido
gh run rerun 1234567890 --failed         # re-ejecutar solo lo fallido
gh pr merge 42 --auto --squash           # auto-merge cuando CI pase

# ── Publicar una release ───────────────────────────
git tag -a v2.0.0 -m "v2.0.0" && git push origin v2.0.0
gh release create v2.0.0 --title "v2.0.0" --notes "Cambios..." dist/*.tar.gz
gh release view v2.0.0                   # verificar
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

## Configuración avanzada

```bash
# ── Opciones del cliente ──
gh config list                           # ver todo
gh config set git_protocol ssh           # ssh | https
gh config set editor code                # editor para gh edit, issue create
gh config set browser firefox            # navegador para gh ... --web
gh config set pager delta                # pager para salidas largas

# ── Configuración por host (GitHub Enterprise) ──
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
