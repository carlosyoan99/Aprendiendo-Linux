---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: alta
licencia: MongoDB (SSPL), Redis (BSD), Neo4j (GPLv3 / Commercial)
alternativas: PostgreSQL, SQLite, MySQL
---

# MongoDB y NoSQL

> Las bases de datos NoSQL (Not Only SQL) abarcan sistemas que **no usan el modelo relacional tabular**. En lugar de tablas, filas y joins, almacenan los datos en formatos como documentos JSON, pares clave-valor, columnas anchas o grafos. Cada uno resuelve un problema específico que SQL tradicional no aborda bien.

---

## Los 4 tipos de bases de datos NoSQL

| Tipo | Modelo | Ejemplos | Ideal para |
|---|---|---|---|
| **Documentos** | JSON/BSON anidado | MongoDB, CouchDB, Firebase | Catálogos, CMS, logs, datos flexibles |
| **Clave-Valor** | Pares key→value | Redis, Memcached, etcd | Caché, sesiones, colas, config |
| **Column-Family** | Columnas anchas | Cassandra, ScyllaDB, HBase | Series temporales, analítica masiva |
| **Grafos** | Nodos + relaciones | Neo4j, ArangoDB, Dgraph | Redes sociales, detección de fraude, recomendaciones |

### CAP Theorem — Lo que debes saber

En un sistema distribuido, solo puedes tener **2 de 3** garantías:

```text
         Consistency
         (todos ven lo mismo)
              │
              │
  Availability ─────── Partition Tolerance
  (siempre       (funciona pese a
   responde)       caídas de red)
```

| Combinación | Sistema | Comportamiento |
|---|---|---|
| **CP** | MongoDB (default), etcd, HBase | Sacrifica disponibilidad durante particiones de red |
| **AP** | Cassandra, CouchDB, Redis cluster | Sacrifica consistencia inmediata (eventual consistency) |
| **CA** | Sistemas tradicionales de un solo nodo | No existe en sistemas distribuidos reales |

> **En la práctica:** las particiones de red siempre pueden ocurrir, así que la decisión real es entre CP y AP.

---

## MongoDB — Bases de datos documentales

### Qué es

**MongoDB** es la base de datos NoSQL más popular. Almacena datos como **documentos BSON** (Binary JSON), sin esquema fijo. Creada por **MongoDB Inc.** en 2009.

```javascript
// Un documento en MongoDB (parece JSON pero es BSON)
{
    _id: ObjectId("507f1f77bcf86cd799439011"),
    nombre: "Ana García",
    email: "ana@ejemplo.com",
    direccion: {
        calle: "Av. Principal 123",
        ciudad: "Madrid",
        codigo_postal: "28001"
    },
    intereses: ["lectura", "senderismo", "linux"],
    pedidos: [
        { producto: "Laptop", total: 1200, fecha: ISODate("2026-07-01") },
        { producto: "Ratón", total: 25, fecha: ISODate("2026-07-15") }
    ],
    creado_en: ISODate("2025-01-15")
}
```

### Instalación

```bash
# Importar clave GPG de MongoDB
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
  sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

# Añadir repositorio (Ubuntu 22.04)
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
  sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt update && sudo apt install -y mongodb-org

# Iniciar servicio
sudo systemctl enable --now mongod

# Verificar
mongosh --eval "db.version()"
```

### CRUD básico

```javascript
// Usar/crear base de datos
use midb

// CREATE
db.usuarios.insertOne({
    nombre: "Ana",
    email: "ana@ejemplo.com",
    edad: 30
})

db.usuarios.insertMany([
    { nombre: "Luis", email: "luis@ejemplo.com", edad: 25 },
    { nombre: "Carlos", email: "carlos@ejemplo.com", edad: 35 }
])

// READ
db.usuarios.find()                           // todos
db.usuarios.find({ edad: { $gt: 30 } })      // filtro
db.usuarios.find({}, { nombre: 1, _id: 0 })  // proyección
db.usuarios.findOne({ email: "ana@ejemplo.com" })

// UPDATE
db.usuarios.updateOne(
    { email: "ana@ejemplo.com" },
    { $set: { edad: 31 } }
)

db.usuarios.updateMany(
    { edad: { $lt: 30 } },
    { $inc: { edad: 1 } }
)

// DELETE
db.usuarios.deleteOne({ email: "ana@ejemplo.com" })
db.usuarios.deleteMany({ edad: { $lt: 18 } })
```

