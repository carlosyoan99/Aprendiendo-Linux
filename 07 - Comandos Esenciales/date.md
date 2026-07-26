---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: alta
---

# date

## Sintaxis

```bash
date [opciones] [+formato]
```

## Descripción

Muestra o establece la fecha y hora del sistema. Viene en `coreutils` — disponible en toda distro sin instalación.

## Opciones

| Flag | Efecto |
|---|---|
| `-u` | Mostrar hora UTC |
| `-I` | Formato ISO 8601 |
| `-R` | Formato RFC 5322 |
| `-d <string>` | Mostrar una fecha arbitraria |
| `-r <archivo>` | Última modificación de un archivo |
| `-s <string>` | Establecer la fecha (root) |

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

## Ejemplos

```bash
date                                           # Thu Jul 23 14:30:45 CEST 2026
date +"%Y-%m-%d %H:%M:%S"                      # 2026-07-23 14:30:45
date +%s                                       # timestamp Unix
date -d "yesterday"                            # ayer
date -d "+2 weeks" +%F                         # fecha en 2 semanas
date -r /etc/passwd +%F                        # modificación de archivo
```

## Casos de uso

```bash
# Timestamp para logs
echo "[$(date +'%F %T')] Script iniciado" >> script.log

# Nombrar backups con fecha
tar -czf backup-$(date +"%F_%H-%M").tar.gz ~/Documentos
```

## Ver también

- [[timedatectl]] — gestión de zona horaria y NTP
- [[Reloj desincronizado en dual boot]]

## Enlaces externos

- [Wikipedia — date (Unix)](https://en.wikipedia.org/wiki/Date_(Unix))
- [Linux man page — date](https://man7.org/linux/man-pages/man1/date.1.html)

#comando
