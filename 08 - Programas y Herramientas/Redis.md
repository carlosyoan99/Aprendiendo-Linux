---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
licencia: BSD-3-Clause
alternativas: Memcached, DragonflyDB, KeyDB, etcd
---

# Redis

> **Redis** (Remote Dictionary Server) es un almacén de estructura de datos en memoria, usado como base de datos, caché, cola de mensajes y motor de streaming. Creado por **Salvatore Sanfilippo (antirez)** en 2009, es el software más rápido del ecosistema NoSQL — la mayoría de las operaciones se ejecutan en **< 1 ms**.

```text
         ┌────────────────────────────────────┐
         │         Redis Architecture          │
         ├────────────────────────────────────┤
         │                                    │
         │   ┌─ Client ─┐  ┌─ Client ─┐      │
         │   │ (TCP/IP) │  │ (TCP/IP) │      │
         │   └────┬─────┘  └────┬─────┘      │
         │        └──────┬──────┘             │
         │               ▼                    │
         │   ┌──────────────────────┐         │
         │   │ I/O Multiplexing     │         │
         │   │ (epoll/kqueue/select)│         │
         │   └──────────┬───────────┘         │
         │              ▼                      │
         │   ┌──────────────────────┐         │
         │   │ Single-Thread Event  │         │
         │   │ Loop (comandos)      │         │
         │   └──────────┬───────────┘         │
         │              │                      │
         │   ┌──────────▼───────────┐         │
         │   │ Data Structures      │         │
         │   │ SDS · Dict · Ziplist │         │
         │   │ Skiplist · Intset    │         │
         │   │ Quicklist · Listpack │         │
         │   └──────────┬───────────┘         │
         │              │                      │
         │   ┌──────────▼───────────┐         │
         │   │ Persistence (RDB/AOF)│         │
         │   └──────────────────────┘         │
         └────────────────────────────────────┘
```

---

## 1. Arquitectura

### Single-threaded event loop

Redis procesa todos los comandos en **un solo hilo**. Esto suena contradictorio para una base de datos rápida, pero es precisamente lo que la hace rápida:

| Ventaja | Explicación |
|---|---|
| **Sin locks** | No hay mutexes, semáforos ni condiciones de carrera entre comandos. Cada comando es atómico por definición |
| **Sin context switching** | No hay cambios de contexto entre hilos — cero overhead de scheduler |
| **Cache CPU predecible** | Un solo hilo mantiene caliente la caché L1/L2 sin invalidaciones |
| **Simplicidad** | El código es mucho más simple que un sistema multi-hilo |

El truco está en **I/O Multiplexing**: Redis no bloquea esperando clientes. Usa `epoll` (Linux), `kqueue` (macOS/BSD) o `select` para monitorizar miles de conexiones simultáneas y solo procesa las que tienen datos listos.

```text
Conexiones entrantes (miles)
         │
         ▼
┌────────────────────┐
│  I/O Multiplexer   │  ← epoll_wait() — solo devuelve
│  (epoll/kqueue)    │    los sockets con datos
└────────┬───────────┘
         │ eventos listos
         ▼
┌────────────────────┐
│  Event Loop        │  ← procesa UN comando a la vez
│  (single-thread)   │    pero sin bloqueos
└────────┬───────────┘
         │
         ▼
   Respuesta al cliente
```

> **Excepción:** Desde Redis 6.0, ciertas operaciones pesadas (como `UNLINK`, `FLUSHALL ASYNC`, `AOF rewrite`) se delegan a **hilos de background** para no bloquear el event loop principal. El núcleo de comandos sigue siendo single-thread.

### Latencia típica por operación

| Operación | Latencia (localhost) |
|---|---|
| `SET` / `GET` simple | ~0.1 ms |
| `LPUSH` / `RPOP` | ~0.1 ms |
| `ZRANGE` (100 elementos) | ~0.2 ms |
| `SINTER` (2 sets de 1000) | ~0.5 ms |
| `EVAL` Lua script | depende del script |

---

## 2. Estructuras de datos internas

Redis no guarda strings planos. Por debajo usa estructuras optimizadas para memoria y velocidad:

### SDS (Simple Dynamic String)

Usado para strings. Mejora las strings de C (`char*`) en aspectos clave:

| Característica | SDS | `char*` de C |
|---|---|---|
| Longitud O(1) | ✅ guarda `len` explícitamente | ❌ necesita `strlen()` O(n) |
| Binary safe | ✅ Soporta `\0` en medio del string | ❌ `\0` termina el string |
| Buffer overflow | ✅ Siempre redimensiona automáticamente | ❌ Famoso `strcpy()` sin control |
| Pre-allocation | ✅ Reserva espacio extra para crecimiento | ❌ Hay que gestionarlo manualmente |

### Dict (Hash Table)

El diccionario que almacena todo el espacio de claves de Redis. Usa **incremental rehashing** para evitar bloqueos largos.

```text
dict[0] (activo)          dict[1] (rehash target)
┌────┬────┬────┐          ┌────┬────┬────┬────┐
│    │ptr │    │          │    │    │ptr │    │
└────┴─┬──┴────┘          └────┴────┴─┬──┴────┘
       ▼                              ▼
  ┌──────────┐                   ┌──────────┐
  │ key1→val1│                   │ key7→val7│
  │ key2→val2│                   │ key8→val8│
  └──────────┘                   └──────────┘

Rehash incremental: por cada comando que llega, mueve
4 buckets de dict[0] → dict[1] hasta que dict[0] se vacía.
```

### Skiplist (Sorted Set)

Usado en **Sorted Sets** (`ZADD`, `ZRANGE`). Es una lista enlazada con múltiples niveles que permiten saltar elementos:

```text
Level 3:  HEAD ────────────────────────────→ 60 ───→ NULL
Level 2:  HEAD ──────────→ 30 ─────────────→ 60 ───→ NULL
Level 1:  HEAD ───→ 10 ──→ 30 ──→ 40 ─────→ 60 ───→ NULL
Level 0:  HEAD → 5 → 10 → 30 → 40 → 50 → 60 → 70 → NULL
```

- **Búsqueda: O(log N)** — comparable a un árbol balanceado
- **Inserción: O(log N)** — sin rebalanceo complejo
- **Implementación: ~200 líneas de código** (vs cientos de líneas para un árbol rojo-negro)

### Ziplist / Listpack (optimización de memoria)

Para listas, hashes y sorted sets pequeños, Redis no usa las estructuras completas sino una **representación contigua y compacta**:

```text
Ziplist (estructura lineal en memoria):
┌──────┬──────┬──────┬──────┬──────┬──────┬──────┐
│ zlbytes│zltail│zllen│entry│entry│entry│zlend│
└──────┴──────┴──────┴──────┴──────┴──────┴──────┘
            Cada entry: |prevlen|encoding|data|
```

Cuando un elemento crece demasiado, Redis promociona automáticamente a la estructura completa (ej: ziplist → linked list, intset → dict).

### Intset (Set de enteros)

Usado para **Sets** que solo contienen enteros. Es un array ordenado de enteros (bits variables: 16, 32 o 64 bits). Cuando se añade un número que necesita más bits, todo el intset se promociona automáticamente.

