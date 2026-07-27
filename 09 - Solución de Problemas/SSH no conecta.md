---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: troubleshooting
sistema: SSH
prioridad: baja
---

# SSH Connection refused / no se puede conectar

> Error `Connection refused` al intentar conectar por SSH a un servidor. El servidor no está aceptando conexiones en el puerto SSH, o hay un firewall/bloqueo de por medio.

## Síntoma

```bash
ssh usuario@servidor
# ssh: connect to host servidor port 22: Connection refused
# O: connection timed out
# O: Permission denied (publickey)
```

| Error | Significado |
|---|---|
| `Connection refused` | El puerto está cerrado o no hay servicio escuchando |
| `Connection timed out` | El host no es alcanzable (firewall, red caída, IP incorrecta) |
| `Permission denied (publickey)` | Autenticación fallida (clave incorrecta o no autorizada) |
| `Host key verification failed` | La clave del host remoto cambió (reinstalación o MITM) |
| `Too many authentication failures` | Claves incorrectas enviadas muchas veces |
| `Connection closed by remote host` | El servidor cerró la conexión (config sshd denegando acceso) |

## Diagnóstico

```bash
# 1. ¿El host es alcanzable?
ping -c 3 servidor                          # conectividad básica
# Si no responde → problema de red, no de SSH

# 2. ¿El puerto está abierto desde tu máquina?
nc -zv servidor 22                          # netcat: probar puerto 22
nmap -p 22 servidor                         # nmap: escaneo de puerto
# Si muestra "filtered" → firewall bloqueando
# Si muestra "closed" → SSH no está escuchando

# 3. ¿El servicio SSH está corriendo en el servidor?
# (desde el servidor mismo o con acceso a su terminal)
systemctl status sshd                       # status del servicio
ss -tulpn | grep :22                        # ¿algo escucha en puerto 22?
journalctl -u sshd -n 30                    # últimos logs de SSH

# 4. ¿El puerto es el correcto?
# Quizás el servidor usa un puerto no estándar (ej. 2222)
ssh -p 2222 usuario@servidor
```

## Causa

1. **Servicio SSH no instalado o no iniciado** — `sshd` no corre, o no está habilitado.
2. **Firewall bloqueando el puerto 22** — `ufw`, `firewalld`, `iptables`, o un firewall externo.
3. **SSH configurado en puerto no estándar** — el servidor usa puerto 2222 y tú intentas 22.
4. **IP incorrecta o hostname mal resuelto** — estás conectando a la máquina equivocada.
5. **Clave pública no autorizada** — `~/.ssh/authorized_keys` no contiene tu clave.
6. **Denegación explícita en sshd_config** — `AllowUsers`, `DenyUsers`, o `PermitRootLogin no` bloquean tu usuario.
7. **Host key cambiada** — el servidor se reinstaló y generó nuevas claves de host.

## Solución

### 1. Servicio SSH no instalado/no iniciado

```bash
# En el servidor (físicamente o por consola remota):
sudo systemctl enable --now sshd             # Debian/Ubuntu: ssh (no sshd)
sudo systemctl enable --now ssh              # Debian/Ubuntu

# Instalar si no existe
sudo apt install openssh-server              # Debian/Ubuntu
sudo pacman -S openssh                       # Arch
sudo dnf install openssh-server              # Fedora
```

### 2. Firewall bloqueando

```bash
# Verificar estado del firewall
sudo ufw status                              # ufw
sudo firewall-cmd --list-all                 # firewalld
sudo iptables -L -n | grep :22               # iptables

# Abrir puerto SSH
sudo ufw allow ssh                           # ufw (permite puerto 22)
sudo ufw allow 2222/tcp                      # puerto personalizado
sudo firewall-cmd --permanent --add-service=ssh  # firewalld
sudo firewall-cmd --reload

# Si es firewall externo (VPS, cloud): revisar Security Groups / firewall del proveedor
```

### 3. Verificar ip/hostname y resolución DNS

```bash
# ¿La IP es correcta?
dig servidor +short                          # qué IP resuelve
getent hosts servidor                        # búsqueda en /etc/hosts + DNS

# ¿El hostname local del servidor es correcto?
hostnamectl                                  # hostname actual en el servidor
cat /etc/hostname
```

### 4. Solucionar "Host key verification failed"

```bash
# La clave del servidor cambió (común tras reinstalar):
ssh-keygen -R servidor                       # eliminar la clave vieja del known_hosts
# En ~/.ssh/known_hosts se borra la línea de ese servidor
ssh usuario@servidor                         # aceptar la nueva clave

# Verificación manual:
ssh-keyscan -H servidor >> ~/.ssh/known_hosts  # preaceptar clave
```

### 5. Forzar autenticación con clave específica

```bash
# Usar una clave concreta (si tienes varias)
ssh -i ~/.ssh/id_ed25519 usuario@servidor

# Debugging detallado (verbose)
ssh -vvv usuario@servidor                    # muestra cada paso de la conexión
# Buscar líneas como:
# - debug1: Authentications that can continue: publickey
# - debug1: Offering public key: ... (indica qué claves ofrece)
# - debug1: Authentication succeeded (publickey)
```

### 6. Verificar authorized_keys

```bash
# En el servidor:
cat ~/.ssh/authorized_keys                   # ¿contiene tu clave pública?
ls -la ~/.ssh/                               # permisos correctos?
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_ed25519                  # clave privada
chmod 644 ~/.ssh/id_ed25519.pub              # clave pública
```

### 7. Solucionar "Too many authentication failures"

```bash
# SSH envía todas tus claves, y si el servidor las rechaza, cierra tras N intentos
# Solución: especificar la clave exacta
ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519 usuario@servidor

# O en ~/.ssh/config:
# Host servidor
#     IdentitiesOnly yes
#     IdentityFile ~/.ssh/id_ed25519
```

## Verificación

```bash
# Conexión exitosa:
ssh usuario@servidor "echo 'SSH funciona correctamente'"

# Puerto abierto desde fuera (probar desde otra máquina):
nc -zv servidor 22
```

## Prevención

- Configurar `ServerAliveInterval` en `~/.ssh/config` para evitar timeouts
- Usar `sudo systemctl enable sshd` para que SSH arranque siempre al inicio
- Si cambias el puerto SSH, documentarlo (o ponerlo en `~/.ssh/config`)
- Mantener el servidor actualizado: `sudo apt upgrade` regularmente
- Monitorear intentos fallidos: `journalctl -u sshd | grep "Failed password"`

## Enlaces externos

- [Arch Wiki — SSH](https://wiki.archlinux.org/title/SSH)
- [Ubuntu Help — SSH](https://help.ubuntu.com/community/SSH)
- [OpenSSH Manual](https://www.openssh.com/manual.html)

## Ver también

- [[SSH]] — comando detallado
- [[Firewall]] — ufw, firewalld, iptables
- [[Redes Basicas]] — diagnóstico de conectividad
- [[nc]] — netcat para probar puertos

#troubleshooting
