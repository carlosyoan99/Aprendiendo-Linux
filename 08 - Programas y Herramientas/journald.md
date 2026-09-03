---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: alta
---

# journald

> **journald** es el daemon de registro de eventos de **systemd**. Captura logs de todos los servicios, del kernel y del arranque en un formato binario estructurado y los expone con **journalctl**. Es la herramienta estándar de monitoreo de logs en las distros modernas (todas con systemd).

## Qué es

journald recibe logs de:

- **Servicios systemd** — stdout/stderr de cada unidad
- **Kernel** — mensajes de `dmesg`
- **Syslog tradicional** — protocolo compat (puede reemplazar a rsyslog)
- **Aplicaciones** — vía syslog() o el socket nativo

Ventajas frente a los logs de texto clásicos (`/var/log/*.log`):

| Aspecto | journald | syslog clásico (rsyslog) |
|---|---|---|
| **Formato** | Binario estructurado (índices, campos) | Texto plano |
| **Metadatos** | PID, UID, unidad, prioridad, timestamp preciso | Solo lo que la app escribe |
| **Consultas** | `journalctl` con filtros potentes | `grep` sobre archivos |
| **Rotación** | Automática (por tamaño/tiempo) | Configuración manual (logrotate) |
| **Persistencia** | Volátil por defecto; persistente configurable | Siempre persistente |
| **Integridad** | Checksums opcionales (FSS) | Ninguna |

---

## Instalación y persistencia

```bash
# Ya viene con systemd — nada que instalar
systemctl --version | head -1

# Configuración: /etc/systemd/journald.conf
# Por defecto los logs son volátiles (/run/log/journal)
# Para persistencia (recomendado en servidores):
sudo mkdir -p /var/log/journal
sudo systemd-tmpfiles --create --prefix /var/log/journal
sudo systemctl restart systemd-journald

# Verificar persistencia
journalctl --verify | head -5
ls /var/log/journal/
```

### Configuración recomendada (/etc/systemd/journald.conf)

```ini
[Journal]
# Límite de almacenamiento (SystemMaxUse)
SystemMaxUse=500M
# Tamaño máximo por archivo
SystemMaxFileSize=50M
# Número de archivos
SystemMaxFiles=100
# Compresión
Compress=yes
# Sincronizar a disco (seguridad vs rendimiento)
SyncIntervalSec=5m
# Nivel máximo de log (0 emerg - 7 debug)
MaxLevelStore=debug
```

---

## Comandos esenciales

### Leer logs

```bash
# Todos los logs
journalctl

# Últimos N líneas (como tail -f)
journalctl -n 50
journalctl -n 50 -f                    # seguir en vivo

# Solo del boot actual
journalctl -b
# Boot anterior
journalctl -b -1
# Listar boots disponibles
journalctl --list-boots

# Por unidad/servicio
journalctl -u nginx
journalctl -u nginx -u postgresql       # varias unidades
journalctl -u nginx --since today

# Por proceso/PID
journalctl _PID=1234

# Por usuario
journalctl _UID=1000

# Por prioridad
journalctl -p err                       # solo errores y superiores
journalctl -p warning -u nginx          # combinado con unidad
```

### Filtrar por tiempo

```bash
journalctl --since "2026-09-03 10:00:00"
journalctl --since "2 hours ago"
journalctl --until "yesterday"
journalctl --since today --until "1 hour ago"
```

### Formato y campos

```bash
# Formato detallado con metadatos
journalctl -o verbose

# Formato JSON (para scripting)
journalctl -o json
journalctl -o json-pretty

# Campos concretos
journalctl -o verbose | grep -E "COMM=|EXE=|UNIT="

# Ver todos los campos disponibles de un mensaje
journalctl -o json-pretty -n 1 | python3 -m json.tool | head -30
```

### Kernel

```bash
# Mensajes del kernel (equivalente a dmesg)
journalctl -k
journalctl -k --since today

# Errores de kernel recientes
journalctl -k -p err --since "3 days ago"
```

---

## Integración con rsyslog / syslog-ng

```bash
# journald puede forwardear a rsyslog para compatibilidad:
# En /etc/systemd/journald.conf:
#   ForwardToSyslog=yes
#   ForwardToConsole=no
#   ForwardToWall=no

# Y en rsyslog configurar para recibir de journal:
# /etc/rsyslog.conf:
#   $ModLoad imjournal
#   $OmitLocalLogging off
```