---

## 3. Tipos de datos en profundidad

| Tipo | Comando clave | Almacena | Máximo |
|---|---|---|---|
| **String** | `SET` / `GET` | Strings, números, binario | 512 MB |
| **List** | `LPUSH` / `LRANGE` | Lista ordenada de strings | 2³² - 1 elementos |
| **Set** | `SADD` / `SMEMBERS` | Strings únicos sin orden | 2³² - 1 elementos |
| **Sorted Set** | `ZADD` / `ZRANGE` | Strings únicos con score | 2³² - 1 elementos |
| **Hash** | `HSET` / `HGETALL` | Pares campo→valor | 2³² - 1 campos |
| **Bitmap** | `SETBIT` / `GETBIT` | Array de bits | 512 MB (~4.3B bits) |
| **HyperLogLog** | `PFADD` / `PFCOUNT` | Conteo probabilístico | ~12 KB por key |
| **Geospatial** | `GEOADD` / `GEORADIUS` | Coordenadas (Sorted Set subyacente) | — |
| **Stream** | `XADD` / `XRANGE` | Log inmutable de eventos | Ilimitado |

### String

El más básico, pero con operaciones adicionales útiles:

```bash
# Operaciones con strings
SET usuario:1:nombre "Ana García"

# Contadores atómicos
SET contador 100
INCR contador              # 101
INCRBY contador 5          # 106
DECR contador              # 105

# Substrings y longitud
APPEND usuario:1:nombre " (Admin)"   # "Ana García (Admin)"
STRLEN usuario:1:nombre              # 19
GETRANGE usuario:1:nombre 0 2        # "Ana"
GETSET usuario:1:nombre "Nuevo"      # GET + SET atómico

# TTL (Time To Live) — auto-expiración
SETEX cache:consulta 3600 "{...}"    # set + expire en 1 comando
SET cache:data "{...}"
EXPIRE cache:data 3600               # expira en 1 hora
TTL cache:data                       # cuántos segundos quedan
PERSIST cache:data                   # quitar expiración
```

### List

Lista ordenada de strings. **No** es una linked list clásica — usa **quicklist**, una estructura híbrida:

```bash
# Cola FIFO (First In, First Out)
LPUSH cola:tareas "tarea-1"
LPUSH cola:tareas "tarea-2"
LPUSH cola:tareas "tarea-3"
RPOP cola:tareas              # "tarea-1" — el primero en entrar

# Pila LIFO (Last In, First Out)
RPUSH pila:acciones "accion-A"
RPUSH pila:acciones "accion-B"
RPOP pila:acciones            # "accion-B" — el último en entrar

# Rangos
LRANGE cola:tareas 0 -1       # todos los elementos
LRANGE cola:tareas 0 4        # primeros 5
LLEN cola:tareas              # longitud

# Bloqueo (ideal para workers)
BRPOP cola:tareas 0           # bloquea hasta que haya elemento (0 = infinito)
BLPOP cola:tareas 30          # bloquea 30 segundos máximo

# Rotación (útil para round-robin)
RPOPLPUSH cola:procesar cola:pendientes  # mueve elemento entre listas
```

### Set

Colección de strings únicos sin orden. Operaciones de conjunto completas:

```bash
SADD usuarios:1:roles "admin" "editor" "viewer"
SMEMBERS usuarios:1:roles                # "admin", "editor", "viewer"
SISMEMBER usuarios:1:roles "admin"       # 1 (true)
SREM usuarios:1:roles "viewer"           # eliminar
SCARD usuarios:1:roles                   # 2 (cardinalidad)

# Operaciones de conjunto
SINTER estudiantes:python estudiantes:linux    # intersección (🚀 rápido)
SUNION estudiantes:python estudiantes:linux    # unión
SDIFF estudiantes:python estudiantes:linux     # diferencia

# Aleatoriedad
SRANDMEMBER usuarios:1:roles 1                 # elemento al azar
SPOP cola:lotería                              # saca y elimina aleatorio
```

### Sorted Set (ZSet)

Como un Set pero con **score** para ordenar. La estructura que hace únicos a Redis:

```bash
# Leaderboard de juego
ZADD leaderboard:2026 1500 "jugador1"
ZADD leaderboard:2026 2300 "jugador2"
ZADD leaderboard:2026 1800 "jugador3"

# Top 3 (orden descendente)
ZREVRANGE leaderboard:2026 0 2 WITHSCORES
# 1) "jugador2" (2300)
# 2) "jugador3" (1800)
# 3) "jugador1" (1500)

# Rango por score
ZRANGEBYSCORE leaderboard:2026 1000 2000    # jugadores entre 1000 y 2000 puntos
ZCOUNT leaderboard:2026 1000 2000            # cuántos en ese rango

# Incrementar score (atómico)
ZINCRBY leaderboard:2026 50 "jugador1"      # jugador1 ahora tiene 1550

# Obtener posición (rank)
ZRANK leaderboard:2026 "jugador1"           # posición 2 (0-indexed)
ZREVRANK leaderboard:2026 "jugador1"        # posición 1 (el 2º mejor)

# Score de un elemento
ZSCORE leaderboard:2026 "jugador1"          # 1550

# Operaciones de conjunto ordenado
ZUNIONSTORE top_global 2 leaderboard:2026 leaderboard:2025 AGGREGATE MAX
ZINTERSTORE comunes 2 seguidores:1 seguidores:2  # usuarios comunes con score
```

### Hash

Objetos planos (similar a un diccionario dentro de una clave):

```bash
HSET usuario:1 nombre "Ana" edad 30 email "ana@ejemplo.com"
HGET usuario:1 nombre                       # "Ana"
HGETALL usuario:1                           # todos los campos
HMSET usuario:2 nombre "Luis" edad 25       # múltiples campos (legacy)
HSET usuario:2 nombre "Luis" edad 25        # desde Redis 4.0 hace lo mismo

# Incrementar campo numérico
HINCRBY usuario:1 puntos 100                # +100 puntos
HDEL usuario:1 email                        # eliminar campo
HEXISTS usuario:1 email                     # 0 (no existe)
HKEYS usuario:1                             # todas las claves
HVALS usuario:1                             # todos los valores
HLEN usuario:1                              # número de campos
```

### Bitmap

Operaciones a nivel de bit sobre strings. Ideales para **tracking masivo**:

```bash
# Marcar día 15 como "activo" para usuario 42
SETBIT usuarios:2026:activos 42 1

# Marcar día 15 como "login" para usuario 42
SETBIT login:2026-07-15 42 1

# Contar usuarios activos en un día
BITCOUNT login:2026-07-15                   # 150 usuarios

# Usuarios activos en ambos días (AND)
BITOP AND login:dos_dias login:2026-07-14 login:2026-07-15

# Usuarios activos en cualquier día (OR)
BITOP OR login:cualquier login:2026-07-14 login:2026-07-15

# Un bitmap de 1 M de usuarios ocupa solo ~122 KB
# Para 365 días: ~44 MB para trackear 1M usuarios por día
```

### HyperLogLog

Conteo probabilístico de elementos únicos con memoria fija (~12 KB) y error del ~0.81%:

```bash
PFADD visitas:2026-07-20 "usuario-1" "usuario-2" "usuario-3"
PFADD visitas:2026-07-20 "usuario-1"                              # duplicado ignorado
PFCOUNT visitas:2026-07-20                                        # 3

# Fusionar varios HLLs (útil para combinación)
PFADD visitas:2026-07-19 "usuario-4"
PFMERGE visitas:finde visitas:2026-07-19 visitas:2026-07-20
PFCOUNT visitas:finde                                              # 4
```

### Geospatial (GEO)

Coordenadas geográficas almacenadas como Sorted Set con codificación **Geohash**:

```bash
GEOADD lugares 2.1734 41.3851 "Barcelona"
GEOADD lugares -3.7038 40.4168 "Madrid"
GEOADD lugares -0.3763 39.4699 "Valencia"

# Distancia entre dos puntos (km, mi, ft)
GEODIST lugares "Madrid" "Barcelona" km          # ~505 km

# Puntos en un radio
GEORADIUS lugares 2.1734 41.3851 200 km          # puntos a ≤200 km de Barcelona
GEORADIUSBYMEMBER lugares "Madrid" 500 km         # con ciudad como centro

# Obtener coordenadas
GEOPOS lugares "Madrid"                           # -3.7038, 40.4168

# Hash geohash (útil para integraciones)
GEOHASH lugares "Madrid"                          # "ezj3r6k0sp0"
```

### Streams (desde Redis 5.0)

Estructura de **log inmutable y append-only**. Más potente que Pub/Sub porque los mensajes persisten:

```bash
# Añadir entradas al stream
XADD eventos:pedidos * usuario 123 accion "compra" total 150.00
XADD eventos:pedidos * usuario 456 accion "devolucion"

# * significa timestamp auto-generado (ID: 1678901234567-0)

# Leer rango
XRANGE eventos:pedidos - +                  # todos los eventos
XRANGE eventos:pedidos 1678901234567 1678901234568  # rango por ID

# Leer nuevos eventos (como tail -f)
XREAD BLOCK 0 STREAMS eventos:pedidos 0     # desde el inicio, bloqueando

# Consumer groups (procesamiento distribuido con acuse)
XGROUP CREATE eventos:pedidos grupo-workers 0  # crear grupo
XREADGROUP GROUP grupo-workers worker-1 BLOCK 2000 COUNT 10 STREAMS eventos:pedidos >
# > = solo mensajes no entregados a este worker

# Acusar recibo (ACK) — sin esto, el mensaje reaparece
XACK eventos:pedidos grupo-workers 1678901234567-0

# Ver mensajes pendientes
XPENDING eventos:pedidos grupo-workers
```

### Pub/Sub

Mensajería **fire-and-forget**: los mensajes se pierden si no hay suscriptores:

```bash
# Terminal 1 (suscriptor)
SUBSCRIBE canal:noticias
PSUBSCRIBE canal:*                           # patrón: canales que coincidan

# Terminal 2 (editor)
PUBLISH canal:noticias "¡Nueva versión de Redis 8.0!"
PUBLISH canal:alertas "CPU al 90% en servidor-1"

# Pub/Sub no persiste — si no hay suscriptor, el mensaje se pierde
```

| Característica | Pub/Sub | Streams |
|---|---|---|
| Persistencia | ❌ No persiste | ✅ Persiste en disco |
| Consumer groups | ❌ No | ✅ Sí (ACK, re-entrega) |
| Historial | ❌ No (solo en vivo) | ✅ Puedes leer desde cualquier punto |
| Rendimiento | ⚡ Más rápido | ✅ Muy rápido también |
| Ideal para | Notificaciones en vivo, broadcasting | Colas de tareas, event sourcing |

---

## 4. Persistencia (RDB vs AOF)

Redis es en memoria, pero puede persistir a disco de dos formas:

### RDB (Redis Database File)

Snapshots periódicos del dataset completo en disco:

```bash
# Configuración en redis.conf
save 900 1             # snapshot si ≥1 cambio en 900 segundos
save 300 10            # snapshot si ≥10 cambios en 300 segundos
save 60 10000          # snapshot si ≥10000 cambios en 60 segundos

# Manual
SAVE                   # snapshot SÍNCRONO (bloquea Redis)
BGSAVE                 # snapshot ASÍNCRONO (fork + child process)
LASTSAVE               # timestamp del último snapshot

# Archivos
ls /var/lib/redis/dump.rdb
```

### AOF (Append-Only File)

Cada operación de escritura se registra en un archivo de log:

```bash
# Configuración
appendonly yes                 # activar AOF
appendfsync always             # fsync por cada escritura (seguro, lento)
appendfsync everysec           # fsync cada segundo (balance)
appendfsync no                 # deja que el SO decida (rápido, menos seguro)

# AOF rewrite — compacta el log eliminando operaciones redundantes
BGREWRITEAOF

# Ejemplo de cómo se ve el AOF:
# *2
# $6
# SELECT
# $1
# 0
# *3
# $3
# SET
# ...
```

### Comparativa

| Aspecto | RDB | AOF | Ambos |
|---|---|---|---|
| **Tamaño** | Compacto | Crece (se compacta con rewrite) | El más grande |
| **Restauración** | ⚡ Muy rápida | Más lenta | Depende del tamaño |
| **Pérdida máxima** | Datos desde último snapshot | 1 segundo (`everysec`) o 0 (`always`) | Mínima |
| **Overhead escritura** | Mínimo (fork periódico) | Medio (fsync) | Medio-alto |
| **Legibilidad** | Binario (no legible) | Texto (sí, es el protocolo Redis) | — |

> **Recomendación general:** activar **ambos**. Redis los carga así: primero el AOF (más completo) y luego el RDB. Si solo puedes elegir uno, usa AOF con `appendfsync everysec` para datos importantes, o RDB si aceptas perder minutos de datos a cambio de rendimiento.

---

## 5. Transacciones y Lua Scripting

### MULTI / EXEC / WATCH

Redis no tiene transacciones ACID como SQL, pero ofrece atomicidad con `MULTI`/`EXEC`:

> ⚠️ **Importante:** a diferencia de SQL, Redis **no soporta rollback**. Si un comando dentro de una transacción falla (ej: error de tipo), los comandos restantes se ejecutan igual. No hay deshacer. Redis prioriza la velocidad y simplicidad sobre la seguridad transaccional completa.

| Comando | Qué hace |

```bash
# Transacción básica: todos los comandos se ejecutan o ninguno
MULTI
SET cuenta:a 100
SET cuenta:b 200
EXEC

# Con WATCH (optimistic locking)
WATCH cuenta:a cuenta:b          # observa estas claves
monto = GET cuenta:a             # 100
MULTI
DECRBY cuenta:a monto            # resta
INCRBY cuenta:b monto            # suma
EXEC                             # si alguien modificó cuenta:a o b, esto falla
```

| Comando | Qué hace |
|---|---|
| `MULTI` | Inicia la transacción |
| `EXEC` | Ejecuta todos los comandos en cola |
| `DISCARD` | Cancela la transacción |
| `WATCH` | Optimistic lock: EXEC falla si las claves cambiaron |
| `UNWATCH` | Cancela todos los WATCH |

