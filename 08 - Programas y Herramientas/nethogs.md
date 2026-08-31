---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: baja
---

# nethogs

> Monitor de red que agrupa tráfico por proceso. Muestra qué programa está consumiendo ancho de banda en tiempo real.

## Sintaxis

```bash
nethogs [opciones] [dispositivo...]
```

## Descripción

`nethogs` es como `top` pero para la red: muestra qué procesos están usando la red y cuánto ancho de banda consumen. A diferencia de iftop (que muestra por host), nethogs agrupa por PID/nombre de proceso.

## Opciones

| Opción | Descripción |
|---|---|
| `-d <segundos>` | Intervalo de refresco |
| `-v <modo>` | Modo: 0 (KB/s), 1 (total KB), 2 (total B), 3 (total MB) |
| `-p` | Modo tracemode (sin TUI) |
| `-t` | Modo texto (sin pantalla completa) |
| `-c <n>` | Número de ciclos antes de salir |

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `m` | Cambiar unidad (KB/s, KB, B, MB) |
| `r` | Ordenar por RX |
| `s` | Ordenar por TX |
| `q` | Salir |

## Ejemplos

```bash
sudo nethogs                         # interfaz por defecto
sudo nethogs eth0                    # monitorear eth0
sudo nethogs wlan0 -d 2              # WiFi, refresco cada 2s
sudo nethogs -t -v 2                 # modo texto, MB
sudo nethogs -p -d 5                 # tracemode (para scripts)
```

## Formato de salida

```
PID    User    PROGRAM        DEV       SENT      RECEIVED
1234   carlos   firefox       eth0      12.5 KB/s  456.2 KB/s
5678   carlos   curl          eth0       2.1 KB/s   12.3 KB/s
9012   root     apt           eth0       0.5 KB/s  1024.0 KB/s
```

## Casos de uso

### Descubrir qué consume tu banda ancha
```bash
sudo nethogs -t -v 0
# Ver qué proceso consume más download/upload
```

### Detectar malware o proceso sospechoso
```bash
sudo nethogs eth0
# Si ves procesos desconocidos con tráfico alto → investigar
```

### Debug de aplicaciones de red
```bash
sudo nethogs -p -d 1 > /tmp/nethogs.log
# Capturar 60 segundos de datos para análisis
timeout 60 nethogs -p -d 1 >> /tmp/nethogs.log
```

## Alternativas

| Herramienta | Enfoque |
|---|---|
| **iftop** | Por conexión (host a host) |
| **bmon** | Por interfaz (aggregate) |
| **bandwhich** | TUI moderno, proceso + host |
| **nload** | Por interfaz, gráfico ASCII |

## Ver también

- [[iftop]] — monitor por conexión
- [[bmon]] — monitor por interfaz
- [[bandwhich]] — TUI moderno de bandwidth
- [[ps]] — ver procesos

## Enlaces externos

- [GitHub — nethogs](https://github.com/rubo/nethogs)
- [Wikipedia — nethogs](https://en.wikipedia.org/wiki/Nethogs)
- [Arch Wiki — nethogs](https://wiki.archlinux.org/title/Nethogs)

#programa #tui #redes
