---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-27
estado: resuelto
categoria: sistema
prioridad: alta
---

# rsyslog — Log en texto plano

Antes de systemd, rsyslog era el sistema de logging estándar en Linux. Hoy sigue activo en muchas distros (Debian/Ubuntu) coexistiendo con journald. Escribe en archivos de texto plano en `/var/log/`.

## Arquitectura

```
Facility (origen) → Priority (gravedad) → Destino (archivo/remoto)
authpriv           → info               → /var/log/auth.log
kern               → warn               → /var/log/kern.log
local0             → debug              → /var/log/myapp/debug.log
```

## Facilities y prioridades

### Facilities (orígenes)

| Facility | Qué genera |
|---|---|
| `kern` | Mensajes del kernel |
| `user` | Aplicaciones de usuario |
| `mail` | Sistema de correo |
| `daemon` | Servicios del sistema |
| `auth`/`authpriv` | Autenticación |
| `cron` | cron/at |
| `local0`-`local7` | Personalizable |

### Prioridades

| Prioridad | Código | Significado |
|---|---|---|
| `emerg` | 0 | Pánico, sistema inutilizable |
| `alert` | 1 | Acción inmediata |
| `crit` | 2 | Condición crítica |
| `err` | 3 | Error |
| `warning` | 4 | Advertencia |
| `notice` | 5 | Notificación |
| `info` | 6 | Informativo |
| `debug` | 7 | Depuración |

## Configuración básica

```bash
# Archivo principal: /etc/rsyslog.conf
# Fragmentos:      /etc/rsyslog.d/*.conf
```

```bash
# /etc/rsyslog.conf (sintaxis legacy: facility.priority  destino)
*.info;mail.none;authpriv.none;cron.none    /var/log/messages
authpriv.*                                   /var/log/auth.log
mail.*                                       /var/log/mail.log
cron.*                                       /var/log/cron.log
kern.*                                       /var/log/kern.log
```

## Sintaxis RainerScript (moderna)

Rsyslog ofrece una sintaxis más potente llamada **RainerScript**:

```bash
# /etc/rsyslog.d/50-default.conf
module(load="builtin:omfile")

# Filtrar por prioridad
if $syslogseverity <= 3 then /var/log/critical.log

# Filtrar por contenido del mensaje
if $msg contains "error" then /var/log/errors.log

# Filtrar por facility
if $syslogfacility-text == "mail" then /var/log/mail.log

# Discard (stop processing) mensajes debug
if $syslogseverity >= 7 then stop
```

## Templates (formatos personalizados)

Los templates definen cómo se formatea cada entrada de log antes de escribirla:

```bash
# Template string simple (sintaxis tradicional)
$template CustomFmt,"%timegenerated% %hostname% %syslogtag% %msg%\n"
*.* /var/log/custom.log;CustomFmt

# Template tipo lista (RainerScript, recomendado para JSON)
template(name="JsonFormat" type="list") {
    constant(value="{")
    constant(value="\"timestamp\":\"")     property(name="timereported" dateFormat="rfc3339")
    constant(value="\",\"host\":\"")       property(name="hostname")
    constant(value="\",\"message\":\"")    property(name="msg" format="json")
    constant(value="\"}\n")
}

*.* action(type="omfile" file="/var/log/app.json" template="JsonFormat")
```

## Filtrado avanzado

```bash
# Propiedades disponibles
# $msg           - contenido del mensaje
# $hostname      - host de origen
# $syslogtag     - tag del programa (ej: "sshd[1234]:")
# $syslogfacility-text - facility como texto
# $syslogseverity - prioridad numérica (0-7)
# $fromhost-ip   - IP del emisor
# $programname   - nombre del programa

# Combinaciones
if $programname == "sshd" and $msg contains "Failed password" then /var/log/ssh-failed.log
if $fromhost-ip == "192.168.1.100" then /var/log/trusted.log
```

## Forwarding remoto

```bash
# UDP (simple, sin confirmación)
*.* @192.168.1.10:514

# TCP (con confirmación, más fiable)
*.* @@192.168.1.10:514

# RainerScript (forwarding con cola)
action(type="omfwd"
       target="logs.example.com"
       port="514"
       protocol="tcp"
       queue.type="linkedlist"
       queue.fileName="forward_queue"
       queue.maxDiskSpace="2g"
       queue.saveOnShutdown="on")

# Recibir logs remotos
module(load="imudp")
input(type="imudp" port="514")

module(load="imtcp")
input(type="imtcp" port="514")
```

## Transporte seguro (TLS + RELP)

Para evitar logs en texto plano por la red y garantizar que no se pierden mensajes:

```bash
# Instalar módulos necesarios
sudo apt install rsyslog-gnutls rsyslog-relp    # Debian/Ubuntu
sudo pacman -S rsyslog                           # Arch (incluye la mayoría)
```

