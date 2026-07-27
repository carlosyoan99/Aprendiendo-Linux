---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-27
estado: resuelto
categoria: automatizacion
prioridad: alta
---

# Scripts del Vault

> Herramientas de automatización para mantener el vault organizado, validado y con estadísticas actualizadas. Todos los scripts están en `scripts/`.

## Vista rápida

| Script | Función | Frecuencia | Dependencias |
|---|---|---|---|
| `vault-stats.sh` | Estadísticas completas (~0.16s) | Semanal (manual/cron) | `find`, `grep` |
| `vault-stats-weekly.sh` | Wrapper cron para stats semanales | Semanal (cron) | vault-stats.sh |
| `daily-log.sh` | Crea nota de log diaria | Diaria (manual) | — |
| `check-frontmatter.sh` | Valida frontmatter (~0.4s) | Al crear/editar notas | — |
| `find-orphans.sh` | Encuentra notas no enlazadas (~6s) | Semanal | MoC - Linux.md |
| `add-modification-date.sh` | Sincroniza fechas con mtime (perl) | Semanal (cron) | `perl`, `date`, `grep` |
| `setup.sh` | Configura git hooks y cron jobs | Una vez (post-clon) | — |

---

## 1. vault-stats.sh

**Ubicación:** `scripts/vault-stats.sh`

Muestra estadísticas detalladas del vault: total de notas, estado (borrador/en progreso/resuelto), prioridad, categorías, distribución por carpeta, y últimas modificaciones.

### Uso

```bash
# Estadísticas completas
bash scripts/vault-stats.sh

# Resumen breve (solo estado + prioridad)
bash scripts/vault-stats.sh --resumen

# Salida en CSV (para pipear a herramientas externas)
bash scripts/vault-stats.sh --csv
```

### Funcionamiento

1. Cuenta archivos `.md` excluyendo `Templates/` y `.obsidian/`
2. **Single-pass**: un solo `grep -rh` extrae a la vez `estado:`, `prioridad:`, `categoria:` de todas las notas
3. Procesa con `sort | uniq -c` para obtener conteos agregados
4. Agrupa notas por carpeta con `find | awk -F/` (sin bash loop lento)
5. Obtiene las 10 últimas modificaciones del filesystem (`mtime`)

> ⚡ **Optimizado**: de ~11s a **~0.16s** (68x más rápido) usando un solo scan combinado en vez de 7 scans separados.

### Salida CSV

```csv
metrico,valor
total,516
borrador,0
resuelto,509
prioridad_alta,215
categoria_comando,109
```

---

## 2. vault-stats-weekly.sh

**Ubicación:** `scripts/vault-stats-weekly.sh`

---

## 7. setup.sh

**Ubicación:** `setup.sh` (raíz de `10 - Automatizacion y Scripts/`)

Script de instalación que configura git hooks y cron jobs automáticamente. Es la puerta de entrada para nuevos colaboradores del vault.

### Uso

```bash
# Configurar todo (hooks + cron, interactivo)
bash setup.sh

# Solo git hooks (no interactivo)
bash setup.sh --hooks-only --yes

# Solo cron jobs
bash setup.sh --cron-only

# Eliminar cron jobs instalados
bash setup.sh --cron-remove

# Verificar estado actual
bash setup.sh --check
```

### Modos

| Modo | Qué hace |
|---|---|
| `completo` (default) | Configura hooks + pregunta si instalar cron |
| `--hooks-only` | Activa git hooks (`core.hooksPath`, permisos) |
| `--cron-only` | Instala solo los cron jobs semanales |
| `--cron-remove` | Elimina los cron jobs del vault del crontab |
| `--check` | Muestra estado: hooks, cron, scripts disponibles |
| `--yes` | No interactivo (asume sí a todo) |

### Funcionamiento

1. **Git hooks**:
   - Hace ejecutables los hooks en `.githooks/`
   - Ejecuta `git config core.hooksPath .githooks`
   - Muestra resumen de cada hook instalado

2. **Cron jobs**:
   - Añade entradas al crontab del usuario con un tag identificador: `# VAULT:AprendiendoLinux:tipo:id`
   - `add-modification-date.sh` → Domingos 08:00
   - `vault-stats-weekly.sh` → Domingos 09:00
   - Es **idempotente**: detecta entradas existentes y no las duplica
   - `--cron-remove` busca el tag y elimina solo las entradas del vault

