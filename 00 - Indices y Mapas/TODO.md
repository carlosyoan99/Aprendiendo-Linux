---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-09-02
estado: en progreso
categoria: indice
prioridad: alta
---

# TODO — Plan de trabajo del vault

> Este archivo centraliza el estado de todo el proyecto: lo completado, lo pendiente, y el roadmap futuro.
> Última actualización: 2026-09-02 (v45: 13 notas nuevas de distros/DE/WM)

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

### 🟢 EXPANSIÓN DE NOTAS CORTAS POR LOTES (plan v33+)

Plan para expandir las notas <100 líneas imprescindibles. Cada lote = una sesión con su propio commit `expand:`. Los hubs/índices (Cifrado, Bootloaders, SELinux y AppArmor, Logging, Gestión usuarios, PostgresQL y MySQL, Vim Neovim, nohup-timeout-at, df y du, date y timedatectl, sed y awk, Navegadores Web, Editores de Texto, Emuladores de Terminal, Utilidades Base, Diagnóstico de hardware, Monitorización, Multimedia, Lenguajes y gestores, Atajos de teclado) NO se expanden — sus hijas ya existen desarrolladas (decisión v22 de evitar duplicación).

**✅ Lote 1 — Programas de uso diario (08), completado v34**:
| Nota | Antes | Después |
|---|---|---|
| [[obsidian]] | ~50 | ~100 |
| [[mise]] | ~52 | ~100 |
| [[google-chrome]] | ~54 | ~100 |
| [[snapper]] | ~54 | ~100 |
| [[Helix]] | ~57 | ~100 |
| [[Alacritty]] | ~63 | ~100 |
| [[Kitty]] | ~69 | ~100 |
| [[Foot]] | ~62 | ~100 |
| [[vlc]] | ~78 | ~100 |
| [[AbiWord]] | ~77 | ~100 |
| [[Dolphin]] | ~61 | ~100 |
| [[Double Commander]] | ~76 | ~100 |
| [[gstreamer]] | ~75 | ~100 |

> Los 5 marcados ✓ del plan original ([[PCManFM]], [[handbrake]], [[duplicity]], [[lshw]], [[SpaceFM]]) quedaron cubiertos por el Lote 2 de programas 08 antiguas (v32). "Ethernet" ya no existe como nota.

**✅ Lote 2 — Programas 08 antiguas (completado v32)**:
| Nota | Antes | Después |
|---|---|---|
| [[GNUstep]] | ~100 | ~130 |
| [[SONiC]] | ~110 | ~140 |
| [[lshw]] | ~55 | ~130 |
| [[PCManFM]] | ~110 | ~130 |
| [[SpaceFM]] | ~110 | ~130 |
| [[handbrake]] | ~80 | ~130 |
| [[duplicity]] | ~70 | ~130 |
| [[ethtool]] | nueva | ~130 |

**✅ Lote 3 — Distribuciones 11 (completado v32)**:
| Nota | Antes | Después |
|---|---|---|
| [[Zentyal]] | ~59 | ~130 |
| [[Xero Linux]] | ~62 | ~130 |
| [[Garuda Linux]] | ~66 | ~140 |
| [[Vanilla OS]] | ~73 | ~130 |
| [[LXLE Linux]] | ~74 | ~130 |
| [[Drauger OS]] | ~76 | ~130 |
| [[EU OS]] | ~76 | ~130 |
| [[Lubuntu]] | ~88 | ~130 |
| [[HoloISO]] | ~89 | ~130 |
| [[EndeavourOS]] | ~93 | ~130 |
| [[Clear Linux]] | ~94 | ~130 |

**✅ Lote 2 — Comandos 07 (completado v33)**:
| Nota | Antes | Después |
|---|---|---|
| [[du]] | ~67 | ~120 |
| [[md5sum]] | ~74 | ~120 |
| [[history]] | ~75 | ~120 |
| [[date]] | ~77 | ~120 |
| [[sed]] | ~77 | ~120 |
| [[zip]] | ~84 | ~120 |
| [[chmod]] | ~87 | ~120 |

