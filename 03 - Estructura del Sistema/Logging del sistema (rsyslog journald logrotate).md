---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: sistema
prioridad: alta
---

# Logging del sistema (rsyslog, journald, logrotate)

## Definición

El logging en Linux es el sistema que registra eventos del kernel, servicios y aplicaciones. Tradicionalmente gestionado por **syslog** (y su variante moderna **rsyslog**), hoy coexiste con **journald** (systemd). **logrotate** se encarga de rotar, comprimir y eliminar logs viejos.

## Componentes

- [[journald]] — log binario de systemd (estructurado, metadatos)
- [[rsyslog]] — log en texto plano tradicional
- [[logrotate]] — rotación y compresión de logs

## Comparativa rápida

| Característica | journald | rsyslog |
|---|---|---|
| **Formato** | Binario (estructurado) | Texto plano |
| **Filtrado** | Potente (campos, prioridad, tiempo) | Básico (grep) |
| **Rotación** | Integrada | Externa (logrotate) |
| **Logs remotos** | Limitado | Excelente (UDP/TCP nativo) |
| **Ideal para** | Diagnóstico local | Centralización remota |

## Archivos de log comunes

| Archivo | Contenido |
|---|---|
| `/var/log/syslog` | Log general (Debian/Ubuntu) |
| `/var/log/messages` | Log general (Fedora/RHEL) |
| `/var/log/auth.log` | Intentos de login (Debian/Ubuntu) |
| `/var/log/kern.log` | Mensajes del kernel |

## Buenas prácticas

```bash
# Hacer journald persistente
sudo mkdir -p /var/log/journal
sudo systemctl restart systemd-journald

# Limitar espacio de journald (en /etc/systemd/journald.conf)
# SystemMaxUse=500M

# Verificar logrotate activo
sudo systemctl status logrotate.timer
```

## Ver también

- [[journalctl]] — comando para consultar journald
- [[systemd]] — configuración de journald
- [[tail]] — seguir logs en tiempo real
- [[grep]] — buscar en logs
- [[Filesystem Hierarchy Standard]] — `/var/log` en el FHS

## Enlaces externos

- [Wikipedia — rsyslog](https://en.wikipedia.org/wiki/Rsyslog)
- [Wikipedia — Log rotation](https://en.wikipedia.org/wiki/Log_rotation)
- [systemd manual — journald](https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html)

#sistema #logging
