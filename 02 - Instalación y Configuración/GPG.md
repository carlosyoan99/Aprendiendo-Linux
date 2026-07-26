---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: instalacion
prioridad: alta
---

# GPG — Cifrado de archivos y firmas

GPG (GNU Privacy Guard) implementa el estándar OpenPGP para cifrado asimétrico y simétrico, firmas digitales y verificación.

## Cifrado simétrico (una contraseña)

```bash
gpg --symmetric --cipher-algo AES256 documento.pdf   # cifrar
# → documento.pdf.gpg

gpg documento.pdf.gpg                                  # descifrar
gpg --decrypt documento.pdf.gpg > documento.pdf
```

## Cifrado asimétrico (clave pública/privada)

```bash
# 1. Generar par de claves
gpg --full-generate-key
#   Tipo: RSA 4096 o Ed25519

# 2. Listar claves
gpg --list-keys                         # públicas
gpg --list-secret-keys                  # privadas

# 3. Exportar clave pública
gpg --export --armor usuario@email.com > mi-clave-publica.asc

# 4. Importar clave recibida
gpg --import clave-de-alguien.asc

# 5. Cifrar para un destinatario
gpg --encrypt --recipient destinatario@email.com documento.pdf

# 6. Firmar
gpg --sign documento.pdf                # firma + archivo
gpg --detach-sign documento.pdf         # firma separada (.sig)
gpg --clearsign documento.txt           # firma visible (texto)

# 7. Verificar firma
gpg --verify documento.pdf.sig documento.pdf

# 8. Cifrar y firmar
gpg --encrypt --sign --recipient destinatario@email.com documento.pdf
```

## Backup cifrado

```bash
tar czf - /ruta/a/backup/ | gpg --symmetric --cipher-algo AES256 > backup.tar.gz.gpg
gpg --decrypt backup.tar.gz.gpg | tar xzf -
```

## Revocar una clave

```bash
gpg --gen-revoke usuario@email.com > revocacion.asc
gpg --import revocacion.asc
```

## Buenas prácticas

- ✅ Proteger la clave privada con frase fuerte
- ✅ Configurar caducidad (2 años, renovable)
- ❌ No compartir la clave privada
- ❌ No usar frases cortas o predecibles

## Ver también

- [[LUKS]] — cifrado de disco completo
- [[Cifrado (LUKS dm-crypt GPG)]] — índice + comparativa
- [[SSH]] — GPG se usa para firmar claves SSH
- [[Gestores de Paquetes]] — GPG verifica firmas de paquetes

## Enlaces externos

- [Wikipedia — GNU Privacy Guard](https://en.wikipedia.org/wiki/GNU_Privacy_Guard)
- [GPG oficial](https://gnupg.org/)

#cifrado #seguridad
