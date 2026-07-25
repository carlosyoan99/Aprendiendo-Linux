---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
licencia: PostgreSQL (PostgreSQL license), MySQL (GPLv2), MariaDB (GPLv2)
alternativas: SQLite, MongoDB, Redis, SQL Server
---

# PostgreSQL y MySQL

> Las dos bases de datos relacionales **open source** más utilizadas en Linux. **PostgreSQL** destaca por su robustez, cumplimiento ACID, extensibilidad y características avanzadas. **MySQL/MariaDB** es la opción más extendida en web (LAMP) por su simplicidad y rendimiento.

---

## Comparativa rápida

| Aspecto | PostgreSQL | MySQL | MariaDB |
|---|---|---|---|
| **Licencia** | PostgreSQL license | GPLv2 / Oracle | GPLv2 |
| **Modelo** | ORDBMS (objetos+relacional) | RDBMS relacional | RDBMS relacional |
| **Cumplimiento ACID** | Completo desde el inicio | Depende del motor (InnoDB sí) | Completo |
| **SQL estándar** | Muy alto | Medio | Medio-alto |
| **Índices** | B-tree, Hash, GiST, GIN, SP-GiST, BRIN | B-tree, Hash, Full-text | B-tree, Hash, Full-text |
| **JSON** | Nativo + índices JSONB | Nativo (JSON) | Nativo (JSON) |
| **Extensiones** | PostGIS, pgvector, TimescaleDB, pg_partman | Plugins limitados | Plugins + Aria, MyRocks |
| **Replicación** | Streaming, lógica, cascada | Nativa (binlog) | Nativa + Galera |
| **Concurrencia** | MVCC sin bloqueo de lecturas | MVCC con InnoDB | MVCC + Galera |
| **Uso típico** | Datos complejos, geoespaciales, analíticos | Web, LAMP, CRUD simple | Web, reemplazo MySQL |
| **Empresas usuarias** | Apple, Reddit, Instagram, Spotify | Facebook, Twitter, YouTube | Wikipedia, WordPress |

---

## Arquitectura de PostgreSQL

PostgreSQL usa un **modelo multi-proceso** (un proceso por conexión), a diferencia de MySQL que usa multihilos:

```
postmaster (proceso padre)
    │
    ├── backend process (cliente 1)    ← un proceso por conexión
    ├── backend process (cliente 2)
    ├── backend process (cliente N)
    │
    ├── background writer              ← vuelca páginas sucias a disco gradualmente
    ├── WAL writer                     ← persiste el WAL buffers periódicamente
    ├── checkpointer                   ← checkpoint: sincroniza datos + WAL
    ├── autovacuum launcher            ← lanza workers de VACUUM
    │   └── autovacuum worker 1
    │   └── autovacuum worker N
    ├── WAL archiver                   ← archiva segmentos WAL (backups)
    ├── stats collector                ← recolecta estadísticas de consultas
    └── logical replication launcher   ← replicación lógica
```

### MVCC (Multiversion Concurrency Control)

PostgreSQL implementa MVCC sin bloqueo de lecturas — las lecturas **nunca bloquean escrituras** ni viceversa:

```sql
-- Cada transacción ve una "snapshot" del momento en que empezó
-- PostgreSQL mantiene múltiples versiones de cada fila (tuplas)

-- Cuando actualizas una fila:
--   ❌ No se modifica la original
--   ✅ Se crea una nueva versión (tupla muerta)
--   ⏳ Las transacciones viejas ven la versión antigua
--   🔄 VACUUM limpia las versiones que ya no ve nadie
```

### WAL (Write-Ahead Log)

El **WAL** es el corazón de la durabilidad en PostgreSQL. Antes de modificar cualquier página de datos, los cambios se escriben secuencialmente en el WAL:

```
1. Llega un UPDATE
2. Se escribe en WAL buffer (memoria)     ← rápido
3. WAL writer lo persiste a disco         ← fsync()
4. Backend process modifica shared_buffers
5. Background writer vuelca a disco       ← eventual
6. Checkpointer sincroniza todo           ← periódico
```

```bash
# Ver archivos WAL
ls -la $PGDATA/pg_wal/

# Configuración WAL
# wal_level = replica              # mínimo para replicación
# wal_buffers = 16MB              # buffer en memoria para WAL
# synchronous_commit = on         # espera confirmación de disco
# checkpoint_timeout = 5min       # intervalo entre checkpoints
# max_wal_size = 1GB              # tamaño máximo de WAL antes de forzar checkpoint

# En casos de baja criticidad (carga masiva):
# synchronous_commit = off        # más rápido, riesgo de perder último tx
# checkpoint_completion_target = 0.9  # distribuye el checkpoint
```

### VACUUM y Autovacuum

El **VACUUM** recupera espacio de tuplas muertas (versiones viejas de filas actualizadas/eliminadas):

```bash
# VACUUM manual
VACUUM;                                       # recupera espacio, no bloquea
VACUUM FULL;                                  # recupera espacio al OS, BLOQUEA la tabla
ANALYZE;                                      # actualiza estadísticas para el optimizador
VACUUM ANALYZE;                               # ambas operaciones

# Ver actividad de autovacuum
SELECT schemaname, tablename, n_dead_tup,
       last_autovacuum, last_autoanalyze
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000;
```

**Consejos de autovacuum:**
```sql
-- Por tabla: ajustar agresividad para tablas muy activas
ALTER TABLE pedidos SET (
    autovacuum_vacuum_scale_factor = 0.01,    -- 1% de tuplas muertas (más agresivo)
    autovacuum_vacuum_threshold = 1000        -- mínimo 1000 tuplas antes de actuar
);

-- Parámetros globales en postgresql.conf
-- autovacuum_max_workers = 3
-- autovacuum_naptime = 1min
-- autovacuum_vacuum_scale_factor = 0.2       -- 20% (default, demasiado para tablas grandes)
```

### TOAST (The Oversized-Attribute Storage Technique)

PostgreSQL mueve automáticamente valores grandes (> ~2KB) a tablas TOAST separadas:

```sql
-- Ver estrategia de almacenamiento de columnas
SELECT attname, attstorage
FROM pg_attribute
WHERE attrelid = 'mi_tabla'::regclass;

-- Estrategias: PLAIN (sin TOAST), MAIN (prefiere comprimir),
--              EXTENDED (comprime y mueve), EXTERNAL (solo mueve)
```

---

## Arquitectura de MySQL/MariaDB

MySQL usa un modelo **multi-hilo** (un hilo por conexión dentro de un solo proceso):

