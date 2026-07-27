---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: alta
---

# RAID por software (mdadm)

## Definición

RAID (Redundant Array of Independent Disks) combina varios discos físicos en un solo volumen lógico para conseguir redundancia (tolerancia a fallos), rendimiento, o ambos. **mdadm** es la herramienta estándar en Linux para gestionar RAID por software a nivel del kernel (md — multiple device).

```
Niveles de RAID más comunes:

RAID 0  (striping)        RAID 1  (mirror)          RAID 5  (striping + paridad)
┌───┬───┐                ┌───┬───┐                ┌───┬───┬───┐
│ A │ B │                │ A │ A │                │ A │ B │ P │
│ C │ D │                │ B │ B │                │ C │ D │ P │
│ E │ F │                │ C │ C │                │ E │ F │ P │
├───┼───┤                ├───┼───┤                ├───┼───┼───┤
│sda│sdb│                │sda│sdb│                │sda│sdb│sdc│
└───┴───┘                └───┴───┘                └───┴───┴───┘
Capacidad: N×disco      Capacidad: 1×disco        Capacidad: (N-1)×disco
Sin redundancia          Redundancia: 1 fallo      Redundancia: 1 fallo

RAID 6  (doble paridad)     RAID 10  (striping + mirror)
┌───┬───┬───┬───┐           ┌───────┬───────┐
│ A │ B │ P │ Q │           │ A  A' │ B  B' │
│ C │ D │ P │ Q │           │ C  C' │ D  D' │
│ E │ F │ P │ Q │           ├───┬───┼───┬───┤
├───┼───┼───┼───┤           │sda│sdb│sdc│sdd│
│sda│sdb│sdc│sdd│           └───┴───┴───┴───┘
└───┴───┴───┴───┘           Capacidad: N/2×disco
Capacidad: (N-2)×disco      Redundancia: 1 fallo por espejo
Redundancia: 2 fallos
```

---

## Niveles de RAID

| Nivel | Nombre | Mín. discos | Capacidad utilizable | Tolerancia a fallos | Rendimiento | Ideal para |
|---|---|---|---|---|---|---|
| **0** | Striping | 2 | N × disco | ❌ Ninguno | ⭐⭐⭐⭐⭐ Lectura/Escritura | Datos temporales, caché (sin datos importantes) |
| **1** | Mirror | 2 | 1 × disco | ✅ 1 disco | ⭐⭐⭐ Lectura, ⭐⭐ Escritura | Sistema operativo, datos críticos |
| **5** | Paridad simple | 3 | (N-1) × disco | ✅ 1 disco | ⭐⭐⭐⭐ Lectura, ⭐⭐⭐ Escritura | Servidores de archivos, NAS |
| **6** | Doble paridad | 4 | (N-2) × disco | ✅ 2 discos | ⭐⭐⭐ Lectura, ⭐⭐ Escritura | Datos muy críticos, discos grandes (>2TB) |
| **10** | Stripping + Mirror | 4 | N/2 × disco | ✅ 1 por espejo | ⭐⭐⭐⭐⭐ | Bases de datos, servidores de alto rendimiento |

---

## Instalación

```bash
# mdadm suele venir instalado en la mayoría de distros. Si no:
sudo apt install mdadm                    # Debian/Ubuntu
sudo pacman -S mdadm                      # Arch
sudo dnf install mdadm                    # Fedora

# Verificar que el módulo md está cargado
lsmod | grep md
cat /proc/mdstat                          # estado de todos los arrays RAID

# mdadm --help o man mdadm para explorar
mdadm --help
```

---

## Crear un array RAID

### RAID 1 (mirror) — ejemplo con 2 discos

```bash
# 1. Identificar los discos (⚠️ ¡los datos se borran!)
lsblk                                      # ej: sdb y sdc, discos completos
sudo fdisk -l /dev/sdb /dev/sdc

# 2. Crear el array RAID 1
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc

# 3. Ver progreso de sincronización
cat /proc/mdstat                           # muestra [UU] cuando termine
watch -n 1 cat /proc/mdstat               # ver en tiempo real

# 4. Formatear y montar
sudo mkfs.ext4 /dev/md0
sudo mkdir /mnt/raid1
sudo mount /dev/md0 /mnt/raid1
```

