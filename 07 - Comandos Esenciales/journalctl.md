---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: comando
prioridad: alta
---

# journalctl

## Sintaxis
```
journalctl [opciones]
```

## Descripción
Visor de logs de **systemd** (el sistema de logging centralizado, reemplazo de los archivos de texto en `/var/log/`). Captura logs del kernel, servicios, aplicaciones y eventos del sistema. Es la primera herramienta de troubleshooting en sistemas modernos.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-u <servicio>` | Logs de un servicio/unidad systemd específica |
| `-f` | Modo follow (como `tail -f`) |
| `-b` | Logs desde el arranque actual |
| `-b -1` | Logs del arranque anterior (`-2` del antepenúltimo, etc.) |
| `-x` | Añadir explicaciones a los mensajes (más legible) |
| `-e` | Ir al final del log (como abrir con `G` en [[less]]) |
| `-p <nivel>` | Filtrar por prioridad: `err`, `warn`, `info`, `debug` |
| `--since` | Desde una fecha/hora |
| `--until` | Hasta una fecha/hora |
| `-k` | Solo mensajes del kernel (como `dmesg`) |
| `--list-boots` | Lista los boots disponibles con sus índices (`-b -1`, etc.) |
| `-n <N>` | Últimas N líneas |

## Niveles de prioridad

| Nivel | Valor | Uso |
|---|---|---|
| `emerg` | 0 | Emergencia — sistema inusable |
| `alert` | 1 | Requiere acción inmediata |
| `crit` | 2 | Condición crítica |
| `err` | 3 | Error |
| `warning` / `warn` | 4 | Advertencia |
| `notice` | 5 | Notificación |
| `info` | 6 | Informativo |
| `debug` | 7 | Depuración |

## Ejemplos
```bash
# Troubleshooting diario
journalctl -xe                           # logs recientes con explicaciones (el clásico)
journalctl -u nginx -f                   # seguir logs de nginx en vivo
journalctl -u sshd --since "1 hour ago" # logs de SSH de la última hora
journalctl -b                            # desde que arrancó el sistema
journalctl -b -1                         # logs del boot anterior (útil si el problema causó reboot)

# Filtros avanzados
journalctl -p err -b                     # solo errores desde el arranque actual
journalctl --since "2026-07-17 10:00" --until "2026-07-17 12:00"  # rango de tiempo
journalctl -k                            # solo mensajes del kernel (equivalente a dmesg)
journalctl _PID=1234                     # logs de un PID específico
journalctl -u nginx -u postgresql        # logs de múltiples servicios

# Mantenimiento
journalctl --disk-usage                  # cuánto ocupan los logs en disco
sudo journalctl --vacuum-size=500M       # reducir logs a máximo 500 MB
sudo journalctl --vacuum-time=30days     # borrar logs de más de 30 días
```

## Filtros avanzados — Combinación de campos

```bash
# Múltiples servicios a la vez
journalctl -u nginx -u postgresql -u sshd --since today

# Servicio + prioridad + tiempo
journalctl -u nginx -p err --since "30 min ago"

# Puerto de syslog + prioridad
journalctl _TRANSPORT=syslog -p warning --since yesterday

# PID específico + follow en vivo
journalctl _PID=1234 -f

# Usuario + servicio específico
journalctl _UID=1000 -u nginx

# Usar jq con salida JSON (para scripting avanzado)
journalctl -u sshd --since today -o json | jq 'select(.PRIORITY == "3") | {msg: .MESSAGE, time: .__REALTIME_TIMESTAMP}'
```

## Salida con formato

```bash
journalctl -o short                     # formato por defecto
journalctl -o short-full                # timestamp completo
journalctl -o short-iso                 # ISO 8601
journalctl -o verbose                   # TODOS los metadatos disponibles
journalctl -o json                      # JSON (una línea por entrada)
journalctl -o json-pretty               # JSON formateado
journalctl -o cat                       # solo el mensaje (sin metadatos)
journalctl -o export                    # formato portable (para migrar logs)
```

## Exportar e importar logs

```bash
# Exportar logs de un servicio a un archivo portable
journalctl -u nginx -o export > nginx-logs.journal

# Analizar logs exportados en otra máquina
journalctl --file=nginx-logs.journal
journalctl --file=nginx-logs.journal -p err

# Guardar en texto plano (para compartir)
journalctl -u nginx --since today --no-pager > nginx-logs.txt

