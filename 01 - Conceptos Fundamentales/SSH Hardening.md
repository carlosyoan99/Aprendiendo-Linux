---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: concepto
prioridad: alta
---

# SSH Hardening

> Configuración práctica para asegurar un servidor SSH: desde autenticación por clave hasta fail2ban, port knocking y certificates SSH. Incluye checklist completo y configuración copiable.

## ¿Qué es SSH Hardening?

SSH (OpenSSH) es la forma estándar de acceder remotamente a servidores Linux. Un SSH sin endurecer es una puerta abierta: bots escanean el puerto 22 constantemente, probando contraseñas débiles. SSH Hardening consiste en cerrar todas las vías de acceso no deseadas manteniendo la funcionalidad remota.

---

## Checklist rápido

```bash
# Ejecutar esta lista de verificación en tu servidor:
echo "=== SSH Hardening Checklist ==="
echo "1. ¿Puerto 22 cambiado?  $(grep '^Port ' /etc/ssh/sshd_config 2>/dev/null || echo 'NO')"
echo "2. ¿Root login deshabilitado?  $(grep '^PermitRootLogin no' /etc/ssh/sshd_config 2>/dev/null && echo 'OK' || echo 'NO')"
echo "3. ¿Solo claves?  $(grep '^PasswordAuthentication no' /etc/ssh/sshd_config 2>/dev/null && echo 'OK' || echo 'NO')"
echo "4. ¿Protocolo 2?  $(grep '^Protocol 2' /etc/ssh/sshd_config 2>/dev/null && echo 'OK' || echo 'NO (implícito en OpenSSH 7.4+)')"
echo "5. ¿MaxAuthTries bajo?  $(grep '^MaxAuthTries' /etc/ssh/sshd_config 2>/dev/null || echo 'Default: 6')"
echo "6. ¿Users/Groups restringidos?  $(grep -E '^AllowUsers|^AllowGroups' /etc/ssh/sshd_config 2>/dev/null && echo 'OK' || echo 'NO')"
echo "7. ¿X11 forwarding deshabilitado?  $(grep '^X11Forwarding no' /etc/ssh/sshd_config 2>/dev/null && echo 'OK' || echo 'NO')"
echo "8. ¿fail2ban activo?  $(systemctl is-active fail2ban 2>/dev/null || echo 'NO')"
```

---

## 1. Cambiar el puerto SSH

```bash
# Editar /etc/ssh/sshd_config
sudo nano /etc/ssh/sshd_config

# Cambiar:
# Port 22
# A:
Port 2222                    # o cualquier puerto > 1024

# ⚠️ ANTES de reiniciar sshd, abrir el nuevo puerto en el firewall:
sudo ufw allow 2222/tcp      # si usas UFW
sudo nft add rule inet filter input tcp dport 2222 accept  # si usas nftables
sudo firewall-cmd --add-port=2222/tcp --permanent && sudo firewall-cmd --reload  # firewalld

# Reiniciar sshd
sudo systemctl restart sshd

# Verificar que funciona ANTES de cerrar la sesión actual
ssh -p 2222 usuario@servidor
```

---

## 2. Deshabilitar login como root

```bash
# En /etc/ssh/sshd_config:
PermitRootLogin no           # prohíbe login directo como root

# Alternativa más flexible:
PermitRootLogin prohibit-password  # permite root solo con clave (no contraseña)

# Reiniciar
sudo systemctl restart sshd
```

---

## 3. Autenticación por clave (obligatoria)