---

## Seguridad y auditoría

### Logs firmados (FSS — Forward Secure Sealing)

```bash
# Detecta manipulación de logs
journalctl --setup-keys
# En /etc/systemd/journald.conf:
#   Seal=yes

# Verificar integridad
sudo journalctl --verify --key=/var/log/journal/$(cat /etc/machine-id)/fss 2>/dev/null | tail -3
```

### Protección de la configuración

```bash
# El usuario normal puede ver sus propios logs y los del sistema
# Para restringir acceso a logs de unidades específicas:
# En el unit file del servicio:
#   LogExtraFields=...  (no existe)
# En su lugar, usar:
# /etc/systemd/journald.conf
#   [Journal]
#   # Restringir por grupo:
#   # (no nativo — usar ACLs en /var/log/journal)
```

### Tamaño y rotación

```bash
# Vaciar logs (⚠️ irreversible)
sudo journalctl --vacuum-size=100M        # dejar máximo 100M
sudo journalctl --vacuum-time=7d          # borrar lo anterior a 7 días
sudo journalctl --vacuum-files=5          # conservar 5 archivos

# Ver uso actual
journalctl --disk-usage
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `No journal files were found` | Logs volátiles + reinicio reciente | Activar persistencia (mkdir /var/log/journal) |
| `journalctl` lento en máquinas grandes | Índices no construidos | `journalctl --verify` para reconstruir |
| Logs de ayer no aparecen | Rotación por tamaño agresiva | Ajustar SystemMaxUse en journald.conf |
| Servicio sin logs | La unidad no hace flush | Verificar `StandardOutput=journal` en el unit |
| `Failed to write entry` | Disco lleno | `journalctl --vacuum-size=` para liberar |
| Logs duplicados (journal + syslog) | ForwardToSyslog=yes + rsyslog local | Elegir una vía: desactivar forwarding o imjournal |
| journald consume mucha RAM | Buffer grande por defecto | Reducir `RuntimeMaxUse` en journald.conf |

### Diagnóstico

```bash
# Estado del journald
systemctl status systemd-journald
journalctl --verify                        # integridad de archivos

# ¿Qué unidad genera más logs?
journalctl --no-pager -o verbose | grep -oE "UNIT=[^ ]+" | sort | uniq -c | sort -rn | head -10

# Monitorizar en vivo errores de todo el sistema
journalctl -f -p warning
```

---

## journalctl vs alternativas

| Herramienta | Rol | Ventaja |
|---|---|---|
| **journalctl** | Logs de systemd | Integrado, filtros potentes, metadatos |
| **dmesg** | Solo kernel | Simple, enfocado en hardware/drivers |
| **rsyslog** | Syslog clásico | Compatibilidad, reenvío a servidores remotos |
| **logrotate** | Rotación de archivos de texto | Necesario solo para logs que no pasan por journal |
| **auditd** | Auditoría de seguridad | Reglas de acceso, ejecución, llamadas al sistema |
| **Logwatch / logcheck** | Resúmenes periódicos por email | Alertas resumidas automáticas |
| **GoAccess** | Análisis de logs web | Stats de Nginx/Apache |

**Recomendación**: usa journald/journalctl como fuente primaria. Añade **rsyslog** solo si necesitas reenvío a un servidor central de logs. Para seguridad y auditoría, complementa con [[auditd]].

---

## Ver también

- [[systemd]] — el ecosistema que gestiona journald
- [[auditd]] — auditoría de seguridad (complementa a journald)
- [[dmesg]] — mensajes del kernel
- [[Monitorización (Prometheus node_exporter)]] — monitoreo de métricas
- [[Solución de Problemas - Recursos]] — diagnóstico general

## Enlaces externos

- [Arch Wiki — systemd/Journal](https://wiki.archlinux.org/title/Systemd/Journal)
- [man journalctl](https://www.freedesktop.org/software/systemd/man/journalctl.html)
- [man journald.conf](https://www.freedesktop.org/software/systemd/man/journald.conf.html)
- [DigitalOcean — How to Use Journalctl](https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs)

#programa #logs #systemd #servidor