### Lua Scripting (EVAL)

Para lógica más compleja, Redis ejecuta scripts **Lua** del lado del servidor. El script entero es **atómico**:

```bash
# Script Lua inline
EVAL "return redis.call('SET', KEYS[1], ARGV[1])" 1 mi-clave "valor"

# Script atómico: transferencia entre cuentas
EVAL "
    local saldo_origen = redis.call('GET', KEYS[1])
    if tonumber(saldo_origen) < tonumber(ARGV[1]) then
        return redis.error_reply('SALDO_INSUFICIENTE')
    end
    redis.call('DECRBY', KEYS[1], ARGV[1])
    redis.call('INCRBY', KEYS[2], ARGV[1])
    return 'OK'
" 2 cuenta:a cuenta:b 50
```

```bash
# Scripts precargados (evita reenviar el código cada vez)
SCRIPT LOAD "return redis.call('GET', KEYS[1])"
# → "4e6d0c0a1a..." (SHA del script)

EVALSHA 4e6d0c0a1a... 1 mi-clave          # ejecutar por SHA
SCRIPT EXISTS 4e6d0c0a1a...                # verificar si existe
SCRIPT FLUSH                                # limpiar todos los scripts
```

| Característica | MULTI/EXEC | Lua EVAL |
|---|---|---|
| **Atomicidad** | ✅ Atómico | ✅ Atómico |
| **Lógica condicional** | ❌ (solo cola comandos) | ✅ (if/while/for) |
| **Rendimiento** | Bueno (mínimo overhead) | Mejor (evita RTT múltiples) |
| **Complejidad** | Baja | Media |
| **Depuración** | Fácil | Scripts largos difíciles de debuggear |

---

## 6. Caching con Redis

Los patrones de caché más comunes con Redis:

### Cache-Aside (Lazy Loading)

La aplicación verifica Redis antes de consultar la base de datos:

```text
1. App: ¿Está en Redis?
   ├── ✅ Sí → devuelve (cache hit)
   └── ❌ No → consulta DB, guarda en Redis, devuelve (cache miss)
```

```python
import redis
r = redis.Redis()

def get_user(user_id):
    cache_key = f"user:{user_id}"

    # 1. Intentar cache
    data = r.get(cache_key)
    if data:
        return data

    # 2. Cache miss — consultar DB
    data = db.query("SELECT * FROM users WHERE id = ?", user_id)

    # 3. Guardar en cache por 1 hora
    r.setex(cache_key, 3600, data)
    return data
```

### Write-Through

Cada escritura va primero a Redis y luego a la base de datos:

```python
def update_user(user_id, data):
    cache_key = f"user:{user_id}"

    # 1. Escribir en Redis
    r.setex(cache_key, 3600, data)

    # 2. Escribir en DB
    db.query("UPDATE users SET ... WHERE id = ?", data, user_id)
```

### Write-Behind (Write-Back)

Las escrituras van a Redis inmediatamente y se sincronizan con la DB de forma asíncrona. Redis actúa como buffer de escritura:

```text
App → Redis (inmediato) → [worker asíncrono] → DB (eventual)
```

### Estrategias de invalidación

| Estrategia | Descripción |
|---|---|
| **TTL fijo** | `SETEX key 3600 data` — la cache se invalida sola tras 1 hora |
| **Invalidación manual** | `DEL cache:user:123` — cuando actualizas el usuario en DB |
| **Invalidación por patrón** | `SCAN 0 MATCH cache:user:* COUNT 1000` + `DEL` cada uno |
| **Invalidación por versión** | `cache:user:123:v2` — usas versiones en la clave |

### Políticas de evicción (maxmemory)

Cuando Redis llega al límite de memoria configurado, usa estas políticas:

| Política | Comportamiento |
|---|---|
| `noeviction` | Error en escrituras (solo lecturas) |
| `allkeys-lru` | Elimina las claves **menos usadas recientemente** | ← **recomendada** |
| `allkeys-lfu` | Elimina las **menos frecuentes** |
| `volatile-lru` | Elimina las menos usadas solo de las que tienen TTL |
| `volatile-lfu` | Elimina las menos frecuentes solo de las que tienen TTL |
| `allkeys-random` | Elimina claves al azar |
| `volatile-random` | Elimina al azar solo de las que tienen TTL |
| `volatile-ttl` | Elimina las que tienen el TTL más corto |

```bash
# Configuración en redis.conf
maxmemory 2gb
maxmemory-policy allkeys-lru
maxmemory-samples 10           # muestras para LRU aproximado (mayor = más preciso)
```

---

## 7. Rate Limiting (Control de tasa)

### Fixed Window (Ventana fija)

```bash
# Ventana por minuto para una IP
INCR rate:192.168.1.1:$(date +%H%M)
EXPIRE rate:192.168.1.1:$(date +%H%M) 60
# Si > 100, rechazar
```

**Problema:** Una ráfaga justo en el cambio de minuto puede duplicar el límite.

### Sliding Window Log (Ventana deslizante con Sorted Set)

```python
import redis, time
r = redis.Redis()

def check_rate_limit(user_id, max_requests=100, window_seconds=60):
    key = f"ratelimit:{user_id}"
    now = time.time()
    window_start = now - window_seconds

    # Limpiar entradas antiguas y añadir actual
    pipeline = r.pipeline()
    pipeline.zremrangebyscore(key, 0, window_start)
    pipeline.zadd(key, {str(now): now})
    pipeline.expire(key, window_seconds + 1)
    pipeline.zcard(key)              # contar entradas en la ventana
    _, _, _, count = pipeline.execute()

    return count <= max_requests
```

### Token Bucket con Lua (atómico)

```lua
-- Script: token_bucket.lua
local key = KEYS[1]
local rate = tonumber(ARGV[1])     -- tokens por segundo
local burst = tonumber(ARGV[2])    -- tamaño máximo del bucket
local now = tonumber(ARGV[3])
local cost = tonumber(ARGV[4])     -- tokens a consumir

local bucket = redis.call('HMGET', key, 'tokens', 'last_refill')
local tokens = tonumber(bucket[1] or burst)
local last_refill = tonumber(bucket[2] or now)

local elapsed = now - last_refill
tokens = math.min(burst, tokens + elapsed * rate)

if tokens >= cost then
    tokens = tokens - cost
    redis.call('HMSET', key, 'tokens', tokens, 'last_refill', now)
    redis.call('EXPIRE', key, 10)
    return 1  -- permitido
else
    return 0  -- rate limit excedido
end
```

```bash
# Uso
EVAL "$(cat token_bucket.lua)" 1 rate:Limit:IP 10 100 $(date +%s) 1
```

---

## 8. Distributed Locks con Redlock

Algoritmo para asegurar acceso exclusivo a un recurso en sistemas distribuidos:

```text
Cliente A                    Redis 1              Redis 2              Redis 3
   │                          │                     │                    │
   │── LOCK key (N|current) ──→                     │                    │
   │── LOCK key (N|current) ────────────────────────→                    │
   │── LOCK key (N|current) ─────────────────────────────────────────────→
   │                          │                     │                    │
   │← OK (3/3 acks, < 100ms) ─│─────────────────────│────────────────────│
   │                          │                     │                    │
   │          [CRÍTICO: ejecuta operación]          │                    │
   │                          │                     │                    │
   │── UNLOCK key (Lua) ──────→                     │                    │
   │── UNLOCK key (Lua) ────────────────────────────→                    │
   │── UNLOCK key (Lua) ────────────────────────────────────────────────→
```

```lua
-- Script Lua para adquirir lock (atómico)
if redis.call('SET', KEYS[1], ARGV[1], 'NX', 'PX', ARGV[2]) then
    return 1  -- lock adquirido
else
    return 0  -- ya tiene lock
end
```

```lua
-- Script Lua para liberar lock (solo si eres el dueño)
if redis.call('GET', KEYS[1]) == ARGV[1] then
    return redis.call('DEL', KEYS[1])
else
    return 0
end
```

```python
# Implementación simplificada de Redlock
import redis
import time
import uuid

class Redlock:
    def __init__(self, redis_uris):
        self.servers = [redis.Redis.from_url(u) for u in redis_uris]
        self.quorum = len(self.servers) // 2 + 1

    def lock(self, resource, ttl_ms=10000):
        token = str(uuid.uuid4())
        acquired = 0
        start = time.time() * 1000

        for server in self.servers:
            try:
                if server.set(resource, token, nx=True, px=ttl_ms):
                    acquired += 1
            except:
                pass

        # Verificar que adquirió mayoría y no excedió tiempo
        elapsed = time.time() * 1000 - start
        if acquired >= self.quorum and elapsed < ttl_ms:
            return token  # ✅ lock adquirido
        else:
            self.unlock(resource, token)  # rollback
            return None

    def unlock(self, resource, token):
        # Script Lua: solo libera si el token coincide
        script = """
        if redis.call('GET', KEYS[1]) == ARGV[1] then
            return redis.call('DEL', KEYS[1])
        end
        """
        for server in self.servers:
            try:
                server.eval(script, 1, resource, token)
            except:
                pass
```

> **Advertencia:** Redlock es controvertido. Martin Kleppmann (autor de *Designing Data-Intensive Applications*) señaló problemas con pausas de GC y relojes. Redis contraargumentó. En la práctica, para la mayoría de los casos funciona bien, pero para sistemas críticos considera alternativas como etcd o ZooKeeper.

---

## 9. Alta Disponibilidad

### WAIT — Consistencia síncrona

Por defecto, la replicación en Redis es **asíncrona**: cuando el master responde OK, la réplica puede no tener aún los datos. Para forzar sincronía:

```bash
SET clave "valor"
WAIT 1 1000        # espera hasta que 1 réplica confirme, timeout 1000ms
# Devuelve el número de réplicas que confirmaron
```

Esto **no** es ACID — sigue siendo eventualmente consistente en caso de partición de red. Útil para reducir la ventana de pérdida de datos en failover.

### CLIENT PAUSE — Failover controlado

Para failover manual sin pérdida de datos, puedes pausar las escrituras entrantes mientras promueves una réplica:

```bash
# En el master: pausa todas las escrituras durante 30 segundos
CLIENT PAUSE 30000 WRITE

# Promover réplica (en otro terminal)
SLAVEOF 192.168.1.20 6379

# Las escrituras se reanudan automáticamente tras los 30s
```

El master acumula las escrituras en un buffer y las procesa al reanudar. El cliente no recibe errores — solo latencia.

---

### Sentinel (Failover automático)

### Sentinel (Failover automático)

Sistema de monitoreo que promueve una réplica cuando el primario cae:

```text
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Sentinel 1 │    │  Sentinel 2 │    │  Sentinel 3 │
│  (quórum)   │◄──►│             │◄──►│             │
└──────┬──────┘    └──────┬──────┘    └──────┬──────┘
       │                  │                  │
       ▼                  ▼                  ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Redis MASTER ◄────  Redis SLAVE  │    │  Redis SLAVE │
│  (activo)    │    │  (réplica)   │    │  (réplica)   │
└──────────────┘    └──────────────┘    └──────────────┘
```

```bash
# Configuración sentinel.conf
sentinel monitor mi-cluster 127.0.0.1 6379 2
sentinel down-after-milliseconds mi-cluster 5000
sentinel failover-timeout mi-cluster 10000
sentinel parallel-syncs mi-cluster 1

# Iniciar sentinel
redis-sentinel /etc/redis/sentinel.conf

# Comandos
SENTINEL masters                        # ver todos los clusters monitoreados
SENTINEL get-master-addr-by-name mi-cluster  # IP y puerto del master actual
SENTINEL failover mi-cluster            # forzar failover manual
```

### Redis Cluster (Sharding nativo)

Distribuye datos entre múltiples nodos con **16384 hash slots**:

```bash
# Calcular slot de una clave
HASH_SLOT = CRC16(key) % 16384

# Ejemplo con 3 nodos maestro
```

```text
┌──────────┐     ┌──────────┐     ┌──────────┐
│ Nodo 1   │     │ Nodo 2   │     │ Nodo 3   │
│ Slots     │     │ Slots    │     │ Slots    │
│ 0-5460   │◄───►│ 5461-10922│◄───►│ 10923-16383│
│ ┌──────┐ │     │ ┌──────┐ │     │ ┌──────┐ │
│ │Slave1│ │     │ │Slave2│ │     │ │Slave3│ │
│ └──────┘ │     │ └──────┘ │     │ └──────┘ │
└──────────┘     └──────────┘     └──────────┘
    ↕ réplica         ↕              ↕
┌──────────┐     ┌──────────┐     ┌──────────┐
│ Nodo 4   │     │ Nodo 5   │     │ Nodo 6   │
│(réplica) │     │(réplica) │     │(réplica) │
└──────────┘     └──────────┘     └──────────┘
```

```bash
# Crear cluster (3 masters, 3 replicas)
redis-cli --cluster create \
    192.168.1.10:6379 192.168.1.11:6379 192.168.1.12:6379 \
    192.168.1.13:6379 192.168.1.14:6379 192.168.1.15:6379 \
    --cluster-replicas 1

# Ver slots y nodos
redis-cli --cluster check 192.168.1.10:6379
CLUSTER INFO
CLUSTER NODES
CLUSTER KEYSLOT "mi-clave"           # qué slot tiene esta clave

# Rebalancear
redis-cli --cluster rebalance 192.168.1.10:6379

# Añadir nodo
redis-cli --cluster add-node nueva_ip:6379 existente_ip:6379

# Añadir réplica
redis-cli --cluster add-node replica_ip:6379 master_ip:6379 --cluster-slave
```

### Comparativa

| Aspecto | Sentinel | Cluster |
|---|---|---|
| **Propósito** | HA (failover automático) | HA + escalado horizontal |
| **Datos** | Todos los nodos tienen todo | Shardeado por slots |
| **Escrituras** | 1 nodo (el master) | Múltiples (cada master escribe sus slots) |
| **Consistencia** | Eventual (asíncrona) | Eventual (asíncrona entre réplicas) |
| **Conexión** | Normal (cualquier cliente Redis) | Cliente cluster-aware (redirección MOVED/ASK) |
| **Complejidad** | Baja | Alta |
| **Ideal para** | Caché, apps pequeñas/medianas | Grandes volúmenes de datos |

