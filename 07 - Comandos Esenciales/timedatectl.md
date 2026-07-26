---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
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

## Ver también

- [[date]] — comando de fecha/hora clásico
- [[Reloj desincronizado en dual boot]]
- [[systemd]] — systemd-timesyncd

## Enlaces externos

- [Arch Wiki — System time](https://wiki.archlinux.org/title/System_time)
- [Linux man page — timedatectl](https://man7.org/linux/man-pages/man1/timedatectl.1.html)

#comando
