# Instrucciones para la IA — Vault "AprendiendoLinux"

Este documento define cómo cualquier agente LLM (Claude u otro) debe leer, mantener y expandir este vault. Léelo por completo antes de crear o editar cualquier nota.

## 1. Propósito del vault
Documentar el aprendizaje de Linux de forma incremental: conceptos, comandos, programas, entornos gráficos y soluciones a problemas reales encontrados en el camino. No es una copia de documentación externa — cada nota debe reflejar comprensión propia, con ejemplos y notas personales, no solo teoría copiada.

## 2. Estructura de carpetas

| Carpeta | Contenido |
|---|---|
| `00 - Indices y Mapas` | Notas MoC (Map of Content), Dashboard, Rutas de Aprendizaje, TODO |
| `01 - Conceptos Fundamentales` | Qué es Linux, kernel, filosofía, namespaces, locale, NTP |
| `02 - Instalacion y Configuracion` | Guías de instalación, particionado, dist-upgrade, checklists |
| `03 - Estructura del Sistema` | FHS, permisos, procesos, cgroups, boot process |
| `04 - Entornos de Escritorio` | GNOME, KDE, XFCE, etc. + Desktop Shells |
| `05 - Gestores de Ventanas` | i3, Hyprland, DWM, etc. |
| `06 - La Terminal` | Shell, tmux, screen, filosofía de la terminal |
| `07 - Comandos Esenciales` | Una nota por comando + cheat sheet general |
| `08 - Programas y Herramientas` | Apps y utilidades (editores, navegadores, lenguajes, suites, Ansible) |
| `09 - Solucion de Problemas` | Recursos generales + **16 problemas resueltos** (WiFi, permisos, SSH, Docker, Bluetooth, GRUB, NVIDIA, pantalla negra, etc.) |
| `10 - Automatizacion y Scripts` | Notas de automatización, Log.md, cron logs |
| `scripts/` | Scripts del vault (bash + Python): automatización, stats, descargas |
| `11 - Distribuciones` | Catálogo de distribuciones Linux (40 notas: Ubuntu, Debian, Arch, Fedora, etc.) |
| `Templates` | Plantillas — no editar su estructura sin avisar al usuario |

### Enlaces externos e imágenes

- Se pueden incluir **imágenes públicas de Wikipedia** (`https://upload.wikimedia.org/...`) cuando aporten valor visual (diagramas, capturas de interfaz, logotipos).
- **Enlaces externos**: incluir enlaces a GitHub, Wikipedia y wikis oficiales de distribuciones cuando sea relevante para que el usuario pueda profundizar.

### Assets locales (`assets/`)

Las imágenes descargadas se almacenan localmente en `assets/` para acceso sin conexión:

```
assets/
├── logos/          # Logos de distribuciones, DEs, WMs, programas
├── screenshots/    # Capturas de pantalla de entornos y aplicaciones
└── diagrams/       # Diagramas técnicos (kernel, FHS, boot process, etc.)
```

Para insertar una imagen en una nota, usar sintaxis Markdown:
```markdown
![Ubuntu](assets/logos/ubuntu.svg)
```
O wikilink de Obsidian (permite redimensionar):
```markdown
![[assets/logos/ubuntu.svg|200]]
```

Las imágenes deben ser de **uso libre** (Wikimedia Commons, sitios oficiales, dominio público, CC BY-SA, GPL). Se aceptan formatos SVG (logos, diagramas vectoriales) y PNG (capturas de pantalla).

## 3. Reglas al crear una nota nueva
1. Elegir la carpeta correcta según la tabla anterior.
2. Usar la plantilla correspondiente de `Templates/` como base (comando, programa, concepto, entorno/WM, distro, problema resuelto, log diario).
3. Frontmatter obligatorio en toda nota:
   ```yaml
   ---
   fecha_creacion: YYYY-MM-DD
   fecha_modificacion: YYYY-MM-DD
   estado: borrador | en progreso | resuelto
   categoria: concepto | comando | programa | sistema | entorno-escritorio | distribucion | instalacion | terminal | troubleshooting | automatizacion | indice | log
   prioridad: alta | media | baja
   ---
   ```
   `fecha_modificacion` se actualiza automáticamente vía script (`add-modification-date.sh`) o al editar la nota manualmente. Sirve para identificar notas desactualizadas que necesitan revisión.
   `prioridad` es opcional en notas de índice/log, pero obligatorio en cualquier nota de contenido — indica cuánto conviene profundizar en ese tema antes que en otros de la misma categoría. Ver criterio completo en `00 - Indices y Mapas/Rutas de Aprendizaje.md`.

   **Categorías disponibles** (12):
   - `concepto` — teoría, fundamentos, ideas abstractas (01 - Conceptos Fundamentales)
   - `comando` — utilidades de terminal, una nota por comando (07 - Comandos Esenciales)
   - `programa` — aplicaciones y herramientas (08 - Programas y Herramientas)
   - `sistema` — componentes del sistema operativo (03 - Estructura del Sistema)
   - `entorno-escritorio` — DEs y WMs (04 - Entornos de Escritorio, 05 - Gestores de Ventanas)
   - `distribucion` — distros Linux (11 - Distribuciones)
   - `instalacion` — guías de instalación, configuración, upgrade (02 - Instalacion y Configuracion)
   - `terminal` — la shell, multiplexores (06 - La Terminal)
   - `troubleshooting` — problemas y soluciones (09 - Solucion de Problemas)
   - `automatizacion` — scripts, cron, timers, hooks (10 - Automatizacion y Scripts)
   - `indice` — MoC, Dashboard, mapas de contenido (00 - Indices y Mapas)
   - `log` — registro de sesiones (10 - Automatizacion y Scripts/Log.md)

