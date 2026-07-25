---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
licencia: PostgreSQL (PostgreSQL license), MongoDB (SSPL)
alternativas: SQLite, MySQL, Redis, Cassandra
---

# PostgreSQL vs MongoDB

> **PostgreSQL** (SQL, relacional) y **MongoDB** (NoSQL, documental) son las dos bases de datos open source más populares del mundo, pero representan filosofías opuestas. Esta nota te ayuda a decidir cuál usar — y cómo migrar entre ambas cuando te equivocaste.

```text
                   ┌─────────────────────────────┐
                   │   ¿Qué base de datos usas?   │
                   └──────────────┬──────────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    ▼                           ▼
        ┌───────────────────┐       ┌───────────────────┐
        │   PostgreSQL      │       │     MongoDB        │
        │                   │       │                    │
        │  Tablas, filas,   │       │  Documentos JSON   │
        │  esquema fijo     │       │  sin esquema fijo  │
        │  Joins, ACID      │       │  Embed, array, denorm│
        │  SQL completo     │       │  Aggregation Pipe. │
        └───────────────────┘       └────────────────────┘
```

---

## 1. Filosofías opuestas

| Dimensión | PostgreSQL | MongoDB |
|---|---|---|
| **Modelo** | Relacional (tablas, filas, columnas) | Documental (colecciones, documentos BSON) |
| **Esquema** | **Estricto** — defines columnas y tipos antes de insertar | **Flexible** — cada documento puede tener campos diferentes |
| **Integridad** | Foreign keys, constraints, check, unique, not null | Se gestiona en la aplicación (no hay FKs nativas) |
| **Joins** | ✅ `JOIN` entre tablas, nativo y optimizado | ❌ No hay JOIN — usas `$lookup` (lento) o embebes datos |
| **Transacciones** | ✅ ACID completo desde 1996 | ✅ ACID multi-documento desde 4.0 (2019), más limitado |
| **Consultas** | SQL completo (CTE, window functions, subqueries, triggers) | Aggregation pipeline (potente pero menos expresivo) |
| **Escalado** | Vertical (más CPU/RAM) + réplicas de lectura | Horizontal (sharding nativo desde el diseño) |
| **Consistencia** | **Consistencia fuerte** por defecto | **Consistencia configurable** (fuerte o eventual) |
| **Flexibilidad** | Cambios requieren `ALTER TABLE` + migraciones | Añadir campos es gratis (sin migración) |
| **Curva** | Media-alta (SQL, normalización, migraciones) | Baja (empiezas a insertar JSON al instante) |

---

## 2. Modelo de datos comparado

### El mismo blog en PostgreSQL vs MongoDB

```sql
-- PostgreSQL: datos normalizados en 3 tablas
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE articulos (
    id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL REFERENCES usuarios(id),
    titulo VARCHAR(200) NOT NULL,
    contenido TEXT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    articulo_id INT NOT NULL REFERENCES articulos(id),
    autor VARCHAR(100) NOT NULL,
    texto TEXT NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Consultar artículo con autor y comentarios:
SELECT u.nombre, a.titulo, a.contenido,
       json_agg(json_build_object(
           'autor', c.autor,
           'texto', c.texto
       )) AS comentarios
FROM articulos a
JOIN usuarios u ON a.usuario_id = u.id
LEFT JOIN comentarios c ON c.articulo_id = a.id
WHERE a.id = 1
GROUP BY u.nombre, a.titulo, a.contenido;
```

```javascript
// MongoDB: el mismo blog como documento anidado
db.articulos.insertOne({
    _id: ObjectId("..."),
    titulo: "PostgreSQL vs MongoDB",
    contenido: "Ambos son excelentes, pero...",
    autor: {
        nombre: "Ana García",
        email: "ana@ejemplo.com"
    },
    comentarios: [
        { autor: "Luis", texto: "Muy buen artículo", creado_en: ISODate("...") },
        { autor: "Carlos", texto: "Me faltó la parte de escalado", creado_en: ISODate("...") }
    ],
    tags: ["bases-de-datos", "sql", "nosql"],
    creado_en: ISODate("...")
});

// Consultar — sin joins, el documento ya tiene todo:
db.articulos.findOne({ _id: ObjectId("...") })
```

