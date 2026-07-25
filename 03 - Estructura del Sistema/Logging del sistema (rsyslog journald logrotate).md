---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: sistema
prioridad: alta
---

# Logging del sistema (rsyslog, journald, logrotate)

## Definición

El logging en Linux es el sistema que registra eventos del kernel, servicios y aplicaciones en archivos de texto o bases de datos binarias. Tradicionalmente gestionado por **syslog** (y su variante moderna **rsyslog**), hoy coexiste con **journald** (systemd). **logrotate** se encarga de rotar, comprimir y eliminar logs viejos para que no llenen el disco.

```
Arquitectura del logging en Linux:

  Aplicaciones / Servicios
     │            │
     │ stdout     │ syslog() / logger
     ▼            ▼
  ┌────────┐  ┌──────────┐
  │journald│  │  rsyslog │  ← pueden coexistir
  │(binario)│  │ (texto)  │
  └───┬────┘  └────┬─────┘
      │            │
      ▼            ▼
  /var/log/journal/  /var/log/syslog
                     /var/log/auth.log
                     /var/log/kern.log
                         │
                         ▼
                    ┌──────────┐
                    │logrotate │  ← comprime, rota, elimina
                    └──────────┘
```

---

## journald — Log binario de systemd

journald (systemd-journald) recolecta logs del kernel, de servicios gestionados por systemd, y de aplicaciones que escriben a stdout/stderr. Almacena en formato **binario** con metadatos estructurados (PID, UID, prioridad, timestamp, código de fuente).

### Dónde están los logs

| Ubicación | Persistencia | Cuándo existe |
|---|---|---|
| `/run/log/journal/` | Volátil (se borra al reiniciar) | **Siempre** |
| `/var/log/journal/` | Persistente | Solo si se crea el directorio |

```bash
# Hacer logs persistentes (recomendado)
sudo mkdir -p /var/log/journal
sudo journalctl --flush                    # migrar logs de /run a /var/log sin reiniciar
sudo systemctl restart systemd-journald    # reiniciar para que coja la nueva config

# Ver cuánto ocupan
journalctl --disk-usage
```

### Consultas avanzadas (más allá de lo básico)

```bash
# ── Filtrar por prioridad ──
journalctl -p 0                          # emerg: sistema inutilizable
journalctl -p 1                          # alert: acción inmediata requerida
journalctl -p 2                          # crit: condiciones críticas
journalctl -p 3                          # err: errores
journalctl -p 4                          # warning: advertencias

# ── Filtrar por kernel ──
journalctl -k                            # solo mensajes del kernel (como dmesg)
journalctl -k -p err                     # errores del kernel
journalctl -k --since "1 hour ago"       # kernel logs de la última hora

# ── Filtrar por metadata ──
journalctl _TRANSPORT=syslog             # logs que llegaron vía syslog
journalctl _TRANSPORT=stdout             # logs de stdout de servicios
journalctl _TRANSPORT=kernel             # logs del kernel
journalctl _COMM=sshd                    # logs del comando sshd
journalctl _EXE=/usr/bin/nginx           # logs del binario específico
journalctl _SYSTEMD_UNIT=nginx.service   # logs de la unidad systemd

# ── Salida con formato ──
journalctl -o short-monotonic            # formato por defecto, con timestamp monotónico
journalctl -o verbose                    # todos los metadatos disponibles
journalctl -o json                       # JSON (para parsear con jq)
journalctl -o json-pretty                # JSON formateado
journalctl -o cat                        # solo el mensaje, sin metadatos

# ── Combinaciones potentes ──
# Últimos errores de los últimos 30 minutos
journalctl -p err --since "30 min ago"

# Logs de SSH de hoy, en JSON
journalctl -u sshd --since today -o json | jq '. | {msg: .MESSAGE, user: ._UID}'

# Todos los servicios que fallaron al arrancar
journalctl --list-boots                  # lista de boots (reinicios)
journalctl -b -1 -p err                  # errores del boot anterior
```

### Configuración de journald

```ini
# /etc/systemd/journald.conf
[Journal]
Storage=auto                     # auto: persistente si /var/log/journal existe
                                 # persistent: siempre guardar en disco
                                 # volatile: solo en /run (se pierde al reiniciar)
                                 # none: no almacenar logs

Compress=yes                     # comprimir logs viejos (lz4)
Seal=yes                         # firmar logs (para detectar manipulación)
SplitMode=uid                    # separar logs por UID de usuario

SystemMaxUse=500M                # máximo espacio en disco para logs del sistema
SystemMaxFileSize=100M           # tamaño máximo por archivo journal
SystemMaxFiles=7                 # máximo número de archivos journal

MaxRetentionSec=2weeks           # tiempo máximo de retención

ForwardToSyslog=no               # ¿reenviar logs a rsyslog?
ForwardToWall=yes                # ¿mensajes de emergencia a todos los usuarios?
```

