---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: instalacion
prioridad: alta
---

# Cifrado (LUKS, dm-crypt, GPG)

## Definición

El cifrado en Linux protege datos en reposo transformándolos en información ilegible sin una clave. Se aplica en dos niveles principales:

| Nivel | Herramienta | Qué protege | Cuándo usarlo |
|---|---|---|---|
| **Bloque** (disco completo) | LUKS + dm-crypt | Partición o disco entero (root, home, swap cifrados) | Portátiles, discos externos, servidores con datos sensibles |
| **Archivo** (cifrado individual) | GPG | Archivos sueltos, correos, backups, firmas digitales | Enviar datos por red, almacenar credenciales, verificar autenticidad |

```
Arquitectura del cifrado en Linux:

          ┌─────────────────────────────┐
          │         Aplicaciones        │
          │  GPG → cifrado de archivos  │
          └─────────────────────────────┘
                        │
          ┌─────────────▼───────────────┐
          │  dm-crypt (kernel, device   │
          │  mapper — mapea bloques     │
          │  cifrados a /dev/mapper/)   │
          └─────────────┬───────────────┘
          ┌─────────────▼───────────────┐
          │  LUKS (formato de cabecera  │
          │  — metadatos, frases,       │
          │  slots de clave)            │
          └─────────────┬───────────────┘
          ┌─────────────▼───────────────┐
          │  /dev/sda2 (disco real)     │
          │  [cabecera LUKS | datos     │
          │   cifrados con AES-XTS]     │
          └─────────────────────────────┘
```

---

## Cifrado de disco — LUKS + dm-crypt

LUKS (Linux Unified Key Setup) es el estándar de facto para cifrado de discos en Linux. Define un formato de cabecera que almacena:

- Algoritmo de cifrado (AES-XTS por defecto, AES-CBC como alternativo)
- **8 slots de frase** (hasta 8 contraseñas diferentes para abrir el mismo disco)
- Parámetros de _key derivation_ (PBKDF2 o Argon2id)

### Crear un volumen cifrado

```bash
# 1. Particionar normalmente (con fdisk, gdisk, parted, etc.)
sudo fdisk /dev/sdb          # crear, ej: /dev/sdb1

# 2. Formatear con LUKS (esto destruye los datos existentes)
sudo cryptsetup luksFormat /dev/sdb1
# Se te pedirá: CONTRASEÑA (asegúrate de usar YES en mayúsculas)
# WARNING: Esto borra TODO el contenido de la partición

# 3. Abrir el volumen (lo mapea a /dev/mapper/<nombre>)
sudo cryptsetup open /dev/sdb1 mi_volumen
# Ingresa la frase de cifrado → ahora existe /dev/mapper/mi_volumen

# 4. Formatear con sistema de archivos (sobre el mapeo)
sudo mkfs.ext4 /dev/mapper/mi_volumen

# 5. Montar
sudo mount /dev/mapper/mi_volumen /mnt/cifrado
```

### Operaciones diarias

```bash
# Cerrar y desmontar
sudo umount /mnt/cifrado
sudo cryptsetup close mi_volumen

# Abrir de nuevo (paso 3 otra vez)
sudo cryptsetup open /dev/sdb1 mi_volumen
sudo mount /dev/mapper/mi_volumen /mnt/cifrado

# Ver estado de volúmenes abiertos
sudo cryptsetup status mi_volumen
sudo dmsetup ls                       # lista todos los device mapper

# Ver información de la cabecera LUKS
sudo cryptsetup luksDump /dev/sdb1
```

### Gestión de frases de cifrado (key slots)

```bash
# Añadir una frase adicional (slot 1..7)
sudo cryptsetup luksAddKey /dev/sdb1

# Cambiar una frase existente
sudo cryptsetup luksChangeKey /dev/sdb1 -S 0   # slot 0

# Eliminar un slot (revocar acceso a alguien)
sudo cryptsetup luksKillSlot /dev/sdb1 2        # elimina slot 2

# Backup de la cabecera LUKS (¡crítico! si se corrompe, pierdes los datos)
sudo cryptsetup luksHeaderBackup /dev/sdb1 --header-backup-file luks-header-backup.img
```

### Cifrado completo del sistema (root)

La mayoría de instaladores de distros ofrecen cifrar root automáticamente (Ubuntu, Fedora, Arch, Debian). Manualmente:

```bash
# Durante la instalación, crear particiones así:
# /dev/sda1 → EFI (sin cifrar, FAT32, ~512MB)
# /dev/sda2 → boot (sin cifrar, ext4, ~1GB) — solo si se usa GRUB legacy
# /dev/sda3 → LUKS cifrado (resto del disco)

# Abrir y crear LVM dentro de LUKS:
sudo cryptsetup open /dev/sda3 lvm_sistema
# Dentro de /dev/mapper/lvm_sistema crear:
#   lv_root (/, ext4 o btrfs)
#   lv_home (/home, ext4)
#   lv_swap (swap)

# En /etc/crypttab (para que se abra automáticamente al arrancar):
# lvm_sistema /dev/sda3 none luks

# En /etc/fstab:
# /dev/mapper/lv_root  /  ext4  defaults  0 1
# /dev/mapper/lv_home  /home  ext4  defaults  0 2
```

> **Nota**: Con UEFI + GRUB + LUKS2 (usando PBKDF2, que es el algoritmo por defecto en la mayoría de distros), GRUB puede leer la cabecera LUKS2 y pedir la frase antes de cargar el kernel. Se necesita `GRUB_ENABLE_CRYPTODISK=y` en `/etc/default/grub`. Esto permite que `/boot` esté dentro del volumen cifrado. Sin embargo, algunas distros (Fedora, Ubuntu) recomiendan mantener `/boot` fuera del cifrado por simplicidad y compatibilidad — ambas opciones son válidas.

#### Cifrar un disco en uso (sin formatear)

Desde cryptsetup 2.2+, puedes convertir un disco que ya tiene datos (no cifrado) a LUKS sin perderlos:

```bash
# NOTA: HAZ BACKUP primero. Aunque el proceso es seguro, un corte de luz lo pierde todo.

# Convertir partición existente a LUKS (en caliente, requiere espacio libre al final)
sudo cryptsetup reencrypt --encrypt /dev/sdb1 --reduce-device-size 32M
# Te pedirá la frase de cifrado y procederá a cifrar en el lugar

# Abrir el volumen cifrado resultante
sudo cryptsetup open /dev/sdb1 mi_volumen
sudo mount /dev/mapper/mi_volumen /mnt/cifrado
```

---

## Parámetros avanzados de cryptsetup

| Opción | Descripción | Valor recomendado |
|---|---|---|
| `--cipher` | Algoritmo de cifrado | `aes-xts-plain64` (por defecto) |
| `--key-size` | Tamaño de clave | `512` (para AES-XTS, 256 efectivos por cada mitad) |
| `--pbkdf` | Algoritmo de derivación de clave | `argon2id` (resistente a GPU) |
| `--iter-time` | Tiempo de derivación (ms) | `2000` (2 segundos, más seguro pero más lento) |

Ejemplo de formato con parámetros explícitos:

```bash
sudo cryptsetup luksFormat --cipher aes-xts-plain64 --key-size 512 --pbkdf argon2id --iter-time 3000 /dev/sdb1
```

---

## Cifrado de archivos — GPG

GPG (GNU Privacy Guard) implementa el estándar OpenPGP para cifrado asimétrico y simétrico, firmas digitales y verificación.

### Cifrado simétrico (una contraseña)

```bash
# Cifrar un archivo (te pedirá una contraseña)
gpg --symmetric --cipher-algo AES256 documento.pdf
# → Genera documento.pdf.gpg

# Descifrar
gpg documento.pdf.gpg
# → Genera documento.pdf

# Redirigir a stdout (útil en pipelines)
gpg --decrypt documento.pdf.gpg > documento.pdf
```

### Cifrado asimétrico (clave pública/privada)

```bash
# 1. Generar un par de claves
gpg --full-generate-key
#   Tipo: RSA (o Ed25519 si se prefiere)
#   Tamaño: 4096 bits
#   Validez: 2y (o la que quieras)

# 2. Listar claves
gpg --list-keys                         # claves públicas
gpg --list-secret-keys                  # claves privadas

# 3. Exportar clave pública (para compartir)
gpg --export --armor usuario@email.com > mi-clave-publica.asc

# 4. Importar una clave pública recibida
gpg --import clave-de-alguien.asc

# 5. Cifrar un archivo para un destinatario
gpg --encrypt --recipient destinatario@email.com documento.pdf
# → Solo el destinatario puede descifrarlo con su clave privada

# 6. Firmar un archivo (verificar que viene de ti)
gpg --sign documento.pdf                # firma + archivo original
gpg --detach-sign documento.pdf         # firma separada (archivo.sig)
gpg --clearsign documento.txt           # firma visible (texto)

# 7. Verificar firma
gpg --verify documento.pdf.sig documento.pdf

# 8. Cifrar y firmar a la vez
gpg --encrypt --sign --recipient destinatario@email.com documento.pdf
```

