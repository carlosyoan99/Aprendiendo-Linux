---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# SSH

## Sintaxis
```
ssh usuario@host [-p puerto] [-i clave] [-L/-R/-D túneles]
```

## Descripción

Protocolo y comando para conectarse de forma segura (cifrada) a otra máquina por terminal. Es la base de la administración remota de servidores, transferencia de archivos (scp, sftp), túneles y forwarding.

## Opciones frecuentes

| Flag | Efecto |
|------|--------|
| `-p` | Puerto (default 22) |
| `-i` | Ruta a una clave privada específica |
| `-L` | Local port forwarding (túnel desde tu máquina al destino) |
| `-R` | Remote port forwarding (túnel desde el servidor hacia ti) |
| `-D` | Dynamic port forwarding (SOCKS proxy) |
| `-J` | ProxyJump: saltar vía un host intermedio |
| `-A` | Forward del agente SSH (permiso para usar tus claves desde el host remoto) |
| `-N` | No ejecutar comandos, solo establecer túnel |
| `-v` | Modo verbose (útil para debugging) |
| `-C` | Comprimir datos (útil en conexiones lentas) |
| `-o` | Opción en formato `Clave=Valor` (para opciones sin flag específico) |

## Autenticación por clave (sin contraseña)

```bash
# 1. Generar par de claves (ed25519 es más seguro y rápido que RSA)
ssh-keygen -t ed25519 -C "mi-equipo"          # -C es un comentario opcional
ssh-keygen -t rsa -b 4096                      # alternativa RSA si el servidor es viejo

# 2. Copiar la clave pública al servidor
ssh-copy-id -i ~/.ssh/id_ed25519.pub usuario@host
# Esto agrega tu clave a ~/.ssh/authorized_keys en el servidor

# 3. A partir de ahora ya no pide contraseña
ssh usuario@host
```

```bash
# Si no tienes ssh-copy-id, hazlo manual:
cat ~/.ssh/id_ed25519.pub | ssh usuario@host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### Gestión de claves

```bash
# Ver huellas digitales de tus claves
ssh-keygen -l -f ~/.ssh/id_ed25519          # fingerprint
ssh-keygen -lv -f ~/.ssh/id_ed25519         # + imagen ASCII (para verificar visualmente)

# Cambiar contraseña de una clave privada
ssh-keygen -p -f ~/.ssh/id_ed25519

# ssh-agent (recordar la clave en sesión actual)
eval "$(ssh-agent -s)"                       # iniciar agente
ssh-add ~/.ssh/id_ed25519                    # agregar clave (pedirá passphrase una vez)
ssh-add -l                                   # listar claves cargadas
ssh-add -d ~/.ssh/id_ed25519                 # eliminar clave del agente
```

## Túneles SSH (Port Forwarding)

### Local (`-L`): exponer un puerto remoto en tu máquina local

```bash
# El servidor remoto tiene un servicio en localhost:8080 (ej. una web interna)
# Quieres acceder desde tu navegador local en http://localhost:9090
ssh -L 9090:localhost:8080 usuario@servidor

# También puedes redirigir a otra máquina desde el servidor:
# El servidor puede alcanzar 10.0.0.5:5432, tú no
ssh -L 65432:10.0.0.5:5432 usuario@servidor
# Ahora conectarte a localhost:65432 te lleva a 10.0.0.5:5432 vía el servidor
```

### Remoto (`-R`): exponer un puerto local en el servidor remoto

```bash
# Tu máquina local tiene un servicio en el puerto 3000
# Quieres que el servidor remoto pueda accederlo en localhost:3000
ssh -R 3000:localhost:3000 usuario@servidor
# Útil para: mostrar un servidor de desarrollo local a alguien que solo accede al servidor
```

### Dinámico (`-D`): SOCKS proxy

```bash
# Crea un proxy SOCKS5 en tu máquina. Todo el tráfico que pase por él
# saldrá a internet desde el servidor remoto
ssh -D 1080 usuario@servidor
# Configurar navegador → proxy SOCKS5 → localhost:1080
# Útil para: navegar como si estuvieras en otra red (ej. desde el trabajo hacia tu casa)
```

## Archivo de configuración (~/.ssh/config)

En lugar de escribir `ssh -p 2222 -i ~/.ssh/server.key -J jump.example.com usuario@host ejemplo.com`, define perfiles:

```sshconfig
# ~/.ssh/config

# Configuración global
Host *
    ServerAliveInterval 60                 # mantener conexión activa
    ServerAliveCountMax 3
    Compression yes

# Servidor personal (atajo: "ssh server")
Host server
    HostName 192.168.1.100
    User carlos
    Port 22
    IdentityFile ~/.ssh/id_ed25519

