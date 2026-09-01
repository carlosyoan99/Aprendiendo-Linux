---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: alta
---

# chmod

> Cambia los permisos de lectura (r), escritura (w) y ejecución (x) de archivos y directorios. Herramienta fundamental para resolver "Permission denied" y gestionar quién puede acceder a qué.

## Sintaxis

```bash
chmod [opciones] permisos archivo...
```

## Descripción

Cambia los permisos de lectura (r), escritura (w) y ejecución (x) de archivos y directorios. Soporta dos modos: **octal** (números) y **simbólico** (letras). Es el comando que resuelve "Permission denied" cuando el problema no es de propietario.

## Modo simbólico

```
Referencias: u (dueño/user), g (grupo), o (otros/others), a (todos/all)
Operadores:  + (añadir), - (quitar), = (igualar/poner exactamente)
Permisos:    r (leer), w (escribir), x (ejecutar)
```

## Opciones principales

| Flag | Efecto |
|---|---|
| `-R` | Recursivo — cambia permisos en todo un árbol de directorios |
| `-v` | Verboso |
| `-c` | Reporta solo los cambios realizados (`--changes`) |
| `--reference=archivo` | Copia los permisos de otro archivo |

## Tabla de permisos (notación octal)

| Número | Binario | Permisos |
|--------|---------|----------|
| 0 | 000 | `---` |
| 1 | 001 | `--x` |
| 2 | 010 | `-w-` |
| 3 | 011 | `-wx` |
| 4 | 100 | `r--` |
| 5 | 101 | `r-x` |
| 6 | 110 | `rw-` |
| 7 | 111 | `rwx` |

```bash
# Cálculo: 755 = dueño(7=rwx) + grupo(5=r-x) + otros(5=r-x)
```

## Ejemplos

```bash
# Octal (común)
chmod 755 script.sh               # dueño:rwx, grupo:rx, otros:rx (scripts)
chmod 644 documento.txt           # dueño:rw, grupo:r, otros:r (archivos)
chmod 700 privado/                # solo dueño puede entrar/leer
chmod 600 ~/.ssh/id_ed25519      # obligatorio para claves SSH
chmod 777 todo_visible/           # ⚠️ todos acceden (nunca usar)

# Simbólico (más legible)
chmod +x script.sh                # añadir ejecución a todos
chmod u+x script.sh               # añadir ejecución solo al dueño
chmod go-w archivo.txt            # quitar escritura a grupo y otros
chmod a=rw archivo.txt            # poner lectura+escritura a todos
chmod -R g+w directorio/          # añadir escritura al grupo recursivamente

# Con referencia
chmod --reference=modelo.txt destino.txt   # copiar permisos de modelo
```

## Recetas comunes

```bash
# Scripts ejecutables
chmod 755 script.sh

# Archivos de configuración privados
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_*

# Directorio web
chmod -R 755 /var/www/html/
chmod -R 644 /var/www/html/*.html

# Directorio compartido en grupo
chmod 2775 /compartido/          # 2 = SGID (nuevos archivos heredan grupo)
chmod 1777 /tmp/                 # 1 = sticky bit (solo dueño borra)

# Logs accesibles solo por root
chmod 640 /var/log/miapp.log
chmod 640 /var/log/miapp/
```

## Permisos especiales

| Permiso | Octal | Efecto |
|---|---|---|
| **SUID** (4) | `4755` | Ejecuta como propietario del archivo |
| **SGID** (2) | `2755` | Ejecuta como grupo / hereda grupo en directorios |
| **Sticky bit** (1) | `1777` | Solo el dueño puede borrar archivos (ej: `/tmp`) |

```bash
# Ejemplos de permisos especiales
chmod 4755 /usr/bin/passwd       # SUID: ejecuta como root
chmod 2775 /equipo/proyectos/    # SGID: nuevos archivos heredan grupo
chmod 1777 /tmp/                 # Sticky: solo dueño puede borrar
```

## Notas y advertencias

- Para cambiar permisos necesitas ser el **propietario** o **root**.
- `chmod +x` es lo mínimo para que un script sea ejecutable (`./script.sh`).
- En directorios, `x` significa **poder entrar** (no ejecutar). Sin `x`, no puedes `cd` ni listar.
- El combo `chmod 600` para claves SSH (`~/.ssh/id_ed25519`) es **obligatorio** — SSH rechaza claves con permisos abiertos.
- `chmod -R` en directorios grandes puede tardar. Usar con cuidado.
- Para permisos más granulares, usar [[ACLs]] (`setfacl`/`getfacl`).

## Ver también

- [[chown]] — cambiar propietario y grupo
- [[chgrp]] — cambiar solo el grupo
- [[Permisos y Propietarios]] — conceptos completos
- [[ACLs]] — permisos avanzados
- [[Cheat Sheet - Comandos Esenciales]]
- [[SSH]] — claves SSH y permisos

## Enlaces externos

- [Wikipedia — chmod](https://en.wikipedia.org/wiki/Chmod)
- [GNU Coreutils — chmod manual](https://www.gnu.org/software/coreutils/manual/html_node/chmod-invocation.html)
- [Arch Wiki — chmod](https://man.archlinux.org/man/chmod.1)

#comando #permisos #seguridad
