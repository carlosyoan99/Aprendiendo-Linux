---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
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

## Performance tuning

```ini
# /etc/mysql/mariadb.conf.d/50-server.cnf
innodb_buffer_pool_size = 4G     # 50-70% de RAM
innodb_log_file_size = 1G
innodb_flush_log_at_trx_commit = 1
innodb_flush_method = O_DIRECT
```

## Backups

```bash
mysqldump -u root -p mibase > backup.sql
mysqldump --all-databases > todas.sql
mysql -u root -p mibase < backup.sql          # restaurar
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

#programa #base-de-datos