---

## 10. Redis Stack (Módulos)

Desde Redis 7+, **Redis Stack** agrupa módulos oficiales que extienden Redis más allá de clave-valor:

```bash
# Instalar Redis Stack (incluye todo)
# Linux: descargar desde https://redis.io/download
# Docker:
docker run -p 6379:6379 redis/redis-stack

# O instalar módulos individualmente
# En redis.conf:
loadmodule /usr/lib/redis/modules/redisjson.so
loadmodule /usr/lib/redis/modules/redisearch.so
loadmodule /usr/lib/redis/modules/redistimeseries.so
loadmodule /usr/lib/redis/modules/redisbloom.so
```

### RedisJSON

Almacena y consulta documentos JSON con Path syntax:

```bash
JSON.SET usuario:1 $ '{"nombre":"Ana","edad":30,"direccion":{"ciudad":"Madrid"}}'
JSON.GET usuario:1 $.nombre                       # "Ana"
JSON.GET usuario:1 $.direccion.ciudad             # "Madrid"
JSON.ARRAPPEND usuario:1 $.intereses '"lectura"'
JSON.DEL usuario:1 $.edad                         # eliminar campo
JSON.OBJLEN usuario:1                             # número de campos
```

### RediSearch

Índice de texto completo y búsqueda secundaria:

```bash
# Crear índice
FT.CREATE idx:productos ON HASH PREFIX 1 "producto:" \
    SCHEMA nombre TEXT WEIGHT 5.0 \
           descripcion TEXT WEIGHT 1.0 \
           precio NUMERIC \
           categoria TAG

# Indexar datos
HSET producto:1 nombre "Laptop Gamer" descripcion "RTX 4060, 32GB RAM" precio 1200 categoria "electronica"

# Buscar
FT.SEARCH idx:productos "laptop"                   # búsqueda texto
FT.SEARCH idx:productos "laptop" LIMIT 0 10        # paginado
FT.SEARCH idx:productos "@precio:[500 1500]"       # filtro numérico
FT.SEARCH idx:productos "@categoria:{electronica}"  # filtro tag

# Búsqueda con faceta
FT.AGGREGATE idx:productos "*" GROUPBY 1 @categoria REDUCE COUNT 0 AS num

# Búsqueda difusa (fuzzy)
FT.SEARCH idx:productos "%%lapto%%"                # tolerancia a typos
```

### RedisTimeSeries

Series temporales con downsampling automático:

```bash
# Crear serie temporal con retención
TS.CREATE cpu:server1 RETENTION 86400000           # 24 horas (en ms)
TS.CREATE cpu:server2 RETENTION 86400000 LABELS tipo "production" ubicacion "madrid"

# Insertar datos
TS.ADD cpu:server1 * 45.5                          # timestamp automático, valor: 45.5%
TS.ADD cpu:server2 1678900000000 78.2

# Consultar rango
TS.RANGE cpu:server1 1678800000000 1678900000000
TS.RANGE cpu:server1 1678800000000 1678900000000 AGGREGATION avg 60000  # avg cada 1 min

# Reglas de downsampling automático
TS.CREATERULE cpu:server1 cpu:server1:5min AGGREGATION avg 300000
```

### RedisBloom

Estructuras de datos probabilísticas:

```bash
# Bloom Filter (¿este elemento YA fue visto?)
BF.RESERVE filtro:urls 0.01 1000000     # 1% error, 1M elementos
BF.ADD filtro:urls "https://ejemplo.com"
BF.EXISTS filtro:urls "https://ejemplo.com"  # 1 (probablemente sí)
BF.EXISTS filtro:urls "https://otro.com"      # 0 (seguro que no)

# Cuckoo Filter (soporta eliminación)
CF.ADD filtro:users "user_123"
CF.EXISTS filtro:users "user_123"
CF.DEL filtro:users "user_123"

# Top-K (elementos más frecuentes)
TOPK.ADD trending "linux" "docker" "kubernetes" "linux" "docker"
TOPK.LIST trending                              # ["docker", "linux", "kubernetes"]

# Count-Min Sketch (frecuencia aproximada)
CMS.INCRBY contador:eventos "visita" 1
CMS.QUERY contador:eventos "visita"              # ~N visitas
```

---

## 11. Seguridad

### ACLs (desde Redis 6.0)

Control de acceso por usuario con permisos granulares:

```bash
# Configuración en redis.conf
aclfile /etc/redis/users.acl

# O en redis-cli
ACL SETUSER admin ON >contraseña_segura ~* +@all
ACL SETUSER lector ON >otra_contraseña ~* +@read
ACL SETUSER worker ON >worker_pass ~cola:* +@write -@dangerous

# Ver usuarios
ACL LIST
ACL GETUSER lector

# Categorías de comandos
# +@read     → GET, HGET, KEYS, EXISTS, TYPE, etc.
# +@write    → SET, HSET, DEL, EXPIRE, etc.
# +@admin    → CONFIG, SHUTDOWN, DEBUG, etc.
# +@dangerous→ FLUSHALL, SLAVEOF, DEBUG, etc.
# +@all      → todo
# -@dangerous→ todo menos dangerous

# Comandos específicos
ACL SETUSER dev ON >dev_pass ~dev:* +SET +GET +DEL -FLUSHALL
```

### Otras medidas de seguridad

```bash
# Contraseña global (legacy, pre-ACL)
# redis.conf
requirepass tu_contraseña_segura

# Renombrar comandos peligrosos
rename-command FLUSHALL ""
rename-command CONFIG "ADMIN_CONFIG_9f4b2a"

# TLS/SSL (Redis 6.0+)
# redis.conf
tls-port 6380
port 0                          # deshabilitar puerto no-TLS
tls-cert-file /etc/redis/certs/redis.crt
tls-key-file /etc/redis/certs/redis.key
tls-ca-cert-file /etc/redis/certs/ca.crt
```

### Hardening checklist

- [ ] ACL habilitado con usuarios mínimos
- [ ] Puerto no estándar (6379 → otro)
- [ ] `protected-mode yes`
- [ ] `bind` a IP de loopback o red interna (no 0.0.0.0)
- [ ] `rename-command FLUSHALL` y otros peligrosos
- [ ] TLS activado si Redis está expuesto a red
- [ ] `requirepass` o ACL configurado
- [ ] `maxmemory` límite configurado

---

## 12. Rendimiento y monitoreo

### Comandos de diagnóstico

```bash
# Información general
INFO                          # todo: server, clients, memory, persistence, stats
INFO memory                   # solo memoria
INFO stats                    # solo estadísticas
INFO commandstats             # estadísticas por comando
INFO keyspace                 # claves por base de datos

# Monitoreo en vivo
MONITOR                       # todas las operaciones en tiempo real
SLOWLOG GET 10                # últimas 10 consultas lentas
SLOWLOG LEN                   # cuántas consultas lentas registradas
SLOWLOG RESET                 # limpiar slow log

# Diagnóstico de latencia
LATENCY LATEST                # últimas latencias altas registradas
LATENCY HISTORY command       # historial de latencia de un evento
LATENCY GRAPH                 # gráfico ASCII de latencia

# Memoria
MEMORY USAGE mi-clave         # cuánto ocupa una clave específica (bytes)
MEMORY STATS                  # estadísticas detalladas de memoria
MEMORY DOCTOR                 # recomendaciones si hay problemas de memoria
MEMORY PURGE                  # liberar memoria (no es necesario normalmente)
```

