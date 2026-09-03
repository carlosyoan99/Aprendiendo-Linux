---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: baja
---

# Grafana

Plataforma de dashboards visuales que se conecta a [[Prometheus]] (y otras fuentes de datos) para crear gráficas, tableros y paneles de monitorización. Es el frontend visual estándar en el ecosistema de monitorización moderno.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install -y apt-transport-https software-properties-common wget
wget -q -O- https://packages.grafana.com/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/grafana.gpg
echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://packages.grafana.com/oss/deb stable main" | \
  sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update && sudo apt install grafana

# Arch
sudo pacman -S grafana

# Fedora
sudo dnf install grafana

# Iniciar servicio
sudo systemctl enable --now grafana-server
```

Acceder a la interfaz en **http://localhost:3000** (usuario: `admin`, contraseña: `admin`).

## Configurar fuente de datos (Prometheus)

Desde la interfaz web:
1. **Connections → Data sources → Add data source**
2. Seleccionar **Prometheus**
3. URL: `http://localhost:9090` (o la IP donde corra Prometheus)
4. **Save & Test**

También se puede configurar vía archivo de provisioning:

```yaml
# /etc/grafana/provisioning/datasources/prometheus.yml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true
```

## Dashboards recomendados para node_exporter

| Dashboard | ID | Qué muestra |
|---|---|---|
| Node Exporter Full | `1860` | CPU, RAM, disco, red, temperatura, procesos |
| Node Exporter Server Metrics | `11074` | Versión moderna, limpia, con alertas visuales |
| 1 Node Exporter for Prometheus | `16098` | Simple, ideal para un solo servidor |

Para importar: UI de Grafana → **+ → Import** → pegar el ID del dashboard.

## Alertas

Grafana dispone de un sistema de alertas nativo (desde v8+) que permite:

```yaml
# Ejemplo de regla de alerta vía provisioning
# /etc/grafana/provisioning/alerting/alert_rules.yml
apiVersion: 1
groups:
  - name: host_alerts
    interval: 1m
    rules:
      - uid: high_cpu
        title: CPU alta
        condition: avg()
        data:
          - refId: A
            datasourceUid: prometheus
            model:
              expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
              interval: 1m
```

## Comparativa con alternativas

| Aspecto | Grafana | Kibana | Datadog | Netdata | Prometheus UI |
|---|---|---|---|---|---|
| **Fuentes** | ✅ Prometheus, InfluxDB, SQL, CloudWatch, 100+ | ⚠️ Solo Elasticsearch | ⚠️ Solo Datadog SaaS | ⚠️ Solo Netdata | Solo Prometheus |
| **Alertas** | ✅ Reglas con Canales (Slack, email, Telegram) | ✅ Watcher | ✅ Nativo | ✅ Básico | ⚠️ Básico |
| **Dashboards** | ✅ JSON, import/export, comunidad masiva | ✅ Kibana UI | ✅ Nativo | ✅ Auto-generados | ❌ |
| **Análisis logs** | ⚠️ Loki (plugin) | ✅ Nativo (ELK) | ✅ Nativo | ⚠️ Limitado | ❌ |
| **Costo** | ✅ OSS gratuito | ✅ OSS | 💰 SaaS desde $15/host | ✅ OSS | ✅ OSS |
| **Despliegue** | Docker/binary | Docker | SaaS | Agent | Integrado en Prometheus |
| **Ideal para** | Multi-fuente, visualización, alerts | Logs Elasticsearch | Enterprise SaaS | Monitoreo auto-hosted | Métricas Prometheus básicas |

> **Stack típico:** Prometheus (métricas) + Grafana (visualización/alertas) + Loki (logs) = alternativa OSS a Datadog.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Panel "No data" | Datasource sin datos o query errónea | Verificar intervalo, datasource y que Prometheus/Influx respondan |
| UI no carga / 302 | Config o auth | Revisar `grafana-server.ini` (`root_url`, `http_port`), reiniciar servicio |
| Login con correo roto | SMTP no configurado | Configurar `[smtp]` o usar auth local |
| Alertas no disparan | Evaluación/permisos | Revisar reglas, las evaluaciones del periodo y que el datasource esté healthy |
| Dashboard no persiste plugins | Permisos de carpeta | `grafana-cli plugins install` y permisos en `/var/lib/grafana/plugins` |

## Ver también

- [[Prometheus]] — fuente de datos principal
- [[node_exporter]] — métricas del sistema
- [[Monitorización (Prometheus node_exporter)]] — índice del stack

## Enlaces externos

- [Sitio oficial — Grafana](https://grafana.com/)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
- [Documentación de provisioning](https://grafana.com/docs/grafana/latest/administration/provisioning/)

#programa #monitorizacion
