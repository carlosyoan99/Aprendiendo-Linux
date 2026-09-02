---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: comando
prioridad: media
---

# mtr

> Combina `ping` y `traceroute` en un solo comando. Muestra en tiempo real la ruta de paquetes y la calidad de cada salto (latencia, pérdida de paquetes).

## Sintaxis

```bash
mtr [opciones] destino
```

## Descripción

**mtr** (My TraceRoute) envía paquetes ICMP continuamente a un destino y muestra estadísticas acumuladas de cada salto de la ruta. A diferencia de `traceroute` (un solo disparo), mtr funciona de forma continua como un ping con tracing.

## Ejemplos prácticos

```bash
mtr google.com                          # modo interactivo (TUI)
mtr -r google.com                       # reporte y salir (sin TUI)
mtr -r -c 100 google.com                # reporte con 100 paquetes
mtr -rw google.com                      # reporte con nombres DNS
mtr -T 80 google.com                    # usar TCP en puerto 80 (evade ICMP)
mtr -P 53 google.com                    # usar DNS (puerto 53)
mtr -z google.com                       # mostrar IPs y hostname
mtr -n google.com                       # sin resolución DNS (rápido)
mtr --json google.com                   # salida JSON
mtr --csv google.com                    # salida CSV
```

## Modo interactivo (TUI)

En el modo interactivo, se puede:
- Usar flechas ↑↓ para navegar entre saltos
- `p` — pausar actualización
- `r` — reiniciar estadísticas
- `n` — cambiar entre IPs y nombres
- `q` — salir

## Columnas de salida

| Columna | Significado |
|---|---|
| **Host** | IP o hostname del salto |
| **Loss%** | Porcentaje de paquetes perdidos |
| **Snt** | Paquetes enviados |
| **Avg** | Latencia promedio (ms) |
| **Best** | Mejor latencia |
| **Wrst** | Peor latencia |
| **StDev** | Desviación estándar (jitter) |

## Ejemplo de salida

```
                         Loss%  Snt   Last   Avg  Best  Wrst StDev
1. gateway.local          0.0%   50    1.2   1.3   0.8   2.1   0.3
2. isp-router.net         0.0%   50    8.4   9.1   7.2  15.3   1.8
3. ???                   100.0   50    0.0   0.0   0.0   0.0   0.0
4. core-backbone.net      0.0%   50   12.3  13.1  11.5  18.7   1.5
5. google.com             0.0%   50   14.2  14.8  13.1  20.4   1.6
```

## mtr vs traceroute vs ping

| Aspecto | mtr | traceroute | ping |
|---|---|---|---|
| Tipo | Continuo | Disparo único | Continuo |
| Muestra ruta | Sí | Sí | No |
| Estadísticas | Sí (loss, avg, stdev) | No (solo RTT) | Parcial (avg, loss) |
| Modo TUI | Sí | No | No |
| Ideal | Diagnosticar ruta completa | Ver saltos una vez | Probar conectividad |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Sin respuesta de mtr | Firewall bloquea ICMP | Usar `mtr -T` (TCP) o `mtr -P 53` (DNS) |
| Loss% alto en un salto | Puede ser normal (ICMP deprioritizado) | Verificar si el loss persiste en saltos siguientes |
| Salto "???" | Firewall que no responde | Normal en muchos routers ISP — no implica problema |

## Ver también

- [[ping]] — prueba de conectividad básica
- [[traceroute]] — ruta de paquetes (disparo único)
- [[dig]] — resolución DNS
- [[curl]] — prueba HTTP
- [[Red no conecta]] — troubleshooting de red

## Enlaces externos

- [Arch Wiki — mtr](https://wiki.archlinux.org/title/Mtr)
- [mtr — sitio oficial](https://www.bitwizard.nl/mtr/)

#comando #redes #diagnostico