### Ventajas e inconvenientes de cada enfoque

| Aspecto | Normalizado (PostgreSQL) | Embedido/Denormalizado (MongoDB) |
|---|---|---|
| **Lectura del post + comentarios** | 1 query con JOIN (rápido con índices) | 1 query directa (sin JOIN, más rápida) |
| **Añadir comentario** | INSERT en tabla comentarios (rápido) | UPDATE artículo con $push (reescribe el documento entero) |
| **Actualizar nombre de autor** | UPDATE usuarios (1 fila) | UPDATE en TODOS los artículos donde aparezca |
| **Consultar "últimos comentarios"** | SELECT con ORDER BY y LIMIT (rápido) | Consulta contra el array dentro de cada doc (más lento) |
| **Evolución del esquema** | ALTER TABLE, migraciones | Añadir campo al nuevo documento y ya |
| **Transacciones** | ✅ Nativo, cualquier operación | ✅ Desde v4.0 pero alcance limitado |

---

## 3. Cuándo usar PostgreSQL

### ✅ Buen candidato para PostgreSQL

| Escenario | Por qué PostgreSQL |
|---|---|
| **Datos financieros o de facturación** | Necesitas ACID real, rollbacks, consistencia fuerte |
| **Relaciones complejas entre entidades** | Muchos JOINs entre tablas (ERP, CRM, sistemas contables) |
| **Integridad de datos crítica** | Foreign keys, constraints CHECK, UNIQUE, triggers de validación |
| **Reportes y analítica** | SQL completo con window functions, CTE recursivas, vistas materializadas |
| **Datos geoespaciales** | PostGIS es imbatible (routing, polígonos, proyecciones) |
| **Equipo que sabe SQL** | Menos curva si el equipo ya conoce SQL |
| **Búsqueda de texto completo** | tsvector/tsquery con ranking, stemming español, diccionarios |
| **Datos que cambian de estructura lentamente** | Migraciones controladas, esquema explícito |
| **Aislamiento SERIALIZABLE** | PostgreSQL lo implementa correctamente (con detección de conflictos) |

### ❌ Mal candidato para PostgreSQL

| Escenario | Problema |
|---|---|
| **Datos con estructura impredecible** | Cada fila tiene campos distintos (catálogo de productos con atributos variables) |
| **Prototipado rápido sin esquema** | Cada cambio de schema requiere migración |
| **Escalado horizontal masivo** | PostgreSQL escala bien vertical, pero sharding es complejo (necesita extensiones como Citus) |
| **Datos puramente jerárquicos** | Un árbol de categorías con profundidad variable es molesto de modelar en SQL |

### Ejemplo: Sistema de facturación (PostgreSQL ✅)

```sql
-- PostgreSQL brilla aquí: integridad referencial, ACID, reportes
CREATE TABLE facturas (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES clientes(id),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2) NOT NULL CHECK (total > 0),
    estado TEXT NOT NULL CHECK (estado IN ('pendiente', 'pagada', 'cancelada'))
);

CREATE TABLE detalle_factura (
    id SERIAL PRIMARY KEY,
    factura_id INT NOT NULL REFERENCES facturas(id) ON DELETE CASCADE,
    producto_id INT NOT NULL REFERENCES productos(id),
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED
);

-- Transacción que garantiza consistencia
BEGIN;
INSERT INTO facturas (cliente_id, total, estado)
VALUES (42, 1500.00, 'pendiente');

INSERT INTO detalle_factura (factura_id, producto_id, cantidad, precio_unitario)
VALUES (currval('facturas_id_seq'), 101, 2, 500.00);

INSERT INTO detalle_factura (factura_id, producto_id, cantidad, precio_unitario)
VALUES (currval('facturas_id_seq'), 102, 1, 500.00);

UPDATE productos SET stock = stock - 2 WHERE id = 101;
UPDATE productos SET stock = stock - 1 WHERE id = 102;
COMMIT;

-- Reporte mensual con window functions:
SELECT
    DATE_TRUNC('month', fecha) AS mes,
    COUNT(*) AS facturas,
    SUM(total) AS ingresos,
    LAG(SUM(total)) OVER (ORDER BY DATE_TRUNC('month', fecha)) AS mes_anterior,
    SUM(total) - LAG(SUM(total)) OVER (ORDER BY DATE_TRUNC('month', fecha)) AS diferencia
FROM facturas
WHERE estado = 'pagada'
GROUP BY mes
ORDER BY mes;
```

