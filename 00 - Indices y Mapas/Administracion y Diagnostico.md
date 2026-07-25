---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: indice
prioridad: alta
---

# Administración y Diagnóstico

Prioridad 2 — Lo que necesitas cuando algo se rompe o al configurar servidores.

> Para el día a día en terminal, ver [[Dia a Dia en CLI]] (Prioridad 1).

---

## ⚙️ Systemd — El corazón del sistema

### Gestión de servicios con systemctl

```bash
# Estados
systemctl status nginx               # estado + últimas líneas del log
systemctl is-active nginx            # active / inactive
systemctl is-enabled nginx           # enabled / disabled
systemctl list-units --failed        # servicios que fallaron

# Ciclo de vida
sudo systemctl start nginx           # iniciar ahora
sudo systemctl stop nginx            # detener ahora
sudo systemctl restart nginx         # reiniciar
sudo systemctl reload nginx          # recargar config (sin reiniciar)
sudo systemctl enable nginx          # que arranque al boot
sudo systemctl disable nginx         # que NO arranque al boot
sudo systemctl enable --now nginx    # enable + start en un comando
sudo systemctl mask nginx            # bloquear completamente
sudo systemctl daemon-reload         # recargar units después de crear/editar
```

### Crear un servicio simple

```ini
# /etc/systemd/system/mi-app.service
[Unit]
Description=Mi aplicación
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/mi-app
Restart=on-failure
User=mi-usuario
WorkingDirectory=/opt/mi-app

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload          # recargar units
sudo systemctl enable --now mi-app    # activar y arrancar
```

### journalctl — Logs del sistema

```bash
journalctl -u nginx                   # logs de un servicio
journalctl -p err                     # solo errores
journalctl --since "1 hour ago"       # por tiempo
journalctl -f                         # seguir en tiempo real (como tail -f)
journalctl -k                         # solo mensajes del kernel (como dmesg)
journalctl -u sshd | grep "Failed"    # filtrar por palabra
journalctl --disk-usage               # cuánto ocupan los logs
```

> Ver [[systemd]] para targets, timers, systemd-analyze, y configuración de journald.

---

## 💾 Almacenamiento y discos

### Identificar discos

```bash
lsblk                                # todos los discos y particiones (árbol)
lsblk -f                             # con UUID y tipo de FS
sudo blkid                           # UUID de todas las particiones
sudo fdisk -l /dev/sda              # tabla de particiones detallada
```

### Particionar

```bash
sudo cfdisk /dev/sda                 # interactivo (más amigable)
sudo fdisk /dev/sda                  # clásico
sudo gdisk /dev/sda                  # solo GPT
```

### Formatear y montar

```bash
sudo mkfs.ext4 /dev/sda1             # formatear como ext4
sudo mkfs.btrfs /dev/sda1            # formatear como btrfs
sudo mkfs.fat -F32 /dev/sda1         # FAT32 (para EFI/USB)

sudo mount /dev/sda1 /mnt            # montar
sudo mount UUID="xxxx" /mnt         # montar por UUID (recomendado)
sudo umount /mnt                     # desmontar

# Montaje persistente (/etc/fstab)
# UUID=xxxx-xxxx  /  ext4  defaults,noatime  0  1
```

> Ver [[mount]] para fstab, UUID vs etiquetas, y troubleshooting.
> Ver [[Particionado y Esquemas de Disco]] para esquemas típicos.
> Ver [[LVM]] para volúmenes lógicos flexibles.

---

## 🌐 Red avanzada y firewall

### Diagnóstico de red

```bash
ping -c 4 8.8.8.8                   # conectividad básica
traceroute -n google.com             # ruta de paquetes (¿dónde se pierden?)
mtr google.com                       # traceroute + ping continuo (mejor)
dig +short google.com                # resolución DNS
dig @1.1.1.1 google.com             # consultar a un DNS específico
nslookup google.com                  # DNS clásico
```

### Puertos y conexiones

```bash
ss -tulpn                            # ¿qué puertos están abiertos y qué procesos?
ss -tulpn | grep :80                 # ¿algo escuchando en el puerto 80?
ip a                                 # interfaces y direcciones IP
ip route                             # tabla de rutas (gateway)
```

### Firewall

```bash
# ufw (Ubuntu/Debian) — el más simple
sudo ufw status
sudo ufw allow ssh
sudo ufw enable

# nftables (moderno)
sudo nft list ruleset

# firewalld (Fedora/RHEL)
sudo firewall-cmd --list-all
```

