---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: sistema
prioridad: media
---

# nftables

> Framework de filtrado de paquetes que reemplaza a iptables. Es el firewall estándar en el kernel Linux desde 2014 (kernel 3.13), con sintaxis más limpia y mejor rendimiento.

## Qué es

`nftables` es el sustituto moderno de `iptables`/`ip6tables`/`ebtables`/`arptables`. Opera con tablas, chains y reglas, similar a iptables, pero con sintaxis unificada para IPv4 e IPv6, sets dinámicos, y rendimiento mejorado al no depender de módulos por protocolo.

**Distros que ya usan nftables por defecto:**
- Debian 10+, Ubuntu 20.04+, Fedora, Arch Linux, RHEL 8+

## Ver también

- [[Firewall]] — guía general de firewalls
- [[iptables]] — firewall legacy (transición a nftables)
- [[ufw]] — frontend simplificado (usa nftables internamente)
- [[Seguridad en Linux (Guía completa)]] — seguridad integral

#sistema #redes #firewall