**✅ Comandos 07 restantes (completado v34)**:
| Nota | Antes | Después |
|---|---|---|
| [[nc]] | ~99 | ~120 |
| [[tar]] | ~91 | ~120 |
| [[expr]] | ~92 | ~120 |
| [[yes]] | ~97 | ~120 |
| [[paste]] | ~81 | ~120 |
| [[nl]] | ~84 | ~120 |
| [[comm]] | ~89 | ~120 |

**✅ Lote 5 — Programas 08 cortas (completado v42)**:
| Nota | Antes | Después |
|---|---|---|
| [[kew]] | 63 | 120 |
| [[Antigravity]] | 65 | 110 |
| [[Gem]] | 79 | 109 |
| [[Gnumeric]] | 81 | 120 |
| [[google-chrome]] | 82 | 102 |
| [[Proton]] | 82 | 112 |
| [[snapper]] | 83 | 100 |
| [[Calligra Suite]] | 83 | 118 |
| [[FreeOffice]] | 83 | 107 |
| [[st]] | 83 | 140 |

### 🟡 Prioridad media

| Tarea | Detalle | Estado |
|---|---|---|
| ~~Verificar wikilinks rotos~~ | `find-orphans.sh` confirma solo README.md intencional | ✅ completado |
| ~~Verificar notas con `fecha_modificacion` antigua (>30 días)~~ | Identificar candidatas a revisión/expansión — 348 notas con fecha 2026-07-25 | ✅ completado |
| ~~Automatizar `add-modification-date.sh`~~ | Ejecutar periódicamente para mantener fechas al día — automatizado en el hook pre-commit (v37): sincroniza `fecha_modificacion` de las notas staged a la fecha actual | ✅ completado |
| ~~Expandir resto de fragmentadas~~ | MySQL, GPG, rsyslog, logrotate, LUKS, chage, chsh, skel — las 13 ya completas (AppArmor, Snap, Limine, PAM, journald ya estaban expandidas) | ✅ completado |
| ~~Expandir notas de 08 antiguas (Lote 2)~~ | 8 notas de 08 antiguas — completadas en v32: GNUstep, SONiC, lshw, PCManFM, SpaceFM, handbrake, duplicity, ethtool | ✅ completado |

### 🟢 Prioridad baja — Mejoras continuas

| Tarea | Detalle | Estado |
|---|---|---|
| ~~Crea nota xh.md~~ | Alternativa Rust a httpie (resolver wikilink roto) | ✅ ya creada |
| Unificar bloques de código sueltos | Fedora, NixOS, GitHub CLI, FHS, DNS, Sistemas de Archivos, Permisos | ✅ completado |
| Expandir Motif.md | ~50 → ~100 líneas | ✅ completado |

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

### 🧠 Integración y personalización al sistema real — Sesión 2026-08-30 (v19)

| Completado | Nota | Cambio |
|---|---|---|
| ✅ | [[Niri]] | Sección "Mi configuración real (CachyOS + Noctalia)": cfg/, keybinds reales, gaming-mode |
| ✅ | [[CachyOS]] | Sección "Mi sistema CachyOS": hardware, kernel, scripts propios |
| ✅ | [[Desktop Shells (Noctalia Caelestia)]] | Sección "Noctalia en mi sistema (realidad 2026)" |
| ✅ | [[Fish]] | Sección "Mi config.fish (real)" |
| ✅ | [[kew]] · [[snapper]] · [[obsidian]] · [[meld]] | Programas nuevos (08) |
| ✅ | [[pavucontrol]] · [[gparted]] · [[octopi]] | Programas nuevos (08) |
| ✅ | [[google-chrome]] · [[telegram-desktop]] · [[glances]] | Programas nuevos (08) |
| ✅ | [[Mi equipo (hardware CachyOS-Laptop)]] | Nota nueva (03 - Sistema) |
| ✅ | [[Tema Material You en el escritorio]] | Nota nueva (04 - Escritorio) |
| ✅ | Scripts propios, watchers systemd, OCR/remind | Notas nuevas (10 - Automatización) |

