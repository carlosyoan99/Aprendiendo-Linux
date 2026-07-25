---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# date y timedatectl

> `date` es el comando clásico de fecha/hora. `timedatectl` es la herramienta moderna de systemd para gestionar la zona horaria, NTP y el reloj hardware (RTC).

---

## Sintaxis

```bash
date [opciones] [+formato]
timedatectl [comando] [opciones]
```

---

## date

### Descripción

Muestra o establece la **fecha y hora del sistema**. Su uso más común es mostrar la fecha actual con formato personalizado. Solo root puede cambiar la fecha del sistema.

Viene en el paquete `coreutils` — disponible en toda distro sin instalación adicional.

### Opciones frecuentes

| Flag | Efecto |
|---|---|
| `-u` | Mostrar hora UTC (no la local) |
| `-I` | Formato ISO 8601 (ej. `2026-07-23`) |
| `-R` | Formato RFC 5322 (ej. `Thu, 23 Jul 2026 14:30:00 +0200`) |
| `-d <string>` | Mostrar una fecha arbitraria (no la actual) |
| `-r <archivo>` | Mostrar la última fecha de modificación de un archivo |
| `-s <string>` | **Establecer** la fecha del sistema (requiere root) |

### Formato de salida personalizado

```bash
date +"formato"
```

| Especificador | Significado | Ejemplo |
|---|---|---|
| `%Y` | Año (4 dígitos) | `2026` |
| `%y` | Año (2 dígitos) | `26` |
| `%m` | Mes (01-12) | `07` |
| `%d` | Día (01-31) | `23` |
| `%H` | Hora (00-23) | `14` |
| `%M` | Minutos (00-59) | `30` |
| `%S` | Segundos (00-59) | `45` |
| `%A` | Día de la semana | `Thursday` |
| `%B` | Nombre del mes | `July` |
| `%Z` | Zona horaria | `CEST` |
| `%s` | Timestamp Unix (segundos desde 1970) | `1780123456` |
| `%j` | Día del año (001-366) | `204` |
| `%F` | Equivale a `%Y-%m-%d` | `2026-07-23` |
| `%T` | Equivale a `%H:%M:%S` | `14:30:45` |
| `%N` | Nanosegundos | `123456789` |
| `%:z` | Diferencia UTC con `:` | `+02:00` |

### Ejemplos

```bash
# Formato básico
date                                           # Thu Jul 23 14:30:45 CEST 2026
date -u                                        # Thu Jul 23 12:30:45 UTC 2026

# Formatos personalizados
date +"%Y-%m-%d %H:%M:%S"                      # 2026-07-23 14:30:45
date +"%A, %d de %B de %Y"                     # Thursday, 23 de July de 2026
date +"%F_%H-%M-%S"                            # 2026-07-23_14-30-45 (ideal para nombres de archivo)
date +%s                                       # 1780123445 (timestamp Unix)

# Timestamps para logs/scripts
echo "[$(date +'%F %T')] Script iniciado" >> script.log

# Fechas relativas con -d (GNU date)
date -d "yesterday"                            # ayer
date -d "next friday"                          # próximo viernes
date -d "+2 weeks" +%F                         # fecha dentro de 2 semanas
date -d "@1780123445"                          # timestamp Unix a fecha legible

# Fecha de modificación de un archivo
date -r /etc/passwd +%F                        # última modificación de /etc/passwd

# Establecer fecha (root)
sudo date -s "2026-07-23 14:30:00"
sudo date -s "+5 minutes"                      # adelantar 5 minutos
```

---

## timedatectl

### Descripción

Herramienta de **systemd** para consultar y cambiar la fecha/hora del sistema, la zona horaria, la sincronización NTP, y el modo del RTC (reloj hardware). Reemplaza a herramientas legacy como `hwclock`, `tzselect`, `ntpdate`.

### Comandos

| Comando | Efecto |
|---|---|
| `status` | Mostrar estado completo (por defecto) |
| `list-timezones` | Listar todas las zonas horarias disponibles |
| `set-timezone <zona>` | Cambiar zona horaria |
| `set-time "HH:MM:SS"` | Establecer hora |
| `set-ntp true/false` | Activar/desactivar sincronización NTP automática |
| `set-local-rtc true/false` | RTC en hora local (true) o UTC (false) |

### Ejemplos

