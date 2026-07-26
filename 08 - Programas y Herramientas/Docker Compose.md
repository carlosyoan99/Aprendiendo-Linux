---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: alta
---

# Docker Compose

> Herramienta para definir y ejecutar aplicaciones multi-contenedor con un archivo YAML. El estándar para desarrollo local con Docker.

## Sintaxis

```bash
docker compose [comando] [opciones]
docker-compose [comando] [opciones]   # syntax legacy (v1)
```

## Descripción

Docker Compose permite definir un entorno completo de desarrollo (app + base de datos + cache + etc.) en un solo archivo `docker-compose.yml`. Un solo comando levanta todo: `docker compose up`.

| Aspecto | Detalle |
|---|---|
| **Archivo** | `docker-compose.yml` o `compose.yml` |
| **Syntax** | YAML con servicios, redes, volúmenes |
| **Dependencias** | Docker Engine + Docker Compose plugin (v2) |
| **Uso típico** | Desarrollo local, testing, demo environments |

## Comandos esenciales

```bash
# Levantar todo en background
docker compose up -d

# Ver estado
docker compose ps

# Ver logs
docker compose logs -f
docker compose logs -f app

# Parar y limpiar
docker compose down
docker compose down -v    # eliminar volúmenes también

# Reconstruir imágenes
docker compose build
docker compose up -d --build

# Ejecutar comando en contenedor
docker compose exec db psql -U postgres
docker compose run --rm app pytest
```

## Ejemplo completo

```yaml
# docker-compose.yml
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
      - REDIS_URL=redis://cache:6379
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_started
    volumes:
      - .:/app
      - node_modules:/app/node_modules

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user"]
      interval: 5s
      timeout: 5s
      retries: 5

  cache:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  pgdata:
  node_modules:
```

## Funciones avanzadas

### Profiles
```yaml
services:
  app:
    build: .
    profiles: ["dev"]

  debug-tools:
    image: busybox
    profiles: ["debug"]
```

```bash
docker compose --profile dev up -d     # levanta solo "dev"
docker compose --profile debug up -d   # levanta "dev" + "debug"
```

### Watch (desarrollo en vivo)
```yaml
services:
  app:
    develop:
      watch:
        - action: sync
          path: ./src
          target: /app/src
        - action: rebuild
          path: package.json
```

```bash
docker compose watch    # sincroniza cambios en vivo
```

### Variables de entorno
```yaml
services:
  app:
    env_file:
      - .env
    environment:
      - NODE_ENV=${NODE_ENV:-development}
```

## Casos de uso

### Levantar entorno de desarrollo completo
```bash
git clone mi-proyecto && cd mi-proyecto
docker compose up -d
# App en localhost:3000, DB en localhost:5432, Redis en localhost:6379
```

### Ejecutar tests aislados
```bash
docker compose -f docker-compose.test.yml up -d
docker compose -f docker-compose.test.yml run --rm app pytest
docker compose -f docker-compose.test.yml down -v
```

### Debug en vivo
```bash
docker compose exec app bash    # entrar al contenedor
docker compose logs -f app      # ver logs en tiempo real
```

## Formato de salida

```
NAME                    IMAGE               COMMAND                  SERVICE             STATUS
mi-proyecto-app-1       mi-proyecto         "node server.js"        app                 running (healthy)
mi-proyecto-db-1        postgres:16-alpine  "docker-entrypoint.s…"  db                  running (healthy)
mi-proyecto-cache-1     redis:7-alpine      "redis-server"          cache               running
```

## Troubleshooting

| Problema | Solución |
|---|---|
| Puerto en uso | `docker compose down` o cambiar puerto |
| Imagen no construye | `docker compose build --no-cache` |
| Contenedor se reinicia | `docker compose logs <servicio>` |
| depends_on no espera | Usar `condition: service_healthy` con healthcheck |
| Volúmenes permisos | `user: "1000:1000"` en el servicio |
| Red no conecta | Servicios en mismo `docker-compose.yml` comparten red automáticamente |

## Ver también

- [[Docker]] — fundamentos de contenedores
- [[Kubernetes]] — orquestación en producción
- [[Docker Compose]] — comparativa con orquestadores
- [[Podman]] — alternativa sin daemon
- [[DevOps]] — cultura de entrega continua

## Enlaces externos

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Wikipedia — Docker Compose](https://en.wikipedia.org/wiki/Docker_(platform)#Compose)
- [GitHub — docker/compose](https://github.com/docker/compose)
- [Compose Specification](https://compose-spec.io/)

#programa #docker #contenedores
