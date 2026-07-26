---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
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
    compress                          # comprimir (gzip)
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
| `rotate N` | Conservar N archivos rotados |
| `compress` | Comprimir con gzip |
| `delaycompress` | No comprimir la más reciente |
| `missingok` | No dar error si el log no existe |
| `notifempty` | No rotar si está vacío |
| `create` | Crear archivo nuevo tras rotar |
| `size 100M` | Rotar por tamaño (no por fecha) |
| `maxage 30` | Eliminar rotaciones >30 días |
| `postrotate`/`endscript` | Comandos tras rotar |
| `dateext` | Añadir fecha al nombre rotado |
| `su usuario grupo` | Ejecutar rotación como otro usuario |

## Probar y forzar rotación

```bash
sudo logrotate -d /etc/logrotate.conf             # simular (dry-run)
sudo logrotate -f /etc/logrotate.conf             # forzar rotación
sudo logrotate -f /etc/logrotate.d/nginx          # forzar regla específica
cat /var/lib/logrotate.status                     # ver última ejecución
```

## Ver también

- [[journald]] — log binario de systemd
- [[rsyslog]] — log en texto plano
- [[Logging del sistema (rsyslog journald logrotate)]] — índice + comparativa

## Enlaces externos

- [Wikipedia — Log rotation](https://en.wikipedia.org/wiki/Log_rotation)
- [Arch Wiki — logrotate](https://wiki.archlinux.org/title/Logrotate)

#sistema #logging
