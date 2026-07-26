---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: baja
---

# LUKS2 y Btrfs

> Cifrado de bloque con LUKS2 combinado con Btrfs como filesystem. Snapshots cifrados, backup con borg, consideraciones de rendimiento.

## Por qué LUKS2 + Btrfs

Btrfs soporta snapshots, compresión y subvolúmenes. LUKS2 cifra todo el bloque subyacente. La combinación permite snapshots cifrados sin configuración extra.

```
Aplicación
    ↓
Btrfs (subvolúmenes, snapshots, compresión)
    ↓
LUKS2 (cifrado AES-256-XTS)
    ↓
Disco físico (/dev/sda2)
```

## Instalación desde cero

```bash
# 1. Particionar (UEFI + root + swap)
gdisk /dev/sda
#   → EFI (512M, EF00)
#   → LUKS (resto, 8309)

# 2. Cifrar con LUKS2
sudo cryptsetup luksFormat --type luks2 --cipher aes-xts-plain64 --key-size 512 --hash sha256 /dev/sda2
sudo cryptsetup luksOpen /dev/sda2 cryptroot

# 3. Crear Btrfs en el volumen cifrado
sudo mkfs.btrfs -f -L root /dev/mapper/cryptroot

# 4. Montar y crear subvolúmenes
sudo mount /dev/mapper/cryptroot /mnt
sudo btrfs subvolume create /mnt/@
sudo btrfs subvolume create /mnt/@home
sudo btrfs subvolume create /mnt/@snapshots
sudo umount /mnt

# 5. Remontar con subvolúmenes
sudo mount -o subvol=@,compress=zstd /dev/mapper/cryptroot /mnt
sudo mkdir -p /mnt/{home,snapshots,boot/efi}
sudo mount -o subvol=@home /dev/mapper/cryptroot /mnt/home
sudo mount -o subvol=@snapshots /dev/mapper/cryptroot /mnt/snapshots
sudo mount /dev/sda1 /mnt/boot/efi

# 6. fstab
echo 'UUID=<uuid> / btrfs compress=zstd,subvol=@ 0 0' | sudo tee -a /mnt/etc/fstab
echo 'UUID=<uuid> /home btrfs compress=zstd,subvol=@home 0 0' | sudo tee -a /mnt/etc/fstab
```

## Snapshots

```bash
# Crear snapshot
sudo btrfs subvolume snapshot -r /mnt/@ /mnt/snapshots/snapshot-$(date +%Y%m%d)

# Listar snapshots
sudo btrfs subvolume list /mnt

# Restaurar snapshot
sudo btrfs subvolume delete /mnt/@
sudo btrfs subvolume snapshot /mnt/snapshots/snapshot-20260725 /mnt/@
```

## Backup con borg sobre Btrfs cifrado

```bash
# Borg trabaja sobre el filesystem montado — no necesita saber de LUKS
borg init --encryption=repokey /mnt/snapshots/borg-repo
borg create /mnt/snapshots/borg-repo::daily /mnt/@ --exclude /mnt/@/.cache
```

## Ver también

- [[Cifrado (LUKS dm-crypt GPG)]]
- [[Btrfs]]
- [[zram]]
- [[Backups (borg restic duplicity rsync)]]

#sistema #cifrado #luks #btrfs #snapshots
