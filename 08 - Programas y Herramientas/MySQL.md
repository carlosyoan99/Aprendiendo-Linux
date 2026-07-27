---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-27
estado: resuelto
categoria: programa
prioridad: alta
---

# MySQL / MariaDB

Base de datos relacional open source más extendida en web (LAMP). Destaca por su simplicidad, rendimiento y ecosistema. **MariaDB** es un fork comunitario, compatible y recomendado como reemplazo directo.

## Instalación

```bash
# MariaDB (recomendado)
sudo apt install mariadb-server mariadb-client   # Debian/Ubuntu
sudo pacman -S mariadb                            # Arch
sudo dnf install mariadb-server mariadb           # Fedora
sudo systemctl enable --now mariadb
sudo mysql_secure_installation

# MySQL de Oracle
sudo apt install mysql-server mysql-client
```

## Primeros pasos

```bash
sudo mysql

CREATE USER 'juan'@'localhost' IDENTIFIED BY 'secreta';
CREATE DATABASE mibase;
GRANT ALL PRIVILEGES ON mibase.* TO 'juan'@'localhost';
FLUSH PRIVILEGES;
exit

mysql -u juan -p mibase
```

## Arquitectura (multi-hilo)

```
mysqld → hilo de red
       → hilo de I/O (replicación)
       → hilo de SQL (replicación)
       → hilo de purge (MVCC)
       → conexión 1..N (un hilo por conexión)
```

## Motores de almacenamiento

| Motor | Transacciones | Uso |
|---|---|---|
| **InnoDB** (default) | ✅ ACID | La mayoría de aplicaciones |
| **MyISAM** | ❌ | Tablas estáticas, full-text |
| **Aria** (MariaDB) | ❌ | Reemplazo moderno de MyISAM |
| **MyRocks** (MariaDB) | ✅ | Alta compresión (RocksDB) |
| **Memory** | ❌ | Caché, tablas temporales |

## Comandos MySQL

```bash
SHOW DATABASES;
USE mibase;
SHOW TABLES;
DESCRIBE tabla;
SHOW INDEX FROM tabla;
SHOW PROCESSLIST;
SHOW ENGINE INNODB STATUS\G
```

## Replicación (maestro-esclavo)

La replicación permite copiar datos de un servidor maestro a uno o más esclavos. Con **GTID** (Global Transaction ID) se simplifica la gestión.

### Configuración con GTID (MariaDB 10+ / MySQL 5.6+)

```ini
# /etc/mysql/mariadb.conf.d/50-server.cnf (maestro y esclavos)
[mysqld]
server-id = 1                      # único por servidor
log_bin = /var/log/mysql/mysql-bin.log
gtid_strict_mode = 1               # evitar transacciones huérfanas
log_slave_updates = 1              # necesario si hay cadena de esclavos
binlog_format = ROW                # recomendado sobre STATEMENT/MIXED
```

```sql
-- En el maestro: crear usuario de replicación
CREATE USER 'replicator'@'%' IDENTIFIED BY 'secreta';
GRANT REPLICATION SLAVE ON *.* TO 'replicator'@'%';

-- En el esclavo: configurar replicación
CHANGE MASTER TO
  MASTER_HOST='192.168.1.10',
  MASTER_USER='replicator',
  MASTER_PASSWORD='secreta',
  MASTER_USE_GTID=slave_pos;
START SLAVE;
SHOW SLAVE STATUS\G
```

### Verificar replicación

```sql
SHOW SLAVE STATUS\G
-- Buscar:
--   Slave_IO_Running: Yes
--   Slave_SQL_Running: Yes
--   Seconds_Behind_Master: 0
```

### Resolución de problemas de replicación

| Síntoma | Causa | Solución |
|---|---|---|
| `Slave_IO_Running: Connecting` | Red, credenciales o firewall | Verificar conectividad: `mysql -u replicator -h 192.168.1.10 -p` |
| `Slave_SQL_Running: No` | Conflicto de datos (duplicado, clave foránea) | `SHOW SLAVE STATUS\G` → ver `Last_Error`. Saltar: `SET GLOBAL sql_slave_skip_counter = 1` |
| GTID inconsistente | Maestro y esclavo desincronizados | Reinicializar esclavo desde backup reciente |
| Lag alto (>10s) | Consultas lentas en esclavo o I/O insuficiente | Verificar `Seconds_Behind_Master`, revisar queries lentas |

## Galera Cluster (MariaDB)

Galera proporciona replicación síncrona multi-maestro. Todos los nodos pueden escribir y reciben confirmación antes de que la transacción sea visible.

