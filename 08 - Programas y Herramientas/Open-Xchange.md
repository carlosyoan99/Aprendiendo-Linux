---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
licencia: Open Source (edición comunidad)
alternativas: Zentyal, Nextcloud, Kopano
---

# Open-Xchange (OX)

> Suite de **software colaborativo** (groupware) de código abierto con sede en Alemania. Ofrece correo, calendario, contactos y tareas con compatibilidad nativa con Microsoft Outlook.

## Qué es

Open-Xchange es un servidor de mensajería y colaboración que compite con Microsoft Exchange Server. Soporta múltiples protocolos y dispositivos, con versiones para hosting (ISP) y para empresas.

## Funcionalidades

- Correo electrónico (IMAP, POP3, SMTP)
- Calendario y contactos compartidos
- Gestión de tareas y proyectos
- Documentos, enlaces y base de conocimiento
- Foros
- Sincronización ActiveSync (móviles)

### Protocolos soportados

| Protocolo | Uso |
|---|---|
| MAPI/EWS | Compatibilidad con Outlook |
| ActiveSync | Sincronización móvil |
| CalDAV/CardDAV | Calendario y contactos |
| WebDAV | Acceso a documentos |
| SMTP/IMAP/POP3 | Correo estándar |

## Ediciones

| Edición | Público |
|---|---|
| **OX Hosting Edition** | ISP y proveedores |
| **OX App Suite** | Empresas |

## Instalación multi-distro

| Distro | Método |
|---|---|
| Debian/Ubuntu | Repo oficial + apt |
| RHEL/CentOS | Repo oficial + yum/dnf |
| Docker | `docker compose` (recomendado para pruebas) |

```bash
# Instalación vía Docker (recomendada)
git clone https://gitlab.com/open-xchange/docker/apps-suite_compose
cd apps-suite_compose
docker compose up -d

# Verificar
curl -k https://localhost/autologin
```

## OX App Suite: funcionalidades detalladas

| Módulo | Descripción |
|---|---|
| **Mail** | IMAP/POP3/SMTP, reglas, anti-spam |
| **Calendar** | CalDAV, eventos compartidos, recordatorios |
| **Contacts** | CardDAV, distribución, import/export |
| **Drive** | Almacenamiento, versionado, compartir |
| **Tasks** | Gestión de tareas, projetos, asignación |
| **Webmail** | Interfaz web completa |

## Comparativa con alternativas

| Característica | OX App Suite | Nextcloud | Zentyal |
|---|---|---|---|
| ActiveSync | ✅ | ✅ (plugin) | ✅ |
| CalDAV/CardDAV | ✅ | ✅ | ✅ |
| Outlook compat | ✅ MAPI | ❌ | ✅ |
| LDAP/AD | ✅ | ✅ | ✅ |
| Fácil despliegue | ⚠️ Complejo | ✅ Docker | ✅ Appliance |
| Código abierto | ✅ Community | ✅ | ✅ |

## Troubleshooting

| Problema | Solución |
|---|---|
| No inicia en Docker | Verificar puertos: `docker compose logs` |
| Login falla | Verificar MySQL: `docker exec -it ox_db mysql -uox -p` |
| ActiveSync no sincroniza | Verificar URL: `https://dominio/servlets/activesync` |
| LDAP no conecta | Verificar `ldap.conf` y certificados |

## Enlaces externos

- [Sitio oficial](https://www.open-xchange.com/)
- [Wikipedia — Open-Xchange](https://es.wikipedia.org/wiki/Open-Xchange)
- [OX Documentation](https://documentation.open-xchange.com/)
- [GitHub — OX App Suite](https://gitlab.com/open-xchange/appsuite/appsuite)

## Ver también

- [[Zentyal]] — solución similar con AD/Exchange
- [[Nextcloud]] — suite colaborativa diferente
- [[Nginx]] — proxy reverso para OX
- [[Docker]] — contenedores para despliegue

#programa #colaboracion
