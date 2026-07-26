---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# Backups (borg, restic, duplicity, rsync)

## Qué son

Herramientas de **backup de datos** (archivos personales, bases de datos, configuraciones) que permiten copias de seguridad automáticas, cifradas, y eficientes en espacio gracias a deduplicación y compresión. A diferencia de [[timeshift]] (que protege el sistema operativo), estas herramientas están diseñadas para proteger **tus datos personales** contra pérdida accidental, ransomware, o fallo de disco.

---

## Visión general

| Herramienta | Enfoque | Deduplicación | Cifrado | Remoto (SSH) | Snapshots | Ideal para |
|---|---|---|---|---|---|---|
| **rsync** | Sincronización de archivos | ❌ No | ❌ No (pero vía SSH) | ✅ Sí | ❌ No | Backups simples, sincronización diaria |
| **borg** | Backup deduplicado | ✅ Sí (por bloques) | ✅ Sí (clave/contraseña) | ✅ Sí (ssh) | ✅ Sí | Grandes volúmenes, backups frecuentes |
| **restic** | Backup rápido y flexible | ✅ Sí (por bloques) | ✅ Sí | ✅ Sí (ssh, s3, r2, etc.) | ✅ Sí | Múltiples destinos (local + cloud) |
| **duplicity** | Backup cifrado tradicional | ❌ No (solo compresión) | ✅ Sí (GPG) | ✅ Sí (ssh, s3, ftp) | ❌ No | Backups cifrados simples, legado |

---

## rsync — Sincronización de archivos

Ya cubierto en detalle en [[rsync]]. Aquí se menciona como parte de una estrategia de backup:

```bash
# Backup local simple (a disco externo)
rsync -avh --delete /home/usuario/Documentos/ /mnt/disco_externo/backups/Docs/

# Backup remoto vía SSH
rsync -avhz --delete /home/usuario/ usuario@servidor:/backups/

# Excluir archivos
rsync -avh --delete --exclude='node_modules/' --exclude='.cache/' /home/usuario/ /mnt/backup/

# Backup incremental (solo archivos más recientes)
rsync -avh --link-dest=/mnt/backup/anterior/ /home/usuario/ /mnt/backup/actual/
```

**Ventajas**: Universal, instalado por defecto, mínimo overhead.
**Desventajas**: Sin deduplicación, sin compresión nativa, sin snapshots integrados.

---

## borg — Backup deduplicado y eficiente

BorgBackup es la herramienta de backup más eficiente en espacio para Linux. Divide los archivos en **bloques de ~64 KB** y cada bloque se almacena una sola vez — si modificas 2 KB de un archivo de 1 GB, solo se guardan esos 2 KB nuevos.

### Instalación

```bash
# Debian/Ubuntu
sudo apt install borgbackup

# Arch
sudo pacman -S borg

# Fedora
sudo dnf install borgbackup
```

### Uso básico

```bash
# 1. Inicializar un repositorio (local o remoto)
borg init --encryption=repokey-blake2 /mnt/disco_externo/borg-repo
# Te pedirá una contraseña → guardarla en un gestor de contraseñas

# 2. Crear un snapshot (archive)
borg create --stats --progress \
  /mnt/disco_externo/borg-repo::docs-$(date +%Y-%m-%d) \
  /home/usuario/Documentos/ \
  --exclude '*.tmp' \
  --exclude '.cache/'

# 3. Listar snapshots
borg list /mnt/disco_externo/borg-repo

# 4. Ver diferencias entre snapshots
borg diff /mnt/disco_externo/borg-repo::docs-2026-07-01 docs-2026-07-15

# 5. Montar un snapshot como sistema de archivos (sin restaurar, requiere fuse instalado)
borg mount /mnt/disco_externo/borg-repo::docs-2026-07-15 /mnt/restore
ls /mnt/restore
borg umount /mnt/restore

# 6. Extraer archivos específicos
borg extract /mnt/disco_externo/borg-repo::docs-2026-07-15 \
  --path 'home/usuario/Documentos/importante.pdf'

# 7. Eliminar snapshots antiguos
borg delete /mnt/disco_externo/borg-repo::docs-2026-04-01

# 8. Prune (limpieza automática: conservar ciertos rangos)
borg prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6 \
  /mnt/disco_externo/borg-repo
```

### Backup remoto vía SSH

