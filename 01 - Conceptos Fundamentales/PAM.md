---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: concepto
prioridad: alta
---

# PAM — Pluggable Authentication Modules

Framework que permite cambiar la autenticación sin recompilar las aplicaciones. Define **módulos** que se ejecutan en cadena para servicios que requieren autenticación (login, sudo, ssh, passwd).

## Arquitectura

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
       ├──► pam_tally2.so  (bloqueo por intentos)
       └──► pam_access.so  (restricción por IP/hora)
```

## Tipos de módulos

| Tipo | Controla | Ejemplos |
|---|---|---|
| **auth** | Verificar identidad | `pam_unix.so`, `pam_google_authenticator.so` |
| **account** | Validar cuenta (caducidad, horario) | `pam_time.so`, `pam_access.so` |
| **password** | Actualizar contraseñas | `pam_pwquality.so`, `pam_unix.so` |
| **session** | Configurar entorno al iniciar | `pam_limits.so`, `pam_motd.so` |

## Sintaxis

```bash
# /etc/pam.d/sshd
# tipo    control        módulo          argumentos
auth     required       pam_nologin.so
auth     include        system-auth
account  required       pam_nologin.so
account  include        system-auth
password include        system-auth
session  required       pam_loginuid.so
session  include        system-auth
```

### Campos de control

| Control | Significado |
|---|---|
| `required` | Si falla, la auth falla. Se siguen ejecutando demás módulos |
| `requisite` | Si falla, la auth falla **inmediatamente** |
| `sufficient` | Si tiene éxito, la auth se concede (no sigue) |
| `optional` | No crítico |
| `include` | Incluir config de otro archivo |

## Ejemplos prácticos

### Bloquear tras 3 intentos fallidos SSH

```bash
# En /etc/pam.d/sshd (pam_faillock, moderno):
auth    required       pam_faillock.so preauth audit deny=3 unlock_time=600
auth    [default=die]  pam_faillock.so authfail audit deny=3 unlock_time=600

sudo faillock --user maria              # ver intentos
sudo faillock --user maria --reset      # resetear
```

### Forzar contraseñas seguras

```bash
# En /etc/pam.d/passwd:
password    required    pam_pwquality.so retry=3 minlen=12 difok=3
```

### Limitar horario de acceso (solo laboral)

```bash
# En /etc/pam.d/sshd:
account    required    pam_time.so
# En /etc/security/time.conf:
sshd;*;maria;MoTuWeThFr;0800-1800
```

### Limitar acceso por IP

```bash
# En /etc/pam.d/sshd:
account    required    pam_access.so
# En /etc/security/access.conf:
+ : maria : 192.168.1.0/24
- : maria : ALL
```

### Límites de recursos (ulimit)

```bash
# En /etc/pam.d/system-auth:
session    required    pam_limits.so
# En /etc/security/limits.conf:
maria  hard  nproc   50
maria  hard  nofile  1024
```

## Ver también

- [[chage]] — caducidad de contraseñas
- [[chsh]] — cambiar shell por defecto
- [[SSH]] — autenticación remota
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — índice

## Enlaces externos

- [Wikipedia — Linux PAM](https://en.wikipedia.org/wiki/Linux_PAM)
- [Documentación oficial de PAM](https://linux-pam.org/)

#concepto #seguridad