# Ver logs en formato JSON para procesar con scripts
journalctl -u nginx -o json | jq '.MESSAGE' | sort | uniq -c | sort -rn | head -10
```

## Debugging con logs de depuración

Por defecto, journald solo captura logs hasta nivel `info` (6). Para ver logs `debug` (7):

```bash
# 1. Aumentar nivel de log de journald
sudo mkdir -p /etc/systemd/journald.conf.d/
sudo tee /etc/systemd/journald.conf.d/99-debug.conf << 'EOF'
[Journal]
LogLevel=debug
EOF
sudo systemctl restart systemd-journald

# 2. Ahora se pueden ver logs debug
journalctl -p debug --since "5 min ago"

# 3. O para un servicio específico, cambiar su log level en el override:
sudo systemctl edit mi-servicio
# [Service]
# Environment=LOG_LEVEL=debug
```

```bash
# Alternativa: ver logs debug de systemd itself
journalctl -u systemd-journald -p debug

# Ver debug de un servicio específico (si soporta variables de entorno)
sudo SYSTEMD_LOG_LEVEL=debug systemctl status nginx
```

## Troubleshooting de journald

| Problema | Causa | Solución |
|---|---|---|
| `journalctl: No journals found` | No hay logs (volátiles o vacíos) | Crear `/var/log/journal` para persistencia |
| `journalctl: Failed to get data: Cannot assign requested address` | Archivo journal corrupto | `sudo journalctl --rotate; sudo journalctl --vacuum-size=100M` |
| `Cannot open /var/log/journal/...: No such file or directory` | Logs rotados o eliminados | Verificar con `journalctl --list-boots` cuánto historial hay |
| journald consume mucha RAM | `RuntimeMaxUse` muy alto | Limitar en `/etc/systemd/journald.conf`: `RuntimeMaxUse=50M` |
| Logs de un PID específico no aparecen | El proceso terminó y journald recicló | Usar `journalctl _COMM=nombre` o `_EXE=/ruta` en su lugar |
| `--since` y `--until` no filtran correctamente | Formato de hora incorrecto | Usar formato ISO: `"2026-07-19 14:00:00"` |
| journalctl es muy lento en sistemas con muchos logs | Muchos archivos journal | `sudo journalctl --vacuum-time=30d` para compactar |

## Trucos avanzados

```bash
# Monitorear en vivo errores críticos del sistema completo
journalctl -f -p err

# Ver logs con resalte de palabras clave (colores)
journalctl -u nginx -f | grep --color=always -E "error|warn|crit|fail|denied|$\"

# Ver cuántas veces falló un servicio
journalctl -u nginx -p err --no-pager | wc -l

# Ver tipos de mensajes más frecuentes en un servicio
journalctl -u nginx -o json --no-pager | jq -r '.MESSAGE' | sort | uniq -c | sort -rn | head -10

# Ver logs del boot anterior que coinciden con un patrón
journalctl -b -1 -g "error\|fail\|OOM"
# -g = grep (búsqueda de texto en el mensaje, no en metadatos)
```

## Configuración recomendada

```ini
# /etc/systemd/journald.conf
[Journal]
Storage=persistent                    # guardar siempre en disco
Compress=yes                          # comprimir logs viejos
Seal=yes                              # firmar logs (seguridad)
SystemMaxUse=500M                     # máximo 500MB para logs del sistema
SystemMaxFileSize=100M                # máximo 100MB por archivo
MaxRetentionSec=4weeks                # retener máximo 4 semanas
ForwardToSyslog=no                    # no duplicar a rsyslog (si usas journald como primario)
```

```bash
# Aplicar configuración
sudo systemctl restart systemd-journald
journalctl --disk-usage               # verificar que se redujo
```

## Ver también
- [[systemd]] — gestión de servicios, unidades, targets
- [[Logging del sistema (rsyslog journald logrotate)]] — rsyslog, logrotate, configuración completa de journald
- [[less]] — navegación de logs largos
- [[Solucion de Problemas - Recursos]] — dónde mirar según el problema
- [[grep]] — búsqueda de patrones en logs
- [[journalctl]] — este mismo comando

## Enlaces externos

- [Wikipedia - systemd-journald](https://en.wikipedia.org/wiki/Systemd-journald)
- [Freedesktop - journalctl docs](https://www.freedesktop.org/software/systemd/man/journalctl.html)
- [Arch Wiki - journalctl](https://wiki.archlinux.org/title/Journalctl)

#comando
