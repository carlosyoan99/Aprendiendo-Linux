---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: sistema
prioridad: alta
---

# Permisos y Propietarios

## Definición

Cada archivo y directorio en Linux tiene un **propietario** (usuario), un **grupo**, y tres conjuntos de permisos (lectura/escritura/ejecución) para: el dueño, el grupo, y "otros". A esto se suman mecanismos más avanzados como **ACLs**, **atributos extendidos** y **bits especiales** (SUID, SGID, sticky) que permiten un control de acceso mucho más granular.

```
Propietario ──→  rwx  (dueño)
                 rwx  (grupo)
                 rwx  (otros)
```

## Lectura de `ls -l`

```bash
$ ls -l
-rwxr-xr--  1 carlos desarrolladores  1234 jul 18 10:00 script.sh
 ^^^^^^^^^  ^                           ^
 │          │                           └── propietario:grupo
 │          └── número de hard links
 └── tipo + permisos
```

| Componente | Significado |
|---|---|
| **Primer carácter** | Tipo: `-` archivo, `d` directorio, `l` symlink, `c` dispositivo char, `b` dispositivo block |
| **Caracteres 2-4** | Permisos del **dueño** (u) — rwx |
| **Caracteres 5-7** | Permisos del **grupo** (g) — rwx |
| **Caracteres 8-10** | Permisos de **otros** (o) — rwx |
| **Carácter 11** (opcional) | `+` si tiene ACLs, `.` si tiene SELinux, `@` si tiene atributos extendidos |

### Posiciones especiales (bits SUID, SGID, Sticky)

En lugar de `r`, `w` o `x`, en ciertas posiciones puedes encontrar letras distintas:

| Posición | Letra | Significado |
|---|---|---|
| Bit de dueño (posición 4) | `s` → `rws` | **SUID** — el archivo se ejecuta con permisos del dueño |
| Bit de grupo (posición 7) | `s` → `rws` | **SGID** — el archivo se ejecuta con permisos del grupo |
| Bit de grupo (directorio) | `s` → `rws` | **SGID** — archivos nuevos heredan el grupo del directorio |
| Bit de otros (posición 10) | `t` → `rwt` | **Sticky bit** — solo el dueño puede eliminar sus archivos |

```bash
# Ejemplos de ls -l con bits especiales
-rwsr-xr-x  1 root root    51280 ene  1  2024 /usr/bin/passwd    # SUID
drwxrws---  2 root www-data  4096 jul 18 10:00 /var/www/shared    # SGID en directorio
drwxrwxrwt  7 root root      4096 jul 18 12:00 /tmp               # Sticky bit
-rw-r--r--@ 1 carlos carlos  1024 jul 18 10:00 archivo.txt       # Atributos extendidos
-rw-rw----+ 1 carlos carlos  1024 jul 18 10:00 archivo.txt       # + = tiene ACLs
```

## Notación numérica (octal)

| Permiso | Valor Octal |
|---|---|
| `r` (leer) | 4 |
| `w` (escribir) | 2 |
| `x` (ejecutar) | 1 |

| Número | Binario | Permisos |
|---|---|---|
| 0 | 000 | `---` |
| 1 | 001 | `--x` |
| 2 | 010 | `-w-` |
| 3 | 011 | `-wx` |
| 4 | 100 | `r--` |
| 5 | 101 | `r-x` |
| 6 | 110 | `rw-` |
| 7 | 111 | `rwx` |

```bash
chmod 755 archivo     # dueño rwx (7), grupo r-x (5), otros r-x (5)
chmod 644 archivo     # dueño rw- (6), grupo r-- (4), otros r-- (4)
```

### Bits especiales en octal

| Bit | Valor Octal | Equivalente simbólico |
|---|---|---|
| SUID | 4000 | `u+s` |
| SGID | 2000 | `g+s` |
| Sticky | 1000 | `o+t` |

```bash
chmod 4755 script     # SUID + rwxr-xr-x  → el 4 extra es el SUID
chmod 2755 directorio # SGID + rwxr-xr-x  → el 2 extra es el SGID
chmod 1777 /tmp       # Sticky + rwxrwxrwx → el 1 extra es el sticky

# Se pueden combinar:
chmod 6755 archivo    # SUID(4) + SGID(2) + rwxr-xr-x(755)
```

## Notación simbólica

```
Referencias: u (dueño/user), g (grupo), o (otros/others), a (todos/all)
Operadores:  + (añadir), - (quitar), = (igualar/poner exactamente)
Permisos:    r (leer), w (escribir), x (ejecutar),
             s (SUID/SGID), t (sticky), X (ejecutar solo para directorios)
```

