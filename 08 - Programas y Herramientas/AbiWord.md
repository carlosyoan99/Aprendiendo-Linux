---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# AbiWord

Procesador de textos ligero y rápido, parte del proyecto GNOME. Ideal para equipos con pocos recursos o cuando solo necesitas un editor de documentos básico sin el peso de una suite completa.

Se complementa con [[Gnumeric]] (hoja de cálculo) como alternativa ultraligera a [[LibreOffice]].

## Instalación

```bash
sudo apt install abiword              # Debian/Ubuntu
sudo pacman -S abiword               # Arch
sudo dnf install abiword             # Fedora
```

## Primeros pasos

Una vez instalado, se lanza desde el menú o con:

```bash
abiword                         # Abrir interfaz gráfica
abiword documento.docx          # Abrir un documento existente
abiword --to=txt documento.odt  # Convertir ODT a texto plano
```

## Formatos compatibles

| Formato | Lectura | Escritura |
|---|---|---|
| .docx | ✅ | ✅ |
| .odt (ODF) | ✅ | ✅ |
| .doc (Word 97) | ✅ | ❌ |
| .rtf | ✅ | ✅ |
| .txt | ✅ | ✅ |
| .html | ✅ | ✅ |

## Características

- **Muy ligero**: ~5 MB de instalación, arranque instantáneo
- **Interfaz limpia y sencilla**: sin distracciones, similar a WordPad
- **Corrector ortográfico**: integrado con diccionarios por idioma
- **Exportación múltiple**: PDF, HTML, ODF, .docx, RTF, TXT
- **Plugins**: gramática, plantillas, colaboración básica
- **Atajos de teclado**: compatibles con los de GNOME

## Ventajas

- Funciona en hardware antiguo o limitado (RPi, netbooks)
- Arranque casi instantáneo incluso en discos HDD
- Consume ~20 MB de RAM frente a los ~300 MB de LibreOffice

## Desventajas

- Sin tabla de estilos avanzada (como las de Word o LibreOffice)
- Sin control de cambios (track changes)
- Limitado para documentos largos o con formato complejo
- Sin compatibilidad con macros

## Ver también

- [[Gnumeric]] — hoja de cálculo ligera
- [[LibreOffice]] — suite completa
- [[Suite de Oficina]] — índice + comparativa

## Enlaces externos

- [Sitio oficial](https://www.abisource.com/)
- [Wikipedia — AbiWord](https://en.wikipedia.org/wiki/AbiWord)

#programa #ofimatica