### Aggregation Pipeline

El pipeline de agregación es el equivalente a `GROUP BY` + funciones de ventana en SQL:

```javascript
db.pedidos.aggregate([
    // Stage 1: filtrar (como WHERE)
    { $match: { fecha: { $gte: ISODate("2026-01-01") } } },

    // Stage 2: agrupar
    { $group: {
        _id: "$usuario_id",
        total_gastado: { $sum: "$total" },
        num_pedidos: { $sum: 1 },
        pedido_max: { $max: "$total" },
        fecha_ultimo: { $last: "$fecha" }
    }},

    // Stage 3: ordenar
    { $sort: { total_gastado: -1 } },

    // Stage 4: limitar
    { $limit: 10 },

    // Stage 5: enriquecer con datos del usuario (como JOIN)
    { $lookup: {
        from: "usuarios",
        localField: "_id",
        foreignField: "_id",
        as: "usuario"
    }},

    // Stage 6: reshapear
    { $project: {
        usuario: { $arrayElemAt: ["$usuario.nombre", 0] },
        total_gastado: 1,
        num_pedidos: 1
    }}
])
```

### Índices

```javascript
// Índice simple
db.usuarios.createIndex({ email: 1 })              // 1=ascendente, -1=descendente

// Índice compuesto (orden importa)
db.pedidos.createIndex({ usuario_id: 1, fecha: -1 })

// Índice texto
db.articulos.createIndex({ titulo: "text", contenido: "text" })
db.articulos.find({ $text: { $search: "linux tutorial" } })

// Índice geoespacial
db.lugares.createIndex({ ubicacion: "2dsphere" })
db.lugares.find({
    ubicacion: {
        $near: {
            $geometry: { type: "Point", coordinates: [-3.703, 40.416] },
            $maxDistance: 5000   // 5km
        }
    }
})

// Índice TTL (auto-expiración)
db.sesiones.createIndex({ creado_en: 1 }, { expireAfterSeconds: 3600 })

// Ver índices
db.usuarios.getIndexes()

// Explicar plan de ejecución
db.usuarios.find({ email: "ana@ejemplo.com" }).explain("executionStats")
```

### Réplicas (Replica Sets)

```javascript
// Iniciar un replica set (tres nodos)
mongod --replSet "miRS" --dbpath /data/rs1 --port 27017
mongod --replSet "miRS" --dbpath /data/rs2 --port 27018
mongod --replSet "miRS" --dbpath /data/rs3 --port 27019

// Configurar desde mongosh
rs.initiate({
    _id: "miRS",
    members: [
        { _id: 0, host: "localhost:27017" },
        { _id: 1, host: "localhost:27018" },
        { _id: 2, host: "localhost:27019", arbiterOnly: true }
    ]
})

// Ver estado
rs.status()
rs.isMaster()

// Failover automático: si el primario cae, un secundario asume
```

### Sharding (escalado horizontal)

```javascript
// mongos (router de consultas) distribuye datos entre shards
// Cada shard es un replica set
// La clave de shard determina cómo se distribuyen los datos

sh.enableSharding("midb")
sh.shardCollection("midb.pedidos", { usuario_id: "hashed" })
```

### Transacciones ACID (desde v4.0)