```bash
# --- En el cliente (tu máquina local) ---

# Generar par de claves (Ed25519, más seguro que RSA)
ssh-keygen -t ed25519 -C "tu@email.com"
# O RSA si necesitas compatibilidad:
ssh-keygen -t rsa -b 4096 -C "tu@email.com"

# Copiar clave pública al servidor
ssh-copy-id -p 2222 usuario@servidor

# Verificar que funciona
ssh -p 2222 usuario@servidor
# Debe pedir la passphrase de la clave, NO la contraseña del usuario

# --- En el servidor ---

# En /etc/ssh/sshd_config:
PubkeyAuthentication yes
PasswordAuthentication no        # deshabilitar login por contraseña
ChallengeResponseAuthentication no
UsePAM yes                       # mantener PAM para otros servicios

# ⚠️ IMPORTANTE: verificar que la clave funciona ANTES de deshabilitar contraseñas
# Abrir una NUEVA terminal y probar:
ssh -p 2222 usuario@servidor
# Si funciona, cerrar la sesión antigua
# Si NO funciona, poder arreglar desde la sesión activa

sudo systemctl restart sshd
```

---

## 4. Configuración completa del servidor

```bash
# /etc/ssh/sshd_config — configuración completa recomendada

# Puerto y protocolo
Port 2222
Protocol 2

# Autenticación
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
ChallengeResponseAuthentication no
AuthenticationMethods publickey
MaxAuthTries 3
MaxSessions 5
LoginGraceTime 30

# Restringir usuarios/grupos
AllowUsers admin deployer
# O por grupo:
AllowGroups ssh-users admins

# Desactivar features innecesarias
X11Forwarding no
AllowAgentForwarding no
AllowTcpForwarding no
PermitTunnel no
GatewayPorts no
PermitUserEnvironment no

# Criptografía (OpenSSH 9.0+)
KexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com

# Logging
SyslogFacility AUTH
LogLevel VERBOSE

# Timeouts
ClientAliveInterval 300
ClientAliveCountMax 2
TCPKeepAlive no

# Banner
Banner /etc/ssh/banner.txt
```

---

## 5. SSH Certificate Authority (para equipos)

```bash
# SSH certs reemplazan authorized_keys con una CA firmante
# Útil para equipos con muchos servidores

# --- Crear la CA ---
ssh-keygen -t ed25519 -f /etc/ssh/ca_user_key -C "ssh-ca-user"

# --- Firmar una clave de usuario ---
ssh-keygen -s /etc/ssh/ca_user_key -I "carlos-2026" -n carlos ~/.ssh/id_ed25519.pub
# Genera: id_ed25519-cert.pub (la clave firmada)

# --- En el servidor, confiar en la CA ---
# En /etc/ssh/sshd_config:
TrustedUserCAKeys /etc/ssh/ca_user_key.pub

# --- Opcional: restrict keys con opciones ---
ssh-keygen -s /etc/ssh/ca_user_key -I "carlos-limitado" \
  -n carlos -O "from=192.168.1.0/24" \
  -O "command=/usr/bin/validate-command" \
  ~/.ssh/id_ed25519.pub
```

---

## 6. Fail2Ban para SSH

```bash
# Instalar fail2ban
sudo apt install fail2ban        # Debian/Ubuntu
sudo pacman -S fail2ban           # Arch

# Configurar para SSH
sudo tee /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3
backend = systemd

[sshd]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 86400
EOF

# Iniciar
sudo systemctl enable --now fail2ban

# Ver estado
sudo fail2ban-client status sshd
# Ver IPs baneadas
sudo fail2ban-client status sshd | grep "Banned"
```

---

## 7. Port knocking (ocultar el puerto)

```bash
# El puerto SSH no está abierto hasta que el cliente "toca" una secuencia de puertos

# Servidor:
sudo apt install knockd

# /etc/knockd.conf:
[openSSH]
    sequence    = 7000,8000,9000
    seq_timeout = 10
    command     = /sbin/iptables -A INPUT -s %IP% -p tcp --dport 2222 -j ACCEPT
    tcpflags    = syn

[closeSSH]
    sequence    = 9000,8000,7000
    seq_timeout = 10
    command     = /sbin/iptables -D INPUT -s %IP% -p tcp --dport 2222 -j ACCEPT
    tcpflags    = syn

# Cliente:
knock -p 7000,8000,9000 servidor 7000 8000 9000
ssh -p 2222 usuario@servidor
# Para cerrar:
knock -p 7000,8000,9000 servidor 9000 8000 7000
```

