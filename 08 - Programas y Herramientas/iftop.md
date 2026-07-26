---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# iftop

> Monitor de ancho de banda en tiempo real por conexión de red. Muestra qué hosts están consumiendo bandwidth en la interfaz de red.

## Sintaxis

```bash
iftop [opciones]
```

## Descripción

`iftop` captura tráfico de red y lo muestra en una tabla en tiempo real, ordenado por ancho de banda. Muestra origen, destino, y total de datos transferidos. Útil para detectar procesos o hosts que saturan la red.

## Opciones

| Opción | Descripción |
|---|---|
| `-i <interfaz>` | Interfaz a monitorear |
| `-n` | No resolver nombres DNS |
| `-N` | No resolver puertos a servicios |
| `-P` | Mostrar puertos |
| `-B` | Mostrar en bytes (no bits) |
| `-s <segundos>` | Intervalo de refresco |
| `-f <filtro>` | Filtrar tráfico (filtro pcap) |
| `-G` | Salida de grupo (IPv6) |

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `t` | Cambiar modo de display (2 líneas, 1 línea, solo TX, solo RX) |
| `n` | Toggle resolución DNS |
| `s` | Toggle resolución de puertos |
| `p` | Mostrar puertos |
| `P` | Pausar |
| `1/2/3` | Ordenar por 2s/10s/40s promedio |
| `o` | Pausar display |
| `f` | Editar filtro |
| `q` | Salir |

## Ejemplos

### Monitorear interfaz por defecto
```bash
sudo iftop
```

### Monitorear interfaz específica
```bash
sudo iftop -i eth0
sudo iftop -i wlan0
```

### Sin DNS (más rápido)
```bash
sudo iftop -n -N
```

### Solo ver puertos
```bash
sudo iftop -P -n
```

### Filtrar tráfico HTTP
```bash
sudo iftop -f "port 80 or port 443"
```

## Formato de salida

```
                  12.5Kb          25.0Kb          37.5Kb          50.0Kb    62.5Kb
└─────────────────┴───────────────┴───────────────┴───────────────┴───────────────┴──
hostname1.local   <=              8.5Kb     12.3Kb     45.2Kb
hostname2.local   =>              4.2Kb      8.1Kb     32.1Kb
server.example.com <=              1.1Kb      2.3Kb     15.6Kb
                                                 TX:             12.3Kb    32.1Kb    89.5Kb
                                                 RX:              8.5Kb    22.7Kb    65.3Kb
                                                 TOTAL:          20.8Kb    54.8Kb   154.8Kb
```

## Casos de uso

### Diagnosticar uso de ancho de banda
```bash
# Ver qué consume tu conexión
sudo iftop -n -P

# Con nombres DNS (más lento pero más legible)
sudo iftop -i eth0
```

### Detectar tráfico sospechoso
```bash
# Ver conexiones entrantes
sudo iftop -i eth0 -f "dst port 22"

# Ver tráfico a hosts externos
sudo iftop -n -G
```

## Combinaciones pipe

```bash
# iftop no es pipe-friendly, pero puede usarse con tmux
tmux new-session -d "sudo iftop -n -P"
# Capturar snapshot cada 5 segundos
watch -n 5 "sudo iftop -n -P -t -s 5 | head -20"
```

## Alternativas

| Herramienta | Ventaja |
|---|---|
| **nload** | Más simple, gráfico por interfaz |
| **nethogs** | Por proceso (no por host) |
| **bmon** | Gráfico de bandwidth por interfaz |
| **bandwhich** | TUI moderno, por proceso + host |
| **vnstat** | Estadísticas históricas (no tiempo real) |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| "Permission denied" | Necesita root | `sudo iftop` |
| No muestra tráfico | Interfaz incorrecta | `iftop -i eth0` o `iftop -i wlan0` |
| Muy lento | Resolviendo DNS | `iftop -n -N` |
| Solo muestra localhost | Filtro mal | Verificar interfaz y subnet |

## Ver também

- [[bmon]] — monitor de bandwidth
- [[nethogs]] — monitor por proceso
- [[bandwhich]] — TUI moderno de bandwidth
- [[Redes Basicas]] — conceptos de red
- [[ss]] — sockets activos

## Enlaces externos

- [GitHub — iftop](https://github.com/equipment-maintainer/iftop) (fork activo)
- [Wikipedia — iftop](https://en.wikipedia.org/wiki/Iftop)
- [Arch Wiki — iftop](https://wiki.archlinux.org/title/iftop)
- [man iftop(8)](https://www.ex-parrot.com/~pdw/iftop/)

#programa #tui #redes
