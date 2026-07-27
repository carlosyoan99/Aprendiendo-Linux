---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: apt (Debian Testing)
base: Debian Testing
---

# Kali Linux

## Qué es

**Kali Linux** es una distribución basada en **Debian Testing** especializada en **seguridad informática** y **pentesting** (pruebas de penetración). Es el estándar de facto para profesionales de seguridad, con más de 600 herramientas preinstaladas.

Creada por **Offensive Security** (OffSec) en 2013 como sucesora de **BackTrack Linux** (que a su vez unía WHAX y SLAX). Es mantenida activamente y recibe actualizaciones continuas.

## Filosofía

- **Herramientas especializadas**: Kali no es para uso diario — es un **kit de herramientas de seguridad**
- **Entorno controlado**: diseñada para ejecutarse en **entornos controlados** (laboratorios, VMs, hardware dedicado)
- **Live USB persistente**: ideal para llevar un laboratorio de pruebas en el bolsillo
- **Mantener la cadena de herramientas**: cada herramienta se prueba y se mantiene actualizada

## Gestor de paquetes

```bash
# Basada en Debian, usa apt
sudo apt update
sudo apt full-upgrade -y

# Metapaquetes de herramientas
sudo apt install kali-linux-headless     # sin GUI (servidores/VM)
sudo apt install kali-linux-default      # instalación por defecto (recomendada)
sudo apt install kali-linux-large        # todas las herramientas
sudo apt install kali-tools-*            # categorías específicas

# Categorías disponibles:
# kali-tools-information-gathering      # recolección de información
# kali-tools-vulnerability              # análisis de vulnerabilidades
# kali-tools-web                        # aplicaciones web
# kali-tools-database                   # bases de datos
# kali-tools-passwords                   # cracking de contraseñas
# kali-tools-wireless                   # redes inalámbricas
# kali-tools-exploitation               # explotación
# kali-tools-sniffing                   # sniffing y spoofing
# kali-tools-post-exploitation           # post-explotación
# kali-tools-forensics                  # forense digital
```

## Herramientas destacadas

```bash
# Escaneo de redes
nmap -sV -sC -O 192.168.1.0/24
masscan 192.168.1.0/24 -p80,443,22

# Análisis de tráfico
wireshark                                # análisis gráfico de paquetes
tcpdump -i eth0 -n port 80              # captura desde terminal

# Frameworks de explotación
msfconsole                              # Metasploit Framework
searchsploit wordpress 6.0              # Search Exploit-DB

# Cracking de contraseñas
john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
hashcat -m 0 -a 0 hash.txt rockyou.txt

# Análisis web
burpsuite                                # proxy de interceptación
nikto -h https://ejemplo.com            # escáner de vulnerabilidades web
gobuster dir -u https://ejemplo.com -w /usr/share/wordlists/dirb/common.txt

# Wireless
aircrack-ng wlan0                        # suite de análisis WiFi
reaver -i mon0 -b BSSID                 # WPS PIN attack

# Forense
autopsy                                  # análisis forense gráfico
foremost -i imagen.dd -t pdf,jpg        # recuperación de archivos
```

## Instalación

```bash
# Opción 1: Instalación en disco
# Descargar ISO desde https://www.kali.org/get-kali/
# Grabar en USB:
sudo dd if=kali-linux-2026.1-installer-amd64.iso of=/dev/sdX bs=4M status=progress

# Opción 2: Live USB con persistencia
# Crear USB live con espacio de persistencia cifrado:
sudo dd if=kali-linux-2026.1-live-amd64.iso of=/dev/sdX bs=4M status=progress
# Particionar espacio restante como persistencia:
sudo cfdisk /dev/sdX
sudo mkfs.ext4 -L persistence /dev/sdX3
# Montar y crear persistence.conf:
echo "/ union" | sudo tee /mnt/persistence.conf

# Opción 3: Máquina virtual (recomendada)
# Descargar VM preconfigurada desde https://www.kali.org/get-kali/#kali-virtual-machines
```

## Escritorio por defecto

Kali usa **XFCE** (ligero, funciona en hardware modesto), pero ofrece spins:
- **XFCE** (por defecto)
- **GNOME** (Kali Purple, para defensa)
- **KDE Plasma**
- **i3** (minimalista, para terminal)
- **LXDE** (ultra ligero)
- **Sway** (Wayland)

## Kali Purple

Desde 2023, **Kali Purple** es la edición centrada en **defensa/blue team** (no solo ataque). Incluye herramientas de monitoreo, detección y respuesta:

- **TheHive** — plataforma de respuesta a incidentes
- **Cortex** — motor de análisis
- **Arkime** (antes Moloch) — captura y búsqueda de paquetes
- **Cyberchef** — herramienta de análisis de datos
- **Kismet** — detector de redes inalámbricas
- **Wazuh** — SIEM (integración opcional)

## ⚠️ Advertencia legal

Kali Linux es una herramienta profesional para **entornos autorizados**. Usar las herramientas de Kali contra sistemas sin permiso explícito es **ilegal** en la mayoría de países. Violas leyes como:
- Computer Fraud and Abuse Act (CFAA) en EE.UU.
- Ley de Delitos Informáticos en España/América Latina
- GDPR si accedes a datos personales

## Ver también

- [[Parrot OS]] — alternativa con enfoque en privacidad
- [[Tails]] — anonimato extremo (Tor por defecto)
- [[Debian]] — base de Kali
- [[Redes Basicas]] — fundamentos de redes (necesarios para pentesting)
- [[Firewall]] — iptables/nftables
- [[WireGuard VPN]] — conexiones seguras en pentesting
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]]

## Enlaces externos

- [Kali Linux — Página oficial](https://www.kali.org/)
- [Kali Documentation](https://www.kali.org/docs/)
- [Kali Tools — Lista completa](https://www.kali.org/tools/)
- [Exploit-DB](https://www.exploit-db.com/)
- [OffSec Training](https://www.offsec.com/)

#distro #seguridad
