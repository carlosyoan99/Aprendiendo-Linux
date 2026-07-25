---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: concepto
prioridad: alta
---

# Docker

## Qué es

Docker es la herramienta más popular para crear, desplegar y ejecutar **contenedores**. Empaqueta aplicaciones en imágenes portátiles que corren igual en cualquier sistema Linux (o macOS/Windows con una VM ligera detrás).

Usa una arquitectura **cliente-servidor**: el comando `docker` (CLI) se comunica con `dockerd` (daemon) para gestionar contenedores, imágenes, redes y volúmenes.

Ver [[Contenedores]] para entender el concepto general.

## Historia

| Año | Hito |
|---|---|
| **2008** | Lanzamiento de **LXC** (Linux Containers), la tecnología base de contenedores a nivel de kernel (cgroups + namespaces) |
| **2013** | **Docker Inc.** (entonces dotCloud) lanza Docker como plataforma que simplifica enormemente el uso de contenedores. Usa LXC inicialmente |
| **2014** | Docker libera su propio runtime **libcontainer**, reemplazando LXC. Estalla la guerra de orquestación (Docker Swarm, Mesos, Kubernetes) |
| **2015** | Se funda la **Open Container Initiative (OCI)** para estandarizar formatos de imágenes y runtimes |
| **2017** | Docker dona el runtime **containerd** a la CNCF. Se convierte en el runtime estándar de Kubernetes |
| **2019** | **Mirantis** adquiere el negocio empresarial de Docker. Docker CE (Community Edition) queda en manos de la comunidad |
| **2020+** | Docker pierde cuota frente a **Podman** (daemonless, rootless) y **containerd** directo. Sigue siendo el más usado en desarrollo |

Docker revolucionó el despliegue de software al popularizar el concepto de "build, ship, and run" — construir una imagen, subirla a un registro, y ejecutarla en cualquier otro sistema con Docker instalado.

## Instalación

```bash
# La forma recomendada es usar el script oficial (detecta la distro automáticamente):
curl -fsSL https://get.docker.com | sh

# Después de instalar, agregar tu usuario al grupo docker para no tener que usar sudo:
sudo usermod -aG docker $USER
# Cerrar sesión y volver a entrar (o ejecutar: newgrp docker)

# Alternativa por gestor de paquetes:
# Debian/Ubuntu
sudo apt install docker.io
sudo systemctl enable --now docker

# Arch
sudo pacman -S docker
sudo systemctl enable --now docker

# Fedora
sudo dnf install docker
sudo systemctl enable --now docker
```

## Comandos básicos

```bash
# Imágenes
docker pull ubuntu:latest               # descargar imagen de Docker Hub
docker images                            # listar imágenes locales
docker rmi <imagen>                      # eliminar imagen

# Contenedores
docker run ubuntu echo "hola"            # ejecutar comando y salir
docker run -it ubuntu bash               # ejecutar interactivo (terminal)
docker run -d --name mi-web -p 8080:80 nginx  # daemon, mapear puerto
docker ps                                # contenedores en ejecución
docker ps -a                             # todos los contenedores
docker stop <contenedor>                 # detener
docker start <contenedor>                # iniciar detenido
docker rm <contenedor>                   # eliminar contenedor

# Ejecutar comandos dentro de un contenedor en ejecución
docker exec -it mi-web bash

# Logs
docker logs -f mi-web                    # seguir logs

# Limpieza
docker system prune                      # limpiar todo lo no usado (contenedores, imágenes, redes)
```

## Dockerfile (construir tu propia imagen)

```dockerfile
# Ejemplo: imagen con Node.js que sirve una app
FROM node:20-alpine                      # base: Node 20 sobre Alpine Linux (~120MB en vez de ~1GB)
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

```bash
docker build -t mi-app .                 # construir imagen desde el Dockerfile
docker run -p 3000:3000 mi-app           # ejecutar la app
```

## docker-compose (múltiples contenedores)

```yaml
# docker-compose.yml: app web + base de datos
services:
  web:
    build: .
    ports:
      - "3000:3000"
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: secret123
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

```bash
docker compose up -d                     # levantar todo
docker compose down                      # detener y eliminar
```

### Ejemplo completo: Ecosistema NoSQL para desarrollo

El vault incluye un [`docker-compose.yml`](/docker-compose.yml) en la raíz del proyecto con MongoDB 7, Redis 7, Cassandra 4 y Neo4j 5 listos para desarrollo:

```bash
# Pre-requisitos: copiar .env
cp docker/.env.example .env

# Levantar todos los servicios
docker compose up -d

# Ver estado
docker compose ps

# Ver logs
docker compose logs -f

# Levantar solo algunos
docker compose up -d mongodb redis

# Detener todo y eliminar volúmenes (¡borra datos!)
docker compose down -v
```

| Servicio | Puerto | UI Web | Credenciales (default) |
|---|---|---|---|
| MongoDB | `27017` | `http://localhost:8081` (mongo-express) | `admin` / `mongopass` |
| Redis | `6379` | `http://localhost:8082` (redis-commander) | Sin contraseña (desarrollo) |
| Cassandra | `9042` | — | `cassandra` / `cassandra` |
| Neo4j | `7474` (HTTP), `7687` (Bolt) | `http://localhost:7474` (Neo4j Browser) | `neo4j` / `neopass` |

Cada base de datos incluye:
- **Health check** (espera a que el servicio esté listo)
- **Volumen persistente** (los datos sobreviven a `docker compose down`)
- **Scripts de inicialización** en `docker/<servicio>/` (datos de ejemplo al primer arranque)
- **Variables personalizables** vía `.env`

## Alternativas

| Herramienta | Diferencias con Docker |
|---|---|
| **Podman** | Misma sintaxis CLI (`podman` en vez de `docker`), sin daemon (fork/exec), rootless nativo. Muchos alias `alias docker=podman` |
| **containerd** | El runtime de contenedores que Docker usa por debajo. Puede usarse directo |
| **LXC/LXD** | Contenedores tipo VM (más pesados, init completo dentro). Más usado para entornos tipo VPS |
| **systemd-nspawn** | Contenedor integrado con systemd, no requiere daemon externo |

## Configuración básica

```bash
# Ver información del motor Docker
docker info

# Acelerar pulls con mirror registries (para evitar rate limiting de Docker Hub)
# Editar /etc/docker/daemon.json:
{
  "registry-mirrors": ["https://mirror.gcr.io"]
}
sudo systemctl restart docker
```

## Notas y advertencias

- `sudo usermod -aG docker $USER` da acceso equivalente a root al grupo docker (es un riesgo de seguridad). No hacerlo en servidores compartidos.
- Docker Hub tiene **rate limiting**: pulls anónimos limitados a 100/6h, autenticados a 200/6h. Usar mirrors o registries privados para uso intensivo.
- Las imágenes `:latest` cambian con el tiempo. Preferir tags específicos (`node:20-alpine`, `postgres:16`) en producción para builds reproducibles.

## Ver también

- [[Contenedores]]
- [[systemd-nspawn]]
- [[Alpine Linux]]
- [[systemd]]
- [[Redes Basicas]]

#concepto
