---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: programa
prioridad: alta
---

# NTFS-3G

## Definición

**NTFS-3G** es un controlador de código abierto (GPL) para el sistema de archivos **NTFS** de Microsoft Windows en sistemas Linux, macOS, FreeBSD y Haiku. Proporciona **soporte completo de lectura y escritura** en particiones NTFS.

A diferencia del controlador NTFS incluido en el kernel de Linux, que solo permite lectura, NTFS-3G permite crear, renombrar, mover y borrar archivos en NTFS de cualquier tamaño (excepto archivos cifrados con EFS) mediante FUSE (Filesystem in Userspace).

> A partir del kernel Linux 5.15, el nuevo controlador **ntfs3** (desarrollado por Paragon) se incluye en el kernel y ofrece mejor rendimiento que NTFS-3G. Sin embargo, NTFS-3G sigue siendo una alternativa sólida y más probada.

## NTFS-3G vs ntfs3 (kernel) vs ntfs (kernel legacy)

| Característica | ntfs (legacy) | NTFS-3G | ntfs3 (Paragon) |
|---|---|---|---|
| **Rendimiento** | Bajo | ⭐⭐⭐ Bueno (vía FUSE) | ⭐⭐⭐⭐ Excelente (en kernel) |
| **Escritura** | ❌ No | ✅ Sí | ✅ Sí |
| **Archivos cifrados EFS** | ❌ | ⚠️ No soportado | ❌ Documentación limitada |
| **ACLs** | ❌ | ⚠️ Lectura básica | ⚠️ Parcial |
| **Compresión NTFS** | ❌ | ⚠️ Lectura | ⚠️ Parcial |
| **Transacciones NTFS** | ❌ | ⚠️ Limitado | ✅ |
| **Desde kernel** | 2.6 | 5.15 |
| **Licencia** | GPL | GPL | GPL |

## Instalación

```bash
# Debian/Ubuntu
sudo apt install ntfs-3g

# Arch Linux
sudo pacman -S ntfs-3g

# Fedora
sudo dnf install ntfs-3g

# Una vez instalado, montar usando mount normal:
sudo mount -t ntfs-3g /dev/sda1 /mnt/windows

# O automáticamente (mount -a si está en fstab)
```

## Uso básico

```bash
# Montar una partición NTFS manualmente
sudo mount -t ntfs-3g /dev/sda1 /mnt/windows

# Montar con permisos específicos para tu usuario
sudo mount -t ntfs-3g -o uid=1000,gid=1000,umask=022 /dev/sda1 /mnt/windows

# Montar en /etc/fstab (para montaje automático al arrancar)
echo "UUID=XXXX-XXXX /mnt/windows ntfs-3g uid=1000,gid=1000,dmask=022,fmask=133 0 0" | sudo tee -a /etc/fstab

# Desmontar
sudo umount /mnt/windows
```

### Opciones de montaje frecuentes

| Opción | Efecto |
|---|---|
| `uid=1000,gid=1000` | El usuario con UID 1000 será el propietario de los archivos |
| `umask=022` | Permisos por defecto: 755 directorios, 644 archivos |
| `dmask=000,fmask=111` | Permisos completos para todos (similar a Windows) |
| `noexec` | No permitir ejecución de binarios (seguridad) |
| `locale=es_ES.UTF-8` | Forzar codificación de caracteres |
| `big_writes` | Mejor rendimiento en escrituras grandes |
| `force` | Forzar montaje aunque la partición esté "dirty" (no desmontada limpiamente) |

## Recuperación y reparación

```bash
# Verificar y reparar una partición NTFS (como chkdsk en Windows)
sudo ntfsfix /dev/sda1

# Forzar montaje aunque la partición esté sucia
sudo mount -t ntfs-3g -o force /dev/sda1 /mnt/windows

# Si ntfsfix no es suficiente, necesitarás Windows (chkdsk /f)
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `NTFS is either inconsistent, or there is no ntfs-3g installed` | Partición no desmontada limpiamente en Windows | `sudo ntfsfix /dev/sda1` o arrancar Windows y apagar correctamente |
| `Wrong NTFS, blocksize not power of 2` | Estructura NTFS dañada | `sudo ntfsfix -b /dev/sda1` (backup boot sector) |
| `Failed to mount: Operation not permitted` | Secure Boot bloqueando FUSE | Desactivar Secure Boot en BIOS/UEFI |
| Archivos sin permisos de escritura | Partición montada como solo lectura | Verificar que Windows Fast Startup está deshabilitado (es la causa #1) |
| Muy lento al copiar archivos grandes | ntfs-3g sobre USB 2.0 | Usar `big_writes`, o considerar `exfat` para discos externos |

## Desactivar Windows Fast Startup (¡IMPORTANTE!)

Windows **Fast Startup** (Inicio rápido) deja la partición NTFS en estado "hibernado", lo que impide el montaje en modo escritura desde Linux:

```bash
# En Windows PowerShell (como administrador):
powercfg /h off
```

O en Windows: Panel de control → Opciones de energía → Elegir comportamiento del botón de inicio/apagado → Desactivar "Activar inicio rápido".

## Notas personales

- En dual boot, la causa #1 de problemas es **Fast Startup de Windows**. Desactívalo siempre
- Para discos externos formateados en NTFS (like USB drives), `ntfs-3g` funciona perfectamente
- Si usas kernel 6.2+, considera probar el driver ntfs3 (Paragon) que viene incluido — monta con `-t ntfs3` en lugar de `-t ntfs-3g`
- ExFAT es mejor opción para discos externos compartidos entre Linux, Windows y Mac (ver `exfatprogs`)

## Enlaces externos

- [Página oficial de NTFS-3G](https://www.tuxera.com/community/open-source-ntfs-3g/) (Tuxera)
- [Arch Wiki — NTFS-3G](https://wiki.archlinux.org/title/NTFS-3G)
- [Wikipedia — NTFS-3G](https://es.wikipedia.org/wiki/NTFS-3G)
- [NTFS-3G FAQ](https://www.tuxera.com/community/ntfs-3g-faq/)

## Ver también

- [[Dual Boot con Windows]] — gestión de NTFS en dual boot
- [[Particionado y Esquemas de Disco]] — esquemas de disco compatibles
- [[Sistemas de Archivos]] — comparativa entre sistemas de archivos
- [[Cifrado (LUKS dm-crypt GPG)]] — cifrado de discos que puede contener NTFS

#programa #ntfs #sistemadearchivos
