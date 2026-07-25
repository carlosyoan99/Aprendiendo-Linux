---
fecha_creacion: 2026-07-20
estado: resuelto
categoria: comando
prioridad: alta
---

# adduser

## Sintaxis
```bash
adduser [opciones] nombre_usuario
```

## Descripción

**adduser** es la versión interactiva y amigable de `useradd`. Mientras que `useradd` es la herramienta de bajo nivel para crear usuarios, `adduser` guía al administrador con preguntas (nombre completo, contraseña, etc.) y aplica configuraciones por defecto definidas en `/etc/adduser.conf`.

La gran diferencia: **adduser** pregunta por el campo GECOS (nombre completo, teléfono, etc.), crea el grupo del mismo nombre, el directorio home, y copia los archivos de `/etc/skel/`. **useradd** solo registra la entrada en `/etc/passwd` y `/etc/shadow` — sin opciones adicionales no crea ni el home ni el grupo.

## Diferencias entre distribuciones

| Distribución | adduser | useradd |
|---|---|---|
| **Debian/Ubuntu** | `adduser` es el comando interactivo avanzado (Perl script) | `useradd` es el binario de bajo nivel (shadow-utils) |
| **Red Hat/Fedora** | `adduser` es un enlace simbólico a `useradd` | `useradd` es el único comando real |

En Debian y derivados, **adduser** es el comando recomendado para crear usuarios. En Red Hat y derivados, se usa directamente `useradd`.

## Opciones frecuentes

| Flag / Opción | Efecto | Ejemplo |
|---|---|---|
| `--home DIR` | Especificar directorio home | `adduser juan --home /var/www/juan` |
| `--shell SHELL` | Shell por defecto | `adduser juan --shell /usr/bin/zsh` |
| `--ingroup GRUPO` | Grupo principal del usuario | `adduser juan --ingroup developers` |
| `--disabled-password` | Crear usuario sin contraseña (cuenta bloqueada) | `adduser juan --disabled-password` |
| `--gecos "texto"` | Especificar campo GECOS sin interactividad | `adduser juan --gecos "Juan Pérez,313,,"` |
| `--no-create-home` | No crear directorio home | `adduser juan --no-create-home` |
| `--system` | Crear usuario de sistema (sin home, sin contraseña) | `adduser --system mysql` |

## Configuración global: `/etc/adduser.conf`

```bash
# Valores por defecto para todos los usuarios nuevos
cat /etc/adduser.conf | grep -v '^#' | grep -v '^$'
```

Parámetros clave:

| Directiva | Valor típico | Qué hace |
|---|---|---|
| `DHOME` | `/home` | Directorio base donde se crean los homes |
| `DSHELL` | `/bin/bash` | Shell por defecto |
| `FIRST_SYSTEM_UID` / `LAST_SYSTEM_UID` | 100-999 | Rango de UIDs para usuarios de sistema |
| `FIRST_UID` / `LAST_UID` | 1000-59999 | Rango de UIDs para usuarios normales |
| `USERGROUPS` | yes | Crear un grupo con el mismo nombre que el usuario |
| `SKEL` | `/etc/skel` | Directorio plantilla para el home |
| `QUOTAUSER` | (vacío) | Usuario cuya cuota se copia |

## Ejemplos de uso

```bash
# Uso básico (interactivo: pide contraseña y datos)
sudo adduser juan

# No interactivo (útil para scripts)
sudo adduser juan --gecos "Juan Pérez,3,612345678," --disabled-password

# Usuario de sistema (para servicios)
sudo adduser --system --group --no-create-home mysql

# Especificar home y shell diferentes
sudo adduser juan --home /srv/juan --shell /usr/bin/zsh

# Verificar creación
id juan
ls -la /home/juan/
sudo passwd juan      # asignar o cambiar contraseña
```

## Campos GECOS

El campo GECOS (en `/etc/passwd`) almacena información adicional del usuario, separada por comas:

| Campo | Significado | Ejemplo |
|---|---|---|
| 1 | Nombre completo | Juan Pérez García |
| 2 | Número de habitación/oficina | 3B |
| 3 | Teléfono interno | 612345678 |
| 4 | Otro teléfono | 912345678 |

```bash
# Ver campo GECOS
finger juan
# O directamente en /etc/passwd
grep juan /etc/passwd | awk -F: '{print $5}'

# Modificar GECOS después de crear
sudo chfn juan
```

## Troubleshooting

| Error | Causa | Solución |
|---|---|---|
| `user juan already exists` | El usuario ya está creado | Usar `usermod` para modificar |
| `group juan already exists` | adduser crea grupo automáticamente | Es normal, usar `--ingroup` para evitar |
| `No existe /etc/skel` | Directorio plantilla no encontrado | Crear `/etc/skel/` con contenido básico |
| `UID 1000 already exists` | Conflicto de UID | Debian/Ubuntu gestiona UIDs automáticamente |

## Notas y advertencias

- En Debian/Ubuntu, **usa siempre `adduser`** para crear usuarios humanos y `addgroup` para grupos
- `adduser --system` crea usuarios sin contraseña ni home — perfecto para servicios (nginx, mysql, postgres)
- El comando complementario para eliminar es `deluser` (también interactivo, Debian/Ubuntu)
- Los scripts de automatización deben usar `useradd` (más predecible y no interactivo)

## Enlaces externos

- [man adduser (Linux die.net)](https://linux.die.net/man/8/adduser)
- [Wikipedia — adduser](https://es.wikipedia.org/wiki/Adduser)
- [Debian Wiki — adduser](https://wiki.debian.org/adduser)

## Ver también

- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — gestión de usuarios en profundidad
- [[Permisos y Propietarios]] — dueños de archivos y grupos
- [[sudo]] — ejecutar como superusuario

#comando #usuarios
