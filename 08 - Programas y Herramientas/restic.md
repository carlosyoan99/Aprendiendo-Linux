---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# restic

## Qué es

**restic** es una herramienta de backup rápida, cifrada y deduplicada, diseñada para ser fácil de usar y compatible con múltiples backends de almacenamiento (local, SSH, S3, Backblaze B2, Azure, Google Cloud, REST server, etc.). A diferencia de borg, restic prioriza la simplicidad y la flexibilidad de destinos sobre la eficiencia máxima de espacio.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install restic

# Arch
sudo pacman -S restic

# Fedora
sudo dnf install restic

# O descargar la última versión desde GitHub
curl -s https://api.github.com/repos/restic/restic/releases/latest | \
  grep browser_download_url | grep linux_amd64 | cut -d'"' -f4 | wget -qi -
bunzip2 restic_*_linux_amd64.bz2
chmod +x restic_*_linux_amd64
sudo mv restic_*_linux_amd64 /usr/local/bin/restic
```

## Uso básico

```bash
# 1. Inicializar repositorio local
restic init --repo /mnt/disco_externo/restic-repo
# Te pedirá una contraseña

# 2. Crear un snapshot
restic --repo /mnt/disco_externo/restic-repo \
  backup /home/usuario/Documentos/ \
  --exclude='*.tmp' \
  --exclude-file=~/.restic_excludes

# 3. Listar snapshots
restic snapshots --repo /mnt/disco_externo/restic-repo

# 4. Ver contenido de un snapshot
restic ls --repo /mnt/disco_externo/restic-repo latest
restic ls --repo /mnt/disco_externo/restic-repo <snapshot-id>
```

## Múltiples destinos

```bash
# S3 (AWS, MinIO, DigitalOcean Spaces)
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
restic init --repo s3:s3.eu-central-1.amazonaws.com/mi-bucket/restic-repo
restic -r s3:s3.eu-central-1.amazonaws.com/mi-bucket/restic-repo backup /home/usuario/

# Backblaze B2
export B2_ACCOUNT_ID=...
export B2_ACCOUNT_KEY=...
restic -r b2:mi-bucket:/restic-repo backup /home/usuario/

# SFTP (SSH)
restic -r sftp:usuario@servidor:/backups/restic-repo backup /home/usuario/

# REST Server (servidor HTTP dedicado)
restic -r rest:https://rest-server.local:8000/ backup /home/usuario/
```

## Variables de entorno

```bash
# Para no escribir --repo y contraseña cada vez
export RESTIC_REPOSITORY="/mnt/disco_externo/restic-repo"
export RESTIC_PASSWORD="tu-contraseña-segura"
```

## Restaurar y mantener

```bash
# Restaurar un snapshot completo
restic --repo /mnt/disco_externo/restic-repo restore latest --target /tmp/restore

# Restaurar archivos específicos
restic restore <snapshot-id> --target /tmp/restore --include /ruta/especifica

# Montar snapshot como FS (explorar sin restaurar)
restic mount /mnt/restore

# Verificar integridad
restic check --read-data --repo /mnt/disco_externo/restic-repo

# Eliminar snapshots antiguos (forget + prune)
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
```

## Ver también

- [[borg]] — backup deduplicado más eficiente en espacio
- [[duplicity]] — backup cifrado con GPG (legacy)
- [[Backups (borg restic duplicity rsync)]] — índice comparativo y estrategia 3-2-1
- [[rsync]] — sincronización de archivos
- [[Cron]] · [[systemd timers]] — automatización de backups

## Enlaces externos

- [Sitio oficial — restic](https://restic.net/)
- [GitHub — restic/restic](https://github.com/restic/restic)

#programa
