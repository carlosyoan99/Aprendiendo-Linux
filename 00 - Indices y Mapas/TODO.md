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

### 🏗️ Infraestructura del vault — Sesión 1 (2026-07-23)
| Completado | Cambio | Detalle |
|---|---|---|
| ✅ | 7 templates actualizados con nuevas secciones | (2026-07-23) |
| ✅ | Hashtags `#DE-WM` → `#entorno-escritorio` | 28 notas de 04 y 05 corregidas |
| ✅ | README.md actualizado con cifras exactas | Estructura y tabla de contenidos reflejan reorganización |
| ✅ | CLAUDE.md actualizado | 12 categorías documentadas, reglas de estilo, Git hooks |
| ✅ | **Git hooks creados y activados** | `.githooks/` con pre-commit, commit-msg y pre-push |
| ✅ | **Referencias obsoletas eliminadas** | `raw/` y `Clippings/` borradas de .gitignore, Dashboard, Log y 3 notas |

### 🔗 Enlaces externos — Sesión 2 (2026-07-24)
| Completado | Nota | Detalle |
|---|---|---|
| ✅ | ~48 notas de todo el vault | Enlaces externos (Wikipedia + GitHub + docs oficiales) añadidos |
| ✅ | **07 - Comandos Esenciales (67/67)** | 100% completo con enlaces externos |
| ✅ | **03 - Sistema (28/28)** | 100% completo |
| ✅ | **08 - Programas (70/70)** | 100% completo |

### 📝 Expansión de notas con plantilla (2026-07-24)

| Completado | Nota | Mejora |
|---|---|---|
| ✅ | [[top]] | Opciones con columna Ejemplo, 6 casos numerados, flags -d y -o añadidos |
| ✅ | [[ps]] | Opciones con columna Ejemplo, 10 casos numerados |
| ✅ | [[kill]] | Opciones con columna Ejemplo, 12 casos numerados, flag -0 añadido |

---

## 🎯 PRÓXIMOS PASOS

### 🔴 Prioridad alta — Expandir notas existentes

Notas identificadas como cortas o con secciones faltantes, listas para expandir usando las nuevas plantillas como guía:

| Nota | Ubicación | Acción necesaria | Prioridad |
|---|---|---|---|
| `Daemon.md` | 01 - Conceptos | Expandir con ejemplos prácticos, tipos de daemons, tabla de señales | alta |
| `Busybox.md` | 08 - Programas | Expandir con comandos incluidos, comparativa con Coreutils, casos de uso | alta |
| `Ncurses.md` | 08 - Programas | Expandir con apps que lo usan (htop, nano, aptitude), ejemplos prácticos | alta |
| `Ubuntu.md` | 11 - Distribuciones | Expandir con tabla comparativa de sabores, troubleshooting post-instalación | alta |
| `Debian.md` | 11 - Distribuciones | Alinear con plantilla distro expandida (ciclo, gestor, requisitos) | alta |
| `Comparativa editores Linux.md` | 00 - Índices | Ya existe — verificar que esté completa y enlazada desde MoC | media |
| `Entorno de desarrollo Linux.md` | 08 - Programas | Guía práctica de stacks de desarrollo (Python, Node, C/C++, Rust) | media |

### 🟡 Prioridad media — Nuevas notas planificadas

Basado en el análisis de brechas del vault — notas que aportarían valor significativo:

| Nota | Categoría | Justificación | Prioridad |
|---|---|---|---|
| `Regular Expressions.md` | concepto | grep, sed, awk las usan — nota de referencia central (alta demanda) | media |
| `Vim comandos avanzados.md` | comando | Expandir más allá de la nota introductoria actual (modos, macros, registros) | media |
| `systemd unidades personalizadas.md` | sistema | Cómo crear servicios, timers, targets propios | media |
| `Contenedores orquestación.md` | concepto | Docker Compose, Kubernetes, swarm — más allá de lo básico | baja |
| `Optimización de rendimiento.md` | concepto | tuning de kernel, sysctl, límites de recursos | baja |

