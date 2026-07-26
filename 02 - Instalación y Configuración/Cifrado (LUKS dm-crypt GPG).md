---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: instalacion
prioridad: alta
---

# Cifrado (LUKS, dm-crypt, GPG)

El cifrado en Linux protege datos en reposo transformándolos en información ilegible sin una clave.

## Niveles de cifrado

| Nivel | Herramienta | Qué protege |
|---|---|---|
| **Bloque** (disco) | [[LUKS]] + dm-crypt | Partición o disco completo |
| **Archivo** | [[GPG]] | Archivos sueltos, backups, firmas |

## Comparativa

| Característica | LUKS/dm-crypt | GPG |
|---|---|---|
| **Nivel** | Bloque | Archivo |
| **Velocidad** | ~500-3000 MB/s (AES-NI) | ~50-200 MB/s |
| **Transparencia** | Montas y usas normalmente | Descifrar/volver a cifrar |
| **Firma digital** | ❌ | ✅ |
| **Ideal para** | Disco completo, home, swap | Backups selectivos, credenciales |

## Buenas prácticas

```bash
# ✅ Hacer backup de cabecera LUKS
sudo cryptsetup luksHeaderBackup /dev/sdb1 --header-backup-file header.img

# ✅ Verificar AES-NI
grep -E '^flags' /proc/cpuinfo | head -1 | grep -o aes

# ❌ No compartir clave privada GPG
# ❌ No usar frases cortas en LUKS
```

## Ver también

- [[Particionado y Esquemas de Disco]] — LUKS sobre particiones
- [[LVM]] — LVM dentro de LUKS
- [[Sistemas de Archivos]] — ext4, Btrfs, XFS
- [[Permisos y Propietarios]]
- [[Gestores de Paquetes]] — GPG verifica firmas de paquetes

## Enlaces externos

- [Wikipedia — LUKS](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup)
- [Wikipedia — dm-crypt](https://en.wikipedia.org/wiki/Dm-crypt)
- [Wikipedia — GNU Privacy Guard (GPG)](https://en.wikipedia.org/wiki/GNU_Privacy_Guard)
- [Arch Wiki — dm-crypt](https://wiki.archlinux.org/title/Dm-crypt)

#cifrado #seguridad
