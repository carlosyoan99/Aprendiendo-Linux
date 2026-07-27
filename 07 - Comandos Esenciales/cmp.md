---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: media
---

# cmp

> Compara dos archivos byte a byte. Devuelve la primera diferencia o indica si son idénticos. Esencial para verificar integridad de binarios, imágenes, o archivos grandes, donde `diff` es ineficiente.

## Sintaxis

```bash
cmp [opciones] archivo1 archivo2 [saltar1 [saltar2]]
```

## Descripción

`cmp` compara dos archivos byte a byte. A diferencia de `diff` (que compara línea por línea para texto), `cmp` opera a nivel de bytes y es la herramienta correcta para archivos binarios (imágenes, PDFs, ejecutables, ISOs).

**Códigos de salida:**
| Código | Significado |
|---|---|
| `0` | Archivos idénticos |
| `1` | Archivos diferentes (muestra la primera discrepancia) |
| `2` | Error (archivo no accesible) |

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-b` | Muestra el byte diferente (en octal + ASCII) | `cmp -b a.png b.png` |
| `-l` | Lista TODAS las diferencias (no solo la primera) | `cmp -l a.png b.png` |
| `-n N` | Comparar solo los primeros N bytes | `cmp -n 100 a.png b.png` |
| `-i N` | Saltar N bytes al inicio de ambos archivos | `cmp -i 1024 a.png b.png` |
| `-s` | Silencioso (solo código de salida, sin output) | `cmp -s a.png b.png` |

## Formato de salida

```bash
$ cmp a.txt b.txt
a.txt b.txt differ: byte 25, line 5
```

Con `-l`:
```bash
$ cmp -l a.txt b.txt
25 101 141
26 102 142
```

Cada línea: `byte_pos valor1_octal valor2_octal`

Con `-b`:
```bash
$ cmp -b a.txt b.txt
a.txt b.txt differ: byte 25, line 5 is 101 A 141 a
```

## Ejemplos

```bash
# 1. Comparación básica
cmp foto.jpg copia_foto.jpg
# (sin salida = idénticos)

# 2. Mostrar primera diferencia (binarios)
cmp -b imagen.jpg sospechoso.jpg
# imagen.jpg sospechoso.jpg differ: byte 1024, line 1 is 377 377 12 377

# 3. Listar TODAS las diferencias (útiles para ver cuánto difieren)
cmp -l archivo1.bin archivo2.bin | head -20

# 4. Silencioso — solo código de salida (para scripts)
if cmp -s /ruta/original /backup/original; then
    echo "Los archivos son idénticos"
else
    echo "¡Los archivos difieren!"
fi

# 5. Comparar solo los primeros 512 bytes (MBR)
cmp -n 512 /dev/sda /dev/sdb

# 6. Comparar saltando los primeros 1024 bytes (metadata)
cmp -i 1024 archivo1.bin archivo2.bin

# 7. Contar cuántos bytes difieren
cmp -l a.txt b.txt | wc -l
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Verificar que una copia de ISO es exacta** | `cmp -s ubuntu.iso copia.iso && echo "iguales"` |
| **Comparar dos binarios compilados** | `cmp programa programa_v2` |
| **Chequear integridad de backup de foto** | `cmp -s DSC001.jpg /backup/DSC001.jpg` |
| **Encontrar diferencias en cabeceras de archivos** | `cmp -n 1000 archivo1.png archivo2.png` |
| **Verificar que un archivo no cambió** en script | `cmp -s archivo backup_archivo -o skip_bytes` |
| **Comparar MBR de dos discos** | `sudo cmp -n 512 /dev/sda /dev/sdb` |

## cmp vs otros comandos de comparación

| Herramienta | Nivel | Ideal para |
|---|---|---|
| **cmp** | Byte a byte | Binarios, ISOs, imágenes, verificación exacta |
| **diff** | Línea a línea | Texto, configuraciones, código fuente |
| **sha256sum / md5sum** | Hash criptográfico | Verificación rápida de integridad (no muestra dónde difiere) |
| **rsync --dry-run** | Archivo a archivo | Comparar directorios completos |

## Combinaciones comunes con pipe

```bash
# Contar diferencias en un binario
cmp -l a.bin b.bin | wc -l

# Verificar varios archivos con loop
for f in *.jpg; do
    cmp -s "$f" "backup/$f" || echo "$f ha cambiado"
done

# Comparar salida de comandos (vía process substitution)
cmp -s <(sha256sum /etc/passwd) <(sha256sum /etc/passwd.bak)
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `cmp: EOF on archivo1` | Un archivo es más corto que el otro | `wc -c archivo1 archivo2` para ver tamaños |
| `cmp: archivo: No such file or directory` | Archivo no existe | Verificar ruta |
| `cmp: archivo: Permission denied` | Sin permiso de lectura | Usar `sudo` o verificar permisos |
| `cmp: -l: too many differences` | Archivos completamente distintos | Usar `cmp` sin `-l` para ver solo la primera diferencia |
| **Archivos grandes son lentos** | cmp lee byte a byte | Usar `sha256sum` para verificación rápida, `cmp` solo si hay discrepancia |

## Notas

- **Silencioso con `-s`**: ideal para scripts de verificación. Solo importa el código de salida.
- **`cmp` no tiene límite de tamaño**: puede comparar archivos de cualquier tamaño (a diferencia de `diff` que carga en memoria).
- **`cmp` es más rápido que `diff`** para binarios porque no necesita parsear líneas.
- **Para verificar integridad de descargas**, usa `sha256sum` o `md5sum` en vez de `cmp` — son más rápidos y muestran un hash que puedes verificar contra el sitio oficial.

## Enlaces externos

- [Wikipedia — cmp](https://en.wikipedia.org/wiki/Cmp_(Unix))
- [GNU Diffutils — cmp manual](https://www.gnu.org/software/diffutils/manual/diffutils.html#cmp)
- [Linux man page — cmp(1)](https://man.archlinux.org/man/cmp.1)

## Ver también

- [[diff]] — comparación línea a línea (para texto)
- [[sha256sum]] — verificación rápida con hash
- [[rsync]] — copia y verificación de archivos
- [[Cheat Sheet - Comandos Esenciales]]

#comando #diffutils
