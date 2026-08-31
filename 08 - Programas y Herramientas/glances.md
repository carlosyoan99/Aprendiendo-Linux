---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# glances

> Monitor de sistema en terminal (TUI) escrito en Python: CPU, RAM, disco, red, procesos y carga del sistema en tiempo real. Complementa a btop y puede servir estadísticas por web.

## Qué es

**glances** es un monitor de sistema multiplataforma escrito en Python que muestra en tiempo real: CPU, memoria, disco, red, procesos, temperatura, y más. A diferencia de `htop` o `btop`, glances incluye un **servidor web integrado** para monitorear el sistema remotamente y exportación de métricas a CSV/JSON/influxDB.

**Ventajas clave:**
- Modo servidor web para monitoreo remoto (`glances -w`)
- Exportación a CSV, JSON, InfluxDB, Prometheus
- Plugins extensibles (Docker, Spark, RAID, etc.)
- Detecta automáticamente umbrales de alerta (CPU >90%, RAM >80%...)
- TUI ligera con vista por módulos

## Instalación

```bash
# Debian/Ubuntu
sudo apt install glances

# Arch / CachyOS
sudo pacman -S glances

# Fedora
sudo dnf install glances

# Con soporte Docker (extras)
pip install 'glances[docker]'

# Con soporte web
pip install 'glances[web]'
```

## Uso

```bash
glances                     # monitor TUI interactivo
glances -w                  # modo servidor web (http://localhost:61208)
glances --export csv        # exportar métricas a CSV
glances --export json       # exportar a JSON
glances --time 5            # refrescar cada 5 segundos
glances -1                  # vista por CPU (un solo CPU)
```

## Atajos de teclado

| Tecla | Vista |
|---|---|
| `1` | CPU (todos o uno por uno) |
| `2` | Disco |
| `3` | Red |
| `4` | Procesos (lista completa) |
| `5` | Alertas |
| `6` | Temperatura |
| `m` | MEMORIA |
| `n` | Red |
| `d` | Disco |
| `t` | Procesos (modo árbol) |
| `f` | Filtrar procesos |
| `e` | Mostrar/ocultar permisos |
| `q` | Salir |
| `W` | Mostrar/ocultar información de disco |
| `r` | Mostrar/ocultar RAID |

## Uso avanzado

### Servidor web para monitoreo remoto

```bash
# Iniciar servidor en puerto específico
glances -w -p 61209

# Acceder desde otro navegador
http://localhost:61209
```

El servidor web incluye una API REST que puede integrarse con dashboards.

### Exportación a InfluxDB

```bash
# Instalar el plugin
pip install glances-influxdb2

# Ejecutar con exportación
glances --export influxdb2
```

### Configuración (`/etc/glances/glances.conf`)

```ini
[cpu]
careful=50
warning=70
critical=90

[mem]
careful=50
warning=70
critical=90
```

## Comparativa con alternativas

| Aspecto | glances | btop | htop | atop |
|---|---|---|---|---|
| **Servidor web** | ✅ | ❌ | ❌ | ❌ |
| **Exportación métricas** | ✅ CSV/JSON/InfluxDB | ❌ | ❌ | ✅ (atop -r) |
| **Docker integrado** | ✅ (plugin) | ❌ | ❌ | ❌ |
| **GPU monitoring** | ❌ | ✅ | ❌ | ❌ |
| **Rendimiento** | 🐌 Python | ⚡ C++ | ⚡ C | ⚡ C |
| **RAM usage** | ~30MB | ~15MB | ~10MB | ~5MB |
| **Plugins** | ✅ Extensibles | ❌ | ❌ | ❌ |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `ModuleNotFoundError: docker` | Plugin Docker no instalado | `pip install 'glances[docker]'` |
| Servidor web no responde | Puerto bloqueado o no iniciado | Verificar `glances -w -p 61208` y firewall |
| Alertas no aparecen | Umbrales muy altos | Editar `/etc/glances/glances.conf` |
| CPU alta en glances | Refresco muy rápido | Aumentar intervalo: `glances --time 3` |
| No detecta GPU | Falta plugin nvidia | `pip install glances[gpu]` |

## Notas personales

- Lo uso complementariamente a `btop`: glances para el servidor web y exportación, btop para la TUI principal.
- El modo `-w` es útil para monitorear el sistema desde el móvil en la misma red local.

## Enlaces externos

- [Sitio oficial](https://nicolargo.github.io/glances/)
- [GitHub — Glances](https://github.com/nicolargo/glances)
- [Arch Wiki — Glances](https://wiki.archlinux.org/title/Glances)
- [Wikipedia — Glances](https://en.wikipedia.org/wiki/Glances)

## Ver también

- [[btop]] — alternativa todo-en-uno en C++
- [[htop btop]] — nota general sobre monitores
- [[free]] — memoria desde CLI
- [[glances]] — monitor del sistema en Python (TUI + web)
- [[Prometheus]] — monitoreo profesional (glances puede exportar a Prometheus)

#programa #monitor #tui