```
mysqld
  ├── main thread (conexiones entrantes)
  ├── hilo de red           ← maneja conexiones TCP/IP
  ├── hilo de log           ← escribe logs binarios
  ├── hilo de I/O           ← replicación: lee relay log del master
  ├── hilo de SQL           ← replicación: ejecuta eventos del relay log
  ├── hilo de purge         ← limpia versiones viejas (MVCC Innodb)
  ├── hilo master           ← tareas internas
  ├── conexión 1 (hilo)     ← un hilo por conexión
  ├── conexión 2 (hilo)
  └── conexión N (hilo)
```

### Motores de almacenamiento (MySQL/MariaDB)

| Motor | Transacciones | Bloqueo | Uso |
|---|---|---|---|
| **InnoDB** (default) | ✅ ACID | Row-level | La mayoría de aplicaciones |
| **MyISAM** | ❌ No | Table-level | Tablas estáticas, full-text search |
| **Aria** (MariaDB) | ❌ No | Table-level | Reemplazo moderno de MyISAM |
| **MyRocks** (MariaDB) | ✅ | Row-level | Alta compresión (RocksDB/LSM) |
| **Memory/HEAP** | ❌ No | Table-level | Caché, tablas temporales |
| **XtraDB** (MariaDB) | ✅ ACID | Row-level | Fork de InnoDB con mejoras |
| **Archive** | ❌ No | Row-level | Logs históricos |
| **ColumnStore** (MariaDB) | ❌ | — | Analítico, columnar |

```sql
-- Ver motor de una tabla
SHOW TABLE STATUS LIKE 'usuarios';

-- Cambiar motor
ALTER TABLE usuarios ENGINE = MyISAM;

-- Ver engine por defecto
SHOW VARIABLES LIKE 'default_storage_engine';
```

---

## Índices en profundidad

### PostgreSQL — tipos de índice

| Tipo | Comando | Cuándo usarlo |
|---|---|---|
| **B-tree** (default) | `CREATE INDEX ...` | La mayoría de casos: igualdad, rangos, orden, LIKE sin wildcard inicial |
| **Hash** | `CREATE INDEX ... USING HASH` | Solo igualdad (`=`). Rara vez mejor que B-tree |
| **GiST** | `CREATE INDEX ... USING GIST` | Búsqueda geométrica, full-text (tsvector), rangos, similitud |
| **GIN** | `CREATE INDEX ... USING GIN` | Arrays, JSONB, full-text (tsvector), búsqueda dentro de documentos |
| **BRIN** | `CREATE INDEX ... USING BRIN` | Tablas **muy grandes** (>100GB) con datos correlacionados físicamente (logs ordenados por fecha) |
| **SP-GiST** | `CREATE INDEX ... USING SPGIST` | Datos agrupados espacialmente (mapas, clústeres) |

```sql
-- B-tree: el índice estándar
CREATE INDEX idx_usuarios_email ON usuarios (email);
CREATE INDEX idx_usuarios_apellido_nombre ON usuarios (apellido, nombre);

-- GIN: búsqueda en JSONB (espectacular)
CREATE INDEX idx_productos_tags ON productos USING GIN (tags);
-- Consulta: SELECT * FROM productos WHERE tags @> '{"categoria": "electronica"}'

-- BRIN: ideal para tablas de logs (el dato físico sigue el orden lógico)
CREATE INDEX idx_logs_fecha ON logs USING BRIN (fecha)
WITH (pages_per_range = 32);
-- 100x más pequeño que B-tree en tablas grandes, pero escanea rangos

-- GiST: búsqueda geoespacial (con PostGIS)
CREATE INDEX idx_ubicaciones ON lugares USING GIST (coordenadas);
-- Consulta: SELECT * FROM lugares WHERE ST_DWithin(coordenadas, punto, 1000)

-- Parcial: solo indexa filas que cumplen la condición
CREATE INDEX idx_pedidos_activos ON pedidos (fecha)
WHERE estado = 'pendiente';
```

### MySQL/MariaDB — tipos de índice

```sql
-- B-tree (default en InnoDB)
CREATE INDEX idx_email ON usuarios (email);
CREATE INDEX idx_apellido_nombre ON usuarios (apellido, nombre);

-- FULLTEXT: búsqueda de texto completo
CREATE FULLTEXT INDEX idx_articulos ON articulos (contenido);
-- Consulta: SELECT * FROM articulos WHERE MATCH(contenido) AGAINST('linux' IN BOOLEAN MODE);

-- SPATIAL: datos geoespaciales (MyISAM, InnoDB)
CREATE SPATIAL INDEX idx_ubicacion ON lugares (coordenadas);

-- Hash (solo en MEMORY engine)
CREATE INDEX idx_hash_email ON usuarios (email) USING HASH;
```

### Cuándo NO usar índices

| Situación | Motivo |
|---|---|
| Tablas pequeñas (< 1000 filas) | El índice es más caro que el full scan |
| Columnas con pocos valores distintos (booleano, género) | Baja cardinalidad — el índice no discrimina |
| Columnas que se actualizan frecuentemente | El índice debe reconstruirse en cada UPDATE/INSERT |
| Consultas que nunca filtran por esa columna | El índice ocupa espacio sin usarse |
| `LIKE '%texto'` (wildcard al inicio) | B-tree no puede usarse así |

---

## SQL avanzado

### CTE (WITH) — Consultas con expresiones de tabla comunes

```sql
-- PostgreSQL: WITH es más potente que MySQL
WITH ventas_por_mes AS (
    SELECT
        DATE_TRUNC('month', fecha) AS mes,
        SUM(total) AS total_mes
    FROM pedidos
    GROUP BY mes
),
mejor_mes AS (
    SELECT mes, total_mes
    FROM ventas_por_mes
    ORDER BY total_mes DESC
    LIMIT 1
)
SELECT * FROM mejor_mes;
```

### CTE Recursivas (PostgreSQL)

```sql
-- Árbol jerárquico: categorías y subcategorías
WITH RECURSIVE categorias_tree AS (
    -- Caso base: categorías raíz
    SELECT id, nombre, padre_id, 1 AS nivel
    FROM categorias
    WHERE padre_id IS NULL

    UNION ALL

    -- Paso recursivo: hijos de cada categoría
    SELECT c.id, c.nombre, c.padre_id, ct.nivel + 1
    FROM categorias c
    JOIN categorias_tree ct ON c.padre_id = ct.id
)
SELECT * FROM categorias_tree ORDER BY nivel, nombre;

-- Serie de números (ejemplo clásico)
WITH RECURSIVE nums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM nums WHERE n < 10
)
SELECT * FROM nums;
```

### Window Functions — Funciones de ventana