### Mantenimiento de journald

```bash
# Rotación manual (cierra archivo actual, abre nuevo)
sudo journalctl --rotate

# Reducir tamaño inmediatamente
sudo journalctl --vacuum-size=200M         # dejar solo 200MB
sudo journalctl --vacuum-time=7d           # dejar solo últimos 7 días
sudo journalctl --vacuum-files=5           # dejar solo 5 archivos

# Verificar integridad
sudo journalctl --verify                   # comprobar que los journals no están corruptos

# Exportar/importar logs
journalctl -o export > logs-exportados.journal   # exportar (formato transportable)
sudo journalctl --file=logs-exportados.journal    # leer exportación
```

---

## rsyslog — Log en texto plano tradicional

Antes de systemd, rsyslog era el sistema de logging estándar en Linux. Hoy sigue activo en muchas distros (especialmente Debian/Ubuntu) coexistiendo con journald. Escribe en archivos de texto plano en `/var/log/`.

### Arquitectura

```
Facility (origen)  →  Priority (gravedad)  →  Destino (archivo/remoto)

Ejemplo:
authpriv           →  info                 →  /var/log/auth.log
kern               →  warn                 →  /var/log/kern.log
*.*                →  mail                 →  /var/log/mail.log
```

### Facilities (orígenes)

| Facility | Qué genera | Código |
|---|---|---|
| `kern` | Mensajes del kernel | 0 |
| `user` | Aplicaciones de usuario | 1 |
| `mail` | Sistema de correo | 2 |
| `daemon` | Servicios del sistema | 3 |
| `auth` / `authpriv` | Autenticación e identificación | 4 / 10 |
| `syslog` | El propio sistema de logging | 5 |
| `lpr` | Sistema de impresión | 6 |
| `cron` | cron/at | 9 |
| `local0` - `local7` | Personalizable para aplicaciones | 16-23 |

### Prioridades

| Prioridad | Código | Significado |
|---|---|---|
| `emerg` | 0 | Pánico, sistema inutilizable |
| `alert` | 1 | Acción inmediata requerida |
| `crit` | 2 | Condición crítica |
| `err` | 3 | Error |
| `warning` | 4 | Advertencia |
| `notice` | 5 | Notificación (normal pero importante) |
| `info` | 6 | Informativo |
| `debug` | 7 | Depuración |

### Configuración

```bash
# Archivo principal
/etc/rsyslog.conf
/etc/rsyslog.d/*.conf                 # fragmentos adicionales (mejor práctica)
```

```bash
# /etc/rsyslog.conf (sintaxis: facility.priority  destino)

# ── Reglas por defecto ──
*.info;mail.none;authpriv.none;cron.none    /var/log/messages   # todo info excepto mail/auth/cron
authpriv.*                                   /var/log/auth.log    # logs de autenticación
mail.*                                       /var/log/mail.log    # logs de correo
cron.*                                       /var/log/cron.log    # logs de cron
kern.*                                       /var/log/kern.log    # logs del kernel

# ── Enviar a servidor remoto (centralizado) ──
*.* @logserver.local:514                     # UDP (un @)
*.* @@logserver.local:514                    # TCP (@@, más fiable)

# ── Recibir logs remotos ──
module(load="imudp")                         # cargar módulo UDP
input(type="imudp" port="514")               # escuchar en puerto 514
module(load="imtcp")                         # cargar módulo TCP
input(type="imtcp" port="514")               # escuchar en TCP 514
```

### Comandos

```bash
# Verificar sintaxis de la config
sudo rsyslogd -N 1

# Recargar configuración
sudo systemctl reload rsyslog
# o: sudo kill -HUP $(cat /var/run/syslogd.pid)

# Ver estado
sudo systemctl status rsyslog
```

---

## logrotate — Rotación y compresión de logs

Sin logrotate, los logs crecerían hasta llenar el disco. logrotate comprime, rota (renombra) y elimina archivos de log según reglas configurables.

### Configuración

