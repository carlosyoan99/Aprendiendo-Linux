---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: troubleshooting
sistema: Linux permissions
prioridad: alta
---

# Error de permisos (Permission denied)

## Síntoma

Al intentar ejecutar un script, acceder a un archivo, montar un disco o usar `sudo`, aparece el mensaje "Permission denied" o "Operation not permitted".

## Diagnóstico

```bash
# 1. ¿De quién es el archivo y qué permisos tiene?
ls -la archivo.txt                         # permisos + propietario + grupo
stat archivo.txt                           # información detallada (incluye ACL)

# 2. ¿Quién soy?
id                                         # mi uid, gid y grupos

# 3. ¿Tiene ACLs extendidas?
getfacl archivo.txt                        # muestra ACLs si las hay (el + en ls -la)

# 4. ¿Es un problema de montaje?
mount | grep /ruta                         # ver opciones de montaje (noexec, ro, etc.)
```

## Causa

1. **Permisos insuficientes** — el archivo no tiene permisos de lectura/escritura/ejecución para tu usuario o grupo.
2. **Propietario incorrecto** — el archivo pertenece a root u otro usuario y no tienes acceso.
3. **Archivo no ejecutable** — falta `+x` para scripts.
4. **Montado con opciones restrictivas** — disco montado con `noexec`, `ro` (solo lectura) o `nodev`.
5. **SELinux/AppArmor** — bloqueo de seguridad adicional (común en Fedora/RHEL/Rocky).

## Solución

```bash
# 1. Dar permisos de ejecución a un script
chmod +x script.sh
./script.sh

# 2. Cambiar propietario (necesita sudo)
sudo chown usuario:grupo archivo

# 3. Dar permisos de lectura/escritura
chmod 644 archivo.txt                      # dueño rw, resto solo lectura
chmod 755 directorio/                      # dueño rwx, grupo rx, otros rx

# 4. Añadir usuario al grupo necesario
sudo usermod -aG docker $USER              # ejemplo: agregar al grupo docker
sudo usermod -aG vboxsf $USER              # ejemplo: carpetas compartidas VirtualBox
# (requiere cerrar sesión y volver a entrar)

# 5. Remontar con permisos adecuados
sudo mount -o remount,rw /ruta            # remontar lectura/escritura
sudo mount -o remount,exec /ruta          # remontar permitiendo ejecución

# 6. Solución drástica: ejecutar como root (no recomendado como hábito)
sudo ./script.sh

# 7. SELinux (Fedora/RHEL/Rocky)
ls -Z archivo.txt                          # ver contexto SELinux
sudo restorecon -v archivo.txt             # restaurar contexto por defecto
sudo setenforce 0                          # desactivar temporalmente (solo diagnóstico)
```

## Enlaces externos

- [Wikipedia — chmod](https://en.wikipedia.org/wiki/Chmod)
- [Wikipedia — chown](https://en.wikipedia.org/wiki/Chown)
- [Wikipedia — Unix permissions](https://en.wikipedia.org/wiki/File-system_permissions)
- [Arch Wiki — File permissions and attributes](https://wiki.archlinux.org/title/File_permissions_and_attributes)
- [man page chmod(1)](https://man.archlinux.org/man/chmod.1)
- [man page chown(1)](https://man.archlinux.org/man/chown.1)
- [Red Hat — SELinux troubleshooting](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/troubleshooting-problems-related-to-selinux_using-selinux)

## Referencias

- [[Permisos y Propietarios]] — nota completa sobre permisos en Linux
- [[chmod]] y [[chown]] — comandos específicos

#troubleshooting