```bash
# Forwarder (envía con RELP + TLS)
module(load="omrelp")
action(type="omrelp"
       target="logs.example.com"
       port="6514"
       tls="on"
       tls.caCert="/etc/ssl/certs/ca.pem"
       tls.myCert="/etc/ssl/certs/client.pem"
       tls.myPrivKey="/etc/ssl/private/client-key.pem"
       tls.authMode="name"
       queue.type="linkedlist"
       queue.fileName="relp_queue")

# Receiver (recibe con RELP + TLS)
module(load="imrelp")
input(type="imrelp"
      port="6514"
      tls="on"
      tls.caCert="/etc/ssl/certs/ca.pem"
      tls.myCert="/etc/ssl/certs/server.pem"
      tls.myPrivKey="/etc/ssl/private/server-key.pem"
      tls.authMode="name")
```

## Forwarding a base de datos

```bash
# MySQL/MariaDB
sudo apt install rsyslog-mysql

module(load="ommysql")
action(type="ommysql"
       server="localhost"
       db="Syslog"
       uid="rsyslog"
       pwd="secreta")

# Nota: Siempre poner una cola disk-assisted delante de omysql
# para evitar que una BD lenta bloquee todo rsyslog
action(type="ommysql"
       server="localhost"
       db="Syslog" uid="rsyslog" pwd="secreta"
       queue.type="linkedlist"
       queue.fileName="mysql_queue"
       queue.maxDiskSpace="1g")
```

## Logging de archivos de aplicaciones (imfile)

El módulo `imfile` permite ingestar logs de aplicaciones que escriben en archivos de texto plano:

```bash
module(load="imfile")

input(type="imfile"
      File="/var/log/myapp/*.log"
      Tag="myapp:"
      Severity="info"
      Facility="local0"
      PersistStateInterval="10")    # guardar offset cada 10 líneas
```

> `imfile` trackea el offset de cada archivo, por lo que sobrevive a reinicios de rsyslog y rotaciones de log.

## Colas (performance y fiabilidad)

Las colas desacoplan la recepción del procesamiento, evitando cuellos de botella:

| Tipo | Comportamiento | Uso |
|---|---|---|
| **Direct** (default) | Sin cola, entrega inmediata | Logs locales, archivos |
| **LinkedList** | En memoria, tamaño dinámico | Forwarding a servidores remotos |
| **FixedArray** | En memoria, tamaño fijo (predecible) | Sistemas con RAM limitada |
| **Disk** | En disco, más lento pero persistente | Datos críticos que no pueden perderse |
| **Disk-Assisted** | LinkedList + spill a disco si se llena | **Recomendado** para producción |

```bash
# Cola disk-assisted para forwarding fiable
action(type="omfwd"
       target="logs.example.com" port="514" protocol="tcp"
       queue.type="linkedlist"
       queue.fileName="fwd_queue"        # archivo de spill en disco
       queue.maxDiskSpace="2g"            # máximo en disco
       queue.highWatermark="200000"       # 200K msgs en RAM → empieza a spill
       queue.lowWatermark="50000"         # 50K msgs → para de spill
       queue.saveOnShutdown="on")        # guardar al apagar
```

## Rate limiting

Por defecto rsyslog limita mensajes repetidos para evitar tormentas de logs:

```bash
# /etc/rsyslog.conf
$RepeatedMsgReduction on                # reducir mensajes repetidos

# Deshabilitar rate limiting (útil para debugging)
module(load="imuxsock" SysSock.RateLimit.Interval="0")
```

## Monitorización con impstats

```bash
module(load="impstats" interval="60" severity="7")
# Cada 60 segundos escribe estadísticas internas al facility debug
# Permite ver: tamaño de colas, mensajes procesados, errores
```

```bash
# Capturar stats en archivo separado
module(load="impstats" interval="60"
       log.file="/var/log/rsyslog-stats.log"
       log.syslog="off")
```

## Comandos

```bash
sudo rsyslogd -N 1             # verificar sintaxis (dry-run)
sudo systemctl reload rsyslog  # recargar configuración
sudo systemctl status rsyslog  # ver estado
rsyslogd -v                    # versión
```

## Troubleshooting

| Problema | Solución |
|---|---|
| Config no válida | `sudo rsyslogd -N 1` para validar sintaxis |
| Logs no aparecen | Verificar permisos del directorio (debe ser escribible por `syslog` o `root`) |
| Forwarding no funciona | `tcpdump -i any port 514` para ver si salen paquetes |
| Cola llena | `impstats` para ver tamaño de cola. Aumentar `queue.maxDiskSpace` |
| Archivos rotados no se reabren | Añadir `$ReopenOnTruncate on` al inicio de la configuración |
| Logs duplicados | Verificar que no hay reglas solapadas; usar `stop` para descartar después de escribir |

## Ver también

- [[journald]] — log binario de systemd
- [[journalctl]] — comando para consultar journald
- [[logrotate]] — rotación y compresión de logs
- [[Logging del sistema (rsyslog journald logrotate)]] — índice + comparativa

## Enlaces externos

- [Wikipedia — rsyslog](https://en.wikipedia.org/wiki/Rsyslog)
- [Documentación oficial rsyslog](https://www.rsyslog.com/doc/)
- [Arch Wiki — rsyslog](https://wiki.archlinux.org/title/Rsyslog)
- [Rsyslog Queue Modes Explained](https://www.rsyslog.com/doc/concepts/queues.html)

#sistema #logging
