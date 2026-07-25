---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
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

### Sticky, SUID y SGID — Bits especiales

```bash
# ── Sticky bit (+t / 1xxx): solo el dueño elimina sus archivos ──
chmod +t /compartido                     # activar
chmod 1777 /tmp                          # sticky + 777 (/tmp es el ejemplo clásico)
ls -ld /tmp                              # drwxrwxrwt

# ── SUID (u+s / 4xxx): se ejecuta como el dueño del archivo ──
ls -l /usr/bin/passwd                    # -rwsr-xr-x (s en dueño = SUID)
sudo chmod u+s /usr/bin/miprograma
sudo chmod 4755 /usr/bin/miprograma      # SUID + rwxr-xr-x
# Auditoría: find / -perm -4000 -type f 2>/dev/null
#
# ⚠️ Linux ignora SUID en scripts con shebang (#!/bin/bash, #!/usr/bin/python).
# Solo binarios ELF compilados pueden tener SUID efectivo.
# Si necesitas un script con privilegios, usa `sudo` con reglas en /etc/sudoers.

# ── SGID (g+s / 2xxx): heredar grupo del directorio ──
sudo mkdir -p /var/www/proyecto
sudo chgrp www-data /var/www/proyecto
sudo chmod g+s /var/www/proyecto         # nuevos archivos → grupo www-data
sudo chmod 2775 /var/www/proyecto        # SGID + rwxrwxr-x
ls -ld /var/www/proyecto                 # drwxrwsr-x (s en grupo = SGID)
chmod g-s directorio/                    # desactivar
```

---

### Tabla resumen de bits especiales

| Bit | Símbolo | Octal | En archivos | En directorios |
|---|---|---|---|---|
| **SUID** | `u+s` | 4xxx | Ejecuta como el dueño del archivo | (sin efecto) |
| **SGID** | `g+s` | 2xxx | Ejecuta como el grupo del archivo | Nuevos archivos heredan el grupo del directorio |
| **Sticky** | `+t` | 1xxx | (sin efecto en Linux) | Solo el dueño puede eliminar sus archivos |

```bash
sudo find / -perm -4000 -type f 2>/dev/null    # buscar SUID
sudo find / -perm -2000 -type f 2>/dev/null    # buscar SGID
sudo find / -perm /6000 -type f 2>/dev/null    # ambos combinados
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

### Comandos, máscara y recetas prácticas

```bash
# ── Asignar permisos con ACL ──
setfacl -m u:maria:rwx archivo.txt       # maria obtiene rwx
setfacl -m g:desarrolladores:rw archivo.txt  # grupo obtiene rw
setfacl -x u:maria archivo.txt           # quitar entrada
setfacl -b archivo.txt                   # quitar TODAS las ACLs

# ── Copiar ACLs ──
getfacl modelo.txt | setfacl --set-file=- destino.txt

# ── ACLs recursivas y por defecto ──
setfacl -R -m u:invitado:rx directorio/               # recursivo
setfacl -d -m g:desarrolladores:rw directorio/         # archivos nuevos heredan

# ── Máscara ACL (limita el máximo permiso de entradas extra) ──
getfacl archivo.txt | grep mask                        # ver máscara
setfacl -m m::rx archivo.txt                           # forzar máscara
# ⚠️ chmod en archivo con ACLs recalcula la máscara automáticamente
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

```bash
chmod 700 ~/.ssh                          # directorio: solo dueño
chmod 600 ~/.ssh/id_ed25519               # clave privada: solo dueño
chmod 644 ~/.ssh/id_ed25519.pub           # clave pública: lectura
chmod 644 ~/.ssh/authorized_keys          # claves autorizadas
chmod 644 ~/.ssh/config                   # configuración
# Error típico: Permissions 0644 for 'id_rsa' are too open.
```

> 🔒 **Hardening:** Puedes proteger `~/.ssh/authorized_keys` con `chattr +i` para evitar modificaciones no autorizadas:
> ```bash
> sudo chattr +i ~/.ssh/authorized_keys   # proteger (ni root puede tocarlo)
> # Antes de añadir una clave nueva, quitar y re-aplicar:
> sudo chattr -i ~/.ssh/authorized_keys
> ssh-copy-id servidor
> sudo chattr +i ~/.ssh/authorized_keys
> ```

### 2. `/etc/shadow` — contraseñas de usuarios

```bash
ls -l /etc/shadow                         # -rw-r----- root shadow
ls -l /etc/passwd                         # -rw-r--r-- root root
# ⚠️ shadow debe ser 640 — si fuera 644, cualquiera podría leer hashes
```

### 3. `/usr/bin/passwd` — SUID en acción

```bash
ls -l /usr/bin/passwd                     # -rwsr-xr-x (SUID activo)
# passwd se ejecuta como root aunque lo ejecute un usuario normal
```

### 4. Logs (`/var/log/`) — grupos de lectura

```bash
ls -la /var/log/                          # logs: solo lectura para adm/journal
sudo usermod -aG adm $USER                # grupo adm (Debian/Ubuntu)
sudo usermod -aG systemd-journal $USER    # grupo journal
```

### 5. Auditar SUID/SGID en tu sistema

```bash
find / -perm -4000 -type f 2>/dev/null | sort > suid-baseline.txt  # línea base
find / -perm -4000 -type f 2>/dev/null | sort | diff - suid-baseline.txt  # auditoría
```

### 6. `/tmp` y el Sticky bit

```bash
ls -ld /tmp                               # drwxrwxrwt (sticky activo)
touch /tmp/prueba.txt                     # cualquiera crea archivos
rm /tmp/archivo-ajeno                     # pero no puede borrar los de otros (Operation not permitted)
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
