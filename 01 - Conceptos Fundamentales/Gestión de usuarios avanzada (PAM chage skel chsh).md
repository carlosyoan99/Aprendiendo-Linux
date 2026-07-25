---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: alta
---

# Gestión de usuarios avanzada (PAM, chage, skel, chsh)

## Definición

Linux ofrece herramientas de gestión de usuarios que van más allá de `useradd` y `passwd`: **PAM** (Pluggable Authentication Modules) controla *cómo* se autentican los usuarios, **chage** gestiona la caducidad de contraseñas, **/etc/skel/** define el entorno inicial de nuevos usuarios, y **chsh** cambia el shell por defecto. Son esenciales para administrar sistemas con múltiples usuarios y para hardening de seguridad.

```bash
# Comandos básicos de gestión de usuarios
useradd    # crear usuario (bajo nivel)
adduser    # crear usuario (interactivo, Debian/Ubuntu)
usermod    # modificar usuario
userdel    # eliminar usuario
groupadd   # crear grupo
passwd     # cambiar contraseña
gpasswd    # administrar grupos
id         # ver UID/GID/grupos del usuario
who        # usuarios conectados
w          # usuarios conectados + qué están haciendo
last       # historial de logins
```

---

## Archivos del sistema de usuarios

```bash
/etc/passwd       # base de datos de usuarios (todos pueden leer)
/etc/shadow       # contraseñas cifradas (solo root puede leer)
/etc/group        # grupos del sistema
/etc/gshadow      # contraseñas de grupos
/etc/default/useradd  # valores por defecto para useradd
/etc/login.defs   # políticas globales de usuarios (UID mín/máx, días entre cambios, etc.)
/etc/skel/        # plantilla para el home de nuevos usuarios
```

### Estructura de los archivos

```bash
# /etc/passwd — 7 campos separados por :
# usuario:contraseña:UID:GID:descripción:home:shell
carlos:x:1000:1000:Carlos:/home/carlos:/bin/bash
#        ↑ la 'x' significa que la contraseña está en /etc/shadow

# /etc/shadow — 9 campos
# usuario:hash:últimoCambio:min:díasMax:aviso:inactividad:expiración
carlos:$y$j9T$...:19876:0:99999:7:::

# /etc/group — 4 campos
# grupo:contraseña:GID:miembros
sudo:x:27:carlos,maria
```

---

## PAM — Pluggable Authentication Modules

PAM es un framework que permite cambiar la autenticación sin recompilar las aplicaciones. Define *módulos* que se ejecutan en cadena para cada servicio que requiere autenticación (login, sudo, ssh, passwd).

### Arquitectura

```
Aplicación (sshd, login, sudo)
       │
       ▼
  ┌──────────┐
  │   PAM    │  →  /etc/pam.d/sshd  →  módulos en cadena
  └──────────┘
       │
       ├──► pam_unix.so    (contraseñas del sistema)
       ├──► pam_ldap.so    (autenticación LDAP)
       ├──► pam_google_auth.so  (2FA)
       ├──► pam_tally2.so (bloqueo por intentos)
       └──► pam_access.so (restricción por IP/hora)
```

### Tipos de módulos PAM

| Tipo | Controla | Ejemplos |
|---|---|---|
| **auth** | Verificar identidad (contraseña, 2FA, huella) | `pam_unix.so`, `pam_google_authenticator.so` |
| **account** | Validar cuenta (caducidad, horario de acceso) | `pam_time.so`, `pam_access.so`, `pam_lastlog.so` |
| **password** | Actualizar contraseñas (políticas de complejidad) | `am_pwquality.so`, `pam_unix.so` |
| **session** | Configurar entorno al iniciar sesión | `pam_limits.so`, `pam_motd.so`, `pam_env.so` |

### Sintaxis de /etc/pam.d/

```bash
# /etc/pam.d/sshd
# tipo    control        módulo          argumentos

auth     required       pam_nologin.so              # denegar si /etc/nologin existe
auth     include        system-auth                  # incluir reglas generales
account  required       pam_nologin.so
account  include        system-auth
password include        system-auth
session  required       pam_loginuid.so
session  include        system-auth
```

| Campo de control | Significado |
|---|---|
| `required` | Si falla, la autenticación falla. Pero se siguen ejecutando los demás módulos |
| `requisite` | Si falla, la autenticación falla **inmediatamente** (no sigue) |
| `sufficient` | Si tiene éxito, la autenticación se concede (no sigue) |
| `optional` | No crítico. Solo relevante si es el único módulo |
| `include` | Incluir configuración de otro archivo |

### Ejemplos prácticos con PAM

```bash
# ── Bloquear a un usuario después de 3 intentos fallidos de SSH ──
# Opción A: pam_tally2 (Debian/Ubuntu, legacy)
# Añadir al inicio de /etc/pam.d/sshd:
auth     required       pam_tally2.so deny=3 unlock_time=600
# deny=3 → bloquear tras 3 fallos
# unlock_time=600 → desbloquear automáticamente tras 10 min

# Opción B: pam_faillock (Fedora/RHEL 8+, Debian reciente)
auth    required       pam_faillock.so preauth audit deny=3 unlock_time=600
auth    [default=die]  pam_faillock.so authfail audit deny=3 unlock_time=600

sudo faillock --user maria                  # ver intentos
sudo faillock --user maria --reset          # resetear

# Ver intentos fallidos (pam_tally2)
sudo pam_tally2 --user maria

# Resetear el contador manualmente
sudo pam_tally2 --user maria --reset

# ── Forzar contraseñas seguras ──
# Añadir a /etc/pam.d/passwd (o system-auth):
password    required    pam_pwquality.so retry=3 minlen=12 difok=3
# minlen=12 → mínimo 12 caracteres
# difok=3 → al menos 3 caracteres diferentes de la anterior

# ── Limitar horario de acceso (ssh solo en horario laboral) ──
# Añadir a /etc/pam.d/sshd:
account    required    pam_time.so
# Configurar /etc/security/time.conf:
# sshd;*;maria;MoTuWeThFr;0800-1800
# Formato: servicio;tty;usuarios;días;horario
# Los días se escriben pegados: Mo Tu We Th Fr Sa Su (sin espacios ni comas)

# ── Limitar acceso por IP (pam_access) ──
# Añadir a /etc/pam.d/sshd:
account    required    pam_access.so
# Configurar /etc/security/access.conf:
# + : maria : 192.168.1.0/24    # permitir desde red local
# - : maria : ALL                # denegar desde cualquier otro lado
# Formato: +/- : usuarios : orígenes

# ── Límites de recursos por usuario (ulimit) ──
# Añadir a /etc/pam.d/system-auth (o login):
session    required    pam_limits.so
# Configurar /etc/security/limits.conf:
# maria  hard  nproc   50    # máximo 50 procesos
# maria  hard  nofile  1024  # máximo 1024 archivos abiertos
```

### Límites de recursos con /etc/security/limits.conf

```bash
# /etc/security/limits.conf
# <dominio>  <tipo>  <item>          <valor>

# Límites globales
*           soft    nofile          4096
*           hard    nofile          65536

# Por usuario
carlos      hard    nproc           200      # procesos
carlos      hard    fsize           1000000  # tamaño de archivos (KB)
carlos      hard    cpu             60       # minutos de CPU

# Por grupo
@desarrolladores  hard    memlock     unlimited  # bloquear en RAM
```

---

## chage — Caducidad de contraseñas

```bash
# Ver info de caducidad de un usuario
chage -l carlos
# Último cambio de contraseña   : jul 18, 2026
# La contraseña expira          : never
# La contraseña queda inactiva  : never
# La cuenta expira              : never
# Mínimo días entre cambios     : 0
# Máximo días entre cambios     : 99999
# Días de aviso                 : 7

# Configurar caducidad
sudo chage -M 90 carlos                  # contraseña expira en 90 días
sudo chage -m 7 carlos                   # mínimo 7 días entre cambios
sudo chage -W 14 carlos                  # avisar 14 días antes de expirar
sudo chage -I 30 carlos                  # inactivar cuenta 30 días después de expirar
sudo chage -E 2026-12-31 carlos          # cuenta expira el 31 dic 2026

# Forzar cambio de contraseña en el próximo login
sudo chage -d 0 carlos                   # último cambio = 0 (obliga a cambiar)
```

### Políticas globales en /etc/login.defs

```bash
# /etc/login.defs — valores por defecto para todos los usuarios
PASS_MAX_DAYS   99999    # días máximo entre cambios
PASS_MIN_DAYS   0        # días mínimo entre cambios
PASS_WARN_AGE   7        # días de aviso antes de expirar
PASS_MIN_LEN    5        # longitud mínima (obsoleto, PAM lo gestiona)
UID_MIN         1000     # UID mínimo para usuarios normales
UID_MAX         60000    # UID máximo para usuarios normales
CREATE_HOME     yes      # crear /home/usuario automáticamente
USERGROUPS_ENAB yes      # crear grupo con el mismo nombre que el usuario
```

---

## /etc/skel/ — Plantilla para nuevos usuarios

Cuando creas un usuario con `useradd -m`, los archivos de `/etc/skel/` se copian automáticamente a su home. Esto permite preconfigurar el entorno de todos los usuarios nuevos.

```bash
# Contenido típico de /etc/skel/
ls -la /etc/skel/
# .bashrc
# .profile
# .bash_logout
# .config/

# Personalizar el prompt para todos los usuarios nuevos
echo 'export PS1="\u@\h:\w\$ "' | sudo tee -a /etc/skel/.bashrc

# Añadir alias por defecto
echo 'alias ll="ls -lah"' | sudo tee -a /etc/skel/.bashrc

# Crear directorios estándar
sudo mkdir -p /etc/skel/Documentos /etc/skel/Descargas /etc/skel/.ssh
sudo chmod 700 /etc/skel/.ssh

# Verificar que los archivos se copian correctamente:
sudo useradd -m prueba
ls -la /home/prueba/              # debería tener .bashrc, Documentos, .ssh
sudo userdel -r prueba            # limpiar
```

---

## chsh — Cambiar shell por defecto

Cada usuario tiene un shell por defecto definido en `/etc/passwd`. Se puede cambiar con `chsh`.

```bash
# Ver shells disponibles en el sistema
cat /etc/shells
# /bin/bash
# /bin/zsh
# /bin/fish
# /usr/bin/fish

# Cambiar shell (el usuario actual)
chsh -s /usr/bin/zsh

# Cambiar shell de otro usuario (solo root)
sudo chsh -s /usr/bin/fish maria

# Verificar el cambio
grep maria /etc/passwd
# maria:x:1001:1001::/home/maria:/usr/bin/fish

# Si un shell no está en /etc/shells, dará error
# Para permitir shells no listados: chsh solo valida contra /etc/shells
```

---

## Comandos de gestión útiles

```bash
# ── Crear usuario completo (todos los pasos manuales) ──
sudo useradd -m -s /bin/bash -G sudo,adm -c "Maria Garcia" maria
sudo passwd maria
# -m : crear home
# -s : shell por defecto
# -G : grupos secundarios
# -c : comentario (nombre completo)

# ── Crear usuario sin contraseña (solo SSH) ──
sudo useradd -m -s /bin/bash deploy
sudo passwd -l deploy                    # bloquear contraseña
# Luego copiar clave pública a ~deploy/.ssh/authorized_keys

# ── Bloquear/desbloquear un usuario ──
sudo usermod -L maria                    # bloquear (lock)
sudo usermod -U maria                    # desbloquear (unlock)
sudo passwd -l maria                     # alternativa para bloquear
sudo passwd -u maria                     # desbloquear

# ── Eliminar usuario ──
sudo userdel maria                       # eliminar usuario (home queda)
sudo userdel -r maria                    # eliminar usuario + home + mail spool

# ── Grupo ──
sudo groupadd developers                 # crear grupo
sudo gpasswd -a maria developers         # añadir usuario al grupo
sudo gpasswd -d maria developers         # quitar usuario del grupo
sudo groupdel developers                 # eliminar grupo
```

---

## Buenas prácticas

- **No compartir cuentas root**: cada admin debe tener su usuario con `sudo`.
- **Contraseñas expiradas**: en servidores con múltiples usuarios, configurar `chage -M 90`.
- **PAM para 2FA**: `pam_google_authenticator.so` añade segundo factor para SSH.
- **Auditar usuarios**: revisar periódicamente `lastlog`, `/etc/shadow`, y `users` activos.
- **Política de contraseñas**: usar `pam_pwquality.so` en lugar de `login.defs`.
- **Shell por defecto**: no usar `/bin/sh` (que suele apuntar a dash, sin autocompletado). Usar bash o zsh.

## Ver también

- [[Permisos y Propietarios]] — quién es dueño de qué
- [[ACLs]] — permisos extendidos más allá de dueño/grupo
- [[SSH]] — autenticación remota, claves vs contraseñas
- [[SELinux y AppArmor]] — MAC (control de acceso obligatorio)
- [[Shells (bash zsh fish)]] — shells disponibles para chsh
- [[Firewall]] — restricciones de acceso por red
- [[Logging del sistema (rsyslog journald logrotate)]] — registros de intentos de login

## Enlaces externos

- [Wikipedia — Linux PAM](https://en.wikipedia.org/wiki/Linux_PAM)
- [Repositorio oficial en GitHub](https://github.com/linux-pam/linux-pam)
- [Documentación oficial de PAM](https://linux-pam.org/)

#concepto #seguridad
