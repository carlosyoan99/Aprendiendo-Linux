---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# snapper

> Herramienta de snapshot de sistemas de archivos, principalmente Btrfs. Es la base del sistema de rollback en CachyOS y del reload/restore de instantáneas.

## Instalación

```bash
sudo pacman -S snapper        # Arch / CachyOS
```

## Sintaxis

```bash
snapper list                                # listar snapshots
snapper create --type snapshot -d "descripcion"   # crear manual
snapper list-configs                       # configuraciones
snapper delete <número>                    # borrar un snapshot
snapper rollback                           # revertir a un snapshot anterior
```

## Configuración

- Configuraciones en `/etc/snapper/configs/*`. En CachyOS se crea `/home` con `SNAPPER_BTRFS` (instalador Calamares) — snapshots automáticos por cron/systemd.
- Timeline (`--sync` + timeline_create) mantiene snapshots por hora/día/mes.

## Uso en CachyOS

CachyOS preconfigura Btrfs + Snapper: los snapshots del root `/` se guardan en la subvolumen `.snapshots`. Con `snapper rollback` se restauran el root o el home:

```bash
sudo snapper -c root rollback
```

> **Importante**: en sistemas con btrfs-as-subv-optimizado, el rollback real se hace desde el menú de arranque (bootloader) seleccionando un snapshot — no requiere entrar al sistema.

## Ver también

- [[Btrfs]] — sistema de archivos que usa snapshots
- [[timeshift]] — alternativa estilo rsync
- [[Backups (borg restic duplicity rsync)]] — nota general de respaldos

## Enlaces externos

- [snapper — GitHub](https://github.com/openSUSE/snapper)
- [Arch Wiki — Snapper](https://wiki.archlinux.org/title/Snapper)

#programa #snapshot #btrfs #rollback