```sql
-- Ranking dentro de grupos
SELECT
    nombre,
    departamento,
    salario,
    RANK() OVER (PARTITION BY departamento ORDER BY salario DESC) AS rank_salario,
    DENSE_RANK() OVER (PARTITION BY departamento ORDER BY salario DESC) AS dense_rank,
    ROW_NUMBER() OVER (PARTITION BY departamento ORDER BY salario DESC) AS row_num
FROM empleados;

-- Agregaciones sin GROUP BY (ventanas)
SELECT
    fecha,
    total,
    SUM(total) OVER (ORDER BY fecha) AS acumulado,
    AVG(total) OVER (ORDER BY fecha ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS media_movil_7dias,
    LAG(total, 1) OVER (ORDER BY fecha) AS dia_anterior,
    LEAD(total, 1) OVER (ORDER BY fecha) AS dia_siguiente,
    total - LAG(total, 1) OVER (ORDER BY fecha) AS diferencia_diaria
FROM ventas_diarias;
```

### EXPLAIN ANALYZE — Diagnóstico de consultas

```sql
-- PostgreSQL: muestra el plan de ejecución real
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT u.nombre, COUNT(p.id) AS total_pedidos
FROM usuarios u
LEFT JOIN pedidos p ON u.id = p.usuario_id
WHERE u.creado_en > '2025-01-01'
GROUP BY u.nombre
ORDER BY total_pedidos DESC
LIMIT 10;

-- Output típico:
-- Limit  (cost=...) (actual time=12.345..12.350 rows=10 loops=1)
--   ->  Sort  (cost=...) (actual time=12.344..12.347 rows=10 loops=1)
--         Sort Key: (count(p.id)) DESC
--         ->  GroupAggregate  (cost=...) (actual time=12.100..12.300 rows=1000 loops=1)
--               ->  Merge Left Join  (cost=...) (actual time=10.000..11.500 rows=5000 loops=1)
--                     Merge Cond: (u.id = p.usuario_id)
--                     ->  Index Scan using usuarios_creado_idx on usuarios u
--                           (actual time=0.500..5.000 rows=1000 loops=1)
--                     ->  Index Scan using pedidos_usuario_idx on pedidos p
--                           (actual time=0.300..4.000 rows=5000 loops=1)

-- Qué buscar en EXPLAIN ANALYZE:
-- ⚠️ "Seq Scan on" en tablas grandes → falta índice
-- ⚠️ "rows" estimado vs "actual rows" muy diferente → ANALYZE desactualizado
-- ⚠️ "Sort Method: external merge" → work_mem insuficiente
-- ⚠️ "actual time" alto en un solo nodo → cuello de botella
```

```sql
-- MySQL: EXPLAIN ANALYZE (8.0.18+)
EXPLAIN ANALYZE
SELECT u.nombre, COUNT(p.id)
FROM usuarios u
LEFT JOIN pedidos p ON u.id = p.usuario_id
WHERE u.creado_en > '2025-01-01'
GROUP BY u.nombre;
```

---

## Performance tuning

### PostgreSQL — Parámetros clave en postgresql.conf

```bash
# ── Memoria ──
shared_buffers = '4GB'                 # 25-40% de RAM total
effective_cache_size = '12GB'          # 50-75% de RAM total
work_mem = '64MB'                      # por operación (sort, hash, join)
maintenance_work_mem = '1GB'           # para VACUUM, CREATE INDEX
wal_buffers = '64MB'                   # buffer WAL en memoria

# ── Planificador ──
random_page_cost = 1.1                 # 4.0 para HDD, 1.1 para SSD (¡ajustar!)
effective_io_concurrency = 200         # 200 para SSD, 2 para HDD

# ── Escritura ──
synchronous_commit = on                # off para más velocidad (riesgo de pérdida)
checkpoint_timeout = '15min'
checkpoint_completion_target = 0.9
max_wal_size = '4GB'                   # entre más grande, checkpoint menos frecuente
min_wal_size = '1GB'

# ── Conexiones ──
max_connections = 100                  # cada conexión consume ~10MB
```

**Regla general:**
```bash
# Para un servidor PostgreSQL dedicado con 16GB RAM:
# shared_buffers:   ~4-6GB   (25-40%)
# effective_cache:  ~10-12GB (70-75%)
# work_mem:         ~64MB    (calcula: 16GB * 0.25 / max_connections)

# Fórmula rápida para work_mem:
# Si tienes 100 conexiones, work_mem = (RAM_total * 0.25) / 100 = ~40MB con 16GB
# Demasiado work_mem → OOM cuando todas las conexiones lo usan a la vez
```

```bash
# Ver configuración actual
psql -c "SHOW ALL;" | grep -E '(shared_buffers|work_mem|effective_cache|random_page_cost)'

# Ver qué parámetros están usando más memoria
SELECT name, setting, unit, context
FROM pg_settings
WHERE category LIKE '%Memory%';
```

### PostgreSQL — Consultas lentas

```bash
# Habilitar log de consultas lentas en postgresql.conf
log_min_duration_statement = 1000      # ms → log de consultas que tarden >1s
log_autovacuum_min_duration = 100      # ms → log de autovacuum lento
```

```sql
-- Las 10 consultas más lentas (pg_stat_statements)
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

SELECT query, calls, total_exec_time, mean_exec_time, rows
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;

-- Resetear estadísticas
SELECT pg_stat_statements_reset();
```

### MySQL/MariaDB — Parámetros clave

```ini
# /etc/mysql/mariadb.conf.d/50-server.cnf
[mysqld]
# ── Memoria ──
innodb_buffer_pool_size = 4G           # 50-70% de RAM (análogo a shared_buffers)
innodb_log_buffer_size = 64M           # buffer de redo log
key_buffer_size = 256M                 # índice de MyISAM (si usas MyISAM)

# ── Cache de consultas (deprecated en MySQL 8.0) ──
query_cache_type = 0                   # deshabilitado en MySQL 8.0+
query_cache_size = 0

# ── Conexiones ──
max_connections = 150
thread_cache_size = 8

# ── InnoDB ──
innodb_log_file_size = 1G              # tamaño del redo log
innodb_flush_log_at_trx_commit = 1     # 1=seguro, 2=rápido
innodb_flush_method = O_DIRECT         # evita doble cache (OS + InnoDB)
innodb_file_per_table = 1              # cada tabla en su propio archivo .ibd
```

```sql
-- Ver variables activas
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'max_connections';
```

---

## Transacciones y niveles de aislamiento

### PostgreSQL

```sql
-- Niveles de aislamiento:
-- READ COMMITTED   (default)  → ve solo datos commited antes de cada statement
-- REPEATABLE READ             → ve datos commited al inicio de la transacción
-- SERIALIZABLE                → las transacciones parecen ejecutarse en serie

BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT saldo FROM cuentas WHERE id = 1;
-- ... otro proceso actualiza la cuenta ...

UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;
-- ✅ En REPEATABLE READ, el SELECT ve el saldo original
-- ✅ El UPDATE funciona sobre el valor actual

COMMIT;

-- SERIALIZABLE detecta conflictos:
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT saldo FROM cuentas WHERE id = 1;
-- Si otra transacción modificó la cuenta concurrentemente:
UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;
-- ❌ ERROR: could not serialize access due to concurrent update
COMMIT;
```

