---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# PostgreSQL

Base de datos relacional open source más potente del ecosistema. Destaca por cumplimiento ACID, extensibilidad, índices avanzados (GiST, GIN, BRIN), extensiones (PostGIS, pgvector) y su modelo multi-proceso.

## Instalación

```bash
sudo apt install postgresql postgresql-contrib   # Debian/Ubuntu
sudo pacman -S postgresql                         # Arch
sudo dnf install postgresql-server postgresql-contrib  # Fedora
sudo systemctl enable --now postgresql
```

## Primeros pasos

```bash
sudo -u postgres psql

CREATE USER juan WITH PASSWORD 'secreta';
CREATE DATABASE mibase OWNER juan;
GRANT ALL PRIVILEGES ON DATABASE mibase TO juan;
\q

psql -h localhost -U juan -d mibase
```

## Arquitectura (multi-proceso)

```
postmaster → backend process (por conexión)
           → background writer
           → WAL writer
           → checkpointer
           → autovacuum launcher
           → stats collector
```

### MVCC — Sin bloqueo de lecturas

Las lecturas nunca bloquean escrituras ni viceversa. Cada transacción ve un snapshot del momento en que empezó.

### WAL (Write-Ahead Log)

Antes de modificar cualquier página, los cambios se escriben secuencialmente en el WAL: durabilidad garantizada.

## Índices avanzados

| Tipo | Uso |
|---|---|
| **B-tree** (default) | Igualdad, rangos, orden |
| **GIN** | JSONB, arrays, full-text |
| **GiST** | Geoespacial (PostGIS), rangos |
| **BRIN** | Tablas muy grandes con datos correlacionados |
| **Hash** | Solo igualdad |
| **SP-GiST** | Datos agrupados espacialmente |

## Performance tuning

```bash
shared_buffers = '4GB'              # 25-40% de RAM
effective_cache_size = '12GB'       # 50-75% de RAM
work_mem = '64MB'                   # por operación
maintenance_work_mem = '1GB'        # VACUUM, CREATE INDEX
random_page_cost = 1.1              # SSD
```

## Configuración de conexiones (pg_hba.conf)

El archivo `pg_hba.conf` controla qué usuarios pueden conectar desde qué direcciones y con qué método de autenticación. **La primera coincidencia gana.**

```
# TYPE  DATABASE    USER        ADDRESS         METHOD
local   all         all                         peer
host    all         all         127.0.0.1/32    scram-sha-256
host    mibase      juan        192.168.1.0/24  scram-sha-256
host    replication replicator 10.0.0.0/8       scram-sha-256
```

| Método | Uso |
|---|---|
| `peer` | Confía en usuario del SO (solo local) |
| `scram-sha-256` | Seguro con contraseña (reemplaza md5) |
| `trust` | Sin contraseña (solo redes internas) |
| `reject` | Denegar acceso explícitamente |

Tras editar: `SELECT pg_reload_conf();` o `pg_ctl reload`.

## Streaming Replication

PostgreSQL permite replicación en streaming: un **standby** mantiene una copia actualizada mediante envío continuo de WAL.

### En el primario (`postgresql.conf`)
```bash
wal_level = replica
max_wal_senders = 10
```

En `pg_hba.conf`:
```
host replication replicator 192.168.1.0/24 scram-sha-256
```

### En el standby
```bash
pg_basebackup -h 192.168.1.10 -D /var/lib/postgresql/data \
  -U replicator -P -v -R
# -R crea standby.signal y postgresql.auto.conf automáticamente
```

| Parámetro | Descripción |
|---|---|
| `synchronous_commit = on` | Espera confirmación del standby |
| `hot_standby = on` | Permite consultas de solo lectura en standby |
| `max_wal_senders` | Máximo número de conexiones de replicación |

## Connection Pooling (PgBouncer)

PgBouncer mantiene un pool de conexiones reutilizables, reduciendo la sobrecarga de crear conexiones nuevas.

