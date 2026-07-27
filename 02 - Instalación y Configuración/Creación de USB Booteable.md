---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: instalacion
prioridad: alta
---

# Creación de USB Booteable

## Definición

Antes de instalar cualquier distro hay que "grabar" la imagen ISO en un USB de forma que la BIOS/UEFI pueda arrancar desde ahí. No es simplemente copiar el archivo — la ISO debe escribirse de forma que el firmware reconozca el USB como un dispositivo de arranque válido.

---

## BIOS/MBR vs UEFI/GPT

El método de grabación y la compatibilidad dependen del firmware de la placa. Es importante saber en qué modo arrancará tu sistema.

| Característica | **BIOS / Legacy** (MBR) | **UEFI** (GPT) |
|---|---|---|
| **Esquema de particiones** | MBR (Master Boot Record) | GPT (GUID Partition Table) |
| **Discos > 2 TB** | ❌ No soporta | ✅ Sí |
| **Particiones primarias** | 4 máximo (3 + extended) | 128 por defecto |
| **Bootloader** | En el primer sector del disco | En la partición EFI (FAT32) |
| **Seguridad** | Sin Secure Boot | Secure Boot (firma de bootloaders) |
| **Compatibilidad** | Universal (placa anterior a ~2012) | Estándar moderno (~2012+) |
| **Velocidad de arranque** | Más lenta | Más rápida |
| **Modo compatible** | — | CSM (Compatibility Support Module) emula BIOS |

```bash
# Verificar en qué modo arrancó tu sistema actual
ls /sys/firmware/efi       # si existe → UEFI; si no → BIOS legacy
```

### ¿Cómo elegir al grabar?

| Si tu equipo es... | Elige... |
|---|---|
| **Placa anterior a 2012** | MBR / BIOS legacy |
| **UEFI moderno (la mayoría)** | GPT / UEFI |
| **Dual boot con Windows** | GPT / UEFI (Windows 8+ lo exige) |
| **No sabes / no te importa** | Usa una ISO híbrida (isohybrid) + GPT — funciona en ambos |

> La mayoría de ISOs modernas son **híbridas**: funcionan tanto en BIOS como en UEFI. `dd` escribe la imagen tal cual, y la ISO ya trae la estructura correcta.

---

## Herramientas

| Herramienta | SO | Notas |
|---|---|---|
| **`dd`** | Linux/macOS | Nativo, sin GUI, riesgo alto si te equivocas de disco |
| **balenaEtcher** | Linux / macOS / Windows | GUI simple, escribe la ISO automáticamente. Buena para principiantes |
| **Ventoy** | Multiplataforma | Se instala UNA vez en el USB; después solo copias ISOs y eliges cuál bootear — no hay que re-grabar cada vez |
| **Rufus** | Windows | La más usada en Windows. Opciones avanzadas (GPT/MBR, persistencia, Secure Boot) |
| **Popsicle** | Linux | Escritor de ISOs multiplataforma multi-USB de System76. Permite grabar varios USBs a la vez |
| **Fedora Media Writer** | Linux / Windows | Creado por Fedora, soporta descarga directa de ISOs oficiales y verificación GPG integrada |
| **mkusb** | Linux | Herramienta avanzada con menú en terminal. Soporta persistencia, instalación de Ventoy, y arreglo de USBs dañados |

### Tabla comparativa rápida

| Herramienta | GUI/CLI | Persistencia | Secure Boot | Multi-ISO | Instalación |
|---|---|---|---|---|---|
| `dd` | CLI | ❌ No | ❌ No | ❌ No | Nativo |
| balenaEtcher | GUI | ❌ No | ❌ No | ❌ No | Flatpak, AppImage, paquete |
| Ventoy | CLI+GUI | ✅ Sí (plugin) | ✅ Sí | ✅ Sí | PPA, paquete, script |
| Rufus | GUI | ✅ Sí | ✅ Sí | ❌ No | Windows (ejecutable) |
| Popsicle | GUI | ❌ No | ❌ No | ❌ No | Flatpak, paquete |
| Fedora Media Writer | GUI | ❌ No | ✅ Sí | ❌ No | Flatpak, paquete |
| mkusb | CLI (curses) | ✅ Sí | ❌ No | ❌ No | PPA, paquete |

