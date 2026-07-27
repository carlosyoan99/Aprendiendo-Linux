---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: media
---

# pv

> Monitorea el progreso de datos a través de un pipeline: muestra velocidad, tiempo transcurrido, ETA y barra de progreso. Útil cuando ejecutas un pipe largo (dd, compresión, transferencia de archivos) y quieres saber cuánto falta.

## Sintaxis

```bash
pv [opciones] [archivo...]
comando_origen | pv [opciones] | comando_destino
```

## Descripción

`pv` (pipe viewer) se inserta en un pipe para monitorizar el flujo de datos. Sin argumentos, pasa los datos de stdin a stdout mientras muestra una barra de progreso, velocidad y ETA en stderr.

Es la herramienta ideal para hacer visible el progreso en pipes que normalmente son mudos (dd, gzip, tar, netcat, etc.).

## Formato de salida

```bash
 511MiB 0:00:05 [ 102MiB/s] [========================>] 100%
```

| Componente | Significado |
|---|---|
| `511MiB` | Total de datos transferidos |
| `0:00:05` | Tiempo transcurrido (HH:MM:SS) |
| `[ 102MiB/s]` | Velocidad actual de transferencia |
| `[===> ]` | Barra de progreso |
| `100%` | Porcentaje completado (si conoce el total) |

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-s N` | Tamaño total estimado (para barra de progreso %) | `pv -s 4G < archivo.iso > /dev/sdb` |
| `-S` | Detectar tamaño automáticamente si el archivo existe | `pv -S archivo.iso > /dev/sdb` |
| `-N nombre` | Nombre/etiqueta para el progreso | `pv -N "ISO" archivo.iso > /dev/sdb` |
| `-L N` | Limitar velocidad (rate limit, útil para no saturar red) | `pv -L 10m archivo > /dev/null` |
| `-W` | No mostrar barra hasta que pasen datos | `pv -W archivo.iso > /dev/sdb` |
| `-c` | Usar cursor positioning (evita scroll) | `pv -c archivo.iso > /dev/null` |
| `-p` | Mostrar porcentaje | `pv -p archivo.iso > /dev/sdb` |
| `-t` | Mostrar temporizador | `pv -t archivo.iso > /dev/sdb` |
| `-r` | Mostrar velocidad (rate) | `pv -r archivo.iso > /dev/sdb` |
| `-B` | Tamaño del buffer (bytes) | `pv -B 16M archivo.iso > /dev/sdb` |
| `-S` | Salida más compacta | `pv -S archivo.iso > /dev/sdb` |
| `-F formato` | Formato personalizado | `pv -F "%t %r %p" archivo.iso` |

## Ejemplos

```bash
# 1. Progreso de dd al crear USB booteable
sudo dd if=ubuntu.iso bs=4M | pv -s 4G | sudo dd of=/dev/sdb bs=4M

# 2. Progreso de compresión
tar cf - /ruta/carpeta | pv -s 500M | gzip > backup.tar.gz

# 3. Progreso de copia de archivo grande
pv archivo_grande.iso > destino.iso

# 4. Progreso de transferencia SSH
tar czf - /ruta | pv | ssh usuario@servidor "cat > backup.tar.gz"

# 5. Limitar velocidad de transferencia (útil en redes compartidas)
pv -L 5m archivo.iso > /dev/sdb      # máximo 5 MB/s

# 6. Nombrar el progreso para múltiples pipes
pv -N "Carpeta1" carpeta1.tar.gz | ...\npv -N "Carpeta2" carpeta2.tar.gz | ...

# 7. Con tamaño detectado automáticamente
pv -S ubuntu.iso > copia.iso

# 8. Verificar velocidad de lectura de disco
dd if=/dev/sda bs=1M | pv | dd of=/dev/null

# 9. Transferir archivo por red con netcat
pv archivo.iso | nc servidor 9999

# 10. Usar en lugar de cat para ver progreso
pv archivo.sql | mysql -u root base_de_datos
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Ver progreso de dd** sin `status=progress` | `dd if=disco.img \| pv -s 100G \| dd of=/dev/sdb` |
| **Backup remoto** con progreso | `tar czf - /home \| pv \| ssh server \"cat > home.tar.gz\"` |
| **Importar SQL grande** con feedback | `pv db.sql.gz \| gunzip \| mysql -u root basededatos` |
| **Copiar ISO a USB** con ETA | `pv ubuntu.iso > /dev/sdb` |
| **Rate limit** para no saturar red | `pv -L 2m archivo.iso > /dev/sdb` |

## Combinaciones comunes con pipe

```bash
# Con tar comprimiendo
tar cf - /var/www | pv -s $(du -sb /var/www | awk '{print $1}') | gzip > www_backup.tar.gz

# Con netcat enviando archivo
pv archivo.iso | nc -w 3 192.168.1.100 9999

# Copia con checksum simultáneo
pv archivo.iso | tee copia.iso | sha256sum > checksum.txt

# Ver velocidad real de un pipe sin archivo base
cat /dev/zero | pv | dd of=/dev/null     # prueba de velocidad de CPU/memoria
```

## Alternativas

| Herramienta | Ventaja |
|---|---|
| **pv** | Independiente, se inserta en cualquier pipe |
| **dd status=progress** | Integrado en dd moderno (coreutils 8.24+) |
| **rsync --progress** | Muestra progreso por archivo |
| **progress** (comando) | Monitoriza progreso de procesos en ejecución | `progress -w` |
| **bar** | Alternativa ligera a pv |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `pv: command not found` | pv no está instalado | `sudo apt install pv` (Debian), `sudo pacman -S pv` (Arch) |
| Barra de progreso sin porcentaje | Falta `-s` o `-S` para conocer el tamaño total | Usar `pv -s TAMAÑO` o `pv archivo` (lee tamaño automáticamente) |
| Velocidad incorrecta | pv mide velocidad en tiempo real — fluctúa | Es normal. La velocidad es instantánea, no promedio |
| pv no muestra nada | Datos pasan demasiado rápido y pv no refresca | Usar `-c` o probar con un archivo más grande |
| pv ralentiza el pipe | pv añade overhead mínimo | Usar `pv -b` (solo bytes, sin barra) para mínimo overhead |

## Notas

- **Instalación**: No viene preinstalado en la mayoría de distros. `sudo apt install pv`.
- **Siempre que veas `|` y te preguntes "¿cuánto falta?"**, agrega un `pv` en el medio.
- **Si pv conoce el tamaño** (porque lees un archivo directamente o usas `-s`), muestra ETA, porcentaje y barra.
- **Si no conoce el tamaño** (pipe sin `-s`), muestra solo datos transferidos, velocidad y tiempo.
- **Formatos de tamaño**: K, M, G, T, P, E (también KiB, MiB, GiB).

## Enlaces externos

- [Sitio oficial de pv](https://www.ivarch.com/programs/pv.shtml)
- [Linux man page — pv(1)](https://man.archlinux.org/man/pv.1)
- [Arch Wiki — pv](https://wiki.archlinux.org/title/Pv)

## Ver también

- [[dd]] — copia de bloques (a menudo combinado con pv)
- [[tar]] — empaquetado (combinado con pv para progreso)
- [[rsync]] — copia remota con progreso nativo
- pipe — tuberías en Linux
- [[Cheat Sheet - Comandos Esenciales]]

#comando #util
