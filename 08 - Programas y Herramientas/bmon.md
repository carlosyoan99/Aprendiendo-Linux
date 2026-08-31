---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: baja
---

# bmon

> Monitor de ancho de banda en tiempo real con gráficos ASCII. Muestra throughput por interfaz de red con históricos y estadísticas.

## Sintaxis

```bash
bmon [opciones]
```

## Descripción

`bmon` es un monitor de ancho de banda ligero que muestra throughput por interfaz con gráficos ASCII en tiempo real. A diferencia de iftop (que muestra por conexión), bmon se enfoca en el aggregate de cada interfaz.

## Opciones

| Opción | Descripción |
|---|---|
| `-p <interfaz>` | Monitorear interfaz específica |
| `-d <segundos>` | Intervalo de refresco |
| `-r <segundos>` | Duración de captura |
| `-o <formato>` | Salida: `ascii`, `html`, `csv` |
| `-a` | Mostrar todas las interfaces |

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `d` | Mostrar/detalle por interfaz |
| `e` |-expandir interfaz seleccionada |
| `q` | Salir |
| `+/-` | Zoom in/out |
| `?` | Ayuda |

## Ejemplos

```bash
bmon                                # interfaz por defecto
bmon -p eth0                        # monitorear eth0
bmon -p wlan0 -d 1                  # WiFi, refresco cada 1s
bmon -a                             # todas las interfaces
bmon -o html > report.html          # exportar a HTML
```

## Formato de salida

```
Interface  State      RX Rate      TX Rate       Total RX     Total TX
eth0       UP       1.2 MB/s      456 KB/s      1.2 GB       320 MB
wlan0      UP       234 KB/s       89 KB/s      45 MB        12 MB
lo         UP         0 B/s         0 B/s      2.3 MB       2.3 MB
```

## Alternativas

| Herramienta | Enfoque |
|---|---|
| **nload** | Por interfaz, gráfico ASCII |
| **iftop** | Por conexión individual |
| **nethogs** | Por proceso |
| **bandwhich** | TUI moderno, por proceso+host |

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install bmon` |
| Arch | `sudo pacman -S bmon` |
| Fedora | `sudo dnf install bmon` |
| Alpine | `sudo apk add bmon` |
| macOS | `brew install bmon` |

## Configuración

```bash
# ~/.bmonrc — configuración por defecto
# No hay archivo de config por defecto, se usa cli flags

# Formatos de salida
bmon -o ascii        # por defecto (terminal)
bmon -o curses       # curses (más interactivo)
bmon -o html         # HTML para reportes
bmon -o csv          # CSV para análisis
bmon -o json         # JSON para procesamiento
bmon -o null         # solo la salida en la terminal
```

## Filtrado y opciones avanzadas

```bash
# Monitorear solo una interfaz
bmon -p eth0

# Todas las interfaces (incluyendo virtual)
bmon -a

# Capturar por tiempo específico (para scripts)
bmon -r 60 > report.txt    # 60 segundos

# Exportar a HTML
bmon -o html > /var/www/html/monitor.html

# Intervalo de refresco (por defecto 1s)
bmon -d 0.5    # cada 500ms
bmon -d 5      # cada 5s

# Combinar con pipes para análisis
timeout 60 bmon -r 60 -o csv | cut -d',' -f1,4 | sort
```

## Atajos de teclado expandidos

| Tecla | Acción |
|---|---|
| `d` | Mostrar/detalle por interfaz |
| `e` | Expandir interfaz seleccionada |
| `q` | Salir |
| `+/-` | Zoom in/out |
| `?` | Ayuda |
| `h` | Mostrar ayuda |
| `r` | Refrescar |
| `s` | Seleccionar interfaz |
| `n` | Siguiente interfaz |
| `p` | Interfaz anterior |

## Comparativa con monitores de red

| Herramienta | Enfoque | Granularidad |
|---|---|---|
| **bmon** | Por interfaz, gráfico ASCII | Interface |
| **nload** | Por interfaz, gráfico ASCII | Interface |
| **iftop** | Por conexión (IP:puerto) | Conexión |
| **nethogs** | Por proceso | Proceso |
| **bandwhich** | Por proceso+host | Proceso+host |
| **nethogs** | Por proceso | Proceso |
| **vnstat** | Histórico | Interface |
| **ifstat** | Histórico, scripting | Interface |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `bmon: command not found` | No instalado | `sudo apt install bmon` |
| No muestra interfaces | Solo monitorea por defecto | `bmon -a` para todas |
| Gráfico no aparece | Terminal no soporta | Usar `bmon -o csv` o `bmon -o html` |
| No muestra tráfico real | Permisos | `sudo bmon` |
| Refresh muy rápido/lento | Intervalo por defecto | `bmon -d 2` para cada 2s |

## Enlaces externos

- [GitHub — bmon](https://github.com/troglobit/bmon)
- [Wikipedia — bmon](https://en.wikipedia.org/wiki/Bmon)
- [Arch Wiki — bmon](https://wiki.archlinux.org/title/Bmon)

## Ver también

- [[iftop]] — monitor por conexión
- [[nethogs]] — monitor por proceso
- [[bandwhich]] — TUI moderno de bandwidth
- [[Redes Basicas]] — conceptos de red
- [[ss]] — socket statistics

#programa #tui #redes
