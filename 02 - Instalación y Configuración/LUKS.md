---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: instalacion
prioridad: alta
---

# LUKS + dm-crypt — Cifrado de disco

LUKS (Linux Unified Key Setup) es el estándar de facto para cifrado de discos en Linux. Define una cabecera con algoritmo de cifrado, hasta 8 slots de frase, y parámetros de derivación de clave (PBKDF2 o Argon2id). dm-crypt es el módulo del kernel que realiza el cifrado a nivel de bloques.

## Crear un volumen cifrado

```bash
# 1. Particionar
sudo fdisk /dev/sdb          # crear /dev/sdb1

# 2. Formatear con LUKS
sudo cryptsetup luksFormat /dev/sdb1
# ¡Usar YES en mayúsculas para confirmar!

# 3. Abrir el volumen
sudo cryptsetup open /dev/sdb1 mi_volumen

# 4. Formatear con sistema de archivos
sudo mkfs.ext4 /dev/mapper/mi_volumen

# 5. Montar
sudo mount /dev/mapper/mi_volumen /mnt/cifrado
```

## Operaciones diarias

```bash
# Cerrar y desmontar
sudo umount /mnt/cifrado
sudo cryptsetup close mi_volumen

# Ver estado
sudo cryptsetup status mi_volumen
sudo cryptsetup luksDump /dev/sdb1       # info de cabecera
```

## Gestión de frases (key slots)

```bash
sudo cryptsetup luksAddKey /dev/sdb1                  # añadir frase
sudo cryptsetup luksChangeKey /dev/sdb1 -S 0           # cambiar slot 0
sudo cryptsetup luksKillSlot /dev/sdb1 2               # eliminar slot 2
sudo cryptsetup luksHeaderBackup /dev/sdb1 --header-backup-file header.img  # ¡crítico!
```

## Cifrado completo del sistema (root)

```bash
# Esquema típico (UEFI):
# /dev/sda1 → EFI (FAT32, ~512MB, sin cifrar)
# /dev/sda2 → LUKS cifrado (resto del disco)

# Abrir y crear LVM dentro de LUKS:
sudo cryptsetup open /dev/sda2 lvm_sistema
# Crear: lv_root, lv_home, lv_swap
```

> Con UEFI + GRUB + LUKS2 (PBKDF2), GRUB puede pedir la frase antes del kernel. Se necesita `GRUB_ENABLE_CRYPTODISK=y` en `/etc/default/grub`.

## Cifrar un disco en uso (sin formatear)

```bash
# cryptsetup 2.2+ permite convertir disco existente a LUKS sin perder datos
sudo cryptsetup reencrypt --encrypt /dev/sdb1 --reduce-device-size 32M
```

## Parámetros avanzados

| Opción | Recomendado |
|---|---|
| `--cipher` | `aes-xts-plain64` (default) |
| `--key-size` | `512` (256 efectivos por cada mitad) |
| `--pbkdf` | `argon2id` (resistente a GPU) |
| `--iter-time` | `2000` (2 segundos) |

```bash
sudo cryptsetup luksFormat --cipher aes-xts-plain64 --key-size 512 \
  --pbkdf argon2id --iter-time 3000 /dev/sdb1
```

## Rendimiento

```bash
# Verificar AES-NI (debe aparecer "aes" en flags)
grep -E '^flags' /proc/cpuinfo | head -1 | grep -o aes
```

Con AES-NI, el cifrado tiene impacto mínimo (~500-3000 MB/s).

## Ver también

- [[GPG]] — cifrado de archivos
- [[Particionado y Esquemas de Disco]]
- [[LVM]] — LVM dentro de LUKS
- [[Cifrado (LUKS dm-crypt GPG)]] — índice + comparativa

## Enlaces externos

- [Wikipedia — LUKS](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup)
- [Arch Wiki — dm-crypt](https://wiki.archlinux.org/title/Dm-crypt)

#cifrado #seguridad