```bash
chmod u+x script.sh          # añadir ejecución solo al dueño
chmod go-w archivo.txt       # quitar escritura a grupo y otros
chmod u=rwx,go=rx script.sh  # igual que chmod 755
chmod a=rw archivo.txt       # lectura+escritura para todos
chmod u+s archivo            # activar SUID
chmod g+s directorio/        # activar SGID en directorio
chmod +t /tmp                # activar sticky bit (o+t)
chmod -R g+w directorio/     # añadir escritura al grupo (recursivo)
chmod a+X directorio/        # añadir ejecución solo a directorios (útil con -R)
```

## Comandos básicos

```bash
chmod 644 archivo.txt         # dueño rw, resto solo lectura
chmod +x script.sh            # agregar ejecución (a todos)
chown usuario:grupo archivo   # cambiar propietario y grupo
chgrp grupo archivo           # cambiar solo el grupo
```

> Para más detalles sobre cada comando, ver [[chmod]], [[chown]].

---

## Bits especiales: Sticky, SUID y SGID

### Sticky bit (`+t` / `chmod 1xxx`)

Cuando se aplica a un **directorio**, el sticky bit restringe la eliminación: solo el **propietario del archivo**, el **propietario del directorio** o **root** pueden borrar o renombrar archivos dentro de él, incluso si el directorio tiene permisos `777`.

```bash
# /tmp es el ejemplo clásico: cualquiera puede escribir, pero no borrar archivos ajenos
$ ls -ld /tmp
drwxrwxrwt 7 root root 4096 jul 18 12:00 /tmp

# Activar/desactivar
chmod +t /compartido
chmod -t /compartido
chmod 1777 /compartido    # sticky + 777
```

**Aplicaciones típicas:** `/tmp`, `/var/tmp`, directorios compartidos de proyectos.

---

### SUID (Set User ID) — `u+s` / `chmod 4xxx`

Un archivo ejecutable con SUID se ejecuta con los permisos de su **propietario** (no del usuario que lo ejecuta). Esto permite que usuarios normales hagan tareas privilegiadas sin necesidad de `sudo`.

```bash
# passwd necesita SUID para modificar /etc/shadow como root
$ ls -l /usr/bin/passwd
-rwsr-xr-x 1 root root 51280 ene  1  2024 /usr/bin/passwd
#          ↑
#          la s en vez de x indica SUID

# Aplicar SUID
sudo chmod u+s /usr/bin/miprograma
sudo chmod 4755 /usr/bin/miprograma    # 4xxx activa SUID
```

⚠️ **Riesgo de seguridad:** Un SUID mal configurado permite escalar privilegios a root. Herramientas de auditoría como `sudo find / -perm -4000` listan todos los binarios SUID del sistema.

> 🔒 **Nota importante:** Linux **ignora el bit SUID en scripts con shebang** (`#!/bin/bash`, `#!/usr/bin/python`, etc.). Solo los binarios ELF compilados (como `/usr/bin/passwd`) pueden tener SUID efectivo. El kernel descarta el SUID en scripts por seguridad — de lo contrario, cualquier script malicioso podría ejecutarse con privilegios elevados. Si necesitas un script con privilegios, usa `sudo` con reglas en `/etc/sudoers` en lugar de SUID.

---

### SGID (Set Group ID) — `g+s` / `chmod 2xxx`

En **archivos ejecutables**: el proceso se ejecuta con los permisos del **grupo** del archivo (análogo a SUID pero con el grupo).

En **directorios** (uso más común): los archivos nuevos creados dentro heredan el **grupo del directorio**, no el grupo primario del usuario que los crea.

```bash
# Caso típico: directorio compartido donde todos los archivos deben pertenecer al mismo grupo
sudo mkdir -p /var/www/proyecto
sudo chgrp www-data /var/www/proyecto
sudo chmod g+s /var/www/proyecto    # nuevos archivos → grupo www-data
sudo chmod 2775 /var/www/proyecto   # SGID + rwxrwxr-x

# Verificar
$ ls -ld /var/www/proyecto
drwxrwsr-x 2 root www-data 4096 jul 18 12:00 /var/www/proyecto
#          ↑
#          la s en grupo indica SGID

# Activar/desactivar
chmod g+s directorio/
chmod g-s directorio/
```

---

### Tabla resumen de bits especiales

| Bit | Símbolo | Octal | En archivos | En directorios |
|---|---|---|---|---|
| **SUID** | `u+s` | 4xxx | Ejecuta como el dueño del archivo | (sin efecto) |
| **SGID** | `g+s` | 2xxx | Ejecuta como el grupo del archivo | Nuevos archivos heredan el grupo del directorio |
| **Sticky** | `+t` | 1xxx | (sin efecto en Linux) | Solo el dueño puede eliminar sus archivos |

