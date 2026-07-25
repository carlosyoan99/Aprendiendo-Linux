---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# sudo

## Sintaxis
```
sudo [opciones] comando [argumentos...]
sudo [opciones] -u usuario comando
```

## Descripción

`sudo` (superuser do) permite ejecutar comandos con privilegios de otro usuario (por defecto `root`), autenticando con la **contraseña del propio usuario** (no la de root). Es el mecanismo estándar de escalada de privilegios en Linux, reemplazando al antiguo `su` para tareas administrativas.

A diferencia de `su`, que requiere la contraseña de root y abre una shell completa, `sudo` otorga privilegios específicos con auditoría (`/var/log/auth.log` o `journald`).

## Archivo de configuración: `/etc/sudoers`

El archivo `/etc/sudoers` define quién puede ejecutar qué comandos. **Nunca se edita directamente** — siempre con `visudo`:

```bash
sudo visudo                    # editor seguro (valida sintaxis al guardar)
sudo visudo -f /etc/sudoers.d/archivo  # archivo separado (recomendado)
```

### Sintaxis del sudoers

```
usuario    HOST=(USUARIO:GRUPO)  TAG: COMANDOS
%grupo     HOST=(USUARIO:GRUPO)  TAG: COMANDOS
```

| Campo | Descripción | Ejemplo |
|---|---|---|
| `usuario` / `%grupo` | Usuario o grupo (con %) | `carlos` / `%wheel` |
| `HOST` | Hostname (usar `ALL` para todos) | `ALL` |
| `(USUARIO:GRUPO)` | Como qué usuario/grupo ejecutar | `(ALL:ALL)` |
| `TAG:` | Tags opcionales (ver abajo) | `NOPASSWD:` |
| `COMANDOS` | Rutas absolutas o `ALL` | `/usr/bin/pacman, /usr/bin/systemctl` |

### Ejemplos comunes

```bash
# Usuario 'carlos' puede ejecutar cualquier comando
carlos ALL=(ALL:ALL) ALL

# Grupo wheel puede ejecutar cualquier comando (pide contraseña)
%wheel ALL=(ALL:ALL) ALL

# Grupo wheel sin contraseña
%wheel ALL=(ALL:ALL) NOPASSWD: ALL

# Usuario puede solo reiniciar y apagar
carlos ALL=(ALL:ALL) /usr/sbin/reboot, /usr/sbin/shutdown

# Usuario puede gestionar systemd (pero no editar archivos)
carlos ALL=(ALL:ALL) /usr/bin/systemctl *

# Ejecutar solo como un usuario específico
carlos ALL=(www-data) ALL
```

### Tags especiales

| Tag | Efecto |
|---|---|
| `NOPASSWD:` | No pedir contraseña |
| `PASSWD:` | Forzar contraseña (por defecto) |
| `SETENV:` | Permitir pasar variables de entorno |
| `NOSETENV:` | No permitir pasar variables |
| `NOEXEC:` | Impedir que el comando ejecute otros programas |

## Opciones frecuentes

| Flag | Efecto |
|---|---|
| `-u usuario` | Ejecutar como otro usuario (no root) |
| `-g grupo` | Ejecutar con un grupo específico |
| `-k` | Invalidar la caché de contraseña |
| `-l` | Listar los comandos permitidos para el usuario actual |
| `-ll` | Listado detallado (con rutas completas) |
| `-v` | Validar/extender la caché sin ejecutar nada |
| `-E` | Preservar el entorno (`env_reset`) |
| `-s` | Ejecutar shell con privilegios |
| `-i` | Ejecutar shell de login (entorno completo de root) |
| `-H` | Usar el HOME del usuario destino |

## Ejemplos

```bash
# Ejecutar un comando como root
sudo pacman -Syu

# Ejecutar como otro usuario
sudo -u www-data whoami

# Listar permisos del usuario actual
sudo -l

# Abrir una shell como root (peligroso, mejor comandos individuales)
sudo -s

# Shell de login como root (entorno completo)
sudo -i

# Validar/extender contraseña
sudo -v

# Invalidar caché (forzar contraseña en el próximo sudo)
sudo -k

# Ejecutar con entorno preservado
sudo -E comando

# Editar un archivo como root (con visudo para sudoers)
sudo -e /etc/hosts
```

## Temporizador de contraseña

Por defecto, `sudo` recuerda la contraseña por **5 minutos** (timestamp_timeout). Durante ese tiempo, los siguientes `sudo` no pedirán contraseña.

```bash
# Configurar en /etc/sudoers (o /etc/sudoers.d/00-timeout)
Defaults timestamp_timeout=10   # 10 minutos
Defaults timestamp_timeout=0    # pedir siempre (máxima seguridad)
```

## sudo vs doas

**doas** (port OpenBSD) es una alternativa moderna y minimalista a sudo, popular en sistemas de escritorio.

| Característica | sudo | doas |
|---|---|---|
| Configuración | `/etc/sudoers` (visudo) | `/etc/doas.conf` |
| Sintaxis | Verbosa y compleja | Minimalista |
| Tamaño | ~500 KB | ~15 KB |
| Funcionalidad | Muchas opciones | Lo esencial |
| Popular en | Todas las distros | Gentoo, Void Linux, Alpine |
| Tags/reglas | Muy flexibles | Básicas |

```bash
# Instalar doas
sudo apt install doas              # Debian/Ubuntu
sudo pacman -S opendoas            # Arch

# Configuración /etc/doas.conf
permit persist :wheel              # grupo wheel, mantener sesión
permit nopass carlos               # carlos sin contraseña

# Usar doas
doas comando
doas -u usuario comando
```

## Notas y advertencias

- **Nunca edites `/etc/sudoers` a mano** — si cometes un error de sintaxis, perderás acceso sudo. Siempre usa `visudo`.
- Si bloqueas sudo (config incorrecta), necesitas reiniciar en **single-user mode** o desde un Live USB para reparar.
- `NOPASSWD:` es cómodo pero reduce seguridad — úsalo solo en equipos personales.
- `sudo !!` repite el último comando con sudo (atajo de bash/zsh).
- Revisa regularmente `/var/log/auth.log` o `journalctl -u sudo` para auditoría.
- Usa `sudo -l` para saber exactamente qué comandos tienes permitidos.

## Enlaces externos

- [Wikipedia — sudo](https://en.wikipedia.org/wiki/Sudo)
- [Sudo official site](https://www.sudo.ws/)
- [Arch Wiki — sudo](https://wiki.archlinux.org/title/Sudo)

## Ver también

- [[Permisos y Propietarios]] — base de permisos en Linux
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — PAM authentication
- [[Procesos y Senales]] — gestión de procesos
- [[Gestores de Paquetes]] — instalar paquetes con sudo

#comando