```javascript
const session = db.getMongo().startSession()
session.startTransaction({
    readConcern: { level: "snapshot" },
    writeConcern: { w: "majority" }
})

try {
    const cuentas = session.getDatabase("midb").cuentas
    cuentas.updateOne({ _id: 1 }, { $inc: { saldo: -100 } })
    cuentas.updateOne({ _id: 2 }, { $inc: { saldo: 100 } })
    session.commitTransaction()
} catch (e) {
    session.abortTransaction()
} finally {
    session.endSession()
}
```

---

## Redis — Clave-Valor en memoria

**Redis** es un almacén de estructura de datos en memoria, usado como caché, cola de mensajes, sesiones y base de datos en tiempo real.

### Instalación

```bash
sudo apt install redis-server
sudo systemctl enable --now redis-server
redis-cli ping                # PONG
```

### Tipos de datos

```bash
# String (el más básico)
SET usuario:1:nombre "Ana"
GET usuario:1:nombre          # "Ana"
INCR contador_visitas         # 1, 2, 3...
EXPIRE temp_data 3600         # expira en 1 hora

# List (cola FIFO/LIFO)
LPAD cola:pedidos "pedido-1"
RPUSH cola:pedidos "pedido-2"
LPOP cola:pedidos             # "pedido-1" (FIFO)
RPOP cola:pedidos             # "pedido-2" (LIFO)

# Set (valores únicos sin orden)
SADD usuarios:1:roles "admin" "editor"
SMEMBERS usuarios:1:roles     # "admin", "editor"
SISMEMBER usuarios:1:roles "admin"  # 1 (true)

# Sorted Set (ordenado por score)
ZADD leaderboard 1000 "jugador1" 800 "jugador2" 1200 "jugador3"
ZRANGE leaderboard 0 2 REV       # top 3
ZINCRBY leaderboard 50 "jugador1"

# Hash (objeto)
HSET usuario:1 nombre "Ana" edad 30 email "ana@ejemplo.com"
HGETALL usuario:1
HGET usuario:1 nombre

# Pub/Sub (editor/suscriptor)
# Terminal 1: SUSCRIBE canal:noticias
# Terminal 2: PUBLISH canal:noticias "Nueva versión de Linux 6.12"
```

### Persistencia

| Modo | Descripción | Cuándo usarlo |
|---|---|---|
| **RDB** (snapshots) | Volcado periódico en disco | Caché, datos prescindibles |
| **AOF** (Append-Only File) | Cada escritura se logea | Datos críticos (más lento) |
| **Ninguna** | Solo en RAM | Caché pura, datos temporales |

```bash
# Configuración en /etc/redis/redis.conf
save 900 1           # RDB: si hay 1 cambio en 15 min
save 300 10          # RDB: si hay 10 cambios en 5 min
save 60 10000        # RDB: si hay 10000 cambios en 1 min
appendonly yes       # AOF activado
appendfsync everysec # AOF: fsync cada segundo
```

### Casos de uso

| Caso | Código Redis |
|---|---|
| **Caché de consultas SQL** | `SETEX consulta:123 3600 "{resultado}"` |
| **Sesiones de usuario** | `SETEX session:token123 86400 "{datos}"` |
| **Rate limiting** | `INCR rate:IP:$(date +%H); EXPIRE rate:IP:$(date +%H) 3600` |
| **Cola de tareas** | `LPUSH cola:tareas "{...}"` y worker hace `BRPOP` |
| **Leaderboard** | `ZINCRBY leaderboard:game "${puntos}" "${usuario}"` |

---

## etcd — Clave-Valor consistente para infraestructura

**etcd** es un almacén clave-valor **distribuido y consistente** (CP en CAP). Usa el protocolo **Raft** para consenso. Es el cerebro de Kubernetes (almacena todo el estado del clúster).

```bash
# Instalación
sudo apt install etcd

# Comandos básicos
etcdctl put /clave "valor"
etcdctl get /clave                    # "valor"
etcdctl get / --prefix                # todas las claves con prefijo /
etcdctl watch /cambios                # observar cambios en tiempo real
etcdctl del /clave

# Usar TTL (lease)
etcdctl lease grant 60               # lease de 60 segundos
etcdctl put --lease=ID_LEASE /temp "expira"

# Ideal para: config service, service discovery, liderazgo
```

