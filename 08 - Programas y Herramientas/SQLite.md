---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: alta
licencia: Dominio público
alternativas: PostgreSQL, MySQL, DuckDB, LevelDB, RocksDB, Redis
---

# SQLite

> La base de datos relacional **más usada del mundo**. Está en cada teléfono Android, en cada navegador (Firefox, Chrome, Safari), en cada Mac y iPhone, en innumerables dispositivos IoT, y en aplicaciones de escritorio. No es un servidor — es una **biblioteca embebida** que lee y escribe archivos `.db` directamente.

## Qué es

SQLite no es PostgreSQL ni MySQL. No es un servidor al que te conectas por red. Es una **biblioteca en C** que tu aplicación enlaza directamente. La base de datos es un solo archivo `.db` (o `.sqlite`) en tu disco.

**Creado por D. Richard Hipp en 2000.** SQLite es el software más desplegado del planeta — se estima que hay **más de 1 billón (10¹²) de copias** activas.

### Filosofía

SQLite no compite con PostgreSQL/MySQL. Resuelve un problema diferente:

| Aspecto | SQLite | PostgreSQL / MySQL |
|---|---|---|
| **Arquitectura** | Embebida (biblioteca) | Cliente-servidor (proceso separado) |
| **Conexión** | Llamada a función | TCP/IP o socket Unix |
| **Administración** | Cero | Configuración, usuarios, backups |
| **Concurrencia** | Un escritor, múltiples lectores (WAL) | Múltiples escritores simultáneos |
| **Tamaño máx. DB** | 281 TB (práctico: ~GB) | Ilimitado (práctico: ~TB) |
| **Velocidad** | Muy rápida (sin overhead de red) | Depende de configuración y hardware |
| **Instalación** | `apt install sqlite3` | `apt install postgresql` + init + systemctl |

---

## Arquitectura — Sin servidor

```
Aplicación (Python, C, Go, Rust...)
    │
    ├── llama a sqlite3_open("mi.db")
    │
    ▼
┌─────────────────────────────────────────┐
│            SQLite Library                │
│  ┌─────────┐  ┌──────────┐              │
│  │  Core   │  │   SQL    │              │
│  │ (calls) │◄─┤ Compiler │              │
│  └────┬────┘  └──────────┘              │
│       │                                  │
│  ┌────▼────┐                             │
│  │ Backend │  ┌────────┐  ┌────────┐    │
│  │ (B-tree)├──► Pager ├──► VFS   │    │
│  └─────────┘  │(Cache) │  │(OS I/O)│    │
│               └────────┘  └────────┘    │
└─────────────────────────────────────────┘
                    │
                    ▼
        ┌─────────────────────┐
        │   mi.db (archivo)   │
        │   mi.db-wal (WAL)   │
        │   mi.db-shm (SHM)   │
        └─────────────────────┘
```

**Componentes clave:**

| Componente | Función |
|---|---|
| **Core** | Maneja conexiones, transacciones, VDBE |
| **SQL Compiler** | Tokenizador → Parser → Code Generator (genera VDBE bytecode) |
| **Backend (B-tree)** | Estructura de datos. Cada tabla/índice es un B-tree |
| **Pager** | Cache de páginas en memoria. Gestiona lectura/escritura a disco |
| **VFS** | Virtual File System. Capa de abstracción de E/S (permite `:memory:`) |

### El motor virtual de datos (VDBE)

SQLite compila SQL a **bytecode** que ejecuta una máquina virtual interna. Puedes verlo:

```sql
EXPLAIN SELECT * FROM usuarios WHERE id = 42;
-- Muestra el bytecode: OpenRead, Column, ResultRow, Next, etc.
```

---

## Modos de journal: DELETE vs WAL

### Modo DELETE (por defecto)

- Crea un archivo `-journal` temporal
- Lectores y escritores se **bloquean entre sí**
- Seguro, simple, predecible

### Modo WAL (Write-Ahead Log)

- Crea archivos `.db-wal` y `.db-shm`
- **Múltiples lectores simultáneos + un escritor** sin bloqueo
- Significativamente más rápido en concurrencia de lectura