---

## 4. Cuándo usar MongoDB

### ✅ Buen candidato para MongoDB

| Escenario | Por qué MongoDB |
|---|---|
| **Catálogo de productos** | Cada producto tiene atributos distintos (talla, color, peso, voltaje...) |
| **CMS / Plataforma de contenido** | Documentos con estructura anidada variable (blog, wiki, documentación) |
| **Logs y eventos** | Volumen masivo de escritura, estructura simple, sharding nativo |
| **Prototipado y MVPs** | Sin migraciones, iteras el modelo sobre la marcha |
| **IoT y time-series ligeros** | Colecciones por dispositivo, escrituras masivas |
| **Datos que se leen completos** | El documento contiene todo lo necesario (sin JOINs) |
| **Sistema de inventario real** | Ejemplo clásico: cada ítem tiene atributos diferentes |

### ❌ Mal candidato para MongoDB

| Escenario | Problema |
|---|---|
| **Relaciones muchos-a-muchos complejos** | Sin JOINs nativos — $lookup es lento y no escala |
| **Reportes financieros** | Transacciones multi-documento limitadas, sin rollback de schema |
| **Datos que requieren joins intensivos** | Terminas embediendo datos duplicados o haciendo $lookups lentos |
| **Integridad referencial estricta** | No hay foreign keys, la app debe gestionarlo |
| **Consultas ad-hoc complejas** | Aggregation pipeline es potente pero no es SQL |

### Ejemplo: Catálogo de productos e-commerce (MongoDB ✅)

```javascript
// MongoDB brilla aquí: cada producto tiene atributos distintos
db.productos.insertMany([
    {
        sku: "LAP-001",
        nombre: "Laptop Gamer",
        precio: 1200,
        especificaciones: {
            procesador: "Intel i7",
            ram: "32GB DDR5",
            almacenamiento: "1TB NVMe",
            gpu: "RTX 4060"
        },
        colores: ["negro", "plateado"],
        stock: 15,
        categoria: "electronica",
        etiquetas: ["gaming", "portatil"]
    },
    {
        sku: "CAM-001",
        nombre: "Cámara Mirrorless",
        precio: 850,
        especificaciones: {
            sensor: "APS-C 24MP",
            iso: "100-51200",
            video: "4K 60fps"
        },
        accesorios_incluidos: ["batería", "cargador", "correa"],
        stock: 8,
        categoria: "fotografia",
        etiquetas: ["mirrorless", "fotografia"]
    }
]);

// Consultar productos con atributos variables
db.productos.find({
    "especificaciones.procesador": { $exists: true },
    precio: { $lt: 1500 }
});

// Agregar campos a algunos productos sin afectar al resto
db.productos.updateOne(
    { sku: "LAP-001" },
    { $set: { garantia_meses: 24, peso_kg: 2.1 } }
);
// Producto CAM-001 sigue sin estos campos — y no pasa nada
```

---

## 5. Tabla de decisión rápida

