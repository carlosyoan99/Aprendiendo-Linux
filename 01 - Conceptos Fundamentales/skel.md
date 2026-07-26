---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: concepto
prioridad: baja
---

# /etc/skel/ — Plantilla para nuevos usuarios

Cuando creas un usuario con `useradd -m`, los archivos de `/etc/skel/` se copian automáticamente a su home. Permite preconfigurar el entorno de todos los usuarios nuevos del sistema.

## Contenido típico

```bash
ls -la /etc/skel/
# .bashrc
# .profile
# .bash_logout
# .config/
```

## Personalización

```bash
# Personalizar el prompt para todos los usuarios nuevos
echo 'export PS1="\u@\h:\w\$ "' | sudo tee -a /etc/skel/.bashrc

# Añadir alias por defecto
echo 'alias ll="ls -lah"' | sudo tee -a /etc/skel/.bashrc

# Crear directorios estándar
sudo mkdir -p /etc/skel/Documentos /etc/skel/Descargas /etc/skel/.ssh
sudo chmod 700 /etc/skel/.ssh

# Verificar que se copian correctamente:
sudo useradd -m prueba
ls -la /home/prueba/
sudo userdel -r prueba
```

## Archivos relacionados

- `/etc/default/useradd` — valores por defecto para useradd
- `/etc/login.defs` — políticas globales (CREATE_HOME, etc.)
- `/etc/skel/` — plantilla del home

## Ver también

- [[PAM]] — módulos de autenticación
- [[chsh]] — cambiar shell por defecto
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — índice

#concepto #usuarios
