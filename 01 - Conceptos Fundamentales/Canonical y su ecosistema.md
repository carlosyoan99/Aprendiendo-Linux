---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: concepto
prioridad: alta
---

# Canonical y su ecosistema

## Qué es Canonical

**Canonical Ltd.** es la empresa fundada por **Mark Shuttleworth** en 2004 con sede en Londres, responsable del desarrollo y mantenimiento de **Ubuntu Linux** y su ecosistema de productos. Su misión declarada: llevar Linux al escritorio de forma masiva y facilitar su adopción empresarial.

A diferencia de otras empresas Linux (Red Hat, SUSE), Canonical es **privada** y ha sido financiada principalmente por la fortuna personal de Shuttleworth (proveniente de la venta de su empresa de certificados SSL, Thawte, a VeriSign en 1999).

```ascii
┌─────────────────────────────────────────────────────────────┐
│                    CANONICAL LTD. (2004)                      │
├─────────────────────────────────────────────────────────────┤
│  Mark Shuttleworth (fundador)                               │
│  Sede: Londres, Reino Unido                                 │
│  Modelo: Servicios empresariales + soporte                  │
│  Ingresos estimados: ~$250M (2023)                          │
│  Empleados: ~1,000+                                         │
└─────────────────────────────────────────────────────────────┘
```

---

## Productos del ecosistema

### 🐧 Ubuntu — La distribución insignia

[[Ubuntu]] es el producto más conocido de Canonical. Es la distribución Linux más popular para escritorio, servidor y cloud.

```bash
# Ubuntu LTS (cada 2 años) — 5 años de soporte (10 con Ubuntu Pro)
# Ubuntu Intermedio (cada 6 meses) — 9 meses de soporte
# Ubuntu Core — versión minimalista para IoT
```

| Producto | Propósito |
|---|---|
| **Ubuntu Desktop** | Escritorio Linux más popular |
| **Ubuntu Server** | Servidores, cloud (AWS, Azure, GCP) |
| **Ubuntu Core** | IoT y dispositivos embebidos |
| **Ubuntu Pro** | Suscripción empresarial con soporte extendido |

---

### 📦 Snap — Paquete universal

**Snap** es el sistema de paquetes universales de Canonical. Sandboxea aplicaciones con AppArmor, las actualiza automáticamente y funciona en cualquier distro Linux con `snapd` instalado.

```bash
# Snap en acción
snap install firefox           # Firefox como snap (por defecto en Ubuntu)
snap install lxd               # LXD como snap (recomendado por Canonical)
snap list
snap refresh
```

| Aspecto | Detalle |
|---|---|
| **Repositorio** | Snap Store (Canonical, código cerrado) |
| **Formato** | `.snap` (SquashFS) |
| **Daemon** | `snapd` (requiere systemd) |
| **Actualizaciones** | Automáticas forzadas (cada día) |
| **Confinamiento** | AppArmor + seccomp |
| **Rollback** | ✅ `snap revert` |

#### Controversias de Snap

- **Tienda cerrada**: la Snap Store es **propietaria de Canonical** — el backend no es de código abierto, lo que contradice la filosofía del software libre.
- **Actualizaciones forzadas**: las apps se actualizan automáticamente sin preguntar al usuario.
- **Rendimiento**: los snaps tardan más en arrancar que las apps nativas o Flatpak.
- **Rechazo comunitario**: [[Linux Mint]] deshabilitó Snap por defecto; Arch Linux eliminó `snapd` de los repos oficiales; la comunidad prefiere masivamente [[Snap y Flatpak|Flatpak]].

```bash
# Ubuntu instala Firefox como snap por defecto desde 22.04
# Para evitarlo, muchos usuarios añaden el PPA de Mozilla:
sudo add-apt-repository ppa:mozillateam/ppa
sudo apt install firefox                   # versión nativa .deb
```

---

### 🖥️ LXD — Gestor de contenedores

**LXD** es un gestor de contenedores de sistema construido sobre [[LXC y Contenedores del Sistema|LXC]], con API REST, snapshots y clustering. Originalmente era un proyecto de la comunidad **linuxcontainers.org**, pero Canonical tomó el control total en 2023, lo que provocó la creación del fork comunitario **Incus**.

```bash
# LXD (versión de Canonical)
sudo snap install lxd
lxc launch ubuntu:24.04 mi-servidor
```

| Hito | Fecha |
|---|---|
| **LXD creado** por linuxcontainers.org | 2014 |
| **Canonical contrata** a los desarrolladores principales | 2015 |
| **Canonical toma control total** del proyecto | 2023 |
| **La comunidad crea Incus** como fork | 2023 |
| **Incus añade VMs** vía QEMU | 2024 |
| **LXD añade VMs** vía QEMU (v5.19) | 2024 |

Ver la comparativa completa en [[Contenedores - Comparativa LXC LXD Incus Docker Podman systemd-nspawn]].

---

### 🏢 Landscape — Gestión empresarial

**Landscape** es la herramienta de gestión remota de Canonical para flotas de servidores Ubuntu. Permite:

```bash
# Acceso web en: https://tu-servidor:9090/landscape
# o via Landscape SaaS (cloud.canonical.com)
```

| Función | Descripción |
|---|---|
| **Monitorización** | Estado, recursos, alertas de todos los equipos |
| **Actualizaciones** | Desplegar parches de seguridad en toda la flota |
| **Gestión de usuarios** | Políticas, grupos, permisos centralizados |
| **Cumplimiento** | Auditorías, reportes, conformidad con normativas |
| **Repositorios** | Mirrors de apt y snaps para la organización |

