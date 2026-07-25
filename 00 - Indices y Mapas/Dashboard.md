---
fecha_creacion: 2026-07-18
estado: en progreso
categoria: indice
---

# Dashboard (requiere plugin Dataview)

**Este dashboard es automático** — cualquier nota nueva que siga el frontmatter y hashtags definidos en `CLAUDE.md` aparece aquí sin editar este archivo.

---

## 📊 Resumen del vault

| Métrica | Total |
|---|---|
| Notas totales | **314** |
| Estado **resuelto** | 309 |
| Estado **en progreso** | 4 (TODO, MoC, Dashboard, Log) |
| Estado **borrador** | 0 (falsos positivos en CLAUDE.md y Log.md que contienen la palabra en su texto) |
| Prioridad **alta** | 153 |
| Prioridad **media** | 105 |
| Prioridad **baja** | 51 |

### Por categoría

| Categoría | Notas |
|---|---|
| Comando | 68 |
| Programa | 70 |
| Concepto | 36 |
| Distribución | 40 |
| Sistema | 29 |
| Entorno / WM | 27 |
| Troubleshooting | 16 |
| Índice | 12 |
| Instalación | 9 |
| Terminal | 4 |
| Automatización | 3 |
| Log | 1 |

---

## 🎯 Prioridad alta (empezar por aquí)

```dataview
TABLE categoria as "Categoría", estado as "Estado", file.folder as "Carpeta"
FROM -"Templates"
WHERE prioridad = "alta" AND estado != "log" AND categoria != "indice"
SORT estado ASC, categoria ASC
```

---

## 🚧 En progreso (necesitan ser completadas)

```dataview
TABLE categoria as "Categoría", prioridad as "Prioridad", file.mtime as "Modificada"
FROM -"Templates"
WHERE estado = "en progreso"
SORT prioridad ASC, file.mtime DESC
```

---

## ✅ Resueltas — por categoría

### 🐧 Todas las distribuciones

```dataview
TABLE gestor_paquetes as "Gestor", base as "Base", prioridad as "Prioridad"
FROM #distro
SORT file.name ASC
```

### 🖥️ Entornos de escritorio y Window Managers

```dataview
TABLE tipo as "Tipo", prioridad as "Prioridad", file.folder as "Carpeta"
FROM #entorno-escritorio
SORT tipo ASC, file.name ASC
```

### 💡 Conceptos fundamentales

```dataview
TABLE prioridad as "Prioridad", estado as "Estado"
FROM #concepto
SORT prioridad ASC, file.name ASC
```

### ⚙️ Sistema

```dataview
TABLE prioridad as "Prioridad", estado as "Estado"
FROM #sistema
SORT prioridad ASC, file.name ASC
```

### 📦 Programas y herramientas

```dataview
TABLE prioridad as "Prioridad", estado as "Estado"
FROM #programa
SORT prioridad ASC, file.name ASC
```

### ⌨️ Comandos documentados

```dataview
LIST
FROM #comando
SORT file.name ASC
```

### 🛠️ Troubleshooting (problemas resueltos)

```dataview
TABLE sistema as "Sistema", prioridad as "Prioridad"
FROM #troubleshooting
WHERE estado = "resuelto"
SORT prioridad ASC, file.name ASC
```

### 📥 Instalación y configuración

```dataview
TABLE prioridad as "Prioridad", estado as "Estado"
FROM #instalacion
SORT prioridad ASC, file.name ASC
```

### 🔧 Automatización

```dataview
LIST
FROM #automatizacion
SORT file.name ASC
```

### 🖥️ Terminal

```dataview
TABLE prioridad as "Prioridad", estado as "Estado"
FROM #terminal
SORT file.name ASC
```

---

## 📅 Notas modificadas recientemente (últimos 14 días)

```dataview
TABLE file.mtime as "Modificada", categoria as "Categoría"
FROM -"Templates"
WHERE file.mtime >= date(today) - dur(14 days)
SORT file.mtime DESC
LIMIT 20
```

---

## 📈 Notas por prioridad

### Alta (153 notas)

```dataview
TABLE categoria as "Categoría", estado as "Estado"
FROM -"Templates"
WHERE prioridad = "alta" AND categoria != "indice"
SORT categoria ASC
```

### Media (105 notas)

```dataview
TABLE categoria as "Categoría", estado as "Estado"
FROM -"Templates"
WHERE prioridad = "media"
SORT estado ASC, categoria ASC
```

### Baja (51 notas)

```dataview
TABLE categoria as "Categoría", estado as "Estado"
FROM -"Templates"
WHERE prioridad = "baja"
SORT categoria ASC
```

## Enlaces externos

- [Obsidian Dataview plugin](https://blacksmithgu.github.io/obsidian-dataview/) — documentación oficial
- [Obsidian — Community plugins](https://obsidian.md/plugins)

---

## 📋 Ver también

- [[Rutas de Aprendizaje]] — qué priorizar en cada categoría
- [[MoC - Linux]] — mapa de contenido completo

#indice #dashboard
