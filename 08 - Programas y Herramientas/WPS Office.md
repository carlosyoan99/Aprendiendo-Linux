---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
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

# Fedora — descargar .rpm desde la web oficial
# (no hay repo oficial; usar los paquetes de wps.com)

# Flatpak (soporte comunitario)
flatpak install flathub com.wps.Office

# Diccionarios / interfaz en español (Arch)
yay -S wps-office-mui-spanish                     # interfaz en español
yay -S wps-office-extension-spanish-dictionary    # corrector ortográfico
```

## Uso desde la terminal

```bash
wps                  # procesador de textos (Writer)
et                   # hoja de cálculo (Spreadsheets)
wpp                  # presentaciones
wpspdf               # visor PDF

# Abrir un archivo directamente
wps ~/Documentos/informe.docx
et ~/Datos/presupuesto.xlsx
```

Las integraciones de escritorio (asociar .docx a wps, iconos, mime types) se instalan con el paquete `wps-office-mime` en Arch, o automáticamente con el .deb/.rpm.

## Configuración

- **Idioma y diccionarios**: se instalan como paquetes separados (`wps-office-mui-*`, `wps-office-extension-*-dictionary`).
- **Fuentes**: WPS usa las fuentes del sistema; para fidelidad con documentos MS Office conviene instalar `ttf-mscorefonts-installer` (Debian/Ubuntu) o `ttf-ms-fonts` (Arch, AUR).
- **Modo oscuro y tema**: Ajustes → Apariencia (estilo similar a MS Office 2013/2016/2019).
- **Cuenta WPS**: algunos ajustes de nube y colaboración requieren iniciar sesión; el uso local funciona sin cuenta.

## Ventajas

- Interfaz muy familiar para usuarios de MS Office
- Rápida y ligera (~200 MB)
- Excelente compatibilidad OOXML
- Buen manejo de PDF (ver, convertir a Word/Excel/PowerPoint)

## Desventajas

- **Propietaria** (código cerrado)
- Anuncios en la versión gratuita
- Requiere cuenta WPS para algunas funciones (cloud, colaboración)
- Disponible en AUR, pero no en repos oficiales
- Menos integración con servicios Linux (sin portal de colaboración real)

## Comparativa con alternativas

| Aspecto | WPS Office | OnlyOffice | LibreOffice |
|---|---|---|---|
| **Interfaz MS Office** | Muy similar | Similar | Propia |
| **Compatibilidad OOXML** | Máxima | Máxima | Alta |
| **Licencia** | Propietaria | Libre (AGPL) | Libre (LGPL) |
| **Anuncios** | Sí (gratis) | No | No |
| **Macros** | Limitadas | Básicas (JS) | Potentes (BASIC) |
| **Peso** | ~200 MB | ~300 MB | ~500 MB |

**Cuándo elegir cada una**: WPS si vienes de Windows y quieres la transición más suave posible (y aceptas el cierre de código); OnlyOffice si la fidelidad OOXML es lo importante y prefieres software libre; LibreOffice si necesitas macros, máximo control y ecosistema 100 % abierto.

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| Interfaz en inglés | Falta paquete de idioma | Instalar `wps-office-mui-spanish` (o .deb de idioma) |
| Fuentes de documentos se ven raras | Faltan fuentes propietarias | Instalar paquetes `ttf-mscorefonts` o equivalentes libres |
| Anuncios persistentes | Versión gratuita | Configurar en ajustes o valorar suite libre |
| No abre archivos con doble clic | Asociaciones de MIME no instaladas | Instalar `wps-office-mime` (Arch) o reinstalar .deb/.rpm |
| Hoja de cálculo lenta con muchos datos | Optimización por tamaño | Usar LibreOffice Calc o OnlyOffice para conjuntos grandes |
| WPS se cierra en Wayland | Problemas de ventana/GPU | Ejecutar con variable de sesión X11 (`env XDG_SESSION_TYPE=x11`) o actualizar |

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
- [[Atajos de teclado - LibreOffice]] — atajos de la suite libre

#programa #ofimatica