---
fecha_creacion: 2026-07-20
estado: resuelto
categoria: concepto
prioridad: media
---

# Linux From Scratch (LFS)

## ¿Qué es?

**Linux From Scratch (LFS)** es un proyecto que proporciona instrucciones **paso a paso** para construir un sistema Linux completo y funcional **compilando todo desde código fuente**. No es una distribución — es un **libro** (documentación) que te guía en la construcción artesanal de tu propio Linux.

Fundado por **Gerard Beekmans** en 1999, el proyecto LFS nació como respuesta a la pregunta: _"¿Qué pasaría si construyéramos un sistema Linux desde cero, entendiendo cada pieza?"_ El libro se publica bajo licencia MIT y está disponible gratuitamente en [linuxfromscratch.org](https://www.linuxfromscratch.org/).

A diferencia de [[Compilacion desde Codigo Fuente]], donde compilas **un programa** individual, LFS compila **todo el sistema operativo**: el kernel, las herramientas base, las bibliotecas, el init, y todo lo necesario para que el sistema arranque por sí mismo.

```bash
# Lo que consigues al final: un sistema que arranca, tiene shell,
# herramientas POSIX básicas, y está listo para que le añadas lo que quieras.
# Sin systemd (a menos que lo elijas), sin gestor de paquetes,
# sin nada que no hayas puesto tú mismo.
```

---

## LFS ↔ BLFS ↔ ALFS — El ecosistema

El proyecto se divide en tres subproyectos complementarios:

| Proyecto | Qué construye | Propósito |
|---|---|---|
| **LFS** | Sistema base mínimo: kernel, libc, shell, coreutils, init, toolchain | Obtener un sistema que arranque a la shell. **Fundación** |
| **BLFS** (Beyond LFS) | Red, Xorg/Wayland, sonido, escritorio, servidores, lenguajes | Añadir funcionalidad al sistema base. **Extensión** |
| **ALFS** (Automated LFS) | Automatización del proceso con scripts | Reproducir el build sin intervención manual. **Automatización** |

### BLFS — Beyond Linux From Scratch

Una vez tienes LFS funcionando, BLFS te guía para añadir:

- **Red**: interfaces, DHCP, DNS, SSH
- **Gráficos**: Xorg, Wayland, drivers
- **Escritorios**: XFCE, KDE, GNOME, LXQt
- **Sonido**: ALSA, PulseAudio, PipeWire
- **Servidores**: Apache/Nginx, MySQL/PostgreSQL, Samba
- **Lenguajes**: Python, Perl, Ruby, Node.js
- **Documentos**: TeX, Ghostscript, LibreOffice

No es necesario seguir BLFS al pie de la letra — puedes elegir solo lo que necesitas.

### ALFS — Automated Linux From Scratch

ALFS proporciona herramientas para automatizar el proceso. La principal es **jhalfs**, que convierte el XML del libro LFS en scripts ejecutables:

```bash
# jhalfs toma el libro LFS y genera scripts make
jhalfs  # descarga fuentes, las compila, las instala
```

**Usos de ALFS:**
- Los desarolladores del libro lo usan para verificar que las instrucciones son correctas
- Usuarios avanzados que ya construyeron LFS manualmente y quieren repetir el proceso de forma automatizada
- Testing de versiones nuevas del libro

---

## El proceso de construcción (fases)

Construir LFS es un proceso lineal que sigue estas fases:

```
Fase 0: Preparación del host
    ↓
Fase 1: Toolchain temporal (cross-compilación)
    ↓
Fase 2: Herramientas temporales (chroot)
    ↓
Fase 3: Sistema base completo
    ↓
Fase 4: Configuración del sistema
    ↓
Fase 5: Kernel + bootloader
    ↓
🎉 Reinicio en el nuevo sistema
```

### Fase 0 — Preparación del host

Necesitas una distribución Linux existente (el "host") con:

```bash
# Requisitos mínimos del host
gcc --version                    # compilador C/C++
ld --version                     # binutils (linker)
ldd --version                    # glibc
make --version                   # make
bison --version                  # generador de parsers
gawk --version                   # awk GNU
bash --version                   # shell
# Y varios más (texinfo, gperf, perl, python, etc.)
```

Además:
- **Partición**: una partición libre (o disco) para el nuevo sistema (~10-20 GB mínimo)
- **Variables de entorno**: `LFS=/mnt/lfs` apuntando al punto de montaje
- **Usuario `lfs`**: un usuario sin privilegios para construir los paquetes (seguridad)

```bash
export LFS=/mnt/lfs
mkdir -pv $LFS
sudo mount /dev/sdX $LFS       # montar la partición destino

# Crear usuario de build
sudo groupadd lfs
sudo useradd -s /bin/bash -g lfs -m -k /dev/null lfs
sudo passwd lfs
sudo chown -v lfs $LFS         # dar permisos al usuario lfs
```

### Fase 1 — Toolchain temporal (cross-compilación)

Esta es la fase **más educativa** y **la más crítica**. Se construye una **toolchain** (cadena de herramientas) que se ejecuta en el host pero produce código para el nuevo sistema.

```bash
# La técnica: cross-compilación dinámica
# 1. Compilamos binutils para el target (el nuevo sistema)
# 2. Compilamos GCC con soporte limitado
# 3. Compilamos glibc (usando el GCC limitado)
# 4. Recompilamos GCC completo contra la nueva glibc
# 5. Ahora tenemos un compilador que genera código para el target
```

**¿Por qué es necesario este baile?**
- El compilador del host genera código para el host (ej. x86_64 con glibc 2.35)
- El nuevo sistema necesita su propia glibc y su propio GCC
- Hay una dependencia circular: GCC necesita glibc, glibc necesita GCC
- La solución es construir en etapas: primero un GCC mínimo, luego glibc, luego GCC completo

```bash
# Ejemplo conceptual: construir binutils para el target
cd $LFS/sources
tar xf binutils-*.tar.xz
cd binutils-*
mkdir -v build && cd build
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT \
             --disable-nls \
             --enable-gprofng=no \
             --disable-werror
make -j$(nproc)
make install
```

### Fase 2 — Herramientas temporales (chroot)

Una vez que la toolchain funciona, se construyen herramientas básicas dentro de un **entorno chroot** que aísla el build del host:

```bash
# Entrar al entorno chroot
chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /tools/bin/bash --login +h
```

Dentro del chroot se compilan e instalan:
- **Coreutils**: cp, mv, rm, ls, cat...
- **Findutils**: find, locate
- **Grep, Sed, Awk**: herramientas de texto
- **Diffutils, Patch**: herramientas de parcheo
- **Make, Autotools**: herramientas de build
- **GCC, Binutils, Glibc** (ya existen pero se reinstalan en ubicación definitiva)

Cada paquete se compila e instala con el mismo patrón:

```bash
./configure --prefix=/usr
make -j$(nproc)
make install
```

Pero antes de instalar, se verifica que funcione:

```bash
# Ejemplo típico en el libro LFS:
tar xf coreutils-*.tar.xz
cd coreutils-*
./configure --prefix=/usr \
            --enable-no-install-program=kill,uptime
make -j$(nproc)
make DESTDIR=$LFS install    # instalar en staging
# PENDIENTE: ajustes de permisos, mover binarios...
```

### Fase 3 — Sistema base completo

Se instalan los paquetes que forman el sistema completo (en orden, porque hay dependencias):

| Orden | Paquete | Propósito |
|---|---|---|
| 1 | Man-pages | Documentación de llamadas al sistema |
| 2 | Iana-etc | `/etc/services` y `/etc/protocols` |
| 3 | Glibc | **Biblioteca C estándar** — el corazón del sistema |
| 4 | Zlib, Bzip2, Xz | Compresión/descompresión |
| 5 | Readline | Edición de línea de comandos |
| 6 | M4, Bison, Flex | Generadores de parsers |
| 7 | Grep, Sed, Awk | Herramientas de texto |
| 8 | Coreutils | Comandos base (cp, mv, ls...) |
| 9 | Bash | Shell por defecto |
| 10 | ... y ~70 paquetes más |

**Total: ~80 paquetes** en la versión estable actual (LFS 12.2).

### Fase 4 — Configuración del sistema

Una vez instalado el software, se configura:

```bash
# Crear estructura de directorios FHS
mkdir -pv /{boot,home,etc,opt,srv,usr/local,var/log,var/mail}

# Archivos de configuración esenciales
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon:/run/dbus:/usr/bin/false
systemd-bus-proxy:x:72:72:systemd Bus Proxy:/dev/null:/usr/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/dev/null:/usr/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/dev/null:/usr/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/dev/null:/usr/bin/false
systemd-network:x:76:76:systemd Network Management:/dev/null:/usr/bin/false
systemd-resolve:x:77:77:systemd Resolver:/dev/null:/usr/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/dev/null:/usr/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF

# Configurar red, hostname, consola, timezone
echo "mi-lfs" > /etc/hostname
cat > /etc/hosts << "EOF"
127.0.0.1 localhost
::1 localhost
EOF

# Configurar el sistema de init (/etc/inittab o systemd)
# LFS usa systemd por defecto desde la versión 12.0
```

### Fase 5 — Kernel y bootloader

```bash
# Configurar y compilar el kernel
cd /sources
tar xf linux-*.tar.xz
cd linux-*
make mrproper
make menuconfig          # configuración interactiva del kernel
make -j$(nproc)
make modules_install
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-*-lfs

# Instalar y configurar GRUB
grub-install /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg
```

---

## ¿Qué aprendes construyendo LFS?

| Concepto | Dónde aparece en LFS |
|---|---|
| **Toolchain** | Fase 1 — construyes binutils+GCC+glibc desde cero, entiendes su interdependencia |
| **Especulaciones circulares** | GCC necesita glibc, glibc necesita GCC — LFS te muestra cómo romper el ciclo |
| **Cross-compilación** | Construyes software que corre en una máquina (host) para otra máquina (target) |
| **Chroot** | Fase 2 — aíslas el nuevo sistema del host para evitar contaminación |
| **FHS** | Creas manualmente `/usr`, `/var`, `/etc`, `/opt` — sabes por qué existen |
| **Init system** | Configuras systemd (o sysvinit si eliges la versión alternativa) |
| **Kernel config** | Configuras y compilas tu kernel manualmente |
| **Boot process** | Instalas GRUB, configuras la entrada de arranque, entiendes la cadena completa |
| **Dependencias** | ~80 paquetes deben compilarse en orden exacto — entiendes quién depende de quién |
| **Systemd units** | Creas servicios, timers, targets para que el sistema arranque correctamente |

---

## Tabla comparativa: LFS vs Gentoo vs distro binaria

| Aspecto | LFS | Gentoo | Distro binaria (Ubuntu/Arch) |
|---|---|---|---|
| **Instalación** | ~1-3 días (manual, compilando todo) | ~4-8 horas (compilando) | ~15-30 minutos |
| **Control** | Absoluto (tú eliges cada paquete y opción) | Muy alto (USE flags) | Medio-Alto (repositorios) |
| **Gestor paquetes** | Ninguno (tú gestionas) | Portage (emerge) | apt/pacman/dnf |
| **Actualizaciones** | Manuales (recompilar) | `emerge -uDN @world` | `apt upgrade` |
| **Dificultad** | Muy alta | Alta | Baja-Media |
| **Aprendizaje** | Máximo | Muy alto | Bajo |
| **Mantenimiento** | Muy difícil | Moderado | Fácil |

---

## Por qué importa

LFS no es práctico para el día a día — nadie usa LFS como su distro principal durante años. Pero es **la mejor inversión educativa** que puedes hacer si quieres entender Linux en profundidad:

- **Desmitifica el sistema**: después de LFS, sabes qué hace cada archivo en `/etc`, `/usr/lib`, `/var/log`
- **Debugging real**: cuando algo se rompe, sabes qué componentes están involucrados y cómo diagnosticar
- **Embedded**: construir sistemas mínimos para Raspberry Pi, routers, o dispositivos embebidos es esencialmente LFS a pequeña escala
- **Contenedores**: entender qué necesita un sistema mínimo para funcionar te ayuda a crear imágenes Docker más pequeñas y seguras
- **Confianza**: después de construir tu propio Linux desde cero, ninguna distro te parece "complicada"

## Qué NO es LFS

- ❌ **No es una distribución** para usar diariamente
- ❌ **No es para principiantes** — requiere soltura con la terminal y haber compilado programas antes
- ❌ **No es rápido** — compilar ~80 paquetes lleva horas
- ❌ **No tiene gestor de paquetes** — actualizar un paquete requiere recompilarlo manualmente

## Cuándo tiene sentido construir LFS

| Situación | Recomendación |
|---|---|
| Quieres entender Linux desde dentro | ✅ Adelante, es la mejor inversión |
| Necesitas un sistema mínimo para un dispositivo embebido | ✅ LFS es la base conceptual |
| Has usado Arch/Gentoo y quieres el siguiente nivel | ✅ Es el paso natural |
| Es tu primera vez en Linux | ❌ Empieza con [[Linux Mint]] o [[Ubuntu]] |
| Necesitas un sistema productivo para trabajar | ❌ Usa una distro estable |
| Quieres una distro personalizada optimizada | ⚠️ Considera [[Gentoo]] primero |

---

## Troubleshooting común

| Problema | Causa | Solución |
|---|---|---|
| `make: *** No rule to make target` | Paquete mal configurado o dependencia faltante | Revisar las instrucciones del libro LFS. Verificar que todos los prerequisitos del paquete están instalados |
| `undefined reference to '...'` | La toolchain no se construyó correctamente | Revisar que los enlaces simbólicos de la toolchain apuntan adonde deben |
| `chroot: failed to run command` | El binario no existe o no tiene permiso de ejecución | Verificar que el binario fue instalado correctamente y tiene `+x` |
| Kernel panic al arrancar | Root filesystem no encontrado | Revisar `root=` en GRUB. Verificar que el driver del FS está compilado en el kernel |
| `can't open /dev/null: Permission denied` | Permisos incorrectos en `/dev` | Crear nodos de dispositivo correctamente con `mknod` o montar devtmpfs |
| `Segmentation fault` en herramientas base | La glibc está corrupta o hay mezcla de versiones | Revisar que se instaló la glibc correcta y que no hay librerías del host interfiriendo |
| `No space left on device` al compilar | Espacio insuficiente en la partición destino | Asignar mínimo 10 GB. Verificar que los sources se limpian tras compilar |
| El sistema arranca pero no ve la red | Faltan drivers de red en el kernel | Recompilar el kernel con los módulos de red correctos (`lspci -k` para identificarlos) |

---

## Ver también

- [[Compilacion desde Codigo Fuente]] — compilación de programas individuales, prerrequisito conceptual para LFS
- [[Gentoo]] — distribución source-based menos radical que LFS (tiene gestor de paquetes)
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — qué ocurre cuando arrancas el sistema que construiste
- [[Kernel Linux]] — el componente más importante que configuras en LFS
- [[Genkernel]] — alternativa para configurar el kernel automáticamente (Gentoo pero aplicable conceptualmente)
- [[Linux embebido]] — construcción de sistemas Linux mínimos para hardware específico
- [[Contenedores]] — qué necesita un sistema Linux mínimo para funcionar (aplicable a imágenes Docker)
- [[Busybox]] — alternativa ligera a Coreutils, usada en initramfs y embebido

## Enlaces externos

- [Linux From Scratch — Página oficial](https://www.linuxfromscratch.org/)
- [LFS — Libro estable (online)](https://www.linuxfromscratch.org/lfs/view/stable/)
- [BLFS — Libro estable (online)](https://www.linuxfromscratch.org/blfs/view/stable/)
- [ALFS — Automated Linux From Scratch](https://www.linuxfromscratch.org/alfs/)
- [LFS — Hints](https://www.linuxfromscratch.org/hints/) — trucos y optimizaciones de la comunidad
- [LFS — Patches](https://www.linuxfromscratch.org/patches/) — parches necesarios para ciertos paquetes
- [FAQ de LFS](https://www.linuxfromscratch.org/faq/)
- [Wikipedia — Linux From Scratch](https://en.wikipedia.org/wiki/Linux_From_Scratch)

#concepto #lfs
