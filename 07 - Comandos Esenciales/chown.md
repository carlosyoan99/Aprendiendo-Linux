---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# chown

> Cambia el propietario y/o grupo de un archivo o directorio. Solo root puede transferir la propiedad — un usuario normal **no puede** "regalar" sus archivos a otro.

## Sintaxis

```bash
chown [opciones] usuario[:grupo] archivo...
chown [opciones] :grupo archivo...              # cambiar solo el grupo
chown [opciones] --reference=archivo_ref destino  # copiar propietario de otro archivo
```

## Descripción

`chown` (change owner) asigna un nuevo propietario y/o grupo a uno o más archivos. Es el comando principal para corregir problemas de propiedad después de copias con `sudo`, instalaciones de software, o montajes de discos externos.

**⚠️ Seguridad**: Solo root puede cambiar el propietario. No existe `chown` sin `sudo` para cambiar a otro usuario — esto evita que un usuario malicioso pueda "regalar" archivos comprometidos y eludir cuotas de disco.

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-R` | Recursivo — cambia en todo un árbol de directorios | `chown -R user:group /ruta/` |
| `-v` | Verboso — muestra cada archivo procesado | `chown -v user archivo` → `changed ownership of 'archivo' from old to new` |
| `-c` | Reporta solo los cambios realizados (no los archivos sin cambios) | `chown -c user archivo` |
| `-h` | Cambia el symlink en sí, no el archivo al que apunta | `chown -h user symlink` |
| `--from=user_actual:grupo_actual` | Cambia solo si el propietario actual coincide | `chown --from=root:root user archivo` |
| `--reference=archivo` | Copia propietario y grupo de otro archivo | `chown --reference=modelo.txt destino.txt` |
| `--preserve-root` | No opera recursivamente sobre `/` (protección contra errores) | `chown -R --preserve-root user /` (falla) |

## Formato de salida

Con `-v`:
```text
changed ownership of 'archivo.txt' from root:root to carlos:carlos
```

Con `-c` (solo cuando realmente hubo cambio):
```text
changed ownership of 'archivo.txt' from root:root to carlos:carlos
# No imprime nada si no hubo cambios
```

## Modos de uso

```bash
chown usuario archivo                   # cambiar solo el propietario
chown usuario:grupo archivo             # cambiar propietario y grupo
chown usuario: archivo                  # cambiar propietario, grupo al grupo principal del usuario
chown :grupo archivo                    # cambiar solo el grupo (dejar propietario igual)
```

## Ejemplos

```bash
# 1. Asignar archivo a un usuario específico
sudo chown carlos documento.txt

# 2. Asignar propietario y grupo
sudo chown carlos:carlos documento.txt

# 3. Arreglar permisos de toda una web (recomendado tras clonar repositorio)
sudo chown -R www-data:www-data /var/www/

# 4. Cambiar solo el grupo (útil para sockets Docker)
sudo chown :docker /var/run/docker.sock

# 5. Usar --from para cambiar solo si es root:root actualmente
sudo chown --from=root:root carlos:carlos archivo.txt

# 6. Copiar propietario de otro archivo
sudo chown --reference=modelo.txt destino.txt

# 7. Recursivo con verificación de cada archivo
sudo chown -Rv carlos:carlos /home/carlos/

# 8. Después de copiar archivos con sudo (recuperar propiedad)
sudo chown -R $USER:$USER ~/Descargas/
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Arreglar carpeta personal** tras restore o instalación nueva | `sudo chown -R $USER:$USER ~/` |
| **Permisos de servidor web** después de clonar repo con sudo | `sudo chown -R www-data:www-data /var/www/proyecto` |
| **Montaje USB/NFS** — archivos aparecen como root | `sudo chown -R $USER:$USER /media/usb/` |
| **Socket Docker** — añadir usuario al grupo docker o cambiar socket | `sudo chown :docker /var/run/docker.sock` |
| **Copiar permisos de un archivo modelo** a otros | `sudo chown --reference=.env.example .env` |

## Combinaciones comunes con pipe

```bash
# Cambiar propietario de todos los archivos creados por root en home
find ~/ -user root -exec sudo chown $USER:$USER {} \;

# Listar archivos con un propietario específico y arreglarlos
find /var/www -user root | xargs sudo chown www-data:www-data

# Arreglar permisos de archivos copiados con sudo (sólo archivos, no directorios)
find ~/Descargas/ -type f -user root -exec sudo chown $USER:$USER {} \;
```

## Alternativas modernas

| Comando | Alternativa | Cuándo usarla |
|---|---|---|
| `chown` | (ninguna) | No hay reemplazo directo. El comando es parte de GNU Coreutils |
| `chown :grupo` | `chgrp` | `chgrp` cambia solo el grupo, mismo efecto que `chown :grupo`. Cuestión de preferencia |
| `chown --reference` | `cp -p` | `cp -p archivo_copy` preserva propietario si se ejecuta como root |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `chown: changing ownership of 'archivo': Operation not permitted` | No eres root o no tienes permisos CAP_CHOWN | Anteponer `sudo` |
| `chown: invalid user: 'usuario'` | El usuario o grupo no existe | Verificar con `id usuario` o `getent passwd usuario` |
| `chown: cannot access 'archivo': No such file or directory` | La ruta no existe | Verificar con `ls -la` que el archivo exista |
| `chown: 'archivo' and 'archivo' are the same file` | Origen y destino apuntan al mismo inodo | Usar `--reference` en vez del argumento |
| `chown: changing ownership of 'symlink': Not supported` | El sistema de archivos no soporta cambiar propietario de symlinks | Usar `-h` para cambiar el symlink en sí |

## Notas y advertencias

- **No puedes "regalar" un archivo**: `chown otro_usuario archivo` requiere sudo. Linux previene que un usuario evite cuotas de disco regalando archivos.
- **Symlinks**: por defecto, `chown` sigue el symlink. Usar `-h` para cambiar el symlink en lugar del destino.
- **Recursivo con cuidado**: `chown -R /` sin `--preserve-root` puede dejar el sistema inutilizable. Siempre verificar 3 veces la ruta al usar `-R`.
- **Sistemas de archivos**: NFS con `root_squash` (root anónimo) impide `chown` remoto como root. Sistemas FAT/exFAT/VFAT no soportan propietarios Unix.
- **Diferencia con `chgrp`**: `chown :grupo` y `chgrp grupo` hacen exactamente lo mismo. Usa `chown :grupo` si ya estás usando `chown`; usa `chgrp` si solo cambias grupo (más explícito).

## Enlaces externos

- [Wikipedia — chown](https://en.wikipedia.org/wiki/Chown)
- [GNU Coreutils — chown manual](https://www.gnu.org/software/coreutils/manual/html_node/chown-invocation.html)
- [Arch Wiki — File permissions and attributes](https://wiki.archlinux.org/title/File_permissions_and_attributes)
- [Linux man page — chown(1)](https://man.archlinux.org/man/chown.1)

## Ver también

- [[chmod]] — cambiar permisos de archivos
- [[chgrp]] — cambiar grupo (alternativa a `chown :grupo`)
- [[Permisos y Propietarios]] — nota completa sobre permisos en Linux
- [[ACLs]] — listas de control de acceso extendidas
- [[Error de permisos]] — troubleshooting de Permission denied
- [[Cheat Sheet - Comandos Esenciales]]

#comando
