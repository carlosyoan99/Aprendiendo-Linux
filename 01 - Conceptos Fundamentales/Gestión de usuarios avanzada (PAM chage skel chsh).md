---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: concepto
prioridad: alta
---

# Gestión de usuarios avanzada (PAM, chage, skel, chsh)

Linux ofrece herramientas de gestión de usuarios que van más allá de `useradd` y `passwd`: **PAM** controla *cómo* se autentican los usuarios, **chage** gestiona la caducidad de contraseñas, **/etc/skel/** define el entorno inicial de nuevos usuarios, y **chsh** cambia el shell por defecto.

## Componentes

- [[PAM]] — Pluggable Authentication Modules (framework de autenticación)
- [[chage]] — caducidad de contraseñas
- [[skel]] — plantilla para nuevos usuarios (/etc/skel/)
- [[chsh]] — cambiar shell por defecto

## Archivos del sistema

```bash
/etc/passwd       # base de datos de usuarios
/etc/shadow       # contraseñas cifradas (solo root)
/etc/group        # grupos del sistema
/etc/default/useradd  # valores por defecto
/etc/login.defs   # políticas globales
/etc/skel/        # plantilla para nuevos usuarios
```

## Comandos básicos

```bash
useradd    # crear usuario (bajo nivel)
adduser    # crear usuario (interactivo, Debian/Ubuntu)
usermod    # modificar usuario
userdel    # eliminar usuario
passwd     # cambiar contraseña
id         # ver UID/GID/grupos
```

## Buenas prácticas

- No compartir cuentas root: cada admin con su usuario + sudo
- Contraseñas expiradas: `chage -M 90` en servidores multi-usuario
- PAM para 2FA: `pam_google_authenticator.so` para SSH
- Política de contraseñas: `pam_pwquality.so` en lugar de login.defs
- Shell por defecto: bash o zsh, no `/bin/sh`

## Ver también

- [[Permisos y Propietarios]] — quién es dueño de qué
- [[ACLs]] — permisos extendidos
- [[SSH]] — autenticación remota
- [[SELinux y AppArmor]] — MAC
- [[Shells (bash zsh fish)]] — shells disponibles

## Enlaces externos

- [Wikipedia — Linux PAM](https://en.wikipedia.org/wiki/Linux_PAM)
- [Documentación oficial de PAM](https://linux-pam.org/)

#concepto #seguridad
