---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: sistema
prioridad: alta
---

# Proceso de Arranque (Boot Process)

## Definición

La secuencia completa desde que presionas el botón de encendido hasta que ves el prompt de inicio de sesión. Entenderla es clave para diagnosticar fallos de arranque, optimizar tiempos, y configurar kernels personalizados.

```
Secuencia completa del arranque:

  1. POST / Firmware (BIOS/UEFI)
          ↓
  2. Bootloader (GRUB / systemd-boot)
          ↓
  3. Kernel + initramfs (cargados en RAM)
          ↓
  4. initramfs monta drivers esenciales
          ↓
  5. init (PID 1) — systemd arranca servicios
          ↓
  6. getty / display-manager → login
          ↓
  7. Shell / entorno gráfico listo
```

---

## 1. POST / Firmware

Al encender, la placa base ejecuta el firmware (BIOS o UEFI) que realiza el **Power-On Self Test**:

| Firmware | Ubicación | Características |
|---|---|---|
| **BIOS** (Legacy) | ROM de la placa | Interfaz de texto, MBR (512B), máximo 2 TB de disco, lento |
| **UEFI** (Moderno) | Partición EFI (ESP, FAT32) | Interfaz gráfica, GPT, Secure Boot, arranque más rápido |

```bash
# Verificar si tu sistema arranca en UEFI o BIOS/Legacy
ls /sys/firmware/efi/                    # si existe → UEFI
# Si no existe → BIOS legacy

# Alternativa:
[ -d /sys/firmware/efi ] && echo "UEFI" || echo "BIOS Legacy"
```

### Secure Boot

El firmware UEFI puede verificar que el bootloader esté firmado por una clave de confianza antes de ejecutarlo. Las distros principales (Ubuntu, Fedora, Arch) firman su bootloader (shim) con la clave de Microsoft incluida en la mayoría de placas.

```bash
# Verificar estado de Secure Boot
mokutil --sb-state                       # SecureBoot enabled/disabled
bootctl status | grep -i secure          # desde systemd-boot
```

---

## 2. Bootloader

El firmware localiza el bootloader en el disco y lo ejecuta. El bootloader más común es **GRUB**, seguido de **systemd-boot** (Pop!_OS, Arch) y **Limine** (usado en configuraciones avanzadas).

Para información detallada sobre cada bootloader, incluyendo configuración, temas, rescue shell, instalación y comparativas → ver **[[Bootloaders (GRUB Limine systemd-boot)]]**

### GRUB vs LILO (contexto histórico)

Antes de que GRUB dominara el ecosistema Linux, **LILO** (Linux Loader) era el bootloader por defecto. Las diferencias clave:

| Aspecto | GRUB | LILO |
|---|---|---|
| **Sistema de archivos** | Entiende ext2/3/4, Btrfs, XFS (lee el kernel desde el FS) | No entiende FS — usa desplazamientos de disco en bruto |
| **Interfaz** | Menú + línea de comandos interactiva | Solo menú (sin shell) |
| **Configuración** | `/boot/grub/grub.cfg` (archivo de texto) | `/etc/lilo.conf` — cualquier cambio requiere reescribir el MBR |
| **Recuperación** | Fácil: interfaz de comandos permite boot manual | Más difícil: error de configuración puede dejar el disco inservible |
| **Mantenimiento** | `update-grub` regenera automáticamente | `lilo` reescribe el MBR manualmente |
| **Uso actual** | Estándar en casi todas las distros | Obsoleto (última versión 2015) |

### Loadlin (método histórico)

Antes de que Linux tuviera controladores para todo el hardware, existía **Loadlin**, una herramienta que permitía cargar Linux desde **DOS** o **Windows 9x**. El kernel Linux reemplazaba completamente el sistema operativo en ejecución. Era útil cuando:

- El BIOS no soportaba arranque desde el dispositivo donde estaba Linux
- Hardware que solo tenía controladores para DOS (módems, ciertos adaptadores de red)

Este método cayó en desuso a medida que Linux ganó soporte de hardware nativo y dejó de ser necesario a principios de los 2000.

### Las 4 etapas de GRUB

1. **Stage 1**: el firmware (BIOS/UEFI) carga el MBR (512 bytes) o el ejecutable EFI
2. **Stage 1.5** (opcional): código adicional en el MBR o partición de arranque para leer discos grandes (>1024 cilindros) o unidades LBA
3. **Stage 2**: el gestor de arranque completo — muestra el menú, permite editar entradas, acceder a la shell
4. **Stage 3**: carga del kernel + initramfs según la entrada seleccionada