> Ver [[Firewall]] para nftables, iptables, ufw y firewalld.
> Ver [[traceroute]] para diagnóstico de ruta de red.
> Ver [[dig]] para diagnóstico DNS.

### Resolución DNS local

```bash
cat /etc/hosts                        # archivo de hosts estático (sobrescribe DNS)
resolvectl status                     # DNS servers activos (systemd-resolved)
resolvectl query google.com           # probar resolución local
cat /etc/resolv.conf                  # servidores DNS configurados
```

---

## 🔐 SSH y acceso remoto

### Hardening del servidor (sshd_config)

```bash
# /etc/ssh/sshd_config — cambios esenciales:
Port 2222                              # cambiar puerto (reduce ruido de bots)
PermitRootLogin prohibit-password      # no permitir root con contraseña
PasswordAuthentication no              # solo claves, nada de contraseñas
PubkeyAuthentication yes               # autenticación por clave
AllowUsers carlos ana                  # solo estos usuarios pueden hacer SSH
```

```bash
# Verificar sintaxis y reiniciar
sudo sshd -t
sudo systemctl restart sshd
```

### Generar claves y copiar

```bash
ssh-keygen -t ed25519 -C "mi-equipo"   # generar clave (ed25519 > RSA)
ssh-copy-id -i ~/.ssh/id_ed25519.pub usuario@host  # copiar al servidor
ssh usuario@host                       # ahora sin contraseña
```

### Túneles

```bash
ssh -L 9090:localhost:8080 server      # local: puerto remoto → local
ssh -R 3000:localhost:3000 server      # remoto: puerto local → remoto
ssh -D 1080 server                     # SOCKS proxy (navegar como si estuvieras allá)
ssh -J bastion server-final            # ProxyJump (saltar vía host intermedio)
```

> Ver [[SSH]] para configuración avanzada, ProxyJump, agent forwarding y rsync sobre SSH.

---

## 📊 Logs y monitoreo

### Dónde están los logs

| Log | Qué contiene | Comando |
|---|---|---|
| Journald (todos) | Todo el sistema (kernel, servicios, apps) | `journalctl -u servicio` |
| `/var/log/syslog` | Log general del sistema (Debian/Ubuntu) | `tail -f /var/log/syslog` |
| `/var/log/auth.log` | Intentos de login, sudo, SSH | `sudo tail -f /var/log/auth.log` |
| Kernel ring buffer | Mensajes del kernel (arranque, hardware) | `dmesg -H` o `journalctl -k` |
| `/var/log/nginx/access.log` | Accesos a Nginx | `tail -f /var/log/nginx/access.log` |

### fail2ban — Anti-bots

```bash
sudo fail2ban-client status sshd       # IPs baneadas en SSH
sudo fail2ban-client status            # todas las cárceles
sudo journalctl -u fail2ban -f         # logs en vivo de fail2ban
```

> Ver [[fail2ban]] para configuración de baneos por servicio.
> Ver [[Logging del sistema (rsyslog journald logrotate)]] para rsyslog, logrotate y persistencia.

---

## ⏰ Tareas programadas

### cron — La clásica

```bash
crontab -e                            # editar tareas del usuario actual
# formato: minuto hora día mes día-semana comando
  0       3    *   *    *     /home/user/backup.sh   # cada día a las 3:00
  */15    *    *   *    *     /home/user/script.sh   # cada 15 minutos
  0       9    *   *    1     /home/user/reporte.sh  # cada lunes a las 9:00
```

### systemd timers — La moderna

```ini
# /etc/systemd/system/mi-backup.timer
[Timer]
OnCalendar=daily
Persistent=true                    # si el PC estaba apagado, ejecuta al encender
RandomizedDelaySec=60

[Install]
WantedBy=timers.target
```

```bash
sudo systemctl enable --now mi-backup.timer
systemctl list-timers               # ver todos los timers activos
```

> Ver [[Cron y Systemd Timers]] para comparativa detallada y ejemplos.

---

## 🔧 Flujo de troubleshooting

Cuando algo no funciona, sigue esta secuencia:

```
  ┌─ ¿El servicio está corriendo?
  │   systemctl status nombre
  │   ¿Inactivo? → sudo systemctl start nombre
  │   ¿Falló?    → journalctl -u nombre -p err --since "10 min ago"
  │
  ├─ ¿El puerto está abierto?
  │   sudo ss -tulpn | grep :PUERTO
  │   ¿No aparece? → revisar configuración del servicio
  │   ¿Aparece?    → probar desde fuera: nc -zv localhost PUERTO
  │
  ├─ ¿El firewall lo bloquea?
  │   sudo ufw status
  │   sudo nft list ruleset
  │
  ├─ ¿Hay conectividad de red?
  │   ping -c 4 8.8.8.8
  │   traceroute -T -p 80 google.com
  │   dig +short midominio.com
  │
  ├─ ¿Hay espacio en disco?
  │   df -h
  │   journalctl --disk-usage
  │
  ├─ ¿Hay errores en logs?
  │   journalctl -p err --since "1 hour ago"
  │   dmesg -H | grep -i error
  │   tail -f /var/log/syslog
  │
  └─ ¿Es un problema de permisos?
      ls -l /ruta/al/archivo
      whoami
      sudo -u usuario comando
```

### Ejemplos de troubleshooting real

```
"El puerto 80 no responde":
  ss -tulpn | grep :80           # ¿nginx está escuchando?
  sudo systemctl status nginx    # ¿nginx está corriendo?
  sudo journalctl -u nginx -p err  # ¿hay errores?
  sudo ufw status                # ¿el firewall bloquea?
  curl -I localhost              # ¿responde localmente?

"No puedo hacer SSH al servidor":
  ping -c 4 servidor             # ¿el servidor responde?
  ssh -v usuario@servidor        # modo verbose para ver dónde falla
  sudo journalctl -u sshd -p err # ¿SSH está corriendo y aceptando?
  sudo fail2ban-client status sshd  # ¿mi IP está baneada?
  sudo ss -tulpn | grep :22      # ¿SSH escucha en el puerto correcto?

"El disco está lleno":
  df -h                          # ¿qué partición está llena?
  du -sh /* | sort -rh | head -10  # ¿qué carpeta pesa más?
  journalctl --disk-usage        # ¿los logs ocupan mucho?
  sudo journalctl --vacuum-size=200M  # reducir logs
  sudo apt autoremove            # limpiar paquetes huérfanos
  sudo du -sh /var/log/         # ¿los logs ocupan mucho?
```

---

## 📋 Resumen de comandos por categoría

| Categoría | Comandos esenciales |
|---|---|
| **Servicios** | `systemctl`, `journalctl`, `systemd-analyze` |
| **Discos** | `lsblk`, `fdisk`, `mkfs`, `mount`, `umount`, `blkid`, `df`, `du` |
### anacron — Para equipos que se apagan

`anacron` ejecuta tareas que se perdieron porque el equipo estaba apagado. Ideal para scripts de mantenimiento en laptops:

```bash
# /etc/anacrontab — formato:
# periodo_dias retardo_minutos nombre-del-trabajo comando
1          15              daily.clean      apt-get autoremove
7          30              weekly.backup    /home/user/backup.sh
30         60              monthly.logs     /home/user/clean-logs.sh
```

> `cron` necesita que el equipo esté encendido exactamente a la hora programada. `anacron` ejecuta la tarea la próxima vez que el equipo se encienda. Se complementan: cron para tareas con hora fija, anacron para tareas diarias/semanales que no requieren hora exacta.

---

### systemd timers — La moderna
| **Firewall** | `ufw`, `nft`, `iptables`, `firewall-cmd` |
| **SSH** | `ssh`, `ssh-keygen`, `ssh-copy-id`, `scp`, `rsync` |
| **Logs** | `journalctl`, `dmesg`, `tail`, `grep` |
| **Seguridad** | `fail2ban-client`, `sudo`, `chmod`, `chown` |
| **Programación** | `crontab`, `systemctl` (timers) |
| **Monitoreo** | `htop`, `df -h`, `free -h`, `uptime` |

---

## Enlaces externos

- [Arch Wiki — System administration](https://wiki.archlinux.org/title/Category:System_administration)
- [Arch Wiki — systemd](https://wiki.archlinux.org/title/Systemd)
- [Red Hat Enterprise Linux — System administrator's guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/system_administrators_guide/index)
- [Ubuntu Server Guide](https://ubuntu.com/server/docs)
- [Linux man pages online](https://man.archlinux.org/)

## 📖 Ver también

- [[Dia a Dia en CLI]] — Prioridad 1: comandos esenciales diarios
- [[Cheat Sheet - Comandos Esenciales]] — referencia rápida
- [[Solucion de Problemas - Recursos]] — metodología de troubleshooting
- [[Rutas de Aprendizaje]] — prioridades del vault
- [[MoC - Linux]] — índice completo del vault

#indice #administracion #troubleshooting #prioridad2
