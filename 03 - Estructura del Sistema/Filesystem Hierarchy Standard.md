---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: sistema
prioridad: alta
---

# Filesystem Hierarchy Standard (FHS)

## Definición

El FHS define la estructura de directorios estándar en Linux. Todo el sistema de archivos es un solo árbol que parte de la raíz `/`, a diferencia de Windows donde cada disco tiene su propia raíz (`C:\`, `D:\`).

```bash
tree -L 1 /            # ver las carpetas principales (puede tardar)
ls /                   # versión rápida
```

## Directorios clave y su propósito

| Ruta | Contenido | Cuándo te importa |
|------|-----------|-------------------|
| `/bin` | Ejecutables esenciales del sistema (`ls`, `cp`, `cat`, `bash`) | Cuando un comando deja de funcionar (suele ser symlink a `/usr/bin` hoy en día) |
| `/sbin` | Ejecutables del sistema para administración (`fdisk`, `mkfs`, `iptables`) | Similar a `/bin`, usualmente requiere `sudo` |
| `/etc` | Archivos de configuración globales (texto plano) | Cuando editas config de red, repos, servicios — casi todo está aquí |
| `/home` | Directorios personales de usuarios (`/home/tu_usuario`) | Tus archivos, dotfiles, descargas |
| `/root` | Home del usuario root | Cuando trabajas como superusuario |
| `/var` | Datos variables: logs, colas de impresión, bases de datos | `/var/log` es lo primero que revisas al troubleshootear |
| `/usr` | Programas y datos compartidos (no esenciales para el arranque) | Donde están la mayoría de binarios, librerías y documentación |
| `/tmp` | Archivos temporales — se borran al reiniciar | Útil para descargas rápidas o archivos que no necesitas conservar |
| `/dev` | Dispositivos del sistema (discos, USBs, terminales) | Cuando usas `lsblk` para encontrar un disco |
| `/proc` | Info del kernel y procesos en tiempo real (sistema de archivos virtual) | `cat /proc/cpuinfo`, `/proc/meminfo`, `/proc/version` |
| `/sys` | Información y configuración de dispositivos y drivers (virtual) | Más moderno que `/proc`, usado por herramientas como `systemd` |
| `/boot` | Archivos del kernel y bootloader (vmlinuz, initramfs, GRUB) | Cuando actualizas el kernel o reparas el arranque |
| `/opt` | Software opcional de terceros (no gestionado por el gestor de paquetes) | Donde instalan cosas como Google Earth, IntelliJ, etc. |
| `/mnt` / `/media` | Puntos de montaje temporales (manual / automático) | Cuando montas un USB o disco externo |
| `/srv` | Datos de servicios del sistema (servidores web, FTP) | Raro en escritorio; aparece si montas un servidor |

## Evolución: `/bin` y `/sbin` → `/usr/bin`

En distribuciones modernas (Fedora, Arch, Debian reciente), `/bin`, `/sbin` y `/lib` son **symlinks** a `/usr/bin`, `/usr/sbin` y `/usr/lib`. Esto simplifica el árbol:

```bash
ls -la /bin     # probablemente veas: lrwxrwxrwx ... /bin -> usr/bin
ls -la /sbin    # lrwxrwxrwx ... /sbin -> usr/sbin
```

## Convenciones importantes

| Convención | Explicación |
|---|---|
| `/usr/local/` | Para software compilado manualmente (no entra en conflicto con paquetes del sistema) |
| `/etc/` guarda config, los binarios van en `/usr/bin` | Separación clara: config vs ejecutables |
| Los dotfiles del usuario van en `$HOME` | `~/.bashrc`, `~/.config/`, etc. |
| Los archivos de socket/pipe van en `/run` o `/tmp` | Comunicación entre procesos en tiempo real |

## Por qué importa

Saber qué va dónde te permite:
- Encontrar logs rápidamente (`/var/log`)
- Editar config sin buscar (`/etc/`)
- No llenar `/tmp` con cosas que necesitas guardar
- Entender qué borra cada `apt autoremove` vs qué está en `/usr/local/`

## Ver también

- [[Que es Linux]]
- [[Permisos y Propietarios]]
- [[Symlinks y Dotfiles]]

## Enlaces externos

- [Wikipedia — Filesystem Hierarchy Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)
- [Linux Foundation — FHS](https://www.linuxfoundation.org/)
- [Arch Wiki — File System Hierarchy](https://wiki.archlinux.org/title/File_system_hierarchy)

#sistema #fhs
