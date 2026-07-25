---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: instalacion
prioridad: alta
---

# Proceso de Instalación General (paso a paso)

Flujo típico, aplicable con variaciones a casi cualquier distro moderna con instalador gráfico (Calamares, Ubiquity, Anaconda).

---

## 1. Preparación

```
☐ Elegir distro y verificar requisitos de hardware
☐ Hacer backup de datos importantes si hay datos existentes
☐ Comprobar espacio libre en disco (mínimo ~20 GB, recomendado 50+ GB)
☐ Crear USB booteable (ver [[Creacion de USB Booteable]])
```

### Requisitos comunes por tipo de distro

| Tipo de distro | RAM mínima | Disco mínimo | Ejemplos |
|---|---|---|---|
| **Escritorio moderno** (GNOME/KDE) | 4 GB (8 GB recomendado) | 25 GB | Ubuntu, Fedora, openSUSE, Arch + DE |
| **Escritorio ligero** (XFCE/LXQt) | 2 GB | 20 GB | Linux Mint XFCE, Xubuntu, Lubuntu |
| **Minimal/ventana** (WM) | 1 GB | 10 GB | Arch + i3, Debian + bspwm |
| **Servidor** (sin GUI) | 512 MB | 5 GB | Ubuntu Server, Debian, Rocky |

---

## 2. Arranque desde USB

- Entrar al menú de boot según fabricante: `F12` (Dell/Lenovo), `F2` (HP), `Esc` (ASUS), `Del` (placas ASUS/MSI), `F9` (HP), `F10` (acer). O cambiar el orden de arranque en BIOS/UEFI permanentemente.
- **Secure Boot**: puede ser necesario desactivarlo en BIOS/UEFI. Algunas distros lo soportan:
  - ✅ **Soporte nativo**: Ubuntu (shim), Fedora (shim), openSUSE
  - ⚠️ **Puede fallar**: Debian (depende del hardware), Arch (manual)
  - ❌ **Requiere desactivar**: la mayoría de rolling releases, distros sin shim
- **Fast Boot**: desactivarlo en BIOS puede ayudar a que el USB sea detectado correctamente.

```bash
# Verificar modo de arranque (una vez en el live USB)
ls /sys/firmware/efi      # si existe → UEFI; si no → BIOS legacy
```

---

## 3. Modo Live (opcional pero recomendado)

La mayoría de ISOs arrancan primero en modo "live" (probar sin instalar). Es útil para:

```
☐ Verificar que WiFi funciona (driver de red cargado)
☐ Verificar que la GPU se detecta (lspci, glxinfo)
☐ Verificar que el sonido se escucha
☐ Confirmar que el teclado y touchpad funcionan
☐ Probar la distro antes de instalarla
```

```bash
# Comandos útiles desde el live USB (sin nada instalado)
lspci -k | grep -E "VGA|Network"     # GPU y tarjeta de red
lsblk                                 # discos detectados
free -h                               # RAM total disponible
```

---

## 4. Particionado y sistema de archivos

> **Nota:** Esta sección cubre las decisiones que tomarás durante la instalación. Para detalles profundos sobre herramientas de particionado y esquemas de disco, ver [[Particionado y Esquemas de Disco]].

### Elegir el sistema de archivos

| FS | Ideal para | Por qué elegirlo | Por qué NO elegirlo |
|---|---|---|---|
| **ext4** | ✅ Escritorio general, principiantes | Máxima compatibilidad, probado durante décadas, fácil de reparar | No tiene snapshots, compresión ni checksums |
| **Btrfs** | ✅ Escritorio moderno, Fedora/openSUSE | Snapshots (timeshift), compresión zstd, checksums, auto-reparación | Mayor complejidad, RAID5/6 experimental |
| **XFS** | ✅ Servidores, archivos grandes (>10 GB) | Rendimiento superior para archivos grandes y E/S paralela | ❌ **No se puede reducir**, no recomendado para escritorio general |
| **ZFS** | ✅ NAS, servidores de almacenamiento | Checksums, RAID-Z, compresión, gestión de volúmenes integrada | No está en kernel mainline, consume RAM, no ideal para laptops |

```
Regla práctica:
  - ¿Primera instalación? → ext4
  - ¿Quieres snapshots y rollbacks? → Btrfs
  - ¿Servidor de archivos? → XFS
  - ¿NAS con varios discos? → ZFS
```

> Para profundizar: [[Sistemas de Archivos]] — comparativa detallada de cada FS con comandos y mantenimiento.

### Swap: archivo, partición o zram

Durante la instalación se te preguntará cómo configurar la memoria swap. Las opciones hoy en día:

| Opción | Cuándo usarla | Tamaño recomendado |
|---|---|---|
| **Archivo de swap** | ✅ Opción moderna y flexible | 2-4 GB si no hibernas; = RAM si hibernas |
| **Partición swap** | ❌ Legado — solo si el instalador lo fuerza | Antigua regla: RAM × 1.5 si RAM < 8 GB, sino = RAM |
| **zram** (swap comprimido en RAM) | ✅ Excelente en sistemas con ≥ 4 GB RAM | Automático (comprime en RAM, no usa disco) |
| **zswap** | Alternativa a zram (caché comprimida + swap real) | Similar a zram, pero + swap de respaldo en disco |
| **Sin swap** | Solo si tienes ≥ 16 GB RAM y no hibernas | — |

```bash
# Crear archivo de swap (post-instalación)
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Activar zram (post-instalación)
sudo apt install zram-tools          # Debian/Ubuntu
sudo pacman -S zram-generator        # Arch (o systemd-zram-generator)
```

> Ver [[zram]] para más detalles sobre swap comprimido en RAM.

### Cifrado con LUKS

Muchos instaladores ofrecen cifrar el disco durante la instalación:

| Opción | Qué protege | Rendimiento |
|---|---|---|
| **Cifrar todo el disco** | Root, home, swap — todo | Mínimo impacto (AES-NI) |
| **Cifrar solo /home** | Solo datos personales | Sin impacto en el sistema |
| **Sin cifrar** | Nada | Máximo rendimiento |

```
¿Cifrar o no?
  - Portátil → SÍ, cifra siempre (robo = datos protegidos)
  - Servidor → Depende: necesario si hay datos sensibles
  - Escritorio fijo en casa → Opcional, pero recomendado
  - Si cifras root → el sistema pedirá contraseña al arrancar
```

Durante la instalación, el instalador (según distro):

- **Ubuntu**: ofrece "Cifrar la nueva instalación de Ubuntu por seguridad" (LUKS + LVM automático)
- **Fedora**: ofrece cifrado automático con LUKS durante el particionado
- **Debian**: opción en el particionado guiado "cifrado LVM"
- **Arch (archinstall)**: opción `--disk-encryption` con LUKS
- **Calamares** (muchas distros): checkbox "Cifrar sistema" en la pantalla de particionado

> Para profundizar en LUKS (gestión de frases, slots, backup de cabecera, rendimiento): [[Cifrado (LUKS dm-crypt GPG)]]

### Esquemas de particionado típicos

| Esquema | Descripción | Ideal para |
|---|---|---|
| **Todo en una** (`/` todo el disco) | Una sola partición root + EFI | Principiantes, discos pequeños (< 128 GB) |
| **Root + /home separado** | Root (~40-80 GB) + Home (resto) | Reinstalaciones sin perder datos |
| **Root + /home + /var separado** | Root + Home + Var (logs) | Servidores (evita que logs llenen root) |
| **Root + /home + swap (partición)** | Todo separado | Control granular, hibernación |
| **Dual boot** | Windows + Linux lado a lado | Necesitas ambos SO |
| **LVM** | Volúmenes lógicos flexibles | Servidores, discos múltiples, redimensiones en caliente |

```bash
# Esquema recomendado para escritorio (con /home separado):
# /dev/sda1 → EFI     (FAT32, 512 MB)
# /dev/sda2 → /       (ext4 o btrfs, 40-80 GB)
# /dev/sda3 → /home   (ext4 o btrfs, resto del disco)
# swap → archivo de swap (no partición)

# Esquema para servidor:
# /dev/sda1 → EFI     (FAT32, 512 MB)
# /dev/sda2 → /       (ext4 o xfs, 20-40 GB)
# /dev/sda3 → /var    (xfs o ext4, 10-20 GB)
# /dev/sda4 → /home   (xfs, resto)
# swap → archivo de swap
```

> Para más esquemas detallados (incluyendo dual boot y LVM): [[Particionado y Esquemas de Disco]]

---

## 5. Configuración durante la instalación

- **Usuario y contraseña**: el primer usuario suele tener acceso `sudo`. No uses la misma contraseña para el usuario y el cifrado de disco.
- **Hostname**: nombre que identificará al equipo en la red. Ej: `carlos-laptop`, `server-casa`.
- **Zona horaria**: seleccionar ciudad/continente.
- **Layout de teclado**: `es` (español), `latam` (latinoamericano), `us` (inglés) según corresponda.
- **Red**: elegir WiFi/Ethernet durante la instalación (en algunas distros, los paquetes adicionales se descargan durante el proceso).
- **DE/WM**: si la distro lo permite (CachyOS, EndeavourOS, Manjaro), elegir el entorno gráfico.

### Kernel alternativo