```sql
-- Cambiar a modo WAL (recomendado para la mayoría de aplicaciones)
PRAGMA journal_mode=WAL;

-- Ver modo actual
PRAGMA journal_mode;
-- wal | delete | off | truncate | persist | memory
```

```bash
# Los archivos WAL pueden crecer con uso intensivo
# Punto de control: cuando el WAL alcanza 1000 páginas por defecto
PRAGMA wal_autocheckpoint=1000;

# Forzar checkpoint manual
PRAGMA wal_checkpoint;
```

---

## El archivo único: ¿qué hay dentro?

```bash
# Los archivos generados por SQLite
mi.db                      # base de datos principal
mi.db-wal                  # WAL (solo en modo WAL)
mi.db-shm                  # Shared Memory (solo en modo WAL, concurrente)
mi.db-journal              # Rollback journal (solo en modo DELETE)

# Ver metadatos del archivo
sqlite3 mi.db
sqlite> .database           # muestra el archivo actual
sqlite> .tables             # lista tablas
sqlite> .schema             # esquema completo
sqlite> .stats              # estadísticas de página
```

---

## SQL compatibles

SQLite soporta la mayoría del estándar SQL-92 y muchas características modernas:

| Característica | SQLite | PostgreSQL |
|---|---|---|
| **CTEs (WITH)** | ✅ | ✅ |
| **CTEs recursivas** | ✅ | ✅ |
| **Window functions** | ✅ (3.25+) | ✅ |
| **JSON** | ✅ (JSON1 extension, 3.9+) | ✅ (JSONB) |
| **Full-text search** | ✅ (FTS5) | ✅ (tsvector/tsquery) |
| **Triggers** | ✅ | ✅ |
| **Índices parciales** | ✅ | ✅ |
| **Stored procedures** | ❌ (no, pero puede emularse) | ✅ (PL/pgSQL) |
| **ALTER TABLE** | Limitado (ADD COLUMN, RENAME COLUMN) | Completo |
| **RIGHT JOIN / FULL JOIN** | ❌ (solo LEFT) | ✅ |
| **Grant/roles** | ❌ (no hay usuarios) | ✅ |

### Diferencias notables con otros RDBMS

```sql
-- Tipos: SQLite usa type affinity (no tipos estrictos)
CREATE TABLE ejemplo (
    id INTEGER PRIMARY KEY AUTOINCREMENT,  -- necesario AUTOINCREMENT
    nombre TEXT,
    edad INTEGER,
    activo INTEGER  -- SQLite no tiene BOOLEAN (0/1)
);

-- Puedes insertar cualquier tipo en cualquier columna:
INSERT INTO ejemplo VALUES ('no-es-numero', 42, 'tampoco-solo-numeros');
-- SQLite lo acepta (lo guarda como texto)
-- ⚠️ Esto no pasa en PostgreSQL/MySQL, que tienen tipos estrictos

-- UPSERT: ambas sintaxis funcionan (INSERT OR REPLACE tradicional + ON CONFLICT desde 3.24.0)
INSERT OR REPLACE INTO usuarios (id, nombre) VALUES (1, 'Ana');
INSERT INTO usuarios (id, nombre) VALUES (1, 'Ana')
    ON CONFLICT(id) DO UPDATE SET nombre = excluded.nombre;

-- LIMIT y OFFSET obligatorio en DELETE/UPDATE con límite
DELETE FROM usuarios WHERE activo = 0 LIMIT 100;

-- No existe SELECT ... FOR UPDATE (no hay bloqueo de filas)
```

---

## PRAGMAs — Configuración

Los `PRAGMA` son comandos específicos de SQLite para configuración:

```sql
-- Rendimiento
PRAGMA journal_mode=WAL;           -- modo WAL (recomendado)
PRAGMA synchronous=NORMAL;         -- 0=OFF, 1=NORMAL, 2=FULL
PRAGMA cache_size=-8000;           -- 8MB de cache negativos = KB
PRAGMA page_size=4096;             -- tamaño de página (512-65536)
PRAGMA mmap_size=268435456;        -- 256MB memory-mapped I/O
PRAGMA temp_store=MEMORY;          -- tablas temporales en RAM
PRAGMA busy_timeout=5000;          -- esperar 5s antes de dar error de bloqueo

-- Integridad
PRAGMA foreign_keys=ON;            -- habilitar claves foráneas (OFF por defecto)
PRAGMA integrity_check;            -- verificar integridad de la BD
PRAGMA quick_check;                -- verificación rápida

-- Depuración
PRAGMA compile_options;            -- con qué opciones se compiló SQLite
PRAGMA database_list;              -- bases de datos adjuntas
PRAGMA count_changes=OFF;          -- no reportar número de filas afectadas
```

```bash
# Configuración recomendada para producción (aplicación)
sqlite3 mi.db "PRAGMA journal_mode=WAL;"
sqlite3 mi.db "PRAGMA synchronous=NORMAL;"
sqlite3 mi.db "PRAGMA foreign_keys=ON;"
```

---

## Índices en SQLite

```sql
-- B-tree (único tipo de índice disponible)
CREATE INDEX idx_usuarios_email ON usuarios (email);
CREATE INDEX idx_usuarios_apellido ON usuarios (apellido, nombre);
CREATE UNIQUE INDEX idx_usuarios_email_unique ON usuarios (email);

-- Índices parciales (muy útiles)
CREATE INDEX idx_pedidos_pendientes ON pedidos (fecha)
WHERE estado = 'pendiente';

-- Índices en expresiones (3.9+)
CREATE INDEX idx_usuarios_email_dominio ON usuarios (LOWER(email));

-- Ver índices
.indices usuarios                     # en sqlite3 CLI
SELECT * FROM sqlite_master WHERE type = 'index';

-- ANALYZE para estadísticas
ANALYZE;
```

> **Solo B-tree.** No hay índices hash, GIN, GiST ni BRIN como en PostgreSQL. Para texto completo se usa FTS5 (ver más abajo).

---

## FTS5 — Full-Text Search

SQLite incluye **FTS5**, un motor de búsqueda de texto completo muy rápido:

```sql
-- Crear tabla virtual FTS5
CREATE VIRTUAL TABLE articulos_busqueda USING fts5(
    titulo,
    contenido,
    content='articulos',        -- tabla origen
    content_rowid='id'
);

-- Poblar
INSERT INTO articulos_busqueda SELECT id, titulo, contenido FROM articulos;

-- Buscar
SELECT * FROM articulos_busqueda
WHERE articulos_busqueda MATCH 'linux tutorial';

-- Operadores booleanos
SELECT * FROM articulos_busqueda
WHERE contenido MATCH 'linux AND (tutorial OR guia) NOT windows';

-- Ranking
SELECT *, rank
FROM articulos_busqueda
WHERE contenido MATCH 'linux'
ORDER BY rank;

-- Trigger para mantener sincronizado
CREATE TRIGGER articulos_ai AFTER INSERT ON articulos BEGIN
    INSERT INTO articulos_busqueda (rowid, titulo, contenido)
    VALUES (new.id, new.titulo, new.contenido);
END;
```

---

## Conexión desde lenguajes

### Python (nativo, sin dependencias)

```python
import sqlite3

# Conectar (crea el archivo si no existe)
conn = sqlite3.connect("mi.db")
conn.row_factory = sqlite3.Row   # acceder por nombre de columna

# Activar WAL + foreign keys
conn.execute("PRAGMA journal_mode=WAL")
conn.execute("PRAGMA foreign_keys=ON")

cursor = conn.cursor()
cursor.execute("CREATE TABLE IF NOT EXISTS usuarios (id INTEGER PRIMARY KEY, nombre TEXT)")
cursor.execute("INSERT INTO usuarios (nombre) VALUES (?)", ("Ana",))
conn.commit()

cursor.execute("SELECT * FROM usuarios")
rows = cursor.fetchall()
for row in rows:
    print(row["nombre"])  # con row_factory = sqlite3.Row

conn.close()
```

### Node.js

