---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-27
estado: resuelto
categoria: sistema
prioridad: alta
---

# logrotate — Rotación y compresión de logs

Sin logrotate, los logs crecerían hasta llenar el disco. logrotate comprime, rota (renombra) y elimina archivos de log según reglas configurables.

## Configuración

```bash
# Principal:       /etc/logrotate.conf
# Reglas por svc:  /etc/logrotate.d/nginx, /etc/logrotate.d/rsyslog
```

## Sintaxis de una regla

```bash
# /etc/logrotate.d/nginx
/var/log/nginx/*.log {
    daily                             # daily / weekly / monthly
    missingok                         # no fallar si no hay logs
    rotate 14                         # conservar 14 rotaciones
    compress                          # comprimir (gzip por defecto)
    delaycompress                     # comprimir la rotación anterior mañana
    notifempty                        # no rotar si está vacío
    create 640 www-data adm           # crear archivo nuevo con permisos
    sharedscripts                     # ejecutar script una vez
    postrotate
        [ -f /var/run/nginx.pid ] && kill -USR1 `cat /var/run/nginx.pid`
    endscript
}
```

## Directivas principales

| Directiva | Significado |
|---|---|
| `daily`/`weekly`/`monthly` | Frecuencia de rotación |
| `size 100M` | Rotar por tamaño (se puede combinar con time-based) |
| `minsize 100M` | Rotar solo si se cumple el intervalo Y el tamaño mínimo |
| `maxsize 100M` | Rotar si se cumple el intervalo O el tamaño máximo |
| `rotate N` | Conservar N archivos rotados |
| `compress` | Comprimir con gzip |
| `delaycompress` | No comprimir la más reciente |
| `missingok` | No dar error si el log no existe |
| `notifempty` | No rotar si está vacío |
| `create` | Crear archivo nuevo tras rotar |
| `copytruncate` | Copiar y truncar (en vez de renombrar) |
| `maxage 30` | Eliminar rotaciones >30 días |
| `dateext` | Añadir fecha al nombre rotado |
| `su usuario grupo` | Ejecutar rotación como otro usuario |
| `sharedscripts` | Ejecutar script una vez (no por cada archivo) |

## copytruncate vs create

| Método | Cómo funciona | Cuándo usarlo |
|---|---|---|
| **create** (default) | Renombra el log (`.log` → `.log.1`) y crea uno nuevo vacío | Aplicaciones que reabren el log al recibir una señal (nginx, rsyslog) |
| **copytruncate** | Copia el contenido y trunca el original | Aplicaciones que mantienen el archivo abierto y no lo reabren (ej: Docker containers, old apps) |

```bash
# copytruncate: para apps que no pueden reabrir logs
/var/log/miapp/*.log {
    copytruncate
    rotate 7
    compress
    size 50M
}
```

## Compresión avanzada

logrotate usa gzip por defecto, pero puede configurarse para usar otros algoritmos:

```bash
/var/log/nginx/*.log {
    compress
    compresscmd /usr/bin/bzip2       # usar bzip2 (mayor compresión, más lento)
    compressext .bz2                 # extensión del archivo comprimido
    compressoptions -9               # nivel de compresión máximo
}
```

| Algoritmo | Comando | Extensión | Ratio | Velocidad |
|---|---|---|---|---|
| **gzip** (default) | `/usr/bin/gzip` | `.gz` | Medio | Rápida |
| **bzip2** | `/usr/bin/bzip2` | `.bz2` | Alto | Lenta |
| **xz** | `/usr/bin/xz` | `.xz` | Muy alto | Muy lenta |
| **zstd** | `/usr/bin/zstd` | `.zst` | Alto | Muy rápida |

```bash
# zstd: mejor equilibrio ratio/velocidad
/var/log/*.log {
    compress
    compresscmd /usr/bin/zstd
    compressext .zst
    compressoptions -3
}
```

## dateext y dateformat

En lugar de números secuenciales (`.log.1`, `.log.2`), añade la fecha al nombre rotado:

