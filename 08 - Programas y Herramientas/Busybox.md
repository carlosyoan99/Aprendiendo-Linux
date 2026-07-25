---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: programa
prioridad: alta
licencia: GPLv2
alternativas: Toybox (BSD)
---

# BusyBox

> La **navaja suiza del Linux embebido**: un único ejecutable que reemplaza más de 300 comandos Unix estándar (ls, cp, cat, grep, init, vi, etc.) en un solo binario. Esencial en sistemas integrados, routers, Android y contenedores Docker.

## Qué es

BusyBox es un *software suite* que combina múltiples utilidades Unix en un solo archivo ejecutable. Fue creado por **Bruce Perens** en 1995 para poner un sistema de arranque completo en un disquete (instalador de Debian). Hoy es el **estándar de facto** para el espacio de usuario en sistemas Linux embebidos, routers (OpenWrt), contenedores Docker (Alpine Linux) y dispositivos Android (vía root).

La magia de BusyBox: un solo binario que se comporta como diferentes comandos según el nombre con el que se le invoque (via enlaces simbólicos o duros).

### Arquitectura: multi-call binary vs GNU multi-binary

```
┌── GNU Coreutils ───────────────────┐      ┌── BusyBox ──────────────────┐
│                                    │      │                             │
│  /bin/ls     → ELF propio (1 MB)   │      │  /bin/busybox → ELF único   │
│  /bin/cp     → ELF propio (0.8 MB) │      │       │                     │
│  /bin/mv     → ELF propio (0.7 MB) │      │       ├── ls  (symlink)     │
│  /bin/cat    → ELF propio (0.5 MB) │      │       ├── cp  (symlink)     │
│  /bin/grep   → ELF propio (1.2 MB) │      │       ├── mv  (symlink)     │
│  /bin/find   → ELF propio (1.5 MB) │      │       ├── cat (symlink)     │
│  ...         → 100+ ELFs           │      │       ├── grep (symlink)    │
│                                    │      │       └── ... (~300 cmds)   │
│  Total: ~10-20 MB                  │      │   Total: ~1-2 MB            │
└────────────────────────────────────┘      └─────────────────────────────┘
```

Esto ahorra espacio porque:
1. Un solo binario ELF en lugar de 300+
2. Código compartido entre comandos dentro del mismo binario
3. Versiones simplificadas de los comandos (sin features avanzados)

## Capturas / Imágenes

> ![BusyBox](https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/BusyBox_screenshot.png/320px-BusyBox_screenshot.png)
> *BusyBox ejecutándose en un dispositivo embebido*

## Instalación

```bash
# Debian/Ubuntu
sudo apt install busybox

# Arch Linux
sudo pacman -S busybox

# Fedora
sudo dnf install busybox

# Alpine Linux (viene preinstalado)
apk add busybox

# En contenedores Docker (imagen Alpine ~5 MB)
docker pull alpine
docker run alpine busybox ls -la /
```

## Cómo funciona

BusyBox utiliza el enfoque de **binario único**: en lugar de tener un ejecutable separado para cada comando (como hace GNU Coreutils), todos los comandos están compilados en un solo archivo.

```bash
# Llamar a un comando específico
/bin/busybox ls -la

# Los comandos suelen tener enlaces simbólicos
ls -la /bin/ls
# /bin/ls -> /bin/busybox

# Ver comandos disponibles compilados en el binario
busybox --list

# Ver la lista completa
busybox --list-full
```

Esto ahorra espacio porque:
1. Un solo binario ELF en lugar de 300+
2. Código compartido entre comandos dentro del mismo binario
3. Versiones simplificadas de los comandos (sin features avanzados)

### Tamaño comparativo

| Suite | Tamaño típico | Dispositivo |
|---|---|---|
| **BusyBox** | ~1-2 MB | Router, embebido, contenedor |
| **GNU Coreutils** | ~10-20 MB | Escritorio Linux |
| **Toybox** | ~1 MB | Android |

## Comandos incluidos

BusyBox implementa la mayoría de los comandos POSIX y GNU que un usuario espera:

