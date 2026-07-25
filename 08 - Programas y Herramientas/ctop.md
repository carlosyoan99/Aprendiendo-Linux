---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: baja
---

# ctop

> `top` para contenedores. Muestra métricas en tiempo real de todos los contenedores: CPU, memoria, red, E/S. Similar a `htop` pero para Docker/Podman.

## Qué es

**ctop** (no confundir con ctop de bcicen) es un monitor interactivo de contenedores. Muestra una vista en tiempo real de todos los contenedores en ejecución con sus métricas de consumo (CPU, memoria, red, E/S de disco), permitiendo ordenar, filtrar y gestionar contenedores desde una sola pantalla.

No requiere Docker Compose ni configuración especial — solo necesita acceso al socket de Docker.

## Instalación

```bash
# Desde GitHub (binario estático - recomendado)
curl -sL https://github.com/bcicen/ctop/releases/latest/download/ctop-linux-amd64 -o ctop
chmod +x ctop
sudo mv ctop /usr/local/bin/

# Snap
sudo snap install ctop

# Arch (AUR)
yay -S ctop-bin
```

## Uso básico

```bash
ctop                                  # mostrar todos los contenedores en ejecución
ctop -a                               # mostrar también contenedores parados
```

## Atajos esenciales

| Tecla | Acción |
|---|---|
| `q` | Salir |
| `a` | Mostrar/ocultar contenedores parados |
| `f` | Filtrar por nombre (escribe texto mientras ves ctop) |
| `s` | Ordenar: CPU, memoria, nombre, estado |
| `o` | Abrir menú de acciones del contenedor seleccionado |
| `l` | Ver logs del contenedor (tail -f) |
| `e` | Exec shell (`/bin/bash` o `/bin/sh`) dentro del contenedor |
| `r` | Restart contenedor |
| `h` | Ayuda completa |

## Salida típica

```
ctop - 16/08/2026 14:30:22                          Config
  NAME                    CPU %     MEM %     MEM NEW   NET RX/TX    IO R/W
● nginx                   0.12%     1.45%     28MiB     3.2/1.8MB    0B/0B
○ postgres                0.00%     2.10%     42MiB     0B/0B        0B/0B
● redis                   0.05%     0.80%     16MiB     1.1/0.5KB    0B/0B
● mi-app                  2.30%     3.50%     68MiB     12.4/5.2KB   1.2MB/0B

  ● = corriendo  ○ = parado
```

## Ordenar por columna

```bash
# Presionar 's' para abrir el menú de ordenación
# Elegir entre: cpu, mem, net, io, name, state

# Ordenación persistente:
# ctop recuerda la última columna seleccionada
```

## Casos de uso reales

```bash
# 1. Ver qué contenedor consume más memoria
ctop -a           # abrir, presionar 's' → seleccionar 'mem'

# 2. Encontrar un contenedor por nombre
ctop              # abrir, presionar 'f', escribir "nginx"

# 3. Ver logs de un contenedor problemático
ctop              # navegar al contenedor, presionar 'l'

# 4. Entrar a un contenedor para debuggear
ctop              # navegar, presionar 'e' → se abre bash

# 5. Monitoreo rápido de CPU de todos los contenedores
ctop              # ordenar por CPU, ver actualización en vivo
```

## Comparativa

| Aspecto | ctop | lazydocker | docker stats | Portainer |
|---|---|---|---|---|
| **Métricas en vivo** | ✅ CPU/RAM/IO/Red | ✅ | ✅ | ✅ |
| **Logs** | ✅ Rápido | ✅ Panel dedicado | ❌ | ✅ |
| **Exec shell** | ✅ | ✅ | ❌ | ✅ Web |
| **Gestión completa** | ❌ Básica (start/stop/restart) | ✅ Completa | ❌ | ✅ |
| **Peso** | ~5 MB | ~15 MB | N/A | ~100 MB |
| **Dependencias** | Ninguna (binario único) | Ninguna | Docker CLI | Docker + servidor web |
| **Ideal para** | Monitoreo rápido | Gestión diaria | Scripts | Web UI multi-usuario |

> ctop es ideal para una **vista rápida** de métricas de un vistazo. Para gestionar contenedores (start, stop, logs detallados, exec, Compose), [[lazydocker]] es más completo.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `Could not connect to Docker` | Usuario no está en grupo docker | `sudo usermod -aG docker $USER && newgrp docker` |
| No veo contenedores | Docker daemon no corriendo | `sudo systemctl start docker` |
| ctop no disponible en apt | No está en repos oficiales | Usar binario estático desde GitHub |
| Métricas de red a 0 | Contenedor sin tráfico activo | Hacer ping o curl desde dentro del contenedor |

## Ver también

- [[lazydocker]] — Docker TUI interactivo (gestión completa)
- [[dive]] — explorar capas de imágenes Docker
- [[Docker]] — notas sobre Docker en el vault
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — bcicen/ctop](https://github.com/bcicen/ctop)

#programa #tui #docker