```javascript
const sqlite3 = require('better-sqlite3');  // o sql.js
const db = new sqlite3('mi.db');

db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

db.exec('CREATE TABLE IF NOT EXISTS usuarios (id INTEGER PRIMARY KEY, nombre TEXT)');
const stmt = db.prepare('INSERT INTO usuarios (nombre) VALUES (?)');
stmt.run('Ana');
const rows = db.prepare('SELECT * FROM usuarios').all();
console.log(rows);
db.close();
```

### Go

```go
import "database/sql"
import _ "github.com/mattn/go-sqlite3"

db, _ := sql.Open("sqlite3", "mi.db?_journal=WAL&_foreign_keys=on")
db.Exec("CREATE TABLE IF NOT EXISTS usuarios (id INTEGER PRIMARY KEY, nombre TEXT)")
db.Exec("INSERT INTO usuarios (nombre) VALUES (?)", "Ana")
rows, _ := db.Query("SELECT * FROM usuarios")
```

### Rust

```rust
use rusqlite::Connection;

let conn = Connection::open("mi.db")?;
conn.execute_batch("PRAGMA journal_mode=WAL; PRAGMA foreign_keys=ON;")?;
conn.execute("CREATE TABLE IF NOT EXISTS usuarios (id INTEGER PRIMARY KEY, nombre TEXT)", [])?;
conn.execute("INSERT INTO usuarios (nombre) VALUES (?1)", ["Ana"])?;
let mut stmt = conn.prepare("SELECT * FROM usuarios")?;
let rows = stmt.query_map([], |row| {
    let nombre: String = row.get("nombre")?;
    Ok(nombre)
})?;
```

---

## SQLite vs NoSQL — ¿Cuándo usar cada uno?

SQLite no es NoSQL. Es SQL puro. Pero muchas aplicaciones eligen entre una base de datos relacional embebida (SQLite) o una NoSQL (documentos, clave-valor):

| Situación | SQLite | NoSQL (MongoDB, LevelDB, Redis) |
|---|---|---|
| **Relaciones entre datos** | ✅ Joins, FK, transacciones | ❌ Datos desnormalizados |
| **Consultas complejas** | ✅ SQL completo, CTEs, window functions | ❌ Queries limitadas |
| **Integridad ACID** | ✅ Completa | ⚠️ Variable |
| **Esquema fijo** | ✅ Tipos, constraints, checks | ❌ Schema-less |
| **Prototipado rápido** | ⚠️ Hay que definir esquema | ✅ Flexibilidad |
| **Escalado horizontal** | ❌ Un solo archivo | ✅ Sharding nativo |
| **Datos jerárquicos** | ⚠️ Posible con CTEs | ✅ Documentos anidados |
| **Cache en RAM** | ❌ Disco | ✅ Redis (en RAM) |
| **Tiempo real / colas** | ❌ No es su fuerte | ✅ Redis pub/sub, colas |

### Casos de uso típicos de SQLite

| Caso de uso | ¿SQLite? | Alternativa |
|---|---|---|
| App móvil (Android/iOS) | ✅ **Estándar** | Realm, Couchbase Lite |
| Navegador web | ✅ **Ya lo usan** | — |
| App de escritorio | ✅ **Ideal** | PostgreSQL (si requieres concurrencia) |
| Sitio web bajo-medio tráfico | ✅ Hasta ~100K req/día | PostgreSQL si escala |
| Prototipado / desarrollo | ✅ **Perfecto** | La misma que en prod |
| Análisis de datos (CSVs) | ✅ **Excelente** | DuckDB (OLAP) |
| IoT / dispositivos embebidos | ✅ **Estándar** | LevelDB |
| Alta concurrencia de escritura | ❌ | PostgreSQL, MySQL |
| Aplicación multi-servidor | ❌ | PostgreSQL, MySQL |
| Big Data (>TB) | ❌ | PostgreSQL, Cassandra |
| Sistema de archivos | ✅ **SQLite como formato** | JSON, XML, binary |

---

## Cuándo NO usar SQLite

SQLite tiene limitaciones claras. No es la herramienta adecuada si:

1. **Muchos escritores concurrentes** (>10 escribiendo simultáneamente)
2. **Acceso por red** — SQLite sobre NFS/Samba da problemas de locking
3. **Muchos usuarios simultáneos** >100 conexiones
4. **Necesitas control de acceso granular** (usuarios, roles, permisos por tabla)
5. **Necesitas replicación** — no hay replicación nativa como streaming replication de PostgreSQL
6. **La base de datos es muy grande** (>100GB, aunque técnicamente soporta hasta 281 TB)
7. **Requieres ALTER TABLE complejo** (DROP COLUMN necesita recrear la tabla)

> **Caso clásico de fracaso:** poner SQLite como backend de una aplicación web con cientos de usuarios concurrentes escribiendo. La solución correcta es PostgreSQL o MySQL. SQLite brilla en escritorio, móvil, embebido y tráfico bajo/medio.

---

## Herramientas

### sqlite3 CLI

```bash
# Abrir base de datos
sqlite3 mi.db

# Comandos punto (dot-commands)
sqlite> .help               # todos los comandos
sqlite> .tables             # listar tablas
sqlite> .schema usuarios    # esquema de una tabla
sqlite> .indexes            # índices
sqlite> .databases          # bases de datos abiertas
sqlite> .dump               # volcar a SQL
sqlite> .dump usuarios      # volcar una tabla
sqlite> .output dump.sql    # redirigir salida
sqlite> .read dump.sql      # ejecutar SQL desde archivo
sqlite> .import data.csv mi_tabla  # importar CSV
sqlite> .mode column        # modo de salida
sqlite> .headers on         # mostrar cabeceras
sqlite> .stats on           # estadísticas
sqlite> .backup backup.db   # backup online
sqlite> .restore backup.db  # restaurar
sqlite> .quit
```

### DB Browser for SQLite (GUI)

```bash
sudo apt install sqlitebrowser
```

Interfaz gráfica para explorar, editar, importar/exportar y visualizar datos.

### sqlite-utils (CLI avanzada)

```bash
pipx install sqlite-utils
sqlite-utils create mi.db usuarios id:integer nombre:text --pk=id
sqlite-utils insert mi.db usuarios data.json --pk=id
sqlite-utils query mi.db "SELECT * FROM usuarios" --json
sqlite-utils enable-fts mi.db usuarios nombre
```

---

## Backups

```bash
# 1. .dump (SQL portátil)
sqlite3 mi.db .dump > backup.sql
sqlite3 mi.db < backup.sql                     # restaurar

# 2. .backup (copia online, segura)
sqlite3 mi.db ".backup backup.db"              # mientras está en uso
sqlite3 backup.db ".restore mi.db"             # restaurar

# 3. VACUUM INTO (SQLite 3.27+)
sqlite3 mi.db "VACUUM INTO 'backup.db'"        # copia optimizada

# 4. Copia directa (solo sin conexión)
cp mi.db backup.db                              # ⚠️ solo si nadie escribe

# 5. Backup programático (Python)
import sqlite3
src = sqlite3.connect('mi.db')
dst = sqlite3.connect('backup.db')
src.backup(dst)                                 # online backup API
dst.close()
src.close()
```

---

## Integridad y optimización

```bash
# Verificar integridad
sqlite3 mi.db "PRAGMA integrity_check;"
# Si devuelve "ok", la base está sana.
# Si devuelve filas con errores, hay corrupción.

# Verificar claves foráneas
sqlite3 mi.db "PRAGMA foreign_key_check;"

# Reclamar espacio (VACUUM)
sqlite3 mi.db "VACUUM;"
# Reconstruye el archivo completo, eliminando espacio no usado.

# VACUUM INTO (nueva copia sin bloquear)
sqlite3 mi.db "VACUUM INTO 'mi_reempaquetada.db';"

# Analizar estadísticas para el optimizador
sqlite3 mi.db "ANALYZE;"

# Ver tamaño de tablas
SELECT name, SUM(pgsize) AS bytes
FROM dbstat GROUP BY name ORDER BY bytes DESC;
```

---

## Comparativa: SQLite vs PostgreSQL vs MySQL

