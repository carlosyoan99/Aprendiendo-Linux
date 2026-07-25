---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: sistema
prioridad: media
---

# ACLs (Access Control Lists)

## Definición

Las ACLs (Listas de Control de Acceso) extienden el modelo tradicional de permisos de Linux (dueño/grupo/otros) permitiendo asignar permisos específicos a **múltiples usuarios y grupos** sobre un mismo archivo o directorio. Mientras que los permisos clásicos solo permiten un dueño y un grupo, las ACLs permiten una lista arbitraria de entradas (ACE — Access Control Entry).

```
Permisos clásicos (rwx para 3 roles):
  rwx  r-x  ---
 dueño grupo otros

ACLs (lista arbitraria):
  dueño:    rwx
  grupo:    r-x
  otros:    ---
  usuario1: rw-    ← ACL adicional
  usuario2: ---    ← ACL adicional
  grupo2:   rwx    ← ACL adicional
```

## Comandos

```bash
# getfacl — ver ACLs de un archivo
getfacl archivo.txt

# setfacl — establecer ACLs
setfacl -m u:maria:rw archivo.txt       # dar permisos rw al usuario maria
setfacl -m g:developers:rx archivo.txt  # dar permisos rx al grupo developers
setfacl -x u:maria archivo.txt          # eliminar la ACL del usuario maria

# ACL por defecto (se hereda a nuevos archivos dentro de un directorio)
setfacl -d -m g:developers:rx directorio/  # nuevos archivos heredan permiso rx para developers
```

## Opciones frecuentes de setfacl

| Flag | Efecto |
|------|--------|
| `-m` | Modificar (añadir/actualizar) una ACL |
| `-x` | Eliminar una ACE específica |
| `-b` | Eliminar todas las ACLs (volver a permisos clásicos) |
| `-R` | Recursivo (aplicar a todo un árbol) |
| `-d` | ACL por defecto (se hereda a nuevos archivos) |

## Lectura de permisos con ACL

```bash
ls -l archivo.txt
# -rw-rw----+ 1 carlos carlos 1234 Jul 18 12:00 archivo.txt
#             ↑
# El "+" al final indica que este archivo tiene ACLs extendidas
```

```bash
getfacl archivo.txt
# file: archivo.txt
# owner: carlos
# group: carlos
# user::rw-          ← permisos clásicos del dueño
# user:maria:rw-     ← ACL: maria tiene rw
# group::r--         ← permisos clásicos del grupo
# group:developers:rx-  ← ACL: grupo developers tiene rx
# mask::rwx          ← máscara: limita el máximo permiso que las ACLs pueden otorgar
# other::---         ← permisos clásicos de otros
```

**La máscara**: es el máximo permiso efectivo que cualquier ACE (excepto el dueño y otros) puede otorgar. Si la máscara es `r--`, un usuario con ACL `rwx` tendrá efectivamente solo `r--`.

## Cuándo usar ACLs

| Situación | Sin ACLs | Con ACLs |
|---|---|---|
| Un usuario necesita acceso a un archivo de otro | Mover al grupo o compartir contraseña del dueño | `setfacl -m u:usuario:r archivo` |
| Varios grupos con distintos permisos sobre un mismo directorio | Imposible (solo un grupo por archivo) | `setfacl -m g:grupoA:rx,g:grupoB:rwx directorio/` |
| Directorio compartido donde los archivos nuevos heredan permisos específicos | No posible automáticamente | `setfacl -d -m g:grupo:rwx directorio/` |

## Por qué importa

- Los permisos clásicos de Linux (dueño/grupo/otros) se quedan cortos en entornos con múltiples usuarios y grupos (servidores de archivos, proyectos colaborativos, entornos educativos).
- Las ACLs son la solución estándar en Linux para este problema — no hay que instalar nada extra, están en el kernel desde hace años.
- El `+` en `ls -l` te avisa de que hay ACLs, pero no muestra los detalles (hay que usar `getfacl`).

## Relación con otros conceptos

- [[Permisos y Propietarios]] — la base sobre la que se apoyan las ACLs
- [[chmod]] — permisos clásicos
- [[chown]] — cambio de propietario

## Ver también

- [[Permisos y Propietarios]]
- [[chmod]]
- [[chown]]
- [[LVM]] — también es una capa de abstracción, pero para discos

## Enlaces externos

- [Wikipedia — Access-control list](https://en.wikipedia.org/wiki/Access-control_list)
- [Arch Wiki — ACL](https://wiki.archlinux.org/title/Access_Control_Lists)
- [Red Hat — ACL manual](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_file_systems/task-setting-access-acls)

#sistema