| Tu problema | PostgreSQL | MongoDB | ¿Por qué? |
|---|---|---|---|
| Una app que gestiona **dinero** | ✅ **Elige** | ❌ | ACID, integridad referencial, rollbacks |
| Un **catálogo** donde cada producto tiene atributos distintos | ❌ | ✅ **Elige** | Documentos anidados, sin esquema |
| Una **red social** con amigos, posts, likes, comentarios | ✅ **Elige** | ⚠️ Posible | Relaciones complejas → PostgreSQL gana |
| Un **blog** o CMS simple | ⚠️ Posible | ✅ **Elige** | Documentos anidados = menos JOINs |
| **Analítica** de ventas con reportes complejos | ✅ **Elige** | ❌ | Window functions, CTE, SQL completo |
| **Logs** de servidor (millones/día) | ❌ | ✅ **Elige** | Escritura masiva, sharding nativo |
| **SaaS multi-tenancy** con datos variados por tenant | ⚠️ Posible | ✅ **Elige** | Esquema flexible por tenant, embedding |
| **ERP** (facturación, inventario, RRHH) | ✅ **Elige** | ❌ | JOINs constantes, integridad, reportes |
| **IoT** con millones de lecturas de sensores | ❌ | ✅ **Elige** | Time-series, sharding, escrituras masivas |
| **MVP** que necesitas lanzar en 2 semanas | ⚠️ Posible | ✅ **Elige** | Sin migraciones, iteras rápido |
| **Búsqueda geoespacial** (restaurantes cerca de mí) | ✅ **Elige** (PostGIS) | ✅ Posible (2dsphere) | PostGIS es más potente |
| **Panel en tiempo real** (estadísticas, métricas) | ⚠️ Puede | ✅ **MongoDB** | Aggregation pipeline + cambio streams |

---

## 6. Casos prácticos de migración

### Caso 1: De PostgreSQL a MongoDB — Catálogo de productos

**Escenario:** Un e-commerce empezó con PostgreSQL, pero cada vez que añadían un tipo de producto nuevo (electrónica, ropa, muebles), necesitaban `ALTER TABLE` para añadir columnas específicas. Llegaron a 15 tablas con atributos EAV (Entity-Attribute-Value).

**Síntomas del error:**
```sql
-- PostgreSQL: Modelo EAV (anti-patrón)
SELECT p.id, p.nombre, pa.nombre AS atributo, pa.valor
FROM productos p
JOIN productos_atributos pa ON p.id = pa.producto_id
WHERE p.categoria = 'electronica'
  AND pa.nombre = 'procesador'
  AND pa.valor LIKE '%i7%';
-- 5 JOINs y lento cuando hay millones de atributos
```

**Solución: Migrar a MongoDB**
```javascript
// MongoDB: un documento por producto con atributos anidados
db.productos.find({
    categoria: 'electronica',
    "especificaciones.procesador": /i7/
});
// 1 consulta, sin JOINs, con índice en especificaciones.procesador
```

**Resultado:** Consultas 10x más rápidas, sin migraciones de schema al añadir nuevos tipos de producto.

### Caso 2: De MongoDB a PostgreSQL — Sistema de facturación

**Escenario:** Una startup de fintech empezó con MongoDB porque era fácil prototipar. Cuando necesitaron reportes fiscales (IVA, retenciones, balances mensuales), la aggregation pipeline se volvió inmanejable.

**Síntomas del error:**
```javascript
// MongoDB: pipeline monstruoso para un reporte simple
db.facturas.aggregate([
    { $match: { fecha: { $gte: start, $lte: end } } },
    { $unwind: "$detalles" },
    { $lookup: { from: "clientes", localField: "cliente_id", foreignField: "_id", as: "cliente" } },
    { $unwind: "$cliente" },
    { $group: {
        _id: {
            mes: { $month: "$fecha" },
            cliente_tipo: "$cliente.tipo"
        },
        base: { $sum: { $subtract: ["$detalles.subtotal", "$detalles.iva"] } },
        iva: { $sum: "$detalles.iva" },
        total: { $sum: "$detalles.subtotal" }
    }},
    { $sort: { "_id.mes": 1 } }
]);
// 6 stages de pipeline, lento con $lookup, difícil de mantener
```

**Solución: Migrar a PostgreSQL**
```sql
-- PostgreSQL: el mismo reporte en SQL puro
SELECT
    DATE_TRUNC('month', f.fecha) AS mes,
    c.tipo AS cliente_tipo,
    SUM(df.subtotal - df.iva) AS base,
    SUM(df.iva) AS iva,
    SUM(df.subtotal) AS total
FROM facturas f
JOIN clientes c ON f.cliente_id = c.id
JOIN detalle_factura df ON df.factura_id = f.id
WHERE f.fecha BETWEEN $1 AND $2
GROUP BY mes, c.tipo
ORDER BY mes;
```

