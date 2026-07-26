---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# PostgreSQL y MySQL — Bases de datos relacionales

Las dos bases de datos relacionales open source más utilizadas en Linux.

## Comparativa rápida

| Aspecto | PostgreSQL | MySQL / MariaDB |
|---|---|---|
| **Modelo** | ORDBMS (objetos+relacional) | RDBMS relacional |
| **ACID** | Completo desde inicio | Depende del motor (InnoDB sí) |
| **Índices** | B-tree, Hash, GiST, GIN, BRIN | B-tree, Hash, Full-text |
| **JSON** | Nativo + JSONB (indexado) | Nativo (JSON) |
| **Extensiones** | PostGIS, pgvector, TimescaleDB | Plugins limitados |
| **Arquitectura** | Multi-proceso | Multi-hilo |
| **Uso típico** | Datos complejos, geoespaciales | Web, LAMP, CRUD simple |

## Notas individuales

- [[PostgreSQL]] — base de datos avanzada (WAL, MVCC, índices GiST/GIN/BRIN)
- [[MySQL]] — base de datos web (motores InnoDB/MyISAM, replicación)

## ¿Cuál elegir?

| Si buscas... | Recomendación |
|---|---|
| Cumplimiento ACID estricto | PostgreSQL |
| Datos geoespaciales (PostGIS) | PostgreSQL |
| Búsqueda full-text avanzada | PostgreSQL (tsvector) |
| Web/LAMP tradicional | MySQL/MariaDB |
| Simplicidad y rendimiento básico | MySQL/MariaDB |
| Extensiones y custom types | PostgreSQL |
| Replicación simple | MySQL (nativa) |

## Ver también

- [[PostgreSQL vs MongoDB]] — SQL vs NoSQL
- [[SQLite]] — base de datos embebida
- [[Redis]] — caché en memoria
- [[Entorno de desarrollo Linux]] — conexión desde lenguajes

## Enlaces externos

- [Sitio oficial PostgreSQL](https://www.postgresql.org/)
- [Sitio oficial MariaDB](https://mariadb.org/)
- [Wikipedia — MySQL](https://en.wikipedia.org/wiki/MySQL)
- [Wikipedia — PostgreSQL](https://en.wikipedia.org/wiki/PostgreSQL)

#programa #base-de-datos