# Servidor con jump host (atajo: "ssh interno")
Host interno
    HostName 10.0.0.50
    User admin
    Port 2222
    ProxyJump server                       # primero ssh a server, desde ahí a 10.0.0.50
    IdentityFile ~/.ssh/id_ed25519

# GitHub con clave específica
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github
```

```bash
# Ahora en lugar de:
ssh -p 2222 -i ~/.ssh/server.key -J jump.example.com admin@10.0.0.50

# Solo escribes:
ssh interno

# Y para GitHub:
ssh -T git@github.com                     # prueba de conexión
```

## ProxyJump (`-J`): saltar entre hosts

```bash
# Tu máquina NO puede ver el servidor final directamente,
# pero puede ver un host intermedio (bastion/jump host)
ssh -J usuario@bastion usuario@servidor-final

# Múltiples saltos:
ssh -J usuario@host1,usuario@host2,usuario@host3 usuario@final

# Equivalente a:
ssh -o ProxyJump=usuario@bastion usuario@servidor-final
```

## Agent Forwarding (`-A`)

```bash
# Si tienes tus claves cargadas en ssh-agent, con -A el host remoto
# puede usar TUS claves como si fueran locales (para hacer git push, etc.)
ssh -A usuario@servidor

# ⚠️  Seguridad: no uses -A si no confías en el admin del servidor
# El usuario root del servidor podría usar tus claves sin que lo sepas
# Alternativa más segura: ProxyJump o añadir tu clave pública al host final
```

## Transferencia de archivos

### scp (simple, un solo archivo)

```bash
# Subir
scp archivo.txt usuario@host:/ruta/destino/
scp -r carpeta/ usuario@host:/ruta/destino/   # recursivo (directorios)

# Bajar
scp usuario@host:/ruta/remoto/archivo.txt ./

# Entre dos hosts remotos (el tráfico pasa por tu máquina)
scp usuario1@host1:/archivo.txt usuario2@host2:/

# Usar un perfil del config
scp archivo.txt server:~/                     # si definiste "Host server" en el config
```

### sftp (interactivo, múltiples archivos)

```bash
sftp usuario@host
# Comandos dentro de sftp:
# ls, cd, pwd  → navegar en el remoto
# lls, lcd, lpwd → navegar en local
# get archivo.txt  → bajar archivo
# put archivo.txt  → subir archivo
# mget *.txt      → bajar múltiples archivos
# mput *.txt      → subir múltiples archivos
# exit            → salir
```

### rsync (incremental, eficiente para backups)

```bash
# Ver [[rsync]] para más detalles
rsync -avz directorio/ usuario@host:/ruta/destino/
```

## Seguridad y hardening

```bash
# En el servidor: /etc/ssh/sshd_config
# NO usar contraseña, solo claves:
#   PasswordAuthentication no
#   PermitRootLogin prohibit-password
#   PubkeyAuthentication yes

# Cambiar puerto (reduce ruido de bots):
#   Port 2222

# Limitar usuarios que pueden hacer SSH:
#   AllowUsers carlos ana

# Verificar cambios:
# sudo sshd -t                 # test de sintaxis
# sudo systemctl restart sshd  # aplicar

# Ver intentos de conexión fallidos en el log:
sudo journalctl -u sshd | grep "Failed password"

# Filtrar IPs que intentaron conectarse:
sudo journalctl -u sshd | grep "Failed password" | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr
```

## Trucos útiles

```bash
# Ejecutar un solo comando remoto
ssh server "df -h | grep /dev/sda"

# Conexión mantenida viva (evita timeouts por inactividad)
ssh -o ServerAliveInterval=30 -o ServerAliveCountMax=5 server

# Reenviar variable de entorno local al remoto
ssh -o SendEnv=CUSTOM_VAR server

# Copiar tu clave pública a un servidor desde otra máquina
ssh-keygen -t ed25519 -f ~/.ssh/llave-temporal   # generar clave ad-hoc
ssh-copy-id -i ~/.ssh/llave-temporal.pub usuario@host

# Túnel persistente con autossh (se reconecta si se cae)
sudo apt install autossh
autossh -M 0 -N -L 9090:localhost:8080 usuario@servidor
```

## Ver también

- [[Redes Basicas]] — conceptos de red
- [[rsync]] — copia incremental sobre SSH
- [[nc]] — netcat, alternativa simple para túneles rápidos
- [[journalctl]] — revisar logs de sshd

## Enlaces externos

- [Wikipedia - SSH](https://en.wikipedia.org/wiki/Secure_Shell)
- [Sitio oficial - OpenSSH](https://www.openssh.com/)
- [Arch Wiki - SSH](https://wiki.archlinux.org/title/SSH)

#comando