| Aspecto | SQLite | PostgreSQL | MySQL |
|---|---|---|---|
| **Arquitectura** | Embebida (biblioteca) | Servidor (procesos) | Servidor (hilos) |
| **Instalación** | `apt install sqlite3` | `apt install postgresql` + init | `apt install mariadb-server` |
| **Configuración** | Cero (PRAGMAs) | `/etc/postgresql/*/postgresql.conf` | `/etc/mysql/mariadb.conf.d/` |
| **Usuarios** | No (sistema de archivos) | Roles, permisos granulares | Usuarios, grants |
| **Red** | No (archivo local) | TCP/IP, SSL | TCP/IP, SSL |
| **Concurrencia** | Un escritor (WAL) | Múltiples escritores | Múltiples escritores |
| **Transacciones** | ACID | ACID | ACID (InnoDB) |
| **Tipos de índice** | B-tree, FTS5 | B-tree, Hash, GiST, GIN, BRIN | B-tree, Hash, FULLTEXT |
| **JSON** | Funciones, no índices | JSONB con índices GIN | JSON |
| **Extensiones** | Limitado (FTS5, JSON1) | PostGIS, pgvector, TimescaleDB | Plugins |
| **Replicación** | No nativa | Streaming, lógica, cascada | Binlog, Galera |
| **Backup online** | `.backup`, `VACUUM INTO` | `pg_dump`, `pg_basebackup` | `mysqldump`, `XtraBackup` |
| **Tamaño máx.** | ~281 TB | Ilimitado | Ilimitado |
| **Velocidad (simple)** | ⚡ Muy rápida | Media (overhead de red) | Media |
| **Velocidad (compleja)** | Media | ⚡ Muy rápida (optimizador) | Rápida |

---

## Estudio de caso: SQLite como formato de archivo

SQLite se usa como **formato de archivo** en muchos programas. En vez de inventar un formato binario propio, usan SQLite:

| Programa | Uso de SQLite |
|---|---|
| **Firefox** | Marcadores, historial, cookies, contraseñas (`places.sqlite`) |
| **Chrome/Chromium** | Historial, cookies, datos de extensiones (`History`, `Cookies`) |
| **Android** | Contactos, SMS, configuraciones (cada app tiene su `.db`) |
| **iOS/macOS** | Mensajes, notas, contactos |
| **Dropbox** | Metadata de archivos, sincronización |
| **Skype** | Historial de chat |
| **SPSS** | Formato de archivo `.sav` |
| **Airbus A350** | Base de datos embebida en sistemas de vuelo |
| **Ventiladores médicos** | Registro de datos de pacientes |

**Ventajas de SQLite como formato de archivo:**
- Un solo archivo, fácil de copiar/enviar
- Consultas SQL en vez de parsear binario
- Transacciones atómicas (el archivo nunca queda a medio escribir)
- Acceso concurrente de lectura
- Ecosistema de herramientas (sqlite3, DB Browser)
- No dependes de un servidor externo

---

## Ver también

- [[PostgreSQL y MySQL]] — servidores SQL para cuando SQLite no es suficiente
- [[Python en Linux]] — el módulo `sqlite3` viene incluido sin instalar nada
- [[Docker]] — SQLite no necesita Docker, pero a veces se usa en contenedores pequeños
- [[Backups (borg restic duplicity rsync)]] — estrategias para respaldar archivos `.db`
- [[Desarrollo en Linux (gcc make gdb strace)]] — toolchain de desarrollo con SQLite como backend

## Enlaces externos

- [SQLite — Página oficial](https://sqlite.org/)
- [SQLite — Documentación](https://sqlite.org/docs.html)
- [SQLite — Cuando usarla](https://sqlite.org/whentouse.html)
- [SQLite — Características](https://sqlite.org/features.html)
- [SQLite — FTS5](https://sqlite.org/fts5.html)
- [SQLite — PRAGMAs](https://sqlite.org/pragma.html)
- [DB Browser for SQLite](https://sqlitebrowser.org/)
- [sqlite-utils](https://sqlite-utils.datasette.io/)
- [Arch Wiki — SQLite](https://wiki.archlinux.org/title/SQLite)
- [SQLite Internals — B-tree](https://sqlite.org/fileformat2.html)

#programa #database #sql
