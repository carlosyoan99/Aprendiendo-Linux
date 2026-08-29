---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
---

# Suite de Oficina — Índice

Las suites ofimáticas son conjuntos de aplicaciones para productividad: procesador de textos, hoja de cálculo, presentaciones, y a veces base de datos, diagramas o edición de fórmulas.

## Qué es una suite ofimática

Una suite ofimática agrupa las herramientas básicas de oficina en una aplicación única, con un formato de archivo compartido y una interfaz coherente. Los componentes habituales son:

- **Procesador de textos** (documentos)
- **Hoja de cálculo** (cálculos y datos)
- **Presentaciones** (diapositivas)
- **Base de datos** (opcional)
- **Diagramas / dibujo** (opcional)
- **Editor de fórmulas** (a menudo integrado)

## Comparativa de suites

| Suite | Licencia | Peso | Compatibilidad OOXML | Nativa Linux |
|---|---|---|---|---|
| [[LibreOffice]] | Libre (LGPL) | ~500 MB | ⭐⭐⭐⭐ | ✅ |
| [[OnlyOffice]] | Libre (AGPL) | ~300 MB | ⭐⭐⭐⭐⭐ | ✅ |
| [[WPS Office]] | Propietaria | ~200 MB | ⭐⭐⭐⭐⭐ | ✅ |
| [[FreeOffice]] | Propietaria (gratis) | ~400 MB | ⭐⭐⭐⭐ | ✅ |
| [[Calligra Suite]] | Libre (GPL) | ~200 MB | ⭐⭐⭐ | ✅ |
| [[AbiWord]] + [[Gnumeric]] | Libre (GPL) | ~15 MB | ⭐⭐ | ✅ |
| **Google Docs / Sheets** | Cloud | Navegador | ⭐⭐⭐⭐ | 🌐 |
| **Microsoft 365** | Suscripción | Navegador | ⭐⭐⭐⭐⭐ | 🌐 |

## ¿Cuál elegir?

| Si buscas... | Recomendación |
|---|---|
| Software 100% libre | [[LibreOffice]] |
| Máxima compatibilidad con .docx/.xlsx | [[OnlyOffice]] |
| Interfaz similar a MS Office | [[WPS Office]] |
| Ligereza (hardware limitado) | [[AbiWord]] + [[Gnumeric]] |
| Trabajo colaborativo online | Google Docs (en navegador) |
| Uso profesional/empresarial | [[OnlyOffice]] |

## Formato de archivos

- **ODF (` .odt/.ods/.odp`)** — formato abierto estándar (ISO 26300), usado por defecto por LibreOffice.
- **OOXML (` .docx/.xlsx/.pptx`)** — formato de Microsoft; la compatibilidad varía según la suite.
- **Legacy (` .doc/.xls/.ppt`)** — formatos antiguos de Microsoft, todavía leídos por la mayoría de suites.

## Empaquetado en Linux

```bash
# LibreOffice (Debian/Ubuntu, Fedora, Arch)
sudo apt install libreoffice
sudo dnf install libreoffice
sudo pacman -S libreoffice-fresh

# OnlyOffice
flatpak install flathub org.onlyoffice.desktopeditors

# WPS Office (descarga desde la web oficial)

# AbiWord + Gnumeric (ligeros)
sudo apt install abiword gnumeric
```

## Consumo de recursos

| Suite | RAM media | Ideal para |
|---|---|---|
| LibreOffice | ~300-500 MB | Uso general completo |
| OnlyOffice | ~200-300 MB | Máxima compatibilidad |
| WPS Office | ~150-250 MB | Parecido visual a MS Office |
| AbiWord + Gnumeric | ~15 MB | Hardware muy limitado |
| Google Docs (navegador) | según pestaña | Colaboración online |

## Ver también

- [[LibreOffice]] — nota dedicada
- [[Navegadores Web]] — Google Docs y MS 365 en el navegador
- [[OnlyOffice]], [[WPS Office]], [[FreeOffice]], [[Calligra Suite]] — notas individuales

## Enlaces externos

- [Wikipedia — Office suite](https://en.wikipedia.org/wiki/Office_suite)
- [Wikipedia — Comparison of office suites](https://en.wikipedia.org/wiki/Comparison_of_office_suites)
- [Wikipedia — OpenDocument (ODF)](https://en.wikipedia.org/wiki/OpenDocument)

#programa #ofimatica
