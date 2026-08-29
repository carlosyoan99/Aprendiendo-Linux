---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: Propietaria (gratis)
alternativas: [[LibreOffice]], [[OnlyOffice]], [[WPS Office]]
---

# FreeOffice

> Versión gratuita de SoftMaker Office: interfaz clásica, compatible con formatos de MS Office y sin coste de licencia.

## Qué es

**FreeOffice** es la edición gratuita de **SoftMaker Office**, la suite ofimática de la empresa alemana SoftMaker. Ofrece una **interfaz clásica** (con opción de cintas estilo Microsoft) y una **excelente compatibilidad** con los formatos `.docx`, `.xlsx` y `.pptx`. A diferencia de las suites libres, FreeOffice se distribuye gratis pero bajo licencia **propietaria (freemium)**; la versión de pago (SoftMaker Office) añade funciones avanzadas como corrección ortográfica en más idiomas, diccionarios, y herramientas de mayor profundidad.

## Componentes

- **TextMaker** — procesador de textos
- **PlanMaker** — hoja de cálculo
- **Presentations** — presentaciones / diapositivas

## Instalación

```bash
# Desde la web oficial (instalador .deb / .rpm por distribución)
# https://www.freeoffice.com/en/download
# Tras instalar el .deb, se registra con:
softmaker-freeoffice --register
```

> No suele estar en los repositorios de las distribuciones; se descarga el instalador desde el sitio oficial.

## Configuración básica

- Al primer inicio hay que **seleccionar el perfil de interfaz** (clásica o cinta estilo MS Office).
- El idioma de la interfaz y de la corrección se configura desde el diálogo de opciones de cada aplicación.
- Se pueden configurar los formatos por defecto (ODF u OOXML) en la configuración.

## Atajos / uso

| Función | Efecto |
|---|---|
| `Ctrl+N / O / S` | Nuevo / abrir / guardar |
| `F1` | Ayuda contextual |
| Cinta / menú clásico | Según perfil de interfaz elegido |

## Comparativa con alternativas

| Aspecto | FreeOffice | LibreOffice | OnlyOffice | WPS Office |
|---|---|---|---|---|
| **Licencia** | Propietaria (gratis) | Libre (LGPL) | Libre (AGPL) | Propietaria |
| **Compatibilidad OOXML** | Muy alta | Alta | Máxima | Máxima |
| **Peso** | ~400 MB | ~500 MB | ~300 MB | ~200 MB |
| **Código abierto** | No | Sí | Sí | No |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| La versión gratuita no activa el corrector | Idioma no incluido | Usar SoftMaker Office de pago o descargar diccionarios |
| Diferencia de fuentes con MS Office | Fuentes propietarias ausentes | Instalar fuentes como *Carlito* / *Caladea* (equivalentes libres) |

## Notas y advertencias

- FreeOffice es **propietario**: no cumple criterios de software 100 % libre; si eso importa, usa [[LibreOffice]].
- Su mayor baza es la **fidelidad de renderizado** con documentos de MS Office sin depender de la nube.

## Enlaces externos

- [Sitio oficial](https://www.freeoffice.com/)
- [Wikipedia — FreeOffice](https://en.wikipedia.org/wiki/SoftMaker_Office#FreeOffice)

## Ver también

- [[LibreOffice]] — suite libre por defecto
- [[OnlyOffice]] — suite libre con mejor compatibilidad OOXML
- [[WPS Office]] — alternativa propietaria
- [[Suite de Oficina]] — índice + comparativa

#programa #ofimatica