```bash
# Principal
/etc/logrotate.conf

# Reglas por servicio (cada paquete instala su propia regla)
/etc/logrotate.d/nginx
/etc/logrotate.d/apache2
/etc/logrotate.d/rsyslog
```

### Sintaxis de una regla

```bash
# /etc/logrotate.d/nginx
/var/log/nginx/*.log {                # ruta de los logs (puede usar wildcards)
    daily                             # rotación: daily / weekly / monthly
    missingok                         # no fallar si no hay logs
    rotate 14                         # conservar 14 rotaciones
    compress                          # comprimir rotaciones viejas (gzip)
    delaycompress                     # comprimir la rotación anterior al día siguiente
    notifempty                        # no rotar si el archivo está vacío
    create 640 www-data adm           # crear archivo nuevo con estos permisos
    sharedscripts                     # ejecutar script una vez (no por cada archivo)
    postrotate                        # script a ejecutar después de rotar
        [ -f /var/run/nginx.pid ] && kill -USR1 `cat /var/run/nginx.pid`
    endscript
}
```

### Directivas principales

| Directiva | Significado | Ejemplo |
|---|---|---|
| `daily` / `weekly` / `monthly` | Frecuencia de rotación | `weekly` |
| `rotate N` | Conservar N archivos rotados | `rotate 7` |
| `compress` | Comprimir con gzip | `compress` |
| `delaycompress` | No comprimir la rotación más reciente | `delaycompress` |
| `missingok` | No dar error si el log no existe | `missingok` |
| `notifempty` | No rotar si el log está vacío | `notifempty` |
| `create` | Crear archivo nuevo tras rotar | `create 640 www-data adm` |
| `size 100M` | Rotar cuando llegue a 100 MB (en vez de por fecha) | `size 100M` |
| `maxage 30` | Eliminar rotaciones de más de 30 días | `maxage 30` |
| `postrotate` / `endscript` | Comandos a ejecutar tras rotar | Reiniciar servicio |
| `prerotate` / `endscript` | Comandos a ejecutar antes de rotar | Notificar a la app |
| `sharedscripts` | Ejecutar script una vez (no por cada archivo) | `sharedscripts` |
| `dateext` | Añadir fecha al nombre del archivo rotado | `dateext` |
| `su usuario grupo` | Ejecutar rotación como otro usuario | `su nginx nginx` |

### Ejemplos por servicio

```bash
# /etc/logrotate.d/rsyslog — rotación de logs del sistema
/var/log/syslog
/var/log/messages
/var/log/kern.log
/var/log/auth.log
/var/log/mail.log
/var/log/cron.log
/var/log/daemon.log
/var/log/debug
/var/log/user.log {
    rotate 4
    weekly
    missingok
    notifempty
    compress
    delaycompress
    postrotate
        /usr/lib/rsyslog/rsyslog-rotate
    endscript
}

# /etc/logrotate.d/nginx
/var/log/nginx/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 640 www-data adm
    sharedscripts
    postrotate
        [ -f /var/run/nginx.pid ] && kill -USR1 `cat /var/run/nginx.pid`
    endscript
}
```

### Probar y forzar rotación

```bash
# Simular (dry-run, no hace nada)
sudo logrotate -d /etc/logrotate.conf

# Forzar rotación
sudo logrotate -f /etc/logrotate.conf

# Forzar una regla específica
sudo logrotate -f /etc/logrotate.d/nginx

# Ver cuándo se ejecutó la última vez
cat /var/lib/logrotate.status
```

---

## Archivos de log comunes en /var/log/

| Archivo | Contenido | Distro típica |
|---|---|---|
| `/var/log/syslog` | Log general del sistema | Debian, Ubuntu |
| `/var/log/messages` | Log general del sistema | Fedora, RHEL, Arch |
| `/var/log/auth.log` | Intentos de login, sudo, SSH | Debian, Ubuntu |
| `/var/log/secure` | Intentos de login, sudo, SSH | Fedora, RHEL |
| `/var/log/kern.log` | Mensajes del kernel | Debian, Ubuntu |
| `/var/log/dmesg` | Mensajes del ring buffer del kernel (arranque) | Todas |
| `/var/log/boot.log` | Mensajes del arranque del sistema | systemd-based |
| `/var/log/faillog` | Intentos de login fallidos | Todas |
| `/var/log/lastlog` | Último login de cada usuario | Todas |
| `/var/log/btmp` | Intentos de login fallidos (formato binario) | Todas (leer con `lastb`) |
| `/var/log/wtmp` | Historial de logins (formato binario) | Todas (leer con `last`) |
| `/var/log/nginx/access.log` | Accesos a Nginx | Si nginx está instalado |
| `/var/log/nginx/error.log` | Errores de Nginx | Si nginx está instalado |
| `/var/log/apache2/access.log` | Accesos a Apache | Si apache está instalado |
| `/var/log/mysql/error.log` | Errores de MySQL/MariaDB | Si MySQL está instalado |

