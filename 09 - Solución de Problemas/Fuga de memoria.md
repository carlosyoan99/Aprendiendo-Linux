---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: troubleshooting
prioridad: media
---

# Fuga de memoria

> El sistema se vuelve progresivamente más lento hasta que se queda sin RAM y empieza a usar swap agresivamente, o el OOM Killer mata procesos. Un proceso consume más y más memoria sin liberarla, o la "cached" memory crece sin control.

## Síntoma

- `free -h` muestra poca memoria disponible aunque no haya muchas apps abiertas.
- El sistema se ralentiza progresivamente durante horas/días de uso.
- Swap se llena o se usa intensivamente (thrashing).
- El OOM Killer mata procesos (Chrome, Firefox, compiladores).
- `dmesg` muestra "Out of memory: Kill process" o "oom-kill".
- Algunos procesos muestran un uso de RSS creciente en `htop` o `ps`.
- La "available" memory en `free -h` es mucho menor que la total.

## Diagnóstico

```bash
# 1. Estado actual de la memoria
free -h                                      # total, used, free, shared, buff/cache, available
cat /proc/meminfo | head -20                 # detallado

# 2. Procesos que más memoria consumen
ps aux --sort=-%mem | head -20               # top 20 por uso de RAM
ps aux --sort=-%mem | awk '$6 > 100000 {print}'  # procesos con >100MB RSS

# 3. Verificar si es OOM Killer el problema
sudo dmesg | grep -iE "oom|out of memory|kill process" | tail -10
journalctl -k | grep -iE "oom|out of memory" | tail -10

# 4. Verificar swap
sudo swapon --show
cat /proc/swaps
vmstat 1 5                                    # ver si está usando swap (si/so > 0)

# 5. Ver memoria por proceso (detallado)
cat /proc/<PID>/status | grep -iE "vmsize|vmrss|vmswap"  # de un proceso específico
smem -t -k -s rss                             # si smem está instalado
# O instalar: sudo apt install smem / sudo pacman -S smem

# 6. Verificar slab cache (kernel memory)
cat /proc/meminfo | grep -i slab
slabtop                                      # memoria de kernel

# 7. Verificar si es memoria "perdida" (no aparece enfree/used)
# Si MemTotal - MemAvailable - SwapTotal es mucho mayor que expected:
cat /proc/meminfo | grep -E "MemTotal|MemAvailable|Buffers|Cached|Slab|SReclaimable"
```

### Logs relevantes

```bash
# OOM Killer events
sudo journalctl -k | grep -iE "oom|out of memory|killed process" | tail -20

# Último OOM event (con detalles del proceso killed)
sudo journalctl -k -p err | grep -A 10 "oom" | tail -30

# Verificar si hay procesos zombie (memory leak a veces los crea)
ps aux | awk '$8 ~ /Z/ {print}' | head -10

# Memory pressure events
sudo journalctl -k | grep -iE "memory pressure|lowmem|memcg" | tail -10

# Historial de uso de memoria (si systemd-oomd está activo)
journalctl -u systemd-oomd --no-pager | tail -20
```

## Causa

1. **Proceso con memory leak** — aplicación que reserva memoria y no la libera (bug de software). Ejemplos: Firefox con muchas pestañas, Node.js apps, Java apps mal configuradas.
2. **Cache del filesystem crece sin control** — la "buff/cache" de `free` crece y no se libera (esto es normal en Linux, pero puede ser problemático si es excesivo).
3. **Swap insuficiente o ausente** — sin swap, el OOM Killer actúa antes de thrashing.
4. **Cgroups/containers sin límites** — Docker, Podman o systemd-run sin límites de memoria.
5. **Kernel memory leak** — módulo del kernel con leak (menos común pero más grave).
6. **Applications con heap grande** — Java, Go, Rust pueden reservar mucha memoria sin liberar.
7. **Zombie processes** — procesos terminados que consumen entradas de procesos.

## Solución

### Caso 1: identificar el proceso con leak

```bash
# Monitorear uso de memoria de procesos cada 5 segundos
watch -n 5 'ps aux --sort=-%mem | head -10'

# Ver el historial de un proceso específico (si tienes pidstat):
pidstat -r -p <PID> 5 10                     # cada 5s, 10 iteraciones

# O con ps en bucle:
for i in $(seq 1 12); do
  ps -p <PID> -o pid,rss,vsz,comm
  sleep 5
done

# Si el RSS crece constantemente → leak confirmado

# Para Firefox con muchas pestañas:
# Reducir pestañas o usar extensiones como Auto Tab Discard
# Firefox: about:config → browser.sessionhistory.max_entries = 10
```

### Caso 2: limpiar cache de filesystem

```bash
# Liberar cache (temporal, vuelve a llenarse)
sudo sync && sudo sysctl -w vm.drop_caches=3
# 1 = page cache, 2 = dentries+inodes, 3 = todo

# Para que no vuelva a llenarse:
# Editar /etc/sysctl.conf:
#   vm.swappiness=10              # reducir uso de swap
#   vm.vfs_cache_pressure=50      # liberar inode/dentry cache más agresivamente
#   vm.dirty_ratio=15             # % de RAM para dirty pages antes de escribir a disco
#   vm.dirty_background_ratio=5   # % para empezar a escribir en background

sudo sysctl -p
```

### Caso 3: configurar swap adecuadamente

