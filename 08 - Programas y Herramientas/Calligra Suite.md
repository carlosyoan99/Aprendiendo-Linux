---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# Calligra Suite

Suite ofimática libre del proyecto KDE. Incluye procesador de textos (Words), hoja de cálculo (Sheets), presentaciones (Stage), base de datos (Kexi) y más aplicaciones creativas.

## Componentes

| Aplicación | Propósito | Binario |
|---|---|---|
| **Words** | Procesador de textos similar a Word | `calligrawords` |
| **Sheets** | Hoja de cálculo similar a Excel | `calligrasheets` |
| **Stage** | Presentaciones similar a PowerPoint | `calligrastage` |
| **Kexi** | Base de datos visual (MS Access-like) | `kexi` |
| **Plan** | Gestión de proyectos (Gantt) | `calligraplan` |
| **Braindump** | Notas y mapas mentales | `braindump` |
| **Gemini** | Visor de documentos (PDF, mobi, ePub) | `okular` parte de KDE |

## Instalación

```bash
# Arch (completa)
sudo pacman -S calligra

# Debian/Ubuntu (componentes por separado)
sudo apt install calligrawords calligrasheets calligrastage kexi

# Fedora
sudo dnf install calligra
```

Se pueden instalar solo las aplicaciones que se necesiten (no es necesario instalar toda la suite).

## Primeros pasos

```bash
# Lanzar componentes individuales
calligrawords documento.odt     # Abrir documento
calligrasheets hoja.ods         # Abrir hoja de cálculo
kexi proyecto.kexi              # Abrir base de datos
```

## Características

- **Aplicaciones independientes**: no necesitas instalar toda la suite
- **Formato nativo ODF** (OpenDocument)
- **Integración KDE**: plasma-workspace, KIO, Akonadi, Dolphin
- **Ligera**: ~200 MB completa, componentes individuales ~40-60 MB
- **Compatibilidad básica** con formatos MS Office (.docx, .xlsx, .pptx)
- **Múltiples idiomas**: interfaz traducida a 30+ idiomas

## Ventajas

- Excelente integración con KDE Plasma (iconos, atajos, temas)
- App por separado: instalas solo lo que usas
- Aplicaciones especializadas: Kexi (bases de datos) y Plan (proyectos) no tienen equivalente directo en LibreOffice

## Desventajas

- Menor compatibilidad con formatos MS Office que LibreOffice
- Menos usuarios → menos tutoriales y comunidades
- Algunas apps (Braindump, Plan) reciben menos desarrollo
- Renderizado de documentos complejos inferior a LibreOffice

## Ver también

- [[LibreOffice]] — suite libre por defecto
- [[Suite de Oficina]] — índice + comparativa
- [[KDE Plasma]] — DE asociado

## Enlaces externos

- [Sitio oficial](https://calligra.org/)
- [Wikipedia — Calligra Suite](https://en.wikipedia.org/wiki/Calligra_Suite)
- [Repositorio KDE — Calligra](https://invent.kde.org/office/calligra)

#programa #ofimatica
