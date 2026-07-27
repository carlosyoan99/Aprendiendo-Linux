---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-27
estado: resuelto
categoria: concepto
prioridad: baja
---

# /etc/skel/ — Plantilla para nuevos usuarios

Cuando creas un usuario con `useradd -m`, los archivos de `/etc/skel/` se copian automáticamente a su home. Permite preconfigurar el entorno de todos los usuarios nuevos del sistema.

## Contenido típico

```bash
ls -la /etc/skel/
# drwxr-xr-x   .config/
# -rw-r--r--   .bashrc
# -rw-r--r--   .profile
# -rw-r--r--   .bash_logout
```

## Estructura completa recomendada

Para entornos corporativos o educativos, puedes incluir directorios y dotfiles útiles:

```bash
sudo mkdir -p /etc/skel/{Documentos,Descargas,Imágenes,Proyectos,.ssh,.config,.local/share}
sudo chmod 700 /etc/skel/.ssh
sudo chmod 755 /etc/skel/Documentos
```

```
/etc/skel/
├── .bashrc              # alias y prompt por defecto
├── .bash_logout         # limpieza al salir
├── .profile             # variables de entorno
├── .config/
│   └── user-dirs.dirs   # XDG user directories
├── .local/
│   └── share/
├── .ssh/                # directorio SSH (vació para que el usuario lo gestione)
├── Documentos/
├── Descargas/
├── Imágenes/
└── Proyectos/
```

## Personalización avanzada

```bash
# ── .bashrc para todos los usuarios nuevos ──
sudo tee /etc/skel/.bashrc << 'EOF'
# ~/.bashrc para usuarios nuevos
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
alias ll='ls -lah --color=auto'
alias la='ls -A'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias l='ls -CF'

# Prompt de color para root (rojo)
if [ "$UID" = "0" ]; then
  PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

export EDITOR=nano
export VISUAL=nano
EOF

# ── .profile con variables XDG ──
sudo tee /etc/skel/.profile << 'EOF'
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/Proyectos" ]; then
    cd "$HOME/Proyectos"
fi
EOF

# ── user-dirs.dirs (carpetas XDG) ──
sudo tee /etc/skel/.config/user-dirs.dirs << 'EOF'
XDG_DESKTOP_DIR="$HOME/"
XDG_DOWNLOAD_DIR="$HOME/Descargas"
XDG_DOCUMENTS_DIR="$HOME/Documentos"
XDG_PICTURES_DIR="$HOME/Imágenes"
EOF
```

## Verificar que se copia correctamente

```bash
sudo useradd -m usuarioprueba
ls -la /home/usuarioprueba/
ls -la /home/usuarioprueba/.config/
sudo userdel -r usuarioprueba      # limpiar
```

## Archivos relacionados

```bash
# /etc/default/useradd — valores por defecto
sudo grep -v "^#" /etc/default/useradd | grep -v "^$"
# GROUP=100
# HOME=/home
# INACTIVE=-1
# EXPIRE=
# SHELL=/bin/bash
# SKEL=/etc/skel
# CREATE_MAIL_SPOOL=yes

# /etc/login.defs — políticas globales
grep -E "^(CREATE_HOME|MAIL_DIR|UMASK|USERGROUPS_ENAB)" /etc/login.defs
```

## Personalización por grupo (técnica avanzada)

Si necesitas diferentes plantillas para distintos tipos de usuarios, puedes crear un script en `/etc/profile.d/` o usar un hook de `useradd`:

```bash
# Crear múltiples plantillas
sudo mkdir /etc/skel-dev /etc/skel-corp

# /etc/skel-dev/.bashrc → alias de desarrollo (git, docker, etc.)
# /etc/skel-corp/.bashrc → alias corporativos (VPN, proxies, etc.)

# Usar un wrapper de useradd:
sudo useradd -m -k /etc/skel-dev -s /bin/zsh desarrollador   # -k = skel alternativo
sudo useradd -m -k /etc/skel-corp empleado
```

## Casos de uso

| Escenario | Solución |
|---|---|
| Todos los nuevos usuarios tengan `ll`, `grep --color` | Añadir alias al `/etc/skel/.bashrc` |
| Usuarios tengan carpeta `Proyectos/` por defecto | `mkdir -p /etc/skel/Proyectos` |
| Shell por defecto para nuevos usuarios | `useradd -s /usr/bin/zsh` o editar `/etc/default/useradd` |
| Clave SSH pública para acceso inicial | Poner `.ssh/authorized_keys` en `/etc/skel/` (cuidado con seguridad) |
| Usuarios temporales sin shell | `useradd --shell /usr/sbin/nologin tempuser` (el `-s` sobreescribe `/etc/default/useradd`) |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Nuevo usuario no tiene los archivos esperados | `-m` no usado o SKEL mal configurado | Usar `useradd -m`, verificar `grep SKEL /etc/default/useradd` |
| Permisos incorrectos en el home | umask no configurado | Ajustar `UMASK 022` en `/etc/login.defs` |
| `.bashrc` se ignora | Shell por defecto no es bash | Cambiar shell en `/etc/default/useradd` o con `-s` |
| Usuarios existentes no se benefician | `/etc/skel/` solo afecta a usuarios NUEVOS | Copiar a mano: `cp -r /etc/skel/* ~/` en cada usuario |

## Ver también

- [[PAM]] — módulos de autenticación
- [[chsh]] — cambiar shell por defecto
- [[adduser]] — creación de usuarios
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — índice

## Enlaces externos

- [Arch Wiki — /etc/skel](https://wiki.archlinux.org/title/Skeleton)
- [man hier — filesystem hierarchy](https://man7.org/linux/man-pages/man7/hier.7.html)

#concepto #usuarios
