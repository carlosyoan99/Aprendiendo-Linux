---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# dd

> Copia datos a nivel de bloques, byte por byte. Se usa para clonar discos, crear USBs booteables, hacer backups completos (imágenes), o benchmarks de disco. Opera a bajo nivel — no le importa el sistema de archivos, solo los bytes.

## Sintaxis

```bash
dd if=origen of=destino [opciones]
dd if=/dev/zero of=archivo bs=1M count=1024
```

`dd` usa sintaxis con `=` en vez de flags Unix tradicionales: `if=` (input file), `of=` (output file).

## Descripción

`dd` (data duplicator / disk destroyer, según el humor) copia datos crudos entre dispositivos, archivos o flujos. Opera a nivel de bloques: copia sectores completos sin interpretar el sistema de archivos. Es la herramienta correcta para:

- **Crear USBs booteables** desde una ISO
- **Clonar discos completos** (incluyendo sector de arranque)
- **Hacer imágenes forenses** (copia bit a bit)
- **Benchmarks** de escritura/lectura de disco
- **Limpiar discos** escribiendo ceros o datos aleatorios

**⚠️ DANGER ZONE**: `dd` ejecutado con `of=` equivocado puede **destruir discos enteros** en segundos. Siempre verificar 3 veces `if` y `of` antes de presionar Enter.

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `if=<archivo>` | Origen (input file) | `if=/dev/sda` |
| `of=<archivo>` | Destino (output file) | `of=/dev/sdb` |
| `bs=<N>` | Tamaño de bloque (bytes). K/M/G aceptados | `bs=4M` |
| `count=<N>` | Copiar solo N bloques | `count=100` |
| `status=progress` | Muestra progreso durante la copia | `status=progress` |
| `conv=fsync` | Forzar escritura física antes de terminar | `conv=fsync` |
| `conv=sparse` | No escribir bloques de ceros (ahorra espacio) | `conv=sparse` |
| `seek=<N>` | Saltar N bloques en el destino | `seek=1000` (no sobrescribe inicio) |
| `skip=<N>` | Saltar N bloques en el origen | `skip=1000` (leer desde byte 1000*bs) |
| `oflag=sync` | Escribir sincrónicamente (sin buffering) | `oflag=sync` |

## Formato de salida (status=progress)

```
104857600 bytes (105 MB, 100 MiB) copied, 2.345 s, 44.7 MB/s
```

Muestra: bytes copiados, tiempo transcurrido, velocidad media.

## Ejemplos

```bash
# 1. Crear USB booteable desde una ISO
sudo dd if=ubuntu.iso of=/dev/sdb bs=4M status=progress conv=fsync

# 2. Clonar disco completo
sudo dd if=/dev/sda of=/dev/sdb bs=4M status=progress conv=fsync

# 3. Hacer imagen de un disco parted
sudo dd if=/dev/sda of=backup_disco.img bs=4M status=progress

# 4. Restaurar imagen a disco
sudo dd if=backup_disco.img of=/dev/sdb bs=4M status=progress

# 5. Benchmark de escritura
dd if=/dev/zero of=test bs=1M count=1024 status=progress

# 6. Benchmark de lectura
dd if=test of=/dev/null bs=1M status=progress

# 7. Limpiar disco (escribir ceros)
sudo dd if=/dev/zero of=/dev/sdb bs=4M status=progress

# 8. Crear archivo de swap
sudo dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 9. Respaldar MBR (primeros 512 bytes)
sudo dd if=/dev/sda of=mbr_backup.bin bs=512 count=1

# 10. Restaurar MBR
sudo dd if=mbr_backup.bin of=/dev/sda bs=512 count=1

# 11. Copiar un archivo grande mostrando progreso
dd if=archivo_grande.iso of=destino.iso bs=4M status=progress
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **USB booteable** rápido y confiable para instalar distro | `sudo dd if=debian.iso of=/dev/sdb bs=4M status=progress conv=fsync` |
| **Benchmark rápido de disco** antes de comprar un SSD | `dd if=/dev/zero of=test bs=1M count=4096 status=progress; dd if=test of=/dev/null bs=1M status=progress; rm test` |
| **Crear imagen forense** de un disco dañado (con ddrescue) | `sudo ddrescue -d /dev/sda imagen.img mapa.log` |
| **Generar archivo de prueba** de tamaño exacto | `dd if=/dev/urandom of=100mb.bin bs=1M count=100 status=progress` |
| **Limpiar espacio libre** antes de comprimir VM | `dd if=/dev/zero of=zero bs=1M; rm zero` (llena el disco con ceros para que se comprima mejor) |

## Combinaciones comunes con pipe

```bash
# Comprimir imagen directamente (evita escribir imagen sin comprimir)
sudo dd if=/dev/sda bs=4M status=progress | gzip > backup_disco.img.gz

