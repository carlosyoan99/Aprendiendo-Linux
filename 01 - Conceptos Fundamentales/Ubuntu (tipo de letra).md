---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: baja
---

# Ubuntu (tipo de letra)

## Definición

La **tipografía Ubuntu** es una familia tipográfica **sans-serif humanística** diseñada por la fundidora **Dalton Maag** bajo patrocinio de **Canonical Ltd.** Se introdujo como la fuente predeterminada del sistema operativo Ubuntu a partir de la versión 10.10 (Maverick Meerkat), reemplazando la tipografía Bitstream Vera.

Es una de las señas de identidad visual más reconocibles de Ubuntu, junto con el círculo naranja de su logo.

## Características tipográficas

| Aspecto | Detalle |
|---|---|
| **Clasificación** | Sans-serif humanística (basada en el modelo Vox-ATypI) |
| **Diseñador** | Dalton Maag (Londres) |
| **Lanzamiento** | Septiembre de 2010 (beta), octubre de 2010 (estable) |
| **Cobertura Unicode** | Latina extendida A y B, griego politónico, cirílico extendido |
| **Licencia** | Ubuntu Font Licence (basada en SIL OFL) |
| **Optimizada para** | Pantallas (espaciado ajustado para tamaños de texto de cuerpo) |

Curiosidad: fue la primera tipografía predeterminada de un sistema operativo en incluir el **símbolo de la rupia india** (₹).

## Ubuntu Font Licence (UFL)

La licencia UFL está basada en la **SIL Open Font License** (OFL) y es una licencia **copyleft** que permite:

- ✅ Usar la tipografía en cualquier proyecto (personal, comercial)
- ✅ Estudiar, modificar y redistribuir
- ✅ Incluir en sistemas operativos, apps, sitios web
- ❌ Los trabajos derivados deben usar la misma licencia UFL
- ❌ No puedes vender la fuente sola (sí incluirla en un producto)

## Dónde se usa

| Ámbito | Dónde se ve |
|---|---|
| **Sistema operativo** | Ubuntu y sus sabores oficiales (Kubuntu, Xubuntu, etc.) |
| **Web** | Disponible en Google Fonts, usada en miles de sitios |
| **Documentación** | Documentos, presentaciones con estilo Ubuntu |
| **Apps** | App Center de Ubuntu, branding de Canonical |

```css
/* Usar en una web vía Google Fonts */
@import url('https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap');

body {
  font-family: 'Ubuntu', sans-serif;
}
```

## Instalación en otros sistemas

```bash
# Arch Linux
sudo pacman -S ttf-ubuntu-font-family

# Fedora
sudo dnf install ubuntu-font-family

# Debian/Ubuntu (normalmente ya instalado)
sudo apt install fonts-ubuntu

# Descargar directamente
# https://fonts.google.com/specimen/Ubuntu
```

## Pesos y estilos disponibles

| Peso | Estilo | Uso típico |
|---|---|---|
| Light (300) | Normal, Italic | Títulos grandes, decoración |
| Regular (400) | Normal, Italic | Texto de cuerpo |
| Medium (500) | Normal, Italic | Subtítulos, énfasis |
| Bold (700) | Normal, Italic | Títulos, encabezados |
| Mono (monospace) | Regular | Código, terminal |

## Notas personales

- La Ubuntu Font es gratis y de muy buena calidad — es una excelente opción para cualquier proyecto que necesite una sans-serif moderna y legible
- La versión monospace (Ubuntu Mono) es muy popular entre desarrolladores como fuente de terminal/editor
- Es una de las pocas tipografías diseñada específicamente para **pantallas** (no para papel), lo que se nota en su legibilidad en monitores modernos

## Enlaces externos

- [Sitio oficial de la tipografía](http://font.ubuntu.com/)
- [Ubuntu Font en Google Fonts](https://fonts.google.com/specimen/Ubuntu)
- [Wikipedia — Ubuntu (tipo de letra)](https://es.wikipedia.org/wiki/Ubuntu_(tipo_de_letra))
- [Ubuntu Font Licence (texto completo)](http://font.ubuntu.com/ufl/)

## Ver también

- [[Ubuntu]] — sistema operativo que usa esta tipografía
- [[Canonical y su ecosistema]] — empresa detrás de Ubuntu

#concepto #tipografia #ubuntu