Algunos instaladores (especialmente en distros rolling como Arch, CachyOS, Manjaro) permiten elegir entre distintos kernels durante la instalación:

| Kernel | Para qué | Cuándo usarlo |
|---|---|---|
| **linux** (kernel estable) | Uso diario general | **Opción por defecto** — casi siempre la correcta |
| **linux-lts** (Long Term Support) | Estabilidad máxima, hardware antiguo | Servidores, producción, hardware que falla con kernels nuevos |
| **linux-zen** (kernel optimizado) | Rendimiento interactivo | Gaming, escritorio, latency baja |
| **linux-hardened** (kernel seguridad) | Seguridad extra | Pentesting, hardening, servidores expuestos |
| **linux-rt** (Real-Time) | Tiempo real | Audio profesional, sistemas embebidos, robótica |

```bash
# Ejemplo: instalar kernels adicionales post-instalación (Arch)
sudo pacman -S linux-lts linux-lts-headers
sudo grub-mkconfig -o /boot/grub/grub.cfg   # regenerar GRUB
# En el arranque, GRUB mostrará ambos kernels para elegir

# Debian/Ubuntu (kernels genérico vs lowlatency)
sudo apt install linux-image-lowlatency    # para audio profesional
sudo apt install linux-image-6.8.0-XX-generic  # kernel específico
```

Si quieres mantener **múltiples kernels** en el arranque:

```bash
# Arch: los kernels se instalan en paralelo, GRUB los lista automáticamente
pacman -Q | grep linux                    # listar kernels instalados

# Debian/Ubuntu: kernel por defecto se actualiza con apt
# Para mantener un kernel específico:
sudo apt-mark hold linux-image-6.8.0-XX-generic  # evitar que se actualice
```

---

## 6. Instalación del bootloader

| Bootloader | Ideal para | Notas |
|---|---|---|
| **GRUB** | Estándar universal | Soporta BIOS y UEFI, temas, arranque cifrado (LUKS2), detecta otros SO automáticamente |
| **systemd-boot** | UEFI simple | Más rápido y simple que GRUB, pero solo UEFI, detección manual de kernels |
| **Limine** | Alternativa moderna | Soporta BIOS + UEFI, arranque desde LUKS2, configuración simple |
| **efistub** | Directo desde UEFI | Sin bootloader intermedio — el kernel se arranca directo desde la UEFI |

```bash
# La partición EFI va en:
# /boot/efi (Ubuntu/Debian/Fedora)
# /boot     (Arch, algunas distros)
```

> Detalles completos en [[Bootloaders (GRUB Limine systemd-boot)]].

---

## 7. Post-instalación

Una vez completada la instalación:

```
☐ Primer arranque: iniciar sesión, conectar a internet
☐ Ejecutar actualización completa del sistema
☐ Verificar que los drivers de GPU funcionan (nvidia-smi, glxinfo)
☐ Instalar paquetes esenciales (navegador, editor, codecs)
☐ Configurar backups (ver [[Backups (borg restic duplicity rsync)]])
```

Ver la guía completa en [[Post-Instalacion Checklist]].

---

## Resumen de decisiones clave durante la instalación

| Decisión | Opción por defecto | Alternativa recomendada |
|---|---|---|
| **Sistema de archivos** | ext4 | Btrfs (si quieres snapshots) |
| **Swap** | Partición swap | Archivo de swap (o zram) |
| **Cifrado** | Sin cifrar | Cifrar todo el disco (portátiles) |
| **Particionado** | Todo en una raíz | Root + /home separados |
| **Kernel** | linux (estable) | linux-zen (gaming), linux-lts (servidor) |
| **Bootloader** | GRUB | systemd-boot (UEFI), Limine |

## Ver también

- [[Particionado y Esquemas de Disco]] — herramientas y esquemas detallados
- [[Sistemas de Archivos]] — ext4, Btrfs, XFS, ZFS a fondo
- [[Cifrado (LUKS dm-crypt GPG)]] — LUKS, GPG, buenas prácticas
- [[Dual Boot con Windows]] — instalación junto a Windows
- [[Creacion de USB Booteable]] — cómo preparar el medio de instalación
- [[Post-Instalacion Checklist]] — qué hacer después de instalar
- [[Bootloaders (GRUB Limine systemd-boot)]] — gestores de arranque
- [[zram]] — swap comprimido en RAM

## Enlaces externos

- [Wikipedia — Proceso de instalación de Linux](https://en.wikipedia.org/wiki/Linux_installation)
- [Arch Wiki — Installation guide](https://wiki.archlinux.org/title/Installation_guide)
- [Debian Installation Manual](https://www.debian.org/releases/stable/installmanual)

#instalacion
