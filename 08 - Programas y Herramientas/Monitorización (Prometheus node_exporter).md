---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# Monitorización (Prometheus, node_exporter)

## Qué es

Prometheus es un sistema de monitorización y alerta de código abierto que recoge **métricas numéricas** de sistemas y servicios en intervalos regulares. **node_exporter** es el recolector estándar para métricas del sistema Linux (CPU, RAM, disco, red, temperatura). Juntos forman el stack de monitorización más usado en el mundo cloud-native.

```
Arquitectura Prometheus:

                ┌──────────────────┐
                │   node_exporter  │ ◄── Servidor 1 (Linux)
                │   :9100          │
                └────────┬─────────┘
                         │ GET /metrics
                ┌────────▼─────────┐
                │   node_exporter  │ ◄── Servidor 2 (Linux)
                │   :9100          │
                └────────┬─────────┘
                         │
               ┌─────────▼──────────┐
               │    Prometheus       │
               │    Server           │
               │    :9090            │
               └─────────┬──────────┘
                         │
            ┌────────────┼────────────┐
            ▼            ▼            ▼
      ┌──────────┐ ┌──────────┐ ┌──────────┐
      │ Grafana  │ │ Alert-   │ │ PromQL   │
      │ :3000    │ │ manager  │ │ consultas │
      └──────────┘ └──────────┘ └──────────┘
```

---

## node_exporter — Métricas del sistema

Exporta métricas del sistema en formato texto en el endpoint `/metrics`. No necesita configuración — se ejecuta y ya.

### Instalación

```bash
# Descargar la última versión desde GitHub
curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | \
  grep browser_download_url | grep linux-amd64 | cut -d'"' -f4 | wget -qi -
tar xzf node_exporter-*.linux-amd64.tar.gz
sudo install node_exporter-*/node_exporter /usr/local/bin/

# O desde repos (versión más antigua)
sudo apt install prometheus-node-exporter   # Debian/Ubuntu
sudo pacman -S prometheus-node-exporter     # Arch
sudo dnf install golang-github-prometheus-node-exporter  # Fedora

# Verificar que funciona
node_exporter --version

# Ejecutar (prueba)
node_exporter &
curl http://localhost:9100/metrics | head -20
```

### Configuración como servicio systemd

```bash
# /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
Type=simple
User=nobody
Group=nogroup                 # Debian/Ubuntu; en Fedora/RHEL usar Group=nobody
ExecStart=/usr/local/bin/node_exporter \
  --web.listen-address=:9100 \
  --path.procfs=/proc \
  --path.sysfs=/sys \
  --collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($|/)
Restart=always

[Install]
WantedBy=multi-user.target

# Activar
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
```

### Colectores disponibles

```bash
# Ver qué colectores están activos
node_exporter --help | grep collector

# Activar/desactivar colectores específicos
node_exporter \
  --collector.diskstats        # estadísticas de disco (por defecto: sí)
  --collector.meminfo          # memoria (sí)
  --collector.cpu              # CPU (sí)
  --collector.netstat          # estadísticas de red (sí)
  --collector.systemd          # unidades de systemd (no)
  --collector.processes        # procesos (no)
  --collector.logind           # sesiones de login (no)
  --no-collector.arp           # desactivar ARP
```

### Métricas principales expuestas

| Métrica | Descripción | Ejemplo de valor |
|---|---|---|
| `node_cpu_seconds_total` | Tiempo de CPU por modo (user, system, idle, iowait) | 123456.78 |
| `node_memory_MemTotal_bytes` | RAM total | 16718491648 |
| `node_memory_MemAvailable_bytes` | RAM disponible | 8246296576 |
| `node_filesystem_avail_bytes` | Espacio disponible en disco | 50000000000 |
| `node_network_receive_bytes_total` | Bytes recibidos por interfaz | 1.234e+09 |
| `node_disk_io_time_seconds_total` | Tiempo de E/S de disco | 2345.67 |
| `node_load1` / `node_load5` / `node_load15` | Load average | 0.45 |
| `node_systemd_unit_state` | Estado de unidades systemd | 1 (activo) / 0 (inactivo) |

---

## Prometheus Server — Recolección y almacenamiento

Prometheus "scrapea" (recolecta) métricas de los exportadores cada cierto intervalo y las almacena en una base de datos de series temporales.

### Instalación

```bash
# Descargar
wget https://github.com/prometheus/prometheus/releases/latest/download/prometheus-*.linux-amd64.tar.gz
tar xzf prometheus-*.linux-amd64.tar.gz
sudo install prometheus-*/prometheus prometheus-*/promtool /usr/local/bin/
```

### Configuración básica (prometheus.yml)

```yaml
# /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s          # cada cuánto recolectar métricas
  evaluation_interval: 15s      # cada cuánto evaluar reglas de alerta

scrape_configs:
  # Prometheus se monitoriza a sí mismo
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Servidores Linux con node_exporter
  - job_name: 'servidores'
    static_configs:
      - targets:
        - '192.168.1.10:9100'    # servidor web
        - '192.168.1.11:9100'    # base de datos
        - '192.168.1.12:9100'    # backup
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
```