### MySQL/MariaDB

```sql
-- Niveles de aislamiento en InnoDB:
-- READ UNCOMMITTED → dirty reads posibles
-- READ COMMITTED   → evita dirty reads
-- REPEATABLE READ  (default) → evita dirty y non-repeatable reads
-- SERIALIZABLE     → máximo aislamiento (bloquea lecturas)

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT saldo FROM cuentas WHERE id = 1;
-- ...
COMMIT;
```

### Tabla de anomalías por nivel

| Nivel de aislamiento | Dirty Read | Non-repeatable Read | Phantom Read | Serialization Anomaly |
|---|---|---|---|---|
| **READ UNCOMMITTED** | ❌ Posible | ❌ Posible | ❌ Posible | ❌ Posible |
| **READ COMMITTED** | ✅ Evita | ❌ Posible | ❌ Posible | ❌ Posible |
| **REPEATABLE READ** | ✅ Evita | ✅ Evita | ❌ Posible (MySQL ✅) | ❌ Posible |
| **SERIALIZABLE** | ✅ Evita | ✅ Evita | ✅ Evita | ✅ Evita |

---

## Stored Procedures y Funciones

### PostgreSQL — PL/pgSQL

```sql
-- Función que devuelve un valor
CREATE OR REPLACE FUNCTION total_pedidos_usuario(p_usuario_id INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*) INTO total
    FROM pedidos
    WHERE usuario_id = p_usuario_id;

    RETURN total;
END;
$$;

-- Llamar
SELECT total_pedidos_usuario(42);

-- Función que devuelve una tabla
CREATE OR REPLACE FUNCTION pedidos_recientes(p_dias INT)
RETURNS TABLE(id INT, total DECIMAL, fecha TIMESTAMP)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.total, p.fecha
    FROM pedidos p
    WHERE p.fecha > CURRENT_TIMESTAMP - (p_dias || ' days')::INTERVAL
    ORDER BY p.fecha DESC;
END;
$$;

-- Procedimiento (PostgreSQL 11+)
CREATE OR REPLACE PROCEDURE transferir(
    p_desde INT, p_hacia INT, p_monto DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE cuentas SET saldo = saldo - p_monto WHERE id = p_desde;
    UPDATE cuentas SET saldo = saldo + p_monto WHERE id = p_hacia;
    COMMIT;
END;
$$;

CALL transferir(1, 2, 500);
```

### MySQL/MariaDB

```sql
DELIMITER //

CREATE PROCEDURE Transferir(
    IN p_desde INT,
    IN p_hacia INT,
    IN p_monto DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    UPDATE cuentas SET saldo = saldo - p_monto WHERE id = p_desde;
    UPDATE cuentas SET saldo = saldo + p_monto WHERE id = p_hacia;
    COMMIT;
END//

DELIMITER ;

CALL Transferir(1, 2, 500);
```

---

## Triggers — Acciones automáticas

### PostgreSQL

```sql
-- Función de trigger
CREATE OR REPLACE FUNCTION actualizar_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- Trigger que se ejecuta antes de cada UPDATE
CREATE TRIGGER trg_usuarios_updated_at
    BEFORE UPDATE ON usuarios
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_updated_at();

-- Trigger de auditoría
CREATE TABLE auditoria_pedidos (
    id SERIAL PRIMARY KEY,
    pedido_id INT,
    accion TEXT,
    usuario TEXT,
    datos_viejos JSONB,
    datos_nuevos JSONB,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION auditar_pedidos()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO auditoria_pedidos (pedido_id, accion, usuario, datos_viejos, datos_nuevos)
    VALUES (
        COALESCE(NEW.id, OLD.id),
        TG_OP,
        CURRENT_USER,
        CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN row_to_json(OLD)::jsonb ELSE NULL END,
        CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN row_to_json(NEW)::jsonb ELSE NULL END
    );
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_pedidos_auditoria
    AFTER INSERT OR UPDATE OR DELETE ON pedidos
    FOR EACH ROW
    EXECUTE FUNCTION auditar_pedidos();
```

### MySQL/MariaDB

```sql
CREATE TRIGGER trg_actualizar_updated_at
    BEFORE UPDATE ON usuarios
    FOR EACH ROW
    SET NEW.updated_at = CURRENT_TIMESTAMP;

-- Trigger de auditoría
CREATE TRIGGER trg_pedidos_auditoria_insert
    AFTER INSERT ON pedidos
    FOR EACH ROW
    INSERT INTO auditoria_pedidos (pedido_id, accion, datos_nuevos)
    VALUES (NEW.id, 'INSERT', JSON_OBJECT('total', NEW.total, 'fecha', NEW.fecha));
```

---

## Full-text Search

### PostgreSQL — tsvector / tsquery

```sql
-- Crear columna tsvector
ALTER TABLE articulos ADD COLUMN contenido_busqueda tsvector;

-- Poblar con las columnas a buscar
UPDATE articulos SET contenido_busqueda =
    setweight(to_tsvector('spanish', titulo), 'A') ||
    setweight(to_tsvector('spanish', contenido), 'B');

-- Índice GIN para búsqueda rápida
CREATE INDEX idx_articulos_busqueda ON articulos USING GIN (contenido_busqueda);

-- Consultar
SELECT titulo, ts_rank(contenido_busqueda, query) AS relevancia
FROM articulos, plainto_tsquery('spanish', 'linux tutorial') AS query
WHERE contenido_busqueda @@ query
ORDER BY relevancia DESC
LIMIT 10;

-- Trigger para mantener el índice actualizado automáticamente
CREATE FUNCTION articulos_tsvector_update() RETURNS TRIGGER AS $$
BEGIN
    NEW.contenido_busqueda :=
        setweight(to_tsvector('spanish', NEW.titulo), 'A') ||
        setweight(to_tsvector('spanish', NEW.contenido), 'B');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_articulos_tsvector
    BEFORE INSERT OR UPDATE ON articulos
    FOR EACH ROW
    EXECUTE FUNCTION articulos_tsvector_update();
```

### MySQL — FULLTEXT

```sql
-- Índice FULLTEXT
CREATE FULLTEXT INDEX idx_articulos_fulltext ON articulos (titulo, contenido);

-- Búsqueda en modo natural
SELECT * FROM articulos
WHERE MATCH(titulo, contenido) AGAINST('linux tutorial');

-- Búsqueda booleana (operadores +, -, *, ", (), ~)
SELECT * FROM articulos
WHERE MATCH(titulo, contenido) AGAINST('+linux +tutorial -windows' IN BOOLEAN MODE);
```