---

## Verificación de la ISO (checksums y GPG)

**Siempre verificar la ISO antes de grabarla.** Una ISO corrupta o modificada puede causar fallos de instalación o ser un riesgo de seguridad.

### Checksum (SHA256)

```bash
# Descargar el archivo SHA256 de la página oficial de la distro
# (junto a la ISO suele haber un archivo .sha256, .sha512 o CHECKSUMS)

# Calcular el hash de tu ISO descargada
sha256sum distro.iso
# Compara la salida con el hash oficial (debe ser IDÉNTICO)

# Verificación automática si tienes el archivo .sha256
sha256sum -c distro.iso.sha256
# distro.iso: OK   ← todo bien
# distro.iso: FAILED ← ISO corrupta o diferente
```

### Verificación GPG (firma digital)

Algunas distros además firman los checksums con GPG para garantizar que no fueron modificados en el servidor:

```bash
# 1. Descargar la ISO, el archivo CHECKSUMS y CHECKSUMS.sig (o .asc)

# 2. Importar la clave pública del equipo de la distro
gpg --keyserver keyserver.ubuntu.com --recv-keys <ID_CLAVE>

# 3. Verificar la firma
gpg --verify CHECKSUMS.sig CHECKSUMS
# gpg: Good signature from "Ubuntu CD Image Automatic Signing Key"

# 4. Verificar la ISO contra los checksums firmados
sha256sum -c CHECKSUMS 2>&1 | grep OK
```

> ⚠️ Si el checksum NO coincide: no uses esa ISO. Puede estar corrupta (descarga incompleta) o comprometida (raro pero posible).

---

## Con `dd` (Linux) — El método nativo

`dd` es la herramienta más directa y está disponible en todo Linux sin instalar nada.

```bash
# 1. Identificar el USB (¡con cuidado!)
lsblk
# Busca el dispositivo con el tamaño de tu USB, ej: /dev/sdb

# 2. Opcional: desmontar particiones montadas automáticamente
sudo umount /dev/sdb1 2>/dev/null

# 3. Escribir la ISO en el USB
sudo dd if=distro.iso of=/dev/sdb bs=4M status=progress oflag=sync conv=fsync

# Parámetros:
#   if=archivo.iso            → entrada (la ISO)
#   of=/dev/sdb               → salida (el USB completo, NO una partición)
#   bs=4M                     → bloques de 4 MB (más rápido que 512 bytes)
#   status=progress           → mostrar progreso durante la escritura
#   oflag=sync                → asegurar que los datos se escriban antes de terminar
#   conv=fsync                → forzar sincronización al final
```

⚠️ **`of=` debe apuntar al disco completo** (`/dev/sdb`), no a una partición (`/dev/sdb1`). Un error aquí puede borrar el disco equivocado para siempre.

### `dd` avanzado: verificar la escritura

```bash
# Después de escribir, verificar que los datos sean correctos
# Calcula el checksum de la ISO original y del USB, deben coincidir
sha256sum distro.iso
sudo dd if=/dev/sdb bs=4M count=$(wc -c < distro.iso) | sha256sum
```

### isohybrid

Las ISOs de Linux modernas suelen ser **híbridas**: el mismo archivo contiene un MBR válido para arranque directo desde USB (con `dd`) Y un volumen ISO9660 estándar para CD/DVD. Esto permite usar la misma ISO en USB y CD sin modificaciones.

```bash
# Verificar si una ISO es híbrida con el comando file:
file distro.iso

# Si la salida incluye "DOS/MBR boot sector" Y "ISO 9660 CD-ROM filesystem data":
#   distro.iso: DOS/MBR boot sector, ... ISO 9660 CD-ROM filesystem data 'Ubuntu ...'
#   → ✅ Híbrida (funciona en USB y CD)

# Si solo muestra "ISO 9660 CD-ROM filesystem data" (sin MBR):
#   distro.iso: ISO 9660 CD-ROM filesystem data '...'
#   → ❌ No híbrida (solo para CD/DVD, puede no bootear en USB)

# También se puede verificar con fdisk directamente sobre la ISO:
fdisk -l distro.iso 2>/dev/null | head -5
# Si muestra una tabla de particiones válida, es híbrida

# Forzar hybrid mode (si la ISO no es híbrida y la necesitas en USB)
# Normalmente no es necesario en ISOs modernas.
# En distros antiguas:
isohybrid distro.iso
```

