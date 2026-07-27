---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: media
---

# zram

> Módulo del kernel de Linux que crea un **dispositivo de bloques comprimido en RAM**, usado como swap para mejorar el rendimiento en sistemas con poca memoria. Anteriormente llamado **compcache**.

## Qué es

zram (antes compcache) es un módulo del kernel Linux que crea un dispositivo de bloques virtual en la RAM cuyo contenido se almacena **comprimido**. En lugar de paginar a disco (swap lento), las páginas de memoria se comprimen y almacenan en la propia RAM, reduciendo la necesidad de swap en disco y mejorando drásticamente el rendimiento en sistemas con poca memoria.

Es especialmente útil en:
- **Portátiles con poca RAM** (4 GB o menos)
- **Raspberry Pi y dispositivos ARM**
- **Android** (usado por defecto desde Android 4.4)
- **Servidores con mucha carga** como caché de compresión
- **Chromebooks** (usado por defecto en ChromeOS)

## Cómo funciona

```bash
# El kernel crea un dispositivo /dev/zram0
# Las páginas de memoria se comprimen con algoritmos (lzo, lz4, zstd)
# y se almacenan en el dispositivo zram
# Cuando el sistema necesita la página, se descomprime al vuelo

# Proporción de compresión típica: 2:1 a 3:1
# 1 GB de RAM → ~2-3 GB de espacio zram
```

```
┌───────────────────────┐
│     Memoria RAM        │
├───────────────────────┤
│  Apps y procesos       │ ← Memoria activa
├───────────────────────┤
│  zram (comprimido)     │ ← Páginas menos usadas (swap rápido)
│  ~2-3× compresión      │
├───────────────────────┤
│  Swap en disco (lento) │ ← Solo cuando zram se llena
└───────────────────────┘
```

## Instalación y configuración

```bash
# Verificar soporte en el kernel
zramctl --help

# Ver dispositivos zram activos
zramctl

# Activar zram manualmente (2 GB)
sudo modprobe zram
echo 2G | sudo tee /sys/block/zram0/disksize
sudo mkswap /dev/zram0
sudo swapon -p 100 /dev/zram0   # prioridad alta (swap en RAM primero)

# Desactivar
sudo swapoff /dev/zram0
sudo modprobe -r zram
```

### Configuración permanente (systemd)

```bash
# Crear /etc/systemd/zram-generator.conf (Fedora 35+, systemd 248+)
[zram0]
zram-size = ram * 2     # 2× el tamaño de RAM
compression-algorithm = zstd
```

### Algoritmos de compresión

| Algoritmo | Velocidad | Ratio | CPU |
|---|---|---|---|
| **lzo** | Rápido | 2:1 | Bajo |
| **lz4** | Muy rápido | 2:1 | Muy bajo |
| **zstd** | Medio | 2.5:1 | Medio |
| **842** | Lento | 2.8:1 | Alto |

```bash
# Ver algoritmos disponibles
cat /sys/block/zram0/comp_algorithm

# Cambiar algoritmo
echo zstd | sudo tee /sys/block/zram0/comp_algorithm
```

## zram vs zswap vs zcache

| Característica | zram | zswap | zcache |
|---|---|---|---|
| **Tipo** | Bloque comprimido en RAM | Caché de compresión para swap | Pool de páginas comprimidas |
| **Uso** | Como swap directamente | Intercepta páginas que van a swap | Frontend de swap |
| **Persistencia** | Volátil (se pierde al reboot) | Volátil | Volátil |
| **Recomendado para** | Sistemas con poca RAM | Sistemas con swap en disco | Sistemas con mucho I/O |
| **Configuración** | Fácil (zramctl) | Media (kernel params) | Difícil (obsoleto) |

### Recomendación

```bash
# Sistema con poca RAM (< 4 GB): usar zram como swap principal
# Sistema con suficiente RAM: usar zswap para mejorar el swap existente

# RHEL/Fedora recomienda zram por defecto desde Fedora 33+
# ChromeOS/Android usan zram por defecto
# Ubuntu 20.04+ usa zswap por defecto
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| zram no disponible | Módulo no cargado | `sudo modprobe zram` |
| Rendimiento pobre | CPU lenta + algoritmo zstd | Cambiar a lz4: `echo lz4 > /sys/.../comp_algorithm` |
| OOM pese a zram | zram muy pequeño | Aumentar `zram-size` en configuración |
| Alto uso de CPU | Compresión/descompresión | Usar lz4 (más rápido, menos ratio) |
| zram no persiste | Configuración temporal | Usar systemd-zram-generator o script en rc.local |

## Ver también

- [[Sistemas de Archivos]] — ext4, Btrfs, XFS
- [[RAID (mdadm)]] — redundancia de discos
- [[Stratis]] — gestión de almacenamiento moderna
- [[Proc y Sys]] — /proc y /sys

## Enlaces externos

- [Documentación kernel — zram](https://www.kernel.org/doc/html/latest/admin-guide/blockdev/zram.html)
- [Arch Wiki — zram](https://wiki.archlinux.org/title/Zram)
- [Wikipedia — zram](https://en.wikipedia.org/wiki/Zram)
- [systemd-zram-generator](https://github.com/systemd/zram-generator)

#sistema