### Configuración de rendimiento

```bash
# redis.conf - parámetros clave
timeout 300                    # cerrar conexiones idle tras 5 min
tcp-keepalive 300              # mantener vivas conexiones TCP
lfu-log-factor 10              # factor de decaimiento LFU

# Tamaño de páginas y buffers
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit replica 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60

# Deshabilitar THP (Transparent Huge Pages) — crítico para rendimiento
# /etc/rc.local o systemd unit:
# echo never > /sys/kernel/mm/transparent_hugepage/enabled

# Ajustar overcommit (permite que el fork de BGSAVE funcione)
# sysctl vm.overcommit_memory=1
```

### Latencia en redes

```text
Conexión localhost:
  SET clave valor  → 0.1 ms

Conexión misma región (DC):
  SET clave valor  → 0.5-1 ms

Conexión cross-region:
  SET clave valor  → 10-50 ms (no recomendado)
```

---

## 13. Conexión desde lenguajes

### Python (redis-py)

```python
# pip install redis
import redis

r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)

# Básico
r.set('clave', 'valor')
print(r.get('clave'))                     # 'valor'

# Pipeline (reduce RTT)
pipe = r.pipeline()
pipe.set('a', 1)
pipe.incr('a')
pipe.get('a')
resultados = pipe.execute()               # [True, 2, b'2']

# Pool de conexiones
pool = redis.ConnectionPool(host='localhost', port=6379, max_connections=50)
r = redis.Redis(connection_pool=pool)

# Cluster
from redis.cluster import RedisCluster
rc = RedisCluster(host='localhost', port=6379)
rc.set('foo', 'bar')
```

### Node.js (ioredis)

```javascript
// npm install ioredis
const Redis = require('ioredis');

const redis = new Redis({ host: 'localhost', port: 6379 });

// Básico
await redis.set('clave', 'valor');
const val = await redis.get('clave');        // 'valor'

// Pipeline
const pipeline = redis.pipeline();
pipeline.set('a', 1);
pipeline.incr('a');
pipeline.get('a');
const results = await pipeline.exec();

// Cluster
const Cluster = require('ioredis').Cluster;
const cluster = new Cluster([
  { host: '127.0.0.1', port: 6379 },
  { host: '127.0.0.1', port: 6380 },
]);
```

### Go (go-redis)

```go
// go get github.com/redis/go-redis/v9
import "github.com/redis/go-redis/v9"

rdb := redis.NewClient(&redis.Options{
    Addr:     "localhost:6379",
    Password: "",
    DB:       0,
    PoolSize: 50,
})

err := rdb.Set(ctx, "clave", "valor", 0).Err()
val, err := rdb.Get(ctx, "clave").Result()

// Pipeline
pipe := rdb.Pipeline()
incr := pipe.Incr(ctx, "contador")
pipe.Expire(ctx, "contador", time.Hour)
_, err = pipe.Exec(ctx)
fmt.Println(incr.Val())
```

### Rust (redis-rs)

```rust
// Cargo.toml: redis = { version = "0.27", features = ["tokio-comp"] }
use redis::AsyncCommands;

let client = redis::Client::open("redis://localhost:6379/")?;
let mut con = client.get_multiplexed_async_connection().await?;

con.set("clave", "valor").await?;
let val: String = con.get("clave").await?;

// Pipeline
let (val1, val2): (i32, i32) = redis::pipe()
    .cmd("SET").arg("a").arg(42).ignore()
    .cmd("INCR").arg("a").query_async(&mut con).await?;
```

---

## 14. Casos de uso prácticos

### Caché de consultas SQL (Cache-Aside)

```python
def get_expensive_query(user_id):
    cache_key = f"query:user:{user_id}:orders"

    # Cache hit
    result = r.get(cache_key)
    if result:
        return json.loads(result)

    # Cache miss
    result = db.query("""
        SELECT o.*, p.nombre
        FROM orders o JOIN products p ON o.product_id = p.id
        WHERE o.user_id = ?
    """, user_id)

    # Guardar con TTL
    r.setex(cache_key, 600, json.dumps(result))
    return result
```

### Sesiones de usuario

```python
def create_session(user_id):
    token = secrets.token_urlsafe(32)
    session_data = json.dumps({
        "user_id": user_id,
        "ip": request.remote_addr,
        "created_at": time.time()
    })
    r.setex(f"session:{token}", 86400, session_data)  # 24h
    return token

def get_session(token):
    data = r.get(f"session:{token}")
    return json.loads(data) if data else None
```

### Cola de tareas con Streams

```python
# Productor
def enqueue_task(task_type, payload):
    r.xadd("tasks:queue", {
        "type": task_type,
        "payload": json.dumps(payload),
        "created_at": time.time()
    })

# Worker con consumer group
def worker(worker_id):
    group = "workers"
    try:
        r.xgroup_create("tasks:queue", group, id="0", mkstream=True)
    except:
        pass  # grupo ya existe

    while True:
        messages = r.xreadgroup(group, worker_id,
                                {"tasks:queue": ">"}, count=1, block=5000)
        if messages:
            stream, entries = messages[0]
            for msg_id, data in entries:
                try:
                    process_task(data)
                    r.xack("tasks:queue", group, msg_id)
                except:
                    # El mensaje queda pendiente para retry
                    pass
```

### Leaderboard en tiempo real

```python
def add_score(game_id, player, score):
    r.zincrby(f"leaderboard:{game_id}", score, player)

def get_top_10(game_id):
    return r.zrevrange(f"leaderboard:{game_id}", 0, 9, withscores=True)

def get_player_rank(game_id, player):
    rank = r.zrevrank(f"leaderboard:{game_id}", player)
    score = r.zscore(f"leaderboard:{game_id}", player)
    return rank + 1, score if rank is not None else None
```

### Contador de visitas único (HyperLogLog)

```python
def track_visit(page_id, ip_address):
    key = f"visits:{page_id}:{datetime.now():%Y-%m-%d}"
    r.pfadd(key, ip_address)

def unique_visitors_today(page_id):
    key = f"visits:{page_id}:{datetime.now():%Y-%m-%d}"
    return r.pfcount(key)

def unique_visitors_week(page_id):
    keys = [f"visits:{page_id}:{(datetime.now() - timedelta(days=d)):%Y-%m-%d}"
            for d in range(7)]
    r.pfmerge(f"visits:{page_id}:week", *keys)
    return r.pfcount(f"visits:{page_id}:week")
```

### Cache de sesión con fallback y locking

