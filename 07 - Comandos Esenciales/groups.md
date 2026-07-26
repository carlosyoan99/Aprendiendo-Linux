---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: baja
---

# groups

> Muestra los grupos a los que pertenece un usuario. Esencial para gestionar permisos y acceso a recursos del sistema.

## Sintaxis

```bash
groups [usuario]
groups                             # grupos del usuario actual
```

## Descripción

`groups` muestra los grupos de un usuario. En Linux, cada usuario pertenece a un grupo primario y puede tener grupos secundarios. Los grupos determinan acceso a archivos, dispositivos y servicios (ej: `docker`, `sudo`, `audio`, `video`).

## Ejemplos

### Ver grupos del usuario actual
```bash
groups
# carlos : carlos sudo docker video audio
```

### Ver grupos de otro usuario
```bash
groups www-data
# www-data : www-data
```

### Verificar si perteneces a un grupo
```bash
groups | grep -q docker && echo "Docker OK" || echo "No tienes acceso a Docker"
```

### Agregar usuario a un grupo
```bash
sudo usermod -aG docker carlos     # agregar al grupo docker (-a = append)
sudo usermod -aG sudo carlos       # agregar a sudo
sudo usermod -aG audio carlos      # acceso a audio
# ⚠️ SIN -a: el usuario pierde todos los demás grupos secundarios
```

### Cambiar grupo primario
```bash
sudo usermod -g newgroup usuario   # cambiar grupo primario
```

### Crear grupo
```bash
sudo groupadd developers
sudo usermod -aG developers carlos
```

### Ver todos los grupos del sistema
```bash
cat /etc/group                     # todos los grupos
getent group docker                # miembros de un grupo específico
```

## Formato de salida

```
carlos : carlos sudo docker video audio plugdev
```

## Casos de uso

### Verificar acceso a Docker
```bash
groups | grep -q docker && echo "Puede usar docker" || echo "Necesita: sudo usermod -aG docker $USER"
```

### Gestión de permisos por grupo
```bash
# Crear grupo para proyecto compartido
sudo groupadd proyecto
sudo usermod -aG proyecto carlos
sudo usermod -aG proyecto ana
sudo chown -R root:proyecto /srv/proyecto
sudo chmod -R 770 /srv/proyecto    # rw para owner+group
```

## Combinaciones pipe

```bash
# Ver solo grupos del usuario actual (sin nombre de usuario)
groups $(whoami) | cut -d: -f2 | tr ' ' '\n' | tail -n +2

# Listar usuarios de un grupo
getent group sudo | cut -d: -f4 | tr ',' '\n'

# Verificar si un usuario específico está en un grupo
id -nG carlos | grep -q docker && echo "OK"
```

## Comandos relacionados

| Comando | Para qué |
|---|---|
| `groups` | Ver grupos de un usuario |
| `id` | Ver UID, GID y grupos |
| `getent group` | Ver miembros de un grupo |
| `usermod -aG` | Agregar usuario a grupo |
| `gpasswd -a` | Agregar usuario a grupo (alternativa) |
| `newgrp` | Cambiar grupo activo |

## Ver también

- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — gestión avanzada de usuarios
- [[Permisos y Propietarios]] — cómo funcionan los permisos
- [[adduser]] — creación de usuarios
- [[chmod]] — cambiar permisos

## Enlaces externos

- [Wikipedia — Unix groups](https://en.wikipedia.org/w/index.php?title=Unix_group)
- [man groups(1)](https://man7.org/linux/man-pages/man1/groups.1.html)
- [man usermod(8)](https://man7.org/linux/man-pages/man8/usermod.8.html)

#comando