### Comparativa full-text

| Aspecto | PostgreSQL | MySQL |
|---|---|---|
| **Indexado** | GIN (muy rápido) | B-tree especial (FULLTEXT) |
| **Idiomas** | 30+ configuraciones (stemming, stop words) | Limitado |
| **Ranking** | `ts_rank()`, `ts_rank_cd()` | Relevancia por defecto |
| **Ponderación** | `setweight()` por columna | No nativo |
| **Diccionarios** | Ispell, Snowball, Thesaurus | No |
| **Operadores** | `@@`, `&&`, `||`, `!!` | `AGAINST(... IN BOOLEAN MODE)` |
| **Rendimiento** | Excelente (GIN + ranking) | Bueno para cargas moderadas |

---

## Replicación

### PostgreSQL — Streaming Replication

```bash
# ── MASTER (primario) ──
# postgresql.conf
wal_level = replica
max_wal_senders = 5                     # número de réplicas simultáneas
wal_keep_size = 512MB                   # WAL retenido para réplicas caídas
listen_addresses = '*'                  # escuchar en todas las interfaces

# pg_hba.conf
host replication replicador 192.168.1.0/24 md5

# Crear usuario de replicación
CREATE ROLE replicador WITH REPLICATION LOGIN PASSWORD 'secreta';

# ── STANDBY (réplica) ──
# 1. Hacer backup del primario
pg_basebackup -h 192.168.1.10 -D /var/lib/postgresql/data \
    -U replicador -P -v --wal-method=stream

# 2. Crear archivo de señalización
touch /var/lib/postgresql/data/standby.signal

# 3. Configurar conexión al primario (postgresql.conf)
primary_conninfo = 'host=192.168.1.10 port=5432 user=replicador password=secreta'

# 4. Iniciar réplica
sudo systemctl start postgresql

# Verificar replicación
SELECT client_addr, state, sync_state FROM pg_stat_replication;
```

### PostgreSQL — Replicación lógica

```sql
-- Publicador (primario)
CREATE PUBLICATION mi_publicacion FOR TABLE usuarios, pedidos;
ALTER PUBLICATION mi_publicacion ADD TABLE productos;

-- Suscriptor (réplica)
CREATE SUBSCRIPTION mi_suscripcion
    CONNECTION 'host=192.168.1.10 dbname=mibase user=replicador password=secreta'
    PUBLICATION mi_publicacion;

-- Ver estado
SELECT * FROM pg_stat_subscription;
```

### MySQL/MariaDB — Replicación

```ini
# ── MASTER ──
[mysqld]
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = mibase

# ── SLAVE ──
[mysqld]
server-id = 2
replicate-do-db = mibase
```

```sql
-- MASTER: crear usuario de replicación
CREATE USER 'replicador'@'192.168.1.%' IDENTIFIED BY 'secreta';
GRANT REPLICATION SLAVE ON *.* TO 'replicador'@'192.168.1.%';

-- Ver estado del master
SHOW MASTER STATUS;

-- SLAVE: configurar replicación
CHANGE MASTER TO
    MASTER_HOST='192.168.1.10',
    MASTER_USER='replicador',
    MASTER_PASSWORD='secreta',
    MASTER_LOG_FILE='mysql-bin.000001',
    MASTER_LOG_POS=107;

START SLAVE;
SHOW SLAVE STATUS\G
```

---

## Connection Pooling

En producción, las aplicaciones no se conectan directamente a la base de datos — usan un **pool de conexiones**:

### PgBouncer (PostgreSQL)

```bash
# Instalar
sudo apt install pgbouncer

# /etc/pgbouncer/pgbouncer.ini
[databases]
mibase = host=127.0.0.1 port=5432 dbname=mibase

[pgbouncer]
listen_addr = 127.0.0.1
listen_port = 6432
auth_type = scram-sha-256
auth_file = /etc/pgbouncer/userlist.txt
pool_mode = transaction          # session | transaction | statement
default_pool_size = 25           # conexiones reales a PostgreSQL
max_client_conn = 200            # conexiones de clientes (se multiplexan)

# userlist.txt (contraseña en md5)
"juan" "md5a1b2c3d4e5f6..."
```

**Modos de pool:**

| Modo | Comportamiento |
|---|---|
| **session** | Una conexión real por conexión de cliente (pool básico) |
| **transaction** | ✅ Recomendado. La conexión se libera al terminar cada transacción |
| **statement** | Se libera tras cada sentencia. Usar solo si sabes lo que haces |

```python
# La app se conecta a PgBouncer (puerto 6432), no a PostgreSQL (5432)
conn = psycopg2.connect(
    host="localhost",
    port=6432,                # ← ¡PgBouncer!
    database="mibase",
    user="juan",
    password="secreta"
)
```

### ProxySQL (MySQL/MariaDB)

```bash
# Instalar
sudo apt install proxysql

# Configurar desde MySQL client
mysql -u admin -padmin -h 127.0.0.1 -P 6032

INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (0, '192.168.1.10', 3306);
INSERT INTO mysql_users (username, password, default_hostgroup) VALUES ('app', 'secreta', 0);
LOAD MYSQL SERVERS TO RUNTIME;
SAVE MYSQL SERVERS TO DISK;
```

---

## Migración entre motores

### De MySQL a PostgreSQL

```bash
# 1. Exportar desde MySQL
mysqldump -u root -p --compatible=postgresql --no-create-db mibase > mibase_mysql.sql

# 2. Convertir con pgloader (recomendado)
sudo apt install pgloader
pgloader mysql://root:pass@localhost/mibase postgresql:///mibase

# 3. O manualmente: ajustar tipos
#   TINYINT → SMALLINT
#   DATETIME → TIMESTAMP
#   AUTO_INCREMENT → SERIAL
#   `backticks` → "dobles comillas" o nada
#   \\ → ESCAPE con E'' o dólares $$ (en cadenas)
```

### De PostgreSQL a MySQL

```bash
# 1. Exportar desde PostgreSQL
pg_dump --column-inserts --no-owner mibase > mibase_pg.sql

# 2. Ajustes manuales:
#   SERIAL → INT AUTO_INCREMENT
#   BOOLEAN → TINYINT(1)
#   ARRAY → tabla separada o JSON
#   JSONB → JSON
#   TEXT[] → no existe en MySQL, usar JSON o tabla separada
#   RETURNING → no existe en MySQL, usar LAST_INSERT_ID()
```

---

## Conexión desde lenguajes

### Node.js

