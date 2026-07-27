---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
---

# lazydocker

> Interfaz TUI para Docker y Docker Compose. Gestiona contenedores, imágenes, volúmenes y redes desde la terminal con paneles visuales. El mismo creador que **lazygit**.

## Qué es

**lazydocker** es un cliente Docker interactivo para terminal. Muestra el estado del ecosistema Docker en paneles: contenedores en ejecución/parados, imágenes descargadas, volúmenes y redes. Permite ejecutar todas las operaciones comunes (start, stop, restart, logs, exec, prune) sin recordar comandos Docker.

Escrito en Go, binario único.

## Instalación

```bash
# Debian/Ubuntu (necesita repositorio Docker configurado)
sudo apt install lazydocker

# Arch
sudo pacman -S lazydocker

# Fedora
sudo dnf install lazydocker

# Homebrew (macOS/Linux)
brew install lazydocker

# Desde GitHub (binario estático recomendado)
# https://github.com/jesseduffield/lazydocker/releases

# O con Docker:
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock lazyteam/lazydocker
```

## Atajos esenciales

### Globales

| Tecla | Acción |
|---|---|
| `q` | Salir |
| `?` | Ayuda completa |
| `Tab` | Cambiar entre paneles |
| `x` | Menú de comandos |

### Contenedores

| Tecla | Acción |
|---|---|
| `espacio` | Iniciar/Detener contenedor |
| `d` | Eliminar contenedor |
| `s` | Restart |
| `e` | Exec (abrir shell dentro del contenedor) |
| `l` | Ver logs en tiempo real |
| `Enter` | Mostrar logs |
| `[` / `]` | Cambiar entre pestañas de logs |

### Imágenes

| Tecla | Acción |
|---|---|
| `d` | Eliminar imagen |
| `p` | Prune imágenes no usadas |
| `Enter` | Ver capas de la imagen |

### Volúmenes y redes

| Tecla | Acción |
|---|---|
| `d` | Eliminar |
| `p` | Prune (volúmenes/redes no usados) |

## Flujo de trabajo típico

```bash
# Desde cualquier directorio con docker-compose.yml
cd ~/proyecto
lazydocker

# 1. Ver contenedores (panel superior izquierdo)
# 2. Navegar logs (panel inferior)
# 3. Comandos rápidos:
#    - espacio: stop/start container
#    - e: abrir bash dentro del contenedor
#    - l: seguir logs en vivo
#    - d: eliminar (con confirmación)
```

## Comparativa

| Aspecto | lazydocker | docker CLI | Portainer (web) | Dockly |
|---|---|---|---|---|
| **Curva aprendizaje** | Muy baja | Alta | Baja | Baja |
| **Logs en vivo** | ✅ Panel dedicado | ✅ `docker logs -f` | ✅ Web UI | ✅ |
| **Exec en contenedor** | ✅ Con un click | ✅ `docker exec -it` | ✅ Web terminal | ✅ |
| **Docker Compose** | ✅ Integrado | ✅ `docker-compose` | ❌ | ❌ |
| **Prune** | ✅ Desde menú | ✅ `docker system prune` | ✅ | ❌ |
| **Rendimiento** | Rápido | N/A | Más pesado | Rápido |
| **Binario único** | ✅ Sí | ✅ | ❌ Web server | ✅ |

> Si usas Docker constante, lazydocker te ahorra escribir comandos todo el día. Si solo usas `docker run` de vez en cuando, no lo necesitas.

## Ver también

- [[Docker]] — Docker en el vault
- [[Contenedores orquestación]] — Docker Compose, Swarm, K8s
- [[dive]] — explorar capas de imágenes Docker
- [[ctop]] — top-like para contenedores
- [[k9s]] — el equivalente a lazydocker pero para Kubernetes
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — jesseduffield/lazydocker](https://github.com/jesseduffield/lazydocker)
- [Sitio oficial](https://lazydocker.github.io/)

#programa #tui #docker
