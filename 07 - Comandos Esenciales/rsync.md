---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# rsync

## Sintaxis
```
rsync [opciones] origen destino
rsync [opciones] usuario@host:/ruta/origen /ruta/destino
```

## Descripción
Copia archivos de forma **incremental**: solo transfiere las partes que cambiaron, no todo el archivo nuevamente. Esencial para backups, sincronización entre servidores y réplica de directorios. Rápido, seguro vía SSH y eficiente en ancho de banda.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-a` | Archive: preserva permisos, timestamps, propietario, y copia recursivamente |
| `-v` | Verboso (muestra lo que transfiere) |
| `-z` | Comprimir durante la transferencia (útil para redes lentas) |
| `-P` | Progress + partial: barra de progreso + permite reanudar |
| `-n` | Dry-run: muestra lo QUE HARÍA sin hacerlo (pruébalo siempre primero) |
| `--delete` | Elimina archivos en destino que ya no existen en origen |
| `--exclude=patron` | Excluir archivos que coincidan |
| `-e ssh` | Forzar uso de SSH como transporte (por defecto en remoto) |

## Ejemplos
```bash
# Local: copiar directorio
rsync -av proyecto/ backup/               # sincronizar proyecto/ con backup/

# Remoto: subir archivo a servidor
rsync -avz archivo.zip usuario@servidor:/home/usuario/

# Remoto: bajar archivo del servidor
rsync -avz usuario@servidor:/home/usuario/backup.sql .

# Backup con barra de progreso y reanudación
rsync -avzP ~/Documentos/ /mnt/disco_externo/backup-docs/

# Dry-run: ver qué se copiaría sin hacerlo
rsync -avn ~/Documentos/ /mnt/disco_externo/backup-docs/

# Sincronización exacta (espejo): eliminar archivos que ya no están en origen
rsync -av --delete origen/ destino/       # ¡cuidado! borra en destino lo que falte en origen

# Excluir carpetas
rsync -av --exclude=".cache" --exclude="node_modules" ~/proyecto/ ~/backup-proyecto/

# Usar puerto SSH no estándar
rsync -avz -e "ssh -p 2222" archivo.zip usuario@servidor:/destino
```

## Casos de uso reales

### Backup diario de documentos a disco externo

```bash
rsync -avzP --delete ~/Documentos/ /mnt/disco_externo/backup-docs/
# Primera vez: copia todo (puede tardar)
# Segunda vez y siguientes: solo los cambios (rápido)
```

### Sincronizar proyecto web a servidor de producción

```bash
rsync -avz --delete --exclude="node_modules" --exclude=".git" \
  ~/mi-proyecto/ usuario@servidor:/var/www/mi-sitio/
# Sube solo los archivos cambiados, excluye node_modules y .git
```

### Migrar datos de un servidor a otro

```bash
rsync -avzP --remove-source-files usuario@servidor-viejo:/datos/ /datos/
# Transfiere todo, borra origen cuando se confirma copia
# Útil para migraciones controladas
```

## Combinaciones comunes con pipe

```bash
# rsync no se usa directamente con pipe (es copia de archivos), pero:
# Listar qué se transferiría (para logs)
rsync -avn --delete ~/proyecto/ backup/ | tee dry-run.log

# rsync sobre SSH con compresión y limitación de ancho de banda
rsync -avzP --bwlimit=5000 -e "ssh" ~/video.mp4 usuario@servidor:/videos/
# --bwlimit=5000 = 5 MB/s máximo, evita saturar la subida

# Backups incrementales con hard links (snapshots tipo Time Machine)
rsync -avP --delete --link-dest=../backup-ayer ~/Documentos/ ~/backup-hoy/
# backup-hoy parece completo pero solo ocupa los cambios
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `rsync` | `rclone` | Sincroniza con cloud (Google Drive, Dropbox, S3, etc.) |
| `rsync -av` | `unison` | Sincronización bidireccional (rsync es unidireccional) |
| `rsync --link-dest` | `restic` / `borg` | Backups con deduplicación, cifrado y versiones |

```bash
# rclone — sincronización con servicios cloud
sudo apt install rclone
rclone sync ~/Documentos/ gdrive:backup-docs/

# restic — backups cifrados con versiones
sudo apt install restic
restic init --repo /mnt/backup/          # inicializar repo
restic backup ~/Documentos/               # backup versionado
restic snapshots                          # listar versiones
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| La barra `/` final cambia el comportamiento | Sin `/` al final: copia la carpeta. Con `/`: copia el contenido | `rsync -av dir/ dest/` (contenido) vs `rsync -av dir dest/` (carpeta) |
| `Permission denied (publickey)` | SSH sin clave configurada | Usar `ssh-copy-id usuario@servidor` primero |
| `rsync error: some files could not be transferred` | Permisos o archivos en uso | Usar `--ignore-errors` o verificar archivos específicos |
| La transferencia es muy lenta en WAN | Sin compresión habilitada | Usar `-z` (compresión) y `--bwlimit` si es necesario |
| `--delete` borró archivos que no debía | El path fuente estaba mal escrito | **Siempre** probar con `-n` (dry-run) antes de `--delete` |

## Notas y advertencias
- La **barra final** (`/`) importa: `rsync -av origen/ destino/` copia el **contenido** de origen dentro de destino. `rsync -av origen destino/` copia la **carpeta origen** dentro de destino. Confuso al principio, pero crucial.
- Siempre probar con `-n` (dry-run) antes del comando real, sobre todo si usas `--delete`.
- `rsync` es ideal para backups periódicos porque después de la primera vez, solo transfiere los cambios (mucho más rápido que `cp` o `scp`).
- Para backups importantes, combinar con `--link-dest` para backups incrementales con snapshots completos (cada backup parece completo pero solo ocupa los cambios).

## Ver también
- [[cp]]
- [[SSH]] (scp)
- [[tar]]
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — rsync](https://en.wikipedia.org/wiki/Rsync)
- [Sitio oficial — rsync](https://rsync.samba.org/)
- [Documentación — rsync man page](https://man7.org/linux/man-pages/man1/rsync.1.html)

#comando
