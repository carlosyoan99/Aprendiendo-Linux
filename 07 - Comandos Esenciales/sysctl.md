---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: comando
prioridad: media
---

# sysctl — Parámetros del kernel en caliente

## Definición

`sysctl` permite **leer y modificar parámetros del kernel en tiempo de ejecución** sin reiniciar. Es la interfaz amigable para `/proc/sys/` — cada parámetro sysctl corresponde a un archivo dentro de `/proc/sys/`.

```
sysctl → /proc/sys/
  net.ipv4.ip_forward  →  /proc/sys/net/ipv4/ip_forward
  vm.swappiness        →  /proc/sys/vm/swappiness
  kernel.hostname      →  /proc/sys/kernel/hostname
```

> Ver [[Proc y Sys]] para entender la relación con `/proc/sys/`.

---

## Comandos básicos

```bash
# ── Leer parámetros ──
sysctl net.ipv4.ip_forward                  # 0 o 1
sysctl vm.swappiness                        # tendencia a usar swap (0-100)
sysctl kernel.hostname                      # nombre del host
sysctl fs.file-max                          # máximo de archivos abiertos global

# Leer varios
sysctl net.ipv4.tcp_syncookies vm.swappiness kernel.hostname

# Leer TODOS los parámetros (cientos de líneas)
sysctl -a                                    # todos los parámetros
sysctl -a | grep -i "net\|tcp"              # solo parámetros de red
sysctl -a | grep vm                         # solo parámetros de memoria virtual

# Contar parámetros disponibles
sysctl -a | wc -l                            # ~1000+ parámetros en un kernel moderno
```

```bash
# ── Escribir parámetros (temporal, hasta reinicio) ──
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w vm.swappiness=10
sudo sysctl -w fs.file-max=100000

# Formato: sysctl -w clave=valor
# Nota: los cambios no persisten al reiniciar
```

```bash
# ── Persistir cambios ──
# Los archivos en /etc/sysctl.d/ se cargan al arrancar
# También /etc/sysctl.conf (archivo tradicional)

# Crear archivo de configuración
sudo tee /etc/sysctl.d/99-mis-ajustes.conf << 'EOF'
# IP forwarding (para router/NAT)
net.ipv4.ip_forward = 1

# Reducir uso de swap (en sistemas con suficiente RAM)
vm.swappiness = 10

# Aumentar límite de archivos abiertos
fs.file-max = 100000

# Seguridad de red
net.ipv4.conf.all.rp_filter = 1             # protección contra IP spoofing
net.ipv4.tcp_syncookies = 1                 # protección SYN flood
net.ipv4.icmp_echo_ignore_broadcasts = 1    # ignorar pings broadcast
net.ipv4.conf.all.accept_redirects = 0      # no aceptar redirects ICMP
net.ipv6.conf.all.accept_redirects = 0      # para IPv6 también
EOF

# Aplicar los cambios sin reiniciar
sudo sysctl --system                         # carga todos los archivos de /etc/sysctl.d/

# Verificar que los cambios se aplicaron
sysctl net.ipv4.ip_forward vm.swappiness fs.file-max
```

---

## Categorías principales de parámetros

| Prefijo | Categoría | Ejemplos |
|---|---|---|
| `net.core.*` | Red — configuración global del stack de red | `net.core.somaxconn`, `net.core.rmem_max` |
| `net.ipv4.*` | Red — TCP/IP (IPv4) | `net.ipv4.tcp_syncookies`, `net.ipv4.ip_forward` |
| `net.ipv6.*` | Red — TCP/IP (IPv6) | `net.ipv6.conf.all.disable_ipv6` |
| `vm.*` | Memoria virtual, swap, caché | `vm.swappiness`, `vm.dirty_ratio`, `vm.vfs_cache_pressure` |
| `kernel.*` | Kernel general | `kernel.hostname`, `kernel.pid_max`, `kernel.sysrq` |
| `fs.*` | Sistema de archivos | `fs.file-max`, `fs.inotify.max_user_watches` |
| `dev.*` | Dispositivos específicos | `dev.raid.speed_limit_max` |

---

## Tuning de red (parámetros clave)

### Protección y seguridad

```bash
# /etc/sysctl.d/99-seguridad-red.conf
# SYN flood protection
net.ipv4.tcp_syncookies = 1

# Ignorar pings broadcast (evita ser amplificador de DDoS)
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Ignorar redirects ICMP (evita ataques MITM)
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0

# Reverse Path Filtering (protege contra IP spoofing)
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignorar peticiones de source routing
net.ipv4.conf.all.accept_source_route = 0
```

### Rendimiento de red (servidores con mucha carga)

```bash
# /etc/sysctl.d/99-rendimiento-red.conf
# Cola de conexiones entrantes (aumentar para servidores con muchas conexiones)
net.core.somaxconn = 65535                   # default 128

# Tamaño de buffers de red (aumentar para throughput alto)
net.core.rmem_max = 16777216                 # buffer de lectura max 16 MB
net.core.wmem_max = 16777216                 # buffer de escritura max 16 MB

# Buffers TCP automáticos
net.ipv4.tcp_rmem = 4096 131072 16777216    # min, default, max
net.ipv4.tcp_wmem = 4096 65536 16777216     # min, default, max

# Habilitar TCP Fast Open (reduce latencia en conexiones nuevas)
net.ipv4.tcp_fastopen = 3

# Reutilizar conexiones TIME_WAIT (útil para servidores web)
# ⚠️ tcp_tw_reuse fue eliminado del kernel en 5.15+
# Alternativa: reducir tiempo TIME_WAIT con tcp_fin_timeout
net.ipv4.tcp_fin_timeout = 15

# Rango de puertos efímeros (para clientes con muchas conexiones salientes)
net.ipv4.ip_local_port_range = 1024 65535
```