### Configuración mínima

```ini
# /etc/mysql/mariadb.conf.d/60-galera.cnf (en cada nodo)
[mysqld]
wsrep_on = ON
wsrep_provider = /usr/lib/galera/libgalera_smm.so
wsrep_cluster_name = "mi-cluster"
wsrep_cluster_address = "gcomm://192.168.1.10,192.168.1.11,192.168.1.12"
wsrep_node_name = "nodo1"
wsrep_node_address = "192.168.1.10"
binlog_format = ROW
default_storage_engine = InnoDB
innodb_doublewrite = 1
innodb_autoinc_lock_mode = 2
```

```bash
# Arrancar el primer nodo (inicializar cluster)
sudo galera_new_cluster

# Unir nodos adicionales (ya en marcha)
sudo systemctl start mariadb
```

### Puertos necesarios

| Puerto | Protocolo | Uso |
|---|---|---|
| 3306 | TCP | Clientes MySQL / State Snapshot Transfer (SST) |
| 4444 | TCP | SST (rsync, mariabackup, mysqldump) |
| 4567 | UDP/TCP | Comunicación de grupo (replicación) |
| 4568 | TCP | Incremental State Transfer (IST) |

### Estado del cluster

```sql
SHOW STATUS LIKE 'wsrep_cluster_size';       -- número de nodos
SHOW STATUS LIKE 'wsrep_cluster_status';     -- Primary / Non-Primary
SHOW STATUS LIKE 'wsrep_connected';          -- conectado al grupo?
SHOW STATUS LIKE 'wsrep_ready';              -- listo para aceptar queries?
SHOW STATUS LIKE 'wsrep_local_state_comment'; -- estado del nodo (Joiner/Synced/Donor)
```

### Failure recovery

- **IST (Incremental State Transfer)**: Si el nodo cayó poco tiempo y su `gcache` (<-- / `wsrep_provider_options="gcache.size=1G"`) aún contiene las transacciones perdidas, se reincorpora rápido sin transferir toda la base de datos.
- **SST (State Snapshot Transfer)**: Si el nodo cayó demasiado tiempo (gcache insuficiente), necesita una copia completa desde otro nodo vía rsync/mariabackup/mysqldump.

## Performance tuning

```ini
# /etc/mysql/mariadb.conf.d/50-server.cnf
innodb_buffer_pool_size = 4G     # 50-70% de RAM
innodb_log_file_size = 1G
innodb_flush_log_at_trx_commit = 1    # 2 si toleras perder 1s en crash
innodb_flush_method = O_DIRECT
```

### performance_schema

El `performance_schema` es un motor de diagnóstico de bajo overhead. Permite identificar consultas lentas, contención de locks y uso de recursos:

```sql
-- Consultas lentas agrupadas por fingerprint
SELECT DIGEST_TEXT, COUNT_STAR, AVG_TIMER_WAIT/1e12 AS avg_sec
FROM performance_schema.events_statements_summary_by_digest
WHERE AVG_TIMER_WAIT/1e12 > 1
ORDER BY AVG_TIMER_WAIT DESC;

-- Top 10 tablas por E/S
SELECT OBJECT_SCHEMA, OBJECT_NAME, COUNT_READ, COUNT_WRITE
FROM performance_schema.table_io_waits_summary_by_table
ORDER BY COUNT_READ DESC LIMIT 10;
```

### Variables de rendimiento clave

| Variable | Recomendación | Explicación |
|---|---|---|
| `innodb_buffer_pool_size` | 50-70% RAM | Cuanto más grande, menos I/O a disco |
| `innodb_log_file_size` | 512M-2G | Tamaño del redo log (afecta escrituras) |
| `innodb_flush_log_at_trx_commit` | 1 (2 opcional) | 1 = más seguro, 2 = más rápido |
| `max_connections` | 100-500 según RAM | Cada conexión consume ~2MB |
| `tmp_table_size` / `max_heap_table_size` | 64M-256M | Tablas temporales en memoria |
| `query_cache_size` | 0 (deshabilitado) | Obsoleto en MySQL 8, no recomendado |

## Gestión de usuarios avanzada