3. **Identificador único**: Cada instalación genera un `CRON_ID` basado en el hash del path del vault, permitiendo múltiples clones sin conflicto.

### Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `crontab: command not found` | cron no instalado en el sistema | `sudo apt install cron` (Debian) o `sudo pacman -S cronie` (Arch) |
| `md5sum: command not found` | md5sum no disponible (macOS) | El script fallback a "default" — sigue funcionando |
| Los hooks no se ejecutan | `core.hooksPath` no configurado | Ejecutar `bash setup.sh --hooks-only` |
| Los cron jobs no se ejecutan | El servicio cron no está activo | `sudo systemctl enable --now cronie` o `cron` según la distro |

### Ver también

- [[Git hooks para el vault]] — hooks en detalle
- [[Cron]] · [[systemd timers]] — automatización programada
- [[Scripts del Vault]] — documentación de todos los scripts

Wrapper para ejecutar `vault-stats.sh --resumen` semanalmente vía cron y guardar el resultado en `vault-stats-weekly.log`.

### Uso

```bash
# Ejecución manual
bash scripts/vault-stats-weekly.sh

# Configuración cron (domingos 9:00)
# 0 9 * * 0 /ruta/completa/scripts/vault-stats-weekly.sh
```

### Funcionamiento

1. Determina la raíz del vault automáticamente (esté donde esté el script)
2. Verifica que `vault-stats.sh` exista
3. Ejecuta `vault-stats.sh --resumen` y redirige stdout a `vault-stats-weekly.log`
4. Añade timestamp a cada ejecución

### Log de ejemplo

```
══════════════════════════════════════
📊 VAULT STATS — 2026-07-26 09:00
══════════════════════════════════════
Total: 320 notas
Resuelto: 315 ...
```

---

## 3. daily-log.sh

**Ubicación:** `scripts/daily-log.sh`

Crea una nota de log diaria individual en `10 - Automatizacion y Scripts/Log - YYYY-MM-DD.md` con secciones predefinidas.

### Uso

```bash
# Log vacío (solo estructura)
bash scripts/daily-log.sh

# Log con contenido inicial
bash scripts/daily-log.sh "Explorando Hyprland por primera vez"

# Flags específicos
bash scripts/daily-log.sh \
  -a "Configuré i3 con polybar" \    # Qué exploré hoy
  -c "i3-msg, xrandr" \              # Comandos nuevos
  -e "Polybar no muestra el módulo de red" \  # Problemas
  -s "Probar picom para transparencias"       # Próximos pasos
```

### Funcionamiento

1. Genera nombre de archivo con fecha actual: `Log - 2026-07-24.md`
2. Verifica que no exista ya (si existe, lo abre con `$EDITOR`)
3. Crea el archivo con frontmatter + secciones rellenadas
4. Usa la plantilla `Templates/Plantilla - Log Diario.md`

---

## 4. check-frontmatter.sh

**Ubicación:** `scripts/check-frontmatter.sh`

Valida que todas las notas del vault tengan frontmatter correcto según las reglas de CLAUDE.md.

### Uso

```bash
# Validar todas las notas
bash scripts/check-frontmatter.sh

# Solo mostrar errores (oculta OK)
bash scripts/check-frontmatter.sh --solo-errores

# Reparar errores simples (añadir hashtag faltante)
bash scripts/check-frontmatter.sh --fix

# Validar solo una carpeta
bash scripts/check-frontmatter.sh "07 - Comandos Esenciales"
```

### Validaciones

| Verificación | Qué comprueba |
|---|---|
| `---` inicial | El archivo empieza con frontmatter |
| Cierre de frontmatter | Tiene `---` de cierre |
| `fecha_creacion` | Campo presente |
| `estado` | Campo presente (`borrador`, `en progreso`, `resuelto`) |
| `categoria` | Campo presente |
| Hashtag al final | Las últimas 3 líneas contienen un `#hashtag` |

### Modo --fix

Actualmente solo repara hashtags faltantes, infiriendo la categoría del frontmatter:

```
Sin hashtag → Se añade #categoria al final
```

---

## 5. find-orphans.sh

**Ubicación:** `scripts/find-orphans.sh`

