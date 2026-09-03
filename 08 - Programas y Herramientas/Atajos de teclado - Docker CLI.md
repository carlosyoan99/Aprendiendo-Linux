---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# Atajos de teclado - Docker CLI

> Aliases, funciones shell y atajos para trabajar con **Docker** de forma eficiente. Docker es CLI, así que los "atajos" son aliases en `~/.bashrc`/`~/.zshrc` y funciones que simplifican comandos frecuentes de contenedores, imágenes, redes y volúmenes.

## Aliases esenciales (~/.bashrc o ~/.zshrc)

```bash
# --- Contenedores ---
alias dk='docker'
alias dkc='docker container'
alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dkl='docker logs'
alias dklf='docker logs -f'
alias dki='docker inspect'
alias dkr='docker run -it --rm'
alias dke='docker exec -it'
alias dkrm='docker rm -f'
alias dkstop='docker stop $(docker ps -q)'
alias dkkill='docker kill $(docker ps -q)'

# --- Imágenes ---
alias dki='docker images'
alias dkpull='docker pull'
alias dkbuild='docker build'
alias dktag='docker tag'
alias dkpush='docker push'
alias dkmi='docker image ls'
alias dkrmimg='docker image rm'
alias dkprune='docker system prune -af'
alias dkprunev='docker volume prune -f'

# --- Redes ---
alias dkn='docker network'
alias dknl='docker network ls'
alias dkn inspect='docker network inspect'

# --- Volumenes ---
alias dkv='docker volume'
alias dkvl='docker volume ls'

# --- Docker Compose ---
alias dco='docker compose'
alias dcup='docker compose up -d'
alias dcdown='docker compose down'
alias dcps='docker compose ps'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'
alias dcr='docker compose run --rm'
alias dcb='docker compose build'
alias dcpull='docker compose pull'
alias dce='docker compose exec'

# --- System ---
alias dks='docker system'
alias dkdf='docker system df'
alias dkpr='docker system prune'
```

---

## Comandos Docker rápidos (sin alias)

### Contenedores

| Comando | Alias | Efecto |
|---|---|---|
| `docker ps` | `dkps` | Contenedores en ejecución |
| `docker ps -a` | `dkpsa` | Todos los contenedores (incl. detenidos) |
| `docker run -it --rm ubuntu bash` | `dkr ubuntu bash` | Ubuntu interactivo, eliminarse al salir |
| `docker exec -it <id> bash` | `dke <id> bash` | Shell en contenedor en ejecución |
| `docker logs -f <id>` | `dklf <id>` | Logs en tiempo real |
| `docker stop <id>` | — | Parar contenedor gracefully |
| `docker kill <id>` | — | Matar contenedor (SIGKILL) |
| `docker rm <id>` | — | Eliminar contenedor detenido |
| `docker rm -f <id>` | `dkrm <id>` | Forzar eliminación de contenedor activo |
| `docker inspect <id>` | `dki <id>` | Info detallada (JSON) |
| `docker stats` | — | Uso de CPU/RAM en tiempo real |
| `docker top <id>` | — | Procesos dentro del contenedor |
| `docker cp <id>:/path ./` | — | Copiar archivos del contenedor |
| `docker cp ./file <id>:/path` | — | Copiar archivos al contenedor |

### Imágenes

| Comando | Alias | Efecto |
|---|---|---|
| `docker images` | `dki` | Listar imágenes locales |
| `docker pull nginx:alpine` | `dkpull nginx:alpine` | Descargar imagen |
| `docker build -t mi-app .` | `dkbuild -t mi-app .` | Construir imagen desde Dockerfile |
| `docker tag mi-app user/mi-app:v1` | `dktag mi-app user/mi-app:v1` | Etiquetar imagen |
| `docker push user/mi-app:v1` | `dkpush user/mi-app:v1` | Subir a registry |
| `docker rmi <imagen>` | — | Eliminar imagen |
| `docker image prune -a` | — | Eliminar imágenes sin uso |
| `docker history <imagen>` | — | Ver capas de la imagen |
| `docker inspect <imagen>` | — | Info de la imagen |

### Docker Compose

| Comando | Alias | Efecto |
|---|---|---|
| `docker compose up -d` | `dcup` | Levantar servicios en background |
| `docker compose down` | `dcdown` | Detener y eliminar servicios |
| `docker compose ps` | `dcps` | Estado de servicios |
| `docker compose logs -f` | `dclf` | Logs en tiempo real |
| `docker compose logs -f <svc>` | — | Logs de un servicio específico |
| `docker compose exec <svc> bash` | `dce <svc> bash` | Shell en servicio |
| `docker compose run --rm <svc> cmd` | `dcr <svc> cmd` | Ejecutar comando en servicio |
| `docker compose build` | `dcb` | Reconstruir imágenes |
| `docker compose pull` | `dcpull` | Actualizar imágenes |
| `docker compose restart <svc>` | — | Reiniciar servicio |
| `docker compose config` | — | Verificar docker-compose.yml |