```javascript
// PostgreSQL
const { Pool } = require('pg');
const pool = new Pool({
    host: 'localhost',
    database: 'mibase',
    user: 'juan',
    password: 'secreta',
    max: 20,                    // pool size
    idleTimeoutMillis: 30000
});
const { rows } = await pool.query('SELECT * FROM usuarios');

// MySQL
const mysql = require('mysql2/promise');
const conn = await mysql.createConnection({
    host: 'localhost',
    user: 'juan',
    database: 'mibase',
    password: 'secreta'
});
const [rows] = await conn.execute('SELECT * FROM usuarios');
```

### Go

```go
// PostgreSQL
import "github.com/jackc/pgx/v5/pgxpool"

pool, _ := pgxpool.New(ctx, "postgres://juan:secreta@localhost:5432/mibase")
rows, _ := pool.Query(ctx, "SELECT * FROM usuarios")

// MySQL
import "database/sql"
import _ "github.com/go-sql-driver/mysql"

db, _ := sql.Open("mysql", "juan:secreta@tcp(localhost:3306)/mibase")
rows, _ := db.Query("SELECT * FROM usuarios")
```

### Rust

```rust
// PostgreSQL (sqlx)
use sqlx::postgres::PgPoolOptions;

let pool = PgPoolOptions::new()
    .max_connections(5)
    .connect("postgres://juan:secreta@localhost/mibase")
    .await?;
let rows: Vec<(i32, String)> = sqlx::query_as(
    "SELECT id, nombre FROM usuarios"
).fetch_all(&pool).await?;

// MySQL (sqlx)
let pool = sqlx::mysql::MySqlPoolOptions::new()
    .max_connections(5)
    .connect("mysql://juan:secreta@localhost/mibase")
    .await?;
```

---

## Seguridad

### SSL/TLS

```bash
# PostgreSQL
# En postgresql.conf:
ssl = on
ssl_cert_file = '/etc/ssl/certs/server.crt'
ssl_key_file = '/etc/ssl/private/server.key'
ssl_ca_file = '/etc/ssl/certs/ca.crt'

# En pg_hba.conf (exigir SSL):
hostssl mibase juan 192.168.1.0/24 md5

# MySQL/MariaDB
# En 50-server.cnf:
ssl-ca = /etc/mysql/ssl/ca-cert.pem
ssl-cert = /etc/mysql/ssl/server-cert.pem
ssl-key = /etc/mysql/ssl/server-key.pem

# Verificar conexiones SSL
# PostgreSQL: SELECT * FROM pg_stat_ssl;
# MySQL:      SHOW STATUS LIKE 'Ssl_cipher';
```

### Hardening básico

```bash
# 1. Puerto no estándar
# PostgreSQL: port = 5433 (en postgresql.conf)
# MySQL:      port = 3307 (en 50-server.cnf)

# 2. Firewall
sudo ufw allow from 192.168.1.0/24 to any port 5432

# 3. Autenticación fuerte
# PostgreSQL: scram-sha-256 (el más seguro)
# En pg_hba.conf: host all all 0.0.0.0/0 scram-sha-256

# 4. Roles con mínimos privilegios
# PostgreSQL: NO INHERIT, solo los permisos necesarios
CREATE ROLE app_lectura LOGIN PASSWORD 'x';
GRANT CONNECT ON DATABASE mibase TO app_lectura;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_lectura;

# 5. Cifrado en reposo (LUKS)
# La forma más simple: cifrar el disco/partición donde está PGDATA
```

---

## Instalación

### PostgreSQL

```bash
# Debian/Ubuntu
sudo apt install postgresql postgresql-contrib

# Arch Linux
sudo pacman -S postgresql

# Fedora/RHEL
sudo dnf install postgresql-server postgresql-contrib

# Inicializar (primera vez en Arch/Fedora)
sudo su - postgres -c "initdb --locale $LANG -D /var/lib/postgres/data"
# En Debian/Ubuntu se hace automáticamente

# Iniciar servicio
sudo systemctl enable --now postgresql

# Verificar versión
psql --version
```

### MySQL / MariaDB

```bash
# Debian/Ubuntu — MariaDB (reemplazo directo de MySQL)
sudo apt install mariadb-server mariadb-client

# Arch Linux — MariaDB
sudo pacman -S mariadb
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mariadb

# Fedora/RHEL
sudo dnf install mariadb-server mariadb
sudo systemctl enable --now mariadb

# Si prefieres MySQL de Oracle (no MariaDB):
# sudo apt install mysql-server mysql-client

# Verificar versión
mysql --version

# Ejecutar script de seguridad
sudo mysql_secure_installation
```

---

## Primeros pasos

### PostgreSQL

```bash
# Acceder (por defecto solo local, usuario postgres)
sudo -u postgres psql

# Crear usuario y base de datos
CREATE USER juan WITH PASSWORD 'secreta';
CREATE DATABASE mibase OWNER juan;
GRANT ALL PRIVILEGES ON DATABASE mibase TO juan;

# Salir
\q

# Conectar con el nuevo usuario
psql -h localhost -U juan -d mibase
```

### MySQL/MariaDB

```bash
# Acceder como root (con sudo)
sudo mysql

# Crear usuario y base de datos
CREATE USER 'juan'@'localhost' IDENTIFIED BY 'secreta';
CREATE DATABASE mibase;
GRANT ALL PRIVILEGES ON mibase.* TO 'juan'@'localhost';
FLUSH PRIVILEGES;

# Salir (con sudo requiere ; después del exit)
exit;

# Conectar
mysql -u juan -p mibase
```

---

## Comandos esenciales

### PostgreSQL (psql)

| Comando psql | Descripción |
|---|---|
| `\l` | Listar bases de datos |
| `\c mibase` | Conectar a base de datos |
| `\dt` | Listar tablas |
| `\d tabla` | Describir tabla (columnas, tipos, índices, triggers, constraints) |
| `\di` | Listar índices |
| `\du` | Listar usuarios/roles |
| `\dn` | Listar esquemas |
| `\df` | Listar funciones |
| `\dv` | Listar vistas |
| `\x` | Vista expandida (columnas verticales) |
| `\i archivo.sql` | Ejecutar script SQL |
| `\copy tabla TO 'file.csv' CSV` | Exportar tabla a CSV |
| `\timing` | Activar medición de tiempo de consultas |
| `\e` | Abrir editor externo para consulta larga |
| `\watch 1` | Repetir consulta cada 1 segundo |
| `\q` | Salir |

### MySQL/MariaDB (mysql client)