---

## Con balenaEtcher

```bash
# Descargar la AppImage o Flatpak desde https://etcher.balena.io/
# GUI: Select image → Select target → Flash!

# CLI (headless):
balena-etcher-cli distro.iso
```

**Ventajas:** Simple, multiplataforma, verifica la escritura automáticamente.
**Desventajas:** No soporta persistencia ni multi-ISO.

---

## Con Ventoy (multi-ISO, recomendado)

Ventoy permite tener **múltiples ISOs** en el mismo USB. Se instala una vez y después simplemente copias archivos `.iso` al USB.

```bash
# Instalación
# Opción A: desde terminal
sudo apt install ventoy           # Ubuntu/Debian
sudo pacman -S ventoy             # Arch

# Opción B: descargar el script desde https://github.com/ventoy/Ventoy/releases
# Extraer y ejecutar:
sudo sh Ventoy2Disk.sh -i /dev/sdb   # instalar Ventoy en el USB (borra el disco)
# -i = instalar, -I = forzar instalación si ya tiene Ventoy

# Una vez instalado, el USB se ve como un disco normal
# Solo copia las ISOs:
cp ubuntu-24.04.iso /media/Ventoy/
cp fedora-40.iso /media/Ventoy/
cp archlinux-2026.iso /media/Ventoy/

# Al arrancar desde el USB, Ventoy muestra un menú para elegir qué ISO bootear
```

**Plugins útiles de Ventoy:**

| Plugin | Archivo de configuración | Qué hace |
|---|---|---|
| **Persistencia** | `ventoy/ventoy.json` | Reserva espacio para cambios persistentes (ej. en live USB de Ubuntu) |
| **Secure Boot** | Automático | Ventoy firma sus binarios, funciona con Secure Boot activado |
| **Theme** | `ventoy/theme/` | Cambiar el tema del menú de arranque |
| **Auto-install** | `ventoy/autoinstall/` | Instalación desatendida con preseed/kickstart |

```json
// Ejemplo de ventoy/ventoy.json para persistencia:
{
    "persistence": [
        {
            "image": "ubuntu-24.04.iso",
            "size": 4096
        }
    ]
}
// Reserva 4 GB de persistencia para la ISO de Ubuntu
```

**Ventajas:** No hay que re-grabar el USB por cada ISO, soporta persistencia, soporta Secure Boot.
**Desventajas:** Ocupa algo de espacio en el USB para su propio bootloader (~35 MB).

---

## Con Popsicle (Linux)

Popsicle es la herramienta de **System76** (creadores de Pop!_OS). Permite grabar una ISO en **varios USBs simultáneamente**.

```bash
# Instalación
sudo apt install popsicle           # Pop!_OS / Ubuntu
flatpak install flathub com.system76.Popsicle  # otras distros

# GUI: Seleccionar ISO → Seleccionar uno o más USBs → Flash!

# CLI:
popsicle-cli distro.iso /dev/sdb
popsicle-cli -p distro.iso /dev/sdb /dev/sdc /dev/sdd   # 3 USBs a la vez
```

**Ventajas:** Útil si tienes que preparar varios USBs (talleres, eventos). Verifica automáticamente.
**Desventajas:** Solo Linux, sin persistencia.

---

## Con Fedora Media Writer

Herramienta oficial de Fedora, pero soporta cualquier ISO:

```bash
# Instalación
flatpak install flathub org.fedoraproject.MediaWriter

# GUI: Selecciona ISO local o descarga directa de Fedora,
#       selecciona USB y escribe. Verifica GPG automáticamente
#       si usas una ISO oficial de Fedora.

# CLI:
mediawriter --download Fedora-40   # descarga + graba automáticamente
mediawriter --use-iso distro.iso   # grabar ISO local
```

