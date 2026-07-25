---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: sistema
prioridad: alta
---

# systemd

## Definición

Sistema de **init** (el primer proceso que arranca, PID 1) y suite de gestión de servicios usado por la mayoría de distros modernas (Ubuntu, Fedora, Arch, Debian). Reemplazó a los antiguos scripts SysV init.

## Componentes principales

| Comando | Uso |
|---|---|
| `systemctl` | Gestionar servicios (start/stop/enable/status) y unidades |
| `journalctl` | Ver logs del sistema (systemd-journald) |
| `systemd-analyze` | Medir tiempos de arranque y dependencias |
| `timedatectl` | Configurar fecha/hora y zona horaria |
| `hostnamectl` | Ver/configurar nombre del equipo |
| `loginctl` | Gestionar sesiones de usuario |
| `machinectl` | Gestionar contenedores (systemd-nspawn) |
| `bootctl` | Gestionar el bootloader (systemd-boot) |
| `resolvectl` | Gestionar resolución DNS (systemd-resolved) |

## Gestión de servicios con systemctl

```bash
# Estado
systemctl status nginx                 # estado + últimas líneas del log
systemctl is-active nginx              # solo active/inactive
systemctl is-enabled nginx             # solo enabled/disabled
systemctl list-units --type=service    # todos los servicios y su estado
systemctl list-units --failed          # solo los que fallaron

# Ciclo de vida
sudo systemctl start nginx             # iniciar ahora
sudo systemctl stop nginx              # detener ahora
sudo systemctl restart nginx           # reiniciar
sudo systemctl reload nginx            # recargar config sin reiniciar (si el servicio lo soporta)
sudo systemctl enable nginx            # que arranque automáticamente al boot
sudo systemctl disable nginx           # que NO arranque automáticamente
sudo systemctl enable --now nginx      # enable + start en un solo comando
sudo systemctl mask nginx              # bloquear completamente (imposible iniciar)
sudo systemctl unmask nginx            # desbloquear

# Recargar la configuración de systemd después de crear/editar unidades
sudo systemctl daemon-reload
```

## Anatomía de un servicio (unit file)

Los servicios se definen en archivos `.service` ubicados en:
- `/usr/lib/systemd/system/` — provistos por paquetes instalados (no editar)
- `/etc/systemd/system/` — creados por el admin o overrides (tienen prioridad)
- `~/.config/systemd/user/` — servicios de usuario (sin necesidad de sudo)

```ini
# Ejemplo: /etc/systemd/system/mi-servicio.service
[Unit]
Description=Mi servicio personal
Documentation=https://ejemplo.com/docs
After=network.target                    # arrancar después de que la red esté lista
Wants=postgresql.service               # si postgres está, que arranque antes; si no, sigue igual

[Service]
Type=simple                            # simple (default), forking, oneshot, notify, dbus
ExecStart=/usr/local/bin/mi-app        # comando para iniciar
ExecReload=/bin/kill -HUP $MAINPID     # comando para recargar
Restart=on-failure                     # reiniciar si falla: no, always, on-success, on-abnormal
RestartSec=5                           # esperar 5s antes de reintentar
User=mi-usuario                        # ejecutar como este usuario (no root)
WorkingDirectory=/opt/mi-app
Environment="NODE_ENV=production"      # variables de entorno
StandardOutput=journal                  # stdout al log de systemd
StandardError=journal                   # stderr al log de systemd

[Install]
WantedBy=multi-user.target             # en qué target se activa (multi-user = arranque normal)
```

```bash
# Ver el unit file de un servicio
systemctl cat nginx

# Editar opciones sin modificar el archivo original (drop-in)
sudo systemctl edit nginx              # crea override en /etc/systemd/system/nginx.service.d/
sudo systemctl edit --full nginx       # editar el archivo completo

# Ver diferencias entre el original y los overrides
systemctl diff nginx
```

### Types de servicio

| Type | Cuándo usarlo |
|---|---|
| `simple` | El proceso principal queda en foreground (default) |
| `forking` | El proceso hace fork y el padre se va (típico de daemons clásicos) |
| `oneshot` | Ejecuta una vez y termina. Usar con `RemainAfterExit=yes` si queremos tracking |
| `notify` | El proceso avisa a systemd cuando está listo vía sd_notify() |
| `dbus` | El proceso se registra en D-Bus y systemd espera ese registro |