| Comando mysql | Descripción |
|---|---|
| `SHOW DATABASES;` | Listar bases de datos |
| `USE mibase;` | Conectar a base de datos |
| `SHOW TABLES;` | Listar tablas |
| `DESCRIBE tabla;` | Describir tabla |
| `SHOW INDEX FROM tabla;` | Listar índices |
| `SHOW CREATE TABLE tabla;` | Ver SQL de creación de la tabla |
| `SHOW GRANTS FOR 'user'@'host';` | Ver permisos de usuario |
| `SHOW PROCESSLIST;` | Consultas activas |
| `SHOW ENGINE INNODB STATUS\G` | Estado interno de InnoDB |
| `status;` | Estado del servidor |
| `\G` | Formato vertical en lugar de tabla |
| `source archivo.sql;` | Ejecutar script SQL |
| `SELECT * INTO OUTFILE 'file.csv' ...` | Exportar a CSV |
| `exit;` | Salir |

---

## Operaciones básicas SQL

```sql
-- Crear tabla
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,              -- PostgreSQL
    -- id INT AUTO_INCREMENT PRIMARY KEY,  -- MySQL
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar
INSERT INTO usuarios (nombre, email) VALUES ('Ana', 'ana@ejemplo.com');
INSERT INTO usuarios (nombre, email) VALUES ('Luis', 'luis@ejemplo.com')
    ON CONFLICT (email) DO UPDATE SET nombre = EXCLUDED.nombre;  -- PostgreSQL
    -- ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);  -- MySQL

-- Consultar
SELECT * FROM usuarios;
SELECT * FROM usuarios WHERE nombre LIKE 'A%';

-- Actualizar
UPDATE usuarios SET email = 'ana.nueva@ejemplo.com' WHERE id = 1;

-- Eliminar
DELETE FROM usuarios WHERE id = 1;

-- Unir tablas
SELECT u.nombre, p.titulo
FROM usuarios u
JOIN publicaciones p ON u.id = p.usuario_id;
```

---

## Gestión de usuarios y permisos

### PostgreSQL

```sql
-- Crear rol con login
CREATE ROLE juan LOGIN PASSWORD 'secreta';

-- Permisos a nivel de base de datos
GRANT CONNECT ON DATABASE mibase TO juan;
GRANT USAGE ON SCHEMA public TO juan;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO juan;

-- Permisos para futuras tablas
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT ON TABLES TO juan;

-- Grupo de roles (herencia)
CREATE ROLE lectores;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO lectores;
GRANT lectores TO juan;

-- Ver permisos
\du
\dp tabla
SELECT * FROM information_schema.table_privileges WHERE table_name = 'usuarios';
```

### MySQL/MariaDB

```sql
-- Crear usuario
CREATE USER 'juan'@'localhost' IDENTIFIED BY 'secreta';

-- Permisos granulares
GRANT SELECT, INSERT, UPDATE ON mibase.* TO 'juan'@'localhost';
GRANT ALL PRIVILEGES ON mibase.* TO 'juan'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

-- Acceso remoto (no localhost)
CREATE USER 'app'@'192.168.1.%' IDENTIFIED BY 'secreta';
GRANT SELECT ON mibase.* TO 'app'@'192.168.1.%';

-- Ver permisos
SHOW GRANTS FOR 'juan'@'localhost';
```

---

## Configuración remota

### PostgreSQL

```bash
# Editar postgresql.conf
sudo nano /etc/postgresql/*/main/postgresql.conf
# listen_addresses = 'localhost' → listen_addresses = '*'

# Editar pg_hba.conf (control de acceso)
sudo nano /etc/postgresql/*/main/pg_hba.conf
# Añadir:
# host    mibase    juan    192.168.1.0/24    scram-sha-256
# host    all       all     0.0.0.0/0         scram-sha-256  # ⚠️ solo con firewall

sudo systemctl restart postgresql
```

### MySQL/MariaDB

```bash
# Editar configuración
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf   # MariaDB
# bind-address = 127.0.0.1 → bind-address = 0.0.0.0

sudo systemctl restart mariadb
```

---

## Backups y restauración

### PostgreSQL

```bash
# Backup de una base de datos
pg_dump mibase > mibase_backup.sql
pg_dump -h localhost -U juan mibase > mibase_backup.sql

# Backup comprimido
pg_dump mibase | gzip > mibase_backup.sql.gz

# Backup de todas las bases
pg_dumpall > todas_backup.sql

# Backup en formato custom (compresión + paralelo)
pg_dump -Fc -j 4 mibase > mibase_backup.dump   # -j 4 = 4 hilos
pg_restore -j 4 -d mibase mibase_backup.dump    # restaura en paralelo

# Restaurar
psql mibase < mibase_backup.sql
psql -U juan -d mibase < mibase_backup.sql
gunzip -c mibase_backup.sql.gz | psql mibase
```

### MySQL/MariaDB

```bash
# Backup
mysqldump -u root -p mibase > mibase_backup.sql
mysqldump -u root -p --all-databases > todas_backup.sql
mysqldump -u root -p mibase | gzip > mibase_backup.sql.gz

# Backup de todas las tablas en archivos separados
for table in $(mysql -u root -p -N -e "SHOW TABLES FROM mibase"); do
    mysqldump -u root -p mibase "$table" > "backup_${table}.sql"
done

# Restaurar
mysql -u root -p mibase < mibase_backup.sql
gunzip -c mibase_backup.sql.gz | mysql -u root -p mibase
```

---

## Rendimiento y monitoreo

### PostgreSQL

```bash
# Consultas lentas (en postgresql.conf)
# log_min_duration_statement = 1000  # ms

# Ver consultas activas
SELECT pid, query, state, age(now(), query_start) AS tiempo,
       wait_event_type, wait_event
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY tiempo DESC;

# Tamaño de bases de datos
SELECT datname, pg_size_pretty(pg_database_size(datname))
FROM pg_database
ORDER BY pg_database_size(datname) DESC;

# Top 10 tablas por tamaño
SELECT schemaname, tablename,
       pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
LIMIT 10;

# Índices no usados
SELECT schemaname, tablename, indexname,
       pg_size_pretty(pg_relation_size(indexrelid)) AS size
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY pg_relation_size(indexrelid) DESC;
```

### MySQL/MariaDB

```sql
-- Ver consultas activas
SHOW FULL PROCESSLIST;

-- Tamaño de bases de datos
SELECT table_schema AS db,
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS size_mb
FROM information_schema.tables
GROUP BY table_schema
ORDER BY size_mb DESC;

-- Estadísticas de rendimiento
SHOW GLOBAL STATUS LIKE '%Queries%';
SHOW GLOBAL STATUS LIKE '%Connections%';
SHOW GLOBAL STATUS LIKE 'Innodb_%';

-- Consultas lentas (habilitar en config)
-- slow_query_log = 1
-- long_query_time = 2

-- Ver locks activos
SELECT * FROM information_schema.INNODB_LOCKS;
SELECT * FROM information_schema.INNODB_LOCK_WAITS;
```

---

## Docker (para desarrollo)