---

### ⚙️ Otros productos

| Producto | Propósito | Estado |
|---|---|---|
| **MAAS** (Metal-as-a-Service) | Aprovisionar servidores físicos como si fueran VMs en la nube | Activo |
| **Juju** | Orquestación de aplicaciones en cloud (similar a Kubernetes pero más abstracto) | Activo |
| **Multipass** | VMs ligeras de Ubuntu para desarrollo local (Linux, macOS, Windows) | Activo |
| **Ubuntu Core** | Ubuntu minimalista para IoT, con snaps como único formato de paquetes | Activo |
| **Netplan** | Utilidad de configuración de red declarativa (YAML), por defecto en Ubuntu desde 17.10 | Activo |

```bash
# Multipass: VMs Ubuntu en segundos
multipass launch --name dev --cpus 2 --memory 4G --disk 20G
multipass shell dev

# MAAS: aprovisionamiento bare-metal
maas login my-server http://10.0.0.1:5240/MAAS/api/2.0 apikey
```

---

## Modelo de negocio

Canonical genera ingresos principalmente a través de:

| Fuente | Descripción |
|---|---|
| **Ubuntu Pro** | Suscripción empresarial: parches de seguridad extendidos (10+ años), soporte técnico 24/7, cumplimiento normativo (FIPS, CIS) |
| **Cloud partnerships** | Optimización de Ubuntu para AWS, Azure, GCP — Canonical recibe ingresos por cada instancia Ubuntu |
| **Servicios profesionales** | Consultoría, formación, migración a Ubuntu |
| **Landscape** | Suscripción a la herramienta de gestión empresarial |
| **IoT/Embedded** | Ubuntu Core + Snap Store privada para dispositivos |

```bash
# Ubuntu Pro es gratuito para hasta 5 máquinas (uso personal)
sudo pro attach   # requiere token de ubuntu.com/pro
```

---

## Controversias y relación con la comunidad

Canonical tiene una relación compleja con la comunidad Linux. A pesar de mantener la distro más popular, ha tomado decisiones unilaterales que han generado rechazo:

### Proyectos abandonados

| Proyecto | Años | Causa del fracaso |
|---|---|---|
| **Unity** (entorno de escritorio) | 2010-2017 | Canonical lo abandonó, volvió a GNOME |
| **Mir** (servidor gráfico) | 2013-2017 | Compitió con Wayland, perdió |
| **Ubuntu Phone / Touch** | 2013-2017 | Convergencia fallida, poca adopción |
| **Ubuntu for Android** | 2012-2014 | Nunca se lanzó comercialmente |
| **Ubuntu TV** | 2012 | Smart TV con Ubuntu, nunca llegó |

### Decisiones polémicas

1. **Snap Store cerrada**: Canonical insiste en Snap a pesar del rechazo mayoritario de la comunidad. Linux Mint, Pop!_OS y otros bloquean Snap por defecto.
2. **Absorción de LXD**: Tomar control de un proyecto comunitario (linuxcontainers.org) y moverlo a su infraestructura corporativa generó desconfianza y el fork Incus.
3. **Telemetría en Ubuntu**: La recogida de datos del sistema (opt-out) en el instalador de Ubuntu generó críticas por privacidad.
4. **Integración con Microsoft**: La colaboración con Microsoft para WSL (Windows Subsystem for Linux) fue vista con recelo por sectores puristas del software libre.

### Comparativa: Canonical vs Red Hat

| Aspecto | Canonical | Red Hat (IBM) |
|---|---|---|
| **Fundación** | 2004 | 1993 |
| **Propietario** | Privada (Shuttleworth) | IBM (comprada en 2019 por $34B) |
| **Distro** | Ubuntu | RHEL, Fedora |
| **Formato paquetes** | .deb + Snap | .rpm + Flatpak |
| **Gestor contenedores** | LXD (antes comunidad) | Podman (creado por Red Hat) |
| **Formato universal** | Snap (propietario) | Flatpak (comunitario) |
| **Cloud nativo** | AWS, Azure, GCP | Todas las nubes |
| **Modelo** | Servicios + Pro | Suscripciones RHEL |

---

## Ver también

- [[Ubuntu]] — la distro insignia de Canonical
- [[Snap y Flatpak]] — Snap vs Flatpak en detalle
- [[LXC y Contenedores del Sistema]] — LXC y LXD
- [[Contenedores - Comparativa LXC LXD Incus Docker Podman systemd-nspawn]] — comparativa completa
- [[Linux Mint]] — distro que rechazó Snap
- [[Debian]] — base de Ubuntu
- [[Gestores de Paquetes]] — apt, dpkg, snap, flatpak
- [[Que es Linux]] — contexto general

## Enlaces externos

- [Canonical — Página oficial](https://canonical.com/)
- [Canonical — Productos](https://canonical.com/products)
- [Ubuntu — Página oficial](https://ubuntu.com/)
- [Snapcraft — Snap Store](https://snapcraft.io/)
- [LXD — Ubuntu](https://ubuntu.com/lxd)
- [Landscape — Gestión](https://ubuntu.com/landscape)
- [MAAS — Metal as a Service](https://maas.io/)
- [Juju — Orquestación](https://juju.is/)
- [Multipass — VMs ligeras](https://multipass.run/)
- [Incus — Fork comunitario de LXD](https://linuxcontainers.org/incus/)
- [Canonical — Wikipedia](https://en.wikipedia.org/wiki/Canonical_(company))
- [Ubuntu Pro — Suscripción](https://ubuntu.com/pro)

#concepto #canonical #ubuntu