```python
import threading

class SessionCache:
    def __init__(self, redis_client, db_client):
        self.r = redis_client
        self.db = db_client
        self.local = threading.local()

    def get_user(self, user_id):
        # 1. Cache local (request-scoped)
        if hasattr(self.local, f"user_{user_id}"):
            return getattr(self.local, f"user_{user_id}")

        cache_key = f"user:{user_id}"

        # 2. Redis
        data = self.r.get(cache_key)
        if data:
            user = json.loads(data)
        else:
            # 3. DB con lock distribuido para evitar cache stampede
            lock_key = f"lock:user:{user_id}"
            lock_token = str(uuid.uuid4())
            acquired = self.r.set(lock_key, lock_token, nx=True, px=2000)

            if acquired:
                user = self.db.fetch_user(user_id)
                self.r.setex(cache_key, 3600, json.dumps(user))
                self.r.delete(lock_key)
            else:
                # Esperar un poco y reintentar
                time.sleep(0.05)
                data = self.r.get(cache_key)
                user = json.loads(data) if data else None

        setattr(self.local, f"user_{user_id}", user)
        return user
```

---

## 15. Redis vs otras opciones

### Redis vs Memcached

| Aspecto | Redis | Memcached |
|---|---|---|
| **Tipos de datos** | Strings, Listas, Sets, Hashes, etc. | Solo strings |
| **Persistencia** | RDB + AOF | ❌ No persiste |
| **Pub/Sub** | ✅ | ❌ |
| **Replicación** | ✅ Master-replica + Cluster | ❌ |
| **Lua scripting** | ✅ | ❌ |
| **Transacciones** | ✅ MULTI/EXEC/WATCH | ❌ |
| **Serialización** | Interna (tipos nativos) | Solo texto/serializado por cliente |
| **Multi-thread** | Parcial (6.0+ en networking) | ✅ Multi-thread completo |
| **Complejidad** | Media | Baja |

### Redis vs DragonflyDB / KeyDB

| Aspecto | Redis | DragonflyDB | KeyDB |
|---|---|---|---|
| **Modelo** | Single-thread (comandos) | Multi-thread (shared-nothing) | Multi-thread (fork de Redis) |
| **Rendimiento** | Excelente | Superior en multi-core | Superior en multi-core |
| **Compatibilidad** | Referencia | Alta (API compatible) | Alta (API compatible) |
| **Madurez** | ✅ 15+ años | ⚠️ Relativamente nuevo | ⚠️ Relativamente nuevo |
| **Ecosistema** | ✅ Más módulos/Stack | ⚠️ Menos módulos | ⚠️ Menos módulos |

---

## 16. Optimización de memoria

```bash
# Configuración avanzada de memoria
hash-max-ziplist-entries 512    # hash pequeño → ziplist
hash-max-ziplist-value 64       # hasta 64 bytes por entrada
list-max-ziplist-size -2        # lista pequeña → quicklist compacta
set-max-intset-entries 512      # set de enteros → intset hasta 512
zset-max-ziplist-entries 128    # sorted set pequeño → ziplist
zset-max-ziplist-value 64       # hasta 64 bytes

# Activar resizing de diccionario
activerehashing yes             # rehash en background

# Fragmentación
# Redis no libera memoria al SO inmediatamente
# Usar MEMORY PURGE para forzar (raro que sea necesario)
```

### Cálculo de memoria

```text
1 millón de claves string de 50 bytes:
  - Overhead por clave: ~80 bytes (dict entry + SDS header + punteros)
  - Datos: 50 bytes
  - Total por clave: ~130 bytes
  - Total: ~130 MB + overhead de tabla hash (~8 MB)
  → ~140 MB para 1M de claves

Ejemplo real: 1M sesiones de usuario de 200 bytes:
  - Overhead: ~80 bytes/clave
  - Datos: ~200 bytes/clave
  - Total → ~280 MB + overhead Redis (~50 MB) ≈ 330 MB
```

---

## 17. Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `MISCONF Redis is configured to save RDB snapshots` | BGSAVE falló por permisos de disco | Verificar `dir` en redis.conf y permisos de `/var/lib/redis` |
| `OOM command not allowed when used memory > 'maxmemory'` | Redis llegó al límite de memoria | Aumentar `maxmemory`, cambiar política de evicción, o escalar |
| `BUSY Redis is busy running a script` | Script Lua se ejecuta > `lua-time-limit` | `SCRIPT KILL` (si no modificó datos) o esperar |
| `LOADING Redis is loading the dataset in memory` | Redis está cargando RDB/AOF al iniciar | Esperar a que termine la carga |
| `-MOVED 1234 192.168.1.10:6379` | La clave está en otro nodo del cluster | El cliente debe redirigir la conexión (los clientes cluster-aware lo hacen solos) |
| `-ASK 1234 192.168.1.11:6379` | La clave se está migrando entre nodos | El cliente debe seguir la redirección (ASK) |
| `Can't save in background: fork: Cannot allocate memory` | **overcommit_memory=0** (fork necesita el doble de RAM) | `sysctl vm.overcommit_memory=1` |
| Slow queries en `SLOWLOG` | Comando O(n) contra datasets grandes, o Redis en red lenta | Usar `SCAN` en vez de `KEYS`, indexar con Sorted Sets, pipeline |
| `ERR AOF: rewrite failed` | No hay suficiente espacio en disco para la reescritura AOF | Liberar disco o mover AOF a otro volumen |
| `MISCONF Cluster state is not ok` | Slot(s) sin cubrir en el cluster (nodo caído) | `redis-cli --cluster fix` o restaurar nodo caído |
| Punto muerto por `WATCH` excesivo | Muchos reintentos de transacciones | Pasar la lógica a Lua script (atómico de verdad) |

---

## Ver también

- [[MongoDB y NoSQL]] — comparativa completa del ecosistema NoSQL
- [[PostgreSQL y MySQL]] — bases de datos relacionales (a menudo se usan con Redis)
- [[Docker]] — levantar Redis con docker-compose
- [[Python en Linux]] — conexión con `redis-py`
- [[Backups (borg restic duplicity rsync)]] — estrategias de backup para datos persistentes
- [[Monitorización (Prometheus node_exporter)]] — el exporter oficial `redis_exporter`

## Enlaces externos

- [Redis — Documentación oficial](https://redis.io/docs/)
- [Redis — Try it Online](https://try.redis.io/)
- [Redis — GitHub](https://github.com/redis/redis)
- [Redis — Latency monitoring](https://redis.io/docs/latest/operate/oss_and_stack/management/latency-monitor/)
- [Redis — ACL documentation](https://redis.io/docs/latest/operate/oss_and_stack/management/security/acl/)
- [Redis Cluster — Tutorial](https://redis.io/docs/latest/operate/oss_and_stack/management/scaling/)
- [Redlock — Distributed Locks](https://redis.io/docs/latest/develop/use/patterns/distributed-locks/)
- [RediSearch — Query syntax](https://redis.io/docs/latest/interact/search-and-query/query/)
- [Redis Streams — Intro](https://redis.io/docs/latest/data-types/streams-tutorial/)
- [Arch Wiki — Redis](https://wiki.archlinux.org/title/Redis)
- [Martin Kleppmann — How to do distributed locking (crítica a Redlock)](https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html)

#programa #redis #nosql #cache