GRUB soporta arranque directo (Linux), chain-loading (Windows, otros SO), y tiene tres interfaces: menú de selección, editor de configuración y consola de línea de comandos.

### Parámetros del kernel desde el bootloader

Independientemente del bootloader, los parámetros que se pasan al kernel se configuran de la siguiente manera:

```bash
# GRUB: /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX="net.ifnames=0"

# systemd-boot: en los archivos .conf del kernel
options root=UUID=... rw quiet
```

### Cómo añadir parámetros temporalmente (GRUB)

En el menú de GRUB: presiona `e` sobre la entrada, navega a la línea que empieza con `linux` o `linuxefi`, añade el parámetro al final, y presiona `Ctrl+X` o `F10` para arrancar.

---

## 3. Kernel + initramfs

El bootloader carga dos archivos en memoria:

| Archivo | Ruta típica | Propósito |
|---|---|---|
| **vmlinuz** | `/boot/vmlinuz-*-*` | El kernel comprimido (bzip2/zstd). Contiene los drivers compilados estáticamente |
| **initramfs** | `/boot/initramfs-*-*` | Sistema de archivos temporal en RAM (~5-40MB). Contiene drivers modulares y scripts necesarios para montar el sistema real |

```bash
# Ver kernels instalados
ls /boot/vmlinuz-*
file /boot/vmlinuz-*                 # ver tipo: Linux kernel x86 boot executable

# Regenerar initramfs
sudo mkinitcpio -P                    # Arch (genera todos los kernels)
sudo update-initramfs -u              # Debian/Ubuntu
sudo dracut --force                   # Fedora/RHEL
```

### ¿Qué hay dentro del initramfs?

El initramfs es un archivo comprimido (CPIO) que se extrae en RAM como el sistema de archivos raíz temporal:

```bash
# Extraer y explorar initramfs (Arch)
mkdir /tmp/initramfs && cd /tmp/initramfs

# Detectar compresión y descomprimir (gzip, zstd o xz)
file /boot/initramfs-linux.img            # muestra el tipo de compresión
zcat /boot/initramfs-linux.img | cpio -idmv   # si es gzip
zstdcat /boot/initramfs-linux.img | cpio -idmv # si es zstd (Arch reciente, Fedora)
xzcat /boot/initramfs-linux.img | cpio -idmv   # si es xz (algunas distros)

ls                                    # verás /bin, /etc, /lib, /init...
cat init                              # el script que arranca (busca root, monta, exec systemd)

# Debian/Ubuntu usa múltiples pequeños cpios
/usr/lib/dracut/skipcpio /boot/initrd.img-* | zcat | cpio -idmv
```

El initramfs se encarga de:
1. Cargar drivers de almacenamiento (AHCI, NVMe, SATA, virtio)
2. Cargar drivers de sistema de archivos (ext4, Btrfs, XFS, F2FS)
3. Desbloquear volúmenes cifrados (LUKS) si es necesario
4. Activar LVM si la raíz está en volúmenes lógicos
5. Montar el sistema de archivos raíz real
6. Hacer `switch_root` o `pivot_root` al sistema real y ejecutar `/sbin/init`

### Espacio de usuario temprano (early userspace)

En kernels modernos, el initramfs forma parte de lo que se llama **early userspace** (espacio de usuario temprano). El kernel realiza la mínima inicialización necesaria, monta el initramfs como raíz temporal, y pasa el control a `/init` (un script o binario dentro del initramfs). Este se encarga de:

1. Cargar los módulos del kernel necesarios (drivers de almacenamiento, FS, red)
2. Desbloquear volúmenes cifrados (LUKS)
3. Activar LVM o RAID si la raíz está en esos esquemas
4. Montar el sistema de archivos raíz real
5. Ejecutar `switch_root` o `pivot_root` para cambiar al sistema real
6. Ejecutar `/sbin/init` (systemd)

Esta separación permite mantener el kernel más pequeño y genérico, ya que los drivers específicos se cargan como módulos desde el initramfs.

### Microcódigo de CPU

Los CPUs modernos necesitan microcódigo actualizado para correcciones de seguridad y estabilidad. Se carga como un initramfs adicional:

```bash
# Intel
sudo pacman -S intel-ucode            # Arch
sudo apt install intel-microcode      # Debian/Ubuntu
# AMD
sudo pacman -S amd-ucode              # Arch
sudo apt install amd64-microcode       # Debian/Ubuntu

# En GRUB, debe aparecer ANTES que el initramfs normal:
# initrd /intel-ucode.img /initramfs-linux.img
```

### Fase de carga del kernel (detalle interno)

