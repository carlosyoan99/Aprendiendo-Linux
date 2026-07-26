---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# Timeshift

## Qué es

Timeshift es una herramienta de **backups del sistema** (tipo System Restore de Windows o Time Machine de macOS). Crea snapshots del sistema de forma periódica y permite restaurar el sistema completo a un estado anterior si algo sale mal — actualizaciones rotas, configuraciones corruptas, malware. Esencial en distribuciones rolling release como [[Arch Linux]] o [[CachyOS]].

Funciona creando snapshots de los archivos del sistema (no de `/home` por defecto) usando **rsync** (compatible con cualquier FS) o **Btrfs snapshots** (instantáneos, solo con Btrfs).

## Instalación

```bash
# Debian/Ubuntu
sudo apt install timeshift

# Arch
sudo pacman -S timeshift

# Fedora
sudo dnf install timeshift
```

## Configuración inicial

Timeshift tiene interfaz gráfica (GTK) pero también se maneja por terminal:

```bash
# Lanzar la GUI de configuración
sudo timeshift-gtk

# O desde terminal:
sudo timeshift --create --comments "antes de actualizar kernel"  # snapshot manual
sudo timeshift --list                                            # listar snapshots
```

### Asistente de primera ejecución

Al abrir Timeshift por primera vez:

1. Elegir tipo de snapshot: **Rsync** (compatible con cualquier FS) o **Btrfs** (solo si tu sistema usa Btrfs).
2. Elegir ubicación de los snapshots (preferiblemente un disco aparte del sistema).
3. Configurar frecuencia: **Monthly, Weekly, Daily** y cuántos conservar de cada tipo.
4. Elegir qué incluir/excluir: por defecto excluye `/home` y `/root`.

```bash
# Configuración típica por terminal (tras crear config inicial):
# Editar /etc/timeshift/timeshift.json para ajustes finos
```

## Uso básico

```bash
# Crear snapshots
sudo timeshift --create                    # crear snapshot con descripción automática
sudo timeshift --create --comments "antes de actualizar nvidia"  # con comentario

# Listar snapshots disponibles
sudo timeshift --list

# Restaurar un snapshot
sudo timeshift --restore                   # menú interactivo para elegir snapshot
# O especificando:
sudo timeshift --restore --snapshot '2026-07-18_12-00-00'

# Eliminar snapshots viejos
sudo timeshift --delete --snapshot '2026-07-10_15-30-00'

# Ver espacio usado por snapshots
sudo timeshift --list-devices              # discos con snapshots y su uso
```

## Programación automática

```bash
# Timeshift instala un cron/systemd timer automáticamente
# Las frecuencias se configuran desde la GUI o editando:
/etc/timeshift/timeshift.json

# Verificar timers activos:
systemctl list-timers | grep timeshift
```

## Rsync vs Btrfs

| Característica | Rsync | Btrfs |
|---|---|---|
| Compatibilidad FS | Todos (ext4, xfs, btrfs, ntfs...) | Solo Btrfs |
| Velocidad de creación | Lenta (copia archivos) | Instantánea (copia referencias) |
| Uso de disco | Copia completa la primera vez, luego incremental | Snapshot pointer + copy-on-write |
| Restauración | Copia archivos de vuelta | Cambia el subvolumen activo |
| Ideal para | Cualquier sistema | Sistemas con Btrfs (Fedora, openSUSE) |

## Notas y advertencias

- **Timeshift no es un backup de datos personales**: excluye `/home` por defecto. Para tus archivos personales usa otro método (backup manual, Deja Dup, rsync a un disco externo).
- Los snapshots **se guardan en el mismo disco** a menos que configures otro destino. Si el disco falla, los snapshots también se pierden.
- En sistemas Btrfs, los snapshots son prácticamente instantáneos y ocupan poco espacio adicional (solo los cambios desde el snapshot).
- Si no tienes Btrfs, Timeshift sigue siendo útil, pero los snapshots tardan más y ocupan más espacio.
- En sistemas rolling release (Arch, CachyOS), se recomienda crear un snapshot antes de cada `pacman -Syu` por si algo se rompe.

## Alternativas

| Herramienta | Diferencias |
|---|---|
| **Snapper** | Más potente que Timeshift, snaps automáticos configurables, ideal para Btrfs |
| **Btrbk** | Backup de snapshots Btrfs a discos externos |
| **Deja Dup** | Backup de archivos personales (no del sistema), interfaz GNOME simple |
| **rsync manual** | Control total, sin GUI |

## Ver también

- [[Cron]] · [[systemd timers]] — para programar snapshots automáticos
- [[LVM]] — snapshots de volúmenes lógicos (alternativa a nivel de bloque)
- [[Particionado y Esquemas de Disco]]
- [[systemd]]

## Enlaces externos

- [Sitio oficial — Timeshift](https://github.com/linuxmint/timeshift)
- [GitHub — linuxmint/timeshift](https://github.com/linuxmint/timeshift)
- [Linux Mint — Timeshift](https://linuxmint.com/timeshift/)

#programa