---

## 8. SSH tunneling seguro (Port Forwarding)

```bash
# Local forward: acceder a servicio remoto desde local
ssh -L 8080:localhost:80 usuario@servidor
# Ahora http://localhost:8080 → servidor:80

# Remote forward: exponer servicio local al servidor
ssh -R 3000:localhost:3000 usuario@servidor
# Ahora servidor:3000 → tu máquina:3000

# Dynamic forward (SOCKS proxy):
ssh -D 1080 usuario@servidor
# Configurar navegador para usar SOCKS5 proxy en localhost:1080
```

---

## 9. SSH Config del cliente (~/.ssh/config)

```
# ~/.ssh/config — configuración del cliente

Host servidor-produccion
    HostName 192.168.1.100
    Port 2222
    User admin
    IdentityFile ~/.ssh/id_ed25519
    ForwardAgent no
    AddKeysToAgent yes
    IdentitiesOnly yes

Host servidor-staging
    HostName staging.ejemplo.com
    Port 2222
    User deployer
    IdentityFile ~/.ssh/id_ed25519_staging
    ProxyJump servidor-produccion     # saltar por producción

# Para todo host no definido:
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    AddKeysToAgent yes
    HashKnownHosts yes
```

---

## 10. Auditoría y monitoreo

```bash
# Ver quiénes se conectaron
last -i | head -20                    # historial de logins
who                                   # quién está conectado ahora

# Ver intentos fallidos
journalctl -u sshd | grep -i "failed\|invalid\|refused" | tail -20
sudo grep "Failed password" /var/log/auth.log | tail -20

# Verificar que no hay usuarios no autorizados
grep "^AuthorizedKeysFile" /etc/ssh/sshd_config
for user in $(cut -d: -f1 /etc/passwd); do
  keys=$(cat /home/$user/.ssh/authorized_keys 2>/dev/null | wc -l)
  echo "$user: $keys keys"
done

# Verificar integridad del sshd_config
sudo sshd -T | grep -E "port|permitrootlogin|passwordauthentication|pubkeyauthentication"
```

---

## Comparativa de métodos de hardening

| Método | Seguridad | Complejidad | Mantenimiento |
|---|---|---|---|
| **Cambiar puerto** | Baja (obfuscation) | Muy fácil | Ninguno |
| **Solo claves** | Alta | Fácil | Baja |
| **Fail2Ban** | Alta | Fácil | Baja |
| **AllowUsers** | Media | Fácil | Media |
| **Port knocking** | Media-Alta | Media | Media |
| **SSH Certificates** | Muy alta | Alta | Media |
| **Todos combinados** | Máxima | Media | Media |

**Recomendación mínima**: claves + fail2ban + AllowUsers
**Recomendación completa**: todos los anteriores + SSH certs + port knocking

---

## Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `Permission denied (publickey)` | Clave no copiada o permisos incorrectos | `chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys` |
| `Connection refused` tras cambio de puerto | Firewall no actualizado | Abrir nuevo puerto en UFW/nftables ANTES de reiniciar sshd |
| No puedo entrar como root | `PermitRootLogin no` | Usar usuario normal + `sudo`, o `su -` |
| SSH lento al conectar | DNS resolution timeout | En sshd_config: `UseDNS no` |
| `Too many authentication failures` | Muchas claves en el cliente | `IdentitiesOnly yes` en ~/.ssh/config |

---

## Ver también

- [[SSH no conecta]] — troubleshooting de conexión SSH
- [[sshfs]] — montaje remoto vía SSH
- [[Seguridad en Linux (Guía completa)]] — guía general de seguridad
- [[nftables]] — firewall moderno
- [[ufw]] — firewall simplificado
- [[fail2ban]] — protección contra brute force

#seguridad #ssh #redes #servidor
