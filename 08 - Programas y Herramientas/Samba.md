---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPLv3
alternativas: NFS, SSHFS, Nextcloud, FTP, Syncthing
---

# Samba

> Implementación libre del protocolo **SMB/CIFS** (Server Message Block) que permite compartir archivos e impresoras entre sistemas Linux y Windows. Creado por **Andrew Tridgell** en 1992, Samba es el puente estándar entre el mundo Unix/Linux y las redes Windows.

## Historia

| Hito | Año |
|---|---|
| Andrew Tridgell desarrolla el primer SMB reverse-engineered | 1992 |
| Lanzamiento Samba 1.0 | 1992 |
| Soporte de NT Domain | 1999 |
| Samba 4.0 — Active Directory domain controller | 2012 |
| Samba 4.19+ — mejoras de rendimiento y seguridad | 2023 |

El nombre Samba viene de «SMB» + la letra «a» (como en «Samba», el ritmo brasileño), siguiendo el patrón de añadir vocales a acrónimos (como GNU → GNU's Not Unix).

## Instalación

```bash
# Debian/Ubuntu
sudo apt install samba

# Arch Linux
sudo pacman -S samba

# Fedora/RHEL
sudo dnf install samba samba-client

# Verificar instalación
smbstatus --version
```

### Componentes principales

| Componente | Función |
|---|---|
| **smbd** | Demonio que proporciona servicios de archivos e impresión (puertos 139/tcp, 445/tcp) |
| **nmbd** | Demonio de NetBIOS sobre IP (puertos 137/udp, 138/udp) — descubrimiento de hosts |
| **smbclient** | Cliente FTP-like para acceder a recursos SMB desde terminal |
| **smbpasswd** | Gestiona contraseñas de usuarios Samba |
| **smbstatus** | Muestra conexiones activas y bloqueos |
| **testparm** | Valida la sintaxis de smb.conf |
| **net** | Herramienta de administración (unir dominio, gestionar usuarios) |
| **samba-tool** | Administración de Samba AD Domain Controller |

### Puertos necesarios

| Puerto | Protocolo | Uso |
|---|---|---|
| 445/tcp | SMB over TCP (directo) | Tráfico SMB moderno |
| 139/tcp | NetBIOS session | Tráfico SMB legacy |
| 137/udp | NetBIOS name resolution | Descubrimiento de nombres |
| 138/udp | NetBIOS datagram | Servicios de datagramas |

## Configuración básica

### smb.conf — estructura

```bash
# /etc/samba/smb.conf — configuración principal
sudo nano /etc/samba/smb.conf

# Verificar sintaxis
testparm
```

### Recurso compartido básico (guest)

```ini
[global]
   workgroup = WORKGROUP
   server string = Servidor Samba
   netbios name = SERVIDOR
   security = user
   map to guest = Bad User          # usuarios sin cuenta → guest
   guest account = nobody

   # Logs
   log file = /var/log/samba/log.%m
   max log size = 1000

[Compartido]
   path = /samba/compartido
   browseable = yes
   read only = no
   guest ok = yes
   create mask = 0775
   directory mask = 0775
```

```bash
# Crear directorio y permisos
sudo mkdir -p /samba/compartido
sudo chown nobody:nogroup /samba/compartido
sudo chmod 0775 /samba/compartido

# Iniciar servicio
sudo systemctl enable --now smbd nmbd

# Acceder desde Windows: \\IP-DEL-SERVIDOR\Compartido
# Acceder desde terminal:
smbclient //localhost/Compartido -U guest
```

### Recurso compartido con autenticación

```ini
[global]
   workgroup = WORKGROUP
   server string = Servidor Samba
   security = user

[Privado]
   path = /samba/privado
   browseable = yes
   read only = no
   valid users = @sambausers          # solo miembros del grupo
   create mask = 0700
   directory mask = 0700
   force group = sambausers
```

```bash
# Crear grupo y usuario
sudo groupadd sambausers
sudo useradd -m -G sambausers juan      # usuario del sistema
sudo smbpasswd -a juan                  # contraseña para Samba

# Crear directorio
sudo mkdir -p /samba/privado
sudo chown root:sambausers /samba/privado
sudo chmod 0770 /samba/privado

# Recargar Samba
sudo systemctl reload smbd
```

### Recurso de solo lectura (público)

```ini
[Documentos]
   path = /samba/documentos
   browseable = yes
   read only = yes
   guest ok = yes
```

## Administración de usuarios

```bash
# Usuarios deben existir en el sistema primero
sudo useradd -M -s /usr/sbin/nologin ana
sudo smbpasswd -a ana                  # añadir a Samba
sudo smbpasswd -e ana                  # habilitar usuario
sudo smbpasswd -d ana                  # deshabilitar usuario
sudo smbpasswd -x ana                  # eliminar usuario de Samba

# Listar usuarios Samba
sudo pdbedit -L
sudo pdbedit -L -v                     # detallado

# Ver conexiones activas
smbstatus
```

## Montar recursos SMB en Linux

```bash
# Montaje manual con mount.cifs
sudo apt install cifs-utils
sudo mount -t cifs //192.168.1.100/Compartido /mnt/samba \
    -o username=juan,uid=1000,gid=1000,iocharset=utf8

# Montaje con credenciales (/etc/samba/credenciales):
# username=juan
# password=secreta
# domain=WORKGROUP
sudo mount -t cifs //192.168.1.100/Privado /mnt/samba \
    -o credentials=/etc/samba/credenciales,uid=1000,gid=1000

# /etc/fstab
//192.168.1.100/Compartido  /mnt/samba  cifs  credentials=/etc/samba/credenciales,uid=1000,gid=1000,iocharset=utf8,noauto 0 0

# Acceder desde terminal
smbclient //192.168.1.100/Compartido -U juan
```

## Samba como servidor de archivos (mejores prácticas)

```ini
[global]
   workgroup = WORKGROUP
   server string = Servidor de Archivos

   # Seguridad
   security = user
   map to guest = Bad User
   encrypt passwords = yes
   smb encrypt = required              # cifrado SMB3 obligatorio
   server min protocol = SMB3          # rechazar versiones antiguas
   ntlm auth = msv1                    # NTLMv2

   # Rendimiento
   socket options = TCP_NODELAY IPTOS_LOWDELAY
   read raw = yes
   write raw = yes

   # Logs
   log level = 1
   log file = /var/log/samba/log.%m

   # Prevención
   veto files = /*.exe/*.bat/*.cmd/    # ocultar ciertos archivos
   delete veto files = yes
```

## Samba como miembro de dominio Windows

```bash
# Unir servidor Linux a un dominio Active Directory
sudo apt install samba krb5-user winbind

# Configurar /etc/samba/smb.conf para AD
sudo net ads join -U Administrador        # unir al dominio
sudo net ads testjoin                     # verificar unión

# Autenticar usuarios del dominio
sudo winbindd
wbinfo -u                                 # listar usuarios del dominio
getent passwd DOMINIO\\usuario
```

## Samba como controlador de dominio (AD DC)

Samba 4 puede actuar como **Active Directory Domain Controller**:

```bash
# Instalar y aprovisionar
sudo apt install samba smbclient winbind
sudo samba-tool domain provision \
    --use-rfc2307 \
    --domain=MIEMPRESA \
    --adminpass=ContraseñaSegura123 \
    --realm=MIEMPRESA.LOCAL

# Servicios
sudo systemctl stop smbd nmbd winbind     # se usa samba-ad-dc en su lugar
sudo systemctl disable smbd nmbd winbind
sudo systemctl enable --now samba-ad-dc

# Gestionar
sudo samba-tool user list
sudo samba-tool user create juan
sudo samba-tool group addmembers "Domain Admins" juan
sudo samba-tool domain info 127.0.0.1
```

## Seguridad

```ini
[global]
   # Cifrado
   smb encrypt = required
   server min protocol = SMB3_11         # SMB 3.1.1 (más seguro)
   client min protocol = SMB3

   # Deshabilitar protocolos inseguros
   disable netbios = yes                 # si no necesitas NetBIOS
   disable spoolss = yes                 # si no compartes impresoras

   # Logs de auditoría
   log level = 2 auth_audit:5

   # Restringir acceso
   hosts allow = 127.0.0.1 192.168.1.0/24
   hosts deny = 0.0.0.0/0
```

### Cortafuegos

```bash
# Para Samba sin NetBIOS (solo SMB directo)
sudo ufw allow 445/tcp

# Para Samba completo (con NetBIOS)
sudo ufw allow 137/udp
sudo ufw allow 138/udp
sudo ufw allow 139/tcp
sudo ufw allow 445/tcp
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `tree connect failed: NT_STATUS_BAD_NETWORK_NAME` | El recurso no existe | Verificar `path` en smb.conf |
| `NT_STATUS_ACCESS_DENIED` | Permisos del directorio | `chmod` y `chown` correctos en la ruta |
| No aparece en el explorador de Windows | NetBIOS deshabilitado | Verificar `nmbd` corriendo, `disable netbios = no` |
| `protocol negotiation failed` | Versión SMB incompatible | Windows 10+ requiere SMB3; server min protocol = SMB3 |
| `session setup failed: NT_STATUS_LOGON_FAILURE` | Contraseña incorrecta | `sudo smbpasswd -a usuario` |
| Conexión lenta | DNS reverse lookup | Añadir `name resolve order = lmhosts host bcast` |
| Los cambios de config no se aplican | No se recargó | `sudo systemctl reload smbd` |
| `timeout connecting` | Firewall bloqueando | Verificar puertos 445 y 139 desde el cliente |

### Comandos de diagnóstico

```bash
# Verificar configuración
testparm -v
testparm -s                           # sin comentarios (salida limpia)

# Ver conexiones activas
smbstatus
smbstatus -L                          # bloqueos activos

# Ver qué servicios de red expone Samba
sudo ss -tulpn | grep -E 'smbd|nmbd'

# Probar conectividad desde el cliente
smbclient -L //192.168.1.100 -U juan  # listar recursos disponibles
smbclient //192.168.1.100/Documentos -U juan  # conectar a recurso

# Probar con SMB directo (sin NetBIOS)
smbclient -m SMB3 //192.168.1.100/Compartido -U juan

# Logs en tiempo real
sudo tail -f /var/log/samba/log.smbd
sudo journalctl -u smbd -f

# Resolver nombres NetBIOS
nmblookup SERVIDOR
```

## Alternativas

| Alternativa | Cuándo usarla | Diferencia |
|---|---|---|
| **NFS** | Solo Linux/Unix | Más rápido, sin soporte Windows nativo |
| **SSHFS** | Acceso remoto ocasional | Basado en FUSE, encriptado por defecto |
| **Nextcloud** | Sincronización + web | Concurrencia, versionado, interfaz web |
| **Syncthing** | Sincronización P2P | Sin servidor central, cifrado |
| **rsync** | Transferencias one-shot | No es un sistema de archivos montable |

## Comparativa: SMB vs NFS

| Aspecto | Samba (SMB) | NFS |
|---|---|---|
| **Cliente Windows** | Nativo | No nativo (requiere software extra) |
| **Rendimiento** | Bueno | Excelente (Linux↔Linux) |
| **Autenticación** | Kerberos/NTLM | AUTH_SYS, Kerberos |
| **Configuración** | Media | Simple |
| **Cifrado** | SMB3 nativo | Kerberos o STunnel |
| **Bloqueo de archivos** | Sí (oportunista) | Sí (NLM/FCNTL) |

## Enlaces externos

- [Samba — Página oficial](https://www.samba.org/)
- [Samba HOWTO Collection](https://www.samba.org/samba/docs/)
- [Samba Wiki](https://wiki.samba.org/)
- [Samba — ArchWiki](https://wiki.archlinux.org/title/Samba)
- [CIFS-Utils man page](https://man.archlinux.org/man/mount.cifs.8)

## Ver también

- [[Firewall]] — apertura de puertos SMB
- [NFS — Wikipedia](https://es.wikipedia.org/wiki/Network_File_System) — alternativa Linux-nativa de sistema de archivos en red
- [[Dual Boot con Windows]] — coexistencia de sistemas
- [[Redes Basicas]] — conceptos de red subyacentes
- [[Nmap]] — descubrimiento de servidores Samba en la red
- [[DNS y BIND]] — resolución de nombres de servidor

#programa #red #archivos
