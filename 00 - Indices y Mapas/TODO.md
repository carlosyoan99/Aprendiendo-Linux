---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-24
estado: en progreso
categoria: indice
prioridad: alta
---

# TODO — Plan de trabajo del vault

> Este archivo centraliza el estado de todo el proyecto: lo completado, lo pendiente, y el roadmap futuro.
> Última actualización: 2026-07-24

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
| ✅ | Enlaces externos completados al 100% en notas de contenido | 2026-07-24 |
| ✅ | Repositorio Git inicializado (commit inicial) | 2026-07-24 |
| ✅ | Scripts de automatización (5) + cron semanal vault-stats | 2026-07-24 |

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
| ✅ | Dashboard.md actualizado | Stats corregidas (314 notas, 27 Entorno/WM, etc.) |
| ✅ | MoC - Linux.md corregido | Eliminadas entradas duplicadas y huérfanas |

---

## 🎯 PRÓXIMOS PASOS

### 🔴 Prioridad alta

| Tarea | Detalle | Estado |
|---|---|---|
| `Entorno de desarrollo Linux.md` | 08 - Programas — guía práctica de stacks (Python, Node, C/C++, Rust) | ⚪ pendiente |
| `Contenedores orquestación.md` | concepto — Docker Compose, Kubernetes, swarm | ⚪ pendiente |
| `Optimización de rendimiento.md` | concepto — tuning de kernel, sysctl, límites de recursos | ⚪ pendiente |

### 🟡 Prioridad media

| Tarea | Detalle | Estado |
|---|---|---|
| Verificar wikilinks rotos | Ejecutar `git push` con hook pre-push o script find-orphans | ⚪ pendiente |
| Verificar notas con `fecha_modificacion` antigua (>30 días) | Identificar candidatas a revisión/expansión | ⚪ pendiente |
| Automatizar `add-modification-date.sh` | Ejecutar periódicamente para mantener fechas al día | ⚪ pendiente |

### 🟢 Prioridad baja — Mejoras continuas

| Tarea | Detalle | Estado |
|---|---|---|
| Unificar bloques de código sueltos | Agrupar en un solo bloque por sección (estilo plantilla) | ⚪ pendiente |
| Expandir notas nuevas con `fecha_modificacion` antigua | Identificar y priorizar según antigüedad | ⚪ pendiente |

---

## 📊 ESTADÍSTICAS DEL VAULT (reales — 2026-07-24)

| Métrica | Valor |
|---|---|
| **Notas totales** | **314** (+ 7 templates) |
| **Estado resuelto** | 309 |
| **Estado en progreso** | 4 (TODO, MoC, Dashboard, Log) |
| **Estado borrador** | 0 (falsos positivos en CLAUDE.md y Log.md que contienen la palabra en su texto) |
| **Prioridad alta** | 153 |
| **Prioridad media** | 103 |
| **Prioridad baja** | 51 |

### Por categoría (real)

| Categoría | Notas | Categoría | Notas |
|---|---|---|---|
| **Programa** | 70 | **Comando** | 68 |
| **Concepto** | 36 | **Distribución** | 40 |
| **Sistema** | 29 | **Entorno / WM** | 27 |
| **Troubleshooting** | 16 | **Índice** | 12 |
| **Instalación** | 9 | **Terminal** | 4 |
| **Automatización** | 3 | **Log** | 1 |

### Por carpeta (real)

| Carpeta | Notas | Carpeta | Notas |
|---|---|---|---|
| 00 - Indices y Mapas | 12 | 01 - Conceptos Fundamentales | 36 |
| 02 - Instalacion y Configuracion | 9 | 03 - Estructura del Sistema | 28 |
| 04 - Entornos de Escritorio | 14 | 05 - Gestores de Ventanas | 13 |
| 06 - La Terminal | 4 | 07 - Comandos Esenciales | 67 |
| 08 - Programas y Herramientas | 69 | 09 - Solucion de Problemas | 16 |
| 10 - Automatizacion y Scripts | 4 | 11 - Distribuciones | 40 |

---

## 📝 NOTAS

- Las plantillas se actualizaron el 2026-07-23 y se volvieron a actualizar el 2026-07-24 con `fecha_modificacion`.
- Las notas existentes NO se migraron automáticamente a las nuevas plantillas — se expandirán progresivamente según prioridad.
- **Log.md** en `10 - Automatizacion y Scripts/` tiene el registro histórico detallado de todas las sesiones.
- El script `add-modification-date.sh` permite re-ejecutar la actualización de `fecha_modificacion` en cualquier momento.
- Se eliminaron 2 archivos resumen redundantes (`DEs adicionales` y `WMs adicionales`) — todos los DEs y WMs tienen nota individual completa.

---

#indice #todo