### 🆕 Notas de alta prioridad — Sesión 2026-08-30 (v20)

| Completado | Nota | Categoría | Contenido |
|---|---|---|---|
| ✅ | [[systemctl]] | comando | Gestión de servicios/units systemd: start/stop/restart/enable/mask, targets, list-units, systemd-analyze, `--user` |
| ✅ | [[fstab (montaje de discos)]] | sistema | Montaje persistente: 6 columnas, UUID vs /dev/sdX, opciones (nofail/noatime/ro/uid...), NFS/CIFS, automount, troubleshooting modo emergencia |

### ✏️ Expansión de notas de programa — Sesión 2026-08-30 (v21)

| Completado | Nota | Antes | Después | Mejoras clave |
|---|---|---|---|---|
| ✅ | [[delta]] | ~40 | **~130** | Qué es, multi-distro, config avanzada (side-by-side, syntax-theme), comparativa con diff-so-fancy, troubleshooting |
| ✅ | [[pavucontrol]] | ~44 | **~115** | Qué es, multi-distro, comparativa con pw-recording/GNOME Settings, troubleshooting, notas personales |
| ✅ | [[telegram-desktop]] | ~45 | **~130** | Qué es, multi-distro + Flatpak/Snap, atajos, múltiples cuentas, temas, comparativa con WhatsApp/Signal, troubleshooting |
| ✅ | [[gparted]] | ~46 | **~125** | Qué es, multi-distro, uso avanzado (redimensionar, dual boot, copiar), comparativa con parted/fdisk, troubleshooting |
| ✅ | [[octopi]] | ~46 | **~120** | Qué es, disponibilidad (solo Arch), config notificador/AUR, comparativa con pamac/yay, troubleshooting |
| ✅ | [[glances]] | ~47 | **~140** | Qué es, multi-distro + pip extras, servidor web, config umbrales, comparativa con btop/htop, troubleshooting |
| ✅ | [[meld]] | ~47 | **~135** | Qué es, carpetas, atajos, Git difftool/mergetool, comparativa con vimdiff/delta, troubleshooting |
| ✅ | [[binutils]] | ~52 | **~150** | Qué es, multi-distro, casos de uso (seguridad/desarrollo/admin), comparativa LLVM, troubleshooting |

---

## 📊 ESTADÍSTICAS DEL VAULT (vault-stats.sh 2026-09-02)

| Métrica | Valor |
|---|---|
| **Notas totales** | **580** (+ 7 templates) |
| **Estado resuelto** | 557 |
| **Estado en progreso** | 6 (TODO, MoC, Dashboard, Log.md, Log-2026.md, Prompts de Trabajo) |
| **Estado borrador** | 13 (las 13 notas nuevas de v45, pendientes de promoción a "resuelto") |
| **Prioridad alta** | 216 |
| **Prioridad media** | 205 |
| **Prioridad baja** | 150 |

### Por categoría (real)

| Categoría | Notas | Categoría | Notas |
|---|---|---|---|
| **Programa** | 206 | **Comando** | 122 |
| **Concepto** | 47 | **Distribución** | 54 |
| **Sistema** | 49 | **Entorno / WM** | 38 |
| **Troubleshooting** | 19 | **Índice** | 13 |
| **Instalación** | 13 | **Terminal** | 5 |
| **Automatización** | 8 | **Log** | 2 |

### Por carpeta (real)

| Carpeta | Notas | Carpeta | Notas |
|---|---|---|---|
| 00 - Indices y Mapas | 13 | 01 - Conceptos Fundamentales | 46 |
| 02 - Instalacion y Configuracion | 13 | 03 - Estructura del Sistema | 49 |
| 04 - Entornos de Escritorio | 19 | 05 - Gestores de Ventanas | 19 |
| 06 - La Terminal | 6 | 07 - Comandos Esenciales | 122 |
| 08 - Programas y Herramientas | 206 | 09 - Solucion de Problemas | 19 |
| 10 - Automatizacion y Scripts | 10 | 11 - Distribuciones | 54 |