## Drop-in configuration (overrides)

En lugar de editar los archivos de unidad originales (que se sobrescriben al actualizar el paquete), systemd permite añadir **overrides** parciales:

```bash
# Crear/modificar override para un servicio (abre editor)
sudo systemctl edit nginx
# Crea: /etc/systemd/system/nginx.service.d/override.conf

# Editar el archivo completo (no recomendado si el paquete se actualiza)
sudo systemctl edit --full nginx

# Ver el resultado final (original + overrides combinados)
systemctl cat nginx

# Ver diferencias entre original y overrides
systemctl diff nginx
```

Ejemplo de override:
```ini
# /etc/systemd/system/nginx.service.d/override.conf
[Service]
# Aumentar límite de archivos abiertos para nginx
LimitNOFILE=65535

# Añadir variable de entorno
Environment="MY_CUSTOM_VAR=valor"
```

---

## Socket activation — Servicios bajo demanda

systemd puede escuchar en un socket **antes** de que el servicio exista, y arrancar el servicio solo cuando llegue una conexión:

```ini
# /etc/systemd/system/mi-app.socket
[Unit]
Description=Socket para mi app

[Socket]
ListenStream=8080                    # escuchar en TCP puerto 8080
# ListenStream=/var/run/mi-app.sock  # también puede ser Unix socket
Accept=false                         # false = systemd acepta la conexión y pasa el fd

[Install]
WantedBy=sockets.target
```

```ini
# /etc/systemd/system/mi-app.service
[Unit]
Description=Mi app (bajo demanda)

[Service]
Type=simple
ExecStart=/usr/local/bin/mi-app
StandardInput=socket                 # el servicio lee del socket via stdin
```

```bash
sudo systemctl enable --now mi-app.socket   # activar socket (servicio arranca bajo demanda)
systemctl list-sockets                       # ver todos los sockets activos
```

Útil para servicios con baja frecuencia de uso (ej: servidor de impresión CUPS, contenedores por SSH).

---

## Path units — Disparar acciones al cambiar archivos

Ejecuta un servicio cuando un archivo o directorio cambia:

```ini
# /etc/systemd/system/mi-watcher.path
[Unit]
Description=Monitorear cambios en /etc/config

[Path]
PathModified=/etc/config              # disparar cuando /etc/config cambie
# PathExists=/ruta                    # disparar si la ruta existe
# PathChanged=/ruta                   # disparar cuando cambie (espera a que termine escritura)
Unit=mi-watcher.service               # qué servicio ejecutar

[Install]
WantedBy=multi-user.target
```

```ini
# /etc/systemd/system/mi-watcher.service
[Unit]
Description=Procesar cambios de configuración

[Service]
Type=oneshot
ExecStart=/usr/local/bin/procesar-cambios.sh
```

```bash
sudo systemctl enable --now mi-watcher.path
```

---

## Control de recursos con systemd

systemd puede limitar CPU, memoria y E/S por servicio usando cgroups v2:

```ini
# /etc/systemd/system/mi-servicio.service.d/override.conf
[Service]
# ── CPU ──
CPUWeight=200                            # peso relativo (100 = default)
CPUQuota=50%                             # máximo 50% de un núcleo

# ── Memoria ──
MemoryMax=512M                           # límite absoluto (OOM si se excede)
MemoryHigh=384M                          # límite blando (se relentiza antes de OOM)
MemorySwapMax=128M                       # máximo de swap

# ── E/S de disco ──
IOWeight=200
IOReadBandwidthMax=/dev/sda 50M
IOWriteBandwidthMax=/dev/sda 20M

# ── Procesos ──
TasksMax=100                             # máximo de procesos/tareas

# ── CPUs específicas ──
AllowedCPUs=0-3                          # solo núcleos 0 a 3
```

> Ver [[cgroups (control de recursos)]] para más detalles sobre cgroups v2.

---

## Timers (alternativa moderna a cron)

