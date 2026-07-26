---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# BorgBackup

## Qué es

**BorgBackup** (borg) es una herramienta de backup deduplicada, comprimida y cifrada para Linux. Divide los archivos en **bloques de ~64 KB** y cada bloque se almacena una sola vez — si modificas 2 KB de un archivo de 1 GB, solo se guardan esos 2 KB nuevos. Es la herramienta de backup más eficiente en espacio para Linux.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install borgbackup

# Arch
sudo pacman -S borg

# Fedora
sudo dnf install borgbackup
```

## Uso básico

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

# 5. Montar un snapshot como sistema de archivos (sin restaurar, requiere fuse)
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

## Backup remoto vía SSH

```bash
# Inicializar repositorio remoto
borg init --encryption=repokey-blake2 usuario@servidor:/backups/borg-repo

# Crear snapshot remoto
borg create --stats --progress \
  usuario@servidor:/backups/borg-repo::fotos-$(date +%Y-%m-%d) \
  /home/usuario/Fotos/

# Usar clave SSH sin contraseña (recomendado para automatización)
ssh-keygen -t ed25519 -f ~/.ssh/id_borg -N ""
ssh-copy-id -i ~/.ssh/id_borg usuario@servidor
export BORG_RSH="ssh -i ~/.ssh/id_borg"
```

## Ver repositorio

```bash
# Ver estadísticas: tamaño original vs almacenado
borg info /mnt/disco_externo/borg-repo

# Verificar integridad
borg check /mnt/disco_externo/borg-repo

# Cambiar contraseña
borg key change-passphrase /mnt/disco_externo/borg-repo
```

## Automatización con systemd timers (flujo completo)

Aquí tienes un ejemplo **completo y listo para usar** que integra un script de backup con borg, variables de entorno seguras, logging y un timer de systemd. Esto unifica los conceptos de [[Cron]] y [[systemd timers]] con borg.

### 1. Script de backup

```bash
# ~/scripts/backup-borg.sh
#!/bin/bash
set -euo pipefail

REPO="/mnt/disco_externo/borg-repo"
LOG="/var/log/backup-borg.log"
FECHA=$(date +'%Y-%m-%d_%H-%M')

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

borg prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6 "$REPO" >> "$LOG" 2>&1

echo "[$(date +'%F %T')] Backup completado." >> "$LOG"
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
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/home/usuario/scripts/backup-borg.sh
EnvironmentFile=/etc/systemd/backup-borg.env
CPUQuota=50%
MemoryMax=1G
IOSchedulingClass=idle
StandardOutput=journal
StandardError=journal
Restart=on-failure
RestartSec=5min
StartLimitBurst=2
```

### 3. Archivo de variables de entorno (secretos)

```bash
# /etc/systemd/backup-borg.env — ¡NO versionar en Git!
BORG_PASSPHRASE=tu-contraseña-segura-aqui
BORG_RSH=ssh -i /home/usuario/.ssh/id_borg

sudo chown root:root /etc/systemd/backup-borg.env
sudo chmod 600 /etc/systemd/backup-borg.env
```

### 4. Timer systemd (define el CUÁNDO)

```ini
# /etc/systemd/system/backup-borg.timer
[Unit]
Description=Timer para backup Borg diario

[Timer]
OnCalendar=daily
Persistent=true
RandomizedDelaySec=30min

[Install]
WantedBy=timers.target
```

### 5. Activar todo

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now backup-borg.timer
sudo systemctl start backup-borg.service
systemctl list-timers --all | grep backup
journalctl -u backup-borg.service -n 20
```

### Ventajas frente a cron

| Aspecto | Cron | Systemd timer |
|---|---|---|
| **Secretos** | En el script | `EnvironmentFile` con `chmod 600` |
| **Logging** | Redirigir a archivo | `journalctl -u backup-borg.service` |
| **Recuperación tras apagón** | ❌ Se pierde | ✅ `Persistent=true` |
| **Control de recursos** | ❌ | ✅ CPUQuota, MemoryMax, IOSchedulingClass |
| **Aleatorizar ejecución** | ❌ | ✅ `RandomizedDelaySec` |

## Ver también

- [[restic]] — alternativa rápida con múltiples destinos cloud
- [[duplicity]] — backup cifrado con GPG (legacy)
- [[Backups (borg restic duplicity rsync)]] — índice comparativo y estrategia 3-2-1
- [[rsync]] — sincronización de archivos
- [[Cron]] · [[systemd timers]] — automatización de backups

## Enlaces externos

- [Sitio oficial — BorgBackup](https://www.borgbackup.org/)
- [GitHub — borgbackup/borg](https://github.com/borgbackup/borg)
- [Wikipedia — Borg (backup)](https://en.wikipedia.org/wiki/Borg_(backup))
- [Documentación oficial](https://borgbackup.readthedocs.io/)

#programa
