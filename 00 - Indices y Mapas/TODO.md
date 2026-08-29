---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-08-29
estado: en progreso
categoria: indice
prioridad: alta
---

# TODO — Plan de trabajo del vault

> Este archivo centraliza el estado de todo el proyecto: lo completado, lo pendiente, y el roadmap futuro.
> Última actualización: 2026-08-29 (v14 — expansión de 7 navegadores + nota nueva Konqueror)

---

## ✅ COMPLETADO

### 🚀 Fase 1 — Prioridad alta (10 notas)
| Completado | Nota | Categoría |
|---|---|---|
| ✅ | Pantalla en negro tras actualizar drivers | troubleshooting |
| ✅ | Disco lleno (No space left on device) | troubleshooting |
| ✅ | Teclado con layout incorrecto | troubleshooting |
| ✅ | Bluetooth no conecta | troubleshooting |
| ✅ | Resolución de pantalla y multi-monitor | troubleshooting |
| ✅ | Reloj desincronizado en dual boot | troubleshooting |
| ✅ | df y du (espacio en disco) | comando |
| ✅ | free (memoria RAM/swap) | comando |
| ✅ | uname (kernel/arquitectura) | comando |
| ✅ | date y timedatectl (fecha/hora) | comando |

### 📋 Fase 2 — Prioridad media (7 items)
| Completado | Nota | Cambio |
|---|---|---|
| ✅ | [[Namespaces (Linux)]] | Nota nueva (01 - Conceptos) |
| ✅ | [[Symlinks y Dotfiles]] | Expandida: anatomía de inodos, link count |
| ✅ | [[Locale y configuracion de idioma]] | Nota nueva (01 - Conceptos) |
| ✅ | [[NTP y chrony]] | Nota nueva (01 - Conceptos) |
| ✅ | [[Actualización entre versiones mayores]] | Nota nueva (02 - Instalacion) |
| ✅ | [[Ansible]] | Nota nueva (08 - Programas) |
| ✅ | [[Backups (borg restic duplicity rsync)]] | Expandida: automatización + systemd timers |

### 📎 Fase 3 — Prioridad baja (4 items)
| Completado | Nota | Categoría |
|---|---|---|
| ✅ | [[SSH no conecta]] | troubleshooting |
| ✅ | [[Docker permiso denegado]] | troubleshooting |
| ✅ | [[Fuentes rotas o faltantes (fontconfig)]] | troubleshooting |
| ✅ | [[Git hooks para el vault]] | automatizacion |

### 🏗️ Infraestructura del vault — Sesiones anteriores

| Completado | Cambio | Sesión |
|---|---|---|
| ✅ | 7 templates actualizados con nuevas secciones | 2026-07-23 |
| ✅ | Hashtags `#DE-WM` → `#entorno-escritorio` (28 notas) | 2026-07-23 |
| ✅ | README.md, CLAUDE.md, TODO.md, Dashboard.md actualizados | 2026-07-23 |
| ✅ | Git hooks creados y activados (`.githooks/`) | 2026-07-23 |
| ✅ | Repositorio Git inicializado (commit inicial) | 2026-07-24 |
| ✅ | Scripts de automatización (5) + cron semanal vault-stats | 2026-07-24 |
| ✅ | `check-frontmatter.sh` optimizado ~0.15s (de >30s a 0.15s) | 2026-07-24 |

### 📝 Expansión de notas — Sesión 2026-07-24

| Completado | Nota | Mejora |
|---|---|---|
| ✅ | [[top]] | Opciones con columna Ejemplo, 6 casos numerados, flags -d y -o |
| ✅ | [[ps]] | Opciones con columna Ejemplo, 10 casos numerados |
| ✅ | [[kill]] | Opciones con columna Ejemplo, 12 casos numerados, flag -0 |
| ✅ | [[Daemon]] | Señales para daemons, hardening systemd, logging con logrotate |
| ✅ | [[Busybox]] | ash vs bash, BusyBox init vs systemd, compilación desde fuente |
| ✅ | [[Ncurses]] | Terminfo, tput, ejemplo TUI completo con ventanas y colores |
| ✅ | [[Ubuntu]] | Netplan, Ubuntu Pro gratuito, cloud-init |
| ✅ | [[Debian]] | APT pinning, Debian packaging, evolución non-free-firmware |
| ✅ | [[CDE]] | Expandida de 40 a ~200 líneas (nota completa) |