### 🟢 Prioridad baja — Mejoras continuas y mantenimiento

| Tarea | Detalle | Estado |
|---|---|---|
| Auditoría de wikilinks rotos | El hook pre-push ya lo verifica automáticamente | ✅ automático |
| Git hooks | Instalados y activos (`.githooks/`, `core.hooksPath` configurado) | ✅ completado |
| Script check-frontmatter | Funciona correctamente (0 falsos positivos reales) | ✅ verificado |
| Enlaces externos | **100% completados** en notas de contenido | ✅ completado |
| Repositorio Git | Inicializado con historial completo del vault | ✅ completado (2026-07-24) |
| Cron semanal vault-stats | Verificar que el cron está activo o crearlo | ⚪ pendiente |
| Unificar bloques de código sueltos | Agrupar en un solo bloque por sección (estilo plantilla) | ⚪ pendiente |
| Expandir 5 notas prioridad alta | Daemon, Busybox, Ncurses, Ubuntu, Debian | 🔴 pendiente |
| Crear notas prioridad media | Regular Expressions, Vim avanzados, systemd unidades | 🟡 pendiente |
| Verificar Dashboard Dataview | Asegurar que las queries siguen funcionando tras cambios | ⚪ pendiente |

## Enlaces externos

- [Obsidian — sitio oficial](https://obsidian.md/)
- [Obsidian Dataview plugin](https://blacksmithgu.github.io/obsidian-dataview/)
- [Obsidian Templater plugin](https://silentvoid13.github.io/Templater/)
- [The Linux Documentation Project](https://tldp.org/)
- [Git](https://git-scm.com/) — sistema de control de versiones

---

## 📊 ESTADÍSTICAS DEL VAULT (reales — 2026-07-24)

| Métrica | Valor |
|---|---|
| **Notas totales** | **314** (+ 7 templates) |
| **Estado resuelto** | 309 |
| **Estado en progreso** | 4 (TODO, MoC, Dashboard, Log) |
| **Estado borrador** | 0 (CLAUDE.md y Log.md contienen la palabra `borrador` en su texto, pero NO son notas en ese estado) |
| **Prioridad alta** | 153 |
| **Prioridad media** | 103 |
| **Prioridad baja** | 53 |

### Por categoría (real)

| Categoría | Notas | Categoría | Notas |
|---|---|---|---|
| **Programa** | 70 | **Comando** | 67 |
| **Concepto** | 36 | **Distribución** | 40 |
| **Sistema** | 28 | **Entorno / WM** | 29 |
| **Troubleshooting** | 16 | **Índice** | 12 |
| **Instalación** | 9 | **Terminal** | 4 |
| **Automatización** | 3 | **Log** | 1 |

### Por carpeta (real)

| Carpeta | Notas | Carpeta | Notas |
|---|---|---|---|
| 00 - Indices y Mapas | 12 | 01 - Conceptos Fundamentales | 35 |
| 02 - Instalacion y Configuracion | 9 | 03 - Estructura del Sistema | 28 |
| 04 - Entornos de Escritorio | 15 | 05 - Gestores de Ventanas | 14 |
| 06 - La Terminal | 4 | 07 - Comandos Esenciales | 66 |
| 08 - Programas y Herramientas | 69 | 09 - Solucion de Problemas | 16 |
| 10 - Automatizacion y Scripts | 4 | 11 - Distribuciones | 40 |

---

## 📝 NOTAS

- Las plantillas se actualizaron el 2026-07-23. Las notas existentes NO se migraron automáticamente — se expandirán progresivamente.
- **Discrepancias corregidas en esta sesión**:
  - Estadísticas corregidas con datos reales del escaneo (314 notas en lugar de 306) ✅
  - Carpeta `11 - Distribuciones` añadida (40 notas movidas de 02) ✅
  - No hay notas en estado `borrador` real — solo falsos positivos de grep en CLAUDE.md (instrucciones) ✅
  - `Comparativa editores Linux.md` ya existe y está enlazada desde el MoC ✅
- Log.md tiene el registro histórico detallado de todas las sesiones.

---

#indice #todo