**Ventajas:** Verificación GPG automática, descarga integrada de ISOs de Fedora.
**Desventajas:** Principalmente orientado a Fedora.

---

## Con mkusb (Linux avanzado)

`mkusb` es una herramienta en terminal (con menú curses) que maneja casos complejos: USBs con persistencia, instalación de Ventoy, USBs dañados, etc.

```bash
# Instalación
sudo add-apt-repository ppa:mkusb/ppa   # Ubuntu/Debian
sudo apt update
sudo apt install mkusb mkusb-nox        # mkusb-nox = versión sin GUI

# Uso
sudo mkusb distro.iso
# Menú interactivo: elegir USB, tipo de instalación (USB live persistente,
# instalación limpia, Ventoy, etc.), sistema de archivos, etc.

# Opciones de mkusb:
# - USB live persistente (casper-rw / writepartition)
# - Instalación de Ventoy en el USB
# - Clonar USB a USB
# - Restaurar USB a su estado normal (formatear)
```

---

## Persistencia en USB live

Un USB live normal pierde todos los cambios al reiniciar. La **persistencia** permite guardar configuraciones, paquetes instalados y archivos entre reinicios.

### Método 1: Ventoy (recomendado)

```json
// ventoy/ventoy.json — persistencia configurada por ISO
{
    "persistence": [
        {
            "image": "ubuntu-24.04.iso",
            "size": 4096
        }
    ]
}
```

### Método 2: Casper-rw (para ISOs basadas en Ubuntu/Debian)

```bash
# Después de grabar la ISO con dd, crear una partición extra para persistencia:
# 1. Particionar el USB
sudo cfdisk /dev/sdb
# Crear una segunda partición con el espacio restante

# 2. Formatear como ext4 con etiqueta "casper-rw"
sudo mkfs.ext4 -L casper-rw /dev/sdb2

# Esta partición se monta automáticamente al arrancar desde el USB
# y guarda los cambios entre sesiones
```

### Método 3: mkusb (guiado)

```bash
sudo mkusb distro.iso           # elegir opción "usb live persistente"
# Te guía: tamaño de persistencia, sistema de archivos (ext4 recomendado)
```

### Método 4: Rufus (Windows)

En Rufus, seleccionar "Persistent partition" y definir el tamaño en GB antes de grabar.

---

## Secure Boot y USB booteable

Secure Boot verifica que el bootloader esté firmado por una clave de confianza antes de ejecutarlo.

| Distro | Secure Boot | Notas |
|---|---|---|
| **Fedora** | ✅ Soporte nativo (shim + GRUB firmado) | Funciona sin desactivar |
| **Ubuntu** | ✅ Soporte nativo (shim) | Funciona sin desactivar |
| **openSUSE** | ✅ Soporte nativo | Funciona sin desactivar |
| **Debian** | ⚠️ Parcial | A veces funciona, otras no (depende del hardware) |
| **Arch Linux** | ❌ Sin soporte oficial | Desactivar Secure Boot |
| **Manjaro** | ⚠️ Parcial | Puede funcionar, pero no garantizado |
| **Ventoy** | ✅ Sí | Ventoy firma sus componentes; funciona con SB activado |

```bash
# Si la distro no bootea y tienes Secure Boot activado:
# Solución A: Desactivar Secure Boot en BIOS/UEFI
#   Boot → Secure Boot → Disable
# Solución B: Usar Ventoy (lo firma por ti)
# Solución C: Firmar manualmente el bootloader con mokutil
sudo mokutil --disable-validation    # desactivar validación de módulos
# (requiere reinicio y seguir el asistente MOK)
```

---

## Troubleshooting: "El USB no bootea"

