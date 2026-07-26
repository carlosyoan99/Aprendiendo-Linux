---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# procps-ng

Conjunto de utilidades para monitorizar y gestionar procesos y recursos del sistema. Viene preinstalado en prácticamente cualquier distro Linux.

## Componentes principales

| Comando | Función |
|---|---|
| `ps` | Listar procesos en ejecución |
| `top` | Monitor interactivo de procesos |
| `free` | Mostrar uso de memoria RAM/swap |
| `uptime` | Tiempo de actividad del sistema |
| `vmstat` | Estadísticas de memoria, CPU, I/O |
| `w` | Usuarios conectados y su actividad |
| `kill` | Enviar señales a procesos |
| `pgrep` / `pkill` | Buscar/matar procesos por nombre |
| `slabtop` | Estadísticas de caché del kernel |

## Ejemplos

```bash
# Uso de memoria
free -h

# Estadísticas del sistema (cada 2 segundos)
vmstat 2

# Usuarios conectados
w

# Matar proceso por nombre
pkill -f nombre_proceso
```

## Ver también

- [[Coreutils y util-linux]] — comandos base del sistema
- [[Utilidades Base del Sistema]] — índice de paquetes base
- [[binutils]] — herramientas de binarios
- [[htop btop]] — monitores modernos
- [[top]] — monitor interactivo de procesos
- [[ps]] — listar procesos

## Enlaces externos

- [GitHub — procps-ng](https://gitlab.com/procps-ng/procps)
- [Wikipedia — procps](https://en.wikipedia.org/wiki/Procps)

#programa #sistema
