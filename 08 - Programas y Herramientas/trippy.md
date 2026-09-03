---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: baja
---

# trippy

> `traceroute` + `ping` + `mtr` en un solo TUI moderno. Diagnóstico de red visual con gráficos en tiempo real. Escrito en Rust.

## Qué es

**trippy** combina traceroute, ping y estadísticas de red en una interfaz TUI. Muestra la ruta completa hasta un host, con latencia, pérdida de paquetes, saltos (hops), y gráficos históricos por cada salto. Similar a `mtr` pero con mucho más detalle visual.

Binario único, sin dependencias.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install trippy

# Arch
sudo pacman -S trippy

# Fedora
sudo dnf install trippy

# Homebrew
brew install trippy

# Desde GitHub (binario estático)
# https://github.com/fujiapple852/trippy/releases

# Con cargo (Rust)
cargo install trippy
```

## Uso básico

```bash
# TUI interactiva
trippy google.com
trippy 1.1.1.1
trippy midominio.com

# Modo clásico (como mtr)
trippy google.com --mode classic

# Con puerto específico (TCP)
trippy google.com --target-port 80

# Sin interfaz (salida JSON para scripts)
trippy google.com --report
trippy google.com --report-json
```

## Atajos esenciales

| Tecla | Acción |
|---|---|
| `q` | Salir |
| `?` | Ayuda |
| `Tab` | Cambiar entre paneles |
| `Flechas` | Navegar por saltos |
| `h` | Alternar vista histórica/actual |
| `r` | Reiniciar traceroute |
| `+` / `-` | Acercar / alejar escala |
| `p` | Pausar/reanudar |
| `f` | Buscar host |

## Interpretación de la salida

```
Trippy 0.11.0 — google.com (142.250.80.46)
                                       ┌─── HISTORIAL ────┐
 Hop   Host                   Loss%    Last   Avg   Best  │  ▁▂▃▄▅▆▇█  │
 ─────────────────────────────────────────────────────────┘─────────────┘
  1    192.168.1.1             0.0%    1.2   1.1   0.8   │ █▄▁▁▁▁▁▁▁▁  │
  2    10.0.0.1                0.0%    3.4   3.8   2.1   │ ▃▃██▇▅▃▂▁▁  │
  3    172.16.1.1              0.0%    5.1   5.5   4.2   │ ▁▁▁▂▃▅███▇  │
  4    72.14.237.1             0.5%   12.3  14.2  11.1   │ ▁▇██▇▅▃▁▁▁  │
  5    108.170.234.1           1.2% ▲ 22.8  20.5  18.3   │ ▁▁▂▃▅▇███▇  │
  6    142.250.46.1            2.1%   25.4  24.1  22.0   │ ▂▃▅▇███▇▅▃  │
  7    142.250.80.46           0.0%   24.1  23.8  21.5   │ ▄▆██▇▆▅▃▂▁  │
```

### Indicadores clave

| Indicador | Significado |
|---|---|
| **Loss%** | Porcentaje de pérdida de paquetes (▲ si supera 1%) |
| **Last** | Última latencia medida (ms) |
| **Avg** | Latencia promedio (ms) |
| **Best** | Mejor latencia registrada (ms) |
| **Gráfico** | Historial visual de latencia (▁=bajo, █=alto) |

## Modos de visualización

| Modo | Comando | Descripción |
|---|---|---|
| **TUI** | `trippy host` | Interfaz interactiva con paneles |
| **Classic** | `trippy host --mode classic` | Similar a mtr (una línea por hop) |
| **Report** | `trippy host --report` | Salida tipo `mtr --report` |
| **JSON** | `trippy host --report-json` | Para procesar con [[jq]] |

## Comparativa

| Aspecto | trippy | mtr | traceroute | ping |
|---|---|---|---|---|
| **TUI interactiva** | ✅ Excelente | ✅ Básica | ❌ | ❌ |
| **Gráficos históricos** | ✅ Por cada hop | ❌ | ❌ | ❌ |
| **Detección de pérdida** | ✅ Por hop | ✅ | ❌ | ✅ Sólo destino |
| **Puerto TCP** | ✅ | ❌ | ❌ | ❌ |
| **Salida JSON** | ✅ | ❌ | ❌ | ❌ |
| **Velocidad** | Rápida | Rápida | Lenta | Muy rápida |

> trippy es la mejor herramienta actual para diagnóstico visual de red. Reemplaza a `mtr`, `traceroute` y `ping -f` en un solo comando.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No muestra saltos | Firewall bloquea ICMP | Probar `--tcp`/`--udp` para paquetes TCP/UDP |
| SALIDA lentísima | Timeout alto por salto | Ajustar `--max-hop` y timeout (`--timeout`) |
| Caracteres rotos en TUI | ANSI/TERM | Terminal moderno y `TERM=xterm-256color` |
| Permisos para sockets sin priviledge | Ping necesita icmp | Algunos distros necesitan `sysctl net.ipv4.ping_group_range` |

## Ver también

- [[ping]] — conectividad básica
- [[traceroute]] — ruta de paquetes clásica
- [[ss]] — estadísticas de puertos y conexiones
- [[ip]] — configuración de interfaces
- [[Redes Basicas]] — conceptos de red
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — fujiapple852/trippy](https://github.com/fujiapple852/trippy)
- [Documentación](https://trippy.cli.rs/)

#programa #tui #red