```bash
# Crear usuario y directorios
sudo useradd -r -s /bin/false prometheus
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# Activar
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus

# Ver interfaz web
# http://localhost:9090
```

---

## PromQL — Consultas sobre métricas

PromQL es el lenguaje de consulta de Prometheus. Desde la interfaz web (`http://localhost:9090/graph`) o desde Grafana.

### Consultas básicas

```promql
# Valores actuales
node_load1                                        # load average 1 min
node_memory_MemAvailable_bytes                    # RAM disponible en bytes
node_memory_MemAvailable_bytes / 1024 / 1024      # RAM disponible en MB

# Tasas (rate) — por segundo
rate(node_cpu_seconds_total{mode="idle"}[5m])     # % CPU idle (media 5 min)
rate(node_network_receive_bytes_total[1m])        # tráfico de red (bytes/s)

# Agregaciones
sum(rate(node_cpu_seconds_total{mode!="idle"}[5m])) by (instance)  # CPU usada por servidor
topk(3, node_load1)                               # top 3 servidores por carga

# Operadores
node_filesystem_avail_bytes / node_filesystem_size_bytes * 100      # % disco libre
```

### Consultas útiles (dashboard)

```promql
# CPU usage (%)
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# RAM usage (%)
(1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100

# Espacio en disco usado (%)
(node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100

# Tráfico de red (bytes/s)
rate(node_network_receive_bytes_total[5m])

# I/O de disco (% tiempo ocupado)
rate(node_disk_io_time_seconds_total[5m])

# Tiempo de actividad (días)
(time() - node_boot_time_seconds) / 86400
```

---

## Alertas con Alertmanager

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
        annotations:
          summary: "Disco casi lleno en {{ $labels.instance }} ({{ $value | humanizePercentage }})"

      - alert: AltaCargaCPU
        expr: 100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 10m
        annotations:
          summary: "CPU > 80% en {{ $labels.instance }}"
```

```yaml
# Incluir las reglas en prometheus.yml
rule_files:
  - "/etc/prometheus/rules.yml"
```

---

## Grafana — Dashboards visuales

Grafana se conecta a Prometheus como fuente de datos y permite crear dashboards visuales.

```bash
# Debian/Ubuntu (requiere añadir repo oficial primero)
sudo apt install -y apt-transport-https software-properties-common wget
wget -q -O- https://packages.grafana.com/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/grafana.gpg
echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://packages.grafana.com/oss/deb stable main" | \
  sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update && sudo apt install grafana

# Arch (en community)
sudo pacman -S grafana

# Fedora
sudo dnf install grafana

# Activar
sudo systemctl enable --now grafana-server

# Acceder: http://localhost:3000 (admin/admin)
```

### Dashboards recomendados

| Dashboard | ID (Grafana.com) | Qué muestra |
|---|---|---|
| **Node Exporter Full** | `1860` | CPU, RAM, disco, red, temperatura — el más completo |
| **Node Exporter Server Metrics** | `11074` | Versión más moderna y limpia |
| **1 Node Exporter for Prometheus** | `16098` | Simple, un solo servidor |

```bash
# Importar dashboard desde la CLI de Grafana (o desde la UI: Import → pegar ID 1860)
# En la web: Configuration → Data Sources → Add → Prometheus (http://localhost:9090)
```

---

## Tabla comparativa: opciones de monitorización

| Herramienta | Alcance | Almacena históricos? | Alertas? | Dashboard? | Ideal para |
|---|---|---|---|---|---|
| **htop/btop** | Un solo equipo | ❌ | ❌ | ❌ | Monitorización rápida local |
| **Prometheus + node_exporter** | Múltiples servidores | ✅ Sí (TSDB) | ✅ (Alertmanager) | ✅ (Grafana) | Infraestructura mediana/grande |
| **Netdata** | Múltiples servidores | ✅ Sí | ✅ | ✅ (integrado) | Monitorización todo-en-uno, fácil |
| **Nagios/Icinga** | Múltiples servidores | ✅ Sí | ✅ | Limitado | Check de servicios (HTTP, SSH, etc.) |
| **Zabbix** | Múltiples servidores | ✅ Sí | ✅ | ✅ | Entornos empresariales grandes |

---

## Ver también

- [[htop btop]] — monitorización local en terminal
- [[RAID (mdadm)]] — monitorizar salud de discos
- [[Logging del sistema (rsyslog journald logrotate)]] — logs vs métricas
- [[Backups (borg restic duplicity rsync)]] — monitorizar backups
- [[systemd]] — systemd puede exponer métricas a Prometheus
- [[Cron]] · [[systemd timers]] — programar scripts de monitorización
- [[Firewall]] — puertos 9090 y 9100

## Enlaces externos

- [Wikipedia — Prometheus](https://en.wikipedia.org/wiki/Prometheus_(software))
- [Sitio oficial — Prometheus](https://prometheus.io/)
- [GitHub — prometheus/prometheus](https://github.com/prometheus/prometheus)
- [GitHub — prometheus/node_exporter](https://github.com/prometheus/node_exporter)

#programa
