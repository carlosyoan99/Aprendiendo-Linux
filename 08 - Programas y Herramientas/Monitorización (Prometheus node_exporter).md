---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# Monitorización — Índice

Stack de monitorización cloud-native: [[Prometheus]] recolecta y almacena métricas, [[node_exporter]] las expone desde cada servidor, y [[Grafana]] las visualiza.

## Componentes

| Componente | Función | Puerto |
|---|---|---|
| [[Prometheus]] | Servidor de métricas, TSDB, PromQL, alertas | `:9090` |
| [[node_exporter]] | Exportador de métricas del sistema Linux | `:9100` |
| [[Grafana]] | Dashboards visuales, fuente de datos Prometheus | `:3000` |

## Arquitectura

```
Servidores con node_exporter (:9100)
         │
         ▼ GET /metrics
    Prometheus Server (:9090)
         │
    ┌────┴────┐
    ▼         ▼
 Grafana  Alertmanager
```

## Tabla comparativa: opciones de monitorización

| Herramienta | Alcance | Históricos | Alertas | Dashboard |
|---|---|---|---|---|
| [[Prometheus]] + [[node_exporter]] | Múltiples servidores | ✅ TSDB | ✅ | ✅ Grafana |
| [[htop btop]] | Un solo equipo | ❌ | ❌ | ❌ |
| **Netdata** | Múltiples servidores | ✅ | ✅ | ✅ integrado |
| **Nagios/Icinga** | Múltiples servidores | ✅ | ✅ | Limitado |
| **Zabbix** | Múltiples servidores | ✅ | ✅ | ✅ |

## Ver también

- [[htop btop]] — monitorización local
- [[RAID (mdadm)]] — monitorizar salud de discos
- [[Logging del sistema (rsyslog journald logrotate)]] — logs vs métricas
- [[systemd]] — systemd puede exponer métricas a Prometheus
- [[Cron]] · [[systemd timers]] — programar scripts
- [[Firewall]] — puertos 9090 y 9100

## Enlaces externos

- [Wikipedia — Prometheus](https://en.wikipedia.org/wiki/Prometheus_(software))
- [Sitio oficial — Prometheus](https://prometheus.io/)
- [GitHub — prometheus/prometheus](https://github.com/prometheus/prometheus)
- [GitHub — prometheus/node_exporter](https://github.com/prometheus/node_exporter)

#programa
