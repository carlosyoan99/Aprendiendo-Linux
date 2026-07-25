---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-25
estado: en progreso
categoria: indice
prioridad: alta
---

# TODO — Plan de trabajo del vault

> Este archivo centraliza el estado de todo el proyecto: lo completado, lo pendiente, y el roadmap futuro.
> Última actualización: 2026-07-25 (sesión expansiones + enlaces externos)

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
| ✅ | [[Actualizacion entre versiones mayores]] | Nota nueva (02 - Instalacion) |
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

### 🐛 Bugs corregidos — Sesión 2026-07-25

| Completado | Fix | Archivo |
|---|---|---|
| ✅ | `[[xh]]` → texto plano (xh sin nota propia) | httpie.md |
| ✅ | `prioridad: media` → `baja` (consistencia con otras TUI) | fd-find.md |
| ✅ | Troubleshooting duplicado fusionado (`command not found` x2) | nala.md |
| ✅ | Orden de secciones invertido (Enlaces externos antes de Ver también) | jq.md |

---

## 🎯 PRÓXIMOS PASOS

### 🔴 Prioridad alta

| Tarea | Detalle | Estado |
|---|---|---|
| `Entorno de desarrollo Linux.md` | 08 - Programas — guía práctica de stacks (Python, Node, C/C++, Rust) | ✅ completado |
| `Contenedores orquestación.md` | concepto — Docker Compose, Swarm, K8s, árbol de decisión | ✅ completado |
| `Optimización de rendimiento.md` | concepto — tuning de kernel, sysctl, límites de recursos | ✅ completado |

### 🟡 Prioridad media

| Tarea | Detalle | Estado |
|---|---|---|
| Verificar wikilinks rotos | Ejecutar `git push` con hook pre-push o script find-orphans | ⚪ pendiente |
| Verificar notas con `fecha_modificacion` antigua (>30 días) | Identificar candidatas a revisión/expansión | ⚪ pendiente |
| Automatizar `add-modification-date.sh` | Ejecutar periódicamente para mantener fechas al día | ⚪ pendiente |

### 🟢 Prioridad baja — Mejoras continuas

| Tarea | Detalle | Estado |
|---|---|---|
| Crea nota xh.md | Alternativa Rust a httpie (resolver wikilink roto) | ⚪ pendiente |
| Unificar bloques de código sueltos | Agrupar en un solo bloque por sección | ⚪ pendiente |
| Expandir Motif.md | ~50 → ~100 líneas | ⚪ pendiente |

---

## 📊 ESTADÍSTICAS DEL VAULT (reales — 2026-07-25)

| Métrica | Valor |
|---|---|
| **Notas totales** | **357** (+ 7 templates) |
| **Estado resuelto** | 352 |
| **Estado en progreso** | 4 (TODO, MoC, Dashboard, Log) |
| **Estado borrador** | 1 (Log.md contiene la palabra en su texto) |
| **Prioridad alta** | 168 |
| **Prioridad media** | 117 |
| **Prioridad baja** | 67 |

### Por categoría (real)

| Categoría | Notas | Categoría | Notas |
|---|---|---|---|
| **Programa** | 93 | **Comando** | 83 |
| **Concepto** | 38 | **Distribución** | 41 |
| **Sistema** | 30 | **Entorno / WM** | 29 |
| **Troubleshooting** | 16 | **Índice** | 12 |
| **Instalación** | 9 | **Terminal** | 4 |
| **Automatización** | 3 | **Log** | 1 |

### Por carpeta (real)

| Carpeta | Notas | Carpeta | Notas |
|---|---|---|---|
| 00 - Indices y Mapas | 12 | 01 - Conceptos Fundamentales | 37 |
| 02 - Instalacion y Configuracion | 9 | 03 - Estructura del Sistema | 30 |
| 04 - Entornos de Escritorio | 15 | 05 - Gestores de Ventanas | 13 |
| 06 - La Terminal | 4 | 07 - Comandos Esenciales | 82 |
| 08 - Programas y Herramientas | 92 | 09 - Solucion de Problemas | 16 |
| 10 - Automatizacion y Scripts | 5 | 11 - Distribuciones | 42 |

---

## 📝 NOTAS

- Las plantillas se actualizaron el 2026-07-23 y se volvieron a actualizar el 2026-07-24 con `fecha_modificacion`.
- Las notas existentes NO se migraron automáticamente a las nuevas plantillas — se expandirán progresivamente según prioridad.
- **Log.md** en `10 - Automatizacion y Scripts/` tiene el registro histórico detallado de todas las sesiones.
- Sesión 2026-07-24: 14 notas TUI (1 guía + 13 específicas) + 3 notas planificadas (Regex, Vim, systemd).
- Sesión 2026-07-25: 6 notas alta prioridad (ripgrep, tree, procs, doggo, bandwhich, fx), 5 expandidas (ctop, httpie, fd-find, fzf, nala), enlaces externos a 10 notas.

---

#indice #todo