```bash
sudo apt install pgbouncer
```

```ini
; /etc/pgbouncer/pgbouncer.ini
[databases]
mibase = host=127.0.0.1 port=5432 dbname=mibase

[pgbouncer]
listen_addr = 127.0.0.1
listen_port = 6432
pool_mode = transaction        # session / transaction / statement
default_pool_size = 25
max_client_conn = 100
```

```bash
# Conectar via PgBouncer (puerto 6432)
psql -h localhost -p 6432 -U juan -d mibase
```

| Modo | Descripción |
|---|---|
| `session` | Una conexión por sesión (menos eficiente) |
| `transaction` | Reutiliza conexión entre transacciones (recomendado) |
| `statement` | Reutiliza entre statements (más agresivo) |

## Autovacuum

El autovacuum elimina tuplas muertas (filas eliminadas/actualizadas). **Nunca lo desactives.**

```bash
# postgresql.conf
autovacuum = on                           # activado por defecto
autovacuum_vacuum_scale_factor = 0.01     # 1% de la tabla (default: 0.2)
autovacuum_vacuum_cost_limit = 1000       # más I/O si tienes SSD
```

```sql
-- Monitorear tuplas muertas
SELECT relname, n_dead_tup, n_live_tup,
       round(n_dead_tup * 100.0 / n_live_tup, 1) AS dead_pct
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000
ORDER BY n_dead_tup DESC;
```

Si `n_dead_tup` crece sin control, baja `autovacuum_scale_factor` o sube `autovacuum_cost_limit`.

## Troubleshooting: Locks y conexiones

### Detectar bloqueos
```sql
SELECT pid, wait_event_type, wait_event, query
FROM pg_stat_activity
WHERE wait_event_type = 'Lock' AND state != 'idle';
```

### Encontrar el bloqueador
```sql
SELECT pg_blocking_pids(pid) AS bloqueadores, pid, query
FROM pg_stat_activity
WHERE wait_event_type = 'Lock';
```

### Remediación
```sql
SELECT pg_cancel_backend(12345);       # cancelar consulta
SELECT pg_terminate_backend(12345);    # forzar cierre de conexión
```

```bash
# Loggear esperas de lock para diagnóstico
log_lock_waits = on
lock_timeout = '10s'                  # timeout en la app
```

## Backups

```bash
pg_dump mibase > backup.sql                    # SQL
pg_dump -Fc -j 4 mibase > backup.dump          # custom + paralelo
pg_dumpall > todas_backup.sql                  # todas las bases
psql mibase < backup.sql                       # restaurar
```

## Docker

```bash
docker run -d --name postgres \
  -e POSTGRES_PASSWORD=secreta \
  -e POSTGRES_DB=mibase \
  -v pgdata:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:17

docker exec -it postgres psql -U postgres -d mibase
```

## Versión de comandos (psql)

| Comando | Descripción |
|---|---|
| `\l` | Listar bases de datos |
| `\c mibase` | Conectar |
| `\dt` | Listar tablas |
| `\d tabla` | Describir tabla |
| `\di` | Listar índices |
| `\du` | Listar roles |
| `\x` | Vista expandida |
| `\timing` | Medir tiempo de consultas |
| `\watch 1` | Repetir consulta cada 1s |
| `\conninfo` | Info de conexión actual |

## Ver también

- [[MySQL]] — base de datos web
- [[PostgreSQL y MySQL]] — índice + comparativa
- [[PostgreSQL vs MongoDB]] — SQL vs NoSQL
- [[SQLite]] — base de datos embebida

## Enlaces externos

- [Sitio oficial](https://www.postgresql.org/)
- [Wikipedia — PostgreSQL](https://en.wikipedia.org/wiki/PostgreSQL)
- [PostgreSQL Docs — pg_hba.conf](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html)
- [PostgreSQL Docs — Streaming Replication](https://www.postgresql.org/docs/current/warm-standby.html)

#programa #base-de-datos