| Síntoma | Causa probable | Solución |
|---|---|---|
| **Pantalla negra después de seleccionar USB** | ISO mal grabada o incompatibilidad del modo de arranque | Re-grabar con otra herramienta (probar Ventoy). Verificar checksum de la ISO |
| **"No bootable device"** | El USB no tiene un bootloader válido | Re-grabar (probablemente copiaste la ISO como archivo, no la escribiste). Verificar `dd` apunta al disco completo, no a la partición |
| **El menú de boot no muestra el USB** | Puerto USB incorrecto, Fast Boot activado, o Legacy USB desactivado en BIOS | Probar otro puerto (USB 2.0 si hay problemas con 3.0). Desactivar Fast Boot en BIOS. Activar "Legacy USB Support" o "XHCI Hand-off" |
| **Arranca a GRUB rescue** | GRUB está dañado, ISO mal grabada | Re-grabar. Si el problema persiste, probar otra herramienta (Etcher o Ventoy) |
| **Secure Boot bloquea el arranque** | Bootloader sin firma válida | Desactivar Secure Boot o usar distro que lo soporte |
| **El USB se detecta pero no carga el kernel** | La ISO está corrupta o el USB tiene sectores defectuosos | Verificar checksum de la ISO. Probar otro USB. Usar `badblocks` en el USB: `sudo badblocks -w /dev/sdb` (borra todo, solo como último recurso) |
| **La instalación arranca pero se cuelga** | RAM insuficiente o problema de GPU | Probar con `nomodeset` como parámetro de kernel (pulsar `e` en GRUB y añadir al final de la línea de linux) |
| **USB no bootea en modo UEFI** | Partición EFI no encontrada o ISO no soporta UEFI | Probar con Ventoy (gestiona UEFI automáticamente). Verificar que la ISO sea híbrida |
| **USB funciona en una PC pero no en otra** | Diferencias de firmware (BIOS vs UEFI) | Usar una ISO híbrida + Ventoy que funciona en ambos modos |

### Diagnóstico rápido

```bash
# Desde una PC que funciona, verificar el USB:
lsblk /dev/sdb
# Debe mostrar al menos una partición con tamaño cercano al de la ISO

# Verificar que NO sea un disco montado normalmente:
blkid /dev/sdb*
# Deberías ver algo como `PTUUID` o `PTS_TYPE` (partición de arranque),
# no un sistema de archivos normal como `ext4` con UUID.

# Si lsblk muestra la ISO correctamente pero no bootea:
# 1. Probar en otro puerto USB
# 2. Probar en otra PC
# 3. Re-grabar con Ventoy (es más tolerante)
```

---

## Resumen rápido: qué usar según el caso

| Situación | Herramienta recomendada |
|---|---|
| **Una sola ISO, Linux, sin complicaciones** | `dd` (terminal) o balenaEtcher (GUI) |
| **Varias ISOs en un mismo USB** | Ventoy |
| **Persistencia necesaria** | Ventoy (plugin) o mkusb |
| **Windows** | Rufus |
| **Varios USBs a la vez** | Popsicle |
| **Fedora / GNOME** | Fedora Media Writer |
| **Secure Boot activado** | Ventoy o Fedora Media Writer |
| **USB que no bootea y no sabes por qué** | Ventoy (es más tolerante con firmwares) |
| **USB "roto" o con particiones extrañas** | mkusb (opción "restaurar USB a estado normal") |

## Ver también

- [[Proceso de Instalación General]] — qué hacer después de tener el USB listo
- [[Particionado y Esquemas de Disco]] — cómo particionar durante la instalación
- [[Dual Boot con Windows]] — consideraciones adicionales para dual boot
- [[Bootloaders (GRUB Limine systemd-boot)]] — qué se instala en el disco después
- [[Cifrado (LUKS dm-crypt GPG)]] — cifrado durante la instalación

## Enlaces externos

- [Ventoy — Página oficial](https://www.ventoy.net/)
- [balenaEtcher](https://etcher.balena.io/)
- [Popsicle — GitHub](https://github.com/pop-os/popsicle)
- [Fedora Media Writer — GitHub](https://github.com/FedoraQt/MediaWriter)
- [mkusb — Guía](https://help.ubuntu.com/community/mkusb)
- [Rufus](https://rufus.ie/)

#instalacion #usb
