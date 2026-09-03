---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: concepto
prioridad: alta
---

# DNS encriptado (DoH / DoT)

> DNS es el servicio que traduce nombres de dominio a IPs. Por defecto, las consultas DNS viajan en texto plano — cualquier intermediario puede ver qué sitios visitas. DNS over TLS (DoT) y DNS over HTTPS (DoH) cifran esas consultas para proteger tu privacidad y evitar manipulación.

## ¿Por qué cifrar DNS?

- **Privacidad**: tu proveedor de internet, red WiFi, o administrador de red puede ver todas las páginas que visitas vía DNS sin cifrar.
- **Integridad**: un atacante puede manipular respuestas DNS (DNS spoofing/redirection) para dirigirte a sitios maliciosos.
- **Censura**: algunos ISPs bloquean dominios en el nivel DNS. DoH/DoT evita esto al cifrar la consulta.
- **Publicidad**: los ISP venden datos de navegación. DNS cifrado reduce esa exposición.

---

## DoH vs DoT vs DNSCrypt

| Protocolo | Puerto | Transporte | Ventaja | Desventaja |
|---|---|---|---|---|
| **DNS (clásico)** | 53 UDP/TCP | Texto plano | Universal, rápido | Sin cifrado, visible para todos |
| **DoT (DNS over TLS)** | 853 TCP | TLS (cifrado) | Estándar, fácil de configurar | Puerto específico (fácil de bloquear) |
| **DoH (DNS over HTTPS)** | 443 TCP | HTTPS (cifrado) | No se distingue de tráfico web normal | Más overhead, harder de configurar en sistema |
| **DNSCrypt** | Variable | Protocolo propio | Cifrado + anti-manipulación | No es estándar IETF, menos soporte |

**Recomendación**: DoT para la red local (router/servidor), DoH en navegador como fallback.

---

## Configurar DoT en el sistema completo (systemd-resolved)

```bash
# systemd-resolved ya viene en la mayoría de distros modernas

# Verificar estado
resolvectl status

# Configurar DoT
sudo nano /etc/systemd/resolved.conf
# [Resolve]
# DNS=1.1.1.1#cloudflare-dns.com 9.9.9.9#dns.quad9.net
# FallbackDNS=8.8.8.8#dns.google 2001:4860:4868::8888#dns.google
# DNSOverTLS=yes
# DNSSEC=allow-downgrade
# Cache=yes

# Reiniciar
sudo systemctl restart systemd-resolved
sudo systemctl enable systemd-resolved

# Verificar que DoT está activo
resolvectl status | grep -i "dns over tls\|dnssec"
# Debe mostrar: DNSOverTLS: yes

# Test: ver tráfico DoT (puerto 853)
sudo ss -tlnp | grep 853
```

---

## Configurar DoH en el sistema completo (con dnsproxy)

```bash
# dnsproxy de AdGuard es ligero y fácil de configurar
# Alternativa: stubby (para DoT)

# Instalar dnsproxy
sudo apt install dnsproxy            # Debian/Ubuntu (puede no estar en repos)
# O descargar binario:
wget https://github.com/AdguardTeam/dnsproxy/releases/latest/download/dnsproxy-linux-amd64-latest.tar.gz
tar xzf dnsproxy-linux-amd64-latest.tar.gz
sudo mv linux-amd64/dnsproxy /usr/local/bin/

# Configurar
sudo mkdir -p /etc/dnsproxy
sudo tee /etc/dnsproxy/config.yaml << 'EOF'
listen_addresses:
  - "127.0.0.1"
  - "::1"
port: 53
upstream:
  - "https://1.1.1.1/dns-query"
  - "https://9.9.9.9/dns-query"
  - "tls://8.8.8.8"
  - "tls://8.8.4.4"
bootstrap: ["https://1.1.1.1/dns-query"]
log_format: text
cache: true
cache_size_ub: 4096
EOF

# Crear servicio systemd
sudo tee /etc/systemd/system/dnsproxy.service << 'EOF'
[Unit]
Description=dnsproxy - DNS proxy with DoH/DoT
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/dnsproxy -c /etc/dnsproxy/config.yaml
Restart=always
RestartSec=5
User=nobody
Group=nogroup
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=yes
ReadWritePaths=/var/cache/dnsproxy

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now dnsproxy

# Configurar el sistema para usar dnsproxy
sudo tee /etc/resolv.conf << 'EOF'
# DNS local cifrado
nameserver 127.0.0.1
EOF
# O configurar NetworkManager para usarlo:
# nmcli con IPv4.dns "127.0.0.1"
```

---

## Configurar DoH en navegadores

### Firefox

```
# Ir a: about:config
# Buscar: dns.resolverprovider
# Establecer: cloudflare (o nextbigthing, quad9, etc.)

# O simplemente:
# Settings → Privacy & Security → DNS over HTTPS → Enable
# Choose provider: Cloudflare, NextDNS, Quad9, etc.
```

### Chromium / Chrome / Edge

```
# chrome://settings/security
# Usar DNS seguro: activado
# Método: automatic (o con proveedor personalizado)

# O en chrome://flags:
# #dns-over-https → Enabled
# #dns-over-https-template → https://1.1.1.1/dns-query
```

### Brave

```
# Settings → Security and Privacy → Use secure DNS → activado
# Seleccionar proveedor o añadir personalizado
```

---

## Proveedores DNS públicos cifrados