```yaml
# docker-compose.yml
version: '3'
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: mibase
      POSTGRES_USER: juan
      POSTGRES_PASSWORD: secreta
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    # Health check
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U juan -d mibase"]
      interval: 10s
      timeout: 5s
      retries: 5

  mysql:
    image: mariadb:11
    environment:
      MARIADB_DATABASE: mibase
      MARIADB_USER: juan
      MARIADB_PASSWORD: secreta
      MARIADB_ROOT_PASSWORD: rootpass
    ports:
      - "3306:3306"
    volumes:
      - mysqldata:/var/lib/mysql

volumes:
  pgdata:
  mysqldata:
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `psql: connection refused` | PostgreSQL no está corriendo | `sudo systemctl status postgresql` o revisar `listen_addresses` |
| `Can't connect to MySQL server` | MariaDB no está corriendo | `sudo systemctl status mariadb` |
| `FATAL: password authentication failed` | Contraseña incorrecta o pg_hba.conf restrictivo | Verificar contraseña y método en pg_hba.conf (`md5`/`scram-sha-256`) |
| `ERROR 1698 (28000): Access denied for user 'root'@'localhost'` | Root usa auth socket (no password) | Usar `sudo mysql` o cambiar a `mysql_native_password` |
| `Peer authentication failed` | pg_hba.conf espera peer (usuario del sistema) | Cambiar a `md5` o `scram-sha-256` en pg_hba.conf |
| Puerto ocupado | Otro servicio en 5432 o 3306 | `sudo ss -tulpn \| grep -E ':5432|:3306'` |
| `could not connect to server: No such file or directory` | Socket PostgreSQL no encontrado | Verificar `unix_socket_directories` en postgresql.conf |
| `Table doesn't exist` (MySQL) | Case-sensitivity de nombres | Linux distingue mayúsculas: `mi_tabla` ≠ `Mi_Tabla` |
| Espacio en disco | Logs de base de datos creciendo | Configurar `log_rotation_age` y `log_rotation_size` |
| `ERROR: out of memory` | work_mem demasiado alto para max_connections | Reducir work_mem o aumentar RAM |
| `ERROR: canceling statement due to conflict with recovery` | Réplica cancela consultas largas | Ajustar `hot_standby_feedback` en la réplica |
| Bloqueo por transacción larga | Una transacción abierta sin commit bloquea VACUUM | `SELECT * FROM pg_stat_activity WHERE state = 'idle in transaction'` |
| `InnoDB: Page cleaner took ...` (MySQL) | Innodb buffer pool muy grande con I/O lenta | Reducir `innodb_io_capacity` o buffers |

---

## Extensiones destacadas

### PostgreSQL

| Extensión | Propósito |
|---|---|
| **PostGIS** | Datos geoespaciales (puntos, rutas, polígonos, proyecciones) |
| **pgvector** | Búsqueda vectorial (embeddings, IA, similitud semántica) |
| **TimescaleDB** | Series temporales (métricas, IoT, datos financieros) |
| **pg_partman** | Particionamiento automático de tablas |
| **pg_stat_statements** | Estadísticas de consultas (imprescindible para performance) |
| **uuid-ossp** | Generación de UUIDs (v1, v4) |
| **pgcrypto** | Funciones criptográficas (hash, cifrado, PGP) |
| **ltree** | Estructuras jerárquicas (árboles, categorías) |
| **pg_stat_monitor** | Estadísticas avanzadas de consultas |
| **hypopg** | Índices hipotéticos (probar índices sin crearlos) |
| **pg_hint_plan** | Forzar planes de ejecución (hints de optimizador) |
| **pg_bigm** | Full-text search para idiomas CJK (chino, japonés, coreano) |
| **pgAudit** | Auditoría detallada de consultas |
| **auto_explain** | Log automático de planes EXPLAIN para consultas lentas |

### MySQL/MariaDB

| Motor/Extensión | Propósito |
|---|---|
| **Aria** | Motor transaccional, reemplazo de MyISAM |
| **MyRocks** | Motor basado en RocksDB (Facebook), alta compresión |
| **Galera** | Replicación síncrona multi-maestro |
| **Spider** | Sharding y particionamiento |
| **CONNECT** | Conectar a fuentes externas (CSV, XML, ODBC, MongoDB) |
| **Spider** | Sharding y federación de tablas |
| **ColumnStore** | Motor columnar para analítica |

---

## Dónde están los archivos

| Archivo | PostgreSQL | MySQL/MariaDB |
|---|---|---|
| **Config principal** | `/etc/postgresql/*/main/postgresql.conf` | `/etc/mysql/mariadb.conf.d/50-server.cnf` |
| **Control de acceso** | `/etc/postgresql/*/main/pg_hba.conf` | — (GRANT commands) |
| **Datadir** | `/var/lib/postgresql/*/main/` | `/var/lib/mysql/` |
| **Logs** | `/var/log/postgresql/postgresql-*.log` | `/var/log/mysql/` |
| **Socket** | `/var/run/postgresql/.s.PGSQL.5432` | `/var/run/mysqld/mysqld.sock` |
| **WAL** | `/var/lib/postgresql/*/main/pg_wal/` | `/var/lib/mysql/ib_logfile*` |

---

## Ver también

- [[Python en Linux]] — conexión desde Python (psycopg2, pymysql, SQLAlchemy)
- [[Docker]] — contenedores PostgreSQL/MySQL con docker-compose
- [[Backups (borg restic duplicity rsync)]] — estrategias de backup de bases de datos
- [[Desarrollo en Linux (gcc make gdb strace)]] — toolchain de desarrollo
- [[Nginx]] — servidor web conectado a backend con base de datos
- [[systemd]] — gestión de servicios de base de datos
- [[Kubernetes]] — StatefulSets para bases de datos en K8s

## Enlaces externos

- [PostgreSQL — Documentación oficial](https://www.postgresql.org/docs/)
- [PostgreSQL — Wikibook](https://en.wikibooks.org/wiki/PostgreSQL)
- [MySQL — Documentación oficial](https://dev.mysql.com/doc/)
- [MariaDB — Documentación oficial](https://mariadb.com/kb/en/)
- [pgloader — Migrar MySQL a PostgreSQL](https://pgloader.io/)
- [PgBouncer — Pool de conexiones](https://www.pgbouncer.org/)
- [ProxySQL — Pool para MySQL](https://proxysql.com/)
- [Use The Index, Luke! — Guía de índices](https://use-the-index-luke.com/)
- [PostgreSQL Performance Wiki](https://wiki.postgresql.org/wiki/Performance_Optimization)
- [Arch Wiki — PostgreSQL](https://wiki.archlinux.org/title/PostgreSQL)
- [Arch Wiki — MariaDB](https://wiki.archlinux.org/title/MariaDB)

#programa #databases #sql
