---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: comando
prioridad: alta
---

# systemctl

## Sintaxis
```
systemctl <verbo> [unidad|objetivo] [opciones]
```

## Descripción
Herramienta de control de **systemd** — el sistema de init de la gran mayoría de distros modernas (Arch, CachyOS, Fedora, Ubuntu, Debian, openSUSE...). Permite arrancar/detener/reiniciar servicios, consultar su estado, habilitarlos para que arranquen con el sistema, gestionar *targets* y analizar el arranque. Es la puerta de entrada a la gestión de servicios en cualquier sistema systemd, y su manejo es indispensable en el día a día.

La mayoría de comandos con efecto requieren `sudo` (salvo los de solo consulta y los de ámbito de usuario con `--user`).

## Conceptos clave (Units y Targets)

| Término | Qué es | Ejemplo |
|---|---|---|
| **Unit** | Unidad que systemd gestiona (servicio, timer, socket, target, mount, slice...) | `nginx.service` |
| **Servicio** | Unidad que lanza/controla un proceso | `sshd.service` |
| **Timer** | Unidad que ejecuta algo en un horario (como cron) | `fstrim.timer` |
| **Target** | Agrupación de unidades que se activan juntas (nivel de "runlevel") | `multi-user.target` |
| **Suffix** | Extensión del tipo de unit | `.service`, `.timer`, `.target`, `.mount` |
| **Activo (active)** | Está en ejecución (running) o funcionando | `active (running)` |
| **Enabled** | Está habilitado para arrancar con el sistema | estado `enabled` |
| **Masked** | Bloqueado por completo (no se puede iniciar ni manualmente) | `masked` |

> 📌 Si omites el sufijo (`.service`), systemd lo asume para los tipos más comunes. `systemctl stop nginx` == `systemctl stop nginx.service`.

## Estado de una unidad

```
systemctl status nginx        # estado + últimas líneas de log (usa journalctl por debajo)
systemctl is-active sshd      # active / inactive / failed
systemctl is-enabled sshd     # enabled / disabled / static / masked
systemctl is-failed nginx     # failed (si salió con error) / active
```

| Estado | Significado |
|---|---|
| `loaded` | La definición de la unit se cargó correctamente |
| `active (running)` | Proceso en ejecución |
| `active (exited)` | Terminó correctamente (servicios tipo `oneshot`/`simple` sin daemon) |
| `active (waiting)` | Esperando evento (`-W` socket, etc.) |
| `inactive (dead)` | No en ejecución |
| `failed` | Terminó con error (¡revisa `journalctl -u`!) |
| `enabled` | Se inicia automáticamente al arrancar |
| `disabled` | No se inicia automáticamente (solo manual) |
| `masked` | Bloqueado (no se puede iniciar ni siquiera a mano) |

## Opciones frecuentes

| Verbo/Flag | Efecto |
|---|---|
| `start <u>` | Arrancar la unidad ahora |
| `stop <u>` | Detener la unidad |
| `restart <u>` | Reiniciar la unidad |
| `reload <u>` | Recargar configuración sin interrumpir (solo si el servicio lo soporta) |
| `reload-or-restart <u>` | Recargar si puede, reiniciar si no |
| `enable <u>` | Habilitar para arrancar con el sistema |
| `disable <u>` | Deshabilitar el arranque automático |
| `enable --now <u>` | Habilitar y arrancar de una vez |
| `disable --now <u>` | Deshabilitar y detener |
| `mask <u>` | Bloquear por completo |
| `unmask <u>` | Desbloquear |
| `status <u>` | Estado detallado + logs |
| `is-active / is-enabled / is-failed` | Consulta rápida (para scripts) |
| `list-units` | Unidades cargadas/activas (alias: `systemctl`) |
| `list-unit-files` | Todas las units instaladas y su estado enable/disable |
| `list-timers` | Timers programados y su próxima ejecución |
| `list-sockets` | Sockets listeners de systemd |
| `list-dependencies <t>` | Árbol de dependencias de un target/unit |
| `get-default` | Target de arranque actual (`default.target`) |
| `set-default <target>` | Cambiar el target por defecto (p. ej. `graphical.target`) |
| `isolate <target>` | Activar solo ese target (cambiar de modo al vuelo) |
| `daemon-reload` | Recargar definiciones de units tras editar archivos `.service` |
| `show <u>` | Propiedades completas de la unit en formato `key=value` |
| `cat <u>` | Mostrar el archivo de la unit tal como lo ve systemd |

## Ejemplos de uso

