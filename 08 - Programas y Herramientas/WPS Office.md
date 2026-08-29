---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: Propietaria (gratis con anuncios)
alternativas: [[LibreOffice]], [[OnlyOffice]]
---

# WPS Office

> Suite ofimática propietaria de origen chino, con interfaz muy similar a Microsoft Office y excelente compatibilidad OOXML.

## Qué es

**WPS Office** (antes *Kingsoft Office*) es una suite ofimática **propietaria** de origen chino. Su principal atractivo es una **interfaz casi idéntica a Microsoft Office** (2013-2019), lo que facilita la transición a quien viene de Windows. Ofrece **excelente compatibilidad OOXML** y un peso reducido (~200 MB). La versión gratuita incluye **anuncios** (parcialmente configurables) y algunas funciones requieren cuenta WPS.

## Componentes

- **Writer** — procesador de textos
- **Spreadsheets** — hoja de cálculo
- **Presentation** — presentaciones / diapositivas
- **PDF** — visor/conversor

## Instalación

```bash
# Arch (AUR — no está en repos oficiales)
yay -S wps-office

# Debian/Ubuntu — descargar .deb desde:
# https://www.wps.com/

# Diccionarios / interfaz en español (Arch)
yay -S wps-office-mui-spanish                     # interfaz en español
yay -S wps-office-extension-spanish-dictionary    # corrector ortográfico
```

## Ventajas

- Interfaz muy familiar para usuarios de MS Office
- Rápida y ligera (~200 MB)
- Excelente compatibilidad OOXML
- Buen manejo de PDF

## Desventajas

- **Propietaria** (código cerrado)
- Anuncios en la versión gratuita
- Requiere cuenta WPS para algunas funciones (cloud, colaboración)
- Disponible en AUR, pero no en repos oficiales

## Comparativa con alternativas

| Aspecto | WPS Office | OnlyOffice | LibreOffice |
|---|---|---|---|
| **Interfaz MS Office** | Muy similar | Similar | Propia |
| **Compatibilidad OOXML** | Máxima | Máxima | Alta |
| **Licencia** | Propietaria | Libre (AGPL) | Libre (LGPL) |
| **Anuncios** | Sí (gratis) | No | No |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| Interfaz en inglés | Falta paquete de idioma | Instalar `wps-office-mui-spanish` (o .deb de idioma) |
| Fuentes de documentos se ven raras | Faltan fuentes propietarias | Instalar paquetes `ttf-mscorefonts` o equivalentes libres |
| Anuncios persistentes | Versión gratuita | Configurar en ajustes o valorar suite libre |

## Notas y advertencias

- Al ser **propietario**, no cumple criterios de software libre; si eso importa, usa [[LibreOffice]].
- Compatible con documentos de MS Office con alta fidelidad, ideal si trabajas con gente que usa Office.

## Enlaces externos

- [Sitio oficial](https://www.wps.com/)
- [Wikipedia — WPS Office](https://en.wikipedia.org/wiki/WPS_Office)
- [Arch Wiki — WPS Office](https://wiki.archlinux.org/title/WPS_Office)

## Ver también

- [[LibreOffice]] — suite libre por defecto
- [[OnlyOffice]] — suite libre con mejor compatibilidad OOXML
- [[Suite de Oficina]] — índice + comparativa

#programa #ofimatica
