---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: alta
---

# date y timedatectl

> `date` es el comando clásico para mostrar/establecer fecha y hora de forma puntual; `timedatectl` es la herramienta moderna de [[systemd]] que gestiona la zona horaria, NTP y el reloj hardware (RTC).

## Qué son

Ambos muestran la hora del sistema, pero actúan en niveles distintos y **se complementan**:

- **`date`** — utilidad de `coreutils` que muestra o establece una fecha instantánea y permite **formatear la salida** (`+%F`, `+%s`, timestamps Unix, fechas relativas con `-d`). Es la elección natural para logs, backups y cualquier script que necesite etiquetar algo con la hora actual.
- **`timedatectl`** — herramienta de systemd que gestiona la **configuración global** de la hora: zona horaria, sincronización NTP (a través de `systemd-timesyncd`) y el modo del reloj hardware (RTC, hora UTC o local).

La relación entre ambos: `date` consume lo que `timedatectl` configura. Si la zona horaria es incorrecta, el NTP está desactivado o el RTC está en el modo equivocado, `date` mostrará horas erróneas. Por eso primero se diagnostica/ajusta con `timedatectl` y luego se usa `date` para formatear salidas.

## Tabla comparativa

| Aspecto | `date` | `timedatectl` |
|---|---|---|
| Origen | GNU coreutils | systemd (systemd-timesyncd) |
| Alcance | Fecha/hora puntual | Configuración global (zona, NTP, RTC) |
| Formato de salida | Libre (`+%Y-%m-%d`, `%s`, ...) | Estado fijo de diagnóstico |
| Zona horaria | La usa según `/etc/localtime` | `set-timezone` la cambia |
| Sincronización NTP | No la gestiona | `set-ntp true/false` |
| Reloj hardware (RTC) | Sin acceso | `set-local-rtc` define su modo |
| Permisos | Mostrar: cualquiera; establecer: root | Cambios requieren root |

## Cuándo usar cada uno

- Usa **`date`** cuando necesites mostrar una fecha con formato concreto, calcular timestamps Unix, fechas relativas (`date -d "yesterday"`) o etiquetar backups.
- Usa **`timedatectl`** cuando la hora esté mal, quieras cambiar de zona horaria, activar/desactivar la sincronización automática o diagnosticar el reloj completo (`synchronized: yes/no`).

## Ejemplos de uso combinado

```bash
# 1. Diagnóstico: estado global del reloj
timedatectl status

# 2. Ver y cambiar la zona horaria
timedatectl list-timezones | grep -i madrid
sudo timedatectl set-timezone Europe/Madrid

# 3. Activar la sincronización NTP automática
sudo timedatectl set-ntp true

# 4. Mostrar la hora con formato (ya con la zona correcta)
date +"%A, %d de %B de %Y — %H:%M:%S"
date +%s   # timestamp Unix para scripts

# 5. Etiquetar un backup con la fecha
tar -czf backup-$(date +"%F_%H-%M").tar.gz ~/Documentos
```

### RTC y dual boot

El reloj hardware (RTC) guarda la hora en un formato único. Linux asume **UTC** por defecto; Windows la asume en **hora local**. Compartir disco en un [[Dual Boot con Windows]] produce así el clásico **reloj desincronizado**: al arrancar cada sistema corrige la hora del RTC a su manera y el otro muestra hora corrida.

```bash
# Ver el modo actual del RTC
timedatectl status | grep "RTC in local TZ"

# Linux puro: RTC en UTC (recomendado)
sudo timedatectl set-local-rtc 0

# Dual boot: RTC en hora local (alternativa a tocar Windows)
sudo timedatectl set-local-rtc 1
```

Hay dos soluciones habituales, detalladas en [[Reloj desincronizado en dual boot]]: configurar Windows para usar UTC (registro `RealTimeIsUniversal`) o decirle a Linux que use hora local. La base del protocolo y sus alternativas se explican en [[NTP y chrony]].

## Ver también

- [[date]] — formato de salida, opciones, timestamp Unix
- [[timedatectl]] — zona horaria, NTP, RTC, diagnóstico con journalctl
- [[Reloj desincronizado en dual boot]] — problema clásico de la hora en sistemas duales
- [[systemd]] — systemd-timesyncd como servicio de sincronización
- [[Dual Boot con Windows]] — convivencia de ambos sistemas en un disco
- [[NTP y chrony]] — protocolo NTP y alternativas de sincronización

## Enlaces externos

- [Wikipedia — date (Unix)](https://en.wikipedia.org/wiki/Date_(Unix))
- [Arch Wiki — System time](https://wiki.archlinux.org/title/System_time)
- [Linux man page — timedatectl](https://man7.org/linux/man-pages/man1/timedatectl.1.html)

#comando