### 🆕 Notas nuevas creadas — Sesión 2026-07-24

| Completado | Nota | Categoría | Contenido |
|---|---|---|---|
| ✅ | [[Regular Expressions]] | concepto | BRE/ERE/PCRE, lookaround, patrones prácticos, backtracking |
| ✅ | [[Vim comandos avanzados]] | comando | Macros, registros, quickfix, marks, plegados, vimdiff, Lua |
| ✅ | [[systemd unidades personalizadas]] | sistema | Service types, templates, timers, sockets, paths, drop-ins |

### 🗑️ Archivos eliminados — Sesión 2026-07-24

| Archivo | Razón |
|---|---|
| `DEs adicionales (Budgie Deepin ...).md` | Redundante (todos los DEs tienen nota individual) |
| `WMs adicionales (bspwm qtile ...).md` | Redundante (todos los WMs tienen nota individual) |

### 🔧 Automatización y frontmatter — Sesión 2026-07-24

| Completado | Cambio | Detalle |
|---|---|---|
| ✅ | `fecha_modificacion` añadido a **312 notas** | Script `add-modification-date.sh` creado |
| ✅ | 7 templates actualizados con `fecha_modificacion` | Campo añadido tras `fecha_creacion` |
| ✅ | CLAUDE.md actualizado | Nueva regla de frontmatter documentada |
| ✅ | Dashboard.md actualizado | Stats corregidas |
| ✅ | MoC - Linux.md corregido | Eliminadas entradas duplicadas y huérfanas |
| ✅ | `check-frontmatter.sh` optimizado a ~0.15s | De >30s con awk + single-pass |

### 🖥️ TUI tools — Sesión 2026-07-24 (ronda 1)

| Completado | Cambio | Detalle |
|---|---|---|
| ✅ | [[TUI tools]] creada | Nota comprehensive con 12 categorías de TUIs |
| ✅ | [[bat]] creada | cat moderno con syntax highlighting, integración Git |
| ✅ | [[lazygit]] creada | Git TUI interactivo: stage, commit, branch, merge, stash |
| ✅ | [[lazydocker]] creada | Docker TUI: contenedores, imágenes, logs, exec, Compose |
| ✅ | [[k9s]] creada | Kubernetes TUI: pods, deployments, services, logs, shell |
| ✅ | [[yazi]] creada | Gestor de archivos TUI en Rust |
| ✅ | [[zellij]] creada | Multiplexor de terminal moderno, layouts, plugins |
| ✅ | Sección instalación masiva (5 scripts bash) | essentials / full / all / containers / todo-en-uno |

### 🖥️ TUI tools — Sesión 2026-07-24 (ronda 2: faltantes)

| Completado | Cambio | Detalle |
|---|---|---|
| ✅ | [[dive]] creada | Explorador de capas Docker: análisis de eficiencia |
| ✅ | [[ctop]] creada | top-like para contenedores: CPU/RAM/IO/Red en vivo |
| ✅ | [[gitui]] creada | Git TUI en Rust: rápido, temas integrados |
| ✅ | [[tig]] creada | Visor de commits y log Git: blame, diff, stash |
| ✅ | [[trippy]] creada | traceroute + ping visual: gráficos históricos |
| ✅ | [[glow]] creada | Visor Markdown bonito: explorador TUI, 30+ temas |

### 🆕 Notas nuevas — Sesión 2026-07-25 (alta prioridad)

| Completado | Nota | Archivo | Contenido |
|---|---|---|---|
| ✅ | [[ripgrep]] | 07 - Comandos Esenciales | grep moderno en Rust, 10x más rápido, .gitignore-aware, ~170 líneas |
| ✅ | [[tree]] | 07 - Comandos Esenciales | mostrar árbol de directorios, profundidad, patrones, ~110 líneas |
| ✅ | [[procs]] | 07 - Comandos Esenciales | ps moderno con colores, árbol, filtros, temas, ~110 líneas |
| ✅ | [[doggo]] | 07 - Comandos Esenciales | dig moderno con colores, JSON, todos los tipos de registro, ~120 líneas |
| ✅ | [[bandwhich]] | 08 - Programas y Herramientas | monitor de ancho de banda TUI por proceso/IP, ~120 líneas |
| ✅ | [[fx]] | 08 - Programas y Herramientas | visor JSON interactivo TUI, path del nodo, búsqueda, ~120 líneas |

