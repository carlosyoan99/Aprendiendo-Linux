---
fecha_creacion: 2026-07-23
estado: resuelto
categoria: concepto
prioridad: media
---

# NTP y chrony — Sincronización de hora

> El tiempo en Linux se gestiona en dos niveles: el **reloj hardware** (RTC, la pila CMOS de la placa) y el **reloj del sistema** (mantenido por el kernel mientras el equipo está encendido). NTP/chrony sincronizan el reloj del sistema con servidores de tiempo en internet para mantener la hora precisa.

## Definición

NTP (Network Time Protocol) es el protocolo estándar para sincronizar relojes de computadoras a través de una red. **chrony** es la implementación moderna más usada (reemplazo de `ntpd` tradicional en la mayoría de distros). **systemd-timesyncd** es el cliente NTP mínimo integrado en systemd.

```bash
# ¿Qué tienes instalado?
timedatectl                           # NTP service: active/inactive → indica si hay NTP
systemctl status chronyd              # chrony
systemctl status systemd-timesyncd    # systemd-timesyncd
systemctl status ntpd                 # ntpd tradicional (obsoleto)
```

## Clientes NTP en Linux

| Cliente | Distro por defecto | Precisión | Complejidad | Uso |
|---|---|---|---|---|
| **chrony** (chronyd) | Fedora, RHEL, CentOS, openSUSE, Arch | Alta (sub-milisegundo) | Media | Servidores, escritorios, VMs |
| **systemd-timesyncd** | Ubuntu, Debian, Arch (opcional) | Baja (10-100ms) | Mínima | Escritorios, laptops (suficiente para uso normal) |
| **ntpd** (ntp.org) | Legado, casi ninguna moderna | Alta | Alta | Reemplazado por chrony |
| **ntpsec** | Derivadas de Debian | Alta | Baja | Fork de ntpd con seguridad mejorada |

> Para la mayoría de escritorios, **systemd-timesyncd** es suficiente (precisión de 10-100ms). Para servidores que necesiten precisión de milisegundos o microsegundos, **chrony** es la opción recomendada.

## chrony (recomendado para precisión)

### Instalación

```bash
# Debian/Ubuntu
sudo apt install chrony

# Fedora/RHEL (viene por defecto)
sudo dnf install chrony

# Arch
sudo pacman -S chrony

# Activar (desactivando systemd-timesyncd si está activo)
sudo systemctl disable --now systemd-timesyncd
sudo systemctl enable --now chronyd
```

### Configuración

```bash
# /etc/chrony/chrony.conf  (Debian/Ubuntu)
# /etc/chrony.conf         (Fedora/Arch)

# Servidores de tiempo (pool.ntp.org balancea automáticamente)
pool 0.pool.ntp.org iburst
pool 1.pool.ntp.org iburst
pool 2.pool.ntp.org iburst

# Servidores específicos por región
# pool es.pool.ntp.org iburst               # España
# pool br.pool.ntp.org iburst               # Brasil
# pool mx.pool.ntp.org iburst               # México

# Servidores NIST (si necesitas máxima precisión certificada)
# server time.nist.gov iburst

# Precisión
makestep 1.0 3                      # ajuste brusco si diff >1s en los primeros 3 sondeos
rtcsync                             # actualizar RTC cada vez que se sincroniza el reloj

# Permitir que clientes de la red local consulten
# allow 192.168.1.0/24

# Logging
logdir /var/log/chrony
```

### Comandos de chrony

```bash
# Ver estado de sincronización
chronyc tracking
# Reference ID    : 192.168.1.1 (ntp.redlocal.net)
# Stratum         : 3
# Ref time (UTC)  : Thu Jul 23 14:30:00 2026
# System time     : 0.000012345 seconds slow of NTP time
# Last offset     : +0.000003456 seconds
# RMS offset      : 0.000987654 seconds
# Frequency       : 123.456 ppm fast
# Residual freq   : -0.001 ppm
# Skew            : 0.005 ppm
# Root delay      : 0.012345 seconds
# Root dispersion : 0.001234 seconds
# Update interval : 64.0 seconds
# Leap status     : Normal

# Ver fuentes de tiempo (servidores)
chronyc sources -v                      # lista de servidores con su estado
# 210 Number of sources = 4
# MS Name/IP address         Stratum Poll Reach LastRx Last sample
# ^* ntp1.example.com             2   6   377    12  -1234us[-1234us] +/-   25ms
# ^+ ntp2.example.com             2   6   377    13   +567us[+567us] +/-   26ms
# Los símbolos indican:
#   ^* = fuente seleccionada actual
#   ^+ = fuente candidata (aceptable, pero no la seleccionada)
#   ^? = fuente no alcanzable
#   ^~ = fuente con mucha dispersión

# Ver actividad detallada
chronyc sourcestats -v

# Forzar sincronización inmediata
sudo chronyc -a makestep

# Ver estadísticas de chrony
chronyc activity

# Ver clientes que están consultando este servidor
chronyc clients
```

### Parámetros clave de la salida `chronyc tracking`