---

## Redis — Instalación en Linux

```bash
# Debian/Ubuntu
sudo apt install redis-server
sudo systemctl enable --now redis-server
redis-cli ping                # PONG

# Arch
sudo pacman -S redis
sudo systemctl enable --now redis

# Fedora
sudo dnf install redis
sudo systemctl enable --now redis
```

---

## Cassandra — Column-Family (Columnas anchas)

**Apache Cassandra** está diseñada para **escrituras masivas** y **alta disponibilidad** (AP en CAP). Usada por Netflix, Apple, Instagram.

```sql
-- Cassandra Query Language (CQL) similar a SQL
CREATE KEYSPACE midb WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 3
};

CREATE TABLE midb.pedidos (
    usuario_id UUID,
    fecha TIMESTAMP,
    total DECIMAL,
    items LIST<TEXT>,
    PRIMARY KEY (usuario_id, fecha)  -- partition key + clustering key
) WITH CLUSTERING ORDER BY (fecha DESC);

INSERT INTO midb.pedidos (usuario_id, fecha, total, items)
VALUES (uuid(), '2026-07-20', 150.00, ['laptop', 'ratón']);

SELECT * FROM midb.pedidos
WHERE usuario_id = ?;
```

| Característica | Cassandra | MongoDB |
|---|---|---|
| **Modelo CAP** | AP (disponible + tolerante) | CP (consistente) |
| **Escrituras** | Excelente (linealmente escalable) | Buenas |
| **Consultas** | Por clave primaria (modelo limitado) | Ricas (aggregation pipeline) |
| **Modelo datos** | Columnas anchas, desnormalizado | Documentos anidados |
| **Consistencia** | Eventual (configurable) | Fuerte por defecto |

---

## Cassandra — Instalación en Linux

```bash
# Añadir repositorio oficial de Apache Cassandra
echo "deb https://debian.cassandra.apache.org 41x main" | sudo tee /etc/apt/sources.list.d/cassandra.sources.list
curl -fsSL https://downloads.apache.org/cassandra/KEYS | sudo gpg --dearmor -o /usr/share/keyrings/cassandra-archive.gpg
echo "deb [signed-by=/usr/share/keyrings/cassandra-archive.gpg] https://debian.cassandra.apache.org 41x main" | sudo tee /etc/apt/sources.list.d/cassandra.list
sudo apt update && sudo apt install cassandra -y
sudo systemctl enable --now cassandra
nodetool status                # ver estado del clúster
```

---

## Neo4j — Grafos

**Neo4j** almacena datos como **nodos** (entidades) y **relaciones** (conexiones entre entidades). Usa el lenguaje **Cypher** para consultas.

```cypher
// Crear nodos y relaciones
CREATE (ana:Usuario {nombre: "Ana", edad: 30})
CREATE (luis:Usuario {nombre: "Luis", edad: 25})
CREATE (madrid:Ciudad {nombre: "Madrid"})
CREATE (ana)-[:VIVE_EN]->(madrid)
CREATE (luis)-[:VIVE_EN]->(madrid)
CREATE (ana)-[:CONOCE_A {desde: 2020}]->(luis)

// Consultar: amigos de amigos
MATCH (a:Usuario {nombre: "Ana"})-[:CONOCE_A]->(amigo)-[:CONOCE_A]->(amigo_amigo)
RETURN amigo_amigo.nombre

// Camino más corto entre dos personas
MATCH (ana:Usuario {nombre: "Ana"}), (carlos:Usuario {nombre: "Carlos"}),
      p = shortestPath((ana)-[*..6]-(carlos))
RETURN p

// Recomendación: qué ciudades visitan amigos de Ana
MATCH (ana:Usuario {nombre: "Ana"})-[:CONOCE_A]->(amigo)-[:VIVE_EN]->(ciudad)
WHERE NOT (ana)-[:VIVE_EN]->(ciudad)
RETURN ciudad.nombre, count(amigo) AS amigos_alli
ORDER BY amigos_alli DESC
```

