---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: alta
---

# timedatectl

## Descripción

Herramienta de **systemd** para consultar y cambiar la fecha/hora, zona horaria, NTP y modo del RTC. Reemplaza a herramientas legacy como `hwclock`, `tzselect`, `ntpdate`.

## Comandos

| Comando | Efecto |
|---|---|
| `status` | Mostrar estado completo |
| `list-timezones` | Listar zonas horarias |
| `set-timezone <zona>` | Cambiar zona horaria |
| `set-time "HH:MM:SS"` | Establecer hora |
| `set-ntp true/false` | Activar/desactivar NTP |
| `set-local-rtc true/false` | RTC en hora local o UTC |

## Ejemplos

```bash
# Ver estado
timedatectl status

# Cambiar zona horaria
timedatectl list-timezones | grep -i madrid
sudo timedatectl set-timezone Europe/Madrid

# NTP
sudo timedatectl set-ntp true          # sincronización automática
sudo timedatectl set-ntp false         # manual

# RTC (dual boot)
sudo timedatectl set-local-rtc 0       # RTC en UTC (recomendado)
sudo timedatectl set-local-rtc 1       # hora local (para dual boot con Windows)
```

## Diagnóstico

```bash
timedatectl status | grep synchronized
journalctl -u systemd-timesyncd -n 20  # logs de sincronización
```

## Entendiendo el `status`

La salida de `timedatectl status` muestra campos clave que conviene saber leer:

| Campo | Qué indica |
|---|---|
| `Local time` | Hora de la zona horaria activa |
| `Universal time` | Hora UTC |
| `RTC time` | Hora que guarda el reloj hardware |
| `Time zone` | Zona horaria en uso (`/etc/localtime`) |
| `System clock synchronized: yes/no` | Si systemd-timesyncd está consiguiendo la hora de un servidor NTP |
| `NTP service: active/inactive` | Estado del servicio de sincronización |
| `RTC in local TZ: no/yes` | Si el RTC guarda hora local (dual boot) |

> Clave: si `System clock synchronized: no`, casi siempre hay un problema de NTP o de zona horaria y `date` mostrará la hora desviada.

## Zonas horarias y sintaxis de búsqueda

```bash
# Listar y filtrar zonas disponibles
timedatectl list-timezones | grep -i '^america'

# Asignar directamente por nombre de región/ciudad
sudo timedatectl set-timezone Europe/Madrid
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `synchronized: no` | systemd-timesyncd inactivo o sin red | `sudo timedatectl set-ntp true` y revisar `journalctl -u systemd-timesyncd` |
| La hora se desfasa tras reiniciar | NTP desactivado o RTC mal | Activar NTP y verificar el modo del RTC |
| Hora incorrecta al arrancar Windows | RTC en UTC pero Windows espera local | Solución completa en [[Reloj desincronizado en dual boot]] |
| `set-time` no persiste | NTP activo la re-corrige | `sudo timedatectl set-ntp false` antes de fijar hora manual |
| "Failed to set time zone" | Permiso insuficiente o zona inexistente | Usar `sudo` y verificar el nombre en `list-timezones` |

## Ver también

- [[date]] — comando de fecha/hora clásico
- [[Reloj desincronizado en dual boot]]
- [[systemd]] — systemd-timesyncd

## Enlaces externos

- [Arch Wiki — System time](https://wiki.archlinux.org/title/System_time)
- [Linux man page — timedatectl](https://man7.org/linux/man-pages/man1/timedatectl.1.html)

#comando