```bash
# Verificar swap actual
sudo swapon --show
free -h

# Crear swapfile si no existe (Ubuntu/Debian):
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Para Arch (sin fallocate):
sudo dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Ajustar swappiness (0-200, default 60)
# Bajo = usa RAM primero, alto = usa swap primero
sudo sysctl vm.swappiness=10
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
```

### Caso 4: limitar memoria de containers

```bash
# Docker: limitar memoria de un contenedor
docker run -m 512m --memory-swap 1g mi-app

# Docker Compose:
# services:
#   app:
#     deploy:
#       resources:
#         limits:
#           memory: 512M

# systemd-run: limitar servicio
sudo systemd-run --scope -p MemoryMax=1G mi-servicio

# Verificar uso de memoria de containers
docker stats --no-stream
```

### Caso 5: configurar OOM Killer

```bash
# Ver prioridad OOM de un proceso (menor = más protegido)
cat /proc/<PID>/oom_score_adj                 # -1000 a 1000

# Proteger un proceso crítico del OOM Killer
echo -1000 | sudo tee /proc/<PID>/oom_score_adj  # nunca será killed

# Hacer que un proceso sea el primero en ser killed
echo 1000 | sudo tee /proc/<PID>/oom_score_adj

# Configurar systemd-oomd (OOM killer moderno, systemd 247+)
sudo systemctl enable systemd-oomd
sudo systemctl start systemd-oomd

# Verificar que está activo
systemctl status systemd-oomd
```

### Caso 6: encontrar y eliminar procesos zombie

```bash
# Ver procesos zombie
ps aux | awk '$8 ~ /Z/ {print}'

# Encontrar el padre del zombie
ps -eo pid,ppid,stat,cmd | grep -E "Z|defunct"

# Matar el padre (el zombie desaparecerá)
kill -9 <PPID del zombie>

# Si hay muchos zombies, puede ser un bug del padre
# Verificar con: pstree -p
```

### Verificación

```bash
# Tras aplicar la solución:
free -h                                       # memoria disponible razonable
ps aux --sort=-%mem | head -10                # ningún proceso con RSS anormal
sudo dmesg | grep -iE "oom|kill" | wc -l     # 0 nuevos OOM events
vmstat 1 5                                    # si/so debe ser 0 o muy bajo
```

## Escenarios / Variantes

| Variante / Síntoma | Causa típica | Solución rápida |
|---|---|---|
| **Firefox/Chrome consume mucha RAM** | Muchas pestañas | Reducir pestañas, usar uBlock Origin, activar `about:config` memory optimizations |
| **"Out of memory: Killed process"** en logs | OOM Killer activado | Añadir swap, identificar proceso con `ps aux --sort=-%mem`, limitar con cgroups |
| **Swap lleno pero RAM no** | swappiness muy alto | `sysctl vm.swappiness=10` |
| **Buffer/cache crece sin parar** | Normal en Linux pero excesivo | `sysctl vm.drop_caches=3` (temporal), ajustar `vm.vfs_cache_pressure` |
| **Docker consume toda la RAM** | Sin límites de memoria | `docker run -m 512m` o limits en docker-compose |
| **Java app con memory leak** | Heap sin GC adecuado | Ajustar `-Xmx`, usar jmap/jstat para diagnosticar |
| **Node.js app con leak** | Event listeners o buffers sin liberar | `node --max-old-space-size=512`, usar clinic.js |
| **Memoria "missing" (>20% de RAM)** | Kernel o hardware (ECC) | `slabtop` para ver slab cache, verificar con `dmesg` |

## Prevención

1. **Configurar swap adecuado** — al menos 2GB o igual a RAM si usas hibernate.
2. **Usar `vm.swappiness=10`** — evita swap agresivo innecesario.
3. **Monitorear periódicamente** — `htop` o `btop` para ver uso de memoria en tiempo real.
4. **Limitar memoria de containers** — siempre usar `-m` en Docker o `MemoryMax` en systemd.
5. **Configurar systemd-oomd** — mata procesos problemáticos automáticamente.
6. **No ejecutar servicios con memory leak en producción** — usar `valgrind` o `heaptrack` para diagnosticar.

## Notas adicionales

- En Linux, la "buff/cache" memory se libera automáticamente cuando una app la necesita — no es un problema si `available` es alto.
- Si `free -h` muestra 0 free pero `available` es >50% de total, no hay problema real.
- `smem` es más preciso que `ps` para medir memoria real (PSS vs RSS).
- Para servidores, usar `atop` o `netdata` para monitoreo histórico de memoria.
- Si sospechas de leak en el kernel, verificar con `slabtop` — si `dentry` o `inode_cache` crece sin límite, puede ser un leak de kernel.

## Enlaces externos

- [Arch Wiki — Process management](https://wiki.archlinux.org/title/Process_management)
- [Arch Wiki — Tuning squashfs/zram/swap](https://wiki.archlinux.org/title/Swap)
- [Linux Memory Management documentation](https://www.kernel.org/doc/Documentation/vm/)
- [smem — memory usage reporting](https://www.selenic.com/smem/)
- [systemd-oomd docs](https://www.freedesktop.org/software/systemd/man/systemd-oomd.service.html)

## Ver también

- [[Disco lleno (No space left on device)]] — espacio en disco vs memoria
- [[Gestión de energía y batería]] — power management y memoria
- [[Optimización de rendimiento]] — rendimiento general del sistema
- [[Docker permiso denegado]] — problemas de permisos en containers
- [[systemd]] — gestión de servicios y cgroups

#troubleshooting #memory #performance