```bash
# Buscar todos los binarios SUID/SGID del sistema
sudo find / -perm -4000 -type f 2>/dev/null    # solo SUID
sudo find / -perm -2000 -type f 2>/dev/null    # solo SGID
sudo find / -perm /6000 -type f 2>/dev/null    # ambos
```

---

## umask (permisos por defecto)

`umask` define qué permisos **se quitan** a los archivos y directorios nuevos. No es un comando que se ejecute una sola vez, sino una configuración de la shell.

```bash
# Ver la umask actual
$ umask
0022                              # octal

# La máscara se resta (con AND complementario) de los permisos base:
# Archivos:   base 666 (rw-rw-rw-)
# Directorios: base 777 (rwxrwxrwx)
#
# umask 022 → quita escritura a grupo y otros
#   archivo:  666 - 022 = 644 (rw-r--r--)
#   directorio: 777 - 022 = 755 (rwxr-xr-x)

# Cambiar umask temporalmente
umask 077                         # modo estricto: solo dueño tiene acceso
#   archivo:   666 - 077 = 600 (rw-------)
#   directorio: 777 - 077 = 700 (rwx------)

# Valores comunes
```

| `umask` | Permisos archivo | Permisos directorio | Uso típico |
|---|---|---|---|
| `0000` | 666 (rw-rw-rw-) | 777 (rwxrwxrwx) | Muy abierto (inseguro) |
| `0022` | 644 (rw-r--r--) | 755 (rwxr-xr-x) | **Por defecto en la mayoría de distros** |
| `0027` | 640 (rw-r-----) | 750 (rwxr-x---) | Servidores web (grupo limitado) |
| `0077` | 600 (rw-------) | 700 (rwx------) | Estricto (solo el usuario) |

```bash
# Persistir umask en el archivo de shell
echo "umask 027" >> ~/.bashrc     # para bash
echo "umask 027" >> ~/.zshrc      # para zsh

# umask por proceso vs global
# /etc/profile, /etc/bash.bashrc → umask global
# ~/.bashrc, ~/.zshrc            → umask por usuario
# /etc/pam.d/common-session      → umask via PAM (afecta sesiones gráficas y TTY)
```

> Ver [[chmod]] para más ejemplos de permisos.

---

## ACLs (Access Control Lists)

Las ACLs permiten asignar permisos a **usuarios y grupos específicos** más allá del trío dueño/grupo/otros. Se identifican con un `+` al final de `ls -l`.

```bash
# Verificar si un archivo tiene ACLs
$ ls -l archivo.txt
-rw-rw----+ 1 carlos carlos 1024 jul 18 10:00 archivo.txt
#          ↑
#          el + indica ACLs

# Ver ACLs
getfacl archivo.txt
# file: archivo.txt
# owner: carlos
# group: carlos
# user::rw-
# user:maria:rwx          ← maria tiene permisos específicos
# group::r--
# group:desarrolladores:rw-   ← el grupo desarrolladores tiene permisos
# mask::rwx
# other::---
```

### Comandos principales

```bash
# Asignar permisos a un usuario específico
setfacl -m u:maria:rwx archivo.txt     # maria obtiene rwx

# Asignar permisos a un grupo específico
setfacl -m g:desarrolladores:rw archivo.txt

# Quitar una entrada ACL
setfacl -x u:maria archivo.txt

# Copiar ACLs de un archivo a otro
getfacl modelo.txt | setfacl --set-file=- destino.txt

# ACLs recursivas (directorios)
setfacl -R -m u:maria:rwx directorio/

# ACLs por defecto (los archivos nuevos heredan)
setfacl -d -m g:desarrolladores:rw directorio/
```

### Máscara ACL

La **máscara** limita los permisos máximos que pueden tener las entradas de usuarios y grupos adicionales (excepto el dueño y `other`). Si cambias permisos con `chmod` en un archivo con ACLs, la máscara se recalcula automáticamente.

```bash
# Ver máscara actual
getfacl archivo.txt | grep mask

# Forzar máscara (recorta permisos de todas las entradas ACL)
setfacl -m m::rx archivo.txt    # ninguno de los usuarios/grupos extra puede tener más que rx

# ⚠️ Si haces chmod en un archivo con ACLs, la máscara se actualiza:
chmod 644 archivo.txt   # recalcula la máscara a r--
```

### Recetas prácticas con ACLs