### Deshabilitar IPv6 (si no lo usas)

```bash
# /etc/sysctl.d/99-deshabilitar-ipv6.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
# Nota: require reinicio de interfaces o reboot para efecto completo
```

---

## Tuning de memoria y swap

```bash
# /etc/sysctl.d/99-memoria.conf

# swappiness: tendencia a usar swap (0-100)
# 0 → solo swap si es absolutamente necesario (SSD o mucha RAM)
# 10 → intercambio mínimo (buen balance en escritorio)
# 60 → default de la mayoría de distros
# 100 → intercambio agresivo
vm.swappiness = 10

# dirty_ratio: % de memoria que puede estar sucia antes de forzar escritura
vm.dirty_ratio = 20                          # default 20%
vm.dirty_background_ratio = 10               # default 10%

# vfs_cache_pressure: tendencia a reclamar caché de inodos/dentry
# 100 → balance neutral (default)
# 50 → conservar más caché (mejor rendimiento de FS a costa de RAM)
# 200 → reclamar más agresivo (liberar RAM para apps)
vm.vfs_cache_pressure = 50

# overcommit: política de asignación de memoria
# 0 → heurística (kernel decide), 1 → siempre asignar, 2 → no exceder swap+RAM*ratio
vm.overcommit_memory = 0
vm.overcommit_ratio = 50                     # solo si overcommit_memory=2
```

---

## Tuning del kernel (parámetros generales)

```bash
# /etc/sysctl.d/99-general.conf

# Límite de archivos abiertos global
fs.file-max = 200000

# Límite de watches de inotify (útil para editores, IDEs, y herramientas de monitoreo)
# Si ves "too many open files" con inotify, aumentar esto
fs.inotify.max_user_watches = 524288

# PID máximo (útil en servidores con muchos procesos)
kernel.pid_max = 131072

# SysRq (magic keys) — útil si el sistema se congela
# 1 = habilitado, 0 = deshabilitado
kernel.sysrq = 1

# Core dumps
kernel.core_pattern = /var/crash/core-%e-%p-%t
```

---

## Aplicar cambios y verificar

```bash
# Aplicar todos los archivos de sysctl.d
sudo sysctl --system

# Ver un parámetro específico
sysctl net.ipv4.ip_forward

# Verificar que un archivo se cargó correctamente
sysctl --system 2>&1 | grep -i "error\|fail"

# Ver valores actuales vs defaults
sysctl -a | grep vm.swappiness

# Si un parámetro requiere reinicio (poco común), lo verás en la documentación
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `sysctl: permission denied` | Falta sudo | `sudo sysctl -w ...` |
| `sysctl: unknown key` | El parámetro no existe | Verificar nombre exacto con `sysctl -a \| grep ...` |
| Parámetro no persiste al reiniciar | No está en `/etc/sysctl.d/` | Crear archivo `.conf` y ejecutar `sudo sysctl --system` |
| `sysctl --system` ignora mi archivo | El archivo no termina en `.conf` | Renombrar a `*.conf` |
| Parámetro no tiene efecto | Depende de kernel module cargado | `modinfo br_netfilter` (ej: `net.bridge.bridge-nf-call-iptables` requiere módulo `br_netfilter`) |

### Parámetros que requieren módulos específicos

```bash
# Ver módulos necesarios para ciertos parámetros
# Puente de red (bridge) requiere:
sudo modprobe br_netfilter
sysctl net.bridge.bridge-nf-call-iptables    # Ahora sí disponible

# Hacerlo persistente:
echo "br_netfilter" | sudo tee /etc/modules-load.d/br_netfilter.conf
```

---

## Buenas prácticas

1. **Archivos separados por propósito**: `99-red.conf`, `99-memoria.conf`, `99-seguridad.conf` — más fácil de mantener que un solo `sysctl.conf` gigante.
2. **Prefijo numérico**: los archivos se cargan en orden alfabético. `01-...` se carga antes que `99-...`. Los valores posteriores sobrescriben a los anteriores.
3. **Probar en caliente antes de persistir**: ejecuta `sudo sysctl -w clave=valor` primero. Si funciona y no rompe nada, añádelo al archivo `.conf`.
4. **Documentar cada cambio**: añade un comentario explicando por qué cambiaste un parámetro. Ahorrarás horas de debugging meses después.
5. **No tocar parámetros sin entenderlos**: algunos (como `vm.dirty_ratio` muy alto) pueden causar pérdida de datos si el sistema se apaga inesperadamente.

## Ver también

- [[Proc y Sys]] — `/proc/sys/` es la interfaz raw que sysctl abstrae
- [[Redes Basicas]] — tuning de red y configuración de interfaces
- [[Firewall]] — sysctl params de seguridad de red
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — parámetros del kernel al arrancar
- [[Módulos del kernel (lsmod modprobe blacklist)]] — módulos que habilitan ciertos sysctls

## Enlaces externos

- [Wikipedia - sysctl](https://en.wikipedia.org/wiki/Sysctl)
- [Linux man page - sysctl](https://man7.org/linux/man-pages/man8/sysctl.8.html)
- [Arch Wiki - sysctl](https://wiki.archlinux.org/title/Sysctl)

#comando #kernel #rendimiento