```bash
# Comandos de archivo
ls, cp, mv, rm, cat, find, tar, gzip, dd

# Comandos de sistema
init, modprobe, insmod, lsmod, mdev, syslogd, crond

# Editores
vi, sed, awk, grep

# Shell
ash (Almquist shell)

# Red
ping, wget, tftp, telnet, nc, ifconfig, udhcpc

# Otros
chmod, chown, mount, umount, printf, head, tail, sort, wc, test
```

Un sistema típico con BusyBox crea enlaces simbólicos automáticamente:

```bash
# Instalar enlaces BusyBox en /bin
busybox --install -s /bin
# Ahora /bin/ls, /bin/cp, etc. apuntan a /bin/busybox
```

## Shell ash vs Bash — diferencias clave

BusyBox incluye **ash** (Almquist Shell) como shell por defecto, no Bash. ash es POSIX-compliant pero carece de muchas extensiones de Bash:

| Característica | ash (BusyBox) | Bash |
|---|---|---|
| `[[ ... ]]` condicional | ❌ Usar `[ ... ]` POSIX | ✅ |
| Arrays indexados | ❌ | ✅ |
| Arrays asociativos | ❌ | ✅ |
| `${var/patrón/reemplazo}` | ❌ | ✅ |
| Process substitution `<(...)` | ❌ | ✅ |
| `echo {1..10}` brace expansion | ❌ | ✅ |
| `=~` regex matching | ❌ | ✅ |
| `source` alias | ❌ (usar `.` POSIX) | ✅ |
| **Rendimiento** | Más rápido y ligero | Más lento (más features) |
| **Uso en RAM** | ~100 KB | ~1 MB |

```bash
# Script compatible ash y bash (POSIX)
if [ "$var" = "valor" ]; then  # NO usar [[ ]] 
    echo "ok"
fi

# Evitar funciones Bash-only
# for i in {1..10}; do ... done  ← no funciona en ash
# Usar en su lugar:
i=1
while [ "$i" -le 10 ]; do
    ...
    i=$((i + 1))
done
```

> 📝 **Regla práctica**: si escribes scripts para Alpine/embebido, asume ash. Prueba con `busybox sh script.sh`.

## BusyBox init vs systemd vs SysV

BusyBox incluye un **init mínimo** (PID 1) para sistemas embebidos, sin dependencias ni paralelismo:

| Aspecto | BusyBox init | SysVinit | systemd |
|---|---|---|---|
| **Configuración** | `/etc/inittab` | `/etc/inittab` + scripts | `.service` units |
| **Paralelismo** | ❌ No | ❌ No | ✅ Sí |
| **Dependencias** | ❌ No | ❌ No | ✅ Sí |
| **Socket activation** | ❌ No | ❌ No | ✅ Sí |
| **Respawn** | ✅ Sí (`respawn`) | ✅ Sí | ✅ Sí (`Restart=`) |
| **Logging** | ❌ No integrado | ❌ No integrado | ✅ journald |
| **Tamaño** | ~20 KB | ~200 KB | ~2 MB+ |
| **Complejidad** | Mínima | Baja | Alta |
| **Usado en** | OpenWrt, Alpine, embebido | Distros legacy | Distros modernas |

```bash
# /etc/inittab típico para BusyBox init
::sysinit:/etc/init.d/rcS          # Scripts de arranque
::respawn:/sbin/getty 115200 tty1  # Consola interactiva
::ctrlaltdel:/sbin/reboot          # Ctrl+Alt+Supr
::shutdown:/bin/umount -a -r       # Apagado
```

## Compilar BusyBox desde fuente

Para sistemas embebidos o contenedores personalizados, puedes compilar BusyBox solo con los comandos que necesitas:

```bash
# 1. Descargar fuente
git clone https://git.busybox.net/busybox
cd busybox

# 2. Configurar applets (similar al kernel Linux)
make defconfig                     # configuración por defecto (~300 applets)
# O mejor: empezar de cero
make allnoconfig                   # deshabilitar todo
make menuconfig                    # seleccionar SOLO los applets necesarios

# 3. Compilar
make -j$(nproc)

# 4. Instalar en un directorio destino
make CONFIG_PREFIX=./rootfs install
# Esto crea ./rootfs/bin/busybox + enlaces simbólicos

# 5. Verificar tamaño
ls -lh busybox                      # ~800 KB - 1.5 MB
du -sh rootfs/                       # ~2 MB con enlaces
```