El kernel se almacena como imagen comprimida (`zImage` o `bzImage`) usando zlib o zstd. Al cargarse:

1. La cabecera del kernel realiza una configuración mínima de hardware
2. Descomprime la imagen completa en memoria alta
3. En x86, ejecuta `startup_32()` (en `/arch/x86/boot/compressed/head_64.S`)
4. Configura tablas de paginación y gestión de memoria básica
5. Detecta el tipo de CPU y capacidades (punto flotante, extensiones)
6. Llama a `start_kernel()`, la función de inicio independiente de arquitectura

`start_kernel()` inicializa:
- Manejo de interrupciones (IRQs)
- Memoria adicional
- El planificador de tareas
- Inicia el primer proceso de espacio de usuario (`init`)
- Arranca la tarea inactiva (`cpu_idle()`)

---

## 4. Parámetros del kernel (kernel cmdline)

Se pasan al kernel desde el bootloader para modificar comportamiento en el arranque sin recompilar:

```bash
# Ver parámetros con los que arrancó el sistema actual
cat /proc/cmdline

# Ejemplo típico (Ubuntu):
# BOOT_IMAGE=/vmlinuz-6.8.0-45-generic root=UUID=1234-5678 ro quiet splash

# Ejemplo típico (Arch):
# root=UUID=1234-5678 rw loglevel=3 quiet
```

### Parámetros esenciales

| Parámetro | Qué hace | Ejemplo |
|---|---|---|
| `root=` | Dispositivo donde está la raíz (por UUID, LABEL o /dev/sdX) | `root=UUID=abc-def-123` |
| `rw` / `ro` | Montar raíz en lectura-escritura / solo lectura | `rw` |
| `quiet` | Ocultar mayoría de mensajes del kernel (boot más limpio) | `quiet` |
| `splash` | Mostrar animación de carga (plymouth) | `splash` |

### Parámetros de troubleshooting (modo rescue)

| Parámetro | Qué hace | Cuándo usarlo |
|---|---|---|
| `single` | Modo monousuario (shell como root, sin servicios) | Reparar sistema que no arranca |
| `init=/bin/bash rw` | Arrancar directo a bash (sin systemd). **Incluir `rw`** o la raíz se montará solo lectura y no podrás reparar nada | Recuperación de emergencia |
| `systemd.unit=rescue.target` | Arrancar en modo rescate de systemd | Alternativa moderna a `single` |
| `systemd.unit=multi-user.target` | Arrancar sin GUI (solo texto) | Cuando la interfaz gráfica falla |
| `nomodeset` | Deshabilitar modosetting del kernel (usa framebuffer genérico) | **Problemas con drivers gráficos** (NVIDIA, pantalla negra tras arranque) |
| `acpi=off` | Desactivar ACPI por completo | Problemas de energía, apagado, suspensión |
| `acpi_osi=Linux` | Reportar "Linux" al firmware ACPI | Soluciona algunos problemas de hardware específicos |
| `noapic` | Deshabilitar APIC | Problemas de interrupciones en hardware antiguo |
| `nolapic` | Deshabilitar APIC local | Similar, para CPUs antiguos |
| `maxcpus=1` | Usar solo 1 núcleo | Aislar problemas de SMP/multinúcleo |
| `mem=4G` | Limitar RAM visible | Probar comportamiento con poca memoria |
| `root=/dev/sdaX` | Especificar raíz manualmente | Si falla UUID |
| `panic=10` | Reiniciar automáticamente tras 10s de kernel panic | Servidores (para que se recuperen solos) |
| `3` | Equivalente a runlevel 3 | Arranque en modo texto (**solo distros con sysvinit**, ej. Devuan antiguo). En distros con systemd usar `systemd.unit=multi-user.target` |
| `debug` | Logs del kernel en nivel máximo | Diagnóstico detallado |
| `earlyprintk=ttyS0,115200` | Logs tempranos por puerto serie | Debug sin pantalla |

### Cómo añadir parámetros temporalmente

En el menú de GRUB: presiona `e` sobre la entrada, navega a la línea que empieza con `linux` o `linuxefi`, añade el parámetro al final, y presiona `Ctrl+X` o `F10` para arrancar.

```bash
# Ejemplo: línea linux antes
linux /vmlinuz-linux root=UUID=abc rw quiet

# Editar a:
linux /vmlinuz-linux root=UUID=abc rw quiet nomodeset single
# → Arrancará en modo monousuario sin drivers gráficos acelarados
```

### Cómo añadir parámetros permanentemente