# Restaurar imagen comprimida
gunzip -c backup_disco.img.gz | sudo dd of=/dev/sdb bs=4M status=progress

# Enviar imagen a través de SSH (backup remoto)
sudo dd if=/dev/sda bs=4M status=progress | ssh usuario@servidor "dd of=backup.img"

# Hacer checksum mientras se copia
dd if=archivo.iso bs=4M status=progress | tee copia.iso | sha256sum > checksum.txt
```

## Alternativas modernas

| Herramienta | Ventaja sobre dd |
|---|---|
| **ddrescue** (GNU) | Salta sectores dañados y reintenta. Ideal para discos con fallos mecánicos |
| **pv** (pipe viewer) | Muestra progreso, velocidad y ETA en cualquier pipe | `pv archivo.iso > /dev/sdb` |
| **balenaEtcher** / **Popsicle** | Herramientas gráficas para crear USBs booteables más seguras |
| **Clonezilla** | Clonación de discos con compresión y particionado inteligente |
| **partclone** | Clona solo los bloques usados del sistema de archivos (mucho más rápido) |
| **cp --sparse=always** | Copia archivos preservando sparse (agujeros) — mejor que dd para archivos individuales |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| **dd: /dev/sdb: Permission denied** | Falta sudo para acceder al dispositivo | Anteponer `sudo` |
| **dd: /dev/sdb: Resource busy** | El disco está montado | `sudo umount /dev/sdb*` o `sudo lsof /dev/sdb` para ver qué proceso lo usa |
| **dd: write error: No space left on device** | El destino se ha llenado (al clonar a disco más pequeño) | Verificar capacidades: `lsblk`, usar disco de mayor o igual tamaño |
| **dd: reading «/dev/sda»: Input/output error** | Sectores dañados en el origen | Usar `ddrescue` en vez de `dd` — salta los sectores malos y sigue |
| **USB no bootea después de dd** | ISO híbrida o falta sincronizar escritura | `sync` o usar `conv=fsync` |
| **dd parece congelado** | No muestra progreso (dd antiguo) | En otra terminal: `kill -USR1 $(pidof dd)` para ver progreso |

## Notas y advertencias

- **⚠️ Verificar `of=` tres veces**: `dd if=/dev/sda of=/dev/sdb` (sda → sdb) es copiar. `dd if=/dev/sdb of=/dev/sda` (sdb → sda) **borra** el disco original. Siempre confirmar cuál es ORIGEN y cuál es DESTINO.
- **`status=progress`** es esencial en versiones modernas (coreutils 8.24+). En sistemas más viejos, usar `kill -USR1`.
- **`conv=fsync`** evita que datos queden en caché. Sin esto, `dd` puede terminar antes de que los datos estén físicamente escritos.
- **Tamaño de bloque (`bs`)**: valores altos (4M-16M) aceleran la copia. Valores bajos (512, 1K) son más lentos pero permiten mayor control (útil para MBR).
- **No usar dd para backups diarios**: usa [[rsync]] (copia incremental), [[tar]] (empaquetado), o herramientas de backup dedicadas. `dd` copia discos completos incluso espacio vacío.
- **MBR vs GPT**: `dd bs=512 count=1` respalda el MBR tradicional. En GPT, la tabla de particiones principal es más grande (34 sectores).

## Enlaces externos

- [Wikipedia — dd (Unix)](https://en.wikipedia.org/wiki/Dd_(command))
- [GNU Coreutils — dd manual](https://www.gnu.org/software/coreutils/manual/html_node/dd-invocation.html)
- [Arch Wiki — dd](https://wiki.archlinux.org/title/Dd)
- [GNU ddrescue](https://www.gnu.org/software/ddrescue/)
- [Linux man page — dd(1)](https://man.archlinux.org/man/dd.1)

## Ver también

- [[rsync]] — copia incremental de archivos (más segura para backups diarios)
- [[tar]] — empaquetado y compresión de archivos
- [[cp]] — copia normal de archivos
- [[pv]] — monitor de progreso en pipes
- [[Creación de USB Booteable]] — guía completa de USBs booteables
- [[df y du]] — diagnóstico de espacio en disco
- [[Cheat Sheet - Comandos Esenciales]]

#comando