| Campo | Significado | Valores normales |
|---|---|---|
| `Stratum` | Distancia jerárquica del servidor raíz (1 = atómico/GPS, 2+ = servidores) | 2-4 en escritorio |
| `System time` | Diferencia entre reloj del sistema y NTP | < 1ms en buen estado |
| `Last offset` | Último ajuste aplicado | < 10ms |
| `RMS offset` | Desviación típica del error | < 5ms en buena conexión |
| `Frequency` | Deriva del reloj local (ppm) | Varía (0.1-500 ppm) |
| `Root delay` | Latencia total hasta el servidor raíz | 10-100ms |
| `Leap status` | Si hay o no segundo intercalar | Normal |

## systemd-timesyncd (suficiente para escritorio)

Viene integrado en systemd y es el cliente NTP mínimo. No tiene todas las capacidades de chrony (como ser servidor NTP o polling adaptativo), pero es suficiente para mantener la hora correcta en un escritorio/laptop.

```bash
# Configuración
sudo nano /etc/systemd/timesyncd.conf
# [Time]
# NTP=0.pool.ntp.org 1.pool.ntp.org       # servidores NTP
# FallbackNTP=ntp.ubuntu.com               # respaldo si los anteriores fallan
# RootDistanceMaxSec=5                     # distancia máxima aceptable

# Ver estado
timedatectl timesync-status
# Server: 91.189.91.157 (ntp.ubuntu.com)
# Poll interval: 34min 8s (min: 32s, max: 34min 8s)
# Leap: Normal
# Offset: +0.23ms
# Delay: 12.5ms
# Jitter: 0.98ms
# Packet count: 3

# Verificaciones
timedatectl show-timesync --all
systemctl status systemd-timesyncd
journalctl -u systemd-timesyncd
```

### Cuándo usar cada uno

| Situación | Recomendación |
|---|---|
| Escritorio/laptop básico | **systemd-timesyncd** (viene por defecto, no instalar nada extra) |
| Servidor de producción | **chrony** (mejor precisión, polling adaptativo) |
| Servidor con conexión intermitente | **chrony** (maneja mejor cortes de red) |
| Necesitas ser servidor NTP en tu LAN | **chrony** (systemd-timesyncd no ofrece servicio) |
| Precisión de microsegundos (trading, HPC) | **chrony** + PTP + kernel sincronizado |
| Raspberry Pi sin RTC | chrony (o PPS + GPS para máxima precisión) |

## Troubleshooting

```bash
# 1. ¿El servicio NTP está activo?
timedatectl                               # NTP service: active
systemctl status chronyd                  # chrony
systemctl status systemd-timesyncd        # systemd-timesyncd

# 2. ¿La hora está sincronizada?
timedatectl status | grep "synchronized"
# System clock synchronized: yes

# 3. ¿Hay servidores NTP alcanzables?
chronyc sources -v                        # chrony
timedatectl timesync-status               # systemd-timesyncd

# 4. Revisar logs
journalctl -u chronyd -n 30
journalctl -u systemd-timesyncd -n 30

# 5. Forzar sincronización
sudo chronyc -a makestep                  # chrony
sudo systemctl restart systemd-timesyncd  # systemd-timesyncd
# Esperar unos segundos y verificar con timedatectl
```

| Problema | Causa | Solución |
|---|---|---|
| `System clock synchronized: no` | NTP desactivado o sin servidores | `sudo timedatectl set-ntp true` |
| chrony no se sincroniza | Puertos UDP 123 bloqueados por firewall | `sudo ufw allow ntp` o abrir 123/udp |
| `chronyc sources` muestra `^?` en todas las fuentes | Sin conexión a internet o servidores NTP bloqueados | Probar con `ping pool.ntp.org` |
| Gran diferencia de hora (> 1000s) | RTC muy desviado o tiempo no sincronizado nunca | `makestep 1.0 -1` en chrony.conf o un reinicio forzado |
| Hora correcta en Linux, incorrecta en Windows | Conflicto UTC vs local | Ver [[Reloj desincronizado en dual boot]] |
| En VM, la hora se desvía constantemente | VM no tiene acceso directo al TSC | Instalar chrony con `confdir /etc/chrony/conf.d` y ajustar polling |

## Por qué importa

- Autenticación Kerberos/SSO requiere hora sincronizada (tolerancia típica: 5 minutos)
- Logs de seguridad con timestamp incorrecto no sirven para forense
- Certificados TLS comparan fechas (un sistema con hora atrasada no podrá navegar)
- Cron jobs y timers se ejecutan en hora incorrecta
- Sistemas distribuidos (bases de datos, colas) dependen de tiempo consistente

## Enlaces externos

- [chrony project](https://chrony-project.org/)
- [Arch Wiki — chrony](https://wiki.archlinux.org/title/Chrony)
- [Arch Wiki — systemd-timesyncd](https://wiki.archlinux.org/title/Systemd-timesyncd)
- [Debian Wiki — NTP](https://wiki.debian.org/NTP)
- [Fedora Wiki — chrony](https://fedoraproject.org/wiki/Chronic) (documentación oficial Red Hat)

## Ver también

- [[Redes Basicas]] — conectividad de red, UDP 123
- [[date y timedatectl]] — comandos de fecha/hora y timedatectl
- [[Reloj desincronizado en dual boot]] — UTC vs hora local con Windows
- [[systemd]] — systemd-timesyncd como parte del ecosistema
- [[Dual Boot con Windows]] — gestión del RTC

#concepto #red #tiempo
