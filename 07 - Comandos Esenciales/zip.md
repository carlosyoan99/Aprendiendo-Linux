---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: media
---

# zip / unzip

> Empaqueta y comprime archivos en formato ZIP. El formato más universal (compatible con Windows y macOS sin herramientas extra). `zip` comprime, `unzip` extrae.

## Sintaxis

```bash
zip [opciones] archivo.zip archivos...
unzip [opciones] archivo.zip
```

## Descripción

ZIP es el formato de compresión más universal del mundo. A diferencia de `tar`, ZIP integra la compresión en un solo paso (no necesita pipe a gzip/bzip2). Es ideal para compartir archivos con usuarios de Windows/macOS, pero no preserva permisos de Linux (usar `tar` para backups de sistemas).

## Opciones principales de zip

| Flag | Efecto |
|---|---|
| `-r` | Recursivo (necesario para directorios) |
| `-q` | Modo silencioso |
| `-9` | Máxima compresión (más lento) |
| `-1` | Compresión rápida (más rápido) |
| `-e` | Cifrar con contraseña |
| `-P <pass>` | Contraseña desde línea de comandos (inseguro) |
| `-d` | Eliminar archivos dentro del ZIP sin extraer todo |
| `-m` | Mover: comprime y borra los originales |
| `-v` | Ver contenido (verbose) |
| `-T` | Test de integridad |
| `-u` | Actualizar: añadir archivos modificados |

## Opciones principales de unzip

| Flag | Efecto |
|---|---|
| `-l` | Listar contenido sin extraer |
| `-d directorio` | Extraer en un directorio específico |
| `-o` | Sobrescribir archivos sin preguntar |
| `-q` | Modo silencioso |
| `-t` | Test de integridad |
| `-n` | No sobrescribir (nunca) |
| `-P <pass>` | Contraseña |

## Ejemplos

```bash
# Comprimir directorio
zip -r proyecto.zip proyecto/
zip -r -9 backup-max.zip datos/           # máxima compresión

# Comprimir con contraseña
zip -e secreto.zip documento.txt
zip -P "mi-contraseña" archivo.txt        # inseguro (visible en procesos)

# Extraer
unzip proyecto.zip                        # en directorio actual
unzip proyecto.zip -d /tmp/               # en /tmp
unzip -o proyecto.zip                     # sobrescribir sin preguntar

# Listar contenido
unzip -l proyecto.zip                     # lista de archivos
unzip -l proyecto.zip | grep "\.txt$"     # solo archivos .txt

# Modificar ZIP sin extraer
zip -d proyecto.zip archivo-temp.txt      # eliminar archivo del ZIP
zip -m proyecto.zip viejo.log             # comprimir y borrar original
zip -u proyecto.zip nuevo_archivo.txt     # añadir/actualizar archivo

# Test de integridad
zip -T archivo.zip                        # verificar ZIP corrupto
unzip -t archivo.zip                      # test con unzip

# Comprimir archivos de texto (mejor compresión)
zip -9 -r textos.zip documentacion/
```

## tar vs zip vs 7z

| Característica | tar + gzip | zip | 7z |
|---|---|---|---|
| **Compresión integrada** | ❌ (pipe) | ✅ | ✅ |
| **Preserva permisos Linux** | ✅ | ❌ | Parcial |
| **Compatible Windows** | ❌ | ✅ | ✅ (7-Zip) |
| **Compatible macOS** | ✅ | ✅ | ✅ (The Unarchiver) |
| **Compresión máxima** | xz (~95%) | deflate (~85%) | LZMA2 (~98%) |
| **Velocidad** | Rápida (gzip) | Rápida | Lenta (LZMA) |
| **Ideal para** | Backups, distribución de código | Compartir con Windows | Máxima compresión |

## Notas y advertencias

- **Siempre usar `-r`** para comprimir directorios, sino `zip` los salta sin aviso.
- ZIP **no preserva permisos** de ejecución ni propietarios de Linux. Para backups de sistemas usar `tar`.
- `unzip` puede no venir preinstalado en distros mínimas: `sudo apt install unzip` / `sudo pacman -S unzip`.
- Para crear ZIP desde `tar`: `tar -cf - directorio/ | zip -r archivo.zip -`
- Para extraer ZIP a `tar`: `unzip -p archivo.zip | tar -xf -`

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `unzip: command not found` | No instalado | `sudo apt install unzip` / `sudo pacman -S unzip` |
| `zip: command not found` | No instalado | `sudo apt install zip` / `sudo pacman -S zip` |
| ZIP corrupto tras transferencia | SCP/FTP interrumpido | Verificar checksum: `zip -T archivo.zip` |
| Directorios no comprimidos | Falta flag `-r` | `zip -r archivo.zip directorio/` |
| Permisos perdidos al extraer | ZIP no preserva permisos | Usar `tar` para backups de sistemas |
| Contraseña no funciona | Diferencia entre mayúsculas | Verificar que la contraseña es correcta |

## Ver también

- [[tar]] — formato estándar Linux para backups
- [[7z]] — 7-Zip para máxima compresión
- [[Cheat Sheet - Comandos Esenciales]]
- [[rsync]] — sincronización sin formato de archivo

## Enlaces externos

- [Wikipedia — Zip (file format)](https://en.wikipedia.org/wiki/Zip_(file_format))
- [Info-ZIP official](http://www.info-zip.org/)
- [Man page — zip](https://man7.org/linux/man-pages/man1/zip.1.html)
- [Man page — unzip](https://man7.org/linux/man-pages/man1/unzip.1.html)

#comando #compresion
