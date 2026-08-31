---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: comando
prioridad: baja
---

# sha256sum

> Genera o verifica hashes SHA-256 de archivos. Esencial para verificar integridad de descargas y detectar corrupción de datos.

## Sintaxis

```bash
sha256sum [opciones] [archivo...]
```

## Descripción

`sha256sum` calcula un hash SHA-256 (256 bits, 64 caracteres hexadecimales) de uno o más archivos. Se usa para verificar que un archivo no ha sido modificado ni corrompido.

## Opciones

| Opción | Descripción |
|---|---|
| `-b` | Modo binario (no significativo en Linux) |
| `-t` | Modo texto (default en Linux) |
| `--check` | Verificar hashes contra archivo de checksums |
| `--ignore-missing` | Ignorar archivos no encontrados al verificar |
| `--quiet` | Solo mostrar resultado (no nombre de archivo) |
| `--status` | Sin salida (solo código de retorno) |

## Ejemplos

### Generar hash de un archivo
```bash
sha256sum archivo.tar.gz
# Salida: d9e6762dd1c8eaf6d61b3c6192fc408d4d6d5f1176d0c29169bc24e71c3f274ad  archivo.tar.gz
```

### Verificar integridad de una descarga
```bash
# Descargar archivo y su checksum
wget https://example.com/file.iso
wget https://example.com/file.iso.sha256

# Verificar
sha256sum --check file.iso.sha256
# file.iso: OK  (si coincide)
# file.iso: FAILED  (si no coincide)
```

### Generar archivo de checksums
```bash
# Crear archivo de checksums para múltiples archivos
sha256sum *.iso > checksums.sha256

# Contenido del archivo:
# abc123...  ubuntu-24.04.iso
# def456...  debian-12.iso

# Verificar todos
sha256sum --check checksums.sha256
```

### Verificar hash manualmente
```bash
# Comparar hash conocido
echo "e3b0c44298fc1c149afbf4c8996fb924..." | sha256sum -c
#stdin: OK

# O comparar directamente
sha256sum archivo.tar.gz | awk '{print $1}'
# Si coincide con el hash publicado → archivo íntegro
```

## Formato de salida

```
<hash hexadecimal de 64 chars>        <nombre archivo>
```

## Casos de uso

### Verificar ISO de Linux
```bash
# Después de descargar Ubuntu
wget https://releases.ubuntu.com/24.04/ubuntu-24.04-desktop-amd64.iso
wget https://releases.ubuntu.com/24.04/SHA256SUMS

# Verificar
sha256sum --check SHA256SUMS | grep ubuntu-24.04
# ubuntu-24.04-desktop-amd64.iso: OK
```

### Verificar backup
```bash
# Generar hash del backup
sha256sum backup-$(date +%Y%m%d).tar.gz > backup.sha256

# Después (días/meses), verificar que no se corrompió
sha256sum --check backup.sha256
```

## Combinaciones pipe

```bash
# Hash de un string
echo -n "password" | sha256sum
# stdin: 5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8

# Hash de archivo sin el nombre
sha256sum archivo | awk '{print $1}'

# Comparar dos archivos por hash
diff <(sha256sum a.txt | awk '{print $1}') <(sha256sum b.txt | awk '{print $1}')
```

## Alternativas

| Herramienta | Algoritmo | Cuándo usarla |
|---|---|---|
| **sha256sum** | SHA-256 | Verificación de integridad (estándar) |
| **sha512sum** | SHA-512 | Mayor seguridad |
| **md5sum** | MD5 | Rápido pero no seguro (legacy) |
| **b2sum** | BLAKE2 | Rápido y seguro |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Hash no coincide | Archivo corrupto o modificado | Re-descargar el archivo |
| "no such file" | Archivo no encontrado | Verificar ruta |
| Hash muy largo | Usando SHA-512 | Usar sha256sum (64 chars) |

## Ver también

- [[md5sum]] — hash MD5 (legacy, inseguro)
- [[cmp]] — comparar archivos byte a byte
- [[diff]] — comparar archivos línea a línea
- [[rsync]] — sincronizar con verificación de integridad

## Enlaces externos

- [Wikipedia — SHA-2](https://en.wikipedia.org/wiki/SHA-2)
- [man sha256sum(1)](https://man7.org/linux/man-pages/man1/sha256sum.1.html)
- [GNU Coreutils — sha256sum](https://www.gnu.org/software/coreutils/manual/html_node/sha256sum-invocation.html)

#comando