```ini
# /etc/systemd/system/mi-backup.timer
[Unit]
Description=Ejecutar backup semanal

[Timer]
OnCalendar=weekly                     # también: daily, hourly, "Mon..Fri 02:00", "*-*-1..7 03:00"
Persistent=true                       # si el equipo estaba apagado, ejecuta al encender
RandomizedDelaySec=60                 # evitar que todos los timers se disparen a la vez
OnActiveSec=5min                      # ejecutar 5 minutos después de activar el timer
OnBootSec=10min                       # ejecutar 10 minutos después de arrancar
OnUnitActiveSec=1h                    # ejecutar 1 hora después de la última ejecución

[Install]
WantedBy=timers.target
```

```bash
# Activar el timer (no el servicio directamente)
sudo systemctl enable --now mi-backup.timer

# Ver timers activos
systemctl list-timers --all

# Probar ejecución sin esperar la fecha
sudo systemctl start mi-backup.service   # el timer ejecutará el servicio del mismo nombre
```

Ver [[Cron y Systemd Timers]] para comparativa detallada.

---

## Troubleshooting de servicios systemd

```bash
# ── Servicio no arranca ──
systemctl status nginx                     # ¿qué dice exactamente?
systemctl status nginx --no-pager          # sin paginador
journalctl -u nginx -p err --since "1 hour ago"  # errores recientes

# ── Dependencias — ¿qué necesita mi servicio? ──
systemctl list-dependencies nginx          # qué necesita nginx para arrancar
systemctl list-dependencies --reverse nginx  # qué depende de nginx

# ── Servicio muere sin mensaje claro ──
# Probar ejecución manual (fuera de systemd):
sudo -u usuario /usr/local/bin/mi-app      # ¿funciona en terminal?

# ── Error "Unit not found" ──
systemctl daemon-reload                    # recargar units
systemctl list-unit-files | grep nginx      # ¿existe el unit file?

# ── Servicio muestra "deactivating" permanentemente ──
# El proceso no termina limpiamente. Forzar:
sudo systemctl kill --signal=SIGKILL nginx

# ── Timers que no se ejecutan ──
systemctl list-timers --all                 # ¿el timer está activo?
systemctl status mi-backup.timer            # ¿el timer tiene errores?
journalctl -u mi-backup.timer               # ¿disparó pero el servicio falló?

# ── Error de timeout al iniciar/detener ──
# Aumentar timeout en override:
# [Service]
# TimeoutStartSec=300
# TimeoutStopSec=60

# ── Debug de arranque (servicios lentos) ──
systemd-analyze blame                       # ¿qué servicio tarda más?
systemd-analyze critical-chain              # cadena crítica de dependencias

# ── Resetear un servicio fallido ──
sudo systemctl reset-failed nginx           # limpiar estado "failed"
```

### Errores comunes y soluciones

| Error | Causa | Solución |
|---|---|---|
| `code=exited status=1/127` | El binario no existe o falló | Verificar ruta en `ExecStart`, hacer `which` del binario |
| `code=killed status=KILL` | OOM killer (se excedió MemoryMax) | Revisar `dmesg`, aumentar MemoryMax o memoria física |
| `code=killed status=HUP` | Recibió SIGHUP (terminal cerró) | Añadir `Type=forking` o `KillMode=process` |
| `FAILED: Unit nginx.service is masked` | El servicio está bloqueado | `sudo systemctl unmask nginx` |
| `Timed out waiting for device` | Un disco no apareció a tiempo | Revisar `systemd-analyze blame`, añadir `x-systemd.device-timeout=120` en fstab |
| `GUNIT: Unit entered failed state` | Error genérico del servicio | Revisar logs del servicio (no de systemctl) para la causa real |

---

## Targets (niveles de ejecución modernos)

Los targets reemplazan a los antiguos runlevels de SysV:

```bash
# Ver target actual
systemctl get-default

# Cambiar target (ej: arrancar sin interfaz gráfica)
sudo systemctl set-default multi-user.target   # arrancar en modo texto (similar a runlevel 3)
sudo systemctl set-default graphical.target    # arrancar con GUI (default en la mayoría)

# Cambiar en caliente (sin reiniciar)
sudo systemctl isolate multi-user.target       # apagar la GUI ahora
```

