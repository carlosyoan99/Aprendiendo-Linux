---
fecha_creacion: 2026-07-25
estado: en progreso
categoria: indice
prioridad: alta
---

# Prompts de Trabajo — Retomar el Vault con Cualquier IA

Copiar y pegar tal cual al inicio de una conversación nueva, adjuntando o dando acceso a la carpeta del vault (`AprendiendoLinux/`). Cada prompt asume que la IA puede leer archivos del vault directamente — si no puede, pega primero el contenido de `CLAUDE.md`.

No reemplazan a `CLAUDE.md` (que define las reglas técnicas del esquema) — son el "gatillo" para que una IA nueva lo lea y actúe en consecuencia, ya que una sesión nueva no lee nada por su cuenta a menos que se le indique.

---

## 1. Onboarding — retomar el proyecto después de tiempo sin tocarlo

```
Estoy retomando el proyecto "AprendiendoLinux", un vault de Obsidian para
documentar mi aprendizaje de Linux, con esquema de frontmatter propio y
convenciones ya definidas.

Antes de hacer nada:
1. Lee CLAUDE.md en la raíz — define estructura de carpetas, esquema de
   frontmatter (fecha_creacion, fecha_modificacion, estado, categoria,
   prioridad) y reglas de edición.
2. Lee 00 - Indices y Mapas/TODO.md — próximos pasos ya priorizados.
3. Lee las últimas 3-5 entradas de 10 - Automatizacion y Scripts/Log.md —
   qué se hizo en las sesiones más recientes.
4. Si hay un repo git, revisa `git log --oneline -15` para el historial
   reciente de commits.

Después, dame un resumen breve (5-6 líneas) del estado actual: cuántas
notas hay, qué se hizo últimamente, y qué queda pendiente según el TODO.
No edites nada todavía — solo confirmame que entendiste el proyecto antes
de que te pida la siguiente tarea.
```

## 2. Crear notas nuevas sobre un tema

```
Quiero agregar notas nuevas al vault sobre: [TEMA O LISTA DE TEMAS].

Sigue exactamente las convenciones de CLAUDE.md:
- Ubica cada nota en la carpeta correcta según la tabla de estructura.
- Usa la plantilla correspondiente de Templates/ como base.
- Frontmatter completo: fecha_creacion, estado, categoria (del enum
  documentado), prioridad (alta/media/baja).
- Antes de crear, revisa que el tema no exista ya (evitar duplicados).
- Enlaza cada nota nueva desde 00 - Indices y Mapas/MoC - Linux.md.
- Usa [[wikilinks]] hacia notas relacionadas ya existentes.
- Registra la sesión en Log.md al final (2-4 líneas, qué se agregó y dónde).
```

## 3. Auditoría completa

```
Audita el vault completo antes de tocar nada. Verifica:
1. Nombres de archivo rotos (encoding, caracteres extraños) — revisa
   especialmente títulos con tildes/ñ.
2. Notas huérfanas: usa scripts/find-orphans.sh
   si existe, o compara manualmente los wikilinks del MoC contra los
   archivos reales.
3. Frontmatter: usa scripts/check-frontmatter.sh si existe, o verifica
   a mano que categoria/estado/prioridad respeten el enum de CLAUDE.md.
4. Cifras del README.md contra la realidad — usa scripts/vault-stats.sh
   si existe como fuente de verdad, no cuentes a ojo.
5. Consistencia de estructura: carpetas vacías residuales, duplicados,
   convenciones de nombres.

Repórtame los hallazgos ANTES de corregir nada, clasificados en:
errores reales (rompen algo) vs. puntos de mejora (no rompen pero
convendría arreglar) vs. observaciones (decisión mía, no lo toques).
Después de mi confirmación, aplica los fixes y registra todo en Log.md.
```

## 4. Priorizar próximos temas

```
Dado el estado actual del vault (revisa qué ya existe recorriendo las
carpetas y el MoC), dame una lista de posibles notas nuevas a agregar,
organizadas por categoría y con prioridad (alta/media/baja) según el
mismo criterio de 00 - Indices y Mapas/Rutas de Aprendizaje.md: alta =
base indispensable, media = amplía, baja = nicho/redundante con algo
que ya existe. No crees nada todavía, solo la lista para que yo decida
por dónde seguir.
```

## 5. Cierre de sesión

```
Antes de terminar: registra en Log.md un resumen de todo lo que se hizo
en esta sesión (2-6 líneas según el volumen de cambios). Si algo quedó
pendiente, actualiza TODO.md. Si hay repo git, prepara el commit
siguiendo el formato de mensajes ya usado en el historial (revisa
`git log` para el estilo exacto) — no hagas commit sin que yo lo pida
explícitamente si estamos en una sesión donde no lo he mencionado antes.
```

---

## Notas de uso

- Si la IA no tiene acceso directo a los archivos (por ejemplo, un chat
  sin adjuntos), pega primero el contenido completo de `CLAUDE.md` antes
  de usar cualquiera de estos prompts.
- Estos prompts asumen que el esquema y las carpetas no cambiaron desde
  la última sesión. Si reestructuraste algo grande, actualiza primero
  `CLAUDE.md` para que quede como fuente de verdad — estos prompts
  delegan en él a propósito, no repiten las reglas.
- El prompt de auditoría (#3) es el más pesado — úsalo después de una
  sesión larga o de recibir el vault de otra fuente (otra máquina,
  otra IA), no en cada sesión.

#indice #prompts
