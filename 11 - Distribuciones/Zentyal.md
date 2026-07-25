---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-20
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: apt (dpkg)
base: Ubuntu LTS
modelo_lanzamiento: Fixed
init: systemd
arquitecturas:
  - x86_64
---

# Zentyal

> Distribución Linux para servidores que emula un **controlador de dominio Windows** (Active Directory + Exchange) usando software libre (Samba, Postfix, Dovecot). Ideal para PYMEs que necesitan compatibilidad con Microsoft Outlook sin pagar licencias de Windows Server.

## Filosofía / público objetivo

Zentyal (antes eBox Platform) convierte un servidor Ubuntu en un **sustituto de Windows Server** con Active Directory, Exchange, DNS, DHCP, firewall, VPN y más — todo gestionado desde una interfaz web. Es compatible de forma nativa con Microsoft Outlook.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Ubuntu LTS |
| **Interfaz** | Web (NGINX + Perl + Mason) |
| **Compatibilidad** | Active Directory, Exchange MAPI, Outlook |
| **Uso** | PYMEs, servidores |
| **Licencia** | Open Source (edición desarrollo gratuita) |

### Componentes integrados

- **Correo**: Postfix + Dovecot + Amavis (antispam/antivirus)
- **Directorio**: Samba 4 como Active Directory
- **Red**: Firewall (iptables), DNS (BIND), DHCP, OpenVPN
- **Impresión**: CUPS
- **Sincronización**: ActiveSync (móviles), CalDAV, CardDAV

## Ediciones

| Edición | Público | Precio |
|---|---|---|
| **Zentyal Server** | PYMEs | Desarrollo: gratis / Comercial: pago |
| **Zentyal Cloud** | Proveedores hosting | Suscripción |

## Enlaces externos

- [Sitio oficial](https://www.zentyal.com/)
- [Wikipedia — Zentyal](https://es.wikipedia.org/wiki/Zentyal)

## Ver también

- [[Ubuntu]] — base del sistema
- [[Firewall]] — seguridad de red
- [[Samba]] — compatibilidad con Windows

#distro #servidor