```bash
# Compartir carpeta con un usuario específico
sudo setfacl -R -m u:invitado:rx /home/carlos/compartido
sudo setfacl -R -dm u:invitado:rx /home/carlos/compartido   # archivos nuevos heredan

# Dar acceso a un grupo en /var/www sin mover el usuario de grupo
setfacl -R -m g:www-data:rx /home/desarrollador/sitio

# Quitar todas las ACLs
setfacl -b archivo.txt
```

---

## Atributos extendidos (chattr / lsattr)

Los atributos extendidos de Linux (`chattr`/`lsattr`) operan a nivel de **inodo** y permiten proteger archivos contra modificaciones, incluso por root.

```bash
# Ver atributos de un archivo
lsattr archivo.txt
# ----i--------e-- archivo.txt

# Símbolos comunes
```

| Atributo | Flag | Efecto |
|---|---|---|
| **Immutable** | `i` | El archivo no se puede modificar, eliminar, renombrar ni enlazar — ni por root |
| **Append only** | `a` | Solo se puede añadir contenido (logs) |
| **No dump** | `d` | El archivo se ignora en backups con `dump` |
| **Synchronous** | `S` | Las escrituras son síncronas (como `sync` en cada write) |
| **Compressed** | `c` | El kernel comprime/descomprime automáticamente |
| **Extents** | `e` | Formato por extensiones (atributo **por defecto** en ext4, no se puede quitar) |
| **No COW** | `C` | Desactiva copy-on-write (btrfs) — útil para VMs |
| **No atime update** | `A` | No actualiza el timestamp de acceso |

```bash
# Hacer un archivo inmutable (ni root puede modificarlo)
sudo chattr +i /etc/hosts              # proteger /etc/hosts
sudo chattr +i /etc/resolv.conf        # evitar que NetworkManager lo sobrescriba

# Archivo append-only (para logs)
sudo chattr +a /var/log/syslog

# Quitar atributo
sudo chattr -i archivo.txt
sudo chattr -a archivo.txt

# Verificar (lsattr también acepta -R para recursivo)
lsattr /etc/hosts
lsattr -R /etc/                     # todos los archivos en /etc
```

⚠️ **Cuidado:** Si marcas un archivo del sistema como `+i`, no podrás actualizarlo ni eliminarlo hasta que quites el atributo. `chattr` no funciona en todos los sistemas de archivos (funciona en ext4, btrfs, xfs; limitado en tmpfs, fat32, ntfs).

---

## Casos prácticos de seguridad

### 1. Directorio `~/.ssh` — claves SSH

SSH es muy estricto con los permisos de su directorio de configuración:

> 🔒 **Hardening adicional:** Puedes proteger `~/.ssh/authorized_keys` con `chattr +i` para evitar que malware o configuraciones maliciosas añadan claves:
> ```bash
> sudo chattr +i ~/.ssh/authorized_keys   # nadie puede modificar (ni root)
> # Antes de añadir una clave nueva legítima:
> sudo chattr -i ~/.ssh/authorized_keys
> ssh-copy-id servidor
> sudo chattr +i ~/.ssh/authorized_keys
> ```

```bash
# Permisos correctos para SSH
chmod 700 ~/.ssh                  # directorio: solo dueño (rwx------)
chmod 600 ~/.ssh/id_ed25519       # clave privada: solo dueño (rw-------)
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_ed25519.pub   # clave pública: lectura para todos
chmod 644 ~/.ssh/authorized_keys  # claves autorizadas (lectura, no escritura)
chmod 644 ~/.ssh/config           # configuración SSH
chmod 644 ~/.ssh/known_hosts      # hosts conocidos

# Error típico: SSH se niega a usar una clave privada con permisos demasiado abiertos
# $ ssh -i ~/.ssh/id_rsa servidor
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
# Permissions 0644 for 'id_rsa' are too open.
```

### 2. `/etc/shadow` — contraseñas de usuarios

```bash
# Solo root puede leer el hash de contraseñas
$ ls -l /etc/shadow
-rw-r----- 1 root shadow 1234 jul 18 10:00 /etc/shadow

# /etc/passwd (legible por todos) contiene los nombres de usuario
$ ls -l /etc/passwd
-rw-r--r-- 1 root root 2345 jul 18 10:00 /etc/passwd

# ⚠️ Si /etc/shadow tuviera permisos 644, cualquier usuario podría
# extraer los hashes de contraseñas y crackearlos offline.
```

### 3. `/usr/bin/passwd` — el SUID clásico