### 📝 Expansión de notas — Sesión 2026-07-25

| Completado | Nota | Antes | Después | Mejoras clave |
|---|---|---|---|---|
| ✅ | [[ctop]] | ~60 líneas | **131** | Comparativa con lazydocker, troubleshooting completo |
| ✅ | [[httpie]] | ~40 líneas | **153** | Sintaxis completa, pipes con jq, vs curl detallado |
| ✅ | [[fd-find]] | ~40 líneas | **157** | 20+ opciones, integración fzf, comparativa find/locate/fzf |
| ✅ | [[fzf]] | ~50 líneas | **189** | Key bindings, config avanzada (FZF_DEFAULT_OPTS), temas |
| ✅ | [[nala]] | ~40 líneas | **129** | nala fetch mirrors, historial transacciones, vs apt |

### 🔗 Enlaces externos — Sesión 2026-07-25

| Completado | Notas | Enlaces añadidos |
|---|---|---|
| ✅ | Fedora, CentOS, Rocky, EndeavourOS, Manjaro, Arch | Sitios oficiales, Wikipedia, Arch Wiki, foros, GitHub |
| ✅ | jq, Nextcloud, Podman, Motif | Sitios oficiales, GitHub, Wikipedia, documentación |

### ✅ Alta prioridad completada — Sesión 2026-07-25

| Completado | Nota | Categoría | Contenido |
|---|---|---|---|
| ✅ | [[Entorno de desarrollo Linux]] | 08 - Programas | Toolchain completo por lenguaje, contenedores para desarrollo |
| ✅ | [[Contenedores orquestación]] | 01 - Conceptos | Docker Compose, Swarm, K8s, árbol de decisión |
| ✅ | [[Optimización de rendimiento]] | 01 - Conceptos | Tuning de kernel, sysctl, límites de recursos, perfiles por uso |

### 🗒️ Nota nueva — Sesión 2026-07-25

| Completado | Nota | Archivo | Contenido |
|---|---|---|---|
| ✅ | [[xh]] | 08 - Programas y Herramientas | Cliente HTTP Rust, binario estático, sintaxis httpie-compatible, flag --curl |

### 🐛 Bugs corregidos — Sesión 2026-07-25

| Completado | Fix | Archivo |
|---|---|---|
| ✅ | `[[xh]]` → texto plano (xh sin nota propia) | httpie.md |
| ✅ | `prioridad: media` → `baja` (consistencia con otras TUI) | fd-find.md |
| ✅ | Troubleshooting duplicado fusionado (`command not found` x2) | nala.md |
| ✅ | Orden de secciones invertido (Enlaces externos antes de Ver también) | jq.md |

---

### 🗒️ Sesión 2026-07-26 — Fragmentación total + borradores + expansiones + fixes

#### 🧩 Fragmentación final (8 notas agrupadas → ~20 individuales)

| Grupo | Notas nuevas | Original → Índice |
|---|---|---|
| **PostgreSQL y MySQL** | [[PostgreSQL]], [[MySQL]] | [[PostgreSQL y MySQL]] → índice |
| **Vim Neovim** | [[Vim]], [[Neovim]] | [[Vim Neovim]] → índice |
| **Logging del sistema** | [[journald]], [[rsyslog]], [[logrotate]] | [[Logging del sistema]] → índice |
| **Bootloaders** | [[GRUB]], [[Limine]] | [[Bootloaders]] → índice |
| **SELinux y AppArmor** | [[SELinux]], [[AppArmor]] | [[SELinux y AppArmor]] → índice |
| **Gestión usuarios avanzada** | [[PAM]], [[chage]], [[chsh]], [[skel]] | [[Gestión de usuarios avanzada]] → índice |
| **Cifrado** | [[LUKS]], [[GPG]] | [[Cifrado]] → índice |
| **Gestores de Paquetes** | [[dnf]], [[Flatpak]], [[Snap]] | [[Gestores de Paquetes]] → índice |

