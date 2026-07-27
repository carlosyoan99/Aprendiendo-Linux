---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-27
estado: resuelto
categoria: instalacion
prioridad: alta
---

# LUKS + dm-crypt — Cifrado de disco

LUKS (Linux Unified Key Setup) es el estándar de facto para cifrado de discos en Linux. Define una cabecera con algoritmo de cifrado, hasta 8 slots de frase, y parámetros de derivación de clave (PBKDF2 o Argon2id). dm-crypt es el módulo del kernel que realiza el cifrado a nivel de bloques.

## LUKS1 vs LUKS2

| Característica | LUKS1 | LUKS2 |
|---|---|---|
| Formato de cabecera | Binaria | **JSON** (flexible, extensible) |
| PBKDF por defecto | PBKDF2 | **Argon2id** (resistente a GPU/ASIC) |
| Tamaño de cabecera | 2 MiB fijo | 4-128 MiB configurable |
| Keyslots | 8 | Hasta 32 |
| Re-encryption online | ❌ | ✅ (sin desmontar) |
| Integridad (dm-integrity) | ❌ | ✅ |
| Token TPM2 / PKCS#11 | ❌ | ✅ |
| Compatibilidad GRUB | ✅ (PBKDF2) | ⚠️ Solo si usa PBKDF2 (no Argon2) |

## Crear un volumen cifrado

```bash
# 1. Particionar
sudo fdisk /dev/sdb          # crear /dev/sdb1

# 2. Formatear con LUKS (LUKS2 + Argon2id por defecto)
sudo cryptsetup luksFormat /dev/sdb1
# ¡Usar YES en mayúsculas para confirmar!

# 3. Abrir el volumen
sudo cryptsetup open /dev/sdb1 mi_volumen

# 4. Formatear con sistema de archivos
sudo mkfs.ext4 /dev/mapper/mi_volumen

# 5. Montar
sudo mount /dev/mapper/mi_volumen /mnt/cifrado
```

### Parámetros avanzados

```bash
# LUKS2 con Argon2id explícito, clave AES-512
sudo cryptsetup luksFormat --type luks2 \
  --cipher aes-xts-plain64 --key-size 512 \
  --pbkdf argon2id --iter-time 3000 /dev/sdb1

# LUKS1 (necesario para GRUB con LUKS)
sudo cryptsetup luksFormat --type luks1 /dev/sdb1
```

## Operaciones diarias

```bash
# Cerrar y desmontar
sudo umount /mnt/cifrado
sudo cryptsetup close mi_volumen

# Ver estado
sudo cryptsetup status mi_volumen
sudo cryptsetup luksDump /dev/sdb1       # info de cabecera (JSON en LUKS2)
```

## Gestión de frases (key slots)

```bash
sudo cryptsetup luksAddKey /dev/sdb1                  # añadir frase
sudo cryptsetup luksChangeKey /dev/sdb1 -S 0           # cambiar slot 0
sudo cryptsetup luksKillSlot /dev/sdb1 2               # eliminar slot 2
sudo cryptsetup luksRemoveKey /dev/sdb1                # eliminar interactivo

# Ver slots ocupados y libres
sudo cryptsetup luksDump /dev/sdb1 | grep -E "Slot|Status"
```

> **Buenas prácticas**: Mantener un slot de emergencia con una frase de recovery guardada offline. No eliminar todos los slots de golpe.

## Cabecera: backup y restauración

La cabecera LUKS contiene toda la información para descifrar el disco. Si se daña, los datos son irrecuperables.

```bash
# Backup urgente (¡hacerlo justo después de crear el volumen!)
sudo cryptsetup luksHeaderBackup /dev/sdb1 \
  --header-backup-file /backups/luks-header-sdb1.img

# Restaurar cabecera (siempre del mismo disco)
sudo cryptsetup luksHeaderRestore /dev/sdb1 \
  --header-backup-file /backups/luks-header-sdb1.img
```