```bash
# Ver estado completo
timedatectl
#                Local time: jue 2026-07-23 14:30:45 CEST
#            Universal time: jue 2026-07-23 12:30:45 UTC
#                  RTC time: jue 2026-07-23 12:30:44
#                 Time zone: Europe/Madrid (CEST, +0200)
# System clock synchronized: yes
#               NTP service: active
#           RTC in local TZ: no

# Cambiar zona horaria
timedatectl list-timezones | grep -i madrid    # buscar zonas
timedatectl list-timezones | grep -i "buenos"
sudo timedatectl set-timezone Europe/Madrid
sudo timedatectl set-timezone America/Argentina/Buenos_Aires

# Activar/desactivar NTP
sudo timedatectl set-ntp true                  # sincronización automática
sudo timedatectl set-ntp false                 # manual (para usar date -s)

# Configurar RTC
sudo timedatectl set-local-rtc 0               # RTC en UTC (recomendado)
sudo timedatectl set-local-rtc 1               # RTC en hora local (para dual boot con Windows)

# Establecer hora manualmente (requiere set-ntp false)
sudo timedatectl set-ntp false
sudo timedatectl set-time "2026-07-23 14:30:00"
sudo timedatectl set-ntp true                  # reactivar NTP tras cambio
```

### Diagnóstico de hora

```bash
# ¿El sistema está sincronizado?
timedatectl status | grep synchronized
# System clock synchronized: yes  ✅ (NTP funciona)
# System clock synchronized: no   ❌ (NTP no disponible o desactivado)

# Ver servidores NTP configurados
# systemd-timesyncd (el cliente NTP por defecto)
cat /etc/systemd/timesyncd.conf | grep -v "^#" | grep -v "^$"

# Ver logs de sincronización
journalctl -u systemd-timesyncd -n 20
```

## Casos de uso reales

### Nombrar backups con timestamp

```bash
tar -czf backup-$(date +"%F_%H-%M").tar.gz ~/Documentos
# Crea: backup-2026-07-23_14-30.tar.gz
```

### Calcular cuánto lleva arrancado el sistema

```bash
# Con date:
uptime -s                           # "2026-07-21 12:15:00" (inicio del sistema)
echo "Arrancado desde: $(date -d @$(date -d "$(uptime -s)" +%s))"
```

### Timestamps en logs de scripts

```bash
log() {
  echo "[$(date +'%F %T')] $*" >> ~/script.log
}
log "Backup completado"
```

### Arreglar hora en dual boot

```bash
# Hacer que Linux use RTC en UTC (estándar)
sudo timedatectl set-local-rtc 0
# Hacer que Windows use UTC (requiere comando en Windows CMD)
# Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1 /f
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `date` muestra hora incorrecta | Zona horaria mal configurada o RTC en modo incorrecto | `timedatectl list-timezones` y `set-timezone` correcta |
| System clock synchronized: no | NTP desactivado o sin conexión | `sudo timedatectl set-ntp true` |
| La hora se desajusta al reiniciar | Batería CMOS agotada o RTC mal configurado | Reemplazar pila CMOS o verificar `timedatectl` status |
| Fecha incorrecta en dual boot con Windows | Conflicto RTC local/UTC | Ver [[Reloj desincronizado en dual boot]] |

## Notas y advertencias

- `timedatectl` solo funciona en sistemas con `systemd` (la gran mayoría de distros modernas). En sistemas sin systemd (Gentoo sin systemd, Alpine), usar `hwclock` y scripts manuales.
- No confundir `timedatectl` con `systemd-timesyncd` — el primero es la interfaz de control, el segundo es el cliente NTP.
- `date -d` con fechas relativas ("yesterday", "+2 weeks") es funcionalidad de **GNU date** — en sistemas BSD/macOS usar `date -v` en su lugar.
- Para scripts críticos, usar formato ISO (`%F %T`) — es portable y ordenable alfabéticamente.
- El timestamp Unix (`date +%s`) es útil para cálculos de tiempo y para medir duración de scripts.

## Enlaces externos

- [Wikipedia — date (Unix)](https://en.wikipedia.org/wiki/Date_(Unix))
- [Arch Wiki — System time](https://wiki.archlinux.org/title/System_time)
- [Arch Wiki — timedatectl](https://man.archlinux.org/man/timedatectl.1)
- [Linux man page — date](https://man7.org/linux/man-pages/man1/date.1.html)
- [Linux man page — timedatectl](https://man7.org/linux/man-pages/man1/timedatectl.1.html)

## Ver también

- [[Reloj desincronizado en dual boot]] — arreglar hora en sistemas con Windows
- [[systemd]] — systemd-timesyncd y gestión de servicios
- [[Dual Boot con Windows]] — configuración de RTC UTC/local
- [[Cheat Sheet - Comandos Esenciales]]

#comando
