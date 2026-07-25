---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-20
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPLv2
alternativas: masscan, netcat (nc), unicornscan, RustScan, Zmap
---

# Nmap

> Herramienta de **descubrimiento de red** y **escaneo de puertos** de código abierto. Desde 1997 es el estándar de facto para auditar redes, inventariar hosts y detectar servicios. Incluye el potente **NSE (Nmap Scripting Engine)**.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install nmap

# Arch Linux
sudo pacman -S nmap

# Fedora/RHEL
sudo dnf install nmap

# Verificar instalación
nmap --version
nmap --help | head -20
```

## Modos de escaneo

| Técnica | Flag | Descripción | Permisos |
|---|---|---|---|
| **TCP SYN** (stealth) | `-sS` | Escaneo medio abierto, no completa handshake | Root |
| **TCP connect** | `-sT` | Conexión completa (usa API del sistema) | Cualquiera |
| **UDP** | `-sU` | Escanea puertos UDP (lento) | Root |
| **TCP ACK** | `-sA` | Mapeo de reglas de firewall | Root |
| **TCP Window** | `-sW` | Detecta puertos abiertos por tamaño de ventana TCP | Root |
| **TCP Maimon** | `-sM` | Envía paquetes FIN/ACK (a veces evita detección) | Root |
| **Idle scan** | `-sI` | Escaneo zombie (IP falsa intermediaria) | Root |
| **Ping sweep** | `-sn` | Solo descubrimiento (no escanea puertos) | Cualquiera |
| **Version detection** | `-sV` | Detecta versión de servicios en puertos abiertos | Cualquiera |
| **OS detection** | `-O` | Detecta sistema operativo del host | Root |

## Comandos esenciales

### Descubrimiento de hosts

```bash
# Ping sweep — qué hosts están activos en la red
nmap -sn 192.168.1.0/24               # escanear toda la subred
nmap -sn 192.168.1.1-50               # rango de IPs
nmap -sn 192.168.1.1/24 --exclude 192.168.1.1  # excluir el gateway

# Sin ping (asumir que todos los hosts están activos)
nmap -Pn 192.168.1.0/24               # útil si bloquean ICMP
```

### Escaneo de puertos

```bash
# Escaneo básico (top 1000 puertos)
nmap 192.168.1.1

# Escaneo SYN (stealth, necesita root)
sudo nmap -sS 192.168.1.1

# Puertos específicos
nmap -p 22,80,443 192.168.1.1                   # puertos concretos
nmap -p 1-1000 192.168.1.1                       # rango
nmap -p- 192.168.1.1                              # todos los 65535 puertos (lento)
nmap --top-ports 100 192.168.1.1                  # los 100 más comunes

# Todos los puertos + versiones + OS (escanéo completo)
sudo nmap -sS -sV -O -p- 192.168.1.1
```

### Detección de servicios y OS

```bash
# Detectar versiones de servicios
nmap -sV 192.168.1.1
nmap -sV --version-intensity 9   # más agresivo (0-9, default 7)

# Detectar sistema operativo
sudo nmap -O 192.168.1.1

# Todo en uno: SYN + versiones + OS + scripts por defecto + traceroute
sudo nmap -A 192.168.1.1
```

### Salida y formatos

```bash
# Guardar resultados
nmap -oN resultado.txt 192.168.1.1    # normal
nmap -oX resultado.xml 192.168.1.1    # XML (para procesar)
nmap -oG resultado.grep 192.168.1.1   # grepeable
nmap -oA resultado 192.168.1.1        # todos los formatos

# Verbosidad y velocidad
nmap -v 192.168.1.1                   # verbose
nmap -vv 192.168.1.1                  # muy verbose
nmap -T4 192.168.1.1                  # velocidad: -T0 (paranoico) a -T5 (loco)
```

## Estados de puerto

| Estado | Significado |
|---|---|
| **open** | Puerto abierto, servicio escuchando |
| **closed** | Puerto accesible pero sin servicio |
| **filtered** | Firewall bloquea el acceso (no se sabe si está abierto) |
| **unfiltered** | Accesible pero nmap no determina open/closed |
| **open\|filtered** | Nmap no puede distinguir entre abierto o filtrado |
| **closed\|filtered** | Nmap no puede distinguir entre cerrado o filtrado |

## NSE (Nmap Scripting Engine)

NSE permite ejecutar scripts escritos en **Lua** para automatizar tareas:

```bash
# Categorías de scripts
nmap --script-help all | grep "^Categories:" | sort -u
# Categories: auth, broadcast, brute, default, discovery, dos,
#              exploit, external, fuzzer, intrusive, malware,
#              safe, version, vuln

# Scripts por defecto (los más útiles y seguros)
nmap -sC 192.168.1.1                  # equivalente a --script=default
nmap -sV -sC 192.168.1.1              # versión + scripts default

# Categorías específicas
nmap --script=vuln 192.168.1.1        # vulnerabilidades conocidas
nmap --script=safe 192.168.1.1        # scripts seguros
nmap --script=auth 192.168.1.1        # autenticación
nmap --script=discovery 192.168.1.1   # descubrimiento adicional

# Scripts individuales
nmap --script=http-enum 192.168.1.1   # enumerar directorios web
nmap --script=smb-os-discovery 192.168.1.1  # detectar OS vía SMB
nmap --script=dns-zone-transfer 192.168.1.1 # intentar transferencia de zona DNS