**Resultado:** Reportes 5x más rápidos, consultas mantenibles, integridad referencial.

### Caso 3: Híbrido — PostgreSQL + MongoDB

**Escenario:** Una plataforma SaaS de gestión empresarial necesita lo mejor de ambos mundos.

```text
┌─────────────────────────────────────────────────────┐
│                    Aplicación                        │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────────────────┐   ┌──────────────────┐        │
│  │   PostgreSQL     │   │    MongoDB        │        │
│  │                  │   │                   │        │
│  │  • Facturación   │   │  • Catálogo       │        │
│  │  • Usuarios      │   │  • Sesiones       │        │
│  │  • Pedidos       │   │  • Logs           │        │
│  │  • Reportes      │   │  • Preferencias   │        │
│  │  • Transacciones │   │  • Metadata       │        │
│  └──────────────────┘   └───────────────────┘        │
│                                                      │
│  ┌────────────────────────────────────┐              │
│  │         Redis (caché/colas)        │              │
│  └────────────────────────────────────┘              │
└─────────────────────────────────────────────────────┘
```

```python
# Ejemplo: la app usa PostgreSQL para los datos críticos
# y MongoDB para catálogo y metadatos

from sqlalchemy import create_engine, Column, Integer, String, Float
from sqlalchemy.orm import declarative_base
from pymongo import MongoClient
import redis

# ── PostgreSQL: datos transaccionales ──
engine_pg = create_engine("postgresql://user:pass@localhost/mipg")
Base = declarative_base()

class Pedido(Base):
    __tablename__ = 'pedidos'
    id = Column(Integer, primary_key=True)
    usuario_id = Column(Integer, nullable=False)
    total = Column(Float, nullable=False)
    estado = Column(String, default='pendiente')

# ── MongoDB: catálogo de productos ──
mongo = MongoClient("mongodb://localhost:27017")
db_catalogo = mongo.catalogo

def buscar_productos(filtro):
    return db_catalogo.productos.find(filtro).limit(20)

# ── Redis: sesiones y caché ──
r = redis.Redis()

def get_session(token):
    data = r.get(f"session:{token}")
    return json.loads(data) if data else None
```

**Caso real:** Una app que usa PostgreSQL para transacciones financieras y MongoDB para el catálogo de productos con atributos variables.

### Caso 4: Migración PostgreSQL → MongoDB con herramienta

```bash
# 1. Exportar desde PostgreSQL en formato portable
psql -d midb -c "COPY (
    SELECT json_build_object(
        'sku', p.sku,
        'nombre', p.nombre,
        'precio', p.precio,
        'categoria', c.nombre,
        'especificaciones', p.especificaciones
    )
    FROM productos p
    JOIN categorias c ON p.categoria_id = c.id
) TO '/tmp/productos.json';"

# 2. Importar a MongoDB
mongoimport --db catalogo --collection productos \
    --file /tmp/productos.json --jsonArray

# 3. Re-crear índices
mongosh catalogo --eval '
    db.productos.createIndex({ sku: 1 }, { unique: true });
    db.productos.createIndex({ categoria: 1 });
    db.productos.createIndex({ "especificaciones.procesador": 1 });
'
```

### Caso 5: Migración MongoDB → PostgreSQL con pgloader

```bash
# pgloader soporta migración directa MongoDB → PostgreSQL
cat > migrar.load << 'EOF'
LOAD DATABASE
     FROM mongodb://localhost:27017/midb
     INTO postgresql://user:pass@localhost/mipg

WITH include drop, create tables, create indexes, reset sequences,
     batch rows = 1000, batch size = 1MB

SET maintenance_work_mem to '128MB',
    work_mem to '12MB'

CAST type datetime to timestamptz,
     type objectid to text,
     type binData to bytea
;
EOF

pgloader migrar.load
```

---

## 7. Anti-patrones frecuentes

### Usar PostgreSQL cuando deberías usar MongoDB

