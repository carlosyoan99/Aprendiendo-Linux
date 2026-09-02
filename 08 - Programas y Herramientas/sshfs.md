---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: programa
prioridad: media
---

# sshfs

> Monta un sistema de archivos remoto vía SSH como si fuera una carpeta local. Ideal para acceder a archivos en servidores sin descargarlos.

## Qué es

**sshfs** es un cliente de sistema de archivos FUSE que usa SSH para montar directorios remotos. Permite trabajar con archivos en un servidor como si estuvieran en una carpeta local (leer, escribir, copiar, editar), sin necesidad de `scp` o `rsync` para cada operación individual.

## Instalación

```bash
sudo apt install sshfs             # Debian / Ubuntu
sudo pacman -S sshfs               # Arch / CachyOS
sudo dnf install sshfs             # Fedora
```

> **Nota:** Requiere `ssh` instalado y acceso al servidor remoto por SSH.

## Sintaxis

```bash
sshfs usuario@host:/ruta/remota /mnt/local          # montar
fusermount -u /mnt/local                             # desmontar (FUSE 2)
fusermount3 -u /mnt/local                            # desmontar (FUSE 3)
umount /mnt/local                                    # desmontar (alternativa)
sshfs usuario@host:/ruta /mnt -o reconnect           # reconexión automática
sshfs usuario@host:/ruta /mnt -o follow_symlinks     # seguir enlaces simbólicos
sshfs usuario@host:/ruta /mnt -o ro                  # solo lectura
sshfs usuario@host:/ruta /mnt -o port=2222           # puerto SSH personalizado
```

## Uso típico

```bash
# 1. Crear punto de montaje
sudo mkdir -p /mnt/miservidor

# 2. Montar
sshfs admin@192.168.1.100:/home/admin/proyectos /mnt/miservidor

# 3. Trabajar normalmente
ls /mnt/miservidor
cp /mnt/miservidor/archivo.txt ~/Desktop/
nano /mnt/miservidor/config.yaml

# 4. Desmontar cuando termines
fusermount -u /mnt/miservidor
```

## Opciones útiles

| Opción | Efecto |
|---|---|
| `-o reconnect` | Reconectar automáticamente si se cae la conexión |
| `-o ro` | Montar solo lectura |
| `-o port=2222` | Puerto SSH personalizado |
| `-o follow_symlinks` | Seguir symlinks remotos |
| `-o id_map=user` | Mapear UID/GID del usuario local |
| `-o no_readahead` | Sin prefetch (útil para archivos grandes) |
| `-o cache=no` | Sin caché (siempre lee del servidor) |

## Montaje automático con fstab

```bash
# En /etc/fstab (con clave SSH configurada o key-based):
sshfs#usuario@host:/ruta/remota /mnt/local fuse ro,reconnect,auto 0 0

# O con systemd mount unit:
# /etc/systemd/system/mnt-miservidor.mount
[Unit]
Description=Montaje sshfs del servidor
After=network-online.target

[Mount]
What=sshfs#admin@192.168.1.100:/home/admin/proyectos
Where=/mnt/miservidor
Type=fuse
Options=ro,reconnect,auto

[Install]
WantedBy=multi-user.target
```

## sshfs vs rsync vs scp vs NFS

| Aspecto | sshfs | rsync | scp | NFS |
|---|---|---|---|---|
| Tipo | Montaje en vivo | Sincronización | Copia puntual | Montaje en red |
| Acceso interactivo | Sí | No | No | Sí |
| Velocidad inicial | Media | Alta (delta) | Media | Alta |
| Latencia | Depende de SSH | Optimizada | Depende de SSH | Baja (LAN) |
| Ideal | Edición remota | Backup/sync | Copia rápida | Red local |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| "Transport endpoint is not connected" | Montaje previo no limpiado | `fusermount -u /mnt` o `umount -l /mnt` |
| Lentísimo al listar archivos | Sin caché + SSH lento | Añadir `-o cache=yes,max_readahead=0` |
| "Permission denied" | Clave SSH no configurada | Configurar SSH keys con `ssh-copy-id` |
| No se desmonta | Proceso usando el montaje | `fuser -k /mnt` antes de desmontar |

## Ver también

- [[rsync]] — sincronización de archivos
- [[SSH]] — acceso remoto
- [[FHS]] — jerarquía de directorios
- [[NFS]] — montaje de red local

## Enlaces externos

- [Arch Wiki — sshfs](https://wiki.archlinux.org/title/sshfs)
- [GitHub — sshfs](https://github.com/libfuse/sshfs)

#programa #redes #ssh #fuse