### RAID 5 — ejemplo con 3 discos

```bash
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb /dev/sdc /dev/sdd
# O con un disco de repuesto (spare):
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 --spare-devices=1 \
  /dev/sdb /dev/sdc /dev/sdd /dev/sde
```

### RAID 10 — ejemplo con 4 discos

```bash
sudo mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/sdb /dev/sdc /dev/sdd /dev/sde
```

### Flags importantes de --create

| Flag | Significado | Ejemplo |
|---|---|---|
| `--level` | Nivel de RAID | `--level=5` |
| `--raid-devices` | Nº de discos activos | `--raid-devices=3` |
| `--spare-devices` | Nº de discos de repuesto | `--spare-devices=1` |
| `--chunk` | Tamaño de chunk en KB (striping) | `--chunk=64` (default) |
| `--metadata` | Versión de metadatos | `--metadata=1.2` (default moderno) |

---

## Expandir un array (--grow)

```bash
# Añadir un disco a RAID 5 (ej: pasar de 3 a 4 discos)
sudo mdadm --manage /dev/md0 --add /dev/sde              # añadir disco
sudo mdadm --grow /dev/md0 --raid-devices=4              # expandir array
# ⏳ La expansión ocurre en segundo plano (ver cat /proc/mdstat)
# Al terminar, redimensionar el sistema de archivos
sudo resize2fs /dev/md0                                  # ext4
# o sudo xfs_growfs /mnt/raid                            # XFS

# Nota: --grow también puede cambiar el nivel RAID (ej: RAID 1 → RAID 5)
# pero requiere añadir discos y tener paciencia (el proceso es lento en discos grandes)
```

---

## Gestión y monitorización

### Comandos básicos

```bash
# Ver estado del array
cat /proc/mdstat                           # resumen rápido
sudo mdadm --detail /dev/md0              # detalle completo (nivel, discos, estado)
sudo mdadm --detail --scan                # resumen de todos los arrays

# Ver información de un disco dentro del array
sudo mdadm --examine /dev/sdb             # metadatos RAID en el disco
sudo mdadm --examine --scan               # escanear todos los discos buscando arrays

# Detener y reiniciar un array
sudo mdadm --stop /dev/md0
sudo mdadm --assemble --scan              # reensamblar todos los arrays detectados
```

### Simular un fallo y recuperación

```bash
# 1. Simular fallo de un disco
sudo mdadm --manage /dev/md0 --fail /dev/sdb
cat /proc/mdstat                           # debería mostrar [U_] (un disco caído)

# 2. Retirar el disco fallado
sudo mdadm --manage /dev/md0 --remove /dev/sdb

# 3. Añadir un disco nuevo (si había spare, se activa automáticamente)
sudo mdadm --manage /dev/md0 --add /dev/sdd
cat /proc/mdstat                           # resincronizando...

# 4. Cuando termine: [UU]
```

### Discos de repuesto (spare)

```bash
# Al crear:
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 --spare-devices=1 \
  /dev/sdb /dev/sdc /dev/sdd /dev/sde

# Añadir un spare después:
sudo mdadm --manage /dev/md0 --add /dev/sde

# Ver spares disponibles:
sudo mdadm --detail /dev/md0 | grep Spare
```

---

## Persistencia (mdadm.conf)

Sin configuración persistente, el array se reensambla automáticamente si los discos están presentes (mdadm detecta los metadatos en los discos al arrancar). Para una configuración explícita:

```bash
# Escanear y guardar la configuración
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf

# Actualizar initramfs (para que el RAID esté disponible en el arranque temprano)
sudo update-initramfs -u                  # Debian/Ubuntu
sudo mkinitcpio -P                        # Arch
sudo dracut --force                       # Fedora

# Verificar que el array se monta al inicio (añadir a /etc/fstab)
echo '/dev/md0 /mnt/raid1 ext4 defaults 0 0' | sudo tee -a /etc/fstab
```

---

## Monitorización y alertas