```bash
# Backup de la cabecera con información de recuperación
sudo cryptsetup luksDump /dev/sdb1 > /backups/luks-header-info.txt
# Guardar: cipher, hash, key size, uuid
```

## Cabecera desvinculada (detached header)

Separa la cabecera del disco cifrado, dejando el disco como ruido aleatorio puro. Útil para plausible deniability o para proteger la cabecera.

```bash
# Crear con cabecera separada
sudo cryptsetup luksFormat --header /backups/header.img /dev/sdb1

# Abrir especificando la cabecera
sudo cryptsetup --header /backups/header.img open /dev/sdb1 mi_volumen

# La partición /dev/sdb1 sin la cabecera se ve como datos aleatorios
hexdump -C /dev/sdb1 | head
# No hay cabecera LUKS visible
```

## LVM sobre LUKS

Esquema más flexible: un solo volumen LUKS contiene LVM con múltiples volúmenes lógicos.

```bash
# 1. Crear y abrir LUKS
sudo cryptsetup luksFormat /dev/sda2
sudo cryptsetup open /dev/sda2 cryptroot

# 2. Crear LVM dentro
sudo pvcreate /dev/mapper/cryptroot
sudo vgcreate vg_sistema /dev/mapper/cryptroot
sudo lvcreate -L 20G vg_sistema -n lv_root
sudo lvcreate -L 10G vg_sistema -n lv_home
sudo lvcreate -L 4G vg_sistema -n lv_swap

# 3. Formatear y montar
sudo mkfs.ext4 /dev/mapper/vg_sistema-lv_root
sudo mkfs.ext4 /dev/mapper/vg_sistema-lv_home
sudo mkswap /dev/mapper/vg_sistema-lv_swap
```

```
Esquema resultante:
┌──────────┐  ┌─────────────────────────────────────┐
│  /boot   │  │         /dev/sda2 (LUKS2)           │
│ (ext4)   │  │  ┌─────────────────────────────────┐│
│ sin cifr │  │  │  vg_sistema (LVM)              ││
└──────────┘  │  │  ┌──────┐┌──────┐┌──────────┐ ││
              │  │  │ root ││ home ││   swap    │ ││
              │  │  │ 20G  ││ 10G  ││   4G      │ ││
              │  │  └──────┘└──────┘└──────────┘ ││
              │  └─────────────────────────────────┘│
              └─────────────────────────────────────┘
```

## Cifrar un disco en uso (sin formatear)

```bash
# cryptsetup 2.2+ permite convertir disco existente a LUKS sin perder datos
sudo cryptsetup reencrypt --encrypt /dev/sdb1 --reduce-device-size 32M

# Detener/reanudar (útil para pausar en servidores)
sudo cryptsetup reencrypt --decrypt /dev/sdb1
```

## Rendimiento

```bash
# Verificar AES-NI (debe aparecer "aes" en flags)
grep -E '^flags' /proc/cpuinfo | head -1 | grep -o aes

# Benchmark de cifrado
cryptsetup benchmark
```

Con AES-NI, el cifrado tiene impacto mínimo (~500-3000 MB/s). Sin AES-NI, se recomienda `--cipher aes-cbc-essiv:sha256` por ser más rápido en CPUs sin aceleración hardware.

## Cifrado completo del sistema (root)

```bash
# Esquema típico (UEFI):
# /dev/sda1 → EFI (FAT32, ~512MB, sin cifrar)
# /dev/sda2 → LUKS cifrado (resto del disco)

# Abrir y crear LVM dentro de LUKS:
sudo cryptsetup open /dev/sda2 lvm_sistema
# Crear: lv_root, lv_home, lv_swap
```

> Con UEFI + GRUB + LUKS1, GRUB puede pedir la frase antes del kernel. Se necesita `GRUB_ENABLE_CRYPTODISK=y` en `/etc/default/grub`. LUKS2 solo funciona con GRUB si usa PBKDF2 (no Argon2id).

