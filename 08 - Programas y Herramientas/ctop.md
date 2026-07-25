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

**ctop** (no confundir con ctop de bcicen) es un monitor interactivo de contenedores. Muestra una vista en tiempo real de todos los contenedores en ejecución con sus métricas de consumo, permitiendo ordenar, filtrar y gestionar contenedores desde una sola pantalla.

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
ctop                                  # mostrar todos los contenedores
ctop -a                               # mostrar también contenedores parados
```

## Atajos esenciales

| Tecla | Acción |
|---|---|
| `q` | Salir |
| `a` | Mostrar/ocultar contenedores parados |
| `f` | Filtrar por nombre |
| `s` | Ordenar (CPU, memoria, nombre, estado) |
| `o` | Abrir menú de acciones del contenedor |
| `l` | Ver logs del contenedor |
| `e` | Exec shell dentro del contenedor |
| `r` | Restart contenedor |
| `h` | Ayuda |

## Comparativa

| Aspecto | ctop | lazydocker | docker stats | Portainer |
|---|---|---|---|---|
| **Métricas en vivo** | ✅ CPU/RAM/IO/Red | ✅ | ✅ | ✅ |
| **Logs** | ✅ | ✅ Panel dedicado | ❌ | ✅ |
| **Exec shell** | ✅ | ✅ | ❌ | ✅ Web |
| **Gestión completa** | ❌ Básica | ✅ Completa | ❌ | ✅ |
| **Peso** | ~5 MB | ~15 MB | N/A | ~100 MB |
| **Ideal para** | Monitoreo rápido | Gestión diaria | Scripts | Web UI |

> ctop es ideal para una **vista rápida** de métricas. Para gestionar contenedores (start, stop, logs, exec), [[lazydocker]] es más completo.

## Ver también

- [[lazydocker]] — Docker TUI interactivo (gestión completa)
- [[dive]] — explorar capas de imágenes Docker
- [[Docker]] — notas sobre Docker en el vault
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — bcicen/ctop](https://github.com/bcicen/ctop)

#programa #tui #docker