**Cross-compilación** (para ARM, RISC-V, etc.):

```bash
make CROSS_COMPILE=arm-linux-gnueabihf- defconfig
make CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc)
```

## Usos principales

### BusyBox en contenedores

```bash
# Alpine Linux es el caso de uso más común de BusyBox
# Imagen base: ~5 MB (vs ~100 MB de Debian o ~200 MB de Ubuntu)

FROM alpine:latest
RUN apk add --no-cache python3
# Resultado: ~50 MB en lugar de ~300 MB con Ubuntu
```

## Casos prácticos

### Initramfs personalizado con BusyBox

```bash
# Crear un initramfs mínimo que use BusyBox como init
# (útil para sistemas embebidos o rescate)
mkdir -p initramfs/{bin,dev,etc,proc,sys}
cp /bin/busybox initramfs/bin/
ln -s busybox initramfs/bin/sh
ln -s busybox initramfs/bin/mount
# Crear /init script que monte /proc, /sys y ejecute sh
cd initramfs && find . | cpio -H newc -o | gzip > ../initramfs.cpio.gz
```

### Contenedor ultra-ligero con BusyBox + Alpine

```bash
# Alpine Linux usa BusyBox por defecto, ocupando ~5 MB
# Ideal como base para contenedores Docker
FROM alpine:latest
RUN apk add --no-cache curl
# Resultado: ~15 MB en lugar de ~200 MB con Ubuntu
```

## Comparativa con alternativas

| Aspecto | BusyBox | Toybox | GNU Coreutils |
|---|---|---|---|
| **Tamaño** | ~1-2 MB | ~1 MB | ~10-20 MB |
| **Licencia** | GPLv2 | BSD | GPLv3 |
| **Comandos** | ~300 | ~200 | ~100 |
| **Usado en** | Alpine, OpenWrt, Buildroot | Android | Escritorios Linux |
| **Flags avanzados** | Limitados | Limitados | Completos |
| **vi incluido** | ✅ Sí | ❌ No | ❌ No |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Comando no reconocido | Enlaces simbólicos no instalados | `busybox --install -s /bin` |
| Falta flag `--color` en ls | BusyBox es simplificado | Usar la versión GNU si se necesita |
| `vi` no tiene syntax highlighting | BusyBox vi es mínimo | Usar `nano` o instalar `vim` completo |
| No encuentra `busybox` | No instalado | `sudo apt install busybox` |
| Script requiere GNU específico | BusyBox no implementa flags no estándar | Usar la versión completa del comando |

## Notas personales

- BusyBox es lo primero que instalo en cualquier contenedor mínimo o sistema embebido que administre. Su `ash` shell es sorprendentemente capaz para scripting básico.
- El `vi` de BusyBox es mínimal pero suficiente para editar config en un rescate — aprender sus comandos básicos (i, ESC, :wq, /buscar) vale la pena.
- Diferencia clave con GNU: BusyBox prioriza el cumplimiento POSIX sobre extensiones GNU. Scripts que usen flags GNU específicos (ej. `sed -i` con sintaxis GNU) pueden fallar.
- Si un script no funciona en Alpine/BusyBox, el culpable suele ser un flag que BusyBox no implementa o un comando que no existe (ej. `hostname` sin flags).

## Enlaces externos

- [Sitio oficial BusyBox](https://busybox.net/)
- [Lista de comandos BusyBox](https://busybox.net/downloads/BusyBox.html)
- [Wikipedia — BusyBox](https://en.wikipedia.org/wiki/BusyBox)
- [Alpine Linux](https://alpinelinux.org/) — distro que usa BusyBox
- [Toybox](https://landley.net/toybox/) — alternativa bajo licencia BSD
- [Buildroot](https://buildroot.org/) — sistema embebido con BusyBox

## Ver también

- [[Utilidades Base del Sistema]] — herramientas GNU estándar
- [[Coreutils y util-linux]] — suite completa de comandos
- [[Contenedores]] — BusyBox en imágenes ligeras
- [[Docker]] — Alpine como imagen base
- [[Gestores de Paquetes]] — APK de Alpine

#programa