```bash
# Inicializar repositorio remoto
borg init --encryption=repokey-blake2 usuario@servidor:/backups/borg-repo

# Crear snapshot remoto
borg create --stats --progress \
  usuario@servidor:/backups/borg-repo::fotos-$(date +%Y-%m-%d) \
  /home/usuario/Fotos/

# Usar clave SSH sin contraseña (recomendado para automatización)
ssh-keygen -t ed25519 -f ~/.ssh/id_borg -N ""               # generar clave
ssh-copy-id -i ~/.ssh/id_borg usuario@servidor               # copiar al servidor
export BORG_RSH="ssh -i ~/.ssh/id_borg"                      # borg usará esta clave
```

### Ver repositorio

```bash
# Ver estadísticas: tamaño original vs almacenado
borg info /mnt/disco_externo/borg-repo

# Verificar integridad
borg check /mnt/disco_externo/borg-repo

# Cambiar contraseña
borg key change-passphrase /mnt/disco_externo/borg-repo
```

---

## restic — Backup rápido con múltiples destinos

Restic está diseñado para ser rápido, fácil de usar, y compatible con múltiples backends de almacenamiento (local, SSH, S3, Backblaze B2, Azure, Google Cloud, REST server, etc.).

### Instalación

```bash
# Debian/Ubuntu
sudo apt install restic

# Arch
sudo pacman -S restic

# Fedora
sudo dnf install restic

# O descargar la última versión desde GitHub (revisar https://github.com/restic/restic/releases/latest)
curl -s https://api.github.com/repos/restic/restic/releases/latest | \
  grep browser_download_url | grep linux_amd64 | cut -d'"' -f4 | wget -qi -
bunzip2 restic_*_linux_amd64.bz2
chmod +x restic_*_linux_amd64
sudo mv restic_*_linux_amd64 /usr/local/bin/restic
```

### Uso básico

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

### Múltiples destinos

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

### Variables de entorno

```bash
# Para no escribir --repo y contraseña cada vez
export RESTIC_REPOSITORY="/mnt/disco_externo/restic-repo"
export RESTIC_PASSWORD="tu-contraseña-segura"
```

### Restaurar y mantener

```bash
# Restaurar un snapshot completo
restic --repo /mnt/disco_externo/restic-repo restore latest --target /tmp/restore

# Restaurar archivos específicos
restic restore <snapshot-id> --target /tmp/restore --include /ruta/especifica

# Montar snapshot como FS (explorar sin restaurar)
restic mount /mnt/restore
# Abrir otra terminal y explorar /mnt/restore

# Verificar integridad
restic check --read-data --repo /mnt/disco_externo/restic-repo

# Eliminar snapshots antiguos (forget + prune)
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
```

---

## duplicity — Backup cifrado con GPG

Duplicity usa **rsync** + **GPG** para hacer backups incrementales cifrados. Más lento que borg/restic pero muy maduro y confiable.

### Instalación

```bash
sudo apt install duplicity            # Debian/Ubuntu
sudo pacman -S duplicity              # Arch
sudo dnf install duplicity            # Fedora
```

### Uso básico

```bash
# Backup completo a disco local (cifrado con GPG)
duplicity /home/usuario/Documentos/ file:///mnt/backup/duplicity/

# Backup incremental (duplicity detecta automáticamente)
duplicity /home/usuario/Documentos/ file:///mnt/backup/duplicity/

# Backup remoto vía SSH
duplicity /home/usuario/Documentos/ scp://usuario@servidor/backups/

# Listar backups disponibles
duplicity collection-status file:///mnt/backup/duplicity/

# Restaurar
duplicity file:///mnt/backup/duplicity/ /tmp/restore

# Restaurar archivo específico
duplicity --file-to-restore Documentos/importante.pdf \
  file:///mnt/backup/duplicity/ /tmp/restore/

# Eliminar backups antiguos
duplicity remove-older-than 30D file:///mnt/backup/duplicity/ --force
```

### Cifrado con clave GPG

```bash
# Usar una clave GPG específica
export PASSPHRASE="tu-frase"
export SIGN_PASSPHRASE="tu-frase-de-firma"
export GPG_KEY="ID_DE_TU_CLAVE_GPG"

duplicity --encrypt-key $GPG_KEY --sign-key $GPG_KEY \
  /home/usuario/ scp://usuario@servidor/backups/
```