#### ✅ Borradores completados (10 → resuelto)

| Nota | Mejoras añadidas |
|---|---|
| [[AbiWord]] | Ejemplos de uso, tabla de formatos, ventajas/desventajas |
| [[Antigravity]] | Atajos, ventajas/desventajas, más características |
| [[Calligra Suite]] | Tabla de componentes, ejemplos |
| [[Double Commander]] | Atajos F-key, plugins, conexiones de red |
| [[Gnumeric]] | Importación CSV, tabla de formatos, rendimiento |
| [[Grafana]] | Datasource config (manual + provisioning), sistema de alertas |
| [[PCManFM]] | Atajos, gestión de escritorio, montaje |
| [[SpaceFM]] | Vista dividida, plugins, gestión sin GVfs |
| [[st]] | Tabla de parches, wikilink [[suckless]] reparado |
| [[wezterm]] | Atajos completo, config multi-font, workspaces |

#### ✨ Nota nueva: [[suckless]]

Creada para reparar el wikilink roto en [[st]] (referenciaba a [[suckless]] inexistente).

#### 🔧 Fix: GNOME Web rename

`GNOME Web.md` → **`GNOME Web (Epiphany).md`** para que coincida con el wikilink `[[GNOME Web (Epiphany)]]` en MoC y Navegadores Web.md.

#### 📈 Expansión de notas fragmentadas (5)

| Nota | Antes | Después | Secciones nuevas |
|---|---|---|---|
| [[PostgreSQL]] | ~170 | **~300** | pg_hba.conf, Streaming Replication, PgBouncer, Autovacuum tuning, Locks troubleshooting, Docker |
| [[Neovim]] | ~130 | **~310** | Características exclusivas, LSP Mason+lspconfig, blink.cmp, Telescope keymaps, DAP, init.lua modular, troubleshooting |
| [[GRUB]] | ~100 | **~230** | Parámetros kernel avanzados, contraseña PBKDF2, entradas custom /etc/grub.d/, LUKS2 cryptodisk, shell avanzado, troubleshooting |
| [[Flatpak]] | ~70 | **~190** | Remotes, permisos detallados + Flatseal, runtimes, xdg-desktop-portal, flatpak-builder, troubleshooting |
| [[SELinux]] | ~110 | **~240** | semanage fcontext/port/login, booleanos por servidor, audit2allow workflow, udica contenedores, troubleshooting scenarios |

#### 🐛 Fix: vault-stats.sh (discrepancias de conteo)

| Bug | Causa | Fix |
|---|---|---|
| Estados off by 1 | `grep -rl "estado:"` sin ancla `^` → CLAUDE.md y Log.md como falsos positivos | `^estado:` anclado a inicio de línea |
| Categorías off by 5 | `grep -v "./Templates/"` no filtraba por `-h` (no-op) | `--exclude-dir=Templates` |
| Script moría sin output | `set -eo pipefail` con grep que devuelve exit 1 (sin matches) | `|| true` en pipelines de grep |
| Dashboard stats desactualizadas | 361 estático vs 516 reales | Tabla estática actualizada con vault-stats.sh |

#### ✅ Frontmatter sweep

Verificadas 516 notas: 100% de valores válidos en estado/categoría/prioridad. Sin inconsistencias.

---

## 🎯 PRÓXIMOS PASOS

### 🟡 Prioridad media

| Tarea | Detalle | Estado |
|---|---|---|
| ~~Verificar wikilinks rotos~~ | `find-orphans.sh` confirma solo README.md intencional | ✅ completado |
| ~~Verificar notas con `fecha_modificacion` antigua (>30 días)~~ | Identificar candidatas a revisión/expansión — 0 notas encontradas (vault empezó el 18 jul) | ✅ completado |
| Automatizar `add-modification-date.sh` | Ejecutar periódicamente para mantener fechas al día | ⚪ pendiente |
| ~~Expandir resto de fragmentadas~~ | MySQL, GPG, rsyslog, logrotate, LUKS, chage, chsh, skel — las 13 ya completas (AppArmor, Snap, Limine, PAM, journald ya estaban expandidas) | ✅ completado |