# Scripts con argumentos
nmap --script=http-enum --script-args http-enum.fingerprintfile=./custom.txt 192.168.1.1
```

### Scripts útiles por categoría

| Categoría | Scripts destacados |
|---|---|
| **discovery** | `dns-zone-transfer`, `whois-domain`, `traceroute-geolocation` |
| **safe** | `http-title`, `ssh-hostkey`, `ssl-cert`, `ftp-anon` |
| **vuln** | `http-shellshock`, `ssl-heartbleed`, `smb-vuln-ms17-010` |
| **auth** | `http-brute`, `ssh-brute`, `ftp-brute` |
| **broadcast** | `dhcp-discover`, `wsdiscovery`, `llmnr-resolve` |

## Ejemplos prácticos

### Escaneo rápido de una red local

```bash
# ¿Qué dispositivos hay en mi red?
nmap -sn 192.168.1.0/24

# ¿Qué servicios ofrece mi servidor?
nmap -sV 192.168.1.100

# ¿Mi servidor web es accesible desde fuera?
nmap -p 80,443 -sV <ip-publica>
```

### Auditoría de seguridad básica

```bash
# Escaneo completo de un servidor
sudo nmap -sS -sV -O -p- -T4 -A -oA auditoria 192.168.1.100

# Buscar vulnerabilidades comunes
nmap --script=vuln 192.168.1.100

# Verificar Heartbleed
nmap --script=ssl-heartbleed -p 443 192.168.1.100

# Verificar puertos abiertos hacia Internet (desde VPS)
nmap -p 22,80,443,3306,8080 <ip-publica>
```

### Múltiples hosts y subredes

```bash
# Escanear varias IPs
nmap 192.168.1.1 192.168.1.10 192.168.1.100

# Escanear desde archivo
nmap -iL hosts.txt

# Excluir hosts
nmap 192.168.1.0/24 --exclude 192.168.1.1,192.168.1.254

# Escaneo aleatorio
nmap --randomize-hosts 192.168.1.0/24
```

### Evasión de firewalls

```bash
# Fragmentar paquetes (pasa por algunos firewalls)
sudo nmap -f 192.168.1.1

# Usar puerto de origen específico (algunos firewalls confían en puertos bajos)
sudo nmap --source-port 53 192.168.1.1

# Spoofear IP de origen
sudo nmap -S 192.168.1.200 192.168.1.1

# Modificar TTL
sudo nmap --ttl 128 192.168.1.1

# Usar proxy SOCKS
nmap --proxies socks4://192.168.1.200:1080 192.168.1.1

# Escaneo decoy (IPs señuelo)
sudo nmap -D 192.168.1.10,192.168.1.20,ME 192.168.1.1
```

## Timing y rendimiento

| Plantilla | Nombre | Descripción |
|---|---|---|
| `-T0` | Paranoico | Muy lento, evade IDS |
| `-T1` | Sneaky | Lento, para evasión |
| `-T2` | Polite | Moderado, consume menos ancho de banda |
| `-T3` | Normal | Default |
| `-T4` | Aggressive | Rápido, asume red rápida |
| `-T5` | Insane | Muy agresivo, puede perder puertos |

```bash
# Opciones de timing manuales
nmap --min-rate 1000 192.168.1.1         # mínimo 1000 paq/s
nmap --max-rate 100 192.168.1.1          # máximo 100 paq/s
nmap --host-timeout 30s 192.168.1.1      # timeout por host
nmap --max-retries 2 192.168.1.1         # reintentos máximos
```

## Seguridad y legalidad

> ⚠️ **Escaneo de redes sin autorización puede ser ilegal** en muchos países. Solo escanea redes de tu propiedad o con permiso explícito del propietario.

```bash
# Buenas prácticas
nmap -sL 192.168.1.0/24              # list scan (solo lista, no envía paquetes)
nmap --reason 192.168.1.1            # explica por qué nmap decidió el estado
```

## Ndiff (comparar escaneos)

```bash
# Comparar dos resultados para detectar cambios en la red
nmap -oX antes.xml 192.168.1.0/24
nmap -oX despues.xml 192.168.1.0/24
ndiff antes.xml despues.xml
```

## Zenmap (interfaz gráfica)

```bash
sudo apt install zenmap     # interfaz gráfica para nmap
zenmap &
```

Permite guardar perfiles de escaneo, ver topología de red, y comparar resultados visualmente.

## Alternativas

| Herramienta | Enfoque | Diferencias con nmap |
|---|---|---|
| **masscan** | Escaneo masivo | Escanea Internet entero en minutos, menos detalle |
| **Zmap** | Escaneo masivo | Similar a masscan, research académico |
| **RustScan** | Rápido + NSE | Escrito en Rust, muy rápido, llama a nmap para detalle |
| **netcat (nc)** | Conexiones manuales | No escanea, pero verifica puertos uno a uno |
| **unicornscan** | Escaneo stateless | Rápido, pero desactualizado |

## Enlaces externos

- [Nmap — Página oficial](https://nmap.org/)
- [Nmap Reference Guide](https://nmap.org/book/man.html)
- [NSE Scripts Database](https://nmap.org/nsedoc/)
- [Nmap Network Scanning (libro oficial)](https://nmap.org/book/)

## Ver también

- [[Redes Basicas]] — conceptos de red subyacentes
- [[Firewall]] — qué detecta nmap al escanear
- [[nc]] — netcat, verificación manual de puertos
- [[DNS y BIND]] — DNS, puerto 53
- [[Nginx]] — servidor web en puertos 80/443
- [[auditd]] — detección de escaneos en logs del sistema

#programa #red #seguridad