---

## Tabla comparativa detallada

| Característica | rsync | borg | restic | duplicity |
|---|---|---|---|---|
| **Velocidad 1er backup** | Rápida | Media (divide en bloques) | Media (divide en bloques) | Lenta (cifra cada archivo) |
| **Velocidad backups siguientes** | Rápida (solo cambios) | Muy rápida (solo bloques nuevos) | Muy rápida (solo bloques nuevos) | Lenta (cifra de nuevo) |
| **Deduplicación** | ❌ | ✅ Por bloques (~64KB) | ✅ Por bloques (variable) | ❌ |
| **Compresión** | ❌ | ✅ (lz4, zstd, lzma) | ✅ | ✅ (gzip, bzip2) |
| **Cifrado** | SSH (transporte) | ✅ AES-256 (en reposo) | ✅ AES-256 (en reposo) | ✅ GPG (en reposo) |
| **Recuperación de archivo único** | Directa | ✅ `borg extract` | ✅ `restic restore` | ✅ `--file-to-restore` |
| **Montar snapshot como FS** | ❌ | ✅ `borg mount` | ✅ `restic mount` | ❌ |
| **Snapshots automáticos** | ❌ (solo link-dest) | ✅ + prune | ✅ + forget/prune | ❌ (full+incremental) |
| **Múltiples destinos** | SSH, local | SSH, local | **S3, B2, GCS, Azure, SFTP, REST** | SSH, S3, FTP, local |
| **Facilidad de uso** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **Popularidad en servidores** | Muy alta | Alta | Creciente | Decreciente |

---

## Estrategia recomendada: 3-2-1

La regla de oro de los backups:

> **3** copias de tus datos, en **2** tipos de medio diferentes, con **1** copia fuera del sitio.

```
Ejemplo práctico (para un escritorio Linux):

  ┌─────────────────────────────────────────────────────┐
  │ DATOS ORIGINALES: /home/usuario/                    │
  ├─────────────────────────────────────────────────────┤
  │                                                     │
  │  Copia 1: Disco externo USB (borg / restic)        │  ← local
  │    - Backup automático diario con borg              │
  │    - Snapshots de los últimos 30 días               │
  │                                                     │
  │  Copia 2: NAS local (rsync)                        │  ← local, otro dispositivo
  │    - Sincronización semanal de archivos críticos    │
  │    - Montado vía NFS/Samba                          │
  │                                                     │
  │  Copia 3: Nube (restic → B2/S3)                    │  ← fuera del sitio
  │    - Backup semanal de datos críticos               │
  │    - Cifrado antes de salir de casa                 │
  └─────────────────────────────────────────────────────┘
```

---

## Automatización con systemd timers (flujo completo)

Aquí tienes un ejemplo **completo y listo para usar** que integra un script de backup con borg, variables de entorno seguras, logging y un timer de systemd. Esto unifica los conceptos de [[Cron]] y [[systemd timers]] con las herramientas de backup.

### 1. Script de backup

```bash
# ~/scripts/backup-borg.sh
#!/bin/bash
set -euo pipefail

REPO="/mnt/disco_externo/borg-repo"
LOG="/var/log/backup-borg.log"
FECHA=$(date +'%Y-%m-%d_%H-%M')

# Las variables de entorno se cargan desde el servicio systemd (EnvironmentFile)
# para no hardcodear contraseñas en el script

echo "[$(date +'%F %T')] Iniciando backup..." >> "$LOG"

borg create --stats --progress \
  "$REPO::$(hostname)-$FECHA" \
  /home/usuario/Documentos \
  /home/usuario/Fotos \
  /etc \
  --exclude '**/.cache' \
  --exclude '**/node_modules' \
  --exclude '*.iso' \
  --compression lz4 \
  >> "$LOG" 2>&1

# Limpiar snapshots viejos (policy: 7 diarios, 4 semanales, 6 mensuales)
borg prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6 "$REPO" >> "$LOG" 2>&1

echo "[$(date +'%F %T')] Backup completado." >> "$LOG"

# Notificar resultado (opcional, requiere notify-send o similar)
# notify-send "Backup borg" "Completado: $FECHA"
```

```bash
chmod +x ~/scripts/backup-borg.sh
```

### 2. Servicio systemd (define el QUÉ)

