---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: alta
---

# date

> Muestra o establece la fecha y hora del sistema. Herramienta esencial para timestamps en scripts,logs, backups, y diagnóstico de problemas de sincronización horaria.

## Sintaxis

```bash
date [opciones] [+formato]
```

## Descripción

Muestra o establece la fecha y hora del sistema. Viene en `coreutils` — disponible en toda distro sin instalación. Para gestionar zona horaria y NTP, usar [[timedatectl]].

## Opciones principales

| Flag | Efecto |
|---|---|
| `-u` | Mostrar hora UTC |
| `-I` | Formato ISO 8601 |
| `-R` | Formato RFC 5322 |
| `-d <string>` | Mostrar una fecha arbitraria ("yesterday", "+2 weeks") |
| `-r <archivo>` | Última modificación de un archivo |
| `-s <string>` | Establecer la fecha (root) |
| `-f <formato> <string>` | Parsear fecha con formato específico |

## Formato de salida

| Especificador | Significado | Ejemplo |
|---|---|---|
| `%Y` | Año (4 dígitos) | `2026` |
| `%m` | Mes (01-12) | `07` |
| `%d` | Día (01-31) | `23` |
| `%H` | Hora (00-23) | `14` |
| `%M` | Minutos (00-59) | `30` |
| `%S` | Segundos (00-59) | `45` |
| `%F` | `%Y-%m-%d` | `2026-07-23` |
| `%T` | `%H:%M:%S` | `14:30:45` |
| `%s` | Timestamp Unix | `1780123456` |
| `%A` | Día de la semana largo | `Thursday` |
| `%B` | Mes largo | `July` |
| `%Z` | Zona horaria | `CEST` |
| `%z` | Offset UTC | `+0200` |
| `%I` | Hora 12h (01-12) | `02` |
| `%p` | AM/PM | `PM` |

## Ejemplos

```bash
# Formato básico
date                                           # Thu Jul 23 14:30:45 CEST 2026
date +"%Y-%m-%d %H:%M:%S"                     # 2026-07-23 14:30:45
date +"%F_%H-%M"                              # 2026-07-23_14-30

# Timestamp Unix
date +%s                                       # 1780123456

# Fechas relativas
date -d "yesterday" +%F                        # 2026-07-22
date -d "tomorrow" +%F                         # 2026-07-24
date -d "+2 weeks" +%F                         # 2026-08-06
date -d "last monday" +%F                      # último lunes
date -d "next friday" +%F                      # próximo viernes

# UTC
date -u +"%Y-%m-%dT%H:%M:%SZ"                 # 2026-07-23T12:30:45Z

# Última modificación de un archivo
date -r /etc/passwd +%F                        # 2026-07-01

# Parsear fecha
date -f "%Y-%m-%d %H:%M" "2026-12-25 10:00"   # parsear string

# Convertir timestamp Unix a fecha legible
date -d @1780123456                            # convertir timestamp

# Fecha en otros calendarios
date +%j                                       # día del año (001-365)
date +%U                                       # número de semana (00-53)
date +%w                                       # día de la semana (0=domingo)
```

## Casos de uso

### Timestamps en scripts y logs

```bash
# Logging con timestamp
echo "[$(date +'%F %T')] Iniciando backup..." >> /var/log/backup.log

# Timestamp para nombres de archivo
tar -czf "backup-$(date +'%F_%H-%M').tar.gz" ~/Documentos

# Timestamp ISO para APIs
date -u +"%Y-%m-%dT%H:%M:%SZ"
```

### Cálculos de tiempo

```bash
# Calcular duración
start=$(date +%s)
# ... operación larga ...
end=$(date +%s)
echo "Duración: $((end - start)) segundos"

# Fecha en el pasado
date -d "30 days ago" +%F

# Días entre dos fechas
echo $(( ($(date -d "2026-12-31" +%s) - $(date -d "2026-01-01" +%s)) / 86400 ))
```

### Verificar sincronización horaria

```bash
# Comparar hora local con UTC
echo "Local: $(date +"%F %T %Z")"
echo "UTC:   $(date -u +"%F %T %Z")"
echo "Diff:  $(( $(date +%s) - $(date -u +%s) )) segundos"

# Verificar si el reloj está sincronizado (usar timedatectl)
timedatectl status | grep "synchronized"
```

## date vs timedatectl

| Aspecto | date | timedatectl |
|---|---|---|
| **Función** | Mostrar/formatear fecha | Gestionar zona horaria, NTP |
| **Formato** | Personalizable (+formato) | Formato fijo |
| **Establecer fecha** | `date -s` (root) | `timedatectl set-time` |
| **Zona horaria** | Solo muestra | Cambia la zona horaria |
| **NTP** | No | Sincronización automática |
| **Ideal para** | Scripts, timestamps | Configuración del sistema |

## Ver también

- [[timedatectl]] — gestión de zona horaria y NTP
- [[date y timedatectl]] — índice combinado
- [[Reloj desincronizado en dual boot]] — troubleshooting
- [[NTP y chrony]] — sincronización de hora
- [[Variables de Entorno y PATH]] — TZ para zona horaria

## Enlaces externos

- [Wikipedia — date (Unix)](https://en.wikipedia.org/wiki/Date_(Unix))
- [Man page — date](https://man7.org/linux/man-pages/man1/date.1.html)
- [GNU date manual](https://www.gnu.org/software/coreutils/manual/html_node/date-invocation.html)

#comando #tiempo #scripts
