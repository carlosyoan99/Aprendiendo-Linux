---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: sistema
prioridad: alta
---

# fstab (montaje automático de discos)

## Definición
**`/etc/fstab`** (File System Table) es el archivo de configuración que le dice a Linux **qué sistemas de archivos montar y cómo**, en el arranque o bajo demanda. Cada línea define un punto de montaje (partición, disco, USB, NFS, swap...). Es el sitio para que tus discos y particiones se monten siempre en el mismo lugar sin tener que ejecutar `mount` a mano cada vez.

> `mount` monta **una vez y para ese momento**; `fstab` lo hace **persistente** en todos los arranques. Por eso `fstab` es lo primero que se configura tras instalar una distro o añadir un disco.

## Por qué importa
Sin `fstab`, tras cada reinicio tendrías que montar manualmente cada partición interna (tu `/home` en un disco aparte, un disco de datos, tu disco externo...). Con `fstab` bien configurado, todo aparece automáticamente en el mismo sitio, con las mismas opciones (permisos, modo, sellado), de forma predecible. Es esencial para:
- Montar automáticamente particiones de datos en el arranque.
- Configurar `swap` (aunque systemd moderno lo detecte también por GPT).
- Montar compartidas de red (NFS, CIFS/Samba) o dispositivos USB/removibles con opciones concretas.
- Montar imágenes ISO o sistemas en memoria (`tmpfs`) con opciones.

## Sintaxis del archivo — las 6 columnas

Cada línea no vacía y no comentada (`#`) sigue este formato:

```
<device>       <mount_point>   <filesystem>   <options>   <dump>   <fsck order>
```

| Columna | Significado | Ejemplo |
|---|---|---|
| **1. device** | Dispositivo o identificador (mejor usar `UUID=`/`LABEL=` que `/dev/sdX`) | `UUID=abc-123` |
| **2. mount point** | Directorio donde se monta | `/`, `/home`, `/mnt/datos` |
| **3. filesystem** | Tipo de sistema de archivos | `ext4`, `btrfs`, `xfs`, `swap`, `ntfs-3g`, `exfat`, `nfs`, `cifs` |
| **4. options** | Opciones de montaje separadas por comas (`defaults` = conjunto habitual) | `defaults`, `noatime` |
| **5. dump** | Si se hace backup con `dump` (casi siempre `0`) | `0` |
| **6. fsck order** | Orden de chequeo: `/`=1, resto de particiones=2, `0`=no comprobar | `1`, `2`, `0` |

### Columna 6 — orden fsck
- `1` → se verifica primero (normalmente solof variar la raíz `/`).
- `2` → se verifican después (otras particiones del sistema).
- `0` → no se verifica al arrancar (swap, particiones de datos, red, etc.).

### Columna 5 — dump
Casi siempre `0`. Solo se usa `1` si quieres que `dump` haga backup del FS.

## Ejemplo de fstab real

```
# device (UUID)   mount point  fs      options                    dump  fsck
UUID=abcd-1234    /            ext4    defaults,noatime            0      1
UUID=efgh-5678    /home        ext4    defaults                    0      2
UUID=swap-xxxx    none         swap    sw                          0      0
/dev/sdb1         /mnt/datos   xfs     defaults,noatime            0      2
192.168.1.10:/srv /mnt/nfs     nfs     defaults,noatime            0      0
LABEL=Data        /mnt/usb     exfat   defaults,uid=1000,gid=1000  0      0
tmpfs             /tmp         tmpfs   defaults,noatime,mode=1777  0      0
```

## Cómo obtener los UUID de tus discos

```bash
sudo blkid                  # UUID + tipo de FS de todos los dispositivos
lsblk -f                    # árbol de disco + FS + UUID + punto de montaje
```

> ⚠️ **Prefiere `UUID=`** en lugar de `/dev/sdX`. Los nombres `/dev/sda`, `/dev/sdb` cambian según el orden de detección del kernel y pueden "saltar" entre arranques; el UUID es estable.

## Opciones de montaje frecuentes

| Opción | Efecto | Uso típico |
|---|---|---|
| `defaults` | `rw,suid,dev,exec,auto,nouser,async` | valor por defecto casi siempre |
| `noauto` | No montar automáticamente; solo a demanda (`mount /punto`) | discos opcionales |
| `nofail` | No bloquear el arranque si el dispositivo no está | discos externos/USB |
| `noatime` | No actualizar tiempos de acceso (menos escrituras, más rápido) | SSD, /home |
| `nodiratime` | Igual pero solo directorios | ahorro de I/O |
| `ro` | Montar solo lectura | backups, respecto a datos |
| `uid=1000,gid=1000` | Forzar propietario a un usuario/grupo | FAT/exFAT/NTFS |
| `umask=022` | Máscara de permisos por defecto (022 = 755) | FAT/exFAT |
| `exec` / `noexec` | Permitir / impedir ejecutar binarios | seguridad en /tmp |
| `users` / `user` | Permitir que usuarios monten/desmonten | USB/removibles |
| `auto` | Montar con `mount -a` (arranque) | control con `noauto` |
| `discard` | Habilitar TRIM continuo (SSD) | SSD |
| `errors=remount-ro` | Pasar a solo lectura ante errores | sistemas críticos |
| `nodev`, `nosuid`, `nostick` | Endurecer (negar dispositivos/setuid) | particiones con datos de usuario |

