---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: baja
---

# chsh — Cambiar shell por defecto

Cada usuario tiene un shell por defecto definido en `/etc/passwd`. `chsh` permite cambiarlo.

## Sintaxis

```
chsh -s /ruta/al/shell [usuario]
```

## Ejemplos

```bash
# Ver shells disponibles
cat /etc/shells
# /bin/bash
# /bin/zsh
# /bin/fish

# Cambiar shell (usuario actual)
chsh -s /usr/bin/zsh

# Cambiar shell de otro usuario (solo root)
sudo chsh -s /usr/bin/fish maria

# Verificar
grep maria /etc/passwd
# maria:x:1001:1001::/home/maria:/usr/bin/fish
```

> Si un shell no está en `/etc/shells`, `chsh` dará error. Esto es una validación de seguridad.

## Ver también

- [[PAM]] — módulos de autenticación
- [[Shells (bash zsh fish)]] — shells disponibles
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — índice

## Enlaces externos

- [man7 — chsh](https://man7.org/linux/man-pages/man1/chsh.1.html)

#comando #usuarios