### Cifrar un backup completo

```bash
# Cifrar un backup de manera segura con clave simétrica
tar czf - /ruta/a/backup/ | gpg --symmetric --cipher-algo AES256 > backup-$(date +%F).tar.gz.gpg

# Descifrar y extraer en un paso
gpg --decrypt backup-2026-01-15.tar.gz.gpg | tar xzf -
```

### Revocar una clave

```bash
gpg --gen-revoke usuario@email.com > revocacion.asc
gpg --import revocacion.asc
```

---

## Tabla comparativa

| Característica | LUKS/dm-crypt | GPG |
|---|---|---|
| **Nivel** | Bloque (disco/partición) | Archivo |
| **Velocidad** | Muy rápida (cifrado hardware AES-NI) | Lenta en archivos grandes |
| **Transparencia** | Montas y usas normalmente | Necesitas descifrar/volver a cifrar |
| **Múltiples usuarios** | 8 slots de frase | Clave pública para cada destinatario |
| **Firma digital** | ❌ No | ✅ Sí (verificar autoría) |
| **Ideal para** | Disco completo, home, swap | Correo, backups selectivos, credenciales |
| **Rendimiento típico** | ~500-3000 MB/s (con AES-NI) | ~50-200 MB/s |

---

## Buenas prácticas y advertencias

### ⚠️ Lo que nunca debes hacer

```bash
# ❌ Usar el mismo password para LUKS y la cuenta de usuario
# ❌ Olvidar hacer backup de la cabecera LUKS (sin ella los datos son irrecuperables)
# ❌ Cifrar sin verificar que el disco no tenga errores antes
# ❌ Compartir la clave privada de GPG
# ❌ Usar frases cortas o predecibles en LUKS
```

### ✅ Buenas prácticas

```bash
# ✅ Hacer backup de la cabecera LUKS en un lugar seguro
sudo cryptsetup luksHeaderBackup /dev/sdb1 --header-backup-file /backup/luks-header-sdb1.img

# ✅ Tener al menos 2 frases activas (por si olvidas una)
sudo cryptsetup luksAddKey /dev/sdb1

# ✅ Proteger la clave privada GPG con una frase fuerte
# ✅ Configurar caducidad en claves GPG (2 años, renovable)
# ✅ Cifrar siempre el swap si cifras root (datos sensibles pueden estar en swap)
```

### Cifrado y rendimiento

Los CPUs modernos con **AES-NI** (AES New Instructions, presente en casi cualquier Intel/AMD desde 2010) hacen que el cifrado tenga un impacto mínimo en rendimiento:

```bash
# Verificar si tu CPU soporta AES-NI (debe aparecer "aes" en flags)
grep -E '^flags' /proc/cpuinfo | head -1 | grep -o aes
# Si sale "aes", el cifrado de disco es casi tan rápido como sin cifrar
```

Sin AES-NI (CPUs muy antiguos o ARM sin aceleración), LUKS puede ralentizar operaciones de E/S un 20-40%.

---

## Relación con otros conceptos

- [[Particionado y Esquemas de Disco]] — LUKS se aplica sobre particiones
- [[LVM]] — LVM dentro de LUKS es la combinación más potente (flexibilidad + seguridad)
- [[Sistemas de Archivos]] — ext4, Btrfs, XFS sobre el volumen descifrado
- [[Permisos y Propietarios]] — el cifrado no reemplaza los permisos
- [[SSH]] — GPG se usa a menudo para firmar claves SSH o verificar identidad
- [[Gestores de Paquetes]] — GPG se usa para verificar firmas de paquetes

## Enlaces externos

- [Wikipedia — LUKS](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup)
- [Wikipedia — dm-crypt](https://en.wikipedia.org/wiki/Dm-crypt)
- [Wikipedia — GNU Privacy Guard (GPG)](https://en.wikipedia.org/wiki/GNU_Privacy_Guard)
- [Arch Wiki — dm-crypt](https://wiki.archlinux.org/title/Dm-crypt)

## Ver también

- [[Particionado y Esquemas de Disco]]
- [[LVM]]
- [[Sistemas de Archivos]]
- [[Automatizacion y Scripts]] — scripts para automatizar montaje/desmontaje cifrado

#cifrado #seguridad