### Casos de uso de grafos

| Problema | Solución con grafo |
|---|---|
| Red social | Amigos → amigos de amigos → recomendaciones |
| Detección de fraude | Patrones de cuentas conectadas en transacciones sospechosas |
| Motor de recomendaciones | "A los usuarios que compraron X también les gustó Y" |
| Rutas y logística | Camino más corto entre nodos en un mapa de ciudades |
| Gestión de dependencias | ¿Qué servicios se ven afectados si este nodo falla? |

### Instalación

```bash
# Neo4j Community Edition (método moderno con signed-by)
curl -fsSL https://debian.neo4j.com/neotechnology.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/neo4j.gpg
echo "deb [signed-by=/usr/share/keyrings/neo4j.gpg] https://debian.neo4j.com stable latest" | sudo tee /etc/apt/sources.list.d/neo4j.list
sudo apt update && sudo apt install neo4j -y
sudo systemctl enable --now neo4j
# Interfaz web: http://localhost:7474
```

---

## Comparativa: SQL vs NoSQL

| Aspecto | SQL (PostgreSQL, MySQL) | Documentos (MongoDB) | Clave-Valor (Redis) | Column-Family (Cassandra) | Grafos (Neo4j) |
|---|---|---|---|---|---|
| **Modelo** | Tablas + relaciones | JSON/BSON anidado | Pares key→value | Columnas anchas | Nodos + aristas |
| **Esquema** | Fijo (migraciones) | Flexible (sin esquema) | Sin esquema | Flexible | Flexible |
| **Joins** | ✅ Nativo | ❌ (embed / $lookup) | ❌ | ❌ | ✅ Nativo (relaciones) |
| **Transacciones** | ✅ ACID completo | ✅ (4.0+) | ❌ (Lua scripts) | ❌ | ✅ ACID |
| **Escalado** | Vertical (principalmente) | Horizontal (sharding) | Horizontal (cluster) | Horizontal (nativo) | Vertical / Lectura |
| **Consultas** | SQL completo | Aggregation pipeline | Comandos simples | CQL limitado | Cypher (grafos) |
| **Consistencia** | Fuerte | Configurable | Configurable | Eventual | Fuerte |
| **Rendimiento lectura** | Alto | Alto | ⚡ Altísimo (RAM) | Alto | Medio |
| **Rendimiento escritura** | Medio | Alto | ⚡ Altísimo | ⚡ Altísimo | Medio |
| **Aprendizaje** | Medio | Fácil | Fácil | Medio | Medio |

---

## ¿Cuándo usar cada tipo?

| Necesitas... | Usa... | Ejemplo |
|---|---|---|
| **Datos con estructura variable** | MongoDB | Catálogo de productos, cada uno con atributos distintos |
| **Caché ultrarrápida** | Redis | Resultados de consultas, sesiones de usuario |
| **Colas y pub/sub en tiempo real** | Redis | Notificaciones, chats, procesamiento asíncrono |
| **Config service / service discovery** | etcd | Estado de clúster Kubernetes, config centralizada |
| **Escrituras masivas (time-series)** | Cassandra | Logs de servidores, métricas IoT, eventos |
| **Relaciones complejas entre datos** | Neo4j | Red social, detección de fraude, recomendaciones |
| **Datos que caben en RAM y necesitas velocidad** | Redis | Leaderboards, contadores, rate limiting |
| **Datos geoespaciales** | MongoDB | Lugares cercanos, rutas, mapas |
| **Prototipado rápido sin esquema** | MongoDB | MVP, pruebas de concepto |
| **Transacciones ACID multi-documento** | MongoDB (4.0+) | Financiero, pedidos |

---

## ¿Cuándo NO usar NoSQL?

