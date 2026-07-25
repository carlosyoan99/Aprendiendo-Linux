---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# chgrp

> Cambia el grupo propietario de archivos y directorios. Es la alternativa explícita a `chown :grupo` cuando solo necesitas cambiar el grupo.

## Sintaxis

```bash
chgrp [opciones] grupo archivo...
chgrp [opciones] --reference=archivo_ref destino
```

## Descripción

`chgrp` (change group) cambia el grupo al que pertenece un archivo o directorio. Es funcionalmente idéntico a `chown :grupo`, pero más explícito cuando solo quieres cambiar el grupo (no el usuario).

Un usuario normal puede cambiar el grupo de sus archivos **solo a grupos de los que es miembro**. Root puede cambiar a cualquier grupo.

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-R` | Recursivo | `chgrp -R www-data /var/www/` |
| `-v` | Verboso | `chgrp -v docker /var/run/docker.sock` |
| `-c` | Reportar solo cambios | `chgrp -c grupo archivo` |
| `-h` | Cambiar el symlink en sí, no el destino | `chgrp -h grupo symlink` |
| `--reference=archivo` | Copiar grupo de otro archivo | `chgrp --reference=modelo.txt destino.txt` |
| `--preserve-root` | No operar sobre `/` | `chgrp -R --preserve-root grupo /` |

## Ejemplos

```bash
# 1. Cambiar grupo de un archivo
sudo chgrp www-data index.html

# 2. Recursivo en un directorio
sudo chgrp -R www-data /var/www/mi-sitio/

# 3. Verboso (ver cada archivo procesado)
sudo chgrp -Rv docker /var/run/

# 4. Copiar grupo de otro archivo
sudo chgrp --reference=modelo.txt destino.txt

# 5. Cambiar grupo de un symlink (no el destino)
sudo chgrp -h grupo mi-enlace

# 6. Usuario normal cambia a grupo del que es miembro
chgrp docker /tmp/test.sock
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Socket Docker** — dar acceso al grupo docker | `sudo chgrp docker /var/run/docker.sock` |
| **Servidor web** — archivos del proyecto legibles por nginx | `sudo chgrp -R www-data /var/www/proyecto` |
| **Directorio compartido** — varios usuarios del mismo grupo | `sudo chgrp -R desarrolladores /opt/proyecto` |
| **USB montado** — permitir escritura a grupo específico | `sudo chgrp -R usuarios /media/disco` |

## chgrp vs chown :grupo

```bash
# Equivalente exacto:
chgrp grupo archivo
chown :grupo archivo

# Ambos hacen lo mismo. Usa chgrp si solo cambias grupo (más legible).
```

## Combinaciones comunes con pipe

```bash
# Cambiar grupo de todos los archivos de un usuario
find /var/www -group root -exec sudo chgrp www-data {} \\;

# Verificar que el cambio se aplicó
ls -la /var/www/ | grep www-data
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `chgrp: changing group of 'archivo': Operation not permitted` | No tienes permisos o no eres miembro del grupo destino | Usar `sudo` o verificar con `groups $USER` |
| `chgrp: invalid group: 'grupo'` | El grupo no existe | `getent group grupo` para verificar |
| `chgrp: cannot access 'archivo': No such file or directory` | El archivo no existe | Verificar ruta con `ls -la` |

## Notas

- `chgrp` y `chown :grupo` son exactamente equivalentes — cuestión de preferencia.
- `chgrp -R` sobre `/` puede dejar el sistema inutilizable. Usar `--preserve-root`.
- Sistemas FAT/exFAT no soportan grupos Unix.

## Enlaces externos

- [Wikipedia — chgrp](https://en.wikipedia.org/wiki/Chgrp)
- [GNU Coreutils — chgrp manual](https://www.gnu.org/software/coreutils/manual/html_node/chgrp-invocation.html)
- [Linux man page — chgrp(1)](https://man.archlinux.org/man/chgrp.1)

## Ver también

- [[chown]] — cambiar propietario (puede cambiar grupo también)
- [[chmod]] — cambiar permisos
- [[Permisos y Propietarios]] — guía completa de permisos
- [[groups]] — ver grupos del usuario actual
- [[Cheat Sheet - Comandos Esenciales]]

#comando #coreutils
