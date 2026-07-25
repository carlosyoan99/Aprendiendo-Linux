---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: apk
base: independiente
---

# Alpine Linux

## Filosofía / público objetivo

Distro minimalista orientada a **seguridad y tamaño reducido** (imagen base de ~5 MB, comparado con ~200 MB+ de Ubuntu/Debian). Usa `musl libc` en vez de `glibc` y `busybox` en vez de coreutils GNU.

## ¿Dónde se encuentra Alpine?

Es la distro más usada como **base de imágenes Docker** (`FROM alpine:latest` pesa ~5 MB). También se usa en:

- **Contenedores Docker** — inmensa mayoría de imágenes ligeras en Docker Hub
- **Routers y dispositivos embebidos** — OpenRC sin systemd, footprint mínimo
- **Servidores minimalistas** — sin dependencias innecesarias
- **WSL** — Windows Subsystem for Linux

## Gestor de paquetes: apk

`apk` (Alpine Package Keeper) es rápido, minimalista y gestiona dependencias automáticamente:

```bash
# Búsqueda y repositorios
apk update                               # actualizar índice de paquetes
apk search <termino>                     # buscar por nombre
apk search -v <termino>                  # búsqueda verbose (muestra descripción)
apk search cmd:nginx                     # buscar paquete que contiene un binario
apk search so:libssl.so                  # buscar paquete que provee una lib

# Instalación
apk add <paquete>                        # instalar (guarda índice en /var/cache/apk)
apk add --no-cache <paquete>             # instalar SIN guardar índice (ideal para Docker)
apk add --virtual build-deps gcc make    # paquete virtual (ver abajo)

# Información
apk info <paquete>                       # metadatos del paquete
apk -L info <paquete>                    # listar archivos que instaló
apk list                                 # paquetes instalados
apk list -I                              # paquetes instalados (solo nombres)

# Mantenimiento
apk upgrade                              # actualizar todos los paquetes
apk del <paquete>                        # eliminar paquete
apk del build-deps                       # eliminar paquete virtual (dependencias build)
apk audit                                # verificar integridad de archivos del sistema
```

### Paquetes virtuales

Útiles para compilar e inmediatamente limpiar las dependencias:

```bash
# Instalar herramientas de build como paquete virtual
apk add --virtual .build-deps gcc make musl-dev linux-headers

# Compilar algo...
make && make install

# Eliminar todo el grupo de una vez
apk del .build-deps
```

### Repositorios

Archivo `/etc/apk/repositories` — por defecto incluye `main` y `community`:

```text
https://dl-cdn.alpinelinux.org/alpine/v3.21/main
https://dl-cdn.alpinelinux.org/alpine/v3.21/community
# https://dl-cdn.alpinelinux.org/alpine/edge/main    # edge (rolling)
# https://dl-cdn.alpinelinux.org/alpine/edge/testing # paquetes experimentales
```

## musl vs glibc: diferencias clave

| Característica | glibc (Ubuntu, Debian, Arch, Fedora) | musl (Alpine) |
|---|---|---|
| **Tamaño de libc** | ~2 MB | ~0.6 MB |
| **Compatibilidad binaria** | Universal (estándar de facto) | Parcial — binarios precompilados para glibc no funcionan |
| **DNS resolution** | `/etc/nsswitch.conf` (NSS modular) | Resolución simple, /etc/hosts + /etc/resolv.conf |
| **Locales** | Completo (`locale-gen`, cientos de locales) | Limitado (`musl-locales`, solo UTF-8 básico) |
| **Threading** | NPTL (Native POSIX Thread Library) | Implementación propia compatible |
| **Malloc** | Arena-based (rendimiento multi-hilo) | Simple (menos memoria, más lento en multi-hilo) |
| **Errores comunes** | — | `wget` HTTPS falla si falta `ca-certificates` |
| **Static binaries** | Pesadas (~1 MB hello world) | Mucho más pequeñas (~10 KB hello world) |

```bash
# Saber qué libc usa tu sistema
ldd --version 2>&1 | head -1             # si muestra "musl" → estás en Alpine

# Si necesitas un binario compilado para glibc en Alpine:
apk add gcompat                          # capa de compatibilidad glibc para musl
# gcompat no es 100% — algunas apps pueden fallar
```

## Init system: OpenRC

Alpine usa **OpenRC** en vez de systemd. Es más simple, más rápido, y sin dependencias pesadas:

```bash
# Gestión de servicios
rc-service nginx start                   # iniciar servicio
rc-service nginx stop                    # detener
rc-service nginx restart                 # reiniciar
rc-service nginx status                  # estado

# Habilitar en arranque
rc-update add nginx default              # añadir al runlevel default
rc-update del nginx                      # quitar del arranque
rc-update show                           # ver todos los servicios y runlevels

# Estado del sistema
rc-status                                # estado de todos los servicios
rc-status --all                          # incluyendo detenidos
rc-status -s                             # solo servicios iniciados

# Iniciar sesión de OpenRC manualmente (útil dentro de contenedores)
openrc default                           # arrancar servicios del runlevel default
openrc shutdown                          # detener servicios
```

### OpenRC vs systemd