```bash
$ ls -l /usr/bin/passwd
-rwsr-xr-x 1 root root 51280 ene  1  2024 /usr/bin/passwd
#  ↑
#  SUID: se ejecuta como root aunque lo ejecute un usuario normal

# Esto permite que cualquier usuario cambie su contraseña:
$ passwd                                  # se ejecuta como root gracias al SUID
# Changing password for carlos.
# Current password:
# (passwd modifica /etc/shadow como root, no como carlos)
```

### 4. Archivos de logs (`/var/log/`)

```bash
# Los logs suelen ser solo lectura para grupos específicos
$ ls -la /var/log/
drwxr-x---  2 root     adm      4096 jul 18 12:00 apache2
-rw-r-----  1 syslog   adm     12345 jul 18 12:00 syslog
-rw-rw----  1 root     utmp     1024 jul 18 12:00 wtmp

# Para leer logs sin ser root:
sudo usermod -aG adm $USER                # grupo adm (Debian/Ubuntu)
sudo usermod -aG systemd-journal $USER    # grupo journal
# (requiere cerrar sesión y volver a entrar)
```

### 5. SUID malicioso — cómo auditar tu sistema

```bash
# Encontrar todos los binarios con SUID (potencial riesgo de seguridad)
find / -perm -4000 -type f 2>/dev/null

# Lo mismo con SGID
find / -perm -2000 -type f 2>/dev/null

# Comparar contra una línea base para detectar cambios (útil como script de auditoría)
# Guardar línea base después de una instalación limpia:
find / -perm -4000 -type f 2>/dev/null | sort > suid-baseline.txt
# Luego, en auditorías:
find / -perm -4000 -type f 2>/dev/null | sort | diff - suid-baseline.txt
```

### 6. Directorio `/tmp` con Sticky bit

```bash
$ ls -ld /tmp
drwxrwxrwt 7 root root 4096 jul 18 12:00 /tmp

# Cualquiera puede crear archivos en /tmp:
$ touch /tmp/prueba.txt

# Pero nadie puede borrar archivos de otros:
$ rm /tmp/archivo-de-otro-usuario
rm: remove write-protected regular file '/tmp/archivo-de-otro-usuario'? y
rm: cannot remove '/tmp/archivo-de-otro-usuario': Operation not permitted
```

---

## Resumen rápido: permisos típicos

| Caso | Permisos | Comando |
|---|---|---|
| Script personal | `rwxr-xr-x` | `chmod 755 script.sh` |
| Documento personal | `rw-rw-r--` | `chmod 664 doc.txt` |
| Clave privada SSH | `rw-------` | `chmod 600 ~/.ssh/id_ed25519` |
| Clave pública SSH | `rw-r--r--` | `chmod 644 ~/.ssh/id_ed25519.pub` |
| Directorio personal | `rwx------` | `chmod 700 ~/.ssh` |
| Directorio compartido | `rwxrws---` | `chmod 2770 /compartido` (SGID) |
| Archivo de sistema | inmutable | `sudo chattr +i /etc/hosts` |
| Directorio temporal | `rwxrwxrwt` | `chmod 1777 /tmp` (sticky) |
| Script SUID (cuidado) | `rwsr-xr-x` | `chmod 4755 /usr/bin/programa` |
| Log del sistema | `rw-r-----` | `chmod 640 /var/log/syslog` |

## Por qué importa

Los errores "Permission denied" son la fuente #1 de frustración para quien empieza con Linux. Entender permisos evita el reflejo de usar `sudo` para todo — que a su vez puede causar problemas de seguridad y permisos incorrectos en archivos personales (`~/.ssh/`, `~/.config/`). Conocer ACLs, umask y atributos extendidos permite diseñar sistemas multi-usuario robustos y seguros.

## Ver también

- [[chmod]] — cambiar permisos
- [[chown]] — cambiar propietario/grupo
- [[Error de permisos]] — troubleshooting de "Permission denied"
- [[ACLs]] — control de acceso avanzado
- [[SELinux y AppArmor]] — sistemas de seguridad adicionales
- [[Cheat Sheet - Comandos Esenciales]] — referencia rápida
- [[SSH]] — permisos del directorio ~/.ssh
- [[systemd]] — gestión de servicios y sus permisos
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — usuarios y grupos

## Enlaces externos

- [Arch Wiki — File permissions and attributes](https://wiki.archlinux.org/title/File_permissions_and_attributes)
- [Red Hat — Managing ACLs](https://www.redhat.com/sysadmin/linux-access-control-lists)
- [Wikipedia — chattr](https://en.wikipedia.org/wiki/Chattr)
- [Linux Handbook — Umask explained](https://linuxhandbook.com/umask/)

#sistema #permisos #seguridad
