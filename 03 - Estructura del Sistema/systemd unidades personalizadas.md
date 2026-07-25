---
fecha_creacion: 2026-07-24
estado: resuelto
categoria: sistema
prioridad: media
---

# systemd — Unidades personalizadas

> Cómo crear servicios, timers, sockets, paths y templates en systemd más allá de lo básico.

**Prerrequisito**: Esta nota asume que conoces la gestión básica de servicios con `systemctl`. Ver [[systemd]] primero.

---

## Tipos de unidades

systemd maneja **12 tipos de unidades**, cada una con extensión propia. Las más usadas para personalización:

| Extensión | Propósito | ¿Requiere otra unidad? |
|---|---|---|
| `.service` | Ejecutar un proceso (el más común) | No |
| `.timer` | Programar ejecución de un `.service` | Sí (mismo nombre) |
| `.socket` | Escuchar en un puerto/socket y activar un `.service` | Sí |
| `.path` | Monitorear archivos y activar un `.service` | Sí |
| `.target` | Agrupar unidades (ej: `multi-user.target`) | — |
| `.mount` | Punto de montaje (alternativa a `/etc/fstab`) | No |
| `.slice` | Agrupar procesos para control de recursos (cgroups) | No |

> Todas las unidades se ubican en `/etc/systemd/system/` (admin) o `/usr/lib/systemd/system/` (paquetes).

---

## Service types en detalle

El `Type=` de un `.service` determina **cómo** systemd detecta que el servicio está listo:

| Type | Cuándo usarlo | Comportamiento |
|---|---|---|
| `simple` | Procesos que quedan en foreground sin avisar | systemd asume listo al instante tras fork |
| `exec` | Similar a simple, pero espera a que `ExecStart` termine el `execve()` | Más seguro que `simple` (detecta errores de arranque) |
| `forking` | Daemons clásicos que hacen fork y el padre muere | systemd espera que el padre termine y asume listo |
| `oneshot` | Tareas que ejecutan y terminan (no quedan en memoria) | systemd espera a que termine la ejecución |
| `notify` | Procesos que avisan con `sd_notify(0, "READY=1")` | systemd espera la notificación explícita |
| `dbus` | Procesos que se registran en D-Bus | systemd espera que el nombre D-Bus esté disponible |

```ini
# Type=simple (default) — proceso en foreground
[Service]
Type=simple
ExecStart=/usr/local/bin/mi-app
Restart=on-failure

# Type=forking — daemon clásico (ej: sshd, httpd legacy)
[Service]
Type=forking
PIDFile=/var/run/mi-app.pid
ExecStart=/usr/local/bin/mi-app --daemon
ExecStartPost=/bin/sleep 1          # dar tiempo a crear el PID

# Type=oneshot — tarea que ejecuta y termina
[Service]
Type=oneshot
RemainAfterExit=yes                  # marca el servicio como "activo" incluso tras terminar
ExecStart=/usr/local/bin/mi-setup.sh
ExecStop=/usr/local/bin/mi-teardown.sh

# Type=notify — el proceso avisa cuando está listo
[Service]
Type=notify
ExecStart=/usr/local/bin/mi-app-moderna
WatchdogSec=30                       # si no envía notificación en 30s, reiniciar
```

```bash
# Ver el Type de un servicio activo
systemctl show nginx -p Type
```

---

## Template units — unidades parametrizables

Una **template unit** tiene un `@` en el nombre (ej: `mi-servicio@.service`) y permite crear múltiples instancias con un mismo archivo:

```ini
# /etc/systemd/system/mi-servicio@.service
[Unit]
Description=Mi servicio personalizado (%i)
Documentation=https://docs.mi-app.com

[Service]
Type=simple
ExecStart=/usr/local/bin/mi-app --instance %i
User=mi-usuario
WorkingDirectory=/var/lib/mi-app/%i

[Install]
WantedBy=multi-user.target
```

```bash
# Activar con diferentes instancias
sudo systemctl enable --now mi-servicio@produccion
sudo systemctl enable --now mi-servicio@staging
sudo systemctl enable --now mi-servicio@testing
```

### Especificadores (placeholders) para templates

| Specifier | Reemplazado por | Ejemplo |
|---|---|---|
| `%n` | Nombre completo de la unidad | `mi-servicio@prod.service` |
| `%N` | Nombre escapado | `mi-servicio@prod.service` |
| `%p` | Prefijo (antes del `@`) | `mi-servicio` |
| `%i` | **Instancia** (después del `@`) | `prod` |
| `%I` | Instancia escapada | `prod` |
| `%H` | Hostname del sistema | `servidor1` |
| `%u` | Usuario ejecutor | `root` |
| `%h` | Home del usuario | `/root` |
| `%t` | Directorio de runtime | `/run` |

```ini
# Ejemplo real: servicio por usuario
[Service]
ExecStart=/usr/local/bin/app --user %u --home %h
Environment="HOME=%h"
```