### Opciones de red (NFS / CIFS-Samba)
```bash
# NFS: montar en arranque de forma robusta
192.168.1.10:/vol /mnt/nfs  nfs  rw,noatime,noatime,nofail,nolock,x-systemd.automount  0 0

# CIFS/SMB (Windows/Samba) con credenciales en archivo
//192.168.1.20/compartido /mnt/win  cifs  credentials=/etc/smbcreds,uid=1000,gid=1000,iocharset=utf8  0 0
```

## Probar y aplicar cambios

```bash
sudo mount -a                    # montar todo lo de fstab (¡prueba tu edición sin reiniciar!)
sudo umount -a                   # desmontar todo (CUIDADO, desmonta todo)
findmnt --verify                 # validar fstab (systemd): reporta errores de sintaxis
sudo systemd-analyze verify /etc/fstab   # chequear con las herramientas de systemd
```

> ⚠️ **Antes de reiniciar**, ejecuta `sudo mount -a` y `findmnt --verify` para comprobar que tu fstab es correcto. Un `fstab` mal escrito puede impedir el arranque (caes a `emergency mode`).

## Montaje bajo demanda con systemd automount

Para no montar unidades de red/externas hasta que se acceda a ellas, systemd soporta `x-systemd.automount`:

```bash
192.168.1.10:/vol /mnt/nfs  nfs  noauto,x-systemd.automount  0 0
```

Así el disco solo se monta cuando entras en `/mnt/nfs`. Útil para no colgar el arranque con recursos de red lenta.

## Troubleshooting / Problemas comunes

| Problema | Causa probable | Solución |
|---|---|---|
| "An error occurred while mounting /..." en arranque | fstab con UUID/opciones inválidas | Arrancar en `emergency mode`, ejecutar `mount -a` para ver el error, corregir y `fstab` |
| `fsck` pide contraseña al arrancar | `fsck order` con `1`/`2` en partición rota/pendiente | `fsck` en live USB o `sudo tune2fs -c 0` |
| Disco externo/USB impide arranque si no está | Falta `nofail` y/o `noauto` | Añadir `nofail` (y `noauto` si es opcional) |
| Se monta pero con permisos raros | FAT/exFAT/NTFS no guardan permisos Unix | Forzar `uid=1000,gid=1000,umask=022` |
| `mount.nfs: access denied` | Permisos/exports del servidor | Verificar `/etc/exports` del servidor y opciones `rw` |
| "Device /dev/sdb1 does not exist" tras reiniciar | Nombre `/dev/sdX` cambió | Cambiar a `UUID=`/`LABEL=` |
| Cambios en fstab "no se aplican" | No se ha hecho `mount -a` ni reiniciado, o systemd cache | `sudo systemctl daemon-reload` + `mount -a` |

## Notas y advertencias

- **Siempre testea con `mount -a` y `findmnt --verify`** antes de reiniciar. Un error grave cae a modo de emergencia.
- Usa `UUID`/`LABEL` en vez de `/dev/sdX` siempre que puedas.
- Los comentarios con `#` son útiles para documentar cada línea.
- `swap` se monta con mount point `none` y filesystem `swap`.
- Para OPCIÓN de montaje persistente de tu usuario en discos FAT/NTFS, pon `uid=1000,gid=1000`.
- En CachyOS/Arch, `mount -a` y systemd leen fstab; `systemd-fstab-generator` la convierte en units.

## Relación con otras notas
- [[mount]] — comando manual; fstab es su versión persistente.
- [[Sistemas de Archivos]] — tipos de FS y su gestión.
- [[Particionado y Esquemas de Disco]] — cómo crear/particionar antes de montar.
- [[lsblk]] — listar dispositivos y puntos de montaje.
- [[LUKS2 y Btrfs]] — cifrado/montaje de discos cifrados (los discos LUKS se desbloquean vía crypttab, adyacente a fstab).
- [[systemd unidades personalizadas]] — genera units .mount/.automount desde systemd.
- [[LVM]] — volúmenes lógicos (mapa de dispositivos en `/dev/mapper/...`).

## Enlaces externos
- [Arch Wiki — fstab](https://wiki.archlinux.org/title/Fstab)
- [Debian Admin — fstab](https://www.debian.org/doc/manuals/debian-reference/ch05.en.html)
- [man fstab](https://man.archlinux.org/man/fstab.5)
- [Linux Foundation — fstab tutorial](https://www.linuxfoundation.org/)

#sistema
