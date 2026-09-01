---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-08-31
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

Está dirigido a:
- **PYMES** que necesitan dominio Active Directory sin licencias Microsoft
- **Administradores** que buscan migrar de Windows Server gradualmente
- **Escuelas y asociaciones** con presupuesto limitado

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Ubuntu LTS |
| **Interfaz** | Web (NGINX + Perl + Mason) |
| **Compatibilidad** | Active Directory, Exchange MAPI, Outlook |
| **Uso** | PYMEs, servidores |
| **Licencia** | Open Source (edición desarrollo gratuita) |

### Componentes integrados

| Servicio | Software | Función |
|---|---|---|
| **Correo** | Postfix + Dovecot + Amavis | SMTP, IMAP/POP3, antispam/antivirus |
| **Directorio** | Samba 4 | Active Directory (LDAP compatible) |
| **DNS** | BIND | Resolución de nombres interna |
| **DHCP** | ISC DHCP | Asignación automática de IPs |
| **Firewall** | iptables/nftables | Filtrado de tráfico |
| **VPN** | OpenVPN / IPsec | Acceso remoto seguro |
| **Impresión** | CUPS | Cola de impresión centralizada |
| **Sincronización** | ActiveSync, CalDAV, CardDAV | Móviles, calendarios, contactos |
| **Web** | NGINX + Apache | Servidor web interno |

## Ediciones

| Edición | Público | Precio |
|---|---|---|
| **Zentyal Server Development** | Desarrollo/testing | Gratis |
| **Zentyal Server** | Producción PYMEs | Pago (suscripción) |
| **Zentyal Cloud** | Proveedores hosting | Suscripción |

## Instalación

```bash
# Opción 1: ISO completa (recomendado para nuevos despliegues)
# Descargar ISO desde zentyal.com/download
# El instalador incluye todos los módulos de servidor

# Opción 2: Repositorio sobre Ubuntu Server existente
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
  0x6055448A8A8E01A9
echo "deb http://repo.zentyal.org/zentyal 8.1 ppc" | \
  sudo tee /etc/apt/sources.list.d/zentyal.list
sudo apt update
sudo apt install zentyal

# Tras instalar, acceder a la interfaz web:
# https://192.168.1.1:8443
```

## Configuración inicial

```bash
# El asistente web guía la configuración:
# 1. Configuración de red (IP estática recomendada)
# 2. Nombre del dominio (ej: empresa.local)
# 3. Contraseña del administrador
# 4. Módulos a activar:
#    - DHCP Server ✓
#    - DNS Server ✓
#    - Mail Server ✓
#    - Active Directory ✓
#    - Firewall ✓
#    - VPN ✓

# Post-configuración vía CLI:
sudo /etc/init.d/zentyal webadmin   # reiniciar interfaz web
sudo domainjoin-cli join empresa.local admin  # unir PC Windows al dominio
```

## Casos de uso

- **Migración de Windows Server**: Active Directory + Exchange sin licencias Microsoft
- **Servidor de oficina**: DNS, DHCP, firewall, correo, impresión en un solo equipo
- **Dominio para PYME**: authenticación centralizada, políticas de grupo
- **Servidor de acceso remoto**: VPN OpenVPN para trabajadores externos
- **Escuelas/associaciones**: servidor con presupuesto mínimo

## Comparativa con alternativas

| Aspecto | Zentyal | Windows Server | Univention | Samba standalone |
|---|---|---|---|---|
| **Coste** | Gratis (dev) / Pago (prod) | $500-5000+ | Gratis / Enterprise | Gratis |
| **Active Directory** | ✅ (Samba 4) | ✅ (nativo) | ✅ (OpenLDAP) | ✅ (manual) |
| **Exchange** | ✅ (Postfix+Dovecot) | ✅ (Exchange) | ❌ | ❌ |
| **Interfaz web** | ✅ | ✅ | ✅ | ❌ |
| **Soporte Outlook** | ✅ (MAPI) | ✅ (nativo) | Parcial | Parcial |
| **Comunidad** | Pequeña | Masiva | Mediana | Grande |
| **Curva aprendizaje** | Baja-Media | Media | Media | Alta |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No accede a la interfaz web | Firewall bloquea puerto 8443 | `sudo iptables -A INPUT -p tcp --dport 8443 -j ACCEPT` |
| Active Directory no resuelve | BIND no configurado correctamente | Verificar en Web → DNS → Zonas |
| Outlook no conecta (MAPI) | Samba 4 no levantó | `sudo systemctl status samba-ad-dc` |
| Correo no sale (SMTP) | Postfix mal configurado o bloqueado ISP | Verificar relay, puerto 587, logs: `/var/log/mail.log` |
| VPN no conecta desde fuera | Puerto UDP 1194 bloqueado | Abrir puerto en firewall/router |
| "Trust relationship" falla en Windows | Relación AD rota | Reconectar PC al dominio: `domainjoin-cli leave` + `domainjoin-cli join` |

## Ver también

- [[Ubuntu]] — base del sistema
- [[Firewall]] — seguridad de red
- [[Samba]] — compatibilidad con Windows
- [[DNS y BIND]] — servidor DNS
- [[SSH]] — acceso remoto por terminal

## Enlaces externos

- [Sitio oficial](https://www.zentyal.com/)
- [Wikipedia — Zentyal](https://es.wikipedia.org/wiki/Zentyal)
- [Documentación](https://doc.zentyal.com/)
- [Foro de la comunidad](https://community.zentyal.com/)

#distro #servidor
