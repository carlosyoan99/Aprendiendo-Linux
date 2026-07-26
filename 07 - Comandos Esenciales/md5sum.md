---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: baja
---

# md5sum

> Genera o verifica hashes MD5 de archivos. Legacy e inseguro — usar [[sha256sum]] para nuevos casos.

## Sintaxis

```bash
md5sum [opciones] [archivo...]
```

## Descripción

`md5sum` calcula un hash MD5 (128 bits, 32 caracteres hexadecimales). Aunque MD5 está roto criptográficamente, se usa ampliamente para verificación de integridad no crítica (descargas, backups antiguos).

## Opciones

| Opción | Descripción |
|---|---|
| `-b` | Modo binario |
| `-t` | Modo texto (default) |
| `--check` | Verificar hashes contra archivo |
| `--quiet` | Solo mostrar resultado |
| `--status` | Sin salida (solo código de retorno) |

## Ejemplos

```bash
md5sum archivo.tar.gz              # generar hash
md5sum --check checksums.md5       # verificar
echo -n "password" | md5sum        # hash de un string
```

## Casos de uso

### Verificar descarga
```bash
wget https://example.com/file.zip
wget https://example.com/file.zip.md5
md5sum --check file.zip.md5
```

### Comparar dos archivos
```bash
diff <(md5sum a.txt | awk '{print $1}') <(md5sum b.txt | awk '{print $1}')
```

## Alternativas

| Herramienta | Seguridad |
|---|---|
| **sha256sum** | ✅ Recomendado |
| **sha512sum** | ✅ Más seguro |
| **md5sum** | ⚠️ Legacy, no criptográficamente seguro |

## Ver también

- [[sha256sum]] — hash SHA-256 (recomendado)
- [[cmp]] — comparar archivos byte a byte
- [[rsync]] — sincronizar con verificación

## Enlaces externos

- [Wikipedia — MD5](https://en.wikipedia.org/wiki/MD5)
- [man md5sum(1)](https://man7.org/linux/man-pages/man1/md5sum.1.html)

#comando
