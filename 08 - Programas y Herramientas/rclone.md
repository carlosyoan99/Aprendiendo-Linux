---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# rclone

> Sincronización y gestión de almacenamiento en la nube desde terminal. Soporta 70+ proveedores (S3, Google Drive, OneDrive, Dropbox, Backblaze, etc.) y se puede montar como disco local con FUSE.

## Qué es

**rclone** es una herramienta CLI para sincronizar, copiar, mover y montar archivos entre almacenamiento local y remoto. Es el "rsync de la nube" — supporting 70+ backends incluyendo S3, Google Drive, OneDrive, Dropbox, SFTP, WebDAV, y muchos más.

**Ventajas clave:**
- 70+ backends soportados (S3, GCS, Azure, Drive, Dropbox, etc.)
- Cifrado E2E opcional (encrypt/decrypt on the fly)
- Montaje como disco local vía FUSE (`rclone mount`)
- Sincronización bidireccional con `bisync`
- Serve para montar almacenamiento remoto como WebDAV/FTP/S3

## Instalación

```bash
# Debian/Ubuntu
sudo apt install rclone

# Arch / CachyOS
sudo pacman -S rclone

# Fedora
sudo dnf install rclone

# Script de instalación oficial
curl https://rclone.org/install.sh | sudo bash
```

## Configuración

```bash
rclone config          # asistente interactivo para configurar remotes
```

### Ejemplo de configuración S3

```bash
rclone config
# → n (nuevo remote)
# → nombre: mi-s3
# → Storage: Amazon S3
# → Provider: AWS
# → Access Key ID: <tu-key>
# → Secret Access Key: <tu-secret>
# → Region: eu-west-1
# → ✔ Yes, exit
```

## Comandos principales

| Comando | Descripción |
|---|---|
| `rclone copy` | Copiar archivos del origen al destino |
| `rclone sync` | Sincronizar (borra archivos que no existen en origen) |
| `rclone move` | Mover archivos |
| `rclone ls` | Listar archivos en remoto |
| `rclone lsd` | Listar directorios en remoto |
| `rclone mount` | Montar remoto como disco local (FUSE) |
| `rclone serve` | Servir remoto como WebDAV/FTP/S3 |
| `rclone bisync` | Sincronización bidireccional |
| `rclone check` | Verificar integridad entre origen y destino |
| `rclone size` | Ver tamaño total del remoto |

## Ejemplos

```bash
# Copiar directorio a S3
rclone copy ./backup s3:mi-bucket/backups --progress

# Sincronizar directorio local con Google Drive
rclone sync ~/Documents gdrive:Documents --progress

# Listar archivos en remoto
rclone ls gdrive:Documents

# Montar Google Drive como disco local
rclone mount gdrive: /mnt/gdrive --vfs-cache-mode full &

# Sincronización bidireccional
rclone bisync ~/Projects gdrive:Projects --resync

# Verificar integridad
rclone check ~/backup s3:mi-bucket/backup --progress
```

## Rclone mount

```bash
# Montar S3 como disco
rclone mount mi-s3:mi-bucket /mnt/s3 --vfs-cache-mode full --daemon

# Montar Google Drive (read-only)
rclone mount gdrive: /mnt/gdrive --read-only --allow-other

# Desmontar
fusermount -u /mnt/s3
```

## Cifrado

```bash
# Crear remote con cifrado
rclone config
# → n (nuevo remote)
# → nombre: encriptado
# → Storage: Crypt
# → remote: s3:mi-bucket/cifrado
# → password: <contraseña de cifrado>
# → password2: <contraseña de salting>

# Ahora rclone encripta/descifra automáticamente
rclone copy ./datos encriptado: --progress
```

## Comparativa con alternativas

| Aspecto | rclone | rsync | restic | borg |
|---|---|---|---|---|
| **Almacenamiento remoto** | ✅ 70+ backends | ❌ Solo SSH | ✅ S3/B2/etc | ❌ Solo SSH |
| **Cifrado E2E** | ✅ | ❌ | ✅ | ✅ |
| **Deduplicación** | ❌ | ❌ | ✅ | ✅ |
| **Mount FUSE** | ✅ | ❌ | ❌ | ❌ |
| **Bidireccional** | ✅ (bisync) | ❌ (unidireccional) | ❌ | ❌ |
| **Backups** | Parcial (sin dedup) | ❌ | ✅ | ✅ |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `FATAL: Cannot open /dev/fuse` | Usuario no en grupo fuse | `sudo usermod -aG fuse $USER` + re-login |
| Rate limit 429 | Proveedor limita requests | `--tpslimit 4` o `--bwlimit 1M` |
| Archivos corruptos al copiar | Transferencia incompleta | `--checksum` para verificar integridad |
| Mount lento | Sin caché | `--vfs-cache-mode full` |

## Ver también

- [[Backups (borg restic duplicity rsync)]] — estrategias de backup
- [[rsync]] — sincronización local/SSH
- [[borg]] — backups con deduplicación
- [[Nextcloud]] — nube privada self-hosted

## Enlaces externos

- [Sitio oficial](https://rclone.org/)
- [GitHub — rclone](https://github.com/rclone/rclone)
- [Listado de 70+ backends](https://rclone.org/overview/)
- [Arch Wiki — rclone](https://wiki.archlinux.org/title/Rclone)

#programa #cloud #sync #backup
