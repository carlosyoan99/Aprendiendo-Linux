---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# dive

> Explorador de capas de imágenes Docker. Analiza el contenido de cada capa, identifica espacio desperdiciado y ayuda a optimizar Dockerfiles.

## Qué es

**dive** es una herramienta TUI para inspeccionar imágenes Docker capa por capa. Muestra qué archivos añade, modifica o elimina cada capa, el tamaño de cada una, y sugiere mejoras para reducir el tamaño final de la imagen.

Escrito en Go, binario único. Esencial para optimizar Dockerfiles.

## Instalación

```bash
# Debian/Ubuntu (necesita repo Docker)
sudo apt install dive

# Arch
sudo pacman -S dive

# Fedora
sudo dnf install dive

# Homebrew
brew install dive

# Desde GitHub (binario estático)
# https://github.com/wagoodman/dive/releases

# O con Docker
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive
```

## Uso básico

```bash
# Analizar una imagen existente
dive nginx:latest
dive mi-app:latest

# Analizar desde un Docker build (sin tag)
dive docker://nginxdemos/hello

# Atajos: Tab = cambiar panel, flechas = navegar capas
# Enter = colapsar/expandir directorio
# Ctrl+Espacio = marcar diferencia
```

## Atajos esenciales

| Tecla | Acción |
|---|---|
| `Tab` | Cambiar entre paneles (capas / árbol archivos) |
| `Flechas` | Navegar entre capas |
| `Enter` | Expandir/colapsar directorio |
| `Ctrl+Espacio` | Marcar/desmarcar diferencia |
| `Ctrl+F` | Buscar archivo |
| `Ctrl+U` | Mostrar solo archivos únicos (no en capas anteriores) |
| `q` | Salir |
| `?` | Ayuda |

## Interpretación de la salida

```
┌─ Capas ──────────────────┬─ Árbol de archivos ────────┐
│ ▶ 1. FROM debian:11      │ /etc/nginx/nginx.conf       │
│   2. RUN apt update      │ /usr/share/nginx/html/      │
│ ▶ 3. COPY . /app         │ /app/node_modules/ (55 MB)  │ ← MUCHO PESO
│   4. RUN npm install     │ /app/src/                   │
│ ▶ 5. RUN rm -rf /tmp/*   │                             │
│                          │                             │
│ Imagen eficiencia: 92%   │ Espacio potencial: 45 MB    │
│                          │                             │
│ ⚠️  Capa 4 añadió 55 MB  │                             │
└──────────────────────────┴─────────────────────────────┘
```

### Indicadores de eficiencia

| Indicador | Significado |
|---|---|
| Porcentaje | Qué % del espacio total es realmente útil |
| Espacio potencial | MB que se podrían recuperar optimizando capas |
| ⚠️ Wasted space | Archivos eliminados en capas posteriores (innecesarios) |

## Optimización de Dockerfiles con dive

```dockerfile
# MAL — capa 2 incluye el build cache que se elimina en capa 3
# pero el espacio queda ocupado en la capa 2
RUN npm install
RUN rm -rf /root/.npm

# BIEN — todo en una sola capa, sin espacio desperdiciado
RUN npm install && rm -rf /root/.npm

# MEJOR — multi-stage build
FROM node:18 AS builder
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine
COPY --from=builder /app/node_modules ./node_modules
COPY . .
```

## Comparativa

| Aspecto | dive | docker history | docker inspect | Docker Desktop |
|---|---|---|---|---|
| **Vista por capas** | ✅ Interactiva | ✅ Texto plano | ❌ | ✅ |
| **Árbol archivos** | ✅ Expandible | ❌ | ✅ JSON | ✅ |
| **Espacio desperdiciado** | ✅ Detecta automáticamente | ❌ | ❌ | ❌ |
| **Sugerencias de mejora** | ✅ | ❌ | ❌ | ❌ |

> dive es la mejor herramienta para **optimizar** imágenes. Para uso diario (logs, exec, start/stop) usa [[lazydocker]].

## Ver también

- [[Docker]] — contenedores en el vault
- [[lazydocker]] — Docker TUI interactivo
- [[Contenedores orquestación]] — Docker Compose, Swarm, K8s
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — wagoodman/dive](https://github.com/wagoodman/dive)
- [Artículo: Optimizando imágenes Docker con dive](https://wagoodman.com/2019/04/15/optimizing-docker-images-with-dive/)

#programa #tui #docker