| Proveedor | DoT Hostname | DoH URL | IPv4 | IPv6 | DNSSEC | No-log | Bloqueo |
|---|---|---|---|---|---|---|---|
| **Cloudflare** | `1.1.1.1` | `https://1.1.1.1/dns-query` | 1.1.1.1 | 2606:4700:4700::1111 | ✅ | ✅ | No |
| **Quad9** | `dns.quad9.net` | `https://dns.quad9.net/dns-query` | 9.9.9.9 | 9.9.9.9 | ✅ | ✅ | Malware |
| **Google** | `dns.google` | `https://dns.google/dns-query` | 8.8.8.8 | 2001:4860:4868::8844 | ✅ | Parcial | No |
| **NextDNS** | `firefox.dns.nextdns.io` | `https://firefox.dns.nextdns.io` | Varies | Varies | ✅ | ✅ | Configurable |
| **Mullvad** | `dns.mullvad.net` | `https://dns.mullvad.net/dns-query` | 194.242.2.2 | 2a07:a300:: | ✅ | ✅ | Anuncios+Trackers |
| **AdGuard** | `dns.adguard-dns.com` | `https://dns.adguard-dns.com/dns-query` | 94.140.14.14 | 2a10:50c0::ad1:ff | ✅ | ✅ | Anuncios |

**Recomendación**: Cloudflare (rápido) o Quad9 (seguridad, bloquea malware). Mullvad o NextDNS si quieres más control.

---

## Configurar DNS en router (red completa)

```bash
# Si tu router soporta DoT (pocos routers lo soportan nativamente):
# En la config del router → WAN/DNS → configurar DoT

# Alternativa: Pi-hole o AdGuard Home como DNS local
# Pi-hole ya soporta DoH/DoT upstream:
# Settings → DNS → upstream → añadir DoT servers

# Para un router OpenWrt:
# En /etc/config/dhcp:
#   option dns '/etc/pihole/dnsmasq.conf'
# O configurar un cliente DoT:
# opkg install stubby
# nano /etc/stubby/stubby.yml
```

---

## Verificar que funciona

```bash
# Test 1: verificar que las consultas van cifradas
# Instalar dnsdiag
pip install dnsdiag

# Test DoT:
python3 -m dnsdiag.dnsdiag --tls 1.1.1.1 google.com

# Test DoH:
python3 -m dnsdiag.dnsdiag --doh https://1.1.1.1/dns-query google.com

# Test 2: verificar que no se ve tráfico DNS plano
sudo tcpdump -i any port 53 -n | head -10
# No debería haber tráfico en puerto 53 si todo usa DoT/DoH

# Test 3: verificar que el puerto 853 está activo
sudo ss -tlnp | grep 853

# Test 4: test de resolución DNS
resolvectl query google.com
dig @1.1.1.1 google.com

# Test 5: verificar DNSSEC
delv @1.1.1.1 google.com A +rtrace
```

---

## DNS encriptado con containers

```bash
# Docker: usar DNS cifrado para containers
docker run --dns=1.1.1.1 mi-imagen
# O en /etc/docker/daemon.json:
# { "dns": ["1.1.1.1", "9.9.9.9"] }

# Docker Compose:
# services:
#   app:
#     dns:
#       - 1.1.1.1
#       - 9.9.9.9

# Para que el host también use DNS cifrado:
# Configurar systemd-resolved o dnsproxy como se describe arriba
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| **DNS no resuelve** | DoT/DoH configurado mal | Verificar connectivity al puerto 853/443: `openssl s_client -connect 1.1.1.1:853` |
| **Resolución lenta** | Overhead de TLS o latencia del proveedor | Cambiar a un servidor más cercano, verificar `resolvectl query` |
| **Algunos dominios no resuelven** | DNSSEC validation falla | `DNSSEC=allow-downgrade` en resolved.conf |
| **Puerto 53 aún activo** | Algunas apps ignoran systemd-resolved | Verificar `resolvectl query`, forzar con NetworkManager |
| **VPN + DNS leak** | La VPN no configura DNS | Verificar que la VPN configura DNS, o usar DNS cifrado en el sistema |
| **Pi-hole + DoT conflictos** | Pi-hole intercepta DNS en puerto 53 | Configurar Pi-hole upstream como DoT |

### Comandos de diagnóstico

```bash
# Ver qué servidor DNS está usando el sistema
resolvectl status

# Ver resolución de un dominio específico
resolvectl query google.com
resolvectl query --tls google.com     # forzar DoT

# Verificar que no hay DNS leak
curl -s https://1.1.1.1/cdn-cgi/trace | grep -i "warp"
# O visitar: https://dnsleaktest.com

# Verificar connectividad a servidores DoT
openssl s_client -connect 1.1.1.1:853 -brief 2>&1 | head -3
openssl s_client -connect 9.9.9.9:853 -brief 2>&1 | head -3
```

---

## Comparativa de métodos de implementación

| Método | Alcance | Complejidad | Mantenimiento |
|---|---|---|---|
| **Browser DoH** | Solo el navegador | Muy fácil | Ninguno |
| **systemd-resolved** | Todo el sistema | Fácil | Bajo |
| **dnsproxy / stubby** | Todo el sistema | Media | Bajo |
| **Router Pi-hole** | Toda la red | Media | Bajo |
| **VPN con DNS** | Red completa | Media | Medio |

**Recomendación**: Browser DoH como mínimo. systemd-resolved DoT para todo el sistema. Pi-hole si quieres control de la red completa.

---

## Ver también

- [[Redes Basicas]] — conceptos de red y DNS
- [[DNS y BIND]] — servidor DNS completo
- [[Red no conecta]] — troubleshooting de red
- [[Seguridad en Linux (Guía completa)]] — guía general de seguridad
- [[WireGuard VPN]] — túneles cifrados
- [[SSH Hardening]] — endurecimiento SSH

#seguridad #dns #privacidad #redes
