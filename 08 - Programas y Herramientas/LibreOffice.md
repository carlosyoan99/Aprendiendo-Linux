---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# LibreOffice

## Qué es

LibreOffice es una suite ofimática libre, sucesora de OpenOffice.org tras la adquisición de Sun Microsystems por Oracle en 2010. Es el estándar ofimático en la mayoría de distribuciones Linux y compatible con formatos de Microsoft Office (.docx, .xlsx, .pptx), aunque la fidelidad de formato puede variar en documentos complejos con macros o estilos avanzados.

Viene **preinstalado por defecto** en Ubuntu, Debian, Linux Mint, Fedora Workstation y la mayoría de distros de escritorio.

## Componentes

| Módulo | Nombre | Equivalente MS Office | Extensión por defecto |
|---|---|---|---|
| **Writer** | Procesador de textos | Word | .odt |
| **Calc** | Hoja de cálculo | Excel | .ods |
| **Impress** | Presentaciones | PowerPoint | .odp |
| **Base** | Base de datos | Access | .odb |
| **Draw** | Diagramas y dibujo vectorial | Visio | .odg |
| **Math** | Editor de fórmulas matemáticas | — | .odf |

## Instalación

```bash
# Ya viene preinstalado en la mayoría de distros de escritorio
# Si no:
sudo apt install libreoffice              # Debian/Ubuntu (instala el grupo completo)
sudo pacman -S libreoffice-fresh          # Arch (versión más reciente)
sudo pacman -S libreoffice-still          # Arch (versión estable)
sudo dnf install libreoffice              # Fedora
sudo dnf groupinstall \"Office Suite\"      # Fedora (grupo completo)

# Solo componentes específicos
sudo apt install libreoffice-writer       # solo Writer
sudo pacman -S libreoffice-calc           # solo Calc

# Versión Flatpak (entorno aislado, recomendada para distros rolling)
flatpak install flathub org.libreoffice.LibreOffice
```

## Instalación de idioma español

```bash
# Paquetes de idioma
sudo apt install libreoffice-l10n-es      # Debian/Ubuntu
sudo pacman -S libreoffice-fresh-es       # Arch
sudo dnf install libreoffice-langpack-es  # Fedora

# Corrector ortográfico
sudo apt install hunspell-es              # Debian/Ubuntu
sudo pacman -S hunspell-es                # Arch
sudo dnf install hunspell-es              # Fedora
```

## Atajos de teclado esenciales

| Atajo | Acción |
|---|---|
| `Ctrl+Z` / `Ctrl+Y` | Deshacer / Rehacer |
| `Ctrl+B` / `Ctrl+I` / `Ctrl+U` | Negrita / Cursiva / Subrayado |
| `Ctrl+S` | Guardar |
| `Ctrl+Shift+S` | Guardar como |
| `Ctrl+P` | Imprimir |
| `Ctrl+F` | Buscar |
| `Ctrl+H` | Buscar y reemplazar |
| `F7` | Corrector ortográfico |
| `F12` | Numeración |
| `Ctrl+L` | Viñetas |
| `Ctrl+Shift+P` | Superíndice |
| `Ctrl+Shift+B` | Subíndice |
| `Ctrl+Enter` | Salto de página |
| `F5` | Navegador (índice, imágenes, tablas) |
| `Ctrl+Shift+F5` | Editor de estilos |

## Integración con Microsoft Office

| Formato | Compatibilidad | Notas |
|---|---|---|
| **.docx** (Word) | ✅ Buena | Puede perder formato complejo, tablas anidadas, márgenes |
| **.xlsx** (Excel) | ✅ Buena | Tablas dinámicas y macros VBA no son compatibles |
| **.pptx** (PowerPoint) | ⚠️ Parcial | Animaciones complejas y transiciones pueden perderse |
| **.doc** (Word legacy) | ✅ Excelente | Mejor compatibilidad que con .docx |
| **Archivos con macros** | ⚠️ Parcial | Las macros VBA no funcionan, reescribir con LibreOffice Basic |

Para máxima compatibilidad, **usar formatos ODF** (.odt, .ods, .odp) y exportar a PDF para compartir.

## Personalización

```bash
# Temas visuales (iconos)
# Herramientas → Opciones → LibreOffice → Ver → Estilo de iconos
# Opciones: Automático, Breeze, Colibre, Elementary, Karasa Jaga, Sifr

# Instalar más temas de iconos
sudo apt install libreoffice-style-breeze libreoffice-style-colibre
```

## Alternativas ligeras

Si LibreOffice es demasiado pesado para tu equipo:

| Alternativa | Peso | Compatibilidad MS Office |
|---|---|---|
| **AbiWord** + **Gnumeric** | Muy ligero (~10 MB) | Básica |
| **OnlyOffice Desktop Editors** | Medio (~300 MB) | Excelente |
| **WPS Office** | Medio (~200 MB) | Excelente (no libre) |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Arranque muy lento / bloquea | Perfil corrupto o índice | Borrar/resetear `~/.config/libreoffice` y `~/.config/.libreoffice` temporalmente |
| Fuentes se ven raras en docs | Fuentes MS ausentes | Instalar `ttf-mscorefonts-installer` |
| No guarda en formatos MS | Falta filtro completo | Instalar variantes completas (`libreoffice-full`) |
| No abre .docx/.xlsx correctamente | Compatibilidad de filtros | Actualizar LibreOffice; usar el modo de compatibilidad |
| `soffice` desde CLI no convierte | Headless flag | `soffice --headless --convert-to pdf archivo` |

## Ver también

- [[Suite de Oficina]] — visión general y alternativas
- [[Impresión (CUPS)]] — imprimir documentos desde LibreOffice

## Enlaces externos

- [Wikipedia — LibreOffice](https://en.wikipedia.org/wiki/LibreOffice)
- [Sitio oficial — LibreOffice](https://www.libreoffice.org/)
- [GitHub — LibreOffice/core](https://github.com/LibreOffice/core)

#programa #ofimatica