Encuentra notas que no están enlazadas desde el MoC (Map of Content) ni desde otras notas.

### Uso

```bash
# Buscar huérfanas (contra MoC)
bash scripts/find-orphans.sh

# Solo contra el MoC (ignora backlinks)
bash scripts/find-orphans.sh --moc-only

# Incluir verificación de backlinks (quién enlaza a cada nota)
bash scripts/find-orphans.sh --backlinks

# Mostrar sugerencias de dónde enlazar cada huérfana
bash scripts/find-orphans.sh --sugerencias
```

### Funcionamiento

1. Escanea todos los `.md` del vault y los guarda en un **array asociativo** (O(1) lookup)
2. Extrae wikilinks del MoC en otro array asociativo
3. Opcionalmente, extrae todos los wikilinks de todas las notas (backlinks) con un solo `grep -roP`
4. Compara cada nota contra los enlaces existentes con lookup O(1), sin bucles anidados
5. Excluye: `Templates/`, `.obsidian/`, `scripts/`, `Log.md`, `MoC - Linux.md`, `README.md`, `CLAUDE.md`

> ⚡ **Optimizado**: de ~30s a **~6s** usando arrays asociativos en vez de bucles O(n×m).

### Sugerencias automáticas

Con `--sugerencias`, el script infiere en qué sección del MoC añadir cada huérfana según su carpeta:

| Carpeta | Sugerencia |
|---|---|
| `01 - Conceptos` | `## Fundamentos` |
| `07 - Comandos` | `## Terminal y comandos` |
| `11 - Distribuciones` | `## Distribuciones` |
| ... | ... |

---

## 6. add-modification-date.sh

**Ubicación:** `scripts/add-modification-date.sh`

Sincroniza el campo `fecha_modificacion` del frontmatter con la fecha de modificación real del archivo (`mtime`).

### Uso

```bash
# Actualizar todas las notas
bash scripts/add-modification-date.sh
```

### Funcionamiento

1. Recorre todos los `.md` del vault
2. Salta archivos sin frontmatter (CLAUDE.md, README.md)
3. Obtiene `mtime` del archivo con `date -r`
4. Si ya tiene `fecha_modificacion:` → la actualiza con `perl -i -pe` (más rápido que `sed -i`)
5. Si no tiene → la añade después de `fecha_creacion:` con `perl -i -pe`

> ⚡ **Optimizado**: de ~23s a ~12s usando perl en vez de sed para edición in-place.

### Automatización recomendada

```bash
# Ejecución semanal vía cron (domingos 8:00)
0 8 * * 0 /ruta/completa/scripts/add-modification-date.sh

# O como hook pre-commit (opcional)
# Añadir a .githooks/pre-commit:
# bash 10 - Automatizacion\ y\ Scripts/scripts/add-modification-date.sh
```

---

## Configuración cron recomendada

Para mantener el vault actualizado automáticamente:

```bash
# Editar crontab
crontab -e

# Añadir estas líneas:
# ┌─ minuto  │  hora  │  día mes  │  mes  │  día semana
# ↓
0 8 * * 0 /ruta/completa/scripts/add-modification-date.sh    # Dom 08:00 — fechas
0 9 * * 0 /ruta/completa/scripts/vault-stats-weekly.sh       # Dom 09:00 — stats
```

> **Nota**: Reemplazar `/ruta/completa/` con la ruta absoluta del vault.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `check-frontmatter.sh` tarda >0.5s | Escanea 516 archivos | Normal. El script está optimizado con awk single-pass (~0.4s) |
| `find-orphans.sh` marca README.md como huérfana | README.md no está en el MoC | Es correcto — README.md es el índice del repo, no una nota de contenido |
| `add-modification-date.sh` no actualiza CLAUDE.md | CLAUDE.md no tiene frontmatter | Es correcto — CLAUDE.md no es una nota de contenido |
| `daily-log.sh` dice que ya existe | Ya creaste un log hoy | Se abre el log existente para editar — no hay duplicados |

## Ver también

- [[Log]] — registro cronológico de sesiones del vault
- [[CLAUDE.md]] — reglas y convenciones del vault
- [[Git hooks]] — automatización pre-commit/commit-msg/pre-push
- [[Cron]] · [[systemd timers]] — automatización programada

#automatizacion #scripts