```ini
# /etc/systemd/system/backup-borg.service
[Unit]
Description=Backup Borg diario
Documentation=https://borgbackup.readthedocs.io/
Wants=network-online.target                # esperar red si el repo es remoto
After=network-online.target

[Service]
Type=oneshot
ExecStart=/home/usuario/scripts/backup-borg.sh

# EnvironmentFile para secretos (NO en el script ni en el service directo)
EnvironmentFile=/etc/systemd/backup-borg.env

# Control de recursos
CPUQuota=50%
MemoryMax=1G
IOSchedulingClass=idle                     # E/S de fondo, no afecta al usuario

# Logging
StandardOutput=journal
StandardError=journal

# Si falla, intentar 2 veces con 5 min de espera
Restart=on-failure
RestartSec=5min
StartLimitBurst=2
```

### 3. Archivo de variables de entorno (secretos)

```bash
# /etc/systemd/backup-borg.env — ¡NO versionar en Git!
# Contraseñas y rutas sensibles se cargan desde este archivo
BORG_PASSPHRASE=tu-contraseña-segura-aqui
BORG_RSH=ssh -i /home/usuario/.ssh/id_borg

# Permisos: solo root puede leerlo
sudo chown root:root /etc/systemd/backup-borg.env
sudo chmod 600 /etc/systemd/backup-borg.env
```

### 4. Timer systemd (define el CUÁNDO)

```ini
# /etc/systemd/system/backup-borg.timer
[Unit]
Description=Timer para backup Borg diario
Documentation=https://wiki.archlinux.org/title/Systemd/Timers

[Timer]
OnCalendar=daily                           # ejecutar cada día
Persistent=true                            # si estaba apagado, ejecutar al encender
RandomizedDelaySec=30min                   # evitar pico de carga a las 00:00 exactas

[Install]
WantedBy=timers.target
```

### 5. Activar todo

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now backup-borg.timer

# Probar ejecución inmediata (sin esperar al timer)
sudo systemctl start backup-borg.service

# Verificar estado
systemctl list-timers --all | grep backup
journalctl -u backup-borg.service -n 20
```

### Ventajas de este enfoque frente a cron

| Aspecto | Cron | Systemd timer |
|---|---|---|
| **Secretos** | En el script o variable de entorno | `EnvironmentFile` con `chmod 600` |
| **Logging** | Redirigir manualmente a archivo | `journalctl -u backup-borg.service` |
| **Recuperación tras apagón** | ❌ Se pierde | ✅ `Persistent=true` |
| **Control de recursos** | ❌ | ✅ CPUQuota, MemoryMax, IOSchedulingClass |
| **Notificación de fallo** | Mail (si configurado) | `OnFailure=notificar.service` |
| **Aleatorizar ejecución** | ❌ | ✅ `RandomizedDelaySec` |

> Para más detalles sobre timers, ver [[systemd timers]].

---

## Alternativas

| Herramienta | Diferencias |
|---|---|
| **Deja Dup** | Interfaz GNOME, usa duplicity por detrás, ideal para usuarios que quieren GUI |
| **Back In Time** | GUI simple para rsync con snapshots (link-dest) |
| **Kopia** | Moderno, multiplataforma, GUI + CLI, soporta S3 y nube |
| **Rclone** | Sincronización a servicios cloud (Google Drive, Dropbox, OneDrive) — no es backup deduplicado |
| **Snapper** | Snapshots de sistema (Btrfs), no es para datos personales |

## Ver también

- [[timeshift]] — backups del sistema operativo (complementa a estas herramientas)
- [[rsync]] — comando detallado
- [[Cron]] · [[systemd timers]] — automatización de backups (timer completo)
- [[Cifrado (LUKS dm-crypt GPG)]] — GPG para cifrado de duplicity
- [[Automatización y Scripts]] — scripts de backup
- [[SSH]] — claves para backups remotos automatizados

## Enlaces externos

- [Wikipedia — Borg (backup)](https://en.wikipedia.org/wiki/Borg_(backup))
- [Wikipedia — Rsync](https://en.wikipedia.org/wiki/Rsync)
- [Sitio oficial — BorgBackup](https://www.borgbackup.org/)
- [Sitio oficial — Restic](https://restic.net/)
- [GitHub — borgbackup/borg](https://github.com/borgbackup/borg)
- [GitHub — restic/restic](https://github.com/restic/restic)

#programa
