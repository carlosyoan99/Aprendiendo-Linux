---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: media
---

# snapper

> Herramienta de snapshot de sistemas de archivos, principalmente Btrfs. Es la base del sistema de rollback en CachyOS y del reload/restore de instantáneas.

## Qué es

- Utilidad desarrollada por **openSUSE** para crear y gestionar **snapshots** (instantáneas) de sistemas de archivos. Funciona principalmente sobre **Btrfs**, aprovechando sus subvolúmenes y el COW (copy-on-write), que hace los snapshots casi instantáneos y de bajo costo.
- Permite revertir el sistema a un estado anterior (rollback), útil antes de actualizaciones o cambios de configuración arriesgados.
- Integra cron/systemd (timers) para snapshots automáticos por hora, día, semana y mes (timeline), además de snapshots manuales.
- Cada snapshot puede tener una *descripción y presetname* (tipo) para clasificarlo.

## Instalación

```bash
sudo pacman -S snapper        # Arch / CachyOS
sudo apt install snapper      # Debian / Ubuntu
sudo dnf install snapper      # Fedora
# openSUSE suele traerlo preinstalado
```

## Sintaxis

```bash
snapper list                                # listar snapshots
snapper create --type snapshot -d "descripcion"   # crear manual
snapper list-configs                       # configuraciones
snapper delete <número>                    # borrar un snapshot
snapper rollback                           # revertir a un snapshot anterior
snapper status <a>..<b>                    # ver cambios entre snapshots
snapper diff <a>..<b>                      # ver diff de archivos
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

## snapper vs Btrfs-assistant vs timeshift

| Aspecto | Regular snapper | Btrfs Assistant | timeshift |
|---|---|---|---|
| Backend | Btrfs nativo | GUI sobre snapper | rsync o Btrfs |
| Rollback | CLI + bootloader | GUI | CLI |
| Automático | Cron/timers | Automa | Cron |
| Interfaz | CLI | GUI | GUI/CLI |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No hay `root` config | Falta `snapper -c root create-config` | Crear la configuración del root |
| Rollback no aparece | bootloader sin entry de snapshot | Usar Btrfs-assistant o regenerar GRUB |
| Snapshots ocupan mucho | Mucha timeline sin limpieza | Ajustar timelimit al config |

## Ver también

- [[Btrfs]] — sistema de archivos que usa snapshots
- [[timeshift]] — alternativa estilo rsync
- [[Backups (borg restic duplicity rsync)]] — nota general de respaldos

## Enlaces externos

- [snapper — GitHub](https://github.com/openSUSE/snapper)
- [Arch Wiki — Snapper](https://wiki.archlinux.org/title/Snapper)

#programa #snapshot #btrfs #rollback