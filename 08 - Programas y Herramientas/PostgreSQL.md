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

## Backups

```bash
pg_dump mibase > backup.sql                    # SQL
pg_dump -Fc -j 4 mibase > backup.dump          # custom + paralelo
pg_dumpall > todas_backup.sql                  # todas las bases
psql mibase < backup.sql                       # restaurar
```

## Ver también

- [[MySQL]] — base de datos web
- [[PostgreSQL y MySQL]] — índice + comparativa
- [[PostgreSQL vs MongoDB]] — SQL vs NoSQL
- [[SQLite]] — base de datos embebida

## Enlaces externos

- [Sitio oficial](https://www.postgresql.org/)
- [Wikipedia — PostgreSQL](https://en.wikipedia.org/wiki/PostgreSQL)

#programa #base-de-datos
