---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# ping

## Sintaxis
```
ping [opciones] destino
```

## Descripción
Envía paquetes **ICMP Echo Request** a un host y espera una respuesta (Echo Reply). Sirve para probar conectividad de red básica y medir latencia. Es la primera herramienta cuando "no tengo internet".

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-c <N>` | Enviar N paquetes y luego parar |
| `-i <seg>` | Intervalo entre paquetes (default 1s) |
| `-s <tamaño>` | Tamaño del paquete en bytes |
| `-4` | Forzar IPv4 |
| `-6` | Forzar IPv6 |
| `-D` | Mostrar timestamp en cada respuesta |
| `-q` | Modo silencioso (solo resumen final) |

## Ejemplos
```bash
ping -c 4 8.8.8.8                        # 4 paquetes a Google DNS
ping -c 10 google.com                    # 10 paquetes resolución DNS + conectividad
ping -i 0.5 192.168.1.1                  # ping cada 0.5s al router local
ping -c 1 -s 1472 8.8.8.8               # probar MTU (paquete grande)
ping -D google.com                       # con timestamp para logs
ping -4 google.com                       # forzar IPv4
```

## Casos de uso reales

### Diagnóstico de conectividad paso a paso

```bash
# 1. ¿La interfaz de red está activa?
ip addr show

# 2. ¿El router local responde?
ping -c 2 192.168.1.1                     # si falla → problema de red local o WiFi

# 3. ¿Hay salida a internet?
ping -c 2 8.8.8.8                         # si falla → problema con el router/ISP

# 4. ¿El DNS funciona?
ping -c 2 google.com                      # si falla pero 8.8.8.8 funciona → problema DNS
```

### Medir latencia de forma continua (para detectar cortes)

```bash
ping -D -i 1 8.8.8.8 | tee ping-log.txt   # ping cada segundo con timestamp
# Dejar corriendo en una terminal mientras se prueba la red
# Ctrl+C para parar y revisar ping-log.txt
```

### Detectar pérdida de paquetes en WiFi

```bash
ping -c 100 -i 0.2 192.168.1.1            # 100 paquetes rápidos al router
# Si ves >1% packet loss → WiFi inestable (interferencias, señal baja)
# Si ves >5% → problema serio de conectividad
```

## Combinaciones comunes con pipe

```bash
# Extraer solo la latencia de cada respuesta
ping -c 10 google.com | grep "time=" | sed 's/.*time=//; s/ ms//'

# Loggear latencia media cada minuto
while true; do ping -c 5 -q 8.8.8.8 | tail -1 | awk '{print $4}' | tr '/' ' ' >> latencia.log; sleep 60; done

# Ver si un host está vivo (para scripts)
ping -c 1 -W 2 192.168.1.50 > /dev/null 2>&1 && echo "Host vivo" || echo "Host caído"
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `ping` | `mtr` | Combina ping + traceroute en tiempo real, actualización continua |
| `ping -f google.com` | `mtr --report google.com` | Flood ping + reporte detallado con cada salto |
| `ping` en scripts | `fping` | Ping a múltiples hosts simultáneamente |

```bash
# mtr — traceroute + ping en uno
sudo apt install mtr
mtr 8.8.8.8                              # interactivo, q para salir
mtr --report -c 10 8.8.8.8               # reporte de 10 segundos no interactivo

# fping — ping a múltiples hosts
sudo apt install fping
fping -c 3 google.com github.com          # ping a varios hosts a la vez
fping -g 192.168.1.0/24                  # escanear toda la subred
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `ping: google.com: Name or service not known` | El DNS no resuelve (no internet o DNS mal configurado) | `ping -c 2 8.8.8.8` para ver si es DNS o conectividad |
| `Destination Host Unreachable` | No hay ruta al destino (router caído, cable desconectado) | Verificar `ip route`, revisar conexión física |
| `Request timed out` | El host no responde (puede bloquear ICMP) | Probar con `curl https://host` — si funciona, bloquea ICMP |
| `ping: socket: Operation not permitted` | Necesitas root para ciertas opciones (como ping con -f) | Usar `sudo ping` o verificar permisos de ping (setuid) |
| Packet loss > 0% en LAN | Interferencia WiFi, switch defectuoso o cable malo | Probar con cable Ethernet, cambiar canal WiFi |

## Interpretación de la salida

```
PING google.com (142.250.80.14) 56(84) bytes of data.
64 bytes from 142.250.80.14: icmp_seq=1 ttl=118 time=14.2 ms

--- google.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 14.2/15.1/17.3/1.2 ms
```

| Métrica | Significa |
|---|---|
| `time=14.2ms` | Latencia de ida y vuelta — <20ms excelente, <60ms buena |
| `ttl=118` | Tiempo de vida del paquete — se reduce en cada salto |
| `0% packet loss` | 0% pérdida = conectividad perfecta |
| `mdev` | Variación de la latencia — bajo = conexión estable |

## Notas y advertencias
- Algunos servidores bloquean ICMP por seguridad, así que `ping` puede fallar aunque el servicio HTTP funcione. Si `ping 8.8.8.8` falla pero `curl https://google.com` funciona, es un bloqueo de ICMP, no un problema de red.
- Sin `-c`, `ping` corre **indefinidamente** (presiona Ctrl+C para parar).
- Usar `ping -c 4 8.8.8.8` primero evita depender de DNS para diagnosticar. Si eso funciona y `ping google.com` no, el problema es DNS.
- En redes locales, latencias <1ms son normales. >100ms en LAN indica problema (WiFi saturado, switch defectuoso).

## Ver también
- [[Redes Basicas]]
- [[curl]]
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — ping](https://en.wikipedia.org/wiki/Ping_(networking_utility))
- [Linux man page — ping](https://man7.org/linux/man-pages/man8/ping.8.html)

#comando
