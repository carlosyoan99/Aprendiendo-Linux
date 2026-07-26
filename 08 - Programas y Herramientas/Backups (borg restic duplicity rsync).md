---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# Backups (borg, restic, duplicity, rsync)

## Qué son

Herramientas de **backup de datos** (archivos personales, bases de datos, configuraciones) que permiten copias de seguridad automáticas, cifradas, y eficientes en espacio gracias a deduplicación y compresión. A diferencia de [[timeshift]] (que protege el sistema operativo), estas herramientas están diseñadas para proteger **tus datos personales** contra pérdida accidental, ransomware, o fallo de disco.

## Notas individuales

Cada herramienta tiene ahora su propia nota:

- [[borg]] — backup deduplicado, cifrado y comprimido (máxima eficiencia de espacio)
- [[restic]] — backup rápido y flexible con múltiples destinos cloud
- [[duplicity]] — backup cifrado con GPG (maduro, legacy)
- [[rsync]] — sincronización de archivos (comando detallado)

## Visión general

| Herramienta | Enfoque | Deduplicación | Cifrado | Remoto (SSH) | Snapshots | Ideal para |
|---|---|---|---|---|---|---|
| **rsync** | Sincronización de archivos | ❌ No | ❌ No (pero vía SSH) | ✅ Sí | ❌ No | Backups simples, sincronización diaria |
| **borg** | Backup deduplicado | ✅ Sí (por bloques) | ✅ Sí (clave/contraseña) | ✅ Sí (ssh) | ✅ Sí | Grandes volúmenes, backups frecuentes |
| **restic** | Backup rápido y flexible | ✅ Sí (por bloques) | ✅ Sí | ✅ Sí (ssh, s3, r2, etc.) | ✅ Sí | Múltiples destinos (local + cloud) |
| **duplicity** | Backup cifrado tradicional | ❌ No (solo compresión) | ✅ Sí (GPG) | ✅ Sí (ssh, s3, ftp) | ❌ No | Backups cifrados simples, legado |

## Tabla comparativa detallada

| Característica | rsync | borg | restic | duplicity |
|---|---|---|---|---|
| **Velocidad 1er backup** | Rápida | Media (divide en bloques) | Media (divide en bloques) | Lenta (cifra cada archivo) |
| **Velocidad backups siguientes** | Rápida (solo cambios) | Muy rápida (solo bloques nuevos) | Muy rápida (solo bloques nuevos) | Lenta (cifra de nuevo) |
| **Deduplicación** | ❌ | ✅ Por bloques (~64KB) | ✅ Por bloques (variable) | ❌ |
| **Compresión** | ❌ | ✅ (lz4, zstd, lzma) | ✅ | ✅ (gzip, bzip2) |
| **Cifrado** | SSH (transporte) | ✅ AES-256 (en reposo) | ✅ AES-256 (en reposo) | ✅ GPG (en reposo) |
| **Montar snapshot como FS** | ❌ | ✅ `borg mount` | ✅ `restic mount` | ❌ |
| **Múltiples destinos** | SSH, local | SSH, local | **S3, B2, GCS, Azure, SFTP, REST** | SSH, S3, FTP, local |

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

## Alternativas adicionales

| Herramienta | Diferencias |
|---|---|
| **Deja Dup** | Interfaz GNOME, usa duplicity por detrás, ideal para usuarios que quieren GUI |
| **Back In Time** | GUI simple para rsync con snapshots (link-dest) |
| **Kopia** | Moderno, multiplataforma, GUI + CLI, soporta S3 y nube |
| **Rclone** | Sincronización a servicios cloud (Google Drive, Dropbox, OneDrive) |
| **Snapper** | Snapshots de sistema (Btrfs), no es para datos personales |

## Ver también

- [[timeshift]] — backups del sistema operativo (complementa a estas herramientas)
- [[Cron]] · [[systemd timers]] — automatización de backups
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
