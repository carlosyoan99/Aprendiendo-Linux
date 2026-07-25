---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: comando
prioridad: media
---

# chown

## Sintaxis
```
chown [opciones] usuario[:grupo] archivo...
```

## Descripción
Cambia el propietario y/o grupo de un archivo o directorio. Solo el usuario **root** puede cambiar el propietario de un archivo (un usuario normal no puede "regalar" sus archivos a otro).

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-R` | Recursivo — cambia propietario en todo un árbol |
| `-v` | Verboso |
| `-c` | Reporta solo los cambios realizados |
| `--from=usuario:grupo` | Cambia solo si el actual coincide |

## Modos de uso

```bash
chown usuario archivo              # cambiar solo el propietario
chown usuario:grupo archivo        # cambiar propietario y grupo
chown :grupo archivo               # cambiar solo el grupo (dejar propietario igual)
chown usuario: archivo             # cambiar propietario, grupo al del usuario
```

## Ejemplos
```bash
chown carlos documento.txt                   # asignar archivo a carlos
chown carlos:carlos documento.txt            # asignar a carlos:grupo carlos
chown -R www-data:www-data /var/www/         # cambiar toda la web a usuario del servidor
chown :docker /var/run/docker.sock           # cambiar solo el grupo a docker
chown --from=root:root nuevo:grupo archivo   # cambiar solo si es root:root actualmente
```

## Notas y advertencias
- `chown` requiere `sudo` (o ser root) para cambiar el propietario. No se puede "regalar" un archivo a otro usuario.
- Al cambiar permisos recursivamente (`-R`), los **symlinks** no se siguen por seguridad. Usar `-h` para cambiar el symlink en sí.
- Es común ver `chown -R usuario:usuario ~/` después de una instalación donde algunos archivos quedaron con root como dueño.
- `chgrp` es un comando separado para cambiar solo el grupo, pero `chown :grupo` hace lo mismo y es más compacto.

## Enlaces externos

- [Wikipedia — chown](https://en.wikipedia.org/wiki/Chown)
- [GNU Coreutils — chown manual](https://www.gnu.org/software/coreutils/manual/html_node/chown-invocation.html)

## Ver también
- [[chmod]]
- [[Permisos y Propietarios]]
- [[Cheat Sheet - Comandos Esenciales]]

#comando