### 🟢 Prioridad baja — Mejoras continuas

| Tarea | Detalle | Estado |
|---|---|---|
| ~~Crea nota xh.md~~ | Alternativa Rust a httpie (resolver wikilink roto) | ✅ ya creada |
| Unificar bloques de código sueltos | Fedora, NixOS, GitHub CLI, FHS, DNS, Sistemas de Archivos, Permisos | ✅ completado |
| Expandir Motif.md | ~50 → ~100 líneas | ✅ completado |
| Descargar logos restantes | Fedora, Arch, Mint, openSUSE, Manjaro, NixOS, Alpine, etc. (~12) | ⚪ pendiente |
| Descargar capturas DE/WM | GNOME, KDE, XFCE, i3, Hyprland, etc. (7 capturas) | ⚪ pendiente |
| Descargar diagramas técnicos | Kernel, FHS, boot process (3 diagramas) | ⚪ pendiente |

---

### 📝 Expansión de notas — Sesión 2026-07-25 (v3)

| Completado | Nota | Antes | Después | Mejoras clave |
|---|---|---|---|---|
| ✅ | [[Motif]] | ~50 | **~110** | Historia CDE, Motif 2.1 vs 3.x, instalación, bindings Python/Rust |
| ✅ | [[Alpine Linux]] | ~92 | **~190** | apk avanzado, OpenRC, musl vs glibc, Docker/container, multi-stage |
| ✅ | [[Linux Lite]] | ~82 | **~165** | 6 herramientas propias, tabla equivalencias Windows, comparativa Zorin/Mint/LXLE |
| ✅ | [[openSUSE]] | ~101 | **~175** | YaST módulos, Zypper avanzado, Tumbleweed vs Leap, OBS/osc, Snapper+Btrfs, Aeon/Kalpa |
| ✅ | [[Versiones de Debian]] | ~103 | **~195** | Timeline releases, LTS/ELTS, freeze process, Toy Story naming, stable/testing/unstable |
| ✅ | [[Peppermint OS]] | ~61 | **~115** | SSBs/Ice framework, requisitos HW, Pep Tools, edición Loaded, comparativa alternativas |

### 🆕 Notas nuevas — Sesión 2026-07-25 (v3)

| Completado | Nota | Categoría | Contenido |
|---|---|---|---|
| ✅ | [[GTK]] | programa | Historia, GTK3 vs GTK4, instalación, hello world C, comparativa con Qt, troubleshooting |
| ✅ | [[Qt]] | programa | Historia, Qt5 vs Qt6, instalación, hello world C++/CMake, MOC, comparativa con GTK, troubleshooting |

### 🔧 Unificación de bloques de código — Sesión 2026-07-25 (v3)

| Completado | Nota | Bloques originales | Bloques tras unificar |
|---|---|---|---|
| ✅ | [[Fedora]] | 5 separados (dnf, rpm, RPM Fusion, COPR, upgrade) | 1 con comentarios de sección |
| ✅ | [[NixOS]] | 5 pares consecutivos (nix+bash) | 4 unificados con comentarios `#` |
| ✅ | [[GitHub CLI (gh)]] | ~27 minibloques | ~10 por tema (PRs, Issues, Actions, Releases...) |
| ✅ | [[Sistemas de Archivos]] | ~12 bloques | ~5 (ext4, Btrfs, XFS, ZFS, crear+fsck+UUID) |
| ✅ | [[Permisos y Propietarios]] | ~15 bloques | ~5 (sticky/SUID/SGID, ACLs, casos prácticos) |
| ✅ | [[FHS]] | ~10 bloques | ~5 (etc, var, usr, proc+sys, tmp+run+mnt+opt) |
| ✅ | [[DNS y BIND]] | ~8 bloques | ~4 (host+nslookup, hosts+resolv.conf, resolved+NSSwitch, verificación) |

---

## 📊 ESTADÍSTICAS DEL VAULT (vault-stats.sh 2026-08-29)

