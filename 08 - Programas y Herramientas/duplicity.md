---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL v2
alternativas: borg, restic, rsync, timeshift
---

# duplicity

> Herramienta de backups **incrementales cifrados** que combina rsync para la sincronización y GPG para el cifrado. Más lento que borg o restic (cifra cada archivo individualmente) pero muy maduro, confiable y ampliamente usado en servidores y entornos legacy.

## Qué es

duplicity toma un directorio fuente, genera un backup completo cifrado con GPG, y luego solo sincroniza los archivos que cambiaron (incremental). Los backups se almacenan como archivos GPG individuales, lo que facilita restaurar sin herramientas especializadas pero desperdicia espacio (sin deduplicación).

- **Método**: incremental por rsync diffs + cifrado GPG individual por archivo
- **Destinos**: local, SSH/SCP, FTP, S3, Swift, GCS, Rackspace, WebDAV
- **Cifrado**: GPG (simétrico o asimétrico, firmado o no)
- **Diferencia vs borg/restic**: sin deduplicación, sin compresión de bloques

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install duplicity` |
| Arch | `sudo pacman -S duplicity` |
| Fedora | `sudo dnf install duplicity` |
| openSUSE | `sudo zypper install duplicity` |
| Void | `sudo xbps-install -S duplicity` |
| Alpine | `sudo apk add duplicity` |
| pip | `pip install --user duplicity` |
| macOS | `brew install duplicity` |

## Sintaxis

```bash
duplicity [opciones] <fuente> <destino>
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `--full-if-older-than <time>` | Forzar backup completo tras X tiempo |
| `--remove-older-than <time>` | Eliminar backups antiguos |
| `--encrypt-key <KEY>` | Clave GPG para cifrar |
| `--sign-key <KEY>` | Clave GPG para firmar |
| `--asynchronous-upload` | Subir en segundo plano |
| `--volsize <MB>` | Tamaño de volumen (por defecto 25 MB) |
| `--exclude <pattern>` | Excluir archivos/patrones |
| `--include <pattern>` | Incluir solo estos archivos |
| `--dry-run` | Simular sin ejecutar |
| `--verbosity <n>` | Nivel de detalle (0-9) |

## Ejemplos

```bash
# Backup completo a disco local (cifrado con GPG)
duplicity /home/usuario/Documentos/ file:///mnt/backup/duplicity/

# Backup incremental (duplicity detecta automáticamente)
duplicity /home/usuario/Documentos/ file:///mnt/backup/duplicity/

# Backup remoto vía SSH
duplicity /home/usuario/Documentos/ scp://usuario@servidor/backups/

# Backup completo forzado cada 30 días
duplicity --full-if-older-than 30D \
  /home/usuario/ file:///mnt/backup/

# Listar backups disponibles
duplicity collection-status file:///mnt/backup/duplicity/

# Restaurar todo
duplicity file:///mnt/backup/duplicity/ /tmp/restore

# Restaurar archivo específico
duplicity --file-to-restore Documentos/importante.pdf \
  file:///mnt/backup/duplicity/ /tmp/restore/

# Eliminar backups antiguos (>30 días)
duplicity remove-older-than 30D file:///mnt/backup/duplicity/ --force

# Backup a Amazon S3
duplicity /home/usuario/ s3+https://s3.amazonaws.com/my-bucket/

# Backup con exclusiones
duplicity --exclude '**/.cache' --exclude '**/node_modules' \
  /home/usuario/ file:///mnt/backup/

# Verificar integridad
duplicity verify file:///mnt/backup/ /home/usuario/
```

## Cifrado con clave GPG

```bash
# Usar una clave GPG específica
export PASSPHRASE="tu-frase"
export SIGN_PASSPHRASE="tu-frase-de-firma"
export GPG_KEY="ID_DE_TU_CLAVE_GPG"

duplicity --encrypt-key $GPG_KEY --sign-key $GPG_KEY \
  /home/usuario/ scp://usuario@servidor/backups/

# Cifrado simétrico (contraseña, sin clave asym)
export PASSPHRASE="mi-contraseña-segura"
duplicity /home/usuario/ file:///mnt/backup/

# Importar clave pública para restaurar en otro equipo
gpg --import public-key.asc
duplicity restore file:///backup/ /restauracion/
```

## Automatización con cron

```bash
# Backup diario a las 2:00 AM
0 2 * * * PASSPHRASE="..." duplicity --full-if-older-than 30D \
  /home/usuario/ s3+https://s3.amazonaws.com/my-bucket/ \
  >> /var/log/duplicity.log 2>&1

# Limpieza semanal (domingos a las 4:00 AM)
0 4 * * 0 PASSPHRASE="..." duplicity remove-older-than 60D \
  s3+https://s3.amazonaws.com/my-bucket/ --force
```

## Comparativa con alternativas

| Aspecto | duplicity | borg | restic | rsync |
|---|---|---|---|---|
| **Cifrado** | ✅ GPG | ✅ AES-256 | ✅ AES-256 | ❌ (solo SSH) |
| **Deduplicación** | ❌ | ✅ | ✅ | ❌ |
| **Compresión** | ❌ | ✅ LZ4/ZSTD | ✅ | ❌ |
| **Incremental** | ✅ diffs | ✅ bloques | ✅ bloques | ✅ diffs |
| **Destinos** | SSH, S3, FTP, Swift | SSH, S3, local | SSH, S3, restic-server, local | SSH, local |
| **Velocidad** | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Madurez** | Desde 2002 | Desde 2010 | Desde 2015 | Desde 1996 |
| **Ideal para** | Servidores legacy, S3 | Deduplicación máxima | Multi-destino | Sincronización simple |

> **Regla práctica**: si empiezas un proyecto nuevo, usa **borg** o **restic** (deduplicación + compresión = ahorra 50-80% de espacio). Si ya tienes duplicity funcionando y no tienes problemas, no hay urgencia en migrar.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `gpg: decryption failed: No secret key` | Falta la clave GPG privada | Importar la clave: `gpg --import private-key.asc` |
| `PASSPHRASE variable not set` | Variable de entorno no exportada | `export PASSPHRASE="..."` antes de ejecutar |
| Backup incremental muy lento | Muchos archivos pequeños | Aumentar `--volsize` o usar `--asynchronous-upload` |
| `Wrong number of arguments` | Sintaxis incorrecta | Verificar: `duplicity <opciones> <fuente> <destino>` |
| Espacio crece sin límite | No se ejecuta `remove-older-than` | Añadir limpieza periódica al cron |
| Error de conexión SSH | SSH key no configurada | Verificar `ssh-copy-id` y `~/.ssh/config` |
| Restaurar sin duplicity | Archivos GPG individuales | Descifrar manualmente: `gpg -d archivo.gpg > archivo` |

## Enlaces externos

- [Sitio oficial — duplicity](https://duplicity.gitlab.io/)
- [Wikipedia — duplicity](https://en.wikipedia.org/wiki/Duplicity_(software))
- [Arch Wiki — duplicity](https://wiki.archlinux.org/title/Duplicity)
- [Manual completo](https://duplicity.gitlab.io/stable/duplicity.1.html)

## Ver también

- [[borg]] — backup deduplicado más eficiente en espacio
- [[restic]] — backup rápido con múltiples destinos cloud
- [[Backups (borg restic duplicity rsync)]] — índice comparativo y estrategia 3-2-1
- [[Cifrado (LUKS dm-crypt GPG)]] — GPG para cifrado
- [[rsync]] — sincronización de archivos

#programa #backup
