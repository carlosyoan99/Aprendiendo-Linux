---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
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

## Ver también

- [[iftop]] — monitor por conexión
- [[nethogs]] — monitor por proceso
- [[bandwhich]] — TUI moderno de bandwidth
- [[Redes Basicas]] — conceptos de red

## Enlaces externos

- [GitHub — bmon](https://github.com/troglobit/bmon)
- [Wikipedia — bmon](https://en.wikipedia.org/wiki/Bmon)
- [Arch Wiki — bmon](https://wiki.archlinux.org/title/Bmon)

#programa #tui #redes