| Aspecto | OpenRC (Alpine) | systemd (Ubuntu, Arch, Fedora) |
|---|---|---|
| **Tamaño** | ~2 MB | ~50 MB (con dependencias) |
| **Dependencias** | Casi ninguna (shell + /sbin/init) | dbus, udev, logind, journald... |
| **Paralelización** | Limitada | Completa (socket/unit activation) |
| **Logs** | Archivos de texto en `/var/log/` | journald (binario) |
| **Complejidad** | Baja (scripts shell) | Alta (C + unidades declarativas) |
| **Configuración** | Scripts en `/etc/init.d/` | Archivos .service en `/usr/lib/systemd/` |

## Alpine en contenedores Docker

Alpine es la base de imágenes más popular en Docker precisamente por su tamaño mínimo:

```dockerfile
# Dockerfile básico — imagen de ~50 MB con Node.js
FROM alpine:latest

# --no-cache imprescindible: evita guardar el índice en la capa
RUN apk add --no-cache nodejs npm

# Alternativa: si necesitas build tools temporales
RUN apk add --no-cache --virtual .build-deps python3 make g++ && \
    npm install     && \
    apk del .build-deps

WORKDIR /app
COPY . .
CMD ["node", "index.js"]
```

```bash
# Tamaños comparativos de imágenes Docker
docker images --format "{{.Repository}}:{{.Tag}}\t{{.Size}}"
# alpine:latest           → 7.05 MB
# ubuntu:latest           → 78 MB
# node:20-alpine          → 130 MB
# node:20                 → 1.1 GB
# python:3.12-alpine      → 57 MB
# python:3.12             → 1.0 GB
```

**Ventaja**: imágenes 10-20× más pequeñas → builds más rápidos, menos ancho de banda, menor superficie de ataque.

**Riesgo**: paquetes npm/gems/pip nativos (C/C++) pueden necesitar compilación para musl, alargando el build. Si no compilan, usa `FROM debian:stable-slim` como alternativa ligera.

### Instalación en contenedor (Ad-hoc)

```bash
# Probar Alpine sin instalarlo en el sistema
docker run -it alpine:latest /bin/sh

# Ya dentro del contenedor Alpine:
cat /etc/os-release                     # NAME="Alpine Linux"
apk add --no-cache curl vim             # instalar lo que necesites
curl https://ejemplo.com                 # funciona con apk add ca-certificates

# Con OpenRC (necesita --privileged o montar cgroups — complicado)
# docker run -it --rm --privileged alpine:latest /bin/sh
# El patrón estándar en Docker es ejecutar servicios en foreground:
apk add --no-cache nginx
nginx -g 'daemon off;'                   # nginx en foreground (patrón Docker)
```

### Alpine como base para imágenes multi-etapa

```dockerfile
# Etapa 1: compilar en Alpine con --virtual
FROM alpine:latest AS builder
RUN apk add --no-cache --virtual .build go
COPY main.go .
RUN go build -o /app main.go

# Etapa 2: imagen final minúscula
FROM alpine:latest
COPY --from=builder /app /app
CMD ["/app"]
# Resultado: imagen final de ~12 MB
```

## Alpine vs otras distros minimalistas

| Aspecto | Alpine | Debian slim | Arch Linux | Busybox |
|---|---|---|---|---|
| **Tamaño base** | ~5 MB | ~80 MB | ~800 MB |
| **Libc** | musl | glibc | glibc |
| **Init** | OpenRC | systemd | systemd |
| **Gestor paquetes** | apk | apt | pacman |
| **Caso de uso** | Contenedores, embebido | Servidores, contenedores | Escritorio avanzado |

## Notas de instalación propias

- Alpine no tiene sistema de instalación gráfico — la instalación en bare metal se hace desde consola con `setup-alpine`
- Ideal para VPS: consume ~50 MB RAM en idle
- Para debugging: `apk add util-linux` da acceso a dmesg, lsblk, lscpu
- Algunas imágenes Docker oficiales usan `alpine:3.21` en vez de `latest` por reproducibilidad

## Enlaces externos

- [Wikipedia — Alpine Linux](https://en.wikipedia.org/wiki/Alpine_Linux)
- [Sitio oficial](https://alpinelinux.org/)
- [Alpine Wiki — apk](https://wiki.alpinelinux.org/wiki/Alpine_Package_Keeper)
- [Alpine Wiki — OpenRC](https://wiki.alpinelinux.org/wiki/OpenRC)
- [musl libc — Differences from glibc](https://wiki.musl-libc.org/functional-differences-from-glibc.html)
- [GitHub gliderlabs/docker-alpine](https://github.com/gliderlabs/docker-alpine)
- [Docker Hub — Alpine oficial](https://hub.docker.com/_/alpine)

## Ver también

- [[Arch Linux]] — enfoque minimalista pero con glibc y systemd
- [[Gestores de Paquetes]] — comparativa entre apk, apt, pacman, dnf
- [[systemd]] — el init que Alpine NO usa (OpenRC en su lugar)
- [[Utilidades Base del Sistema]] — busybox vs GNU coreutils
- [[Contenedores]] — cómo Alpine se usa como base de contenedores
- [[Docker]] — Alpine es la imagen base más popular en Docker Hub
- [[Busybox]] — el entorno base que Alpine utiliza

#distro