```bash
/var/log/nginx/access.log {
    daily
    rotate 90
    dateext
    dateformat -%Y%m%d                # access.log-20260727.gz
    compress
}

# Con hora (para rotaciones frecuentes)
dateformat -%Y%m%d%H%M%S             # access.log-20260727120000.gz
```

> ⚠️ `dateformat` debe generar nombres **ordenables alfabéticamente** para que `rotate N` funcione correctamente.

## Múltiples rutas en una regla

```bash
/var/log/app1.log /var/log/app2.log /var/log/app3.log {
    weekly
    rotate 4
    compress
    sharedscripts
    postrotate
        systemctl reload miapp > /dev/null 2>&1 || true
    endscript
}
```

## sharedscripts vs scripts individuales

```bash
# SIN sharedscripts: el script se ejecuta por CADA archivo
/var/log/nginx/*.log {
    postrotate
        kill -USR1 `cat /var/run/nginx.pid`  # se ejecuta varias veces
    endscript
}

# CON sharedscripts: el script se ejecuta UNA SOLA VEZ
/var/log/nginx/*.log {
    sharedscripts
    postrotate
        kill -USR1 `cat /var/run/nginx.pid`  # se ejecuta una vez
    endscript
}
```

## prerotate (antes de rotar)

Ejecuta comandos **antes** de la rotación. Útil para copias de seguridad o notificaciones:

```bash
/var/log/mysql/slow.log {
    daily
    rotate 30
    compress
    prerotate
        # Backup antes de rotar
        cp /var/log/mysql/slow.log /backups/mysql-slow-$(date +%F).log
    endscript
}
```

## Probar y forzar rotación

```bash
sudo logrotate -d /etc/logrotate.conf             # simular (dry-run)
sudo logrotate -f /etc/logrotate.conf             # forzar rotación
sudo logrotate -f /etc/logrotate.d/nginx          # forzar regla específica
cat /var/lib/logrotate/status                     # ver última ejecución
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `error: Failed to create file` | Permisos insuficientes | Usar `su usuario grupo` para ejecutar como el propietario del log |
| Logs no se rotan | Status desactualizado o configuración incorrecta | `logrotate -d` para ver qué haría. Verificar `rotate` no está en 0 |
| Script postrotate no funciona | `sharedscripts` faltante con wildcards | Añadir `sharedscripts` cuando se usan patrones `*` |
| El log se trunca antes de copiarse | `copytruncate` pierde datos entre copy y truncate | Usar `create` si la app soporta reabrir logs |
| Compresión falla | Comando no disponible o extensión incorrecta | Verificar `compresscmd` existe y `compressext` coincide |
| SELinux bloquea | Contexto de seguridad incorrecto | `ausearch -m AVC -ts recent` y crear política o cambiar contexto |
| Rotación diaria no ocurre | cron / systemd timer no ejecutándose | Verificar `systemctl status logrotate.timer` o `crontab -l \| grep logrotate` |
| Estado no refleja cambios | Status file corrupto | Eliminar `/var/lib/logrotate/status` y forzar: `logrotate -f /etc/logrotate.conf` |

### Permisos (con su)

Cuando logrotate se ejecuta como root pero los logs pertenecen a otro usuario:

```bash
/var/log/app/*.log {
    daily
    rotate 7
    compress
    su appuser appgroup
    create 640 appuser appgroup
}
```

## Ver también

- [[journald]] — log binario de systemd
- [[rsyslog]] — log en texto plano
- [[Logging del sistema (rsyslog journald logrotate)]] — índice + comparativa

## Enlaces externos

- [Wikipedia — Log rotation](https://en.wikipedia.org/wiki/Log_rotation)
- [Arch Wiki — logrotate](https://wiki.archlinux.org/title/Logrotate)
- [man logrotate](https://man7.org/linux/man-pages/man8/logrotate.8.html)
- [Logrotate: The Complete Guide (FiveNines)](https://www.digitalocean.com/community/tutorials/how-to-manage-log-files-with-logrotate-on-ubuntu-20-04)

#sistema #logging
