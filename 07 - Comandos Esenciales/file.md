---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# file

> Identifica el tipo de archivo examinando su contenido (magic numbers), no la extensión. Esencial para scripts y troubleshooting.

## Sintaxis

```bash
file [opciones] [archivo...]
```

## Descripción

`file` lee los primeros bytes de un archivo (magic numbers) y los compara con una base de datos de firmas conocidas (`/usr/share/misc/magic`). Determina el tipo real sin importar la extensión — un archivo `.jpg` que en realidad es un `.png` será detectado correctamente.

## Opciones principales

| Opción | Descripción |
|---|---|
| `-i` | Mostrar tipo MIME |
| `-b` | Modo brief (sin nombre de archivo) |
| `-f <lista>` | Leer nombres de archivo desde un archivo |
| `-z` | Examinar contenido comprimido |
| `-L` | Seguir symlinks |
| `--mime-type` | Solo tipo MIME |
| `--extension` | Solo extensión sugerida |

## Ejemplos

### Identificar un archivo
```bash
file imagen.png
# imagen.png: PNG image data, 800 x 600, 8-bit/color RGB
```

### Tipo MIME
```bash
file -i documento.pdf
# documento.pdf: application/pdf; charset=binary
```

### Modo brief (solo tipo, sin nombre)
```bash
file -b archivo.tar.gz
# gzip compressed data
```

### Verificar que una descarga es realmente una imagen
```bash
file -b foto.jpg | grep -qi "image" && echo "OK" || echo "No es imagen"
```

### Examinar archivos comprimidos
```bash
file -z archivo.gz
# gzip compressed data (examina el contenido interno)
```

## Formato de salida

```
imagen.png:           PNG image data, 800 x 600, 8-bit/color RGB
script.sh:            Bourne-Again shell script, ASCII text executable
backup.tar.gz:        gzip compressed data
elf:                  ELF 64-bit LSB executable, x86-64
vacío:                empty
```

## Magic numbers comunes

| Tipo | Magic bytes (hex) | Ejemplo |
|---|---|---|
| PNG | `89 50 4E 47` | `file imagen.png` |
| JPEG | `FF D8 FF` | `file foto.jpg` |
| PDF | `25 50 44 46` (%PDF) | `file doc.pdf` |
| ZIP | `50 4B 03 04` (PK..) | `file archivo.zip` |
| ELF | `7F 45 4C 46` (.ELF) | `file programa` |
| Gzip | `1F 8B` | `file backup.gz` |
| Btrfs | magic at offset 64k | `file /dev/sda1` |

## Casos de uso

### Verificar integridad de descarga
```bash
# Descargaste una ISO — ¿es realmente una imagen de disco?
file ubuntu-24.04.iso
# ubuntu-24.04.iso: ISO 9660 CD-ROM filesystem data 'Ubuntu-24.04'
```

### Encontrar archivos de tipo específico
```bash
# Encontrar todos los PNG en un directorio
find . -exec file {} \; | grep "PNG image" | cut -d: -f1
```

### Verificar que un script es ejecutable
```bash
file -b script.sh | grep -q "executable" && echo "OK" || chmod +x script.sh
```

### Detectar archivos vacíos
```bash
find . -name "*.md" -exec file {} \; | grep empty
```

### Verificar tipo MIME para web server
```bash
file -i --mime-type *.html | head -5
# index.html: text/html; charset=utf-8
```

## Combinaciones pipe

```bash
# Contar archivos por tipo
find . -type f -exec file -b {} \; | sort | uniq -c | sort -rn | head -10

# Encontrar ejecutables ELF
find /usr/bin -exec file {} \; | grep "ELF" | wc -l

# Verificar que todos los .md son texto
find . -name "*.md" -exec file -i {} \; | grep -v "text/plain" 
```

## Alternativas

| Herramienta | Cuándo usarla |
|---|---|
| **file** | Identificar tipo de contenido (magic numbers) |
| **stat** | Metadata del archivo (timestamps, permisos, inode) |
| **ls -l** | Tipo por letra inicial (-, d, l, etc.) |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| "cannot open" | Archivo no existe | Verificar ruta |
| Resultado incorrecto | Base de datos magic desactualizada | `sudo update-mime-database /usr/share/mime` |
| No detecta tipo | Archivo muy pequeño/vacío | `file` reportará "empty" |

## Ver también

- [[stat]] — metadata detallada (timestamps, permisos)
- [[ls]] — listado rápido
- [[chmod]] — cambiar permisos
- [[sha256sum]] — verificar integridad con hash

## Enlaces externos

- [man file(1)](https://man7.org/linux/man-pages/man1/file.1.html)
- [Wikipedia — file (command)](https://en.wikipedia.org/wiki/File_(command))
- [libmagic documentation](https://man7.org/linux/man-pages/man3/magic.3.html)

#comando
