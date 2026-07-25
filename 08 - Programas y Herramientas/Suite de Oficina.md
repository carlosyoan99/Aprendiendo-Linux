---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: programa
prioridad: baja
---

# Suite de Oficina

## Qué son

Las suites ofimáticas son conjuntos de aplicaciones para productividad: procesador de textos, hoja de cálculo, presentaciones, y a veces base de datos, diagramas o edición de fórmulas. En Linux hay múltiples opciones, desde software libre completo hasta alternativas propietarias o servicios cloud.

## Comparativa de suites

| Suite | Licencia | Peso | Compatibilidad MS Office | Nativa Linux |
|---|---|---|---|---|
| **[[LibreOffice]]** | Libre (LGPL) | ~500 MB | ⭐⭐⭐⭐ | ✅ Sí |
| **OnlyOffice** | Libre (AGPL) | ~300 MB | ⭐⭐⭐⭐⭐ | ✅ Sí |
| **WPS Office** | Propietaria (gratuita) | ~200 MB | ⭐⭐⭐⭐⭐ | ✅ Sí |
| **FreeOffice** (SoftMaker) | Propietaria (gratuita) | ~400 MB | ⭐⭐⭐⭐ | ✅ Sí |
| **Google Docs / Sheets** | Cloud (gratuito) | Navegador | ⭐⭐⭐⭐ | 🌐 Web |
| **Microsoft 365** | Propietaria (suscripción) | Navegador | ⭐⭐⭐⭐⭐ | 🌐 Web |
| **Calligra Suite** | Libre (GPL) | ~200 MB | ⭐⭐⭐ | ✅ Sí |
| **AbiWord + Gnumeric** | Libre (GPL) | ~15 MB | ⭐⭐ | ✅ Sí |

### OnlyOffice

Suite ofimática moderna con excelente compatibilidad con formatos MS Office. Escrita en HTML5/JS, funciona en Linux, Windows y macOS. Ideal para entornos donde la fidelidad con .docx/.xlsx es crítica.

```bash
# Instalación
flatpak install flathub org.onlyoffice.desktopeditors
# O descargar .deb/.rpm desde: https://www.onlyoffice.com/download-desktop.aspx
```

**Ventajas**: Mejor compatibilidad OOXML, interfaz moderna, colaboración en tiempo real.
**Desventajas**: Menos funcionalidades que LibreOffice (sin base de datos, sin macros potentes).

### WPS Office

Suite propietaria china con interfaz muy similar a Microsoft Office 2013-2019. Compatibilidad OOXML excelente. La versión gratuita incluye anuncios (configurables).

```bash
# Instalación (Arch)
yay -S wps-office
# O descargar .deb desde: https://www.wps.com/

# Diccionarios en español
yay -S wps-office-mui-spanish            # interfaz en español
yay -S wps-office-extension-spanish-dictionary  # corrector
```

**Ventajas**: Interfaz familiar para usuarios de MS Office, muy rápida.
**Desventajas**: Propietaria, anuncios en versión gratuita, requiere cuenta WPS para algunas funciones.

### FreeOffice (SoftMaker)

Versión gratuita de SoftMaker Office. Interfaz clásica, compatible con formatos MS Office.

```bash
# Descargar desde: https://www.freeoffice.com/en/download
# .deb o .rpm disponible
```

### Google Docs / Microsoft 365

Ambos funcionan perfectamente en navegadores Linux (Firefox, Chromium). No requieren instalación. Google Docs funciona offline con la extensión adecuada.

## ¿Cuál elegir?

| Si buscas... | Recomendación |
|---|---|
| Software 100% libre | **LibreOffice** |
| Máxima compatibilidad con .docx/.xlsx | **OnlyOffice** |
| Interfaz similar a MS Office | **WPS Office** |
| Ligereza (hardware limitado) | **AbiWord + Gnumeric** o **OnlyOffice** |
| Trabajo colaborativo online | **Google Docs** (en Firefox/Chromium) |
| Uso profesional/empresarial | **OnlyOffice** o **MS 365** (web) |

## Ver también

- [[LibreOffice]] — la suite por defecto en Linux (nota dedicada)
- [[Navegadores Web]] — Google Docs y MS 365 funcionan en el navegador

## Enlaces externos

- [Wikipedia — Office suite](https://en.wikipedia.org/wiki/Office_suite)
- [Wikipedia — Comparison of office suites](https://en.wikipedia.org/wiki/Comparison_of_office_suites)

#programa #ofimatica
