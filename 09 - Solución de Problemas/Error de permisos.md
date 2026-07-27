---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: troubleshooting
sistema: Linux permissions
prioridad: alta
---

# Error de permisos (Permission denied)

> "Permission denied" es el error más común en Linux. Aparece al ejecutar un script, acceder a un archivo, montar un disco, usar `sudo` o conectar un periférico. La causa puede ser permisos Unix, ACLs, montaje restrictivo, o SELinux/AppArmor.

## Síntoma

- `bash: ./script.sh: Permission denied` — no se puede ejecutar.
- `cat: /ruta/archivo: Permission denied` — no se puede leer.
- `touch: cannot touch 'archivo': Permission denied` — no se puede escribir.
- `sudo: unable to open /etc/sudoers: Permission denied` — el propio sudo falla.
- `mount: only root can do that` — falta privilegios para montar.
- Operaciones que funcionaban ayer hoy dan "Permission denied" (suelen ser ACLs o SELinux).

## Diagnóstico

```bash
# 1. ¿De quién es el archivo y qué permisos tiene?
ls -la archivo.txt                         # permisos + propietario + grupo
stat archivo.txt                           # info detallada (tamaño, inodo, timestamps)

# 2. ¿Quién soy? ¿A qué grupos pertenezco?
id                                         # uid, gid, grupos secundarios
id nombre_usuario                          # info de otro usuario
groups                                     # solo los grupos del usuario actual

# 3. ¿Tiene ACLs extendidas? (lo indica el + en ls -la)
getfacl archivo.txt                        # muestra ACLs completas

# 4. ¿Es un problema de montaje?
mount | grep /ruta                         # ver opciones de montaje
findmnt /ruta                              # árbol de montajes

# 5. ¿SELinux o AppArmor están bloqueando?
# SELinux (Fedora/RHEL/Rocky, Debian/Ubuntu con soporte)
ls -Z archivo.txt                          # contexto SELinux
# AppArmor (Ubuntu/Debian, openSUSE)
sudo aa-status | grep -i "archivo\|comando"  # perfiles AppArmor

# 6. ¿Hay atributos extendidos de archivo?
lsattr archivo.txt                         # atributos inmutable, append-only, etc.
```

### Logs relevantes

```bash
# SELinux: audit.log
grep -i "denied\|avc" /var/log/audit/audit.log 2>/dev/null || echo "No audit log"

# AppArmor
grep -i "apparmor\|denied" /var/log/syslog 2>/dev/null | tail -10
journalctl -k | grep -i "apparmor" | tail -10    # kernel messages

# mount fails
dmesg | grep -i "permission denied\|denied" | tail -10
```

## Causa

1. **Permisos Unix insuficientes** — el archivo/directorio no tiene permisos de `r` (lectura), `w` (escritura) o `x` (ejecución) para tu usuario o grupo.
2. **Propietario incorrecto** — el archivo pertenece a root u otro usuario y tu usuario no tiene acceso al grupo.
3. **Archivo o directorio no ejecutable** — falta `+x` para scripts (`.sh`) o para entrar a un directorio (`cd` requiere `x`).
4. **Montado con opciones restrictivas** — partición montada con `noexec` (no permite ejecutar), `ro` (solo lectura), o `nodev`.
5. **SELinux/AppArmor** — bloqueo de seguridad de nivel de kernel, común en Fedora/RHEL/Rocky/Debian.
6. **Atributos extendidos** — flag `i` (inmutable) impide modificar incluso como root.
7. **Grupo no actualizado** — después de `usermod -aG grupo`, no se ha cerrado sesión o no se ha ejecutado `newgrp`.

## Solución

```bash
# 1. Dar permisos de ejecución a un script
chmod +x script.sh
./script.sh

# 2. Dar permisos específicos (numérico)
chmod 644 archivo.txt                      # dueño: rw-, grupo: r--, otros: r--
chmod 755 directorio/                      # dueño: rwx, grupo: r-x, otros: r-x
chmod 600 ~/.ssh/id_rsa                    # clave privada: solo dueño
chmod 700 ~/.ssh                           # directorio SSH: solo dueño

# 3. Cambiar propietario (con sudo)
sudo chown usuario:grupo archivo

# Ejemplo concreto: arreglar permisos de carpetas personales
sudo chown -R $USER:$USER /home/$USER

# 4. Añadir usuario al grupo necesario
sudo usermod -aG docker $USER              # grupo docker
sudo usermod -aG vboxsf $USER              # VirtualBox shared folders
sudo usermod -aG plugdev $USER             # acceso a dispositivos USB

# ⚠️ Los cambios de grupo requieren cerrar sesión y volver a entrar
# Para aplicar sin cerrar sesión:
newgrp docker                             # inicia sub-shell con el grupo
# O ejecutar el comando en una shell con el grupo:
sg docker -c "docker ps"

# 5. Remontar con permisos adecuados
sudo mount -o remount,rw /ruta            # remontar lectura/escritura
sudo mount -o remount,exec /ruta          # remontar permitiendo ejecución

# 6. Resolver SELinux
ls -Z archivo.txt                          # contexto actual
sudo restorecon -v archivo.txt             # restaurar contexto por defecto
sudo restorecon -Rv /ruta                  # restaurar recursivamente

# Si restorecon no funciona, cambiar contexto manualmente:
sudo chcon -t httpd_sys_content_t /var/www/html/index.html

# ⚠️ No desactivar SELinux permanentemente como solución
sudo setenforce 0                          # solo para diagnóstico temporal

# 7. Eliminar atributo extendido (si el archivo es inmutable)
sudo chattr -i archivo.txt                 # quitar flag inmutable

# 8. Resolver AppArmor
sudo aa-status                             # ver perfiles
sudo aa-complain /usr/bin/programa         # modo complain (solo logs, no bloquea)
sudo aa-disable /usr/bin/programa          # desactivar perfil (si es necesario)
```