| Anti-patrón | Lo que pasa | Alternativa |
|---|---|---|
| Modelo EAV (Entity-Attribute-Value) en PostgreSQL | Tabla `atributos` con filas clave-valor que imitan documentos | **MongoDB**: guarda los atributos como campos del documento |
| Tabla `metadata` tipo JSONB para todo lo que no encaja | Terminas con un JSONB gigante sin schema que nadie entiende | **MongoDB** o al menos define un schema JSON con CHECK |
| 20 tablas con JOINs para algo que es un documento | Consultas lentas, modelo sobre-normalizado | **MongoDB**: un documento anidado |
| Particionamiento manual o complicado para escalar | Sharding en PostgreSQL requiere Citus (extension) o lógica externa | **MongoDB**: sharding nativo |

### Usar MongoDB cuando deberías usar PostgreSQL

| Anti-patrón | Lo que pasa | Alternativa |
|---|---|---|
| Datos financieros sin transacciones | Pérdida de datos en concurrencia | **PostgreSQL**: ACID real |
| $lookup tras $lookup tras $lookup | Pipeline de 10+ stages, lento y frágil | **PostgreSQL**: JOINs nativos optimizados |
| Embeding de datos que cambian juntos | Actualizar el nombre de un autor requiere recorrer todos los posts | **PostgreSQL**: normalización + JOIN |
| Sin validación de datos en la DB | Datos inconsistentes porque la app no validó | **PostgreSQL**: CHECK, NOT NULL, FK |
| Documentos que crecen sin control | Documentos > 16MB → error de escritura | Diseñar modelo más plano o referencia |

---

## 8. Patrón híbrido: Poliglota Persistence

Usar la base de datos adecuada para cada subsistema:

```text
                     ┌──────────────────────────┐
                     │     Tu aplicación         │
                     └──────┬───────┬───────┬───┘
                            │       │       │
              ┌─────────────┘       │       └─────────────┐
              ▼                     ▼                     ▼
   ┌──────────────────┐   ┌──────────────┐   ┌──────────────────┐
   │   PostgreSQL     │   │   MongoDB    │   │     Redis        │
   │                  │   │              │   │                  │
   │ Transacciones    │   │ Catálogos    │   │ Caché, sesiones  │
   │ Usuarios/auth    │   │ Logs/eventos │   │ Colas, rate limit│
   │ Reportes         │   │ Metadata     │   │ Leaderboards     │
   │ Datos críticos   │   │ Prototipado  │   │ Contadores       │
   └──────────────────┘   └──────────────┘   └──────────────────┘
```

**Reglas del patrón híbrido:**

1. **Cada servicio elige su DB** — no fuerces una DB para todo el sistema
2. **No compartas DB entre servicios** — cada microservicio tiene su propia instancia
3. **La DB de escritura es la fuente de verdad** — cualquier cache/sincronización es secundaria
4. **Eventual consistency entre DBs** — usa colas (RabbitMQ, Redis Streams) para sincronizar

```python
# Ejemplo: crear un producto y actualizar el catálogo de búsqueda

# 1. PostgreSQL: transacción de creación (fuente de verdad)
with engine_pg.begin() as conn:
    result = conn.execute(
        text("INSERT INTO productos (nombre, precio, stock) VALUES (:n, :p, :s) RETURNING id"),
        {"n": "Laptop Gamer", "p": 1200, "s": 10}
    )
    producto_id = result.scalar()

# 2. Encolar actualización de catálogo MongoDB
r.lpush("sync:catalogo", json.dumps({
    "action": "upsert",
    "id": producto_id,
    "timestamp": time.time()
}))

import json

# Worker asíncrono (podría ser un Celery/RQ worker)
def sync_catalogo():
    while True:
        task = json.loads(r.brpop("sync:catalogo")[1])
        if task["action"] == "upsert":
            # Leer desde PostgreSQL y volcar a MongoDB
            producto = engine_pg.execute(
                text("SELECT * FROM productos WHERE id = :id"),
                {"id": task["id"]}
            ).one()
            db_catalogo.productos.update_one(
                {"_id": task["id"]},
                {"$set": dict(producto)},
                upsert=True
            )
```