| Target | Equivale a | Uso |
|---|---|---|
| `poweroff.target` | Runlevel 0 | Apagar |
| `rescue.target` | Runlevel 1 | Modo recovery (single user) |
| `multi-user.target` | Runlevel 3 | Texto, sin GUI |
| `graphical.target` | Runlevel 5 | Arranque normal con GUI |
| `reboot.target` | Runlevel 6 | Reiniciar |

## journalctl en profundidad

```bash
# Niveles de gravedad
journalctl -p err                      # solo errores (prioridad 0-3)
journalctl -p warning                  # warnings y superior (0-4)
journalctl -p info                     # todo (0-6)

# Por tiempo
journalctl --since "1 hour ago"
journalctl --since yesterday
journalctl --since "2026-07-01" --until "2026-07-15"

# Por unidad
journalctl -u nginx                    # solo logs de nginx
journalctl -u nginx -u postgresql      # combinar varios servicios
journalctl _PID=1234                   # logs de un PID específico
journalctl _UID=1000                   # logs de un usuario específico

# Salida
journalctl -o verbose                  # todos los metadatos disponibles
journalctl -o json                     # formato JSON (pipeable)
journalctl -n 30                       # últimas 30 líneas
journalctl -f                          # seguir en tiempo real (como tail -f)
journalctl --no-pager                  # sin paginador (para grep/pipe)

# Mantenimiento
journalctl --disk-usage                # cuánto ocupan los logs
sudo journalctl --vacuum-size=500M     # reducir logs a 500MB
sudo journalctl --vacuum-time=2weeks   # borrar logs de más de 2 semanas

# Persistencia (por defecto los logs están en /run/log/journal, volátiles)
# Para hacerlos persistentes:
sudo mkdir -p /var/log/journal
```

## systemd-analyze

```bash
# Tiempo total de arranque
systemd-analyze
systemd-analyze time

# Qué servicios tardan más
systemd-analyze blame                  # ordenados por tiempo
systemd-analyze critical-chain         # cadena crítica (qué bloquea el arranque)

# Dependencias
graphical.target systemd-analyze dot | dot -Tsvg > boot.svg   # gráfico de dependencias (requiere graphviz)

# Comparativa de configuraciones
systemd-analyze compare antes.conf    # útil para ver efecto de cambios
```

## Gestión de logs y recursos

```bash
# Ver consumo de memoria de journald
systemctl status systemd-journald

# Límite de tamaño de logs
# /etc/systemd/journald.conf:
# SystemMaxUse=500M
# SystemMaxFileSize=100M
# MaxRetentionSec=2weeks

# Rotación manual
sudo journalctl --rotate               # cerrar archivo de log actual y abrir nuevo
sudo journalctl --vacuum-size=200M     # reducir inmediatamente
```

## systemd-resolved (DNS moderno)

```bash
# Ver estado
resolvectl status
resolvectl query google.com            # resolver un dominio
resolvectl statistics                  # estadísticas de resolución

# Configuración en /etc/systemd/resolved.conf
# FallbackDNS=1.1.1.1 8.8.8.8
# DNSOverTLS=yes                       # DNS cifrado
```

## Por qué importa

Casi cualquier interacción con el sistema moderna pasa por systemd: iniciar/detener servicios, ver logs, programar tareas, gestionar red y DNS, analizar arranque. Entender unidades, targets y journalctl convierte el troubleshooting de "probar cosas al azar" a "seguir la cadena de dependencias".

## Ver también

- [[journalctl]] — comando detallado
- [[Cron y Systemd Timers]] — timers como reemplazo de cron
- [[Solucion de Problemas - Recursos]] — diagnóstico general
- [[Proc y Sys]] — /proc/sys para parámetros del kernel
- [[Procesos y Senales]] — gestión de procesos

## Enlaces externos

- [Wikipedia — systemd](https://en.wikipedia.org/wiki/Systemd)
- [Sitio oficial — freedesktop.org](https://www.freedesktop.org/wiki/Software/systemd/)
- [GitHub — systemd/systemd](https://github.com/systemd/systemd)
- [Arch Wiki — systemd](https://wiki.archlinux.org/title/Systemd)
- [Documentación — systemd.io](https://systemd.io/)

#sistema