### Verificación

```bash
ls -la archivo.txt                         # verificar que los permisos cambiaron
./script.sh                                # ejecutar y confirmar que funciona
cat archivo.txt                            # leer y confirmar
```

## Escenarios / Variantes

| Variante / Síntoma | Causa | Solución |
|---|---|---|
| **Cannot cd into directory** | Directorio sin permiso `x` (ejecución) para tu usuario | `chmod +x directorio/` — el bit `x` en directorios es necesario para entrar |
| **sudo: command not found** aunque existe | /sbin o /usr/sbin no están en PATH del usuario root (sudo -s vs sudo -i) | Usar `sudo -i` (login shell) o `sudo env PATH=$PATH comando` |
| **/etc/shadow: Permission denied** | shadow solo legible por root; es normal | No leer /etc/shadow directamente, usar `sudo cat /etc/shadow` si es necesario |
| **Clave SSH ignorada / pubs keys no funcionan** | Permisos incorrectos en ~/.ssh | `chmod 700 ~/.ssh && chmod 600 ~/.ssh/* && chmod 644 ~/.ssh/*.pub` |
| **USB mount: Permission denied** | Usuario no en grupo plugdev, o udisks no instalado | `sudo usermod -aG plugdev $USER`; instalar `udisks2` |
| **Docker: permission denied** | Usuario no en grupo docker | `sudo usermod -aG docker $USER && newgrp docker` (ver [[Docker permiso denegado]]) |
| **NFS: Permission denied** | UID/GID no coinciden entre cliente y servidor NFS | `id` en ambos lados; usar `anonuid`, `anongid` en /etc/exports |
| **Flatpak/Snap: no puede acceder a ~/Descargas** | Sandboxing de la aplicación | Usar `flatpak override --filesystem=~/Descargas` o configurar permisos en Snap |
| **Archivo inmutable ni root puede borrarlo** | Atributo extendido `i` (inmutable) | `sudo chattr -i archivo.txt` y luego borrar |
| **Systemd-resolved: Failed to connect socket** | Permisos de /run/systemd/resolve | `sudo systemctl restart systemd-resolved`; verificar propietario de socket |

## Prevención

1. **No usar `chmod 777`** como solución genérica — es inseguro. Prefiere permisos específicos (755 para directorios, 644 para archivos).
2. **No ejecutar scripts con `sudo`** sin entender qué hacen — puedes dañar el sistema.
3. **Verificar permisos de montaje** antes de copiar archivos a una partición externa — `mount | grep /mnt`.
4. **Si usas Fedora/RHEL**, aprender los comandos básicos de SELinux (`restorecon`, `chcon`, `audit2allow`).
5. **No desactivar SELinux** en producción — configurarlo correctamente.
6. **Usar `sudo -l`** para ver qué comandos puedes ejecutar como root.

## Notas adicionales

- El orden de verificación para permisos en Linux es: **propietario** → **grupo** → **otros**. El primer match se aplica y los siguientes se ignoran. Si eres el propietario del archivo, se usan los permisos de propietario aunque estés en el grupo.
- `chmod 777` da permisos totales a cualquiera (lectura, escritura, ejecución). Equivale a `chmod ugo+rwx`.
- `strace` puede ayudar a diagnosticar errores de permisos difíciles: `strace -e trace=open,openat,stat ./script 2>&1 | grep -i EACCES`.

## Enlaces externos

- [Wikipedia — chmod](https://en.wikipedia.org/wiki/Chmod)
- [Wikipedia — chown](https://en.wikipedia.org/wiki/Chown)
- [Wikipedia — Unix permissions](https://en.wikipedia.org/wiki/File-system_permissions)
- [Arch Wiki — File permissions and attributes](https://wiki.archlinux.org/title/File_permissions_and_attributes)
- [man page chmod(1)](https://man.archlinux.org/man/chmod.1)
- [man page chown(1)](https://man.archlinux.org/man/chown.1)
- [Red Hat — SELinux troubleshooting](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/troubleshooting-problems-related-to-selinux_using-selinux)

## Ver también

- [[Permisos y Propietarios]] — nota completa sobre permisos en Linux
- [[chmod]] — comando chmod en profundidad
- [[chown]] — comando chown en profundidad
- [[ACLs]] — listas de control de acceso extendidas
- [[SELinux y AppArmor]] — módulos de seguridad de Linux
- [[strace]] — depuración de llamadas al sistema

#troubleshooting