---

## Timer units — programación avanzada

Los timers tienen **dos modos** de activación: **calendar** (fecha/hora fija) y **monotonic** (relativa a un evento).

### Calendar events

```ini
# /etc/systemd/system/mi-tarea.timer
[Unit]
Description=Timer de ejemplo

[Timer]
# Formato: día-semana año-mes-día hora:minuto:segundo
OnCalendar=daily                       # atajos: hourly, daily, weekly, monthly, yearly
OnCalendar=Mon..Fri 09:00:00           # laborables a las 9 AM
OnCalendar=*-*-1,15 03:00:00           # días 1 y 15 a las 3 AM
OnCalendar=*-*-* 00/6:00:00            # cada 6 horas
OnCalendar=Sat,Sun 10:00:00            # fines de semana a las 10 AM
OnCalendar=2026-12-31 23:59:00         # fecha específica
Persistent=true                        # si el PC estaba apagado, ejecuta al encender
RandomizedDelaySec=5m                  # aleatorizar inicio ±5 minutos

[Install]
WantedBy=timers.target
```

### Monotonic events

```ini
[Timer]
OnBootSec=5min                         # 5 minutos después de arrancar
OnActiveSec=1h                         # 1 hora después de activar el timer
OnStartupSec=10min                     # 10 min después de que systemd arrancó
OnUnitActiveSec=30min                  # 30 min después de la última ejecución
OnUnitInactiveSec=1h                   # 1 hora después de que el servicio terminó
AccuracySec=1min                       # precisión (por defecto 1 minuto)
```

### Ver y depurar timers

```bash
# Listar todos los timers
systemctl list-timers --all

# Ver la próxima ejecución de un timer específico
systemctl list-timers --all | grep mi-tarea

# Calcular cuándo se disparará un OnCalendar (sin activarlo)
systemd-analyze calendar "Mon..Fri 09:00:00"

# Ver el calendario para el próximo año
systemd-analyze calendar --iterations 5 "Mon..Fri 09:00:00"
```

---

## Path units — reaccionar a cambios en archivos

Ejecuta un servicio **cuando un archivo o directorio cambia**:

```ini
# /etc/systemd/system/mi-watcher.path
[Unit]
Description=Monitorear cambios en /etc/mi-app

[Path]
PathModified=/etc/mi-app/config.yaml   # disparar cuando cambie el archivo
# PathChanged=/etc/mi-app/             # disparar cuando cambie el directorio
# PathExists=/tmp/senal                # disparar si el archivo existe
# PathExistsGlob=/tmp/*.senal          # disparar si algún archivo coincide
Unit=mi-watcher.service

[Install]
WantedBy=multi-user.target
```

```ini
# /etc/systemd/system/mi-watcher.service
[Unit]
Description=Procesar cambios de configuración

[Service]
Type=oneshot
ExecStart=/usr/local/bin/reload-config.sh
```

```bash
sudo systemctl enable --now mi-watcher.path
```

**Diferencia entre `PathModified` y `PathChanged`:**
- `PathModified`: se dispara en **cada escritura** al archivo
- `PathChanged`: espera a que el archivo se **cierre** después de escribir (evita múltiples disparos durante una misma edición)

---

## Socket activation — servicios bajo demanda

systemd escucha el socket **antes** de que el servicio exista, y lo arranca solo cuando llega una conexión:

### Accept=false (default) — un servicio maneja todas las conexiones

```ini
# /etc/systemd/system/mi-api.socket
[Unit]
Description=Socket para mi API

[Socket]
ListenStream=8080
# ListenStream=/var/run/mi-api.sock    # también Unix socket
# ListenDatagram=53                    # UDP
Accept=false                           # systemd acepta y pasa el fd
BindIPv6Only=ipv6-only                 # solo IPv6 (o both)

[Install]
WantedBy=sockets.target
```

```ini
# /etc/systemd/system/mi-api.service
[Unit]
Description=API service (socket-activated)

[Service]
Type=simple
ExecStart=/usr/local/bin/mi-api
StandardInput=socket                   # recibe el fd del socket por stdin
```

### Accept=true — un servicio por conexión (como inetd)

```ini
[Socket]
ListenStream=8080
Accept=true                            # systemd hace fork+exec por cada conexión
MaxConnectionsPerSocket=10            # límite por socket
```

```bash
# Activar
sudo systemctl enable --now mi-api.socket

# Ver sockets activos
systemctl list-sockets

# Probar
curl http://localhost:8080/health      # el servicio arranca automáticamente
```

---

## Drop-in overrides — modificar unidades sin tocarlas

Nunca edites archivos en `/usr/lib/systemd/system/` — se sobrescriben al actualizar el paquete. Usa **overrides**:

```bash
# Crear override (abre editor automáticamente)
sudo systemctl edit nginx
# Crea: /etc/systemd/system/nginx.service.d/override.conf

# Editar el archivo completo (crea copia en /etc/systemd/system/)
sudo systemctl edit --full nginx

# Ver resultado final (original + overrides)
systemctl cat nginx

# Ver diferencias
systemctl diff nginx
```

```ini
# Ejemplo: /etc/systemd/system/nginx.service.d/override.conf
[Service]
# Hardening
ProtectSystem=strict
PrivateTmp=true
NoNewPrivileges=true

# Límites
LimitNOFILE=65535
MemoryMax=1G

# Variables de entorno adicionales
Environment="NGINX_CUSTOM_CONF=/etc/nginx/custom.conf"
```

```bash
# Aplicar cambios
sudo systemctl daemon-reload
sudo systemctl restart nginx
```

---

## Instancias de servicio con template + socket

Combinando template units con socket activation:

```ini
# /etc/systemd/system/mi-app@.service
[Unit]
Description=Mi App instance %i

[Service]
Type=simple
ExecStart=/usr/local/bin/mi-app --port %i
StandardInput=socket
User=nobody
Group=nogroup
```

```ini
# /etc/systemd/system/mi-app@8080.socket  (instancia específica)
[Socket]
ListenStream=8080

[Install]
WantedBy=sockets.target
```

```ini
# /etc/systemd/system/mi-app@8081.socket
[Socket]
ListenStream=8081

[Install]
WantedBy=sockets.target
```

```bash
sudo systemctl enable --now mi-app@8080.socket
sudo systemctl enable --now mi-app@8081.socket
```

---

## Verificación de unidades

```bash
# Validar sintaxis de un unit file sin cargarlo
systemd-analyze verify /ruta/a/mi-unidad.service

# Validar todos los units del sistema
systemd-analyze verify /etc/systemd/system/*

# Ver dependencias de una unidad
systemctl list-dependencies mi-servicio
systemctl list-dependencies --reverse mi-servicio

# Ver propiedades completas de una unidad
systemctl show mi-servicio

# Depurar arranque de una unidad
journalctl -u mi-servicio -f
```

---

## Orden de carga de unidades

systemd busca unidades en este orden (el primero encontrado tiene prioridad):

| Prioridad | Ruta | Propósito |
|---|---|---|
| 1 (máxima) | `/etc/systemd/system/` | Admin overrides y units personalizados |
| 2 | `/run/systemd/system/` | Units generados en runtime |
| 3 (mínima) | `/usr/lib/systemd/system/` | Units provistos por paquetes |

Los drop-in overrides en `/etc/systemd/system/<unidad>.d/*.conf` se aplican sobre el unit base, sin importar de dónde venga.

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `systemctl daemon-reload` no detecta cambios | Archivo con errores de sintaxis | `systemd-analyze verify /etc/systemd/system/mi.service` |
| Timer no se ejecuta | El timer no está activo | `sudo systemctl enable --now mi-timer.timer` |
| Socket activation no funciona | `.socket` y `.service` no tienen el mismo nombre base | Asegurar que `mi-app.socket` → `mi-app.service` |
| Template unit: `%i` vacío | Se activó el servicio sin instancia | Usar `systemctl start mi-app@instancia.service` |
| `ExecStart` falla con exit code 203/127 | Ejecutable no encontrado | Verificar ruta absoluta en `ExecStart` |
| `RemainAfterExit=yes` no funciona | `Type=oneshot` no está seteado | `RemainAfterExit` solo aplica con `Type=oneshot` |
| Override no tiene efecto | Mala sección en el .conf | Verificar que la sección `[Service]` coincide exactamente |

## Comandos asociados

| Comando | Para qué |
|---|---|
| `systemctl edit <unidad>` | Crear drop-in override |
| `systemctl cat <unidad>` | Ver unit final (original + overrides) |
| `systemd-analyze verify <archivo>` | Validar sintaxis de unit |
| `systemd-analyze calendar <expr>` | Calcular próxima ejecución de timer |
| `systemctl list-timers --all` | Listar todos los timers |
| `systemctl list-sockets` | Listar sockets activos |
| `systemctl show <unidad> -p Type` | Ver propiedad específica |

## Ver también

- [[systemd]] — gestión básica de servicios systemd
- [[Cron y Systemd Timers]] — comparativa cron vs timers
- [[Daemon]] — concepto de daemon y daemonización
- [[cgroups (control de recursos)]] — límites de CPU/memoria con systemd

## Enlaces externos

- [systemd.service(5) — man page](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [systemd.timer(5) — man page](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)
- [systemd.socket(5) — man page](https://www.freedesktop.org/software/systemd/man/systemd.socket.html)
- [systemd.path(5) — man page](https://www.freedesktop.org/software/systemd/man/systemd.path.html)
- [systemd.unit(5) — man page](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)
- [Arch Wiki — systemd](https://wiki.archlinux.org/title/Systemd)
- [systemd.io — documentación oficial](https://systemd.io/)

#sistema
