---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: AGPL-3.0
alternativas: [[LibreOffice]], [[WPS Office]]
---

# OnlyOffice

> Suite ofimática moderna con la mejor compatibilidad OOXML: ideal donde la fidelidad con `.docx`/`.xlsx` es crítica.

## Qué es

**OnlyOffice** (antes *TeamLab Office*) es una suite ofimática escrita en **HTML5/JavaScript** con interfaz renderizada en el escritorio (vía Electron). Su gran ventaja es la **mejor compatibilidad OOXML del mercado** (⭐⭐⭐⭐⭐) entre las suites libres, siendo la más fiel a los documentos `.docx`, `.xlsx` y `.pptx`. Combina el procesador de textos, la hoja de cálculo y las presentaciones, además de un **componente de colaboración en tiempo real** y un editor de formularios/PDF.

## Instalación

```bash
# Flatpak (recomendado)
flatpak install flathub org.onlyoffice.desktopeditors

# Debian/Ubuntu (repo oficial)
sudo apt install onlyoffice-desktopeditors   # si se añade el repo
# O descargar .deb/.rpm desde:
# https://www.onlyoffice.com/download-desktop.aspx
```

## Ventajas

- Mejor compatibilidad OOXML del mercado (⭐⭐⭐⭐⭐)
- Interfaz moderna, limpia y familiar
- Colaboración en tiempo real y edición concurrente
- Ligera (~300 MB)
- Licencia **AGPL** (libre)
- Editor de formularios y PDF integrados

## Desventajas

- Sin base de datos integrada (a diferencia de componentes de otras suites)
- Macros más limitadas que en LibreOffice (BASIC/JS)
- Menos funcionalidades "extra" que suites maduras

## Atajos útiles (similares a MS Office)

| Atajo | Efecto |
|---|---|
| `Ctrl+Shift+S` | Guardar como |
| `Ctrl+F` | Buscar |
| `Ctrl+H` | Reemplazar |
| `Alt+Shift+X` | Insertar comentario |
| `Ctrl+K` | Insertar hipervínculo |

## Comparativa con alternativas

| Aspecto | OnlyOffice | LibreOffice | WPS Office |
|---|---|---|---|
| **Compatibilidad OOXML** | Máxima | Alta | Máxima |
| **Licencia** | Libre (AGPL) | Libre (LGPL) | Propietaria |
| **Colaboración real** | Sí (conectada) | Parcial | Nube |
| **Peso** | ~300 MB | ~500 MB | ~200 MB |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| La hoja de cálculo se bloquea en fórmulas complejas | Rendimiento en conjuntos grandes | Vincular a Excel/LibreOffice para datos masivos |
| Las macros no se ejecutan | Formato/macros limitadas | Usar [[LibreOffice]] para macros potentes |

## Notas y advertencias

- OnlyOffice es la elección recomendada en esta web para **trabajo profesional/empresarial** por su fidelidad de formato.
- Colaboración plena (documentos compartidos) requiere la versión servidor/cloud de OnlyOffice.

## Enlaces externos

- [Sitio oficial](https://www.onlyoffice.com/)
- [Wikipedia — OnlyOffice](https://en.wikipedia.org/wiki/OnlyOffice)
- [Arch Wiki — OnlyOffice](https://wiki.archlinux.org/title/OnlyOffice)

## Ver también

- [[LibreOffice]] — suite libre por defecto en Linux
- [[WPS Office]] — alternativa propietaria con interfaz MS Office
- [[Suite de Oficina]] — índice + comparativa

#programa #ofimatica