```bash
# Gestión básica de servicios (el pan de cada día)
sudo systemctl start sshd
sudo systemctl enable --now bluetooth        # habilitar + arrancar juntos
sudo systemctl status docker                 # ver si está corriendo y por qué
sudo systemctl restart nginx
sudo systemctl reload sshd                   # recargar config sin cortar
sudo systemctl disable --now cups            # quitar y apagar

# Consultas de estado
systemctl list-units --type=service --state=running   # servicios activos
systemctl list-units --state=failed                   # unidades que fallaron
systemctl list-unit-files | grep enabled              # qué arranca con el sistema
systemctl list-timers                                 # timers programados
systemctl is-active sshd && echo "SSH corriendo"      # para scripts

# Tras editar un archivo de unit manualmente
sudo systemctl daemon-reload && sudo systemctl restart mi-servicio

# Cambiar el target de arranque (modos)
sudo systemctl get-default        # usually graphical.target
sudo systemctl isolate multi-user.target   # modo texto (sin GUI) al vuelo
sudo systemctl set-default multi-user.target   # arrancar siempre en texto
```

## Diagnóstico de arranque

```bash
# Qué tarda más en el arranque
systemd-analyze blame
systemd-analyze critical-chain     # cadena crítica de dependencias

# Analizar el árbol de arranque (gráfico SVG)
systemd-analyze plot > boot.svg

# Listar qué falló / qué está activo ahora
systemctl list-units --state=failed
systemctl --failed
```

## Ámbito de usuario (`--user`)

systemd también gestiona procesos de usuario (services de usuario sin root). Igual que a nivel sistema pero sin `sudo`:

```bash
systemctl --user list-units
systemctl --user enable --now mi-daemon
systemctl --user status mi-servicio
```

Requiere que `user@<uid>.service` esté corriendo (por defecto en distros con systemd activando user services). Los units de usuario viven en `~/.config/systemd/user/`.

## Ver también las units desde archivo

```bash
systemctl cat mi-servicio                 # mostrar definición efectiva (con drop-ins aplicados)
systemctl show mi-servicio -p ExecStart   # propiedad concreta
systemctl status mi-servicio -l           # -l elimina truncado de líneas
systemd-analyze verify /etc/systemd/system/mi-servicio.service   # validar un archivo de unit
```

## Troubleshooting / Errores comunes

| Error/Síntoma | Causa | Solución |
|---|---|---|
| `Failed to start ... Unit not found` | Unit no existe o nombre erróneo | Revisar ortografía y sufijo; `systemctl list-unit-files` |
| `Operation refused` | Falta `sudo` (o unit de usuario sin `--user`) | Anteponer `sudo` o añadir `--user` |
| `Failed to enable: Unit file ... does not exist` | Archivo de unit no instalado en `/etc/systemd/system` o `/usr/lib/systemd/system` | Verificar ruta; crearlo desde plantilla |
| `Unit ... has failed` | El servicio salió con error | `systemctl status` + `journalctl -u <servicio> -e` para ver el fallo |
| `Job for nginx.service failed because the control process exited with error code` | Problema al arrancar (config inválida, puerto ocupado) | Leer `journalctl -u nginx -xe`; corregir config; `systemctl restart` |
| `Warning: The unit file, source configuration file or drop-ins ... changed on disk` | Se editó el `.service` sin `daemon-reload` | `sudo systemctl daemon-reload` |
| `Unit is masked` | El servicio está bloqueado | `sudo systemctl unmask <servicio>` |
| `systemctl` no existe | La distro no usa systemd (usa OpenRC, runit, s6...) | Usar el gestor propio (`rc-service`, `sv`, `runit`...) |

## Notas y advertencias

- **`disable` no detiene** el servicio en marcha; usa `--now` o `stop` explícito.
- **`daemon-reload` imprescindible** después de editar cualquier archivo de unit o drop-in, o systemd seguirá usando la versión en caché.
- `enable` crea symlinks en `/etc/systemd/system/<target>.wants/`; se pueden ver con `ls`.
- Los drop-ins (`systemctl edit <servicio>`) anulan entradas del archivo original sin tocarlo.
- `reload` NO es lo mismo que `restart`: depende de que el service implemente `ExecReload`.

## Enlaces externos
- [Wikipedia — systemd](https://en.wikipedia.org/wiki/Systemd)
- [Freedesktop — systemctl man page](https://www.freedesktop.org/software/systemd/man/systemctl.html)
- [Arch Wiki — systemd](https://wiki.archlinux.org/title/Systemd)
- [DigitalOcean — systemctl cheatsheet](https://www.digitalocean.com/community/cheatsheets/how-to-use-systemctl-to-manage-systemd-services-and-units)

## Ver también
- [[systemd]] — concepto: units, targets, timeline de arranque
- [[systemd unidades personalizadas]] — crear tus propios servicios/timers/drop-ins
- [[systemd timers]] — alternativas a cron
- [[journalctl]] — leer los logs de los servicios
- [[ps]] · [[kill]] · [[top]] — gestión de procesos alternativa/paralela

#comando