| Situación | Alternativa SQL |
|---|---|
| Datos con relaciones complejas y joins frecuentes | PostgreSQL |
| Esquema bien definido que no cambia | Cualquier RDBMS |
| Necesitas consultas ad-hoc complejas | PostgreSQL (SQL completo) |
| El equipo ya conoce SQL | Sigue con SQL |
| Una base de datos para todo el sistema | PostgreSQL (lo hace casi todo bien) |

---

## Resumen visual del ecosistema NoSQL

```
              ┌──────────────────────────────────────┐
              │         NoSQL Landscape               │
              ├──────────────────────────────────────┤
              │                                      │
 Documentos   │  MongoDB ●━━━━━━━━━○ CouchDB         │
              │  Firebase ○─────────○ Couchbase      │
              │                                      │
 Clave-Valor  │  Redis ●━━━━━━━━━━━○ Memcached       │
              │  etcd ●─────────────○ Riak           │
              │  DynamoDB ○─────────○               │
              │                                      │
 Columnares   │  Cassandra ●━━━━━━━━○ ScyllaDB       │
              │  HBase ○────────────○ Bigtable       │
              │                                      │
 Grafos       │  Neo4j ●━━━━━━━━━━━○ ArangoDB        │
              │  Dgraph ○───────────○ JanusGraph     │
              │                                      │
              └──────────────────────────────────────┘
  ● = sistema cubierto en esta nota
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `MongooseServer: Cannot connect to MongoDB instance` | Servidor no arrancado o puerto equivocado | `systemctl status mongod`; usar `localhost:27017`; en Docker `docker compose up -d mongodb` |
| `Authentication failed` al conectar | Usuario/contraseña incorrectos a la DB auth | Verificar con `mongosh --username ... --password ... --authenticationDatabase admin`; crear con `db.createUser` |
| `Cannot allocate memory` en instancias pequeñas | WiredTiger reserva mucha RAM | Limitar con `storage.wiredTiger.engineConfig.cacheSizeGB` en `mongod.conf` |
| Documentos muy grandes / límite 16 MB | Documento individual excede el límite BSON | Subdividir en documentos más pequeños o usar GridFS para bloques |
| Consultas lentas en colecciones grandes | Sin índices en campos filtrados | `db.collection.createIndex({ campo: 1 })`; revisar con `explain()` |
| Redis lag / eviction | Memoria limitada con LRU evicting | Configurar `maxmemory-policy` (p.ej. `noeviction`) o userextra RAM |

---

## Ver también

- [[PostgreSQL y MySQL]] — el enfoque SQL tradicional
- [[SQLite]] — base de datos SQL embebida
- [[Python en Linux]] — conexión con pymongo, redis-py, cassandra-driver
- [[Docker]] — levantar MongoDB/Redis/Cassandra/Neo4j con [`docker-compose.yml`](/docker-compose.yml) ya incluido en el proyecto
- `docker/.env.example` — variables de entorno personalizables
- `docker/mongodb/init.js` — script de inicialización con datos de ejemplo
- `docker/cassandra/init.cql` — semilla CQL con keyspace y tablas de ejemplo
- [[Kubernetes]] — etcd como cerebro del clúster, StatefulSets para bases de datos NoSQL

## Enlaces externos

- [MongoDB — Documentación](https://www.mongodb.com/docs/)
- [MongoDB — Aggregation Pipeline](https://www.mongodb.com/docs/manual/aggregation/)
- [Redis — Documentación](https://redis.io/docs/)
- [Redis — Try it online](https://try.redis.io/)
- [etcd — Documentación](https://etcd.io/docs/)
- [Cassandra — Documentación](https://cassandra.apache.org/doc/latest/)
- [Neo4j — Documentación](https://neo4j.com/docs/)
- [Neo4j — Cypher Refcard](https://neo4j.com/docs/cypher-refcard/current/)
- [CAP Theorem Explained](https://www.ibm.com/topics/cap-theorem)

#programa #nosql #database