### Leer logs binarios con comandos específicos

```bash
# wtmp (historial de logins)
last                                   # quién se conectó y cuándo
last -F -10                            # últimos 10, con fecha completa

# btmp (intentos fallidos)
sudo lastb                             # intentos de login fallidos
sudo lastb -i 10                       # últimos 10

# lastlog (último login de cada usuario)
lastlog
lastlog -u tu_usuario                  # tu último login
```

---

## journald vs rsyslog — ¿cuál usar?

| Característica | journald | rsyslog |
|---|---|---|
| **Formato** | Binario (estructurado, con metadatos) | Texto plano (legible con cat/less/tail) |
| **Rendimiento** | Muy rápido (no escribe a disco si no es necesario) | Moderado (escribe a disco en cada entrada) |
| **Estructura** | Campos: PRIORITY, _PID, _UID, _COMM, MESSAGE, etc. | Línea de texto: fecha host programa[PID]: mensaje |
| **Rotación** | Integrada (SystemMaxUse, MaxRetentionSec) | Externa (logrotate) |
| **Filtrado** | Potente: por campo, prioridad, tiempo, unidad | Básico: grep sobre texto plano |
| **Exportación** | `journalctl -o export` → portable | Copiar archivo de texto |
| **Logs remotos** | Limitado (requiere ForwardToSyslog) | Excelente (soporte UDP/TCP nativo) |
| **Consumo de disco** | Configurable, compresión nativa | Depende de logrotate |
| **Ideal para** | Diagnóstico local, consultas rápidas | Centralización remota, SIEM, legado |

---

## Buenas prácticas

```bash
# 1. Hacer journald persistente (si usas systemd)
sudo mkdir -p /var/log/journal
sudo systemctl restart systemd-journald

# 2. Limitar espacio de journald
# Editar /etc/systemd/journald.conf:
# SystemMaxUse=500M

# 3. Verificar que logrotate está activo
sudo systemctl status logrotate.timer    # debería mostrar: active (waiting)
sudo logrotate -d /etc/logrotate.conf    # dry-run para detectar errores

# 4. Monitorear espacio real de logs
du -sh /var/log/
journalctl --disk-usage
logrotate -d /etc/logrotate.conf 2>&1 | grep -E "error|warning"

# 5. Rotación manual si un log creció demasiado
sudo journalctl --rotate
sudo logrotate -f /etc/logrotate.d/rsyslog
```

### Script de diagnóstico de logs

```bash
#!/bin/bash
# ~/scripts/diag-logs.sh — diagnóstico rápido del logging
echo "=== Espacio ocupado por logs ==="
du -sh /var/log/
journalctl --disk-usage 2>/dev/null

echo -e "\n=== Logrotate status ==="
cat /var/lib/logrotate.status 2>/dev/null | tail -5

echo -e "\n=== journald conf activa ==="
grep -v '^#' /etc/systemd/journald.conf | grep -v '^$'

echo -e "\n=== Últimas 10 líneas de auth.log ==="
tail -10 /var/log/auth.log 2>/dev/null || echo "(no existe auth.log)"

echo -e "\n=== Errores del kernel recientes ==="
journalctl -k -p err --since "1 hour ago" --no-pager
```

---

## Ver también

- [[journalctl]] — comando para consultar journald
- [[systemd]] — configuración de journald y gestión de logs
- [[Solucion de Problemas - Recursos]] — dónde mirar según el problema
- [[tail]] — seguir logs en tiempo real
- [[grep]] — buscar en logs
- [[less]] — navegar logs grandes
- [[Proc y Sys]] — `/proc/kmsg` y logs del kernel
- [[Filesystem Hierarchy Standard]] — `/var/log` en el FHS

## Enlaces externos

- [Wikipedia — rsyslog](https://en.wikipedia.org/wiki/Rsyslog)
- [Wikipedia — Log rotation](https://en.wikipedia.org/wiki/Log_rotation)
- [systemd manual — journald](https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html)
- [Arch Wiki — Systemd journal](https://wiki.archlinux.org/title/Systemd/Journal)

#sistema #logging
