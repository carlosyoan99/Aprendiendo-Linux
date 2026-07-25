---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# traceroute

## Sintaxis
```bash
traceroute [opciones] destino
```

## Descripción
Muestra la ruta que siguen los paquetes desde tu máquina hasta un destino, saltando por cada router intermedio. Esencial para diagnosticar problemas de conectividad: ¿dónde se pierde el paquete? ¿qué salto está dando latency alta?

```bash
# Instalar (si no viene)
sudo apt install traceroute               # Debian/Ubuntu
sudo pacman -S traceroute                 # Arch
```

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-n` | No resolver nombres de host (más rápido) |
| `-I` | Usar ICMP Echo Request (como ping) en vez de UDP |
| `-T` | Usar TCP SYN (para pasar firewalls) |
| `-p puerto` | Puerto destino para TCP/UDP |
| `-m N` | Máximo de saltos (default 30) |
| `-q N` | Número de consultas por salto (default 3) |
| `-w N` | Timeout en segundos por salto (default 5) |

## Ejemplos
```bash
traceroute google.com                     # traceroute clásico (UDP)
traceroute -n google.com                  # sin resolver nombres (más rápido)
traceroute -I google.com                  # ICMP (como ping, pasa más firewalls)
traceroute -T google.com                  # TCP SYN (el que más firewalls pasa)
traceroute -T -p 80 google.com            # TCP al puerto 80 (HTTP)
traceroute -m 15 8.8.8.8                 # máximo 15 saltos
```

## Alternativa: mtr (mejor traceroute)

`mtr` combina `traceroute` + `ping` continuo. Muestra estadísticas en tiempo real de cada salto:

```bash
sudo apt install mtr                      # instalar
mtr google.com                            # interfaz interactiva (flechas, q=salir)
mtr -r -c 10 google.com                  # modo reporte (10 pings por salto)
mtr -n google.com                         # sin DNS
mtr -T -p 80 google.com                  # TCP al puerto 80
```

Salida de `mtr`:
```
                               My traceroute  [v0.95]
        host                    Loss%   Snt   Last   Avg  Best  Wrst StDev
 1.  192.168.1.1                0.0%    10   0.7   0.6   0.4   0.9   0.2
 2.  10.0.0.1                   0.0%    10   3.2   3.5   2.9   4.8   0.6
 3.  172.16.0.1                 0.0%    10   5.1   5.3   4.8   6.2   0.5
 4.  200.10.20.1                0.0%    10   12.4  14.2  11.8  20.1   3.1
 5.  180.50.40.1               50.0%    10   18.1  45.3  15.2  120.3 38.2
 6.  ???                       100.0%   10    0.0   0.0   0.0   0.0   0.0
```

En el ejemplo, el **salto 5** pierde 50% de paquetes y el **salto 6** no responde — el problema está en el salto 5 o su conexión con el 6.

## Interpretación de resultados

| Señal | Significa |
|---|---|
| `* * *` | El salto no respondió (puede ser firewall o router caído) |
| `!H` | Host unreachable (el destino no es accesible) |
| `!N` | Network unreachable (la red no es accesible) |
| `!P` | Protocol unreachable |
| `!X` | Administratively prohibited (firewall bloquea) |
| Latencia alta en un salto sin pérdida | Congestión en ese router |
| Latencia sube gradualmente | Distancia física normal |
| `30 hops` | Se alcanzó el máximo sin llegar al destino |

## Troubleshooting con traceroute

```
Situación: No puedo conectarme a un servidor web

1. ¿Hay conectividad básica?
   ping -c 4 8.8.8.8                     # ¿llega a internet?

2. ¿El DNS funciona?
   dig +short ejemplo.com                 # ¿resuelve el nombre?

3. ¿Dónde se pierde el paquete?
   traceroute -T -p 80 ejemplo.com        # TCP al puerto 80
   mtr -T -p 443 ejemplo.com             # monitoreo continuo

4. ¿El puerto está abierto?
   nc -zv ejemplo.com 80                  # ¿acepta conexiones?
```

## Ver también
- [[ping]] — probar conectividad básica
- [[dig]] — resolución DNS
- [[ss]] — puertos abiertos locales
- [[curl]] — probar servicios HTTP
- [[Redes Basicas]] — conceptos de red

## Enlaces externos

- [Wikipedia - traceroute](https://en.wikipedia.org/wiki/Traceroute)
- [Linux man page - traceroute](https://man7.org/linux/man-pages/man8/traceroute.8.html)

#comando