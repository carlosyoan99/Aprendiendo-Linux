---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: concepto
prioridad: alta
---

# Contenedores

## Definición

Un **contenedor** es una unidad ligera y portátil que empaqueta una aplicación con todas sus dependencias (binarios, librerías, configuración) para que se ejecute de forma aislada en cualquier sistema Linux. A diferencia de las máquinas virtuales, los contenedores **comparten el kernel del host** — no incluyen su propio sistema operativo.

```bash
# Diferencia práctica entre contenedor y VM:
# Una imagen de Ubuntu Docker pesa ~80 MB
# Una VM de Ubuntu pesa ~2-5 GB
# Un contenedor arranca en <1 segundo
# Una VM arranca en 30-60 segundos
```

```
┌─────────────────────────────────┐      ┌──────────────┐
│         Máquina Virtual         │      │  Contenedor  │
│  ┌──────────┐ ┌──────────┐     │      │  ┌──┐ ┌──┐  │
│  │ Guest OS │ │ Guest OS │     │      │  │A │ │B │  │
│  │   App A  │ │   App B  │     │      │  └──┘ └──┘  │
│  └──────────┘ └──────────┘     │      │  Docker/podman │
│  Hypervisor (VirtualBox, KVM)  │      ├──────────────┤
├────────────────────────────────┤      │   Host OS    │
│          Host OS               │      │   Hardware   │
│          Hardware              │      └──────────────┘
└─────────────────────────────────┘
        VM: cada app con su SO        Contenedores: comparten kernel
```

## Conceptos clave

| Concepto | Qué es |
|---|---|
| **Imagen** | Plantilla de solo lectura con el sistema de archivos del contenedor. Se construye con un `Dockerfile` |
| **Contenedor** | Instancia en ejecución de una imagen. Puede crearse, iniciarse, detenerse y eliminarse |
| **Registro** | Repositorio de imágenes (Docker Hub, GitHub Container Registry, Quay.io) |
| **Orquestación** | Gestión de múltiples contenedores en varios servidores (Kubernetes, Docker Swarm) |
| **Mount bind** | Directorio del host montado dentro del contenedor para persistir datos |
| **Volumen** | Almacenamiento gestionado por Docker, más portable que los bind mounts |
| **Dockerfile** | Archivo de texto con instrucciones para construir una imagen |
| **docker-compose** | Herramienta para definir y ejecutar múltiples contenedores |

## Por qué importa

- **Portabilidad**: "funciona en mi máquina" deja de ser excusa — el contenedor lleva todo lo que necesita.
- **Aislamiento**: dependencias de una app no afectan a otras ni al sistema host.
- **Eficiencia**: un contenedor arranca en milisegundos y ocupa MB (frente a GB/minutos de una VM).
- **DevOps/Cloud**: Docker + Kubernetes son el estándar de la industria para desplegar aplicaciones.
- **Entorno de desarrollo**: puedes probar software sin instalarlo en tu sistema (bases de datos, servidores, entornos de lenguajes).
- **Prácticamente todo corre en Linux**: incluso en macOS/Windows, los contenedores corren sobre una VM Linux ligera.

## Comandos asociados (Docker básico)

```bash
# Gestión de contenedores
docker run nginx                      # ejecutar un contenedor
docker run -d --name web -p 8080:80 nginx  # daemon, mapear puerto
docker ps                             # contenedores activos
docker ps -a                          # todos los contenedores
docker stop web                       # detener
docker start web                      # iniciar detenido
docker rm web                         # eliminar
docker exec -it web bash              # entrar al contenedor

# Gestión de imágenes
docker pull ubuntu:latest             # descargar imagen
docker images                         # listar imágenes locales
docker rmi ubuntu                     # eliminar imagen

# Podman (alternativa sin daemon — mismos comandos)
podman run -d --name web nginx
podman ps
```

## Casos prácticos

### Probar una app sin instalarla en el sistema

```bash
# ¿Quieres probar PostgreSQL pero no instalarlo en tu sistema?
docker run -d --name pg-test -e POSTGRES_PASSWORD=secret -p 5432:5432 postgres:16
psql -h localhost -U postgres           # conectar desde el host
# Cuando termines: docker stop pg-test && docker rm pg-test
# Sin residuos en el sistema
```

### Entorno de desarrollo reproducible

```yaml
# docker-compose.yml — app web + base de datos
services:
  web:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app                         # código montado en caliente
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: secret
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

```bash
docker compose up -d                   # levantar entorno completo
# Todo el equipo tiene el mismo entorno: adiós "en mi máquina funciona"
```

### Aislar herramientas que ensucian el sistema

```bash
# Compilar un paquete sin instalar dependencias en el host
docker run --rm -v $(pwd):/workspace -w /workspace node:20 npm install
# npm install corre dentro del contenedor sin dejar node_modules conflictivos
```

## Docker vs Podman vs systemd-nspawn

| Herramienta | Daemon | Rootless | Uso principal |
|---|---|---|---|
| **Docker** | Sí (dockerd) | Limitado | El estándar de la industria |
| **Podman** | No (fork/exec) | Nativo | Alternativa sin daemon, compatible con Docker CLI |
| **systemd-nspawn** | No | Sí | Contenedores estilo "chroot con esteroides", integrado con systemd |
| **LXC/LXD** | Sí | Limitado | Contenedores tipo sistema (más pesados, init completo) |

## Troubleshooting / Problemas comunes

| Problema | Causa | Solución |
|---|---|---|
| `docker: permission denied` | Usuario no en grupo docker | `sudo usermod -aG docker $USER` y reiniciar sesión (ver [[Docker permiso denegado]]) |
| `port is already allocated` | Puerto ya en uso por otro contenedor o proceso | `sudo ss -tlnp | grep :PORT`, cambiar puerto o detener lo que lo ocupa |
| Contenedor se detiene inmediatamente | La app dentro del contenedor falla al iniciar | `docker logs <contenedor>` para ver el error |
| `Cannot connect to the Docker daemon` | Docker no está corriendo | `sudo systemctl enable --now docker` |
| Espacio en disco lleno | Imágenes y contenedores no limpiados | `docker system prune -a` (cuidado: borra todo lo no usado) |

## Relación con otros conceptos

- [[Namespaces (Linux)]] — los namespaces aíslan procesos, red, montajes (base técnica de los contenedores)
- [[cgroups (control de recursos)]] — cgroups limitan CPU, RAM, IO que puede usar un contenedor
- [[Docker]] — la herramienta concreta para crear y gestionar contenedores
- [[systemd-nspawn]] — contenedores ligeros nativos de systemd
- [[Alpine Linux]] — la distro más usada como base de imágenes Docker
- [[Kubernetes]] — orquestación de contenedores a gran escala

## Enlaces externos

- [Wikipedia — LXC (Linux Containers)](https://en.wikipedia.org/wiki/LXC)
- [Wikipedia — Docker](https://en.wikipedia.org/wiki/Docker_(software))
- [Open Container Initiative (OCI)](https://opencontainers.org/)
- [Repositorio de LXC en GitHub](https://github.com/lxc/lxc)

## Ver también

- [[Docker]]
- [[Podman]]
- [[Alpine Linux]]
- [[systemd-nspawn]]
- [[Procesos y Senales]]
- [[Namespaces (Linux)]]

#concepto #contenedores
