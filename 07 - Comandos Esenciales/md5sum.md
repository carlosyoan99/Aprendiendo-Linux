---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: baja
---

# md5sum

> Genera o verifica hashes MD5 de archivos. Legacy e inseguro — usar [[sha256sum]] para nuevos casos. Útil para verificar integridad de descargas antiguas que aún proporcionan checksums MD5.

## Sintaxis

```bash
md5sum [opciones] [archivo...]
```

## Descripción

`md5sum` calcula un hash MD5 (128 bits, 32 caracteres hexadecimales) de uno o más archivos. Aunque MD5 está roto criptográficamente (se pueden crear colisiones), se usa ampliamente para verificación de integridad no crítica: descargas, backups antiguos, y comparación rápida de archivos.

- **Algoritmo**: MD5 (Message Digest 5)
- **Salida**: 32 caracteres hex (128 bits)
- **Velocidad**: Muy rápido
- **Seguridad**: ⚠️ Rota — no usar para seguridad

## Opciones principales

| Opción | Descripción |
|---|---|
| `-b` | Modo binario |
| `-t` | Modo texto (default) |
| `--check` | Verificar hashes contra archivo de checksums |
| `--quiet` | Solo mostrar resultado (sin nombre de archivo) |
| `--status` | Sin salida (solo código de retorno: 0=ok, 1=fallo) |
| `--tag` | Formato BSD (sin asterisco) |

## Ejemplos

```bash
# Generar hash de un archivo
md5sum archivo.tar.gz
# a1b2c3d4e5f6...  archivo.tar.gz

# Generar hashes de varios archivos
md5sum *.iso > checksums.md5

# Verificar un hash individual
echo "a1b2c3d4e5f6...  archivo.tar.gz" | md5sum --check

# Verificar contra archivo de checksums
md5sum --check checksums.md5
# archivo.tar.gz: OK
# archivo2.tar.gz: FAILED

# Hash de un string (sin archivo)
echo -n "password" | md5sum
# 5f4dcc3b5aa765d61d8327deb882cf99  -

# Comparar dos archivos por hash
diff <(md5sum a.txt | awk '{print $1}') <(md5sum b.txt | awk '{print $1}')

# Hash de un directorio completo (listar todos)
find . -type f -exec md5sum {} + | sort > checksums.md5

# Verificar integridad de una descarga
wget https://example.com/file.zip
wget https://example.com/file.zip.md5
md5sum --check file.zip.md5
```

## Formato de archivo de checksums

```bash
# Formato estándar (GNU coreutils):
a1b2c3d4e5f6...  archivo1.tar.gz
e7f8a9b0c1d2...  archivo2.tar.gz

# Con asterisco (modo binario):
*a1b2c3d4e5f6...  archivo1.bin
```

## Casos de uso

### Verificar descarga de software

```bash
# Descargar ISO y su checksum
wget https://example.com/linux.iso
wget https://example.com/linux.iso.md5

# Verificar
md5sum --check linux.iso.md5
# linux.iso: OK
```

### Comparar dos backups

```bash
# Generar hashes de ambos
md5sum backup_v1.tar.gz > v1.md5
md5sum backup_v2.tar.gz > v2.md5

# Comparar
diff v1.md5 v2.md5
# Si no hay salida, son idénticos
```

### Verificar integridad tras transferencia

```bash
# En el origen
md5sum archivo_grande.tar.gz > check.md5

# En el destino (después de scp/rsync)
md5sum --check check.md5
```

## md5sum vs sha256sum

| Aspecto | md5sum | sha256sum |
|---|---|---|
| **Bits** | 128 | 256 |
| **Velocidad** | Más rápido | Un poco más lento |
| **Seguridad** | ⚠️ Rota (colisiones) | ✅ Seguro |
| **Longitud hash** | 32 chars hex | 64 chars hex |
| **Uso actual** | Legacy, descargas antiguas | Nuevo software, distribuciones |
| **Recomendado** | ❌ No | ✅ Sí |

> **Regla simple**: si el proveedor ofrece SHA256, usa `sha256sum`. Si solo ofrece MD5, usa `md5sum` (es mejor que nada). Para nuevos proyectos, siempre publicar SHA256.

## Ver también

- [[sha256sum]] — hash SHA-256 (recomendado)
- [[cmp]] — comparar archivos byte a byte
- [[rsync]] — sincronizar con verificación integrada
- [[sha256sum]] — alternativa segura
- [[Coreutils y util-linux]] — paquete que incluye md5sum

## Enlaces externos

- [Wikipedia — MD5](https://en.wikipedia.org/wiki/MD5)
- [Man page — md5sum](https://man7.org/linux/man-pages/man1/md5sum.1.html)
- [Arch Wiki — md5sum](https://man.archlinux.org/man/md5sum.1)

#comando #integridad #seguridad