```bash
# mdadm puede enviar correos cuando un disco falla:
# /etc/mdadm/mdadm.conf
MAILADDR tu@email.com

# Verificar estado de manera programada
sudo mdadm --monitor --scan --test        # probar alerta

# Script de monitorización manual
# ~/scripts/check-raid.sh
#!/bin/bash
if ! mdadm --detail /dev/md0 | grep -q "State : clean"; then
    echo "⚠️  RAID problem on $(hostname)" | mail -s "RAID Alert" tu@email.com
fi
```

```bash
# Ver discos defectuosos desde mdadm
sudo mdadm --detail /dev/md0 | grep -i "faulty|failed"

# También desde smartctl (si está instalado)
sudo smartctl -H /dev/sdb                 # salud del disco
```

---

## RAID en caliente (hot-plug)

Puedes añadir y retirar discos sin apagar el sistema:

```bash
# Añadir disco nuevo al array en caliente
sudo mdadm --manage /dev/md0 --add /dev/sde

# Retirar un disco (marcar como fallido primero)
sudo mdadm --manage /dev/md0 --fail /dev/sdb
sudo mdadm --manage /dev/md0 --remove /dev/sdb
```

---

## RAID + LUKS + LVM (la combinación completa)

Para máxima flexibilidad y seguridad:

```bash
# 1. Crear array RAID 1
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc

# 2. Cifrar el array completo con LUKS
sudo cryptsetup luksFormat /dev/md0
sudo cryptsetup open /dev/md0 md0_crypt

# 3. Poner LVM dentro del volumen cifrado
sudo pvcreate /dev/mapper/md0_crypt
sudo vgcreate vg_secure /dev/mapper/md0_crypt
sudo lvcreate -L 50G -n lv_data vg_secure
sudo mkfs.ext4 /dev/vg_secure/lv_data

# 4. Montar
sudo mount /dev/vg_secure/lv_data /mnt/secure
```

---

## RAID por hardware vs software

| Característica | RAID software (mdadm) | RAID por hardware |
|---|---|---|
| **Costo** | Gratuito (usa CPU) | Caro (controladora dedicada) |
| **Rendimiento** | Depende de CPU (mínimo impacto en CPUs modernos) | Independiente de CPU |
| **Portabilidad** | Alta (los discos se leen en cualquier Linux) | Baja (depende del controlador) |
| **Flexibilidad** | Alta (niveles mezclados, LVM, LUKS encima) | Media (limitado por la controladora) |
| **Monitorización** | mdadm, scripts | Utilidad propietaria |
| **Cache/Batería** | ❌ No | ✅ Sí (escritura segura en cache) |
| **Ideal para** | Homelab, servidores pequeños, NAS casero | Servidores empresariales, bases de datos |

---

## Buenas prácticas

- **Siempre verificar los discos antes de crear el RAID**: `lsblk`, `fdisk -l` para asegurarte de que estás usando los discos correctos.
- **Usar discos del mismo tamaño**: En RAID 5/6, el array usará el tamaño del disco más pequeño.
- **RAID no es un backup**: RAID protege contra fallo de disco, no contra borrado accidental, ransomware, o corrupción de archivos. Combínalo con [[Backups (borg restic duplicity rsync)]].
- **Probar la recuperación**: Simula un fallo y verifica que puedes recuperarte antes de depender del RAID.
- **Monitorizar**: Configurar alertas por correo (MAILADDR) para enterarte cuando un disco falla.
- **Smartmontools**: Instalar `smartmontools` para monitorizar la salud de los discos y detectar fallos inminentes.

## Ver también

- [[LVM]] — capa de volúmenes lógicos (a menudo se usa sobre RAID)
- [[Sistemas de Archivos]] — ext4, Btrfs, XFS sobre el dispositivo RAID
- [[Particionado y Esquemas de Disco]] — particionar discos antes del RAID
- [[Cifrado (LUKS dm-crypt GPG)]] — LUKS sobre RAID (o viceversa)
- [[Backups (borg restic duplicity rsync)]] — RAID no reemplaza los backups
- [[Proc y Sys]] — `/proc/mdstat` y el estado del RAID

## Enlaces externos

- [Wikipedia — RAID](https://en.wikipedia.org/wiki/RAID)
- [Arch Wiki — RAID](https://wiki.archlinux.org/title/RAID)
- [mdadm manual](https://man.archlinux.org/man/mdadm.8)

#sistema #almacenamiento
