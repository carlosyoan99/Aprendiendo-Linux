---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
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
# Flatpak (recomendado, sandbox + siempre actualizado)
flatpak install flathub org.onlyoffice.desktopeditors

# Debian/Ubuntu (repo oficial)
wget -qO- https://download.onlyoffice.com/repo/onlyoffice.gpg | sudo gpg --dearmor -o /usr/share/keyrings/onlyoffice.gpg
echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main" | sudo tee /etc/apt/sources.list.d/onlyoffice.list
sudo apt update && sudo apt install onlyoffice-desktopeditors

# Fedora (repo oficial)
sudo dnf config-manager --add-repo https://download.onlyoffice.com/repo/fedora/onlyoffice.repo
sudo dnf install onlyoffice-desktopeditors

# Arch / AUR
yay -S onlyoffice-bin
```

También hay paquete **Snap** (`sudo snap install onlyoffice-desktopeditors`) y .deb/.rpm directos en [onlyoffice.com/download-desktop.aspx](https://www.onlyoffice.com/download-desktop.aspx).

## Uso desde la terminal

```bash
# Lanzar un editor concreto
onlyoffice-desktopeditors        # selector de tipo de documento
desktopeditors --doc             # forzar editor de documentos
desktopeditors --xls             # hoja de cálculo
desktopeditors --ppt             # presentación

# Abrir un archivo directamente
onlyoffice-desktopeditors ~/Documentos/informe.docx

# Convertir documentos sin abrir la GUI (solo en la edición Enterprise/Docs):
# (la versión desktop no incluye CLI de conversión; usar la Docs Community para headless)
```

## Ventajas

- Mejor compatibilidad OOXML del mercado (⭐⭐⭐⭐⭐)
- Interfaz moderna, limpia y familiar
- Colaboración en tiempo real y edición concurrente
- Ligera (~300 MB)
- Licencia **AGPL** (libre)
- Editor de formularios y PDF integrados
- **Plugins** instalables (traducción, OCR, conectores a servicios)

## Desventajas

- Sin base de datos integrada (a diferencia de componentes de otras suites)
- Macros más limitadas que en LibreOffice (BASIC/JS)
- Menos funcionalidades "extra" que suites maduras
- Interfaz Electron: mayor consumo de RAM que LibreOffice en documentos grandes

## Integración con la nube

OnlyOffice Desktop se conecta a servicios de almacenamiento para abrir/guardar remoto:

- **Nextcloud/ownCloud**: ajustes → *Almacenamiento conectado* → Nextcloud (WebDAV).
- **Seafile / WebDAV genérico**: añadir cuenta con URL WebDAV.
- **OneDrive / Google Drive** (vía cuenta OnlyOffice).
- La colaboración en tiempo real completa requiere **OnlyOffice Docs** (servidor) — el desktop solo edita localmente contra el servidor.

## Atajos útiles (similares a MS Office)

| Atajo | Efecto |
|---|---|
| `Ctrl+Shift+S` | Guardar como |
| `Ctrl+F` | Buscar |
| `Ctrl+H` | Reemplazar |
| `Alt+Shift+X` | Insertar comentario |
| `Ctrl+K` | Insertar hipervínculo |
| `Ctrl+Z` / `Ctrl+Y` | Deshacer / rehacer |
| `Ctrl+E` / `Ctrl+L` / `Ctrl+J` / `Ctrl+Shift+J` | Alinear centro / izquierda / justificar / derecha |
| `Ctrl+B` / `Ctrl+I` / `Ctrl+U` | Negrita / cursiva / subrayado |
| `F7` | Revisión ortográfica |
| `Ctrl+S` | Guardar |

## Comparativa con alternativas

| Aspecto | OnlyOffice | LibreOffice | WPS Office |
|---|---|---|---|
| **Compatibilidad OOXML** | Máxima | Alta | Máxima |
| **Licencia** | Libre (AGPL) | Libre (LGPL) | Propietaria |
| **Colaboración real** | Sí (conectada) | Parcial | Nube |
| **Peso** | ~300 MB | ~500 MB | ~200 MB |
| **Macros** | Básicas (JS) | Potentes (BASIC) | Limitadas |

**Cuándo elegir cada una**: OnlyOffice si la fidelidad con Office 365 es lo prioritario (trabajo con gente que usa .docx/.xlsx a diario); LibreOffice si necesitas macros potentes y máxima personalización; WPS si quieres interfaz clónica de MS Office a costa del software libre.

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| La hoja de cálculo se bloquea en fórmulas complejas | Rendimiento en conjuntos grandes | Vincular a Excel/LibreOffice para datos masivos |
| Las macros no se ejecutan | Formato/macros limitadas | Usar [[LibreOffice]] para macros potentes |
| No conecta con Nextcloud | Credenciales WebDAV o app password | Generar app password en Nextcloud; verificar URL WebDAV |
| Fuentes se ven raras en .docx | Faltan fuentes del documento | Instalar `ttf-mscorefonts-installer` o liberar con `ms-fontfix` |
| Ventana en blanco al abrir | Problema de GPU/Electron | Lanzar con `--disable-gpu` o actualizar drivers |
| Guardar en nube falla | Sesión caducada | Re-conectar la cuenta en Almacenamiento conectado |

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
- [[Atajos de teclado - LibreOffice]] — atajos de la suite libre

#programa #ofimatica