## Desbloqueo automático con TPM2 (systemd-cryptenroll)

Si tu sistema tiene chip TPM2, puedes sellar la clave de cifrado para que se desbloquee automáticamente al arrancar, sin pedir frase:

```bash
# Verificar que el TPM está disponible
sudo systemd-cryptenroll --tpm2-device=list

# Sellar la frase actual en el TPM (PCR 7 = Secure Boot state)
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/sda2

# Configurar /etc/crypttab para usar TPM2
# cryptroot  /dev/sda2  -  tpm2-device=auto
```

```bash
# Probar que funciona (el initramfs debe regenerarse)
sudo mkinitcpio -P        # Arch
sudo update-initramfs -u  # Debian/Ubuntu
sudo dracut -f            # Fedora
```

## Desbloqueo remoto por SSH (dropbear en initramfs)

Para servidores headless que necesitan desbloquear el disco cifrado remotamente:

```bash
# Arch: instalar dropbear en initramfs
sudo pacman -S mkinitcpio-dropbear

# Debian/Ubuntu
sudo apt install dropbear-initramfs

# Configurar red en initramfs (IP estática)
# /etc/initramfs-tools/initramfs.conf (Debian)
IP=192.168.1.100:::255.255.255.0::eth0:off

# Añadir clave SSH pública
echo "ssh-ed25519 AAA..." | sudo tee -a /etc/dropbear-initramfs/authorized_keys

# Regenerar initramfs
sudo update-initramfs -u
sudo mkinitcpio -P

# Al reiniciar, el servidor arranca initramfs + dropbear
# Desde otro equipo:
ssh root@192.168.1.100
cryptroot-unlock   # escribir la frase LUKS
# o (según distro):
echo -n "mi-frase" > /lib/cryptsetup/passfifo
```

## Redimensionar un volumen cifrado

```bash
# 1. Redimensionar la partición subyacente (con GParted o fdisk)
# 2. Informar a cryptsetup del nuevo tamaño
sudo cryptsetup resize mi_volumen

# 3. Redimensionar el sistema de archivos
sudo resize2fs /dev/mapper/mi_volumen    # ext4
sudo xfs_growfs /mnt/punto_montaje       # XFS
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `No key available with this passphrase` | Frase incorrecta o slot corrupto | Probar con `--verbose`, verificar con `luksDump` que el slot está activo |
| `Device /dev/sdb1 is not a valid LUKS device` | Cabecera dañada o disco sin formato LUKS | Restaurar cabecera: `luksHeaderRestore` si hay backup |
| `Cannot use LUKS2 with GRUB` | GRUB antiguo (<2.06) o Argon2id | Usar `--type luks1` o `--pbkdf pbkdf2` |
| Arranque pide frase 2 veces | initramfs y GRUB piden por separado | `GRUB_CMDLINE_LINUX="rd.luks.name=UUID=root"` o usar TPM2 |
| `Operation not permitted` | Falta `dm-crypt` en kernel | `modprobe dm-crypt` y verificar kernel |
| `cryptsetup: ERROR: Couldn't resolve device` | UUID incorrecto en crypttab | `sudo blkid /dev/sda2` para obtener UUID correcto |

## Ver también

- [[GPG]] — cifrado de archivos
- [[Particionado y Esquemas de Disco]]
- [[LVM]] — LVM dentro de LUKS
- [[Cifrado (LUKS dm-crypt GPG)]] — índice + comparativa

## Enlaces externos

- [Wikipedia — LUKS](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup)
- [Arch Wiki — dm-crypt](https://wiki.archlinux.org/title/Dm-crypt)
- [systemd-cryptenroll(1)](https://man7.org/linux/man-pages/man1/systemd-cryptenroll.1.html)
- [Clevis + Tang (network binding)](https://github.com/latchset/clevis)

#cifrado #seguridad