```sql
-- Crear usuario con acceso desde IP específica
CREATE USER 'app'@'192.168.1.%' IDENTIFIED BY 'secreta';

-- Otorgar solo lo necesario
GRANT SELECT, INSERT, UPDATE, DELETE ON miapp.* TO 'app'@'192.168.1.%';

-- Ver privilegios
SHOW GRANTS FOR 'app'@'192.168.1.%';

-- Revocar acceso
REVOKE DELETE ON miapp.* FROM 'app'@'192.168.1.%';

-- Renombrar usuario
RENAME USER 'app'@'192.168.1.%' TO 'app'@'10.0.0.%';

-- SSL/TLS obligatorio
CREATE USER 'app_secure'@'%' IDENTIFIED BY 'secreta' REQUIRE SSL;
```

### Hardening de seguridad

```bash
# Después de instalar
sudo mysql_secure_installation   # elimina: root remoto, usuarios anónimos, test DB

# Deshabilitar LOAD DATA LOCAL INFILE
# En my.cnf: local-infile = 0

# Solo socket local (sin red remota)
# En my.cnf: skip-networking

# Bind a interfaz específica (no 0.0.0.0)
# En my.cnf: bind-address = 127.0.0.1
```

## Backups

```bash
mysqldump -u root -p mibase > backup.sql
mysqldump --all-databases > todas.sql
mysql -u root -p mibase < backup.sql          # restaurar

# Backup con compresión y timestamp
mysqldump -u root -p mibase | gzip > "backup-$(date +%F).sql.gz"

# Backup de todas las bases de datos
mysqldump --all-databases --events --routines --triggers > full-backup.sql

# Restaurar backup comprimido
gunzip < backup-2026-07-27.sql.gz | mysql -u root -p mibase

# MariaDB Backup (físico, más rápido que mysqldump)
sudo mariabackup --backup --target-dir=/backups/mysql --user=root --password
sudo mariabackup --prepare --target-dir=/backups/mysql
```

## Troubleshooting

| Problema | Posible causa | Solución |
|---|---|---|
| `Can't connect to MySQL server` | MySQL no corriendo o puerto bloqueado | `systemctl status mariadb`, `ss -tlnp \| grep 3306`, verificar firewall |
| `Table is marked as crashed` | Tabla MyISAM corrupta | `mysqlcheck -r mibase tabla` o `REPAIR TABLE tabla` |
| `Too many connections` | Pool saturado | Aumentar `max_connections` o cerrar conexiones idle |
| `Deadlock found when trying to get lock` | Contención de transacciones concurrentes | Mostrar: `SHOW ENGINE INNODB STATUS\G` - buscar `LATEST DETECTED DEADLOCK` |
| Binary logs llenando disco | Logs de replicación sin rotar | `PURGE BINARY LOGS BEFORE NOW() - INTERVAL 7 DAY` o configurar `expire_logs_days = 7` |
| `MySQL shutdown unexpectedly` | Corrupción de InnoDB | Revisar `/var/log/mysql/error.log`. Intentar: `innodb_force_recovery = 1` (subiendo hasta 6) en my.cnf |

### Binary log management

```sql
-- Ver logs binarios actuales
SHOW BINARY LOGS;

-- Purgar logs anteriores a una fecha
PURGE BINARY LOGS BEFORE NOW() - INTERVAL 7 DAY;

-- Purgar hasta un log específico
PURGE BINARY LOGS TO 'mysql-bin.000123';

-- Configuración automática en my.cnf
expire_logs_days = 7
max_binlog_size = 500M
```

## MySQL en Docker

```bash
# Con Docker Compose
docker run --name mysql -e MYSQL_ROOT_PASSWORD=secreta -p 3306:3306 -d mariadb:11
mysql -h 127.0.0.1 -u root -p
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  db:
    image: mariadb:11
    environment:
      MYSQL_ROOT_PASSWORD: secreta
      MYSQL_DATABASE: miapp
      MYSQL_USER: app
      MYSQL_PASSWORD: secreta
    volumes:
      - mysql_data:/var/lib/mysql
    ports:
      - "3306:3306"

volumes:
  mysql_data:
```

## Ver también

- [[PostgreSQL]] — base de datos avanzada
- [[PostgreSQL y MySQL]] — índice + comparativa
- [[PostgreSQL vs MongoDB]] — SQL vs NoSQL
- [[SQLite]] — base de datos embebida

## Enlaces externos

- [Wikipedia — MySQL](https://en.wikipedia.org/wiki/MySQL)
- [Wikipedia — MariaDB](https://en.wikipedia.org/wiki/MariaDB)
- [MariaDB documentación](https://mariadb.com/docs/)
- [MariaDB Galera Cluster](https://mariadb.com/kb/en/galera-cluster/)
- [MySQL Performance Tuning Cheatsheet](https://www.monolune.com/mysql-performance-tuning-cheatsheet/)

#programa #base-de-datos
