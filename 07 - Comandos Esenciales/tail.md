---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# tail

## Sintaxis
```
tail [opciones] archivo
```

## Descripción
Muestra las últimas líneas de un archivo o de la entrada estándar. Por defecto muestra las últimas 10 líneas. Esencial para monitorear logs en tiempo real con la flag `-f`, ver el final de archivos grandes sin abrirlos completos, y extraer los últimos registros de un log rápidamente.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-n <N>` | Muestra las últimas N líneas (ej. `-n 20`). También `+N` para empezar desde línea N |
| `-f` | Follow: sigue mostrando líneas nuevas a medida que se añaden al archivo |
| `-F` | Como `-f` pero también sigue si el archivo se rota (logrotate) — más robusto |
| `-q` | No muestra cabeceras de archivo cuando se pasan varios archivos |
| `-c <N>` | Muestra los últimos N bytes |
| `-s <N>` | Con `-f`, intervalo de sleeps segundos (default 1s) |
| `--pid=<PID>` | Con `-f`, se detiene cuando el PID especificado muere |
| `--retry` | Sigue intentando abrir el archivo aunque no exista al inicio |

## Ejemplos básicos

```bash
tail /var/log/syslog                      # últimas 10 líneas
tail -n 50 /var/log/syslog                # últimas 50 líneas
tail -f /var/log/nginx/access.log         # seguir logs en vivo (Ctrl+C para salir)
tail -F /var/log/syslog                   # seguir logs incluso si se rotan
tail -n +20 archivo.txt                   # mostrar desde la línea 20 en adelante
tail -c 1000 archivo.log                  # últimos 1000 bytes
```

## Casos de uso reales

### Monitoreo de logs en vivo

```bash
# Seguir logs del sistema
sudo tail -f /var/log/syslog

# Seguir logs de nginx
sudo tail -F /var/log/nginx/access.log

# Seguir logs de Docker
docker logs -f contenedor 2>&1 | tail -f

# Seguir logs de journald
journalctl -u nginx -f | tail -f

# Seguir logs con filtro (tail + grep)
sudo tail -F /var/log/syslog | grep -i "error\|fail\|critical"

# Seguir logs excluyendo ruido
sudo tail -F /var/log/nginx/access.log | grep -v "robots.txt"

# Seguir logs y guardar una copia a la vez
sudo tail -F /var/log/syslog | tee /tmp/log-reciente.txt

# Monitorear varios logs a la vez
tail -F /var/log/nginx/access.log /var/log/nginx/error.log
```

### Análisis de logs

```bash
# Últimas 100 líneas de errores
grep "ERROR" app.log | tail -n 100

# Últimas 5 IPs que accedieron (log de nginx)
tail -n 100 access.log | awk '{print $1}' | sort -u

# Últimas líneas antes de un error (tail + grep -B)
tail -n 500 syslog | grep -B 5 "OOM"

# Ver solo las últimas entradas de un log de sistema
sudo journalctl --since "5 min ago" | tail -n 50

# Extraer la última vez que se ejecutó un cron
grep "CRON" /var/log/syslog | tail -n 5
```

### Procesamiento de archivos

```bash
# Ver las últimas 10 líneas de un archivo enorme (sin cargarlo completo)
tail -n 10 archivo-de-10GB.txt

# Omitir la primera línea de un CSV (cabecera) y tomar las últimas 20
tail -n +2 datos.csv | tail -n 20

# Últimas N líneas de varios archivos
tail -n 5 *.log

# Combinar head + tail: líneas 20 a 30 de un archivo
head -n 30 archivo.txt | tail -n 10

# Últimas líneas de un archivo comprimido (sin descomprimir)
zcat archivo.log.gz | tail -n 20
```

### Scripting y automatización

```bash
# Esperar a que aparezca una línea específica en un log
sudo tail -f /var/log/syslog | while read line; do
    if echo "$line" | grep -q "disconnected"; then
        echo "¡Alguien se desconectó!"
        break
    fi
done

# Monitorear un log y ejecutar comando cuando aparece cierto texto
sudo tail -F /var/log/kern.log | grep --line-buffered "usb" |
    while read line; do
        notify-send "USB event" "$line"
    done

# Hacer una captura única: esperar N líneas nuevas y salir
timeout 30 tail -f /var/log/syslog > /tmp/log-captura.txt

# Ver el último acceso a un archivo (usando watch)
watch -n 1 'wc -l /var/log/nginx/access.log | tail -n 1'
```

### Combinaciones poderosas

```bash
# Las IPs más frecuentes en las últimas 1000 líneas del log de acceso
tail -n 1000 access.log | awk '{print $1}' | sort | uniq -c | sort -rn | head -10

# Últimos 10 códigos HTTP distintos
tail -n 100 access.log | awk '{print $9}' | sort -u

# Últimas 10 URLs más lentas (tiempo de respuesta alto)
tail -n 1000 access.log | awk '{print $NF, $7}' | sort -rn | head -10

# Monitorear intentos de login fallidos (SSH)
sudo tail -F /var/log/auth.log | grep -E "Failed password|Invalid user"

# Contar líneas por minuto en un log (útil para detectar picos)
tail -f /var/log/syslog | grep -o "^... .. ..:.." | uniq -c
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `tail -f` se queda pegado sin mostrar nada | El archivo existe pero no se escriben líneas nuevas | Verificar que el proceso esté escribiendo al archivo. `lsof archivo.log` |
| `tail -f` deja de mostrar al rotar el log | El archivo se rotó (movido/renombrado) y `tail` seguía el inodo viejo | Usar `tail -F` en lugar de `tail -f` |
| `tail: cannot open file` | El archivo no existe temporalmente (logrotate) | Usar `tail --retry` para que reintente |
| Archivos comprimidos no se pueden seguir | `tail -f` no funciona con pipes de zcat | Usar `gztail` o descomprimir antes: `gunzip -c log.gz | tail -f` (no funciona realmente, el pipe termina). Para logs.gz en vivo usar `multitail` |
| `tail: invalid number of lines` | Error de sintaxis en `-n` | Verificar que sea un número: `-n 50`, no `-n 50 líneas` |
| Resultados mezclados al monitorear varios archivos | Sin cabeceras, no sabes de qué archivo viene cada línea | Usar `-v` (verbose: siempre muestra cabeceras) |

## Notas y advertencias
- `tail -f` es el estándar para monitorear logs en vivo. Ctrl+C para salir.
- `tail -F` es más robusto que `-f` cuando los logs se rotan (logrotate). Usar `-F` siempre que sea posible.
- Combinado con `grep` es muy potente: `tail -f log | grep ERROR`. Agregar `--line-buffered` a grep para que no acumule en buffer.
- `tail -n +20` muestra desde la línea 20 **en adelante** (no es lo mismo que `-n 20`).
- Para monitorear múltiples logs simultáneamente con colores: `multitail` o `lnav` son herramientas más avanzadas.
- En scripts que se ejecutan periódicamente, `tail -n 0 -f` es útil para esperar líneas nuevas desde el momento en que empieza el script.

## Ver también
- [[less]] — ver archivos con búsqueda paginada
- [[cat]] — ver archivos completos (archivos pequeños)
- `head` — ver las primeras líneas
- [[grep]] — filtrar líneas por patrón
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — tail](https://en.wikipedia.org/wiki/Tail_(Unix))
- [GNU Coreutils — tail manual](https://www.gnu.org/software/coreutils/manual/html_node/tail-invocation.html)

#comando
