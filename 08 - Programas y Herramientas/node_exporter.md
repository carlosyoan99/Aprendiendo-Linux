---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# node_exporter

Recolector estándar de métricas del sistema Linux para [[Prometheus]]. Expone CPU, RAM, disco, red, temperatura y más en formato texto en el endpoint `/metrics`. No necesita configuración — se ejecuta y ya.

## Instalación

```bash
# Descargar última versión
curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | \
  grep browser_download_url | grep linux-amd64 | cut -d'"' -f4 | wget -qi -
tar xzf node_exporter-*.linux-amd64.tar.gz
sudo install node_exporter-*/node_exporter /usr/local/bin/

# Desde repos (versión más antigua)
sudo apt install prometheus-node-exporter   # Debian/Ubuntu
sudo pacman -S prometheus-node-exporter     # Arch
```

## Servicio systemd

```bash
# /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
Type=simple
User=nobody
Group=nogroup
ExecStart=/usr/local/bin/node_exporter \
  --web.listen-address=:9100 \
  --path.procfs=/proc \
  --path.sysfs=/sys \
  --collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($|/)
Restart=always

[Install]
WantedBy=multi-user.target

sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
```

## Colectores disponibles

```bash
# Ver qué colectores están activos
node_exporter --help | grep collector

# Activar/desactivar
--collector.diskstats        # estadísticas de disco (por defecto: sí)
--collector.meminfo          # memoria (sí)
--collector.cpu              # CPU (sí)
--collector.netstat          # red (sí)
--collector.systemd          # unidades systemd (no)
--collector.processes        # procesos (no)
--no-collector.arp           # desactivar ARP
```

## Métricas principales

| Métrica | Descripción |
|---|---|
| `node_cpu_seconds_total` | Tiempo de CPU por modo (user, system, idle) |
| `node_memory_MemTotal_bytes` | RAM total |
| `node_memory_MemAvailable_bytes` | RAM disponible |
| `node_filesystem_avail_bytes` | Espacio disponible en disco |
| `node_network_receive_bytes_total` | Bytes recibidos por interfaz |
| `node_disk_io_time_seconds_total` | Tiempo de E/S de disco |
| `node_load1` / `node_load5` / `node_load15` | Load average |
| `node_systemd_unit_state` | Estado de unidades systemd |
| `node_boot_time_seconds` | Timestamp de arranque |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Puerto 9100 no responde | Servicio detenido o firewall | `systemctl status node_exporter`; abrir `9100` en firewall |
| Métricas vacías tras configurar collector | Colector deshabilitado por defecto | Añadir `--collector.xxx` al arranque (p.ej. `--collector.systemd`) |
| `node_exporter` no inicia por permisos | Falta binario o usuario inexistente | Crear usuario dedicado y revisar `systemctl cat` |
| Duplicación de métricas de disco | `textfile` y colector a la vez | Limpiar `/var/lib/node_exporter/textfile` solapado |
| Timeout en scrape | Demasiados collectors o máquina lenta | Deshabilitar collectors pesados con `--no-collector.xxx` |

## Comparativa con alternativas

| Herramienta | Tipo | Métricas | Formato | Cuándo elegirla |
|---|---|---|---|---|
| **node_exporter** | Daemon ligero (Go) | Sistema: CPU, RAM, disco, red, filesystems | Prometheus (text exposition) | Es el estándar del stack Prometheus |
| **Telegraf** (InfluxData) | Agente con muchos plugins | Sistema + apps (MySQL, Docker, MQTT...) | InfluxDB, Prometheus, Graphite... | Necesitas métricas de apps sin escribir exporters |
| **collectd** | Daemon clásico (C) | Sistema + plugins | RRD, Graphite, Prometheus (vía plugin) | Sistemas legacy, bajo consumo |
| **Netdata** | Daemon en tiempo real | Sistema + apps, dashboard propio | Proprietary (con export a Prometheus) | Quieres dashboards listos sin Grafana |
| **sysstat (sar/iostat)** | Herramientas CLI | Sistema por intervalos | Texto/CSV | Auditoría histórica puntual, sin daemon de red |

**Recomendación**: si ya usas Prometheus, node_exporter es la elección natural. Si quieres un dashboard sin montar Grafana, Netdata es más rápido de desplegar. Telegraf gana cuando necesitas un solo agente para todo (sistema + apps + colas).

## Ver también

- [[Prometheus]] — servidor que recolecta las métricas
- [[Monitorización (Prometheus node_exporter)]] — índice del stack
- [[Grafana]] — dashboards visuales
- [[smartctl]] — métricas SMART
- [[cgroups (control de recursos)]]

## Enlaces externos

- [GitHub — prometheus/node_exporter](https://github.com/prometheus/node_exporter)

#programa