4. Enlazar la nota nueva desde `00 - Indices y Mapas/MoC - Linux.md` (agregar bajo la sección correspondiente).
5. Usar wikilinks (enlaces dobles `[[nota]]`) para conectar con notas relacionadas ya existentes — revisar el vault antes de crear una nota para no duplicar contenido.
6. Etiquetar con al menos un `#hashtag` de categoría al final de la nota.

## 4. Reglas de edición
- Nunca sobrescribir contenido existente en una nota sin que el usuario lo pida explícitamente — preferir añadir secciones o actualizar `estado`.
- Si una nota tiene `estado: borrador`, se puede expandir libremente.
- Si tiene `estado: resuelto` o `en progreso` con contenido sustancial, confirmar antes de reescribir secciones enteras.

## 5. Registro de sesiones
Cada vez que se trabaje en el vault (nuevas notas, cambios grandes), añadir una entrada al final de `10 - Automatizacion y Scripts/Log.md` con fecha y resumen de 1-3 líneas. Nunca reescribir entradas anteriores del log.

## 6. Estilo
- Español, tono directo, sin relleno.
- Priorizar tablas y bloques de código sobre párrafos largos cuando el contenido lo permita (comandos, comparativas).
- Ejemplos de código siempre en bloques ```bash cuando aplique.
- Al crear troubleshooting notes, seguir la estructura: Síntoma → Diagnóstico → Causa → Solución → Escenarios → Prevención → Ver también.
- Al crear notas de comando, seguir la estructura: Sintaxis → Descripción → Formato salida → Opciones → Ejemplos → Casos de uso → Combinaciones pipe → Alternativas modernas → Troubleshooting → Ver también.

## 7. Plugins recomendados (comunidad de Obsidian)

Instalar desde *Settings → Community plugins → Browse*:

| Plugin | Para qué |
|---|---|
| **Dataview** | Motor de consultas — alimenta `00 - Indices y Mapas/Dashboard.md`. Requiere activar "Enable JavaScript Queries" solo si se usan `dataviewjs` (no es necesario para las queries actuales). |
| **Templater** | Reemplaza el motor de plantillas nativo de Obsidian con soporte para `{{date}}`, prompts y scripts al insertar una plantilla nueva. Configurar la carpeta de plantillas en `Settings → Templater → Template folder location` apuntando a `Templates/`. |
| **Tasks** | Checkboxes con metadatos (fecha límite, prioridad, recurrencia) — útil para `Post-Instalacion Checklist.md` y para trackear pendientes dentro de cualquier nota con `- [ ]`. |
| **QuickAdd** (opcional) | Atajo de teclado para crear una nota nueva desde una plantilla sin navegar manualmente a la carpeta correcta. |
| **Tag Wrangler** (opcional) | Gestionar (renombrar/fusionar) etiquetas masivamente cuando el vault crece. |

Con Dataview instalado, `00 - Indices y Mapas/Dashboard.md` se actualiza solo: agrupa notas por `estado`, tipo, y muestra lo modificado en los últimos 7 días. **Cualquier nota nueva que siga el frontmatter y los `#hashtags` definidos en este documento aparecerá ahí automáticamente** — no hace falta editar el dashboard a mano al agregar notas.

## 8. Git hooks y automatización del vault

El vault incluye Git hooks en `.githooks/` que validan automáticamente:

- **pre-commit**: verifica frontmatter (fecha, estado, categoría) en archivos nuevos/modificados
- **commit-msg**: valida formato del mensaje de commit (feat/fix/docs/expand/refactor/chore)
- **pre-push**: busca wikilinks rotos antes de hacer push

Para activar los hooks al clonar el repo:
```bash
git config core.hooksPath .githooks
chmod +x .githooks/*
```

## 9. Automatización futura
Si se construye un script propio (Python/Node) que use la API de Claude para generar o actualizar notas automáticamente, debe:
- Leer este archivo (`CLAUDE.md`) como system prompt / contexto de reglas.
- Escribir únicamente dentro de la estructura de carpetas definida arriba.
- Registrar su propia ejecución en `Log.md`.
- Documentarse a sí mismo en `scripts/` o `10 - Automatizacion y Scripts/`.
- Revisar `00 - Indices y Mapas/TODO.md` para conocer el estado actual del proyecto.
