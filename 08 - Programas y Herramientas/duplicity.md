---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# duplicity

## Qué es

**duplicity** usa **rsync** + **GPG** para hacer backups incrementales cifrados. Es más lento que borg o restic (cifra cada archivo individualmente) pero muy maduro, confiable y ampliamente usado en entornos legacy.

## Instalación

```bash
sudo apt install duplicity            # Debian/Ubuntu
sudo pacman -S duplicity              # Arch
sudo dnf install duplicity            # Fedora
```

## Uso básico

```bash
# Backup completo a disco local (cifrado con GPG)
duplicity /home/usuario/Documentos/ file:///mnt/backup/duplicity/

# Backup incremental (duplicity detecta automáticamente)
duplicity /home/usuario/Documentos/ file:///mnt/backup/duplicity/

# Backup remoto vía SSH
duplicity /home/usuario/Documentos/ scp://usuario@servidor/backups/

# Listar backups disponibles
duplicity collection-status file:///mnt/backup/duplicity/

# Restaurar
duplicity file:///mnt/backup/duplicity/ /tmp/restore

# Restaurar archivo específico
duplicity --file-to-restore Documentos/importante.pdf \
  file:///mnt/backup/duplicity/ /tmp/restore/

# Eliminar backups antiguos
duplicity remove-older-than 30D file:///mnt/backup/duplicity/ --force
```

## Cifrado con clave GPG

```bash
# Usar una clave GPG específica
export PASSPHRASE="tu-frase"
export SIGN_PASSPHRASE="tu-frase-de-firma"
export GPG_KEY="ID_DE_TU_CLAVE_GPG"

duplicity --encrypt-key $GPG_KEY --sign-key $GPG_KEY \
  /home/usuario/ scp://usuario@servidor/backups/
```

## Ver también

- [[borg]] — backup deduplicado más eficiente en espacio
- [[restic]] — backup rápido con múltiples destinos cloud
- [[Backups (borg restic duplicity rsync)]] — índice comparativo y estrategia 3-2-1
- [[Cifrado (LUKS dm-crypt GPG)]] — GPG para cifrado
- [[rsync]] — sincronización de archivos

## Enlaces externos

- [Sitio oficial — duplicity](https://duplicity.gitlab.io/)

#programa