```bash
# Editar /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"       # para arranque normal
GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"  # siempre (incluye recovery)

# Añadir nomodeset:
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nomodeset"

# Regenerar GRUB
sudo update-grub                    # Debian/Ubuntu
sudo grub-mkconfig -o /boot/grub/grub.cfg  # Arch, Fedora
```

---

## 5. init (PID 1) — systemd

Una vez que el kernel monta la raíz real, ejecuta `/sbin/init` (que es un symlink a systemd en la mayoría de distros):

```bash
# Verificar qué init usa el sistema
ls -la /sbin/init                    # /sbin/init -> /lib/systemd/systemd
ps -p 1 -o comm=                    # debe mostrar systemd
```

1. systemd lee su configuración (`/etc/systemd/system/`, `/usr/lib/systemd/systemd/`)
2. Activa `default.target` (generalmente `graphical.target`)
3. Arranca servicios según dependencias en paralelo

```bash
# Ver la cadena de arranque
systemd-analyze                      # tiempo total
systemd-analyze blame                # qué servicios tardaron más
systemd-analyze critical-chain       # qué bloqueó el arranque
```

---

## 6. Display Manager / Login

El último paso del arranque automático es el gestor de pantalla (GDM, SDDM, LightDM) que presenta la pantalla de login, o directamente un `getty` para login en consola.

```bash
# Ver display manager activo
systemctl status display-manager     # apunta al DM instalado
cat /etc/systemd/system/display-manager.service  # o seguir el symlink

# Deshabilitar DM (para arrancar en consola siempre)
sudo systemctl disable gdm           # o sddm, lightdm, etc.
sudo systemctl set-default multi-user.target  # arranque en modo texto
```

---

## Diagnóstico de arranque

### Kernel panic

Pantalla completa con texto y un contador:

```
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
```

**Causas comunes**:
- `root=` incorrecto en parámetros del kernel
- Falta el driver del sistema de archivos en el initramfs
- UUID cambiado (por cambio de disco, clonación, etc.)

**Solución**: arrancar desde USB, chroot, y regenerar initramfs.

### GRUB Rescue

```bash
# En la shell grub>
ls                              # encontrar discos
set root=(hd0,gpt2)
insmod ext4                    # cargar módulo FS
linux /boot/vmlinuz-linux root=/dev/sda3
initrd /boot/initramfs-linux.img
boot
```

### Loop de login (vuelve al prompt)

Síntoma: ingresas usuario y contraseña correctos y vuelve al prompt de login.

**Causas**:
- `/home` no montado o corrupto
- `~/.Xauthority` o `~/.xsession` corrupto
- Shell por defecto no válida (borraste bash/zsh)

**Solución**: `Ctrl+Alt+F2` → consola alternativa, chown/reparar dotfiles.

### Pantalla negra después de GRUB

**Causas y soluciones**:
1. **NVIDIA**: añadir `nomodeset` a los parámetros del kernel
2. **Wayland incompatible**: cambiar a Xorg en el DM
3. **Kernel nuevo incompatible**: arrancar kernel anterior desde GRUB

---

## Por qué importa

- Cuando el sistema no arranca, saber en qué etapa falló reduce horas de troubleshooting a minutos
- Los parámetros del kernel (`nomodeset`, `single`, `init=/bin/bash`) son el equivalente Linux del "modo seguro" de Windows
- Entender initramfs evita tener que reinstalar cuando algo sale mal con los drivers de disco
- La diferencia entre UEFI y BIOS Legacy determina cómo particionar y qué bootloader usar

## Relación con otros conceptos

- [[Filesystem Hierarchy Standard]] — `/boot/` contiene vmlinuz e initramfs
- [[Proc y Sys]] — `/proc/cmdline` muestra los parámetros de arranque actuales
- [[systemd]] — el init moderno (PID 1) que continúa el proceso tras el kernel
- [[Cifrado (LUKS dm-crypt GPG)]] — initramfs maneja el desbloqueo de LUKS
- [[Particionado y Esquemas de Disco]] — GPT para UEFI, MBR para BIOS
- [[Permisos y Propietarios]] — el initramfs debe ser legible por GRUB

## Ver también

- [[Filesystem Hierarchy Standard]]
- [[Proc y Sys]]
- [[systemd]]
- [[Compilación desde Código Fuente]]
- [[Dual Boot con Windows]] — gestión de bootloaders con múltiples SO

## Enlaces externos

- [Wikipedia — Booting process of Linux](https://en.wikipedia.org/wiki/Booting_process_of_Linux)
- [Wikipedia — initramfs](https://en.wikipedia.org/wiki/Initramfs)
- [Arch Wiki — Arch boot process](https://wiki.archlinux.org/title/Arch_boot_process)

#sistema #arranque