### Redes y volúmenes

| Comando | Efecto |
|---|---|
| `docker network ls` | Redes disponibles |
| `docker network create mi-red` | Crear red |
| `docker network connect mi-red <id>` | Conectar contenedor a red |
| `docker network disconnect mi-red <id>` | Desconectar contenedor |
| `docker volume ls` | Volúmenes disponibles |
| `docker volume create mi-vol` | Crear volumen |
| `docker volume rm mi-vol` | Eliminar volumen |

---

## Funciones shell útiles

```bash
# Parar y eliminar TODOS los contenedores en ejecución
dkstopall() {
  docker stop $(docker ps -q) 2>/dev/null
  echo "Todos los contenedores detenidos."
}

# Eliminar todos los contenedores detenidos
dkclean() {
  docker container prune -f
  docker image prune -af
  docker volume prune -f
  docker network prune -f
  echo "Limpieza completada."
}

# Ver uso de disco Docker
dkusage() {
  docker system df -v
}

# Entrar como root en un contenedor
dkroot() {
  if [ -z "$1" ]; then
    echo "Uso: dkroot <container_id>"
    return 1
  fi
  docker exec -u 0 -it "$1" bash
}

# Logs de los últimos N minutos
dklogs() {
  local container=$1
  local minutes=${2:-5}
  docker logs --since "${minutes}m" "$container"
}

# Ejecutar shell en el último contenedor creado
dklast() {
  local id=$(docker ps -lq)
  docker exec -it "$id" bash
}

# Verificar si Docker está corriendo
dkcheck() {
  docker info >/dev/null 2>&1 && echo "Docker está activo" || echo "Docker NO está corriendo"
}

# Docker Compose: levantar + logs en una línea
dcuplogs() {
  docker compose up -d && docker compose logs -f
}
```

---

## Atajos de teclado del shell para Docker

| Atajo | Efecto |
|---|---|
| `Ctrl+R` | Buscar comandos Docker anteriores en historial |
| `Tab` | Autocompletar nombres de contenedores/imágenes |
| `Tab Tab` | Listar todas las opciones disponibles |
| `Ctrl+C` | Cancelar `docker logs -f` o `docker attach` |
| `Ctrl+P Ctrl+Q` | Desacoplar de `docker attach` sin matar el contenedor |
| `Ctrl+Z` | Suspender contenedor (fg para continuar) |

---

## Atajos dentro de `docker attach`

| Atajo | Efecto |
|---|---|
| `Ctrl+P Ctrl+Q` | Desacoplar sin matar (detach) |
| `Ctrl+C` | Enviar SIGINT (parar proceso graceful) |
| `Ctrl+\` | Enviar SIGQUIT (parar con core dump) |
| `Ctrl+Z` | Suspender proceso |

---

## Atajos dentro de `docker exec`

| Atajo | Efecto |
|---|---|
| `Ctrl+D` | Salir del shell (exit) |
| `Ctrl+C` | Cancelar comando actual |
| `Ctrl+R` | Buscar en historial del shell dentro del container |
| `Tab` | Autocompletar (si bash/zsh instalado en el container) |

---

## Atajos en docker-compose.yml

```yaml
# Snippets útiles para ahorrar tiempo

# Variables de entorno reutilizables
x-common-env: &common-env
  NODE_ENV: production
  LOG_LEVEL: info

# Servicios que heredan
services:
  app:
    <<: *common-env
    ports:
      - "3000:3000"

  worker:
    <<: *common-env
    command: node worker.js
```

---

## Docker Compose atajos de teclado (TUI)

```bash
# Si usas lazydocker (TUI para Docker):
# Enter → seleccionar contenedor
# d → detener
# s → shell
# l → logs
# r → reiniciar
# m → mostrar detalles
# Ctrl+A → acciones (pause, unpause, etc.)
# q → salir
```

---

## Ver también

- [[Docker]] — conceptos y uso completo de Docker
- [[Docker Compose]] — orquestación de múltiples contenedores
- [[Docker permiso denegado]] — troubleshooting de permisos Docker
- [[Podman]] — alternativa rootless a Docker
- [[Shells (bash zsh fish)]] — atajos generales de shell
- [[tmux]] — multiplexor de terminal para sesiones Docker

#atajos #docker #containers #cli