---

## 9. Resumen: árbol de decisión

```text
¿Necesitas transacciones ACID complejas?
├── ✅ Sí → ¿Tus datos tienen relaciones complejas (muchos JOINs)?
│         ├── ✅ Sí → PostgreSQL
│         └── ❌ No → ¿Eres financiero/fiscal?
│                    ├── ✅ Sí → PostgreSQL
│                    └── ❌ No → MongoDB (con transacciones v4.0+)
└── ❌ No → ¿Tu esquema cambia constantemente?
            ├── ✅ Sí → MongoDB (sin migraciones)
            └── ❌ No → ¿Escalas horizontalmente?
                        ├── ✅ Sí → MongoDB (sharding nativo)
                        └── ❌ No → ¿Es un MVP rápido?
                                    ├── ✅ Sí → MongoDB
                                    └── ❌ No → PostgreSQL (seguro, fiable)

Si aún dudas: empieza con PostgreSQL. Es más fácil migrar de PostgreSQL a MongoDB
que al revés, y PostgreSQL cubre el 90% de los casos de uso.
```

---

## 10. Quick Reference: equivalencias SQL ↔ MongoDB

| PostgreSQL (SQL) | MongoDB (Aggregation) |
|---|---|
| `SELECT * FROM usuarios` | `db.usuarios.find()` |
| `WHERE edad > 30` | `{ edad: { $gt: 30 } }` |
| `ORDER BY nombre DESC LIMIT 10` | `.sort({ nombre: -1 }).limit(10)` |
| `GROUP BY ciudad` | `{ $group: { _id: "$ciudad", ... } }` |
| `COUNT(*)` | `{ $group: { _id: null, count: { $sum: 1 } } }` |
| `HAVING count > 5` | `{ $match: { count: { $gt: 5 } } }` (tras $group) |
| `JOIN ON usuarios.id = posts.user_id` | `{ $lookup: { from: "usuarios", localField: "user_id", foreignField: "_id", as: "user" } }` |
| `DISTINCT ciudad` | `db.usuarios.distinct("ciudad")` o `{ $group: { _id: "$ciudad" } }` |
| `INSERT INTO ...` | `db.col.insertOne({...})` |
| `UPDATE SET ... WHERE ...` | `db.col.updateOne({...}, { $set: {...} })` |
| `DELETE FROM ... WHERE ...` | `db.col.deleteOne({...})` |
| `CREATE INDEX ON usuarios (email)` | `db.usuarios.createIndex({ email: 1 })` |
| `ALTER TABLE ADD COLUMN ...` | Simplemente inserta documentos con el nuevo campo |
| `CREATE TABLE con FK` | No existe — referencia manual por ObjectId |

---

## Ver también

- [[PostgreSQL y MySQL]] — guía completa de PostgreSQL y MySQL/MariaDB
- [[MongoDB y NoSQL]] — guía completa de MongoDB y el ecosistema NoSQL
- [[Redis]] — caché, colas y datos en memoria
- [[SQLite]] — base de datos embebida para prototipado
- [[Docker]] — levantar PostgreSQL + MongoDB + Redis con docker-compose
- [[Python en Linux]] — conexión con psycopg2, pymongo, redis-py
- [[Docker]] — levantar PostgreSQL + MongoDB + Redis con docker-compose
- `docker-compose.yml` — ecosistema NoSQL para desarrollo local

## Enlaces externos

- [PostgreSQL — Documentación](https://www.postgresql.org/docs/)
- [MongoDB — Documentación](https://www.mongodb.com/docs/)
- [pgloader — Migrar a PostgreSQL](https://pgloader.io/)
- [MongoDB to PostgreSQL — Guía de migración](https://www.postgresql.org/docs/current/datatype-json.html)
- [Use The Index, Luke! — Optimización de consultas](https://use-the-index-luke.com/)
- [Martin Fowler — Poliglota Persistence](https://martinfowler.com/bliki/PolyglotPersistence.html)

#programa #database #sql #nosql
