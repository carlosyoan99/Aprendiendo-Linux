---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
---

# Prometheus

Sistema de monitorización y alerta de código abierto que recoge **métricas numéricas** de sistemas y servicios en intervalos regulares. Es el estándar de facto en monitorización cloud-native.

## Arquitectura

```
Prometheus "scrapea" (recolecta) métricas de exportadores cada cierto intervalo
y las almacena en una base de datos de series temporales (TSDB).

┌────────────┐    ┌────────────┐
│ Exportador │    │ Exportador │  ← servidores con node_exporter, redis_exporter, etc.
│ :9100      │    │ :9100      │
└─────┬──────┘    └─────┬──────┘
      │                 │
      └────────┬────────┘
               ▼
        ┌──────────────┐
        │  Prometheus  │
        │  :9090       │
        └──────┬───────┘
               │
     ┌─────────┼──────────┐
     ▼         ▼          ▼
  Grafana  Alertmanager   PromQL
```

## Instalación

```bash
# Descargar
wget https://github.com/prometheus/prometheus/releases/latest/download/prometheus-*.linux-amd64.tar.gz
tar xzf prometheus-*.linux-amd64.tar.gz
sudo install prometheus-*/prometheus prometheus-*/promtool /usr/local/bin/
```

## Configuración básica (`prometheus.yml`)

```yaml
# /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'servidores'
    static_configs:
      - targets:
        - '192.168.1.10:9100'
        - '192.168.1.11:9100'
```

### Servicio systemd

```bash
# /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
After=network.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries
Restart=always

[Install]
WantedBy=multi-user.target

# Crear usuario y directorios
sudo useradd -r -s /bin/false prometheus
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo systemctl daemon-reload && sudo systemctl enable --now prometheus
```

## PromQL — Consultas

```promql
# Valores actuales
node_load1
node_memory_MemAvailable_bytes / 1024 / 1024

# Tasas (rate) — por segundo
rate(node_cpu_seconds_total{mode="idle"}[5m])
rate(node_network_receive_bytes_total[1m])

# Agregaciones
sum(rate(node_cpu_seconds_total{mode!="idle"}[5m])) by (instance)
topk(3, node_load1)

# CPU usage (%)
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# RAM usage (%)
(1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100

# Tiempo de actividad (días)
(time() - node_boot_time_seconds) / 86400
```

## Alertas (Alertmanager)

```yaml
# /etc/prometheus/rules.yml
groups:
  - name: servidores
    rules:
      - alert: ServidorCaido
        expr: up == 0
        for: 5m
        annotations:
          summary: "Servidor {{ $labels.instance }} caído"

      - alert: DiscoLLeno
        expr: (node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes > 0.9
        for: 5m
```

```yaml
# Incluir en prometheus.yml
rule_files:
  - "/etc/prometheus/rules.yml"
```

## Comparativa con alternativas

| Herramienta | Tipo | Modelo de datos | Escalado | Cuándo elegirla |
|---|---|---|---|---|
| **Prometheus** | Time-series DB + scrape | Métricas pull (exporters) | Sharding manual, 15 días retención por defecto | Estándar CNCF, Kubernetes nativo, alertas robustas |
| **Grafana + InfluxDB** | TSDB + dashboard | Push (líneas Influx) | Simple | Ya usas InfluxDB, series con tags flexibles, escritura push |
| **VictoriaMetrics** | TSDB compatible Prometheus | Pull + push, PromQL | ✅ Cluster nativo, menos RAM/CPU | Prometheus a gran escala sin gestión manual |
| **Netdata** | Monitoreo en tiempo real | Push propio | Una máquina / dashboards instantáneos | Quieres visibilidad inmediata sin configurar scrape |
| **Zabbix** | Monitoreo clásico | Agent + polling | ✅ Empresarial | Infraestructura clásica (SNMP, agentes, sin contenedores) |
| **Nagios/Icinga** | Monitoreo clásico | Checks + plugins | ✅ Empresarial | Monitorización tradicional de servicios |

**Recomendación**: para Kubernetes y stacks modernos, Prometheus es el estándar de facto. Para homelab simple con dashboards ya hechos, Netdata. Para infraestructura empresarial clásica con SNMP/agentes, Zabbix. Si Prometheus te queda corto en volumen, migra el backend a VictoriaMetrics sin tocar PromQL.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Targets rojo (DOWN) | Endpoint no responde o scrape mal | Verificar `targets` en `/targets` y `scrape_interval`; revisar firewall/puerto |
| Alertas no disparan | Rules de alerta mal validadas | Usar `promtool check rules rules.yml` antes de cargar |
| TSDB crece infinito | Retention largo | Configurar `retention.time`/`size` (`--storage.tsdb.retention.time=30d`) |
| Disk lleno | Block de TSDB grandes | Reducir retention o usar WAL/CGI |
| Integración de exporters no aparece | Config scrape | Añadir el job (ej. `node_exporter.prometheus.yml`) y reload |

## Ver también

- [[node_exporter]] — recolector de métricas del sistema
- [[Monitorización (Prometheus node_exporter)]] — índice del stack
- [[Grafana]] — dashboards visuales
- [[htop btop]] — monitorización local
- [[cgroups (control de recursos)]]

## Enlaces externos

- [Sitio oficial — Prometheus](https://prometheus.io/)
- [Wikipedia — Prometheus](https://en.wikipedia.org/wiki/Prometheus_(software))
- [GitHub — prometheus/prometheus](https://github.com/prometheus/prometheus)

#programa