| Métrica | Valor |
|---|---|
| **Notas totales** | **517** (+ 7 templates) |
| **Estado resuelto** | 509 |
| **Estado en progreso** | 5 (TODO, MoC, Dashboard, Log, Prompts de Trabajo) |
| **Estado borrador** | 0 (todos los drafts completados) |
| **Prioridad alta** | 215 |
| **Prioridad media** | 162 |
| **Prioridad baja** | 133 |

### Por categoría (real)

| Categoría | Notas | Categoría | Notas |
|---|---|---|---|
| **Programa** | 178 | **Comando** | 109 |
| **Concepto** | 47 | **Distribución** | 45 |
| **Sistema** | 47 | **Entorno / WM** | 32 |
| **Troubleshooting** | 20 | **Índice** | 13 |
| **Instalación** | 13 | **Terminal** | 5 |
| **Automatización** | 4 | **Log** | 1 |

### Por carpeta (real)

| Carpeta | Notas | Carpeta | Notas |
|---|---|---|---|
| 00 - Indices y Mapas | 13 | 01 - Conceptos Fundamentales | 46 |
| 02 - Instalacion y Configuracion | 13 | 03 - Estructura del Sistema | 47 |
| 04 - Entornos de Escritorio | 17 | 05 - Gestores de Ventanas | 15 |
| 06 - La Terminal | 6 | 07 - Comandos Esenciales | 109 |
| 08 - Programas y Herramientas | 178 | 09 - Solucion de Problemas | 20 |
| 10 - Automatizacion y Scripts | 5 | 11 - Distribuciones | 45 |

---

## 📝 NOTAS

- Las plantillas se actualizaron el 2026-07-23 y se volvieron a actualizar el 2026-07-24 con `fecha_modificacion`.
- Las notas existentes NO se migraron automáticamente a las nuevas plantillas — se expandirán progresivamente según prioridad.
- **Log.md** en `10 - Automatizacion y Scripts/` tiene el registro histórico detallado de todas las sesiones.
- Sesión 2026-07-24: 14 notas TUI (1 guía + 13 específicas) + 3 notas planificadas (Regex, Vim, systemd).
- Sesión 2026-07-25 (v2): 6 notas alta prioridad, 5 expandidas, enlaces externos, +3 alta prioridad completada, +xh.md creada, TODO.md actualizado con stats correctas (vault-stats.sh)
- Sesión 2026-07-25 (v3): 6 distros expandidas (Motif, Alpine, Linux Lite, openSUSE, Versiones Debian, Peppermint OS), 2 notas nuevas (GTK, Qt), 7 notas con bloques de código unificados (Fedora, NixOS, gh CLI, FHS, DNS, Sistemas Archivos, Permisos), MoC actualizado
- Sesión 2026-07-26 (v10): Fragmentación total de 8 notas agrupadas (~20 individuales), 10 drafts → resuelto, 5 notas expandidas (PostgreSQL, Neovim, GRUB, Flatpak, SELinux), fix vault-stats.sh (^estado: + --exclude-dir + || true), Dashboard stats actualizadas, frontmatter sweep limpio
- Sesión 2026-07-27 (v11): 8 notas fragmentadas expandidas (MySQL, GPG, rsyslog, logrotate, LUKS, chage, chsh, skel), verificación notas antiguas (0 >30 días), Dashboard y TODO actualizados con stats reales (516 notas, 509 resuelto, 215 alta, 162 media, 133 baja)
- Sesión 2026-07-27 (v12): 3 scripts optimizados (vault-stats ~68x, find-orphans ~5x, add-modification-date ~2x), [[suckless]] enlazada al MoC (0 huérfanas), README.md y Scripts del Vault.md actualizados con docs de rendimiento
- Sesión 2026-08-29 (v12.1): creación de AGENTS.md, enlazada al MoC, exclusiones en pre-commit/pre-push, stats corregidas en README/Dashboard/TODO (517 notas, 46 en 01)
- Sesión 2026-08-29 (v13): expansión de 6 notas de comando cortas (yes, nohup, timeout, seq, at, sleep) hacia el esquema de plantilla; fragmentación ya resuelta en sesión previa
- Sesión 2026-08-29 (v14): expansión de 7 navegadores (Falkon, LibreWolf, Vivaldi, Ungoogled Chromium, Brave, Chromium, GNOME Web) + nota nueva [[Konqueror]] (518 notas)

---

#indice #todo