---

## 📝 NOTAS

- Las plantillas se actualizaron el 2026-07-23 y se volvieron a actualizar el 2026-07-24 con `fecha_modificacion`.
- Las notas existentes NO se migraron automáticamente a las nuevas plantillas — se expandirán progresivamente según prioridad.
- **Log.md** en `10 - Automatizacion y Scripts/` tiene el registro compacto (una fila por sesión, rotación por año). El historial detallado vive en `Log-2026.md` (archivo del año).
- Sesión 2026-07-24: 14 notas TUI (1 guía + 13 específicas) + 3 notas planificadas (Regex, Vim, systemd).
- Sesión 2026-07-25 (v2): 6 notas alta prioridad, 5 expandidas, enlaces externos, +3 alta prioridad completada, +xh.md creada, TODO.md actualizado con stats correctas (vault-stats.sh)
- Sesión 2026-07-25 (v3): 6 distros expandidas (Motif, Alpine, Linux Lite, openSUSE, Versiones Debian, Peppermint OS), 2 notas nuevas (GTK, Qt), 7 notas con bloques de código unificados (Fedora, NixOS, gh CLI, FHS, DNS, Sistemas Archivos, Permisos), MoC actualizado
- Sesión 2026-07-26 (v10): Fragmentación total de 8 notas agrupadas (~20 individuales), 10 drafts → resuelto, 5 notas expandidas (PostgreSQL, Neovim, GRUB, Flatpak, SELinux), fix vault-stats.sh (^estado: + --exclude-dir + || true), Dashboard stats actualizadas, frontmatter sweep limpio
- Sesión 2026-07-27 (v11): 8 notas fragmentadas expandidas (MySQL, GPG, rsyslog, logrotate, LUKS, chage, chsh, skel), verificación notas antiguas (0 >30 días), Dashboard y TODO actualizados con stats reales (516 notas, 509 resuelto, 215 alta, 162 media, 133 baja)
- Sesión 2026-07-27 (v12): 3 scripts optimizados (vault-stats ~68x, find-orphans ~5x, add-modification-date ~2x), [[suckless]] enlazada al MoC (0 huérfanas), README.md y Scripts del Vault.md actualizados con docs de rendimiento
- Sesión 2026-08-29 (v12.1): creación de AGENTS.md, enlazada al MoC, exclusiones en pre-commit/pre-push, stats corregidas en README/Dashboard/TODO (517 notas, 46 en 01)
- Sesión 2026-08-29 (v13): expansión de 6 notas de comando cortas (yes, nohup, timeout, seq, at, sleep) hacia el esquema de plantilla; fragmentación ya resuelta en sesión previa
- Sesión 2026-08-29 (v14): expansión de 7 navegadores (Falkon, LibreWolf, Vivaldi, Ungoogled Chromium, Brave, Chromium, GNOME Web) + nota nueva [[Konqueror]] (518 notas)
- Sesión 2026-08-29 (v15): vault en modo adaptive (sigue el tema del SO) + guía de Noctalia expandida en [[Desktop Shells (Noctalia Caelestia)]]
- Sesión 2026-08-29 (v16): expansión de 6 notas de programa (Gedit, Geany, Kate, Xfce Terminal, Konsole, Suite de Oficina) hacia el esquema de plantilla; stats actualizadas (518 notas)
- Sesión 2026-08-29 (v17): expansión de 7 notas de programa (FreeOffice, OnlyOffice, WPS Office, Zed, Lapce, GNOME Terminal, Nemo)
- Sesión 2026-08-29 (v18): expansión de 17 notas (gestores de archivos: Nautilus/Thunar/nnn/Gestores de Archivos; comandos CLI: df, df y du, touch, netstat, nmcli; comandos combinados: date y timedatectl, sed y awk, seq yes sleep, Touch y History; terminal/DE/WM: Nushell, Wayfire, COSMIC, CutefishOS) + **fix del hook pre-push** (bucle lento → `comm`, elimina colgadas y falsos positivos intermitentes)
- Sesión 2026-08-30 (v19): **integración y personalización al sistema real** — 4 notas núcleo personalizadas (Niri, CachyOS, Noctalia, Fish), +16 notas nuevas (10 programas: kew/snapper/obsidian/meld/pavucontrol/gparted/octopi/google-chrome/telegram-desktop/glances; scripts niri-gov/niri-ram/gaming; watchers systemd; OCR/remind; hardware Mi equipo; Tema Material You), MoC y Log actualizados (534 notas)
- Sesión 2026-08-30 (v20): **2 notas de alta prioridad** — [[systemctl]] (07, comando) y [[fstab (montaje de discos)]] (03, sistema); MoC, Log.md y stats actualizadas (536 notas)
- Sesión 2026-08-30 (v21): **expansión de 8 notas de programa cortas** — delta/pavucontrol/telegram-desktop/gparted/octopi/glances/meld/binutils (40-52 → 115-150 líneas); secciones añadidas: qué es, instalación multi-distro, comparativa, troubleshooting; Log.md y TODO actualizados
- Sesión 2026-08-30 (v22): **expansión de [[Gestores de Paquetes]]** (hub alta prioridad, 67 → 135 líneas) — capa alto/bajo nivel, tabla de equivalentes apt/dnf/pacman, gestión de repositorios, troubleshooting rápido; Log.md actualizado. Hallazgo de curado: las demás hubs de alta prioridad (Bootloaders, Gestión de usuarios, Cifrado, SELinux/AppArmor, Logging) tienen hijas ya muy desarrolladas → no se expanden para evitar duplicación
- Sesión 2026-08-30 (v23): **expansión de 5 notas de concepto y troubleshooting cortas** — [[Impresora no funciona]] (72→140), [[RTAI]] (71→120), [[Int 80h]] (73→115), [[Exec Shield]] (70→105), [[GEM]] (76→110); secciones añadidas: tablas comparativas, evolución histórica, comandos de verificación, troubleshooting rápido
- Sesión 2026-08-30 (v24): **8 notas nuevas de programa** — [[rclone]] (cloud sync 70+ backends), [[eza]] (ls moderno), [[dust]] (du con barras), [[zoxide]] (cd inteligente), [[starship]] (prompt Rust), [[hexyl]] (hex viewer), [[sd]] (sed moderno), [[yt-dlp]] (descargador vídeos); MoC actualizado
- Sesión 2026-08-30 (v25): **5 notas nuevas de accesos rápidos por defecto** — [[Atajos de teclado - Firefox]], [[Atajos de teclado - Editores Kate y Gedit]], [[Atajos de teclado - VSCode]], [[Atajos de teclado - GNOME Terminal y Kitty]], [[Atajos de teclado - Nautilus Thunar Dolphin]]; 'Ver también' añadido en Firefox/Kate/Gedit/Editores de código/GNOME Terminal/Kitty/Nautilus/Thunar/Dolphin, MoC actualizado (549 notas)
- Sesión 2026-08-30 (v26): **expansión de 3 notas de terminal/monitores** — [[Shells (bash zsh fish)]] (132→175), [[screen]] (134→185), [[htop btop]] (141→185); config examples por shell, troubleshooting, splits/logging/screen, columnas batch/atop/glances
- Sesión 2026-08-30 (v27): **correcciones de auditoría** — 8 textos con caracteres chinos corruptos corregidos (Arch Linux, macOS, MS-DOS, Tmpfs/ramfs, nethogs, mise, gdb, delta); duplicados [[gdb]]/[[strace]] resueltos (conservada la de 07, borradas las de 08); huérfana/wikilink roto resuelto renombrando youtube-dl.md → [[yt-dlp]]. Validado: 0 wikilinks rotos, sin CJK restantes
- Sesión 2026-08-31 (v28): **expansión de 12 notas de programa 08 antiguas** — Podman/Linux Virtual Server/Heartbeat/btop/GNOME VFS/Open-Xchange/atuin/duf/jq/hyperfine/bmon/lf (51-86 → ~130 líneas cada una); todas tenían `fecha_modificacion: 2026-07-25` (~37 días). Secciones añadidas: instalación multi-distro, uso avanzado, configuración, comparativa con alternativas, troubleshooting; Log.md actualizado
- Sesión 2026-08-30 (v29): **correcciones de errores de alta prioridad (auditoría oleada 2026-07-25)** — 8 errores factuales corregidos (kill, stat, sha256sum, Coreutils y util-linux, Linux en Moviles, Daemon, Hyprland, NVIDIA no detecta); 4 textos corruptos/CJK (bmon, duf, btop, trippy); wikilink roto [[yq]] resuelto en jq; duplicado [[Actualización rota]] eliminado (redirigido a [[Paquete roto]] vía MoC). Validado: sin CJK, 0 wikilinks rotos
- Sesión 2026-08-30 (v30): **correcciones de errores de prioridad media y baja (auditoría oleada 2026-07-25)** — estructura duplicada limpiada (Sugar, Trinity: `## Notas personales` doble; Fedora: H2 vacío; spectrwm: enlace repetido en Ver también); títulos `#` alineados al filename en los 2 problemáticos ([[Proceso de Arranque (GRUB initramfs kernel params)]], [[Cheat Sheet - Comandos Esenciales]]). Validado en las 6 notas tocadas
- Sesión 2026-08-31 (v31): **AGENTS.md actualizado** — añadida sección "Commit flow (commit per phase)": commitear al terminar cada fase (no acumular), mensaje conforme al hook `feat/fix/docs/expand/refactor/chore` + id de sesión, stagear solo los archivos de la fase (nunca `git add -A` con trabajo ajeno sin terminar), decidir los archivos compartidos MoC/Log/TODO. TODO.md actualizado con stats reales (554 notas, 546 resuelto, 200 programa/118 comando/19 troubleshooting)
- Sesión 2026-08-31 (v32): **Lote 2+3 completados** — 8 notas programa 08 antiguas (GNUstep, SONiC, lshw, PCManFM, SpaceFM, handbrake, duplicity, ethtool) + 11 notas distribución 11 (Zentyal, Xero Linux, Garuda, Vanilla OS, LXLE, Drauger, EU OS, Lubuntu, HoloISO, EndeavourOS, Clear Linux) expandidas a ~130+ líneas; ethtool creada nueva (era 'Ethernet' en TODO). Log.md actualizado
- Sesión 2026-08-31 (v33): **Lote 2 completado** — 7 notas comando 07 (du, md5sum, history, date, sed, zip, chmod) expandidas de ~67-87 a ~120+ líneas; secciones añadidas: configuración, ejemplos avanzados, comparativa, troubleshooting. Log.md y TODO actualizados
- Sesión 2026-08-31 (v34): **Resto comandos 07 completado** — 7 notas comando 07 (nc, tar, expr, yes, paste, nl, comm) expandidas de ~81-99 a ~120+ líneas; secciones añadidas: uso avanzado, comparativa, troubleshooting. Log.md y TODO actualizados
- Sesión 2026-08-31 (v35): **Lote 2 — comandos 07 a ~100+ líneas (expansión paralela, sincronizada con v33)** — date (159), sed (127), du (129), history (174), timedatectl (99, 63→99), md5sum (147). Secciones añadidas: casos de uso (timestamps, diagnóstico de disco, checksums), comparativas (date vs timedatectl, md5sum vs sha256sum), historia/estado de timedatectl, troubleshooting. Corregido enlace [[ncdu]] (no existe nota). Content commiteado en `c8c4233` junto al lote 2-3. Log.md actualizado (fila v35)
- Sesión 2026-08-31 (v37): **links rotos resueltos + 4 notas nuevas** — creadas [[7z]], [[AUR]], [[FRRouting]], [[Proton]] (resolvían wikilinks rotos en zip/EndeavourOS/SONiC/HoloISO); corregido [[PCManFM-Qt]]→[[PCManFM]] en Lubuntu; hook pre-push mejorado para ignorar código inline `` `...` `` (eliminó falsos positivos [[Nota]] y [[\"$a\" == *patron*]]); automatizada `fecha_modificacion` en el hook pre-commit (automatiza add-modification-date.sh en staged); eliminadas 3 tareas cosméticas de "Prioridad baja" (descargar logos/capturas/diagramas, contradicen no usar imágenes locales). Stats → 560 notas.
- Sesión 2026-09-01 (v38): **TODO — lotes completados y stats corregidas** — marcados como ✅ completados Lote 1 de programas 08 (v34) y "Automatizar add-modification-date" (v37, pre-commit); stats corregidas a 551 resuelto / 191 media / 145 baja.
- Sesión 2026-09-01 (v39): **Lote 4 Fase A — comandos 07 restantes** — cut (86→117) y seq/yes/sleep (81→137) con casos de uso, sintaxis y troubleshooting; basename/dirname (91→112) con casos en sub-shell y troubleshooting. `nohup` ya completa, sin cambios.
- Sesión 2026-09-01 (v40): **Lote 4 Fase B — utilidades de sistema 08** — procps-ng reescrito (57→145) con componentes, señales y opciones; troubleshooting añadido a lspci/lsusb/dmidecode. gcc/make/node_exporter/smartctl ya completas.
- Sesión 2026-09-01 (v41): **Lote 4 Fase G — Labwc** — [[Labwc]] (WM Wayland 05) expandido (71→~110) con modelo de stacking, comparativa labwc vs Openbox/Sway/Wayfire y troubleshooting. Fases C/D/E/F valoradas sin cambios (notas de editores/programas, ofimática, navegadores y conceptos ya completas — sin padding).
- Sesión 2026-09-02 (v42b): **Lote expansion 08/01/11 restantes** — 6 notas expandidas: AUR (78→120), Firefox OS (82→93), Debate Tanenbaum-Torvalds (83→92), lsusb (83→109), Ungoogled Chromium (86→106), Dolphin (86→108). Secciones añadidas: instalación multi-distro, uso avanzado, comparativas, troubleshooting.
- Sesión 2026-09-02 (v44): **Auditoría completa** — 3 CJK corregidos (PCManFM: 管理→gestión, Log-2026: 用人间→en terminal, 256色→256 colores); ethtool.md añadida al MoC (huérfana); wikilinks verificados (0 rotos); frontmatter OK (561 válidas); 378 notas con fecha_modificación 2026-07-25 (conocido, ya marcado completo en sesiones anteriores).
- Sesión 2026-09-02 (v43): **Notas nuevas topics faltantes** — 6 notas nuevas: sshfs (123 líneas, montaje remoto SSH), mtr (101, diagnóstico de red), inotifywait (132, monitoreo filesystem), ncdu (107, analizador disco TUI), flatpak-builder (127, compilar Flatpaks), yq (116, procesador YAML). MoC actualizado. Eliminada sqlite3 (duplicada con SQLite existente de 585 líneas).
- Sesión 2026-09-02 (v42): **Lote expansion 08 Programas cortas** — 10 notas 08 expandidas a ~100-140 líneas: kew (63→120), Antigravity (65→110), Gem (79→109), Gnumeric (81→120), google-chrome (82→102), Proton (82→112), snapper (83→100), Calligra Suite (83→118), FreeOffice (83→107), st (83→140). Secciones añadidas: instalación multi-distro, uso avanzado, comparativas con alternativas, troubleshooting.
- Sesión 2026-09-02 (v45): **Notas nuevas distros/DE/WM faltantes** — 13 notas nuevas completas (estado borrador): distros Nobara Linux, Artix Linux, Guix System, Devuan, SpiralLinux, Q4OS, EasyOS, BigLinux (11); DE Unity (04); WM Xmonad, IceWM, Window Maker, twm (05). MoC actualizado con enlaces a todas. Commit `feat: 13 notas nuevas de distros DE y WM (v45)` = b387955. Stats → 580 notas.

---

#indice #todo
