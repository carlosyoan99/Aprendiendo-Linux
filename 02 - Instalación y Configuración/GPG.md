---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-27
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

## Subclaves (buena práctica de seguridad)

En lugar de usar la clave maestra para todo, se generan **subclaves** independientes para cada operación (firmar, cifrar, autenticar). La clave maestra se guarda offline.

```bash
# Editar clave maestra
gpg --edit-key usuario@email.com

# Dentro de --edit-key
gpg> addkey
# Elegir tipo: 4 (RSA sign only), 6 (RSA encrypt only), 8 (RSA auth only)
gpg> key 1              # seleccionar la subclave 1
gpg> keytocard          # moverla a una YubiKey (opcional)
gpg> save

# Ver estructura de claves
gpg --list-keys --keyid-format LONG
#   pub   ed25519/AAAA...AAA 2026-01-01  [C]           ← clave maestra (Certify)
#   sub   ed25519/BBBB...BBB 2026-01-01  [S]           ← subclave de firma (Sign)
#   sub   cv25519/CCCC...CCC 2026-01-01  [E]           ← subclave de cifrado (Encrypt)
#   sub   ed25519/DDDD...DDD 2026-01-01  [A]           ← subclave de autenticación (Auth)

# Exportar solo subclave pública (sin clave maestra)
gpg --export --armor usuario@email.com > clave-con-subclaves.asc
```

### Backup de clave maestra (offline)

```bash
# Exportar clave privada maestra
gpg --export-secret-keys --armor usuario@email.com > master-key-backup.asc

# Exportar subclaves privadas (para uso diario)
gpg --export-secret-subkeys --armor usuario@email.com > subkeys-backup.asc

# Eliminar clave maestra del llavero diario (dejar solo subclaves)
gpg --delete-secret-key usuario@email.com
gpg --import subkeys-backup.asc   # importar solo subclaves
```

> **Recomendación**: Guardar la clave maestra en un USB cifrado fuera de línea. Las subclaves se pueden revocar independientemente si se comprometen.

## Web of Trust

GPG no usa autoridades centrales (CAs). En su lugar, las personas **firman** las claves de otras para validar su identidad, formando una red de confianza descentralizada.

```bash
# Firmar una clave (verificando identidad antes)
gpg --sign-key clave-de-alguien.asc

# Establecer nivel de confianza
gpg --edit-key clave-de-alguien.asc
gpg> trust
#   1 = No sé / 2 = Nunca confío / 3 = Marginal / 4 = Completo / 5 = Último

# Verificar cadena de firmas
gpg --list-sigs usuario@email.com

# Buscar clave pública en keyserver
gpg --keyserver hkps://keys.openpgp.org --search-keys usuario@email.com

# Enviar clave pública a keyserver
gpg --keyserver hkps://keys.openpgp.org --send-keys ID_DE_CLAVE

# Actualizar firmas de todas las claves del llavero
gpg --refresh-keys
```

## Firmar commits de Git

GPG permite firmar commits y tags, garantizando que realmente vienen de ti.

```bash
# Configurar Git para usar tu clave
git config --global user.signingkey ID_DE_SUBCLAVE     # la subclave [S]
git config --global commit.gpgsign true                # firmar todos los commits

# Firmar un commit específico
git commit -S -m "feat: mensaje firmado"

# Firmar un tag
git tag -s v1.0 -m "Versión 1.0 firmada"

# Verificar firmas en el historial
git log --show-signature

# Verificar un tag firmado
git tag -v v1.0
```

### Mostrar firma en GitHub

```bash
# Exportar clave pública
gpg --armor --export ID_DE_CLAVE

# Ir a GitHub → Settings → SSH and GPG keys → New GPG key
# Pegar la clave pública
```

## GPG como agente SSH

GPG puede actuar como agente SSH, reemplazando a `ssh-agent` y permitiendo usar la misma clave GPG para SSH.

```bash
# Configurar gpg-agent para SSH
echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf
echo "write-env-file /home/$USER/.gnupg/gpg-agent-info" >> ~/.gnupg/gpg-agent.conf

# En ~/.bashrc o ~/.zshrc
export GPG_TTY=$(tty)
unset SSH_AGENT_PID
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Añadir la subclave de autenticación [A]
gpg --edit-key usuario@email.com
gpg> addkey
# Elegir tipo 8 (RSA set your own capabilities) y marcar solo Authenticate

# Verificar que SSH reconoce la clave
ssh-add -l
```

## YubiKey / Smartcards

Las tarjetas inteligentes (como YubiKey) almacenan las subclaves en hardware, haciéndolas no exportables.

```bash
# Verificar que el sistema reconoce la YubiKey
gpg --card-status

# Mover subclaves a la tarjeta
gpg --edit-key usuario@email.com
gpg> key 1              # seleccionar subclave
gpg> keytocard          # mover a la tarjeta (firma / cifrado / autenticación)
gpg> save

# Una vez movidas, las subclaves ya NO existen en el llavero local:
gpg --list-secret-keys  # muestra 'sec#' (clave maestra no disponible)
                        # y 'ssb>' (subclave en tarjeta, > indica smartcard)

# Firmar usando la YubiKey (pide toque físico o PIN)
echo "test" | gpg --clearsign
```

> **Referencia**: La guía definitiva de drduh: [github.com/drduh/yubikey-guide](https://github.com/drduh/yubikey-guide)

## Cifrado híbrido

GPG no cifra archivos grandes directamente con RSA/ECC — sería muy lento. Usa cifrado **híbrido**:

1. Genera una **clave de sesión** (AES256) aleatoria
2. Cifra el archivo con esa clave de sesión (rápido)
3. Cifra la clave de sesión con tu clave pública RSA/ECC
4. El resultado contiene ambos cifrados

```
Archivo original
      ↓
  [Clave sesión AES] → cifra archivo → archivo.gpg
      ↓
  [Tu clave pública] → cifra clave sesión → se añade al archivo.gpg
```

```bash
# El usuario solo ve esto:
gpg --encrypt --recipient destinatario@email.com archivo.pdf
# GPG maneja el híbrido automáticamente
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

# Enviar revocación al keyserver
gpg --keyserver hkps://keys.openpgp.org --send-keys ID_DE_CLAVE
```

## Buenas prácticas

- ✅ Guardar clave maestra offline (USB cifrado)
- ✅ Usar subclaves separadas para firmar, cifrar y autenticar
- ✅ Configurar caducidad (2 años, renovable)
- ✅ Hacer un certificado de revocación y guardarlo fuera del sistema
- ✅ Proteger la clave privada con frase fuerte
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
- [drduh YubiKey Guide](https://github.com/drduh/yubikey-guide)
- [Keys.openpgp.org](https://keys.openpgp.org/)

#cifrado #seguridad
