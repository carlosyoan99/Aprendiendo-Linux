---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: instalacion
prioridad: baja
---

# Dual Boot con Windows

## Definición

Tener Windows y Linux instalados en el mismo disco (o discos separados), eligiendo cuál arrancar desde el menú de GRUB/bootloader en cada inicio. El dual boot sigue siendo la forma más común de tener ambos SO en una máquina física, aunque alternativas como WSL2 + VMs están ganando terreno.

---

## Pasos recomendados

1. **Instalar Windows primero.** Su instalador sobrescribe el bootloader sin preguntar; instalar Linux después evita tener que reparar el arranque.
2. En Windows: reducir la partición existente desde el "Administrador de discos" para dejar **espacio libre sin asignar** (no crear una partición desde Windows — deja que el instalador de Linux lo haga).
3. **Desactivar Fast Startup** en Windows (hiberna el disco de forma que Linux no puede montarlo con seguridad si no se apaga limpio).
4. Desactivar **Secure Boot** en BIOS/UEFI si la distro no lo soporta (consultar [[Creacion de USB Booteable#Secure Boot y USB booteable]]).
5. Instalar Linux apuntando al espacio libre — la mayoría de instaladores detectan Windows automáticamente y ofrecen "instalar junto a".
6. GRUB debería detectar ambos sistemas y mostrarlos en el menú de arranque.

```bash
# Verificar desde Linux que se detectó Windows
sudo os-prober                        # busca otros SO instalados
sudo update-grub                      # regenera GRUB incluyendo Windows

# Si os-prober no encuentra Windows, verificar:
lsblk                                 # ¿la partición de Windows está visible?
sudo mount /dev/nvme0n1p1 /mnt       # montar la partición EFI de Windows
ls /mnt/EFI/Microsoft/                # ¿están los archivos de boot de Windows?
```

---

## Particionado para dual boot

El esquema de particiones recomendado en un disco con dual boot:

```
Esquema típico (GPT/UEFI):

┌────────────┬─────────────┬──────────────┬──────────────┐
│  EFI System│  Windows C: │  Linux Root  │  Linux Home  │
│  Partition │  (NTFS)     │  (ext4/btrfs)│  (ext4/btrfs)│
│  (FAT32)   │             │              │              │
│  ~512 MB   │  ~50-80%    │  ~40-80 GB   │  Resto       │
└────────────┴─────────────┴──────────────┴──────────────┘
```

| Aspecto | Recomendación |
|---|---|
| **EFI compartida vs separada** | Pueden compartir la misma partición EFI (Windows + Linux). Ambos escriben en la misma partición FAT32 sin conflicto |
| **Swap** | Usar archivo de swap en lugar de partición (más flexible al redimensionar) |
| **/home separado** | Recomendado: si reinstalas Linux, no pierdes datos de /home |
| **NTFS compartido** | Crear una partición NTFS adicional para datos compartidos entre ambos SO |

```bash
# Crear una partición NTFS para datos compartidos desde Linux:
sudo mkfs.ntfs -f /dev/sda4          # formatear como NTFS
# Montar:
sudo mount -t ntfs3 /dev/sda4 /mnt/datos
# En /etc/fstab:
# UUID=xxxx /mnt/datos ntfs3 defaults,uid=1000,gid=1000 0 0
```

> Ver [[Particionado y Esquemas de Disco]] para más detalles sobre esquemas.

---

## NTFS nativo (Linux)

Históricamente Linux necesitaba `ntfs-3g` (FUSE) para leer/escribir NTFS, que era lento. Desde kernel 5.15, el driver **ntfs3** (desarrollado por Paragon) está incluido en el kernel y es mucho más rápido.

```bash
# Verificar si tu kernel soporta ntfs3
cat /boot/config-$(uname -r) | grep NTFS_FS
# CONFIG_NTFS_FS=m o CONFIG_NTFS3_FS=m → soportado

# Montar una partición NTFS con ntfs3
sudo mount -t ntfs3 /dev/nvme0n1p3 /mnt/windows

# Montar con permisos para tu usuario
sudo mount -t ntfs3 /dev/nvme0n1p3 /mnt/windows -o uid=1000,gid=1000,dmask=022,fmask=133

# En /etc/fstab para montaje automático:
# Usar UUID (recomendado):
sudo blkid /dev/nvme0n1p3              # obtener UUID
# Añadir a /etc/fstab:
# UUID=XXXX  /mnt/windows  ntfs3  uid=1000,gid=1000,dmask=022,fmask=133  0  0

# Probar velocidad comparativa:
# ntfs3 (nativo):
sudo dd if=/dev/nvme0n1p3 of=/dev/null bs=1M count=1000 status=progress
# ntfs-3g (FUSE, legacy):
sudo dd if=/dev/nvme0n1p3 of=/dev/null bs=1M count=1000 iflag=nocache status=progress
```

### ntfs3 vs ntfs-3g

| Característica | ntfs3 (nativo kernel) | ntfs-3g (FUSE) |
|---|---|---|
| **Rendimiento** | ⭐ 2-3× más rápido | Lento (capa FUSE) |
| **Integración** | En el kernel (5.15+) | Paquete aparte |
| **Compresión** | Lectura de archivos comprimidos | Lectura y escritura |
| **Manejo de errores** | Limitado | Robusto, recovery |
| **Instalación** | Ya incluido | `sudo apt install ntfs-3g` |

> ⚠️ Si una partición NTFS no se desmontó limpiamente en Windows (por Fast Startup o hibernación), **ni ntfs3 ni ntfs-3g podrán montarla en modo lectura/escritura**. Solo lectura. Para escribir, hay que arrancar Windows y apagarlo completamente: `shutdown /s /t 0` (no hibernar).

---

## ReFS — Resilient File System (Windows)

**ReFS** (Resilient File System) es el sistema de archivos moderno de Microsoft, introducido en **Windows Server 2012** con nombre en clave "Protogon". Está diseñado como sucesor de NTFS para cargas de trabajo que requieren máxima integridad de datos. No es un FS que se use en Linux, pero es relevante conocerlo al hacer dual boot con Windows moderno.

### Características clave

| Característica | ReFS | NTFS |
|---|---|---|
| **Copy-on-Write** | ✅ Sí (en metadatos) | ❌ No |
| **Checksums** | ✅ 64-bit en metadatos (opcional en datos) | ❌ No |
| **Auto-reparación** | ✅ Detecta y corrige corrupción (con espacios reflejados) | ❌ No |
| **Tamaño máx. archivo** | 16 EiB | 16 EiB |
| **Tamaño máx. volumen** | 1 YiB | 256 TB |
| **Estructura** | Árboles B+ (todo es tabla) | MFT (Master File Table) |
| **CHKDSK** | ❌ No necesario | ✅ Sí |
| **Disponible en** | Windows Server / Pro for Workstations | Todas las ediciones de Windows |
| **Compresión** | ❌ No | ✅ Sí |
| **Enlaces duros** | ❌ No | ✅ Sí |
| **Arranque desde ReFS** | ❌ No en Windows 11 estándar | ✅ Sí |

### ¿Afecta al dual boot?

En la práctica, **ReFS no afecta al dual boot** porque:

1. **Windows no arranca desde ReFS** — la partición del sistema (C:\) sigue siendo NTFS en la mayoría de las ediciones de Windows
2. ReFS se usa sobre todo en **volúmenes de datos** (discos de almacenamiento, Spaces Direct)
3. Linux **no puede leer ReFS nativamente** — no hay driver en el kernel. Si tienes un volumen ReFS, no podrás acceder a él desde Linux
4. Para datos compartidos entre SO, sigue siendo mejor usar **NTFS** (con ntfs3) o **exFAT**

```bash
# Verificar si un volumen es ReFS (desde Windows):
fsutil fsinfo volumeinfo C:\
# Si dice "File System Name : ReFS" → es ReFS (inusual para C:\)

# Desde Linux, no hay driver para ReFS. No se puede montar.
```

> ⚠️ Si tu Windows tiene discos con formato ReFS (discos de almacenamiento, no el sistema), esos volúmenes **no serán accesibles desde Linux**. Para compatibilidad dual boot, usa NTFS o exFAT para las particiones compartidas.

---

## BitLocker

Si tu Windows tiene BitLocker activado (común en portátiles empresariales y en Windows 11 Pro/Enterprise), Linux no podrá leer la partición de Windows sin desbloquearla primero.

### Opciones

| Opción | Descripción | Impacto |
|---|---|---|
| **Desactivar BitLocker** | Desde Windows: Panel de control → BitLocker → "Desactivar BitLocker" | ✅ Linux accede a NTFS sin problemas ⚠️ Datos sin cifrar |
| **Guardar la clave de recuperación** | Desde Windows: `manage-bde -protectors -get C:` → guardar la clave de 48 dígitos | ✅ Puedes desbloquear la partición desde Linux si es necesario |
| **Disco aparte para Linux** | Instalar Linux en un disco físico separado | ❌ BitLocker sigue protegiendo Windows, pero no afecta a Linux |
| **Desbloquear desde Linux** | Usar `dislocker` para montar particiones BitLocker | ⚠️ Lento, complicado, no recomendado para uso diario |

```bash
# Desbloquear partición BitLocker desde Linux (con dislocker):
sudo apt install dislocker               # Debian/Ubuntu
sudo pacman -S dislocker                 # Arch

# Montar una partición BitLocker (necesitas la clave de recuperación):
sudo mkdir /media/bitlocker /media/montar
sudo dislocker -r -V /dev/nvme0n1p3 -p123456-789012-... /media/bitlocker
sudo mount -o loop /media/bitlocker/dislocker-file /media/montar
```

Mantener BitLocker activado + dual boot es complejo. La solución más práctica: **desactivar BitLocker antes de instalar Linux, o tener Linux en un disco separado**.

---

## Reparación del boot

Cuando Windows se actualiza o reinstala, suele sobrescribir el bootloader EFI, haciendo que Linux desaparezca del menú de arranque.

### Si arranca directo a Windows (GRUB no aparece)

#### Desde Linux (si puedes arrancar con USB live)

```bash
# Arrancar desde un live USB de cualquier distro
# Identificar particiones
lsblk
# Ej: /dev/nvme0n1p1 = EFI, /dev/nvme0n1p2 = Linux root

# Montar sistema
sudo mount /dev/nvme0n1p2 /mnt
sudo mount /dev/nvme0n1p1 /mnt/boot/efi

# Chroot y reinstalar GRUB
sudo arch-chroot /mnt                    # o: sudo chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
exit
sudo reboot
```

#### Reparar con boot-repair (Ubuntu/Debian)

```bash
# Desde live USB de Ubuntu
sudo add-apt-repository ppa:yannubuntu/boot-repair
sudo apt update
sudo apt install boot-repair
boot-repair                               # GUI: botón "Recommended repair"
```

> Más detalles en [[GRUB no arranca]].

### Si no puedes arrancar Linux en absoluto

#### Reparar desde el propio Windows (con bootrec y bcdedit)

Cuando el boot de Windows está dañado pero Linux intacto, o viceversa:

```bash
# Desde Windows Recovery Environment (WinRE):
# 1. Arrancar desde USB de instalación de Windows
# 2. Elegir "Reparar el equipo" → "Solucionar problemas" → "Símbolo del sistema"

# ── bootrec ──
bootrec /fixmbr                          # reparar MBR (BIOS)
bootrec /fixboot                         # reparar sector de boot
bootrec /scanos                          # escanear instalaciones de Windows
bootrec /rebuildbcd                      # reconstruir BCD (Boot Configuration Data)

# ── bcdedit (gestión de entradas de arranque) ──
bcdedit /enum firmware                   # listar todas las entradas UEFI
bcdedit /enum active                      # entradas activas del boot manager
bcdedit /set {bootmgr} path \\EFI\\grub\\grubx64.efi  # apuntar GRUB
bcdedit /delete {identificador}           # eliminar una entrada específica
bcdedit /timeout 10                       # tiempo de espera en el menú (segundos)

# ── bootsect (cuando /fixboot falla) ──
# bootrec /fixboot repara el boot sector de la partición del sistema.
# Si da "Acceso denegado", bootsect es más agresivo:
bootsect /nt60 SYS                        # reparar boot sector (modo forzado)
bootsect /nt60 ALL                        # reparar todos los volúmenes
```

#### Arreglar orden de arranque en UEFI

```bash
# Desde Linux (si arranca):
sudo efibootmgr -v                       # listar entradas de arranque
# Busca "Windows Boot Manager" y "GRUB" o "Linux"
# Mover GRUB al primer lugar:
sudo efibootmgr -o 0000,0001             # poner Linux (0000), luego Windows (0001)

# Desde BIOS/UEFI:
# Entrar al menú de boot (F2/F12/Del) y mover "GRUB" o "Linux" al primer lugar
```

---

## Reloj desincronizado entre SO

Windows usa la **hora local** del hardware (RTC) directamente, mientras que Linux por defecto asume que el RTC está en **UTC** y convierte a hora local. Esto causa que al cambiar de SO la hora se desfase.

### Solución A: Windows usa UTC (recomendada)

```bash
# Desde Windows (como Administrador), abrir PowerShell o CMD:
Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1

# Luego sincronizar hora manualmente desde Windows:
# Configuración → Hora e idioma → Sincronizar ahora
# O desde CMD:
w32tm /resync

# Verificar desde Linux que se aplicó correctamente:
hwclock --show                           # mostrar hora actual del RTC
hwclock --verbose                        # información detallada (RTC vs sistema)
# Debería mostrar hora UTC si el cambio funcionó
```

**Verificar desde Linux:**

```bash
# El RTC debe estar en UTC:
timedatectl
# RTC time: jue 2026-07-19 17:30:00   ← debe ser la hora UTC, no la local

# Si no coincide, forzar desde Linux:
sudo hwclock --systohc --utc             # guardar hora del sistema al RTC en UTC

# Si necesitas leer el RTC y aplicarlo al sistema:
sudo hwclock --hctosys                   # RTC → sistema (útil en rescate)
```

### Solución B: Linux usa hora local (alternativa)

```bash
# Desde Linux, decirle que el RTC está en hora local:
timedatectl set-local-rtc 1

# Aplicar el cambio inmediatamente:
sudo hwclock --systohc --localtime       # guardar hora local al RTC

# Verificar:
timedatectl
hwclock --show                           # debe mostrar hora local exacta

# Revertir si hay problemas:
timedatectl set-local-rtc 0
sudo hwclock --systohc --utc             # volver a UTC
```

### Comparativa

| Aspecto | Solución A (Windows UTC) | Solución B (Linux local) |
|---|---|---|
| **Windows** | Requiere registro (una vez) | Sin cambios |
| **Linux** | Sin cambios | `timedatectl set-local-rtc 1` |
| **Problemas** | Windows antiguos (≤7) no soportan UTC | `timedatectl` muestra advertencia |
| **Estándar** | ✅ Correcto técnicamente | ⚠️ Puede causar issues con apps que dependen de UTC |

```bash
# Verificar el estado actual del reloj desde Linux
timedatectl
#               Local time: jue 2026-07-19 14:30:00 ART
#           Universal time: jue 2026-07-19 17:30:00 UTC
#                 RTC time: jue 2026-07-19 17:30:00   ← RTC está en UTC
#                Time zone: America/Argentina/Buenos_Aires (-03)
# System clock synchronized: yes
#              NTP service: active
#          RTC in local TZ: no                        ← no está en hora local

# Si RTC está en UTC y el SO cambiante muestra hora incorrecta → aplicar Solución A
```

---

## Problemas comunes (tabla completa)

| Problema | Causa | Solución |
|---|---|---|
| **GRUB no aparece, arranca directo a Windows** | Windows Update sobrescribió el bootloader EFI | Reparar GRUB desde live USB o con `boot-repair` |
| **Arranca a GRUB rescue** | GRUB no encuentra la partición root | Corregir con `configfile` o reinstalar GRUB (ver [[GRUB no arranca]]) |
| **Hora incorrecta al cambiar de SO** | Windows usa hora local, Linux UTC | Aplicar Solución A (recomendada) o Solución B |
| **No puedo escribir en la partición de Windows** | Fast Startup deja NTFS en estado hibernado | Arrancar Windows y apagar completamente: `shutdown /s /t 0` |
| **BitLocker pide clave al arrancar Linux** | Partición de Windows está cifrada | Desactivar BitLocker desde Windows, o usar discos separados |
| **La partición EFI se quedó sin espacio** | Demasiados bootloaders instalados (cada actualización de kernel añade archivos) | Limpiar entradas de arranque viejas desde Windows con `bcdedit` o desde Linux: `sudo rm /boot/efi/EFI/ubuntu/*.bak` |
| **WiFi no funciona en Linux** pero sí en Windows | El adaptador quedó en un estado bloqueado tras el reinicio desde Windows | Apagar completamente Windows (`shutdown /s /t 0`), no \"reiniciar\" |
| **Linux no monta NTFS** (read-only) | Partición no desmontada limpiamente por Windows | `sudo ntfsfix /dev/nvme0n1p3` (repara el journal, seguro para datos) |
| **No aparece Windows en GRUB** | `os-prober` no lo detectó | `sudo os-prober && sudo update-grub`. Si no funciona, verificar que la partición EFI está montada |
| **Pantalla azul en Windows tras instalar Linux** | GRUB cambió un parámetro de arranque UEFI | Desde BIOS: restaurar orden de arranque por defecto, o `efibootmgr` desde Linux |
| **No puedo reducir la partición de Windows** | Archivos inmóviles al final de la partición | Desfragmentar Windows antes, o usar software de terceros (MiniTool, AOMEI) |
| **El teclado/touchpad no funcionan en Linux** | El hardware quedó en un estado de energía propio de Windows | Forzar apagado completo desde Windows y arrancar Linux desde frío |

---

## Buenas prácticas y recomendaciones

```bash
# 1. Usar discos físicos separados si es posible
#    Simplifica: cada SO en su disco, eliges desde BIOS cuál arrancar

# 2. Si usas un solo disco:
#    - Windows primero, Linux después
#    - /home separado (reinstalar Linux no pierde datos)
#    - Archivo de swap en vez de partición (más fácil de redimensionar)

# 3. En Windows (obligatorio):
#    - Desactivar Fast Startup
#    - Si vas a usar UTC: ejecutar el regedit una vez

# 4. En Linux:
#    - Actualizar GRUB después de cada actualización grande de Windows
#    - No tocar la partición EFI de Windows manualmente

# 5. Para acceder a datos compartidos:
#    - Crear una partición NTFS adicional para datos (no usar C:\ de Windows)
#    - Montar con ntfs3 (más rápido que ntfs-3g)
```

## Enlaces externos

- [Wikipedia — Dual boot](https://en.wikipedia.org/wiki/Multi-booting)
- [Arch Wiki — Dual boot with Windows](https://wiki.archlinux.org/title/Dual_boot_with_Windows)
- [ntfs3 — Paragon driver (kernel)](https://github.com/Paragon-Software-Group/ntfs3)

## Ver también

- [[Proceso de Instalación General]] — paso a paso de instalación de Linux
- [[Particionado y Esquemas de Disco]] — esquemas de particionado detallados
- [[Creación de USB Booteable]] — cómo preparar el medio de instalación
- [[GRUB no arranca]] — troubleshooting de GRUB
- [[Gestores de Paquetes]] — instalar herramientas de reparación
- [[Cifrado (LUKS dm-crypt GPG)]] — cifrado en Linux vs BitLocker

#instalacion #dual-boot
