---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPLv2+
alternativas: ZFS, Btrfs, LVM
---

# Stratis

> Demonio de gestión de almacenamiento en espacio de usuario que combina **LVM** y **XFS** para ofrecer características estilo ZFS/Btrfs (snapshots, thin provisioning, pools) sin tocar el kernel. Desarrollado por **Red Hat**.

## Qué es

Stratis es un gestor de almacenamiento **en capas** que configura y supervisa componentes existentes de Linux (LVM + XFS) a través de **D-Bus**, proporcionando una experiencia similar a ZFS o Btrfs pero utilizando tecnología probada a nivel empresarial.

A diferencia de ZFS o Btrfs —que son sistemas de archivos a nivel kernel— Stratis funciona en **espacio de usuario** como un demonio (`stratisd`) que gestiona pools y sistemas de archivos XFS con características avanzadas.

Fue desarrollado por Red Hat para RHEL 8+ y Fedora con el objetivo de tener paridad de funciones con ZFS/Btrfs pero alcanzando madurez más rápidamente al usar componentes ya consolidados (LVM, XFS, device-mapper).

## Instalación

```bash
# Fedora (viene en repos oficiales)
sudo dnf install stratisd stratis-cli

# RHEL / CentOS 8+
sudo dnf install stratisd stratis-cli

# Debian/Ubuntu (experimental)
sudo apt install stratisd stratis-cli

# Arch Linux
sudo pacman -S stratisd stratis-cli

# Iniciar el servicio
sudo systemctl enable --now stratisd
```

## Conceptos básicos

| Concepto | Descripción | Análogo en ZFS/LVM |
|---|---|---|
| **Pool** | Conjunto de discos agrupados | VG (LVM), zpool (ZFS) |
| **Filesystem** | Sistema de archivos XFS con features extras | LV (LVM), dataset (ZFS) |
| **Thin provisioning** | Los FS ocupan solo lo que usan | Sí, nativo |
| **Snapshots** | Capturas instantáneas del FS | LV snapshot (LVM) |
| **Caché** | Dispositivo SSD como caché de discos lentos | lvmcache (LVM) |

## Comandos principales

```bash
# Ver estado de Stratis
stratis --version
systemctl status stratisd

# Crear un pool con un disco
stratis pool create mi_pool /dev/sdb

# Ver pools creados
stratis pool list

# Agregar disco a pool
stratis pool add-data mi_pool /dev/sdc

# Crear sistema de archivos
stratis filesystem create mi_pool datos

# Ver sistemas de archivos
stratis filesystem list

# Montar un FS Stratis
sudo mount /dev/stratis/mi_pool/datos /mnt/datos

# Crear snapshot
stratis filesystem snapshot mi_pool datos datos-backup

# Eliminar snapshot
# (solo desmontar y destruir)
```

## Ejemplo práctico completo

```bash
# 1. Identificar discos disponibles
lsblk

# 2. Crear pool con 2 discos
sudo stratis pool create almacenamiento /dev/sdb /dev/sdc
sudo stratis pool list

# 3. Verificar características del pool
sudo stratis pool list --uuid

# 4. Crear sistema de archivos
sudo stratis filesystem create almacenamiento proyectos
sudo stratis filesystem list

# 5. Montar
sudo mkdir /proyectos
sudo mount /dev/stratis/almacenamiento/proyectos /proyectos

# 6. Crear snapshot
sudo stratis filesystem snapshot almacenamiento proyectos proyectos-2024-07-19

# 7. Ver el snapshot
sudo stratis filesystem list
```

## Stratis vs ZFS vs Btrfs vs LVM

| Característica | Stratis | ZFS | Btrfs | LVM |
|---|---|---|---|---|
| **Licencia** | GPLv2+ | CDDL (incompatible GPL) | GPL | GPL |
| **Nivel kernel** | No (espacio usuario) | Sí (módulo externo) | Sí (nativo) | Sí (nativo) |
| **Snapshots** | ✅ | ✅ | ✅ | ✅ |
| **Rollback** | ⚠️ Manual | ✅ `zfs rollback` | ✅ `btrfs subvol` | ⚠️ Manual |
| **Compresión** | ❌ (usa XFS) | ✅ | ✅ | ❌ |
| **Thin provisioning** | ✅ | ✅ | ✅ | ✅ |
| **Caché SSD** | ✅ | ✅ (ZIL/L2ARC) | ❌ | ✅ (lvmcache) |
| **RAID nativo** | ❌ (usa kernel) | ✅ | ✅ | ❌ (usa mdadm) |
| **Madurez** | Media (desde 2018) | Alta (décadas) | Alta (desde 2009) | Muy alta |
| **Soporte RHEL/Fedora** | Nativo | Manual (DKMS) | Nativo | Nativo |

```bash
# Al final, Stratis es una capa de gestión que simplifica LVM+XFS
# No reemplaza ZFS, sino que ofrece una alternativa GPL-compatible

# Caso típico: reemplazar configuraciones complejas de LVM
# Antes con LVM:
#   pvcreate, vgcreate, lvcreate, mount (4 pasos + thinpool manual)
# Con Stratis:
#   stratis pool create, stratis filesystem create, mount (3 pasos simples)
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| stratisd no arranca | Faltan módulos del kernel | `sudo modprobe dm-thin-pool` |
| No se ve el pool al reiniciar | Servicio no habilitado | `sudo systemctl enable --now stratisd` |
| FS Stratis se llena | Thin provisioning sin límite | Verificar con `df -h` y `stratis pool list` |
| Rendimiento pobre | Sin caché SSD | Agregar disco SSD como caché: `stratis pool add-cache ...` |

## Notas personales

-

## Enlaces externos

- [Sitio oficial Stratis](https://stratis-storage.github.io/)
- [Documentación Red Hat — Stratis](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_file_systems/managing-layered-local-storage-with-stratis_configuring-and-managing-file-systems)
- [Repositorio GitHub](https://github.com/stratis-storage/stratisd)
- [Wikipedia — Stratis](https://en.wikipedia.org/wiki/Stratis_(daemon))
- [FAQ oficial](https://stratis-storage.github.io/faq/)

## Ver también

- [[Sistemas de Archivos]] — ext4, Btrfs, XFS, ZFS
- [[LVM]] — Logical Volume Manager (base de Stratis)
- [[RAID (mdadm)]] — redundancia de discos
- [[zram]] — compresión en RAM
- [[SELinux y AppArmor]] — seguridad en sistemas Red Hat

#programa
